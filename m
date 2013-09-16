Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab3IPOw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:52:58 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:37144 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3IPOwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:52:54 -0400
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: josh.wu@atmel.com, dmitry.torokhov@gmail.com, badarkhe.manish@gmail.com
Subject: [PATCH] Input: atmel_tscadcc - update to devm_* API
Date: Mon, 16 Sep 2013 20:22:58 +0530
Message-Id: <1379343178-6468-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the code to use devm_* API so that driver core will manage
resources.

Signed-off-by: Manish Badarkhe <badarkhe.manish@gmail.com>
---
This is just clean up of code to manage resources using "devm_"
funtions. Not tested on hardware.

:100644 100644 bddabc5... 4ddf97c... M	drivers/input/touchscreen/atmel_tsadcc.c
 drivers/input/touchscreen/atmel_tsadcc.c |   53 ++++++++----------------------
 1 file changed, 13 insertions(+), 40 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_tsadcc.c b/drivers/input/touchscreen/atmel_tsadcc.c
index bddabc5..4ddf97c 100644
--- a/drivers/input/touchscreen/atmel_tsadcc.c
+++ b/drivers/input/touchscreen/atmel_tsadcc.c
@@ -197,53 +197,47 @@ static int atmel_tsadcc_probe(struct platform_device *pdev)
 	}
 
 	/* Allocate memory for device */
-	ts_dev = kzalloc(sizeof(struct atmel_tsadcc), GFP_KERNEL);
+	ts_dev = devm_kzalloc(&pdev->dev, sizeof(struct atmel_tsadcc),
+			      GFP_KERNEL);
 	if (!ts_dev) {
 		dev_err(&pdev->dev, "failed to allocate memory.\n");
 		return -ENOMEM;
 	}
 	platform_set_drvdata(pdev, ts_dev);
 
-	input_dev = input_allocate_device();
+	input_dev = devm_input_allocate_device(&pdev->dev);
 	if (!input_dev) {
 		dev_err(&pdev->dev, "failed to allocate input device.\n");
 		err = -EBUSY;
-		goto err_free_mem;
+		goto err_out;
 	}
 
 	ts_dev->irq = platform_get_irq(pdev, 0);
 	if (ts_dev->irq < 0) {
 		dev_err(&pdev->dev, "no irq ID is designated.\n");
 		err = -ENODEV;
-		goto err_free_dev;
+		goto err_out;
 	}
 
-	if (!request_mem_region(res->start, resource_size(res),
-				"atmel tsadcc regs")) {
-		dev_err(&pdev->dev, "resources is unavailable.\n");
-		err = -EBUSY;
-		goto err_free_dev;
-	}
-
-	tsc_base = ioremap(res->start, resource_size(res));
+	tsc_base = devm_ioremap_resource(&pdev->dev, res);
 	if (!tsc_base) {
 		dev_err(&pdev->dev, "failed to map registers.\n");
 		err = -ENOMEM;
-		goto err_release_mem;
+		goto err_out;
 	}
 
-	err = request_irq(ts_dev->irq, atmel_tsadcc_interrupt, 0,
-			pdev->dev.driver->name, ts_dev);
+	err = devm_request_irq(&pdev->dev, ts_dev->irq, atmel_tsadcc_interrupt,
+			       0, pdev->dev.driver->name, ts_dev);
 	if (err) {
 		dev_err(&pdev->dev, "failed to allocate irq.\n");
-		goto err_unmap_regs;
+		goto err_out;
 	}
 
-	ts_dev->clk = clk_get(&pdev->dev, "tsc_clk");
+	ts_dev->clk = devm_clk_get(&pdev->dev, "tsc_clk");
 	if (IS_ERR(ts_dev->clk)) {
 		dev_err(&pdev->dev, "failed to get ts_clk\n");
 		err = PTR_ERR(ts_dev->clk);
-		goto err_free_irq;
+		goto err_out;
 	}
 
 	ts_dev->input = input_dev;
@@ -309,37 +303,17 @@ static int atmel_tsadcc_probe(struct platform_device *pdev)
 
 err_fail:
 	clk_disable(ts_dev->clk);
-	clk_put(ts_dev->clk);
-err_free_irq:
-	free_irq(ts_dev->irq, ts_dev);
-err_unmap_regs:
-	iounmap(tsc_base);
-err_release_mem:
-	release_mem_region(res->start, resource_size(res));
-err_free_dev:
-	input_free_device(input_dev);
-err_free_mem:
-	kfree(ts_dev);
+err_out:
 	return err;
 }
 
 static int atmel_tsadcc_remove(struct platform_device *pdev)
 {
 	struct atmel_tsadcc *ts_dev = platform_get_drvdata(pdev);
-	struct resource *res;
-
-	free_irq(ts_dev->irq, ts_dev);
 
 	input_unregister_device(ts_dev->input);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	iounmap(tsc_base);
-	release_mem_region(res->start, resource_size(res));
-
 	clk_disable(ts_dev->clk);
-	clk_put(ts_dev->clk);
-
-	kfree(ts_dev);
 
 	return 0;
 }
@@ -356,4 +330,3 @@ module_platform_driver(atmel_tsadcc_driver);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Atmel TouchScreen Driver");
 MODULE_AUTHOR("Dan Liang <dan.liang@atmel.com>");
-
-- 
1.7.10.4

