Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab3JNP2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:28:38 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:49805 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756963Ab3JNP0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:26:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, jackp@codeaurora.org, mgautam@codeaurora.org,
        dsegal@codeaurora.org, linux-usb@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v3 07/13] usb: phy: msm: Replace custom enum usb_mode_type with enum usb_dr_mode
Date: Mon, 14 Oct 2013 18:24:34 +0300
Message-Id: <1381764280-28420-8-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
References: <1381764280-28420-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 arch/arm/mach-msm/board-msm7x30.c |    2 +-
 arch/arm/mach-msm/board-qsd8x50.c |    2 +-
 drivers/usb/phy/phy-msm-usb.c     |   40 ++++++++++++++++++-------------------
 include/linux/usb/msm_hsusb.h     |   19 ++----------------
 4 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index 46de789..0c4c200 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -95,7 +95,7 @@ static int hsusb_phy_clk_reset(struct clk *phy_clk)
 
 static struct msm_otg_platform_data msm_otg_pdata = {
 	.phy_init_seq		= hsusb_phy_init_seq,
-	.mode                   = USB_PERIPHERAL,
+	.mode                   = USB_DR_MODE_PERIPHERAL,
 	.otg_control		= OTG_PHY_CONTROL,
 	.link_clk_reset		= hsusb_link_clk_reset,
 	.phy_clk_reset		= hsusb_phy_clk_reset,
diff --git a/arch/arm/mach-msm/board-qsd8x50.c b/arch/arm/mach-msm/board-qsd8x50.c
index 9169ec3..4c74861 100644
--- a/arch/arm/mach-msm/board-qsd8x50.c
+++ b/arch/arm/mach-msm/board-qsd8x50.c
@@ -116,7 +116,7 @@ static int hsusb_phy_clk_reset(struct clk *phy_clk)
 
 static struct msm_otg_platform_data msm_otg_pdata = {
 	.phy_init_seq		= hsusb_phy_init_seq,
-	.mode                   = USB_PERIPHERAL,
+	.mode                   = USB_DR_MODE_PERIPHERAL,
 	.otg_control		= OTG_PHY_CONTROL,
 	.link_clk_reset		= hsusb_link_clk_reset,
 	.phy_clk_reset		= hsusb_phy_clk_reset,
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 46800c0..2aca042 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -372,10 +372,10 @@ static int msm_otg_reset(struct usb_phy *phy)
 
 	if (pdata->otg_control == OTG_PHY_CONTROL) {
 		val = readl(USB_OTGSC);
-		if (pdata->mode == USB_OTG) {
+		if (pdata->mode == USB_DR_MODE_OTG) {
 			ulpi_val = ULPI_INT_IDGRD | ULPI_INT_SESS_VALID;
 			val |= OTGSC_IDIE | OTGSC_BSVIE;
-		} else if (pdata->mode == USB_PERIPHERAL) {
+		} else if (pdata->mode == USB_DR_MODE_PERIPHERAL) {
 			ulpi_val = ULPI_INT_SESS_VALID;
 			val |= OTGSC_BSVIE;
 		}
@@ -636,7 +636,7 @@ static int msm_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 	 * Fail host registration if this board can support
 	 * only peripheral configuration.
 	 */
-	if (motg->pdata->mode == USB_PERIPHERAL) {
+	if (motg->pdata->mode == USB_DR_MODE_PERIPHERAL) {
 		dev_info(otg->phy->dev, "Host mode is not supported\n");
 		return -ENODEV;
 	}
@@ -665,7 +665,7 @@ static int msm_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 	 * Kick the state machine work, if peripheral is not supported
 	 * or peripheral is already registered with us.
 	 */
-	if (motg->pdata->mode == USB_HOST || otg->gadget) {
+	if (motg->pdata->mode == USB_DR_MODE_HOST || otg->gadget) {
 		pm_runtime_get_sync(otg->phy->dev);
 		schedule_work(&motg->sm_work);
 	}
@@ -709,7 +709,7 @@ static int msm_otg_set_peripheral(struct usb_otg *otg,
 	 * Fail peripheral registration if this board can support
 	 * only host configuration.
 	 */
-	if (motg->pdata->mode == USB_HOST) {
+	if (motg->pdata->mode == USB_DR_MODE_HOST) {
 		dev_info(otg->phy->dev, "Peripheral mode is not supported\n");
 		return -ENODEV;
 	}
@@ -734,7 +734,7 @@ static int msm_otg_set_peripheral(struct usb_otg *otg,
 	 * Kick the state machine work, if host is not supported
 	 * or host is already registered with us.
 	 */
-	if (motg->pdata->mode == USB_PERIPHERAL || otg->host) {
+	if (motg->pdata->mode == USB_DR_MODE_PERIPHERAL || otg->host) {
 		pm_runtime_get_sync(otg->phy->dev);
 		schedule_work(&motg->sm_work);
 	}
@@ -1055,7 +1055,7 @@ static void msm_otg_init_sm(struct msm_otg *motg)
 	u32 otgsc = readl(USB_OTGSC);
 
 	switch (pdata->mode) {
-	case USB_OTG:
+	case USB_DR_MODE_OTG:
 		if (pdata->otg_control == OTG_PHY_CONTROL) {
 			if (otgsc & OTGSC_ID)
 				set_bit(ID, &motg->inputs);
@@ -1067,21 +1067,21 @@ static void msm_otg_init_sm(struct msm_otg *motg)
 			else
 				clear_bit(B_SESS_VLD, &motg->inputs);
 		} else if (pdata->otg_control == OTG_USER_CONTROL) {
-			if (pdata->default_mode == USB_HOST) {
-				clear_bit(ID, &motg->inputs);
-			} else if (pdata->default_mode == USB_PERIPHERAL) {
+			if (pdata->default_mode == USB_DR_MODE_PERIPHERAL) {
 				set_bit(ID, &motg->inputs);
 				set_bit(B_SESS_VLD, &motg->inputs);
+			} else if (pdata->default_mode == USB_DR_MODE_HOST) {
+				clear_bit(ID, &motg->inputs);
 			} else {
 				set_bit(ID, &motg->inputs);
 				clear_bit(B_SESS_VLD, &motg->inputs);
 			}
 		}
 		break;
-	case USB_HOST:
+	case USB_DR_MODE_HOST:
 		clear_bit(ID, &motg->inputs);
 		break;
-	case USB_PERIPHERAL:
+	case USB_DR_MODE_PERIPHERAL:
 		set_bit(ID, &motg->inputs);
 		if (otgsc & OTGSC_BSV)
 			set_bit(B_SESS_VLD, &motg->inputs);
@@ -1257,7 +1257,7 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 	char buf[16];
 	struct usb_otg *otg = motg->phy.otg;
 	int status = count;
-	enum usb_mode_type req_mode;
+	enum usb_dr_mode req_mode;
 
 	memset(buf, 0x00, sizeof(buf));
 
@@ -1267,18 +1267,18 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 	}
 
 	if (!strncmp(buf, "host", 4)) {
-		req_mode = USB_HOST;
+		req_mode = USB_DR_MODE_HOST;
 	} else if (!strncmp(buf, "peripheral", 10)) {
-		req_mode = USB_PERIPHERAL;
+		req_mode = USB_DR_MODE_PERIPHERAL;
 	} else if (!strncmp(buf, "none", 4)) {
-		req_mode = USB_NONE;
+		req_mode = USB_DR_MODE_UNKNOWN;
 	} else {
 		status = -EINVAL;
 		goto out;
 	}
 
 	switch (req_mode) {
-	case USB_NONE:
+	case USB_DR_MODE_UNKNOWN:
 		switch (otg->phy->state) {
 		case OTG_STATE_A_HOST:
 		case OTG_STATE_B_PERIPHERAL:
@@ -1289,7 +1289,7 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 			goto out;
 		}
 		break;
-	case USB_PERIPHERAL:
+	case USB_DR_MODE_PERIPHERAL:
 		switch (otg->phy->state) {
 		case OTG_STATE_B_IDLE:
 		case OTG_STATE_A_HOST:
@@ -1300,7 +1300,7 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 			goto out;
 		}
 		break;
-	case USB_HOST:
+	case USB_DR_MODE_HOST:
 		switch (otg->phy->state) {
 		case OTG_STATE_B_IDLE:
 		case OTG_STATE_B_PERIPHERAL:
@@ -1515,7 +1515,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, motg);
 	device_init_wakeup(&pdev->dev, 1);
 
-	if (motg->pdata->mode == USB_OTG &&
+	if (motg->pdata->mode == USB_DR_MODE_OTG &&
 			motg->pdata->otg_control == OTG_USER_CONTROL) {
 		ret = msm_otg_debugfs_init(motg);
 		if (ret)
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 8705b01..f9d512e 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -23,21 +23,6 @@
 #include <linux/clk.h>
 
 /**
- * Supported USB modes
- *
- * USB_PERIPHERAL       Only peripheral mode is supported.
- * USB_HOST             Only host mode is supported.
- * USB_OTG              OTG mode is supported.
- *
- */
-enum usb_mode_type {
-	USB_NONE = 0,
-	USB_PERIPHERAL,
-	USB_HOST,
-	USB_OTG,
-};
-
-/**
  * OTG control
  *
  * OTG_NO_CONTROL	Id/VBUS notifications not required. Useful in host
@@ -130,9 +115,9 @@ struct msm_otg_platform_data {
 	int *phy_init_seq;
 	void (*vbus_power)(bool on);
 	unsigned power_budget;
-	enum usb_mode_type mode;
+	enum usb_dr_mode mode;
 	enum otg_control_type otg_control;
-	enum usb_mode_type default_mode;
+	enum usb_dr_mode default_mode;
 	enum msm_usb_phy_type phy_type;
 	void (*setup_gpio)(enum usb_otg_state state);
 	char *pclk_src_name;
-- 
1.7.9.5

