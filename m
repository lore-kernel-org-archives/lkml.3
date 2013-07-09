Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3GIPsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:48:15 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:50713 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3GIPsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:48:06 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH v2 2/7] usb: phy: msm: Migrate to Managed Device Resource allocation
Date: Tue,  9 Jul 2013 18:47:08 +0300
Message-Id: <1373384833-18077-3-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
References: <1373384833-18077-1-git-send-email-iivanov@mm-sol.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

Use managed device resources to clean up the probe/remove
and get DT support for free.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 drivers/usb/phy/phy-msm-usb.c |   78 +++++++++++------------------------------
 1 file changed, 20 insertions(+), 58 deletions(-)

diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
index ab1b880..cc37f5e 100644
--- a/drivers/usb/phy/phy-msm-usb.c
+++ b/drivers/usb/phy/phy-msm-usb.c
@@ -1397,13 +1397,14 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	motg = kzalloc(sizeof(struct msm_otg), GFP_KERNEL);
+	motg = devm_kzalloc(&pdev->dev, sizeof(*motg), GFP_KERNEL);
 	if (!motg) {
 		dev_err(&pdev->dev, "unable to allocate msm_otg\n");
 		return -ENOMEM;
 	}
 
-	motg->phy.otg = kzalloc(sizeof(struct usb_otg), GFP_KERNEL);
+	motg->phy.otg = devm_kzalloc(&pdev->dev, sizeof(*motg->phy.otg),
+				     GFP_KERNEL);
 	if (!motg->phy.otg) {
 		dev_err(&pdev->dev, "unable to allocate msm_otg\n");
 		return -ENOMEM;
@@ -1413,18 +1414,16 @@ static int __init msm_otg_probe(struct platform_device *pdev)
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
 	clk_set_rate(motg->clk, 60000000);
 
@@ -1436,21 +1435,19 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	 * on pclk source
 	 */
 	 if (motg->pdata->pclk_src_name) {
-		motg->pclk_src = clk_get(&pdev->dev,
+		motg->pclk_src = devm_clk_get(&pdev->dev,
 			motg->pdata->pclk_src_name);
 		if (IS_ERR(motg->pclk_src))
-			goto put_clk;
+			return PTR_ERR(motg->pclk_src);
 		clk_set_rate(motg->pclk_src, INT_MAX);
 		clk_prepare_enable(motg->pclk_src);
 	} else
 		motg->pclk_src = ERR_PTR(-ENOENT);
 
-
-	motg->pclk = clk_get(&pdev->dev, "usb_hs_pclk");
+	motg->pclk = devm_clk_get(&pdev->dev, "usb_hs_pclk");
 	if (IS_ERR(motg->pclk)) {
 		dev_err(&pdev->dev, "failed to get usb_hs_pclk\n");
-		ret = PTR_ERR(motg->pclk);
-		goto put_pclk_src;
+		return PTR_ERR(motg->pclk);
 	}
 
 	/*
@@ -1458,30 +1455,27 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	 * clock is introduced to remove the dependency on AXI
 	 * bus frequency.
 	 */
-	motg->core_clk = clk_get(&pdev->dev, "usb_hs_core_clk");
+	motg->core_clk = devm_clk_get(&pdev->dev, "usb_hs_core_clk");
 	if (IS_ERR(motg->core_clk))
 		motg->core_clk = NULL;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get platform resource mem\n");
-		ret = -ENODEV;
-		goto put_core_clk;
+		return -ENODEV;
 	}
 
-	motg->regs = ioremap(res->start, resource_size(res));
+	motg->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (!motg->regs) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto put_core_clk;
+		return PTR_ERR(motg->regs);
 	}
 	dev_info(&pdev->dev, "OTG regs = %p\n", motg->regs);
 
 	motg->irq = platform_get_irq(pdev, 0);
-	if (!motg->irq) {
+	if (motg->irq < 0) {
 		dev_err(&pdev->dev, "platform_get_irq failed\n");
-		ret = -ENODEV;
-		goto free_regs;
+		return motg->irq;
 	}
 
 	clk_prepare_enable(motg->clk);
@@ -1490,7 +1484,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	ret = msm_hsusb_init_vddcx(motg, 1);
 	if (ret) {
 		dev_err(&pdev->dev, "hsusb vddcx configuration failed\n");
-		goto free_regs;
+		return ret;
 	}
 
 	ret = msm_hsusb_ldo_init(motg, 1);
@@ -1512,7 +1506,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 
 	INIT_WORK(&motg->sm_work, msm_otg_sm_work);
 	INIT_DELAYED_WORK(&motg->chg_work, msm_chg_detect_work);
-	ret = request_irq(motg->irq, msm_otg_irq, IRQF_SHARED,
+	ret = devm_request_irq(&pdev->dev, motg->irq, msm_otg_irq, IRQF_SHARED,
 					"msm_otg", motg);
 	if (ret) {
 		dev_err(&pdev->dev, "request irq failed\n");
@@ -1531,7 +1525,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	ret = usb_add_phy(&motg->phy, USB_PHY_TYPE_USB2);
 	if (ret) {
 		dev_err(&pdev->dev, "usb_add_phy failed\n");
-		goto free_irq;
+		goto disable_clks;
 	}
 
 	platform_set_drvdata(pdev, motg);
@@ -1549,8 +1543,6 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	return 0;
-free_irq:
-	free_irq(motg->irq, motg);
 disable_clks:
 	clk_disable_unprepare(motg->pclk);
 	clk_disable_unprepare(motg->clk);
@@ -1558,24 +1550,6 @@ ldo_exit:
 	msm_hsusb_ldo_init(motg, 0);
 vddcx_exit:
 	msm_hsusb_init_vddcx(motg, 0);
-free_regs:
-	iounmap(motg->regs);
-put_core_clk:
-	if (motg->core_clk)
-		clk_put(motg->core_clk);
-	clk_put(motg->pclk);
-put_pclk_src:
-	if (!IS_ERR(motg->pclk_src)) {
-		clk_disable_unprepare(motg->pclk_src);
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
 
@@ -1598,7 +1572,6 @@ static int msm_otg_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 
 	usb_remove_phy(phy);
-	free_irq(motg->irq, motg);
 
 	/*
 	 * Put PHY in low power mode.
@@ -1626,18 +1599,7 @@ static int msm_otg_remove(struct platform_device *pdev)
 	}
 	msm_hsusb_ldo_init(motg, 0);
 
-	iounmap(motg->regs);
 	pm_runtime_set_suspended(&pdev->dev);
-
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
 
-- 
1.7.9.5

