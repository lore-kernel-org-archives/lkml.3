Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3HaLaF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:30:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40142 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756531Ab3HaLaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:30:02 -0400
From: Mark Brown <broonie@kernel.org>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:29:21 +0100
Message-Id: <1377948564-8383-6-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377948564-8383-1-git-send-email-broonie@kernel.org>
References: <1377948564-8383-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 06/11] regulator: wm831x-dcdc: Convert to devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm831x-dcdc.c | 66 ++++++++---------------------------------
 1 file changed, 12 insertions(+), 54 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index aca2fcb..6823e6f 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -523,7 +523,8 @@ static int wm831x_buckv_probe(struct platform_device *pdev)
 	config.driver_data = dcdc;
 	config.regmap = wm831x->regmap;
 
-	dcdc->regulator = regulator_register(&dcdc->desc, &config);
+	dcdc->regulator = devm_regulator_register(&pdev->dev, &dcdc->desc,
+						  &config);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
@@ -538,7 +539,7 @@ static int wm831x_buckv_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
-		goto err_regulator;
+		goto err;
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "HC"));
@@ -548,31 +549,19 @@ static int wm831x_buckv_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request HC IRQ %d: %d\n",
 			irq, ret);
-		goto err_regulator;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, dcdc);
 
 	return 0;
 
-err_regulator:
-	regulator_unregister(dcdc->regulator);
 err:
 	return ret;
 }
 
-static int wm831x_buckv_remove(struct platform_device *pdev)
-{
-	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-
-	regulator_unregister(dcdc->regulator);
-
-	return 0;
-}
-
 static struct platform_driver wm831x_buckv_driver = {
 	.probe = wm831x_buckv_probe,
-	.remove = wm831x_buckv_remove,
 	.driver		= {
 		.name	= "wm831x-buckv",
 		.owner	= THIS_MODULE,
@@ -673,7 +662,8 @@ static int wm831x_buckp_probe(struct platform_device *pdev)
 	config.driver_data = dcdc;
 	config.regmap = wm831x->regmap;
 
-	dcdc->regulator = regulator_register(&dcdc->desc, &config);
+	dcdc->regulator = devm_regulator_register(&pdev->dev, &dcdc->desc,
+						  &config);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
@@ -688,31 +678,19 @@ static int wm831x_buckp_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
-		goto err_regulator;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, dcdc);
 
 	return 0;
 
-err_regulator:
-	regulator_unregister(dcdc->regulator);
 err:
 	return ret;
 }
 
-static int wm831x_buckp_remove(struct platform_device *pdev)
-{
-	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-
-	regulator_unregister(dcdc->regulator);
-
-	return 0;
-}
-
 static struct platform_driver wm831x_buckp_driver = {
 	.probe = wm831x_buckp_probe,
-	.remove = wm831x_buckp_remove,
 	.driver		= {
 		.name	= "wm831x-buckp",
 		.owner	= THIS_MODULE,
@@ -804,7 +782,8 @@ static int wm831x_boostp_probe(struct platform_device *pdev)
 	config.driver_data = dcdc;
 	config.regmap = wm831x->regmap;
 
-	dcdc->regulator = regulator_register(&dcdc->desc, &config);
+	dcdc->regulator = devm_regulator_register(&pdev->dev, &dcdc->desc,
+						  &config);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register DCDC%d: %d\n",
@@ -820,31 +799,19 @@ static int wm831x_boostp_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
-		goto err_regulator;
+		goto err;
 	}
 
 	platform_set_drvdata(pdev, dcdc);
 
 	return 0;
 
-err_regulator:
-	regulator_unregister(dcdc->regulator);
 err:
 	return ret;
 }
 
-static int wm831x_boostp_remove(struct platform_device *pdev)
-{
-	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-
-	regulator_unregister(dcdc->regulator);
-
-	return 0;
-}
-
 static struct platform_driver wm831x_boostp_driver = {
 	.probe = wm831x_boostp_probe,
-	.remove = wm831x_boostp_remove,
 	.driver		= {
 		.name	= "wm831x-boostp",
 		.owner	= THIS_MODULE,
@@ -904,7 +871,8 @@ static int wm831x_epe_probe(struct platform_device *pdev)
 	config.driver_data = dcdc;
 	config.regmap = wm831x->regmap;
 
-	dcdc->regulator = regulator_register(&dcdc->desc, &config);
+	dcdc->regulator = devm_regulator_register(&pdev->dev, &dcdc->desc,
+						  &config);
 	if (IS_ERR(dcdc->regulator)) {
 		ret = PTR_ERR(dcdc->regulator);
 		dev_err(wm831x->dev, "Failed to register EPE%d: %d\n",
@@ -920,18 +888,8 @@ err:
 	return ret;
 }
 
-static int wm831x_epe_remove(struct platform_device *pdev)
-{
-	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-
-	regulator_unregister(dcdc->regulator);
-
-	return 0;
-}
-
 static struct platform_driver wm831x_epe_driver = {
 	.probe = wm831x_epe_probe,
-	.remove = wm831x_epe_remove,
 	.driver		= {
 		.name	= "wm831x-epe",
 		.owner	= THIS_MODULE,
-- 
1.8.4.rc3

