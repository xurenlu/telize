FROM nginx:latest
MAINTAINER renlu <xurenlu@gmail.com>


RUN echo "deb http://mirrors.aliyun.com/debian/ bullseye main non-free contrib" > /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/debian/ bullseye main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/debian-security/ bullseye-security main" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/debian-security/ bullseye-security main" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb-src http://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib" >> /etc/apt/sources.list

RUN apt-get update -y
RUN apt install -y build-essential  libssl-dev libmaxminddb-dev
RUN mkdir /var/db/ && mkdir /var/db/GeoIP/
COPY  ./3rd/kore-4.1.0.tar.gz /www/dev/
COPY ./3rd/telize-3.1.0.tar.gz /www/dev/

COPY ./3rd/GeoLite2-ASN.mmdb /var/db/GeoIP/
COPY ./3rd/GeoLite2-City.mmdb /var/db/GeoIP/

RUN cd /www/dev/ && tar -xzf ./kore-4.1.0.tar.gz && cd kore-4.1.0 &&  make && make install
RUN cd /www/dev/ && tar -xzf ./telize-3.1.0.tar.gz  && mv telize-3.1.0 telize && cd telize && kodev clean &&  kodev build
WORKDIR /www/dev/telize/
COPY ./3rd/telize.conf /www/dev/telize/conf/telize.conf
EXPOSE 8080
EXPOSE 8888
CMD ["/usr/local/bin/kodev", "run"]
