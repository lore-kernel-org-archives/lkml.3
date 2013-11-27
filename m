Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3K0ILi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:11:38 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39724 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab3K0ILe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:11:34 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, linus.walleij@linaro.org,
        grant.likely@secretlab.ca, horms@verge.net.au,
        laurent.pinchart@ideasonboard.com, Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 27 Nov 2013 17:12:17 +0900
Message-Id: <20131127081217.18407.70912.sendpatchset@w520>
Subject: [PATCH v3] gpio: Renesas RZ GPIO driver V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This patch adds a GPIO driver for the RZ series of SoCs from
Renesas. The V3 of the driver requires DT to be used.

The hardware allows control of GPIOs in blocks of up to 16 pins.
Interrupts are not included in this hardware block, if interrupts
are needed then the PFC needs to be configured to a IRQ pin function
which is handled by the GIC hardware.

Tested with yet-to-be-posted DT devices on r7s72100 and Genmai using
LEDs, DIP switches and I2C bitbang.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes since V2: (Thanks Laurent)
 - Assume pdev->dev.of_node is set
 - Remove cast to int
 - Use unsigned int
 - Update header

 Changes since V1:
 - Drop platform data interface as suggested by Linus Walleij, thanks!
 - Various changes suggested by Laurent Pinchart (except !!), thanks!

 drivers/gpio/Kconfig   |    6 +
 drivers/gpio/Makefile  |    1 
 drivers/gpio/gpio-rz.c |  211 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 218 insertions(+)

--- 0001/drivers/gpio/Kconfig
+++ work/drivers/gpio/Kconfig	2013-11-27 15:52:12.000000000 +0900
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
+++ work/drivers/gpio/Makefile	2013-11-27 15:52:12.000000000 +0900
@@ -64,6 +64,7 @@ obj-$(CONFIG_GPIO_PXA)		+= gpio-pxa.o
 obj-$(CONFIG_GPIO_RC5T583)	+= gpio-rc5t583.o
 obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
 obj-$(CONFIG_GPIO_RCAR)		+= gpio-rcar.o
+obj-$(CONFIG_GPIO_RZ)		+= gpio-rz.o
 obj-$(CONFIG_GPIO_SAMSUNG)	+= gpio-samsung.o
 obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
 obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
--- /dev/null
+++ work/drivers/gpio/gpio-rz.c	2013-11-27 15:56:45.000000000 +0900
@@ -0,0 +1,211 @@
+/*
+ * RZ GPIO Support - Ports
+ *
+ *  Copyright (C) 2013 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; version 2 of the
+ * License.
+ */
+
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#define RZ_GPIOS_PER_PORT 16
+
+enum { REG_PSR, REG_PPR, REG_PMSR, REG_NR };
+
+struct rz_gpio_priv {
+	void __iomem *io[REG_NR];
+	struct gpio_chip gpio_chip;
+};
+
+static inline u32 rz_gpio_read_ppr(struct rz_gpio_priv *p, int offs)
+{
+	unsigned long msk = BIT(offs % RZ_GPIOS_PER_PORT);
+	unsigned int offset = (offs / RZ_GPIOS_PER_PORT) * 4;
+
+	return ioread32(p->io[REG_PPR] + offset) & msk;
+}
+
+static inline void rz_gpio_write(struct rz_gpio_priv *p, int reg, int offs,
+				 bool value)
+{
+	unsigned long msk = BIT(offs % RZ_GPIOS_PER_PORT);
+	unsigned int offset = (offs / RZ_GPIOS_PER_PORT) * 4;
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
+	return rz_gpio_read_ppr(gpio_to_priv(chip), offset);
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
+	struct rz_gpio_priv *p;
+	struct resource *io[3];
+	struct gpio_chip *gpio_chip;
+	struct device_node *np = pdev->dev.of_node;
+	struct of_phandle_args args;
+	unsigned int k, nr;
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
+		p->io[k] = devm_ioremap_resource(&pdev->dev, io[k]);
+		if (IS_ERR(p->io[k]))
+			return PTR_ERR(p->io[k]);
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
+	ret = of_parse_phandle_with_fixed_args(np, "gpio-ranges", 3, 0, &args);
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
+	gpio_chip->base = -1;
+	gpio_chip->ngpio = ret == 0 ? args.args[2] : RZ_GPIOS_PER_PORT;
+
+	ret = gpiochip_add(gpio_chip);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to add GPIO controller\n");
+		return ret;
+	}
+
+	dev_info(&pdev->dev, "driving %d GPIOs\n", gpio_chip->ngpio);
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
