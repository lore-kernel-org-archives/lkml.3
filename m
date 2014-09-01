Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaIAMyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 08:54:41 -0400
Received: from exprod7og117.obsmtp.com ([64.18.2.6]:33164 "EHLO
	exprod7og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaIAMyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 08:54:04 -0400
From: Anders Berg <anders.berg@avagotech.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anders Berg <anders.berg@avagotech.com>
Subject: [PATCH 1/2] gpio: Add driver for AXM55xx SSP chip selects
Date: Mon,  1 Sep 2014 14:53:40 +0200
Message-Id: <1409576021-24828-2-git-send-email-anders.berg@avagotech.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com>
References: <1409576021-24828-1-git-send-email-anders.berg@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AXM55xx device has a ARM PL022 SSP controller with an extension that
enables the control of up to five chip select signals. This driver implements
the logic to control these signals and exports them as GPIOs.

Signed-off-by: Anders Berg <anders.berg@avagotech.com>
---
 drivers/gpio/Kconfig          |   8 +++
 drivers/gpio/Makefile         |   1 +
 drivers/gpio/gpio-axxia-ssp.c | 128 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 137 insertions(+)
 create mode 100644 drivers/gpio/gpio-axxia-ssp.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 9de1515..c2f2686 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -112,6 +112,14 @@ config GPIO_MAX730X
 
 comment "Memory mapped GPIO drivers:"
 
+config GPIO_AXXIA_SSP
+	tristate "AXM55xx SSP chip select pins as GPIO"
+	depends on ARCH_AXXIA
+	default y if SPI_MASTER
+	select GPIO_GENERIC
+	help
+	  Say yes here to get GPIO interface for AXM55xx SSP chip select signals.
+
 config GPIO_CLPS711X
 	tristate "CLPS711X GPIO support"
 	depends on ARCH_CLPS711X || COMPILE_TEST
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 5d024e3..01e1869 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_GPIO_ADP5520)	+= gpio-adp5520.o
 obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5588.o
 obj-$(CONFIG_GPIO_AMD8111)	+= gpio-amd8111.o
 obj-$(CONFIG_GPIO_ARIZONA)	+= gpio-arizona.o
+obj-$(CONFIG_GPIO_AXXIA_SSP)	+= gpio-axxia-ssp.o
 obj-$(CONFIG_GPIO_BCM_KONA)	+= gpio-bcm-kona.o
 obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
 obj-$(CONFIG_GPIO_CLPS711X)	+= gpio-clps711x.o
diff --git a/drivers/gpio/gpio-axxia-ssp.c b/drivers/gpio/gpio-axxia-ssp.c
new file mode 100644
index 0000000..5884206
--- /dev/null
+++ b/drivers/gpio/gpio-axxia-ssp.c
@@ -0,0 +1,128 @@
+/*
+ * GPIO interface for SSP chip select outputs.
+ *
+ * Copyright (C) 2013 LSI Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/bitops.h>
+#include <linux/init.h>
+#include <linux/gpio.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/of.h>
+
+struct gpio_dev {
+	void __iomem    *reg;
+	struct gpio_chip gpio_chip;
+};
+
+static int ssp_gpio_direction_out(struct gpio_chip *chip,
+				  unsigned offset, int value)
+{
+	/* Always outputs */
+	return 0;
+}
+
+static int ssp_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
+{
+	return -ENXIO;
+}
+
+static int ssp_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpio_dev *priv = dev_get_drvdata(chip->dev);
+	u32 tmp;
+
+	tmp = readl(priv->reg);
+	return !!(tmp & BIT(offset));
+}
+
+static void ssp_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct gpio_dev *priv = dev_get_drvdata(chip->dev);
+	u32 tmp;
+
+	tmp = readl(priv->reg);
+	if (value)
+		tmp |= BIT(offset);
+	else
+		tmp &= ~BIT(offset);
+	writel(tmp, priv->reg);
+}
+
+static int ssp_gpio_probe(struct platform_device *pdev)
+{
+	struct gpio_dev *priv;
+	struct resource *io;
+	struct gpio_chip *chip;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	priv->reg = devm_ioremap(&pdev->dev, io->start, resource_size(io));
+	if (!priv->reg)
+		return -ENXIO;
+
+	platform_set_drvdata(pdev, priv);
+
+	chip = &priv->gpio_chip;
+	chip->dev = &pdev->dev;
+#ifdef CONFIG_OF_GPIO
+	chip->of_node = pdev->dev.of_node;
+#endif
+	chip->direction_input = ssp_gpio_direction_in;
+	chip->direction_output = ssp_gpio_direction_out;
+	chip->get = ssp_gpio_get;
+	chip->set = ssp_gpio_set;
+	chip->label = "ssp-gpio";
+	chip->owner = THIS_MODULE;
+	chip->base = -1;
+	chip->ngpio = 5;
+
+	/* Set all 5 chip-selects high (de-asserted) by default */
+	writel(0x1f, priv->reg);
+
+	ret = gpiochip_add(chip);
+	if (ret < 0)
+		dev_err(&pdev->dev, "failed to register chip, %d\n", ret);
+
+	return ret;
+}
+
+static int ssp_gpio_remove(struct platform_device *pdev)
+{
+	struct gpio_dev *priv = dev_get_drvdata(&pdev->dev);
+
+	return gpiochip_remove(&priv->gpio_chip);
+}
+
+static const struct of_device_id ssp_gpio_id_table[] = {
+	{ .compatible = "lsi,ssp-gpio" },
+	{}
+};
+MODULE_DEVICE_TABLE(platform, ssp_gpio_id_table);
+
+static struct platform_driver ssp_gpio_driver = {
+	.driver = {
+		.name = "ssp-gpio",
+		.owner = THIS_MODULE,
+		.of_match_table = ssp_gpio_id_table
+	},
+	.probe = ssp_gpio_probe,
+	.remove = ssp_gpio_remove,
+};
+
+module_platform_driver(ssp_gpio_driver);
+
+MODULE_AUTHOR("LSI Corporation");
+MODULE_DESCRIPTION("GPIO interface for SSP chip selects");
+MODULE_LICENSE("GPL");
-- 
1.9.1

