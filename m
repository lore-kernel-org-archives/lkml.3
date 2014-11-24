Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaKXOCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:02:07 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:50660 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaKXOCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:02:03 -0500
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Grant Likely <grant.likely@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 2/2] gpio: add a driver for GPIOs going through a level shifter
Date: Mon, 24 Nov 2014 15:01:36 +0100
Message-Id: <1416837696-28066-2-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416837696-28066-1-git-send-email-alban.bedel@avionic-design.de>
References: <1416837696-28066-1-git-send-email-alban.bedel@avionic-design.de>
X-Provags-ID: V02:K0:zZ+Ag0OOU0BzSusOG8Vpk+ufL8yCiV6aYgLOa6kT8U/
 SJ611q5+Wcl9reOgPUhsFePwJo3mi1xOLBjHxX3C6g+1PIBIkG
 XTiJY91MJGoYir7jEEgfabqAhDAuI4othsjlhTlUtQ8FV5xMZO
 LNin164Hr2FZmGaum44emDQJTf/XT30437IBsVXSfp0GzHfYxn
 aNT+z9fW36NyYxB3zbqpFFfPEMHRl7QHVxugooXXBrT+F7MHd9
 gfccvooTNPMfGMFR8u44fTReb1dZG6gBUvlfCoXB9fqfe7kuSi
 JiMNDGW51ISruS5pOXd1Mm4dfxkscmnP6qjKGI33zrGX3bEFal
 tVvED+POgcIuVXdH8Vv12rWIEZqBlk0bz8NXYlTEV07Uoy/f+x
 cLqI5RJfyqh36+5+qzMa/RK2qN9SyMsAAxjdoQFvKSK9ssLdak
 6izQhSInDBi13wtH/nunJFMg4bg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver support setting the level shifter direction and/or enable
as needed.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/gpio/Kconfig              |   6 +
 drivers/gpio/Makefile             |   1 +
 drivers/gpio/gpio-level-shifter.c | 248 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 255 insertions(+)
 create mode 100644 drivers/gpio/gpio-level-shifter.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0959ca9..bb00cc5 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -181,6 +181,12 @@ config GPIO_F7188X
 	  To compile this driver as a module, choose M here: the module will
 	  be called f7188x-gpio.
 
+config GPIO_LEVEL_SHIFTER
+	tristate "Level shifter GPIO support"
+	help
+	  This enables support for GPIOs that are going through a simple level
+	  shifter.
+
 config GPIO_MOXART
 	bool "MOXART GPIO support"
 	depends on ARCH_MOXART
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index e5d346c..e9adc12 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -39,6 +39,7 @@ obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
 obj-$(CONFIG_GPIO_KEMPLD)	+= gpio-kempld.o
 obj-$(CONFIG_ARCH_KS8695)	+= gpio-ks8695.o
 obj-$(CONFIG_GPIO_INTEL_MID)	+= gpio-intel-mid.o
+obj-$(CONFIG_GPIO_LEVEL_SHIFTER)+= gpio-level-shifter.o
 obj-$(CONFIG_GPIO_LP3943)	+= gpio-lp3943.o
 obj-$(CONFIG_ARCH_LPC32XX)	+= gpio-lpc32xx.o
 obj-$(CONFIG_GPIO_LYNXPOINT)	+= gpio-lynxpoint.o
diff --git a/drivers/gpio/gpio-level-shifter.c b/drivers/gpio/gpio-level-shifter.c
new file mode 100644
index 0000000..1760048
--- /dev/null
+++ b/drivers/gpio/gpio-level-shifter.c
@@ -0,0 +1,248 @@
+/*
+ * Driver for GPIOs that are going through a level shifter.
+ *
+ * Copyright (C) 2014 - Alban Bedel
+ *
+ * Author: Alban Bedel <alban.bedel@avionic-design.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/gpio/driver.h>
+#include <linux/gpio/consumer.h>
+#include <linux/regulator/consumer.h>
+
+#define MAX_DATA_GPIO 32
+
+enum level_shifter_direction {
+	DIRECTION_NONE,
+	DIRECTION_INPUT,
+	DIRECTION_OUTPUT
+};
+
+struct level_shifter_gpio {
+	struct gpio_chip gc;
+
+	spinlock_t lock;
+	int num_requested;
+
+	struct gpio_desc *data_gpio[MAX_DATA_GPIO];
+	struct gpio_desc *enable_gpio;
+	struct gpio_desc *direction_gpio;
+	enum level_shifter_direction direction;
+
+	struct regulator *vcc_a;
+	struct regulator *vcc_b;
+};
+
+#define to_level_shifter_gpio(c) \
+	container_of(c, struct level_shifter_gpio, gc)
+
+int level_shifter_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct level_shifter_gpio *ls = to_level_shifter_gpio(chip);
+
+	spin_lock(&ls->lock);
+
+	if (ls->num_requested == 0 && ls->enable_gpio)
+		gpiod_set_value(ls->enable_gpio, 1);
+
+	ls->num_requested++;
+
+	spin_unlock(&ls->lock);
+
+	return 0;
+}
+
+void level_shifter_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct level_shifter_gpio *ls = to_level_shifter_gpio(chip);
+
+	spin_lock(&ls->lock);
+
+	ls->num_requested--;
+
+	if (ls->num_requested == 0) {
+		if (ls->enable_gpio)
+			gpiod_set_value(ls->enable_gpio, 0);
+		if (ls->direction_gpio)
+			ls->direction = DIRECTION_NONE;
+	}
+
+	spin_unlock(&ls->lock);
+}
+
+static void level_shifter_gpio_set(
+	struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct level_shifter_gpio *ls = to_level_shifter_gpio(chip);
+
+	gpiod_set_value(ls->data_gpio[offset], value);
+}
+
+static int level_shifter_gpio_direction_output(
+	struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct level_shifter_gpio *ls = to_level_shifter_gpio(chip);
+	int err;
+
+	spin_lock(&ls->lock);
+
+	/* Set the direction GPIO if needed */
+	if (ls->direction_gpio) {
+		/* We can't change the direction once set */
+		if (ls->direction == DIRECTION_INPUT) {
+			spin_unlock(&ls->lock);
+			return -EINVAL;
+		}
+		gpiod_set_value(ls->direction_gpio, 1);
+	}
+
+	err = gpiod_direction_output(ls->data_gpio[offset], value);
+
+	/* Save the direction if there was no error */
+	if (!err && ls->direction_gpio)
+		ls->direction = DIRECTION_OUTPUT;
+
+	spin_unlock(&ls->lock);
+
+	return err;
+}
+
+static int level_shifter_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct level_shifter_gpio *ls = to_level_shifter_gpio(chip);
+
+	return gpiod_get_value(ls->data_gpio[offset]);
+}
+
+static int level_shifter_gpio_direction_input(
+	struct gpio_chip *chip, unsigned offset)
+{
+	struct level_shifter_gpio *ls = to_level_shifter_gpio(chip);
+	int err;
+
+	spin_lock(&ls->lock);
+
+	/* Set the direction GPIO if needed */
+	if (ls->direction_gpio) {
+		/* We can't change the direction once set */
+		if (ls->direction == DIRECTION_OUTPUT) {
+			spin_unlock(&ls->lock);
+			return -EINVAL;
+		}
+		gpiod_set_value(ls->direction_gpio, 1);
+	}
+
+	err = gpiod_direction_input(ls->data_gpio[offset]);
+
+	/* Save the direction if there was no error */
+	if (!err && ls->direction_gpio)
+		ls->direction = DIRECTION_INPUT;
+
+	spin_unlock(&ls->lock);
+
+	return err;
+}
+
+static int level_shifter_gpio_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct level_shifter_gpio *ls;
+	struct gpio_desc *gpiod;
+	int err, i;
+
+	ls = devm_kzalloc(&pdev->dev, sizeof(*ls), GFP_KERNEL);
+	if (!ls)
+		return -ENOMEM;
+
+	spin_lock_init(&ls->lock);
+
+	if (np)
+		ls->gc.label = np->name;
+	else
+		ls->gc.label = "level-shifter-gpio";
+
+	ls->gc.of_node = pdev->dev.of_node;
+	ls->gc.base = -1;
+	ls->gc.request = level_shifter_gpio_request;
+	ls->gc.free = level_shifter_gpio_free;
+	ls->gc.set = level_shifter_gpio_set;
+	ls->gc.direction_output = level_shifter_gpio_direction_output;
+	ls->gc.get = level_shifter_gpio_get;
+	ls->gc.direction_input = level_shifter_gpio_direction_input;
+
+	for (i = 0; i < MAX_DATA_GPIO; i++) {
+		gpiod = devm_gpiod_get_index_optional(
+			&pdev->dev, "data", i, GPIOD_IN);
+		if (!gpiod)
+			continue;
+		if (IS_ERR(gpiod))
+			return PTR_ERR(gpiod);
+
+		ls->data_gpio[ls->gc.ngpio++] = gpiod;
+	}
+
+	ls->enable_gpio = devm_gpiod_get_optional(
+		&pdev->dev, "enable", GPIOD_OUT_LOW);
+	if (IS_ERR(ls->enable_gpio))
+		return PTR_ERR(ls->enable_gpio);
+
+	ls->direction_gpio = devm_gpiod_get_optional(
+		&pdev->dev, "direction", GPIOD_OUT_LOW);
+	if (IS_ERR(ls->direction_gpio))
+		return PTR_ERR(ls->direction_gpio);
+
+	ls->vcc_a = devm_regulator_get_optional(&pdev->dev, "vcca");
+	if (IS_ERR(ls->vcc_a) && PTR_ERR(ls->vcc_a) != -ENODEV)
+		return PTR_ERR(ls->vcc_a);
+	if (!IS_ERR(ls->vcc_a)) {
+		err = regulator_enable(ls->vcc_a);
+		if (err)
+			return err;
+	}
+
+	ls->vcc_b = devm_regulator_get_optional(&pdev->dev, "vccb");
+	if (IS_ERR(ls->vcc_b) && PTR_ERR(ls->vcc_b) != -ENODEV)
+		return PTR_ERR(ls->vcc_b);
+	if (!IS_ERR(ls->vcc_b)) {
+		err = regulator_enable(ls->vcc_b);
+		if (err)
+			return err;
+	}
+
+	err = gpiochip_add(&ls->gc);
+	if (err) {
+		if (!IS_ERR(ls->vcc_a))
+			regulator_disable(ls->vcc_a);
+		if (!IS_ERR(ls->vcc_b))
+			regulator_disable(ls->vcc_b);
+	}
+	return err;
+}
+
+static const struct of_device_id level_shifter_gpio_of_match[] = {
+	{ .compatible = "gpio-level-shifter"},
+	{},
+};
+MODULE_DEVICE_TABLE(of, level_shifter_gpio_of_match);
+
+static struct platform_driver level_shifter_gpio_driver = {
+	.driver = {
+		.name = "level-shifter-gpio",
+		.owner = THIS_MODULE,
+		.of_match_table = level_shifter_gpio_of_match,
+	},
+	.probe = level_shifter_gpio_probe,
+};
+module_platform_driver(level_shifter_gpio_driver);
+
+MODULE_AUTHOR("Alban Bedel <alban.bedel@avionic-design.de>");
+MODULE_DESCRIPTION("Driver for GPIO going thru a level shifter");
+MODULE_LICENSE("GPL v2");
-- 
2.1.3

