Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590AbaGPNJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:09:50 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47132 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964810AbaGPNJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:09:37 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [RESEND PATCH v3 2/4] usb: dwc3: dwc3-omap: Add dwc3_omap_map_offset() function
Date: Wed, 16 Jul 2014 18:37:06 +0530
Message-ID: <1405516028-26500-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405516028-26500-1-git-send-email-george.cherian@ti.com>
References: <1405516028-26500-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move map offset to its own seperate function.
Improve code readability, decrease the dwc3_probe() size.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 999bdc8..09918ac 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -378,6 +378,25 @@ static int dwc3_omap_vbus_notifier(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
+static void dwc3_omap_map_offset(struct dwc3_omap *omap)
+{
+	struct device_node	*node = omap->dev->of_node;
+
+	/* Differentiate between OMAP5 and AM437x.
+	 * For OMAP5(ES2.0) and AM437x wrapper revision is same  even
+	 * though there are changes in wrapper register offsets.
+	 * Using dt compatible to differentiate  AM437x.
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
@@ -442,19 +461,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		goto err0;
 	}
 
-	/* Differentiate between OMAP5 and AM437x.
-	 * For OMAP5(ES2.0) and AM437x wrapper revision is same, even
-	 * though there are changes in wrapper register offsets.
-	 * Using dt compatible to differentiate  AM437x.
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

