Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3HaLD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:03:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39606 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3HaLDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:03:54 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:03:18 +0100
Message-Id: <1377947000-5746-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377947000-5746-1-git-send-email-broonie@kernel.org>
References: <1377947000-5746-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/4] regulator: wm831x-dcdc: Convert to devm_request_threaded_irq()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

devm guarantees that resources are freed in the opposite order to that
in which they are registered.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm831x-dcdc.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 8f62750..aca2fcb 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -532,8 +532,9 @@ static int wm831x_buckv_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
-	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
-				   IRQF_TRIGGER_RISING, dcdc->name, dcdc);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_dcdc_uv_irq,
+					IRQF_TRIGGER_RISING, dcdc->name, dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -541,21 +542,19 @@ static int wm831x_buckv_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "HC"));
-	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_oc_irq,
-				   IRQF_TRIGGER_RISING, dcdc->name, dcdc);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_dcdc_oc_irq,
+					IRQF_TRIGGER_RISING, dcdc->name, dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request HC IRQ %d: %d\n",
 			irq, ret);
-		goto err_uv;
+		goto err_regulator;
 	}
 
 	platform_set_drvdata(pdev, dcdc);
 
 	return 0;
 
-err_uv:
-	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV")),
-		 dcdc);
 err_regulator:
 	regulator_unregister(dcdc->regulator);
 err:
@@ -565,12 +564,7 @@ err:
 static int wm831x_buckv_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
-	struct wm831x *wm831x = dcdc->wm831x;
 
-	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "HC")),
-			    dcdc);
-	free_irq(wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV")),
-			    dcdc);
 	regulator_unregister(dcdc->regulator);
 
 	return 0;
@@ -688,8 +682,9 @@ static int wm831x_buckp_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
-	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
-				   IRQF_TRIGGER_RISING,	dcdc->name, dcdc);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_dcdc_uv_irq,
+					IRQF_TRIGGER_RISING, dcdc->name, dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -710,8 +705,6 @@ static int wm831x_buckp_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 
-	free_irq(wm831x_irq(dcdc->wm831x, platform_get_irq_byname(pdev, "UV")),
-			    dcdc);
 	regulator_unregister(dcdc->regulator);
 
 	return 0;
@@ -820,9 +813,10 @@ static int wm831x_boostp_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
-	ret = request_threaded_irq(irq, NULL, wm831x_dcdc_uv_irq,
-				   IRQF_TRIGGER_RISING, dcdc->name,
-				   dcdc);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_dcdc_uv_irq,
+					IRQF_TRIGGER_RISING, dcdc->name,
+					dcdc);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -843,8 +837,6 @@ static int wm831x_boostp_remove(struct platform_device *pdev)
 {
 	struct wm831x_dcdc *dcdc = platform_get_drvdata(pdev);
 
-	free_irq(wm831x_irq(dcdc->wm831x, platform_get_irq_byname(pdev, "UV")),
-		 dcdc);
 	regulator_unregister(dcdc->regulator);
 
 	return 0;
-- 
1.8.4.rc3

