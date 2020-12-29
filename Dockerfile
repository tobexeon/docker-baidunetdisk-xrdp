FROM ubuntu:18.04

RUN echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse \n\
        deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse \n\
        deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse \n\
        deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse'\
        > /etc/apt/sources.list \
        && apt update \
        && apt install openbox wget xrdp fonts-wqy-microhei libasound2 -y\
        ; apt install openbox wget xrdp fonts-wqy-microhei libasound2 --fix-missing -y\
        && wget http://wppkg.baidupcs.com/issue/netdisk/Linuxguanjia/3.5.0/baidunetdisk_3.5.0_amd64.deb \
        && dpkg -i baidunetdisk_3.5.0_amd64.deb\
        ; apt --fix-broken install -y \
        && apt autoremove wget -y \
        && apt-get clean autoclean \
        && apt-get autoremove -y \
        && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
        && rm -rf baidunetdisk_3.5.0_amd64.deb

RUN useradd -m -s /bin/bash baidu \
        && passwd baidu \
        && echo 'openbox & \n\
        /opt/baidunetdisk/baidunetdisk --no-sandbox'\
        >/home/baidu/.xsession\
        && chown baidu /home/baidu/.xsession \
        && chgrp baidu /home/baidu/.xsession \
        && echo 'rm -rf /var/run/xrdp/* \n\
        rm -rf /tmp/.* \n\
        xrdp-sesman \n\
        xrdp -n'\
        > /init \
        && chmod +x /init

CMD sh -c /init
