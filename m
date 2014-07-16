Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbaGPNJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:09:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49406 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758139AbaGPNJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:09:16 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [RESEND PATCH v3 3/4] usb: dwc3: dwc3-omap: Add dwc3_omap_set_utmi_mode() function
Date: Wed, 16 Jul 2014 18:37:07 +0530
Message-ID: <1405516028-26500-4-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405516028-26500-1-git-send-email-george.cherian@ti.com>
References: <1405516028-26500-1-git-send-email-george.cherian@ti.com>
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
index 09918ac..56ec6eb 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -397,6 +397,30 @@ static void dwc3_omap_map_offset(struct dwc3_omap *omap)
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
@@ -410,8 +434,6 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	int			ret;
 	int			irq;
 
-	int			utmi_mode = 0;
-
 	u32			reg;
 
 	void __iomem		*base;
@@ -462,23 +484,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
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

