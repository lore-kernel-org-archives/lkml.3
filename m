Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab3CML00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:26:26 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64874 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab3CML0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:26:23 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 13 Mar 2013 20:32:13 +0900
Message-Id: <20130313113213.30133.10066.sendpatchset@w520>
In-Reply-To: <20130313113203.30133.49539.sendpatchset@w520>
References: <20130313113203.30133.49539.sendpatchset@w520>
Subject: [PATCH 01/03] gpio: Renesas R-Car GPIO driver V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch is V2 of a GPIO driver for the R-Car series of
SoCs from Renesas. This driver is designed to be reusable
between multiple SoCs that share the same basic building block,
but so far it has only been used on R-Car H1 (r8a7779).

Each driver instance handles 32 GPIOs with individually
maskable IRQs. The driver operates on a single I/O memory 
range and the 32 GPIOs are hooked up a single interrupt.

In the case of R-Car H1 either external IRQ pins or GPIOs
with interrupts can be used for on-board interupts. For
external IRQs 4 pins are supported, and in the case of GPIO
there are 202 GPIOS as 202 interrupts hooked up via 6 driver
instances and to the GIC and the Cortex-A9 Quad.

At this point this driver is interfacing as a regular
platform device driver. In the future DT support will be
submitted as an incremental feature patch.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes since V1:
 - Update based on most suggestions from review by Laurent, thanks!
 
 Please note that in V2 the driver is reworked to reduce the number of
 lines and includes minor changes related to headers, printouts and
 data types. In V2 the register access order is kept the same as in V1,
 and to make that happen IRQCHIP_SET_TYPE_MASKED is omitted. The interface
 to the Linux kernel is unchanged except the use of dev_dbg() instead of
 pr_debug(). So from a hardware point of view V2 is a drop in replacement
 for V1 and there should be no additional dependencies since devm is
 kept as a separate patch as well. All this to make back porting easier.

 drivers/gpio/Kconfig                    |    6 
 drivers/gpio/Makefile                   |    1 
 drivers/gpio/gpio-rcar.c                |  383 +++++++++++++++++++++++++++++++
 include/linux/platform_data/gpio-rcar.h |   25 ++
 4 files changed, 415 insertions(+)

--- 0001/drivers/gpio/Kconfig
+++ work/drivers/gpio/Kconfig	2013-03-13 19:39:44.000000000 +0900
@@ -201,6 +201,12 @@ config GPIO_PXA
 	help
 	  Say yes here to support the PXA GPIO device
 
+config GPIO_RCAR
+	tristate "Renesas R-Car GPIO"
+	depends on ARM
+	help
+	  Say yes here to support GPIO on Renesas R-Car SoCs.
+
 config GPIO_SPEAR_SPICS
 	bool "ST SPEAr13xx SPI Chip Select as GPIO support"
 	depends on PLAT_SPEAR
--- 0001/drivers/gpio/Makefile
+++ work/drivers/gpio/Makefile	2013-03-13 19:39:44.000000000 +0900
@@ -56,6 +56,7 @@ obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
 obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
 obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
+obj-$(CONFIG_GPIO_RCAR)		+= gpio-rcar.o
 obj-$(CONFIG_PLAT_SAMSUNG)	+= gpio-samsung.o
 obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
 obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
--- /dev/null
+++ work/drivers/gpio/gpio-rcar.c	2013-03-13 19:41:35.000000000 +0900
@@ -0,0 +1,383 @@
+/*
+ * Renesas R-Car GPIO Support
+ *
+ *  Copyright (C) 2013 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/module.h>
+#include <linux/platform_data/gpio-rcar.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+
+struct gpio_rcar_priv {
+	void __iomem *base;
+	spinlock_t lock;
+	struct gpio_rcar_config config;
+	struct platform_device *pdev;
+	struct gpio_chip gpio_chip;
+	struct irq_chip irq_chip;
+	struct irq_domain *irq_domain;
+};
+
+#define IOINTSEL 0x00
+#define INOUTSEL 0x04
+#define OUTDT 0x08
+#define INDT 0x0c
+#define INTDT 0x10
+#define INTCLR 0x14
+#define INTMSK 0x18
+#define MSKCLR 0x1c
+#define POSNEG 0x20
+#define EDGLEVEL 0x24
+#define FILONOFF 0x28
+
+static inline u32 gpio_rcar_read(struct gpio_rcar_priv *p, int offs)
+{
+	return ioread32(p->base + offs);
+}
+
+static inline void gpio_rcar_write(struct gpio_rcar_priv *p, int offs,
+				   u32 value)
+{
+	iowrite32(value, p->base + offs);
+}
+
+static void gpio_rcar_modify_bit(struct gpio_rcar_priv *p, int offs,
+				 int bit, bool value)
+{
+	u32 tmp = gpio_rcar_read(p, offs);
+
+	if (value)
+		tmp |= BIT(bit);
+	else
+		tmp &= ~BIT(bit);
+
+	gpio_rcar_write(p, offs, tmp);
+}
+
+static void gpio_rcar_irq_disable(struct irq_data *d)
+{
+	struct gpio_rcar_priv *p = irq_data_get_irq_chip_data(d);
+
+	gpio_rcar_write(p, INTMSK, ~BIT(irqd_to_hwirq(d)));
+}
+
+static void gpio_rcar_irq_enable(struct irq_data *d)
+{
+	struct gpio_rcar_priv *p = irq_data_get_irq_chip_data(d);
+
+	gpio_rcar_write(p, MSKCLR, BIT(irqd_to_hwirq(d)));
+}
+
+static void gpio_rcar_config_interrupt_input_mode(struct gpio_rcar_priv *p,
+						  unsigned int hwirq,
+						  bool active_high_rising_edge,
+						  bool level_trigger)
+{
+	unsigned long flags;
+
+	/* follow steps in the GPIO documentation for
+	 * "Setting Edge-Sensitive Interrupt Input Mode" and
+	 * "Setting Level-Sensitive Interrupt Input Mode"
+	 */
+
+	spin_lock_irqsave(&p->lock, flags);
+
+	/* Configure postive or negative logic in POSNEG */
+	gpio_rcar_modify_bit(p, POSNEG, hwirq, !active_high_rising_edge);
+
+	/* Configure edge or level trigger in EDGLEVEL */
+	gpio_rcar_modify_bit(p, EDGLEVEL, hwirq, !level_trigger);
+
+	/* Select "Interrupt Input Mode" in IOINTSEL */
+	gpio_rcar_modify_bit(p, IOINTSEL, hwirq, true);
+
+	/* Write INTCLR in case of edge trigger */
+	if (!level_trigger)
+		gpio_rcar_write(p, INTCLR, BIT(hwirq));
+
+	spin_unlock_irqrestore(&p->lock, flags);
+}
+
+static int gpio_rcar_irq_set_type(struct irq_data *d, unsigned int type)
+{
+	struct gpio_rcar_priv *p = irq_data_get_irq_chip_data(d);
+	unsigned int hwirq = irqd_to_hwirq(d);
+
+	dev_dbg(&p->pdev->dev, "sense irq = %d, type = %d\n", hwirq, type);
+
+	switch (type & IRQ_TYPE_SENSE_MASK) {
+	case IRQ_TYPE_LEVEL_HIGH:
+		gpio_rcar_config_interrupt_input_mode(p, hwirq, true, true);
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		gpio_rcar_config_interrupt_input_mode(p, hwirq, false, true);
+		break;
+	case IRQ_TYPE_EDGE_RISING:
+		gpio_rcar_config_interrupt_input_mode(p, hwirq, true, false);
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		gpio_rcar_config_interrupt_input_mode(p, hwirq, false, false);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static irqreturn_t gpio_rcar_irq_handler(int irq, void *dev_id)
+{
+	struct gpio_rcar_priv *p = dev_id;
+	u32 pending;
+	unsigned int offset, irqs_handled = 0;
+
+	while ((pending = gpio_rcar_read(p, INTDT))) {
+		offset = __ffs(pending);
+		gpio_rcar_write(p, INTCLR, BIT(offset));
+		generic_handle_irq(irq_find_mapping(p->irq_domain, offset));
+		irqs_handled++;
+	}
+
+	return irqs_handled ? IRQ_HANDLED : IRQ_NONE;
+}
+
+static inline struct gpio_rcar_priv *gpio_to_priv(struct gpio_chip *chip)
+{
+	return container_of(chip, struct gpio_rcar_priv, gpio_chip);
+}
+
+static void gpio_rcar_config_general_input_output_mode(struct gpio_chip *chip,
+						       unsigned int gpio,
+						       bool output)
+{
+	struct gpio_rcar_priv *p = gpio_to_priv(chip);
+	unsigned long flags;
+
+	/* follow steps in the GPIO documentation for
+	 * "Setting General Output Mode" and
+	 * "Setting General Input Mode"
+	 */
+
+	spin_lock_irqsave(&p->lock, flags);
+
+	/* Configure postive logic in POSNEG */
+	gpio_rcar_modify_bit(p, POSNEG, gpio, false);
+
+	/* Select "General Input/Output Mode" in IOINTSEL */
+	gpio_rcar_modify_bit(p, IOINTSEL, gpio, false);
+
+	/* Select Input Mode or Output Mode in INOUTSEL */
+	gpio_rcar_modify_bit(p, INOUTSEL, gpio, output);
+
+	spin_unlock_irqrestore(&p->lock, flags);
+}
+
+static int gpio_rcar_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	gpio_rcar_config_general_input_output_mode(chip, offset, false);
+	return 0;
+}
+
+static int gpio_rcar_get(struct gpio_chip *chip, unsigned offset)
+{
+	return (int)(gpio_rcar_read(gpio_to_priv(chip), INDT) & BIT(offset));
+}
+
+static void gpio_rcar_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct gpio_rcar_priv *p = gpio_to_priv(chip);
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->lock, flags);
+	gpio_rcar_modify_bit(p, OUTDT, offset, value);
+	spin_unlock_irqrestore(&p->lock, flags);
+}
+
+static int gpio_rcar_direction_output(struct gpio_chip *chip, unsigned offset,
+				      int value)
+{
+	/* write GPIO value to output before selecting output mode of pin */
+	gpio_rcar_set(chip, offset, value);
+	gpio_rcar_config_general_input_output_mode(chip, offset, true);
+	return 0;
+}
+
+static int gpio_rcar_to_irq(struct gpio_chip *chip, unsigned offset)
+{
+	return irq_create_mapping(gpio_to_priv(chip)->irq_domain, offset);
+}
+
+static int gpio_rcar_irq_domain_map(struct irq_domain *h, unsigned int virq,
+				 irq_hw_number_t hw)
+{
+	struct gpio_rcar_priv *p = h->host_data;
+
+	dev_dbg(&p->pdev->dev, "map hw irq = %d, virq = %d\n", (int)hw, virq);
+
+	irq_set_chip_data(virq, h->host_data);
+	irq_set_chip_and_handler(virq, &p->irq_chip, handle_level_irq);
+	set_irq_flags(virq, IRQF_VALID); /* kill me now */
+	return 0;
+}
+
+static struct irq_domain_ops gpio_rcar_irq_domain_ops = {
+	.map	= gpio_rcar_irq_domain_map,
+};
+
+static int gpio_rcar_probe(struct platform_device *pdev)
+{
+	struct gpio_rcar_config *pdata = pdev->dev.platform_data;
+	struct gpio_rcar_priv *p;
+	struct resource *io, *irq;
+	struct gpio_chip *gpio_chip;
+	struct irq_chip *irq_chip;
+	const char *name = dev_name(&pdev->dev);
+	int ret;
+
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		dev_err(&pdev->dev, "failed to allocate driver data\n");
+		ret = -ENOMEM;
+		goto err0;
+	}
+
+	/* deal with driver instance configuration */
+	if (pdata)
+		p->config = *pdata;
+
+	p->pdev = pdev;
+	platform_set_drvdata(pdev, p);
+	spin_lock_init(&p->lock);
+
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+
+	if (!io || !irq) {
+		dev_err(&pdev->dev, "missing IRQ or IOMEM\n");
+		ret = -EINVAL;
+		goto err1;
+	}
+
+	p->base = ioremap_nocache(io->start, resource_size(io));
+	if (!p->base) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		ret = -ENXIO;
+		goto err1;
+	}
+
+	gpio_chip = &p->gpio_chip;
+	gpio_chip->direction_input = gpio_rcar_direction_input;
+	gpio_chip->get = gpio_rcar_get;
+	gpio_chip->direction_output = gpio_rcar_direction_output;
+	gpio_chip->set = gpio_rcar_set;
+	gpio_chip->to_irq = gpio_rcar_to_irq;
+	gpio_chip->label = name;
+	gpio_chip->owner = THIS_MODULE;
+	gpio_chip->base = p->config.gpio_base;
+	gpio_chip->ngpio = p->config.number_of_pins;
+
+	irq_chip = &p->irq_chip;
+	irq_chip->name = name;
+	irq_chip->irq_mask = gpio_rcar_irq_disable;
+	irq_chip->irq_unmask = gpio_rcar_irq_enable;
+	irq_chip->irq_enable = gpio_rcar_irq_enable;
+	irq_chip->irq_disable = gpio_rcar_irq_disable;
+	irq_chip->irq_set_type = gpio_rcar_irq_set_type;
+	irq_chip->flags	= IRQCHIP_SKIP_SET_WAKE;
+
+	p->irq_domain = irq_domain_add_simple(pdev->dev.of_node,
+					      p->config.number_of_pins,
+					      p->config.irq_base,
+					      &gpio_rcar_irq_domain_ops, p);
+	if (!p->irq_domain) {
+		ret = -ENXIO;
+		dev_err(&pdev->dev, "cannot initialize irq domain\n");
+		goto err2;
+	}
+
+	if (request_irq(irq->start, gpio_rcar_irq_handler, 0, name, p)) {
+		dev_err(&pdev->dev, "failed to request IRQ\n");
+		ret = -ENOENT;
+		goto err3;
+	}
+
+	ret = gpiochip_add(gpio_chip);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add GPIO controller\n");
+		goto err4;
+	}
+
+	dev_info(&pdev->dev, "driving %d GPIOs\n", p->config.number_of_pins);
+
+	/* warn in case of mismatch if irq base is specified */
+	if (p->config.irq_base) {
+		ret = irq_find_mapping(p->irq_domain, 0);
+		if (p->config.irq_base != ret)
+			dev_warn(&pdev->dev, "irq base mismatch (%u/%u)\n",
+				 p->config.irq_base, ret);
+	}
+
+	return 0;
+
+err4:
+	free_irq(irq->start, p);
+err3:
+	irq_domain_remove(p->irq_domain);
+err2:
+	iounmap(p->base);
+err1:
+	kfree(p);
+err0:
+	return ret;
+}
+
+static int gpio_rcar_remove(struct platform_device *pdev)
+{
+	struct gpio_rcar_priv *p = platform_get_drvdata(pdev);
+	struct resource *irq;
+	int ret;
+
+	ret = gpiochip_remove(&p->gpio_chip);
+	if (ret)
+		return ret;
+
+	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+
+	free_irq(irq->start, p);
+	irq_domain_remove(p->irq_domain);
+	iounmap(p->base);
+	kfree(p);
+	return 0;
+}
+
+static struct platform_driver gpio_rcar_device_driver = {
+	.probe		= gpio_rcar_probe,
+	.remove		= gpio_rcar_remove,
+	.driver		= {
+		.name	= "gpio_rcar",
+	}
+};
+
+module_platform_driver(gpio_rcar_device_driver);
+
+MODULE_AUTHOR("Magnus Damm");
+MODULE_DESCRIPTION("Renesas R-Car GPIO Driver");
+MODULE_LICENSE("GPL v2");
--- /dev/null
+++ work/include/linux/platform_data/gpio-rcar.h	2013-03-13 19:40:03.000000000 +0900
@@ -0,0 +1,25 @@
+/*
+ * Renesas R-Car GPIO Support
+ *
+ *  Copyright (C) 2013 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __GPIO_RCAR_H__
+#define __GPIO_RCAR_H__
+
+struct gpio_rcar_config {
+	unsigned int gpio_base;
+	unsigned int irq_base;
+	unsigned int number_of_pins;
+};
+
+#endif /* __GPIO_RCAR_H__ */
