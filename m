Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbaCUGyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 02:54:16 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63613 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755431AbaCUGyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 02:54:14 -0400
Message-ID: <1395384848.32206.1.camel@phoenix>
Subject: [PATCH RFT] regulator: s5m8767: Convert to use
 regulator_[enable|disable|is_enabled]_regmap
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 21 Mar 2014 14:54:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ca5d1b3524b4d
"regulator: helpers: Modify helpers enabling multi-bit control",
we can set enable_val setting for device that use multiple bits for control.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s5m8767.c | 78 +++++++++++----------------------------------
 1 file changed, 19 insertions(+), 59 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 342a66ab..f05bada 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -167,12 +167,11 @@ static unsigned int s5m8767_opmode_reg[][4] = {
 	{0x0, 0x3, 0x1, 0x1}, /* BUCK9 */
 };
 
-static int s5m8767_get_register(struct regulator_dev *rdev, int *reg,
-				int *enable_ctrl)
+static int s5m8767_get_register(struct s5m8767_info *s5m8767, int reg_id,
+				int *reg, int *enable_ctrl)
 {
-	int i, reg_id = rdev_get_id(rdev);
+	int i;
 	unsigned int mode;
-	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
 
 	switch (reg_id) {
 	case S5M8767_LDO1 ... S5M8767_LDO2:
@@ -211,53 +210,6 @@ static int s5m8767_get_register(struct regulator_dev *rdev, int *reg,
 	return 0;
 }
 
-static int s5m8767_reg_is_enabled(struct regulator_dev *rdev)
-{
-	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	int ret, reg;
-	int enable_ctrl;
-	unsigned int val;
-
-	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
-	if (ret == -EINVAL)
-		return 1;
-	else if (ret)
-		return ret;
-
-	ret = regmap_read(s5m8767->iodev->regmap_pmic, reg, &val);
-	if (ret)
-		return ret;
-
-	return (val & S5M8767_ENCTRL_MASK) == enable_ctrl;
-}
-
-static int s5m8767_reg_enable(struct regulator_dev *rdev)
-{
-	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	int ret, reg;
-	int enable_ctrl;
-
-	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
-	if (ret)
-		return ret;
-
-	return regmap_update_bits(s5m8767->iodev->regmap_pmic, reg,
-			S5M8767_ENCTRL_MASK, enable_ctrl);
-}
-
-static int s5m8767_reg_disable(struct regulator_dev *rdev)
-{
-	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
-	int ret, reg, enable_ctrl;
-
-	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
-	if (ret)
-		return ret;
-
-	return regmap_update_bits(s5m8767->iodev->regmap_pmic, reg,
-			S5M8767_ENCTRL_MASK, ~S5M8767_ENCTRL_MASK);
-}
-
 static int s5m8767_get_vsel_reg(int reg_id, struct s5m8767_info *s5m8767)
 {
 	int reg;
@@ -407,9 +359,9 @@ static int s5m8767_set_voltage_time_sel(struct regulator_dev *rdev,
 
 static struct regulator_ops s5m8767_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
-	.is_enabled		= s5m8767_reg_is_enabled,
-	.enable			= s5m8767_reg_enable,
-	.disable		= s5m8767_reg_disable,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= s5m8767_set_voltage_sel,
 	.set_voltage_time_sel	= s5m8767_set_voltage_time_sel,
@@ -417,9 +369,9 @@ static struct regulator_ops s5m8767_ops = {
 
 static struct regulator_ops s5m8767_buck78_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
-	.is_enabled		= s5m8767_reg_is_enabled,
-	.enable			= s5m8767_reg_enable,
-	.disable		= s5m8767_reg_disable,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 };
@@ -524,12 +476,13 @@ static void s5m8767_regulator_config_ext_control(struct s5m8767_info *s5m8767,
 static int s5m8767_enable_ext_control(struct s5m8767_info *s5m8767,
 		struct regulator_dev *rdev)
 {
+	int id = rdev_get_id(rdev);
 	int ret, reg, enable_ctrl;
 
-	if (rdev_get_id(rdev) != S5M8767_BUCK9)
+	if (id != S5M8767_BUCK9)
 		return -EINVAL;
 
-	ret = s5m8767_get_register(rdev, &reg, &enable_ctrl);
+	ret = s5m8767_get_register(s5m8767, id, &reg, &enable_ctrl);
 	if (ret)
 		return ret;
 
@@ -984,6 +937,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	for (i = 0; i < pdata->num_regulators; i++) {
 		const struct sec_voltage_desc *desc;
 		int id = pdata->regulators[i].id;
+		int enable_reg, enable_val;
 
 		desc = reg_voltage_map[id];
 		if (desc) {
@@ -997,6 +951,12 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 				regulators[id].vsel_mask = 0x3f;
 			else
 				regulators[id].vsel_mask = 0xff;
+
+			s5m8767_get_register(s5m8767, id, &enable_reg,
+					     &enable_val);
+			regulators[id].enable_reg = enable_reg;
+			regulators[id].enable_mask = S5M8767_ENCTRL_MASK;
+			regulators[id].enable_val = enable_val;
 		}
 
 		config.dev = s5m8767->dev;
-- 
1.8.1.2



