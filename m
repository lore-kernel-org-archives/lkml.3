Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470Ab3BXWS5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 17:18:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759451Ab3BXWSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:18:55 -0500
Date: Mon, 25 Feb 2013 00:19:04 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Asias He <asias@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH dontapply 1/2] tools/virtio: fix build for 3.8
Message-ID: <3ecc083591336b699df9adcb105f767300c6865b.1361743821.git.mst@redhat.com>
References: <cover.1361743821.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1361743821.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/test.c        | 4 +++-
 tools/virtio/Makefile       | 2 +-
 tools/virtio/linux/virtio.h | 7 ++++++-
 tools/virtio/virtio_test.c  | 3 ++-
 4 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index 91d6f06..329d302 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -275,7 +275,9 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
 		return vhost_test_reset_owner(n);
 	default:
 		mutex_lock(&n->dev.mutex);
-		r = vhost_dev_ioctl(&n->dev, ioctl, arg);
+		r = vhost_dev_ioctl(&n->dev, ioctl, argp);
+                if (r == -ENOIOCTLCMD)
+                        r = vhost_vring_ioctl(&n->dev, ioctl, argp);
 		vhost_test_flush(n);
 		mutex_unlock(&n->dev.mutex);
 		return r;
diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index d1d442e..b48c432 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -1,7 +1,7 @@
 all: test mod
 test: virtio_test
 virtio_test: virtio_ring.o virtio_test.o
-CFLAGS += -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow  -MMD
+CFLAGS += -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD
 vpath %.c ../../drivers/virtio
 mod:
 	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index 81847dd..390c4cb 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -85,6 +85,8 @@ typedef __u16 u16;
 typedef enum {
 	GFP_KERNEL,
 	GFP_ATOMIC,
+	__GFP_HIGHMEM,
+	__GFP_HIGH
 } gfp_t;
 typedef enum {
 	IRQ_NONE,
@@ -163,6 +165,8 @@ struct virtqueue {
 	void (*callback)(struct virtqueue *vq);
 	const char *name;
 	struct virtio_device *vdev;
+        unsigned int index;
+        unsigned int num_free;
 	void *priv;
 };
 
@@ -206,7 +210,8 @@ bool virtqueue_enable_cb(struct virtqueue *vq);
 bool virtqueue_enable_cb_delayed(struct virtqueue *vq);
 
 void *virtqueue_detach_unused_buf(struct virtqueue *vq);
-struct virtqueue *vring_new_virtqueue(unsigned int num,
+struct virtqueue *vring_new_virtqueue(unsigned int index,
+				      unsigned int num,
 				      unsigned int vring_align,
 				      struct virtio_device *vdev,
 				      bool weak_barriers,
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index fcc9aa2..faf3f0c 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -92,7 +92,8 @@ static void vq_info_add(struct vdev_info *dev, int num)
 	assert(r >= 0);
 	memset(info->ring, 0, vring_size(num, 4096));
 	vring_init(&info->vring, num, info->ring, 4096);
-	info->vq = vring_new_virtqueue(info->vring.num, 4096, &dev->vdev,
+	info->vq = vring_new_virtqueue(info->idx,
+				       info->vring.num, 4096, &dev->vdev,
 				       true, info->ring,
 				       vq_notify, vq_callback, "test");
 	assert(info->vq);
-- 
MST

