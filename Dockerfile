FROM ubuntu:16.04
MAINTAINER Wicaksono Trihatmaja <trihatmaja@gmail.com>

ENV MCROUTER_DIR /usr/local/mcrouter
ENV MCROUTER_REPO https://github.com/Ngo-The-Trung/mcrouter.git
ENV MCROUTER_RELEASE tngo/binary_protocol

ADD install_ubuntu_16.04.sh /

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y git \
    && mkdir -p $MCROUTER_DIR/repo \
    && cd $MCROUTER_DIR/repo && git clone $MCROUTER_REPO \
    && cd $MCROUTER_DIR/repo/mcrouter && git checkout $MCROUTER_RELEASE \
    && cd $MCROUTER_DIR/repo/mcrouter/mcrouter/scripts \
    && sed 's/\<sudo\> //g' ./install_ubuntu_16.04.sh > ./install_ubuntu_16.04.nosudo.sh \
    && sh ./install_ubuntu_16.04.nosudo.sh $MCROUTER_DIR \
    && rm -rf $MCROUTER_DIR/repo \
    && ln -s $MCROUTER_DIR/install/bin/mcpiper /usr/local/bin/mcpiper \
    && ln -s $MCROUTER_DIR/install/bin/mcrouter /usr/local/bin/mcrouter

RUN mkdir -p /var/mcrouter/fifos /var/spool/mcrouter

VOLUME /var/mcrouter/fifos
VOLUME /var/spool/mcrouter

ENTRYPOINT ["mcrouter"]
