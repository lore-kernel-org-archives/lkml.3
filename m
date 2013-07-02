Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3GBWwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:52:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48308 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755303Ab3GBWwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:52:20 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>, Yi Zhang <yizhang@marvell.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Tue,  2 Jul 2013 23:51:52 +0100
Message-Id: <1372805514-11498-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372805514-11498-1-git-send-email-broonie@kernel.org>
References: <1372805514-11498-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/4] regulator: wm8400: Use linear ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm8400-regulator.c | 50 ++++++++++++------------------------
 1 file changed, 16 insertions(+), 34 deletions(-)

diff --git a/drivers/regulator/wm8400-regulator.c b/drivers/regulator/wm8400-regulator.c
index a09f03e..2ac7e1a 100644
--- a/drivers/regulator/wm8400-regulator.c
+++ b/drivers/regulator/wm8400-regulator.c
@@ -19,47 +19,21 @@
 #include <linux/regulator/driver.h>
 #include <linux/mfd/wm8400-private.h>
 
-static int wm8400_ldo_list_voltage(struct regulator_dev *dev,
-				   unsigned selector)
-{
-	if (selector > WM8400_LDO1_VSEL_MASK)
-		return -EINVAL;
-
-	if (selector < 15)
-		return 900000 + (selector * 50000);
-	else
-		return 1700000 + ((selector - 15) * 100000);
-}
-
-static int wm8400_ldo_map_voltage(struct regulator_dev *dev,
-				  int min_uV, int max_uV)
-{
-	u16 val;
-	int volt;
-
-	if (min_uV < 900000 || min_uV > 3300000)
-		return -EINVAL;
-
-	if (min_uV < 1700000) /* Steps of 50mV from 900mV;  */
-		val = DIV_ROUND_UP(min_uV - 900000, 50000);
-	else /* Steps of 100mV from 1700mV */
-		val = DIV_ROUND_UP(min_uV - 1700000, 100000) + 15;
-
-	volt = wm8400_ldo_list_voltage(dev, val);
-	if (volt < min_uV || volt > max_uV)
-		return -EINVAL;
-
-	return val;
-}
+static const struct regulator_linear_range wm8400_ldo_ranges[] = {
+	{ .min_uV =  900000, .max_uV = 1600000, .min_sel = 0, .max_sel = 14,
+	  .uV_step =  50000 },
+	{ .min_uV = 1700000, .max_uV = 3300000, .min_sel = 15, .max_sel = 31,
+	  .uV_step = 100000 },
+};
 
 static struct regulator_ops wm8400_ldo_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
-	.list_voltage = wm8400_ldo_list_voltage,
+	.list_voltage = regulator_list_voltage_linear_range,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
-	.map_voltage = wm8400_ldo_map_voltage,
+	.map_voltage = regulator_map_voltage_linear_range,
 };
 
 static unsigned int wm8400_dcdc_get_mode(struct regulator_dev *dev)
@@ -155,6 +129,8 @@ static struct regulator_desc regulators[] = {
 		.enable_reg = WM8400_LDO1_CONTROL,
 		.enable_mask = WM8400_LDO1_ENA,
 		.n_voltages = WM8400_LDO1_VSEL_MASK + 1,
+		.linear_ranges = wm8400_ldo_ranges,
+		.n_linear_ranges = ARRAY_SIZE(wm8400_ldo_ranges),
 		.vsel_reg = WM8400_LDO1_CONTROL,
 		.vsel_mask = WM8400_LDO1_VSEL_MASK,
 		.type = REGULATOR_VOLTAGE,
@@ -167,6 +143,8 @@ static struct regulator_desc regulators[] = {
 		.enable_reg = WM8400_LDO2_CONTROL,
 		.enable_mask = WM8400_LDO2_ENA,
 		.n_voltages = WM8400_LDO2_VSEL_MASK + 1,
+		.linear_ranges = wm8400_ldo_ranges,
+		.n_linear_ranges = ARRAY_SIZE(wm8400_ldo_ranges),
 		.type = REGULATOR_VOLTAGE,
 		.vsel_reg = WM8400_LDO2_CONTROL,
 		.vsel_mask = WM8400_LDO2_VSEL_MASK,
@@ -179,6 +157,8 @@ static struct regulator_desc regulators[] = {
 		.enable_reg = WM8400_LDO3_CONTROL,
 		.enable_mask = WM8400_LDO3_ENA,
 		.n_voltages = WM8400_LDO3_VSEL_MASK + 1,
+		.linear_ranges = wm8400_ldo_ranges,
+		.n_linear_ranges = ARRAY_SIZE(wm8400_ldo_ranges),
 		.vsel_reg = WM8400_LDO3_CONTROL,
 		.vsel_mask = WM8400_LDO3_VSEL_MASK,
 		.type = REGULATOR_VOLTAGE,
@@ -191,6 +171,8 @@ static struct regulator_desc regulators[] = {
 		.enable_reg = WM8400_LDO4_CONTROL,
 		.enable_mask = WM8400_LDO4_ENA,
 		.n_voltages = WM8400_LDO4_VSEL_MASK + 1,
+		.linear_ranges = wm8400_ldo_ranges,
+		.n_linear_ranges = ARRAY_SIZE(wm8400_ldo_ranges),
 		.vsel_reg = WM8400_LDO4_CONTROL,
 		.vsel_mask = WM8400_LDO4_VSEL_MASK,
 		.type = REGULATOR_VOLTAGE,
-- 
1.8.3.1

