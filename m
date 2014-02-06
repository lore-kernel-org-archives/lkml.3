Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaBFOns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:43:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46821 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaBFOnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:43:43 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Anson Huang <b20788@freescale.com>,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/2] regulator: anatop: Add bypass support to digital LDOs
Date: Thu,  6 Feb 2014 15:43:33 +0100
Message-Id: <1391697813-20091-2-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391697813-20091-1-git-send-email-p.zabel@pengutronix.de>
References: <1391697813-20091-1-git-send-email-p.zabel@pengutronix.de>
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
 drivers/regulator/anatop-regulator.c | 55 +++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
index 93a6413..7cfaa51 100644
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
 
@@ -68,6 +70,11 @@ static int anatop_regmap_set_voltage_sel(struct regulator_dev *reg,
 	if (!anatop_reg->control_reg)
 		return -ENOTSUPP;
 
+	if (anatop_reg->bypass) {
+		anatop_reg->sel = selector;
+		return 0;
+	}
+
 	ret = regulator_set_voltage_sel_regmap(reg, selector);
 	if (!ret)
 		anatop_reg->sel = selector;
@@ -107,17 +114,22 @@ static int anatop_regmap_get_voltage_sel(struct regulator_dev *reg)
 	if (!anatop_reg->control_reg)
 		return -ENOTSUPP;
 
+	if (anatop_reg->bypass)
+		return anatop_reg->sel;
+
 	return regulator_get_voltage_sel_regmap(reg);
 }
 
 static int anatop_regmap_enable(struct regulator_dev *reg)
 {
 	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	int sel;
 
 	if (!anatop_is_core_reg(anatop_reg))
 		return 0;
 
-	return regulator_set_voltage_sel_regmap(reg, anatop_reg->sel);
+	sel = anatop_reg->bypass ? LDO_FET_FULL_ON : anatop_reg->sel;
+	return regulator_set_voltage_sel_regmap(reg, sel);
 }
 
 static int anatop_regmap_disable(struct regulator_dev *reg)
@@ -140,6 +152,41 @@ static int anatop_regmap_is_enabled(struct regulator_dev *reg)
 	return regulator_get_voltage_sel_regmap(reg) != LDO_POWER_GATE;
 }
 
+static int anatop_regmap_get_bypass(struct regulator_dev *reg, bool *enable)
+{
+	struct anatop_regulator *anatop_reg = rdev_get_drvdata(reg);
+	int sel;
+
+	if (!anatop_is_core_reg(anatop_reg))
+		return -ENOTSUPP;
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
+	if (!anatop_is_core_reg(anatop_reg))
+		return -ENOTSUPP;
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
 	.enable = anatop_regmap_enable,
 	.disable = anatop_regmap_disable,
@@ -149,6 +196,8 @@ static struct regulator_ops anatop_rops = {
 	.get_voltage_sel = anatop_regmap_get_voltage_sel,
 	.list_voltage = regulator_list_voltage_linear,
 	.map_voltage = regulator_map_voltage_linear,
+	.get_bypass = anatop_regmap_get_bypass,
+	.set_bypass = anatop_regmap_set_bypass,
 };
 
 static int anatop_regulator_probe(struct platform_device *pdev)
@@ -254,6 +303,10 @@ static int anatop_regulator_probe(struct platform_device *pdev)
 		}
 
 		sreg->sel = (val & rdesc->vsel_mask) >> sreg->vol_bit_shift;
+		if (sreg->sel == LDO_FET_FULL_ON) {
+			sreg->sel = 0;
+			sreg->bypass = true;
+		}
 	}
 
 	/* register regulator */
-- 
1.8.5.3

