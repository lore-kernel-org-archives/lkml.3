Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbaE2VZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 17:25:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:18831 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbaE2VYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 17:24:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,936,1392192000"; 
   d="scan'208";a="519900291"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Siva Yerramreddy <yshivakrishna@gmail.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Nikhil Rao <nikhil.rao@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [PATCH char-misc-next v2 7/8] misc: mic: add dma support in card driver
Date: Thu, 29 May 2014 14:24:04 -0700
Message-Id: <1fa90e028af4b72fe86844338b758c54a3bed57d.1401397315.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1401397315.git.sudeep.dutt@intel.com>
References: <cover.1401397315.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1401397315.git.sudeep.dutt@intel.com>
References: <cover.1401397315.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Siva Yerramreddy <yshivakrishna@gmail.com>

This patch adds a dma device on the mic virtual bus

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Siva Yerramreddy <yshivakrishna@gmail.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
---
 drivers/misc/mic/Kconfig           |  2 +-
 drivers/misc/mic/card/mic_device.h |  8 ++++--
 drivers/misc/mic/card/mic_x100.c   | 55 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index bf76313..cc4eef0 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -39,7 +39,7 @@ comment "Intel MIC Card Driver"
 
 config INTEL_MIC_CARD
 	tristate "Intel MIC Card Driver"
-	depends on 64BIT && X86
+	depends on 64BIT && X86 && INTEL_MIC_BUS
 	select VIRTIO
 	help
 	  This enables card driver support for the Intel Many Integrated
diff --git a/drivers/misc/mic/card/mic_device.h b/drivers/misc/mic/card/mic_device.h
index e12a0c2..844be8f 100644
--- a/drivers/misc/mic/card/mic_device.h
+++ b/drivers/misc/mic/card/mic_device.h
@@ -31,6 +31,7 @@
 #include <linux/io.h>
 #include <linux/irqreturn.h>
 #include <linux/interrupt.h>
+#include <linux/mic_bus.h>
 
 /**
  * struct mic_intr_info - Contains h/w specific interrupt sources info
@@ -71,6 +72,7 @@ struct mic_device {
  * @hotplug_work: Hot plug work for adding/removing virtio devices.
  * @irq_info: The OS specific irq information
  * @intr_info: H/W specific interrupt information.
+ * @dma_mbdev: dma device on the MIC virtual bus.
  */
 struct mic_driver {
 	char name[20];
@@ -81,6 +83,7 @@ struct mic_driver {
 	struct work_struct hotplug_work;
 	struct mic_irq_info irq_info;
 	struct mic_intr_info intr_info;
+	struct mbus_device *dma_mbdev;
 };
 
 /**
@@ -117,8 +120,9 @@ mic_mmio_write(struct mic_mw *mw, u32 val, u32 offset)
 int mic_driver_init(struct mic_driver *mdrv);
 void mic_driver_uninit(struct mic_driver *mdrv);
 int mic_next_card_db(void);
-struct mic_irq *mic_request_card_irq(irq_handler_t handler,
-	irq_handler_t thread_fn, const char *name, void *data, int intr_src);
+struct mic_irq *
+mic_request_card_irq(irq_handler_t handler, irq_handler_t thread_fn,
+		     const char *name, void *data, int intr_src);
 void mic_free_card_irq(struct mic_irq *cookie, void *data);
 u32 mic_read_spad(struct mic_device *mdev, unsigned int idx);
 void mic_send_intr(struct mic_device *mdev, int doorbell);
diff --git a/drivers/misc/mic/card/mic_x100.c b/drivers/misc/mic/card/mic_x100.c
index 2868945..55c9465 100644
--- a/drivers/misc/mic/card/mic_x100.c
+++ b/drivers/misc/mic/card/mic_x100.c
@@ -148,6 +148,47 @@ void mic_card_unmap(struct mic_device *mdev, void __iomem *addr)
 	iounmap(addr);
 }
 
+static inline struct mic_driver *mbdev_to_mdrv(struct mbus_device *mbdev)
+{
+	return dev_get_drvdata(mbdev->dev.parent);
+}
+
+static struct mic_irq *
+_mic_request_threaded_irq(struct mbus_device *mbdev,
+			  irq_handler_t handler, irq_handler_t thread_fn,
+			  const char *name, void *data, int intr_src)
+{
+	int rc = 0;
+	unsigned int irq = intr_src;
+	unsigned long cookie = irq;
+
+	rc  = request_threaded_irq(irq, handler, thread_fn, 0, name, data);
+	if (rc) {
+		dev_err(mbdev_to_mdrv(mbdev)->dev,
+			"request_threaded_irq failed rc = %d\n", rc);
+		return ERR_PTR(rc);
+	}
+	return (struct mic_irq *)cookie;
+}
+
+static void _mic_free_irq(struct mbus_device *mbdev,
+			  struct mic_irq *cookie, void *data)
+{
+	unsigned long irq = (unsigned long)cookie;
+	free_irq(irq, data);
+}
+
+static void _mic_ack_interrupt(struct mbus_device *mbdev, int num)
+{
+	mic_ack_interrupt(&mbdev_to_mdrv(mbdev)->mdev);
+}
+
+static struct mbus_hw_ops mbus_hw_ops = {
+	.request_threaded_irq = _mic_request_threaded_irq,
+	.free_irq = _mic_free_irq,
+	.ack_interrupt = _mic_ack_interrupt,
+};
+
 static int __init mic_probe(struct platform_device *pdev)
 {
 	struct mic_driver *mdrv = &g_drv;
@@ -166,13 +207,24 @@ static int __init mic_probe(struct platform_device *pdev)
 		goto done;
 	}
 	mic_hw_intr_init(mdrv);
+	platform_set_drvdata(pdev, mdrv);
+	mdrv->dma_mbdev = mbus_register_device(mdrv->dev, MBUS_DEV_DMA_MIC,
+					       NULL, &mbus_hw_ops,
+					       mdrv->mdev.mmio.va);
+	if (IS_ERR(mdrv->dma_mbdev)) {
+		rc = PTR_ERR(mdrv->dma_mbdev);
+		dev_err(&pdev->dev, "mbus_add_device failed rc %d\n", rc);
+		goto iounmap;
+	}
 	rc = mic_driver_init(mdrv);
 	if (rc) {
 		dev_err(&pdev->dev, "mic_driver_init failed rc %d\n", rc);
-		goto iounmap;
+		goto remove_dma;
 	}
 done:
 	return rc;
+remove_dma:
+	mbus_unregister_device(mdrv->dma_mbdev);
 iounmap:
 	iounmap(mdev->mmio.va);
 	return rc;
@@ -184,6 +236,7 @@ static int mic_remove(struct platform_device *pdev)
 	struct mic_device *mdev = &mdrv->mdev;
 
 	mic_driver_uninit(mdrv);
+	mbus_unregister_device(mdrv->dma_mbdev);
 	iounmap(mdev->mmio.va);
 	return 0;
 }
-- 
1.8.2.1

