Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaJHGbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:31:13 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:50857 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750743AbaJHGbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:31:11 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH] Input: lpc32xx-keys: Switch to using managed resources
Date: Wed,  8 Oct 2014 12:04:41 +0530
Message-Id: <1412750081-11205-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change switches to using devm_* managed resources APIs to
request the resources in probe to simplify probe error path and
module unloading.

Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/input/keyboard/lpc32xx-keys.c |   86 +++++++++------------------------
 1 file changed, 23 insertions(+), 63 deletions(-)

diff --git a/drivers/input/keyboard/lpc32xx-keys.c b/drivers/input/keyboard/lpc32xx-keys.c
index 8b1b013..6e244df 100644
--- a/drivers/input/keyboard/lpc32xx-keys.c
+++ b/drivers/input/keyboard/lpc32xx-keys.c
@@ -188,32 +188,27 @@ static int lpc32xx_kscan_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	kscandat = kzalloc(sizeof(struct lpc32xx_kscan_drv), GFP_KERNEL);
-	if (!kscandat) {
-		dev_err(&pdev->dev, "failed to allocate memory\n");
+	kscandat = devm_kzalloc(&pdev->dev, sizeof(*kscandat),
+				GFP_KERNEL);
+	if (!kscandat)
 		return -ENOMEM;
-	}
 
 	error = lpc32xx_parse_dt(&pdev->dev, kscandat);
 	if (error) {
 		dev_err(&pdev->dev, "failed to parse device tree\n");
-		goto err_free_mem;
+		return error;
 	}
 
 	keymap_size = sizeof(kscandat->keymap[0]) *
 				(kscandat->matrix_sz << kscandat->row_shift);
-	kscandat->keymap = kzalloc(keymap_size, GFP_KERNEL);
-	if (!kscandat->keymap) {
-		dev_err(&pdev->dev, "could not allocate memory for keymap\n");
-		error = -ENOMEM;
-		goto err_free_mem;
-	}
+	kscandat->keymap = devm_kzalloc(&pdev->dev, keymap_size, GFP_KERNEL);
+	if (!kscandat->keymap)
+		return -ENOMEM;
 
-	kscandat->input = input = input_allocate_device();
+	kscandat->input = input = devm_input_allocate_device(&pdev->dev);
 	if (!input) {
 		dev_err(&pdev->dev, "failed to allocate input device\n");
-		error = -ENOMEM;
-		goto err_free_keymap;
+		return -ENOMEM;
 	}
 
 	/* Setup key input */
@@ -234,39 +229,37 @@ static int lpc32xx_kscan_probe(struct platform_device *pdev)
 					   kscandat->keymap, kscandat->input);
 	if (error) {
 		dev_err(&pdev->dev, "failed to build keymap\n");
-		goto err_free_input;
+		return error;
 	}
 
 	input_set_drvdata(kscandat->input, kscandat);
 
-	kscandat->iores = request_mem_region(res->start, resource_size(res),
-					     pdev->name);
+	kscandat->iores = devm_request_mem_region(&pdev->dev, res->start,
+						  resource_size(res),
+						  pdev->name);
 	if (!kscandat->iores) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
-		error = -EBUSY;
-		goto err_free_input;
+		return -EBUSY;
 	}
 
-	kscandat->kscan_base = ioremap(kscandat->iores->start,
+	kscandat->kscan_base = devm_ioremap(&pdev->dev, kscandat->iores->start,
 				       resource_size(kscandat->iores));
 	if (!kscandat->kscan_base) {
 		dev_err(&pdev->dev, "failed to remap I/O memory\n");
-		error = -EBUSY;
-		goto err_release_memregion;
+		return -EBUSY;
 	}
 
 	/* Get the key scanner clock */
-	kscandat->clk = clk_get(&pdev->dev, NULL);
+	kscandat->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(kscandat->clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
-		error = PTR_ERR(kscandat->clk);
-		goto err_unmap;
+		return PTR_ERR(kscandat->clk);
 	}
 
 	/* Configure the key scanner */
 	error = clk_prepare_enable(kscandat->clk);
 	if (error)
-		goto err_clk_put;
+		return error;
 
 	writel(kscandat->deb_clks, LPC32XX_KS_DEB(kscandat->kscan_base));
 	writel(kscandat->scan_delay, LPC32XX_KS_SCAN_CTL(kscandat->kscan_base));
@@ -277,52 +270,20 @@ static int lpc32xx_kscan_probe(struct platform_device *pdev)
 	writel(1, LPC32XX_KS_IRQ(kscandat->kscan_base));
 	clk_disable_unprepare(kscandat->clk);
 
-	error = request_irq(irq, lpc32xx_kscan_irq, 0, pdev->name, kscandat);
+	error = devm_request_irq(&pdev->dev, irq, lpc32xx_kscan_irq, 0,
+				 pdev->name, kscandat);
 	if (error) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		goto err_clk_put;
+		return error;
 	}
 
 	error = input_register_device(kscandat->input);
 	if (error) {
 		dev_err(&pdev->dev, "failed to register input device\n");
-		goto err_free_irq;
+		return error;
 	}
 
 	platform_set_drvdata(pdev, kscandat);
-	return 0;
-
-err_free_irq:
-	free_irq(irq, kscandat);
-err_clk_put:
-	clk_put(kscandat->clk);
-err_unmap:
-	iounmap(kscandat->kscan_base);
-err_release_memregion:
-	release_mem_region(kscandat->iores->start,
-			   resource_size(kscandat->iores));
-err_free_input:
-	input_free_device(kscandat->input);
-err_free_keymap:
-	kfree(kscandat->keymap);
-err_free_mem:
-	kfree(kscandat);
-
-	return error;
-}
-
-static int lpc32xx_kscan_remove(struct platform_device *pdev)
-{
-	struct lpc32xx_kscan_drv *kscandat = platform_get_drvdata(pdev);
-
-	free_irq(platform_get_irq(pdev, 0), kscandat);
-	clk_put(kscandat->clk);
-	iounmap(kscandat->kscan_base);
-	release_mem_region(kscandat->iores->start,
-			   resource_size(kscandat->iores));
-	input_unregister_device(kscandat->input);
-	kfree(kscandat->keymap);
-	kfree(kscandat);
 
 	return 0;
 }
@@ -378,7 +339,6 @@ MODULE_DEVICE_TABLE(of, lpc32xx_kscan_match);
 
 static struct platform_driver lpc32xx_kscan_driver = {
 	.probe		= lpc32xx_kscan_probe,
-	.remove		= lpc32xx_kscan_remove,
 	.driver		= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
-- 
1.7.9.5

