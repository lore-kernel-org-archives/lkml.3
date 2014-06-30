Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbaF3P6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:58:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35809 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754706AbaF3P5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:57:54 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Keerthy J <j-keerthy@ti.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 5/6] regulator: palmas: Simplify code by not indexing regulator_desc unnecessarily
Date: Mon, 30 Jun 2014 10:57:38 -0500
Message-ID: <1404143859-8160-6-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404143859-8160-1-git-send-email-nm@ti.com>
References: <1404143859-8160-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas regulator needs to full up the regulator_desc based on PMIC and
type of regulator. However, we dont need to do desc[id] every time. we
can simplify by using a pointer to desc[id] and filling up the
parameters.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/palmas-regulator.c |  248 +++++++++++++++-------------------
 1 file changed, 112 insertions(+), 136 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index d6b734f..ae0f639 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -866,6 +866,7 @@ static int palmas_ldo_registration(struct palmas_pmic *pmic,
 	struct regulator_dev *rdev;
 	struct palmas_reg_init *reg_init;
 	struct palmas_regs_info *rinfo;
+	struct regulator_desc *desc;
 
 	for (id = ddata->ldo_begin; id < ddata->max_reg; id++) {
 		if (pdata && pdata->reg_init[id])
@@ -879,57 +880,51 @@ static int palmas_ldo_registration(struct palmas_pmic *pmic,
 		 */
 
 		/* Register the regulators */
-		pmic->desc[id].name = rinfo->name;
-		pmic->desc[id].id = id;
-		pmic->desc[id].type = REGULATOR_VOLTAGE;
-		pmic->desc[id].owner = THIS_MODULE;
+		desc = &pmic->desc[id];
+		desc->name = rinfo->name;
+		desc->id = id;
+		desc->type = REGULATOR_VOLTAGE;
+		desc->owner = THIS_MODULE;
 
 		if (id < PALMAS_REG_REGEN1) {
-			pmic->desc[id].n_voltages = PALMAS_LDO_NUM_VOLTAGES;
+			desc->n_voltages = PALMAS_LDO_NUM_VOLTAGES;
 			if (reg_init && reg_init->roof_floor)
-				pmic->desc[id].ops =
-					&palmas_ops_ext_control_ldo;
+				desc->ops = &palmas_ops_ext_control_ldo;
 			else
-				pmic->desc[id].ops = &palmas_ops_ldo;
-			pmic->desc[id].min_uV = 900000;
-			pmic->desc[id].uV_step = 50000;
-			pmic->desc[id].linear_min_sel = 1;
-			pmic->desc[id].enable_time = 500;
-			pmic->desc[id].vsel_reg =
-					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
-							   rinfo->vsel_addr);
-			pmic->desc[id].vsel_mask =
-					PALMAS_LDO1_VOLTAGE_VSEL_MASK;
-			pmic->desc[id].enable_reg =
-					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
-							   rinfo->ctrl_addr);
-			pmic->desc[id].enable_mask =
-					PALMAS_LDO1_CTRL_MODE_ACTIVE;
+				desc->ops = &palmas_ops_ldo;
+			desc->min_uV = 900000;
+			desc->uV_step = 50000;
+			desc->linear_min_sel = 1;
+			desc->enable_time = 500;
+			desc->vsel_reg = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+							    rinfo->vsel_addr);
+			desc->vsel_mask = PALMAS_LDO1_VOLTAGE_VSEL_MASK;
+			desc->enable_reg = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+							      rinfo->ctrl_addr);
+			desc->enable_mask = PALMAS_LDO1_CTRL_MODE_ACTIVE;
 
 			/* Check if LDO8 is in tracking mode or not */
 			if (pdata && (id == PALMAS_REG_LDO8) &&
 			    pdata->enable_ldo8_tracking) {
 				palmas_enable_ldo8_track(pmic->palmas);
-				pmic->desc[id].min_uV = 450000;
-				pmic->desc[id].uV_step = 25000;
+				desc->min_uV = 450000;
+				desc->uV_step = 25000;
 			}
 
 			/* LOD6 in vibrator mode will have enable time 2000us */
 			if (pdata && pdata->ldo6_vibrator &&
 			    (id == PALMAS_REG_LDO6))
-				pmic->desc[id].enable_time = 2000;
+				desc->enable_time = 2000;
 		} else {
-			pmic->desc[id].n_voltages = 1;
+			desc->n_voltages = 1;
 			if (reg_init && reg_init->roof_floor)
-				pmic->desc[id].ops =
-					&palmas_ops_ext_control_extreg;
+				desc->ops = &palmas_ops_ext_control_extreg;
 			else
-				pmic->desc[id].ops = &palmas_ops_extreg;
-			pmic->desc[id].enable_reg =
+				desc->ops = &palmas_ops_extreg;
+			desc->enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_RESOURCE_BASE,
 							   rinfo->ctrl_addr);
-			pmic->desc[id].enable_mask =
-					PALMAS_REGEN1_CTRL_MODE_ACTIVE;
+			desc->enable_mask = PALMAS_REGEN1_CTRL_MODE_ACTIVE;
 		}
 
 		if (pdata)
@@ -937,11 +932,10 @@ static int palmas_ldo_registration(struct palmas_pmic *pmic,
 		else
 			config.init_data = NULL;
 
-		pmic->desc[id].supply_name = rinfo->sname;
+		desc->supply_name = rinfo->sname;
 		config.of_node = ddata->palmas_matches[id].of_node;
 
-		rdev = devm_regulator_register(pmic->dev, &pmic->desc[id],
-					       &config);
+		rdev = devm_regulator_register(pmic->dev, desc, &config);
 		if (IS_ERR(rdev)) {
 			dev_err(pmic->dev,
 				"failed to register %s regulator\n",
@@ -981,6 +975,7 @@ static int tps65917_ldo_registration(struct palmas_pmic *pmic,
 	struct regulator_dev *rdev;
 	struct palmas_reg_init *reg_init;
 	struct palmas_regs_info *rinfo;
+	struct regulator_desc *desc;
 
 	for (id = ddata->ldo_begin; id < ddata->max_reg; id++) {
 		if (pdata && pdata->reg_init[id])
@@ -994,49 +989,43 @@ static int tps65917_ldo_registration(struct palmas_pmic *pmic,
 		rinfo = &ddata->palmas_regs_info[id];
 
 		/* Register the regulators */
-		pmic->desc[id].name = rinfo->name;
-		pmic->desc[id].id = id;
-		pmic->desc[id].type = REGULATOR_VOLTAGE;
-		pmic->desc[id].owner = THIS_MODULE;
+		desc = &pmic->desc[id];
+		desc->name = rinfo->name;
+		desc->id = id;
+		desc->type = REGULATOR_VOLTAGE;
+		desc->owner = THIS_MODULE;
 
 		if (id < TPS65917_REG_REGEN1) {
-			pmic->desc[id].n_voltages = PALMAS_LDO_NUM_VOLTAGES;
+			desc->n_voltages = PALMAS_LDO_NUM_VOLTAGES;
 			if (reg_init && reg_init->roof_floor)
-				pmic->desc[id].ops =
-					&palmas_ops_ext_control_ldo;
+				desc->ops = &palmas_ops_ext_control_ldo;
 			else
-				pmic->desc[id].ops = &tps65917_ops_ldo;
-			pmic->desc[id].min_uV = 900000;
-			pmic->desc[id].uV_step = 50000;
-			pmic->desc[id].linear_min_sel = 1;
-			pmic->desc[id].enable_time = 500;
-			pmic->desc[id].vsel_reg =
-					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
-							   rinfo->vsel_addr);
-			pmic->desc[id].vsel_mask =
-					PALMAS_LDO1_VOLTAGE_VSEL_MASK;
-			pmic->desc[id].enable_reg =
-					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
-							   rinfo->ctrl_addr);
-			pmic->desc[id].enable_mask =
-					PALMAS_LDO1_CTRL_MODE_ACTIVE;
+				desc->ops = &tps65917_ops_ldo;
+			desc->min_uV = 900000;
+			desc->uV_step = 50000;
+			desc->linear_min_sel = 1;
+			desc->enable_time = 500;
+			desc->vsel_reg = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+							    rinfo->vsel_addr);
+			desc->vsel_mask = PALMAS_LDO1_VOLTAGE_VSEL_MASK;
+			desc->enable_reg = PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
+							      rinfo->ctrl_addr);
+			desc->enable_mask = PALMAS_LDO1_CTRL_MODE_ACTIVE;
 			/*
 			 * To be confirmed. Discussion on going with PMIC Team.
 			 * It is of the order of ~60mV/uS.
 			 */
-			pmic->desc[id].ramp_delay = 2500;
+			desc->ramp_delay = 2500;
 		} else {
-			pmic->desc[id].n_voltages = 1;
+			desc->n_voltages = 1;
 			if (reg_init && reg_init->roof_floor)
-				pmic->desc[id].ops =
-					&palmas_ops_ext_control_extreg;
+				desc->ops = &palmas_ops_ext_control_extreg;
 			else
-				pmic->desc[id].ops = &palmas_ops_extreg;
-			pmic->desc[id].enable_reg =
+				desc->ops = &palmas_ops_extreg;
+			desc->enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_RESOURCE_BASE,
 							   rinfo->ctrl_addr);
-			pmic->desc[id].enable_mask =
-					PALMAS_REGEN1_CTRL_MODE_ACTIVE;
+			desc->enable_mask = PALMAS_REGEN1_CTRL_MODE_ACTIVE;
 		}
 
 		if (pdata)
@@ -1044,11 +1033,10 @@ static int tps65917_ldo_registration(struct palmas_pmic *pmic,
 		else
 			config.init_data = NULL;
 
-		pmic->desc[id].supply_name = rinfo->sname;
+		desc->supply_name = rinfo->sname;
 		config.of_node = ddata->palmas_matches[id].of_node;
 
-		rdev = devm_regulator_register(pmic->dev, &pmic->desc[id],
-					       &config);
+		rdev = devm_regulator_register(pmic->dev, desc, &config);
 		if (IS_ERR(rdev)) {
 			dev_err(pmic->dev,
 				"failed to register %s regulator\n",
@@ -1089,6 +1077,7 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 	struct regulator_dev *rdev;
 	struct palmas_reg_init *reg_init;
 	struct palmas_regs_info *rinfo;
+	struct regulator_desc *desc;
 
 	for (id = ddata->smps_start; id <= ddata->smps_end; id++) {
 		bool ramp_delay_support = false;
@@ -1128,6 +1117,7 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 				continue;
 		}
 		rinfo = &ddata->palmas_regs_info[id];
+		desc = &pmic->desc[id];
 
 		if ((id == PALMAS_REG_SMPS6) || (id == PALMAS_REG_SMPS8))
 			ramp_delay_support = true;
@@ -1140,9 +1130,8 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 					"reading TSTEP reg failed: %d\n", ret);
 				return ret;
 			}
-			pmic->desc[id].ramp_delay =
-					palmas_smps_ramp_delay[reg & 0x3];
-			pmic->ramp_delay[id] = pmic->desc[id].ramp_delay;
+			desc->ramp_delay = palmas_smps_ramp_delay[reg & 0x3];
+			pmic->ramp_delay[id] = desc->ramp_delay;
 		}
 
 		/* Initialise sleep/init values from platform data */
@@ -1156,31 +1145,28 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 		}
 
 		/* Register the regulators */
-		pmic->desc[id].name = rinfo->name;
-		pmic->desc[id].id = id;
+		desc->name = rinfo->name;
+		desc->id = id;
 
 		switch (id) {
 		case PALMAS_REG_SMPS10_OUT1:
 		case PALMAS_REG_SMPS10_OUT2:
-			pmic->desc[id].n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
-			pmic->desc[id].ops = &palmas_ops_smps10;
-			pmic->desc[id].vsel_reg =
-					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_CTRL);
-			pmic->desc[id].vsel_mask = SMPS10_VSEL;
-			pmic->desc[id].enable_reg =
-					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_CTRL);
+			desc->n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
+			desc->ops = &palmas_ops_smps10;
+			desc->vsel_reg = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							    PALMAS_SMPS10_CTRL);
+			desc->vsel_mask = SMPS10_VSEL;
+			desc->enable_reg = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							    PALMAS_SMPS10_CTRL);
 			if (id == PALMAS_REG_SMPS10_OUT1)
-				pmic->desc[id].enable_mask = SMPS10_SWITCH_EN;
+				desc->enable_mask = SMPS10_SWITCH_EN;
 			else
-				pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
-			pmic->desc[id].bypass_reg =
-					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_CTRL);
-			pmic->desc[id].bypass_mask = SMPS10_BYPASS_EN;
-			pmic->desc[id].min_uV = 3750000;
-			pmic->desc[id].uV_step = 1250000;
+				desc->enable_mask = SMPS10_BOOST_EN;
+			desc->bypass_reg = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							    PALMAS_SMPS10_CTRL);
+			desc->bypass_mask = SMPS10_BYPASS_EN;
+			desc->min_uV = 3750000;
+			desc->uV_step = 1250000;
 			break;
 		default:
 			/*
@@ -1190,7 +1176,7 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 			 * ranges. Read the current smps mode for later use.
 			 */
 			addr = rinfo->vsel_addr;
-			pmic->desc[id].n_linear_ranges = 3;
+			desc->n_linear_ranges = 3;
 
 			ret = palmas_smps_read(pmic->palmas, addr, &reg);
 			if (ret)
@@ -1198,21 +1184,18 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 			if (reg & PALMAS_SMPS12_VOLTAGE_RANGE)
 				pmic->range[id] = 1;
 			if (pmic->range[id])
-				pmic->desc[id].linear_ranges = smps_high_ranges;
+				desc->linear_ranges = smps_high_ranges;
 			else
-				pmic->desc[id].linear_ranges = smps_low_ranges;
+				desc->linear_ranges = smps_low_ranges;
 
 			if (reg_init && reg_init->roof_floor)
-				pmic->desc[id].ops =
-						&palmas_ops_ext_control_smps;
+				desc->ops = &palmas_ops_ext_control_smps;
 			else
-				pmic->desc[id].ops = &palmas_ops_smps;
-			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
-			pmic->desc[id].vsel_reg =
-					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							   rinfo->vsel_addr);
-			pmic->desc[id].vsel_mask =
-					PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
+				desc->ops = &palmas_ops_smps;
+			desc->n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
+			desc->vsel_reg = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							    rinfo->vsel_addr);
+			desc->vsel_mask = PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
 
 			/* Read the smps mode for later use. */
 			addr = rinfo->ctrl_addr;
@@ -1222,28 +1205,25 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 			pmic->current_reg_mode[id] = reg &
 					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 
-			pmic->desc[id].enable_reg =
-					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							   rinfo->ctrl_addr);
-			pmic->desc[id].enable_mask =
-					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
+			desc->enable_reg = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+							      rinfo->ctrl_addr);
+			desc->enable_mask = PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 			/* set_mode overrides this value */
-			pmic->desc[id].enable_val = SMPS_CTRL_MODE_ON;
+			desc->enable_val = SMPS_CTRL_MODE_ON;
 		}
 
-		pmic->desc[id].type = REGULATOR_VOLTAGE;
-		pmic->desc[id].owner = THIS_MODULE;
+		desc->type = REGULATOR_VOLTAGE;
+		desc->owner = THIS_MODULE;
 
 		if (pdata)
 			config.init_data = pdata->reg_data[id];
 		else
 			config.init_data = NULL;
 
-		pmic->desc[id].supply_name = rinfo->sname;
+		desc->supply_name = rinfo->sname;
 		config.of_node = ddata->palmas_matches[id].of_node;
 
-		rdev = devm_regulator_register(pmic->dev, &pmic->desc[id],
-					       &config);
+		rdev = devm_regulator_register(pmic->dev, desc, &config);
 		if (IS_ERR(rdev)) {
 			dev_err(pmic->dev,
 				"failed to register %s regulator\n",
@@ -1269,13 +1249,15 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 	struct regulator_dev *rdev;
 	struct palmas_reg_init *reg_init;
 	struct palmas_regs_info *rinfo;
+	struct regulator_desc *desc;
 
 	for (id = ddata->smps_start; id <= ddata->smps_end; id++) {
 		/*
 		 * Miss out regulators which are not available due
 		 * to slaving configurations.
 		 */
-		pmic->desc[id].n_linear_ranges = 3;
+		desc = &pmic->desc[id];
+		desc->n_linear_ranges = 3;
 		if ((id == TPS65917_REG_SMPS2) && pmic->smps12)
 			continue;
 
@@ -1291,8 +1273,8 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 		rinfo = &ddata->palmas_regs_info[id];
 
 		/* Register the regulators */
-		pmic->desc[id].name = rinfo->name;
-		pmic->desc[id].id = id;
+		desc->name = rinfo->name;
+		desc->id = id;
 
 		/*
 		 * Read and store the RANGE bit for later use
@@ -1309,24 +1291,19 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 			pmic->range[id] = 1;
 
 		if (pmic->range[id])
-				pmic->desc[id].linear_ranges = smps_high_ranges;
-			else
-				pmic->desc[id].linear_ranges = smps_low_ranges;
-
+			desc->linear_ranges = smps_high_ranges;
+		else
+			desc->linear_ranges = smps_low_ranges;
 
 		if (reg_init && reg_init->roof_floor)
-			pmic->desc[id].ops =
-					&tps65917_ops_ext_control_smps;
+			desc->ops = &tps65917_ops_ext_control_smps;
 		else
-			pmic->desc[id].ops = &tps65917_ops_smps;
-		pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
-		pmic->desc[id].vsel_reg =
-				PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-						   rinfo->vsel_addr);
-		pmic->desc[id].vsel_mask =
-				PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
-
-		pmic->desc[id].ramp_delay = 2500;
+			desc->ops = &tps65917_ops_smps;
+		desc->n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
+		desc->vsel_reg = PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
+						    rinfo->vsel_addr);
+		desc->vsel_mask = PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
+		desc->ramp_delay = 2500;
 
 		/* Read the smps mode for later use. */
 		addr = rinfo->ctrl_addr;
@@ -1336,19 +1313,18 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 		pmic->current_reg_mode[id] = reg &
 				PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 
-		pmic->desc[id].type = REGULATOR_VOLTAGE;
-		pmic->desc[id].owner = THIS_MODULE;
+		desc->type = REGULATOR_VOLTAGE;
+		desc->owner = THIS_MODULE;
 
 		if (pdata)
 			config.init_data = pdata->reg_data[id];
 		else
 			config.init_data = NULL;
 
-		pmic->desc[id].supply_name = rinfo->sname;
+		desc->supply_name = rinfo->sname;
 		config.of_node = ddata->palmas_matches[id].of_node;
 
-		rdev = devm_regulator_register(pmic->dev, &pmic->desc[id],
-					       &config);
+		rdev = devm_regulator_register(pmic->dev, desc, &config);
 		if (IS_ERR(rdev)) {
 			dev_err(pmic->dev,
 				"failed to register %s regulator\n",
-- 
1.7.9.5

