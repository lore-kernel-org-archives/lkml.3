Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaIPRXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 13:23:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41747 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbaIPRXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 13:23:05 -0400
From: Doug Anderson <dianders@chromium.org>
To: Mark Brown <broonie@kernel.org>, Chris Zhong <zyw@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>
Cc: Sonny Rao <sonnyrao@chromium.org>, axel.lin@ingics.com,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Doug Anderson <dianders@chromium.org>, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: rk808: Add function for ramp delay for buck1/buck2
Date: Tue, 16 Sep 2014 10:22:54 -0700
Message-Id: <1410888174-8279-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On rk808 buck1 and buck2 have programmable ramp delays.  Let's add a
function to allow a client of rk808 to set them.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
 drivers/regulator/rk808-regulator.c | 57 +++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 07b0eb4..e305416 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -28,6 +28,21 @@
 #define RK808_BUCK4_VSEL_MASK	0xf
 #define RK808_LDO_VSEL_MASK	0x1f
 
+/* Ramp rate definitions for buck1 / buck2 only */
+#define RK808_RAMP_RATE_OFFSET		3
+#define RK808_RAMP_RATE_MASK		(3 << RK808_RAMP_RATE_OFFSET)
+#define RK808_RAMP_RATE_2MV_PER_US	(0 << RK808_RAMP_RATE_OFFSET)
+#define RK808_RAMP_RATE_4MV_PER_US	(1 << RK808_RAMP_RATE_OFFSET)
+#define RK808_RAMP_RATE_6MV_PER_US	(2 << RK808_RAMP_RATE_OFFSET)
+#define RK808_RAMP_RATE_10MV_PER_US	(3 << RK808_RAMP_RATE_OFFSET)
+
+static const int rk808_buck_config_regs[] = {
+	RK808_BUCK1_CONFIG_REG,
+	RK808_BUCK2_CONFIG_REG,
+	RK808_BUCK3_CONFIG_REG,
+	RK808_BUCK4_CONFIG_REG,
+};
+
 static const struct regulator_linear_range rk808_buck_voltage_ranges[] = {
 	REGULATOR_LINEAR_RANGE(700000, 0, 63, 12500),
 };
@@ -49,6 +64,44 @@ static const struct regulator_linear_range rk808_ldo6_voltage_ranges[] = {
 	REGULATOR_LINEAR_RANGE(800000, 0, 17, 100000),
 };
 
+static int rk808_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
+{
+	unsigned int ramp_value = RK808_RAMP_RATE_10MV_PER_US;
+	unsigned int reg = rk808_buck_config_regs[rdev->desc->id -
+						  RK808_ID_DCDC1];
+
+	switch (ramp_delay) {
+	case 1 ... 2000:
+		ramp_value = RK808_RAMP_RATE_2MV_PER_US;
+		break;
+	case 2001 ... 4000:
+		ramp_value = RK808_RAMP_RATE_4MV_PER_US;
+		break;
+	case 4001 ... 6000:
+		ramp_value = RK808_RAMP_RATE_6MV_PER_US;
+		break;
+	case 6001 ... 10000:
+		break;
+	default:
+		pr_warn("%s ramp_delay: %d not supported, setting 10000\n",
+			rdev->desc->name, ramp_delay);
+	}
+
+	return regmap_update_bits(rdev->regmap, reg,
+				  RK808_RAMP_RATE_MASK, ramp_value);
+}
+
+static struct regulator_ops rk808_buck1_2_ops = {
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.set_ramp_delay		= rk808_set_ramp_delay,
+};
+
 static struct regulator_ops rk808_reg_ops = {
 	.list_voltage		= regulator_list_voltage_linear_range,
 	.map_voltage		= regulator_map_voltage_linear_range,
@@ -70,7 +123,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.name = "DCDC_REG1",
 		.supply_name = "vcc1",
 		.id = RK808_ID_DCDC1,
-		.ops = &rk808_reg_ops,
+		.ops = &rk808_buck1_2_ops,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = 64,
 		.linear_ranges = rk808_buck_voltage_ranges,
@@ -84,7 +137,7 @@ static const struct regulator_desc rk808_reg[] = {
 		.name = "DCDC_REG2",
 		.supply_name = "vcc2",
 		.id = RK808_ID_DCDC2,
-		.ops = &rk808_reg_ops,
+		.ops = &rk808_buck1_2_ops,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = 64,
 		.linear_ranges = rk808_buck_voltage_ranges,
-- 
2.1.0.rc2.206.gedb03e5

