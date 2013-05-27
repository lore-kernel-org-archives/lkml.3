Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab3E0IDp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:03:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47661 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756873Ab3E0IDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:03:41 -0400
From: George Cherian <george.cherian@ti.com>
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 3/3] usb: dwc3: omap Modify dwc3_omap_readl/writel with offsets
Date: Mon, 27 May 2013 13:32:57 +0530
Message-ID: <1369641777-4509-4-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1369641777-4509-1-git-send-email-george.cherian@ti.com>
References: <1369641777-4509-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies dwc3_omap_readl/writel calls to accomodate
both OMAP5 and AM437x reg maps (It uses the cached register offsets).
Also renames OMAP5 IRQ1 as IRQMISC, IRQ1 bits as IRQMISC bits.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 136 +++++++++++++++++++++++++------------------
 1 file changed, 80 insertions(+), 56 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index e9e9b58a..d43f7bf 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -67,10 +67,18 @@
 #define USBOTGSS_IRQENABLE_SET_0		0x002c
 #define USBOTGSS_IRQENABLE_CLR_0		0x0030
 #define USBOTGSS_IRQ0_OFFSET			0x0004
-#define USBOTGSS_IRQSTATUS_RAW_1		0x0034
-#define USBOTGSS_IRQSTATUS_1			0x0038
-#define USBOTGSS_IRQENABLE_SET_1		0x003c
-#define USBOTGSS_IRQENABLE_CLR_1		0x0040
+#define USBOTGSS_IRQSTATUS_RAW_1		0x0030
+#define USBOTGSS_IRQSTATUS_1			0x0034
+#define USBOTGSS_IRQENABLE_SET_1		0x0038
+#define USBOTGSS_IRQENABLE_CLR_1		0x003c
+#define USBOTGSS_IRQSTATUS_RAW_2		0x0040
+#define USBOTGSS_IRQSTATUS_2			0x0044
+#define USBOTGSS_IRQENABLE_SET_2		0x0048
+#define USBOTGSS_IRQENABLE_CLR_2		0x004c
+#define USBOTGSS_IRQSTATUS_RAW_3		0x0050
+#define USBOTGSS_IRQSTATUS_3			0x0054
+#define USBOTGSS_IRQENABLE_SET_3		0x0058
+#define USBOTGSS_IRQENABLE_CLR_3		0x005c
 #define USBOTGSS_IRQSTATUS_EOI_MISC		0x0030
 #define USBOTGSS_IRQSTATUS_RAW_MISC		0x0034
 #define USBOTGSS_IRQSTATUS_MISC			0x0038
@@ -102,17 +110,17 @@
 /* IRQS0 BITS */
 #define USBOTGSS_IRQO_COREIRQ_ST		(1 << 0)
 
-/* IRQ1 BITS */
-#define USBOTGSS_IRQ1_DMADISABLECLR		(1 << 17)
-#define USBOTGSS_IRQ1_OEVT			(1 << 16)
-#define USBOTGSS_IRQ1_DRVVBUS_RISE		(1 << 13)
-#define USBOTGSS_IRQ1_CHRGVBUS_RISE		(1 << 12)
-#define USBOTGSS_IRQ1_DISCHRGVBUS_RISE		(1 << 11)
-#define USBOTGSS_IRQ1_IDPULLUP_RISE		(1 << 8)
-#define USBOTGSS_IRQ1_DRVVBUS_FALL		(1 << 5)
-#define USBOTGSS_IRQ1_CHRGVBUS_FALL		(1 << 4)
-#define USBOTGSS_IRQ1_DISCHRGVBUS_FALL		(1 << 3)
-#define USBOTGSS_IRQ1_IDPULLUP_FALL		(1 << 0)
+/* IRQMISC BITS */
+#define USBOTGSS_IRQMISC_DMADISABLECLR		(1 << 17)
+#define USBOTGSS_IRQMISC_OEVT			(1 << 16)
+#define USBOTGSS_IRQMISC_DRVVBUS_RISE		(1 << 13)
+#define USBOTGSS_IRQMISC_CHRGVBUS_RISE		(1 << 12)
+#define USBOTGSS_IRQMISC_DISCHRGVBUS_RISE	(1 << 11)
+#define USBOTGSS_IRQMISC_IDPULLUP_RISE		(1 << 8)
+#define USBOTGSS_IRQMISC_DRVVBUS_FALL		(1 << 5)
+#define USBOTGSS_IRQMISC_CHRGVBUS_FALL		(1 << 4)
+#define USBOTGSS_IRQMISC_DISCHRGVBUS_FALL	(1 << 3)
+#define USBOTGSS_IRQMISC_IDPULLUP_FALL		(1 << 0)
 
 /* UTMI_OTG_CTRL REGISTER */
 #define USBOTGSS_UTMI_OTG_CTRL_DRVVBUS		(1 << 5)
@@ -173,38 +181,44 @@ int dwc3_omap_mailbox(enum omap_dwc3_vbus_id_status status)
 	case OMAP_DWC3_ID_GROUND:
 		dev_dbg(omap->dev, "ID GND\n");
 
-		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
+		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS +
+							omap->utmi_otg_offset);
 		val &= ~(USBOTGSS_UTMI_OTG_STATUS_IDDIG
 				| USBOTGSS_UTMI_OTG_STATUS_VBUSVALID
 				| USBOTGSS_UTMI_OTG_STATUS_SESSEND);
 		val |= USBOTGSS_UTMI_OTG_STATUS_SESSVALID
 				| USBOTGSS_UTMI_OTG_STATUS_POWERPRESENT;
-		dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS, val);
+		dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS +
+						omap->utmi_otg_offset, val);
 		break;
 
 	case OMAP_DWC3_VBUS_VALID:
 		dev_dbg(omap->dev, "VBUS Connect\n");
 
-		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
+		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS +
+							omap->utmi_otg_offset);
 		val &= ~USBOTGSS_UTMI_OTG_STATUS_SESSEND;
 		val |= USBOTGSS_UTMI_OTG_STATUS_IDDIG
 				| USBOTGSS_UTMI_OTG_STATUS_VBUSVALID
 				| USBOTGSS_UTMI_OTG_STATUS_SESSVALID
 				| USBOTGSS_UTMI_OTG_STATUS_POWERPRESENT;
-		dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS, val);
+		dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS +
+						omap->utmi_otg_offset, val);
 		break;
 
 	case OMAP_DWC3_ID_FLOAT:
 	case OMAP_DWC3_VBUS_OFF:
 		dev_dbg(omap->dev, "VBUS Disconnect\n");
 
-		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
+		val = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS +
+							omap->utmi_otg_offset);
 		val &= ~(USBOTGSS_UTMI_OTG_STATUS_SESSVALID
 				| USBOTGSS_UTMI_OTG_STATUS_VBUSVALID
 				| USBOTGSS_UTMI_OTG_STATUS_POWERPRESENT);
 		val |= USBOTGSS_UTMI_OTG_STATUS_SESSEND
 				| USBOTGSS_UTMI_OTG_STATUS_IDDIG;
-		dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS, val);
+		dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS +
+						omap->utmi_otg_offset, val);
 		break;
 
 	default:
@@ -222,44 +236,48 @@ static irqreturn_t dwc3_omap_interrupt(int irq, void *_omap)
 
 	spin_lock(&omap->lock);
 
-	reg = dwc3_omap_readl(omap->base, USBOTGSS_IRQSTATUS_1);
+	reg = dwc3_omap_readl(omap->base, USBOTGSS_IRQSTATUS_MISC +
+						omap->irqmisc_offset);
 
-	if (reg & USBOTGSS_IRQ1_DMADISABLECLR) {
+	if (reg & USBOTGSS_IRQMISC_DMADISABLECLR) {
 		dev_dbg(omap->dev, "DMA Disable was Cleared\n");
 		omap->dma_status = false;
 	}
 
-	if (reg & USBOTGSS_IRQ1_OEVT)
+	if (reg & USBOTGSS_IRQMISC_OEVT)
 		dev_dbg(omap->dev, "OTG Event\n");
 
-	if (reg & USBOTGSS_IRQ1_DRVVBUS_RISE)
+	if (reg & USBOTGSS_IRQMISC_DRVVBUS_RISE)
 		dev_dbg(omap->dev, "DRVVBUS Rise\n");
 
-	if (reg & USBOTGSS_IRQ1_CHRGVBUS_RISE)
+	if (reg & USBOTGSS_IRQMISC_CHRGVBUS_RISE)
 		dev_dbg(omap->dev, "CHRGVBUS Rise\n");
 
-	if (reg & USBOTGSS_IRQ1_DISCHRGVBUS_RISE)
+	if (reg & USBOTGSS_IRQMISC_DISCHRGVBUS_RISE)
 		dev_dbg(omap->dev, "DISCHRGVBUS Rise\n");
 
-	if (reg & USBOTGSS_IRQ1_IDPULLUP_RISE)
+	if (reg & USBOTGSS_IRQMISC_IDPULLUP_RISE)
 		dev_dbg(omap->dev, "IDPULLUP Rise\n");
 
-	if (reg & USBOTGSS_IRQ1_DRVVBUS_FALL)
+	if (reg & USBOTGSS_IRQMISC_DRVVBUS_FALL)
 		dev_dbg(omap->dev, "DRVVBUS Fall\n");
 
-	if (reg & USBOTGSS_IRQ1_CHRGVBUS_FALL)
+	if (reg & USBOTGSS_IRQMISC_CHRGVBUS_FALL)
 		dev_dbg(omap->dev, "CHRGVBUS Fall\n");
 
-	if (reg & USBOTGSS_IRQ1_DISCHRGVBUS_FALL)
+	if (reg & USBOTGSS_IRQMISC_DISCHRGVBUS_FALL)
 		dev_dbg(omap->dev, "DISCHRGVBUS Fall\n");
 
-	if (reg & USBOTGSS_IRQ1_IDPULLUP_FALL)
+	if (reg & USBOTGSS_IRQMISC_IDPULLUP_FALL)
 		dev_dbg(omap->dev, "IDPULLUP Fall\n");
 
-	dwc3_omap_writel(omap->base, USBOTGSS_IRQSTATUS_1, reg);
+	dwc3_omap_writel(omap->base, USBOTGSS_IRQSTATUS_1 +
+						omap->irqmisc_offset, reg);
 
-	reg = dwc3_omap_readl(omap->base, USBOTGSS_IRQSTATUS_0);
-	dwc3_omap_writel(omap->base, USBOTGSS_IRQSTATUS_0, reg);
+	reg = dwc3_omap_readl(omap->base, USBOTGSS_IRQSTATUS_0 -
+						omap->irq0_offset);
+	dwc3_omap_writel(omap->base, USBOTGSS_IRQSTATUS_0 -
+						omap->irq0_offset, reg);
 
 	spin_unlock(&omap->lock);
 
@@ -281,26 +299,30 @@ static void dwc3_omap_enable_irqs(struct dwc3_omap *omap)
 
 	/* enable all IRQs */
 	reg = USBOTGSS_IRQO_COREIRQ_ST;
-	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_0, reg);
-
-	reg = (USBOTGSS_IRQ1_OEVT |
-			USBOTGSS_IRQ1_DRVVBUS_RISE |
-			USBOTGSS_IRQ1_CHRGVBUS_RISE |
-			USBOTGSS_IRQ1_DISCHRGVBUS_RISE |
-			USBOTGSS_IRQ1_IDPULLUP_RISE |
-			USBOTGSS_IRQ1_DRVVBUS_FALL |
-			USBOTGSS_IRQ1_CHRGVBUS_FALL |
-			USBOTGSS_IRQ1_DISCHRGVBUS_FALL |
-			USBOTGSS_IRQ1_IDPULLUP_FALL);
-
-	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_1, reg);
+	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_0 -
+						omap->irq0_offset, reg);
+
+	reg = (USBOTGSS_IRQMISC_OEVT |
+			USBOTGSS_IRQMISC_DRVVBUS_RISE |
+			USBOTGSS_IRQMISC_CHRGVBUS_RISE |
+			USBOTGSS_IRQMISC_DISCHRGVBUS_RISE |
+			USBOTGSS_IRQMISC_IDPULLUP_RISE |
+			USBOTGSS_IRQMISC_DRVVBUS_FALL |
+			USBOTGSS_IRQMISC_CHRGVBUS_FALL |
+			USBOTGSS_IRQMISC_DISCHRGVBUS_FALL |
+			USBOTGSS_IRQMISC_IDPULLUP_FALL);
+
+	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_MISC +
+						omap->irqmisc_offset, reg);
 }
 
 static void dwc3_omap_disable_irqs(struct dwc3_omap *omap)
 {
 	/* disable all IRQs */
-	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_1, 0x00);
-	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_0, 0x00);
+	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_MISC +
+						omap->irqmisc_offset, 0x00);
+	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_0 -
+						omap->irq0_offset, 0x00);
 }
 
 static u64 dwc3_omap_dma_mask = DMA_BIT_MASK(32);
@@ -389,7 +411,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		break;
 	case USBOTGSS_REVISION_XMAJOR2:
 		/* FALLTHROUGH */
-	default: 
+	default:
 		/* Default to the latest revision */
 		omap->irq_eoi_offset = USBOTGSS_EOI_OFFSET;
 		omap->irq0_offset = USBOTGSS_IRQ0_OFFSET;
@@ -399,7 +421,8 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		break;
 	}
 
-	reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS);
+	reg = dwc3_omap_readl(omap->base, USBOTGSS_UTMI_OTG_STATUS +
+						omap->utmi_otg_offset);
 
 	of_property_read_u32(node, "utmi-mode", &utmi_mode);
 
@@ -414,7 +437,8 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 		dev_dbg(dev, "UNKNOWN utmi mode %d\n", utmi_mode);
 	}
 
-	dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS, reg);
+	dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS +
+					omap->utmi_otg_offset, reg);
 
 	/* check the DMA Status */
 	reg = dwc3_omap_readl(omap->base, USBOTGSS_SYSCONFIG);
@@ -481,7 +505,7 @@ static int dwc3_omap_suspend(struct device *dev)
 	struct dwc3_omap	*omap = dev_get_drvdata(dev);
 
 	omap->utmi_otg_status = dwc3_omap_readl(omap->base,
-			USBOTGSS_UTMI_OTG_STATUS);
+			USBOTGSS_UTMI_OTG_STATUS + omap->utmi_otg_offset);
 
 	return 0;
 }
@@ -490,8 +514,8 @@ static int dwc3_omap_resume(struct device *dev)
 {
 	struct dwc3_omap	*omap = dev_get_drvdata(dev);
 
-	dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS,
-			omap->utmi_otg_status);
+	dwc3_omap_writel(omap->base, USBOTGSS_UTMI_OTG_STATUS +
+				omap->utmi_otg_offset, omap->utmi_otg_status);
 
 	pm_runtime_disable(dev);
 	pm_runtime_set_active(dev);
-- 
1.8.1.4

