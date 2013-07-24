Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3GXQfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 12:35:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56491 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3GXQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 12:35:22 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] regulator: Add Dialog DA9063 voltage regulators support.
Date: Wed, 24 Jul 2013 18:34:43 +0200
Message-Id: <1374683683-13370-3-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.104
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krystian Garbaciak <krystian.garbaciak@diasemi.com>

The driver adds support for the following DA9063 PMIC regulators:
 - 11x LDOs (named LDO1 - LDO11),
 - 6x buck converters (BCORE1, BCORE2, BPRO, BMEM, BIO, BPERI),
 - 1x power switch to switch on/off 32 KHz oscilator output (32K_OUT).

Regulators provide following operations:
 - REGULATOR_CHANGE_STATUS for all regulators,
 - REGULATOR_CHANGE_VOLTAGE for LDOs and buck converters,
 - REGULATOR_CHANGE_MODE for LDOs and buck converters, where:
     - LDOs allow REGULATOR_MODE_NORMAL and REGULATOR_MODE_STANDBY,
     - buck converters allow REGULATOR_MODE_FAST, REGULATOR_MODE_NORMAL
       and REGULATOR_MODE_STANDBY,
 - REGULATOR_CHANGE_CURRENT for buck converters (current limits).

The driver generates REGULATOR_EVENT_OVER_CURRENT for LDO3, LDO4, LDO7, LDO8
and LDO11.

Internally, PMIC provides two voltage configurations for normal and suspend
system state for each regulator. The driver switches between those on
suspend/wake-up to provide quick and fluent output voltage change.

This driver requires MFD core driver for operation.

Signed-off-by: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/regulator/Kconfig            |   10 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/da9063-regulator.c | 1042 ++++++++++++++++++++++++++++++++++
 3 files changed, 1053 insertions(+)
 create mode 100644 drivers/regulator/da9063-regulator.c

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index f1e6ad9..b976098 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -120,6 +120,16 @@ config REGULATOR_DA9055
 	  This driver can also be built as a module. If so, the module
 	  will be called da9055-regulator.
 
+config REGULATOR_DA9063
+	tristate "Dialog Semiconductor DA9063 regulators"
+	depends on MFD_DA9063
+	help
+	  Say y here to support the BUCKs and LDOs regulators found on
+	  DA9063 PMICs.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called da9063-regulator.
+
 config REGULATOR_FAN53555
 	tristate "Fairchild FAN53555 Regulator"
 	depends on I2C
diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index ba4a3cf..49c9342 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_REGULATOR_AS3711) += as3711-regulator.o
 obj-$(CONFIG_REGULATOR_DA903X)	+= da903x.o
 obj-$(CONFIG_REGULATOR_DA9052)	+= da9052-regulator.o
 obj-$(CONFIG_REGULATOR_DA9055)	+= da9055-regulator.o
+obj-$(CONFIG_REGULATOR_DA9063)	+= da9063-regulator.o
 obj-$(CONFIG_REGULATOR_DBX500_PRCMU) += dbx500-prcmu.o
 obj-$(CONFIG_REGULATOR_DB8500_PRCMU) += db8500-prcmu.o
 obj-$(CONFIG_REGULATOR_FAN53555) += fan53555.o
diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
new file mode 100644
index 0000000..7b81bf5
--- /dev/null
+++ b/drivers/regulator/da9063-regulator.c
@@ -0,0 +1,1042 @@
+/*
+ * Regulator driver for DA9063 PMIC series
+ *
+ * Copyright 2012 Dialog Semiconductors Ltd.
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/mfd/da9063/core.h>
+#include <linux/mfd/da9063/pdata.h>
+#include <linux/mfd/da9063/registers.h>
+
+
+/* Definition for registering bit fields */
+struct bfield {
+	unsigned short	addr;
+	unsigned char	mask;
+};
+#define BFIELD(_addr, _mask) \
+	{ .addr = _addr, .mask = _mask }
+
+struct field {
+	unsigned short	addr;
+	unsigned char	mask;
+	unsigned char	shift;
+	unsigned char	offset;
+};
+#define FIELD(_addr, _mask, _shift, _offset) \
+	{ .addr = _addr, .mask = _mask, .shift = _shift, .offset = _offset }
+
+/* Regulator capabilities and registers description */
+struct da9063_regulator_info {
+	struct regulator_desc desc;
+
+	/* Current limiting */
+	unsigned	n_current_limits;
+	const int	*current_limits;
+
+	/* DA9063 main register fields */
+	struct field	mode;		/* buck mode of operation */
+	struct bfield	suspend;
+	struct bfield	sleep;
+	struct bfield	suspend_sleep;
+	int suspend_vsel_reg;
+	struct field	ilimit;
+
+	/* DA9063 event detection bit */
+	struct bfield	oc_event;
+};
+
+/* Macro for switch regulator */
+#define DA9063_SWITCH(chip, regl_name) \
+	.desc.id = chip##_ID_##regl_name, \
+	.desc.name = __stringify(chip##_##regl_name), \
+	.desc.ops = &da9063_switch_ops, \
+	.desc.n_voltages = 0
+
+/* Macros for LDO */
+#define DA9063_LDO(chip, regl_name, min_mV, step_mV, max_mV) \
+	.desc.id = chip##_ID_##regl_name, \
+	.desc.name = __stringify(chip##_##regl_name), \
+	.desc.ops = &da9063_ldo_ops, \
+	.desc.min_uV = (min_mV) * 1000, \
+	.desc.uV_step = (step_mV) * 1000, \
+	.desc.n_voltages = (((max_mV) - (min_mV))/(step_mV) + 1)
+
+#define DA9063_LDO_COMMON_FIELDS(regl_name) \
+	.desc.enable_reg = DA9063_REG_##regl_name##_CONT, \
+	.desc.enable_mask = DA9063_LDO_EN, \
+	.sleep = BFIELD(DA9063_REG_V##regl_name##_A, DA9063_LDO_SL), \
+	.suspend_sleep = BFIELD(DA9063_REG_V##regl_name##_B, DA9063_LDO_SL), \
+	.desc.vsel_reg = DA9063_REG_V##regl_name##_A, \
+	.desc.vsel_mask = DA9063_V##regl_name##_MASK, \
+	.desc.linear_min_sel = DA9063_V##regl_name##_BIAS, \
+	.suspend_vsel_reg = DA9063_REG_V##regl_name##_B
+
+/* linear_min_sel */
+
+/* Macros for voltage DC/DC converters (BUCKs) */
+#define DA9063_BUCK(chip, regl_name, min_mV, step_mV, max_mV, limits_array) \
+	.desc.id = chip##_ID_##regl_name, \
+	.desc.name = __stringify(chip##_##regl_name), \
+	.desc.ops = &da9063_buck_ops, \
+	.desc.min_uV = (min_mV) * 1000, \
+	.desc.uV_step = (step_mV) * 1000, \
+	.desc.n_voltages = ((max_mV) - (min_mV))/(step_mV) + 1, \
+	.current_limits = limits_array, \
+	.n_current_limits = ARRAY_SIZE(limits_array)
+
+#define DA9063_BUCK_COMMON_FIELDS(regl_name) \
+	.desc.enable_reg = DA9063_REG_##regl_name##_CONT, \
+	.desc.enable_mask = DA9063_BUCK_EN, \
+	.sleep = BFIELD(DA9063_REG_V##regl_name##_A, DA9063_BUCK_SL), \
+	.suspend_sleep = BFIELD(DA9063_REG_V##regl_name##_B, DA9063_BUCK_SL), \
+	.desc.vsel_reg = DA9063_REG_V##regl_name##_A, \
+	.desc.vsel_mask = DA9063_VBUCK_MASK, \
+	.desc.linear_min_sel = DA9063_VBUCK_BIAS, \
+	.suspend_vsel_reg = DA9063_REG_V##regl_name##_B, \
+	.mode = FIELD(DA9063_REG_##regl_name##_CFG, DA9063_BUCK_MODE_MASK, \
+		      DA9063_BUCK_MODE_SHIFT, 0)
+
+/* Defines asignment of regulators info table to chip model */
+struct da9063_dev_model {
+	const struct da9063_regulator_info	*regulator_info;
+	unsigned				n_regulators;
+	unsigned				dev_model;
+};
+
+/* Single regulator settings */
+struct da9063_regulator {
+	struct regulator_desc			desc;
+	struct regulator_dev			*rdev;
+	struct da9063				*hw;
+	const struct da9063_regulator_info	*info;
+
+	unsigned				mode;
+	unsigned				suspend_mode;
+};
+
+/* Encapsulates all information for the regulators driver */
+struct da9063_regulators {
+	int					irq_ldo_lim;
+	int					irq_uvov;
+
+	unsigned				n_regulators;
+	/* Array size to be defined during init. Keep at end. */
+	struct da9063_regulator			regulator[0];
+};
+
+/* System states for da9063_update_mode_internal()
+   and for da9063_get_mode_internal() */
+enum {
+	SYS_STATE_NORMAL,
+	SYS_STATE_SUSPEND,
+	SYS_STATE_CURRENT
+};
+
+/* BUCK modes for DA9063 */
+enum {
+	BUCK_MODE_MANUAL,	/* 0 */
+	BUCK_MODE_SLEEP,	/* 1 */
+	BUCK_MODE_SYNC,		/* 2 */
+	BUCK_MODE_AUTO		/* 3 */
+};
+
+/* Regulator operations */
+static int da9063_set_current_limit(struct regulator_dev *rdev,
+				    int min_uA, int max_uA);
+static int da9063_get_current_limit(struct regulator_dev *rdev);
+static int da9063_enable(struct regulator_dev *rdev);
+static int da9063_set_mode(struct regulator_dev *rdev, unsigned int mode);
+static unsigned da9063_get_mode(struct regulator_dev *rdev);
+static int da9063_get_status(struct regulator_dev *rdev);
+static int da9063_set_suspend_voltage(struct regulator_dev *rdev, int uV);
+static int da9063_suspend_enable(struct regulator_dev *rdev);
+static int da9063_set_suspend_mode(struct regulator_dev *rdev, unsigned mode);
+
+static struct regulator_ops da9063_switch_ops = {
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.set_suspend_enable	= regulator_enable_regmap,
+	.set_suspend_disable	= regulator_disable_regmap,
+};
+
+static struct regulator_ops da9063_ldo_ops = {
+	.enable			= da9063_enable,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+	.set_mode		= da9063_set_mode,
+	.get_mode		= da9063_get_mode,
+	.get_status		= da9063_get_status,
+	.set_suspend_voltage	= da9063_set_suspend_voltage,
+	.set_suspend_enable	= da9063_suspend_enable,
+	.set_suspend_disable	= regulator_disable_regmap,
+	.set_suspend_mode	= da9063_set_suspend_mode,
+};
+
+static struct regulator_ops da9063_buck_ops = {
+	.enable			= da9063_enable,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+	.set_current_limit	= da9063_set_current_limit,
+	.get_current_limit	= da9063_get_current_limit,
+	.set_mode		= da9063_set_mode,
+	.get_mode		= da9063_get_mode,
+	.get_status		= da9063_get_status,
+	.set_suspend_voltage	= da9063_set_suspend_voltage,
+	.set_suspend_enable	= da9063_suspend_enable,
+	.set_suspend_disable	= regulator_disable_regmap,
+	.set_suspend_mode	= da9063_set_suspend_mode,
+};
+
+/* Current limits array (in uA) for BCORE1, BCORE2, BPRO.
+   Entry indexes corresponds to register values. */
+static const int da9063_buck_a_limits[] = {
+	 500000,  600000,  700000,  800000,  900000, 1000000, 1100000, 1200000,
+	1300000, 1400000, 1500000, 1600000, 1700000, 1800000, 1900000, 2000000
+};
+
+/* Current limits array (in uA) for BMEM, BIO, BPERI.
+   Entry indexes corresponds to register values. */
+static const int da9063_buck_b_limits[] = {
+	1500000, 1600000, 1700000, 1800000, 1900000, 2000000, 2100000, 2200000,
+	2300000, 2400000, 2500000, 2600000, 2700000, 2800000, 2900000, 3000000
+};
+
+/* Current limits array (in uA) for merged BCORE1 and BCORE2.
+   Entry indexes corresponds to register values. */
+static const int da9063_bcores_merged_limits[] = {
+	1000000, 1200000, 1400000, 1600000, 1800000, 2000000, 2200000, 2400000,
+	2600000, 2800000, 3000000, 3200000, 3400000, 3600000, 3800000, 4000000
+};
+
+/* Current limits array (in uA) for merged BMEM and BIO.
+   Entry indexes corresponds to register values. */
+static const int da9063_bmem_bio_merged_limits[] = {
+	3000000, 3200000, 3400000, 3600000, 3800000, 4000000, 4200000, 4400000,
+	4600000, 4800000, 5000000, 5200000, 5400000, 5600000, 5800000, 6000000
+};
+
+/* Info of regulators for DA9063 */
+static const struct da9063_regulator_info da9063_regulator_info[] = {
+	{
+		DA9063_BUCK(DA9063, BCORE1, 300, 10, 1570,
+			    da9063_buck_a_limits),
+		DA9063_BUCK_COMMON_FIELDS(BCORE1),
+		.suspend = BFIELD(DA9063_REG_DVC_1, DA9063_VBCORE1_SEL),
+		.ilimit = FIELD(DA9063_REG_BUCK_ILIM_C, DA9063_BCORE1_ILIM_MASK,
+				DA9063_BCORE1_ILIM_SHIFT, 0),
+	},
+	{
+		DA9063_BUCK(DA9063, BCORE2, 300, 10, 1570,
+			    da9063_buck_a_limits),
+		DA9063_BUCK_COMMON_FIELDS(BCORE2),
+		.suspend = BFIELD(DA9063_REG_DVC_1, DA9063_VBCORE2_SEL),
+
+		.ilimit = FIELD(DA9063_REG_BUCK_ILIM_C,
+				DA9063_BCORE2_ILIM_MASK,
+				DA9063_BCORE2_ILIM_SHIFT,
+				0),
+	},
+	{
+		DA9063_BUCK(DA9063, BPRO, 530, 10, 1800,
+			    da9063_buck_a_limits),
+		DA9063_BUCK_COMMON_FIELDS(BPRO),
+		.suspend = BFIELD(DA9063_REG_DVC_1, DA9063_VBPRO_SEL),
+		.ilimit = FIELD(DA9063_REG_BUCK_ILIM_B, DA9063_BPRO_ILIM_MASK,
+				DA9063_BPRO_ILIM_SHIFT, 0),
+	},
+	{
+		DA9063_BUCK(DA9063, BMEM, 800, 20, 3340,
+			    da9063_buck_b_limits),
+		DA9063_BUCK_COMMON_FIELDS(BMEM),
+		.suspend = BFIELD(DA9063_REG_DVC_1, DA9063_VBMEM_SEL),
+		.ilimit = FIELD(DA9063_REG_BUCK_ILIM_A, DA9063_BMEM_ILIM_MASK,
+				DA9063_BMEM_ILIM_SHIFT, 0),
+	},
+	{
+		DA9063_BUCK(DA9063, BIO, 800, 20, 3340,
+			    da9063_buck_b_limits),
+		DA9063_BUCK_COMMON_FIELDS(BIO),
+		.suspend = BFIELD(DA9063_REG_DVC_2, DA9063_VBIO_SEL),
+		.ilimit = FIELD(DA9063_REG_BUCK_ILIM_A, DA9063_BIO_ILIM_MASK,
+				DA9063_BIO_ILIM_SHIFT, 0),
+	},
+	{
+		DA9063_BUCK(DA9063, BPERI, 800, 20, 3340,
+			    da9063_buck_b_limits),
+		DA9063_BUCK_COMMON_FIELDS(BPERI),
+		.suspend = BFIELD(DA9063_REG_DVC_1, DA9063_VBPERI_SEL),
+		.ilimit = FIELD(DA9063_REG_BUCK_ILIM_B, DA9063_BPERI_ILIM_MASK,
+				DA9063_BPERI_ILIM_SHIFT, 0),
+	},
+	{
+		DA9063_BUCK(DA9063, BCORES_MERGED, 300, 10, 1570,
+			    da9063_bcores_merged_limits),
+		/* BCORES_MERGED uses the same register fields as BCORE1 */
+		DA9063_BUCK_COMMON_FIELDS(BCORE1),
+		.suspend = BFIELD(DA9063_REG_DVC_1, DA9063_VBCORE1_SEL),
+		.ilimit = FIELD(DA9063_REG_BUCK_ILIM_C, DA9063_BCORE1_ILIM_MASK,
+				DA9063_BCORE1_ILIM_SHIFT, 0),
+	},
+	{
+		DA9063_BUCK(DA9063, BMEM_BIO_MERGED, 800, 20, 3340,
+			    da9063_bmem_bio_merged_limits),
+		/* BMEM_BIO_MERGED uses the same register fields as BMEM */
+		DA9063_BUCK_COMMON_FIELDS(BMEM),
+		.suspend = BFIELD(DA9063_REG_DVC_1, DA9063_VBMEM_SEL),
+		.ilimit = FIELD(DA9063_REG_BUCK_ILIM_A, DA9063_BMEM_ILIM_MASK,
+				DA9063_BMEM_ILIM_SHIFT, 0),
+	},
+	{
+		DA9063_LDO(DA9063, LDO1, 600, 20, 1860),
+		DA9063_LDO_COMMON_FIELDS(LDO1),
+		.suspend = BFIELD(DA9063_REG_DVC_1, DA9063_VLDO1_SEL),
+	},
+	{
+		DA9063_LDO(DA9063, LDO2, 600, 20, 1860),
+		DA9063_LDO_COMMON_FIELDS(LDO2),
+		.suspend = BFIELD(DA9063_REG_DVC_1, DA9063_VLDO2_SEL),
+	},
+	{
+		DA9063_LDO(DA9063, LDO3, 900, 20, 3440),
+		DA9063_LDO_COMMON_FIELDS(LDO3),
+		.suspend = BFIELD(DA9063_REG_DVC_1, DA9063_VLDO3_SEL),
+		.oc_event = BFIELD(DA9063_REG_STATUS_D, DA9063_LDO3_LIM),
+	},
+	{
+		DA9063_LDO(DA9063, LDO4, 900, 20, 3440),
+		DA9063_LDO_COMMON_FIELDS(LDO4),
+		.suspend = BFIELD(DA9063_REG_DVC_2, DA9063_VLDO4_SEL),
+		.oc_event = BFIELD(DA9063_REG_STATUS_D, DA9063_LDO4_LIM),
+	},
+	{
+		DA9063_LDO(DA9063, LDO5, 900, 50, 3600),
+		DA9063_LDO_COMMON_FIELDS(LDO5),
+		.suspend = BFIELD(DA9063_REG_LDO5_CONT, DA9063_VLDO5_SEL),
+	},
+	{
+		DA9063_LDO(DA9063, LDO6, 900, 50, 3600),
+		DA9063_LDO_COMMON_FIELDS(LDO6),
+		.suspend = BFIELD(DA9063_REG_LDO6_CONT, DA9063_VLDO6_SEL),
+	},
+	{
+		DA9063_LDO(DA9063, LDO7, 900, 50, 3600),
+		DA9063_LDO_COMMON_FIELDS(LDO7),
+		.suspend = BFIELD(DA9063_REG_LDO7_CONT, DA9063_VLDO7_SEL),
+		.oc_event = BFIELD(DA9063_REG_STATUS_D, DA9063_LDO7_LIM),
+	},
+	{
+		DA9063_LDO(DA9063, LDO8, 900, 50, 3600),
+		DA9063_LDO_COMMON_FIELDS(LDO8),
+		.suspend = BFIELD(DA9063_REG_LDO8_CONT, DA9063_VLDO8_SEL),
+		.oc_event = BFIELD(DA9063_REG_STATUS_D, DA9063_LDO8_LIM),
+	},
+	{
+		DA9063_LDO(DA9063, LDO9, 950, 50, 3600),
+		DA9063_LDO_COMMON_FIELDS(LDO9),
+		.suspend = BFIELD(DA9063_REG_LDO9_CONT, DA9063_VLDO9_SEL),
+	},
+	{
+		DA9063_LDO(DA9063, LDO10, 900, 50, 3600),
+		DA9063_LDO_COMMON_FIELDS(LDO10),
+		.suspend = BFIELD(DA9063_REG_LDO10_CONT, DA9063_VLDO10_SEL),
+	},
+	{
+		DA9063_LDO(DA9063, LDO11, 900, 50, 3600),
+		DA9063_LDO_COMMON_FIELDS(LDO11),
+		.suspend = BFIELD(DA9063_REG_LDO11_CONT, DA9063_VLDO11_SEL),
+		.oc_event = BFIELD(DA9063_REG_STATUS_D, DA9063_LDO11_LIM),
+	},
+	{
+		DA9063_SWITCH(DA9063, 32K_OUT),
+		.desc.enable_reg = DA9063_REG_EN_32K,
+		.desc.enable_mask = DA9063_OUT_32K_EN,
+	},
+};
+
+/* Link chip model with regulators info table */
+static struct da9063_dev_model regulators_models[] = {
+	{
+		.regulator_info = da9063_regulator_info,
+		.n_regulators = ARRAY_SIZE(da9063_regulator_info),
+		.dev_model = PMIC_DA9063,
+	},
+	{ }
+};
+
+/*
+ * Regulator internal functions
+ */
+static int da9063_update_mode_internal(struct da9063_regulator *regl,
+				       int sys_state)
+{
+	const struct da9063_regulator_info *rinfo = regl->info;
+	unsigned val;
+	unsigned mode;
+	int ret;
+
+	if (sys_state == SYS_STATE_SUSPEND)
+		/* Get mode for regulator in suspend state */
+		mode = regl->suspend_mode;
+	else
+		/* Get mode for regulator in normal operation */
+		mode = regl->mode;
+
+	/* LDOs use sleep flags - one for normal and one for suspend state.
+	   For BUCKs single mode register field is used in normal and
+	   suspend state. */
+	if (rinfo->mode.addr) {
+		/* Set mode for BUCK - 3 modes are supported */
+		switch (mode) {
+		case REGULATOR_MODE_FAST:
+			val = BUCK_MODE_SYNC;
+			break;
+		case REGULATOR_MODE_NORMAL:
+			val = BUCK_MODE_AUTO;
+			break;
+		case REGULATOR_MODE_STANDBY:
+			val = BUCK_MODE_SLEEP;
+			break;
+		default:
+			return -EINVAL;
+		}
+		val = val << rinfo->mode.shift;
+
+		ret = regmap_update_bits(regl->hw->regmap, rinfo->mode.addr,
+					 rinfo->mode.mask, val);
+	} else {
+		/* Set mode for LDO - 2 modes are supported */
+		switch (mode) {
+		case REGULATOR_MODE_NORMAL:
+			val = 0;
+			break;
+		case REGULATOR_MODE_STANDBY:
+			val = DA9063_LDO_SL;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		if (sys_state == SYS_STATE_SUSPEND) {
+			if (!rinfo->suspend_sleep.addr)
+				return -EINVAL;
+			ret = regmap_update_bits(regl->hw->regmap,
+						 rinfo->suspend_sleep.addr,
+						 rinfo->suspend_sleep.mask,
+						 val);
+		} else {
+			if (!rinfo->sleep.addr)
+				return -EINVAL;
+			ret = regmap_update_bits(regl->hw->regmap,
+						 rinfo->sleep.addr,
+						 rinfo->sleep.mask, val);
+		}
+	}
+
+	return ret;
+}
+
+static unsigned da9063_get_mode_internal(struct da9063_regulator *regl,
+					 int sys_state)
+{
+	const struct da9063_regulator_info *rinfo = regl->info;
+	int addr, mask, ret, val;
+	unsigned mode = 0;
+
+	/* Bucks use single mode register field for normal operation
+	   and suspend state. LDOs use sleep flags - one for normal
+	   and one for suspend state. */
+	if (rinfo->mode.addr) {
+		/* For BUCKs, there are 3 modes to map to */
+		ret = regmap_read(regl->hw->regmap, rinfo->mode.addr, &val);
+		if (ret < 0)
+			return ret;
+
+		val = (val & rinfo->mode.mask) >> rinfo->mode.shift;
+		switch (val) {
+		default:
+		case BUCK_MODE_MANUAL:
+			mode = REGULATOR_MODE_FAST | REGULATOR_MODE_STANDBY;
+			/* Sleep flag bit decides the mode */
+			break;
+		case BUCK_MODE_SLEEP:
+			return REGULATOR_MODE_STANDBY;
+		case BUCK_MODE_SYNC:
+			return REGULATOR_MODE_FAST;
+		case BUCK_MODE_AUTO:
+			return REGULATOR_MODE_NORMAL;
+		}
+	} else if (rinfo->sleep.addr) {
+		/* For LDOs there are 2 modes to map to */
+		mode = REGULATOR_MODE_NORMAL | REGULATOR_MODE_STANDBY;
+		/* Sleep flag bit decides the mode */
+	} else {
+		/* No support */
+		return 0;
+	}
+
+	/* If sys_state == SYS_STATE_CURRENT, current regulator state
+	   is detected. */
+	if (sys_state == SYS_STATE_CURRENT && rinfo->suspend.addr) {
+		ret = regmap_read(regl->hw->regmap, rinfo->suspend.addr, &val);
+		if (ret < 0)
+			return ret;
+
+		if (val & rinfo->suspend.mask)
+			sys_state = SYS_STATE_SUSPEND;
+		else
+			sys_state = SYS_STATE_NORMAL;
+	}
+
+	/* Read regulator mode from proper register,
+	   depending on selected system state */
+	if (sys_state == SYS_STATE_SUSPEND && rinfo->suspend_sleep.addr) {
+		addr = rinfo->suspend_sleep.addr;
+		mask = rinfo->suspend_sleep.mask;
+	} else {
+		addr = rinfo->sleep.addr;
+		mask = rinfo->sleep.mask;
+	}
+
+	ret = regmap_read(regl->hw->regmap, addr, &val);
+	if (ret < 0)
+		return ret;
+
+	if (val & mask)
+		mode &= REGULATOR_MODE_STANDBY;
+	else
+		mode &= REGULATOR_MODE_NORMAL | REGULATOR_MODE_FAST;
+
+	return mode;
+}
+
+static int da9063_set_current_limit(struct regulator_dev *rdev,
+							int min_uA, int max_uA)
+{
+	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
+	const struct da9063_regulator_info *rinfo = regl->info;
+	int val = INT_MAX;
+	unsigned sel = 0;
+	int n;
+	int tval;
+
+	if (!rinfo->current_limits)
+		return -EINVAL;
+
+	for (n = 0; n < rinfo->n_current_limits; n++) {
+		tval = rinfo->current_limits[n];
+		if (tval >= min_uA && tval <= max_uA && val > tval) {
+			val = tval;
+			sel = n;
+		}
+	}
+	if (val == INT_MAX)
+		return -EINVAL;
+
+	sel = (sel + rinfo->ilimit.offset) << rinfo->ilimit.shift;
+	return regmap_update_bits(regl->hw->regmap, rinfo->ilimit.addr,
+						rinfo->ilimit.mask, sel);
+}
+
+static int da9063_get_current_limit(struct regulator_dev *rdev)
+{
+	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
+	const struct da9063_regulator_info *rinfo = regl->info;
+	int ret, sel;
+
+	ret = regmap_read(regl->hw->regmap, rinfo->ilimit.addr, &sel);
+	if (ret < 0)
+		return ret;
+
+	sel = (sel & rinfo->ilimit.mask) >> rinfo->ilimit.shift;
+	sel -= rinfo->ilimit.offset;
+	if (sel < 0)
+		sel = 0;
+	if (sel >= rinfo->n_current_limits)
+		sel = rinfo->n_current_limits - 1;
+
+	return rinfo->current_limits[sel];
+}
+
+static int da9063_enable(struct regulator_dev *rdev)
+{
+	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
+	int ret;
+
+	if (regl->info->suspend.mask) {
+		/* Make sure to exit from suspend mode on enable */
+		ret = regmap_update_bits(regl->hw->regmap,
+					 regl->info->suspend.addr,
+					 regl->info->suspend.mask, 0);
+		if (ret < 0)
+			return ret;
+
+		/* BUCKs need mode update after wake-up from suspend state. */
+		ret = da9063_update_mode_internal(regl, SYS_STATE_NORMAL);
+		if (ret < 0)
+			return ret;
+	}
+
+	return regulator_enable_regmap(rdev);
+}
+
+static int da9063_set_mode(struct regulator_dev *rdev, unsigned mode)
+{
+	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
+	unsigned orig_mode = regl->mode;
+	int ret;
+
+	regl->mode = mode;
+	ret = da9063_update_mode_internal(regl, SYS_STATE_NORMAL);
+	if (ret)
+		regl->mode = orig_mode;
+
+	return ret;
+}
+
+static unsigned da9063_get_mode(struct regulator_dev *rdev)
+{
+	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
+
+	return da9063_get_mode_internal(regl, SYS_STATE_CURRENT);
+}
+
+static int da9063_get_status(struct regulator_dev *rdev)
+{
+	int ret = regulator_is_enabled_regmap(rdev);
+
+	if (ret == 0) {
+		ret = REGULATOR_STATUS_OFF;
+	} else if (ret > 0) {
+		ret = da9063_get_mode(rdev);
+		if (ret > 0)
+			ret = regulator_mode_to_status(ret);
+		else if (ret == 0)
+			ret = -EIO;
+	}
+
+	return ret;
+}
+
+static int da9063_set_suspend_voltage(struct regulator_dev *rdev, int uV)
+{
+	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
+	const struct da9063_regulator_info *rinfo = regl->info;
+	int ret, sel;
+
+	sel = regulator_map_voltage_linear(rdev, uV, uV);
+	if (sel < 0)
+		return -EINVAL;
+
+	sel <<= ffs(rdev->desc->vsel_mask) - 1;
+
+	ret = regmap_update_bits(regl->hw->regmap, rinfo->suspend_vsel_reg,
+				 rdev->desc->vsel_mask, sel);
+
+	return ret;
+}
+
+static int da9063_suspend_enable(struct regulator_dev *rdev)
+{
+	int ret;
+	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
+	const struct bfield *bsuspend = &regl->info->suspend;
+
+	ret = regmap_update_bits(regl->hw->regmap, bsuspend->addr,
+				 bsuspend->mask, bsuspend->mask);
+	return ret;
+}
+
+static int da9063_set_suspend_mode(struct regulator_dev *rdev, unsigned mode)
+{
+	struct da9063_regulator *regl = rdev_get_drvdata(rdev);
+	int ret;
+
+	regl->suspend_mode = mode;
+	ret = da9063_update_mode_internal(regl, SYS_STATE_SUSPEND);
+	return ret;
+}
+
+/* Regulator interrupt handlers */
+irqreturn_t da9063_ldo_lim_event(int irq, void *data)
+{
+	struct da9063_regulators *regulators = data;
+	struct da9063 *hw = regulators->regulator[0].hw;
+	struct da9063_regulator *regl;
+	int bits, i , ret;
+
+	ret = regmap_read(hw->regmap, DA9063_REG_STATUS_D, &bits);
+	if (ret < 0)
+		return IRQ_NONE;
+
+	for (i = regulators->n_regulators - 1; i >= 0; i--) {
+		regl = &regulators->regulator[i];
+		if (regl->info->oc_event.addr != DA9063_REG_STATUS_D)
+			continue;
+
+		if (regl->info->oc_event.mask & bits)
+			regulator_notifier_call_chain(regl->rdev,
+					REGULATOR_EVENT_OVER_CURRENT, NULL);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * Probing and Initialisation functions
+ */
+static const struct da9063_regulator_info *
+da9063_get_regl_info(const struct da9063 *da9063,
+		     const struct da9063_dev_model *model, int id)
+{
+	int m;
+
+	for (m = model->n_regulators - 1;
+	     model->regulator_info[m].desc.id != id; m--) {
+		if (m <= 0)
+			return NULL;
+	}
+	return &model->regulator_info[m];
+}
+
+#ifdef CONFIG_OF
+static struct of_regulator_match da9063_matches[] = {
+	[DA9063_ID_BCORE1]           = { .name = "bcore1"           },
+	[DA9063_ID_BCORE2]           = { .name = "bcore2"           },
+	[DA9063_ID_BPRO]             = { .name = "bpro",            },
+	[DA9063_ID_BMEM]             = { .name = "bmem",            },
+	[DA9063_ID_BIO]              = { .name = "bio",             },
+	[DA9063_ID_BPERI]            = { .name = "bperi",           },
+	[DA9063_ID_BCORES_MERGED]    = { .name = "bcores-merged"    },
+	[DA9063_ID_BMEM_BIO_MERGED]  = { .name = "bmem-bio-merged", },
+	[DA9063_ID_LDO1]             = { .name = "ldo1",            },
+	[DA9063_ID_LDO2]             = { .name = "ldo2",            },
+	[DA9063_ID_LDO3]             = { .name = "ldo3",            },
+	[DA9063_ID_LDO4]             = { .name = "ldo4",            },
+	[DA9063_ID_LDO5]             = { .name = "ldo5",            },
+	[DA9063_ID_LDO6]             = { .name = "ldo6",            },
+	[DA9063_ID_LDO7]             = { .name = "ldo7",            },
+	[DA9063_ID_LDO8]             = { .name = "ldo8",            },
+	[DA9063_ID_LDO9]             = { .name = "ldo9",            },
+	[DA9063_ID_LDO10]            = { .name = "ldo10",           },
+	[DA9063_ID_LDO11]            = { .name = "ldo11",           },
+	[DA9063_ID_32K_OUT]          = { .name = "32k-out",         },
+};
+
+static struct da9063_regulators_pdata *da9063_parse_regulators_dt(
+		struct platform_device *pdev,
+		struct of_regulator_match **da9063_reg_matches)
+{
+	struct da9063_regulators_pdata *pdata;
+	struct da9063_regulator_data *rdata;
+	struct device_node *node;
+	int i, n, num;
+
+	node = of_find_node_by_name(pdev->dev.parent->of_node, "regulators");
+	if (!node) {
+		dev_err(&pdev->dev, "Regulators device node not found\n");
+		return ERR_PTR(-ENODEV);
+	}
+
+	num = of_regulator_match(&pdev->dev, node, da9063_matches,
+				 ARRAY_SIZE(da9063_matches));
+	if (num < 0) {
+		dev_err(&pdev->dev, "Failed to match regulators\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	pdata->regulator_data = devm_kzalloc(&pdev->dev,
+					num * sizeof(*pdata->regulator_data),
+					GFP_KERNEL);
+	if (!pdata->regulator_data)
+		return ERR_PTR(-ENOMEM);
+	pdata->n_regulators = num;
+
+	n = 0;
+	for (i = 0; i < ARRAY_SIZE(da9063_matches); i++) {
+		if (!da9063_matches[i].init_data)
+			continue;
+
+		rdata = &pdata->regulator_data[n];
+		rdata->id = i;
+		rdata->initdata = da9063_matches[i].init_data;
+
+		n++;
+	};
+
+	*da9063_reg_matches = da9063_matches;
+	return pdata;
+}
+#else
+static struct da9063_regulators_pdata *da9063_parse_regulators_dt(
+		struct platform_device *pdev,
+		struct of_regulator_match **da9063_reg_matches)
+{
+	da9063_reg_matches = NULL;
+	return PTR_ERR(-ENODEV);
+}
+#endif
+
+static int da9063_regulator_probe(struct platform_device *pdev)
+{
+	struct da9063 *da9063 = dev_get_drvdata(pdev->dev.parent);
+	struct da9063_pdata *da9063_pdata = dev_get_platdata(da9063->dev);
+	struct of_regulator_match *da9063_reg_matches;
+	struct da9063_regulators_pdata *regl_pdata;
+	struct da9063_regulator_data *rdata;
+	const struct da9063_dev_model *model;
+	struct da9063_regulators *regulators;
+	struct da9063_regulator *regl;
+	struct regulator_config config;
+	bool bcores_merged, bmem_bio_merged;
+	int irq, n, ret, val;
+	size_t size;
+
+	regl_pdata = da9063_pdata ? da9063_pdata->regulators_pdata : NULL;
+
+	if (!regl_pdata)
+		regl_pdata = da9063_parse_regulators_dt(pdev,
+							&da9063_reg_matches);
+
+	if (IS_ERR(regl_pdata) || regl_pdata->n_regulators == 0) {
+		dev_err(&pdev->dev,
+			"No regulators defined for the platform\n");
+		return PTR_ERR(regl_pdata);
+	}
+
+	/* Find regulators set for particular device model */
+	for (model = regulators_models; model->regulator_info; model++) {
+		if (model->dev_model == da9063_model(da9063))
+			break;
+	}
+	if (!model->regulator_info) {
+		dev_err(&pdev->dev, "Chip model not recognised (%u)\n",
+			da9063_model(da9063));
+		return -ENODEV;
+	}
+
+	ret = regmap_read(da9063->regmap, DA9063_REG_CONFIG_H, &val);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Error while reading BUCKs configuration\n");
+		return -EIO;
+	}
+	bcores_merged = val & DA9063_BCORE_MERGE;
+	bmem_bio_merged = val & DA9063_BUCK_MERGE;
+
+	/* Allocate memory required by usable regulators */
+	size = sizeof(struct da9063_regulators) +
+		regl_pdata->n_regulators * sizeof(struct da9063_regulator);
+	regulators = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	if (!regulators) {
+		dev_err(&pdev->dev, "No memory for regulators\n");
+		return -ENOMEM;
+	}
+
+	regulators->n_regulators = regl_pdata->n_regulators;
+	platform_set_drvdata(pdev, regulators);
+
+	/* Register all regulators declared in platform information */
+	n = 0;
+	while (n < regulators->n_regulators) {
+		rdata = &regl_pdata->regulator_data[n];
+
+		/* Check regulator ID against merge mode configuration */
+		switch (rdata->id) {
+		case DA9063_ID_BCORE1:
+		case DA9063_ID_BCORE2:
+			if (bcores_merged) {
+				dev_err(&pdev->dev,
+					"Cannot use BCORE1 and BCORE2 separately, when in merge mode\n");
+				ret = -EINVAL;
+				goto err;
+			}
+			break;
+		case DA9063_ID_BMEM:
+		case DA9063_ID_BIO:
+			if (bmem_bio_merged) {
+				dev_err(&pdev->dev,
+					"Cannot use BMEM and BIO separately, when in merge mode\n");
+				ret = -EINVAL;
+				goto err;
+			}
+			break;
+		case DA9063_ID_BCORES_MERGED:
+			if (!bcores_merged) {
+				dev_err(&pdev->dev,
+					"BCORE1 and BCORE2 are unavailable in merge mode\n");
+				ret = -EINVAL;
+				goto err;
+			}
+			break;
+		case DA9063_ID_BMEM_BIO_MERGED:
+			if (!bmem_bio_merged) {
+				dev_err(&pdev->dev,
+					"BMEM and BIO are unavailable in merge mode\n");
+				ret = -EINVAL;
+				goto err;
+			}
+			break;
+		}
+
+		/* Initialise regulator structure */
+		regl = &regulators->regulator[n];
+		regl->hw = da9063;
+		regl->info = da9063_get_regl_info(da9063, model, rdata->id);
+		if (!regl->info) {
+			dev_err(&pdev->dev,
+				"Invalid regulator ID in platform data\n");
+			ret = -EINVAL;
+			goto err;
+		}
+		regl->desc = regl->info->desc;
+		regl->desc.type = REGULATOR_VOLTAGE;
+		regl->desc.owner = THIS_MODULE;
+
+		/* Get current modes of operation (A/B voltage selection)
+		   for normal and suspend states */
+		ret = da9063_get_mode_internal(regl, SYS_STATE_NORMAL);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"Failed to read %s regulator's mode\n",
+				regl->desc.name);
+			goto err;
+		}
+		if (ret == 0)
+			regl->mode = REGULATOR_MODE_NORMAL;
+		else
+			regl->mode = ret;
+
+		ret = da9063_get_mode_internal(regl, SYS_STATE_SUSPEND);
+		if (ret < 0) {
+			dev_err(&pdev->dev,
+				"Failed to read %s regulator's mode\n",
+				regl->desc.name);
+			goto err;
+		}
+		if (ret == 0)
+			regl->suspend_mode = REGULATOR_MODE_NORMAL;
+		else
+			regl->suspend_mode = ret;
+
+		/* Register regulator */
+		config.dev = &pdev->dev;
+		config.init_data = rdata->initdata;
+		config.driver_data = regl;
+		config.regmap = da9063->regmap;
+		if (da9063_reg_matches)
+			config.of_node = da9063_reg_matches[rdata->id].of_node;
+		regl->rdev = regulator_register(&regl->desc, &config);
+		if (IS_ERR_OR_NULL(regl->rdev)) {
+			dev_err(&pdev->dev,
+				"Failed to register %s regulator\n",
+				regl->desc.name);
+			ret = PTR_ERR(regl->rdev);
+			goto err;
+		}
+		n++;
+	}
+
+	/* LDOs overcurrent event support */
+	irq = platform_get_irq_byname(pdev, "LDO_LIM");
+	if (irq < 0) {
+		ret = irq;
+		dev_err(&pdev->dev, "Failed to get IRQ.\n");
+		goto err;
+	}
+
+	regulators->irq_ldo_lim = regmap_irq_get_virq(da9063->regmap_irq, irq);
+	if (regulators->irq_ldo_lim >= 0) {
+		ret = request_threaded_irq(regulators->irq_ldo_lim,
+					   NULL, da9063_ldo_lim_event,
+					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					   "LDO_LIM", regulators);
+		if (ret) {
+			dev_err(&pdev->dev,
+					"Failed to request LDO_LIM IRQ.\n");
+			regulators->irq_ldo_lim = -ENXIO;
+		}
+	}
+
+	return 0;
+
+err:
+	/* Wind back regulators registeration */
+	while (--n >= 0)
+		regulator_unregister(regulators->regulator[n].rdev);
+
+	return ret;
+}
+
+static int da9063_regulator_remove(struct platform_device *pdev)
+{
+	struct da9063_regulators *regulators = platform_get_drvdata(pdev);
+	struct da9063_regulator *regl;
+
+	free_irq(regulators->irq_ldo_lim, regulators);
+	free_irq(regulators->irq_uvov, regulators);
+
+	for (regl = &regulators->regulator[regulators->n_regulators - 1];
+	     regl >= &regulators->regulator[0]; regl--)
+		regulator_unregister(regl->rdev);
+
+	return 0;
+}
+
+static struct platform_driver da9063_regulator_driver = {
+	.driver = {
+		.name = DA9063_DRVNAME_REGULATORS,
+		.owner = THIS_MODULE,
+	},
+	.probe = da9063_regulator_probe,
+	.remove = da9063_regulator_remove,
+};
+
+static int __init da9063_regulator_init(void)
+{
+	return platform_driver_register(&da9063_regulator_driver);
+}
+subsys_initcall(da9063_regulator_init);
+
+static void __exit da9063_regulator_cleanup(void)
+{
+	platform_driver_unregister(&da9063_regulator_driver);
+}
+module_exit(da9063_regulator_cleanup);
+
+
+/* Module information */
+MODULE_AUTHOR("Krystian Garbaciak <krystian.garbaciak@diasemi.com>");
+MODULE_DESCRIPTION("DA9063 regulators driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("paltform:" DA9063_DRVNAME_REGULATORS);
-- 
1.8.3.2

