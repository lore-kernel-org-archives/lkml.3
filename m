Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab3GBWwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:52:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48324 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3GBWwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:52:07 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>, Yi Zhang <yizhang@marvell.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Tue,  2 Jul 2013 23:51:54 +0100
Message-Id: <1372805514-11498-4-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372805514-11498-1-git-send-email-broonie@kernel.org>
References: <1372805514-11498-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 4/4] regulator: wm8350: Convert to use linear ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm8350-regulator.c | 55 +++++++++++-------------------------
 1 file changed, 17 insertions(+), 38 deletions(-)

diff --git a/drivers/regulator/wm8350-regulator.c b/drivers/regulator/wm8350-regulator.c
index 7f0fa22..5453dd0 100644
--- a/drivers/regulator/wm8350-regulator.c
+++ b/drivers/regulator/wm8350-regulator.c
@@ -542,41 +542,12 @@ static int wm8350_dcdc_set_suspend_mode(struct regulator_dev *rdev,
 	return 0;
 }
 
-static int wm8350_ldo_list_voltage(struct regulator_dev *rdev,
-				    unsigned selector)
-{
-	if (selector > WM8350_LDO1_VSEL_MASK)
-		return -EINVAL;
-
-	if (selector < 16)
-		return (selector * 50000) + 900000;
-	else
-		return ((selector - 16) * 100000) + 1800000;
-}
-
-static int wm8350_ldo_map_voltage(struct regulator_dev *rdev, int min_uV,
-				  int max_uV)
-{
-	int volt, sel;
-	int min_mV = min_uV / 1000;
-	int max_mV = max_uV / 1000;
-
-	if (min_mV < 900 || min_mV > 3300)
-		return -EINVAL;
-	if (max_mV < 900 || max_mV > 3300)
-		return -EINVAL;
-
-	if (min_mV < 1800) /* step size is 50mV < 1800mV */
-		sel = DIV_ROUND_UP(min_uV - 900, 50);
-	else /* step size is 100mV > 1800mV */
-		sel = DIV_ROUND_UP(min_uV - 1800, 100) + 16;
-
-	volt = wm8350_ldo_list_voltage(rdev, sel);
-	if (volt < min_uV || volt > max_uV)
-		return -EINVAL;
-
-	return sel;
-}
+static const struct regulator_linear_range wm8350_ldo_ranges[] = {
+	{ .min_uV =  900000, .max_uV = 1750000, .min_sel =  0, .max_sel = 15,
+	  .uV_step =  50000 },
+	{ .min_uV = 1800000, .max_uV = 3300000, .min_sel = 16, .max_sel = 31,
+	  .uV_step = 100000 },
+};
 
 static int wm8350_ldo_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 {
@@ -603,7 +574,7 @@ static int wm8350_ldo_set_suspend_voltage(struct regulator_dev *rdev, int uV)
 		return -EINVAL;
 	}
 
-	sel = wm8350_ldo_map_voltage(rdev, uV, uV);
+	sel = regulator_map_voltage_linear_range(rdev, uV, uV);
 	if (sel < 0)
 		return -EINVAL;
 
@@ -998,10 +969,10 @@ static struct regulator_ops wm8350_dcdc2_5_ops = {
 };
 
 static struct regulator_ops wm8350_ldo_ops = {
-	.map_voltage = wm8350_ldo_map_voltage,
+	.map_voltage = regulator_map_voltage_linear_range,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
-	.list_voltage = wm8350_ldo_list_voltage,
+	.list_voltage = regulator_list_voltage_linear_range,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
@@ -1108,6 +1079,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_LDO1,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_LDO1_VSEL_MASK + 1,
+		.linear_ranges = wm8350_ldo_ranges,
+		.n_linear_ranges = ARRAY_SIZE(wm8350_ldo_ranges),
 		.vsel_reg = WM8350_LDO1_CONTROL,
 		.vsel_mask = WM8350_LDO1_VSEL_MASK,
 		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
@@ -1121,6 +1094,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_LDO2,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_LDO2_VSEL_MASK + 1,
+		.linear_ranges = wm8350_ldo_ranges,
+		.n_linear_ranges = ARRAY_SIZE(wm8350_ldo_ranges),
 		.vsel_reg = WM8350_LDO2_CONTROL,
 		.vsel_mask = WM8350_LDO2_VSEL_MASK,
 		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
@@ -1134,6 +1109,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_LDO3,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_LDO3_VSEL_MASK + 1,
+		.linear_ranges = wm8350_ldo_ranges,
+		.n_linear_ranges = ARRAY_SIZE(wm8350_ldo_ranges),
 		.vsel_reg = WM8350_LDO3_CONTROL,
 		.vsel_mask = WM8350_LDO3_VSEL_MASK,
 		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
@@ -1147,6 +1124,8 @@ static const struct regulator_desc wm8350_reg[NUM_WM8350_REGULATORS] = {
 		.irq = WM8350_IRQ_UV_LDO4,
 		.type = REGULATOR_VOLTAGE,
 		.n_voltages = WM8350_LDO4_VSEL_MASK + 1,
+		.linear_ranges = wm8350_ldo_ranges,
+		.n_linear_ranges = ARRAY_SIZE(wm8350_ldo_ranges),
 		.vsel_reg = WM8350_LDO4_CONTROL,
 		.vsel_mask = WM8350_LDO4_VSEL_MASK,
 		.enable_reg = WM8350_DCDC_LDO_REQUESTED,
-- 
1.8.3.1

