Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab3LWQNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:13:36 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61525 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab3LWQNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:13:05 -0500
From: Laszlo Papp <lpapp@kde.org>
To: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Laszlo Papp <lpapp@kde.org>
Subject: [PATCH 3/3] gpio: MAX6650/6651 support
Date: Mon, 23 Dec 2013 16:08:09 +0000
Message-Id: <1387814889-16670-4-git-send-email-lpapp@kde.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1387814889-16670-1-git-send-email-lpapp@kde.org>
References: <1387814889-16670-1-git-send-email-lpapp@kde.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These ICs already have hwmon driver support, but they also have some gpio
functionality which this addition tries to address. Later on, there would be an
MFD driver added as well.

Signed-off-by: Laszlo Papp <lpapp@kde.org>
---
 drivers/gpio/Kconfig                |  14 ++
 drivers/gpio/Makefile               |   2 +
 drivers/gpio/gpio-max6651.c         |  72 +++++++++
 drivers/gpio/gpio-max665x.c         | 301 ++++++++++++++++++++++++++++++++++++
 include/linux/mfd/max6651-private.h |  10 ++
 5 files changed, 399 insertions(+)
 create mode 100644 drivers/gpio/gpio-max6651.c
 create mode 100644 drivers/gpio/gpio-max665x.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 0f04444..50fea6b 100644
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
+	depends on MFD_MAX6651
+	select GPIO_MAX665X
+	help
+	  Say yes here to support the GPIO functionality for the MAX6651 Fan Speed
+	  Regulators and Monitors with SMBus/I2C Compatible Interface IC. It has
+	  five GPIO pins that can be set to various functionality, including the
+	  regular input and output operations. It has an internal pull-up resistor
+	  though within the IC.
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
index 0000000..e32c530
--- /dev/null
+++ b/drivers/gpio/gpio-max6651.c
@@ -0,0 +1,72 @@
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
+#include <linux/slab.h>
+
+#include <linux/mfd/max6651-private.h>
+
+#define PIN_NUMBER 5
+
+static int max6651_probe(struct platform_device *pdev)
+{
+    struct max665x_gpio *gpio;
+    struct da9055_pdata *pdata;
+	int ret;
+
+	gpio = devm_kzalloc(&pdev->dev, sizeof(struct max665x_gpio), GFP_KERNEL);
+	if (!gpio)
+		return -ENOMEM;
+
+    gpio->gp.ngpio = PIN_NUMBER;
+
+	ret = __max665x_probe(gpio);
+	return ret;
+}
+
+static int max6651_remove(struct platform_device *pdev)
+{
+	return __max665x_remove(&pdev->dev);
+}
+
+static const struct i2c_device_id max6651_id[] = {
+	{ "max6651", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, max6651_id);
+
+static struct platform_driver max6651_driver = {
+	.driver = {
+		.name = "gpio-max6651",
+		.owner = THIS_MODULE,
+	},
+	.probe = max6651_probe,
+	.remove = max6651_remove,
+	.id_table = max6651_id,
+};
+
+static int __init max6651_init(void)
+{
+	return platform_driver_register(&max6651_driver);
+}
+subsys_initcall(max6651_init);
+
+static void __exit max6651_exit(void)
+{
+	platform_driver_unregister(&max6651_driver);
+}
+module_exit(max6651_exit);
+
+MODULE_AUTHOR("Laszlo Papp");
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("MAX6651 fan controller");
diff --git a/drivers/gpio/gpio-max665x.c b/drivers/gpio/gpio-max665x.c
new file mode 100644
index 0000000..6615d0f
--- /dev/null
+++ b/drivers/gpio/gpio-max665x.c
@@ -0,0 +1,301 @@
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
+#include <linux/gpio.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/max6651-private.h>
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
+struct max665x_platform_data {
+    /* number assigned to the first GPIO */
+    unsigned    base;
+    /*  
+     * bitmask controlling the pullup configuration,
+     *
+     * _note_ the 3 highest  bits are unused, because there can be maximum up
+     * to five gpio pins on the MAX6651 chip (three on MAX6650).
+     */
+    u8     input_pullup_active;
+};
+
+static inline struct max665x_gpio *to_max665x_gpio(struct gpio_chip *chip)
+{
+    return container_of(chip, struct max665x_gpio, gp);
+}
+
+static int max665x_direction_input_or_output_high(struct gpio_chip *chip, unsigned offset)
+{
+	struct max665x_gpio *gpio = to_max665x_gpio(chip);
+	u8 config;
+	int ret;
+
+	mutex_lock(&gpio->iodev->iolock);
+
+	max6651_read_reg(gpio->iodev->i2c, MAX665X_REG_GPIO_DEF, &config);
+
+    switch (offset) {
+    case 0:
+        config |= PIN0_CONFIG_MASK;
+        break;
+    case 1:
+        config |= PIN1_CONFIG_MASK;
+        break;
+    case 2:
+        config |= PIN2_CONFIG_MASK;
+        break;
+    case 3:
+        config |= PIN3_CONFIG_MASK;
+        break;
+    case 4:
+        config |= PIN4_CONFIG_MASK;
+        break;
+    default:
+	    mutex_unlock(&gpio->iodev->iolock);
+        return -EINVAL;
+    }   
+
+	ret = max6651_write_reg(gpio->iodev->i2c, MAX665X_REG_GPIO_DEF, config);
+
+	mutex_unlock(&gpio->iodev->iolock);
+
+	return ret;
+}
+
+static int max665x_direction_output_low(struct gpio_chip *chip, unsigned offset)
+{
+	struct max665x_gpio *gpio = to_max665x_gpio(chip);
+	u8 config;
+	int ret;
+
+	mutex_lock(&gpio->iodev->iolock);
+
+	max6651_read_reg(gpio->iodev->i2c, MAX665X_REG_GPIO_DEF, &config);
+
+    switch (offset) {
+    case 0:
+        config &= ~PIN0_CONFIG_MASK;
+        config |= PIN0_CONFIG_OUT_LOW;
+        break;
+    case 1:
+        config &= ~PIN1_CONFIG_MASK;
+        config |= PIN1_CONFIG_OUT_LOW;
+        break;
+    case 2:
+        config &= ~PIN2_CONFIG_MASK;
+        config |= PIN2_CONFIG_OUT_LOW;
+        break;
+    case 3:
+        config &= ~PIN3_CONFIG_MASK;
+        break;
+    case 4:
+        config &= ~PIN4_CONFIG_MASK;
+        break;
+    default:
+	    mutex_unlock(&gpio->iodev->iolock);
+        return -EINVAL;
+    }   
+
+    ret = max6651_write_reg(gpio->iodev->i2c, MAX665X_REG_GPIO_DEF, config);
+
+	mutex_unlock(&gpio->iodev->iolock);
+
+	return ret;
+}
+    
+static int max665x_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+    return max665x_direction_input_or_output_high(chip, offset);
+}
+
+static int max665x_direction_output(struct gpio_chip *chip, unsigned offset,
+				    int value)
+{
+    if (value != 0)
+        return max665x_direction_input_or_output_high(chip, offset);
+
+    return max665x_direction_output_low(chip, offset);
+}
+
+static int max665x_get_level(struct max665x_gpio *gpio, unsigned offset, unsigned gpio_value)
+{
+    int ret;
+
+    if (offset < 3) {
+        switch (gpio_value) {
+        case 0:
+        case 3:
+            if (gpio->input_pullup_active & (1 << offset)) {
+                max6651_read_reg(gpio->iodev->i2c, MAX665X_REG_GPIO_STAT, &ret);
+                ret &= (offset + 1);
+            } else {
+                ret = 1;
+            }
+            break;
+        case 2:
+            ret = 0;
+            break;
+        default:
+            ret = 0;
+            dev_err(gpio->iodev->i2c, "Failed to obtain the gpio %d value\n", offset);
+            break;
+        }
+    } else {
+        if (gpio_value) {
+            if (gpio->input_pullup_active & (1 << offset)) {
+                max6651_read_reg(gpio->iodev->i2c, MAX665X_REG_GPIO_STAT, &ret);
+                ret &= (offset + 1);
+            } else {
+                ret = 1;
+            }
+        } else {
+            ret = 0;
+        }
+    }
+
+    return ret;
+}
+
+static int max665x_get(struct gpio_chip *chip, unsigned offset)
+{
+	struct max665x_gpio *gpio = to_max665x_gpio(chip);
+    int level = -EINVAL;
+	u8 config;
+
+	mutex_lock(&gpio->iodev->iolock);
+
+	max6651_read_reg(gpio->iodev->i2c, MAX665X_REG_GPIO_DEF, &config);
+
+    switch (offset) {
+    case 0:
+        level = max665x_get_level(gpio, offset, config & PIN0_CONFIG_MASK);
+        break;
+    case 1:
+        level = max665x_get_level(gpio, offset, (config & PIN1_CONFIG_MASK) >> 2);
+        break;
+    case 2:
+        level = max665x_get_level(gpio, offset, (config & PIN2_CONFIG_MASK) >> 4);
+        break;
+    case 3:
+        level = max665x_get_level(gpio, offset, (config & PIN3_CONFIG_MASK) >> 5);
+        break;
+    case 4:
+        level = max665x_get_level(gpio, offset, (config & PIN3_CONFIG_MASK) >> 6);
+        break;
+    default:
+	    mutex_unlock(&gpio->iodev->iolock);
+        return -EINVAL;
+    }   
+
+	mutex_unlock(&gpio->iodev->iolock);
+
+	return level;
+}
+
+static void max665x_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+    if (value != 0)
+        max665x_direction_input_or_output_high(chip, offset);
+    else
+        max665x_direction_output_low(chip, offset);
+}
+
+int __max665x_probe(struct max665x_gpio *gpio)
+{
+	struct max665x_platform_data *pdata = dev_get_drvdata(gpio->iodev->dev);
+	int offset, ret;
+
+	mutex_init(&gpio->iodev->iolock);
+	dev_set_drvdata(gpio->iodev->dev, gpio);
+
+    if (pdata) {
+        gpio->input_pullup_active = pdata->input_pullup_active;
+        gpio->gp.base = pdata->base;
+    } else {
+        gpio->gp.base = -1; 
+    }
+	gpio->gp.label = gpio->iodev->dev->driver->name;
+
+	gpio->gp.direction_input = max665x_direction_input;
+	gpio->gp.get = max665x_get;
+	gpio->gp.direction_output = max665x_direction_output;
+	gpio->gp.set = max665x_set;
+
+	gpio->gp.can_sleep = 1;
+	gpio->gp.dev = gpio->iodev->dev;
+	gpio->gp.owner = THIS_MODULE;
+
+    /*  
+     * initialize input pullups according to platform data.
+     */
+
+    for (offset = 0; offset < 5; ++offset) {
+        ret = max665x_direction_input(&gpio->gp, offset);
+
+        if (ret)
+            goto exit_destroy;
+    }
+
+	ret = gpiochip_add(&gpio->gp);
+	if (ret)
+		goto exit_destroy;
+
+	return ret;
+
+exit_destroy:
+	dev_set_drvdata(gpio->iodev->dev, NULL);
+	mutex_destroy(&gpio->iodev->iolock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__max665x_probe);
+
+int __max665x_remove(struct device *dev)
+{
+	struct max665x_gpio *gpio = dev_get_drvdata(dev);
+	int ret;
+
+	if (gpio == NULL)
+		return -ENODEV;
+
+	dev_set_drvdata(dev, NULL);
+
+	ret = gpiochip_remove(&gpio->gp);
+	if (!ret) {
+		mutex_destroy(&gpio->iodev->iolock);
+		kfree(gpio);
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
diff --git a/include/linux/mfd/max6651-private.h b/include/linux/mfd/max6651-private.h
index ae90261..1fddf59 100644
--- a/include/linux/mfd/max6651-private.h
+++ b/include/linux/mfd/max6651-private.h
@@ -32,6 +32,7 @@
 #include <linux/i2c.h>
 #include <linux/export.h>
 #include <linux/irqdomain.h>
+#include <linux/gpio.h>
 
 struct max6651_dev {
     struct device *dev;
@@ -42,6 +43,15 @@ struct max6651_dev {
 	int type;
 };
 
+struct max665x_gpio {
+    u8     input_pullup_active;
+    struct max6651_dev *iodev;
+    struct gpio_chip gp; 
+};
+
+extern int __max665x_remove(struct device *dev);
+extern int __max665x_probe(struct max665x_gpio *ts);
+
 enum max6651_types {
 	TYPE_MAX6650,
 	TYPE_MAX6651,
-- 
1.8.5.1

