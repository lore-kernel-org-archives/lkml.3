Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbaEHJfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:35:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59667 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbaEHJft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:35:49 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <rogerq@ti.com>,
        <kishon@ti.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH 2/5] usb: dwc3: dwc3-omap: Add dwc3_omap_set_utmi_mode() function
Date: Thu, 8 May 2014 15:03:04 +0530
Message-ID: <1399541587-14067-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399541587-14067-1-git-send-email-george.cherian@ti.com>
References: <1399541587-14067-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move find and set the utmi mode to its own seperate function.
Improve code readability, decrease the dwc3_probe() size.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 872f065..b739a24 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -426,6 +426,30 @@ static void dwc3_omap_map_offset(struct dwc3_omap *omap)
 	}
 }
 
+static void dwc3_omap_set_utmi_mode(struct dwc3_omap *omap)
+{
+	u32			reg;
+	struct device_node	*node = omap->dev->of_node;
+	int			utmi_mode = 0;
+
+	reg = dwc3_omap_read_utmi_status(omap);
+
+	of_property_read_u32(node, "utmi-mode", &utmi_mode);
+
+	switch (utmi_mode) {
+	case DWC3_OMAP_UTMI_MODE_SW:
+		reg |= USBOTGSS_UTMI_OTG_STATUS_SW_MODE;
+		break;
+	case DWC3_OMAP_UTMI_MODE_HW:
+		reg &= ~USBOTGSS_UTMI_OTG_STATUS_SW_MODE;
+		break;
+	default:
+		dev_dbg(omap->dev, "UNKNOWN utmi mode %d\n", utmi_mode);
+	}
+
+	dwc3_omap_write_utmi_status(omap, reg);
+}
+
 static int dwc3_omap_probe(struct platform_device *pdev)
 {
 	struct device_node	*node = pdev->dev.of_node;
@@ -439,8 +463,6 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	int			ret = -ENOMEM;
 	int			irq;
 
-	int			utmi_mode = 0;
-
 	u32			reg;
 
 	void __iomem		*base;
@@ -491,23 +513,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	}
 
 	dwc3_omap_map_offset(omap);
-
-	reg = dwc3_omap_read_utmi_status(omap);
-
-	of_property_read_u32(node, "utmi-mode", &utmi_mode);
-
-	switch (utmi_mode) {
-	case DWC3_OMAP_UTMI_MODE_SW:
-		reg |= USBOTGSS_UTMI_OTG_STATUS_SW_MODE;
-		break;
-	case DWC3_OMAP_UTMI_MODE_HW:
-		reg &= ~USBOTGSS_UTMI_OTG_STATUS_SW_MODE;
-		break;
-	default:
-		dev_dbg(dev, "UNKNOWN utmi mode %d\n", utmi_mode);
-	}
-
-	dwc3_omap_write_utmi_status(omap, reg);
+	dwc3_omap_set_utmi_mode(omap);
 
 	/* check the DMA Status */
 	reg = dwc3_omap_readl(omap->base, USBOTGSS_SYSCONFIG);
-- 
1.8.3.1

