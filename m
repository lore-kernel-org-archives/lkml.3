Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaK0Ma7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 07:30:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbaK0Ma5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 07:30:57 -0500
Date: Thu, 27 Nov 2014 14:30:11 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com,
        Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Siva Yerramreddy <yshivakrishna@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        virtualization@lists.linux-foundation.org, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org
Subject: [PATCH v5 03/45] virtio: add support for 64 bit features.
Message-ID: <1417091078-24611-4-git-send-email-mst@redhat.com>
References: <1417091078-24611-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417091078-24611-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Change the u32 to a u64, and make sure to use 1ULL
in all devices.

Note: transports are unchanged, and only set low 32 bit.
This ensures that no transport sets e.g. VERSION_1
by mistake without proper support.

MST: drop most transport-specific changes.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h                 |  2 +-
 include/linux/virtio_config.h          |  8 ++++----
 tools/virtio/linux/virtio.h            |  2 +-
 tools/virtio/linux/virtio_config.h     |  2 +-
 drivers/char/virtio_console.c          |  2 +-
 drivers/lguest/lguest_device.c         |  2 +-
 drivers/misc/mic/card/mic_virtio.c     |  2 +-
 drivers/remoteproc/remoteproc_virtio.c |  2 +-
 drivers/s390/kvm/kvm_virtio.c          |  2 +-
 drivers/s390/kvm/virtio_ccw.c          |  2 +-
 drivers/virtio/virtio.c                | 12 ++++++------
 drivers/virtio/virtio_mmio.c           |  2 +-
 drivers/virtio/virtio_pci.c            |  2 +-
 drivers/virtio/virtio_ring.c           |  2 +-
 14 files changed, 22 insertions(+), 22 deletions(-)

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
index aa84d0e..022d904 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -66,7 +66,7 @@ struct virtio_config_ops {
 			vq_callback_t *callbacks[],
 			const char *names[]);
 	void (*del_vqs)(struct virtio_device *);
-	u32 (*get_features)(struct virtio_device *vdev);
+	u64 (*get_features)(struct virtio_device *vdev);
 	void (*finalize_features)(struct virtio_device *vdev);
 	const char *(*bus_name)(struct virtio_device *vdev);
 	int (*set_vq_affinity)(struct virtqueue *vq, int cpu);
@@ -86,14 +86,14 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
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
index 0074f9b..fda9a75 100644
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
index c831c47..49d04d5 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -94,7 +94,7 @@ static unsigned desc_size(const struct lguest_device_desc *desc)
 }
 
 /* This gets the device's feature bits. */
-static u32 lg_get_features(struct virtio_device *vdev)
+static u64 lg_get_features(struct virtio_device *vdev)
 {
 	unsigned int i;
 	u32 features = 0;
diff --git a/drivers/misc/mic/card/mic_virtio.c b/drivers/misc/mic/card/mic_virtio.c
index 2a6bc3f..d037f57 100644
--- a/drivers/misc/mic/card/mic_virtio.c
+++ b/drivers/misc/mic/card/mic_virtio.c
@@ -68,7 +68,7 @@ static inline struct device *mic_dev(struct mic_vdev *mvdev)
 }
 
 /* This gets the device's feature bits. */
-static u32 mic_get_features(struct virtio_device *vdev)
+static u64 mic_get_features(struct virtio_device *vdev)
 {
 	unsigned int i, bits;
 	u32 features = 0;
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index dafaf38..62897db 100644
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
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index ac79a09..1455a9a 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -80,7 +80,7 @@ static unsigned desc_size(const struct kvm_device_desc *desc)
 }
 
 /* This gets the device's feature bits. */
-static u32 kvm_get_features(struct virtio_device *vdev)
+static u64 kvm_get_features(struct virtio_device *vdev)
 {
 	unsigned int i;
 	u32 features = 0;
diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 1dbee95..56d7895 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -660,7 +660,7 @@ static void virtio_ccw_reset(struct virtio_device *vdev)
 	kfree(ccw);
 }
 
-static u32 virtio_ccw_get_features(struct virtio_device *vdev)
+static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct virtio_feature_desc *features;
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
index eb5b0e2..c63d0ef 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -142,7 +142,7 @@ struct virtio_mmio_vq_info {
 
 /* Configuration interface */
 
-static u32 vm_get_features(struct virtio_device *vdev)
+static u64 vm_get_features(struct virtio_device *vdev)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
 
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index ab95a4c..80be24a 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -102,7 +102,7 @@ static struct virtio_pci_device *to_vp_device(struct virtio_device *vdev)
 }
 
 /* virtio config->get_features() implementation */
-static u32 vp_get_features(struct virtio_device *vdev)
+static u64 vp_get_features(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 15a8a05..61a1fe1 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -781,7 +781,7 @@ void vring_transport_features(struct virtio_device *vdev)
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

