Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab3KSWYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:24:18 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44642 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3KSWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:24:14 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl: nomadik: decomission non-DT boot path
Date: Tue, 19 Nov 2013 23:24:05 +0100
Message-Id: <1384899845-10876-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the patches deleting the last board registering this
pin controller as a platform device has been deleted,
proceed to remove the non-DT boot patch and depend on
OF being available and the device to be coming up by
a DT node.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
This will be merged through ARM SoC with dependent
patches removing the dependence on platform data headers
etc.
---
 drivers/pinctrl/pinctrl-nomadik.c | 80 +++++++++++----------------------------
 1 file changed, 22 insertions(+), 58 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index 3895f1415ef9..983662e846a4 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2008,2009 STMicroelectronics
  * Copyright (C) 2009 Alessandro Rubini <rubini@unipv.it>
  *   Rewritten based on work by Prafulla WADASKAR <prafulla.wadaskar@st.com>
- * Copyright (C) 2011 Linus Walleij <linus.walleij@linaro.org>
+ * Copyright (C) 2011-2013 Linus Walleij <linus.walleij@linaro.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1240,7 +1240,7 @@ static const struct irq_domain_ops nmk_gpio_irq_simple_ops = {
 
 static int nmk_gpio_probe(struct platform_device *dev)
 {
-	struct nmk_gpio_platform_data *pdata = dev->dev.platform_data;
+	struct nmk_gpio_platform_data *pdata;
 	struct device_node *np = dev->dev.of_node;
 	struct nmk_gpio_chip *nmk_chip;
 	struct gpio_chip *chip;
@@ -1248,32 +1248,24 @@ static int nmk_gpio_probe(struct platform_device *dev)
 	struct clk *clk;
 	int secondary_irq;
 	void __iomem *base;
-	int irq_start = 0;
 	int irq;
 	int ret;
 
-	if (!pdata && !np) {
-		dev_err(&dev->dev, "No platform data or device tree found\n");
-		return -ENODEV;
-	}
-
-	if (np) {
-		pdata = devm_kzalloc(&dev->dev, sizeof(*pdata), GFP_KERNEL);
-		if (!pdata)
-			return -ENOMEM;
-
-		if (of_get_property(np, "st,supports-sleepmode", NULL))
-			pdata->supports_sleepmode = true;
+	pdata = devm_kzalloc(&dev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
 
-		if (of_property_read_u32(np, "gpio-bank", &dev->id)) {
-			dev_err(&dev->dev, "gpio-bank property not found\n");
-			return -EINVAL;
-		}
+	if (of_get_property(np, "st,supports-sleepmode", NULL))
+		pdata->supports_sleepmode = true;
 
-		pdata->first_gpio = dev->id * NMK_GPIO_PER_CHIP;
-		pdata->num_gpio   = NMK_GPIO_PER_CHIP;
+	if (of_property_read_u32(np, "gpio-bank", &dev->id)) {
+		dev_err(&dev->dev, "gpio-bank property not found\n");
+		return -EINVAL;
 	}
 
+	pdata->first_gpio = dev->id * NMK_GPIO_PER_CHIP;
+	pdata->num_gpio = NMK_GPIO_PER_CHIP;
+
 	irq = platform_get_irq(dev, 0);
 	if (irq < 0)
 		return irq;
@@ -1321,10 +1313,7 @@ static int nmk_gpio_probe(struct platform_device *dev)
 	clk_enable(nmk_chip->clk);
 	nmk_chip->lowemi = readl_relaxed(nmk_chip->addr + NMK_GPIO_LOWEMI);
 	clk_disable(nmk_chip->clk);
-
-#ifdef CONFIG_OF_GPIO
 	chip->of_node = np;
-#endif
 
 	ret = gpiochip_add(&nmk_chip->chip);
 	if (ret)
@@ -1336,10 +1325,8 @@ static int nmk_gpio_probe(struct platform_device *dev)
 
 	platform_set_drvdata(dev, nmk_chip);
 
-	if (!np)
-		irq_start = pdata->first_irq;
 	nmk_chip->domain = irq_domain_add_simple(np,
-				NMK_GPIO_PER_CHIP, irq_start,
+				NMK_GPIO_PER_CHIP, 0,
 				&nmk_gpio_irq_simple_ops, nmk_chip);
 	if (!nmk_chip->domain) {
 		dev_err(&dev->dev, "failed to create irqdomain\n");
@@ -2072,11 +2059,10 @@ static int nmk_pinctrl_resume(struct platform_device *pdev)
 
 static int nmk_pinctrl_probe(struct platform_device *pdev)
 {
-	const struct platform_device_id *platid = platform_get_device_id(pdev);
+	const struct of_device_id *match;
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *prcm_np;
 	struct nmk_pinctrl *npct;
-	struct resource *res;
 	unsigned int version = 0;
 	int i;
 
@@ -2084,16 +2070,10 @@ static int nmk_pinctrl_probe(struct platform_device *pdev)
 	if (!npct)
 		return -ENOMEM;
 
-	if (platid)
-		version = platid->driver_data;
-	else if (np) {
-		const struct of_device_id *match;
-
-		match = of_match_device(nmk_pinctrl_match, &pdev->dev);
-		if (!match)
-			return -ENODEV;
-		version = (unsigned int) match->data;
-	}
+	match = of_match_device(nmk_pinctrl_match, &pdev->dev);
+	if (!match)
+		return -ENODEV;
+	version = (unsigned int) match->data;
 
 	/* Poke in other ASIC variants here */
 	if (version == PINCTRL_NMK_STN8815)
@@ -2103,17 +2083,9 @@ static int nmk_pinctrl_probe(struct platform_device *pdev)
 	if (version == PINCTRL_NMK_DB8540)
 		nmk_pinctrl_db8540_init(&npct->soc);
 
-	if (np) {
-		prcm_np = of_parse_phandle(np, "prcm", 0);
-		if (prcm_np)
-			npct->prcm_base = of_iomap(prcm_np, 0);
-	}
-
-	/* Allow platform passed information to over-write DT. */
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res)
-		npct->prcm_base = devm_ioremap(&pdev->dev, res->start,
-					       resource_size(res));
+	prcm_np = of_parse_phandle(np, "prcm", 0);
+	if (prcm_np)
+		npct->prcm_base = of_iomap(prcm_np, 0);
 	if (!npct->prcm_base) {
 		if (version == PINCTRL_NMK_STN8815) {
 			dev_info(&pdev->dev,
@@ -2172,13 +2144,6 @@ static struct platform_driver nmk_gpio_driver = {
 	.probe = nmk_gpio_probe,
 };
 
-static const struct platform_device_id nmk_pinctrl_id[] = {
-	{ "pinctrl-stn8815", PINCTRL_NMK_STN8815 },
-	{ "pinctrl-db8500", PINCTRL_NMK_DB8500 },
-	{ "pinctrl-db8540", PINCTRL_NMK_DB8540 },
-	{ }
-};
-
 static struct platform_driver nmk_pinctrl_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
@@ -2186,7 +2151,6 @@ static struct platform_driver nmk_pinctrl_driver = {
 		.of_match_table = nmk_pinctrl_match,
 	},
 	.probe = nmk_pinctrl_probe,
-	.id_table = nmk_pinctrl_id,
 #ifdef CONFIG_PM
 	.suspend = nmk_pinctrl_suspend,
 	.resume = nmk_pinctrl_resume,
-- 
1.8.3.1

