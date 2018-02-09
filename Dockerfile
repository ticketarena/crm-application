FROM php:7.1

# Install required extensions
RUN apt-get update && apt-get -y install git libicu-dev libmcrypt-dev libmemcached-dev libpng-dev libtidy-dev libxml2-dev nodejs openssl zlib1g-dev
RUN docker-php-ext-install gd intl mcrypt opcache pdo pdo_mysql soap tidy zip && \
    pecl install memcached

# Install composer
RUN curl -s https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1

# Configure PHP
RUN echo "memory_limit=-1" > "$PHP_INI_DIR/conf.d/memory_limit.ini" && \
    echo "date.timezone=${PHP_TIMEZONE:-UTC}" > "$PHP_INI_DIR/conf.d/date_timezone.ini" && \
    echo "short_open_tag=Off" > "$PHP_INI_DIR/conf.d/short_open_tag.ini" && \
    echo "[opcache]" > "$PHP_INI_DIR/conf.d/opcache.ini" && \
    echo "opcache.enable=1" >> "$PHP_INI_DIR/conf.d/opcache.ini" && \
    echo "opcache.enable_cli=1" >> "$PHP_INI_DIR/conf.d/opcache.ini" && \
    echo "opcache.revalidate_freq=60" >> "$PHP_INI_DIR/conf.d/opcache.ini" && \
    echo "opcache.max_accelerated_files=40000" >> "$PHP_INI_DIR/conf.d/opcache.ini" && \
    echo "opcache.memory_consumption=512M" >> "$PHP_INI_DIR/conf.d/opcache.ini" && \
    echo "opcache.interned_strings_buffer=32" >> "$PHP_INI_DIR/conf.d/opcache.ini" && \
    echo "extension=memcached.so" > "$PHP_INI_DIR/conf.d/memcached.ini"

WORKDIR /opt/src
COPY . .
