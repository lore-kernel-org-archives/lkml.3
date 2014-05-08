Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaEHJfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:35:48 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52921 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216AbaEHJfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:35:46 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <rogerq@ti.com>,
        <kishon@ti.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH 1/5] usb: dwc3: dwc3-omap: Add dwc3_omap_map_offset function
Date: Thu, 8 May 2014 15:03:03 +0530
Message-ID: <1399541587-14067-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399541587-14067-1-git-send-email-george.cherian@ti.com>
References: <1399541587-14067-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculate the wrapper register offsets in a seperate function.
Improve code readability, decrease the dwc3_probe() size.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 80 ++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 36 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 1160ff4..872f065 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -383,6 +383,49 @@ static int dwc3_omap_vbus_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void dwc3_omap_map_offset(struct dwc3_omap *omap)
+{
+	u32			reg;
+	struct device_node	*node = omap->dev->of_node;
+	int			x_major;
+
+	reg = dwc3_omap_readl(omap->base, USBOTGSS_REVISION);
+	omap->revision = reg;
+	x_major = USBOTGSS_REVISION_XMAJOR(reg);
+
+	/* Differentiate between OMAP5 and AM437x */
+	switch (x_major) {
+	case USBOTGSS_REVISION_XMAJOR1:
+	case USBOTGSS_REVISION_XMAJOR2:
+		omap->irq_eoi_offset = 0;
+		omap->irq0_offset = 0;
+		omap->irqmisc_offset = 0;
+		omap->utmi_otg_offset = 0;
+		omap->debug_offset = 0;
+		break;
+	default:
+		/* Default to the latest revision */
+		omap->irq_eoi_offset = USBOTGSS_EOI_OFFSET;
+		omap->irq0_offset = USBOTGSS_IRQ0_OFFSET;
+		omap->irqmisc_offset = USBOTGSS_IRQMISC_OFFSET;
+		omap->utmi_otg_offset = USBOTGSS_UTMI_OTG_OFFSET;
+		omap->debug_offset = USBOTGSS_DEBUG_OFFSET;
+		break;
+	}
+
+	/* For OMAP5(ES2.0) and AM437x x_major is 2 even though there are
+	 * changes in wrapper registers, Using dt compatible for aegis
+	 */
+
+	if (of_device_is_compatible(node, "ti,am437x-dwc3")) {
+		omap->irq_eoi_offset = USBOTGSS_EOI_OFFSET;
+		omap->irq0_offset = USBOTGSS_IRQ0_OFFSET;
+		omap->irqmisc_offset = USBOTGSS_IRQMISC_OFFSET;
+		omap->utmi_otg_offset = USBOTGSS_UTMI_OTG_OFFSET;
+		omap->debug_offset = USBOTGSS_DEBUG_OFFSET;
+	}
+}
+
 static int dwc3_omap_probe(struct platform_device *pdev)
 {
 	struct device_node	*node = pdev->dev.of_node;
@@ -397,7 +440,6 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	int			irq;
 
 	int			utmi_mode = 0;
-	int			x_major;
 
 	u32			reg;
 
@@ -448,41 +490,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	reg = dwc3_omap_readl(omap->base, USBOTGSS_REVISION);
-	omap->revision = reg;
-	x_major = USBOTGSS_REVISION_XMAJOR(reg);
-
-	/* Differentiate between OMAP5 and AM437x */
-	switch (x_major) {
-	case USBOTGSS_REVISION_XMAJOR1:
-	case USBOTGSS_REVISION_XMAJOR2:
-		omap->irq_eoi_offset = 0;
-		omap->irq0_offset = 0;
-		omap->irqmisc_offset = 0;
-		omap->utmi_otg_offset = 0;
-		omap->debug_offset = 0;
-		break;
-	default:
-		/* Default to the latest revision */
-		omap->irq_eoi_offset = USBOTGSS_EOI_OFFSET;
-		omap->irq0_offset = USBOTGSS_IRQ0_OFFSET;
-		omap->irqmisc_offset = USBOTGSS_IRQMISC_OFFSET;
-		omap->utmi_otg_offset = USBOTGSS_UTMI_OTG_OFFSET;
-		omap->debug_offset = USBOTGSS_DEBUG_OFFSET;
-		break;
-	}
-
-	/* For OMAP5(ES2.0) and AM437x x_major is 2 even though there are
-	 * changes in wrapper registers, Using dt compatible for aegis
-	 */
-
-	if (of_device_is_compatible(node, "ti,am437x-dwc3")) {
-		omap->irq_eoi_offset = USBOTGSS_EOI_OFFSET;
-		omap->irq0_offset = USBOTGSS_IRQ0_OFFSET;
-		omap->irqmisc_offset = USBOTGSS_IRQMISC_OFFSET;
-		omap->utmi_otg_offset = USBOTGSS_UTMI_OTG_OFFSET;
-		omap->debug_offset = USBOTGSS_DEBUG_OFFSET;
-	}
+	dwc3_omap_map_offset(omap);
 
 	reg = dwc3_omap_read_utmi_status(omap);
 
-- 
1.8.3.1

