Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaBKNnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:43:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38280 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaBKNnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:43:50 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Anson Huang <b20788@freescale.com>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 1/2] regulator: anatop: Add power gating support to digital LDOs
Date: Tue, 11 Feb 2014 14:43:44 +0100
Message-Id: <1392126225-7017-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM, PU, and SOC LDOs in the i.MX6 PMU can completely gate
their power output. Since power gating is configured by writing
zero to the voltage target bitfield,, store a copy of the
voltage selector to be restored when reenabling the regulator.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v2:
 - Rebased against v3.14-rc2, the anatop_probe_end jump label
   was removed.
---
 drivers/regulator/anatop-regulator.c | 76 +++++++++++++++++++++++++++++++++++-
 1 file changed, 74 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 862e63e..dff120a 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -34,6 +34,8 @@
 #define LDO_RAMP_UP_UNIT_IN_CYCLES      64 /* 64 cycles per step */
 #define LDO_RAMP_UP_FREQ_IN_MHZ         24 /* cycle based on 24M OSC */
 
+#define LDO_POWER_GATE			0x00
+
 struct anatop_regulator {
 	const char *name;
 	u32 control_reg;
@@ -48,6 +50,7 @@ struct anatop_regulator {
 	int max_voltage;
 	struct regulator_desc rdesc;
 	struct regulator_init_data *initdata;
+	int sel;
 };
 
 static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
@@ -97,14 +100,68 @@ static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
 	return regulator_get_voltage_sel_regmap(reg);
 }
 
+static int anatop_regmap_enable(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+
+	return regulator_set_voltage_sel_regmap(reg, anatop_reg->sel);
+}
+
+static int anatop_regmap_disable(struct regulator_dev *reg)
+{
+	return regulator_set_voltage_sel_regmap(reg, LDO_POWER_GATE);
+}
+
+static int anatop_regmap_is_enabled(struct regulator_dev *reg)
+{
+	return regulator_get_voltage_sel_regmap(reg) != LDO_POWER_GATE;
+}
+
+static int anatop_regmap_core_set_voltage_sel(struct regulator_dev *reg,
+					      unsigned selector)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	int ret;
+
+	if (!anatop_regmap_is_enabled(reg)) {
+		anatop_reg->sel = selector;
+		return 0;
+	}
+
+	ret = regulator_set_voltage_sel_regmap(reg, selector);
+	if (!ret)
+		anatop_reg->sel = selector;
+	return ret;
+}
+
+static int anatop_regmap_core_get_voltage_sel(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+
+	if (!anatop_regmap_is_enabled(reg))
+		return anatop_reg->sel;
+
+	return regulator_get_voltage_sel_regmap(reg);
+}
+
 static struct regulator_ops anatop_rops = {
 	.set_voltage_sel = anatop_regmap_set_voltage_sel,
-	.set_voltage_time_sel = anatop_regmap_set_voltage_time_sel,
 	.get_voltage_sel = anatop_regmap_get_voltage_sel,
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
 };
 
+static struct regulator_ops anatop_core_rops = {
+	.enable = anatop_regmap_enable,
+	.disable = anatop_regmap_disable,
+	.is_enabled = anatop_regmap_is_enabled,
+	.set_voltage_sel = anatop_regmap_core_set_voltage_sel,
+	.set_voltage_time_sel = anatop_regmap_set_voltage_time_sel,
+	.get_voltage_sel = anatop_regmap_core_get_voltage_sel,
+	.list_voltage = regulator_list_voltage_linear,
+	.map_voltage = regulator_map_voltage_linear,
+};
+
 static int anatop_regulator_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -116,6 +173,7 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	struct regulator_init_data *initdata;
 	struct regulator_config config = { };
 	int ret = 0;
+	u32 val;
 
 	initdata = of_get_regulator_init_data(dev, np);
 	sreg = devm_kzalloc(dev, sizeof(*sreg), GFP_KERNEL);
@@ -125,7 +183,6 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	sreg->name = of_get_property(np, "regulator-name", NULL);
 	rdesc = &sreg->rdesc;
 	rdesc->name = sreg->name;
-	rdesc->ops = &anatop_rops;
 	rdesc->type = REGULATOR_VOLTAGE;
 	rdesc->owner = THIS_MODULE;
 
@@ -197,6 +254,21 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	config.of_node = pdev->dev.of_node;
 	config.regmap = sreg->anatop;
 
+	/* Only core regulators have the ramp up delay configuration. */
+	if (sreg->control_reg && sreg->delay_bit_width) {
+		rdesc->ops = &anatop_core_rops;
+
+		ret = regmap_read(config.regmap, rdesc->vsel_reg, &val);
+		if (ret) {
+			dev_err(dev, "failed to read initial state\n");
+			return ret;
+		}
+
+		sreg->sel = (val & rdesc->vsel_mask) >> sreg->vol_bit_shift;
+	} else {
+		rdesc->ops = &anatop_rops;
+	}
+
 	/* register regulator */
 	rdev = devm_regulator_register(dev, rdesc, &config);
 	if (IS_ERR(rdev)) {
-- 
1.8.5.3

