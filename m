Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbaHGIGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:06:30 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:44918 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbaHGIGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:06:20 -0400
From: Gyungoh Yoo <gyungoh@gmail.com>
X-Google-Original-From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
To: rdunlap@infradead.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, jg1.han@samsung.com, cooloney@gmail.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, grant.likely@linaro.org
Cc: sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        broonie@kernel.org, jack.yoo@skyworksinc.com, florian.vaussard@epfl.ch,
        thierry.reding@gmail.com, jason@lakedaemon.net, andrew@lunn.ch,
        silvio.fricke@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: [PATCH] Adding a support for Skyworks SKY81452
Date: Thu,  7 Aug 2014 17:05:38 +0900
Message-Id: <1407398738-7582-1-git-send-email-jack.yoo@skyworksinc.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
---
 Documentation/backlight/sky81452.txt               |  25 ++
 Documentation/devicetree/bindings/mfd/sky81452.txt |  24 ++
 .../bindings/regulator/sky81452-regulator.txt      |  16 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 .../video/backlight/sky81452-backlight.txt         |  20 ++
 drivers/mfd/Kconfig                                |  12 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/sky81452.c                             | 115 +++++++
 drivers/regulator/Kconfig                          |  11 +
 drivers/regulator/Makefile                         |   1 +
 drivers/regulator/sky81452-regulator.c             | 127 ++++++++
 drivers/video/backlight/Kconfig                    |  10 +
 drivers/video/backlight/Makefile                   |   1 +
 drivers/video/backlight/sky81452-backlight.c       | 333 +++++++++++++++++++++
 include/linux/mfd/sky81452.h                       |  31 ++
 include/linux/sky81452-backlight.h                 |  46 +++
 16 files changed, 774 insertions(+)
 create mode 100644 Documentation/backlight/sky81452.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/sky81452.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
 create mode 100644 Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
 create mode 100644 drivers/mfd/sky81452.c
 create mode 100644 drivers/regulator/sky81452-regulator.c
 create mode 100644 drivers/video/backlight/sky81452-backlight.c
 create mode 100644 include/linux/mfd/sky81452.h
 create mode 100644 include/linux/sky81452-backlight.h

diff --git a/Documentation/backlight/sky81452.txt b/Documentation/backlight/sky81452.txt
new file mode 100644
index 0000000..e612151
--- /dev/null
+++ b/Documentation/backlight/sky81452.txt
@@ -0,0 +1,25 @@
+Kernel driver for sky81452
+==========================
+
+* Skyworks Solutions SKY81452 :
+  High-Efficiency, Six-Channel White LED Driver with Touch Panel Bias Supply
+
+Description
+-----------
+The SKY81452 is a highly integrated, high-efficiency LED backlight solution for
+tablets, notebook computers, monitors, and other portable devices.
+
+The SKY81452 supports Direct Pulse Width Modulation(DPWM) dimming and Analog
+Pulse Width Modulation (APWM). In the DPWM dimming mode, the output waveform
+follows the Pulse Width Modulation Input(PWMI) signal and the current level is
+set by I2C control and an external RSET resistor. In the APWM mode, the PWMI
+signal duty and the I2C brightness control signal are multiplied to control
+the output current level.
+
+The driver exports some additional attributes for SKY81452.
+- slew_rate : Fade in/out slew rate control, in msec/dimming step.
+	It should be 0, 2, 4 or 8msec/step. 0 means 32usec slew rate.
+- enable : Current sink channels. Bit0 is for channel 1, Bit1 is for channel 2
+	and Bit2 is for channel 3. For example, if 5 is written to this
+	attribute, channel 1 and channel 3 are enabled.
+- status : Fault status indication.
diff --git a/Documentation/devicetree/bindings/mfd/sky81452.txt b/Documentation/devicetree/bindings/mfd/sky81452.txt
new file mode 100644
index 0000000..18dd6ac
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/sky81452.txt
@@ -0,0 +1,24 @@
+SKY81452 bindings
+
+Required properties:
+- compatible		: Must be "sky,sky81452"
+
+Required child nodes:
+- backlight		: container node for backlight following the binding
+		in video/backlight/sky81452-backlight.txt
+- regulator		: container node for regulators following the binding
+		in regulator/sky81452-regulator.txt
+
+Example:
+
+        sky81452@2C {
+                compatible = "sky,sky81452";
+
+		backlight {
+			...
+		};
+
+		regulator {
+			...
+		};
+        };
diff --git a/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
new file mode 100644
index 0000000..f98b5ed
--- /dev/null
+++ b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
@@ -0,0 +1,16 @@
+SKY81452 voltage regulator
+
+Required properties:
+- any required generic properties defined in regulator.txt
+
+Optional properties:
+- any available generic properties defined in regulator.txt
+
+Example:
+
+	regualtor {
+		/* generic regulator properties */
+		regulator-name = "touch_en";
+		regulator-min-microvolt = <4500000>;
+		regulator-max-microvolt = <8000000>;
+	};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 46a311e..a755c52 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -120,6 +120,7 @@ silabs	Silicon Laboratories
 simtek
 sii	Seiko Instruments, Inc.
 sirf	SiRF Technology, Inc.
+sky	Skyworks Solutions, Inc.
 smsc	Standard Microsystems Corporation
 snps 	Synopsys, Inc.
 spansion	Spansion Inc.
diff --git a/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt b/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
new file mode 100644
index 0000000..9bc38b3
--- /dev/null
+++ b/Documentation/devicetree/bindings/video/backlight/sky81452-backlight.txt
@@ -0,0 +1,20 @@
+SKY81452-backlight bindings
+
+Optional properties:
+- name			: Name of backlight device. Default is 'lcd-backlight'.
+- gpio-enable           : GPIO to use to EN pin.
+- enable		: Enable mask for current sink channel 1 to 6.
+- ignore-pwm		: Ignore both PWM input
+- dpwm-mode		: Enable DPWM dimming mode, otherwise Analog dimming mode
+- phase-shift		: Enable phase shift mode
+- ovp-level		: Over-voltage protection level. Should be between 14 or 28V.
+- short-detection-threshold : It should be one of 4, 5, 6 and 7V.
+- boost-current-limit	: It should be one of 800, 1100 and 1500mA.
+
+Example:
+
+        backlight {
+                name = "pwm-backlight";
+		enable = <0x3F>;
+		ignore-pwm;
+        };
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 6cc4b6a..4f1bcd4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -610,6 +610,18 @@ config MFD_SM501_GPIO
 	 lines on the SM501. The platform data is used to supply the
 	 base number for the first GPIO line to register.
 
+config SKY81452
+	tristate "Skyworks Solutions SKY81452"
+	select MFD_CORE
+	select REGMAP_I2C
+	depends on I2C=y
+	help
+	  This is the core driver for the Skyworks SKY81452 backlight and
+	  voltage regulator device.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called sky81452.
+
 config MFD_SMSC
        bool "SMSC ECE1099 series chips"
        depends on I2C=y
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8afedba..c1221e7 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -169,3 +169,4 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
 obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
 obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
+obj-$(CONFIG_SKY81452)		+= sky81452.o
diff --git a/drivers/mfd/sky81452.c b/drivers/mfd/sky81452.c
new file mode 100644
index 0000000..e09552f
--- /dev/null
+++ b/drivers/mfd/sky81452.c
@@ -0,0 +1,115 @@
+/*
+ * sky81452.c	SKY81452 MFD driver
+ *
+ * Copyright 2014 Skyworks Solutions Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/sky81452.h>
+
+static const struct regmap_config sky81452_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+};
+
+static int sky81452_register_devices(struct device *dev,
+		const struct sky81452_platform_data *pdata)
+{
+	struct mfd_cell cells[] = {
+		{
+			.name = "sky81452-bl",
+			.platform_data = pdata->bl_pdata,
+			.pdata_size = sizeof(*pdata->bl_pdata),
+		},
+		{
+			.name = "sky81452-regulator",
+			.platform_data = pdata->regulator_init_data,
+			.pdata_size = sizeof(*pdata->regulator_init_data),
+		},
+	};
+
+	return mfd_add_devices(dev, -1, cells, ARRAY_SIZE(cells),
+			NULL, 0, NULL);
+}
+
+static int sky81452_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	const struct sky81452_platform_data *pdata;
+	struct device *dev = &client->dev;
+	struct regmap *map;
+
+#ifdef CONFIG_OF
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+#else
+	pdata = dev_get_platdata(dev);
+	if (unlikely(!pdata))
+		return -EINVAL;
+#endif
+
+	map = devm_regmap_init_i2c(client, &sky81452_config);
+	if (IS_ERR(map))
+		return PTR_ERR(map);
+
+	i2c_set_clientdata(client, map);
+
+	return sky81452_register_devices(dev, pdata);
+}
+
+static int sky81452_remove(struct i2c_client *client)
+{
+	mfd_remove_devices(&client->dev);
+	return 0;
+}
+
+static const struct i2c_device_id sky81452_ids[] = {
+	{"sky81452", 0},
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, sky81452_ids);
+
+#ifdef CONFIG_OF
+static const struct of_device_id sky81452_of_match[] = {
+	{.compatible = "sky,sky81452",},
+	{ }
+};
+MODULE_DEVICE_TABLE(of, sky81452_of_match);
+#endif
+
+static struct i2c_driver sky81452_driver = {
+	.driver = {
+		.name = "sky81452",
+		.owner = THIS_MODULE,
+		.of_match_table = of_match_ptr(sky81452_of_match),
+	},
+	.probe = sky81452_probe,
+	.remove = sky81452_remove,
+	.id_table = sky81452_ids,
+};
+
+module_i2c_driver(sky81452_driver);
+
+MODULE_DESCRIPTION("Skyworks SKY81452 MFD driver");
+MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0");
diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 789eb46..15baf13 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -473,6 +473,17 @@ config REGULATOR_S5M8767
 	 via I2C bus. S5M8767A have 9 Bucks and 28 LDOs output and
 	 supports DVS mode with 8bits of output voltage control.
 
+config REGULATOR_SKY81452
+	tristate "Skyworks Solutions SKY81452 voltage regulator"
+	depends on SKY81452
+	help
+	  This driver supports Skyworks SKY81452 voltage output regulator
+	  via I2C bus. SKY81452 has one voltage linear regulator can be
+	  programmed from 4.5V to 20V.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called sky81452-regulator.
+
 config REGULATOR_ST_PWM
 	tristate "STMicroelectronics PWM voltage regulator"
 	depends on ARCH_STI
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index d461110..f6f43b2 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -64,6 +64,7 @@ obj-$(CONFIG_REGULATOR_RC5T583)  += rc5t583-regulator.o
 obj-$(CONFIG_REGULATOR_S2MPA01) += s2mpa01.o
 obj-$(CONFIG_REGULATOR_S2MPS11) += s2mps11.o
 obj-$(CONFIG_REGULATOR_S5M8767) += s5m8767.o
+obj-$(CONFIG_REGULATOR_SKY81452) += sky81452-regulator.o
 obj-$(CONFIG_REGULATOR_ST_PWM) += st-pwm.o
 obj-$(CONFIG_REGULATOR_STW481X_VMMC) += stw481x-vmmc.o
 obj-$(CONFIG_REGULATOR_TI_ABB) += ti-abb-regulator.o
diff --git a/drivers/regulator/sky81452-regulator.c b/drivers/regulator/sky81452-regulator.c
new file mode 100644
index 0000000..15a7c0a
--- /dev/null
+++ b/drivers/regulator/sky81452-regulator.c
@@ -0,0 +1,127 @@
+/*
+ * sky81452-regulator.c	SKY81452 regulator driver
+ *
+ * Copyright 2014 Skyworks Solutions Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
+
+/* registers */
+#define SKY81452_REG1	0x01
+#define SKY81452_REG3	0x03
+
+/* bit mask */
+#define SKY81452_LEN	0x40
+#define SKY81452_LOUT	0x1F
+
+static struct regulator_ops sky81452_reg_ops = {
+	.list_voltage = regulator_list_voltage_linear_range,
+	.map_voltage = regulator_map_voltage_linear_range,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
+};
+
+static const struct regulator_linear_range sky81452_reg_ranges[] = {
+	REGULATOR_LINEAR_RANGE(4500000, 0, 14, 250000),
+	REGULATOR_LINEAR_RANGE(9000000, 15, 31, 1000000),
+};
+
+static const struct regulator_desc sky81452_reg = {
+	.name = "LOUT",
+	.ops = &sky81452_reg_ops,
+	.type = REGULATOR_VOLTAGE,
+	.owner = THIS_MODULE,
+	.n_voltages = SKY81452_LOUT + 1,
+	.linear_ranges = sky81452_reg_ranges,
+	.n_linear_ranges = ARRAY_SIZE(sky81452_reg_ranges),
+	.vsel_reg = SKY81452_REG3,
+	.vsel_mask = SKY81452_LOUT,
+	.enable_reg = SKY81452_REG1,
+	.enable_mask = SKY81452_LEN,
+};
+
+#ifdef CONFIG_OF
+static struct regulator_init_data *sky81452_reg_parse_dt(struct device *dev)
+{
+	struct regulator_init_data *init_data;
+	struct device_node *np;
+
+	np = of_get_child_by_name(dev->parent->of_node, "regulator");
+	if (unlikely(!np)) {
+		dev_err(dev, "regulator node not found");
+		return NULL;
+	}
+
+	init_data = of_get_regulator_init_data(dev, np);
+
+	of_node_put(np);
+	return init_data;
+}
+#endif
+
+static int sky81452_reg_probe(struct platform_device *pdev)
+{
+	const struct regulator_init_data *init_data;
+	struct device *dev = &pdev->dev;
+	struct regulator_config config = { };
+	struct regulator_dev *rdev;
+
+#ifdef CONFIG_OF
+	init_data = sky81452_reg_parse_dt(dev);
+#else
+	init_data = dev_get_platdata(dev);
+#endif
+	if (unlikely(!init_data))
+		return -EINVAL;
+
+	config.dev = dev;
+	config.init_data = init_data;
+	config.of_node = dev->of_node;
+	config.regmap = dev_get_drvdata(dev->parent);
+
+	rdev = devm_regulator_register(dev, &sky81452_reg, &config);
+	if (IS_ERR(rdev))
+		return PTR_ERR(rdev);
+
+	platform_set_drvdata(pdev, rdev);
+
+	return 0;
+}
+
+static struct platform_driver sky81452_reg_driver = {
+	.driver = {
+		.name = "sky81452-regulator",
+		.owner = THIS_MODULE,
+	},
+	.probe = sky81452_reg_probe,
+};
+
+module_platform_driver(sky81452_reg_driver);
+
+MODULE_DESCRIPTION("Skyworks SKY81452 Regulator driver");
+MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0");
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 5d44905..c7418ef 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -411,6 +411,16 @@ config BACKLIGHT_PANDORA
 	  If you have a Pandora console, say Y to enable the
 	  backlight driver.
 
+config BACKLIGHT_SKY81452
+	tristate "Backlight driver for SKY81452"
+	depends on BACKLIGHT_CLASS_DEVICE && SKY81452
+	help
+	  If you have a Skyworks SKY81452, say Y to enable the
+	  backlight driver.
+
+	  To compile this driver as a module, choose M here: the module will
+	  be called sky81452-backlight
+
 config BACKLIGHT_TPS65217
 	tristate "TPS65217 Backlight"
 	depends on BACKLIGHT_CLASS_DEVICE && MFD_TPS65217
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index bb82002..7064d61 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -50,6 +50,7 @@ obj-$(CONFIG_BACKLIGHT_PANDORA)		+= pandora_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
 obj-$(CONFIG_BACKLIGHT_PWM)		+= pwm_bl.o
 obj-$(CONFIG_BACKLIGHT_SAHARA)		+= kb3886_bl.o
+obj-$(CONFIG_BACKLIGHT_SKY81452)	+= sky81452-backlight.o
 obj-$(CONFIG_BACKLIGHT_TOSA)		+= tosa_bl.o
 obj-$(CONFIG_BACKLIGHT_TPS65217)	+= tps65217_bl.o
 obj-$(CONFIG_BACKLIGHT_WM831X)		+= wm831x_bl.o
diff --git a/drivers/video/backlight/sky81452-backlight.c b/drivers/video/backlight/sky81452-backlight.c
new file mode 100644
index 0000000..1eb5706
--- /dev/null
+++ b/drivers/video/backlight/sky81452-backlight.c
@@ -0,0 +1,333 @@
+/*
+ * sky81452-backlight.c	SKY81452 backlight driver
+ *
+ * Copyright 2014 Skyworks Solutions Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/regmap.h>
+#include <linux/backlight.h>
+#include <linux/sky81452-backlight.h>
+
+/* registers */
+#define SKY81452_REG0	0x00
+#define SKY81452_REG1	0x01
+#define SKY81452_REG2	0x02
+#define SKY81452_REG4	0x04
+#define SKY81452_REG5	0x05
+
+/* bit mask */
+#define SKY81452_CS	0xFF
+#define SKY81452_EN	0x3F
+#define SKY81452_IGPW	0x20
+#define SKY81452_PWMMD	0x10
+#define SKY81452_PHASE	0x08
+#define SKY81452_ILIM	0x04
+#define SKY81452_VSHRT	0x03
+#define SKY81452_OCP	0x80
+#define SKY81452_OTMP	0x40
+#define SKY81452_SHRT	0x3F
+#define SKY81452_OPN	0x3F
+
+#define SKY81452_DEFAULT_NAME "lcd-backlight"
+#define SKY81452_MAX_BRIGHTNESS	(SKY81452_CS + 1)
+
+/* count trailing zeros */
+#define CTZ(b) ((b) & 0x0F ? \
+	((b) & 0x03 ? ((b) & 0x01 ? 0 : 1) : ((b) & 0x04 ? 2 : 3)) : \
+	((b) & 0x30 ? ((b) & 0x10 ? 4 : 5) : ((b) & 0x40 ? 6 : 7)))
+
+static int sky81452_bl_update_status(struct backlight_device *bd)
+{
+	const struct sky81452_bl_platform_data *pdata =
+			dev_get_platdata(bd->dev.parent);
+	const int unsigned int brightness = (unsigned int)bd->props.brightness;
+	struct regmap *map = bl_get_data(bd);
+	int ret;
+
+	if (brightness == 0)
+		return regmap_update_bits(map, SKY81452_REG1, SKY81452_EN, 0);
+	else {
+		ret = regmap_write(map, SKY81452_REG0, brightness - 1);
+		if (IS_ERR_VALUE(ret))
+			return ret;
+
+		return regmap_update_bits(map, SKY81452_REG1, SKY81452_EN,
+				pdata->enable << CTZ(SKY81452_EN));
+	}
+}
+
+static int sky81452_bl_get_brightness(struct backlight_device *bd)
+{
+	return bd->props.brightness;
+}
+
+static const struct backlight_ops sky81452_bl_ops = {
+	.update_status = sky81452_bl_update_status,
+	.get_brightness = sky81452_bl_get_brightness,
+};
+
+static ssize_t sky81452_bl_store_enable(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct regmap *map = bl_get_data(to_backlight_device(dev));
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul(buf, 16, &value);
+	if (IS_ERR_VALUE(ret))
+		return ret;
+
+	ret = regmap_update_bits(map, SKY81452_REG1,
+			SKY81452_EN, value << CTZ(SKY81452_EN));
+	if (IS_ERR_VALUE(ret))
+		return ret;
+
+	return count;
+}
+
+static ssize_t sky81452_bl_show_open_short(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct regmap *map = bl_get_data(to_backlight_device(dev));
+	unsigned int reg, value = 0;
+	char tmp[3];
+	int i, ret;
+
+	reg = !strcmp(attr->attr.name, "open") ? SKY81452_REG5 : SKY81452_REG4;
+	ret = regmap_read(map, reg, &value);
+	if (IS_ERR_VALUE(ret))
+		return ret;
+
+	if (value & SKY81452_SHRT) {
+		*buf = 0;
+		for (i = 0; i < 6; i++) {
+			if (value & 0x01) {
+				sprintf(tmp, "%d ", i + 1);
+				strcat(buf, tmp);
+			}
+			value >>= 1;
+		}
+		strcat(buf, "\n");
+	} else
+		strcpy(buf, "none\n");
+
+	return strlen(buf);
+}
+
+static ssize_t sky81452_bl_show_fault(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct regmap *map = bl_get_data(to_backlight_device(dev));
+	unsigned int value = 0;
+	int ret;
+
+	ret = regmap_read(map, SKY81452_REG4, &value);
+	if (IS_ERR_VALUE(ret))
+		return ret;
+
+	*buf = 0;
+
+	if (value & SKY81452_OCP)
+		strcat(buf, "over-current ");
+
+	if (value & SKY81452_OTMP)
+		strcat(buf, "over-temperature");
+
+	strcat(buf, "\n");
+	return strlen(buf);
+}
+
+static DEVICE_ATTR(enable, S_IWGRP | S_IWUSR, NULL, sky81452_bl_store_enable);
+static DEVICE_ATTR(open, S_IRUGO, sky81452_bl_show_open_short, NULL);
+static DEVICE_ATTR(short, S_IRUGO, sky81452_bl_show_open_short, NULL);
+static DEVICE_ATTR(fault, S_IRUGO, sky81452_bl_show_fault, NULL);
+
+static struct attribute *sky81452_bl_attribute[] = {
+	&dev_attr_enable.attr,
+	&dev_attr_open.attr,
+	&dev_attr_short.attr,
+	&dev_attr_fault.attr,
+	NULL
+};
+
+static const struct attribute_group sky81452_bl_attr_group = {
+	.attrs = sky81452_bl_attribute,
+};
+
+#ifdef CONFIG_OF
+static struct sky81452_bl_platform_data *sky81452_bl_parse_dt
+		(struct device *dev)
+{
+	struct device_node *np = dev->parent->of_node;
+	struct sky81452_bl_platform_data *pdata;
+	int ret;
+
+	np = of_get_child_by_name(dev->parent->of_node, "backlight");
+	if (unlikely(!np)) {
+		dev_err(dev, "backlight node not found");
+		return ERR_PTR(-EINVAL);
+	}
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (unlikely(!pdata)) {
+		of_node_put(np);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	of_property_read_string(np, "name", &pdata->name);
+	pdata->ignore_pwm = of_property_read_bool(np, "ignore-pwm");
+	pdata->dpwm_mode = of_property_read_bool(np, "dpwm-mode");
+	pdata->phase_shift = of_property_read_bool(np, "phase-shift");
+
+	pdata->gpio_enable = of_get_named_gpio(np, "gpio-enable", 0);
+	if (IS_ERR_VALUE(pdata->gpio_enable))
+		pdata->gpio_enable = -1;
+
+	ret = of_property_read_u32(np, "enable", &pdata->enable);
+	if (IS_ERR_VALUE(ret))
+		pdata->enable = SKY81452_EN >> CTZ(SKY81452_EN);
+
+	ret = of_property_read_u32(np, "short-detection-threshold",
+			&pdata->short_detection_threshold);
+	if (IS_ERR_VALUE(ret))
+		pdata->short_detection_threshold = 7;
+
+	ret = of_property_read_u32(np, "boost-current-limit",
+			&pdata->boost_current_limit);
+	if (IS_ERR_VALUE(ret))
+		pdata->boost_current_limit = 2750;
+
+	of_node_put(np);
+	return pdata;
+}
+#endif
+
+static int sky81452_bl_init_device(struct regmap *map,
+		struct sky81452_bl_platform_data *pdata)
+{
+	unsigned int value;
+
+	value = pdata->ignore_pwm ? SKY81452_IGPW : 0;
+	value |= pdata->dpwm_mode ? SKY81452_PWMMD : 0;
+	value |= pdata->phase_shift ? 0 : SKY81452_PHASE;
+
+	if (pdata->boost_current_limit == 2300)
+		value |= SKY81452_ILIM;
+	else if (pdata->boost_current_limit != 2720)
+		return -EINVAL;
+
+	if (pdata->short_detection_threshold < 4 ||
+			pdata->short_detection_threshold > 7)
+		return -EINVAL;
+	value |= (7 - pdata->short_detection_threshold) << CTZ(SKY81452_VSHRT);
+
+	return regmap_write(map, SKY81452_REG2, value);
+}
+
+static int sky81452_bl_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct regmap *map = dev_get_drvdata(dev->parent);
+	struct sky81452_bl_platform_data *pdata;
+	struct backlight_device *bd;
+	struct backlight_properties props;
+	const char *name;
+	int ret;
+
+#ifdef CONFIG_OF
+	pdata = sky81452_bl_parse_dt(dev);
+	if (IS_ERR(pdata))
+		return PTR_ERR(pdata);
+	dev->platform_data = pdata;
+#else
+	pdata = dev_get_platdata(dev);
+	if (unlikely(!pdata))
+		return -EINVAL;
+#endif
+
+	if (pdata->gpio_enable >= 0) {
+		ret = devm_gpio_request_one(dev, pdata->gpio_enable,
+				GPIOF_OUT_INIT_HIGH, "sky81452-en");
+		if (IS_ERR_VALUE(ret))
+			return ret;
+	}
+
+	ret = sky81452_bl_init_device(map, pdata);
+	if (IS_ERR_VALUE(ret))
+		return ret;
+
+	memset(&props, 0, sizeof(props));
+	props.max_brightness = SKY81452_MAX_BRIGHTNESS,
+	name = pdata->name ? pdata->name : SKY81452_DEFAULT_NAME;
+	bd = devm_backlight_device_register(dev, name,
+			dev, map, &sky81452_bl_ops, &props);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
+
+	platform_set_drvdata(pdev, bd);
+
+	ret  = sysfs_create_group(&bd->dev.kobj, &sky81452_bl_attr_group);
+	if (IS_ERR_VALUE(ret))
+		goto err;
+
+	return ret;
+err:
+	backlight_device_unregister(bd);
+	return ret;
+}
+
+static int sky81452_bl_remove(struct platform_device *pdev)
+{
+	const struct sky81452_bl_platform_data *pdata =
+			dev_get_platdata(&pdev->dev);
+	struct backlight_device *bd = platform_get_drvdata(pdev);
+
+	sysfs_remove_group(&bd->dev.kobj, &sky81452_bl_attr_group);
+
+	bd->props.power = FB_BLANK_UNBLANK;
+	bd->props.brightness = 0;
+	backlight_update_status(bd);
+
+	if (pdata->gpio_enable >= 0)
+		gpio_set_value_cansleep(pdata->gpio_enable, 0);
+
+	return 0;
+}
+
+static struct platform_driver sky81452_bl_driver = {
+	.driver = {
+		.name = "sky81452-bl",
+		.owner = THIS_MODULE,
+	},
+	.probe = sky81452_bl_probe,
+	.remove = sky81452_bl_remove,
+};
+
+module_platform_driver(sky81452_bl_driver);
+
+MODULE_DESCRIPTION("Skyworks SKY81452 backlight driver");
+MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0");
diff --git a/include/linux/mfd/sky81452.h b/include/linux/mfd/sky81452.h
new file mode 100644
index 0000000..b2dd13e
--- /dev/null
+++ b/include/linux/mfd/sky81452.h
@@ -0,0 +1,31 @@
+/*
+ * sky81452.h	SKY81452 backlight driver
+ *
+ * Copyright 2014 Skyworks Solutions Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _SKY81452_H
+#define _SKY81452_H
+
+#include "linux/sky81452-backlight.h"
+#include "linux/regulator/machine.h"
+
+struct sky81452_platform_data {
+	struct sky81452_bl_platform_data *bl_pdata;
+	struct regulator_init_data *regulator_init_data;
+};
+
+#endif
diff --git a/include/linux/sky81452-backlight.h b/include/linux/sky81452-backlight.h
new file mode 100644
index 0000000..426d0a6
--- /dev/null
+++ b/include/linux/sky81452-backlight.h
@@ -0,0 +1,46 @@
+/*
+ * sky81452.h	SKY81452 backlight driver
+ *
+ * Copyright 2014 Skyworks Solutions Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _SKY81452_BACKLIGHT_H
+#define _SKY81452_BACKLIGHT_H
+
+/**
+ * struct sky81452_platform_data
+ * @name:	backlight driver name.
+		If it is not defined, default name is lcd-backlight.
+ * @gpio_enable:GPIO number which control EN pin
+ * @enable:	Enable mask for current sink channel 1, 2, 3, 4, 5 and 6.
+ * @ignore_pwm:	true if DPWMI should be ignored.
+ * @dpwm_mode:	true is DPWM dimming mode, otherwise Analog dimming mode.
+ * @phase_shift:true is phase shift mode.
+ * @short_detecion_threshold:	It should be one of 4, 5, 6 and 7V.
+ * @boost_current_limit:	It should be one of 2300, 2750mA.
+ */
+struct sky81452_bl_platform_data {
+	const char *name;
+	int gpio_enable;
+	unsigned int enable;
+	bool ignore_pwm;
+	bool dpwm_mode;
+	bool phase_shift;
+	unsigned int short_detection_threshold;
+	unsigned int boost_current_limit;
+};
+
+#endif
-- 
1.9.1

