Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966114Ab3DQJra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 05:47:30 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11755 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965843Ab3DQJr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 05:47:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 17 Apr 2013 02:47:26 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>
CC: <sameo@linux.intel.com>, <gg@slimlogic.co.uk>, <ian@slimlogic.co.uk>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/3] regulator: palmas: support for external regulator through control outputs
Date: Wed, 17 Apr 2013 15:13:12 +0530
Message-ID: <1366191793-13934-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com>
References: <1366191793-13934-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas device have control outputs like REGEN1, REGEN2, REGEN3,
SYSEN1 and SYSEN2. These control outputs can be used for controlling
external voltage switches to enabled/disable voltage outputs.

Add support of these control outputs through regulator framework.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/palmas-regulator.c |   95 +++++++++++++++++++++++++++++----
 include/linux/mfd/palmas.h           |    6 ++
 2 files changed, 89 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 7c7992b..28080a7 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -166,6 +166,26 @@ static const struct regs_info palmas_regs_info[] = {
 		.vsel_addr	= PALMAS_LDOUSB_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDOUSB_CTRL,
 	},
+	{
+		.name		= "REGEN1",
+		.ctrl_addr	= PALMAS_REGEN1_CTRL,
+	},
+	{
+		.name		= "REGEN2",
+		.ctrl_addr	= PALMAS_REGEN2_CTRL,
+	},
+	{
+		.name		= "REGEN3",
+		.ctrl_addr	= PALMAS_REGEN3_CTRL,
+	},
+	{
+		.name		= "SYSEN1",
+		.ctrl_addr	= PALMAS_SYSEN1_CTRL,
+	},
+	{
+		.name		= "SYSEN2",
+		.ctrl_addr	= PALMAS_SYSEN2_CTRL,
+	},
 };
 
 #define SMPS_CTRL_MODE_OFF		0x00
@@ -423,6 +443,12 @@ static struct regulator_ops palmas_ops_ldo = {
 	.map_voltage		= regulator_map_voltage_linear,
 };
 
+static struct regulator_ops palmas_ops_extreg = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+};
+
 /*
  * setup the hardware based sleep configuration of the SMPS/LDO regulators
  * from the platform data. This is different to the software based control
@@ -524,6 +550,28 @@ static int palmas_ldo_init(struct palmas *palmas, int id,
 	return 0;
 }
 
+static int palmas_extreg_init(struct palmas *palmas, int id,
+		struct palmas_reg_init *reg_init)
+{
+	unsigned int addr;
+	int ret;
+	unsigned int val = 0;
+
+	addr = palmas_regs_info[id].ctrl_addr;
+
+	if (reg_init->mode_sleep)
+		val = PALMAS_REGEN1_CTRL_MODE_SLEEP;
+
+	ret = palmas_update_bits(palmas, PALMAS_RESOURCE_BASE,
+			addr, PALMAS_REGEN1_CTRL_MODE_SLEEP, val);
+	if (ret < 0) {
+		dev_err(palmas->dev, "Resource reg 0x%02x update failed %d\n",
+			addr, ret);
+		return ret;
+	}
+	return 0;
+}
+
 static struct of_regulator_match palmas_matches[] = {
 	{ .name = "smps12", },
 	{ .name = "smps123", },
@@ -546,6 +594,11 @@ static struct of_regulator_match palmas_matches[] = {
 	{ .name = "ldo9", },
 	{ .name = "ldoln", },
 	{ .name = "ldousb", },
+	{ .name = "regen1", },
+	{ .name = "regen2", },
+	{ .name = "regen3", },
+	{ .name = "sysen1", },
+	{ .name = "sysen2", },
 };
 
 static void palmas_dt_to_pdata(struct device *dev,
@@ -764,21 +817,34 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 		/* Register the regulators */
 		pmic->desc[id].name = palmas_regs_info[id].name;
 		pmic->desc[id].id = id;
-		pmic->desc[id].n_voltages = PALMAS_LDO_NUM_VOLTAGES;
-
-		pmic->desc[id].ops = &palmas_ops_ldo;
-
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
 		pmic->desc[id].owner = THIS_MODULE;
-		pmic->desc[id].min_uV = 900000;
-		pmic->desc[id].uV_step = 50000;
-		pmic->desc[id].linear_min_sel = 1;
-		pmic->desc[id].vsel_reg = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+
+		if (id < PALMAS_REG_REGEN1) {
+			pmic->desc[id].n_voltages = PALMAS_LDO_NUM_VOLTAGES;
+			pmic->desc[id].ops = &palmas_ops_ldo;
+			pmic->desc[id].min_uV = 900000;
+			pmic->desc[id].uV_step = 50000;
+			pmic->desc[id].linear_min_sel = 1;
+			pmic->desc[id].vsel_reg =
+					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
 						palmas_regs_info[id].vsel_addr);
-		pmic->desc[id].vsel_mask = PALMAS_LDO1_VOLTAGE_VSEL_MASK;
-		pmic->desc[id].enable_reg = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+			pmic->desc[id].vsel_mask =
+					PALMAS_LDO1_VOLTAGE_VSEL_MASK;
+			pmic->desc[id].enable_reg =
+					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+						palmas_regs_info[id].ctrl_addr);
+			pmic->desc[id].enable_mask =
+					PALMAS_LDO1_CTRL_MODE_ACTIVE;
+		} else {
+			pmic->desc[id].n_voltages = 1;
+			pmic->desc[id].ops = &palmas_ops_extreg;
+			pmic->desc[id].enable_reg =
+					PALMAS_BASE_TO_REG(PALMAS_RESOURCE_BASE,
 						palmas_regs_info[id].ctrl_addr);
-		pmic->desc[id].enable_mask = PALMAS_LDO1_CTRL_MODE_ACTIVE;
+			pmic->desc[id].enable_mask =
+					PALMAS_REGEN1_CTRL_MODE_ACTIVE;
+		}
 
 		if (pdata)
 			config.init_data = pdata->reg_data[id];
@@ -804,7 +870,12 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 		if (pdata) {
 			reg_init = pdata->reg_init[id];
 			if (reg_init) {
-				ret = palmas_ldo_init(palmas, id, reg_init);
+				if (id < PALMAS_REG_REGEN1)
+					ret = palmas_ldo_init(palmas,
+							id, reg_init);
+				else
+					ret = palmas_extreg_init(palmas,
+							id, reg_init);
 				if (ret) {
 					regulator_unregister(pmic->rdev[id]);
 					goto err_unregister_regulator;
diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
index 4a066d0..fb04d07 100644
--- a/include/linux/mfd/palmas.h
+++ b/include/linux/mfd/palmas.h
@@ -164,6 +164,12 @@ enum palmas_regulators {
 	PALMAS_REG_LDO9,
 	PALMAS_REG_LDOLN,
 	PALMAS_REG_LDOUSB,
+	/* External regulators */
+	PALMAS_REG_REGEN1,
+	PALMAS_REG_REGEN2,
+	PALMAS_REG_REGEN3,
+	PALMAS_REG_SYSEN1,
+	PALMAS_REG_SYSEN2,
 	/* Total number of regulators */
 	PALMAS_NUM_REGS,
 };
-- 
1.7.1.1

