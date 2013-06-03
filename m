Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404Ab3FCQOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:14:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36454 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308Ab3FCQOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:14:21 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>,
        <benoit.cousson@linaro.org>, <anish198519851985@gmail.com>,
        <pmeerw@pmeerw.net>
Subject: [v3 PATCH 5/5] usb: dwc3: use extcon fwrk to receive connect/disconnect
Date: Mon, 3 Jun 2013 21:43:40 +0530
Message-ID: <1370276020-17446-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1370276020-17446-1-git-send-email-kishon@ti.com>
References: <1370276020-17446-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified dwc3-omap to receive connect and disconnect notification using
extcon framework. Also did the necessary cleanups required after
adapting to extcon framework.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
Changes from v2:
* updated the Documentation with dwc3 dt binding information.
* used of_extcon_get_extcon_dev to get extcon device from device tree data.
Changes from v1:
* regulator enable/disable is now done here instead of palmas-usb as some users
of palmas-usb wont need regulator.
 Documentation/devicetree/bindings/usb/omap-usb.txt |    5 +
 drivers/usb/dwc3/dwc3-omap.c                       |  118 ++++++++++++++++----
 include/linux/usb/dwc3-omap.h                      |   30 -----
 3 files changed, 104 insertions(+), 49 deletions(-)
 delete mode 100644 include/linux/usb/dwc3-omap.h

diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt b/Documentation/devicetree/bindings/usb/omap-usb.txt
index d4769f3..f1c15f3 100644
--- a/Documentation/devicetree/bindings/usb/omap-usb.txt
+++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
@@ -53,6 +53,11 @@ OMAP DWC3 GLUE
    It should be set to "1" for HW mode and "2" for SW mode.
  - ranges: the child address space are mapped 1:1 onto the parent address space
 
+Optional Properties:
+ - extcon : phandle for the extcon device omap dwc3 uses to detect
+   connect/disconnect events.
+ - vbus-supply : phandle to the regulator device tree node if needed.
+
 Sub-nodes:
 The dwc3 core should be added as subnode to omap dwc3 glue.
 - dwc3 :
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index f8f76e6..e1aac90 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -43,13 +43,14 @@
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
+#include <linux/regulator/consumer.h>
 
 #include <linux/usb/otg.h>
 
@@ -124,9 +125,21 @@ struct dwc3_omap {
 	u32			utmi_otg_status;
 
 	u32			dma_status:1;
+
+	struct extcon_specific_cable_nb extcon_vbus_dev;
+	struct extcon_specific_cable_nb extcon_id_dev;
+	struct notifier_block	vbus_nb;
+	struct notifier_block	id_nb;
+
+	struct regulator	*vbus_reg;
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
@@ -138,18 +151,23 @@ static inline void dwc3_omap_writel(void __iomem *base, u32 offset, u32 value)
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
+	int	ret;
+	u32	val;
 
 	switch (status) {
 	case OMAP_DWC3_ID_GROUND:
 		dev_dbg(omap->dev, "ID GND\n");
 
+		if (omap->vbus_reg) {
+			ret = regulator_enable(omap->vbus_reg);
+			if (ret) {
+				dev_dbg(omap->dev, "regulator enable failed\n");
+				return;
+			}
+		}
 		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
 		val &= ~(USBOTGSS_UTMI_OTG_STATUS_IDDIG
 				| USBOTGSS_UTMI_OTG_STATUS_VBUSVALID
@@ -172,6 +190,9 @@ int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
 		break;
 
 	case OMAP_DWC3_ID_FLOAT:
+		if (omap->vbus_reg)
+			regulator_disable(omap->vbus_reg);
+
 	case OMAP_DWC3_VBUS_OFF:
 		dev_dbg(omap->dev, "VBUS Disconnect\n");
 
@@ -185,12 +206,9 @@ int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
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
@@ -282,6 +300,32 @@ static void dwc3_omap_disable_irqs(struct dwc3_omap *omap)
 
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
@@ -289,6 +333,8 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	struct dwc3_omap	*omap;
 	struct resource		*res;
 	struct device		*dev = &pdev->dev;
+	struct extcon_dev	*edev;
+	struct regulator	*vbus_reg = NULL;
 
 	int			ret = -ENOMEM;
 	int			irq;
@@ -330,19 +376,22 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	if (of_property_read_bool(node, "vbus-supply")) {
+		vbus_reg = devm_regulator_get(dev, "vbus");
+		if (IS_ERR(vbus_reg)) {
+			dev_err(dev, "vbus init failed\n");
+			return PTR_ERR(vbus_reg);
+		}
+	}
+
 	spin_lock_init(&omap->lock);
 
 	omap->dev	= dev;
 	omap->irq	= irq;
 	omap->base	= base;
+	omap->vbus_reg	= vbus_reg;
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
@@ -381,14 +430,41 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 
 	dwc3_omap_enable_irqs(omap);
 
+	if (of_property_read_bool(node, "extcon")) {
+		edev = of_extcon_get_extcon_dev(dev, 0);
+		if (IS_ERR(edev)) {
+			dev_vdbg(dev, "couldn't get extcon device\n");
+			ret = PTR_ERR(edev);
+			goto err2;
+		}
+
+		omap->vbus_nb.notifier_call = dwc3_omap_vbus_notifier;
+		extcon_register_interest(&omap->extcon_vbus_dev, edev->name,
+					 "USB", &omap->vbus_nb);
+		omap->id_nb.notifier_call = dwc3_omap_id_notifier;
+		extcon_register_interest(&omap->extcon_id_dev, edev->name,
+					 "USB-HOST", &omap->id_nb);
+
+		if (extcon_get_cable_state(edev, "USB") == true)
+			dwc3_omap_set_mailbox(omap, OMAP_DWC3_VBUS_VALID);
+		if (extcon_get_cable_state(edev, "USB-HOST") == true)
+			dwc3_omap_set_mailbox(omap, OMAP_DWC3_ID_GROUND);
+	}
+
 	ret = of_platform_populate(node, NULL, NULL, dev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to create dwc3 core\n");
-		goto err2;
+		goto err3;
 	}
 
 	return 0;
 
+err3:
+	if (omap->extcon_vbus_dev.edev)
+		extcon_unregister_interest(&omap->extcon_vbus_dev);
+	if (omap->extcon_id_dev.edev)
+		extcon_unregister_interest(&omap->extcon_id_dev);
+
 err2:
 	dwc3_omap_disable_irqs(omap);
 
@@ -405,6 +481,10 @@ static int dwc3_omap_remove(struct platform_device *pdev)
 {
 	struct dwc3_omap	*omap = platform_get_drvdata(pdev);
 
+	if (omap->extcon_vbus_dev.edev)
+		extcon_unregister_interest(&omap->extcon_vbus_dev);
+	if (omap->extcon_id_dev.edev)
+		extcon_unregister_interest(&omap->extcon_id_dev);
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
1.7.10.4

