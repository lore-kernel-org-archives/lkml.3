Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbbALKIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:08:52 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:59536 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbbALKIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:08:02 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-gpio@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] gpio: rcar: Switch to use gpiolib irqchip helpers
Date: Mon, 12 Jan 2015 11:07:59 +0100
Message-Id: <1421057279-16081-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421057279-16081-1-git-send-email-geert+renesas@glider.be>
References: <1421057279-16081-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the R-Car Gen2 GPIO driver to use the gpiolib irqchip helpers.

While doing this also make sure that gpiochip_irqchip_add() is called
after the gpiochip itself is registered, as required.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/gpio/Kconfig     |  1 +
 drivers/gpio/gpio-rcar.c | 69 ++++++++++++++++--------------------------------
 2 files changed, 24 insertions(+), 46 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 633ec216e185b795..dbc3acb999b69f4d 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -285,6 +285,7 @@ config GPIO_PXA
 config GPIO_RCAR
 	tristate "Renesas R-Car GPIO"
 	depends on ARM && (ARCH_SHMOBILE || COMPILE_TEST)
+	select GPIOLIB_IRQCHIP
 	help
 	  Say yes here to support GPIO on Renesas R-Car SoCs.
 
diff --git a/drivers/gpio/gpio-rcar.c b/drivers/gpio/gpio-rcar.c
index ca2b6310f8f709d3..c49522efa7b3bce4 100644
--- a/drivers/gpio/gpio-rcar.c
+++ b/drivers/gpio/gpio-rcar.c
@@ -21,7 +21,6 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/irq.h>
-#include <linux/irqdomain.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/pinctrl/consumer.h>
@@ -38,7 +37,6 @@ struct gpio_rcar_priv {
 	struct platform_device *pdev;
 	struct gpio_chip gpio_chip;
 	struct irq_chip irq_chip;
-	struct irq_domain *irq_domain;
 };
 
 #define IOINTSEL 0x00
@@ -82,14 +80,18 @@ static void gpio_rcar_modify_bit(struct gpio_rcar_priv *p, int offs,
 
 static void gpio_rcar_irq_disable(struct irq_data *d)
 {
-	struct gpio_rcar_priv *p = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct gpio_rcar_priv *p = container_of(gc, struct gpio_rcar_priv,
+						gpio_chip);
 
 	gpio_rcar_write(p, INTMSK, ~BIT(irqd_to_hwirq(d)));
 }
 
 static void gpio_rcar_irq_enable(struct irq_data *d)
 {
-	struct gpio_rcar_priv *p = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct gpio_rcar_priv *p = container_of(gc, struct gpio_rcar_priv,
+						gpio_chip);
 
 	gpio_rcar_write(p, MSKCLR, BIT(irqd_to_hwirq(d)));
 }
@@ -131,7 +133,9 @@ static void gpio_rcar_config_interrupt_input_mode(struct gpio_rcar_priv *p,
 
 static int gpio_rcar_irq_set_type(struct irq_data *d, unsigned int type)
 {
-	struct gpio_rcar_priv *p = irq_data_get_irq_chip_data(d);
+	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
+	struct gpio_rcar_priv *p = container_of(gc, struct gpio_rcar_priv,
+						gpio_chip);
 	unsigned int hwirq = irqd_to_hwirq(d);
 
 	dev_dbg(&p->pdev->dev, "sense irq = %d, type = %d\n", hwirq, type);
@@ -175,7 +179,8 @@ static irqreturn_t gpio_rcar_irq_handler(int irq, void *dev_id)
 			  gpio_rcar_read(p, INTMSK))) {
 		offset = __ffs(pending);
 		gpio_rcar_write(p, INTCLR, BIT(offset));
-		generic_handle_irq(irq_find_mapping(p->irq_domain, offset));
+		generic_handle_irq(irq_find_mapping(p->gpio_chip.irqdomain,
+						    offset));
 		irqs_handled++;
 	}
 
@@ -265,29 +270,6 @@ static int gpio_rcar_direction_output(struct gpio_chip *chip, unsigned offset,
 	return 0;
 }
 
-static int gpio_rcar_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	return irq_create_mapping(gpio_to_priv(chip)->irq_domain, offset);
-}
-
-static int gpio_rcar_irq_domain_map(struct irq_domain *h, unsigned int irq,
-				 irq_hw_number_t hwirq)
-{
-	struct gpio_rcar_priv *p = h->host_data;
-
-	dev_dbg(&p->pdev->dev, "map hw irq = %d, irq = %d\n", (int)hwirq, irq);
-
-	irq_set_chip_data(irq, h->host_data);
-	irq_set_chip_and_handler(irq, &p->irq_chip, handle_level_irq);
-	set_irq_flags(irq, IRQF_VALID); /* kill me now */
-	return 0;
-}
-
-static struct irq_domain_ops gpio_rcar_irq_domain_ops = {
-	.map	= gpio_rcar_irq_domain_map,
-	.xlate	= irq_domain_xlate_twocell,
-};
-
 struct gpio_rcar_info {
 	bool has_both_edge_trigger;
 };
@@ -411,7 +393,6 @@ static int gpio_rcar_probe(struct platform_device *pdev)
 	gpio_chip->get = gpio_rcar_get;
 	gpio_chip->direction_output = gpio_rcar_direction_output;
 	gpio_chip->set = gpio_rcar_set;
-	gpio_chip->to_irq = gpio_rcar_to_irq;
 	gpio_chip->label = name;
 	gpio_chip->dev = dev;
 	gpio_chip->owner = THIS_MODULE;
@@ -426,16 +407,19 @@ static int gpio_rcar_probe(struct platform_device *pdev)
 	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE | IRQCHIP_SET_TYPE_MASKED
 			 | IRQCHIP_MASK_ON_SUSPEND;
 
-	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
-					      p->config.number_of_pins,
-					      p->config.irq_base,
-					      &gpio_rcar_irq_domain_ops, p);
-	if (!p->irq_domain) {
-		ret = -ENXIO;
-		dev_err(dev, "cannot initialize irq domain\n");
+	ret = gpiochip_add(gpio_chip);
+	if (ret) {
+		dev_err(dev, "failed to add GPIO controller\n");
 		goto err0;
 	}
 
+	ret = gpiochip_irqchip_add(&p->gpio_chip, irq_chip, p->config.irq_base,
+				   handle_level_irq, IRQ_TYPE_NONE);
+	if (ret) {
+		dev_err(dev, "cannot add irqchip\n");
+		goto err1;
+	}
+
 	if (devm_request_irq(dev, irq->start, gpio_rcar_irq_handler,
 			     IRQF_SHARED, name, p)) {
 		dev_err(dev, "failed to request IRQ\n");
@@ -443,17 +427,11 @@ static int gpio_rcar_probe(struct platform_device *pdev)
 		goto err1;
 	}
 
-	ret = gpiochip_add(gpio_chip);
-	if (ret) {
-		dev_err(dev, "failed to add GPIO controller\n");
-		goto err1;
-	}
-
 	dev_info(dev, "driving %d GPIOs\n", p->config.number_of_pins);
 
 	/* warn in case of mismatch if irq base is specified */
 	if (p->config.irq_base) {
-		ret = irq_find_mapping(p->irq_domain, 0);
+		ret = irq_find_mapping(p->gpio_chip.irqdomain, 0);
 		if (p->config.irq_base != ret)
 			dev_warn(dev, "irq base mismatch (%u/%u)\n",
 				 p->config.irq_base, ret);
@@ -469,7 +447,7 @@ static int gpio_rcar_probe(struct platform_device *pdev)
 	return 0;
 
 err1:
-	irq_domain_remove(p->irq_domain);
+	gpiochip_remove(&p->gpio_chip);
 err0:
 	pm_runtime_put(dev);
 	pm_runtime_disable(dev);
@@ -482,7 +460,6 @@ static int gpio_rcar_remove(struct platform_device *pdev)
 
 	gpiochip_remove(&p->gpio_chip);
 
-	irq_domain_remove(p->irq_domain);
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return 0;
-- 
1.9.1

