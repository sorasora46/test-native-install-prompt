# Use the official Node.js 14 image as the base image
FROM node:14 as build

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire app directory to the container
COPY . .

# Build the React app
RUN npm run build

# Use a lightweight Node.js image as the base image for the final stage
FROM node:14-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the built app from the previous stage
COPY --from=build /app/dist ./dist

# Install serve to run the production build
RUN npm install -g serve

# Set the command to start the server when the container is run
CMD ["serve", "-s", "dist", "-l", "3000"]
