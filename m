Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab3CML0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:26:45 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:45155 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932822Ab3CML0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:26:42 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 13 Mar 2013 20:32:33 +0900
Message-Id: <20130313113233.30133.20516.sendpatchset@w520>
In-Reply-To: <20130313113203.30133.49539.sendpatchset@w520>
References: <20130313113203.30133.49539.sendpatchset@w520>
Subject: [PATCH 03/03] gpio: rcar: Make use of devm functions
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Update the gpio-rcar.c driver to make use of devm
functions. This simplifies the error handling and
makes the code more compact.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/gpio-rcar.c |   32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

--- 0005/drivers/gpio/gpio-rcar.c
+++ work/drivers/gpio/gpio-rcar.c	2013-03-13 19:47:17.000000000 +0900
@@ -252,7 +252,7 @@ static int gpio_rcar_probe(struct platfo
 	const char *name = dev_name(&pdev->dev);
 	int ret;
 
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	if (!p) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		ret = -ENOMEM;
@@ -273,14 +273,15 @@ static int gpio_rcar_probe(struct platfo
 	if (!io || !irq) {
 		dev_err(&pdev->dev, "missing IRQ or IOMEM\n");
 		ret = -EINVAL;
-		goto err1;
+		goto err0;
 	}
 
-	p->base = ioremap_nocache(io->start, resource_size(io));
+	p->base = devm_ioremap_nocache(&pdev->dev, io->start,
+				       resource_size(io));
 	if (!p->base) {
 		dev_err(&pdev->dev, "failed to remap I/O memory\n");
 		ret = -ENXIO;
-		goto err1;
+		goto err0;
 	}
 
 	gpio_chip = &p->gpio_chip;
@@ -310,19 +311,20 @@ static int gpio_rcar_probe(struct platfo
 	if (!p->irq_domain) {
 		ret = -ENXIO;
 		dev_err(&pdev->dev, "cannot initialize irq domain\n");
-		goto err2;
+		goto err1;
 	}
 
-	if (request_irq(irq->start, gpio_rcar_irq_handler, 0, name, p)) {
+	if (devm_request_irq(&pdev->dev, irq->start,
+			     gpio_rcar_irq_handler, 0, name, p)) {
 		dev_err(&pdev->dev, "failed to request IRQ\n");
 		ret = -ENOENT;
-		goto err3;
+		goto err1;
 	}
 
 	ret = gpiochip_add(gpio_chip);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add GPIO controller\n");
-		goto err4;
+		goto err1;
 	}
 
 	dev_info(&pdev->dev, "driving %d GPIOs\n", p->config.number_of_pins);
@@ -337,14 +339,8 @@ static int gpio_rcar_probe(struct platfo
 
 	return 0;
 
-err4:
-	free_irq(irq->start, p);
-err3:
-	irq_domain_remove(p->irq_domain);
-err2:
-	iounmap(p->base);
 err1:
-	kfree(p);
+	irq_domain_remove(p->irq_domain);
 err0:
 	return ret;
 }
@@ -352,19 +348,13 @@ err0:
 static int gpio_rcar_remove(struct platform_device *pdev)
 {
 	struct gpio_rcar_priv *p = platform_get_drvdata(pdev);
-	struct resource *irq;
 	int ret;
 
 	ret = gpiochip_remove(&p->gpio_chip);
 	if (ret)
 		return ret;
 
-	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-
-	free_irq(irq->start, p);
 	irq_domain_remove(p->irq_domain);
-	iounmap(p->base);
-	kfree(p);
 	return 0;
 }
 
