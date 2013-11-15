Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab3KON3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:29:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35298 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223Ab3KON3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:29:07 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.org, lee.jones@linaro.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: arizona-micsupp: Convert to use linear ranges
Date: Fri, 15 Nov 2013 13:13:32 +0000
Message-Id: <1384521213-27141-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/arizona-micsupp.c |   52 +++++++---------------------------
 1 files changed, 11 insertions(+), 41 deletions(-)

diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 724706a..3c75bf8 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -28,8 +28,6 @@
 #include <linux/mfd/arizona/pdata.h>
 #include <linux/mfd/arizona/registers.h>
 
-#define ARIZONA_MICSUPP_MAX_SELECTOR 0x1f
-
 struct arizona_micsupp {
 	struct regulator_dev *regulator;
 	struct arizona *arizona;
@@ -40,42 +38,6 @@ struct arizona_micsupp {
 	struct work_struct check_cp_work;
 };
 
-static int arizona_micsupp_list_voltage(struct regulator_dev *rdev,
-					unsigned int selector)
-{
-	if (selector > ARIZONA_MICSUPP_MAX_SELECTOR)
-		return -EINVAL;
-
-	if (selector == ARIZONA_MICSUPP_MAX_SELECTOR)
-		return 3300000;
-	else
-		return (selector * 50000) + 1700000;
-}
-
-static int arizona_micsupp_map_voltage(struct regulator_dev *rdev,
-				       int min_uV, int max_uV)
-{
-	unsigned int voltage;
-	int selector;
-
-	if (min_uV < 1700000)
-		min_uV = 1700000;
-
-	if (min_uV > 3200000)
-		selector = ARIZONA_MICSUPP_MAX_SELECTOR;
-	else
-		selector = DIV_ROUND_UP(min_uV - 1700000, 50000);
-
-	if (selector < 0)
-		return -EINVAL;
-
-	voltage = arizona_micsupp_list_voltage(rdev, selector);
-	if (voltage < min_uV || voltage > max_uV)
-		return -EINVAL;
-
-	return selector;
-}
-
 static void arizona_micsupp_check_cp(struct work_struct *work)
 {
 	struct arizona_micsupp *micsupp =
@@ -145,8 +107,8 @@ static struct regulator_ops arizona_micsupp_ops = {
 	.disable = arizona_micsupp_disable,
 	.is_enabled = regulator_is_enabled_regmap,
 
-	.list_voltage = arizona_micsupp_list_voltage,
-	.map_voltage = arizona_micsupp_map_voltage,
+	.list_voltage = regulator_list_voltage_linear_range,
+	.map_voltage = regulator_map_voltage_linear_range,
 
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
@@ -155,11 +117,16 @@ static struct regulator_ops arizona_micsupp_ops = {
 	.set_bypass = arizona_micsupp_set_bypass,
 };
 
+static const struct regulator_linear_range arizona_micsupp_ranges[] = {
+	REGULATOR_LINEAR_RANGE(1700000, 0,    0x1e, 50000),
+	REGULATOR_LINEAR_RANGE(3300000, 0x1f, 0x1f, 0),
+};
+
 static const struct regulator_desc arizona_micsupp = {
 	.name = "MICVDD",
 	.supply_name = "CPVDD",
 	.type = REGULATOR_VOLTAGE,
-	.n_voltages = ARIZONA_MICSUPP_MAX_SELECTOR + 1,
+	.n_voltages = 32,
 	.ops = &arizona_micsupp_ops,
 
 	.vsel_reg = ARIZONA_LDO2_CONTROL_1,
@@ -169,6 +136,9 @@ static const struct regulator_desc arizona_micsupp = {
 	.bypass_reg = ARIZONA_MIC_CHARGE_PUMP_1,
 	.bypass_mask = ARIZONA_CPMIC_BYPASS,
 
+	.linear_ranges = arizona_micsupp_ranges,
+	.n_linear_ranges = ARRAY_SIZE(arizona_micsupp_ranges),
+
 	.enable_time = 3000,
 
 	.owner = THIS_MODULE,
-- 
1.7.2.5

