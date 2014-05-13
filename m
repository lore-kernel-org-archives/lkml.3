Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaEMBVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 21:21:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35083 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaEMBVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 21:21:51 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: berthe.ab@gmail.com, linus.walleij@linaro.org, gnurou@gmail.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: using devm functions for timberdale gpio memory allocation This eases memory allocation and provides appropriate logging
Date: Tue, 13 May 2014 03:21:42 +0200
Message-Id: <1399944102-9089-1-git-send-email-berthe.ab@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 drivers/gpio/gpio-timberdale.c | 47 ++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 31 deletions(-)

diff --git a/drivers/gpio/gpio-timberdale.c b/drivers/gpio/gpio-timberdale.c
index f9a8fbd..efc7c12 100644
--- a/drivers/gpio/gpio-timberdale.c
+++ b/drivers/gpio/gpio-timberdale.c
@@ -224,6 +224,7 @@ static struct irq_chip timbgpio_irqchip = {
 static int timbgpio_probe(struct platform_device *pdev)
 {
 	int err, i;
+	struct device *dev = &pdev->dev;
 	struct gpio_chip *gc;
 	struct timbgpio *tgpio;
 	struct resource *iomem;
@@ -231,35 +232,35 @@ static int timbgpio_probe(struct platform_device *pdev)
 	int irq = platform_get_irq(pdev, 0);
 
 	if (!pdata || pdata->nr_pins > 32) {
-		err = -EINVAL;
-		goto err_mem;
+		dev_err(dev, "Invalid platform data\n");
+		return -EINVAL;
 	}
 
 	iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!iomem) {
-		err = -EINVAL;
-		goto err_mem;
+		dev_err(dev, "Unable to get resource\n");
+		return -EINVAL;
 	}
 
-	tgpio = kzalloc(sizeof(*tgpio), GFP_KERNEL);
+	tgpio = devm_kzalloc(dev, sizeof(struct timbgpio), GFP_KERNEL);
 	if (!tgpio) {
-		err = -EINVAL;
-		goto err_mem;
+		dev_err(dev, "Memory alloc failed\n");
+		return -EINVAL;
 	}
 	tgpio->irq_base = pdata->irq_base;
 
 	spin_lock_init(&tgpio->lock);
 
-	if (!request_mem_region(iomem->start, resource_size(iomem),
-		DRIVER_NAME)) {
-		err = -EBUSY;
-		goto err_request;
+	if (!devm_request_mem_region(dev, iomem->start, resource_size(iomem),
+				     DRIVER_NAME)) {
+		dev_err(dev, "Region already claimed\n");
+		return -EBUSY;
 	}
 
-	tgpio->membase = ioremap(iomem->start, resource_size(iomem));
+	tgpio->membase = devm_ioremap(dev, iomem->start, resource_size(iomem));
 	if (!tgpio->membase) {
-		err = -ENOMEM;
-		goto err_ioremap;
+		dev_err(dev, "Cannot ioremap\n");
+		return -ENOMEM;
 	}
 
 	gc = &tgpio->gpio;
@@ -279,7 +280,7 @@ static int timbgpio_probe(struct platform_device *pdev)
 
 	err = gpiochip_add(gc);
 	if (err)
-		goto err_chipadd;
+		return err;
 
 	platform_set_drvdata(pdev, tgpio);
 
@@ -302,17 +303,6 @@ static int timbgpio_probe(struct platform_device *pdev)
 	irq_set_chained_handler(irq, timbgpio_irq);
 
 	return 0;
-
-err_chipadd:
-	iounmap(tgpio->membase);
-err_ioremap:
-	release_mem_region(iomem->start, resource_size(iomem));
-err_request:
-	kfree(tgpio);
-err_mem:
-	printk(KERN_ERR DRIVER_NAME": Failed to register GPIOs: %d\n", err);
-
-	return err;
 }
 
 static int timbgpio_remove(struct platform_device *pdev)
@@ -320,7 +310,6 @@ static int timbgpio_remove(struct platform_device *pdev)
 	int err;
 	struct timbgpio_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct timbgpio *tgpio = platform_get_drvdata(pdev);
-	struct resource *iomem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	int irq = platform_get_irq(pdev, 0);
 
 	if (irq >= 0 && tgpio->irq_base > 0) {
@@ -338,10 +327,6 @@ static int timbgpio_remove(struct platform_device *pdev)
 	if (err)
 		printk(KERN_ERR DRIVER_NAME": failed to remove gpio_chip\n");
 
-	iounmap(tgpio->membase);
-	release_mem_region(iomem->start, resource_size(iomem));
-	kfree(tgpio);
-
 	return 0;
 }
 
-- 
1.8.3.2

