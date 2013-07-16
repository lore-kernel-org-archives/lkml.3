Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab3GPCii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:38:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52529 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3GPCif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:38:35 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "sameo@linux.intel.com" <sameo@linux.intel.com>
CC: "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: [PATCH 1/3] mfd: add LP3943 MFD driver
Thread-Topic: [PATCH 1/3] mfd: add LP3943 MFD driver
Thread-Index: Ac6BzEn3Qmj4peQLTCahfY4cnCS0Aw==
Date: Tue, 16 Jul 2013 02:38:29 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E815C3@DQHE06.ent.ti.com>
Accept-Language: en-US, ko-KR
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP3943 has 16 output LED channels which can be used as GPIO expander and
PWM generators.
This patch supports the MFD structure of those features.

* Regmap I2C interface for R/W LP3943 registers

* Device tree bindings updated
  PWM generator output ports can be defined in the platform data.
  Those are configurable with the DT structure as well.

Signed-off-by: Milo Kim <milo.kim@ti.com>
---
 Documentation/devicetree/bindings/mfd/lp3943.txt |   23 +++
 drivers/mfd/Kconfig                              |    8 +
 drivers/mfd/Makefile                             |    1 +
 drivers/mfd/lp3943.c                             |  206 ++++++++++++++++++++++
 include/linux/mfd/lp3943.h                       |   98 ++++++++++
 5 files changed, 336 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/lp3943.txt
 create mode 100644 drivers/mfd/lp3943.c
 create mode 100644 include/linux/mfd/lp3943.h

diff --git a/Documentation/devicetree/bindings/mfd/lp3943.txt b/Documentation/devicetree/bindings/mfd/lp3943.txt
new file mode 100644
index 0000000..4eb251d
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/lp3943.txt
@@ -0,0 +1,23 @@
+Bindings for TI/National Semiconductor LP3943 Driver
+
+Required properties:
+  - compatible: "ti,lp3943"
+  - reg: 7bit I2C slave address. 0x60 ~ 0x67
+
+Optional properties:
+  - ti,pwm0, ti,pwm1: Output channel definition for PWM port 0 and 1
+                      0 = invalid, 1 = LED0, 2 = LED 1, ... 16 = LED15
+
+Datasheet
+  http://www.ti.com/lit/ds/snvs256b/snvs256b.pdf
+
+Application note: How to use LP3943 as a GPIO expander and PWM generator
+  http://www.ti.com/lit/an/snva287a/snva287a.pdf
+
+Example:
+
+	lp3943@60 {
+		compatible = "ti,lp3943";
+		reg = <0x60>;
+		pwm1 = /bits/ 8 <2>;	/* use LED1 output as PWM #1 */
+	};
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ff553ba..cf9b943 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -506,6 +506,14 @@ config PMIC_ADP5520
 	  individual components like LCD backlight, LEDs, GPIOs and Kepad
 	  under the corresponding menus.
 
+config MFD_LP3943
+	tristate "TI/National Semiconductor LP3943 MFD Driver"
+	depends on I2C
+	select MFD_CORE
+	select REGMAP_I2C
+	help
+	  TI LP3943 supports a GPIO expander and two PWM generators.
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
index 0000000..6d31066
--- /dev/null
+++ b/drivers/mfd/lp3943.c
@@ -0,0 +1,206 @@
+/*
+ * TI/National Semiconductor LP3943 MFD Core Driver
+ *
+ * Copyright 2013 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
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
+#include <linux/of_gpio.h>
+#include <linux/slab.h>
+
+#define LP3943_MAX_REGISTERS		0x09
+
+/* Register configuration for pin MUX */
+static const struct lp3943_reg_cfg lp3943_mux_cfg[16] = {
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
+	},
+	{
+		.name = "lp3943-gpio",
+	},
+};
+
+int lp3943_read_byte(struct lp3943 *l, u8 reg, u8 *read)
+{
+	int ret;
+	unsigned int val;
+
+	ret = regmap_read(l->regmap, reg, &val);
+	if (ret < 0) {
+		dev_err(l->dev, "failed to read 0x%.2x\n", reg);
+		return ret;
+	}
+
+	*read = (u8)val;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(lp3943_read_byte);
+
+int lp3943_write_byte(struct lp3943 *l, u8 reg, u8 data)
+{
+	return regmap_write(l->regmap, reg, data);
+}
+EXPORT_SYMBOL_GPL(lp3943_write_byte);
+
+int lp3943_update_bits(struct lp3943 *l, u8 reg, u8 mask, u8 data)
+{
+	return regmap_update_bits(l->regmap, reg, mask, data);
+}
+EXPORT_SYMBOL_GPL(lp3943_update_bits);
+
+#ifdef CONFIG_OF
+static int lp3943_parse_dt(struct device *dev, struct device_node *node)
+{
+	struct lp3943_platform_data *pdata;
+	u8 port = 0;
+
+	if (!node) {
+		dev_err(dev, "no platform data\n");
+		return -EINVAL;
+	}
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	of_property_read_u8(node, "ti,pwm0", &port);
+	pdata->pwm0 = (enum lp3943_pwm_output)port;
+	port = 0;
+	of_property_read_u8(node, "ti,pwm1", &port);
+	pdata->pwm1 = (enum lp3943_pwm_output)port;
+
+	dev->platform_data = pdata;
+	return 0;
+}
+#else
+static int lp3943_parse_dt(struct device *dev, struct device_node *node)
+{
+	return -EINVAL;
+}
+#endif
+
+static const struct regmap_config lp3943_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = LP3943_MAX_REGISTERS,
+};
+
+static int lp3943_probe(struct i2c_client *cl, const struct i2c_device_id *id)
+{
+	struct lp3943_platform_data *pdata;
+	struct lp3943 *l;
+	int err;
+
+	if (!cl->dev.platform_data) {
+		err = lp3943_parse_dt(&cl->dev, cl->dev.of_node);
+		if (err)
+			return err;
+	}
+
+	pdata = cl->dev.platform_data;
+
+	l = devm_kzalloc(&cl->dev, sizeof(struct lp3943), GFP_KERNEL);
+	if (!l)
+		return -ENOMEM;
+
+	l->regmap = devm_regmap_init_i2c(cl, &lp3943_regmap_config);
+	if (IS_ERR(l->regmap)) {
+		err = PTR_ERR(l->regmap);
+		dev_err(&cl->dev, "regmap init i2c err: %d\n", err);
+		return err;
+	}
+
+	l->pdata = pdata;
+	l->dev = &cl->dev;
+	l->mux_cfg = lp3943_mux_cfg;
+	i2c_set_clientdata(cl, l);
+
+	err = mfd_add_devices(l->dev, -1, lp3943_devs, ARRAY_SIZE(lp3943_devs),
+			NULL, 0, NULL);
+	if (err) {
+		dev_err(l->dev, "add device err: %d\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
+static int lp3943_remove(struct i2c_client *cl)
+{
+	struct lp3943 *l = i2c_get_clientdata(cl);
+
+	mfd_remove_devices(l->dev);
+	return 0;
+}
+
+static const struct i2c_device_id lp3943_ids[] = {
+	{"lp3943", 0},
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
+MODULE_DESCRIPTION("TI LP3943 MFD Core Driver");
+MODULE_AUTHOR("Milo Kim");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/lp3943.h b/include/linux/mfd/lp3943.h
new file mode 100644
index 0000000..208fc73
--- /dev/null
+++ b/include/linux/mfd/lp3943.h
@@ -0,0 +1,98 @@
+/*
+ * TI/National Semiconductor LP3943 Device
+ *
+ * Copyright 2013 Texas Instruments
+ *
+ * Author: Milo(Woogyom) Kim <milo.kim@ti.com>
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
+	LP3943_PWM_LED0,
+	LP3943_PWM_LED1,
+	LP3943_PWM_LED2,
+	LP3943_PWM_LED3,
+	LP3943_PWM_LED4,
+	LP3943_PWM_LED5,
+	LP3943_PWM_LED6,
+	LP3943_PWM_LED7,
+	LP3943_PWM_LED8,
+	LP3943_PWM_LED9,
+	LP3943_PWM_LED10,
+	LP3943_PWM_LED11,
+	LP3943_PWM_LED12,
+	LP3943_PWM_LED13,
+	LP3943_PWM_LED14,
+	LP3943_PWM_LED15,
+};
+
+/**
+ * struct lp3943_platform_data
+ * @pwm0: LED output channel definition for PWM 0 port
+ * @pwm1: LED output channel definition for PWM 1 port
+ */
+struct lp3943_platform_data {
+	enum lp3943_pwm_output pwm0;
+	enum lp3943_pwm_output pwm1;
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
+ * @regmap: Used for i2c communcation on accessing registers
+ * @pdata: LP3943 platform specific data
+ */
+struct lp3943 {
+	struct device *dev;
+	struct regmap *regmap;
+	struct lp3943_platform_data *pdata;
+	const struct lp3943_reg_cfg *mux_cfg;
+};
+
+int lp3943_read_byte(struct lp3943 *lm, u8 reg, u8 *read);
+int lp3943_write_byte(struct lp3943 *lm, u8 reg, u8 data);
+int lp3943_update_bits(struct lp3943 *lm, u8 reg, u8 mask, u8 data);
+#endif
-- 
1.7.9.5


Best Regards,
Milo


