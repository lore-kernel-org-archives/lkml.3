Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbaEMWhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:37:09 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46209 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbaEMWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:37:04 -0400
From: abdoulaye berthe <berthe.ab@gmail.com>
To: linus.walleij@linaro.org, gnurou@gmail.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, berthe.ab@gmail.com
Subject: [PATCH] gpio: gpioep93xx: use devm functions
Date: Wed, 14 May 2014 00:36:54 +0200
Message-Id: <1400020614-18907-1-git-send-email-berthe.ab@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This uses devm functions for mem allocation

Signed-off-by: abdoulaye berthe <berthe.ab@gmail.com>
---
 drivers/gpio/gpio-ep93xx.c | 34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

diff --git a/drivers/gpio/gpio-ep93xx.c b/drivers/gpio/gpio-ep93xx.c
index 80829f3..dd39f27 100644
--- a/drivers/gpio/gpio-ep93xx.c
+++ b/drivers/gpio/gpio-ep93xx.c
@@ -344,37 +344,24 @@ static int ep93xx_gpio_probe(struct platform_device *pdev)
 {
 	struct ep93xx_gpio *ep93xx_gpio;
 	struct resource *res;
-	void __iomem *mmio;
 	int i;
-	int ret;
+	struct device *dev = &pdev->dev;
 
-	ep93xx_gpio = kzalloc(sizeof(*ep93xx_gpio), GFP_KERNEL);
+	ep93xx_gpio = devm_kzalloc(dev, sizeof(struct ep93xx_gpio), GFP_KERNEL);
 	if (!ep93xx_gpio)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		ret = -ENXIO;
-		goto exit_free;
-	}
-
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) {
-		ret = -EBUSY;
-		goto exit_free;
-	}
-
-	mmio = ioremap(res->start, resource_size(res));
-	if (!mmio) {
-		ret = -ENXIO;
-		goto exit_release;
-	}
-	ep93xx_gpio->mmio_base = mmio;
+	ep93xx_gpio->mmio_base = devm_request_and_ioremap(dev, res);
+	if (IS_ERR(ep93xx_gpio->mmio_base))
+		return PTR_ERR(ep93xx_gpio->mmio_base);
 
 	for (i = 0; i < ARRAY_SIZE(ep93xx_gpio_banks); i++) {
 		struct bgpio_chip *bgc = &ep93xx_gpio->bgc[i];
 		struct ep93xx_gpio_bank *bank = &ep93xx_gpio_banks[i];
 
-		if (ep93xx_gpio_add_bank(bgc, &pdev->dev, mmio, bank))
+		if (ep93xx_gpio_add_bank(bgc, &pdev->dev,
+					 ep93xx_gpio->mmio_base, bank))
 			dev_warn(&pdev->dev, "Unable to add gpio bank %s\n",
 				bank->label);
 	}
@@ -382,13 +369,6 @@ static int ep93xx_gpio_probe(struct platform_device *pdev)
 	ep93xx_gpio_init_irq();
 
 	return 0;
-
-exit_release:
-	release_mem_region(res->start, resource_size(res));
-exit_free:
-	kfree(ep93xx_gpio);
-	dev_info(&pdev->dev, "%s failed with errno %d\n", __func__, ret);
-	return ret;
 }
 
 static struct platform_driver ep93xx_gpio_driver = {
-- 
1.8.3.2

