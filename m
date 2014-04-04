Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaDDS53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:57:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59330 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbaDDSpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:45:42 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@kernel.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Matt Wagantall <mattw@codeaurora.org>
Subject: [PATCH 1/4] clk: qcom: Add support for GDSCs
Date: Fri,  4 Apr 2014 11:45:33 -0700
Message-Id: <1396637136-29974-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1396637136-29974-1-git-send-email-sboyd@codeaurora.org>
References: <1396637136-29974-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GDSCs (Global Distributed Switch Controllers) are responsible for
safely collapsing and restoring power to peripherals in the SoC.
Add support for these controllers to the clock driver as the
registers are scattered throughout the clock controller register
space.

This is largely based on code originally written by Matt
Wagantall[1].

[1] https://www.codeaurora.org/cgit/quic/la/kernel/msm/tree/arch/arm/mach-msm/gdsc.c?h=msm-3.4
Cc: Matt Wagantall <mattw@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/clk/qcom/Makefile |   1 +
 drivers/clk/qcom/gdsc.c   | 361 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/clk/qcom/gdsc.h   |  32 ++++
 3 files changed, 394 insertions(+)
 create mode 100644 drivers/clk/qcom/gdsc.c
 create mode 100644 drivers/clk/qcom/gdsc.h

diff --git a/drivers/clk/qcom/Makefile b/drivers/clk/qcom/Makefile
index f60db2ef1aee..2bc09576990a 100644
--- a/drivers/clk/qcom/Makefile
+++ b/drivers/clk/qcom/Makefile
@@ -6,6 +6,7 @@ clk-qcom-y += clk-rcg.o
 clk-qcom-y += clk-rcg2.o
 clk-qcom-y += clk-branch.o
 clk-qcom-y += reset.o
+clk-qcom-y += gdsc.o
 
 obj-$(CONFIG_MSM_GCC_8660) += gcc-msm8660.o
 obj-$(CONFIG_MSM_GCC_8960) += gcc-msm8960.o
diff --git a/drivers/clk/qcom/gdsc.c b/drivers/clk/qcom/gdsc.c
new file mode 100644
index 000000000000..a885fe4bdf38
--- /dev/null
+++ b/drivers/clk/qcom/gdsc.c
@@ -0,0 +1,361 @@
+/*
+ * Copyright (c) 2012-2014, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/of.h>
+#include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
+#include <linux/regulator/of_regulator.h>
+#include <linux/slab.h>
+#include <linux/reset-controller.h>
+#include <linux/regmap.h>
+
+#include "gdsc.h"
+
+#define PWR_ON_MASK		BIT(31)
+#define EN_REST_WAIT_MASK	(0xF << 20)
+#define EN_FEW_WAIT_MASK	(0xF << 16)
+#define CLK_DIS_WAIT_MASK	(0xF << 12)
+#define SW_OVERRIDE_MASK	BIT(2)
+#define HW_CONTROL_MASK		BIT(1)
+#define SW_COLLAPSE_MASK	BIT(0)
+
+/* Wait 2^n CXO cycles between all states. Here, n=2 (4 cycles). */
+#define EN_REST_WAIT_VAL	(0x2 << 20)
+#define EN_FEW_WAIT_VAL		(0x8 << 16)
+#define CLK_DIS_WAIT_VAL	(0x2 << 12)
+
+#define RETAIN_MEM		BIT(14)
+#define RETAIN_PERIPH		BIT(13)
+
+#define TIMEOUT_US		100
+
+struct gdsc {
+	struct regulator_dev	*rdev;
+	struct regulator_desc	rdesc;
+	struct reset_controller_dev *rcdev;
+	struct regmap		*regmap;
+	u32			gdscr;
+	unsigned int		*cxcs;
+	int			cxc_count;
+	unsigned int		*resets;
+	int			reset_count;
+	bool			toggle_mem;
+	bool			toggle_periph;
+	bool			toggle_logic;
+	bool			resets_asserted;
+};
+
+static int gdsc_is_enabled(struct regulator_dev *rdev)
+{
+	unsigned int val;
+	struct gdsc *sc = rdev_get_drvdata(rdev);
+
+	if (!sc->toggle_logic)
+		return !sc->resets_asserted;
+
+	regmap_read(sc->regmap, sc->gdscr, &val);
+	return !!(val & PWR_ON_MASK);
+}
+
+static int gdsc_poll_enable(struct gdsc *sc, bool en)
+{
+	unsigned long timeout;
+	unsigned int val;
+	unsigned int check = en ? PWR_ON_MASK : 0;
+
+	timeout = jiffies + usecs_to_jiffies(TIMEOUT_US);
+	do {
+		regmap_read(sc->regmap, sc->gdscr, &val);
+		if ((val & PWR_ON_MASK) == check)
+			return 0;
+	} while (time_before(jiffies, timeout));
+
+	regmap_read(sc->regmap, sc->gdscr, &val);
+	if ((val & PWR_ON_MASK) == check)
+		return 0;
+
+	pr_err("%s %s timed out\n", en ? "enabling" : "disabling",
+	       sc->rdesc.name);
+	return -ETIMEDOUT;
+}
+
+static int gdsc_toggle_logic(struct gdsc *sc, bool en)
+{
+	int ret;
+	u32 val;
+
+	regmap_read(sc->regmap, sc->gdscr, &val);
+	if (val & HW_CONTROL_MASK) {
+		dev_warn(&sc->rdev->dev,
+			"Invalid %s while %s is under HW control\n",
+			en ? "enable" : "disable", sc->rdesc.name);
+		return -EBUSY;
+	}
+
+	val = en ? 0 : SW_COLLAPSE_MASK;
+	ret = regmap_update_bits(sc->regmap, sc->gdscr, SW_COLLAPSE_MASK, val);
+	if (ret)
+		return ret;
+
+	return gdsc_poll_enable(sc, en);
+}
+
+static int gdsc_enable(struct regulator_dev *rdev)
+{
+	struct gdsc *sc = rdev_get_drvdata(rdev);
+	u32 mask;
+	int i, ret;
+
+	if (sc->toggle_logic) {
+		ret = gdsc_toggle_logic(sc, true);
+		if (ret)
+			return ret;
+	} else {
+		for (i = 0; i < sc->reset_count; i++)
+			sc->rcdev->ops->deassert(sc->rcdev, sc->resets[i]);
+		sc->resets_asserted = false;
+	}
+
+
+	for (i = 0; i < sc->cxc_count; i++) {
+		mask = 0;
+		if (sc->toggle_mem) {
+			mask |= RETAIN_MEM;
+			regmap_update_bits(sc->regmap, sc->cxcs[i], mask, mask);
+		}
+		udelay(1);
+		if (sc->toggle_periph) {
+			mask |= RETAIN_PERIPH;
+			regmap_update_bits(sc->regmap, sc->cxcs[i], mask, mask);
+		}
+	}
+
+	/*
+	 * If clocks to this power domain were already on, they will take an
+	 * additional 4 clock cycles to re-enable after the rail is enabled.
+	 * Delay to account for this. A delay is also needed to ensure clocks
+	 * are not enabled within 400ns of enabling power to the memories.
+	 */
+	udelay(1);
+
+	return 0;
+}
+
+static int gdsc_disable(struct regulator_dev *rdev)
+{
+	struct gdsc *sc = rdev_get_drvdata(rdev);
+	u32 mask = 0;
+	int i, ret = 0;
+
+	if (sc->toggle_mem)
+		mask |= RETAIN_MEM;
+	if (sc->toggle_periph)
+		mask |= RETAIN_PERIPH;
+
+	for (i = sc->cxc_count - 1; i >= 0; i--)
+		regmap_update_bits(sc->regmap, sc->cxcs[i], mask, 0);
+
+	if (sc->toggle_logic) {
+		ret = gdsc_toggle_logic(sc, false);
+		if (ret)
+			return ret;
+	} else {
+		for (i = sc->reset_count - 1; i >= 0; i--)
+			sc->rcdev->ops->assert(sc->rcdev, sc->resets[i]);
+		sc->resets_asserted = true;
+	}
+
+	return ret;
+}
+
+static unsigned int gdsc_get_mode(struct regulator_dev *rdev)
+{
+	struct gdsc *sc = rdev_get_drvdata(rdev);
+	unsigned int val;
+
+	regmap_read(sc->regmap, sc->gdscr, &val);
+	if (val & HW_CONTROL_MASK)
+		return REGULATOR_MODE_FAST;
+	return REGULATOR_MODE_NORMAL;
+}
+
+static int gdsc_set_mode(struct regulator_dev *rdev, unsigned int mode)
+{
+	struct gdsc *sc = rdev_get_drvdata(rdev);
+	unsigned int val;
+	int ret;
+
+	regmap_read(sc->regmap, sc->gdscr, &val);
+
+	/*
+	 * HW control can only be enable/disabled when SW_COLLAPSE
+	 * indicates on.
+	 */
+	if (val & SW_COLLAPSE_MASK) {
+		dev_err(&rdev->dev, "can't enable hw collapse now\n");
+		return -EBUSY;
+	}
+
+	switch (mode) {
+	case REGULATOR_MODE_FAST:
+		/* Turn on HW trigger mode */
+		val |= HW_CONTROL_MASK;
+		regmap_write(sc->regmap, sc->gdscr, val);
+		/*
+		 * There may be a race with internal HW trigger signal,
+		 * that will result in GDSC going through a power down and
+		 * up cycle.  In case HW trigger signal is controlled by
+		 * firmware that also poll same status bits as we do, FW
+		 * might read an 'on' status before the GDSC can finish
+		 * power cycle.  We wait 1us before returning to ensure
+		 * FW can't immediately poll the status bit.
+		 */
+		mb();
+		udelay(1);
+		break;
+
+	case REGULATOR_MODE_NORMAL:
+		/* Turn off HW trigger mode */
+		val &= ~HW_CONTROL_MASK;
+		regmap_write(sc->regmap, sc->gdscr, val);
+		/*
+		 * There may be a race with internal HW trigger signal,
+		 * that will result in GDSC going through a power down and
+		 * up cycle.  If we poll too early, status bit will
+		 * indicate 'on' before the GDSC can finish the power cycle.
+		 * Account for this case by waiting 1us before polling.
+		 */
+		mb();
+		udelay(1);
+		ret = gdsc_poll_enable(sc, true);
+		if (ret) {
+			dev_err(&rdev->dev, "%s set_mode timed out\n",
+				sc->rdesc.name);
+			return ret;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct regulator_ops gdsc_ops = {
+	.is_enabled = gdsc_is_enabled,
+	.enable = gdsc_enable,
+	.disable = gdsc_disable,
+	.set_mode = gdsc_set_mode,
+	.get_mode = gdsc_get_mode,
+};
+
+int gdsc_register(struct device *pdev, struct of_regulator_match *match,
+		  struct reset_controller_dev *rcdev)
+{
+	static atomic_t gdsc_count = ATOMIC_INIT(-1);
+	struct regulator_config reg_config = {};
+	struct regulator_init_data *init_data;
+	struct gdsc *sc;
+	unsigned int val, mask;
+	bool retain_mem, retain_periph, support_hw_trigger;
+	int i, ret;
+	struct device_node *np;
+	struct gdsc_desc *desc;
+
+	sc = devm_kzalloc(pdev, sizeof(*sc), GFP_KERNEL);
+	if (!sc)
+		return -ENOMEM;
+
+	np = match->of_node;
+	desc = match->driver_data;
+	init_data = match->init_data;
+
+	if (of_get_property(np, "parent-supply", NULL))
+		init_data->supply_regulator = "parent";
+
+	ret = of_property_read_string(np, "regulator-name", &sc->rdesc.name);
+	if (ret)
+		return ret;
+
+	sc->regmap = dev_get_regmap(pdev, NULL);
+	sc->gdscr = desc->gdscr;
+	sc->cxcs = desc->cxcs;
+	sc->cxc_count = desc->cxc_count;
+	sc->resets = desc->resets;
+	sc->reset_count = desc->reset_count;
+	sc->rcdev = rcdev;
+
+	sc->rdesc.id = atomic_inc_return(&gdsc_count);
+	sc->rdesc.ops = &gdsc_ops;
+	sc->rdesc.type = REGULATOR_VOLTAGE;
+	sc->rdesc.owner = THIS_MODULE;
+
+	/*
+	 * Disable HW trigger: collapse/restore occur based on registers writes.
+	 * Disable SW override: Use hardware state-machine for sequencing.
+	 * Configure wait time between states.
+	 */
+	mask = HW_CONTROL_MASK | SW_OVERRIDE_MASK |
+	       EN_REST_WAIT_MASK | EN_FEW_WAIT_MASK | CLK_DIS_WAIT_MASK;
+	val = EN_REST_WAIT_VAL | EN_FEW_WAIT_VAL | CLK_DIS_WAIT_VAL;
+	regmap_update_bits(sc->regmap, sc->gdscr, mask, val);
+
+	retain_mem = of_property_read_bool(np, "qcom,retain-mem");
+	sc->toggle_mem = !retain_mem;
+	retain_periph = of_property_read_bool(np, "qcom,retain-periph");
+	sc->toggle_periph = !retain_periph;
+	sc->toggle_logic = !of_property_read_bool(np,
+						"qcom,skip-logic-collapse");
+	support_hw_trigger = of_property_read_bool(np,
+						    "qcom,support-hw-trigger");
+	if (support_hw_trigger) {
+		init_data->constraints.valid_ops_mask |= REGULATOR_CHANGE_MODE;
+		init_data->constraints.valid_modes_mask |=
+				REGULATOR_MODE_NORMAL | REGULATOR_MODE_FAST;
+	}
+
+	if (!sc->toggle_logic) {
+		ret = gdsc_toggle_logic(sc, true);
+		if (ret)
+			return ret;
+	}
+
+	regmap_read(sc->regmap, sc->gdscr, &val);
+	mask = RETAIN_MEM | RETAIN_PERIPH;
+	val = 0;
+	if (retain_mem || (val & PWR_ON_MASK))
+		val |= RETAIN_MEM;
+	if (retain_periph || (val & PWR_ON_MASK))
+		val |= RETAIN_PERIPH;
+
+	for (i = 0; i < sc->cxc_count; i++)
+		regmap_update_bits(sc->regmap, sc->cxcs[i], mask, val);
+
+	reg_config.dev = pdev;
+	reg_config.init_data = init_data;
+	reg_config.driver_data = sc;
+	reg_config.of_node = np;
+	sc->rdev = devm_regulator_register(pdev, &sc->rdesc, &reg_config);
+	if (IS_ERR(sc->rdev)) {
+		dev_err(pdev, "regulator_register(\"%s\") failed.\n",
+			sc->rdesc.name);
+		return PTR_ERR(sc->rdev);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(gdsc_register);
diff --git a/drivers/clk/qcom/gdsc.h b/drivers/clk/qcom/gdsc.h
new file mode 100644
index 000000000000..bd034c5071a9
--- /dev/null
+++ b/drivers/clk/qcom/gdsc.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2014, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __QCOM_GDSC_H__
+#define __QCOM_GDSC_H__
+
+struct device;
+struct device_node;
+struct of_regulator_match;
+
+struct gdsc_desc {
+	unsigned int gdscr;
+	unsigned int *cxcs;
+	int cxc_count;
+	unsigned int *resets;
+	int reset_count;
+};
+
+extern int gdsc_register(struct device *pdev, struct of_regulator_match *match,
+			 struct reset_controller_dev *rcdev);
+
+#endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

