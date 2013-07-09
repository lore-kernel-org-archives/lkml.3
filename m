Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab3GIPsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:48:17 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:50720 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab3GIPsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:48:07 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v2 3/7] usb: phy: msm: Move regulator usage to managed resource allocation
Date: Tue,  9 Jul 2013 18:47:09 +0300
Message-Id: <1373384833-18077-4-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

This patch move global regulators variables to driver state
structire and move allocation of the regulators to be devm managed.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |  111 +++++++++++++++++++----------------------
 include/linux/usb/msm_hsusb.h |    3 ++
 2 files changed, 53 insertions(+), 61 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index cc37f5e..8289270 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -58,47 +58,32 @@
 #define USB_PHY_VDD_DIG_VOL_MIN	1000000 /* uV */
 #define USB_PHY_VDD_DIG_VOL_MAX	1320000 /* uV */
 
-static struct regulator *hsusb_3p3;
-static struct regulator *hsusb_1p8;
-static struct regulator *hsusb_vddcx;
-
 static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 {
 	int ret = 0;
 
 	if (init) {
-		hsusb_vddcx = regulator_get(motg->phy.dev, "HSUSB_VDDCX");
-		if (IS_ERR(hsusb_vddcx)) {
-			dev_err(motg->phy.dev, "unable to get hsusb vddcx\n");
-			return PTR_ERR(hsusb_vddcx);
-		}
-
-		ret = regulator_set_voltage(hsusb_vddcx,
+		ret = regulator_set_voltage(motg->vddcx,
 				USB_PHY_VDD_DIG_VOL_MIN,
 				USB_PHY_VDD_DIG_VOL_MAX);
 		if (ret) {
 			dev_err(motg->phy.dev, "unable to set the voltage "
 					"for hsusb vddcx\n");
-			regulator_put(hsusb_vddcx);
 			return ret;
 		}
 
-		ret = regulator_enable(hsusb_vddcx);
-		if (ret) {
+		ret = regulator_enable(motg->vddcx);
+		if (ret)
 			dev_err(motg->phy.dev, "unable to enable hsusb vddcx\n");
-			regulator_put(hsusb_vddcx);
-		}
 	} else {
-		ret = regulator_set_voltage(hsusb_vddcx, 0,
+		ret = regulator_set_voltage(motg->vddcx, 0,
 			USB_PHY_VDD_DIG_VOL_MAX);
 		if (ret)
 			dev_err(motg->phy.dev, "unable to set the voltage "
 					"for hsusb vddcx\n");
-		ret = regulator_disable(hsusb_vddcx);
+		ret = regulator_disable(motg->vddcx);
 		if (ret)
 			dev_err(motg->phy.dev, "unable to disable hsusb vddcx\n");
-
-		regulator_put(hsusb_vddcx);
 	}
 
 	return ret;
@@ -109,59 +94,44 @@ static int msm_hsusb_ldo_init(struct msm_otg *motg, int init)
 	int rc = 0;
 
 	if (init) {
-		hsusb_3p3 = regulator_get(motg->phy.dev, "HSUSB_3p3");
-		if (IS_ERR(hsusb_3p3)) {
-			dev_err(motg->phy.dev, "unable to get hsusb 3p3\n");
-			return PTR_ERR(hsusb_3p3);
-		}
-
-		rc = regulator_set_voltage(hsusb_3p3, USB_PHY_3P3_VOL_MIN,
+		rc = regulator_set_voltage(motg->v3p3, USB_PHY_3P3_VOL_MIN,
 				USB_PHY_3P3_VOL_MAX);
 		if (rc) {
 			dev_err(motg->phy.dev, "unable to set voltage level "
 					"for hsusb 3p3\n");
-			goto put_3p3;
+			return rc;
 		}
-		rc = regulator_enable(hsusb_3p3);
+		rc = regulator_enable(motg->v3p3);
 		if (rc) {
 			dev_err(motg->phy.dev, "unable to enable the hsusb 3p3\n");
-			goto put_3p3;
-		}
-		hsusb_1p8 = regulator_get(motg->phy.dev, "HSUSB_1p8");
-		if (IS_ERR(hsusb_1p8)) {
-			dev_err(motg->phy.dev, "unable to get hsusb 1p8\n");
-			rc = PTR_ERR(hsusb_1p8);
-			goto disable_3p3;
+			return rc;
 		}
-		rc = regulator_set_voltage(hsusb_1p8, USB_PHY_1P8_VOL_MIN,
+
+		rc = regulator_set_voltage(motg->v1p8, USB_PHY_1P8_VOL_MIN,
 				USB_PHY_1P8_VOL_MAX);
 		if (rc) {
 			dev_err(motg->phy.dev, "unable to set voltage level "
 					"for hsusb 1p8\n");
-			goto put_1p8;
+			goto disable_3p3;
 		}
-		rc = regulator_enable(hsusb_1p8);
+		rc = regulator_enable(motg->v1p8);
 		if (rc) {
 			dev_err(motg->phy.dev, "unable to enable the hsusb 1p8\n");
-			goto put_1p8;
+			goto disable_3p3;
 		}
 
 		return 0;
 	}
 
-	regulator_disable(hsusb_1p8);
-put_1p8:
-	regulator_put(hsusb_1p8);
+	regulator_disable(motg->v1p8);
 disable_3p3:
-	regulator_disable(hsusb_3p3);
-put_3p3:
-	regulator_put(hsusb_3p3);
+	regulator_disable(motg->v3p3);
 	return rc;
 }
 
 #ifdef CONFIG_PM_SLEEP
 #define USB_PHY_SUSP_DIG_VOL  500000
-static int msm_hsusb_config_vddcx(int high)
+static int msm_hsusb_config_vddcx(struct msm_otg *motg, int high)
 {
 	int max_vol = USB_PHY_VDD_DIG_VOL_MAX;
 	int min_vol;
@@ -172,7 +142,7 @@ static int msm_hsusb_config_vddcx(int high)
 	else
 		min_vol = USB_PHY_SUSP_DIG_VOL;
 
-	ret = regulator_set_voltage(hsusb_vddcx, min_vol, max_vol);
+	ret = regulator_set_voltage(motg->vddcx, min_vol, max_vol);
 	if (ret) {
 		pr_err("%s: unable to set the voltage for regulator "
 			"HSUSB_VDDCX\n", __func__);
@@ -185,44 +155,44 @@ static int msm_hsusb_config_vddcx(int high)
 }
 #endif
 
-static int msm_hsusb_ldo_set_mode(int on)
+static int msm_hsusb_ldo_set_mode(struct msm_otg *motg, int on)
 {
 	int ret = 0;
 
-	if (!hsusb_1p8 || IS_ERR(hsusb_1p8)) {
+	if (!motg->v1p8 || IS_ERR(motg->v1p8)) {
 		pr_err("%s: HSUSB_1p8 is not initialized\n", __func__);
 		return -ENODEV;
 	}
 
-	if (!hsusb_3p3 || IS_ERR(hsusb_3p3)) {
+	if (!motg->v3p3 || IS_ERR(motg->v3p3)) {
 		pr_err("%s: HSUSB_3p3 is not initialized\n", __func__);
 		return -ENODEV;
 	}
 
 	if (on) {
-		ret = regulator_set_optimum_mode(hsusb_1p8,
+		ret = regulator_set_optimum_mode(motg->v1p8,
 				USB_PHY_1P8_HPM_LOAD);
 		if (ret < 0) {
 			pr_err("%s: Unable to set HPM of the regulator "
 				"HSUSB_1p8\n", __func__);
 			return ret;
 		}
-		ret = regulator_set_optimum_mode(hsusb_3p3,
+		ret = regulator_set_optimum_mode(motg->v3p3,
 				USB_PHY_3P3_HPM_LOAD);
 		if (ret < 0) {
 			pr_err("%s: Unable to set HPM of the regulator "
 				"HSUSB_3p3\n", __func__);
-			regulator_set_optimum_mode(hsusb_1p8,
+			regulator_set_optimum_mode(motg->v1p8,
 				USB_PHY_1P8_LPM_LOAD);
 			return ret;
 		}
 	} else {
-		ret = regulator_set_optimum_mode(hsusb_1p8,
+		ret = regulator_set_optimum_mode(motg->v1p8,
 				USB_PHY_1P8_LPM_LOAD);
 		if (ret < 0)
 			pr_err("%s: Unable to set LPM of the regulator "
 				"HSUSB_1p8\n", __func__);
-		ret = regulator_set_optimum_mode(hsusb_3p3,
+		ret = regulator_set_optimum_mode(motg->v3p3,
 				USB_PHY_3P3_LPM_LOAD);
 		if (ret < 0)
 			pr_err("%s: Unable to set LPM of the regulator "
@@ -491,8 +461,8 @@ static int msm_otg_suspend(struct msm_otg *motg)
 
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
 			motg->pdata->otg_control == OTG_PMIC_CONTROL) {
-		msm_hsusb_ldo_set_mode(0);
-		msm_hsusb_config_vddcx(0);
+		msm_hsusb_ldo_set_mode(motg, 0);
+		msm_hsusb_config_vddcx(motg, 0);
 	}
 
 	if (device_may_wakeup(phy->dev))
@@ -528,8 +498,8 @@ static int msm_otg_resume(struct msm_otg *motg)
 
 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
 			motg->pdata->otg_control == OTG_PMIC_CONTROL) {
-		msm_hsusb_ldo_set_mode(1);
-		msm_hsusb_config_vddcx(1);
+		msm_hsusb_ldo_set_mode(motg, 1);
+		msm_hsusb_config_vddcx(motg, 1);
 		writel(readl(USB_PHY_CTRL) & ~PHY_RETEN, USB_PHY_CTRL);
 	}
 
@@ -1478,6 +1448,24 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		return motg->irq;
 	}
 
+	motg->v3p3 = devm_regulator_get(&pdev->dev, "HSUSB_3p3");
+	if (IS_ERR(motg->v3p3)) {
+		dev_err(motg->phy.dev, "unable to get hsusb 3p3\n");
+		return PTR_ERR(motg->v3p3);
+	}
+
+	motg->v1p8 = devm_regulator_get(&pdev->dev, "HSUSB_1p8");
+	if (IS_ERR(motg->v1p8)) {
+		dev_err(motg->phy.dev, "unable to get hsusb 1p8\n");
+		return PTR_ERR(motg->v1p8);
+	}
+
+	motg->vddcx = devm_regulator_get(&pdev->dev, "HSUSB_VDDCX");
+	if (IS_ERR(motg->vddcx)) {
+		dev_err(motg->phy.dev, "unable to get hsusb vddcx\n");
+		return PTR_ERR(motg->vddcx);
+	}
+
 	clk_prepare_enable(motg->clk);
 	clk_prepare_enable(motg->pclk);
 
@@ -1492,7 +1480,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "hsusb vreg configuration failed\n");
 		goto vddcx_exit;
 	}
-	ret = msm_hsusb_ldo_set_mode(1);
+	ret = msm_hsusb_ldo_set_mode(motg, 1);
 	if (ret) {
 		dev_err(&pdev->dev, "hsusb vreg enable failed\n");
 		goto ldo_exit;
@@ -1598,6 +1586,7 @@ static int msm_otg_remove(struct platform_device *pdev)
 		clk_put(motg->pclk_src);
 	}
 	msm_hsusb_ldo_init(motg, 0);
+	msm_hsusb_init_vddcx(motg, 0);
 
 	pm_runtime_set_suspended(&pdev->dev);
 	return 0;
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 66081ed..e01f7d4 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -182,6 +182,9 @@ struct msm_otg {
 	enum usb_chg_state chg_state;
 	enum usb_chg_type chg_type;
 	u8 dcd_retries;
+	struct regulator *v3p3;
+	struct regulator *v1p8;
+	struct regulator *vddcx;
 };
 
 #endif
-- 
1.7.9.5

