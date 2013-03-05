Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab3CEA0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 19:26:35 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:60586 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3CEA0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 19:26:33 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: grant.likely@secretlab.ca, Magnus Damm <magnus.damm@gmail.com>,
        horms@verge.net.au, linus.walleij@linaro.org, linux-sh@vger.kernel.org
Date: Tue, 05 Mar 2013 09:32:19 +0900
Message-Id: <20130305003219.14792.13300.sendpatchset@w520>
Subject: [PATCH] gpio: Renesas R-Car GPIO driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch implements a GPIO driver for the R-Car series
of SoCs from Renesas. This driver is designed to be reusable
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

 drivers/gpio/Kconfig                    |    6 
 drivers/gpio/Makefile                   |    1 
 drivers/gpio/gpio-rcar.c                |  406 +++++++++++++++++++++++++++++++
 include/linux/platform_data/gpio-rcar.h |   29 ++
 4 files changed, 442 insertions(+)

--- 0001/drivers/gpio/Kconfig
+++ work/drivers/gpio/Kconfig	2013-03-05 09:07:34.000000000 +0900
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
+++ work/drivers/gpio/Makefile	2013-03-05 09:07:34.000000000 +0900
@@ -56,6 +56,7 @@ obj-$(CONFIG_GPIO_PL061)	+= gpio-pl061.o
 obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
 obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
+obj-$(CONFIG_GPIO_RCAR)		+= gpio-rcar.o
 obj-$(CONFIG_PLAT_SAMSUNG)	+= gpio-samsung.o
 obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
 obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
--- /dev/null
+++ work/drivers/gpio/gpio-rcar.c	2013-03-05 09:13:23.000000000 +0900
@@ -0,0 +1,406 @@
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/irqdomain.h>
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_data/gpio-rcar.h>
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
+static inline unsigned long gpio_rcar_read(struct gpio_rcar_priv *p, int offs)
+{
+	return ioread32(p->base + offs);
+}
+
+static inline void gpio_rcar_write(struct gpio_rcar_priv *p, int offs,
+				   unsigned long value)
+{
+	iowrite32(value, p->base + offs);
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
+	unsigned long bit = BIT(hwirq);
+	unsigned long flags, tmp;
+
+	/* follow steps in the GPIO documentation for
+	 * "Setting Edge-Sensitive Interrupt Input Mode" and
+	 * "Setting Level-Sensitive Interrupt Input Mode"
+	 */
+
+	spin_lock_irqsave(&p->lock, flags);
+
+	/* Configure postive or negative logic in POSNEG */
+	tmp = gpio_rcar_read(p, POSNEG);
+	if (active_high_rising_edge)
+		tmp &= ~bit;
+	else
+		tmp |= bit;
+	gpio_rcar_write(p, POSNEG, tmp);
+
+	/* Configure edge or level trigger in EDGLEVEL */
+	tmp = gpio_rcar_read(p, EDGLEVEL);
+	if (level_trigger)
+		tmp &= ~bit;
+	else
+		tmp |= bit;
+	gpio_rcar_write(p, EDGLEVEL, tmp);
+
+	/* Select "Interrupt Input Mode" in IOINTSEL */
+	tmp = gpio_rcar_read(p, IOINTSEL);
+	tmp |= bit;
+	gpio_rcar_write(p, IOINTSEL, tmp);
+
+	/* Write INTCLR in case of edge trigger */
+	if (!level_trigger)
+		gpio_rcar_write(p, INTCLR, bit);
+
+	spin_unlock_irqrestore(&p->lock, flags);
+}
+
+static int gpio_rcar_irq_set_type(struct irq_data *d, unsigned int type)
+{
+	struct gpio_rcar_priv *p = irq_data_get_irq_chip_data(d);
+	unsigned int hwirq = irqd_to_hwirq(d);
+
+	pr_debug("gpio: sense irq = %d, type = %d\n", hwirq, type);
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
+	unsigned long pending;
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
+	unsigned long bit = BIT(gpio);
+	unsigned long flags, tmp;
+
+	/* follow steps in the GPIO documentation for
+	 * "Setting General Output Mode" and
+	 * "Setting General Input Mode"
+	 */
+
+	spin_lock_irqsave(&p->lock, flags);
+
+	/* Configure postive logic in POSNEG */
+	tmp = gpio_rcar_read(p, POSNEG);
+	tmp &= ~bit;
+	gpio_rcar_write(p, POSNEG, tmp);
+
+	/* Select "General Input/Output Mode" in IOINTSEL */
+	tmp = gpio_rcar_read(p, IOINTSEL);
+	tmp &= ~bit;
+	gpio_rcar_write(p, IOINTSEL, tmp);
+
+	/* Select Input Mode or Output Mode in INOUTSEL */
+	tmp = gpio_rcar_read(p, INOUTSEL);
+	if (output)
+		tmp |= bit;
+	else
+		tmp &= ~bit;
+	gpio_rcar_write(p, INOUTSEL, tmp);
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
+	unsigned long bit = BIT(offset);
+	unsigned long flags, tmp;
+
+	spin_lock_irqsave(&p->lock, flags);
+
+	tmp = gpio_rcar_read(p, OUTDT);
+	if (value)
+		tmp |= bit;
+	else
+		tmp &= ~bit;
+	gpio_rcar_write(p, OUTDT, tmp);
+
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
+	pr_debug("gpio: map hw irq = %d, virq = %d\n", (int)hw, virq);
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
+		memcpy(&p->config, pdata, sizeof(*pdata));
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
+			dev_warn(&pdev->dev, "irq base mismatch (%d/%d)\n",
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
+++ work/include/linux/platform_data/gpio-rcar.h	2013-03-05 09:07:35.000000000 +0900
@@ -0,0 +1,29 @@
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
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
