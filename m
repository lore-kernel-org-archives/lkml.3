Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab3C0GFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 02:05:21 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:62767 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab3C0GFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 02:05:19 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, Magnus Damm <magnus.damm@gmail.com>,
        horms@verge.net.au, linus.walleij@linaro.org, linux-sh@vger.kernel.org
Date: Wed, 27 Mar 2013 15:11:14 +0900
Message-Id: <20130327061114.3356.57465.sendpatchset@w520>
Subject: [PATCH] gpio: em: Make use of devm functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the Emma Mobile GPIO driver to make use of devm
functions. This simplifies the error handling and makes
the code more compact.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Applies to linux-next tag next-20130327, written on top of:
 [PATCH] gpio: em: Add Device Tree support

 drivers/gpio/gpio-em.c |   53 +++++++++++++++++-------------------------------
 1 file changed, 19 insertions(+), 34 deletions(-)

--- 0002/drivers/gpio/gpio-em.c
+++ work/drivers/gpio/gpio-em.c	2013-03-13 18:52:14.000000000 +0900
@@ -245,7 +245,7 @@ static int em_gio_probe(struct platform_
 	const char *name = dev_name(&pdev->dev);
 	int ret;
 
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	if (!p) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		ret = -ENOMEM;
@@ -264,21 +264,23 @@ static int em_gio_probe(struct platform_
 	if (!io[0] || !io[1] || !irq[0] || !irq[1]) {
 		dev_err(&pdev->dev, "missing IRQ or IOMEM\n");
 		ret = -EINVAL;
-		goto err1;
+		goto err0;
 	}
 
-	p->base0 = ioremap_nocache(io[0]->start, resource_size(io[0]));
+	p->base0 = devm_ioremap_nocache(&pdev->dev, io[0]->start,
+					resource_size(io[0]));
 	if (!p->base0) {
 		dev_err(&pdev->dev, "failed to remap low I/O memory\n");
 		ret = -ENXIO;
-		goto err1;
+		goto err0;
 	}
 
-	p->base1 = ioremap_nocache(io[1]->start, resource_size(io[1]));
+	p->base1 = devm_ioremap_nocache(&pdev->dev, io[1]->start,
+				   resource_size(io[1]));
 	if (!p->base1) {
 		dev_err(&pdev->dev, "failed to remap high I/O memory\n");
 		ret = -ENXIO;
-		goto err2;
+		goto err0;
 	}
 
 	if (!pdata) {
@@ -289,13 +291,13 @@ static int em_gio_probe(struct platform_
 					 &pdata->number_of_pins)) {
 			dev_err(&pdev->dev, "Missing ngpios OF property\n");
 			ret = -EINVAL;
-			goto err3;
+			goto err0;
 		}
 
 		ret = of_alias_get_id(pdev->dev.of_node, "gpio");
 		if (ret < 0) {
 			dev_err(&pdev->dev, "Couldn't get OF id\n");
-			goto err3;
+			goto err0;
 		}
 		pdata->gpio_base = ret * 32; /* 32 GPIOs per instance */
 	}
@@ -327,40 +329,32 @@ static int em_gio_probe(struct platform_
 	if (!p->irq_domain) {
 		ret = -ENXIO;
 		dev_err(&pdev->dev, "cannot initialize irq domain\n");
-		goto err3;
+		goto err0;
 	}
 
-	if (request_irq(irq[0]->start, em_gio_irq_handler, 0, name, p)) {
+	if (devm_request_irq(&pdev->dev, irq[0]->start,
+			     em_gio_irq_handler, 0, name, p)) {
 		dev_err(&pdev->dev, "failed to request low IRQ\n");
 		ret = -ENOENT;
-		goto err4;
+		goto err1;
 	}
 
-	if (request_irq(irq[1]->start, em_gio_irq_handler, 0, name, p)) {
+	if (devm_request_irq(&pdev->dev, irq[1]->start,
+			     em_gio_irq_handler, 0, name, p)) {
 		dev_err(&pdev->dev, "failed to request high IRQ\n");
 		ret = -ENOENT;
-		goto err5;
+		goto err1;
 	}
 
 	ret = gpiochip_add(gpio_chip);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add GPIO controller\n");
-		goto err6;
+		goto err1;
 	}
 	return 0;
 
-err6:
-	free_irq(irq[1]->start, pdev);
-err5:
-	free_irq(irq[0]->start, pdev);
-err4:
-	irq_domain_remove(p->irq_domain);
-err3:
-	iounmap(p->base1);
-err2:
-	iounmap(p->base0);
 err1:
-	kfree(p);
+	irq_domain_remove(p->irq_domain);
 err0:
 	return ret;
 }
@@ -368,22 +362,13 @@ err0:
 static int em_gio_remove(struct platform_device *pdev)
 {
 	struct em_gio_priv *p = platform_get_drvdata(pdev);
-	struct resource *irq[2];
 	int ret;
 
 	ret = gpiochip_remove(&p->gpio_chip);
 	if (ret)
 		return ret;
 
-	irq[0] = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-	irq[1] = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
-
-	free_irq(irq[1]->start, pdev);
-	free_irq(irq[0]->start, pdev);
 	irq_domain_remove(p->irq_domain);
-	iounmap(p->base1);
-	iounmap(p->base0);
-	kfree(p);
 	return 0;
 }
 
