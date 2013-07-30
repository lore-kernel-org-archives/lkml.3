Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3G3Am2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 20:42:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41943 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab3G3AmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 20:42:25 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "Samuel Ortiz (sameo@linux.intel.com)" <sameo@linux.intel.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>
Subject: [PATCH v2 1/4] mfd: add LP3943 MFD driver
Thread-Topic: [PATCH v2 1/4] mfd: add LP3943 MFD driver
Thread-Index: Ac6MtTyjOqxscTSbS1eNJ8jjFJq3OQ==
Date: Tue, 30 Jul 2013 00:42:16 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E849D8@DQHE06.ent.ti.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6U0gW4R030752

LP3943 has 16 output pins which can be used as GPIO expander and PWM generator.

* Why do we need GPIO and PWM drivers instead of LED driver?
  To support LED control and general usage, GPIO and PWM drivers are necessary.

  According to the datasheet(1), it's just a LED driver which has 16 channels.
  But here is another application, a GPIO expander.(2)
  (1) http://www.ti.com/lit/ds/snvs256b/snvs256b.pdf
  (2) http://www.ti.com/lit/an/snva287a/snva287a.pdf

  Internal two PWM controllers are used for LED dimming effect.
  And each output pin can be used as a GPIO as well.
  LED functionality can work with GPIOs or PWMs.
  LEDs can be controlled with legacy leds-gpio(static brightness) or
  leds-pwm drivers(dynamic brightness control).
  Additionally, it can be used for generic GPIO and PWM controller.
  For example, a GPIO is HW enable pin of a device.
  PWM is input pin of a backlight device.

  Therefore, LP3943 GPIO and PWM drivers support all application cases.

                                  LED control    General usage for a device
                                  ___________   ____________________________

  LP3943 MFD ---- GPIO expander    leds-gpio            eg) HW enable pin
              |
              --- PWM generator    leds-pwm             eg) PWM input


* Regmap I2C interface for R/W LP3943 registers

* Atomic operations for output pin assignment
  The driver should check whether requested pin is available or not.
  If the pin is already used, pin request returns as a failure.
  A driver data, 'pin_used' is checked when gpio_request() and
  pwm_request() are called. If the pin is available, then pin_used is set.
  And it is cleared when gpio_free() and pwm_free().

* Device tree support
  Compatible strings for GPIO and PWM driver.
  LP3943 platform data is PWM related, so parsing the device tree is
  implemented in the PWM driver.

Cc: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 drivers/mfd/Kconfig        |   11 +++
 drivers/mfd/Makefile       |    1 +
 drivers/mfd/lp3943.c       |  165 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/lp3943.h |  115 ++++++++++++++++++++++++++++++
 4 files changed, 292 insertions(+)
 create mode 100644 drivers/mfd/lp3943.c
 create mode 100644 include/linux/mfd/lp3943.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ff553ba..2d47d43 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -506,6 +506,17 @@ config PMIC_ADP5520
 	  individual components like LCD backlight, LEDs, GPIOs and Kepad
 	  under the corresponding menus.
 
+config MFD_LP3943
+	tristate "TI/National Semiconductor LP3943 MFD Driver"
+	depends on I2C
+	select MFD_CORE
+	select REGMAP_I2C
+	help
+	  Support for the TI/National Semiconductor LP3943.
+	  This driver consists of GPIO and PWM drivers.
+	  With these functionality, it can be used for LED string control or
+	  general usage such like a GPIO controller and a PWM controller.
+
 config MFD_LP8788
 	bool "Texas Instruments LP8788 Power Management Unit Driver"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8b977f8..8f129a4 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -96,6 +96,7 @@ obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
 obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
 obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
 
+obj-$(CONFIG_MFD_LP3943)	+= lp3943.o
 obj-$(CONFIG_MFD_LP8788)	+= lp8788.o lp8788-irq.o
 
 da9055-objs			:= da9055-core.o da9055-i2c.o
diff --git a/drivers/mfd/lp3943.c b/drivers/mfd/lp3943.c
new file mode 100644
index 0000000..4658965
--- /dev/null
+++ b/drivers/mfd/lp3943.c
@@ -0,0 +1,165 @@
+/*
+ * TI/National Semiconductor LP3943 MFD Core Driver
+ *
+ * Copyright 2013 Texas Instruments
+ *
+ * Author: Milo Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/lp3943.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+
+#define LP3943_MAX_REGISTERS		0x09
+
+/* Register configuration for pin MUX */
+static const struct lp3943_reg_cfg lp3943_mux_cfg[] = {
+	/* address, mask, shift */
+	{ LP3943_REG_MUX0, 0x03, 0 },
+	{ LP3943_REG_MUX0, 0x0C, 2 },
+	{ LP3943_REG_MUX0, 0x30, 4 },
+	{ LP3943_REG_MUX0, 0xC0, 6 },
+	{ LP3943_REG_MUX1, 0x03, 0 },
+	{ LP3943_REG_MUX1, 0x0C, 2 },
+	{ LP3943_REG_MUX1, 0x30, 4 },
+	{ LP3943_REG_MUX1, 0xC0, 6 },
+	{ LP3943_REG_MUX2, 0x03, 0 },
+	{ LP3943_REG_MUX2, 0x0C, 2 },
+	{ LP3943_REG_MUX2, 0x30, 4 },
+	{ LP3943_REG_MUX2, 0xC0, 6 },
+	{ LP3943_REG_MUX3, 0x03, 0 },
+	{ LP3943_REG_MUX3, 0x0C, 2 },
+	{ LP3943_REG_MUX3, 0x30, 4 },
+	{ LP3943_REG_MUX3, 0xC0, 6 },
+};
+
+static struct mfd_cell lp3943_devs[] = {
+	{
+		.name = "lp3943-pwm",
+		.of_compatible = "ti,lp3943-pwm",
+	},
+	{
+		.name = "lp3943-gpio",
+		.of_compatible = "ti,lp3943-gpio",
+	},
+};
+
+int lp3943_read_byte(struct lp3943 *lp3943, u8 reg, u8 *read)
+{
+	int ret;
+	unsigned int val;
+
+	ret = regmap_read(lp3943->regmap, reg, &val);
+	if (ret < 0)
+		return ret;
+
+	*read = (u8)val;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(lp3943_read_byte);
+
+int lp3943_write_byte(struct lp3943 *lp3943, u8 reg, u8 data)
+{
+	return regmap_write(lp3943->regmap, reg, data);
+}
+EXPORT_SYMBOL_GPL(lp3943_write_byte);
+
+int lp3943_update_bits(struct lp3943 *lp3943, u8 reg, u8 mask, u8 data)
+{
+	return regmap_update_bits(lp3943->regmap, reg, mask, data);
+}
+EXPORT_SYMBOL_GPL(lp3943_update_bits);
+
+static const struct regmap_config lp3943_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = LP3943_MAX_REGISTERS,
+};
+
+static int lp3943_probe(struct i2c_client *cl, const struct i2c_device_id *id)
+{
+	struct lp3943 *lp3943;
+	int ret;
+
+	lp3943 = devm_kzalloc(&cl->dev, sizeof(*lp3943), GFP_KERNEL);
+	if (!lp3943)
+		return -ENOMEM;
+
+	lp3943->regmap = devm_regmap_init_i2c(cl, &lp3943_regmap_config);
+	if (IS_ERR(lp3943->regmap)) {
+		ret = PTR_ERR(lp3943->regmap);
+		dev_err(&cl->dev, "Regmap init error: %d\n", ret);
+		return ret;
+	}
+
+	lp3943->pdata = cl->dev.platform_data;
+	lp3943->dev = &cl->dev;
+	lp3943->mux_cfg = lp3943_mux_cfg;
+	i2c_set_clientdata(cl, lp3943);
+
+	ret = mfd_add_devices(lp3943->dev, -1, lp3943_devs,
+			ARRAY_SIZE(lp3943_devs), NULL, 0, NULL);
+	if (ret) {
+		dev_err(lp3943->dev, "failed to add MFD devices: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int lp3943_remove(struct i2c_client *cl)
+{
+	struct lp3943 *lp3943 = i2c_get_clientdata(cl);
+
+	mfd_remove_devices(lp3943->dev);
+	return 0;
+}
+
+static const struct i2c_device_id lp3943_ids[] = {
+	{ "lp3943", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, lp3943_ids);
+
+static const struct of_device_id lp3943_dt_ids[] = {
+	{ .compatible = "ti,lp3943", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lp3943_dt_ids);
+
+static struct i2c_driver lp3943_driver = {
+	.driver = {
+		.name = "lp3943",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(lp3943_dt_ids),
+	},
+	.probe = lp3943_probe,
+	.remove = lp3943_remove,
+	.id_table = lp3943_ids,
+};
+
+static int __init lp3943_init(void)
+{
+	return i2c_add_driver(&lp3943_driver);
+}
+subsys_initcall(lp3943_init);
+
+static void __exit lp3943_exit(void)
+{
+	i2c_del_driver(&lp3943_driver);
+}
+module_exit(lp3943_exit);
+
+MODULE_DESCRIPTION("LP3943 MFD Core Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/lp3943.h b/include/linux/mfd/lp3943.h
new file mode 100644
index 0000000..fae320d
--- /dev/null
+++ b/include/linux/mfd/lp3943.h
@@ -0,0 +1,115 @@
+/*
+ * TI/National Semiconductor LP3943 Device
+ *
+ * Copyright 2013 Texas Instruments
+ *
+ * Author: Milo Kim <milo.kim@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#ifndef __MFD_LP3943_H__
+#define __MFD_LP3943_H__
+
+#include <linux/gpio.h>
+#include <linux/pwm.h>
+#include <linux/regmap.h>
+
+/* Registers */
+#define LP3943_REG_GPIO_A		0x00
+#define LP3943_REG_GPIO_B		0x01
+#define LP3943_REG_PRESCALE0		0x02
+#define LP3943_REG_PWM0			0x03
+#define LP3943_REG_PRESCALE1		0x04
+#define LP3943_REG_PWM1			0x05
+#define LP3943_REG_MUX0			0x06
+#define LP3943_REG_MUX1			0x07
+#define LP3943_REG_MUX2			0x08
+#define LP3943_REG_MUX3			0x09
+
+/* Bit description for LP3943_REG_MUX0 ~ 3 */
+#define LP3943_GPIO_IN			0x00
+#define LP3943_GPIO_OUT_HIGH		0x00
+#define LP3943_GPIO_OUT_LOW		0x01
+#define LP3943_DIM_PWM0			0x02
+#define LP3943_DIM_PWM1			0x03
+
+enum lp3943_pwm_output {
+	LP3943_PWM_INVALID,
+	LP3943_PWM_OUT0,
+	LP3943_PWM_OUT1,
+	LP3943_PWM_OUT2,
+	LP3943_PWM_OUT3,
+	LP3943_PWM_OUT4,
+	LP3943_PWM_OUT5,
+	LP3943_PWM_OUT6,
+	LP3943_PWM_OUT7,
+	LP3943_PWM_OUT8,
+	LP3943_PWM_OUT9,
+	LP3943_PWM_OUT10,
+	LP3943_PWM_OUT11,
+	LP3943_PWM_OUT12,
+	LP3943_PWM_OUT13,
+	LP3943_PWM_OUT14,
+	LP3943_PWM_OUT15,
+};
+
+/*
+ * struct lp3943_pwm_map
+ * @output: Output pins which are mapped to each PWM controller
+ * @num_outputs: Number of outputs
+ */
+struct lp3943_pwm_map {
+	enum lp3943_pwm_output *output;
+	int num_outputs;
+};
+
+/*
+ * struct lp3943_platform_data
+ * @pwm0: Output channel definitions for PWM 0 controller
+ * @pwm1: Output channel definitions for PWM 1 controller
+ */
+struct lp3943_platform_data {
+	struct lp3943_pwm_map *pwm0;
+	struct lp3943_pwm_map *pwm1;
+};
+
+/*
+ * struct lp3943_reg_cfg
+ * @reg: Register address
+ * @mask: Register bit mask to be updated
+ * @shift: Register bit shift
+ */
+struct lp3943_reg_cfg {
+	u8 reg;
+	u8 mask;
+	u8 shift;
+};
+
+/*
+ * struct lp3943
+ * @dev: Parent device pointer
+ * @regmap: Used for I2C communication on accessing registers
+ * @pdata: LP3943 platform specific data
+ * @mux_cfg: Register configuration for pin MUX
+ * @pin_used: Bit mask for output pin used.
+ *	      This bitmask is used for pin assignment management.
+ *	      1 = pin used, 0 = available.
+ *	      Only LSB 16 bits are used, but it is unsigned long type
+ *	      for atomic bitwise operations.
+ */
+struct lp3943 {
+	struct device *dev;
+	struct regmap *regmap;
+	struct lp3943_platform_data *pdata;
+	const struct lp3943_reg_cfg *mux_cfg;
+	unsigned long pin_used;
+};
+
+int lp3943_read_byte(struct lp3943 *lp3943, u8 reg, u8 *read);
+int lp3943_write_byte(struct lp3943 *lp3943, u8 reg, u8 data);
+int lp3943_update_bits(struct lp3943 *lp3943, u8 reg, u8 mask, u8 data);
+#endif
-- 
1.7.9.5


Best Regards,
Milo


ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
