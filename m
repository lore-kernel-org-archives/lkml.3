Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab3FYJA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:00:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52979 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990Ab3FYJAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:00:54 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <ldewangan@nvidia.com>,
        <gg@slimlogic.co.uk>, <sameo@linux.intel.com>, <kishon@ti.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] regulator: palmas: model SMPS10 as two regulators
Date: Tue, 25 Jun 2013 14:30:28 +0530
Message-ID: <1372150828-10519-1-git-send-email-kishon@ti.com>
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

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v1:
Reversed the order of SMPS10_OUT2 and SMPS10_OUT1 since the input signal
of OUT1 is OUT2
 drivers/regulator/palmas-regulator.c |   39 ++++++++++++++++++++++++++++++----
 include/linux/mfd/palmas.h           |    9 ++++----
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 3ae44ac..50ca8c0 100644
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
@@ -869,7 +878,25 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 		pmic->desc[id].id = id;
 
 		switch (id) {
-		case PALMAS_REG_SMPS10:
+		case PALMAS_REG_SMPS10_OUT1:
+			pmic->desc[id].n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
+			pmic->desc[id].ops = &palmas_ops_smps10;
+			pmic->desc[id].vsel_reg =
+					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							PALMAS_SMPS10_CTRL);
+			pmic->desc[id].vsel_mask = SMPS10_VSEL;
+			pmic->desc[id].enable_reg =
+					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							PALMAS_SMPS10_CTRL);
+			pmic->desc[id].enable_mask = SMPS10_SWITCH_EN;
+			pmic->desc[id].bypass_reg =
+					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							PALMAS_SMPS10_CTRL);
+			pmic->desc[id].bypass_mask = SMPS10_BYPASS_EN;
+			pmic->desc[id].min_uV = 3750000;
+			pmic->desc[id].uV_step = 1250000;
+			break;
+		case PALMAS_REG_SMPS10_OUT2:
 			pmic->desc[id].n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
 			pmic->desc[id].ops = &palmas_ops_smps10;
 			pmic->desc[id].vsel_reg =
@@ -880,6 +907,10 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
 							PALMAS_SMPS10_CTRL);
 			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
+			pmic->desc[id].bypass_reg =
+					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							PALMAS_SMPS10_CTRL);
+			pmic->desc[id].bypass_mask = SMPS10_BYPASS_EN;
 			pmic->desc[id].min_uV = 3750000;
 			pmic->desc[id].uV_step = 1250000;
 			break;
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 9b81b2b..5251379 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -146,7 +146,8 @@ enum palmas_regulators {
 	PALMAS_REG_SMPS7,
 	PALMAS_REG_SMPS8,
 	PALMAS_REG_SMPS9,
-	PALMAS_REG_SMPS10,
+	PALMAS_REG_SMPS10_OUT2,
+	PALMAS_REG_SMPS10_OUT1,
 	/* LDO regulators */
 	PALMAS_REG_LDO1,
 	PALMAS_REG_LDO2,
@@ -341,9 +342,9 @@ struct palmas_pmic {
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

