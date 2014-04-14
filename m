Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaDNUPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:15:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:51847 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbaDNUPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,859,1389772800"; 
   d="scan'208";a="520341992"
From: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH 5/8] misc: mic: add dma support in host driver
Date: Mon, 14 Apr 2014 13:15:02 -0700
Message-Id: <22a67a268234b0b66673caa83612c25af6007aad.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
In-Reply-To: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
References: <cover.1397504824.git.siva.krishna.kumar.reddy.yerramreddy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a dma device on the mic virtual bus and uses this dmaengine
to transfer data for virtio devices

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Siva Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
---
 drivers/misc/mic/Kconfig           |   2 +-
 drivers/misc/mic/host/mic_boot.c   |  78 +++++++++++++++-
 drivers/misc/mic/host/mic_device.h |  24 +++++
 drivers/misc/mic/host/mic_intr.h   |   3 +-
 drivers/misc/mic/host/mic_virtio.c | 179 +++++++++++++++++++++++++++++--------
 drivers/misc/mic/host/mic_virtio.h |  21 ++++-
 drivers/misc/mic/host/mic_x100.c   |   8 ++
 7 files changed, 274 insertions(+), 41 deletions(-)

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index cfe185f..9409fe5 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -19,7 +19,7 @@ comment "Intel MIC Host Driver"
 
 config INTEL_MIC_HOST
 	tristate "Intel MIC Host Driver"
-	depends on 64BIT && PCI && X86
+	depends on 64BIT && PCI && X86 && INTEL_MIC_BUS
 	select VHOST_RING
 	default N
 	help
diff --git a/drivers/misc/mic/host/mic_boot.c b/drivers/misc/mic/host/mic_boot.c
index b75c6b5..b462177 100644
--- a/drivers/misc/mic/host/mic_boot.c
+++ b/drivers/misc/mic/host/mic_boot.c
@@ -23,11 +23,66 @@
 #include <linux/pci.h>
 
 #include <linux/mic_common.h>
+#include <linux/mic_bus.h>
 #include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_smpt.h"
 #include "mic_virtio.h"
 
+static inline struct mic_device *mbdev_to_mdev(struct mbus_device *mbdev)
+{
+	return dev_get_drvdata(mbdev->dev.parent);
+}
+
+static dma_addr_t mic_dma_map_page(struct device *dev, struct page *page,
+	unsigned long offset, size_t size, enum dma_data_direction dir,
+	struct dma_attrs *attrs)
+{
+	void *va = phys_to_virt(page_to_phys(page)) + offset;
+	struct mic_device *mdev = mbdev_to_mdev(dev_get_drvdata(dev));
+
+	return mic_map_single(mdev, va, size);
+}
+
+static void mic_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
+	size_t size, enum dma_data_direction dir, struct dma_attrs *attrs)
+{
+	struct mic_device *mdev = mbdev_to_mdev(dev_get_drvdata(dev));
+	mic_unmap_single(mdev, dma_addr, size);
+}
+
+static struct dma_map_ops mic_dma_ops = {
+	.map_page = mic_dma_map_page,
+	.unmap_page = mic_dma_unmap_page,
+};
+
+static struct mic_irq *_mic_request_threaded_irq(struct mbus_device *mbdev,
+		irq_handler_t handler, irq_handler_t thread_fn,
+		const char *name, void *data, int intr_src)
+{
+	return mic_request_threaded_irq(mbdev_to_mdev(mbdev), handler,
+					thread_fn, name, data,
+					intr_src, MIC_INTR_DMA);
+}
+
+static void _mic_free_irq(struct mbus_device *mbdev,
+		struct mic_irq *cookie, void *data)
+{
+	return mic_free_irq(mbdev_to_mdev(mbdev), cookie, data);
+}
+
+static void _mic_ack_interrupt(struct mbus_device *mbdev, int num)
+{
+	struct mic_device *mdev = mbdev_to_mdev(mbdev);
+	mdev->ops->intr_workarounds(mdev);
+}
+
+static struct mbus_hw_ops mbus_hw_ops = {
+	.request_threaded_irq = _mic_request_threaded_irq,
+	.free_irq = _mic_free_irq,
+	.ack_interrupt = _mic_ack_interrupt,
+};
+
 /**
  * mic_reset - Reset the MIC device.
  * @mdev: pointer to mic_device instance
@@ -95,9 +150,20 @@ retry:
 		 */
 		goto retry;
 	}
-	rc = mdev->ops->load_mic_fw(mdev, buf);
+	rc = mbus_add_device(&mdev->dma_mbdev, mdev->sdev->parent,
+			     MBUS_DEV_DMA_HOST, &mic_dma_ops, &mbus_hw_ops,
+			     mdev->mmio.va);
 	if (rc)
 		goto unlock_ret;
+
+	mdev->dma_ch = mic_request_dma_chan(mdev);
+	if (!mdev->dma_ch) {
+		rc = -ENXIO;
+		goto dma_remove;
+	}
+	rc = mdev->ops->load_mic_fw(mdev, buf);
+	if (rc)
+		goto dma_release;
 	mic_smpt_restore(mdev);
 	mic_intr_restore(mdev);
 	mdev->intr_ops->enable_interrupts(mdev);
@@ -105,6 +171,11 @@ retry:
 	mdev->ops->write_spad(mdev, MIC_DPHI_SPAD, mdev->dp_dma_addr >> 32);
 	mdev->ops->send_firmware_intr(mdev);
 	mic_set_state(mdev, MIC_ONLINE);
+	goto unlock_ret;
+dma_release:
+	dma_release_channel(mdev->dma_ch);
+dma_remove:
+	mbus_remove_device(&mdev->dma_mbdev);
 unlock_ret:
 	mutex_unlock(&mdev->mic_mutex);
 	return rc;
@@ -122,6 +193,11 @@ void mic_stop(struct mic_device *mdev, bool force)
 	mutex_lock(&mdev->mic_mutex);
 	if (MIC_OFFLINE != mdev->state || force) {
 		mic_virtio_reset_devices(mdev);
+		if (mdev->dma_ch) {
+			dma_release_channel(mdev->dma_ch);
+			mdev->dma_ch = NULL;
+		}
+		mbus_remove_device(&mdev->dma_mbdev);
 		mic_bootparam_init(mdev);
 		mic_reset(mdev);
 		if (MIC_RESET_FAILED == mdev->state)
diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
index 0398c69..7583a80 100644
--- a/drivers/misc/mic/host/mic_device.h
+++ b/drivers/misc/mic/host/mic_device.h
@@ -25,6 +25,8 @@
 #include <linux/idr.h>
 #include <linux/notifier.h>
 #include <linux/irqreturn.h>
+#include <linux/dmaengine.h>
+#include <linux/mic_bus.h>
 
 #include "mic_intr.h"
 
@@ -87,6 +89,8 @@ enum mic_stepping {
  * @cdev: Character device for MIC.
  * @vdev_list: list of virtio devices.
  * @pm_notifier: Handles PM notifications from the OS.
+ * @dma_mbdev: MIC BUS DMA device.
+ * @dma_ch: DMA channel reserved by this driver for use by virtio devices.
  */
 struct mic_device {
 	struct mic_mw mmio;
@@ -124,6 +128,8 @@ struct mic_device {
 	struct cdev cdev;
 	struct list_head vdev_list;
 	struct notifier_block pm_notifier;
+	struct mbus_device dma_mbdev;
+	struct dma_chan *dma_ch;
 };
 
 /**
@@ -144,6 +150,7 @@ struct mic_device {
  * @load_mic_fw: Load firmware segments required to boot the card
  * into card memory. This includes the kernel, command line, ramdisk etc.
  * @get_postcode: Get post code status from firmware.
+ * @dma_filter: DMA filter function to be used.
  */
 struct mic_hw_ops {
 	u8 aper_bar;
@@ -159,6 +166,7 @@ struct mic_hw_ops {
 	void (*send_firmware_intr)(struct mic_device *mdev);
 	int (*load_mic_fw)(struct mic_device *mdev, const char *buf);
 	u32 (*get_postcode)(struct mic_device *mdev);
+	bool (*dma_filter)(struct dma_chan *chan, void *param);
 };
 
 /**
@@ -187,6 +195,22 @@ mic_mmio_write(struct mic_mw *mw, u32 val, u32 offset)
 	iowrite32(val, mw->va + offset);
 }
 
+static inline struct dma_chan *mic_request_dma_chan(struct mic_device *mdev)
+{
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+	chan = dma_request_channel(mask, mdev->ops->dma_filter,
+				   mdev->sdev->parent);
+	if (chan)
+		return chan;
+	dev_err(mdev->sdev->parent, "%s %d unable to acquire channel\n",
+		__func__, __LINE__);
+	return NULL;
+}
+
 void mic_sysfs_init(struct mic_device *mdev);
 int mic_start(struct mic_device *mdev, const char *buf);
 void mic_stop(struct mic_device *mdev, bool force);
diff --git a/drivers/misc/mic/host/mic_intr.h b/drivers/misc/mic/host/mic_intr.h
index 6b03f84..dd354ff 100644
--- a/drivers/misc/mic/host/mic_intr.h
+++ b/drivers/misc/mic/host/mic_intr.h
@@ -27,8 +27,9 @@
  * The minimum number of msix vectors required for normal operation.
  * 3 for virtio network, console and block devices.
  * 1 for card shutdown notifications.
+ * 4 for host owned DMA channels.
  */
-#define MIC_MIN_MSIX 4
+#define MIC_MIN_MSIX 8
 #define MIC_NUM_OFFSETS 32
 
 /**
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index aba3e83..aa8e4d6 100644
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -21,60 +21,155 @@
 #include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/uaccess.h>
-
+#include <linux/dmaengine.h>
 #include <linux/mic_common.h>
+
 #include "../common/mic_dev.h"
 #include "mic_device.h"
 #include "mic_smpt.h"
 #include "mic_virtio.h"
 
 /*
- * Initiates the copies across the PCIe bus from card memory to
- * a user space buffer.
+ * Size of the internal buffer used during DMA's as an intermediate buffer
+ * for copy to/from user.
  */
-static int mic_virtio_copy_to_user(struct mic_vdev *mvdev,
-		void __user *ubuf, size_t len, u64 addr)
+#define MIC_INT_DMA_BUF_SIZE PAGE_ALIGN(64 * 1024ULL)
+
+static int mic_sync_dma(struct mic_device *mdev, dma_addr_t dst,
+			dma_addr_t src, size_t len)
 {
-	int err;
-	void __iomem *dbuf = mvdev->mdev->aper.va + addr;
-	/*
-	 * We are copying from IO below an should ideally use something
-	 * like copy_to_user_fromio(..) if it existed.
-	 */
-	if (copy_to_user(ubuf, (void __force *)dbuf, len)) {
-		err = -EFAULT;
-		dev_err(mic_dev(mvdev), "%s %d err %d\n",
+	int err = 0;
+	struct dma_async_tx_descriptor *tx;
+	struct dma_chan *mic_ch = mdev->dma_ch;
+
+	if (!mic_ch) {
+		err = -EBUSY;
+		goto error;
+	}
+
+	tx = mic_ch->device->device_prep_dma_memcpy(mic_ch, dst, src, len,
+						    DMA_PREP_FENCE);
+	if (!tx) {
+		err = -ENOMEM;
+		goto error;
+	} else {
+		dma_cookie_t cookie = tx->tx_submit(tx);
+
+		err = dma_submit_error(cookie);
+		if (err)
+			goto error;
+		err = dma_sync_wait(mic_ch, cookie);
+	}
+error:
+	if (err)
+		dev_err(mdev->sdev->parent, "%s %d err %d\n",
 			__func__, __LINE__, err);
-		goto err;
+	return err;
+}
+
+/*
+ * Initiates the copies across the PCIe bus from card memory to a user
+ * space buffer. When transfers are done using DMA, source/destination
+ * addresses and transfer length must follow the alignment requirements of
+ * the MIC DMA engine.
+ */
+static int mic_virtio_copy_to_user(struct mic_vdev *mvdev, void __user *ubuf,
+				size_t len, u64 daddr, size_t dlen, int vr_idx)
+{
+	struct mic_device *mdev = mvdev->mdev;
+	void __iomem *dbuf = mdev->aper.va + daddr;
+	struct mic_vringh *mvr = &mvdev->mvr[vr_idx];
+	size_t dma_alignment = 1 << mdev->dma_ch->device->copy_align;
+	size_t dma_offset;
+	size_t partlen;
+	int err;
+
+	dma_offset = daddr - round_down(daddr, dma_alignment);
+	daddr -= dma_offset;
+	len += dma_offset;
+
+	while (len) {
+		partlen = min_t(size_t, len, MIC_INT_DMA_BUF_SIZE);
+
+		err = mic_sync_dma(mdev, mvr->buf_da, daddr,
+				   ALIGN(partlen, dma_alignment));
+		if (err)
+			goto err;
+
+		if (copy_to_user(ubuf, mvr->buf + dma_offset,
+				 partlen - dma_offset)) {
+			err = -EFAULT;
+			goto err;
+		}
+		daddr += partlen;
+		ubuf += partlen;
+		dbuf += partlen;
+		mvdev->in_bytes_dma += partlen;
+		mvdev->in_bytes += partlen;
+		len -= partlen;
+		dma_offset = 0;
 	}
-	mvdev->in_bytes += len;
-	err = 0;
+	return 0;
 err:
+	dev_err(mic_dev(mvdev), "%s %d err %d\n", __func__, __LINE__, err);
 	return err;
 }
 
 /*
- * Initiates copies across the PCIe bus from a user space
- * buffer to card memory.
+ * Initiates copies across the PCIe bus from a user space buffer to card
+ * memory. When transfers are done using DMA, source/destination addresses
+ * and transfer length must follow the alignment requirements of the MIC
+ * DMA engine.
  */
-static int mic_virtio_copy_from_user(struct mic_vdev *mvdev,
-		void __user *ubuf, size_t len, u64 addr)
+static int mic_virtio_copy_from_user(struct mic_vdev *mvdev, void __user *ubuf,
+				size_t len, u64 daddr, size_t dlen, int vr_idx)
 {
+	struct mic_device *mdev = mvdev->mdev;
+	void __iomem *dbuf = mdev->aper.va + daddr;
+	struct mic_vringh *mvr = &mvdev->mvr[vr_idx];
+	size_t dma_alignment = 1 << mdev->dma_ch->device->copy_align;
+	size_t partlen;
 	int err;
-	void __iomem *dbuf = mvdev->mdev->aper.va + addr;
+
+	if (daddr & (dma_alignment - 1)) {
+		mvdev->tx_dst_unaligned += len;
+		goto memcpy;
+	} else if (ALIGN(len, dma_alignment) > dlen) {
+		mvdev->tx_len_unaligned += len;
+		goto memcpy;
+	}
+
+	while (len) {
+		partlen = min_t(size_t, len, MIC_INT_DMA_BUF_SIZE);
+
+		if (copy_from_user(mvr->buf, ubuf, partlen)) {
+			err = -EFAULT;
+			goto err;
+		}
+		err = mic_sync_dma(mdev, daddr, mvr->buf_da,
+				   ALIGN(partlen, dma_alignment));
+		if (err)
+			goto err;
+		daddr += partlen;
+		ubuf += partlen;
+		dbuf += partlen;
+		mvdev->out_bytes_dma += partlen;
+		mvdev->out_bytes += partlen;
+		len -= partlen;
+	}
+memcpy:
 	/*
 	 * We are copying to IO below and should ideally use something
 	 * like copy_from_user_toio(..) if it existed.
 	 */
 	if (copy_from_user((void __force *)dbuf, ubuf, len)) {
 		err = -EFAULT;
-		dev_err(mic_dev(mvdev), "%s %d err %d\n",
-			__func__, __LINE__, err);
 		goto err;
 	}
 	mvdev->out_bytes += len;
-	err = 0;
+	return 0;
 err:
+	dev_err(mic_dev(mvdev), "%s %d err %d\n", __func__, __LINE__, err);
 	return err;
 }
 
@@ -110,7 +205,8 @@ static inline u32 mic_vringh_iov_consumed(struct vringh_kiov *iov)
  * way to override the VRINGH xfer(..) routines as of v3.10.
  */
 static int mic_vringh_copy(struct mic_vdev *mvdev, struct vringh_kiov *iov,
-	void __user *ubuf, size_t len, bool read, size_t *out_len)
+			void __user *ubuf, size_t len, bool read, int vr_idx,
+			size_t *out_len)
 {
 	int ret = 0;
 	size_t partlen, tot_len = 0;
@@ -118,13 +214,15 @@ static int mic_vringh_copy(struct mic_vdev *mvdev, struct vringh_kiov *iov,
 	while (len && iov->i < iov->used) {
 		partlen = min(iov->iov[iov->i].iov_len, len);
 		if (read)
-			ret = mic_virtio_copy_to_user(mvdev,
-				ubuf, partlen,
-				(u64)iov->iov[iov->i].iov_base);
+			ret = mic_virtio_copy_to_user(mvdev, ubuf, partlen,
+						(u64)iov->iov[iov->i].iov_base,
+						iov->iov[iov->i].iov_len,
+						vr_idx);
 		else
-			ret = mic_virtio_copy_from_user(mvdev,
-				ubuf, partlen,
-				(u64)iov->iov[iov->i].iov_base);
+			ret = mic_virtio_copy_from_user(mvdev, ubuf, partlen,
+						(u64)iov->iov[iov->i].iov_base,
+						iov->iov[iov->i].iov_len,
+						vr_idx);
 		if (ret) {
 			dev_err(mic_dev(mvdev), "%s %d err %d\n",
 				__func__, __LINE__, ret);
@@ -192,8 +290,8 @@ static int _mic_virtio_copy(struct mic_vdev *mvdev,
 			ubuf = iov.iov_base;
 		}
 		/* Issue all the read descriptors first */
-		ret = mic_vringh_copy(mvdev, riov, ubuf, len,
-			MIC_VRINGH_READ, &out_len);
+		ret = mic_vringh_copy(mvdev, riov, ubuf, len, MIC_VRINGH_READ,
+				      copy->vr_idx, &out_len);
 		if (ret) {
 			dev_err(mic_dev(mvdev), "%s %d err %d\n",
 				__func__, __LINE__, ret);
@@ -203,8 +301,8 @@ static int _mic_virtio_copy(struct mic_vdev *mvdev,
 		ubuf += out_len;
 		copy->out_len += out_len;
 		/* Issue the write descriptors next */
-		ret = mic_vringh_copy(mvdev, wiov, ubuf, len,
-			!MIC_VRINGH_READ, &out_len);
+		ret = mic_vringh_copy(mvdev, wiov, ubuf, len, !MIC_VRINGH_READ,
+				      copy->vr_idx, &out_len);
 		if (ret) {
 			dev_err(mic_dev(mvdev), "%s %d err %d\n",
 				__func__, __LINE__, ret);
@@ -589,6 +687,10 @@ int mic_virtio_add_device(struct mic_vdev *mvdev,
 		dev_dbg(mdev->sdev->parent,
 			"%s %d index %d va %p info %p vr_size 0x%x\n",
 			__func__, __LINE__, i, vr->va, vr->info, vr_size);
+		mvr->buf = (void *)__get_free_pages(GFP_KERNEL,
+					get_order(MIC_INT_DMA_BUF_SIZE));
+		mvr->buf_da = mic_map_single(mvdev->mdev, mvr->buf,
+					  MIC_INT_DMA_BUF_SIZE);
 	}
 
 	snprintf(irqname, sizeof(irqname), "mic%dvirtio%d", mdev->id,
@@ -673,6 +775,11 @@ skip_hot_remove:
 	vqconfig = mic_vq_config(mvdev->dd);
 	for (i = 0; i < mvdev->dd->num_vq; i++) {
 		struct mic_vringh *mvr = &mvdev->mvr[i];
+
+		mic_unmap_single(mvdev->mdev, mvr->buf_da,
+				 MIC_INT_DMA_BUF_SIZE);
+		free_pages((unsigned long)mvr->buf,
+			   get_order(MIC_INT_DMA_BUF_SIZE));
 		vringh_kiov_cleanup(&mvr->riov);
 		vringh_kiov_cleanup(&mvr->wiov);
 		mic_unmap_single(mdev, le64_to_cpu(vqconfig[i].address),
diff --git a/drivers/misc/mic/host/mic_virtio.h b/drivers/misc/mic/host/mic_virtio.h
index 184f3c8..d574efb 100644
--- a/drivers/misc/mic/host/mic_virtio.h
+++ b/drivers/misc/mic/host/mic_virtio.h
@@ -46,18 +46,23 @@
  * @vrh: The host VRINGH used for accessing the card vrings.
  * @riov: The VRINGH read kernel IOV.
  * @wiov: The VRINGH write kernel IOV.
- * @head: The VRINGH head index address passed to vringh_getdesc_kern(..).
  * @vr_mutex: Mutex for synchronizing access to the VRING.
+ * @buf: Temporary kernel buffer used to copy in/out data
+ * from/to the card via DMA.
+ * @buf_da: dma address of buf.
  * @mvdev: Back pointer to MIC virtio device for vringh_notify(..).
+ * @head: The VRINGH head index address passed to vringh_getdesc_kern(..).
  */
 struct mic_vringh {
 	struct mic_vring vring;
 	struct vringh vrh;
 	struct vringh_kiov riov;
 	struct vringh_kiov wiov;
-	u16 head;
 	struct mutex vr_mutex;
+	void *buf;
+	dma_addr_t buf_da;
 	struct mic_vdev *mvdev;
+	u16 head;
 };
 
 /**
@@ -69,6 +74,14 @@ struct mic_vringh {
  * @poll_wake - Used for waking up threads blocked in poll.
  * @out_bytes - Debug stats for number of bytes copied from host to card.
  * @in_bytes - Debug stats for number of bytes copied from card to host.
+ * @out_bytes_dma - Debug stats for number of bytes copied from host to card
+ * using DMA.
+ * @in_bytes_dma - Debug stats for number of bytes copied from card to host
+ * using DMA.
+ * @tx_len_unaligned - Debug stats for number of bytes copied to the card where
+ * the transfer length did not have the required DMA alignment.
+ * @tx_dst_unaligned - Debug stats for number of bytes copied where the
+ * destination address on the card did not have the required DMA alignment.
  * @mvr - Store per VRING data structures.
  * @virtio_bh_work - Work struct used to schedule virtio bottom half handling.
  * @dd - Virtio device descriptor.
@@ -84,6 +97,10 @@ struct mic_vdev {
 	int poll_wake;
 	unsigned long out_bytes;
 	unsigned long in_bytes;
+	unsigned long out_bytes_dma;
+	unsigned long in_bytes_dma;
+	unsigned long tx_len_unaligned;
+	unsigned long tx_dst_unaligned;
 	struct mic_vringh mvr[MIC_MAX_VRINGS];
 	struct work_struct virtio_bh_work;
 	struct mic_device_desc *dd;
diff --git a/drivers/misc/mic/host/mic_x100.c b/drivers/misc/mic/host/mic_x100.c
index 5562fdd..b7a21e1 100644
--- a/drivers/misc/mic/host/mic_x100.c
+++ b/drivers/misc/mic/host/mic_x100.c
@@ -549,6 +549,13 @@ struct mic_smpt_ops mic_x100_smpt_ops = {
 	.set = mic_x100_smpt_set,
 };
 
+static bool mic_x100_dma_filter(struct dma_chan *chan, void *param)
+{
+	if (chan->device->dev->parent == (struct device *)param)
+		return true;
+	return false;
+}
+
 struct mic_hw_ops mic_x100_ops = {
 	.aper_bar = MIC_X100_APER_BAR,
 	.mmio_bar = MIC_X100_MMIO_BAR,
@@ -563,6 +570,7 @@ struct mic_hw_ops mic_x100_ops = {
 	.send_firmware_intr = mic_x100_send_firmware_intr,
 	.load_mic_fw = mic_x100_load_firmware,
 	.get_postcode = mic_x100_get_postcode,
+	.dma_filter = mic_x100_dma_filter,
 };
 
 struct mic_hw_intr_ops mic_x100_intr_ops = {
-- 
1.8.2.2

