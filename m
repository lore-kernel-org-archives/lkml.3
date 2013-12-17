Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab3LQPeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:34:12 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:53287 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab3LQPeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:34:10 -0500
From: Laszlo Papp <lpapp@kde.org>
To: linus.walleij@linaro.org
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laszlo Papp <lpapp@kde.org>
Subject: [PATCH] gpio: gpio-max665x: add support for the MAX6650-66510 ICs
Date: Tue, 17 Dec 2013 15:29:31 +0000
Message-Id: <1387294171-7280-1-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These ICs already have hwmon driver support, but they also have some gpio
functionality which this addition tries to address. Later on, there would be an
MFD driver added as well.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 drivers/gpio/Kconfig        |  14 +++
 drivers/gpio/Makefile       |   2 +
 drivers/gpio/gpio-max6651.c |  97 ++++++++++++++
 drivers/gpio/gpio-max665x.c | 299 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/max6651.h |  40 ++++++
 5 files changed, 452 insertions(+)
 create mode 100644 drivers/gpio/gpio-max6651.c
 create mode 100644 drivers/gpio/gpio-max665x.c
 create mode 100644 include/linux/i2c/max6651.h

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0f04444..aaa23f4 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -103,6 +103,9 @@ config GPIO_DA9055
 
 	  If driver is built as a module it will be called gpio-da9055.
 
+config GPIO_MAX665X
+	tristate
+
 config GPIO_MAX730X
 	tristate
 
@@ -381,6 +384,17 @@ config GPIO_ARIZONA
 	help
 	  Support for GPIOs on Wolfson Arizona class devices.
 
+config GPIO_MAX6651
+	tristate "Maxim MAX6651 GPIO pins"
+	depends on I2C
+	select GPIO_MAX665X
+	help
+      Say yes here to support the GPIO functionality for the MAX6651 Fan Speed
+      Regulators and Monitors with SMBus/I2C Compatible Interface IC. It has
+      five GPIO pins that can be set to various functionality, including the
+      regular input and output operations. It has an internal pull-up resistor
+      though within the IC.
+
 config GPIO_MAX7300
 	tristate "Maxim MAX7300 GPIO expander"
 	depends on I2C
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 7971e36..a4d34d6 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -37,6 +37,8 @@ obj-$(CONFIG_ARCH_KS8695)	+= gpio-ks8695.o
 obj-$(CONFIG_GPIO_INTEL_MID)	+= gpio-intel-mid.o
 obj-$(CONFIG_ARCH_LPC32XX)	+= gpio-lpc32xx.o
 obj-$(CONFIG_GPIO_LYNXPOINT)	+= gpio-lynxpoint.o
+obj-$(CONFIG_GPIO_MAX665X)	+= gpio-max665x.o
+obj-$(CONFIG_GPIO_MAX6651)	+= gpio-max6651.o
 obj-$(CONFIG_GPIO_MAX730X)	+= gpio-max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= gpio-max7300.o
 obj-$(CONFIG_GPIO_MAX7301)	+= gpio-max7301.o
diff --git a/drivers/gpio/gpio-max6651.c b/drivers/gpio/gpio-max6651.c
new file mode 100644
index 0000000..6d3d45c
--- /dev/null
+++ b/drivers/gpio/gpio-max6651.c
@@ -0,0 +1,97 @@
+/*
+ * Copyright (C) 2013 Laszlo Papp <laszlo.papp@polatis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Check max665x.c for further details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/i2c.h>
+#include <linux/i2c/max6651.h>
+#include <linux/slab.h>
+
+#define PIN_NUMBER 5
+
+static int max6651_i2c_write(struct device *dev, unsigned int reg,
+			     unsigned int value)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+static int max6651_i2c_read(struct device *dev, unsigned int reg)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int max6651_probe(struct i2c_client *client,
+			 const struct i2c_device_id *id)
+{
+	struct max665x *ts;
+	int ret;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	ts = devm_kzalloc(&client->dev, sizeof(struct max665x), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	ts->read = max6651_i2c_read;
+	ts->write = max6651_i2c_write;
+	ts->dev = &client->dev;
+
+	ts->chip.ngpio = PIN_NUMBER;
+
+	ret = __max665x_probe(ts);
+	return ret;
+}
+
+static int max6651_remove(struct i2c_client *client)
+{
+	return __max665x_remove(&client->dev);
+}
+
+static const struct i2c_device_id max6651_id[] = {
+	{"max6651", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, max6651_id);
+
+static struct i2c_driver max6651_driver = {
+	.driver = {
+		   .name = "gpio-max6651",
+		   .owner = THIS_MODULE,
+		   },
+	.probe = max6651_probe,
+	.remove = max6651_remove,
+	.id_table = max6651_id,
+};
+
+static int __init max6651_init(void)
+{
+	return i2c_add_driver(&max6651_driver);
+}
+
+subsys_initcall(max6651_init);
+
+static void __exit max6651_exit(void)
+{
+	i2c_del_driver(&max6651_driver);
+}
+
+module_exit(max6651_exit);
+
+MODULE_AUTHOR("Laszlo Papp");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MAX6651 fan controller");
diff --git a/drivers/gpio/gpio-max665x.c b/drivers/gpio/gpio-max665x.c
new file mode 100644
index 0000000..6f9986e
--- /dev/null
+++ b/drivers/gpio/gpio-max665x.c
@@ -0,0 +1,299 @@
+/**
+ * Copyright (C) 2013 Laszlo Papp <laszlo.papp@polatis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/i2c/max6651.h>
+#include <linux/gpio.h>
+#include <linux/slab.h>
+
+#define MAX665X_REG_GPIO_DEF    0x04
+#define MAX665X_REG_GPIO_STAT   0x14
+
+/*
+ * Gpio Def register bits
+ */
+
+#define PIN0_CONFIG_MASK    0x03
+#define PIN1_CONFIG_MASK    0x0C
+#define PIN2_CONFIG_MASK    0x30
+#define PIN3_CONFIG_MASK    0x40
+#define PIN4_CONFIG_MASK    0x80
+
+#define PIN0_CONFIG_OUT_LOW  0x02
+#define PIN1_CONFIG_OUT_LOW  0x08
+#define PIN2_CONFIG_OUT_LOW  0x20
+
+static int max665x_direction_input_or_output_high(struct gpio_chip *chip,
+						  unsigned offset)
+{
+	struct max665x *ts = container_of(chip, struct max665x, chip);
+	u8 config;
+	int ret;
+
+	mutex_lock(&ts->lock);
+
+	config = ts->read(ts->dev, MAX665X_REG_GPIO_DEF);
+
+	switch (offset) {
+	case 0:
+		config |= PIN0_CONFIG_MASK;
+		break;
+	case 1:
+		config |= PIN1_CONFIG_MASK;
+		break;
+	case 2:
+		config |= PIN2_CONFIG_MASK;
+		break;
+	case 3:
+		config |= PIN3_CONFIG_MASK;
+		break;
+	case 4:
+		config |= PIN4_CONFIG_MASK;
+		break;
+	default:
+		mutex_unlock(&ts->lock);
+		return -EINVAL;
+	}
+
+	ret = ts->write(ts->dev, MAX665X_REG_GPIO_DEF, config);
+
+	mutex_unlock(&ts->lock);
+
+	return ret;
+}
+
+static int max665x_direction_output_low(struct gpio_chip *chip, unsigned offset)
+{
+	struct max665x *ts = container_of(chip, struct max665x, chip);
+	u8 config;
+	int ret;
+
+	mutex_lock(&ts->lock);
+
+	config = ts->read(ts->dev, MAX665X_REG_GPIO_DEF);
+
+	switch (offset) {
+	case 0:
+		config &= ~PIN0_CONFIG_MASK;
+		config |= PIN0_CONFIG_OUT_LOW;
+		break;
+	case 1:
+		config &= ~PIN1_CONFIG_MASK;
+		config |= PIN1_CONFIG_OUT_LOW;
+		break;
+	case 2:
+		config &= ~PIN2_CONFIG_MASK;
+		config |= PIN2_CONFIG_OUT_LOW;
+		break;
+	case 3:
+		config &= ~PIN3_CONFIG_MASK;
+		break;
+	case 4:
+		config &= ~PIN4_CONFIG_MASK;
+		break;
+	default:
+		mutex_unlock(&ts->lock);
+		return -EINVAL;
+	}
+
+	ret = ts->write(ts->dev, MAX665X_REG_GPIO_DEF, config);
+
+	mutex_unlock(&ts->lock);
+
+	return ret;
+}
+
+static int max665x_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	return max665x_direction_input_or_output_high(chip, offset);
+}
+
+static int max665x_direction_output(struct gpio_chip *chip, unsigned offset,
+				    int value)
+{
+	if (value != 0)
+		return max665x_direction_input_or_output_high(chip, offset);
+
+	return max665x_direction_output_low(chip, offset);
+}
+
+static int max665x_get_level(struct max665x *ts, unsigned offset, unsigned
+			     gpio_value)
+{
+	int ret;
+
+	if (offset < 3) {
+		switch (gpio_value) {
+		case 0:
+		case 3:
+			if (ts->input_pullup_active & (1 << offset))
+				ret =
+				    ts->read(ts->dev,
+					     MAX665X_REG_GPIO_STAT) & (offset +
+								       1);
+			else
+				ret = 1;
+			break;
+		case 2:
+			ret = 0;
+			break;
+		default:
+			ret = 0;
+			dev_err(ts->dev, "Failed to obtain the gpio %d value\n",
+				offset);
+			break;
+		}
+	} else {
+		if (gpio_value) {
+			if (ts->input_pullup_active & (1 << offset))
+				ret =
+				    ts->read(ts->dev,
+					     MAX665X_REG_GPIO_STAT) & (offset +
+								       1);
+			else
+				ret = 1;
+		} else {
+			ret = 0;
+		}
+	}
+
+	return ret;
+}
+
+static int max665x_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct max665x *ts = container_of(chip, struct max665x, chip);
+	int config, level = -EINVAL;
+
+	mutex_lock(&ts->lock);
+
+	config = ts->read(ts->dev, MAX665X_REG_GPIO_DEF);
+
+	switch (offset) {
+	case 0:
+		level =
+		    max665x_get_level(ts, offset, config & PIN0_CONFIG_MASK);
+		break;
+	case 1:
+		level =
+		    max665x_get_level(ts, offset,
+				      (config & PIN1_CONFIG_MASK) >> 2);
+		break;
+	case 2:
+		level =
+		    max665x_get_level(ts, offset,
+				      (config & PIN2_CONFIG_MASK) >> 4);
+		break;
+	case 3:
+		level =
+		    max665x_get_level(ts, offset,
+				      (config & PIN3_CONFIG_MASK) >> 5);
+		break;
+	case 4:
+		level =
+		    max665x_get_level(ts, offset,
+				      (config & PIN3_CONFIG_MASK) >> 6);
+		break;
+	default:
+		mutex_unlock(&ts->lock);
+		return -EINVAL;
+	}
+
+	mutex_unlock(&ts->lock);
+
+	return level;
+}
+
+static void max665x_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	if (value != 0)
+		max665x_direction_input_or_output_high(chip, offset);
+	else
+		max665x_direction_output_low(chip, offset);
+}
+
+int __max665x_probe(struct max665x *ts)
+{
+	struct device *dev = ts->dev;
+	struct max665x_platform_data *pdata;
+	int offset, ret;
+
+	pdata = dev_get_platdata(dev);
+
+	mutex_init(&ts->lock);
+	dev_set_drvdata(dev, ts);
+
+	if (pdata) {
+		ts->input_pullup_active = pdata->input_pullup_active;
+		ts->chip.base = pdata->base;
+	} else {
+		ts->chip.base = -1;
+	}
+	ts->chip.label = dev->driver->name;
+
+	ts->chip.direction_input = max665x_direction_input;
+	ts->chip.get = max665x_get;
+	ts->chip.direction_output = max665x_direction_output;
+	ts->chip.set = max665x_set;
+
+	ts->chip.can_sleep = 1;
+	ts->chip.dev = dev;
+	ts->chip.owner = THIS_MODULE;
+
+	/*
+	 * initialize input pullups according to platform data.
+	 */
+
+	for (offset = 0; offset < 5; ++offset) {
+		ret = max665x_direction_input(&ts->chip, offset);
+
+		if (ret)
+			goto exit_destroy;
+	}
+
+	ret = gpiochip_add(&ts->chip);
+	if (ret)
+		goto exit_destroy;
+
+	return ret;
+
+exit_destroy:
+	dev_set_drvdata(dev, NULL);
+	mutex_destroy(&ts->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__max665x_probe);
+
+int __max665x_remove(struct device *dev)
+{
+	struct max665x *ts = dev_get_drvdata(dev);
+	int ret;
+
+	if (ts == NULL)
+		return -ENODEV;
+
+	dev_set_drvdata(dev, NULL);
+
+	ret = gpiochip_remove(&ts->chip);
+	if (!ret) {
+		mutex_destroy(&ts->lock);
+		kfree(ts);
+	} else
+		dev_err(dev, "Failed to remove GPIO controller: %d\n", ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__max665x_remove);
+
+MODULE_AUTHOR("Laszlo Papp");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MAX665x GPIO-Expanders, generic parts");
diff --git a/include/linux/i2c/max6651.h b/include/linux/i2c/max6651.h
new file mode 100644
index 0000000..a0e4c0e
--- /dev/null
+++ b/include/linux/i2c/max6651.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2013 Laszlo Papp <laszlo.papp@polatis.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Check max665x.c for further details.
+ */
+
+#ifndef LINUX_I2C_MAX6651_H
+#define LINUX_I2C_MAX6651_H
+
+#include <linux/gpio.h>
+
+struct max665x {
+	struct mutex lock;
+	u8 input_pullup_active;
+	struct gpio_chip chip;
+	struct device *dev;
+	int (*write) (struct device *dev, unsigned int reg,
+		      unsigned int value);
+	int (*read) (struct device *dev, unsigned int reg);
+};
+
+struct max665x_platform_data {
+	/* number assigned to the first GPIO */
+	unsigned base;
+	/*
+	 * bitmask controlling the pullup configuration,
+	 *
+     * _note_ the 3 highest bits are unused, because there can be maximum up
+	 * to five gpio pins on the MAX6651 chip (three on MAX6650).
+	 */
+	u8 input_pullup_active;
+};
+
+extern int __max665x_remove(struct device *dev);
+extern int __max665x_probe(struct max665x *ts);
+#endif
-- 
1.8.5.1

