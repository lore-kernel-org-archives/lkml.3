Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaEVEFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:05:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50497 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbaEVEDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:03:15 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 1/6] usb: dwc3: dwc3-omap: Remove x_major calculation from revision register
Date: Thu, 22 May 2014 09:31:33 +0530
Message-ID: <1400731298-18442-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400731298-18442-1-git-send-email-george.cherian@ti.com>
References: <1400731298-18442-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the x_major calculation logic from the wrapper revision register
to differentiate between OMAP5 and AM437x. This was done to find the
register offsets of wrapper register. Now that We do it using dt
compatible, remove the whole logic.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 36 ++++--------------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 4af4c35..999bdc8 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -77,10 +77,6 @@
 #define USBOTGSS_DEV_EBC_EN			0x0110
 #define USBOTGSS_DEBUG_OFFSET			0x0600
 
-/* REVISION REGISTER */
-#define USBOTGSS_REVISION_XMAJOR(reg)		((reg >> 8) & 0x7)
-#define USBOTGSS_REVISION_XMAJOR1		1
-#define USBOTGSS_REVISION_XMAJOR2		2
 /* SYSCONFIG REGISTER */
 #define USBOTGSS_SYSCONFIG_DMADISABLE		(1 << 16)
 
@@ -129,7 +125,6 @@ struct dwc3_omap {
 	u32			irq_eoi_offset;
 	u32			debug_offset;
 	u32			irq0_offset;
-	u32			revision;
 
 	u32			dma_status:1;
 
@@ -397,7 +392,6 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	int			irq;
 
 	int			utmi_mode = 0;
-	int			x_major;
 
 	u32			reg;
 
@@ -448,32 +442,10 @@ static int dwc3_omap_probe(struct platform_device *pdev)
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
+	/* Differentiate between OMAP5 and AM437x.
+	 * For OMAP5(ES2.0) and AM437x wrapper revision is same, even
+	 * though there are changes in wrapper register offsets.
+	 * Using dt compatible to differentiate  AM437x.
 	 */
 
 	if (of_device_is_compatible(node, "ti,am437x-dwc3")) {
-- 
1.8.3.1

