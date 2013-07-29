Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095Ab3G2RBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:01:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58127 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758024Ab3G2RBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:01:04 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 2/6] mfd: da9063: Add Dialog DA9063 core driver.
Date: Mon, 29 Jul 2013 19:00:43 +0200
Message-Id: <1375117247-6376-3-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
References: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>

This is MFD module providing access to registers and interrupts of DA906x
series PMIC. It is used by other functional modules, registered as MFD cells.
Driver uses regmap with paging to access extended register list. Register map
is divided into two pages, where the second page is used during initialisation.

This module provides support to following functional cells:
 - Regulators
 - RTC
 - HWMON
 - OnKey (power key misc input device)
 - Vibration (force-feedback input device)
 - Watchdog
 - LEDs

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: Mark Brown <broonie@linaro.org>
---
 drivers/mfd/Kconfig              |  12 +++
 drivers/mfd/Makefile             |   3 +
 drivers/mfd/da9063-core.c        | 129 +++++++++++++++++++++++++++
 drivers/mfd/da9063-i2c.c         | 182 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/da9063/core.h  |  55 ++++++++++++
 include/linux/mfd/da9063/pdata.h | 111 ++++++++++++++++++++++++
 6 files changed, 492 insertions(+)
 create mode 100644 drivers/mfd/da9063-core.c
 create mode 100644 drivers/mfd/da9063-i2c.c
 create mode 100644 include/linux/mfd/da9063/core.h
 create mode 100644 include/linux/mfd/da9063/pdata.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index aecd6dd..144c08e 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -139,6 +139,18 @@ config MFD_DA9055
 	  This driver can be built as a module. If built as a module it will be
 	  called "da9055"
 
+config MFD_DA9063
+	bool "Dialog Semiconductor DA9063 PMIC Support"
+	select MFD_CORE
+	select REGMAP_I2C
+	select REGMAP_IRQ
+	depends on I2C=y && GENERIC_HARDIRQS
+	help
+	  Say yes here for support for the Dialog Semiconductor DA9063 PMIC.
+	  This includes the I2C driver and core APIs.
+	  Additional drivers must be enabled in order to use the functionality
+	  of the device.
+
 config MFD_MC13783
 	tristate
 
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 3c90051..0bb84d5 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -107,6 +107,9 @@ obj-$(CONFIG_MFD_LP8788)	+= lp8788.o lp8788-irq.o
 da9055-objs			:= da9055-core.o da9055-i2c.o
 obj-$(CONFIG_MFD_DA9055)	+= da9055.o
 
+da9063-objs			:= da9063-core.o da9063-i2c.o
+obj-$(CONFIG_MFD_DA9063)	+= da9063.o
+
 obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
 obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 obj-$(CONFIG_MFD_MAX8907)	+= max8907.o
diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
new file mode 100644
index 0000000..29f3ed1
--- /dev/null
+++ b/drivers/mfd/da9063-core.c
@@ -0,0 +1,129 @@
+/*
+ * da9063-core.c: Device access for Dialog DA9063 modules
+ *
+ * Copyright 2012 Dialog Semiconductors Ltd.
+ * Copyright 2013 Philipp Zabel, Pengutronix
+ *
+ * Author: Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
+ *         Michal Hajduk <michal.hajduk@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/mutex.h>
+#include <linux/mfd/core.h>
+#include <linux/regmap.h>
+
+#include <linux/mfd/da9063/core.h>
+#include <linux/mfd/da9063/pdata.h>
+#include <linux/mfd/da9063/registers.h>
+
+#include <linux/proc_fs.h>
+#include <linux/kthread.h>
+#include <linux/uaccess.h>
+
+
+static struct mfd_cell da9063_devs[] = {
+	{
+		.name		= DA9063_DRVNAME_REGULATORS,
+	},
+	{
+		.name		= DA9063_DRVNAME_LEDS,
+	},
+	{
+		.name		= DA9063_DRVNAME_WATCHDOG,
+	},
+	{
+		.name		= DA9063_DRVNAME_HWMON,
+	},
+	{
+		.name		= DA9063_DRVNAME_ONKEY,
+	},
+	{
+		.name		= DA9063_DRVNAME_RTC,
+	},
+	{
+		.name		= DA9063_DRVNAME_VIBRATION,
+	},
+};
+
+int da9063_device_init(struct da9063 *da9063, unsigned int irq)
+{
+	struct da9063_pdata *pdata = da9063->dev->platform_data;
+	int model, revision;
+	int ret;
+
+	if (pdata) {
+		da9063->flags = pdata->flags;
+		da9063->irq_base = pdata->irq_base;
+	} else {
+		da9063->flags = 0;
+		da9063->irq_base = 0;
+	}
+	da9063->chip_irq = irq;
+
+	if (pdata && pdata->init != NULL) {
+		ret = pdata->init(da9063);
+		if (ret != 0) {
+			dev_err(da9063->dev,
+				"Platform initialization failed.\n");
+			return ret;
+		}
+	}
+
+	ret = regmap_read(da9063->regmap, DA9063_REG_CHIP_ID, &model);
+	if (ret < 0) {
+		dev_err(da9063->dev, "Cannot read chip model id.\n");
+		return -EIO;
+	}
+	if (model != PMIC_DA9063) {
+		dev_err(da9063->dev, "Invalid chip model id: 0x%02x\n", model);
+		return -ENODEV;
+	}
+
+	ret = regmap_read(da9063->regmap, DA9063_REG_CHIP_VARIANT, &revision);
+	if (ret < 0) {
+		dev_err(da9063->dev, "Cannot read chip revision id.\n");
+		return -EIO;
+	}
+	revision >>= DA9063_CHIP_VARIANT_SHIFT;
+	if (revision != 3) {
+		dev_err(da9063->dev, "Unknown chip revision: %d\n", revision);
+		return -ENODEV;
+	}
+
+	da9063->model = model;
+	da9063->revision = revision;
+
+	dev_info(da9063->dev,
+		 "Device detected (model-ID: 0x%02X  rev-ID: 0x%02X)\n",
+		 model, revision);
+
+	ret = mfd_add_devices(da9063->dev, -1, da9063_devs,
+			      ARRAY_SIZE(da9063_devs), NULL, da9063->irq_base,
+			      NULL);
+	if (ret)
+		dev_err(da9063->dev, "Cannot add MFD cells\n");
+
+	return ret;
+}
+
+void da9063_device_exit(struct da9063 *da9063)
+{
+	mfd_remove_devices(da9063->dev);
+}
+
+MODULE_DESCRIPTION("PMIC driver for Dialog DA9063");
+MODULE_AUTHOR("Krystian Garbaciak <krystian.garbaciak@diasemi.com>, Michal Hajduk <michal.hajduk@diasemi.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/da9063-i2c.c b/drivers/mfd/da9063-i2c.c
new file mode 100644
index 0000000..8db5c80
--- /dev/null
+++ b/drivers/mfd/da9063-i2c.c
@@ -0,0 +1,182 @@
+/* da9063-i2c.c: Interrupt support for Dialog DA9063
+ *
+ * Copyright 2012 Dialog Semiconductor Ltd.
+ * Copyright 2013 Philipp Zabel, Pengutronix
+ *
+ * Author: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+
+#include <linux/mfd/core.h>
+#include <linux/mfd/da9063/core.h>
+#include <linux/mfd/da9063/pdata.h>
+#include <linux/mfd/da9063/registers.h>
+
+static const struct regmap_range da9063_readable_ranges[] = {
+	{
+		.range_min = DA9063_REG_PAGE_CON,
+		.range_max = DA9063_REG_SECOND_D,
+	}, {
+		.range_min = DA9063_REG_SEQ,
+		.range_max = DA9063_REG_ID_32_31,
+	}, {
+		.range_min = DA9063_REG_SEQ_A,
+		.range_max = DA9063_REG_AUTO3_LOW,
+	}, {
+		.range_min = DA9063_REG_T_OFFSET,
+		.range_max = DA9063_REG_GP_ID_19,
+	}, {
+		.range_min = DA9063_REG_CHIP_ID,
+		.range_max = DA9063_REG_CHIP_VARIANT,
+	},
+};
+
+static const struct regmap_range da9063_writeable_ranges[] = {
+	{
+		.range_min = DA9063_REG_PAGE_CON,
+		.range_max = DA9063_REG_PAGE_CON,
+	}, {
+		.range_min = DA9063_REG_FAULT_LOG,
+		.range_max = DA9063_REG_VSYS_MON,
+	}, {
+		.range_min = DA9063_REG_COUNT_S,
+		.range_max = DA9063_REG_ALARM_Y,
+	}, {
+		.range_min = DA9063_REG_SEQ,
+		.range_max = DA9063_REG_ID_32_31,
+	}, {
+		.range_min = DA9063_REG_SEQ_A,
+		.range_max = DA9063_REG_AUTO3_LOW,
+	}, {
+		.range_min = DA9063_REG_CONFIG_I,
+		.range_max = DA9063_REG_MON_REG_4,
+	}, {
+		.range_min = DA9063_REG_GP_ID_0,
+		.range_max = DA9063_REG_GP_ID_19,
+	},
+};
+
+static const struct regmap_range da9063_volatile_ranges[] = {
+	{
+		.range_min = DA9063_REG_STATUS_A,
+		.range_max = DA9063_REG_EVENT_D,
+	}, {
+		.range_min = DA9063_REG_CONTROL_F,
+		.range_max = DA9063_REG_CONTROL_F,
+	}, {
+		.range_min = DA9063_REG_ADC_MAN,
+		.range_max = DA9063_REG_ADC_MAN,
+	}, {
+		.range_min = DA9063_REG_ADC_RES_L,
+		.range_max = DA9063_REG_SECOND_D,
+	}, {
+		.range_min = DA9063_REG_MON_REG_5,
+		.range_max = DA9063_REG_MON_REG_6,
+	},
+};
+
+static const struct regmap_access_table da9063_readable_table = {
+	.yes_ranges = da9063_readable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(da9063_readable_ranges),
+};
+
+static const struct regmap_access_table da9063_writeable_table = {
+	.yes_ranges = da9063_writeable_ranges,
+	.n_yes_ranges = ARRAY_SIZE(da9063_writeable_ranges),
+};
+
+static const struct regmap_access_table da9063_volatile_table = {
+	.yes_ranges = da9063_volatile_ranges,
+	.n_yes_ranges = ARRAY_SIZE(da9063_volatile_ranges),
+};
+
+static const struct regmap_range_cfg da9063_range_cfg[] = {
+	{
+		.range_min = DA9063_REG_PAGE_CON,
+		.range_max = DA9063_REG_CHIP_VARIANT,
+		.selector_reg = DA9063_REG_PAGE_CON,
+		.selector_mask = 1 << DA9063_I2C_PAGE_SEL_SHIFT,
+		.selector_shift = DA9063_I2C_PAGE_SEL_SHIFT,
+		.window_start = 0,
+		.window_len = 256,
+	}
+};
+
+static struct regmap_config da9063_regmap_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.ranges = da9063_range_cfg,
+	.num_ranges = ARRAY_SIZE(da9063_range_cfg),
+	.max_register = DA9063_REG_CHIP_VARIANT,
+
+	.cache_type = REGCACHE_RBTREE,
+
+	.rd_table = &da9063_readable_table,
+	.wr_table = &da9063_writeable_table,
+	.volatile_table = &da9063_volatile_table,
+};
+
+static int da9063_i2c_probe(struct i2c_client *i2c,
+	const struct i2c_device_id *id)
+{
+	struct da9063 *da9063;
+	int ret;
+
+	da9063 = devm_kzalloc(&i2c->dev, sizeof(struct da9063), GFP_KERNEL);
+	if (da9063 == NULL)
+		return -ENOMEM;
+
+	i2c_set_clientdata(i2c, da9063);
+	da9063->dev = &i2c->dev;
+	da9063->chip_irq = i2c->irq;
+
+	da9063->regmap = devm_regmap_init_i2c(i2c, &da9063_regmap_config);
+	if (IS_ERR(da9063->regmap)) {
+		ret = PTR_ERR(da9063->regmap);
+		dev_err(da9063->dev, "Failed to allocate register map: %d\n",
+			ret);
+		return ret;
+	}
+
+	return da9063_device_init(da9063, i2c->irq);
+}
+
+static int da9063_i2c_remove(struct i2c_client *i2c)
+{
+	struct da9063 *da9063 = i2c_get_clientdata(i2c);
+
+	da9063_device_exit(da9063);
+
+	return 0;
+}
+
+static const struct i2c_device_id da9063_i2c_id[] = {
+	{"da9063", PMIC_DA9063},
+	{},
+};
+MODULE_DEVICE_TABLE(i2c, da9063_i2c_id);
+
+static struct i2c_driver da9063_i2c_driver = {
+	.driver = {
+		.name = "da9063",
+		.owner = THIS_MODULE,
+	},
+	.probe    = da9063_i2c_probe,
+	.remove   = da9063_i2c_remove,
+	.id_table = da9063_i2c_id,
+};
+
+module_i2c_driver(da9063_i2c_driver);
diff --git a/include/linux/mfd/da9063/core.h b/include/linux/mfd/da9063/core.h
new file mode 100644
index 0000000..ec2fd2a
--- /dev/null
+++ b/include/linux/mfd/da9063/core.h
@@ -0,0 +1,55 @@
+/*
+ * Definitions for DA9063 MFD driver
+ *
+ * Copyright 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: Michal Hajduk <michal.hajduk@diasemi.com>
+ *	   Krystian Garbaciak <krystian.garbaciak@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_DA9063_CORE_H__
+#define __MFD_DA9063_CORE_H__
+
+#include <linux/interrupt.h>
+#include <linux/mfd/da9063/registers.h>
+
+/* DA9063 modules */
+#define DA9063_DRVNAME_CORE		"da9063-core"
+#define DA9063_DRVNAME_REGULATORS	"da9063-regulators"
+#define DA9063_DRVNAME_LEDS		"da9063-leds"
+#define DA9063_DRVNAME_WATCHDOG		"da9063-watchdog"
+#define DA9063_DRVNAME_HWMON		"da9063-hwmon"
+#define DA9063_DRVNAME_ONKEY		"da9063-onkey"
+#define DA9063_DRVNAME_RTC		"da9063-rtc"
+#define DA9063_DRVNAME_VIBRATION	"da9063-vibration"
+
+enum da9063_models {
+	PMIC_DA9063 = 0x61,
+};
+
+struct da9063 {
+	/* Device */
+	struct device	*dev;
+	unsigned short	model;
+	unsigned short	revision;
+	unsigned int	flags;
+
+	/* Control interface */
+	struct regmap	*regmap;
+
+	/* Interrupts */
+	int		chip_irq;
+	unsigned int	irq_base;
+};
+
+int da9063_device_init(struct da9063 *da9063, unsigned int irq);
+
+void da9063_device_exit(struct da9063 *da9063);
+
+#endif /* __MFD_DA9063_CORE_H__ */
diff --git a/include/linux/mfd/da9063/pdata.h b/include/linux/mfd/da9063/pdata.h
new file mode 100644
index 0000000..95c8742
--- /dev/null
+++ b/include/linux/mfd/da9063/pdata.h
@@ -0,0 +1,111 @@
+/*
+ * Platform configuration options for DA9063
+ *
+ * Copyright 2012 Dialog Semiconductor Ltd.
+ *
+ * Author: Michal Hajduk <michal.hajduk@diasemi.com>
+ * Author: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_DA9063_PDATA_H__
+#define __MFD_DA9063_PDATA_H__
+
+#include <linux/regulator/machine.h>
+
+/*
+ * Regulator configuration
+ */
+/* DA9063 regulator IDs */
+enum {
+	/* BUCKs */
+	DA9063_ID_BCORE1,
+	DA9063_ID_BCORE2,
+	DA9063_ID_BPRO,
+	DA9063_ID_BMEM,
+	DA9063_ID_BIO,
+	DA9063_ID_BPERI,
+
+	/* BCORE1 and BCORE2 in merged mode */
+	DA9063_ID_BCORES_MERGED,
+	/* BMEM and BIO in merged mode */
+	DA9063_ID_BMEM_BIO_MERGED,
+	/* When two BUCKs are merged, they cannot be reused separately */
+
+	/* LDOs */
+	DA9063_ID_LDO1,
+	DA9063_ID_LDO2,
+	DA9063_ID_LDO3,
+	DA9063_ID_LDO4,
+	DA9063_ID_LDO5,
+	DA9063_ID_LDO6,
+	DA9063_ID_LDO7,
+	DA9063_ID_LDO8,
+	DA9063_ID_LDO9,
+	DA9063_ID_LDO10,
+	DA9063_ID_LDO11,
+};
+
+/* Regulators platform data */
+struct da9063_regulator_data {
+	int				id;
+	struct regulator_init_data	*initdata;
+};
+
+struct da9063_regulators_pdata {
+	unsigned			n_regulators;
+	struct da9063_regulator_data	*regulator_data;
+};
+
+
+/*
+ * RGB LED configuration
+ */
+/* LED IDs for flags in struct led_info. */
+enum {
+	DA9063_GPIO11_LED,
+	DA9063_GPIO14_LED,
+	DA9063_GPIO15_LED,
+
+	DA9063_LED_NUM
+};
+#define DA9063_LED_ID_MASK		0x3
+
+/* LED polarity for flags in struct led_info. */
+#define DA9063_LED_HIGH_LEVEL_ACTIVE	0x0
+#define DA9063_LED_LOW_LEVEL_ACTIVE	0x4
+
+
+/*
+ * General PMIC configuration
+ */
+/* HWMON ADC channels configuration */
+#define DA9063_FLG_FORCE_IN0_MANUAL_MODE	0x0010
+#define DA9063_FLG_FORCE_IN0_AUTO_MODE		0x0020
+#define DA9063_FLG_FORCE_IN1_MANUAL_MODE	0x0040
+#define DA9063_FLG_FORCE_IN1_AUTO_MODE		0x0080
+#define DA9063_FLG_FORCE_IN2_MANUAL_MODE	0x0100
+#define DA9063_FLG_FORCE_IN2_AUTO_MODE		0x0200
+#define DA9063_FLG_FORCE_IN3_MANUAL_MODE	0x0400
+#define DA9063_FLG_FORCE_IN3_AUTO_MODE		0x0800
+
+/* Disable register caching. */
+#define DA9063_FLG_NO_CACHE			0x0008
+
+struct da9063;
+
+/* DA9063 platform data */
+struct da9063_pdata {
+	int				(*init)(struct da9063 *da9063);
+	int				irq_base;
+	unsigned			flags;
+	struct da9063_regulators_pdata	*regulators_pdata;
+	struct led_platform_data	*leds_pdata;
+};
+
+#endif	/* __MFD_DA9063_PDATA_H__ */
-- 
1.8.3.2

