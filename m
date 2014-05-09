Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbaEIHiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:38:14 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:56892 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaEIHiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:38:12 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-gpio@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] RFT: pinctrl: sunxi: convert to GPIO irqchip helpers
Date: Fri,  9 May 2014 09:38:02 +0200
Message-Id: <1399621082-10712-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the sunxi pinctrl driver over to using the generic
gpiolib irqchip helpers for its chained irqs.

As the .to_irq() callback on the gpiochip was doing some function
indexing this was moved over to the .irq_startup callback on the
irqchip (where it belongs, since it is perfectly legal to request
an irq from an irqchip without calling gpio_to_irq() first).

The gpio_chip was converted into a true member of the pinctrl
struct instead of being a pointer to a separately allocated
object, avoiding an unnecessary allocation and making it possible
to use container_of() to get from the struct gpio_chip * back to
the sunxi pinctrl state container.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Maxime, can you test this thing? And if it doesn't work, can you
figure out what it is that I want you to do and do it ;-)
This is done on top of your recently pulled sunxi series.
---
 drivers/pinctrl/sunxi/Kconfig         |   3 +
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 137 +++++++++++++++++-----------------
 drivers/pinctrl/sunxi/pinctrl-sunxi.h |   3 +-
 3 files changed, 72 insertions(+), 71 deletions(-)

diff --git a/drivers/pinctrl/sunxi/Kconfig b/drivers/pinctrl/sunxi/Kconfig
index 3940d098d6cb..fbf0cb914183 100644
--- a/drivers/pinctrl/sunxi/Kconfig
+++ b/drivers/pinctrl/sunxi/Kconfig
@@ -2,8 +2,11 @@ if ARCH_SUNXI
 
 config PINCTRL_SUNXI
 	bool
+	select OF_GPIO
 	select PINMUX
 	select GENERIC_PINCONF
+	select GPIOLIB
+	select GPIOLIB_IRQCHIP
 
 config PINCTRL_SUN4I_A10
        bool
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index f6522b54ece9..0413ecc19efb 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -13,8 +13,6 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/gpio.h>
-#include <linux/irqdomain.h>
-#include <linux/irqchip/chained_irq.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -31,6 +29,11 @@
 #include "../core.h"
 #include "pinctrl-sunxi.h"
 
+static struct sunxi_pinctrl *to_sunxi_pctl(struct gpio_chip *gc)
+{
+	return container_of(gc, struct sunxi_pinctrl, chip);
+}
+
 static struct sunxi_pinctrl_group *
 sunxi_pinctrl_find_group_by_name(struct sunxi_pinctrl *pctl, const char *group)
 {
@@ -517,31 +520,11 @@ static int sunxi_pinctrl_gpio_of_xlate(struct gpio_chip *gc,
 	return pin;
 }
 
-static int sunxi_pinctrl_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct sunxi_pinctrl *pctl = dev_get_drvdata(chip->dev);
-	struct sunxi_desc_function *desc;
-
-	if (offset >= chip->ngpio)
-		return -ENXIO;
-
-	desc = sunxi_pinctrl_desc_find_function_by_pin(pctl, offset, "irq");
-	if (!desc)
-		return -EINVAL;
-
-	pctl->irq_array[desc->irqnum] = offset;
-
-	dev_dbg(chip->dev, "%s: request IRQ for GPIO %d, return %d\n",
-		chip->label, offset + chip->base, desc->irqnum);
-
-	return irq_find_mapping(pctl->domain, desc->irqnum);
-}
-
-
 static int sunxi_pinctrl_irq_set_type(struct irq_data *d,
 				      unsigned int type)
 {
-	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+	struct sunxi_pinctrl *pctl = to_sunxi_pctl(chip);
 	u32 reg = sunxi_irq_cfg_reg(d->hwirq);
 	u8 index = sunxi_irq_cfg_offset(d->hwirq);
 	unsigned long flags;
@@ -581,7 +564,8 @@ static int sunxi_pinctrl_irq_set_type(struct irq_data *d,
 
 static void sunxi_pinctrl_irq_mask_ack(struct irq_data *d)
 {
-	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+	struct sunxi_pinctrl *pctl = to_sunxi_pctl(chip);
 	u32 ctrl_reg = sunxi_irq_ctrl_reg(d->hwirq);
 	u8 ctrl_idx = sunxi_irq_ctrl_offset(d->hwirq);
 	u32 status_reg = sunxi_irq_status_reg(d->hwirq);
@@ -603,7 +587,8 @@ static void sunxi_pinctrl_irq_mask_ack(struct irq_data *d)
 
 static void sunxi_pinctrl_irq_mask(struct irq_data *d)
 {
-	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+	struct sunxi_pinctrl *pctl = to_sunxi_pctl(chip);
 	u32 reg = sunxi_irq_ctrl_reg(d->hwirq);
 	u8 idx = sunxi_irq_ctrl_offset(d->hwirq);
 	unsigned long flags;
@@ -620,7 +605,8 @@ static void sunxi_pinctrl_irq_mask(struct irq_data *d)
 
 static void sunxi_pinctrl_irq_unmask(struct irq_data *d)
 {
-	struct sunxi_pinctrl *pctl = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+	struct sunxi_pinctrl *pctl = to_sunxi_pctl(chip);
 	struct sunxi_desc_function *func;
 	u32 reg = sunxi_irq_ctrl_reg(d->hwirq);
 	u8 idx = sunxi_irq_ctrl_offset(d->hwirq);
@@ -643,17 +629,39 @@ static void sunxi_pinctrl_irq_unmask(struct irq_data *d)
 	spin_unlock_irqrestore(&pctl->lock, flags);
 }
 
+static unsigned int sunxi_pinctrl_irq_startup(struct irq_data *d)
+{
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+	struct sunxi_pinctrl *pctl = to_sunxi_pctl(chip);
+	struct sunxi_desc_function *desc;
+
+	desc = sunxi_pinctrl_desc_find_function_by_pin(pctl, d->hwirq, "irq");
+	if (!desc) {
+		dev_err(chip->dev, "could not startup IRQ\n");
+		return 0;
+	}
+
+	pctl->irq_array[desc->irqnum] = d->hwirq;
+
+	dev_dbg(chip->dev, "%s: request IRQ for GPIO %lu, return %d\n",
+		chip->label, d->hwirq + chip->base, desc->irqnum);
+
+	return 0;
+}
+
 static struct irq_chip sunxi_pinctrl_irq_chip = {
 	.irq_mask	= sunxi_pinctrl_irq_mask,
 	.irq_mask_ack	= sunxi_pinctrl_irq_mask_ack,
 	.irq_unmask	= sunxi_pinctrl_irq_unmask,
 	.irq_set_type	= sunxi_pinctrl_irq_set_type,
+	.irq_startup	= sunxi_pinctrl_irq_startup,
 };
 
 static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
 {
 	struct irq_chip *chip = irq_get_chip(irq);
-	struct sunxi_pinctrl *pctl = irq_get_handler_data(irq);
+	struct gpio_chip *gc = irq_desc_get_handler_data(desc);
+	struct sunxi_pinctrl *pctl = to_sunxi_pctl(gc);
 	const unsigned long reg = readl(pctl->membase + IRQ_STATUS_REG);
 
 	/* Clear all interrupts */
@@ -664,7 +672,7 @@ static void sunxi_pinctrl_irq_handler(unsigned irq, struct irq_desc *desc)
 
 		chained_irq_enter(chip, desc);
 		for_each_set_bit(irqoffset, &reg, SUNXI_IRQ_NUMBER) {
-			int pin_irq = irq_find_mapping(pctl->domain, irqoffset);
+			int pin_irq = irq_find_mapping(gc->irqdomain, irqoffset);
 			generic_handle_irq(pin_irq);
 		}
 		chained_irq_exit(chip, desc);
@@ -825,38 +833,31 @@ int sunxi_pinctrl_init(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	pctl->chip = devm_kzalloc(&pdev->dev, sizeof(*pctl->chip), GFP_KERNEL);
-	if (!pctl->chip) {
-		ret = -ENOMEM;
-		goto pinctrl_error;
-	}
-
 	last_pin = pctl->desc->pins[pctl->desc->npins - 1].pin.number;
-	pctl->chip->owner = THIS_MODULE;
-	pctl->chip->request = sunxi_pinctrl_gpio_request,
-	pctl->chip->free = sunxi_pinctrl_gpio_free,
-	pctl->chip->direction_input = sunxi_pinctrl_gpio_direction_input,
-	pctl->chip->direction_output = sunxi_pinctrl_gpio_direction_output,
-	pctl->chip->get = sunxi_pinctrl_gpio_get,
-	pctl->chip->set = sunxi_pinctrl_gpio_set,
-	pctl->chip->of_xlate = sunxi_pinctrl_gpio_of_xlate,
-	pctl->chip->to_irq = sunxi_pinctrl_gpio_to_irq,
-	pctl->chip->of_gpio_n_cells = 3,
-	pctl->chip->can_sleep = false,
-	pctl->chip->ngpio = round_up(last_pin, PINS_PER_BANK) -
+	pctl->chip.owner = THIS_MODULE;
+	pctl->chip.request = sunxi_pinctrl_gpio_request,
+	pctl->chip.free = sunxi_pinctrl_gpio_free,
+	pctl->chip.direction_input = sunxi_pinctrl_gpio_direction_input,
+	pctl->chip.direction_output = sunxi_pinctrl_gpio_direction_output,
+	pctl->chip.get = sunxi_pinctrl_gpio_get,
+	pctl->chip.set = sunxi_pinctrl_gpio_set,
+	pctl->chip.of_xlate = sunxi_pinctrl_gpio_of_xlate,
+	pctl->chip.of_gpio_n_cells = 3,
+	pctl->chip.can_sleep = false,
+	pctl->chip.ngpio = round_up(last_pin, PINS_PER_BANK) -
 			    pctl->desc->pin_base;
-	pctl->chip->label = dev_name(&pdev->dev);
-	pctl->chip->dev = &pdev->dev;
-	pctl->chip->base = pctl->desc->pin_base;
+	pctl->chip.label = dev_name(&pdev->dev);
+	pctl->chip.dev = &pdev->dev;
+	pctl->chip.base = pctl->desc->pin_base;
 
-	ret = gpiochip_add(pctl->chip);
+	ret = gpiochip_add(&pctl->chip);
 	if (ret)
 		goto pinctrl_error;
 
 	for (i = 0; i < pctl->desc->npins; i++) {
 		const struct sunxi_desc_pin *pin = pctl->desc->pins + i;
 
-		ret = gpiochip_add_pin_range(pctl->chip, dev_name(&pdev->dev),
+		ret = gpiochip_add_pin_range(&pctl->chip, dev_name(&pdev->dev),
 					     pin->pin.number,
 					     pin->pin.number, 1);
 		if (ret)
@@ -879,33 +880,31 @@ int sunxi_pinctrl_init(struct platform_device *pdev,
 		goto clk_error;
 	}
 
-	pctl->domain = irq_domain_add_linear(node, SUNXI_IRQ_NUMBER,
-					     &irq_domain_simple_ops, NULL);
-	if (!pctl->domain) {
-		dev_err(&pdev->dev, "Couldn't register IRQ domain\n");
-		ret = -ENOMEM;
-		goto clk_error;
+	ret = gpiochip_irqchip_add(&pctl->chip,
+				   &sunxi_pinctrl_irq_chip,
+				   0,
+				   handle_simple_irq,
+				   IRQ_TYPE_NONE);
+	if (ret) {
+		dev_err(&pdev->dev, "could not add irqchip\n");
+		ret = -EINVAL;
+		goto irqchip_error;
 	}
 
-	for (i = 0; i < SUNXI_IRQ_NUMBER; i++) {
-		int irqno = irq_create_mapping(pctl->domain, i);
-
-		irq_set_chip_and_handler(irqno, &sunxi_pinctrl_irq_chip,
-					 handle_simple_irq);
-		irq_set_chip_data(irqno, pctl);
-	};
-
-	irq_set_chained_handler(pctl->irq, sunxi_pinctrl_irq_handler);
-	irq_set_handler_data(pctl->irq, pctl);
+	gpiochip_set_chained_irqchip(&pctl->chip,
+				     &sunxi_pinctrl_irq_chip,
+				     pctl->irq,
+				     sunxi_pinctrl_irq_handler);
 
 	dev_info(&pdev->dev, "initialized sunXi PIO driver\n");
 
 	return 0;
 
+irqchip_error:
 clk_error:
 	clk_disable_unprepare(clk);
 gpiochip_error:
-	if (gpiochip_remove(pctl->chip))
+	if (gpiochip_remove(&pctl->chip))
 		dev_err(&pdev->dev, "failed to remove gpio chip\n");
 pinctrl_error:
 	pinctrl_unregister(pctl->pctl_dev);
diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.h b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
index 8169ba598876..54fc934165c6 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.h
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.h
@@ -105,10 +105,9 @@ struct sunxi_pinctrl_group {
 
 struct sunxi_pinctrl {
 	void __iomem			*membase;
-	struct gpio_chip		*chip;
+	struct gpio_chip		chip;
 	const struct sunxi_pinctrl_desc	*desc;
 	struct device			*dev;
-	struct irq_domain		*domain;
 	struct sunxi_pinctrl_function	*functions;
 	unsigned			nfunctions;
 	struct sunxi_pinctrl_group	*groups;
-- 
1.9.0

