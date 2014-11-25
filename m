Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaKYNQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:16:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44863 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbaKYNQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:16:22 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
CC: <peter.chen@freescale.com>, <sojka@merica.cz>, <mathias.nyman@intel.com>,
        <balbi@ti.com>, <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <kgene.kim@samsung.com>,
        <ben-linux@fluff.org>, <linux@arm.linux.org.uk>,
        <galak@codeaurora.org>, <ijc+devicetree@hellion.org.uk>,
        <mark.rutland@arm.com>, <pawel.moll@arm.com>, <robh+dt@kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 10/19] usb: dwc3: core: Adapt to named interrupts
Date: Tue, 25 Nov 2014 18:41:46 +0530
Message-ID: <1416921115-10467-11-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
References: <1416921115-10467-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

Add support to use interrupt names,

Following are the interrupt names

Peripheral Interrupt - peripheral
HOST Interrupt - host
OTG Interrupt - otg

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/dwc3/core.c | 12 ++++++++++++
 drivers/usb/dwc3/core.h |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index fadd767..dbd5589 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -760,6 +760,18 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc->xhci_resources[1].flags = res->flags;
 	dwc->xhci_resources[1].name = res->name;
 
+	dwc->otg_irq = platform_get_irq_byname(pdev, "otg");
+	if (!dwc->otg_irq)
+		dev_err(dev, "missing OTG IRQ\n");
+
+	dwc->gadget_irq = platform_get_irq_byname(pdev, "peripheral");
+	if (!dwc->gadget_irq)
+		dev_err(dev, "missing peripheral IRQ\n");
+
+	dwc->xhci_irq = platform_get_irq_byname(pdev, "host");
+	if (!dwc->xhci_irq)
+		dev_err(dev, "missing HOST IRQ\n");
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(dev, "missing memory resource\n");
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 6b38223..7c5ae37 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -651,6 +651,9 @@ struct dwc3_scratchpad_array {
  * @maximum_speed: maximum speed requested (mainly for testing purposes)
  * @revision: revision register contents
  * @dr_mode: requested mode of operation
+ * @xhci_irq: IRQ number for XHCI IRQs
+ * @gadget_irq: IRQ number for Peripheral IRQs
+ * @otg_irq: IRQ number for OTG IRQs
  * @usb2_phy: pointer to USB2 PHY
  * @usb3_phy: pointer to USB3 PHY
  * @usb2_generic_phy: pointer to USB2 PHY
@@ -747,6 +750,10 @@ struct dwc3 {
 
 	enum usb_dr_mode	dr_mode;
 
+	int			gadget_irq;
+	int			xhci_irq;
+	int			otg_irq;
+
 	/* used for suspend/resume */
 	u32			dcfg;
 	u32			gctl;
-- 
1.8.3.1

