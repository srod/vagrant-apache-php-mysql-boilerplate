#!/usr/bin/env bash

# Get root up in here
sudo su

# Just a simple way of checking if we need to install everything
if [ ! -d "/var/www" ]
then
    # Update and begin installing some utility tools
    apt-get -y update
    apt-get install -y python-software-properties
    apt-get install -y vim git subversion curl
    apt-get install -y memcached build-essential

    echo mysql-server mysql-server/root_password select "vagrant" | debconf-set-selections
    echo mysql-server mysql-server/root_password_again select "vagrant" | debconf-set-selections
    apt-get install -y mysql-server apache2 php5 libapache2-mod-php5 php5-mysql
    VHOST="<VirtualHost *:80>
      DocumentRoot "/vagrant/www"
      ServerName localhost
      <Directory "/vagrant/www">
        AllowOverride All
      </Directory>
    </VirtualHost>"
    echo "${VHOST}" > /etc/apache2/sites-enabled/000-default
    sudo a2enmod info
    sudo a2enmod rewrite
    sudo a2enmod expires
    service apache2 restart
    #mysql -u root -p"vagrant" -e ";DROP DATABASE test;DROP USER ''@'localhost';CREATE DATABASE gitrepos;GRANT ALL ON gitrepos.* TO gitrepos@localhost IDENTIFIED BY 'gitrepos';GRANT ALL ON gitrepos.* TO gitrepos@'%' IDENTIFIED BY 'gitrepos'"
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf
    service mysql restart
    apt-get clean

    # Symlink our host www to the guest /var/www folder
    ln -s /vagrant/www /var/www

    # Victory!
    echo "You're all done!"
fi
