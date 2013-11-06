Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3KFXrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:47:04 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52560 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3KFXrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:47:00 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 07 Nov 2013 08:47:37 +0900
Message-Id: <20131106234737.8971.37405.sendpatchset@w520>
Subject: [PATCH] gpio: Renesas RZ GPIO driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch adds a GPIO driver for the RZ series of SoCs from
Renesas. The driver can be used as platform device with dynamic
or static GPIO assignment or via DT using dynamic GPIOs.

The hardware allows control of GPIOs in blocks of up to 16 pins,
and once device may span multiple blocks. Interrupts are not
included in this hardware block, if interrupts are needed then
the PFC needs to be configured to a IRQ pin function which is
handled by the GIC hardware.

Tested with yet-to-be-posted platform device and DT devices on
r7s72100 and Genmai using LEDs, DIP switches and I2C bitbang.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/gpio/Kconfig                  |    6 
 drivers/gpio/Makefile                 |    1 
 drivers/gpio/gpio-rz.c                |  241 +++++++++++++++++++++++++++++++++
 include/linux/platform_data/gpio-rz.h |   13 +
 4 files changed, 261 insertions(+)

--- 0001/drivers/gpio/Kconfig
+++ work/drivers/gpio/Kconfig	2013-11-06 12:07:13.000000000 +0900
@@ -230,6 +230,12 @@ config GPIO_RCAR
 	help
 	  Say yes here to support GPIO on Renesas R-Car SoCs.
 
+config GPIO_RZ
+	tristate "Renesas RZ GPIO"
+	depends on ARM
+	help
+	  Say yes here to support GPIO on Renesas RZ SoCs.
+
 config GPIO_SAMSUNG
 	bool
 	depends on PLAT_SAMSUNG
--- 0001/drivers/gpio/Makefile
+++ work/drivers/gpio/Makefile	2013-11-06 12:07:13.000000000 +0900
@@ -62,6 +62,7 @@ obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
 obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
 obj-$(CONFIG_GPIO_RCAR)		+= gpio-rcar.o
+obj-$(CONFIG_GPIO_RZ)		+= gpio-rz.o
 obj-$(CONFIG_GPIO_SAMSUNG)	+= gpio-samsung.o
 obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
 obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
--- /dev/null
+++ work/drivers/gpio/gpio-rz.c	2013-11-06 14:20:02.000000000 +0900
@@ -0,0 +1,241 @@
+/*
+ * RZ GPIO Support - Ports
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
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/platform_data/gpio-rz.h>
+
+enum { REG_PSR, REG_PPR, REG_PMSR, REG_NR };
+
+struct rz_gpio_priv {
+	void __iomem *io[REG_NR];
+	struct gpio_chip gpio_chip;
+};
+
+static inline unsigned long rz_gpio_read_ppr(struct rz_gpio_priv *p, int offs)
+{
+	unsigned long msk = BIT(offs % RZ_GPIOS_PER_PORT);
+	int offset = (offs / RZ_GPIOS_PER_PORT) * 4;
+
+	return ioread32(p->io[REG_PPR] + offset) & msk;
+}
+
+static inline void rz_gpio_write(struct rz_gpio_priv *p, int reg, int offs,
+				 bool value)
+{
+	unsigned long msk = BIT(offs % RZ_GPIOS_PER_PORT);
+	int offset = (offs / RZ_GPIOS_PER_PORT) * 4;
+
+	/* upper 16 bits contain mask and lower 16 actual value */
+	iowrite32(value ? (msk | (msk << 16)) : (msk << 16),
+		  p->io[reg] + offset);
+}
+
+static inline struct rz_gpio_priv *gpio_to_priv(struct gpio_chip *chip)
+{
+	return container_of(chip, struct rz_gpio_priv, gpio_chip);
+}
+
+static int rz_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	/* Set bit in PM register via PMSR to disable output */
+	rz_gpio_write(gpio_to_priv(chip), REG_PMSR, offset, true);
+	return 0;
+}
+
+static int rz_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	/* Get bit from PPR register to determine pin state */
+	return (int)(rz_gpio_read_ppr(gpio_to_priv(chip), offset));
+}
+
+static void rz_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	/* Set bit in P register via PSR to control output */
+	rz_gpio_write(gpio_to_priv(chip), REG_PSR, offset, !!value);
+}
+
+static int rz_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+				   int value)
+{
+	/* Write GPIO value to output before selecting output mode of pin */
+	rz_gpio_set(chip, offset, value);
+
+	/* Clear bit in PM register via PMSR to enable output */
+	rz_gpio_write(gpio_to_priv(chip), REG_PMSR, offset, false);
+	return 0;
+}
+
+static int rz_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	return pinctrl_request_gpio(chip->base + offset);
+}
+
+static void rz_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	pinctrl_free_gpio(chip->base + offset);
+
+	/* Set the GPIO as an input to ensure that the next GPIO request won't
+	* drive the GPIO pin as an output.
+	*/
+	rz_gpio_direction_input(chip, offset);
+}
+
+static int rz_gpio_probe(struct platform_device *pdev)
+{
+	struct gpio_rz_config *pdata = dev_get_platdata(&pdev->dev);
+	struct rz_gpio_priv *p;
+	struct resource *io[3];
+	struct gpio_chip *gpio_chip;
+	struct device_node *np = pdev->dev.of_node;
+	struct of_phandle_args args;
+	int number_of_pins, gpio_base;
+	int k, nr;
+	int ret;
+
+	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		dev_err(&pdev->dev, "failed to allocate driver data\n");
+		return -ENOMEM;
+	}
+
+	for (k = 0; k < REG_NR; k++)
+		io[k] = platform_get_resource(pdev, IORESOURCE_MEM, k);
+
+	/* In case of 3 resources PSR, PPR and PMSR order is expected */
+	if (io[REG_PSR] && io[REG_PPR] && io[REG_PMSR]) {
+		nr = REG_NR;
+	} else {
+		/* A single resource is also acceptable (PPR only) */
+		if (io[0] && !io[1] && !io[2]) {
+			nr = 1;
+		} else {
+			dev_err(&pdev->dev, "missing IOMEM\n");
+			return -EINVAL;
+		}
+	}
+
+	for (k = 0; k < nr; k++) {
+		p->io[k] = devm_ioremap_nocache(&pdev->dev, io[k]->start,
+						resource_size(io[k]));
+		if (!p->io[k]) {
+			dev_err(&pdev->dev, "failed to remap low I/O memory\n");
+			return -ENXIO;
+		}
+	}
+
+	/* If only 1 resource is available it must be PPR */
+	if (nr == 1) {
+		io[REG_PPR] = io[0];
+		p->io[REG_PPR] = p->io[0];
+		io[0] = NULL;
+		p->io[0] = NULL;
+	}
+
+	/* Support one device spanning several ports */
+	number_of_pins = RZ_GPIOS_PER_PORT;
+	if (io[REG_PSR])
+		number_of_pins *= resource_size(io[REG_PSR]) / 4;
+
+	gpio_base = pdata ? pdata->gpio_base : -1;
+
+	if (IS_ENABLED(CONFIG_OF) && np) {
+		ret = of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3, 0,
+						       &args);
+		number_of_pins = ret == 0 ? args.args[2] : RZ_GPIOS_PER_PORT;
+	}
+
+	gpio_chip = &p->gpio_chip;
+	gpio_chip->direction_input = rz_gpio_direction_input;
+	gpio_chip->get = rz_gpio_get;
+	gpio_chip->direction_output = rz_gpio_direction_output;
+	gpio_chip->set = rz_gpio_set;
+	gpio_chip->request = rz_gpio_request;
+	gpio_chip->free = rz_gpio_free;
+	gpio_chip->label = dev_name(&pdev->dev);
+	gpio_chip->dev = &pdev->dev;
+	gpio_chip->owner = THIS_MODULE;
+	gpio_chip->base = gpio_base;
+	gpio_chip->ngpio = number_of_pins;
+
+	ret = gpiochip_add(gpio_chip);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add GPIO controller\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "driving %d GPIOs\n", number_of_pins);
+
+	if (pdata && pdata->pctl_name) {
+		ret = gpiochip_add_pin_range(gpio_chip, pdata->pctl_name, 0,
+					     gpio_chip->base, gpio_chip->ngpio);
+		if (ret < 0)
+			dev_warn(&pdev->dev, "failed to add pin range\n");
+	}
+	return 0;
+}
+
+static int rz_gpio_remove(struct platform_device *pdev)
+{
+	struct rz_gpio_priv *p = platform_get_drvdata(pdev);
+
+	return gpiochip_remove(&p->gpio_chip);
+}
+
+static const struct of_device_id rz_gpio_dt_ids[] = {
+	{ .compatible = "renesas,gpio-rz", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, rz_gpio_dt_ids);
+
+static struct platform_driver rz_gpio_device_driver = {
+	.probe		= rz_gpio_probe,
+	.remove		= rz_gpio_remove,
+	.driver		= {
+		.name	= "gpio_rz",
+		.of_match_table = rz_gpio_dt_ids,
+		.owner		= THIS_MODULE,
+	}
+};
+
+static int __init rz_gpio_init(void)
+{
+	return platform_driver_register(&rz_gpio_device_driver);
+}
+postcore_initcall(rz_gpio_init);
+
+static void __exit rz_gpio_exit(void)
+{
+	platform_driver_unregister(&rz_gpio_device_driver);
+}
+module_exit(rz_gpio_exit);
+
+MODULE_AUTHOR("Magnus Damm");
+MODULE_DESCRIPTION("Renesas RZ Port GPIO Driver");
+MODULE_LICENSE("GPL v2");
--- /dev/null
+++ work/include/linux/platform_data/gpio-rz.h	2013-11-06 14:18:46.000000000 +0900
@@ -0,0 +1,13 @@
+#ifndef __GPIO_RZ_H__
+#define __GPIO_RZ_H__
+
+struct gpio_rz_config {
+	int gpio_base;
+	const char *pctl_name;
+};
+
+#define RZ_GPIOS_PER_PORT 16
+
+#define RZ_PORT_PIN(bank, pin)	(((bank) * RZ_GPIOS_PER_PORT) + (pin))
+
+#endif /* __GPIO_RZ_H__ */
