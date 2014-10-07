Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaJGIoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:44:15 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:34305 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbaJGIoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:44:11 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: rk808: Add support setting suspend voltage
Date: Tue,  7 Oct 2014 16:43:57 +0800
Message-Id: <1412671438-25399-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

support setting suspend voltage and disable regulator in suspend.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>

---

 drivers/regulator/rk808-regulator.c |   37 +++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index e305416..6687e6e 100644
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
@@ -91,6 +97,32 @@ static int rk808_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
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
@@ -100,6 +132,8 @@ static struct regulator_ops rk808_buck1_2_ops = {
 	.disable		= regulator_disable_regmap,
 	.is_enabled		= regulator_is_enabled_regmap,
 	.set_ramp_delay		= rk808_set_ramp_delay,
+	.set_suspend_voltage    = rk808_set_suspend_voltage,
+	.set_suspend_disable    = rk808_set_suspend_disable,
 };
 
 static struct regulator_ops rk808_reg_ops = {
@@ -110,12 +144,15 @@ static struct regulator_ops rk808_reg_ops = {
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
 	.is_enabled		= regulator_is_enabled_regmap,
+	.set_suspend_voltage    = rk808_set_suspend_voltage,
+	.set_suspend_disable    = rk808_set_suspend_disable,
 };
 
 static struct regulator_ops rk808_switch_ops = {
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
+	.set_suspend_disable    = rk808_set_suspend_disable,
 };
 
 static const struct regulator_desc rk808_reg[] = {
-- 
1.7.9.5

