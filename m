Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaKKRT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 12:19:26 -0500
Received: from mail-by2on0083.outbound.protection.outlook.com ([207.46.100.83]:49862
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751952AbaKKRSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 12:18:07 -0500
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv7 5/8] usb: dwc2: Update common interrupt handler to call gadget interrupt handler
Date: Tue, 11 Nov 2014 11:13:37 -0600
Message-ID: <1415726020-19238-6-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
References: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR07CA079.namprd07.prod.outlook.com (25.160.24.34) To
 CY1PR0301MB1196.namprd03.prod.outlook.com (25.160.165.27)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-Forefront-PRVS: 0392679D18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(64706001)(20776003)(47776003)(66066001)(53416004)(33646002)(40100003)(101416001)(50466002)(48376002)(122386002)(97736003)(42186005)(102836001)(50226001)(4396001)(105586002)(107046002)(19580395003)(19580405001)(95666004)(21056001)(229853001)(106356001)(86152002)(88136002)(92726001)(104166001)(31966008)(62966003)(87976001)(92566001)(77096003)(87286001)(77156002)(99396003)(89996001)(46102003)(69596002)(120916001)(81156004)(93916002)(86362001)(50986999)(76176999);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1196;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1196;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Make dwc2_handle_common_intr call the gadget interrupt function when operating
in peripheral mode. Remove the spinlock functions in s3c_hsotg_irq as
dwc2_handle_common_intr() already has the spinlocks.

Move the registeration of the IRQ to common code for platform and PCI.

Remove duplicate interrupt conditions that was in gadget, as those are handled
by dwc2 common interrupt handler.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
v7: Use IRQF_SHARED
v5: remove individual devm_request_irq from gadget and hcd, and place a
    single devm_request_irq in platform and pci.
v2: Keep interrupt handler for host and peripheral modes separate
---
 drivers/usb/dwc2/core.c     | 10 ----------
 drivers/usb/dwc2/gadget.c   | 46 +++------------------------------------------
 drivers/usb/dwc2/pci.c      |  6 ++++++
 drivers/usb/dwc2/platform.c |  8 ++++++++
 4 files changed, 17 insertions(+), 53 deletions(-)

diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
index d926945..7605850b 100644
--- a/drivers/usb/dwc2/core.c
+++ b/drivers/usb/dwc2/core.c
@@ -458,16 +458,6 @@ int dwc2_core_init(struct dwc2_hsotg *hsotg, bool select_phy, int irq)
 	/* Clear the SRP success bit for FS-I2c */
 	hsotg->srp_success = 0;
 
-	if (irq >= 0) {
-		dev_dbg(hsotg->dev, "registering common handler for irq%d\n",
-			irq);
-		retval = devm_request_irq(hsotg->dev, irq,
-					  dwc2_handle_common_intr, IRQF_SHARED,
-					  dev_name(hsotg->dev), hsotg);
-		if (retval)
-			return retval;
-	}
-
 	/* Enable common interrupts */
 	dwc2_enable_common_interrupts(hsotg);
 
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index ec85340..37c7916 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2285,33 +2285,12 @@ irq_retry:
 
 	gintsts &= gintmsk;
 
-	if (gintsts & GINTSTS_OTGINT) {
-		u32 otgint = readl(hsotg->regs + GOTGINT);
-
-		dev_info(hsotg->dev, "OTGInt: %08x\n", otgint);
-
-		writel(otgint, hsotg->regs + GOTGINT);
-	}
-
-	if (gintsts & GINTSTS_SESSREQINT) {
-		dev_dbg(hsotg->dev, "%s: SessReqInt\n", __func__);
-		writel(GINTSTS_SESSREQINT, hsotg->regs + GINTSTS);
-	}
-
 	if (gintsts & GINTSTS_ENUMDONE) {
 		writel(GINTSTS_ENUMDONE, hsotg->regs + GINTSTS);
 
 		s3c_hsotg_irq_enumdone(hsotg);
 	}
 
-	if (gintsts & GINTSTS_CONIDSTSCHNG) {
-		dev_dbg(hsotg->dev, "ConIDStsChg (DSTS=0x%08x, GOTCTL=%08x)\n",
-			readl(hsotg->regs + DSTS),
-			readl(hsotg->regs + GOTGCTL));
-
-		writel(GINTSTS_CONIDSTSCHNG, hsotg->regs + GINTSTS);
-	}
-
 	if (gintsts & (GINTSTS_OEPINT | GINTSTS_IEPINT)) {
 		u32 daint = readl(hsotg->regs + DAINT);
 		u32 daintmsk = readl(hsotg->regs + DAINTMSK);
@@ -2392,25 +2371,6 @@ irq_retry:
 		s3c_hsotg_handle_rx(hsotg);
 	}
 
-	if (gintsts & GINTSTS_MODEMIS) {
-		dev_warn(hsotg->dev, "warning, mode mismatch triggered\n");
-		writel(GINTSTS_MODEMIS, hsotg->regs + GINTSTS);
-	}
-
-	if (gintsts & GINTSTS_USBSUSP) {
-		dev_info(hsotg->dev, "GINTSTS_USBSusp\n");
-		writel(GINTSTS_USBSUSP, hsotg->regs + GINTSTS);
-
-		call_gadget(hsotg, suspend);
-	}
-
-	if (gintsts & GINTSTS_WKUPINT) {
-		dev_info(hsotg->dev, "GINTSTS_WkUpIn\n");
-		writel(GINTSTS_WKUPINT, hsotg->regs + GINTSTS);
-
-		call_gadget(hsotg, resume);
-	}
-
 	if (gintsts & GINTSTS_ERLYSUSP) {
 		dev_dbg(hsotg->dev, "GINTSTS_ErlySusp\n");
 		writel(GINTSTS_ERLYSUSP, hsotg->regs + GINTSTS);
@@ -3510,14 +3470,14 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 	s3c_hsotg_hw_cfg(hsotg);
 	s3c_hsotg_init(hsotg);
 
-	ret = devm_request_irq(dev, irq, s3c_hsotg_irq, 0,
-				dev_name(dev), hsotg);
+	ret = devm_request_irq(hsotg->dev, irq, s3c_hsotg_irq, IRQF_SHARED,
+				dev_name(hsotg->dev), hsotg);
 	if (ret < 0) {
 		s3c_hsotg_phy_disable(hsotg);
 		clk_disable_unprepare(hsotg->clk);
 		regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
 				       hsotg->supplies);
-		dev_err(dev, "cannot claim IRQ\n");
+		dev_err(dev, "cannot claim IRQ for gadget\n");
 		goto err_clk;
 	}
 
diff --git a/drivers/usb/dwc2/pci.c b/drivers/usb/dwc2/pci.c
index 6d33ecf..a4e724b 100644
--- a/drivers/usb/dwc2/pci.c
+++ b/drivers/usb/dwc2/pci.c
@@ -141,6 +141,12 @@ static int dwc2_driver_probe(struct pci_dev *dev,
 
 	pci_set_master(dev);
 
+	retval = devm_request_irq(hsotg->dev, dev->irq,
+				  dwc2_handle_common_intr, IRQF_SHARED,
+				  dev_name(hsotg->dev), hsotg);
+	if (retval)
+		return retval;
+
 	spin_lock_init(&hsotg->lock);
 	retval = dwc2_hcd_init(hsotg, dev->irq, &dwc2_module_params);
 	if (retval) {
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index b94867b..3552602 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -196,6 +196,14 @@ static int dwc2_driver_probe(struct platform_device *dev)
 		return irq;
 	}
 
+	dev_dbg(hsotg->dev, "registering common handler for irq%d\n",
+		irq);
+	retval = devm_request_irq(hsotg->dev, irq,
+				  dwc2_handle_common_intr, IRQF_SHARED,
+				  dev_name(hsotg->dev), hsotg);
+	if (retval)
+		return retval;
+
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	hsotg->regs = devm_ioremap_resource(&dev->dev, res);
 	if (IS_ERR(hsotg->regs))
-- 
2.0.3

