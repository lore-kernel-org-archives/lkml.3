Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaJJWfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 18:35:22 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:56265 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaJJWfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 18:35:21 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <527828b0032e5fd305e4cdc474ae7af6>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de, linux-kernel@vger.kernel.org
Cc: Chris Zhong <zyw@rock-chips.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH v2] regulator: rk808: Add support setting suspend voltage
Date: Fri, 10 Oct 2014 15:35:06 -0700
Message-Id: <1412980506-546-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

support setting suspend voltage and disable regulator in suspend.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
Reviewed-by: Doug Anderson <dianders@chromium.org>

---

Changes in v2:
- Add set_suspend_enable

 drivers/regulator/rk808-regulator.c |   57 +++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 196a5c8..ea9d05e 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -36,6 +36,12 @@
 #define RK808_RAMP_RATE_6MV_PER_US	(2 << RK808_RAMP_RATE_OFFSET)
 #define RK808_RAMP_RATE_10MV_PER_US	(3 << RK808_RAMP_RATE_OFFSET)
 
+/* Offset from XXX_ON_VSEL to XXX_SLP_VSEL */
+#define RK808_SLP_REG_OFFSET 1
+
+/* Offset from XXX_EN_REG to SLEEP_SET_OFF_XXX */
+#define RK808_SLP_SET_OFF_REG_OFFSET 2
+
 static const int rk808_buck_config_regs[] = {
 	RK808_BUCK1_CONFIG_REG,
 	RK808_BUCK2_CONFIG_REG,
@@ -91,6 +97,43 @@ static int rk808_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 				  RK808_RAMP_RATE_MASK, ramp_value);
 }
 
+int rk808_set_suspend_voltage(struct regulator_dev *rdev, int uv)
+{
+	unsigned int reg;
+	int sel = regulator_map_voltage_linear_range(rdev, uv, uv);
+
+	if (sel < 0)
+		return -EINVAL;
+
+	reg = rdev->desc->vsel_reg + RK808_SLP_REG_OFFSET;
+
+	return regmap_update_bits(rdev->regmap, reg,
+				  rdev->desc->vsel_mask,
+				  sel);
+}
+
+int rk808_set_suspend_enable(struct regulator_dev *rdev)
+{
+	unsigned int reg;
+
+	reg = rdev->desc->enable_reg + RK808_SLP_SET_OFF_REG_OFFSET;
+
+	return regmap_update_bits(rdev->regmap, reg,
+				  rdev->desc->enable_mask,
+				  0);
+}
+
+int rk808_set_suspend_disable(struct regulator_dev *rdev)
+{
+	unsigned int reg;
+
+	reg = rdev->desc->enable_reg + RK808_SLP_SET_OFF_REG_OFFSET;
+
+	return regmap_update_bits(rdev->regmap, reg,
+				  rdev->desc->enable_mask,
+				  rdev->desc->enable_mask);
+}
+
 static struct regulator_ops rk808_buck1_2_ops = {
 	.list_voltage		= regulator_list_voltage_linear_range,
 	.map_voltage		= regulator_map_voltage_linear_range,
@@ -100,6 +143,9 @@ static struct regulator_ops rk808_buck1_2_ops = {
 	.disable		= regulator_disable_regmap,
 	.is_enabled		= regulator_is_enabled_regmap,
 	.set_ramp_delay		= rk808_set_ramp_delay,
+	.set_suspend_voltage	= rk808_set_suspend_voltage,
+	.set_suspend_enable	= rk808_set_suspend_enable,
+	.set_suspend_disable	= rk808_set_suspend_disable,
 };
 
 static struct regulator_ops rk808_reg_ops = {
@@ -110,12 +156,17 @@ static struct regulator_ops rk808_reg_ops = {
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
 	.is_enabled		= regulator_is_enabled_regmap,
+	.set_suspend_voltage	= rk808_set_suspend_voltage,
+	.set_suspend_enable	= rk808_set_suspend_enable,
+	.set_suspend_disable	= rk808_set_suspend_disable,
 };
 
 static struct regulator_ops rk808_switch_ops = {
-	.enable = regulator_enable_regmap,
-	.disable = regulator_disable_regmap,
-	.is_enabled = regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.set_suspend_enable	= rk808_set_suspend_enable,
+	.set_suspend_disable	= rk808_set_suspend_disable,
 };
 
 static const struct regulator_desc rk808_reg[] = {
-- 
1.7.9.5


