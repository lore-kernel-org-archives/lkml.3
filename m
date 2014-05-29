Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934463AbaE2JZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:25:48 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:34363 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814AbaE2JZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:25:46 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.linux.kernel@gmail.com>
Cc: linux-gpio@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>, spear-devel@list.st.com
Subject: [PATCH] RFT: pinctrl: spear: switch plgpio to irqchip helpers
Date: Thu, 29 May 2014 11:25:31 +0200
Message-Id: <1401355531-632-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This switches the SPEAr PLGPIO driver over to using the irqchip
helpers.

As part of this effort, also get rid of the strange irq_base
calculation and failure to use d->hwirq for obtaining a local
irqchip offset.

Cc: Viresh Kumar <viresh.linux@gmail.com>
Cc: Shiraz Hashim <shiraz.linux.kernel@gmail.com>
Cc: spear-devel@list.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
SPEAr folks: please make sure to test this, it is part of an
important GPIO refactoring round. If it doesn't work: please do
an honest attempt at troubleshooting.
---
 drivers/pinctrl/spear/Kconfig          |  1 +
 drivers/pinctrl/spear/pinctrl-plgpio.c | 81 +++++++++++++---------------------
 2 files changed, 31 insertions(+), 51 deletions(-)

diff --git a/drivers/pinctrl/spear/Kconfig b/drivers/pinctrl/spear/Kconfig
index 04d93e602674..9ef18eb958e1 100644
--- a/drivers/pinctrl/spear/Kconfig
+++ b/drivers/pinctrl/spear/Kconfig
@@ -48,6 +48,7 @@ config PINCTRL_SPEAR1340
 config PINCTRL_SPEAR_PLGPIO
 	bool "SPEAr SoC PLGPIO Controller"
 	depends on GPIOLIB && PINCTRL_SPEAR
+	select GPIOLIB_IRQCHIP
 	help
 	  Say yes here to support PLGPIO controller on ST Microelectronics SPEAr
 	  SoCs.
diff --git a/drivers/pinctrl/spear/pinctrl-plgpio.c b/drivers/pinctrl/spear/pinctrl-plgpio.c
index ff2940e9f2a7..3a20cdc65810 100644
--- a/drivers/pinctrl/spear/pinctrl-plgpio.c
+++ b/drivers/pinctrl/spear/pinctrl-plgpio.c
@@ -11,12 +11,11 @@
 
 #include <linux/clk.h>
 #include <linux/err.h>
-#include <linux/gpio.h>
+#include <linux/gpio/driver.h>
 #include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/irqdomain.h>
-#include <linux/irqchip/chained_irq.h>
 #include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
@@ -54,7 +53,6 @@ struct plgpio_regs {
  *
  * lock: lock for guarding gpio registers
  * base: base address of plgpio block
- * irq_base: irq number of plgpio0
  * chip: gpio framework specific chip information structure
  * p2o: function ptr for pin to offset conversion. This is required only for
  *	machines where mapping b/w pin and offset is not 1-to-1.
@@ -68,8 +66,6 @@ struct plgpio {
 	spinlock_t		lock;
 	void __iomem		*base;
 	struct clk		*clk;
-	unsigned		irq_base;
-	struct irq_domain	*irq_domain;
 	struct gpio_chip	chip;
 	int			(*p2o)(int pin);	/* pin_to_offset */
 	int			(*o2p)(int offset);	/* offset_to_pin */
@@ -280,21 +276,12 @@ disable_clk:
 	pinctrl_free_gpio(gpio);
 }
 
-static int plgpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct plgpio *plgpio = container_of(chip, struct plgpio, chip);
-
-	if (IS_ERR_VALUE(plgpio->irq_base))
-		return -EINVAL;
-
-	return irq_find_mapping(plgpio->irq_domain, offset);
-}
-
 /* PLGPIO IRQ */
 static void plgpio_irq_disable(struct irq_data *d)
 {
-	struct plgpio *plgpio = irq_data_get_irq_chip_data(d);
-	int offset = d->irq - plgpio->irq_base;
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct plgpio *plgpio = container_of(gc, struct plgpio, chip);
+	int offset = d->hwirq;
 	unsigned long flags;
 
 	/* get correct offset for "offset" pin */
@@ -311,8 +298,9 @@ static void plgpio_irq_disable(struct irq_data *d)
 
 static void plgpio_irq_enable(struct irq_data *d)
 {
-	struct plgpio *plgpio = irq_data_get_irq_chip_data(d);
-	int offset = d->irq - plgpio->irq_base;
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct plgpio *plgpio = container_of(gc, struct plgpio, chip);
+	int offset = d->hwirq;
 	unsigned long flags;
 
 	/* get correct offset for "offset" pin */
@@ -329,8 +317,9 @@ static void plgpio_irq_enable(struct irq_data *d)
 
 static int plgpio_irq_set_type(struct irq_data *d, unsigned trigger)
 {
-	struct plgpio *plgpio = irq_data_get_irq_chip_data(d);
-	int offset = d->irq - plgpio->irq_base;
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct plgpio *plgpio = container_of(gc, struct plgpio, chip);
+	int offset = d->hwirq;
 	void __iomem *reg_off;
 	unsigned int supported_type = 0, val;
 
@@ -369,7 +358,8 @@ static struct irq_chip plgpio_irqchip = {
 
 static void plgpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct plgpio *plgpio = irq_get_handler_data(irq);
+	struct gpio_chip *gc = irq_desc_get_handler_data(desc);
+	struct plgpio *plgpio = container_of(gc, struct plgpio, chip);
 	struct irq_chip *irqchip = irq_desc_get_chip(desc);
 	int regs_count, count, pin, offset, i = 0;
 	unsigned long pending;
@@ -410,7 +400,8 @@ static void plgpio_irq_handler(unsigned irq, struct irq_desc *desc)
 
 			/* get correct irq line number */
 			pin = i * MAX_GPIO_PER_REG + pin;
-			generic_handle_irq(plgpio_to_irq(&plgpio->chip, pin));
+			generic_handle_irq(
+				irq_find_mapping(gc->irqdomain, pin));
 		}
 	}
 	chained_irq_exit(irqchip, desc);
@@ -523,10 +514,9 @@ end:
 }
 static int plgpio_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
 	struct plgpio *plgpio;
 	struct resource *res;
-	int ret, irq, i;
+	int ret, irq;
 
 	plgpio = devm_kzalloc(&pdev->dev, sizeof(*plgpio), GFP_KERNEL);
 	if (!plgpio) {
@@ -563,7 +553,6 @@ static int plgpio_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, plgpio);
 	spin_lock_init(&plgpio->lock);
 
-	plgpio->irq_base = -1;
 	plgpio->chip.base = -1;
 	plgpio->chip.request = plgpio_request;
 	plgpio->chip.free = plgpio_free;
@@ -571,10 +560,10 @@ static int plgpio_probe(struct platform_device *pdev)
 	plgpio->chip.direction_output = plgpio_direction_output;
 	plgpio->chip.get = plgpio_get_value;
 	plgpio->chip.set = plgpio_set_value;
-	plgpio->chip.to_irq = plgpio_to_irq;
 	plgpio->chip.label = dev_name(&pdev->dev);
 	plgpio->chip.dev = &pdev->dev;
 	plgpio->chip.owner = THIS_MODULE;
+	plgpio->chip.of_node = pdev->dev.of_node;
 
 	if (!IS_ERR(plgpio->clk)) {
 		ret = clk_prepare(plgpio->clk);
@@ -592,35 +581,25 @@ static int plgpio_probe(struct platform_device *pdev)
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
-		dev_info(&pdev->dev, "irqs not supported\n");
-		return 0;
-	}
-
-	plgpio->irq_base = irq_alloc_descs(-1, 0, plgpio->chip.ngpio, 0);
-	if (IS_ERR_VALUE(plgpio->irq_base)) {
-		/* we would not support irq for gpio */
-		dev_warn(&pdev->dev, "couldn't allocate irq base\n");
+		dev_info(&pdev->dev, "PLGPIO registered without IRQs\n");
 		return 0;
 	}
 
-	plgpio->irq_domain = irq_domain_add_legacy(np, plgpio->chip.ngpio,
-			plgpio->irq_base, 0, &irq_domain_simple_ops, NULL);
-	if (WARN_ON(!plgpio->irq_domain)) {
-		dev_err(&pdev->dev, "irq domain init failed\n");
-		irq_free_descs(plgpio->irq_base, plgpio->chip.ngpio);
-		ret = -ENXIO;
+	ret = gpiochip_irqchip_add(&plgpio->chip,
+				   &plgpio_irqchip,
+				   0,
+				   handle_simple_irq,
+				   IRQ_TYPE_NONE);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add irqchip to gpiochip\n");
 		goto remove_gpiochip;
 	}
 
-	irq_set_chained_handler(irq, plgpio_irq_handler);
-	for (i = 0; i < plgpio->chip.ngpio; i++) {
-		irq_set_chip_and_handler(i + plgpio->irq_base, &plgpio_irqchip,
-				handle_simple_irq);
-		set_irq_flags(i + plgpio->irq_base, IRQF_VALID);
-		irq_set_chip_data(i + plgpio->irq_base, plgpio);
-	}
+	gpiochip_set_chained_irqchip(&plgpio->chip,
+				     &plgpio_irqchip,
+				     irq,
+				     plgpio_irq_handler);
 
-	irq_set_handler_data(irq, plgpio);
 	dev_info(&pdev->dev, "PLGPIO registered with IRQs\n");
 
 	return 0;
-- 
1.9.3

