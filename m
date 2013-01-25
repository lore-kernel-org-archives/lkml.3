Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3AYDBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 22:01:25 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35390 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754633Ab3AYDBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 22:01:10 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
CC: <grant.likely@secretlab.ca>, <gregkh@linuxfoundation.org>, <kishon@ti.com>
Subject: [PATCH v3 05/11] usb: dwc3-omap: Add an API to write to dwc mailbox
Date: Fri, 25 Jan 2013 08:30:49 +0530
Message-ID: <1359082855-7404-6-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359082855-7404-1-git-send-email-kishon@ti.com>
References: <1359082855-7404-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an API in the omap glue layer to write to the mailbox register which
can be used by comparator driver(twl). To pass the detection of the attached
device (signified by VBUS, ID) to the dwc3 core, dwc3 core has to write
to the mailbox regiter.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c  |   60 +++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/dwc3-omap.h |   30 +++++++++++++++++++++
 2 files changed, 90 insertions(+)
 create mode 100644 include/linux/usb/dwc3-omap.h

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index f85ae5e..831b75f 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -43,6 +43,7 @@
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/dwc3-omap.h>
+#include <linux/usb/dwc3-omap.h>
 #include <linux/pm_runtime.h>
 #include <linux/dma-mapping.h>
 #include <linux/ioport.h>
@@ -131,6 +132,8 @@ struct dwc3_omap {
 	u32			dma_status:1;
 };
 
+struct dwc3_omap		*_omap;
+
 static inline u32 dwc3_omap_readl(void __iomem *base, u32 offset)
 {
 	return readl(base + offset);
@@ -141,6 +144,57 @@ static inline void dwc3_omap_writel(void __iomem *base, u32 offset, u32 value)
 	writel(value, base + offset);
 }
 
+void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
+{
+	u32			val;
+	struct dwc3_omap	*omap = _omap;
+
+	switch (status) {
+	case OMAP_DWC3_ID_GROUND:
+		dev_dbg(omap->dev, "ID GND\n");
+
+		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
+		val &= ~(USBOTGSS_UTMI_OTG_STATUS_IDDIG
+				| USBOTGSS_UTMI_OTG_STATUS_VBUSVALID
+				| USBOTGSS_UTMI_OTG_STATUS_SESSEND);
+		val |= USBOTGSS_UTMI_OTG_STATUS_SESSVALID
+				| USBOTGSS_UTMI_OTG_STATUS_POWERPRESENT;
+		dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS, val);
+		break;
+
+	case OMAP_DWC3_VBUS_VALID:
+		dev_dbg(omap->dev, "VBUS Connect\n");
+
+		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
+		val &= ~USBOTGSS_UTMI_OTG_STATUS_SESSEND;
+		val |= USBOTGSS_UTMI_OTG_STATUS_IDDIG
+				| USBOTGSS_UTMI_OTG_STATUS_VBUSVALID
+				| USBOTGSS_UTMI_OTG_STATUS_SESSVALID
+				| USBOTGSS_UTMI_OTG_STATUS_POWERPRESENT;
+		dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS, val);
+		break;
+
+	case OMAP_DWC3_ID_FLOAT:
+	case OMAP_DWC3_VBUS_OFF:
+		dev_dbg(omap->dev, "VBUS Disconnect\n");
+
+		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
+		val &= ~(USBOTGSS_UTMI_OTG_STATUS_SESSVALID
+				| USBOTGSS_UTMI_OTG_STATUS_VBUSVALID
+				| USBOTGSS_UTMI_OTG_STATUS_POWERPRESENT);
+		val |= USBOTGSS_UTMI_OTG_STATUS_SESSEND
+				| USBOTGSS_UTMI_OTG_STATUS_IDDIG;
+		dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS, val);
+		break;
+
+	default:
+		dev_dbg(omap->dev, "ID float\n");
+	}
+
+	return;
+}
+EXPORT_SYMBOL_GPL(dwc3_omap_mailbox);
+
 static int dwc3_omap_register_phys(struct dwc3_omap *omap)
 {
 	struct nop_usb_xceiv_platform_data pdata;
@@ -320,6 +374,12 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	omap->irq	= irq;
 	omap->base	= base;
 
+	/*
+	 * REVISIT if we ever have two instances of the wrapper, we will be
+	 * in big trouble
+	 */
+	_omap	= omap;
+
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
 	if (ret < 0) {
diff --git a/include/linux/usb/dwc3-omap.h b/include/linux/usb/dwc3-omap.h
new file mode 100644
index 0000000..51eae14
--- /dev/null
+++ b/include/linux/usb/dwc3-omap.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (C) 2013 by Texas Instruments
+ *
+ * The Inventra Controller Driver for Linux is free software; you
+ * can redistribute it and/or modify it under the terms of the GNU
+ * General Public License version 2 as published by the Free Software
+ * Foundation.
+ */
+
+#ifndef __DWC3_OMAP_H__
+#define __DWC3_OMAP_H__
+
+enum omap_dwc3_vbus_id_status {
+	OMAP_DWC3_UNKNOWN = 0,
+	OMAP_DWC3_ID_GROUND,
+	OMAP_DWC3_ID_FLOAT,
+	OMAP_DWC3_VBUS_VALID,
+	OMAP_DWC3_VBUS_OFF,
+};
+
+#if (defined(CONFIG_USB_DWC3) || defined(CONFIG_USB_DWC3_MODULE))
+extern void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status);
+#else
+static inline void dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
+{
+	return;
+}
+#endif
+
+#endif	/* __DWC3_OMAP_H__ */
-- 
1.7.9.5

