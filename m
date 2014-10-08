Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaJHKqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:46:40 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:40545 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092AbaJHKqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:46:38 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH] Input: pxa27x_keypad: Switch to using managed resources
Date: Wed,  8 Oct 2014 16:20:11 +0530
Message-Id: <1412765411-6480-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change switches to using devm_* APIs to allocate  resources.
This helps to simplify failure path in probe function and module
unloading and does away with remove function.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/keyboard/pxa27x_keypad.c |   69 +++++++++-----------------------
 1 file changed, 18 insertions(+), 51 deletions(-)

diff --git a/drivers/input/keyboard/pxa27x_keypad.c b/drivers/input/keyboard/pxa27x_keypad.c
index a15063b..719e44e 100644
--- a/drivers/input/keyboard/pxa27x_keypad.c
+++ b/drivers/input/keyboard/pxa27x_keypad.c
@@ -19,6 +19,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/input.h>
 #include <linux/device.h>
 #include <linux/platform_device.h>
@@ -741,37 +742,36 @@ static int pxa27x_keypad_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	keypad = kzalloc(sizeof(struct pxa27x_keypad), GFP_KERNEL);
-	input_dev = input_allocate_device();
+	keypad = devm_kzalloc(&pdev->dev, sizeof(*keypad),
+			      GFP_KERNEL);
+	input_dev = devm_input_allocate_device(&pdev->dev);
 	if (!keypad || !input_dev) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
-		error = -ENOMEM;
-		goto failed_free;
+		return -ENOMEM;
 	}
 
 	keypad->pdata = pdata;
 	keypad->input_dev = input_dev;
 	keypad->irq = irq;
 
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
+	res = devm_request_mem_region(&pdev->dev, res->start,
+				      resource_size(res), pdev->name);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		error = -EBUSY;
-		goto failed_free;
+		return -EBUSY;
 	}
 
-	keypad->mmio_base = ioremap(res->start, resource_size(res));
+	keypad->mmio_base = devm_ioremap(&pdev->dev, res->start,
+					 resource_size(res));
 	if (keypad->mmio_base == NULL) {
 		dev_err(&pdev->dev, "failed to remap I/O memory\n");
-		error = -ENXIO;
-		goto failed_free_mem;
+		return -ENXIO;
 	}
 
-	keypad->clk = clk_get(&pdev->dev, NULL);
+	keypad->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(keypad->clk)) {
 		dev_err(&pdev->dev, "failed to get keypad clock\n");
-		error = PTR_ERR(keypad->clk);
-		goto failed_free_io;
+		return PTR_ERR(keypad->clk);
 	}
 
 	input_dev->name = pdev->name;
@@ -802,7 +802,7 @@ static int pxa27x_keypad_probe(struct platform_device *pdev)
 	}
 	if (error) {
 		dev_err(&pdev->dev, "failed to build keycode\n");
-		goto failed_put_clk;
+		return error;
 	}
 
 	keypad->row_shift = get_count_order(pdata->matrix_key_cols);
@@ -812,56 +812,24 @@ static int pxa27x_keypad_probe(struct platform_device *pdev)
 		input_dev->evbit[0] |= BIT_MASK(EV_REL);
 	}
 
-	error = request_irq(irq, pxa27x_keypad_irq_handler, 0,
-			    pdev->name, keypad);
+	error = devm_request_irq(&pdev->dev, irq, pxa27x_keypad_irq_handler,
+				 0, pdev->name, keypad);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
-		goto failed_put_clk;
+		return error;
 	}
 
 	/* Register the input device */
 	error = input_register_device(input_dev);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register input device\n");
-		goto failed_free_irq;
+		return error;
 	}
 
 	platform_set_drvdata(pdev, keypad);
 	device_init_wakeup(&pdev->dev, 1);
 
 	return 0;
-
-failed_free_irq:
-	free_irq(irq, keypad);
-failed_put_clk:
-	clk_put(keypad->clk);
-failed_free_io:
-	iounmap(keypad->mmio_base);
-failed_free_mem:
-	release_mem_region(res->start, resource_size(res));
-failed_free:
-	input_free_device(input_dev);
-	kfree(keypad);
-	return error;
-}
-
-static int pxa27x_keypad_remove(struct platform_device *pdev)
-{
-	struct pxa27x_keypad *keypad = platform_get_drvdata(pdev);
-	struct resource *res;
-
-	free_irq(keypad->irq, keypad);
-	clk_put(keypad->clk);
-
-	input_unregister_device(keypad->input_dev);
-	iounmap(keypad->mmio_base);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	kfree(keypad);
-
-	return 0;
 }
 
 /* work with hotplug and coldplug */
@@ -877,7 +845,6 @@ MODULE_DEVICE_TABLE(of, pxa27x_keypad_dt_match);
 
 static struct platform_driver pxa27x_keypad_driver = {
 	.probe		= pxa27x_keypad_probe,
-	.remove		= pxa27x_keypad_remove,
 	.driver		= {
 		.name	= "pxa27x-keypad",
 		.of_match_table = of_match_ptr(pxa27x_keypad_dt_match),
-- 
1.7.9.5

