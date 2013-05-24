Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab3EXOca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:32:30 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52511 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab3EXOc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:32:27 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <george.cherian@ti.com>, <kishon@ti.com>,
        <sameo@linux.intel.com>
Subject: [PATCH 3/3] usb: dwc3: use extcon fwrk to receive connect/disconnect notification
Date: Fri, 24 May 2013 20:01:36 +0530
Message-ID: <1369405896-30246-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369405896-30246-1-git-send-email-kishon@ti.com>
References: <1369405896-30246-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified dwc3-omap to receive connect and disconnect notification using
extcon framework. Also did the necessary cleanups required after
adapting to extcon framework.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c  | 80 +++++++++++++++++++++++++++++++++----------
 include/linux/usb/dwc3-omap.h | 30 ----------------
 2 files changed, 62 insertions(+), 48 deletions(-)
 delete mode 100644 include/linux/usb/dwc3-omap.h

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 34638b9..771f936 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -43,13 +43,13 @@
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/dwc3-omap.h>
-#include <linux/usb/dwc3-omap.h>
 #include <linux/pm_runtime.h>
 #include <linux/dma-mapping.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/extcon.h>
 
 #include <linux/usb/otg.h>
 
@@ -124,9 +124,19 @@ struct dwc3_omap {
 	u32			utmi_otg_status;
 
 	u32			dma_status:1;
+
+	struct extcon_specific_cable_nb extcon_vbus_dev;
+	struct extcon_specific_cable_nb extcon_id_dev;
+	struct notifier_block	vbus_nb;
+	struct notifier_block	id_nb;
 };
 
-static struct dwc3_omap		*_omap;
+enum omap_dwc3_vbus_id_status {
+	OMAP_DWC3_ID_FLOAT,
+	OMAP_DWC3_ID_GROUND,
+	OMAP_DWC3_VBUS_OFF,
+	OMAP_DWC3_VBUS_VALID,
+};
 
 static inline u32 dwc3_omap_readl(void __iomem *base, u32 offset)
 {
@@ -138,13 +148,10 @@ static inline void dwc3_omap_writel(void __iomem *base, u32 offset, u32 value)
 	writel(value, base + offset);
 }
 
-int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
+static void dwc3_omap_set_mailbox(struct dwc3_omap *omap,
+	enum omap_dwc3_vbus_id_status status)
 {
-	u32			val;
-	struct dwc3_omap	*omap = _omap;
-
-	if (!omap)
-		return -EPROBE_DEFER;
+	u32	val;
 
 	switch (status) {
 	case OMAP_DWC3_ID_GROUND:
@@ -185,12 +192,9 @@ int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
 		break;
 
 	default:
-		dev_dbg(omap->dev, "ID float\n");
+		dev_dbg(omap->dev, "invalid state\n");
 	}
-
-	return 0;
 }
-EXPORT_SYMBOL_GPL(dwc3_omap_mailbox);
 
 static irqreturn_t dwc3_omap_interrupt(int irq, void *_omap)
 {
@@ -282,6 +286,32 @@ static void dwc3_omap_disable_irqs(struct dwc3_omap *omap)
 
 static u64 dwc3_omap_dma_mask = DMA_BIT_MASK(32);
 
+static int dwc3_omap_id_notifier(struct notifier_block *nb,
+	unsigned long event, void *ptr)
+{
+	struct dwc3_omap *omap = container_of(nb, struct dwc3_omap, id_nb);
+
+	if (event)
+		dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
+	else
+		dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_FLOAT);
+
+	return NOTIFY_DONE;
+}
+
+static int dwc3_omap_vbus_notifier(struct notifier_block *nb,
+	unsigned long event, void *ptr)
+{
+	struct dwc3_omap *omap = container_of(nb, struct dwc3_omap, vbus_nb);
+
+	if (event)
+		dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
+	else
+		dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_OFF);
+
+	return NOTIFY_DONE;
+}
+
 static int dwc3_omap_probe(struct platform_device *pdev)
 {
 	struct device_node	*node = pdev->dev.of_node;
@@ -289,6 +319,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	struct dwc3_omap	*omap;
 	struct resource		*res;
 	struct device		*dev = &pdev->dev;
+	struct extcon_dev	*edev;
 
 	int			ret = -ENOMEM;
 	int			irq;
@@ -330,19 +361,25 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	edev = extcon_get_extcon_dev("palmas-usb");
+	if (!edev) {
+		dev_dbg(dev, "couldn't get extcon device\n");
+		return -EPROBE_DEFER;
+	}
+
 	spin_lock_init(&omap->lock);
 
 	omap->dev	= dev;
 	omap->irq	= irq;
 	omap->base	= base;
+	omap->vbus_nb.notifier_call = dwc3_omap_vbus_notifier;
+	extcon_register_interest(&omap->extcon_vbus_dev, "palmas-usb", "USB",
+		&omap->vbus_nb);
+	omap->id_nb.notifier_call = dwc3_omap_id_notifier;
+	extcon_register_interest(&omap->extcon_id_dev, "palmas-usb", "USB-HOST",
+		&omap->id_nb);
 	dev->dma_mask	= &dwc3_omap_dma_mask;
 
-	/*
-	 * REVISIT if we ever have two instances of the wrapper, we will be
-	 * in big trouble
-	 */
-	_omap	= omap;
-
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
@@ -387,6 +424,11 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	if (extcon_get_cable_state(edev, "USB") == true)
+		dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
+	if (extcon_get_cable_state(edev, "USB-HOST") == true)
+		dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
+
 	return 0;
 }
 
@@ -394,6 +436,8 @@ static int dwc3_omap_remove(struct platform_device *pdev)
 {
 	struct dwc3_omap	*omap = platform_get_drvdata(pdev);
 
+	extcon_unregister_interest(&omap->extcon_vbus_dev);
+	extcon_unregister_interest(&omap->extcon_id_dev);
 	dwc3_omap_disable_irqs(omap);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
diff --git a/include/linux/usb/dwc3-omap.h b/include/linux/usb/dwc3-omap.h
deleted file mode 100644
index 5615f4d..0000000
--- a/include/linux/usb/dwc3-omap.h
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * Copyright (C) 2013 by Texas Instruments
- *
- * The Inventra Controller Driver for Linux is free software; you
- * can redistribute it and/or modify it under the terms of the GNU
- * General Public License version 2 as published by the Free Software
- * Foundation.
- */
-
-#ifndef __DWC3_OMAP_H__
-#define __DWC3_OMAP_H__
-
-enum omap_dwc3_vbus_id_status {
-	OMAP_DWC3_UNKNOWN = 0,
-	OMAP_DWC3_ID_GROUND,
-	OMAP_DWC3_ID_FLOAT,
-	OMAP_DWC3_VBUS_VALID,
-	OMAP_DWC3_VBUS_OFF,
-};
-
-#if (defined(CONFIG_USB_DWC3) || defined(CONFIG_USB_DWC3_MODULE))
-extern int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status);
-#else
-static inline int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
-{
-	return -ENODEV;
-}
-#endif
-
-#endif	/* __DWC3_OMAP_H__ */
-- 
1.8.1.2

