Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaEORwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:52:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34516 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755220AbaEORwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:52:06 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org, Carlo Caione <carlo@caione.org>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [RFC PATCH 1/3] mfd: AXP22x: add support for APX221 PMIC
Date: Thu, 15 May 2014 19:51:43 +0200
Message-Id: <1400176305-22737-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces preliminary support for the X-Powers AXP221 PMIC.
The AXP221 is typically used on boards using Allwinner's A31 SoC.

At the moment, this driver only exposes regulator devices, but other
subdevices.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 drivers/mfd/Kconfig        |  12 +++
 drivers/mfd/Makefile       |   1 +
 drivers/mfd/axp22x.c       | 237 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/axp22x.h | 149 ++++++++++++++++++++++++++++
 4 files changed, 399 insertions(+)
 create mode 100644 drivers/mfd/axp22x.c
 create mode 100644 include/linux/mfd/axp22x.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 34d246f..2ee31b41 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -79,6 +79,18 @@ config MFD_AXP20X
 	  components like regulators or the PEK (Power Enable Key) under the
 	  corresponding menus.
 
+config MFD_AXP22X
+	bool "X-Powers AXP22X"
+	select MFD_CORE
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	depends on I2C=y
+	help
+	  If you say Y here you get support for the X-Powers AXP221.
+	  This driver include only the core APIs. You have to select individual
+	  components like regulators or the PEK (Power Enable Key) under the
+	  corresponding menus.
+
 config MFD_CROS_EC
 	tristate "ChromeOS Embedded Controller"
 	select MFD_CORE
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index df7823c..8b7d2e5 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
 obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
 obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
 obj-$(CONFIG_MFD_AXP20X)	+= axp20x.o
+obj-$(CONFIG_MFD_AXP22X)	+= axp22x.o
 
 obj-$(CONFIG_MFD_LP3943)	+= lp3943.o
 obj-$(CONFIG_MFD_LP8788)	+= lp8788.o lp8788-irq.o
diff --git a/drivers/mfd/axp22x.c b/drivers/mfd/axp22x.c
new file mode 100644
index 0000000..c530c9b
--- /dev/null
+++ b/drivers/mfd/axp22x.c
@@ -0,0 +1,237 @@
+/*
+ * axp22x.c - MFD core driver for the X-Powers AXP221
+ *
+ * AXP22x comprises an adaptive USB-Compatible PWM charger, 5 BUCK DC-DC
+ * converters, 14 LDOs, multiple 12-bit ADCs of voltage, current and temperature
+ * as well as 2 configurable GPIOs.
+ *
+ * Author: Boris Brezillon <boris.brezillon@free-electrons.com>
+ *
+ * Derived from drivers/mfd/axp20x.c:
+ *   Author: Carlo Caione <carlo@caione.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/slab.h>
+#include <linux/regulator/consumer.h>
+#include <linux/mfd/axp22x.h>
+#include <linux/mfd/core.h>
+#include <linux/of_device.h>
+#include <linux/of_irq.h>
+
+#define AXP22X_OFF	0x80
+
+static const struct regmap_range axp22x_writeable_ranges[] = {
+	regmap_reg_range(AXP22X_DATACACHE(0), AXP22X_IRQ5_STATE),
+	regmap_reg_range(AXP22X_DCDC_MODE, AXP22X_BATLOW_THRES1),
+};
+
+static const struct regmap_range axp22x_volatile_ranges[] = {
+	regmap_reg_range(AXP22X_IRQ1_EN, AXP22X_IRQ5_STATE),
+};
+
+static const struct regmap_access_table axp22x_writeable_table = {
+	.yes_ranges	= axp22x_writeable_ranges,
+	.n_yes_ranges	= ARRAY_SIZE(axp22x_writeable_ranges),
+};
+
+static const struct regmap_access_table axp22x_volatile_table = {
+	.yes_ranges	= axp22x_volatile_ranges,
+	.n_yes_ranges	= ARRAY_SIZE(axp22x_volatile_ranges),
+};
+
+static const struct regmap_config axp22x_regmap_config = {
+	.reg_bits	= 8,
+	.val_bits	= 8,
+	.wr_table	= &axp22x_writeable_table,
+	.volatile_table	= &axp22x_volatile_table,
+	.max_register	= AXP22X_BATLOW_THRES1,
+	.cache_type	= REGCACHE_RBTREE,
+};
+
+#define AXP22X_IRQ(_irq, _off, _mask) \
+	[AXP22X_IRQ_##_irq] = { .reg_offset = (_off), .mask = BIT(_mask) }
+
+static const struct regmap_irq axp22x_regmap_irqs[] = {
+	AXP22X_IRQ(ACIN_OVER_V,		0, 7),
+	AXP22X_IRQ(ACIN_PLUGIN,		0, 6),
+	AXP22X_IRQ(ACIN_REMOVAL,	0, 5),
+	AXP22X_IRQ(VBUS_OVER_V,		0, 4),
+	AXP22X_IRQ(VBUS_PLUGIN,		0, 3),
+	AXP22X_IRQ(VBUS_REMOVAL,	0, 2),
+	AXP22X_IRQ(VBUS_V_LOW,		0, 1),
+	AXP22X_IRQ(BATT_PLUGIN,		1, 7),
+	AXP22X_IRQ(BATT_REMOVAL,	1, 6),
+	AXP22X_IRQ(BATT_ENT_ACT_MODE,	1, 5),
+	AXP22X_IRQ(BATT_EXIT_ACT_MODE,	1, 4),
+	AXP22X_IRQ(CHARG,		1, 3),
+	AXP22X_IRQ(CHARG_DONE,		1, 2),
+	AXP22X_IRQ(BATT_TEMP_HIGH,	1, 1),
+	AXP22X_IRQ(BATT_TEMP_LOW,	1, 0),
+	AXP22X_IRQ(DIE_TEMP_HIGH,	2, 7),
+	AXP22X_IRQ(CHARG_I_LOW,		2, 6),
+	AXP22X_IRQ(PEK_SHORT,		2, 1),
+	AXP22X_IRQ(PEK_LONG,		2, 0),
+	AXP22X_IRQ(LOW_PWR_LVL1,	3, 1),
+	AXP22X_IRQ(LOW_PWR_LVL2,	3, 0),
+	AXP22X_IRQ(TIMER,		4, 7),
+	AXP22X_IRQ(PEK_RIS_EDGE,	4, 6),
+	AXP22X_IRQ(PEK_FAL_EDGE,	4, 5),
+	AXP22X_IRQ(GPIO1_INPUT,		4, 1),
+	AXP22X_IRQ(GPIO0_INPUT,		4, 0),
+};
+
+static const struct of_device_id axp22x_of_match[] = {
+	{ .compatible = "x-powers,axp221", .data = (void *) AXP221_ID },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, axp22x_of_match);
+
+/*
+ * This is useless for OF-enabled devices, but it is needed by I2C subsystem
+ */
+static const struct i2c_device_id axp22x_i2c_id[] = {
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, axp22x_i2c_id);
+
+static const struct regmap_irq_chip axp22x_regmap_irq_chip = {
+	.name			= "axp22x_irq_chip",
+	.status_base		= AXP22X_IRQ1_STATE,
+	.ack_base		= AXP22X_IRQ1_STATE,
+	.mask_base		= AXP22X_IRQ1_EN,
+	.num_regs		= 5,
+	.irqs			= axp22x_regmap_irqs,
+	.num_irqs		= ARRAY_SIZE(axp22x_regmap_irqs),
+	.mask_invert		= true,
+	.init_ack_masked	= true,
+};
+
+static const char * const axp22x_supplies[] = {
+	"vbus",
+	"acin",
+	"vin1",
+	"vin2",
+	"vin3",
+	"vin4",
+	"vin5",
+	"aldoin",
+	"dldoin",
+	"eldoin",
+	"ldoioin",
+	"rtcldoin",
+};
+
+static struct mfd_cell axp22x_cells[] = {
+	{
+		.name			= "axp22x-regulator",
+		.parent_supplies	= axp22x_supplies,
+		.num_parent_supplies	= ARRAY_SIZE(axp22x_supplies),
+	},
+};
+
+static struct axp22x_dev *axp22x_pm_power_off;
+static void axp22x_power_off(void)
+{
+	regmap_write(axp22x_pm_power_off->regmap, AXP22X_OFF_CTRL,
+		     AXP22X_OFF);
+}
+
+static int axp22x_i2c_probe(struct i2c_client *i2c,
+			    const struct i2c_device_id *id)
+{
+	struct axp22x_dev *axp22x;
+	const struct of_device_id *of_id;
+	int ret;
+
+	axp22x = devm_kzalloc(&i2c->dev, sizeof(*axp22x), GFP_KERNEL);
+	if (!axp22x)
+		return -ENOMEM;
+
+	of_id = of_match_device(axp22x_of_match, &i2c->dev);
+	if (!of_id) {
+		dev_err(&i2c->dev, "Unable to setup AXP22X data\n");
+		return -ENODEV;
+	}
+	axp22x->variant = (long) of_id->data;
+
+	axp22x->i2c_client = i2c;
+	axp22x->dev = &i2c->dev;
+	dev_set_drvdata(axp22x->dev, axp22x);
+
+	axp22x->regmap = devm_regmap_init_i2c(i2c, &axp22x_regmap_config);
+	if (IS_ERR(axp22x->regmap)) {
+		ret = PTR_ERR(axp22x->regmap);
+		dev_err(&i2c->dev, "regmap init failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = regmap_add_irq_chip(axp22x->regmap, i2c->irq,
+				  IRQF_ONESHOT | IRQF_SHARED, -1,
+				  &axp22x_regmap_irq_chip,
+				  &axp22x->regmap_irqc);
+	if (ret) {
+		dev_err(&i2c->dev, "failed to add irq chip: %d\n", ret);
+		return ret;
+	}
+
+	ret = mfd_add_devices(axp22x->dev, -1, axp22x_cells,
+			      ARRAY_SIZE(axp22x_cells), NULL, 0, NULL);
+
+	if (ret) {
+		dev_err(&i2c->dev, "failed to add MFD devices: %d\n", ret);
+		regmap_del_irq_chip(i2c->irq, axp22x->regmap_irqc);
+		return ret;
+	}
+
+	if (!pm_power_off) {
+		axp22x_pm_power_off = axp22x;
+		pm_power_off = axp22x_power_off;
+	}
+
+	dev_info(&i2c->dev, "AXP22X driver loaded\n");
+
+	return 0;
+}
+
+static int axp22x_i2c_remove(struct i2c_client *i2c)
+{
+	struct axp22x_dev *axp22x = i2c_get_clientdata(i2c);
+
+	if (axp22x == axp22x_pm_power_off) {
+		axp22x_pm_power_off = NULL;
+		pm_power_off = NULL;
+	}
+
+	mfd_remove_devices(axp22x->dev);
+	regmap_del_irq_chip(axp22x->i2c_client->irq, axp22x->regmap_irqc);
+
+	return 0;
+}
+
+static struct i2c_driver axp22x_i2c_driver = {
+	.driver = {
+		.name	= "axp22x",
+		.owner	= THIS_MODULE,
+		.of_match_table	= of_match_ptr(axp22x_of_match),
+	},
+	.probe		= axp22x_i2c_probe,
+	.remove		= axp22x_i2c_remove,
+	.id_table	= axp22x_i2c_id,
+};
+
+module_i2c_driver(axp22x_i2c_driver);
+
+MODULE_DESCRIPTION("PMIC MFD core driver for AXP22X");
+MODULE_AUTHOR("Boris Brezillon <boris.brezillon@free-electrons.com>");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/axp22x.h b/include/linux/mfd/axp22x.h
new file mode 100644
index 0000000..c75fc35
--- /dev/null
+++ b/include/linux/mfd/axp22x.h
@@ -0,0 +1,149 @@
+/*
+ * Functions and registers to access AXP20X power management chip.
+ *
+ * Copyright (C) 2013, Carlo Caione <carlo@caione.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __LINUX_MFD_AXP22X_H
+#define __LINUX_MFD_AXP22X_H
+
+enum {
+	AXP221_ID,
+};
+
+#define AXP22X_DATACACHE(m)		(0x04 + (m))
+
+/* Power supply */
+#define AXP22X_PWR_INPUT_STATUS         0x00
+#define AXP22X_PWR_OP
+#define AXP22X_PWR_OUT_CTRL1		0x10
+#define AXP22X_PWR_OUT_CTRL2		0x12
+#define AXP22X_PWR_OUT_CTRL3		0x13
+#define AXP22X_DLDO1_V_OUT		0x15
+#define AXP22X_DLDO2_V_OUT		0x16
+#define AXP22X_DLDO3_V_OUT		0x17
+#define AXP22X_DLDO4_V_OUT		0x18
+#define AXP22X_ELDO1_V_OUT		0x19
+#define AXP22X_ELDO2_V_OUT		0x1a
+#define AXP22X_ELDO3_V_OUT		0x1b
+#define AXP22X_DC5LDO_V_OUT		0x1c
+#define AXP22X_DCDC1_V_OUT		0x21
+#define AXP22X_DCDC2_V_OUT		0x22
+#define AXP22X_DCDC3_V_OUT		0x23
+#define AXP22X_DCDC4_V_OUT		0x24
+#define AXP22X_DCDC5_V_OUT		0x25
+#define AXP22X_DCDC23_V_RAMP_CTRL	0x27
+#define AXP22X_ALDO1_V_OUT		0x28
+#define AXP22X_ALDO2_V_OUT		0x29
+#define AXP22X_ALDO3_V_OUT		0x2a
+#define AXP22X_WAKE_UP_V_OFF		0x31
+#define AXP22X_OFF_CTRL			0x32
+#define AXP22X_CHRG_CTRL1		0x33
+#define AXP22X_CHRG_CTRL2		0x34
+#define AXP22X_CHRG_CTRL3		0x35
+#define AXP22X_PEK_KEY			0x36
+#define AXP22X_DCDC_FREQ		0x37
+#define AXP22X_V_LTF_CHRG		0x38
+#define AXP22X_V_HTF_CHRG		0x39
+#define AXP22X_V_LTF_DISCHRG		0x3c
+#define AXP22X_V_HTF_DISCHRG		0x3d
+
+/* Interrupt */
+#define AXP22X_IRQ1_EN			0x40
+#define AXP22X_IRQ2_EN			0x41
+#define AXP22X_IRQ3_EN			0x42
+#define AXP22X_IRQ4_EN			0x43
+#define AXP22X_IRQ5_EN			0x44
+#define AXP22X_IRQ1_STATE		0x48
+#define AXP22X_IRQ2_STATE		0x49
+#define AXP22X_IRQ3_STATE		0x4a
+#define AXP22X_IRQ4_STATE		0x4b
+#define AXP22X_IRQ5_STATE		0x4c
+
+/* Power supply */
+#define AXP22X_DCDC_MODE		0x80
+#define AXP22X_ADC_EN1			0x82
+#define AXP22X_ADC_RATE			0x84
+#define AXP22X_TIMER_CTRL		0x8a
+#define AXP22X_PWREN_CTRL1		0x8c
+#define AXP22X_PWREN_CTRL2		0x8d
+#define AXP22X_OVER_TMP			0x8f
+
+/* GPIO */
+#define AXP22X_GPIO0_CTRL		0x90
+#define AXP22X_LDO_IO0_V_OUT		0x91
+#define AXP22X_GPIO1_CTRL		0x90
+#define AXP22X_LDO_IO1_V_OUT		0x93
+#define AXP22X_GPIO_STATE		0x94
+#define AXP22X_GPIO_PULL_DOWN		0x94
+
+/* Battery */
+#define AXP22X_BATLOW_THRES1		0xe6
+
+/* Regulators IDs */
+enum {
+	AXP22X_DCDC1 = 0,
+	AXP22X_DCDC2,
+	AXP22X_DCDC3,
+	AXP22X_DCDC4,
+	AXP22X_DCDC5,
+	AXP22X_DC5LDO,
+	AXP22X_ALDO1,
+	AXP22X_ALDO2,
+	AXP22X_ALDO3,
+	AXP22X_ELDO1,
+	AXP22X_ELDO2,
+	AXP22X_ELDO3,
+	AXP22X_DLDO1,
+	AXP22X_DLDO2,
+	AXP22X_DLDO3,
+	AXP22X_DLDO4,
+	AXP22X_RTC_LDO,
+	AXP22X_LDO_IO0,
+	AXP22X_LDO_IO1,
+	AXP22X_REG_ID_MAX,
+};
+
+/* IRQs */
+enum {
+	AXP22X_IRQ_ACIN_OVER_V = 1,
+	AXP22X_IRQ_ACIN_PLUGIN,
+	AXP22X_IRQ_ACIN_REMOVAL,
+	AXP22X_IRQ_VBUS_OVER_V,
+	AXP22X_IRQ_VBUS_PLUGIN,
+	AXP22X_IRQ_VBUS_REMOVAL,
+	AXP22X_IRQ_VBUS_V_LOW,
+	AXP22X_IRQ_BATT_PLUGIN,
+	AXP22X_IRQ_BATT_REMOVAL,
+	AXP22X_IRQ_BATT_ENT_ACT_MODE,
+	AXP22X_IRQ_BATT_EXIT_ACT_MODE,
+	AXP22X_IRQ_CHARG,
+	AXP22X_IRQ_CHARG_DONE,
+	AXP22X_IRQ_BATT_TEMP_HIGH,
+	AXP22X_IRQ_BATT_TEMP_LOW,
+	AXP22X_IRQ_DIE_TEMP_HIGH,
+	AXP22X_IRQ_CHARG_I_LOW,
+	AXP22X_IRQ_PEK_SHORT,
+	AXP22X_IRQ_PEK_LONG,
+	AXP22X_IRQ_LOW_PWR_LVL1,
+	AXP22X_IRQ_LOW_PWR_LVL2,
+	AXP22X_IRQ_TIMER,
+	AXP22X_IRQ_PEK_RIS_EDGE,
+	AXP22X_IRQ_PEK_FAL_EDGE,
+	AXP22X_IRQ_GPIO1_INPUT,
+	AXP22X_IRQ_GPIO0_INPUT,
+};
+
+struct axp22x_dev {
+	struct device			*dev;
+	struct i2c_client		*i2c_client;
+	struct regmap			*regmap;
+	struct regmap_irq_chip_data	*regmap_irqc;
+	long				variant;
+};
+
+#endif /* __LINUX_MFD_AXP22X_H */
-- 
1.8.3.2

