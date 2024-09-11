FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget apt-transport-https ca-certificates && \
    wget -qO /etc/apt/trusted.gpg.d/nordvpn_public.asc https://repo.nordvpn.com/gpg/nordvpn_public.asc && \
    echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" > /etc/apt/sources.list.d/nordvpn.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nordvpn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

    COPY /rootfs /
ENV S6_CMD_WAIT_FOR_SERVICES=1

RUN chown root /usr/bin/*
RUN chmod 755 /usr/bin/*
RUN chown root /etc/services.d/nordvpn/*
RUN chmod 755 /etc/services.d/nordvpn/*
RUN chown root /etc/services.d/nordvpn/data/*
RUN chmod 755 /etc/services.d/nordvpn/data/*
RUN chmod 755 /etc/cont-init.d/*
RUN chown root /etc/cont-init.d/*

CMD nord_login && nord_config && nord_connect && nord_watch
