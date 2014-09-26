Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbaIZL50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:57:26 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:47709 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaIZL5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:57:20 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "In-Reply-To"
From: Stefan Agner <stefan@agner.ch>
To: linus.walleij@linaro.org, shawn.guo@freescale.com
Cc: gnurou@gmail.com, kernel@pengutronix.de, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpringlemeir@nbsps.com, l.stach@pengutronix.de, stefan@agner.ch
Subject: [PATCH v4 2/4] gpio: vf610: add gpiolib/IRQ chip driver for Vybrid
Date: Fri, 26 Sep 2014 13:57:09 +0200
Message-Id: <d978829094e6a287415dc1baeabb0aed2799aafc.1411731755.git.stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1411731755.git.stefan@agner.ch>
References: <cover.1411731755.git.stefan@agner.ch>
In-Reply-To: <cover.1411731755.git.stefan@agner.ch>
References: <cover.1411731755.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a gpiolib and IRQ chip driver for Vybrid ARM SoC using the
Vybrid's GPIO and PORT module. The driver is instanced once per
each GPIO/PORT module pair and handles 32 GPIO's.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Acked-by: Shawn Guo <shawn.guo@freescale.com>
---
 drivers/gpio/Kconfig      |   7 ++
 drivers/gpio/Makefile     |   1 +
 drivers/gpio/gpio-vf610.c | 295 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 303 insertions(+)
 create mode 100644 drivers/gpio/gpio-vf610.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 9de1515..82b38f5 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -334,6 +334,13 @@ config GPIO_TZ1090_PDC
 	help
 	  Say yes here to support Toumaz Xenif TZ1090 PDC GPIOs.
 
+config GPIO_VF610
+	def_bool y
+	depends on ARCH_MXC && SOC_VF610
+	select GPIOLIB_IRQCHIP
+	help
+	  Say yes here to support Vybrid vf610 GPIOs.
+
 config GPIO_XILINX
 	bool "Xilinx GPIO support"
 	depends on PPC_OF || MICROBLAZE || ARCH_ZYNQ
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 5d024e3..9893d4c 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -95,6 +95,7 @@ obj-$(CONFIG_GPIO_TWL6040)	+= gpio-twl6040.o
 obj-$(CONFIG_GPIO_TZ1090)	+= gpio-tz1090.o
 obj-$(CONFIG_GPIO_TZ1090_PDC)	+= gpio-tz1090-pdc.o
 obj-$(CONFIG_GPIO_UCB1400)	+= gpio-ucb1400.o
+obj-$(CONFIG_GPIO_VF610)	+= gpio-vf610.o
 obj-$(CONFIG_GPIO_VIPERBOARD)	+= gpio-viperboard.o
 obj-$(CONFIG_GPIO_VR41XX)	+= gpio-vr41xx.o
 obj-$(CONFIG_GPIO_VX855)	+= gpio-vx855.o
diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
new file mode 100644
index 0000000..4ee4cee
--- /dev/null
+++ b/drivers/gpio/gpio-vf610.c
@@ -0,0 +1,295 @@
+/*
+ * vf610 GPIO support through PORT and GPIO module
+ *
+ * Copyright (c) 2014 Toradex AG.
+ *
+ * Author: Stefan Agner <stefan@agner.ch>.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_irq.h>
+
+#define VF610_GPIO_PER_PORT		32
+
+struct vf610_gpio_port {
+	struct gpio_chip gc;
+	void __iomem *base;
+	void __iomem *gpio_base;
+	u8 irqc[VF610_GPIO_PER_PORT];
+	int irq;
+};
+
+#define GPIO_PDOR		0x00
+#define GPIO_PSOR		0x04
+#define GPIO_PCOR		0x08
+#define GPIO_PTOR		0x0c
+#define GPIO_PDIR		0x10
+
+#define PORT_PCR(n)		((n) * 0x4)
+#define PORT_PCR_IRQC_OFFSET	16
+
+#define PORT_ISFR		0xa0
+#define PORT_DFER		0xc0
+#define PORT_DFCR		0xc4
+#define PORT_DFWR		0xc8
+
+#define PORT_INT_OFF		0x0
+#define PORT_INT_LOGIC_ZERO	0x8
+#define PORT_INT_RISING_EDGE	0x9
+#define PORT_INT_FALLING_EDGE	0xa
+#define PORT_INT_EITHER_EDGE	0xb
+#define PORT_INT_LOGIC_ONE	0xc
+
+static const struct of_device_id vf610_gpio_dt_ids[] = {
+	{ .compatible = "fsl,vf610-gpio" },
+	{ /* sentinel */ }
+};
+
+static inline void vf610_gpio_writel(u32 val, void __iomem *reg)
+{
+	writel_relaxed(val, reg);
+}
+
+static inline u32 vf610_gpio_readl(void __iomem *reg)
+{
+	return readl_relaxed(reg);
+}
+
+static int vf610_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void vf610_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+}
+
+static int vf610_gpio_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct vf610_gpio_port *port =
+		container_of(gc, struct vf610_gpio_port, gc);
+
+	return !!(vf610_gpio_readl(port->gpio_base + GPIO_PDIR) & BIT(gpio));
+}
+
+static void vf610_gpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	struct vf610_gpio_port *port =
+		container_of(gc, struct vf610_gpio_port, gc);
+	unsigned long mask = BIT(gpio);
+
+	if (val)
+		vf610_gpio_writel(mask, port->gpio_base + GPIO_PSOR);
+	else
+		vf610_gpio_writel(mask, port->gpio_base + GPIO_PCOR);
+}
+
+static int vf610_gpio_direction_input(struct gpio_chip *chip, unsigned gpio)
+{
+	return pinctrl_gpio_direction_input(chip->base + gpio);
+}
+
+static int vf610_gpio_direction_output(struct gpio_chip *chip, unsigned gpio,
+				       int value)
+{
+	vf610_gpio_set(chip, gpio, value);
+
+	return pinctrl_gpio_direction_output(chip->base + gpio);
+}
+
+static void vf610_gpio_irq_handler(u32 irq, struct irq_desc *desc)
+{
+	struct vf610_gpio_port *port = irq_get_handler_data(irq);
+	struct irq_chip *chip = irq_desc_get_chip(desc);
+	int pin;
+	unsigned long irq_isfr;
+
+	chained_irq_enter(chip, desc);
+
+	irq_isfr = vf610_gpio_readl(port->base + PORT_ISFR);
+
+	for_each_set_bit(pin, &irq_isfr, VF610_GPIO_PER_PORT) {
+		vf610_gpio_writel(BIT(pin), port->base + PORT_ISFR);
+
+		generic_handle_irq(irq_find_mapping(port->gc.irqdomain, pin));
+	}
+
+	chained_irq_exit(chip, desc);
+}
+
+static void vf610_gpio_irq_ack(struct irq_data *d)
+{
+	struct vf610_gpio_port *port = irq_data_get_irq_chip_data(d);
+	int gpio = d->hwirq;
+
+	vf610_gpio_writel(BIT(gpio), port->base + PORT_ISFR);
+}
+
+static int vf610_gpio_irq_set_type(struct irq_data *d, u32 type)
+{
+	struct vf610_gpio_port *port = irq_data_get_irq_chip_data(d);
+	u8 irqc;
+
+	switch (type) {
+	case IRQ_TYPE_EDGE_RISING:
+		irqc = PORT_INT_RISING_EDGE;
+		break;
+	case IRQ_TYPE_EDGE_FALLING:
+		irqc = PORT_INT_FALLING_EDGE;
+		break;
+	case IRQ_TYPE_EDGE_BOTH:
+		irqc = PORT_INT_EITHER_EDGE;
+		break;
+	case IRQ_TYPE_LEVEL_LOW:
+		irqc = PORT_INT_LOGIC_ZERO;
+		break;
+	case IRQ_TYPE_LEVEL_HIGH:
+		irqc = PORT_INT_LOGIC_ONE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	port->irqc[d->hwirq] = irqc;
+
+	return 0;
+}
+
+static void vf610_gpio_irq_mask(struct irq_data *d)
+{
+	struct vf610_gpio_port *port = irq_data_get_irq_chip_data(d);
+	void __iomem *pcr_base = port->base + PORT_PCR(d->hwirq);
+
+	vf610_gpio_writel(0, pcr_base);
+}
+
+static void vf610_gpio_irq_unmask(struct irq_data *d)
+{
+	struct vf610_gpio_port *port = irq_data_get_irq_chip_data(d);
+	void __iomem *pcr_base = port->base + PORT_PCR(d->hwirq);
+
+	vf610_gpio_writel(port->irqc[d->hwirq] << PORT_PCR_IRQC_OFFSET,
+			  pcr_base);
+}
+
+static int vf610_gpio_irq_set_wake(struct irq_data *d, u32 enable)
+{
+	struct vf610_gpio_port *port = irq_data_get_irq_chip_data(d);
+
+	if (enable)
+		enable_irq_wake(port->irq);
+	else
+		disable_irq_wake(port->irq);
+
+	return 0;
+}
+
+static struct irq_chip vf610_gpio_irq_chip = {
+	.name		= "gpio-vf610",
+	.irq_ack	= vf610_gpio_irq_ack,
+	.irq_mask	= vf610_gpio_irq_mask,
+	.irq_unmask	= vf610_gpio_irq_unmask,
+	.irq_set_type	= vf610_gpio_irq_set_type,
+	.irq_set_wake	= vf610_gpio_irq_set_wake,
+};
+
+static int vf610_gpio_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct vf610_gpio_port *port;
+	struct resource *iores;
+	struct gpio_chip *gc;
+	int ret;
+
+	port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
+	if (!port)
+		return -ENOMEM;
+
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	port->base = devm_ioremap_resource(dev, iores);
+	if (IS_ERR(port->base))
+		return PTR_ERR(port->base);
+
+	iores = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	port->gpio_base = devm_ioremap_resource(dev, iores);
+	if (IS_ERR(port->gpio_base))
+		return PTR_ERR(port->gpio_base);
+
+	port->irq = platform_get_irq(pdev, 0);
+	if (port->irq < 0)
+		return port->irq;
+
+	gc = &port->gc;
+	gc->of_node = np;
+	gc->dev = dev;
+	gc->label = "vf610-gpio",
+	gc->ngpio = VF610_GPIO_PER_PORT,
+	gc->base = of_alias_get_id(np, "gpio") * VF610_GPIO_PER_PORT;
+
+	gc->request = vf610_gpio_request,
+	gc->free = vf610_gpio_free,
+	gc->direction_input = vf610_gpio_direction_input,
+	gc->get = vf610_gpio_get,
+	gc->direction_output = vf610_gpio_direction_output,
+	gc->set = vf610_gpio_set,
+
+	ret = gpiochip_add(gc);
+	if (ret < 0)
+		return ret;
+
+	/* Clear the interrupt status register for all GPIO's */
+	vf610_gpio_writel(~0, port->base + PORT_ISFR);
+
+	ret = gpiochip_irqchip_add(gc, &vf610_gpio_irq_chip, 0,
+				   handle_simple_irq, IRQ_TYPE_NONE);
+	if (ret) {
+		dev_err(dev, "failed to add irqchip\n");
+		gpiochip_remove(gc);
+		return ret;
+	}
+	gpiochip_set_chained_irqchip(gc, &vf610_gpio_irq_chip, port->irq,
+				     vf610_gpio_irq_handler);
+
+	return 0;
+}
+
+static struct platform_driver vf610_gpio_driver = {
+	.driver		= {
+		.name	= "gpio-vf610",
+		.owner	= THIS_MODULE,
+		.of_match_table = vf610_gpio_dt_ids,
+	},
+	.probe		= vf610_gpio_probe,
+};
+
+static int __init gpio_vf610_init(void)
+{
+	return platform_driver_register(&vf610_gpio_driver);
+}
+device_initcall(gpio_vf610_init);
+
+MODULE_AUTHOR("Stefan Agner <stefan@agner.ch>");
+MODULE_DESCRIPTION("Freescale VF610 GPIO");
+MODULE_LICENSE("GPL v2");
-- 
2.1.0

