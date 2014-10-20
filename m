Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945AbaJTS47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:56:59 -0400
Received: from mail-by2on0082.outbound.protection.outlook.com ([207.46.100.82]:13725
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360AbaJTS4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:56:55 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv5 4/7] usb: dwc2: Update common interrupt handler to call gadget interrupt handler
Date: Mon, 20 Oct 2014 13:52:03 -0500
Message-ID: <1413831126-24193-5-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR03CA014.apcprd03.prod.outlook.com (10.141.119.24) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(95666004)(20776003)(105586002)(88136002)(21056001)(102836001)(77096002)(97736003)(80022003)(99396003)(31966008)(107046002)(77156001)(106356001)(229853001)(81156004)(42186005)(76482002)(46102003)(66066001)(64706001)(120916001)(47776003)(53416004)(40100003)(33646002)(87976001)(93916002)(62966002)(575784001)(86362001)(122386002)(19580405001)(19580395003)(50466002)(69596002)(87286001)(4396001)(104166001)(50226001)(86152002)(92726001)(92566001)(48376002)(50986999)(76176999)(85306004)(101416001)(85852003)(89996001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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
Acked-by: Paul Zimmerman <paulz@synopsys.com>
---
v5: remove individual devm_request_irq from gadget and hcd, and place a
    single devm_request_irq in platform and pci.
v2: Keep interrupt handler for host and peripheral modes separate
---
 drivers/usb/dwc2/core.c      | 10 --------
 drivers/usb/dwc2/core.h      |  3 +++
 drivers/usb/dwc2/core_intr.c |  3 +++
 drivers/usb/dwc2/gadget.c    | 57 ++------------------------------------------
 drivers/usb/dwc2/pci.c       |  6 +++++
 drivers/usb/dwc2/platform.c  |  9 +++++++
 6 files changed, 23 insertions(+), 65 deletions(-)

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
 
diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index de1f357..ba488ec 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -967,6 +967,7 @@ extern int s3c_hsotg_suspend(struct dwc2_hsotg *dwc2);
 extern int s3c_hsotg_resume(struct dwc2_hsotg *dwc2);
 extern int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq);
 extern void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2);
+irqreturn_t s3c_hsotg_irq(int irq, void *pw);
 #else
 static inline int s3c_hsotg_remove(struct dwc2_hsotg *dwc2)
 { return 0; }
@@ -977,6 +978,8 @@ static inline int s3c_hsotg_resume(struct dwc2_hsotg *dwc2)
 static inline int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 { return 0; }
 static inline void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2) {}
+static inline irqreturn_t s3c_hsotg_irq(int irq, void *pw)
+{ return IRQ_HANDLED; }
 #endif
 
 #if IS_ENABLED(CONFIG_USB_DWC2_HOST) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index b176c2f..b0c14e0 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -474,6 +474,9 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
 
 	spin_lock(&hsotg->lock);
 
+	if (dwc2_is_device_mode(hsotg))
+		retval = s3c_hsotg_irq(irq, dev);
+
 	gintsts = dwc2_read_common_intr(hsotg);
 	if (gintsts & ~GINTSTS_PRTINT)
 		retval = IRQ_HANDLED;
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 6793ca8..6ffbfc2 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2257,14 +2257,13 @@ void s3c_hsotg_core_init(struct dwc2_hsotg *hsotg)
  * @irq: The IRQ number triggered
  * @pw: The pw value when registered the handler.
  */
-static irqreturn_t s3c_hsotg_irq(int irq, void *pw)
+irqreturn_t s3c_hsotg_irq(int irq, void *pw)
 {
 	struct dwc2_hsotg *hsotg = pw;
 	int retry_count = 8;
 	u32 gintsts;
 	u32 gintmsk;
 
-	spin_lock(&hsotg->lock);
 irq_retry:
 	gintsts = readl(hsotg->regs + GINTSTS);
 	gintmsk = readl(hsotg->regs + GINTMSK);
@@ -2274,33 +2273,12 @@ irq_retry:
 
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
@@ -2381,25 +2359,6 @@ irq_retry:
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
@@ -2435,10 +2394,9 @@ irq_retry:
 	if (gintsts & IRQ_RETRY_MASK && --retry_count > 0)
 			goto irq_retry;
 
-	spin_unlock(&hsotg->lock);
-
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL(s3c_hsotg_irq);
 
 /**
  * s3c_hsotg_ep_enable - enable the given endpoint
@@ -3491,17 +3449,6 @@ int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 	s3c_hsotg_hw_cfg(hsotg);
 	s3c_hsotg_init(hsotg);
 
-	ret = devm_request_irq(dev, irq, s3c_hsotg_irq, 0,
-				dev_name(dev), hsotg);
-	if (ret < 0) {
-		s3c_hsotg_phy_disable(hsotg);
-		clk_disable_unprepare(hsotg->clk);
-		regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
-				       hsotg->supplies);
-		dev_err(dev, "cannot claim IRQ\n");
-		goto err_clk;
-	}
-
 	/* hsotg->num_of_eps holds number of EPs other than ep0 */
 
 	if (hsotg->num_of_eps == 0) {
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
index 5783ed0..72f32f7 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -196,6 +196,15 @@ static int dwc2_driver_probe(struct platform_device *dev)
 		return irq;
 	}
 
+	dev_dbg(hsotg->dev, "registering common handler for irq%d\n",
+		irq);
+
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

