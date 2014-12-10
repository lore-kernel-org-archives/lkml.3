Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbaLJTyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:54:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:61026 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932918AbaLJTtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770563"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 11/13] misc: mic: MIC host driver specific changes to enable SCIF
Date: Wed, 10 Dec 2014 11:47:51 -0800
Message-Id: <53f0c80e2a0898136ec3357ed6e71a5c58526104.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIC host driver specific changes to enable SCIF. This patch implements
the SCIF hardware bus operations and registers a SCIF device on the
SCIF hardware bus.

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/Kconfig            |   2 +-
 drivers/misc/mic/host/mic_device.h  |  11 +-
 drivers/misc/mic/host/mic_intr.h    |   3 +-
 drivers/misc/mic/host/mic_smpt.h    |   1 +
 drivers/misc/mic/host/mic_boot.c    | 264 ++++++++++++++++++++++++++++++++++--
 drivers/misc/mic/host/mic_debugfs.c |  13 ++
 drivers/misc/mic/host/mic_main.c    |   6 +
 drivers/misc/mic/host/mic_smpt.c    |   7 +-
 drivers/misc/mic/host/mic_virtio.c  |   6 +-
 drivers/misc/mic/host/mic_x100.c    |   3 +-
 10 files changed, 292 insertions(+), 24 deletions(-)

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index bcf6e36..a2ea3ab 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -36,7 +36,7 @@ comment "Intel MIC Host Driver"
 
 config INTEL_MIC_HOST
 	tristate "Intel MIC Host Driver"
-	depends on 64BIT && PCI && X86 && INTEL_MIC_BUS
+	depends on 64BIT && PCI && X86 && INTEL_MIC_BUS && SCIF_BUS
 	select VHOST_RING
 	help
 	  This enables Host Driver support for the Intel Many Integrated
diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
index 016bd15..01a7555 100644
--- a/drivers/misc/mic/host/mic_device.h
+++ b/drivers/misc/mic/host/mic_device.h
@@ -27,7 +27,7 @@
 #include <linux/irqreturn.h>
 #include <linux/dmaengine.h>
 #include <linux/mic_bus.h>
-
+#include "../bus/scif_bus.h"
 #include "mic_intr.h"
 
 /* The maximum number of MIC devices supported in a single host system. */
@@ -90,7 +90,9 @@ enum mic_stepping {
  * @vdev_list: list of virtio devices.
  * @pm_notifier: Handles PM notifications from the OS.
  * @dma_mbdev: MIC BUS DMA device.
- * @dma_ch: DMA channel reserved by this driver for use by virtio devices.
+ * @dma_ch - Array of DMA channels
+ * @num_dma_ch - Number of DMA channels available
+ * @scdev: SCIF device on the SCIF virtual bus.
  */
 struct mic_device {
 	struct mic_mw mmio;
@@ -129,7 +131,9 @@ struct mic_device {
 	struct list_head vdev_list;
 	struct notifier_block pm_notifier;
 	struct mbus_device *dma_mbdev;
-	struct dma_chan *dma_ch;
+	struct dma_chan *dma_ch[MIC_MAX_DMA_CHAN];
+	int num_dma_ch;
+	struct scif_hw_dev *scdev;
 };
 
 /**
@@ -228,4 +232,5 @@ void mic_exit_debugfs(void);
 void mic_prepare_suspend(struct mic_device *mdev);
 void mic_complete_resume(struct mic_device *mdev);
 void mic_suspend(struct mic_device *mdev);
+extern atomic_t g_num_mics;
 #endif
diff --git a/drivers/misc/mic/host/mic_intr.h b/drivers/misc/mic/host/mic_intr.h
index 9f783d4a..cce2882 100644
--- a/drivers/misc/mic/host/mic_intr.h
+++ b/drivers/misc/mic/host/mic_intr.h
@@ -28,8 +28,9 @@
  * 3 for virtio network, console and block devices.
  * 1 for card shutdown notifications.
  * 4 for host owned DMA channels.
+ * 1 for SCIF
  */
-#define MIC_MIN_MSIX 8
+#define MIC_MIN_MSIX 9
 #define MIC_NUM_OFFSETS 32
 
 /**
diff --git a/drivers/misc/mic/host/mic_smpt.h b/drivers/misc/mic/host/mic_smpt.h
index 51970ab..68721c6 100644
--- a/drivers/misc/mic/host/mic_smpt.h
+++ b/drivers/misc/mic/host/mic_smpt.h
@@ -78,6 +78,7 @@ void mic_unmap_single(struct mic_device *mdev,
 dma_addr_t mic_map(struct mic_device *mdev,
 	dma_addr_t dma_addr, size_t size);
 void mic_unmap(struct mic_device *mdev, dma_addr_t mic_addr, size_t size);
+dma_addr_t mic_to_dma_addr(struct mic_device *mdev, dma_addr_t mic_addr);
 
 /**
  * mic_map_error - Check a MIC address for errors.
diff --git a/drivers/misc/mic/host/mic_boot.c b/drivers/misc/mic/host/mic_boot.c
index ff2b0fb..bb15506 100644
--- a/drivers/misc/mic/host/mic_boot.c
+++ b/drivers/misc/mic/host/mic_boot.c
@@ -21,6 +21,7 @@
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/pci.h>
+#include <linux/kmod.h>
 
 #include <linux/mic_common.h>
 #include <linux/mic_bus.h>
@@ -29,6 +30,188 @@
 #include "mic_smpt.h"
 #include "mic_virtio.h"
 
+static inline struct mic_device *scdev_to_mdev(struct scif_hw_dev *scdev)
+{
+	return dev_get_drvdata(scdev->dev.parent);
+}
+
+static void *__mic_dma_alloc(struct device *dev, size_t size,
+			     dma_addr_t *dma_handle, gfp_t gfp,
+			     struct dma_attrs *attrs)
+{
+	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+	dma_addr_t tmp;
+	void *va = kmalloc(size, gfp);
+
+	if (va) {
+		tmp = mic_map_single(mdev, va, size);
+		if (dma_mapping_error(dev, tmp)) {
+			kfree(va);
+			va = NULL;
+		} else {
+			*dma_handle = tmp;
+		}
+	}
+	return va;
+}
+
+static void __mic_dma_free(struct device *dev, size_t size, void *vaddr,
+			   dma_addr_t dma_handle, struct dma_attrs *attrs)
+{
+	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+
+	mic_unmap_single(mdev, dma_handle, size);
+	kfree(vaddr);
+}
+
+static dma_addr_t
+__mic_dma_map_page(struct device *dev, struct page *page, unsigned long offset,
+		   size_t size, enum dma_data_direction dir,
+		   struct dma_attrs *attrs)
+{
+	void *va = phys_to_virt(page_to_phys(page)) + offset;
+	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+
+	return mic_map_single(mdev, va, size);
+}
+
+static void
+__mic_dma_unmap_page(struct device *dev, dma_addr_t dma_addr,
+		     size_t size, enum dma_data_direction dir,
+		     struct dma_attrs *attrs)
+{
+	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+
+	mic_unmap_single(mdev, dma_addr, size);
+}
+
+static int __mic_dma_map_sg(struct device *dev, struct scatterlist *sg,
+			    int nents, enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
+{
+	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+	struct scatterlist *s;
+	int i, j, ret;
+	dma_addr_t da;
+
+	ret = dma_map_sg(mdev->sdev->parent, sg, nents, dir);
+	if (ret <= 0)
+		return 0;
+
+	for_each_sg(sg, s, nents, i) {
+		da = mic_map(mdev, sg_dma_address(s) + s->offset, s->length);
+		if (!da)
+			goto err;
+		sg_dma_address(s) = da;
+	}
+	return nents;
+err:
+	for_each_sg(sg, s, i, j) {
+		mic_unmap(mdev, sg_dma_address(s), s->length);
+		sg_dma_address(s) = mic_to_dma_addr(mdev, sg_dma_address(s));
+	}
+	dma_unmap_sg(mdev->sdev->parent, sg, nents, dir);
+	return 0;
+}
+
+static void __mic_dma_unmap_sg(struct device *dev,
+			       struct scatterlist *sg, int nents,
+			       enum dma_data_direction dir,
+			       struct dma_attrs *attrs)
+{
+	struct scif_hw_dev *scdev = dev_get_drvdata(dev);
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+	struct scatterlist *s;
+	dma_addr_t da;
+	int i;
+
+	for_each_sg(sg, s, nents, i) {
+		da = mic_to_dma_addr(mdev, sg_dma_address(s));
+		mic_unmap(mdev, sg_dma_address(s), s->length);
+		sg_dma_address(s) = da;
+	}
+	dma_unmap_sg(mdev->sdev->parent, sg, nents, dir);
+}
+
+static struct dma_map_ops __mic_dma_ops = {
+	.alloc = __mic_dma_alloc,
+	.free = __mic_dma_free,
+	.map_page = __mic_dma_map_page,
+	.unmap_page = __mic_dma_unmap_page,
+	.map_sg = __mic_dma_map_sg,
+	.unmap_sg = __mic_dma_unmap_sg,
+};
+
+static struct mic_irq *
+___mic_request_irq(struct scif_hw_dev *scdev,
+		   irqreturn_t (*func)(int irq, void *data),
+				       const char *name,
+				       void *data, int db)
+{
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+
+	return mic_request_threaded_irq(mdev, func, NULL, name, data,
+					db, MIC_INTR_DB);
+}
+
+static void
+___mic_free_irq(struct scif_hw_dev *scdev,
+		struct mic_irq *cookie, void *data)
+{
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+
+	return mic_free_irq(mdev, cookie, data);
+}
+
+static void ___mic_ack_interrupt(struct scif_hw_dev *scdev, int num)
+{
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+
+	mdev->ops->intr_workarounds(mdev);
+}
+
+static int ___mic_next_db(struct scif_hw_dev *scdev)
+{
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+
+	return mic_next_db(mdev);
+}
+
+static void ___mic_send_intr(struct scif_hw_dev *scdev, int db)
+{
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+
+	mdev->ops->send_intr(mdev, db);
+}
+
+static void __iomem *___mic_ioremap(struct scif_hw_dev *scdev,
+				    phys_addr_t pa, size_t len)
+{
+	struct mic_device *mdev = scdev_to_mdev(scdev);
+
+	return mdev->aper.va + pa;
+}
+
+static void ___mic_iounmap(struct scif_hw_dev *scdev, void __iomem *va)
+{
+	/* nothing to do */
+}
+
+static struct scif_hw_ops scif_hw_ops = {
+	.request_irq = ___mic_request_irq,
+	.free_irq = ___mic_free_irq,
+	.ack_interrupt = ___mic_ack_interrupt,
+	.next_db = ___mic_next_db,
+	.send_intr = ___mic_send_intr,
+	.ioremap = ___mic_ioremap,
+	.iounmap = ___mic_iounmap,
+};
+
 static inline struct mic_device *mbdev_to_mdev(struct mbus_device *mbdev)
 {
 	return dev_get_drvdata(mbdev->dev.parent);
@@ -127,6 +310,58 @@ void mic_bootparam_init(struct mic_device *mdev)
 	bootparam->h2c_config_db = -1;
 	bootparam->shutdown_status = 0;
 	bootparam->shutdown_card = 0;
+	/* Total nodes = number of MICs + 1 for self node */
+	bootparam->tot_nodes = atomic_read(&g_num_mics) + 1;
+	bootparam->node_id = mdev->id + 1;
+	bootparam->scif_host_dma_addr = 0x0;
+	bootparam->scif_card_dma_addr = 0x0;
+	bootparam->c2h_scif_db = -1;
+	bootparam->h2c_scif_db = -1;
+}
+
+/**
+ * mic_request_dma_chans - Request DMA channels
+ * @mdev: pointer to mic_device instance
+ *
+ * returns number of DMA channels acquired
+ */
+static int mic_request_dma_chans(struct mic_device *mdev)
+{
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+
+	request_module("mic_x100_dma");
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+
+	do {
+		chan = dma_request_channel(mask, mdev->ops->dma_filter,
+					   mdev->sdev->parent);
+		if (chan) {
+			mdev->dma_ch[mdev->num_dma_ch++] = chan;
+			if (mdev->num_dma_ch >= MIC_MAX_DMA_CHAN)
+				break;
+		}
+	} while (chan);
+	dev_info(mdev->sdev->parent, "DMA channels # %d\n", mdev->num_dma_ch);
+	return mdev->num_dma_ch;
+}
+
+/**
+ * mic_free_dma_chans - release DMA channels
+ * @mdev: pointer to mic_device instance
+ *
+ * returns none
+ */
+static void mic_free_dma_chans(struct mic_device *mdev)
+{
+	int i = 0;
+
+	for (i = 0; i < mdev->num_dma_ch; i++) {
+		dma_release_channel(mdev->dma_ch[i]);
+		mdev->dma_ch[i] = NULL;
+	}
+	mdev->num_dma_ch = 0;
 }
 
 /**
@@ -141,6 +376,7 @@ int mic_start(struct mic_device *mdev, const char *buf)
 {
 	int rc;
 	mutex_lock(&mdev->mic_mutex);
+	mic_bootparam_init(mdev);
 retry:
 	if (MIC_OFFLINE != mdev->state) {
 		rc = -EINVAL;
@@ -161,14 +397,22 @@ retry:
 		rc = PTR_ERR(mdev->dma_mbdev);
 		goto unlock_ret;
 	}
-	mdev->dma_ch = mic_request_dma_chan(mdev);
-	if (!mdev->dma_ch) {
-		rc = -ENXIO;
+	if (!mic_request_dma_chans(mdev)) {
+		rc = -ENODEV;
 		goto dma_remove;
 	}
+	mdev->scdev = scif_register_device(mdev->sdev->parent, MIC_SCIF_DEV,
+					   &__mic_dma_ops, &scif_hw_ops,
+					   mdev->id + 1, 0, &mdev->mmio,
+					   &mdev->aper, mdev->dp, NULL,
+					   mdev->dma_ch, mdev->num_dma_ch);
+	if (IS_ERR(mdev->scdev)) {
+		rc = PTR_ERR(mdev->scdev);
+		goto dma_free;
+	}
 	rc = mdev->ops->load_mic_fw(mdev, buf);
 	if (rc)
-		goto dma_release;
+		goto scif_remove;
 	mic_smpt_restore(mdev);
 	mic_intr_restore(mdev);
 	mdev->intr_ops->enable_interrupts(mdev);
@@ -177,8 +421,10 @@ retry:
 	mdev->ops->send_firmware_intr(mdev);
 	mic_set_state(mdev, MIC_ONLINE);
 	goto unlock_ret;
-dma_release:
-	dma_release_channel(mdev->dma_ch);
+scif_remove:
+	scif_unregister_device(mdev->scdev);
+dma_free:
+	mic_free_dma_chans(mdev);
 dma_remove:
 	mbus_unregister_device(mdev->dma_mbdev);
 unlock_ret:
@@ -197,11 +443,9 @@ void mic_stop(struct mic_device *mdev, bool force)
 {
 	mutex_lock(&mdev->mic_mutex);
 	if (MIC_OFFLINE != mdev->state || force) {
+		scif_unregister_device(mdev->scdev);
 		mic_virtio_reset_devices(mdev);
-		if (mdev->dma_ch) {
-			dma_release_channel(mdev->dma_ch);
-			mdev->dma_ch = NULL;
-		}
+		mic_free_dma_chans(mdev);
 		mbus_unregister_device(mdev->dma_mbdev);
 		mic_bootparam_init(mdev);
 		mic_reset(mdev);
diff --git a/drivers/misc/mic/host/mic_debugfs.c b/drivers/misc/mic/host/mic_debugfs.c
index 028ba5d6..f024d29 100644
--- a/drivers/misc/mic/host/mic_debugfs.c
+++ b/drivers/misc/mic/host/mic_debugfs.c
@@ -214,6 +214,19 @@ static int mic_dp_show(struct seq_file *s, void *pos)
 		   bootparam->shutdown_status);
 	seq_printf(s, "Bootparam: shutdown_card %d\n",
 		   bootparam->shutdown_card);
+	seq_printf(s, "Bootparam: tot_nodes %d\n",
+		   bootparam->tot_nodes);
+	seq_printf(s, "Bootparam: node_id %d\n",
+		   bootparam->node_id);
+	seq_printf(s, "Bootparam: c2h_scif_db %d\n",
+		   bootparam->c2h_scif_db);
+	seq_printf(s, "Bootparam: h2c_scif_db %d\n",
+		   bootparam->h2c_scif_db);
+	seq_printf(s, "Bootparam: scif_host_dma_addr 0x%llx\n",
+		   bootparam->scif_host_dma_addr);
+	seq_printf(s, "Bootparam: scif_card_dma_addr 0x%llx\n",
+		   bootparam->scif_card_dma_addr);
+
 
 	for (i = sizeof(*bootparam); i < MIC_DP_SIZE;
 	     i += mic_total_desc_size(d)) {
diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_main.c
index ab37a31..4564629 100644
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -67,6 +67,8 @@ static struct ida g_mic_ida;
 static struct class *g_mic_class;
 /* Base device node number for MIC devices */
 static dev_t g_mic_devno;
+/* Track the total number of MIC devices */
+atomic_t g_num_mics;
 
 static const struct file_operations mic_fops = {
 	.open = mic_open,
@@ -408,6 +410,7 @@ static int mic_probe(struct pci_dev *pdev,
 		dev_err(&pdev->dev, "cdev_add err id %d rc %d\n", mdev->id, rc);
 		goto cleanup_debug_dir;
 	}
+	atomic_inc(&g_num_mics);
 	return 0;
 cleanup_debug_dir:
 	mic_delete_debug_dir(mdev);
@@ -459,6 +462,7 @@ static void mic_remove(struct pci_dev *pdev)
 		return;
 
 	mic_stop(mdev, false);
+	atomic_dec(&g_num_mics);
 	cdev_del(&mdev->cdev);
 	mic_delete_debug_dir(mdev);
 	mutex_lock(&mdev->mic_mutex);
@@ -478,6 +482,7 @@ static void mic_remove(struct pci_dev *pdev)
 	ida_simple_remove(&g_mic_ida, mdev->id);
 	kfree(mdev);
 }
+
 static struct pci_driver mic_driver = {
 	.name = mic_driver_name,
 	.id_table = mic_pci_tbl,
@@ -512,6 +517,7 @@ static int __init mic_init(void)
 	}
 	return ret;
 cleanup_debugfs:
+	ida_destroy(&g_mic_ida);
 	mic_exit_debugfs();
 	class_destroy(g_mic_class);
 cleanup_chrdev:
diff --git a/drivers/misc/mic/host/mic_smpt.c b/drivers/misc/mic/host/mic_smpt.c
index fae474c..cec8203 100644
--- a/drivers/misc/mic/host/mic_smpt.c
+++ b/drivers/misc/mic/host/mic_smpt.c
@@ -174,8 +174,7 @@ static int mic_get_smpt_ref_count(struct mic_device *mdev, dma_addr_t dma_addr,
  *
  * returns a DMA address.
  */
-static dma_addr_t
-mic_to_dma_addr(struct mic_device *mdev, dma_addr_t mic_addr)
+dma_addr_t mic_to_dma_addr(struct mic_device *mdev, dma_addr_t mic_addr)
 {
 	struct mic_smpt_info *smpt_info = mdev->smpt;
 	int spt;
@@ -214,7 +213,7 @@ dma_addr_t mic_map(struct mic_device *mdev, dma_addr_t dma_addr, size_t size)
 	if (!size || size > mic_max_system_memory(mdev))
 		return mic_addr;
 
-	ref = kmalloc(mdev->smpt->info.num_reg * sizeof(s64), GFP_KERNEL);
+	ref = kmalloc_array(mdev->smpt->info.num_reg, sizeof(s64), GFP_ATOMIC);
 	if (!ref)
 		return mic_addr;
 
@@ -271,7 +270,7 @@ void mic_unmap(struct mic_device *mdev, dma_addr_t mic_addr, size_t size)
 	}
 
 	spt = mic_sys_addr_to_smpt(mdev, mic_addr);
-	ref = kmalloc(mdev->smpt->info.num_reg * sizeof(s64), GFP_KERNEL);
+	ref = kmalloc_array(mdev->smpt->info.num_reg, sizeof(s64), GFP_ATOMIC);
 	if (!ref)
 		return;
 
diff --git a/drivers/misc/mic/host/mic_virtio.c b/drivers/misc/mic/host/mic_virtio.c
index a020e4e..cc08e9f 100644
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -40,7 +40,7 @@ static int mic_sync_dma(struct mic_device *mdev, dma_addr_t dst,
 {
 	int err = 0;
 	struct dma_async_tx_descriptor *tx;
-	struct dma_chan *mic_ch = mdev->dma_ch;
+	struct dma_chan *mic_ch = mdev->dma_ch[0];
 
 	if (!mic_ch) {
 		err = -EBUSY;
@@ -80,7 +80,7 @@ static int mic_virtio_copy_to_user(struct mic_vdev *mvdev, void __user *ubuf,
 	struct mic_device *mdev = mvdev->mdev;
 	void __iomem *dbuf = mdev->aper.va + daddr;
 	struct mic_vringh *mvr = &mvdev->mvr[vr_idx];
-	size_t dma_alignment = 1 << mdev->dma_ch->device->copy_align;
+	size_t dma_alignment = 1 << mdev->dma_ch[0]->device->copy_align;
 	size_t dma_offset;
 	size_t partlen;
 	int err;
@@ -129,7 +129,7 @@ static int mic_virtio_copy_from_user(struct mic_vdev *mvdev, void __user *ubuf,
 	struct mic_device *mdev = mvdev->mdev;
 	void __iomem *dbuf = mdev->aper.va + daddr;
 	struct mic_vringh *mvr = &mvdev->mvr[vr_idx];
-	size_t dma_alignment = 1 << mdev->dma_ch->device->copy_align;
+	size_t dma_alignment = 1 << mdev->dma_ch[0]->device->copy_align;
 	size_t partlen;
 	int err;
 
diff --git a/drivers/misc/mic/host/mic_x100.c b/drivers/misc/mic/host/mic_x100.c
index b7a21e1..3341e90 100644
--- a/drivers/misc/mic/host/mic_x100.c
+++ b/drivers/misc/mic/host/mic_x100.c
@@ -167,8 +167,7 @@ static void mic_x100_send_intr(struct mic_device *mdev, int doorbell)
 	if (doorbell < MIC_X100_NUM_SBOX_IRQ) {
 		mic_x100_send_sbox_intr(mdev, doorbell);
 	} else {
-		rdmasr_db = doorbell - MIC_X100_NUM_SBOX_IRQ +
-			MIC_X100_RDMASR_IRQ_BASE;
+		rdmasr_db = doorbell - MIC_X100_NUM_SBOX_IRQ;
 		mic_x100_send_rdmasr_intr(mdev, rdmasr_db);
 	}
 }
-- 
1.8.2.1

