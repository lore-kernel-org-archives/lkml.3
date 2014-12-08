Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbaLHNH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:07:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbaLHNHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:07:23 -0500
Date: Mon, 8 Dec 2014 15:05:58 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dahi@linux.vnet.ibm.com, cornelia.huck@de.ibm.com, rusty@rustcorp.com.au,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: [PATCH v3 3/6] virtio: allow finalize_features to fail
Message-ID: <1418042769-25539-4-git-send-email-mst@redhat.com>
References: <1418042769-25539-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418042769-25539-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will make it easy for transports to validate features and return
failure.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio_config.h          |  3 ++-
 drivers/lguest/lguest_device.c         |  4 +++-
 drivers/misc/mic/card/mic_virtio.c     |  4 +++-
 drivers/remoteproc/remoteproc_virtio.c |  4 +++-
 drivers/s390/kvm/kvm_virtio.c          |  4 +++-
 drivers/s390/kvm/virtio_ccw.c          |  6 ++++--
 drivers/virtio/virtio.c                | 21 ++++++++++++++-------
 drivers/virtio/virtio_mmio.c           |  4 +++-
 drivers/virtio/virtio_pci.c            |  4 +++-
 9 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 1fa5faa..7979f85 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -47,6 +47,7 @@
  *	vdev: the virtio_device
  *	This gives the final feature bits for the device: it can change
  *	the dev->feature bits if it wants.
+ *	Returns 0 on success or error status
  * @bus_name: return the bus name associated with the device
  *	vdev: the virtio_device
  *      This returns a pointer to the bus name a la pci_name from which
@@ -68,7 +69,7 @@ struct virtio_config_ops {
 			const char *names[]);
 	void (*del_vqs)(struct virtio_device *);
 	u64 (*get_features)(struct virtio_device *vdev);
-	void (*finalize_features)(struct virtio_device *vdev);
+	int (*finalize_features)(struct virtio_device *vdev);
 	const char *(*bus_name)(struct virtio_device *vdev);
 	int (*set_vq_affinity)(struct virtqueue *vq, int cpu);
 };
diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index 9b77b66..89088d6 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -126,7 +126,7 @@ static void status_notify(struct virtio_device *vdev)
  * sorted out, this routine is called so we can tell the Host which features we
  * understand and accept.
  */
-static void lg_finalize_features(struct virtio_device *vdev)
+static int lg_finalize_features(struct virtio_device *vdev)
 {
 	unsigned int i, bits;
 	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
@@ -153,6 +153,8 @@ static void lg_finalize_features(struct virtio_device *vdev)
 
 	/* Tell Host we've finished with this device's feature negotiation */
 	status_notify(vdev);
+
+	return 0;
 }
 
 /* Once they've found a field, getting a copy of it is easy. */
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index d027d29..e486a0c 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -84,7 +84,7 @@ static u64 mic_get_features(struct virtio_device *vdev)
 	return features;
 }
 
-static void mic_finalize_features(struct virtio_device *vdev)
+static int mic_finalize_features(struct virtio_device *vdev)
 {
 	unsigned int i, bits;
 	struct mic_device_desc __iomem *desc = to_micvdev(vdev)->desc;
@@ -107,6 +107,8 @@ static void mic_finalize_features(struct virtio_device *vdev)
 			iowrite8(ioread8(&out_features[i / 8]) | (1 << (i % 8)),
 				 &out_features[i / 8]);
 	}
+
+	return 0;
 }
 
 /*
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 627737e..e1a1023 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -217,7 +217,7 @@ static u64 rproc_virtio_get_features(struct virtio_device *vdev)
 	return rsc->dfeatures;
 }
 
-static void rproc_virtio_finalize_features(struct virtio_device *vdev)
+static int rproc_virtio_finalize_features(struct virtio_device *vdev)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 	struct fw_rsc_vdev *rsc;
@@ -235,6 +235,8 @@ static void rproc_virtio_finalize_features(struct virtio_device *vdev)
 	 * to the remote processor once it is powered on.
 	 */
 	rsc->gfeatures = vdev->features;
+
+	return 0;
 }
 
 static void rproc_virtio_get(struct virtio_device *vdev, unsigned offset,
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index f5575cc..dd65c8b 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -93,7 +93,7 @@ static u64 kvm_get_features(struct virtio_device *vdev)
 	return features;
 }
 
-static void kvm_finalize_features(struct virtio_device *vdev)
+static int kvm_finalize_features(struct virtio_device *vdev)
 {
 	unsigned int i, bits;
 	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
@@ -112,6 +112,8 @@ static void kvm_finalize_features(struct virtio_device *vdev)
 		if (__virtio_test_bit(vdev, i))
 			out_features[i / 8] |= (1 << (i % 8));
 	}
+
+	return 0;
 }
 
 /*
diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index c792b5f..789275f 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -752,7 +752,7 @@ out_free:
 	return rc;
 }
 
-static void virtio_ccw_finalize_features(struct virtio_device *vdev)
+static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct virtio_feature_desc *features;
@@ -760,7 +760,7 @@ static void virtio_ccw_finalize_features(struct virtio_device *vdev)
 
 	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
 	if (!ccw)
-		return;
+		return 0;
 
 	features = kzalloc(sizeof(*features), GFP_DMA | GFP_KERNEL);
 	if (!features)
@@ -793,6 +793,8 @@ static void virtio_ccw_finalize_features(struct virtio_device *vdev)
 out_free:
 	kfree(features);
 	kfree(ccw);
+
+	return 0;
 }
 
 static void virtio_ccw_get_config(struct virtio_device *vdev,
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 224f854..e1673a5 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -212,7 +212,9 @@ static int virtio_dev_probe(struct device *_d)
 		if (device_features & (1ULL << i))
 			__virtio_set_bit(dev, i);
 
-	dev->config->finalize_features(dev);
+	err = dev->config->finalize_features(dev);
+	if (err)
+		goto err;
 
 	if (virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
 		add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
@@ -354,6 +356,7 @@ EXPORT_SYMBOL_GPL(virtio_device_freeze);
 int virtio_device_restore(struct virtio_device *dev)
 {
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
+	int ret;
 
 	/* We always start by resetting the device, in case a previous
 	 * driver messed it up. */
@@ -373,14 +376,14 @@ int virtio_device_restore(struct virtio_device *dev)
 	/* We have a driver! */
 	add_status(dev, VIRTIO_CONFIG_S_DRIVER);
 
-	dev->config->finalize_features(dev);
+	ret = dev->config->finalize_features(dev);
+	if (ret)
+		goto err;
 
 	if (drv->restore) {
-		int ret = drv->restore(dev);
-		if (ret) {
-			add_status(dev, VIRTIO_CONFIG_S_FAILED);
-			return ret;
-		}
+		ret = drv->restore(dev);
+		if (ret)
+			goto err;
 	}
 
 	/* Finally, tell the device we're all set */
@@ -389,6 +392,10 @@ int virtio_device_restore(struct virtio_device *dev)
 	virtio_config_enable(dev);
 
 	return 0;
+
+err:
+	add_status(dev, VIRTIO_CONFIG_S_FAILED);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(virtio_device_restore);
 #endif
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index aec1dae..5219210 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -152,7 +152,7 @@ static u64 vm_get_features(struct virtio_device *vdev)
 	return readl(vm_dev->base + VIRTIO_MMIO_HOST_FEATURES);
 }
 
-static void vm_finalize_features(struct virtio_device *vdev)
+static int vm_finalize_features(struct virtio_device *vdev)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 
@@ -164,6 +164,8 @@ static void vm_finalize_features(struct virtio_device *vdev)
 
 	writel(0, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES_SEL);
 	writel(vdev->features, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES);
+
+	return 0;
 }
 
 static void vm_get(struct virtio_device *vdev, unsigned offset,
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index dd6df97..9be59d9 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -112,7 +112,7 @@ static u64 vp_get_features(struct virtio_device *vdev)
 }
 
 /* virtio config->finalize_features() implementation */
-static void vp_finalize_features(struct virtio_device *vdev)
+static int vp_finalize_features(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 
@@ -124,6 +124,8 @@ static void vp_finalize_features(struct virtio_device *vdev)
 
 	/* We only support 32 feature bits. */
 	iowrite32(vdev->features, vp_dev->ioaddr + VIRTIO_PCI_GUEST_FEATURES);
+
+	return 0;
 }
 
 /* virtio config->get() implementation */
-- 
MST

