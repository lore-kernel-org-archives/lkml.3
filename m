Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaJHKrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:47:11 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:50593 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932106AbaJHKqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:46:55 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH] Input: nomadik-ske-keypad: Switch to using managed resources
Date: Wed,  8 Oct 2014 16:20:28 +0530
Message-Id: <1412765428-6517-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change switches to using devm_* APIs to allocate  resources.
This helps to simplify failure path in probe function as well as
remove function.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/keyboard/nomadik-ske-keypad.c |   63 +++++++++------------------
 1 file changed, 20 insertions(+), 43 deletions(-)

diff --git a/drivers/input/keyboard/nomadik-ske-keypad.c b/drivers/input/keyboard/nomadik-ske-keypad.c
index 63332e2..95ac317 100644
--- a/drivers/input/keyboard/nomadik-ske-keypad.c
+++ b/drivers/input/keyboard/nomadik-ske-keypad.c
@@ -247,12 +247,11 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	keypad = kzalloc(sizeof(struct ske_keypad), GFP_KERNEL);
+	keypad = devm_kzalloc(&pdev->dev, sizeof(*keypad), GFP_KERNEL);
 	input = input_allocate_device();
 	if (!keypad || !input) {
 		dev_err(&pdev->dev, "failed to allocate keypad memory\n");
-		error = -ENOMEM;
-		goto err_free_mem;
+		return -ENOMEM;
 	}
 
 	keypad->irq = irq;
@@ -260,31 +259,29 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 	keypad->input = input;
 	spin_lock_init(&keypad->ske_keypad_lock);
 
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+				     resource_size(res), pdev->name)) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		error = -EBUSY;
-		goto err_free_mem;
+		return -EBUSY;
 	}
 
-	keypad->reg_base = ioremap(res->start, resource_size(res));
+	keypad->reg_base = devm_ioremap(&pdev->dev, res->start,
+					resource_size(res));
 	if (!keypad->reg_base) {
 		dev_err(&pdev->dev, "failed to remap I/O memory\n");
-		error = -ENXIO;
-		goto err_free_mem_region;
+		return -ENXIO;
 	}
 
-	keypad->pclk = clk_get(&pdev->dev, "apb_pclk");
+	keypad->pclk = devm_clk_get(&pdev->dev, "apb_pclk");
 	if (IS_ERR(keypad->pclk)) {
 		dev_err(&pdev->dev, "failed to get pclk\n");
-		error = PTR_ERR(keypad->pclk);
-		goto err_iounmap;
+		return PTR_ERR(keypad->pclk);
 	}
 
-	keypad->clk = clk_get(&pdev->dev, NULL);
+	keypad->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(keypad->clk)) {
 		dev_err(&pdev->dev, "failed to get clk\n");
-		error = PTR_ERR(keypad->clk);
-		goto err_pclk;
+		return PTR_ERR(keypad->clk);
 	}
 
 	input->id.bustype = BUS_HOST;
@@ -296,7 +293,7 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 					   keypad->keymap, input);
 	if (error) {
 		dev_err(&pdev->dev, "Failed to build keymap\n");
-		goto err_clk;
+		return error;
 	}
 
 	input_set_capability(input, EV_MSC, MSC_SCAN);
@@ -306,7 +303,7 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 	error = clk_prepare_enable(keypad->pclk);
 	if (error) {
 		dev_err(&pdev->dev, "Failed to prepare/enable pclk\n");
-		goto err_clk;
+		return error;
 	}
 
 	error = clk_prepare_enable(keypad->clk);
@@ -326,8 +323,9 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 		goto err_clk_disable;
 	}
 
-	error = request_threaded_irq(keypad->irq, NULL, ske_keypad_irq,
-				     IRQF_ONESHOT, "ske-keypad", keypad);
+	error = devm_request_threaded_irq(&pdev->dev, keypad->irq, NULL,
+					  ske_keypad_irq, IRQF_ONESHOT,
+					  "ske-keypad", keypad);
 	if (error) {
 		dev_err(&pdev->dev, "allocate irq %d failed\n", keypad->irq);
 		goto err_clk_disable;
@@ -337,7 +335,7 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 	if (error) {
 		dev_err(&pdev->dev,
 				"unable to register input device: %d\n", error);
-		goto err_free_irq;
+		goto err_clk_disable;
 	}
 
 	if (plat->wakeup_enable)
@@ -347,45 +345,24 @@ static int __init ske_keypad_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_free_irq:
-	free_irq(keypad->irq, keypad);
 err_clk_disable:
 	clk_disable_unprepare(keypad->clk);
 err_pclk_disable:
 	clk_disable_unprepare(keypad->pclk);
-err_clk:
-	clk_put(keypad->clk);
-err_pclk:
-	clk_put(keypad->pclk);
-err_iounmap:
-	iounmap(keypad->reg_base);
-err_free_mem_region:
-	release_mem_region(res->start, resource_size(res));
-err_free_mem:
-	input_free_device(input);
-	kfree(keypad);
+
 	return error;
 }
 
 static int ske_keypad_remove(struct platform_device *pdev)
 {
 	struct ske_keypad *keypad = platform_get_drvdata(pdev);
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	free_irq(keypad->irq, keypad);
-
-	input_unregister_device(keypad->input);
 
 	clk_disable_unprepare(keypad->clk);
-	clk_put(keypad->clk);
+	clk_disable_unprepare(keypad->pclk);
 
 	if (keypad->board->exit)
 		keypad->board->exit();
 
-	iounmap(keypad->reg_base);
-	release_mem_region(res->start, resource_size(res));
-	kfree(keypad);
-
 	return 0;
 }
 
-- 
1.7.9.5

