Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbaDVJ0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 05:26:50 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53451 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbaDVJVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 05:21:38 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v6 04/19] usb: phy: msm: Migrate to Managed Device Resource allocation
Date: Tue, 22 Apr 2014 12:20:23 +0300
Message-Id: <1398158438-21579-5-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Move memory, regulators, clocks and irq allocation to
devm_* variants. Properly check for valid clk handles.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c | 195 ++++++++++++++++--------------------------
 1 file changed, 75 insertions(+), 120 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index 6bae936..67cac96 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -63,27 +63,18 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 	int ret = 0;

 	if (init) {
-		motg->vddcx = regulator_get(motg->phy.dev, "HSUSB_VDDCX");
-		if (IS_ERR(motg->vddcx)) {
-			dev_err(motg->phy.dev, "unable to get hsusb vddcx\n");
-			return PTR_ERR(motg->vddcx);
-		}
-
 		ret = regulator_set_voltage(motg->vddcx,
 				USB_PHY_VDD_DIG_VOL_MIN,
 				USB_PHY_VDD_DIG_VOL_MAX);
 		if (ret) {
 			dev_err(motg->phy.dev, "unable to set the voltage "
 					"for hsusb vddcx\n");
-			regulator_put(motg->vddcx);
 			return ret;
 		}

 		ret = regulator_enable(motg->vddcx);
-		if (ret) {
+		if (ret)
 			dev_err(motg->phy.dev, "unable to enable hsusb vddcx\n");
-			regulator_put(motg->vddcx);
-		}
 	} else {
 		ret = regulator_set_voltage(motg->vddcx, 0,
 			USB_PHY_VDD_DIG_VOL_MAX);
@@ -93,8 +84,6 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 		ret = regulator_disable(motg->vddcx);
 		if (ret)
 			dev_err(motg->phy.dev, "unable to disable hsusb vddcx\n");
-
-		regulator_put(motg->vddcx);
 	}

 	return ret;
@@ -105,53 +94,38 @@ static int msm_hsusb_ldo_init(struct msm_otg *motg, int init)
 	int rc = 0;

 	if (init) {
-		motg->v3p3 = regulator_get(motg->phy.dev, "HSUSB_3p3");
-		if (IS_ERR(motg->v3p3)) {
-			dev_err(motg->phy.dev, "unable to get hsusb 3p3\n");
-			return PTR_ERR(motg->v3p3);
-		}
-
 		rc = regulator_set_voltage(motg->v3p3, USB_PHY_3P3_VOL_MIN,
 				USB_PHY_3P3_VOL_MAX);
 		if (rc) {
 			dev_err(motg->phy.dev, "unable to set voltage level "
 					"for hsusb 3p3\n");
-			goto put_3p3;
+			goto exit;
 		}
 		rc = regulator_enable(motg->v3p3);
 		if (rc) {
 			dev_err(motg->phy.dev, "unable to enable the hsusb 3p3\n");
-			goto put_3p3;
-		}
-		motg->v1p8 = regulator_get(motg->phy.dev, "HSUSB_1p8");
-		if (IS_ERR(motg->v1p8)) {
-			dev_err(motg->phy.dev, "unable to get hsusb 1p8\n");
-			rc = PTR_ERR(motg->v1p8);
-			goto disable_3p3;
+			goto exit;
 		}
 		rc = regulator_set_voltage(motg->v1p8, USB_PHY_1P8_VOL_MIN,
 				USB_PHY_1P8_VOL_MAX);
 		if (rc) {
 			dev_err(motg->phy.dev, "unable to set voltage level "
 					"for hsusb 1p8\n");
-			goto put_1p8;
+			goto disable_3p3;
 		}
 		rc = regulator_enable(motg->v1p8);
 		if (rc) {
 			dev_err(motg->phy.dev, "unable to enable the hsusb 1p8\n");
-			goto put_1p8;
+			goto disable_3p3;
 		}

 		return 0;
 	}

 	regulator_disable(motg->v1p8);
-put_1p8:
-	regulator_put(motg->v1p8);
 disable_3p3:
 	regulator_disable(motg->v3p3);
-put_3p3:
-	regulator_put(motg->v3p3);
+exit:
 	return rc;
 }

@@ -506,7 +480,7 @@ static int msm_otg_suspend(struct msm_otg *motg)

 	clk_disable_unprepare(motg->pclk);
 	clk_disable_unprepare(motg->clk);
-	if (motg->core_clk)
+	if (!IS_ERR(motg->core_clk))
 		clk_disable_unprepare(motg->core_clk);

 	if (!IS_ERR(motg->pclk_src))
@@ -546,7 +520,7 @@ static int msm_otg_resume(struct msm_otg *motg)

 	clk_prepare_enable(motg->pclk);
 	clk_prepare_enable(motg->clk);
-	if (motg->core_clk)
+	if (!IS_ERR(motg->core_clk))
 		clk_prepare_enable(motg->core_clk);

 	if (motg->pdata->phy_type == SNPS_28NM_INTEGRATED_PHY &&
@@ -1415,37 +1389,34 @@ static int msm_otg_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}

-	motg = kzalloc(sizeof(struct msm_otg), GFP_KERNEL);
+	motg = devm_kzalloc(&pdev->dev, sizeof(struct msm_otg), GFP_KERNEL);
 	if (!motg) {
 		dev_err(&pdev->dev, "unable to allocate msm_otg\n");
 		return -ENOMEM;
 	}

-	motg->phy.otg = kzalloc(sizeof(struct usb_otg), GFP_KERNEL);
+	motg->phy.otg = devm_kzalloc(&pdev->dev, sizeof(struct usb_otg),
+				     GFP_KERNEL);
 	if (!motg->phy.otg) {
 		dev_err(&pdev->dev, "unable to allocate msm_otg\n");
-		ret = -ENOMEM;
-		goto free_motg;
+		return -ENOMEM;
 	}

 	motg->pdata = dev_get_platdata(&pdev->dev);
 	phy = &motg->phy;
 	phy->dev = &pdev->dev;

-	motg->phy_reset_clk = clk_get(&pdev->dev, "usb_phy_clk");
+	motg->phy_reset_clk = devm_clk_get(&pdev->dev, "usb_phy_clk");
 	if (IS_ERR(motg->phy_reset_clk)) {
 		dev_err(&pdev->dev, "failed to get usb_phy_clk\n");
-		ret = PTR_ERR(motg->phy_reset_clk);
-		goto free_motg;
+		return PTR_ERR(motg->phy_reset_clk);
 	}

-	motg->clk = clk_get(&pdev->dev, "usb_hs_clk");
+	motg->clk = devm_clk_get(&pdev->dev, "usb_hs_clk");
 	if (IS_ERR(motg->clk)) {
 		dev_err(&pdev->dev, "failed to get usb_hs_clk\n");
-		ret = PTR_ERR(motg->clk);
-		goto put_phy_reset_clk;
+		return PTR_ERR(motg->clk);
 	}
-	clk_set_rate(motg->clk, 60000000);

 	/*
 	 * If USB Core is running its protocol engine based on CORE CLK,
@@ -1454,22 +1425,18 @@ static int msm_otg_probe(struct platform_device *pdev)
 	 * CORE CLK. For such USB cores, vote for maximum clk frequency
 	 * on pclk source
 	 */
+	 motg->pclk_src = ERR_PTR(-ENOENT);
 	 if (motg->pdata->pclk_src_name) {
-		motg->pclk_src = clk_get(&pdev->dev,
-			motg->pdata->pclk_src_name);
+		motg->pclk_src = devm_clk_get(&pdev->dev,
+					motg->pdata->pclk_src_name);
 		if (IS_ERR(motg->pclk_src))
-			goto put_clk;
-		clk_set_rate(motg->pclk_src, INT_MAX);
-		clk_prepare_enable(motg->pclk_src);
-	} else
-		motg->pclk_src = ERR_PTR(-ENOENT);
-
+			return PTR_ERR(motg->pclk_src);
+	}

-	motg->pclk = clk_get(&pdev->dev, "usb_hs_pclk");
+	motg->pclk = devm_clk_get(&pdev->dev, "usb_hs_pclk");
 	if (IS_ERR(motg->pclk)) {
 		dev_err(&pdev->dev, "failed to get usb_hs_pclk\n");
-		ret = PTR_ERR(motg->pclk);
-		goto put_pclk_src;
+		return PTR_ERR(motg->pclk);
 	}

 	/*
@@ -1477,65 +1444,78 @@ static int msm_otg_probe(struct platform_device *pdev)
 	 * clock is introduced to remove the dependency on AXI
 	 * bus frequency.
 	 */
-	motg->core_clk = clk_get(&pdev->dev, "usb_hs_core_clk");
-	if (IS_ERR(motg->core_clk))
-		motg->core_clk = NULL;
+	motg->core_clk = devm_clk_get(&pdev->dev, "usb_hs_core_clk");

 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get platform resource mem\n");
-		ret = -ENODEV;
-		goto put_core_clk;
-	}
+	motg->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (IS_ERR(motg->regs))
+		return PTR_ERR(motg->regs);

-	motg->regs = ioremap(res->start, resource_size(res));
-	if (!motg->regs) {
-		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto put_core_clk;
-	}
 	dev_info(&pdev->dev, "OTG regs = %p\n", motg->regs);

 	motg->irq = platform_get_irq(pdev, 0);
 	if (!motg->irq) {
 		dev_err(&pdev->dev, "platform_get_irq failed\n");
-		ret = -ENODEV;
-		goto free_regs;
+		return motg->irq;
+	}
+
+	motg->vddcx = devm_regulator_get(motg->phy.dev, "HSUSB_VDDCX");
+	if (IS_ERR(motg->vddcx)) {
+		dev_err(motg->phy.dev, "unable to get hsusb vddcx\n");
+		return PTR_ERR(motg->vddcx);
+	}
+
+	motg->v3p3 = devm_regulator_get(motg->phy.dev, "HSUSB_3p3");
+	if (IS_ERR(motg->v3p3)) {
+		dev_err(motg->phy.dev, "unable to get hsusb 3p3\n");
+		return PTR_ERR(motg->v3p3);
+	}
+
+	motg->v1p8 = devm_regulator_get(motg->phy.dev, "HSUSB_1p8");
+	if (IS_ERR(motg->v1p8)) {
+		dev_err(motg->phy.dev, "unable to get hsusb 1p8\n");
+		return PTR_ERR(motg->v1p8);
+	}
+
+	clk_set_rate(motg->clk, 60000000);
+	if (!IS_ERR(motg->pclk_src)) {
+		clk_set_rate(motg->pclk_src, INT_MAX);
+		clk_prepare_enable(motg->pclk_src);
 	}

 	clk_prepare_enable(motg->clk);
 	clk_prepare_enable(motg->pclk);

+	if (!IS_ERR(motg->core_clk))
+		clk_prepare_enable(motg->core_clk);
+
 	ret = msm_hsusb_init_vddcx(motg, 1);
 	if (ret) {
 		dev_err(&pdev->dev, "hsusb vddcx configuration failed\n");
-		goto free_regs;
+		goto disable_clks;
 	}

 	ret = msm_hsusb_ldo_init(motg, 1);
 	if (ret) {
 		dev_err(&pdev->dev, "hsusb vreg configuration failed\n");
-		goto vddcx_exit;
+		goto disable_vddcx;
 	}
 	ret = msm_hsusb_ldo_set_mode(motg, 1);
 	if (ret) {
 		dev_err(&pdev->dev, "hsusb vreg enable failed\n");
-		goto ldo_exit;
+		goto disable_ldo;
 	}

-	if (motg->core_clk)
-		clk_prepare_enable(motg->core_clk);
-
 	writel(0, USB_USBINTR);
 	writel(0, USB_OTGSC);

 	INIT_WORK(&motg->sm_work, msm_otg_sm_work);
 	INIT_DELAYED_WORK(&motg->chg_work, msm_chg_detect_work);
-	ret = request_irq(motg->irq, msm_otg_irq, IRQF_SHARED,
+	ret = devm_request_irq(&pdev->dev, motg->irq, msm_otg_irq, IRQF_SHARED,
 					"msm_otg", motg);
 	if (ret) {
 		dev_err(&pdev->dev, "request irq failed\n");
-		goto disable_clks;
+		goto disable_ldo;
 	}

 	phy->init = msm_otg_reset;
@@ -1550,7 +1530,7 @@ static int msm_otg_probe(struct platform_device *pdev)
 	ret = usb_add_phy(&motg->phy, USB_PHY_TYPE_USB2);
 	if (ret) {
 		dev_err(&pdev->dev, "usb_add_phy failed\n");
-		goto free_irq;
+		goto disable_ldo;
 	}

 	platform_set_drvdata(pdev, motg);
@@ -1568,33 +1548,18 @@ static int msm_otg_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);

 	return 0;
-free_irq:
-	free_irq(motg->irq, motg);
+
+disable_ldo:
+	msm_hsusb_ldo_init(motg, 0);
+disable_vddcx:
+	msm_hsusb_init_vddcx(motg, 0);
 disable_clks:
 	clk_disable_unprepare(motg->pclk);
 	clk_disable_unprepare(motg->clk);
-ldo_exit:
-	msm_hsusb_ldo_init(motg, 0);
-vddcx_exit:
-	msm_hsusb_init_vddcx(motg, 0);
-free_regs:
-	iounmap(motg->regs);
-put_core_clk:
-	if (motg->core_clk)
-		clk_put(motg->core_clk);
-	clk_put(motg->pclk);
-put_pclk_src:
-	if (!IS_ERR(motg->pclk_src)) {
+	if (!IS_ERR(motg->core_clk))
+		clk_disable_unprepare(motg->core_clk);
+	if (!IS_ERR(motg->pclk_src))
 		clk_disable_unprepare(motg->pclk_src);
-		clk_put(motg->pclk_src);
-	}
-put_clk:
-	clk_put(motg->clk);
-put_phy_reset_clk:
-	clk_put(motg->phy_reset_clk);
-free_motg:
-	kfree(motg->phy.otg);
-	kfree(motg);
 	return ret;
 }

@@ -1617,7 +1582,7 @@ static int msm_otg_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);

 	usb_remove_phy(phy);
-	free_irq(motg->irq, motg);
+	disable_irq(motg->irq);

 	/*
 	 * Put PHY in low power mode.
@@ -1637,26 +1602,15 @@ static int msm_otg_remove(struct platform_device *pdev)

 	clk_disable_unprepare(motg->pclk);
 	clk_disable_unprepare(motg->clk);
-	if (motg->core_clk)
+	if (!IS_ERR(motg->core_clk))
 		clk_disable_unprepare(motg->core_clk);
-	if (!IS_ERR(motg->pclk_src)) {
+	if (!IS_ERR(motg->pclk_src))
 		clk_disable_unprepare(motg->pclk_src);
-		clk_put(motg->pclk_src);
-	}
+
 	msm_hsusb_ldo_init(motg, 0);

-	iounmap(motg->regs);
 	pm_runtime_set_suspended(&pdev->dev);

-	clk_put(motg->phy_reset_clk);
-	clk_put(motg->pclk);
-	clk_put(motg->clk);
-	if (motg->core_clk)
-		clk_put(motg->core_clk);
-
-	kfree(motg->phy.otg);
-	kfree(motg);
-
 	return 0;
 }

@@ -1736,6 +1690,7 @@ static const struct dev_pm_ops msm_otg_dev_pm_ops = {
 };

 static struct platform_driver msm_otg_driver = {
+	.probe = msm_otg_probe,
 	.remove = msm_otg_remove,
 	.driver = {
 		.name = DRIVER_NAME,
@@ -1744,7 +1699,7 @@ static struct platform_driver msm_otg_driver = {
 	},
 };

-module_platform_driver_probe(msm_otg_driver, msm_otg_probe);
+module_platform_driver(msm_otg_driver);

 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("MSM USB transceiver driver");
--
1.8.3.2

