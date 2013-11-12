Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab3KLO4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 09:56:39 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:51909 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756067Ab3KLOyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 09:54:24 -0500
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, davidb@codeaurora.org,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        devicetree@vger.kernel.org
Subject: [PATCH v4 11/15] usb: phy: msm: Use reset framework for LINK and PHY resets
Date: Tue, 12 Nov 2013 16:51:46 +0200
Message-Id: <1384267910-32066-12-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: devicetree@vger.kernel.org
---
 .../devicetree/bindings/usb/msm-hsusb.txt          |    9 ++++++
 drivers/usb/phy/phy-msm-usb.c                      |   30 ++++++++++++++------
 include/linux/usb/msm_hsusb.h                      |    3 ++
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
index f1045e3..3f21204 100644
--- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
+++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
@@ -57,6 +57,12 @@ Required properties:
 - v1p8-supply:	phandle to the regulator for the 1.8V supply
 - v3p3-supply:	phandle to the regulator for the 3.3V supply
 
+- resets:		A list of phandle + reset-specifier pairs for the
+				resets listed in reset-names
+- reset-names:	Should contain the following:
+  "phy"			USB PHY controller reset
+  "link"		USB LINK controller reset
+
 - qcom,otg-control: OTG control (VBUS and ID notifications) can be one of
 				1 - PHY control
 				2 - PMIC control
@@ -83,6 +89,9 @@ Example HSUSB OTG controller device node:
 		v1p8-supply = <&pm8941_l6>;
 		v3p3-supply = <&pm8941_l24>;
 
+		resets = <&gcc GCC_USB2A_PHY_BCR>, <&gcc GCC_USB_HS_BCR>;
+		reset-names = "phy", "link";
+
 		qcom,otg-control = <1>;
 		qcom,phy-init-sequence = <0x01 0x90 0xffffffff>;
 	};
diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index cc230c8..53fc645 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -32,6 +32,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/reset.h>
 
 #include <linux/usb.h>
 #include <linux/usb/otg.h>
@@ -260,12 +261,16 @@ static void ulpi_init(struct msm_otg *motg)
 
 static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
 {
-	int ret = 0;
+	int ret;
 
-	if (!motg->pdata->link_clk_reset)
-		return ret;
+	if (motg->pdata->link_clk_reset)
+		ret = motg->pdata->link_clk_reset(motg->clk, assert);
+	else
+		if (assert)
+			ret = reset_control_assert(motg->link_rst);
+		else
+			ret = reset_control_deassert(motg->link_rst);
 
-	ret = motg->pdata->link_clk_reset(motg->clk, assert);
 	if (ret)
 		dev_err(motg->phy.dev, "usb link clk reset %s failed\n",
 			assert ? "assert" : "deassert");
@@ -275,12 +280,13 @@ static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
 
 static int msm_otg_phy_clk_reset(struct msm_otg *motg)
 {
-	int ret = 0;
+	int ret;
 
-	if (!motg->pdata->phy_clk_reset)
-		return ret;
+	if (motg->pdata->phy_clk_reset)
+		ret = motg->pdata->phy_clk_reset(motg->phy_reset_clk);
+	else
+		ret = reset_control_reset(motg->phy_rst);
 
-	ret = motg->pdata->phy_clk_reset(motg->phy_reset_clk);
 	if (ret)
 		dev_err(motg->phy.dev, "usb phy clk reset failed\n");
 
@@ -1373,6 +1379,14 @@ static int msm_otg_read_dt(struct platform_device *pdev, struct msm_otg *motg)
 	id = of_match_device(msm_otg_dt_match, &pdev->dev);
 	pdata->phy_type = (int) id->data;
 
+	motg->link_rst = devm_reset_control_get(&pdev->dev, "link");
+	if (IS_ERR(motg->link_rst))
+		return PTR_ERR(motg->link_rst);
+
+	motg->phy_rst = devm_reset_control_get(&pdev->dev, "phy");
+	if (IS_ERR(motg->phy_rst))
+		return PTR_ERR(motg->phy_rst);
+
 	pdata->mode = of_usb_get_dr_mode(node);
 	if (pdata->mode == USB_DR_MODE_UNKNOWN)
 		pdata->mode = USB_DR_MODE_OTG;
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 262ed80..9bf8943 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -163,6 +163,9 @@ struct msm_otg {
 	struct regulator *v3p3;
 	struct regulator *v1p8;
 	struct regulator *vddcx;
+
+	struct reset_control *phy_rst;
+	struct reset_control *link_rst;
 };
 
 #endif
-- 
1.7.9.5

