Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaJ1X36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 19:29:58 -0400
Received: from mail-bn1bon0080.outbound.protection.outlook.com ([157.56.111.80]:23072
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754790AbaJ1X3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 19:29:54 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <swarren@wwwdotorg.org>,
        <b.zolnierkie@samsung.com>, <matthijs@stdin.nl>,
        <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv6 6/8] usb: dwc2: gadget: Do not fail probe if there isn't a clock node
Date: Tue, 28 Oct 2014 18:25:47 -0500
Message-ID: <1414538749-14735-7-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR12CA0019.namprd12.prod.outlook.com (25.160.137.29) To
 DM2PR0301MB1198.namprd03.prod.outlook.com (25.160.217.148)
X-MS-Exchange-Transport-FromEntityHeader: Hosted
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1198;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(122386002)(105586002)(33646002)(95666004)(102836001)(101416001)(53416004)(77156001)(77096002)(50226001)(120916001)(106356001)(229853001)(104166001)(107046002)(80022003)(50986999)(81156004)(69596002)(76176999)(46102003)(92566001)(85852003)(99396003)(4396001)(50466002)(19580405001)(19580395003)(76482002)(62966002)(85306004)(66066001)(97736003)(86362001)(89996001)(48376002)(86152002)(87286001)(20776003)(87976001)(21056001)(88136002)(40100003)(93916002)(92726001)(47776003)(42186005)(64706001)(31966008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1198;H:linux-builds1.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
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
index ec70862..48120c8 100644
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

