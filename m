Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbaJVSl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 14:41:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210AbaJVSlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 14:41:39 -0400
Date: Wed, 22 Oct 2014 21:44:17 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Brian Swetland <swetland@google.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Pawel Moll <pawel.moll@arm.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Heinz Graalfs <graalfs@linux.vnet.ibm.com>,
        Joel Stanley <joel@jms.id.au>,
        virtualization@lists.linux-foundation.org, lguest@lists.ozlabs.org,
        linux-s390@vger.kernel.org
Subject: [PATCH RFC v3 03/16] virtio: use u32, not bitmap for struct
 virtio_device's features
Message-ID: <1414003404-505-4-git-send-email-mst@redhat.com>
References: <1414003404-505-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414003404-505-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

It seemed like a good idea, but it's actually a pain when we get more
than 32 feature bits.  Just change it to a u32 for now.

Cc: Brian Swetland <swetland@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Acked-by: Pawel Moll <pawel.moll@arm.com>
Acked-by: Ohad Ben-Cohen <ohad@wizery.com>

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/linux/virtio.h                 |  3 +--
 include/linux/virtio_config.h          |  2 +-
 tools/virtio/linux/virtio.h            | 22 +---------------------
 tools/virtio/linux/virtio_config.h     |  2 +-
 drivers/char/virtio_console.c          |  2 +-
 drivers/lguest/lguest_device.c         |  8 ++++----
 drivers/remoteproc/remoteproc_virtio.c |  2 +-
 drivers/s390/kvm/kvm_virtio.c          |  2 +-
 drivers/s390/kvm/virtio_ccw.c          | 23 +++++++++--------------
 drivers/virtio/virtio.c                | 10 +++++-----
 drivers/virtio/virtio_mmio.c           |  8 ++------
 drivers/virtio/virtio_pci.c            |  3 +--
 drivers/virtio/virtio_ring.c           |  2 +-
 tools/virtio/virtio_test.c             |  5 ++---
 tools/virtio/vringh_test.c             | 16 ++++++++--------
 15 files changed, 39 insertions(+), 71 deletions(-)

diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 65261a7..7828a7f 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -101,8 +101,7 @@ struct virtio_device {
 	const struct virtio_config_ops *config;
 	const struct vringh_config_ops *vringh_config;
 	struct list_head vqs;
-	/* Note that this is a Linux set_bit-style bitmap. */
-	unsigned long features[1];
+	u32 features;
 	void *priv;
 };
 
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index d38d3c2..946bed7 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -94,7 +94,7 @@ static inline bool virtio_has_feature(const struct virtio_device *vdev,
 	if (fbit < VIRTIO_TRANSPORT_F_START)
 		virtio_check_driver_offered_feature(vdev, fbit);
 
-	return test_bit(fbit, vdev->features);
+	return vdev->features & (1 << fbit);
 }
 
 static inline
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index 5a2d1f0..72bff70 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -6,31 +6,11 @@
 /* TODO: empty stubs for now. Broken but enough for virtio_ring.c */
 #define list_add_tail(a, b) do {} while (0)
 #define list_del(a) do {} while (0)
-
-#define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
-#define BITS_PER_BYTE		8
-#define BITS_PER_LONG (sizeof(long) * BITS_PER_BYTE)
-#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))
-
-/* TODO: Not atomic as it should be:
- * we don't use this for anything important. */
-static inline void clear_bit(int nr, volatile unsigned long *addr)
-{
-	unsigned long mask = BIT_MASK(nr);
-	unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
-
-	*p &= ~mask;
-}
-
-static inline int test_bit(int nr, const volatile unsigned long *addr)
-{
-        return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
-}
 /* end of stubs */
 
 struct virtio_device {
 	void *dev;
-	unsigned long features[1];
+	u32 features;
 };
 
 struct virtqueue {
diff --git a/tools/virtio/linux/virtio_config.h b/tools/virtio/linux/virtio_config.h
index 5049967..1f1636b 100644
--- a/tools/virtio/linux/virtio_config.h
+++ b/tools/virtio/linux/virtio_config.h
@@ -2,5 +2,5 @@
 #define VIRTIO_TRANSPORT_F_END		32
 
 #define virtio_has_feature(dev, feature) \
-	test_bit((feature), (dev)->features)
+	((dev)->features & (1 << feature))
 
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index bfa6400..d79baf0 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -355,7 +355,7 @@ static inline bool use_multiport(struct ports_device *portdev)
 	 */
 	if (!portdev->vdev)
 		return 0;
-	return portdev->vdev->features[0] & (1 << VIRTIO_CONSOLE_F_MULTIPORT);
+	return portdev->vdev->features & (1 << VIRTIO_CONSOLE_F_MULTIPORT);
 }
 
 static DEFINE_SPINLOCK(dma_bufs_lock);
diff --git a/drivers/lguest/lguest_device.c b/drivers/lguest/lguest_device.c
index d0a1d8a..c831c47 100644
--- a/drivers/lguest/lguest_device.c
+++ b/drivers/lguest/lguest_device.c
@@ -137,14 +137,14 @@ static void lg_finalize_features(struct virtio_device *vdev)
 	vring_transport_features(vdev);
 
 	/*
-	 * The vdev->feature array is a Linux bitmask: this isn't the same as a
-	 * the simple array of bits used by lguest devices for features.  So we
-	 * do this slow, manual conversion which is completely general.
+	 * Since lguest is currently x86-only, we're little-endian.  That
+	 * means we could just memcpy.  But it's not time critical, and in
+	 * case someone copies this code, we do it the slow, obvious way.
 	 */
 	memset(out_features, 0, desc->feature_len);
 	bits = min_t(unsigned, desc->feature_len, sizeof(vdev->features)) * 8;
 	for (i = 0; i < bits; i++) {
-		if (test_bit(i, vdev->features))
+		if (vdev->features & (1 << i))
 			out_features[i / 8] |= (1 << (i % 8));
 	}
 
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index a34b506..dafaf38 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -231,7 +231,7 @@ static void rproc_virtio_finalize_features(struct virtio_device *vdev)
 	 * Remember the finalized features of our vdev, and provide it
 	 * to the remote processor once it is powered on.
 	 */
-	rsc->gfeatures = vdev->features[0];
+	rsc->gfeatures = vdev->features;
 }
 
 static void rproc_virtio_get(struct virtio_device *vdev, unsigned offset,
diff --git a/drivers/s390/kvm/kvm_virtio.c b/drivers/s390/kvm/kvm_virtio.c
index 6431290..ac79a09 100644
--- a/drivers/s390/kvm/kvm_virtio.c
+++ b/drivers/s390/kvm/kvm_virtio.c
@@ -106,7 +106,7 @@ static void kvm_finalize_features(struct virtio_device *vdev)
 	memset(out_features, 0, desc->feature_len);
 	bits = min_t(unsigned, desc->feature_len, sizeof(vdev->features)) * 8;
 	for (i = 0; i < bits; i++) {
-		if (test_bit(i, vdev->features))
+		if (vdev->features & (1 << i))
 			out_features[i / 8] |= (1 << (i % 8));
 	}
 }
diff --git a/drivers/s390/kvm/virtio_ccw.c b/drivers/s390/kvm/virtio_ccw.c
index 6cbe6ef..9ffd96f 100644
--- a/drivers/s390/kvm/virtio_ccw.c
+++ b/drivers/s390/kvm/virtio_ccw.c
@@ -701,7 +701,6 @@ static void virtio_ccw_finalize_features(struct virtio_device *vdev)
 {
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct virtio_feature_desc *features;
-	int i;
 	struct ccw1 *ccw;
 
 	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
@@ -715,19 +714,15 @@ static void virtio_ccw_finalize_features(struct virtio_device *vdev)
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
-	for (i = 0; i < sizeof(*vdev->features) / sizeof(features->features);
-	     i++) {
-		int highbits = i % 2 ? 32 : 0;
-		features->index = i;
-		features->features = cpu_to_le32(vdev->features[i / 2]
-						 >> highbits);
-		/* Write the feature bits to the host. */
-		ccw->cmd_code = CCW_CMD_WRITE_FEAT;
-		ccw->flags = 0;
-		ccw->count = sizeof(*features);
-		ccw->cda = (__u32)(unsigned long)features;
-		ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
-	}
+	features->index = 0;
+	features->features = cpu_to_le32(vdev->features);
+	/* Write the feature bits to the host. */
+	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
+	ccw->flags = 0;
+	ccw->count = sizeof(*features);
+	ccw->cda = (__u32)(unsigned long)features;
+	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
+
 out_free:
 	kfree(features);
 	kfree(ccw);
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index df598dd..7814b1f 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -49,9 +49,9 @@ static ssize_t features_show(struct device *_d,
 
 	/* We actually represent this as a bitstring, as it could be
 	 * arbitrary length in future. */
-	for (i = 0; i < ARRAY_SIZE(dev->features)*BITS_PER_LONG; i++)
+	for (i = 0; i < sizeof(dev->features)*8; i++)
 		len += sprintf(buf+len, "%c",
-			       test_bit(i, dev->features) ? '1' : '0');
+			       dev->features & (1ULL << i) ? '1' : '0');
 	len += sprintf(buf+len, "\n");
 	return len;
 }
@@ -168,18 +168,18 @@ static int virtio_dev_probe(struct device *_d)
 	device_features = dev->config->get_features(dev);
 
 	/* Features supported by both device and driver into dev->features. */
-	memset(dev->features, 0, sizeof(dev->features));
+	dev->features = 0;
 	for (i = 0; i < drv->feature_table_size; i++) {
 		unsigned int f = drv->feature_table[i];
 		BUG_ON(f >= 32);
 		if (device_features & (1 << f))
-			set_bit(f, dev->features);
+			dev->features |= (1 << f);
 	}
 
 	/* Transport features always preserved to pass to finalize_features. */
 	for (i = VIRTIO_TRANSPORT_F_START; i < VIRTIO_TRANSPORT_F_END; i++)
 		if (device_features & (1 << i))
-			set_bit(i, dev->features);
+			dev->features |= (1 << i);
 
 	dev->config->finalize_features(dev);
 
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index ef9a165..eb5b0e2 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -155,16 +155,12 @@ static u32 vm_get_features(struct virtio_device *vdev)
 static void vm_finalize_features(struct virtio_device *vdev)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
-	int i;
 
 	/* Give virtio_ring a chance to accept features. */
 	vring_transport_features(vdev);
 
-	for (i = 0; i < ARRAY_SIZE(vdev->features); i++) {
-		writel(i, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES_SEL);
-		writel(vdev->features[i],
-				vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES);
-	}
+	writel(0, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES_SEL);
+	writel(vdev->features, vm_dev->base + VIRTIO_MMIO_GUEST_FEATURES);
 }
 
 static void vm_get(struct virtio_device *vdev, unsigned offset,
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index d34ebfa..ab95a4c 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -120,8 +120,7 @@ static void vp_finalize_features(struct virtio_device *vdev)
 	vring_transport_features(vdev);
 
 	/* We only support 32 feature bits. */
-	BUILD_BUG_ON(ARRAY_SIZE(vdev->features) != 1);
-	iowrite32(vdev->features[0], vp_dev->ioaddr+VIRTIO_PCI_GUEST_FEATURES);
+	iowrite32(vdev->features, vp_dev->ioaddr+VIRTIO_PCI_GUEST_FEATURES);
 }
 
 /* virtio config->get() implementation */
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 048e1bc..ea1c02e 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -782,7 +782,7 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		default:
 			/* We don't understand this bit. */
-			clear_bit(i, vdev->features);
+			vdev->features &= ~(1 << i);
 		}
 	}
 }
diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
index 00ea679..db3437c 100644
--- a/tools/virtio/virtio_test.c
+++ b/tools/virtio/virtio_test.c
@@ -60,7 +60,7 @@ void vhost_vq_setup(struct vdev_info *dev, struct vq_info *info)
 {
 	struct vhost_vring_state state = { .index = info->idx };
 	struct vhost_vring_file file = { .index = info->idx };
-	unsigned long long features = dev->vdev.features[0];
+	unsigned long long features = dev->vdev.features;
 	struct vhost_vring_addr addr = {
 		.index = info->idx,
 		.desc_user_addr = (uint64_t)(unsigned long)info->vring.desc,
@@ -113,8 +113,7 @@ static void vdev_info_init(struct vdev_info* dev, unsigned long long features)
 {
 	int r;
 	memset(dev, 0, sizeof *dev);
-	dev->vdev.features[0] = features;
-	dev->vdev.features[1] = features >> 32;
+	dev->vdev.features = features;
 	dev->buf_size = 1024;
 	dev->buf = malloc(dev->buf_size);
 	assert(dev->buf);
diff --git a/tools/virtio/vringh_test.c b/tools/virtio/vringh_test.c
index 14a4f4c..b6c9ee3 100644
--- a/tools/virtio/vringh_test.c
+++ b/tools/virtio/vringh_test.c
@@ -304,7 +304,7 @@ static int parallel_test(unsigned long features,
 		close(to_guest[1]);
 		close(to_host[0]);
 
-		gvdev.vdev.features[0] = features;
+		gvdev.vdev.features = features;
 		gvdev.to_host_fd = to_host[1];
 		gvdev.notifies = 0;
 
@@ -449,13 +449,13 @@ int main(int argc, char *argv[])
 	bool fast_vringh = false, parallel = false;
 
 	getrange = getrange_iov;
-	vdev.features[0] = 0;
+	vdev.features = 0;
 
 	while (argv[1]) {
 		if (strcmp(argv[1], "--indirect") == 0)
-			vdev.features[0] |= (1 << VIRTIO_RING_F_INDIRECT_DESC);
+			vdev.features |= (1 << VIRTIO_RING_F_INDIRECT_DESC);
 		else if (strcmp(argv[1], "--eventidx") == 0)
-			vdev.features[0] |= (1 << VIRTIO_RING_F_EVENT_IDX);
+			vdev.features |= (1 << VIRTIO_RING_F_EVENT_IDX);
 		else if (strcmp(argv[1], "--slow-range") == 0)
 			getrange = getrange_slow;
 		else if (strcmp(argv[1], "--fast-vringh") == 0)
@@ -468,7 +468,7 @@ int main(int argc, char *argv[])
 	}
 
 	if (parallel)
-		return parallel_test(vdev.features[0], getrange, fast_vringh);
+		return parallel_test(vdev.features, getrange, fast_vringh);
 
 	if (posix_memalign(&__user_addr_min, PAGE_SIZE, USER_MEM) != 0)
 		abort();
@@ -483,7 +483,7 @@ int main(int argc, char *argv[])
 
 	/* Set up host side. */
 	vring_init(&vrh.vring, RINGSIZE, __user_addr_min, ALIGN);
-	vringh_init_user(&vrh, vdev.features[0], RINGSIZE, true,
+	vringh_init_user(&vrh, vdev.features, RINGSIZE, true,
 			 vrh.vring.desc, vrh.vring.avail, vrh.vring.used);
 
 	/* No descriptor to get yet... */
@@ -652,13 +652,13 @@ int main(int argc, char *argv[])
 	}
 
 	/* Test weird (but legal!) indirect. */
-	if (vdev.features[0] & (1 << VIRTIO_RING_F_INDIRECT_DESC)) {
+	if (vdev.features & (1 << VIRTIO_RING_F_INDIRECT_DESC)) {
 		char *data = __user_addr_max - USER_MEM/4;
 		struct vring_desc *d = __user_addr_max - USER_MEM/2;
 		struct vring vring;
 
 		/* Force creation of direct, which we modify. */
-		vdev.features[0] &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
+		vdev.features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
 		vq = vring_new_virtqueue(0, RINGSIZE, ALIGN, &vdev, true,
 					 __user_addr_min,
 					 never_notify_host,
-- 
MST

