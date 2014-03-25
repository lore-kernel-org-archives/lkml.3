Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaCYMww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 08:52:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38912 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbaCYMwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 08:52:49 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-gpio@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] pinctrl: coh901: convert driver to use gpiolib irqchip
Date: Tue, 25 Mar 2014 13:51:34 +0100
Message-Id: <1395751894-7110-5-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395751894-7110-1-git-send-email-linus.walleij@linaro.org>
References: <1395751894-7110-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the COH901 pin control driver to register its
chained irq handler and irqchip using the helpers in the
gpiolib core.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/Kconfig          |   1 +
 drivers/pinctrl/pinctrl-coh901.c | 204 ++++++++++-----------------------------
 2 files changed, 54 insertions(+), 151 deletions(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index a05087bd1955..0c6eb33daa87 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -324,6 +324,7 @@ config PINCTRL_U300
 config PINCTRL_COH901
 	bool "ST-Ericsson U300 COH 901 335/571 GPIO"
 	depends on GPIOLIB && ARCH_U300 && PINCTRL_U300
+	select GPIOLIB_IRQCHIP
 	help
 	  Say yes here to support GPIO interface on ST-Ericsson U300.
 	  The names of the two IP block variants supported are
diff --git a/drivers/pinctrl/pinctrl-coh901.c b/drivers/pinctrl/pinctrl-coh901.c
index 749db595640c..d182fdd2e715 100644
--- a/drivers/pinctrl/pinctrl-coh901.c
+++ b/drivers/pinctrl/pinctrl-coh901.c
@@ -8,17 +8,14 @@
  * Author: Jonas Aaberg <jonas.aberg@stericsson.com>
  */
 #include <linux/module.h>
-#include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/io.h>
-#include <linux/irqdomain.h>
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/gpio.h>
-#include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/pinctrl/consumer.h>
 #include <linux/pinctrl/pinconf-generic.h>
@@ -61,9 +58,17 @@
 #define U300_GPIO_PINS_PER_PORT 8
 #define U300_GPIO_MAX (U300_GPIO_PINS_PER_PORT * U300_GPIO_NUM_PORTS)
 
+struct u300_gpio_port {
+	struct u300_gpio *gpio;
+	char name[8];
+	int irq;
+	int number;
+	u8 toggle_edge_mode;
+};
+
 struct u300_gpio {
 	struct gpio_chip chip;
-	struct list_head port_list;
+	struct u300_gpio_port ports[U300_GPIO_NUM_PORTS];
 	struct clk *clk;
 	void __iomem *base;
 	struct device *dev;
@@ -78,16 +83,6 @@ struct u300_gpio {
 	u32 iev;
 };
 
-struct u300_gpio_port {
-	struct list_head node;
-	struct u300_gpio *gpio;
-	char name[8];
-	struct irq_domain *domain;
-	int irq;
-	int number;
-	u8 toggle_edge_mode;
-};
-
 /*
  * Macro to expand to read a specific register found in the "gpio"
  * struct. It requires the struct u300_gpio *gpio variable to exist in
@@ -308,39 +303,6 @@ static int u300_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
 	return 0;
 }
 
-static int u300_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-{
-	struct u300_gpio *gpio = to_u300_gpio(chip);
-	int portno = offset >> 3;
-	struct u300_gpio_port *port = NULL;
-	struct list_head *p;
-	int retirq;
-	bool found = false;
-
-	list_for_each(p, &gpio->port_list) {
-		port = list_entry(p, struct u300_gpio_port, node);
-		if (port->number == portno) {
-			found = true;
-			break;
-		}
-	}
-	if (!found) {
-		dev_err(gpio->dev, "could not locate port for GPIO %d IRQ\n",
-			offset);
-		return -EINVAL;
-	}
-
-	/*
-	 * The local hwirqs on the port are the lower three bits, there
-	 * are exactly 8 IRQs per port since they are 8-bit
-	 */
-	retirq = irq_find_mapping(port->domain, (offset & 0x7));
-
-	dev_dbg(gpio->dev, "request IRQ for GPIO %d, return %d from port %d\n",
-		offset, retirq, port->number);
-	return retirq;
-}
-
 /* Returning -EINVAL means "supported but not available" */
 int u300_gpio_config_get(struct gpio_chip *chip,
 			 unsigned offset,
@@ -461,7 +423,6 @@ static struct gpio_chip u300_gpio_chip = {
 	.set			= u300_gpio_set,
 	.direction_input	= u300_gpio_direction_input,
 	.direction_output	= u300_gpio_direction_output,
-	.to_irq			= u300_gpio_to_irq,
 };
 
 static void u300_toggle_trigger(struct u300_gpio *gpio, unsigned offset)
@@ -485,9 +446,10 @@ static void u300_toggle_trigger(struct u300_gpio *gpio, unsigned offset)
 
 static int u300_gpio_irq_type(struct irq_data *d, unsigned trigger)
 {
-	struct u300_gpio_port *port = irq_data_get_irq_chip_data(d);
-	struct u300_gpio *gpio = port->gpio;
-	int offset = (port->number << 3) + d->hwirq;
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+	struct u300_gpio *gpio = to_u300_gpio(chip);
+	struct u300_gpio_port *port = &gpio->ports[d->hwirq >> 3];
+	int offset = d->hwirq;
 	u32 val;
 
 	if ((trigger & IRQF_TRIGGER_RISING) &&
@@ -521,9 +483,10 @@ static int u300_gpio_irq_type(struct irq_data *d, unsigned trigger)
 
 static void u300_gpio_irq_enable(struct irq_data *d)
 {
-	struct u300_gpio_port *port = irq_data_get_irq_chip_data(d);
-	struct u300_gpio *gpio = port->gpio;
-	int offset = (port->number << 3) + d->hwirq;
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+	struct u300_gpio *gpio = to_u300_gpio(chip);
+	struct u300_gpio_port *port = &gpio->ports[d->hwirq >> 3];
+	int offset = d->hwirq;
 	u32 val;
 	unsigned long flags;
 
@@ -537,9 +500,9 @@ static void u300_gpio_irq_enable(struct irq_data *d)
 
 static void u300_gpio_irq_disable(struct irq_data *d)
 {
-	struct u300_gpio_port *port = irq_data_get_irq_chip_data(d);
-	struct u300_gpio *gpio = port->gpio;
-	int offset = (port->number << 3) + d->hwirq;
+	struct gpio_chip *chip = irq_data_get_irq_chip_data(d);
+	struct u300_gpio *gpio = to_u300_gpio(chip);
+	int offset = d->hwirq;
 	u32 val;
 	unsigned long flags;
 
@@ -549,45 +512,24 @@ static void u300_gpio_irq_disable(struct irq_data *d)
 	local_irq_restore(flags);
 }
 
-static int u300_gpio_irq_reqres(struct irq_data *d)
-{
-	struct u300_gpio_port *port = irq_data_get_irq_chip_data(d);
-	struct u300_gpio *gpio = port->gpio;
-
-	if (gpio_lock_as_irq(&gpio->chip, d->hwirq)) {
-		dev_err(gpio->dev,
-			"unable to lock HW IRQ %lu for IRQ\n",
-			d->hwirq);
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static void u300_gpio_irq_relres(struct irq_data *d)
-{
-	struct u300_gpio_port *port = irq_data_get_irq_chip_data(d);
-	struct u300_gpio *gpio = port->gpio;
-
-	gpio_unlock_as_irq(&gpio->chip, d->hwirq);
-}
-
 static struct irq_chip u300_gpio_irqchip = {
 	.name			= "u300-gpio-irqchip",
 	.irq_enable		= u300_gpio_irq_enable,
 	.irq_disable		= u300_gpio_irq_disable,
 	.irq_set_type		= u300_gpio_irq_type,
-	.irq_request_resources	= u300_gpio_irq_reqres,
-	.irq_release_resources	= u300_gpio_irq_relres,
 };
 
 static void u300_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 {
-	struct u300_gpio_port *port = irq_get_handler_data(irq);
-	struct u300_gpio *gpio = port->gpio;
+	struct irq_chip *parent_chip = irq_get_chip(irq);
+	struct gpio_chip *chip = irq_get_handler_data(irq);
+	struct u300_gpio *gpio = to_u300_gpio(chip);
+	struct u300_gpio_port *port = &gpio->ports[irq - chip->base];
 	int pinoffset = port->number << 3; /* get the right stride */
 	unsigned long val;
 
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	chained_irq_enter(parent_chip, desc);
+
 	/* Read event register */
 	val = readl(U300_PIN_REG(pinoffset, iev));
 	/* Mask relevant bits */
@@ -600,8 +542,8 @@ static void u300_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 		int irqoffset;
 
 		for_each_set_bit(irqoffset, &val, U300_GPIO_PINS_PER_PORT) {
-			int pin_irq = irq_find_mapping(port->domain, irqoffset);
 			int offset = pinoffset + irqoffset;
+			int pin_irq = irq_find_mapping(chip->irqdomain, offset);
 
 			dev_dbg(gpio->dev, "GPIO IRQ %d on pin %d\n",
 				pin_irq, offset);
@@ -615,7 +557,7 @@ static void u300_gpio_irq_handler(unsigned irq, struct irq_desc *desc)
 		}
 	}
 
-	desc->irq_data.chip->irq_unmask(&desc->irq_data);
+	chained_irq_exit(parent_chip, desc);
 }
 
 static void __init u300_gpio_init_pin(struct u300_gpio *gpio,
@@ -666,20 +608,6 @@ static void __init u300_gpio_init_coh901571(struct u300_gpio *gpio)
 	}
 }
 
-static inline void u300_gpio_free_ports(struct u300_gpio *gpio)
-{
-	struct u300_gpio_port *port;
-	struct list_head *p, *n;
-
-	list_for_each_safe(p, n, &gpio->port_list) {
-		port = list_entry(p, struct u300_gpio_port, node);
-		list_del(&port->node);
-		if (port->domain)
-			irq_domain_remove(port->domain);
-		kfree(port);
-	}
-}
-
 /*
  * Here we map a GPIO in the local gpio_chip pin space to a pin in
  * the local pinctrl pin space. The pin controller used is
@@ -770,17 +698,28 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 	       gpio->base + U300_GPIO_CR);
 	u300_gpio_init_coh901571(gpio);
 
+#ifdef CONFIG_OF_GPIO
+	gpio->chip.of_node = pdev->dev.of_node;
+#endif
+	err = gpiochip_add(&gpio->chip);
+	if (err) {
+		dev_err(gpio->dev, "unable to add gpiochip: %d\n", err);
+		goto err_no_chip;
+	}
+
+	err = gpiochip_irqchip_add(&gpio->chip,
+				   &u300_gpio_irqchip,
+				   0,
+				   handle_simple_irq,
+				   IRQ_TYPE_EDGE_FALLING);
+	if (err) {
+		dev_err(gpio->dev, "no GPIO irqchip\n");
+		goto err_no_irqchip;
+	}
+
 	/* Add each port with its IRQ separately */
-	INIT_LIST_HEAD(&gpio->port_list);
 	for (portno = 0 ; portno < U300_GPIO_NUM_PORTS; portno++) {
-		struct u300_gpio_port *port =
-			kmalloc(sizeof(struct u300_gpio_port), GFP_KERNEL);
-
-		if (!port) {
-			dev_err(gpio->dev, "out of memory\n");
-			err = -ENOMEM;
-			goto err_no_port;
-		}
+		struct u300_gpio_port *port = &gpio->ports[portno];
 
 		snprintf(port->name, 8, "gpio%d", portno);
 		port->number = portno;
@@ -788,50 +727,16 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 
 		port->irq = platform_get_irq(pdev, portno);
 
-		dev_dbg(gpio->dev, "register IRQ %d for port %s\n", port->irq,
-			port->name);
-
-		port->domain = irq_domain_add_linear(pdev->dev.of_node,
-						     U300_GPIO_PINS_PER_PORT,
-						     &irq_domain_simple_ops,
-						     port);
-		if (!port->domain) {
-			err = -ENOMEM;
-			goto err_no_domain;
-		}
-
-		irq_set_chained_handler(port->irq, u300_gpio_irq_handler);
-		irq_set_handler_data(port->irq, port);
-
-		/* For each GPIO pin set the unique IRQ handler */
-		for (i = 0; i < U300_GPIO_PINS_PER_PORT; i++) {
-			int irqno = irq_create_mapping(port->domain, i);
-
-			dev_dbg(gpio->dev, "GPIO%d on port %s gets IRQ %d\n",
-				gpio->chip.base + (port->number << 3) + i,
-				port->name, irqno);
-			irq_set_chip_and_handler(irqno, &u300_gpio_irqchip,
-						 handle_simple_irq);
-			set_irq_flags(irqno, IRQF_VALID);
-			irq_set_chip_data(irqno, port);
-		}
+		gpiochip_set_chained_irqchip(&gpio->chip,
+					     &u300_gpio_irqchip,
+					     port->irq,
+					     u300_gpio_irq_handler);
 
 		/* Turns off irq force (test register) for this port */
 		writel(0x0, gpio->base + portno * gpio->stride + ifr);
-
-		list_add_tail(&port->node, &gpio->port_list);
 	}
 	dev_dbg(gpio->dev, "initialized %d GPIO ports\n", portno);
 
-#ifdef CONFIG_OF_GPIO
-	gpio->chip.of_node = pdev->dev.of_node;
-#endif
-	err = gpiochip_add(&gpio->chip);
-	if (err) {
-		dev_err(gpio->dev, "unable to add gpiochip: %d\n", err);
-		goto err_no_chip;
-	}
-
 	/*
 	 * Add pinctrl pin ranges, the pin controller must be registered
 	 * at this point
@@ -850,12 +755,10 @@ static int __init u300_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 err_no_range:
+err_no_irqchip:
 	if (gpiochip_remove(&gpio->chip))
 		dev_err(&pdev->dev, "failed to remove gpio chip\n");
 err_no_chip:
-err_no_domain:
-err_no_port:
-	u300_gpio_free_ports(gpio);
 	clk_disable_unprepare(gpio->clk);
 	dev_err(&pdev->dev, "module ERROR:%d\n", err);
 	return err;
@@ -874,7 +777,6 @@ static int __exit u300_gpio_remove(struct platform_device *pdev)
 		dev_err(gpio->dev, "unable to remove gpiochip: %d\n", err);
 		return err;
 	}
-	u300_gpio_free_ports(gpio);
 	clk_disable_unprepare(gpio->clk);
 	return 0;
 }
-- 
1.8.5.3

