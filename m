Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3LFCJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:09:33 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38215 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab3LFCJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:09:31 -0500
From: Milo Kim <milo.kim@ti.com>
To: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, Milo Kim <milo.kim@ti.com>
Subject: [PATCH v5 1/4] mfd: add LP3943 MFD driver
Date: Fri, 6 Dec 2013 11:09:20 +0900
Message-ID: <1386295760-22379-1-git-send-email-milo.kim@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP3943 has 16 output pins which can be used as GPIO expander and PWM generator.

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

Signed-off-by: Milo Kim <milo.kim@ti.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
* Patch v5
  Same as v4

* Patch v4
  Driver description was moved from the documentation in patch v3.

* Patch v3
  Now, output pin number is exactly matched with enum value of '
  lp3943_pwm_output'.
  Use dev_get_platdata() helper function in probe().
  Use module_i2c_driver() for initcall.

* Patch v2
  Handle atomic operations for output pin assignment.

 drivers/mfd/Kconfig        |   11 +++
 drivers/mfd/Makefile       |    1 +
 drivers/mfd/lp3943.c       |  167 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/lp3943.h |  114 ++++++++++++++++++++++++++++++
 4 files changed, 293 insertions(+)
 create mode 100644 drivers/mfd/lp3943.c
 create mode 100644 include/linux/mfd/lp3943.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b7c74a7..eb16bd8 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -725,6 +725,17 @@ config MFD_DM355EVM_MSP
 	  boards.  MSP430 firmware manages resets and power sequencing,
 	  inputs from buttons and the IR remote, LEDs, an RTC, and more.
 
+config MFD_LP3943
+	tristate "TI/National Semiconductor LP3943 MFD Driver"
+	depends on I2C
+	select MFD_CORE
+	select REGMAP_I2C
+	help
+	  Support for the TI/National Semiconductor LP3943.
+	  This driver consists of GPIO and PWM drivers.
+	  With these functionalities, it can be used for LED string control or
+	  general usage such like a GPIO controller and a PWM controller.
+
 config MFD_LP8788
 	bool "TI LP8788 Power Management Unit Driver"
 	depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8a28dc9..58554f1 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
 obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
 obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
 
+obj-$(CONFIG_MFD_LP3943)	+= lp3943.o
 obj-$(CONFIG_MFD_LP8788)	+= lp8788.o lp8788-irq.o
 
 da9055-objs			:= da9055-core.o da9055-i2c.o
diff --git a/drivers/mfd/lp3943.c b/drivers/mfd/lp3943.c
new file mode 100644
index 0000000..e322268
--- /dev/null
+++ b/drivers/mfd/lp3943.c
@@ -0,0 +1,167 @@
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
+ * Driver structure:
+ *   LP3943 is an integrated device capable of driving 16 output channels.
+ *   It can be used for a GPIO expander and PWM generators.
+ *
+ *                                   LED control    General usage for a device
+ *                                   ___________   ____________________________
+ *
+ *   LP3943 MFD ---- GPIO expander    leds-gpio        eg) HW enable pin
+ *               |
+ *               --- PWM generator    leds-pwm         eg) PWM input
+ *
+ *   Internal two PWM channels are used for LED dimming effect.
+ *   And each output pin can be used as a GPIO as well.
+ *   The LED functionality can work with GPIOs or PWMs.
+ *   LEDs can be controlled with legacy leds-gpio(static brightness) or
+ *   leds-pwm drivers(dynamic brightness control).
+ *   Alternatively, it can be used for generic GPIO and PWM controller.
+ *   For example, a GPIO is HW enable pin of a device.
+ *   A PWM is input pin of a backlight device.
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
+	struct device *dev = &cl->dev;
+
+	lp3943 = devm_kzalloc(dev, sizeof(*lp3943), GFP_KERNEL);
+	if (!lp3943)
+		return -ENOMEM;
+
+	lp3943->regmap = devm_regmap_init_i2c(cl, &lp3943_regmap_config);
+	if (IS_ERR(lp3943->regmap))
+		return PTR_ERR(lp3943->regmap);
+
+	lp3943->pdata = dev_get_platdata(dev);
+	lp3943->dev = dev;
+	lp3943->mux_cfg = lp3943_mux_cfg;
+	i2c_set_clientdata(cl, lp3943);
+
+	return mfd_add_devices(dev, -1, lp3943_devs, ARRAY_SIZE(lp3943_devs),
+			       NULL, 0, NULL);
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
+#ifdef CONFIG_OF
+static const struct of_device_id lp3943_of_match[] = {
+	{ .compatible = "ti,lp3943", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, lp3943_of_match);
+#endif
+
+static struct i2c_driver lp3943_driver = {
+	.probe = lp3943_probe,
+	.remove = lp3943_remove,
+	.driver = {
+		.name = "lp3943",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(lp3943_of_match),
+	},
+	.id_table = lp3943_ids,
+};
+
+module_i2c_driver(lp3943_driver);
+
+MODULE_DESCRIPTION("LP3943 MFD Core Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/lp3943.h b/include/linux/mfd/lp3943.h
new file mode 100644
index 0000000..3490db7
--- /dev/null
+++ b/include/linux/mfd/lp3943.h
@@ -0,0 +1,114 @@
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
+#define LP3943_NUM_PWMS			2
+
+enum lp3943_pwm_output {
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
+ * @output: Output pins which are mapped to each PWM channel
+ * @num_outputs: Number of outputs
+ */
+struct lp3943_pwm_map {
+	enum lp3943_pwm_output *output;
+	int num_outputs;
+};
+
+/*
+ * struct lp3943_platform_data
+ * @pwms: Output channel definitions for PWM channel 0 and 1
+ */
+struct lp3943_platform_data {
+	struct lp3943_pwm_map *pwms[LP3943_NUM_PWMS];
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
1.7.10.4

