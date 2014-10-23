Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbaJWQYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146AbaJWQVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:21:21 -0400
Date: Thu, 23 Oct 2014 19:24:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Brian Swetland <swetland@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Amit Shah <amit.shah@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        virtualization@lists.linux-foundation.org, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org
Subject: [PATCH RFC v4 04/17] virtio: add support for 64 bit features.
Message-ID: <1414081380-14623-5-git-send-email-mst@redhat.com>
References: <1414081380-14623-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414081380-14623-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Change the u32 to a u64, and make sure to use 1ULL everywhere!

Cc: Brian Swetland <swetland@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
[Thomas Huth: fix up virtio-ccw get_features]
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: Pawel Moll <pawel.moll@arm.com>
Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h                 |  2 +-
 include/linux/virtio_config.h          |  8 ++++----
 tools/virtio/linux/virtio.h            |  2 +-
 tools/virtio/linux/virtio_config.h     |  2 +-
 drivers/char/virtio_console.c          |  2 +-
 drivers/lguest/lguest_device.c         | 10 +++++-----
 drivers/remoteproc/remoteproc_virtio.c |  5 ++++-
 drivers/s390/kvm/kvm_virtio.c          | 10 +++++-----
 drivers/s390/kvm/virtio_ccw.c          | 29 ++++++++++++++++++++++++-----
 drivers/virtio/virtio.c                | 12 ++++++------
 drivers/virtio/virtio_mmio.c           | 14 +++++++++-----
 drivers/virtio/virtio_pci.c            |  5 ++---
 drivers/virtio/virtio_ring.c           |  2 +-
 13 files changed, 64 insertions(+), 39 deletions(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 7828a7f..149284e 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -101,7 +101,7 @@ struct virtio_device {
 	const struct virtio_config_ops *config;
 	const struct vringh_config_ops *vringh_config;
 	struct list_head vqs;
-	u32 features;
+	u64 features;
 	void *priv;
 };
 
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index f03cb7a..4bc2ebe 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -67,7 +67,7 @@ struct virtio_config_ops {
 			vq_callback_t *callbacks[],
 			const char *names[]);
 	void (*del_vqs)(struct virtio_device *);
-	u32 (*get_features)(struct virtio_device *vdev);
+	u64 (*get_features)(struct virtio_device *vdev);
 	void (*finalize_features)(struct virtio_device *vdev);
 	const char *(*bus_name)(struct virtio_device *vdev);
 	int (*set_vq_affinity)(struct virtqueue *vq, int cpu);
@@ -87,14 +87,14 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
 {
 	/* Did you forget to fix assumptions on max features? */
 	if (__builtin_constant_p(fbit))
-		BUILD_BUG_ON(fbit >= 32);
+		BUILD_BUG_ON(fbit >= 64);
 	else
-		BUG_ON(fbit >= 32);
+		BUG_ON(fbit >= 64);
 
 	if (fbit < VIRTIO_TRANSPORT_F_START)
 		virtio_check_driver_offered_feature(vdev, fbit);
 
-	return vdev->features & (1 << fbit);
+	return vdev->features & (1ULL << fbit);
 }
 
 static inline
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index 72bff70..8eb6421 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -10,7 +10,7 @@
 
 struct virtio_device {
 	void *dev;
-	u32 features;
+	u64 features;
 };
 
 struct virtqueue {
diff --git a/tools/virtio/linux/virtio_config.h b/tools/virtio/linux/virtio_config.h
index 1f1636b..a254c2b 100644
--- a/tools/virtio/linux/virtio_config.h
+++ b/tools/virtio/linux/virtio_config.h
@@ -2,5 +2,5 @@
 #define VIRTIO_TRANSPORT_F_END		32
 
 #define virtio_has_feature(dev, feature) \
-	((dev)->features & (1 << feature))
+	((dev)->features & (1ULL << feature))
 
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index d79baf0..1690b2a 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -355,7 +355,7 @@ static inline bool use_multiport(struct ports_device *portdev)
 	 */
 	if (!portdev->vdev)
 		return 0;
-	return portdev->vdev->features & (1 << VIRTIO_CONSOLE_F_MULTIPORT);
+	return portdev->vdev->features & (1ULL << VIRTIO_CONSOLE_F_MULTIPORT);
 }
 
 static DEFINE_SPINLOCK(dma_bufs_lock);
diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index c831c47..4d29bcd 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -94,17 +94,17 @@ static unsigned desc_size(const struct lguest_device_desc *desc)
 }
 
 /* This gets the device's feature bits. */
-static u32 lg_get_features(struct virtio_device *vdev)
+static u64 lg_get_features(struct virtio_device *vdev)
 {
 	unsigned int i;
-	u32 features = 0;
+	u64 features = 0;
 	struct lguest_device_desc *desc = to_lgdev(vdev)->desc;
 	u8 *in_features = lg_features(desc);
 
 	/* We do this the slow but generic way. */
-	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
+	for (i = 0; i < min(desc->feature_len * 8, 64); i++)
 		if (in_features[i / 8] & (1 << (i % 8)))
-			features |= (1 << i);
+			features |= (1ULL << i);
 
 	return features;
 }
@@ -144,7 +144,7 @@ static void lg_finalize_features(struct virtio_device *vdev)
 	memset(out_features, 0, desc->feature_len);
 	bits = min_t(unsigned, desc->feature_len, sizeof(vdev->features)) * 8;
 	for (i = 0; i < bits; i++) {
-		if (vdev->features & (1 << i))
+		if (vdev->features & (1ULL << i))
 			out_features[i / 8] |= (1 << (i % 8));
 	}
 
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index dafaf38..627737e 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -207,7 +207,7 @@ static void rproc_virtio_reset(struct virtio_device *vdev)
 }
 
 /* provide the vdev features as retrieved from the firmware */
-static u32 rproc_virtio_get_features(struct virtio_device *vdev)
+static u64 rproc_virtio_get_features(struct virtio_device *vdev)
 {
 	struct rproc_vdev *rvdev = vdev_to_rvdev(vdev);
 	struct fw_rsc_vdev *rsc;
@@ -227,6 +227,9 @@ static void rproc_virtio_finalize_features(struct virtio_device *vdev)
 	/* Give virtio_ring a chance to accept features */
 	vring_transport_features(vdev);
 
+	/* Make sure we don't have any features > 32 bits! */
+	BUG_ON((u32)vdev->features != vdev->features);
+
 	/*
 	 * Remember the finalized features of our vdev, and provide it
 	 * to the remote processor once it is powered on.
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index ac79a09..c78251d 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -80,16 +80,16 @@ static unsigned desc_size(const struct kvm_device_desc *desc)
 }
 
 /* This gets the device's feature bits. */
-static u32 kvm_get_features(struct virtio_device *vdev)
+static u64 kvm_get_features(struct virtio_device *vdev)
 {
 	unsigned int i;
-	u32 features = 0;
+	u64 features = 0;
 	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
 	u8 *in_features = kvm_vq_features(desc);
 
-	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
+	for (i = 0; i < min(desc->feature_len * 8, 64); i++)
 		if (in_features[i / 8] & (1 << (i % 8)))
-			features |= (1 << i);
+			features |= (1ULL << i);
 	return features;
 }
 
@@ -106,7 +106,7 @@ static void kvm_finalize_features(struct virtio_device *vdev)
 	memset(out_features, 0, desc->feature_len);
 	bits = min_t(unsigned, desc->feature_len, sizeof(vdev->features)) * 8;
 	for (i = 0; i < bits; i++) {
-		if (vdev->features & (1 << i))
+		if (vdev->features & (1ULL << i))
 			out_features[i / 8] |= (1 << (i % 8));
 	}
 }
diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 9ffd96f..27aab69 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -660,11 +660,12 @@ static void virtio_ccw_reset(struct virtio_device *vdev)
 	kfree(ccw);
 }
 
-static u32 virtio_ccw_get_features(struct virtio_device *vdev)
+static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct virtio_feature_desc *features;
-	int ret, rc;
+	int ret;
+	u64 rc;
 	struct ccw1 *ccw;
 
 	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
@@ -677,7 +678,6 @@ static u32 virtio_ccw_get_features(struct virtio_device *vdev)
 		goto out_free;
 	}
 	/* Read the feature bits from the host. */
-	/* TODO: Features > 32 bits */
 	features->index = 0;
 	ccw->cmd_code = CCW_CMD_READ_FEAT;
 	ccw->flags = 0;
@@ -691,6 +691,16 @@ static u32 virtio_ccw_get_features(struct virtio_device *vdev)
 
 	rc = le32_to_cpu(features->features);
 
+	/* Read second half feature bits from the host. */
+	features->index = 1;
+	ccw->cmd_code = CCW_CMD_READ_FEAT;
+	ccw->flags = 0;
+	ccw->count = sizeof(*features);
+	ccw->cda = (__u32)(unsigned long)features;
+	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
+	if (ret == 0)
+		rc |= (u64)le32_to_cpu(features->features) << 32;
+
 out_free:
 	kfree(features);
 	kfree(ccw);
@@ -715,8 +725,17 @@ static void virtio_ccw_finalize_features(struct virtio_device *vdev)
 	vring_transport_features(vdev);
 
 	features->index = 0;
-	features->features = cpu_to_le32(vdev->features);
-	/* Write the feature bits to the host. */
+	features->features = cpu_to_le32((u32)vdev->features);
+	/* Write the first half of the feature bits to the host. */
+	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
+	ccw->flags = 0;
+	ccw->count = sizeof(*features);
+	ccw->cda = (__u32)(unsigned long)features;
+	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
+
+	features->index = 1;
+	features->features = cpu_to_le32(vdev->features >> 32);
+	/* Write the second half of the feature bits to the host. */
 	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 7814b1f..d213567 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -159,7 +159,7 @@ static int virtio_dev_probe(struct device *_d)
 	int err, i;
 	struct virtio_device *dev = dev_to_virtio(_d);
 	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
-	u32 device_features;
+	u64 device_features;
 
 	/* We have a driver! */
 	add_status(dev, VIRTIO_CONFIG_S_DRIVER);
@@ -171,15 +171,15 @@ static int virtio_dev_probe(struct device *_d)
 	dev->features = 0;
 	for (i = 0; i < drv->feature_table_size; i++) {
 		unsigned int f = drv->feature_table[i];
-		BUG_ON(f >= 32);
-		if (device_features & (1 << f))
-			dev->features |= (1 << f);
+		BUG_ON(f >= 64);
+		if (device_features & (1ULL << f))
+			dev->features |= (1ULL << f);
 	}
 
 	/* Transport features always preserved to pass to finalize_features. */
 	for (i = VIRTIO_TRANSPORT_F_START; i < VIRTIO_TRANSPORT_F_END; i++)
-		if (device_features & (1 << i))
-			dev->features |= (1 << i);
+		if (device_features & (1ULL << i))
+			dev->features |= (1ULL << i);
 
 	dev->config->finalize_features(dev);
 
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index eb5b0e2..fd01c6d 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -142,14 +142,16 @@ struct virtio_mmio_vq_info {
 
 /* Configuration interface */
 
-static u32 vm_get_features(struct virtio_device *vdev)
+static u64 vm_get_features(struct virtio_device *vdev)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
+	u64 features;
 
-	/* TODO: Features > 32 bits */
 	writel(0, vm_dev->base + VIRTIO_MMIO_HOST_FEATURES_SEL);
-
-	return readl(vm_dev->base + VIRTIO_MMIO_HOST_FEATURES);
+	features = readl(vm_dev->base + VIRTIO_MMIO_HOST_FEATURES);
+	writel(1, vm_dev->base + VIRTIO_MMIO_HOST_FEATURES_SEL);
+	features |= ((u64)readl(vm_dev->base + VIRTIO_MMIO_HOST_FEATURES) << 32);
+	return features;
 }
 
 static void vm_finalize_features(struct virtio_device *vdev)
@@ -160,7 +162,9 @@ static void vm_finalize_features(struct virtio_device *vdev)
 	vring_transport_features(vdev);
 
 	writel(0, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES_SEL);
-	writel(vdev->features, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES);
+	writel((u32)vdev->features, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES);
+	writel(1, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES_SEL);
+	writel(vdev->features >> 32, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES);
 }
 
 static void vm_get(struct virtio_device *vdev, unsigned offset,
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index ab95a4c..68c0711 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -102,12 +102,11 @@ static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
 }
 
 /* virtio config->get_features() implementation */
-static u32 vp_get_features(struct virtio_device *vdev)
+static u64 vp_get_features(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 
-	/* When someone needs more than 32 feature bits, we'll need to
-	 * steal a bit to indicate that the rest are somewhere else. */
+	/* We only support 32 feature bits. */
 	return ioread32(vp_dev->ioaddr + VIRTIO_PCI_HOST_FEATURES);
 }
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index ea1c02e..b311fa7 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -782,7 +782,7 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		default:
 			/* We don't understand this bit. */
-			vdev->features &= ~(1 << i);
+			vdev->features &= ~(1ULL << i);
 		}
 	}
 }
-- 
MST

