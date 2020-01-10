FROM golang:1.12.7-stretch

ARG DEBUG_IMAGE="disable"

RUN apt-get -y update && \
    apt-get -y install ca-certificates e2fsprogs xfsprogs util-linux && \
    if [ "${DEBUG_IMAGE}" = "enable" ]; then \
        apt-get -y install gdb jq; \
        echo "add-auto-load-safe-path /usr/local/go/src/runtime/runtime-gdb.py" >> /root/.gdbinit; \
    fi

WORKDIR /go/src/github.com/kubernetes-sigs/aws-ebs-csi-driver
COPY . .
RUN make -j 4 && \
    cp /go/src/github.com/kubernetes-sigs/aws-ebs-csi-driver/bin/aws-ebs-csi-driver /bin/aws-ebs-csi-driver


ENTRYPOINT ["/bin/aws-ebs-csi-driver"]
