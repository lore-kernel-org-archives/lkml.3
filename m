Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608Ab3HaLER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:04:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39621 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3HaLD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:03:57 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:03:20 +0100
Message-Id: <1377947000-5746-4-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377947000-5746-1-git-send-email-broonie@kernel.org>
References: <1377947000-5746-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 4/4] regulator: wm831x-ldo: Use devm_request_threaded_irq()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

devm guarantees that resources are freed in the oposite order to that in
which they are allocated.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm831x-ldo.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 1432b26..5570f3e 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -288,9 +288,10 @@ static int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
-	ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq,
-				   IRQF_TRIGGER_RISING, ldo->name,
-				   ldo);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_ldo_uv_irq,
+					IRQF_TRIGGER_RISING, ldo->name,
+					ldo);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -311,8 +312,6 @@ static int wm831x_gp_ldo_remove(struct platform_device *pdev)
 {
 	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
 
-	free_irq(wm831x_irq(ldo->wm831x,
-			    platform_get_irq_byname(pdev, "UV")), ldo);
 	regulator_unregister(ldo->regulator);
 
 	return 0;
@@ -514,8 +513,9 @@ static int wm831x_aldo_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq_byname(pdev, "UV"));
-	ret = request_threaded_irq(irq, NULL, wm831x_ldo_uv_irq,
-				   IRQF_TRIGGER_RISING, ldo->name, ldo);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_ldo_uv_irq,
+					IRQF_TRIGGER_RISING, ldo->name, ldo);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request UV IRQ %d: %d\n",
 			irq, ret);
@@ -536,8 +536,6 @@ static int wm831x_aldo_remove(struct platform_device *pdev)
 {
 	struct wm831x_ldo *ldo = platform_get_drvdata(pdev);
 
-	free_irq(wm831x_irq(ldo->wm831x, platform_get_irq_byname(pdev, "UV")),
-		 ldo);
 	regulator_unregister(ldo->regulator);
 
 	return 0;
-- 
1.8.4.rc3

