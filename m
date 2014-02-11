Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaBKNoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:44:10 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38282 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaBKNnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:43:50 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Anson Huang <b20788@freescale.com>, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 2/2] regulator: anatop: Add bypass support to digital LDOs
Date: Tue, 11 Feb 2014 14:43:45 +0100
Message-Id: <1392126225-7017-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392126225-7017-1-git-send-email-p.zabel@pengutronix.de>
References: <1392126225-7017-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM, PU, and SOC LDOs in the i.MX6 PMU can operate
in bypass mode. This allows to use external switching
regulators for cpu voltage scaling.

Since bypass and power gating modes are not configured
with their own bits, but via the voltage target bitfield,
store bypass state to be restored when reenabling the
regulator.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/regulator/anatop-regulator.c | 45 +++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index dff120a..38e8122 100644
--- a/drivers/regulator/anatop-regulator.c
+++ b/drivers/regulator/anatop-regulator.c
@@ -35,6 +35,7 @@
 #define LDO_RAMP_UP_FREQ_IN_MHZ         24 /* cycle based on 24M OSC */
 
 #define LDO_POWER_GATE			0x00
+#define LDO_FET_FULL_ON			0x1f
 
 struct anatop_regulator {
 	const char *name;
@@ -50,6 +51,7 @@ struct anatop_regulator {
 	int max_voltage;
 	struct regulator_desc rdesc;
 	struct regulator_init_data *initdata;
+	bool bypass;
 	int sel;
 };
 
@@ -103,8 +105,10 @@ static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
 static int anatop_regmap_enable(struct regulator_dev *reg)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	int sel;
 
-	return regulator_set_voltage_sel_regmap(reg, anatop_reg->sel);
+	sel = anatop_reg->bypass ? LDO_FET_FULL_ON : anatop_reg->sel;
+	return regulator_set_voltage_sel_regmap(reg, sel);
 }
 
 static int anatop_regmap_disable(struct regulator_dev *reg)
@@ -123,7 +127,7 @@ static int anatop_regmap_core_set_voltage_sel(struct regulator_dev *reg,
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
 	int ret;
 
-	if (!anatop_regmap_is_enabled(reg)) {
+	if (anatop_reg->bypass || !anatop_regmap_is_enabled(reg)) {
 		anatop_reg->sel = selector;
 		return 0;
 	}
@@ -138,12 +142,41 @@ static int anatop_regmap_core_get_voltage_sel(struct regulator_dev *reg)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
 
-	if (!anatop_regmap_is_enabled(reg))
+	if (anatop_reg->bypass || !anatop_regmap_is_enabled(reg))
 		return anatop_reg->sel;
 
 	return regulator_get_voltage_sel_regmap(reg);
 }
 
+static int anatop_regmap_get_bypass(struct regulator_dev *reg, bool *enable)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	int sel;
+
+	sel = regulator_get_voltage_sel_regmap(reg);
+	if (sel == LDO_FET_FULL_ON)
+		WARN_ON(!anatop_reg->bypass);
+	else if (sel != LDO_POWER_GATE)
+		WARN_ON(anatop_reg->bypass);
+
+	*enable = anatop_reg->bypass;
+	return 0;
+}
+
+static int anatop_regmap_set_bypass(struct regulator_dev *reg, bool enable)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	int sel;
+
+	if (enable == anatop_reg->bypass)
+		return 0;
+
+	sel = enable ? LDO_FET_FULL_ON : anatop_reg->sel;
+	anatop_reg->bypass = enable;
+
+	return regulator_set_voltage_sel_regmap(reg, sel);
+}
+
 static struct regulator_ops anatop_rops = {
 	.set_voltage_sel = anatop_regmap_set_voltage_sel,
 	.get_voltage_sel = anatop_regmap_get_voltage_sel,
@@ -160,6 +193,8 @@ static struct regulator_ops anatop_core_rops = {
 	.get_voltage_sel = anatop_regmap_core_get_voltage_sel,
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
+	.get_bypass = anatop_regmap_get_bypass,
+	.set_bypass = anatop_regmap_set_bypass,
 };
 
 static int anatop_regulator_probe(struct platform_device *pdev)
@@ -265,6 +300,10 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 		}
 
 		sreg->sel = (val & rdesc->vsel_mask) >> sreg->vol_bit_shift;
+		if (sreg->sel == LDO_FET_FULL_ON) {
+			sreg->sel = 0;
+			sreg->bypass = true;
+		}
 	} else {
 		rdesc->ops = &anatop_rops;
 	}
-- 
1.8.5.3

