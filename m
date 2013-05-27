Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3E0IDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:03:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50845 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3E0IDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:03:34 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 2/3] usb: dwc3: omap: Intialize the register offset values for OMAP5 and AM437x
Date: Mon, 27 May 2013 13:32:56 +0530
Message-ID: <1369641777-4509-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1369641777-4509-1-git-send-email-george.cherian@ti.com>
References: <1369641777-4509-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch Initializes the register offset values depending
on the X_MAJOR of USBOTGSS_REVISION register. Also adds register
offset defines and new debug register defines.

X_MAJOR is 1 for OMAP5 and 2 for AM437x.
Register offsets are cached in dwc3_omap struct for reg reads and writes.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index a354b4c..e9e9b58a 100644
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
 
@@ -356,6 +374,31 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	reg = dwc3_omap_readl(omap->base, USBOTGSS_REVISION);
+	omap->revision = reg;
+	x_major = USBOTGSS_REVISION_XMAJOR(reg);
+
+	/* Differentiate between OMAP5 and AM437x */
+	switch (x_major) {
+	case USBOTGSS_REVISION_XMAJOR1:
+		omap->irq_eoi_offset = 0;
+		omap->irq0_offset = 0;
+		omap->irqmisc_offset = 0;
+		omap->utmi_otg_offset = 0;
+		omap->debug_offset = 0;
+		break;
+	case USBOTGSS_REVISION_XMAJOR2:
+		/* FALLTHROUGH */
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
 	reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
 
 	of_property_read_u32(node, "utmi-mode", &utmi_mode);
-- 
1.8.1.4

