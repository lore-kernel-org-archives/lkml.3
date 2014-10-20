Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbaJTS5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:57:16 -0400
Received: from mail-bn1bon0084.outbound.protection.outlook.com ([157.56.111.84]:35808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752521AbaJTS5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:57:10 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv5 6/7] usb: dwc2: gadget: Do not fail probe if there isn't a clock node
Date: Mon, 20 Oct 2014 13:52:05 -0500
Message-ID: <1413831126-24193-7-git-send-email-dinguyen@opensource.altera.com>
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
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(95666004)(20776003)(105586002)(88136002)(21056001)(102836001)(77096002)(97736003)(80022003)(99396003)(31966008)(107046002)(77156001)(106356001)(229853001)(81156004)(42186005)(76482002)(46102003)(66066001)(64706001)(120916001)(47776003)(53416004)(40100003)(33646002)(87976001)(93916002)(62966002)(86362001)(122386002)(19580405001)(19580395003)(50466002)(69596002)(87286001)(4396001)(104166001)(50226001)(86152002)(92726001)(92566001)(48376002)(50986999)(76176999)(85306004)(101416001)(85852003)(89996001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

Since the dwc2 hcd driver is currently not looking for a clock node during
init, we should not completely fail if there isn't a clock provided.
For dual-role mode, we will only fail init for a non-clock node error. We
then update the HCD to only call gadget funtions if there is a proper clock
node.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
---
v5: reworked to not access gadget functions from the hcd.
---
 drivers/usb/dwc2/core.h      |  3 +--
 drivers/usb/dwc2/core_intr.c |  9 ++++++---
 drivers/usb/dwc2/hcd.c       |  3 ++-
 drivers/usb/dwc2/platform.c  | 19 +++++++++++++++----
 4 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index ba488ec..8794c08 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -660,6 +660,7 @@ struct dwc2_hsotg {
 #endif
 #endif /* CONFIG_USB_DWC2_HOST || CONFIG_USB_DWC2_DUAL_ROLE */
 
+	struct clk *clk;
 #if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
 	/* Gadget structures */
 	struct usb_gadget_driver *driver;
@@ -667,8 +668,6 @@ struct dwc2_hsotg {
 	struct usb_phy *uphy;
 	struct s3c_hsotg_plat *plat;
 
-	struct clk *clk;
-
 	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
 
 	u32 phyif;
diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index 1240875..1608037 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -339,7 +339,8 @@ static void dwc2_handle_wakeup_detected_intr(struct dwc2_hsotg *hsotg)
 		}
 		/* Change to L0 state */
 		hsotg->lx_state = DWC2_L0;
-		call_gadget(hsotg, resume);
+		if (!IS_ERR(hsotg->clk))
+			call_gadget(hsotg, resume);
 	} else {
 		if (hsotg->lx_state != DWC2_L1) {
 			u32 pcgcctl = readl(hsotg->regs + PCGCTL);
@@ -400,7 +401,8 @@ static void dwc2_handle_usb_suspend_intr(struct dwc2_hsotg *hsotg)
 			"DSTS.Suspend Status=%d HWCFG4.Power Optimize=%d\n",
 			!!(dsts & DSTS_SUSPSTS),
 			hsotg->hw_params.power_optimized);
-		call_gadget(hsotg, suspend);
+		if (!IS_ERR(hsotg->clk))
+			call_gadget(hsotg, suspend);
 	} else {
 		if (hsotg->op_state == OTG_STATE_A_PERIPHERAL) {
 			dev_dbg(hsotg->dev, "a_peripheral->a_host\n");
@@ -477,7 +479,8 @@ irqreturn_t dwc2_handle_common_intr(int irq, void *dev)
 	spin_lock(&hsotg->lock);
 
 	if (dwc2_is_device_mode(hsotg))
-		retval = s3c_hsotg_irq(irq, dev);
+		if (!IS_ERR(hsotg->clk))
+			retval = s3c_hsotg_irq(irq, dev);
 
 	gintsts = dwc2_read_common_intr(hsotg);
 	if (gintsts & ~GINTSTS_PRTINT)
diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 44c609f..fa49c72 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -1371,7 +1371,8 @@ static void dwc2_conn_id_status_change(struct work_struct *work)
 		hsotg->op_state = OTG_STATE_B_PERIPHERAL;
 		dwc2_core_init(hsotg, false, -1);
 		dwc2_enable_global_interrupts(hsotg);
-		s3c_hsotg_core_init(hsotg);
+		if (!IS_ERR(hsotg->clk))
+			s3c_hsotg_core_init(hsotg);
 	} else {
 		/* A-Device connector (Host Mode) */
 		dev_dbg(hsotg->dev, "connId A\n");
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 72f32f7..77c8417 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -217,8 +217,17 @@ static int dwc2_driver_probe(struct platform_device *dev)
 
 	spin_lock_init(&hsotg->lock);
 	retval = dwc2_gadget_init(hsotg, irq);
-	if (retval)
-		return retval;
+	if (retval) {
+		/*
+		 * We will not fail the driver initialization for dual-role
+		 * if no clock node is supplied. However, all gadget
+		 * functionality will be disabled if a clock node is not
+		 * provided. Host functionality will continue.
+		 * TO-DO: make clock node a requirement for the HCD.
+		 */
+		if (!IS_ERR(hsotg->clk))
+			return retval;
+	}
 	retval = dwc2_hcd_init(hsotg, irq, params);
 	if (retval)
 		return retval;
@@ -234,7 +243,8 @@ static int dwc2_suspend(struct device *dev)
 	int ret = 0;
 
 	if (dwc2_is_device_mode(dwc2))
-		ret = s3c_hsotg_suspend(dwc2);
+		if (!IS_ERR(dwc2->clk))
+			ret = s3c_hsotg_suspend(dwc2);
 	return ret;
 }
 
@@ -244,7 +254,8 @@ static int dwc2_resume(struct device *dev)
 	int ret = 0;
 
 	if (dwc2_is_device_mode(dwc2))
-		ret = s3c_hsotg_resume(dwc2);
+		if (!IS_ERR(dwc2->clk))
+			ret = s3c_hsotg_resume(dwc2);
 
 	return ret;
 }
-- 
2.0.3

