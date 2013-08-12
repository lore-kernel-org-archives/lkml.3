Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab3HLIvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 04:51:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49462 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382Ab3HLIvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 04:51:35 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <kishon@ti.com>, <balbi@ti.com>,
        J Keerthy <j-keerthy@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        Axel Lin <axel.lin@ingics.com>
Subject: [PATCH v4] regulator: palmas: model SMPS10 as two regulators
Date: Mon, 12 Aug 2013 14:21:14 +0530
Message-ID: <1376297474-12242-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMPS10 has two outputs OUT1 and OUT2 and have one input IN1.
SMPS10-OUT2 is connected to SMPS10-IN1 and can be configured either
in BOOST mode or BYPASS mode. regulator_enable of SMPS10-OUT2 configures
it in BOOST mode. For BYPASS mode regulator_allow_bypass() API can be
used. SMPS10-OUT1 is connected to SMPS10-OUT2 and can be enabled using
regulator_enable().

[ axel.lin@ingics.com : Simplify regulator_desc setting for SMPS10_[OUT1|OUT2]

Signed-off-by: J Keerthy <j-keerthy@ti.com>
Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Changes from v3:
rolled in Axel's fix.
rebased to Linux 3.11-rc5

Changes from v2:
Fixed the compilation error.
drivers/regulator/palmas-regulator.c: In function 'palmas_regulators_probe':
drivers/regulator/palmas-regulator.c:850:8: error: 'PALMAS_REG_SMPS10'
undeclared (first use in this function)
   case PALMAS_REG_SMPS10:
        ^
Changes from v1:
Reversed the order of SMPS10_OUT2 and SMPS10_OUT1 since the input signal
of OUT1 is OUT2

 drivers/regulator/palmas-regulator.c |   30 ++++++++++++++++++++++++------
 include/linux/mfd/palmas.h           |    9 +++++----
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index d0c8785..ab58e95 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -97,11 +97,16 @@ static const struct regs_info palmas_regs_info[] = {
 		.ctrl_addr	= PALMAS_SMPS9_CTRL,
 	},
 	{
-		.name		= "SMPS10",
+		.name		= "SMPS10_OUT2",
 		.sname		= "smps10-in",
 		.ctrl_addr	= PALMAS_SMPS10_CTRL,
 	},
 	{
+		.name		= "SMPS10_OUT1",
+		.sname		= "smps10-out2",
+		.ctrl_addr	= PALMAS_SMPS10_CTRL,
+	},
+	{
 		.name		= "LDO1",
 		.sname		= "ldo1-in",
 		.vsel_addr	= PALMAS_LDO1_VOLTAGE,
@@ -487,6 +492,8 @@ static struct regulator_ops palmas_ops_smps10 = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
+	.set_bypass		= regulator_set_bypass_regmap,
+	.get_bypass		= regulator_get_bypass_regmap,
 };
 
 static int palmas_is_enabled_ldo(struct regulator_dev *dev)
@@ -538,7 +545,8 @@ static int palmas_smps_init(struct palmas *palmas, int id,
 		return ret;
 
 	switch (id) {
-	case PALMAS_REG_SMPS10:
+	case PALMAS_REG_SMPS10_OUT1:
+	case PALMAS_REG_SMPS10_OUT2:
 		reg &= ~PALMAS_SMPS10_CTRL_MODE_SLEEP_MASK;
 		if (reg_init->mode_sleep)
 			reg |= reg_init->mode_sleep <<
@@ -681,7 +689,8 @@ static struct of_regulator_match palmas_matches[] = {
 	{ .name = "smps7", },
 	{ .name = "smps8", },
 	{ .name = "smps9", },
-	{ .name = "smps10", },
+	{ .name = "smps10_out2", },
+	{ .name = "smps10_out1", },
 	{ .name = "ldo1", },
 	{ .name = "ldo2", },
 	{ .name = "ldo3", },
@@ -838,7 +847,8 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 				continue;
 			ramp_delay_support = true;
 			break;
-		case PALMAS_REG_SMPS10:
+		case PALMAS_REG_SMPS10_OUT1:
+		case PALMAS_REG_SMPS10_OUT2:
 			if (!PALMAS_PMIC_HAS(palmas, SMPS10_BOOST))
 				continue;
 		}
@@ -872,7 +882,8 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 		pmic->desc[id].id = id;
 
 		switch (id) {
-		case PALMAS_REG_SMPS10:
+		case PALMAS_REG_SMPS10_OUT1:
+		case PALMAS_REG_SMPS10_OUT2:
 			pmic->desc[id].n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
 			pmic->desc[id].ops = &palmas_ops_smps10;
 			pmic->desc[id].vsel_reg =
@@ -882,7 +893,14 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
 							PALMAS_SMPS10_CTRL);
-			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
+			if (id == PALMAS_REG_SMPS10_OUT1)
+				pmic->desc[id].enable_mask = SMPS10_SWITCH_EN;
+			else
+				pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
+			pmic->desc[id].bypass_reg =
+					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							PALMAS_SMPS10_CTRL);
+			pmic->desc[id].bypass_mask = SMPS10_BYPASS_EN;
 			pmic->desc[id].min_uV = 3750000;
 			pmic->desc[id].uV_step = 1250000;
 			break;
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 1a8dd7a..c06d78a 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -160,7 +160,8 @@ enum palmas_regulators {
 	PALMAS_REG_SMPS7,
 	PALMAS_REG_SMPS8,
 	PALMAS_REG_SMPS9,
-	PALMAS_REG_SMPS10,
+	PALMAS_REG_SMPS10_OUT2,
+	PALMAS_REG_SMPS10_OUT1,
 	/* LDO regulators */
 	PALMAS_REG_LDO1,
 	PALMAS_REG_LDO2,
@@ -355,9 +356,9 @@ struct palmas_pmic {
 	int smps123;
 	int smps457;
 
-	int range[PALMAS_REG_SMPS10];
-	unsigned int ramp_delay[PALMAS_REG_SMPS10];
-	unsigned int current_reg_mode[PALMAS_REG_SMPS10];
+	int range[PALMAS_REG_SMPS10_OUT1];
+	unsigned int ramp_delay[PALMAS_REG_SMPS10_OUT1];
+	unsigned int current_reg_mode[PALMAS_REG_SMPS10_OUT1];
 };
 
 struct palmas_resource {
-- 
1.7.10.4

