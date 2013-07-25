Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874Ab3GYRjr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:39:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41089 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3GYRjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:39:43 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 1/2] mfd: Add Dialog DA9063 core driver.
Date: Thu, 25 Jul 2013 19:39:02 +0200
Message-Id: <1374773943-7454-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374773943-7454-1-git-send-email-p.zabel@pengutronix.de>
References: <1374773943-7454-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.104
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
---
 drivers/mfd/Kconfig                  |   12 +
 drivers/mfd/Makefile                 |    3 +
 drivers/mfd/da9063-core.c            |  185 ++++++
 drivers/mfd/da9063-i2c.c             |  182 ++++++
 drivers/mfd/da9063-irq.c             |  193 +++++++
 include/linux/mfd/da9063/core.h      |   93 +++
 include/linux/mfd/da9063/pdata.h     |  114 ++++
 include/linux/mfd/da9063/registers.h | 1028 ++++++++++++++++++++++++++++++++++
 8 files changed, 1810 insertions(+)
 create mode 100644 drivers/mfd/da9063-core.c
 create mode 100644 drivers/mfd/da9063-i2c.c
 create mode 100644 drivers/mfd/da9063-irq.c
 create mode 100644 include/linux/mfd/da9063/core.h
 create mode 100644 include/linux/mfd/da9063/pdata.h
 create mode 100644 include/linux/mfd/da9063/registers.h

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
index 3c90051..15b905c 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -107,6 +107,9 @@ obj-$(CONFIG_MFD_LP8788)	+= lp8788.o lp8788-irq.o
 da9055-objs			:= da9055-core.o da9055-i2c.o
 obj-$(CONFIG_MFD_DA9055)	+= da9055.o
 
+da9063-objs			:= da9063-core.o da9063-irq.o da9063-i2c.o
+obj-$(CONFIG_MFD_DA9063)	+= da9063.o
+
 obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
 obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
 obj-$(CONFIG_MFD_MAX8907)	+= max8907.o
diff --git a/drivers/mfd/da9063-core.c b/drivers/mfd/da9063-core.c
new file mode 100644
index 0000000..c9cf8d9
--- /dev/null
+++ b/drivers/mfd/da9063-core.c
@@ -0,0 +1,185 @@
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
+static struct resource da9063_regulators_resources[] = {
+	{
+		.name	= "LDO_LIM",
+		.start	= DA9063_IRQ_LDO_LIM,
+		.end	= DA9063_IRQ_LDO_LIM,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource da9063_rtc_resources[] = {
+	{
+		.name	= "ALARM",
+		.start	= DA9063_IRQ_ALARM,
+		.end	= DA9063_IRQ_ALARM,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "TICK",
+		.start	= DA9063_IRQ_TICK,
+		.end	= DA9063_IRQ_TICK,
+		.flags	= IORESOURCE_IRQ,
+	}
+};
+
+static struct resource da9063_onkey_resources[] = {
+	{
+		.start	= DA9063_IRQ_ONKEY,
+		.end	= DA9063_IRQ_ONKEY,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource da9063_hwmon_resources[] = {
+	{
+		.start	= DA9063_IRQ_ADC_RDY,
+		.end	= DA9063_IRQ_ADC_RDY,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+
+static struct mfd_cell da9063_devs[] = {
+	{
+		.name		= DA9063_DRVNAME_REGULATORS,
+		.num_resources	= ARRAY_SIZE(da9063_regulators_resources),
+		.resources	= da9063_regulators_resources,
+	},
+	{
+		.name		= DA9063_DRVNAME_LEDS,
+	},
+	{
+		.name		= DA9063_DRVNAME_WATCHDOG,
+	},
+	{
+		.name		= DA9063_DRVNAME_HWMON,
+		.num_resources	= ARRAY_SIZE(da9063_hwmon_resources),
+		.resources	= da9063_hwmon_resources,
+	},
+	{
+		.name		= DA9063_DRVNAME_ONKEY,
+		.num_resources	= ARRAY_SIZE(da9063_onkey_resources),
+		.resources	= da9063_onkey_resources,
+	},
+	{
+		.name		= DA9063_DRVNAME_RTC,
+		.num_resources	= ARRAY_SIZE(da9063_rtc_resources),
+		.resources	= da9063_rtc_resources,
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
+	ret = da9063_irq_init(da9063);
+	if (ret) {
+		dev_err(da9063->dev, "Cannot initialize interrupts.\n");
+		return ret;
+	}
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
+	da9063_irq_exit(da9063);
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
diff --git a/drivers/mfd/da9063-irq.c b/drivers/mfd/da9063-irq.c
new file mode 100644
index 0000000..8229226
--- /dev/null
+++ b/drivers/mfd/da9063-irq.c
@@ -0,0 +1,193 @@
+/* da9063-irq.c: Interrupts support for Dialog DA9063
+ *
+ * Copyright 2012 Dialog Semiconductor Ltd.
+ * Copyright 2013 Philipp Zabel, Pengutronix
+ *
+ * Author: Michal Hajduk <michal.hajduk@diasemi.com>
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
+#include <linux/irq.h>
+#include <linux/mfd/core.h>
+#include <linux/interrupt.h>
+#include <linux/regmap.h>
+#include <linux/mfd/da9063/core.h>
+#include <linux/mfd/da9063/pdata.h>
+
+#define	DA9063_REG_EVENT_A_OFFSET	0
+#define	DA9063_REG_EVENT_B_OFFSET	1
+#define	DA9063_REG_EVENT_C_OFFSET	2
+#define	DA9063_REG_EVENT_D_OFFSET	3
+#define EVENTS_BUF_LEN			4
+
+static const u8 mask_events_buf[] = { [0 ... (EVENTS_BUF_LEN - 1)] = ~0 };
+
+struct da9063_irq_data {
+	u16 reg;
+	u8 mask;
+};
+
+static struct regmap_irq da9063_irqs[] = {
+	/* DA9063 event A register */
+	[DA9063_IRQ_ONKEY] = {
+		.reg_offset = DA9063_REG_EVENT_A_OFFSET,
+		.mask = DA9063_M_ONKEY,
+	},
+	[DA9063_IRQ_ALARM] = {
+		.reg_offset = DA9063_REG_EVENT_A_OFFSET,
+		.mask = DA9063_M_ALARM,
+	},
+	[DA9063_IRQ_TICK] = {
+		.reg_offset = DA9063_REG_EVENT_A_OFFSET,
+		.mask = DA9063_M_TICK,
+	},
+	[DA9063_IRQ_ADC_RDY] = {
+		.reg_offset = DA9063_REG_EVENT_A_OFFSET,
+		.mask = DA9063_M_ADC_RDY,
+	},
+	[DA9063_IRQ_SEQ_RDY] = {
+		.reg_offset = DA9063_REG_EVENT_A_OFFSET,
+		.mask = DA9063_M_SEQ_RDY,
+	},
+	/* DA9063 event B register */
+	[DA9063_IRQ_WAKE] = {
+		.reg_offset = DA9063_REG_EVENT_B_OFFSET,
+		.mask = DA9063_M_WAKE,
+	},
+	[DA9063_IRQ_TEMP] = {
+		.reg_offset = DA9063_REG_EVENT_B_OFFSET,
+		.mask = DA9063_M_TEMP,
+	},
+	[DA9063_IRQ_COMP_1V2] = {
+		.reg_offset = DA9063_REG_EVENT_B_OFFSET,
+		.mask = DA9063_M_COMP_1V2,
+	},
+	[DA9063_IRQ_LDO_LIM] = {
+		.reg_offset = DA9063_REG_EVENT_B_OFFSET,
+		.mask = DA9063_M_LDO_LIM,
+	},
+	[DA9063_IRQ_REG_UVOV] = {
+		.reg_offset = DA9063_REG_EVENT_B_OFFSET,
+		.mask = DA9063_M_UVOV,
+	},
+	[DA9063_IRQ_VDD_MON] = {
+		.reg_offset = DA9063_REG_EVENT_B_OFFSET,
+		.mask = DA9063_M_VDD_MON,
+	},
+	[DA9063_IRQ_WARN] = {
+		.reg_offset = DA9063_REG_EVENT_B_OFFSET,
+		.mask = DA9063_M_VDD_WARN,
+	},
+	/* DA9063 event C register */
+	[DA9063_IRQ_GPI0] = {
+		.reg_offset = DA9063_REG_EVENT_C_OFFSET,
+		.mask = DA9063_M_GPI0,
+	},
+	[DA9063_IRQ_GPI1] = {
+		.reg_offset = DA9063_REG_EVENT_C_OFFSET,
+		.mask = DA9063_M_GPI1,
+	},
+	[DA9063_IRQ_GPI2] = {
+		.reg_offset = DA9063_REG_EVENT_C_OFFSET,
+		.mask = DA9063_M_GPI2,
+	},
+	[DA9063_IRQ_GPI3] = {
+		.reg_offset = DA9063_REG_EVENT_C_OFFSET,
+		.mask = DA9063_M_GPI3,
+	},
+	[DA9063_IRQ_GPI4] = {
+		.reg_offset = DA9063_REG_EVENT_C_OFFSET,
+		.mask = DA9063_M_GPI4,
+	},
+	[DA9063_IRQ_GPI5] = {
+		.reg_offset = DA9063_REG_EVENT_C_OFFSET,
+		.mask = DA9063_M_GPI5,
+	},
+	[DA9063_IRQ_GPI6] = {
+		.reg_offset = DA9063_REG_EVENT_C_OFFSET,
+		.mask = DA9063_M_GPI6,
+	},
+	[DA9063_IRQ_GPI7] = {
+		.reg_offset = DA9063_REG_EVENT_C_OFFSET,
+		.mask = DA9063_M_GPI7,
+	},
+	/* DA9063 event D register */
+	[DA9063_IRQ_GPI8] = {
+		.reg_offset = DA9063_REG_EVENT_D_OFFSET,
+		.mask = DA9063_M_GPI8,
+	},
+	[DA9063_IRQ_GPI9] = {
+		.reg_offset = DA9063_REG_EVENT_D_OFFSET,
+		.mask = DA9063_M_GPI9,
+	},
+	[DA9063_IRQ_GPI10] = {
+		.reg_offset = DA9063_REG_EVENT_D_OFFSET,
+		.mask = DA9063_M_GPI10,
+	},
+	[DA9063_IRQ_GPI11] = {
+		.reg_offset = DA9063_REG_EVENT_D_OFFSET,
+		.mask = DA9063_M_GPI11,
+	},
+	[DA9063_IRQ_GPI12] = {
+		.reg_offset = DA9063_REG_EVENT_D_OFFSET,
+		.mask = DA9063_M_GPI12,
+	},
+	[DA9063_IRQ_GPI13] = {
+		.reg_offset = DA9063_REG_EVENT_D_OFFSET,
+		.mask = DA9063_M_GPI13,
+	},
+	[DA9063_IRQ_GPI14] = {
+		.reg_offset = DA9063_REG_EVENT_D_OFFSET,
+		.mask = DA9063_M_GPI14,
+	},
+	[DA9063_IRQ_GPI15] = {
+		.reg_offset = DA9063_REG_EVENT_D_OFFSET,
+		.mask = DA9063_M_GPI15,
+	},
+};
+
+static struct regmap_irq_chip da9063_irq_chip = {
+	.name = "da9063-irq",
+	.irqs = da9063_irqs,
+	.num_irqs = DA9063_NUM_IRQ,
+
+	.num_regs = 4,
+	.status_base = DA9063_REG_EVENT_A,
+	.mask_base = DA9063_REG_IRQ_MASK_A,
+	.ack_base = DA9063_REG_EVENT_A,
+	.init_ack_masked = true,
+};
+
+int da9063_irq_init(struct da9063 *da9063)
+{
+	int ret;
+
+	if (!da9063->chip_irq) {
+		dev_err(da9063->dev, "No IRQ configured\n");
+		return -EINVAL;
+	}
+
+	ret = regmap_add_irq_chip(da9063->regmap, da9063->chip_irq,
+			IRQF_TRIGGER_LOW | IRQF_ONESHOT | IRQF_SHARED,
+			da9063->irq_base, &da9063_irq_chip,
+			&da9063->regmap_irq);
+	if (ret) {
+		dev_err(da9063->dev, "Failed to reguest IRQ %d: %d\n",
+				da9063->chip_irq, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+void da9063_irq_exit(struct da9063 *da9063)
+{
+	regmap_del_irq_chip(da9063->chip_irq, da9063->regmap_irq);
+}
diff --git a/include/linux/mfd/da9063/core.h b/include/linux/mfd/da9063/core.h
new file mode 100644
index 0000000..2d2a0af
--- /dev/null
+++ b/include/linux/mfd/da9063/core.h
@@ -0,0 +1,93 @@
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
+/* Interrupts */
+enum da9063_irqs {
+	DA9063_IRQ_ONKEY = 0,
+	DA9063_IRQ_ALARM,
+	DA9063_IRQ_TICK,
+	DA9063_IRQ_ADC_RDY,
+	DA9063_IRQ_SEQ_RDY,
+	DA9063_IRQ_WAKE,
+	DA9063_IRQ_TEMP,
+	DA9063_IRQ_COMP_1V2,
+	DA9063_IRQ_LDO_LIM,
+	DA9063_IRQ_REG_UVOV,
+	DA9063_IRQ_VDD_MON,
+	DA9063_IRQ_WARN,
+	DA9063_IRQ_GPI0,
+	DA9063_IRQ_GPI1,
+	DA9063_IRQ_GPI2,
+	DA9063_IRQ_GPI3,
+	DA9063_IRQ_GPI4,
+	DA9063_IRQ_GPI5,
+	DA9063_IRQ_GPI6,
+	DA9063_IRQ_GPI7,
+	DA9063_IRQ_GPI8,
+	DA9063_IRQ_GPI9,
+	DA9063_IRQ_GPI10,
+	DA9063_IRQ_GPI11,
+	DA9063_IRQ_GPI12,
+	DA9063_IRQ_GPI13,
+	DA9063_IRQ_GPI14,
+	DA9063_IRQ_GPI15,
+};
+
+#define DA9063_IRQ_BASE_OFFSET	0
+#define DA9063_NUM_IRQ		(DA9063_IRQ_GPI15 + 1 - DA9063_IRQ_BASE_OFFSET)
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
+	struct regmap_irq_chip_data *regmap_irq;
+};
+
+int da9063_device_init(struct da9063 *da9063, unsigned int irq);
+int da9063_irq_init(struct da9063 *da9063);
+
+void da9063_device_exit(struct da9063 *da9063);
+void da9063_irq_exit(struct da9063 *da9063);
+
+#endif /* __MFD_DA9063_CORE_H__ */
diff --git a/include/linux/mfd/da9063/pdata.h b/include/linux/mfd/da9063/pdata.h
new file mode 100644
index 0000000..4646610
--- /dev/null
+++ b/include/linux/mfd/da9063/pdata.h
@@ -0,0 +1,114 @@
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
+
+	/* RTC internal oscilator switch */
+	DA9063_ID_32K_OUT,
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
diff --git a/include/linux/mfd/da9063/registers.h b/include/linux/mfd/da9063/registers.h
new file mode 100644
index 0000000..5834813
--- /dev/null
+++ b/include/linux/mfd/da9063/registers.h
@@ -0,0 +1,1028 @@
+/*
+ * Registers definition for DA9063 modules
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
+#ifndef _DA9063_REG_H
+#define	_DA9063_REG_H
+
+#define DA9063_I2C_PAGE_SEL_SHIFT	1
+
+#define	DA9063_EVENT_REG_NUM		4
+#define	DA9210_EVENT_REG_NUM		2
+#define	DA9063_EXT_EVENT_REG_NUM	(DA9063_EVENT_REG_NUM + \
+						DA9210_EVENT_REG_NUM)
+
+/* Page selection I2C or SPI always in the begining of any page. */
+/* Page 0 : I2C access 0x000 - 0x0FF	SPI access 0x000 - 0x07F */
+/* Page 1 :				SPI access 0x080 - 0x0FF */
+/* Page 2 : I2C access 0x100 - 0x1FF	SPI access 0x100 - 0x17F */
+/* Page 3 :				SPI access 0x180 - 0x1FF */
+#define	DA9063_REG_PAGE_CON		0x00
+
+/* System Control and Event Registers */
+#define	DA9063_REG_STATUS_A		0x01
+#define	DA9063_REG_STATUS_B		0x02
+#define	DA9063_REG_STATUS_C		0x03
+#define	DA9063_REG_STATUS_D		0x04
+#define	DA9063_REG_FAULT_LOG		0x05
+#define	DA9063_REG_EVENT_A		0x06
+#define	DA9063_REG_EVENT_B		0x07
+#define	DA9063_REG_EVENT_C		0x08
+#define	DA9063_REG_EVENT_D		0x09
+#define	DA9063_REG_IRQ_MASK_A		0x0A
+#define	DA9063_REG_IRQ_MASK_B		0x0B
+#define	DA9063_REG_IRQ_MASK_C		0x0C
+#define	DA9063_REG_IRQ_MASK_D		0x0D
+#define	DA9063_REG_CONTROL_A		0x0E
+#define	DA9063_REG_CONTROL_B		0x0F
+#define	DA9063_REG_CONTROL_C		0x10
+#define	DA9063_REG_CONTROL_D		0x11
+#define	DA9063_REG_CONTROL_E		0x12
+#define	DA9063_REG_CONTROL_F		0x13
+#define	DA9063_REG_PD_DIS		0x14
+
+/* GPIO Control Registers */
+#define	DA9063_REG_GPIO_0_1		0x15
+#define	DA9063_REG_GPIO_2_3		0x16
+#define	DA9063_REG_GPIO_4_5		0x17
+#define	DA9063_REG_GPIO_6_7		0x18
+#define	DA9063_REG_GPIO_8_9		0x19
+#define	DA9063_REG_GPIO_10_11		0x1A
+#define	DA9063_REG_GPIO_12_13		0x1B
+#define	DA9063_REG_GPIO_14_15		0x1C
+#define	DA9063_REG_GPIO_MODE_0_7	0x1D
+#define	DA9063_REG_GPIO_MODE_8_15	0x1E
+#define	DA9063_REG_GPIO_SWITCH_CONT	0x1F
+
+/* Regulator Control Registers */
+#define	DA9063_REG_BCORE2_CONT		0x20
+#define	DA9063_REG_BCORE1_CONT		0x21
+#define	DA9063_REG_BPRO_CONT		0x22
+#define	DA9063_REG_BMEM_CONT		0x23
+#define	DA9063_REG_BIO_CONT		0x24
+#define	DA9063_REG_BPERI_CONT		0x25
+#define	DA9063_REG_LDO1_CONT		0x26
+#define	DA9063_REG_LDO2_CONT		0x27
+#define	DA9063_REG_LDO3_CONT		0x28
+#define	DA9063_REG_LDO4_CONT		0x29
+#define	DA9063_REG_LDO5_CONT		0x2A
+#define	DA9063_REG_LDO6_CONT		0x2B
+#define	DA9063_REG_LDO7_CONT		0x2C
+#define	DA9063_REG_LDO8_CONT		0x2D
+#define	DA9063_REG_LDO9_CONT		0x2E
+#define	DA9063_REG_LDO10_CONT		0x2F
+#define	DA9063_REG_LDO11_CONT		0x30
+#define	DA9063_REG_VIB			0x31
+#define	DA9063_REG_DVC_1		0x32
+#define	DA9063_REG_DVC_2		0x33
+
+/* GP-ADC Control Registers */
+#define	DA9063_REG_ADC_MAN		0x34
+#define	DA9063_REG_ADC_CONT		0x35
+#define	DA9063_REG_VSYS_MON		0x36
+#define	DA9063_REG_ADC_RES_L		0x37
+#define	DA9063_REG_ADC_RES_H		0x38
+#define	DA9063_REG_VSYS_RES		0x39
+#define	DA9063_REG_ADCIN1_RES		0x3A
+#define	DA9063_REG_ADCIN2_RES		0x3B
+#define	DA9063_REG_ADCIN3_RES		0x3C
+#define	DA9063_REG_MON1_RES		0x3D
+#define	DA9063_REG_MON2_RES		0x3E
+#define	DA9063_REG_MON3_RES		0x3F
+
+/* RTC Calendar and Alarm Registers */
+#define	DA9063_REG_COUNT_S		0x40
+#define	DA9063_REG_COUNT_MI		0x41
+#define	DA9063_REG_COUNT_H		0x42
+#define	DA9063_REG_COUNT_D		0x43
+#define	DA9063_REG_COUNT_MO		0x44
+#define	DA9063_REG_COUNT_Y		0x45
+#define	DA9063_REG_ALARM_MI		0x46
+#define	DA9063_REG_ALARM_H		0x47
+#define	DA9063_REG_ALARM_D		0x48
+#define	DA9063_REG_ALARM_MO		0x49
+#define	DA9063_REG_ALARM_Y		0x4A
+#define	DA9063_REG_SECOND_A		0x4B
+#define	DA9063_REG_SECOND_B		0x4C
+#define	DA9063_REG_SECOND_C		0x4D
+#define	DA9063_REG_SECOND_D		0x4E
+
+/* Sequencer Control Registers */
+#define	DA9063_REG_SEQ			0x81
+#define	DA9063_REG_SEQ_TIMER		0x82
+#define	DA9063_REG_ID_2_1		0x83
+#define	DA9063_REG_ID_4_3		0x84
+#define	DA9063_REG_ID_6_5		0x85
+#define	DA9063_REG_ID_8_7		0x86
+#define	DA9063_REG_ID_10_9		0x87
+#define	DA9063_REG_ID_12_11		0x88
+#define	DA9063_REG_ID_14_13		0x89
+#define	DA9063_REG_ID_16_15		0x8A
+#define	DA9063_REG_ID_18_17		0x8B
+#define	DA9063_REG_ID_20_19		0x8C
+#define	DA9063_REG_ID_22_21		0x8D
+#define	DA9063_REG_ID_24_23		0x8E
+#define	DA9063_REG_ID_26_25		0x8F
+#define	DA9063_REG_ID_28_27		0x90
+#define	DA9063_REG_ID_30_29		0x91
+#define	DA9063_REG_ID_32_31		0x92
+#define	DA9063_REG_SEQ_A		0x95
+#define	DA9063_REG_SEQ_B		0x96
+#define	DA9063_REG_WAIT			0x97
+#define	DA9063_REG_EN_32K		0x98
+#define	DA9063_REG_RESET		0x99
+
+/* Regulator Setting Registers */
+#define	DA9063_REG_BUCK_ILIM_A		0x9A
+#define	DA9063_REG_BUCK_ILIM_B		0x9B
+#define	DA9063_REG_BUCK_ILIM_C		0x9C
+#define	DA9063_REG_BCORE2_CFG		0x9D
+#define	DA9063_REG_BCORE1_CFG		0x9E
+#define	DA9063_REG_BPRO_CFG		0x9F
+#define	DA9063_REG_BIO_CFG		0xA0
+#define	DA9063_REG_BMEM_CFG		0xA1
+#define	DA9063_REG_BPERI_CFG		0xA2
+#define	DA9063_REG_VBCORE2_A		0xA3
+#define	DA9063_REG_VBCORE1_A		0xA4
+#define	DA9063_REG_VBPRO_A		0xA5
+#define	DA9063_REG_VBMEM_A		0xA6
+#define	DA9063_REG_VBIO_A		0xA7
+#define	DA9063_REG_VBPERI_A		0xA8
+#define	DA9063_REG_VLDO1_A		0xA9
+#define	DA9063_REG_VLDO2_A		0xAA
+#define	DA9063_REG_VLDO3_A		0xAB
+#define	DA9063_REG_VLDO4_A		0xAC
+#define	DA9063_REG_VLDO5_A		0xAD
+#define	DA9063_REG_VLDO6_A		0xAE
+#define	DA9063_REG_VLDO7_A		0xAF
+#define	DA9063_REG_VLDO8_A		0xB0
+#define	DA9063_REG_VLDO9_A		0xB1
+#define	DA9063_REG_VLDO10_A		0xB2
+#define	DA9063_REG_VLDO11_A		0xB3
+#define	DA9063_REG_VBCORE2_B		0xB4
+#define	DA9063_REG_VBCORE1_B		0xB5
+#define	DA9063_REG_VBPRO_B		0xB6
+#define	DA9063_REG_VBMEM_B		0xB7
+#define	DA9063_REG_VBIO_B		0xB8
+#define	DA9063_REG_VBPERI_B		0xB9
+#define	DA9063_REG_VLDO1_B		0xBA
+#define	DA9063_REG_VLDO2_B		0xBB
+#define	DA9063_REG_VLDO3_B		0xBC
+#define	DA9063_REG_VLDO4_B		0xBD
+#define	DA9063_REG_VLDO5_B		0xBE
+#define	DA9063_REG_VLDO6_B		0xBF
+#define	DA9063_REG_VLDO7_B		0xC0
+#define	DA9063_REG_VLDO8_B		0xC1
+#define	DA9063_REG_VLDO9_B		0xC2
+#define	DA9063_REG_VLDO10_B		0xC3
+#define	DA9063_REG_VLDO11_B		0xC4
+
+/* Backup Battery Charger Control Register */
+#define	DA9063_REG_BBAT_CONT		0xC5
+
+/* GPIO PWM (LED) */
+#define	DA9063_REG_GPO11_LED		0xC6
+#define	DA9063_REG_GPO14_LED		0xC7
+#define	DA9063_REG_GPO15_LED		0xC8
+
+/* GP-ADC Threshold Registers */
+#define	DA9063_REG_ADC_CFG		0xC9
+#define	DA9063_REG_AUTO1_HIGH		0xCA
+#define	DA9063_REG_AUTO1_LOW		0xCB
+#define	DA9063_REG_AUTO2_HIGH		0xCC
+#define	DA9063_REG_AUTO2_LOW		0xCD
+#define	DA9063_REG_AUTO3_HIGH		0xCE
+#define	DA9063_REG_AUTO3_LOW		0xCF
+
+/* DA9063 Configuration registers */
+/* OTP */
+#define	DA9063_REG_OPT_COUNT		0x101
+#define	DA9063_REG_OPT_ADDR		0x102
+#define	DA9063_REG_OPT_DATA		0x103
+
+/* Customer Trim and Configuration */
+#define	DA9063_REG_T_OFFSET		0x104
+#define	DA9063_REG_INTERFACE		0x105
+#define	DA9063_REG_CONFIG_A		0x106
+#define	DA9063_REG_CONFIG_B		0x107
+#define	DA9063_REG_CONFIG_C		0x108
+#define	DA9063_REG_CONFIG_D		0x109
+#define	DA9063_REG_CONFIG_E		0x10A
+#define	DA9063_REG_CONFIG_F		0x10B
+#define	DA9063_REG_CONFIG_G		0x10C
+#define	DA9063_REG_CONFIG_H		0x10D
+#define	DA9063_REG_CONFIG_I		0x10E
+#define	DA9063_REG_CONFIG_J		0x10F
+#define	DA9063_REG_CONFIG_K		0x110
+#define	DA9063_REG_CONFIG_L		0x111
+#define	DA9063_REG_MON_REG_1		0x112
+#define	DA9063_REG_MON_REG_2		0x113
+#define	DA9063_REG_MON_REG_3		0x114
+#define	DA9063_REG_MON_REG_4		0x115
+#define	DA9063_REG_MON_REG_5		0x116
+#define	DA9063_REG_MON_REG_6		0x117
+#define	DA9063_REG_TRIM_CLDR		0x118
+
+/* General Purpose Registers */
+#define	DA9063_REG_GP_ID_0		0x119
+#define	DA9063_REG_GP_ID_1		0x11A
+#define	DA9063_REG_GP_ID_2		0x11B
+#define	DA9063_REG_GP_ID_3		0x11C
+#define	DA9063_REG_GP_ID_4		0x11D
+#define	DA9063_REG_GP_ID_5		0x11E
+#define	DA9063_REG_GP_ID_6		0x11F
+#define	DA9063_REG_GP_ID_7		0x120
+#define	DA9063_REG_GP_ID_8		0x121
+#define	DA9063_REG_GP_ID_9		0x122
+#define	DA9063_REG_GP_ID_10		0x123
+#define	DA9063_REG_GP_ID_11		0x124
+#define	DA9063_REG_GP_ID_12		0x125
+#define	DA9063_REG_GP_ID_13		0x126
+#define	DA9063_REG_GP_ID_14		0x127
+#define	DA9063_REG_GP_ID_15		0x128
+#define	DA9063_REG_GP_ID_16		0x129
+#define	DA9063_REG_GP_ID_17		0x12A
+#define	DA9063_REG_GP_ID_18		0x12B
+#define	DA9063_REG_GP_ID_19		0x12C
+
+/* Chip ID and variant */
+#define	DA9063_REG_CHIP_ID		0x181
+#define	DA9063_REG_CHIP_VARIANT		0x182
+
+/*
+ * PMIC registers bits
+ */
+/* DA9063_REG_PAGE_CON (addr=0x00) */
+#define	DA9063_PEG_PAGE_SHIFT			0
+#define	DA9063_REG_PAGE_MASK			0x07
+#define		DA9063_REG_PAGE0		0x00
+#define		DA9063_REG_PAGE2		0x02
+#define	DA9063_PAGE_WRITE_MODE			0x00
+#define	DA9063_REPEAT_WRITE_MODE		0x40
+#define	DA9063_PAGE_REVERT			0x80
+
+/* DA9063_REG_STATUS_A (addr=0x01) */
+#define	DA9063_NONKEY				0x01
+#define	DA9063_WAKE				0x02
+#define	DA9063_DVC_BUSY				0x04
+#define	DA9063_COMP_1V2				0x08
+
+/* DA9063_REG_STATUS_B (addr=0x02) */
+#define	DA9063_GPI0				0x01
+#define	DA9063_GPI1				0x02
+#define	DA9063_GPI2				0x04
+#define	DA9063_GPI3				0x08
+#define	DA9063_GPI4				0x10
+#define	DA9063_GPI5				0x20
+#define	DA9063_GPI6				0x40
+#define	DA9063_GPI7				0x80
+
+/* DA9063_REG_STATUS_C (addr=0x03) */
+#define	DA9063_GPI8				0x01
+#define	DA9063_GPI9				0x02
+#define	DA9063_GPI10				0x04
+#define	DA9063_GPI11				0x08
+#define	DA9063_GPI12				0x10
+#define	DA9063_GPI13				0x20
+#define	DA9063_GPI14				0x40
+#define	DA9063_GPI15				0x80
+
+/* DA9063_REG_STATUS_D (addr=0x04) */
+#define	DA9063_LDO3_LIM				0x08
+#define	DA9063_LDO4_LIM				0x10
+#define	DA9063_LDO7_LIM				0x20
+#define	DA9063_LDO8_LIM				0x40
+#define	DA9063_LDO11_LIM			0x80
+
+/* DA9063_REG_FAULT_LOG (addr=0x05) */
+#define	DA9063_TWD_ERROR			0x01
+#define	DA9063_POR				0x02
+#define	DA9063_VDD_FAULT			0x04
+#define	DA9063_VDD_START			0x08
+#define	DA9063_TEMP_CRIT			0x10
+#define	DA9063_KEY_RESET			0x20
+#define	DA9063_NSHUTDOWN			0x40
+#define	DA9063_WAIT_SHUT			0x80
+
+/* DA9063_REG_EVENT_A (addr=0x06) */
+#define	DA9063_E_NONKEY				0x01
+#define	DA9063_E_ALARM				0x02
+#define	DA9063_E_TICK				0x04
+#define	DA9063_E_ADC_RDY			0x08
+#define	DA9063_E_SEQ_RDY			0x10
+#define	DA9063_EVENTS_B				0x20
+#define	DA9063_EVENTS_C				0x40
+#define	DA9063_EVENTS_D				0x80
+
+/* DA9063_REG_EVENT_B (addr=0x07) */
+#define	DA9063_E_WAKE				0x01
+#define	DA9063_E_TEMP				0x02
+#define	DA9063_E_COMP_1V2			0x04
+#define	DA9063_E_LDO_LIM			0x08
+#define	DA9063_E_REG_UVOV			0x10
+#define	DA9063_E_DVC_RDY			0x20
+#define	DA9063_E_VDD_MON			0x40
+#define	DA9063_E_VDD_WARN			0x80
+
+/* DA9063_REG_EVENT_C (addr=0x08) */
+#define	DA9063_E_GPI0				0x01
+#define	DA9063_E_GPI1				0x02
+#define	DA9063_E_GPI2				0x04
+#define	DA9063_E_GPI3				0x08
+#define	DA9063_E_GPI4				0x10
+#define	DA9063_E_GPI5				0x20
+#define	DA9063_E_GPI6				0x40
+#define	DA9063_E_GPI7				0x80
+
+/* DA9063_REG_EVENT_D (addr=0x09) */
+#define	DA9063_E_GPI8				0x01
+#define	DA9063_E_GPI9				0x02
+#define	DA9063_E_GPI10				0x04
+#define	DA9063_E_GPI11				0x08
+#define	DA9063_E_GPI12				0x10
+#define	DA9063_E_GPI13				0x20
+#define	DA9063_E_GPI14				0x40
+#define	DA9063_E_GPI15				0x80
+
+/* DA9063_REG_IRQ_MASK_A (addr=0x0A) */
+#define	DA9063_M_ONKEY				0x01
+#define	DA9063_M_ALARM				0x02
+#define	DA9063_M_TICK				0x04
+#define	DA9063_M_ADC_RDY			0x08
+#define	DA9063_M_SEQ_RDY			0x10
+
+/* DA9063_REG_IRQ_MASK_B (addr=0x0B) */
+#define	DA9063_M_WAKE				0x01
+#define	DA9063_M_TEMP				0x02
+#define	DA9063_M_COMP_1V2			0x04
+#define	DA9063_M_LDO_LIM			0x08
+#define	DA9063_M_UVOV				0x10
+#define	DA9063_M_DVC_RDY			0x20
+#define	DA9063_M_VDD_MON			0x40
+#define	DA9063_M_VDD_WARN			0x80
+
+/* DA9063_REG_IRQ_MASK_C (addr=0x0C) */
+#define	DA9063_M_GPI0				0x01
+#define	DA9063_M_GPI1				0x02
+#define	DA9063_M_GPI2				0x04
+#define	DA9063_M_GPI3				0x08
+#define	DA9063_M_GPI4				0x10
+#define	DA9063_M_GPI5				0x20
+#define	DA9063_M_GPI6				0x40
+#define	DA9063_M_GPI7				0x80
+
+/* DA9063_REG_IRQ_MASK_D (addr=0x0D) */
+#define	DA9063_M_GPI8				0x01
+#define	DA9063_M_GPI9				0x02
+#define	DA9063_M_GPI10				0x04
+#define	DA9063_M_GPI11				0x08
+#define	DA9063_M_GPI12				0x10
+#define	DA9063_M_GPI13				0x20
+#define	DA9063_M_GPI14				0x40
+#define	DA9063_M_GPI15				0x80
+
+/* DA9063_REG_CONTROL_A (addr=0x0E) */
+#define	DA9063_SYSTEM_EN			0x01
+#define	DA9063_POWER_EN				0x02
+#define	DA9063_POWER1_EN			0x04
+#define	DA9063_STANDBY				0x08
+#define	DA9063_M_SYSTEM_EN			0x10
+#define	DA9063_M_POWER_EN			0x20
+#define	DA9063_M_POWER1_EN			0x40
+#define	DA9063_CP_EN				0x80
+
+/* DA9063_REG_CONTROL_B (addr=0x0F) */
+#define	DA9063_CHG_SEL				0x01
+#define	DA9063_WATCHDOG_PD			0x02
+#define	DA9063_NRES_MODE			0x08
+#define	DA9063_NONKEY_LOCK			0x10
+
+/* DA9063_REG_CONTROL_C (addr=0x10) */
+#define	DA9063_DEBOUNCING_MASK			0x07
+#define		DA9063_DEBOUNCING_OFF		0x0
+#define		DA9063_DEBOUNCING_0MS1		0x1
+#define		DA9063_DEBOUNCING_1MS		0x2
+#define		DA9063_DEBOUNCING_10MS24	0x3
+#define		DA9063_DEBOUNCING_51MS2		0x4
+#define		DA9063_DEBOUNCING_256MS		0x5
+#define		DA9063_DEBOUNCING_512MS		0x6
+#define		DA9063_DEBOUNCING_1024MS	0x7
+
+#define	DA9063_AUTO_BOOT			0x08
+#define	DA9063_OTPREAD_EN			0x10
+#define	DA9063_SLEW_RATE_MASK			0x60
+#define		DA9063_SLEW_RATE_4US		0x00
+#define		DA9063_SLEW_RATE_3US		0x20
+#define		DA9063_SLEW_RATE_1US		0x40
+#define		DA9063_SLEW_RATE_0US5		0x60
+#define	DA9063_DEF_SUPPLY			0x80
+
+/* DA9063_REG_CONTROL_D (addr=0x11) */
+#define	DA9063_TWDSCALE_MASK			0x07
+#define	DA9063_BLINK_FRQ_MASK			0x38
+#define		DA9063_BLINK_FRQ_OFF		0x00
+#define		DA9063_BLINK_FRQ_1S0		0x08
+#define		DA9063_BLINK_FRQ_2S0		0x10
+#define		DA9063_BLINK_FRQ_4S0		0x18
+#define		DA9063_BLINK_FRQ_0S18		0x20
+#define		DA9063_BLINK_FRQ_2S0_VDD	0x28
+#define		DA9063_BLINK_FRQ_4S0_VDD	0x30
+#define		DA9063_BLINK_FRQ_0S18_VDD	0x38
+
+#define	DA9063_BLINK_DUR_MASK			0xC0
+#define		DA9063_BLINK_DUR_10MS		0x00
+#define		DA9063_BLINK_DUR_20MS		0x40
+#define		DA9063_BLINK_DUR_40MS		0x80
+#define		DA9063_BLINK_DUR_20MSDBL	0xC0
+
+/* DA9063_REG_CONTROL_E (addr=0x12) */
+#define	DA9063_RTC_MODE_PD			0x01
+#define	DA9063_RTC_MODE_SD			0x02
+#define	DA9063_RTC_EN				0x04
+#define	DA9063_ECO_MODE				0x08
+#define	DA9063_PM_FB1_PIN			0x10
+#define	DA9063_PM_FB2_PIN			0x20
+#define	DA9063_PM_FB3_PIN			0x40
+#define	DA9063_V_LOCK				0x80
+
+/* DA9063_REG_CONTROL_F (addr=0x13) */
+#define	DA9063_WATCHDOG				0x01
+#define	DA9063_SHUTDOWN				0x02
+#define	DA9063_WAKE_UP				0x04
+
+/* DA9063_REG_PD_DIS (addr=0x14) */
+#define	DA9063_GPI_DIS				0x01
+#define	DA9063_GPADC_PAUSE			0x02
+#define	DA9063_PMIF_DIS				0x04
+#define	DA9063_HS2WIRE_DIS			0x08
+#define	DA9063_BBAT_DIS				0x20
+#define	DA9063_OUT_32K_PAUSE			0x40
+#define	DA9063_PMCONT_DIS			0x80
+
+/* DA9063_REG_GPIO_0_1 (addr=0x15) */
+#define	DA9063_GPIO0_PIN_MASK			0x03
+#define		DA9063_GPIO0_PIN_ADCIN1		0x00
+#define		DA9063_GPIO0_PIN_GPI		0x01
+#define		DA9063_GPIO0_PIN_GPO_OD		0x02
+#define		DA9063_GPIO0_PIN_GPO		0x03
+#define	DA9063_GPIO0_TYPE			0x04
+#define		DA9063_GPIO0_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO0_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO0_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO0_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO0_NO_WAKEUP			0x08
+#define	DA9063_GPIO1_PIN_MASK			0x30
+#define		DA9063_GPIO1_PIN_ADCIN2_COMP	0x00
+#define		DA9063_GPIO1_PIN_GPI		0x10
+#define		DA9063_GPIO1_PIN_GPO_OD		0x20
+#define		DA9063_GPIO1_PIN_GPO		0x30
+#define	DA9063_GPIO1_TYPE			0x40
+#define		DA9063_GPIO1_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO1_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO1_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO1_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO1_NO_WAKEUP			0x80
+
+/* DA9063_REG_GPIO_2_3 (addr=0x16) */
+#define	DA9063_GPIO2_PIN_MASK			0x03
+#define		DA9063_GPIO2_PIN_ADCIN3		0x00
+#define		DA9063_GPIO2_PIN_GPI		0x01
+#define		DA9063_GPIO2_PIN_GPO_PSS	0x02
+#define		DA9063_GPIO2_PIN_GPO		0x03
+#define	DA9063_GPIO2_TYPE			0x04
+#define		DA9063_GPIO2_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO2_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO2_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO2_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO2_NO_WAKEUP			0x08
+#define	DA9063_GPIO3_PIN_MASK			0x30
+#define		DA9063_GPIO3_PIN_CORE_SW_G	0x00
+#define		DA9063_GPIO3_PIN_GPI		0x10
+#define		DA9063_GPIO3_PIN_GPO_OD		0x20
+#define		DA9063_GPIO3_PIN_GPO		0x30
+#define	DA9063_GPIO3_TYPE			0x40
+#define		DA9063_GPIO3_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO3_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO3_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO3_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO3_NO_WAKEUP			0x80
+
+/* DA9063_REG_GPIO_4_5 (addr=0x17) */
+#define	DA9063_GPIO4_PIN_MASK			0x03
+#define		DA9063_GPIO4_PIN_CORE_SW_S	0x00
+#define		DA9063_GPIO4_PIN_GPI		0x01
+#define		DA9063_GPIO4_PIN_GPO_OD		0x02
+#define		DA9063_GPIO4_PIN_GPO		0x03
+#define	DA9063_GPIO4_TYPE			0x04
+#define		DA9063_GPIO4_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO4_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO4_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO4_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO4_NO_WAKEUP			0x08
+#define	DA9063_GPIO5_PIN_MASK			0x30
+#define		DA9063_GPIO5_PIN_PERI_SW_G	0x00
+#define		DA9063_GPIO5_PIN_GPI		0x10
+#define		DA9063_GPIO5_PIN_GPO_OD		0x20
+#define		DA9063_GPIO5_PIN_GPO		0x30
+#define	DA9063_GPIO5_TYPE			0x40
+#define		DA9063_GPIO5_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO5_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO5_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO5_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO5_NO_WAKEUP			0x80
+
+/* DA9063_REG_GPIO_6_7 (addr=0x18) */
+#define	DA9063_GPIO6_PIN_MASK			0x03
+#define		DA9063_GPIO6_PIN_PERI_SW_S	0x00
+#define		DA9063_GPIO6_PIN_GPI		0x01
+#define		DA9063_GPIO6_PIN_GPO_OD		0x02
+#define		DA9063_GPIO6_PIN_GPO		0x03
+#define	DA9063_GPIO6_TYPE			0x04
+#define		DA9063_GPIO6_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO6_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO6_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO6_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO6_NO_WAKEUP			0x08
+#define	DA9063_GPIO7_PIN_MASK			0x30
+#define		DA9063_GPIO7_PIN_GPI		0x10
+#define		DA9063_GPIO7_PIN_GPO_PSS	0x20
+#define		DA9063_GPIO7_PIN_GPO		0x30
+#define	DA9063_GPIO7_TYPE			0x40
+#define		DA9063_GPIO7_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO7_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO7_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO7_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO7_NO_WAKEUP			0x80
+
+/* DA9063_REG_GPIO_8_9 (addr=0x19) */
+#define	DA9063_GPIO8_PIN_MASK			0x03
+#define		DA9063_GPIO8_PIN_GPI_SYS_EN	0x00
+#define		DA9063_GPIO8_PIN_GPI		0x01
+#define		DA9063_GPIO8_PIN_GPO_PSS	0x02
+#define		DA9063_GPIO8_PIN_GPO		0x03
+#define	DA9063_GPIO8_TYPE			0x04
+#define		DA9063_GPIO8_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO8_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO8_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO8_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO8_NO_WAKEUP			0x08
+#define	DA9063_GPIO9_PIN_MASK			0x30
+#define		DA9063_GPIO9_PIN_GPI_PWR_EN	0x00
+#define		DA9063_GPIO9_PIN_GPI		0x10
+#define		DA9063_GPIO9_PIN_GPO_PSS	0x20
+#define		DA9063_GPIO9_PIN_GPO		0x30
+#define	DA9063_GPIO9_TYPE			0x40
+#define		DA9063_GPIO9_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO9_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO9_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO9_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO9_NO_WAKEUP			0x80
+
+/* DA9063_REG_GPIO_10_11 (addr=0x1A) */
+#define	DA9063_GPIO10_PIN_MASK			0x03
+#define		DA9063_GPIO10_PIN_GPI_PWR1_EN	0x00
+#define		DA9063_GPIO10_PIN_GPI		0x01
+#define		DA9063_GPIO10_PIN_GPO_OD	0x02
+#define		DA9063_GPIO10_PIN_GPO		0x03
+#define	DA9063_GPIO10_TYPE			0x04
+#define		DA9063_GPIO10_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO10_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO10_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO10_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO10_NO_WAKEUP			0x08
+#define	DA9063_GPIO11_PIN_MASK			0x30
+#define		DA9063_GPIO11_PIN_GPO_OD	0x00
+#define		DA9063_GPIO11_PIN_GPI		0x10
+#define		DA9063_GPIO11_PIN_GPO_PSS	0x20
+#define		DA9063_GPIO11_PIN_GPO		0x30
+#define	DA9063_GPIO11_TYPE			0x40
+#define		DA9063_GPIO11_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO11_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO11_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO11_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO11_NO_WAKEUP			0x80
+
+/* DA9063_REG_GPIO_12_13 (addr=0x1B) */
+#define	DA9063_GPIO12_PIN_MASK			0x03
+#define		DA9063_GPIO12_PIN_NVDDFLT_OUT	0x00
+#define		DA9063_GPIO12_PIN_GPI		0x01
+#define		DA9063_GPIO12_PIN_VSYSMON_OUT	0x02
+#define		DA9063_GPIO12_PIN_GPO		0x03
+#define	DA9063_GPIO12_TYPE			0x04
+#define		DA9063_GPIO12_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO12_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO12_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO12_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO12_NO_WAKEUP			0x08
+#define	DA9063_GPIO13_PIN_MASK			0x30
+#define		DA9063_GPIO13_PIN_GPFB1_OUT	0x00
+#define		DA9063_GPIO13_PIN_GPI		0x10
+#define		DA9063_GPIO13_PIN_GPFB1_OUTOD	0x20
+#define		DA9063_GPIO13_PIN_GPO		0x30
+#define	DA9063_GPIO13_TYPE			0x40
+#define		DA9063_GPIO13_TYPE_GPFB1_OUT	0x00
+#define		DA9063_GPIO13_TYPE_GPI		0x00
+#define		DA9063_GPIO13_TYPE_GPFB1_OUTOD	0x04
+#define		DA9063_GPIO13_TYPE_GPO		0x04
+#define	DA9063_GPIO13_NO_WAKEUP			0x80
+
+/* DA9063_REG_GPIO_14_15 (addr=0x1C) */
+#define	DA9063_GPIO14_PIN_MASK			0x03
+#define		DA9063_GPIO14_PIN_GPO_OD	0x00
+#define		DA9063_GPIO14_PIN_GPI		0x01
+#define		DA9063_GPIO14_PIN_HS2DATA	0x02
+#define		DA9063_GPIO14_PIN_GPO		0x03
+#define	DA9063_GPIO14_TYPE			0x04
+#define		DA9063_GPIO14_TYPE_GPI_ACT_LOW	0x00
+#define		DA9063_GPIO14_TYPE_GPO_VDD_IO1	0x00
+#define		DA9063_GPIO14_TYPE_GPI_ACT_HIGH	0x04
+#define		DA9063_GPIO14_TYPE_GPO_VDD_IO2	0x04
+#define	DA9063_GPIO14_NO_WAKEUP			0x08
+#define	DA9063_GPIO15_PIN_MASK			0x30
+#define		DA9063_GPIO15_PIN_GPO_OD	0x00
+#define		DA9063_GPIO15_PIN_GPI		0x10
+#define		DA9063_GPIO15_PIN_GPO		0x30
+#define	DA9063_GPIO15_TYPE			0x40
+#define		DA9063_GPIO15_TYPE_GPFB1_OUT	0x00
+#define		DA9063_GPIO15_TYPE_GPI		0x00
+#define		DA9063_GPIO15_TYPE_GPFB1_OUTOD	0x04
+#define		DA9063_GPIO15_TYPE_GPO		0x04
+#define	DA9063_GPIO15_NO_WAKEUP			0x80
+
+/* DA9063_REG_GPIO_MODE_0_7 (addr=0x1D) */
+#define	DA9063_GPIO0_MODE			0x01
+#define	DA9063_GPIO1_MODE			0x02
+#define	DA9063_GPIO2_MODE			0x04
+#define	DA9063_GPIO3_MODE			0x08
+#define	DA9063_GPIO4_MODE			0x10
+#define	DA9063_GPIO5_MODE			0x20
+#define	DA9063_GPIO6_MODE			0x40
+#define	DA9063_GPIO7_MODE			0x80
+
+/* DA9063_REG_GPIO_MODE_8_15 (addr=0x1E) */
+#define	DA9063_GPIO8_MODE			0x01
+#define	DA9063_GPIO9_MODE			0x02
+#define	DA9063_GPIO10_MODE			0x04
+#define	DA9063_GPIO11_MODE			0x08
+#define		DA9063_GPIO11_MODE_LED_ACT_HIGH	0x00
+#define		DA9063_GPIO11_MODE_LED_ACT_LOW	0x08
+#define	DA9063_GPIO12_MODE			0x10
+#define	DA9063_GPIO13_MODE			0x20
+#define	DA9063_GPIO14_MODE			0x40
+#define		DA9063_GPIO14_MODE_LED_ACT_HIGH	0x00
+#define		DA9063_GPIO14_MODE_LED_ACT_LOW	0x40
+#define	DA9063_GPIO15_MODE			0x80
+#define		DA9063_GPIO15_MODE_LED_ACT_HIGH	0x00
+#define		DA9063_GPIO15_MODE_LED_ACT_LOW	0x80
+
+/* DA9063_REG_SWITCH_CONT (addr=0x1F) */
+#define	DA9063_CORE_SW_GPI_MASK			0x03
+#define		DA9063_CORE_SW_GPI_OFF		0x00
+#define		DA9063_CORE_SW_GPI_GPIO1	0x01
+#define		DA9063_CORE_SW_GPI_GPIO2	0x02
+#define		DA9063_CORE_SW_GPI_GPIO13	0x03
+#define	DA9063_PERI_SW_GPI_MASK			0x0C
+#define		DA9063_PERI_SW_GPI_OFF		0x00
+#define		DA9063_PERI_SW_GPI_GPIO1	0x04
+#define		DA9063_PERI_SW_GPI_GPIO2	0x08
+#define		DA9063_PERI_SW_GPI_GPIO13	0x0C
+#define	DA9063_SWITCH_SR_MASK			0x30
+#define		DA9063_SWITCH_SR_1MV		0x00
+#define		DA9063_SWITCH_SR_5MV		0x10
+#define		DA9063_SWITCH_SR_10MV		0x20
+#define		DA9063_SWITCH_SR_50MV		0x30
+#define	DA9063_SWITCH_SR_DIS			0x40
+#define	DA9063_CP_EN_MODE			0x80
+
+/* DA9063_REGL_Bxxxx_CONT common bits (addr=0x20-0x25) */
+#define	DA9063_BUCK_EN				0x01
+#define DA9063_BUCK_GPI_MASK			0x06
+#define		DA9063_BUCK_GPI_OFF		0x00
+#define		DA9063_BUCK_GPI_GPIO1		0x02
+#define		DA9063_BUCK_GPI_GPIO2		0x04
+#define		DA9063_BUCK_GPI_GPIO13		0x06
+#define	DA9063_BUCK_CONF			0x08
+#define	DA9063_VBUCK_GPI_MASK			0x60
+#define		DA9063_VBUCK_GPI_OFF		0x00
+#define		DA9063_VBUCK_GPI_GPIO1		0x20
+#define		DA9063_VBUCK_GPI_GPIO2		0x40
+#define		DA9063_VBUCK_GPI_GPIO13		0x60
+
+/* DA9063_REG_BCORE1_CONT specific bits (addr=0x21) */
+#define	DA9063_CORE_SW_EN			0x10
+#define	DA9063_CORE_SW_CONF			0x80
+
+/* DA9063_REG_BPERI_CONT specific bits (addr=0x25) */
+#define	DA9063_PERI_SW_EN			0x10
+#define	DA9063_PERI_SW_CONF			0x80
+
+/* DA9063_REG_LDOx_CONT common bits (addr=0x26-0x30) */
+#define	DA9063_LDO_EN				0x01
+#define DA9063_LDO_GPI_MASK			0x06
+#define		DA9063_LDO_GPI_OFF		0x00
+#define		DA9063_LDO_GPI_GPIO1		0x02
+#define		DA9063_LDO_GPI_GPIO2		0x04
+#define		DA9063_LDO_GPI_GPIO13		0x06
+#define	DA9063_LDO_PD_DIS			0x08
+#define	DA9063_VLDO_GPI_MASK			0x60
+#define		DA9063_VLDO_GPI_OFF		0x00
+#define		DA9063_VLDO_GPI_GPIO1		0x20
+#define		DA9063_VLDO_GPI_GPIO2		0x40
+#define		DA9063_VLDO_GPI_GPIO13		0x60
+#define	DA9063_LDO_CONF				0x80
+
+/* DA9063_REG_LDO5_CONT specific bits (addr=0x2A) */
+#define	DA9063_VLDO5_SEL			0x10
+
+/* DA9063_REG_LDO6_CONT specific bits (addr=0x2B) */
+#define	DA9063_VLDO6_SEL			0x10
+
+/* DA9063_REG_LDO7_CONT specific bits (addr=0x2C) */
+#define	DA9063_VLDO7_SEL			0x10
+
+/* DA9063_REG_LDO8_CONT specific bits (addr=0x2D) */
+#define	DA9063_VLDO8_SEL			0x10
+
+/* DA9063_REG_LDO9_CONT specific bits (addr=0x2E) */
+#define	DA9063_VLDO9_SEL			0x10
+
+/* DA9063_REG_LDO10_CONT specific bits (addr=0x2F) */
+#define	DA9063_VLDO10_SEL			0x10
+
+/* DA9063_REG_LDO11_CONT specific bits (addr=0x30) */
+#define	DA9063_VLDO11_SEL			0x10
+
+/* DA9063_REG_VIB (addr=0x31) */
+#define DA9063_VIB_SET_MASK			0x3F
+#define		DA9063_VIB_SET_OFF		0
+#define		DA9063_VIB_SET_MAX		0x3F
+
+/* DA9063_REG_DVC_1 (addr=0x32) */
+#define	DA9063_VBCORE1_SEL			0x01
+#define	DA9063_VBCORE2_SEL			0x02
+#define	DA9063_VBPRO_SEL			0x04
+#define	DA9063_VBMEM_SEL			0x08
+#define	DA9063_VBPERI_SEL			0x10
+#define	DA9063_VLDO1_SEL			0x20
+#define	DA9063_VLDO2_SEL			0x40
+#define	DA9063_VLDO3_SEL			0x80
+
+/* DA9063_REG_DVC_2 (addr=0x33) */
+#define	DA9063_VBIO_SEL				0x01
+#define	DA9063_VLDO4_SEL			0x80
+
+/* DA9063_REG_ADC_MAN (addr=0x34) */
+#define	DA9063_ADC_MUX_MASK			0x0F
+#define		DA9063_ADC_MUX_VSYS		0x00
+#define		DA9063_ADC_MUX_ADCIN1		0x01
+#define		DA9063_ADC_MUX_ADCIN2		0x02
+#define		DA9063_ADC_MUX_ADCIN3		0x03
+#define		DA9063_ADC_MUX_T_SENSE		0x04
+#define		DA9063_ADC_MUX_VBBAT		0x05
+#define		DA9063_ADC_MUX_LDO_G1		0x08
+#define		DA9063_ADC_MUX_LDO_G2		0x09
+#define		DA9063_ADC_MUX_LDO_G3		0x0A
+#define	DA9063_ADC_MAN				0x10
+#define	DA9063_ADC_MODE				0x20
+
+/* DA9063_REG_ADC_CONT (addr=0x35) */
+#define	DA9063_ADC_AUTO_VSYS_EN			0x01
+#define	DA9063_ADC_AUTO_AD1_EN			0x02
+#define	DA9063_ADC_AUTO_AD2_EN			0x04
+#define	DA9063_ADC_AUTO_AD3_EN			0x08
+#define	DA9063_ADC_AD1_ISRC_EN			0x10
+#define	DA9063_ADC_AD2_ISRC_EN			0x20
+#define	DA9063_ADC_AD3_ISRC_EN			0x40
+#define	DA9063_COMP1V2_EN			0x80
+
+/* DA9063_REG_VSYS_MON (addr=0x36) */
+#define	DA9063_VSYS_VAL_MASK			0xFF
+#define	DA9063_VSYS_VAL_BASE			0x00
+
+/* DA9063_REG_ADC_RES_L (addr=0x37) */
+#define	DA9063_ADC_RES_L_BITS			2
+#define	DA9063_ADC_RES_L_MASK			0xC0
+
+/* DA9063_REG_ADC_RES_H (addr=0x38) */
+#define	DA9063_ADC_RES_M_BITS			8
+#define	DA9063_ADC_RES_M_MASK			0xFF
+
+/* DA9063_REG_(xxx_RES/ADC_RES_H) (addr=0x39-0x3F) */
+#define	DA9063_ADC_VAL_MASK			0xFF
+
+/* DA9063_REG_COUNT_S (addr=0x40) */
+#define DA9063_RTC_READ				0x80
+#define DA9063_COUNT_SEC_MASK			0x3F
+
+/* DA9063_REG_COUNT_MI (addr=0x41) */
+#define DA9063_COUNT_MIN_MASK			0x3F
+
+/* DA9063_REG_COUNT_H (addr=0x42) */
+#define DA9063_COUNT_HOUR_MASK			0x1F
+
+/* DA9063_REG_COUNT_D (addr=0x43) */
+#define DA9063_COUNT_DAY_MASK			0x1F
+
+/* DA9063_REG_COUNT_MO (addr=0x44) */
+#define DA9063_COUNT_MONTH_MASK			0x0F
+
+/* DA9063_REG_COUNT_Y (addr=0x45) */
+#define DA9063_COUNT_YEAR_MASK			0x3F
+#define DA9063_MONITOR				0x40
+
+/* DA9063_REG_ALARM_MI (addr=0x46) */
+#define DA9063_ALARM_STATUS_ALARM		0x80
+#define DA9063_ALARM_STATUS_TICK		0x40
+#define DA9063_ALARM_MIN_MASK			0x3F
+
+/* DA9063_REG_ALARM_H (addr=0x47) */
+#define DA9063_ALARM_HOUR_MASK			0x1F
+
+/* DA9063_REG_ALARM_D (addr=0x48) */
+#define DA9063_ALARM_DAY_MASK			0x1F
+
+/* DA9063_REG_ALARM_MO (addr=0x49) */
+#define DA9063_TICK_WAKE			0x20
+#define DA9063_TICK_TYPE			0x10
+#define		DA9063_TICK_TYPE_SEC		0x00
+#define		DA9063_TICK_TYPE_MIN		0x10
+#define DA9063_ALARM_MONTH_MASK			0x0F
+
+/* DA9063_REG_ALARM_Y (addr=0x4A) */
+#define DA9063_TICK_ON				0x80
+#define DA9063_ALARM_ON				0x40
+#define DA9063_ALARM_YEAR_MASK			0x3F
+
+/* DA9063_REG_WAIT (addr=0x97)*/
+#define	DA9063_REG_WAIT_TIME_MASK		0xF
+#define	DA9063_WAIT_TIME_0_US			0x0
+#define	DA9063_WAIT_TIME_512_US			0x1
+#define	DA9063_WAIT_TIME_1_MS			0x2
+#define	DA9063_WAIT_TIME_2_MS			0x3
+#define	DA9063_WAIT_TIME_4_1_MS			0x4
+#define	DA9063_WAIT_TIME_8_2_MS			0x5
+#define	DA9063_WAIT_TIME_16_4_MS		0x6
+#define	DA9063_WAIT_TIME_32_8_MS		0x7
+#define	DA9063_WAIT_TIME_65_5_MS		0x8
+#define	DA9063_WAIT_TIME_128_MS			0x9
+#define	DA9063_WAIT_TIME_256_MS			0xA
+#define	DA9063_WAIT_TIME_512_MS			0xB
+#define	DA9063_WAIT_TIME_1_S			0xC
+#define	DA9063_WAIT_TIME_2_1_S			0xD
+
+/* DA9063_REG_EN_32K  (addr=0x98)*/
+#define	DA9063_STABILIZ_TIME_MASK		0x7
+#define	DA9063_CRYSTAL				0x08
+#define	DA9063_DELAY_MODE			0x10
+#define	DA9063_OUT_CLOCK			0x20
+#define	DA9063_RTC_CLOCK			0x40
+#define	DA9063_OUT_32K_EN			0x80
+
+/* DA9063_REG_CHIP_VARIANT */
+#define	DA9063_CHIP_VARIANT_SHIFT		4
+
+/* DA9063_REG_BUCK_ILIM_A (addr=0x9A) */
+#define DA9063_BIO_ILIM_MASK			0x0F
+#define DA9063_BMEM_ILIM_MASK			0xF0
+
+/* DA9063_REG_BUCK_ILIM_B (addr=0x9B) */
+#define DA9063_BPRO_ILIM_MASK			0x0F
+#define DA9063_BPERI_ILIM_MASK			0xF0
+
+/* DA9063_REG_BUCK_ILIM_C (addr=0x9C) */
+#define DA9063_BCORE1_ILIM_MASK			0x0F
+#define DA9063_BCORE2_ILIM_MASK			0xF0
+
+/* DA9063_REG_Bxxxx_CFG common bits (addr=0x9D-0xA2) */
+#define DA9063_BUCK_FB_MASK			0x07
+#define DA9063_BUCK_PD_DIS_SHIFT		5
+#define DA9063_BUCK_MODE_MASK			0xC0
+#define		DA9063_BUCK_MODE_MANUAL		0x00
+#define		DA9063_BUCK_MODE_SLEEP		0x40
+#define		DA9063_BUCK_MODE_SYNC		0x80
+#define		DA9063_BUCK_MODE_AUTO		0xC0
+
+/* DA9063_REG_BPRO_CFG (addr=0x9F) */
+#define	DA9063_BPRO_VTTR_EN			0x08
+#define	DA9063_BPRO_VTT_EN			0x10
+
+/* DA9063_REG_VBxxxx_A/B (addr=0xA3-0xA8, 0xB4-0xB9) */
+#define DA9063_VBUCK_MASK			0x7F
+#define DA9063_VBUCK_BIAS			0
+#define DA9063_BUCK_SL				0x80
+
+/* DA9063_REG_VLDOx_A/B (addr=0xA9-0x3, 0xBA-0xC4) */
+#define DA9063_LDO_SL				0x80
+
+/* DA9063_REG_VLDO1_A/B (addr=0xA9, 0xBA) */
+#define DA9063_VLDO1_MASK			0x3F
+#define DA9063_VLDO1_BIAS			0
+
+/* DA9063_REG_VLDO2_A/B (addr=0xAA, 0xBB) */
+#define DA9063_VLDO2_MASK			0x3F
+#define DA9063_VLDO2_BIAS			0
+
+/* DA9063_REG_VLDO3_A/B (addr=0xAB, 0xBC) */
+#define DA9063_VLDO3_MASK			0x7F
+#define DA9063_VLDO3_BIAS			0
+
+/* DA9063_REG_VLDO4_A/B (addr=0xAC, 0xBD) */
+#define DA9063_VLDO4_MASK			0x7F
+#define DA9063_VLDO4_BIAS			0
+
+/* DA9063_REG_VLDO5_A/B (addr=0xAD, 0xBE) */
+#define DA9063_VLDO5_MASK			0x3F
+#define DA9063_VLDO5_BIAS			2
+
+/* DA9063_REG_VLDO6_A/B (addr=0xAE, 0xBF) */
+#define DA9063_VLDO6_MASK			0x3F
+#define DA9063_VLDO6_BIAS			2
+
+/* DA9063_REG_VLDO7_A/B (addr=0xAF, 0xC0) */
+#define DA9063_VLDO7_MASK			0x3F
+#define DA9063_VLDO7_BIAS			2
+
+/* DA9063_REG_VLDO8_A/B (addr=0xB0, 0xC1) */
+#define DA9063_VLDO8_MASK			0x3F
+#define DA9063_VLDO8_BIAS			2
+
+/* DA9063_REG_VLDO9_A/B (addr=0xB1, 0xC2) */
+#define DA9063_VLDO9_MASK			0x3F
+#define DA9063_VLDO9_BIAS			3
+
+/* DA9063_REG_VLDO10_A/B (addr=0xB2, 0xC3) */
+#define DA9063_VLDO10_MASK			0x3F
+#define DA9063_VLDO10_BIAS			2
+
+/* DA9063_REG_VLDO11_A/B (addr=0xB3, 0xC4) */
+#define DA9063_VLDO11_MASK			0x3F
+#define DA9063_VLDO11_BIAS			2
+
+/* DA9063_REG_GPO11_LED (addr=0xC6) */
+/* DA9063_REG_GPO14_LED (addr=0xC7) */
+/* DA9063_REG_GPO15_LED (addr=0xC8) */
+#define DA9063_GPIO_DIM				0x80
+#define DA9063_GPIO_PWM_MASK			0x7F
+
+/* DA9063_REG_CONFIG_H (addr=0x10D) */
+#define DA9063_PWM_CLK_MASK			0x01
+#define		DA9063_PWM_CLK_PWM2MHZ		0x00
+#define		DA9063_PWM_CLK_PWM1MHZ		0x01
+#define DA9063_LDO8_MODE_MASK			0x02
+#define		DA9063_LDO8_MODE_LDO		0
+#define		DA9063_LDO8_MODE_VIBR		0x02
+#define DA9063_MERGE_SENSE_MASK			0x04
+#define		DA9063_MERGE_SENSE_GP_FB2	0x00
+#define		DA9063_MERGE_SENSE_GPIO4	0x04
+#define DA9063_BCORE_MERGE			0x08
+#define DA9063_BPRO_OD				0x10
+#define DA9063_BCORE2_OD			0x20
+#define DA9063_BCORE1_OD			0x40
+#define DA9063_BUCK_MERGE			0x80
+
+/* DA9063_REG_CONFIG_I (addr=0x10E) */
+#define DA9063_NONKEY_PIN_MASK			0x03
+#define		DA9063_NONKEY_PIN_PORT		0x00
+#define		DA9063_NONKEY_PIN_SWDOWN	0x01
+#define		DA9063_NONKEY_PIN_AUTODOWN	0x02
+#define		DA9063_NONKEY_PIN_AUTOFLPRT	0x03
+
+/* DA9063_REG_MON_REG_5 (addr=0x116) */
+#define DA9063_MON_A8_IDX_MASK			0x07
+#define		DA9063_MON_A8_IDX_NONE		0x00
+#define		DA9063_MON_A8_IDX_BCORE1	0x01
+#define		DA9063_MON_A8_IDX_BCORE2	0x02
+#define		DA9063_MON_A8_IDX_BPRO		0x03
+#define		DA9063_MON_A8_IDX_LDO3		0x04
+#define		DA9063_MON_A8_IDX_LDO4		0x05
+#define		DA9063_MON_A8_IDX_LDO11		0x06
+#define DA9063_MON_A9_IDX_MASK			0x70
+#define		DA9063_MON_A9_IDX_NONE		0x00
+#define		DA9063_MON_A9_IDX_BIO		0x01
+#define		DA9063_MON_A9_IDX_BMEM		0x02
+#define		DA9063_MON_A9_IDX_BPERI		0x03
+#define		DA9063_MON_A9_IDX_LDO1		0x04
+#define		DA9063_MON_A9_IDX_LDO2		0x05
+#define		DA9063_MON_A9_IDX_LDO5		0x06
+
+/* DA9063_REG_MON_REG_6 (addr=0x117) */
+#define DA9063_MON_A10_IDX_MASK			0x07
+#define		DA9063_MON_A10_IDX_NONE		0x00
+#define		DA9063_MON_A10_IDX_LDO6		0x01
+#define		DA9063_MON_A10_IDX_LDO7		0x02
+#define		DA9063_MON_A10_IDX_LDO8		0x03
+#define		DA9063_MON_A10_IDX_LDO9		0x04
+#define		DA9063_MON_A10_IDX_LDO10	0x05
+
+#endif /* _DA9063_REG_H */
-- 
1.8.3.2

