Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaLZCyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 21:54:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbaLZCyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 21:54:08 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [RFC PATCH 2/3] virtio: let vp_find_vqs accept channel setting paramters
Date: Fri, 26 Dec 2014 10:53:44 +0800
Message-Id: <1419562425-20614-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1419562425-20614-1-git-send-email-jasowang@redhat.com>
References: <1419562425-20614-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch let vp_find_vqs method can accept channel parameters. For
the transports that do not support channel currently, all the
parameters were ignored. For the device that does not use channel, it
can simply pass NULL to transport.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/block/virtio_blk.c             |  3 ++-
 drivers/char/virtio_console.c          |  3 ++-
 drivers/lguest/lguest_device.c         |  5 ++++-
 drivers/misc/mic/card/mic_virtio.c     |  5 ++++-
 drivers/net/caif/caif_virtio.c         |  3 ++-
 drivers/net/virtio_net.c               |  2 +-
 drivers/remoteproc/remoteproc_virtio.c |  5 ++++-
 drivers/rpmsg/virtio_rpmsg_bus.c       |  3 ++-
 drivers/s390/kvm/kvm_virtio.c          |  5 ++++-
 drivers/s390/kvm/virtio_ccw.c          |  5 ++++-
 drivers/scsi/virtio_scsi.c             |  3 ++-
 drivers/virtio/virtio_balloon.c        |  3 ++-
 drivers/virtio/virtio_mmio.c           |  5 ++++-
 drivers/virtio/virtio_pci_common.c     | 16 ++++++++++++++--
 drivers/virtio/virtio_pci_common.h     |  5 ++++-
 include/linux/virtio_config.h          |  8 ++++++--
 16 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 7ef7c09..7b2a15f 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -419,7 +419,8 @@ static int init_vq(struct virtio_blk *vblk)
 	}
 
 	/* Discover virtqueues and write information to configuration.  */
-	err = vdev->config->find_vqs(vdev, num_vqs, vqs, callbacks, names);
+	err = vdev->config->find_vqs(vdev, num_vqs, vqs, callbacks, names,
+				     NULL, NULL, 0);
 	if (err)
 		goto err_find_vqs;
 
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index de03df9..68ed755 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1911,7 +1911,8 @@ static int init_vqs(struct ports_device *portdev)
 	/* Find the queues. */
 	err = portdev->vdev->config->find_vqs(portdev->vdev, nr_queues, vqs,
 					      io_callbacks,
-					      (const char **)io_names);
+					      (const char **)io_names,
+					      NULL, NULL, 0);
 	if (err)
 		goto free;
 
diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index 89088d6..f0866dc 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -375,7 +375,10 @@ static void lg_del_vqs(struct virtio_device *vdev)
 static int lg_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       struct virtqueue *vqs[],
 		       vq_callback_t *callbacks[],
-		       const char *names[])
+		       const char *names[],
+		       unsigned channels[],
+		       const char *channel_names[],
+		       unsigned nchannels)
 {
 	struct lguest_device *ldev = to_lgdev(vdev);
 	int i;
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index e486a0c..09c3f85 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -311,7 +311,10 @@ unmap:
 static int mic_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			struct virtqueue *vqs[],
 			vq_callback_t *callbacks[],
-			const char *names[])
+			const char *names[],
+			unsigned channels[],
+			const char *channel_names[],
+			unsigned nchannels)
 {
 	struct mic_vdev *mvdev = to_micvdev(vdev);
 	struct mic_device_ctrl __iomem *dc = mvdev->dc;
diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index b306210..150809d 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -679,7 +679,8 @@ static int cfv_probe(struct virtio_device *vdev)
 		goto err;
 
 	/* Get the TX virtio ring. This is a "guest side vring". */
-	err = vdev->config->find_vqs(vdev, 1, &cfv->vq_tx, &vq_cbs, &names);
+	err = vdev->config->find_vqs(vdev, 1, &cfv->vq_tx, &vq_cbs, &names,
+				     NULL, NULL, 0);
 	if (err)
 		goto err;
 
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 5ca9771..3ba3499 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1558,7 +1558,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
 	}
 
 	ret = vi->vdev->config->find_vqs(vi->vdev, total_vqs, vqs, callbacks,
-					 names);
+					 names, NULL, NULL, 0);
 	if (ret)
 		goto err_find;
 
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index e1a1023..f193b24 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -147,7 +147,10 @@ static void rproc_virtio_del_vqs(struct virtio_device *vdev)
 static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       struct virtqueue *vqs[],
 		       vq_callback_t *callbacks[],
-		       const char *names[])
+		       const char *names[],
+			unsigned channels[],
+			const char *channel_names[],
+			unsigned nchannels)
 {
 	struct rproc *rproc = vdev_to_rproc(vdev);
 	int i, ret;
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 92f6af6..3f35ab5 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -964,7 +964,8 @@ static int rpmsg_probe(struct virtio_device *vdev)
 	init_waitqueue_head(&vrp->sendq);
 
 	/* We expect two virtqueues, rx and tx (and in this order) */
-	err = vdev->config->find_vqs(vdev, 2, vqs, vq_cbs, names);
+	err = vdev->config->find_vqs(vdev, 2, vqs, vq_cbs, names,
+				     NULL, NULL, 0);
 	if (err)
 		goto free_vrp;
 
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index dd65c8b..96991af 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -255,7 +255,10 @@ static void kvm_del_vqs(struct virtio_device *vdev)
 static int kvm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			struct virtqueue *vqs[],
 			vq_callback_t *callbacks[],
-			const char *names[])
+			const char *names[],
+			unsigned channels[],
+			const char *channel_names[],
+			unsigned nchannels)
 {
 	struct kvm_device *kdev = to_kvmdev(vdev);
 	int i;
diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 71d7802..9369520 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -617,7 +617,10 @@ out:
 static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			       struct virtqueue *vqs[],
 			       vq_callback_t *callbacks[],
-			       const char *names[])
+			       const char *names[],
+			       unsigned channels[],
+			       const char *channel_names[],
+			       unsigned nchannels)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	unsigned long *indicatorp = NULL;
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index c52bb5d..5889a57 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -914,7 +914,8 @@ static int virtscsi_init(struct virtio_device *vdev,
 	}
 
 	/* Discover virtqueues and write information to configuration.  */
-	err = vdev->config->find_vqs(vdev, num_vqs, vqs, callbacks, names);
+	err = vdev->config->find_vqs(vdev, num_vqs, vqs, callbacks, names,
+				     NULL, NULL, 0);
 	if (err)
 		goto out;
 
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 50c5f42..f3169ed 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -375,7 +375,8 @@ static int init_vqs(struct virtio_balloon *vb)
 	 * optionally stat.
 	 */
 	nvqs = virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ) ? 3 : 2;
-	err = vb->vdev->config->find_vqs(vb->vdev, nvqs, vqs, callbacks, names);
+	err = vb->vdev->config->find_vqs(vb->vdev, nvqs, vqs, callbacks, names,
+					 NULL, NULL, 0);
 	if (err)
 		return err;
 
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 00d115b..a0d40f0 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -393,7 +393,10 @@ error_available:
 static int vm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       struct virtqueue *vqs[],
 		       vq_callback_t *callbacks[],
-		       const char *names[])
+		       const char *names[],
+		       unsigned channels[],
+		       const char *channel_names[],
+		       unsigned nchannels)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 	unsigned int irq = platform_get_irq(vm_dev->pdev, 0);
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 36db4ac..5b88ba0 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -389,12 +389,23 @@ error_find:
 int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		struct virtqueue *vqs[],
 		vq_callback_t *callbacks[],
-		const char *names[])
+		const char *names[],
+		unsigned channels[],
+		const char *channel_names[],
+		unsigned nchannels)
 {
 	int err, i;
-	unsigned *channels = kmalloc_array(nvqs, sizeof(unsigned), GFP_KERNEL);
 	const char *cnames[] = {"virtqueues"};
 
+	if (nchannels) {
+		/* Try channel settings */
+		err = vp_try_to_find_vqs(vdev, nvqs, vqs, callbacks, names,
+					 channels, channel_names, nchannels);
+		if (!err)
+			return 0;
+	}
+
+	channels = kmalloc_array(nvqs, sizeof(unsigned), GFP_KERNEL);
 	if (!channels)
 		return -ENOMEM;
 
@@ -405,6 +416,7 @@ int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 				 names, nvqs);
 	if (!err)
 		goto out;
+
 	/* Fallback: MSI-X with one vector for config, one shared for queues. */
 	for (i = 0; i < nvqs; i++)
 		channels[i] = 0;
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index ffe8f7a..c16e46e 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -123,7 +123,10 @@ void vp_del_vqs(struct virtio_device *vdev);
 int vp_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       struct virtqueue *vqs[],
 		       vq_callback_t *callbacks[],
-		       const char *names[]);
+		       const char *names[],
+		       unsigned channels[],
+		       const char *channel_names[],
+		       unsigned nchannels);
 const char *vp_bus_name(struct virtio_device *vdev);
 
 /* Setup the affinity for a virtqueue:
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index ca3ed78..33fd210 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -70,7 +70,10 @@ struct virtio_config_ops {
 	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
 			struct virtqueue *vqs[],
 			vq_callback_t *callbacks[],
-			const char *names[]);
+			const char *names[],
+			unsigned int channels[],
+			const char *channel_names[],
+			unsigned nchannels);
 	void (*del_vqs)(struct virtio_device *);
 	u64 (*get_features)(struct virtio_device *vdev);
 	int (*finalize_features)(struct virtio_device *vdev);
@@ -156,7 +159,8 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
 	vq_callback_t *callbacks[] = { c };
 	const char *names[] = { n };
 	struct virtqueue *vq;
-	int err = vdev->config->find_vqs(vdev, 1, &vq, callbacks, names);
+	int err = vdev->config->find_vqs(vdev, 1, &vq, callbacks, names,
+					 NULL, NULL, 0);
 	if (err < 0)
 		return ERR_PTR(err);
 	return vq;
-- 
1.8.3.1

