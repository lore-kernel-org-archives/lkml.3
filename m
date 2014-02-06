Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaBFOnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:43:43 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46816 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaBFOnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:43:41 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Anson Huang <b20788@freescale.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 1/2] regulator: anatop: Add power gating support to digital LDOs
Date: Thu,  6 Feb 2014 15:43:32 +0100
Message-Id: <1391697813-20091-1-git-send-email-p.zabel@pengutronix.de>
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
 drivers/regulator/anatop-regulator.c | 59 +++++++++++++++++++++++++++++++++++-
 1 file changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index c734d09..93a6413 100644
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
@@ -48,17 +50,28 @@ struct anatop_regulator {
 	int max_voltage;
 	struct regulator_desc rdesc;
 	struct regulator_init_data *initdata;
+	int sel;
 };
 
+static inline bool anatop_is_core_reg(struct anatop_regulator *anatop_reg)
+{
+	/* Only core regulators have the ramp up delay configuration. */
+	return anatop_reg->delay_bit_width;
+}
+
 static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
 					unsigned selector)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	int ret;
 
 	if (!anatop_reg->control_reg)
 		return -ENOTSUPP;
 
-	return regulator_set_voltage_sel_regmap(reg, selector);
+	ret = regulator_set_voltage_sel_regmap(reg, selector);
+	if (!ret)
+		anatop_reg->sel = selector;
+	return ret;
 }
 
 static int anatop_regmap_set_voltage_time_sel(struct regulator_dev *reg,
@@ -97,7 +110,40 @@ static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
 	return regulator_get_voltage_sel_regmap(reg);
 }
 
+static int anatop_regmap_enable(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+
+	if (!anatop_is_core_reg(anatop_reg))
+		return 0;
+
+	return regulator_set_voltage_sel_regmap(reg, anatop_reg->sel);
+}
+
+static int anatop_regmap_disable(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+
+	if (!anatop_is_core_reg(anatop_reg))
+		return -ENOTSUPP;
+
+	return regulator_set_voltage_sel_regmap(reg, LDO_POWER_GATE);
+}
+
+static int anatop_regmap_is_enabled(struct regulator_dev *reg)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+
+	if (!anatop_is_core_reg(anatop_reg))
+		return 1;
+
+	return regulator_get_voltage_sel_regmap(reg) != LDO_POWER_GATE;
+}
+
 static struct regulator_ops anatop_rops = {
+	.enable = anatop_regmap_enable,
+	.disable = anatop_regmap_disable,
+	.is_enabled = anatop_regmap_is_enabled,
 	.set_voltage_sel = anatop_regmap_set_voltage_sel,
 	.set_voltage_time_sel = anatop_regmap_set_voltage_time_sel,
 	.get_voltage_sel = anatop_regmap_get_voltage_sel,
@@ -116,6 +162,7 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	struct regulator_init_data *initdata;
 	struct regulator_config config = { };
 	int ret = 0;
+	u32 val;
 
 	initdata = of_get_regulator_init_data(dev, np);
 	sreg = devm_kzalloc(dev, sizeof(*sreg), GFP_KERNEL);
@@ -199,6 +246,16 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 	config.of_node = pdev->dev.of_node;
 	config.regmap = sreg->anatop;
 
+	if (sreg->control_reg && anatop_is_core_reg(sreg)) {
+		ret = regmap_read(config.regmap, rdesc->vsel_reg, &val);
+		if (ret) {
+			dev_err(dev, "failed to read initial state\n");
+			goto anatop_probe_end;
+		}
+
+		sreg->sel = (val & rdesc->vsel_mask) >> sreg->vol_bit_shift;
+	}
+
 	/* register regulator */
 	rdev = devm_regulator_register(dev, rdesc, &config);
 	if (IS_ERR(rdev)) {
-- 
1.8.5.3

