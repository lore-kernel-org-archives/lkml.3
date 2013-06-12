Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3FLJZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:25:00 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47958 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab3FLJYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:24:24 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 2/3] usb: dwc3: omap: Intialize the register offset values for OMAP5 and AM437x
Date: Wed, 12 Jun 2013 14:53:46 +0530
Message-ID: <1371029027-9100-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1371029027-9100-1-git-send-email-george.cherian@ti.com>
References: <1371029027-9100-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch Initializes the register offset values depending
on the X_MAJOR of USBOTGSS_REVISION register. Also adds register
offset defines and new debug register defines.

X_MAJOR is 2 for both OMAP5 and AM437x. But both have different glue register
layout. Differentiate AM437x using dt compatible.
Register offsets are cached in dwc3_omap struct for reg reads and writes.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 57 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index a354b4c..f204d18 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -61,21 +61,38 @@
 #define USBOTGSS_REVISION			0x0000
 #define USBOTGSS_SYSCONFIG			0x0010
 #define USBOTGSS_IRQ_EOI			0x0020
+#define USBOTGSS_EOI_OFFSET			0x0008
 #define USBOTGSS_IRQSTATUS_RAW_0		0x0024
 #define USBOTGSS_IRQSTATUS_0			0x0028
 #define USBOTGSS_IRQENABLE_SET_0		0x002c
 #define USBOTGSS_IRQENABLE_CLR_0		0x0030
+#define USBOTGSS_IRQ0_OFFSET			0x0004
 #define USBOTGSS_IRQSTATUS_RAW_1		0x0034
 #define USBOTGSS_IRQSTATUS_1			0x0038
 #define USBOTGSS_IRQENABLE_SET_1		0x003c
 #define USBOTGSS_IRQENABLE_CLR_1		0x0040
+#define USBOTGSS_IRQSTATUS_EOI_MISC		0x0030
+#define USBOTGSS_IRQSTATUS_RAW_MISC		0x0034
+#define USBOTGSS_IRQSTATUS_MISC			0x0038
+#define USBOTGSS_IRQENABLE_SET_MISC		0x003c
+#define USBOTGSS_IRQENABLE_CLR_MISC		0x0040
+#define USBOTGSS_IRQMISC_OFFSET			0x03fc
 #define USBOTGSS_UTMI_OTG_CTRL			0x0080
 #define USBOTGSS_UTMI_OTG_STATUS		0x0084
+#define USBOTGSS_UTMI_OTG_OFFSET		0x0480
+#define USBOTGSS_TXFIFO_DEPTH			0x0508
+#define USBOTGSS_RXFIFO_DEPTH			0x050c
 #define USBOTGSS_MMRAM_OFFSET			0x0100
 #define USBOTGSS_FLADJ				0x0104
 #define USBOTGSS_DEBUG_CFG			0x0108
 #define USBOTGSS_DEBUG_DATA			0x010c
+#define USBOTGSS_DEV_EBC_EN			0x0110
+#define USBOTGSS_DEBUG_OFFSET			0x0600
 
+/* REVISION REGISTER */
+#define USBOTGSS_REVISION_XMAJOR(reg)		((reg >> 8) & 0x7)
+#define USBOTGSS_REVISION_XMAJOR1		1
+#define USBOTGSS_REVISION_XMAJOR2		2
 /* SYSCONFIG REGISTER */
 #define USBOTGSS_SYSCONFIG_DMADISABLE		(1 << 16)
 
@@ -300,6 +317,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	int			irq;
 
 	int			utmi_mode = 0;
+	int			x_major;
 
 	u32			reg;
 
@@ -356,6 +374,42 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	reg = dwc3_omap_readl(omap->base, USBOTGSS_REVISION);
+	omap->revision = reg;
+	x_major = USBOTGSS_REVISION_XMAJOR(reg);
+
+	/* Differentiate between OMAP5,AM437x and others*/
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
+
 	reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
 
 	of_property_read_u32(node, "utmi-mode", &utmi_mode);
@@ -412,6 +466,9 @@ static const struct of_device_id of_dwc3_match[] = {
 	{
 		.compatible =	"ti,dwc3"
 	},
+	{
+		.compatible =	"ti,am437x-dwc3"
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, of_dwc3_match);
-- 
1.8.1.4

