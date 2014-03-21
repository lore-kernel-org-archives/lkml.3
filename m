Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbaCUJmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:42:44 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:59069 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760576AbaCUJmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:42:38 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/2] pinctrl: nomadik: factor in platform data container
Date: Fri, 21 Mar 2014 10:42:32 +0100
Message-Id: <1395394952-31545-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old platform data struct is just a leftover from the times
when the driver was not probed exclusively from the device tree.
Factor this into the general state container and simplify the
probe path.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinctrl-nomadik.c | 39 +++++++++------------------------------
 1 file changed, 9 insertions(+), 30 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c
index ee6a8ca264fc..51f28c927c7e 100644
--- a/drivers/pinctrl/pinctrl-nomadik.c
+++ b/drivers/pinctrl/pinctrl-nomadik.c
@@ -246,19 +246,6 @@ enum nmk_gpio_slpm {
 	NMK_GPIO_SLPM_WAKEUP_DISABLE = NMK_GPIO_SLPM_NOCHANGE,
 };
 
-/*
- * Platform data to register a block: only the initial gpio/irq number.
- */
-struct nmk_gpio_platform_data {
-	char *name;
-	int first_gpio;
-	int first_irq;
-	int num_gpio;
-	u32 (*get_latent_status)(unsigned int bank);
-	void (*set_ioforce)(bool enable);
-	bool supports_sleepmode;
-};
-
 struct nmk_gpio_chip {
 	struct gpio_chip chip;
 	struct irq_domain *domain;
@@ -1240,39 +1227,33 @@ static const struct irq_domain_ops nmk_gpio_irq_simple_ops = {
 
 static int nmk_gpio_probe(struct platform_device *dev)
 {
-	struct nmk_gpio_platform_data *pdata;
 	struct device_node *np = dev->dev.of_node;
 	struct nmk_gpio_chip *nmk_chip;
 	struct gpio_chip *chip;
 	struct resource *res;
 	struct clk *clk;
 	int latent_irq;
+	bool supports_sleepmode;
 	void __iomem *base;
 	int irq;
 	int ret;
 
-	pdata = devm_kzalloc(&dev->dev, sizeof(*pdata), GFP_KERNEL);
-	if (!pdata)
-		return -ENOMEM;
-
 	if (of_get_property(np, "st,supports-sleepmode", NULL))
-		pdata->supports_sleepmode = true;
+		supports_sleepmode = true;
+	else
+		supports_sleepmode = false;
 
 	if (of_property_read_u32(np, "gpio-bank", &dev->id)) {
 		dev_err(&dev->dev, "gpio-bank property not found\n");
 		return -EINVAL;
 	}
 
-	pdata->first_gpio = dev->id * NMK_GPIO_PER_CHIP;
-	pdata->num_gpio = NMK_GPIO_PER_CHIP;
-
 	irq = platform_get_irq(dev, 0);
 	if (irq < 0)
 		return irq;
 
+	/* It's OK for this IRQ not to be present */
 	latent_irq = platform_get_irq(dev, 1);
-	if (latent_irq >= 0 && !pdata->get_latent_status)
-		return -EINVAL;
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	base = devm_ioremap_resource(&dev->dev, res);
@@ -1298,15 +1279,13 @@ static int nmk_gpio_probe(struct platform_device *dev)
 	nmk_chip->chip = nmk_gpio_template;
 	nmk_chip->parent_irq = irq;
 	nmk_chip->latent_parent_irq = latent_irq;
-	nmk_chip->get_latent_status = pdata->get_latent_status;
-	nmk_chip->set_ioforce = pdata->set_ioforce;
-	nmk_chip->sleepmode = pdata->supports_sleepmode;
+	nmk_chip->sleepmode = supports_sleepmode;
 	spin_lock_init(&nmk_chip->lock);
 
 	chip = &nmk_chip->chip;
-	chip->base = pdata->first_gpio;
-	chip->ngpio = pdata->num_gpio;
-	chip->label = pdata->name ?: dev_name(&dev->dev);
+	chip->base = dev->id * NMK_GPIO_PER_CHIP;
+	chip->ngpio = NMK_GPIO_PER_CHIP;
+	chip->label = dev_name(&dev->dev);
 	chip->dev = &dev->dev;
 	chip->owner = THIS_MODULE;
 
-- 
1.8.5.3

