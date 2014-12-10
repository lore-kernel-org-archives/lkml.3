Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbaLJTtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:49:21 -0500
Received: from mga02.intel.com ([134.134.136.20]:33536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982AbaLJTtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770565"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 12/13] misc: mic: MIC card driver specific changes to enable SCIF
Date: Wed, 10 Dec 2014 11:47:52 -0800
Message-Id: <fcea09f02a8bb0db8bc217dd930b75d14690b862.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIC card driver specific changes to enable SCIF. This patch implements
the SCIF hardware bus operations and registers a SCIF device on the
SCIF hardware bus.

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/Kconfig           |   2 +-
 drivers/misc/mic/card/mic_device.h |  11 +++-
 drivers/misc/mic/card/mic_x100.h   |   1 +
 drivers/misc/mic/card/mic_device.c | 132 ++++++++++++++++++++++++++++++++++++-
 drivers/misc/mic/card/mic_x100.c   |  61 ++++++++++++++++-
 5 files changed, 201 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index a2ea3ab..e9f2f56 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -56,7 +56,7 @@ comment "Intel MIC Card Driver"
 
 config INTEL_MIC_CARD
 	tristate "Intel MIC Card Driver"
-	depends on 64BIT && X86 && INTEL_MIC_BUS
+	depends on 64BIT && X86 && INTEL_MIC_BUS && SCIF_BUS
 	select VIRTIO
 	help
 	  This enables card driver support for the Intel Many Integrated
diff --git a/drivers/misc/mic/card/mic_device.h b/drivers/misc/mic/card/mic_device.h
index 844be8f..1dbf83c 100644
--- a/drivers/misc/mic/card/mic_device.h
+++ b/drivers/misc/mic/card/mic_device.h
@@ -29,9 +29,9 @@
 
 #include <linux/workqueue.h>
 #include <linux/io.h>
-#include <linux/irqreturn.h>
 #include <linux/interrupt.h>
 #include <linux/mic_bus.h>
+#include "../bus/scif_bus.h"
 
 /**
  * struct mic_intr_info - Contains h/w specific interrupt sources info
@@ -73,6 +73,9 @@ struct mic_device {
  * @irq_info: The OS specific irq information
  * @intr_info: H/W specific interrupt information.
  * @dma_mbdev: dma device on the MIC virtual bus.
+ * @dma_ch - Array of DMA channels
+ * @num_dma_ch - Number of DMA channels available
+ * @scdev: SCIF device on the SCIF virtual bus.
  */
 struct mic_driver {
 	char name[20];
@@ -84,6 +87,9 @@ struct mic_driver {
 	struct mic_irq_info irq_info;
 	struct mic_intr_info intr_info;
 	struct mbus_device *dma_mbdev;
+	struct dma_chan *dma_ch[MIC_MAX_DMA_CHAN];
+	int num_dma_ch;
+	struct scif_hw_dev *scdev;
 };
 
 /**
@@ -122,10 +128,11 @@ void mic_driver_uninit(struct mic_driver *mdrv);
 int mic_next_card_db(void);
 struct mic_irq *
 mic_request_card_irq(irq_handler_t handler, irq_handler_t thread_fn,
-		     const char *name, void *data, int intr_src);
+		     const char *name, void *data, int db);
 void mic_free_card_irq(struct mic_irq *cookie, void *data);
 u32 mic_read_spad(struct mic_device *mdev, unsigned int idx);
 void mic_send_intr(struct mic_device *mdev, int doorbell);
+void mic_send_p2p_intr(int doorbell, struct mic_mw *mw);
 int mic_db_to_irq(struct mic_driver *mdrv, int db);
 u32 mic_ack_interrupt(struct mic_device *mdev);
 void mic_hw_intr_init(struct mic_driver *mdrv);
diff --git a/drivers/misc/mic/card/mic_x100.h b/drivers/misc/mic/card/mic_x100.h
index d66ea55..7e22249 100644
--- a/drivers/misc/mic/card/mic_x100.h
+++ b/drivers/misc/mic/card/mic_x100.h
@@ -35,6 +35,7 @@
 #define MIC_X100_SBOX_SDBIC0 0x0000CC90
 #define MIC_X100_SBOX_SDBIC0_DBREQ_BIT 0x80000000
 #define MIC_X100_SBOX_RDMASR0	0x0000B180
+#define MIC_X100_SBOX_APICICR0 0x0000A9D0
 
 #define MIC_X100_MAX_DOORBELL_IDX 8
 
diff --git a/drivers/misc/mic/card/mic_device.c b/drivers/misc/mic/card/mic_device.c
index 83819ee..6338908 100644
--- a/drivers/misc/mic/card/mic_device.c
+++ b/drivers/misc/mic/card/mic_device.c
@@ -28,6 +28,8 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>
+#include <linux/dmaengine.h>
+#include <linux/kmod.h>
 
 #include <linux/mic_common.h>
 #include "../common/mic_dev.h"
@@ -240,6 +242,111 @@ static void mic_uninit_irq(void)
 	kfree(mdrv->irq_info.irq_usage_count);
 }
 
+static inline struct mic_driver *scdev_to_mdrv(struct scif_hw_dev *scdev)
+{
+	return dev_get_drvdata(scdev->dev.parent);
+}
+
+static struct mic_irq *
+___mic_request_irq(struct scif_hw_dev *scdev,
+		   irqreturn_t (*func)(int irq, void *data),
+				       const char *name, void *data,
+				       int db)
+{
+	return mic_request_card_irq(func, NULL, name, data, db);
+}
+
+static void
+___mic_free_irq(struct scif_hw_dev *scdev,
+		struct mic_irq *cookie, void *data)
+{
+	return mic_free_card_irq(cookie, data);
+}
+
+static void ___mic_ack_interrupt(struct scif_hw_dev *scdev, int num)
+{
+	struct mic_driver *mdrv = scdev_to_mdrv(scdev);
+
+	mic_ack_interrupt(&mdrv->mdev);
+}
+
+static int ___mic_next_db(struct scif_hw_dev *scdev)
+{
+	return mic_next_card_db();
+}
+
+static void ___mic_send_intr(struct scif_hw_dev *scdev, int db)
+{
+	struct mic_driver *mdrv = scdev_to_mdrv(scdev);
+
+	mic_send_intr(&mdrv->mdev, db);
+}
+
+static void ___mic_send_p2p_intr(struct scif_hw_dev *scdev, int db,
+				 struct mic_mw *mw)
+{
+	mic_send_p2p_intr(db, mw);
+}
+
+static void __iomem *
+___mic_ioremap(struct scif_hw_dev *scdev,
+	       phys_addr_t pa, size_t len)
+{
+	struct mic_driver *mdrv = scdev_to_mdrv(scdev);
+
+	return mic_card_map(&mdrv->mdev, pa, len);
+}
+
+static void ___mic_iounmap(struct scif_hw_dev *scdev, void __iomem *va)
+{
+	struct mic_driver *mdrv = scdev_to_mdrv(scdev);
+
+	mic_card_unmap(&mdrv->mdev, va);
+}
+
+static struct scif_hw_ops scif_hw_ops = {
+	.request_irq = ___mic_request_irq,
+	.free_irq = ___mic_free_irq,
+	.ack_interrupt = ___mic_ack_interrupt,
+	.next_db = ___mic_next_db,
+	.send_intr = ___mic_send_intr,
+	.send_p2p_intr = ___mic_send_p2p_intr,
+	.ioremap = ___mic_ioremap,
+	.iounmap = ___mic_iounmap,
+};
+
+static int mic_request_dma_chans(struct mic_driver *mdrv)
+{
+	dma_cap_mask_t mask;
+	struct dma_chan *chan;
+
+	request_module("mic_x100_dma");
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+
+	do {
+		chan = dma_request_channel(mask, NULL, NULL);
+		if (chan) {
+			mdrv->dma_ch[mdrv->num_dma_ch++] = chan;
+			if (mdrv->num_dma_ch >= MIC_MAX_DMA_CHAN)
+				break;
+		}
+	} while (chan);
+	dev_info(mdrv->dev, "DMA channels # %d\n", mdrv->num_dma_ch);
+	return mdrv->num_dma_ch;
+}
+
+static void mic_free_dma_chans(struct mic_driver *mdrv)
+{
+	int i = 0;
+
+	for (i = 0; i < mdrv->num_dma_ch; i++) {
+		dma_release_channel(mdrv->dma_ch[i]);
+		mdrv->dma_ch[i] = NULL;
+	}
+	mdrv->num_dma_ch = 0;
+}
+
 /*
  * mic_driver_init - MIC driver initialization tasks.
  *
@@ -248,6 +355,8 @@ static void mic_uninit_irq(void)
 int __init mic_driver_init(struct mic_driver *mdrv)
 {
 	int rc;
+	struct mic_bootparam __iomem *bootparam;
+	u8 node_id;
 
 	g_drv = mdrv;
 	/*
@@ -268,13 +377,32 @@ int __init mic_driver_init(struct mic_driver *mdrv)
 	rc = mic_shutdown_init();
 	if (rc)
 		goto irq_uninit;
+	if (!mic_request_dma_chans(mdrv)) {
+		rc = -ENODEV;
+		goto shutdown_uninit;
+	}
 	rc = mic_devices_init(mdrv);
 	if (rc)
-		goto shutdown_uninit;
+		goto dma_free;
+	bootparam = mdrv->dp;
+	node_id = ioread8(&bootparam->node_id);
+	mdrv->scdev = scif_register_device(mdrv->dev, MIC_SCIF_DEV,
+					   NULL, &scif_hw_ops,
+					   0, node_id, &mdrv->mdev.mmio, NULL,
+					   NULL, mdrv->dp, mdrv->dma_ch,
+					   mdrv->num_dma_ch);
+	if (IS_ERR(mdrv->scdev)) {
+		rc = PTR_ERR(mdrv->scdev);
+		goto device_uninit;
+	}
 	mic_create_card_debug_dir(mdrv);
 	atomic_notifier_chain_register(&panic_notifier_list, &mic_panic);
 done:
 	return rc;
+device_uninit:
+	mic_devices_uninit(mdrv);
+dma_free:
+	mic_free_dma_chans(mdrv);
 shutdown_uninit:
 	mic_shutdown_uninit();
 irq_uninit:
@@ -294,7 +422,9 @@ put:
 void mic_driver_uninit(struct mic_driver *mdrv)
 {
 	mic_delete_card_debug_dir(mdrv);
+	scif_unregister_device(mdrv->scdev);
 	mic_devices_uninit(mdrv);
+	mic_free_dma_chans(mdrv);
 	/*
 	 * Inform the host about the shutdown status i.e. poweroff/restart etc.
 	 * The module cannot be unloaded so the only code path to call
diff --git a/drivers/misc/mic/card/mic_x100.c b/drivers/misc/mic/card/mic_x100.c
index 9d57545..5ae1078 100644
--- a/drivers/misc/mic/card/mic_x100.c
+++ b/drivers/misc/mic/card/mic_x100.c
@@ -70,6 +70,41 @@ void mic_send_intr(struct mic_device *mdev, int doorbell)
 		       (MIC_X100_SBOX_SDBIC0 + (4 * doorbell)));
 }
 
+/*
+ * mic_x100_send_sbox_intr - Send an MIC_X100_SBOX interrupt to MIC.
+ */
+static void mic_x100_send_sbox_intr(struct mic_mw *mw, int doorbell)
+{
+	u64 apic_icr_offset = MIC_X100_SBOX_APICICR0 + doorbell * 8;
+	u32 apicicr_low = mic_mmio_read(mw, MIC_X100_SBOX_BASE_ADDRESS +
+					apic_icr_offset);
+
+	/* for MIC we need to make sure we "hit" the send_icr bit (13) */
+	apicicr_low = (apicicr_low | (1 << 13));
+	/*
+	 * Ensure that the interrupt is ordered w.r.t. previous stores
+	 * to main memory. Fence instructions are not implemented in X100
+	 * since execution is in order but a compiler barrier is still
+	 * required.
+	 */
+	wmb();
+	mic_mmio_write(mw, apicicr_low,
+		       MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
+}
+
+static void mic_x100_send_rdmasr_intr(struct mic_mw *mw, int doorbell)
+{
+	int rdmasr_offset = MIC_X100_SBOX_RDMASR0 + (doorbell << 2);
+	/*
+	 * Ensure that the interrupt is ordered w.r.t. previous stores
+	 * to main memory. Fence instructions are not implemented in X100
+	 * since execution is in order but a compiler barrier is still
+	 * required.
+	 */
+	wmb();
+	mic_mmio_write(mw, 0, MIC_X100_SBOX_BASE_ADDRESS + rdmasr_offset);
+}
+
 /**
  * mic_ack_interrupt - Device specific interrupt handling.
  * @mdev: pointer to mic_device instance
@@ -91,6 +126,18 @@ static inline int mic_get_rdmasr_irq(int index)
 	return  MIC_X100_RDMASR_IRQ_BASE + index;
 }
 
+void mic_send_p2p_intr(int db, struct mic_mw *mw)
+{
+	int rdmasr_index;
+
+	if (db < MIC_X100_NUM_SBOX_IRQ) {
+		mic_x100_send_sbox_intr(mw, db);
+	} else {
+		rdmasr_index = db - MIC_X100_NUM_SBOX_IRQ;
+		mic_x100_send_rdmasr_intr(mw, rdmasr_index);
+	}
+}
+
 /**
  * mic_hw_intr_init - Initialize h/w specific interrupt
  * information.
@@ -113,11 +160,15 @@ void mic_hw_intr_init(struct mic_driver *mdrv)
 int mic_db_to_irq(struct mic_driver *mdrv, int db)
 {
 	int rdmasr_index;
+
+	/*
+	 * The total number of doorbell interrupts on the card are 16. Indices
+	 * 0-8 falls in the SBOX category and 8-15 fall in the RDMASR category.
+	 */
 	if (db < MIC_X100_NUM_SBOX_IRQ) {
 		return mic_get_sbox_irq(db);
 	} else {
-		rdmasr_index = db - MIC_X100_NUM_SBOX_IRQ +
-			MIC_X100_RDMASR_IRQ_BASE;
+		rdmasr_index = db - MIC_X100_NUM_SBOX_IRQ;
 		return mic_get_rdmasr_irq(rdmasr_index);
 	}
 }
@@ -243,10 +294,16 @@ static void mic_platform_shutdown(struct platform_device *pdev)
 	mic_remove(pdev);
 }
 
+static u64 mic_dma_mask = DMA_BIT_MASK(64);
+
 static struct platform_device mic_platform_dev = {
 	.name = mic_driver_name,
 	.id   = 0,
 	.num_resources = 0,
+	.dev = {
+		.dma_mask = &mic_dma_mask,
+		.coherent_dma_mask = DMA_BIT_MASK(64),
+	},
 };
 
 static struct platform_driver __refdata mic_platform_driver = {
-- 
1.8.2.1

