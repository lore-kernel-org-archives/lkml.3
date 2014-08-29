Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaH2Kq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 06:46:29 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:44859 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaH2Kq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 06:46:26 -0400
From: Daniel Jeong <gshark.jeong@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, Daniel Jeong <gshark.jeong@gmail.com>
Subject: [PATCH] backlight: add new lm3509 backlight driver
Date: Fri, 29 Aug 2014 19:46:14 +0900
Message-Id: <1409309174-1137-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a general driver for LM3509 backlgiht chip of TI.
LM3509 is High Efficiency Boost for White LED's and/or OLED Displays with Dual
Current Sinks. This driver supports OLED/White LED select, brightness control
sub/main conrtorl. 
You can refer to the datasheet at http://www.ti.com/product/lm3509 for review.

Signed-off-by: Daniel Jeong <gshark.jeong@gmail.com>
---
 drivers/video/backlight/Kconfig     |    7 +
 drivers/video/backlight/Makefile    |    1 +
 drivers/video/backlight/lm3509_bl.c |  399 +++++++++++++++++++++++++++++++++++
 3 files changed, 407 insertions(+)
 create mode 100644 drivers/video/backlight/lm3509_bl.c

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 8d03924..9dc119e 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -366,6 +366,13 @@ config BACKLIGHT_AAT2870
 	  If you have a AnalogicTech AAT2870 say Y to enable the
 	  backlight driver.
 
+config BACKLIGHT_LM3509
+	tristate "Backlight Driver for LM3509"
+	depends on BACKLIGHT_CLASS_DEVICE && I2C
+	select REGMAP_I2C
+	help
+	  This supports TI LM3509 Backlight Driver
+
 config BACKLIGHT_LM3630A
 	tristate "Backlight Driver for LM3630A"
 	depends on BACKLIGHT_CLASS_DEVICE && I2C && PWM
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index fcd50b73..c34ed98 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_BACKLIGHT_GPIO)		+= gpio_backlight.o
 obj-$(CONFIG_BACKLIGHT_HP680)		+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_HP700)		+= jornada720_bl.o
 obj-$(CONFIG_BACKLIGHT_IPAQ_MICRO)	+= ipaq_micro_bl.o
+obj-$(CONFIG_BACKLIGHT_LM3509)		+= lm3509_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3533)		+= lm3533_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3630A)		+= lm3630a_bl.o
 obj-$(CONFIG_BACKLIGHT_LM3639)		+= lm3639_bl.o
diff --git a/drivers/video/backlight/lm3509_bl.c b/drivers/video/backlight/lm3509_bl.c
new file mode 100644
index 0000000..4f4fb85
--- /dev/null
+++ b/drivers/video/backlight/lm3509_bl.c
@@ -0,0 +1,399 @@
+/*
+ * Simple driver for Texas Instruments LM3509 Backlight driver chip
+ * Copyright (C) 2014 Texas Instruments
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+#include <linux/backlight.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/module.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+
+#define LM3509_NAME "lm3509"
+
+#define REG_GP	0x10
+#define REG_BMAIN	0xa0
+#define REG_BSUB	0xb0
+#define REG_MAX		0xff
+
+#define LM3509_POR_BR_MAIN	0xe0
+#define LM3509_POR_BR_SUB	0xe0
+#define LM3509_MAX_BR		0xff
+
+enum lm3509_leds {
+	BLED_BMAIN = 0,
+	BLED_BSUB
+};
+
+struct lm3509_chip {
+	struct device *dev;
+	struct backlight_device *bmain;
+	struct backlight_device *bsub;
+	struct regmap *regmap;
+};
+
+/*
+ * enable main
+ * 0 : disables the main current sink and forces MAIN high impedence.
+ * 1 : enables the main current sink.
+ */
+static ssize_t lm3509_bmain_enable_store(struct device *dev,
+				      struct device_attribute *devAttr,
+				      const char *buf, size_t size)
+{
+	struct lm3509_chip *pchip = dev_get_drvdata(dev);
+	unsigned int state;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &state);
+	if (ret) {
+		dev_err(pchip->dev, "input conversion fail\n");
+		return ret;
+	}
+
+	if (!state)
+		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x1, 0x0);
+	else
+		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x1, 0x1);
+	if (ret < 0) {
+		dev_err(pchip->dev, "i2c access fail to register\n");
+		return ret;
+	}
+
+	return size;
+}
+
+static DEVICE_ATTR(main_enable, S_IWUSR, NULL, lm3509_bmain_enable_store);
+
+/*
+ * OLED mode control
+ * 0 : white led mode - main and sub current sinks are active
+ * 1 : OLED mode - sub current sink is idabled
+ */
+static ssize_t lm3509_oled_mode_store(struct device *dev,
+				      struct device_attribute *devAttr,
+				      const char *buf, size_t size)
+{
+	struct lm3509_chip *pchip = dev_get_drvdata(dev);
+	unsigned int state;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &state);
+	if (ret) {
+		dev_err(pchip->dev, "input conversion fail\n");
+		return ret;
+	}
+
+	if (!state)
+		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x20, 0x00);
+	else
+		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x20, 0x20);
+	if (ret < 0) {
+		dev_err(pchip->dev, "i2c access fail to register\n");
+		return ret;
+	}
+
+	return size;
+}
+
+static DEVICE_ATTR(oled_enable, S_IWUSR, NULL, lm3509_oled_mode_store);
+
+/*
+ * brightness rate of change
+ * set the rate of change of the LED current in to MAIN and SUB/FB
+ * in response to change in the contents of registers
+ * 0 - 51 us/step
+ * 1 - 13 ms/step
+ * 2 - 26 ms/step
+ * 3 - 52 ms/step
+ */
+static ssize_t lm3509_rate_store(struct device *dev,
+				      struct device_attribute *devAttr,
+				      const char *buf, size_t size)
+{
+	struct lm3509_chip *pchip = dev_get_drvdata(dev);
+	unsigned int state;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &state);
+	if (ret) {
+		dev_err(pchip->dev, "input conversion fail\n");
+		return ret;
+	}
+
+	ret = regmap_update_bits(pchip->regmap, REG_GP, 0x18, state << 3);
+	if (ret < 0) {
+		dev_err(pchip->dev, "i2c access fail to register\n");
+		return ret;
+	}
+
+	return size;
+}
+
+static DEVICE_ATTR(rate, S_IWUSR, NULL, lm3509_rate_store);
+
+/* update and get brightness */
+static int lm3509_bmain_update_status(struct backlight_device *bl)
+{
+	struct lm3509_chip *pchip = bl_get_data(bl);
+	int ret;
+
+	ret = regmap_write(pchip->regmap, REG_BMAIN, bl->props.brightness);
+	if (ret < 0)
+		dev_err(pchip->dev, "i2c access fail to register\n");
+	return bl->props.brightness;
+}
+
+static int lm3509_bmain_get_brightness(struct backlight_device *bl)
+{
+	return bl->props.brightness;
+}
+
+static const struct backlight_ops lm3509_bmain_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.update_status = lm3509_bmain_update_status,
+	.get_brightness = lm3509_bmain_get_brightness,
+};
+
+/*
+ * enable sub
+ * 0 : disables the secondary current sink and forces SUB/FB high impedence.
+ * 1 : enables the secondary current sink.
+ */
+static ssize_t lm3509_bsub_enable_store(struct device *dev,
+				      struct device_attribute *devAttr,
+				      const char *buf, size_t size)
+{
+	struct lm3509_chip *pchip = dev_get_drvdata(dev);
+	unsigned int state;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &state);
+	if (ret) {
+		dev_err(pchip->dev, "input conversion fail\n");
+		return ret;
+	}
+
+	if (!state)
+		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x2, 0x0);
+	else
+		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x2, 0x2);
+	if (ret < 0) {
+		dev_err(pchip->dev, "i2c access fail to register\n");
+		return ret;
+	}
+
+	return size;
+}
+
+static DEVICE_ATTR(sub_enable, S_IWUSR, NULL, lm3509_bsub_enable_store);
+
+/*
+ * uni mode select
+ * 0 : allows the current into MAIN and SUB/FB to be independently controlled
+ *     via the bmain and bsub.
+ * 1 : disables the bsub register and causes the contents of bmain to set
+ *     the current in both the MAIN and SUB/FB current sinks.
+ */
+static ssize_t lm3509_uni_mode_store(struct device *dev,
+				      struct device_attribute *devAttr,
+				      const char *buf, size_t size)
+{
+	struct lm3509_chip *pchip = dev_get_drvdata(dev);
+	unsigned int state;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &state);
+	if (ret) {
+		dev_err(pchip->dev, "input conversion fail\n");
+		return ret;
+	}
+
+	if (!state)
+		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x4, 0x0);
+	else
+		ret = regmap_update_bits(pchip->regmap, REG_GP, 0x4, 0x4);
+	if (ret < 0) {
+		dev_err(pchip->dev, "i2c access fail to register\n");
+		return ret;
+	}
+
+	return size;
+}
+
+static DEVICE_ATTR(uni_mode, S_IWUSR, NULL, lm3509_uni_mode_store);
+
+/* update and get brightness */
+static int lm3509_bsub_update_status(struct backlight_device *bl)
+{
+	struct lm3509_chip *pchip = bl_get_data(bl);
+	int ret;
+
+	ret = regmap_write(pchip->regmap, REG_BSUB, bl->props.brightness);
+	if (ret < 0)
+		dev_err(pchip->dev, "i2c access fail to register\n");
+	return bl->props.brightness;
+}
+
+static int lm3509_bsub_get_brightness(struct backlight_device *bl)
+{
+	return bl->props.brightness;
+}
+
+static const struct backlight_ops lm3509_bsub_ops = {
+	.options = BL_CORE_SUSPENDRESUME,
+	.update_status = lm3509_bsub_update_status,
+	.get_brightness = lm3509_bsub_get_brightness,
+};
+
+static int lm3509_backlight_register(struct lm3509_chip *pchip,
+				     enum lm3509_leds ledno)
+{
+	struct backlight_properties props;
+
+	props.type = BACKLIGHT_RAW;
+	switch (ledno) {
+	case BLED_BMAIN:
+		props.brightness = LM3509_POR_BR_MAIN;
+		props.max_brightness = LM3509_MAX_BR;
+		pchip->bmain =
+			devm_backlight_device_register(pchip->dev, "bmain",
+				pchip->dev, pchip, &lm3509_bmain_ops, &props);
+		if (IS_ERR(pchip->bmain))
+			return -EIO;
+		break;
+	case BLED_BSUB:
+		props.brightness = LM3509_POR_BR_SUB;
+		props.max_brightness = LM3509_MAX_BR;
+		pchip->bsub =
+			devm_backlight_device_register(pchip->dev, "bsub",
+				pchip->dev, pchip, &lm3509_bsub_ops, &props);
+		if (IS_ERR(pchip->bsub))
+			return -EIO;
+		break;
+	default:
+		BUG();
+	}
+	return 0;
+}
+
+static const struct regmap_config lm3509_regmap = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = REG_MAX,
+};
+
+static int lm3509_probe(struct i2c_client *client,
+				  const struct i2c_device_id *id)
+{
+	struct lm3509_chip *pchip;
+	int ret;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev, "fail : i2c functionality check\n");
+		return -EOPNOTSUPP;
+	}
+
+	pchip = devm_kzalloc(&client->dev, sizeof(struct lm3509_chip),
+			     GFP_KERNEL);
+	if (!pchip)
+		return -ENOMEM;
+	pchip->dev = &client->dev;
+
+	pchip->regmap = devm_regmap_init_i2c(client, &lm3509_regmap);
+	if (IS_ERR(pchip->regmap)) {
+		dev_err(&client->dev, "fail : allocate register map\n");
+		ret = PTR_ERR(pchip->regmap);
+		return ret;
+	}
+	i2c_set_clientdata(client, pchip);
+
+	ret = lm3509_backlight_register(pchip, BLED_BMAIN);
+	if (ret < 0)
+		return ret;
+
+	ret = lm3509_backlight_register(pchip, BLED_BSUB);
+	if (ret < 0)
+		return ret;
+
+	ret = device_create_file(&(pchip->bmain->dev), &dev_attr_main_enable);
+	if (ret < 0)
+		return ret;
+
+	ret = device_create_file(&(pchip->bmain->dev), &dev_attr_oled_enable);
+	if (ret < 0)
+		goto err_oled_enable;
+
+	ret = device_create_file(&(pchip->bmain->dev), &dev_attr_rate);
+	if (ret < 0)
+		goto err_rate;
+
+	ret = device_create_file(&(pchip->bsub->dev), &dev_attr_sub_enable);
+	if (ret < 0)
+		goto err_sub_enable;
+
+	ret = device_create_file(&(pchip->bsub->dev), &dev_attr_uni_mode);
+	if (ret < 0)
+		goto err_uni_mode;
+
+	return 0;
+
+err_uni_mode:
+	device_remove_file(&(pchip->bsub->dev), &dev_attr_sub_enable);
+err_sub_enable:
+	device_remove_file(&(pchip->bmain->dev), &dev_attr_rate);
+err_rate:
+	device_remove_file(&(pchip->bmain->dev), &dev_attr_oled_enable);
+err_oled_enable:
+	device_remove_file(&(pchip->bmain->dev), &dev_attr_main_enable);
+	dev_err(pchip->dev, "failed : add sysfs entries\n");
+
+	return ret;
+}
+
+static int lm3509_remove(struct i2c_client *client)
+{
+	int ret;
+	struct lm3509_chip *pchip = i2c_get_clientdata(client);
+
+	device_remove_file(&(pchip->bsub->dev), &dev_attr_uni_mode);
+	device_remove_file(&(pchip->bsub->dev), &dev_attr_sub_enable);
+	device_remove_file(&(pchip->bmain->dev), &dev_attr_rate);
+	device_remove_file(&(pchip->bmain->dev), &dev_attr_oled_enable);
+	device_remove_file(&(pchip->bmain->dev), &dev_attr_main_enable);
+
+	ret = regmap_write(pchip->regmap, REG_GP, 0x0);
+	if (ret < 0)
+		dev_err(pchip->dev, "i2c failed to access register\n");
+
+	return 0;
+}
+
+static const struct i2c_device_id lm3509_id[] = {
+	{LM3509_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, lm3509_id);
+
+static struct i2c_driver lm3509_i2c_driver = {
+	.driver = {
+		.name = LM3509_NAME,
+	},
+	.probe = lm3509_probe,
+	.remove = lm3509_remove,
+	.id_table = lm3509_id,
+};
+
+module_i2c_driver(lm3509_i2c_driver);
+
+MODULE_DESCRIPTION("Texas Instruments Backlight driver for LM3509");
+MODULE_AUTHOR("Daniel Jeong <gshark.jeong@gmail.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.7.9.5

