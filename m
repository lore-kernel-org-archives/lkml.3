Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbaF3P7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:59:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35805 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbaF3P5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:57:49 -0400
From: Nishanth Menon <nm@ti.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Keerthy J <j-keerthy@ti.com>
CC: Tero Kristo <t-kristo@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 3/6] regulator: palmas: Simplify code by using pointer to palmas_reg_info
Date: Mon, 30 Jun 2014 10:57:36 -0500
Message-ID: <1404143859-8160-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404143859-8160-1-git-send-email-nm@ti.com>
References: <1404143859-8160-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas register information is part of the ddata pointer which is used
through out the code by indexing off the driver data array. Instead,
just do the indexing once and use the pointer to further reference
structure fields.

This simplifies code and prevents errors by accessing wrong variables.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/regulator/palmas-regulator.c |  109 +++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 53 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 05f11b9..f75fb90 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -434,14 +434,14 @@ static int palmas_ldo_write(struct palmas *palmas, unsigned int reg,
 
 static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
 {
+	int id = rdev_get_id(dev);
 	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
 	struct palmas_pmic_driver_data *ddata = pmic->palmas->pmic_ddata;
-	int id = rdev_get_id(dev);
+	struct palmas_regs_info *rinfo = &ddata->palmas_regs_info[id];
 	unsigned int reg;
 	bool rail_enable = true;
 
-	palmas_smps_read(pmic->palmas, ddata->palmas_regs_info[id].ctrl_addr,
-			 &reg);
+	palmas_smps_read(pmic->palmas, rinfo->ctrl_addr, &reg);
 
 	reg &= ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 
@@ -464,8 +464,7 @@ static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
 
 	pmic->current_reg_mode[id] = reg & PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 	if (rail_enable)
-		palmas_smps_write(pmic->palmas,
-				  ddata->palmas_regs_info[id].ctrl_addr, reg);
+		palmas_smps_write(pmic->palmas, rinfo->ctrl_addr, reg);
 
 	/* Switch the enable value to ensure this is used for enable */
 	pmic->desc[id].enable_val = pmic->current_reg_mode[id];
@@ -496,11 +495,11 @@ static unsigned int palmas_get_mode_smps(struct regulator_dev *dev)
 static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
 		 int ramp_delay)
 {
+	int id = rdev_get_id(rdev);
 	struct palmas_pmic *pmic = rdev_get_drvdata(rdev);
 	struct palmas_pmic_driver_data *ddata = pmic->palmas->pmic_ddata;
-	int id = rdev_get_id(rdev);
+	struct palmas_regs_info *rinfo = &ddata->palmas_regs_info[id];
 	unsigned int reg = 0;
-	unsigned int addr = ddata->palmas_regs_info[id].tstep_addr;
 	int ret;
 
 	/* SMPS3 and SMPS7 do not have tstep_addr setting */
@@ -519,7 +518,7 @@ static int palmas_smps_set_ramp_delay(struct regulator_dev *rdev,
 	else
 		reg = 1;
 
-	ret = palmas_smps_write(pmic->palmas, addr, reg);
+	ret = palmas_smps_write(pmic->palmas, rinfo->tstep_addr, reg);
 	if (ret < 0) {
 		dev_err(pmic->palmas->dev, "TSTEP write failed: %d\n", ret);
 		return ret;
@@ -590,13 +589,13 @@ static struct regulator_ops tps65917_ops_ext_control_smps = {
 
 static int palmas_is_enabled_ldo(struct regulator_dev *dev)
 {
+	int id = rdev_get_id(dev);
 	struct palmas_pmic *pmic = rdev_get_drvdata(dev);
 	struct palmas_pmic_driver_data *ddata = pmic->palmas->pmic_ddata;
-	int id = rdev_get_id(dev);
+	struct palmas_regs_info *rinfo = &ddata->palmas_regs_info[id];
 	unsigned int reg;
 
-	palmas_ldo_read(pmic->palmas,
-			ddata->palmas_regs_info[id].ctrl_addr, &reg);
+	palmas_ldo_read(pmic->palmas, rinfo->ctrl_addr, &reg);
 
 	reg &= PALMAS_LDO1_CTRL_STATUS;
 
@@ -643,11 +642,12 @@ static struct regulator_ops tps65917_ops_ldo = {
 static int palmas_regulator_config_external(struct palmas *palmas, int id,
 		struct palmas_reg_init *reg_init)
 {
-	int sleep_id = palmas_regs_info[id].sleep_id;
+	struct palmas_pmic_driver_data *ddata = palmas->pmic_ddata;
+	struct palmas_regs_info *rinfo = &ddata->palmas_regs_info[id];
 	int ret;
 
-	ret = palmas_ext_control_req_config(palmas, sleep_id,
-					reg_init->roof_floor, true);
+	ret = palmas_ext_control_req_config(palmas, rinfo->sleep_id,
+					    reg_init->roof_floor, true);
 	if (ret < 0)
 		dev_err(palmas->dev,
 			"Ext control config for regulator %d failed %d\n",
@@ -665,12 +665,10 @@ static int palmas_smps_init(struct palmas *palmas, int id,
 		struct palmas_reg_init *reg_init)
 {
 	unsigned int reg;
-	unsigned int addr;
 	int ret;
-
 	struct palmas_pmic_driver_data *ddata = palmas->pmic_ddata;
-
-	addr = ddata->palmas_regs_info[id].ctrl_addr;
+	struct palmas_regs_info *rinfo = &ddata->palmas_regs_info[id];
+	unsigned int addr = rinfo->ctrl_addr;
 
 	ret = palmas_smps_read(palmas, addr, &reg);
 	if (ret)
@@ -705,12 +703,11 @@ static int palmas_smps_init(struct palmas *palmas, int id,
 	if (ret)
 		return ret;
 
-	if (ddata->palmas_regs_info[id].vsel_addr && reg_init->vsel) {
-		addr = ddata->palmas_regs_info[id].vsel_addr;
+	if (rinfo->vsel_addr && reg_init->vsel) {
 
 		reg = reg_init->vsel;
 
-		ret = palmas_smps_write(palmas, addr, reg);
+		ret = palmas_smps_write(palmas, rinfo->vsel_addr, reg);
 		if (ret)
 			return ret;
 	}
@@ -718,7 +715,6 @@ static int palmas_smps_init(struct palmas *palmas, int id,
 	if (reg_init->roof_floor && (id != PALMAS_REG_SMPS10_OUT1) &&
 			(id != PALMAS_REG_SMPS10_OUT2)) {
 		/* Enable externally controlled regulator */
-		addr = ddata->palmas_regs_info[id].ctrl_addr;
 		ret = palmas_smps_read(palmas, addr, &reg);
 		if (ret < 0)
 			return ret;
@@ -740,10 +736,10 @@ static int palmas_ldo_init(struct palmas *palmas, int id,
 	unsigned int reg;
 	unsigned int addr;
 	int ret;
-
 	struct palmas_pmic_driver_data *ddata = palmas->pmic_ddata;
+	struct palmas_regs_info *rinfo = &ddata->palmas_regs_info[id];
 
-	addr = ddata->palmas_regs_info[id].ctrl_addr;
+	addr = rinfo->ctrl_addr;
 
 	ret = palmas_ldo_read(palmas, addr, &reg);
 	if (ret)
@@ -765,7 +761,6 @@ static int palmas_ldo_init(struct palmas *palmas, int id,
 
 	if (reg_init->roof_floor) {
 		/* Enable externally controlled regulator */
-		addr = ddata->palmas_regs_info[id].ctrl_addr;
 		ret = palmas_update_bits(palmas, PALMAS_LDO_BASE,
 				addr, PALMAS_LDO1_CTRL_MODE_ACTIVE,
 				PALMAS_LDO1_CTRL_MODE_ACTIVE);
@@ -786,10 +781,10 @@ static int palmas_extreg_init(struct palmas *palmas, int id,
 	unsigned int addr;
 	int ret;
 	unsigned int val = 0;
-
 	struct palmas_pmic_driver_data *ddata = palmas->pmic_ddata;
+	struct palmas_regs_info *rinfo = &ddata->palmas_regs_info[id];
 
-	addr = ddata->palmas_regs_info[id].ctrl_addr;
+	addr = rinfo->ctrl_addr;
 
 	if (reg_init->mode_sleep)
 		val = PALMAS_REGEN1_CTRL_MODE_SLEEP;
@@ -804,7 +799,6 @@ static int palmas_extreg_init(struct palmas *palmas, int id,
 
 	if (reg_init->roof_floor) {
 		/* Enable externally controlled regulator */
-		addr = ddata->palmas_regs_info[id].ctrl_addr;
 		ret = palmas_update_bits(palmas, PALMAS_RESOURCE_BASE,
 				addr, PALMAS_REGEN1_CTRL_MODE_ACTIVE,
 				PALMAS_REGEN1_CTRL_MODE_ACTIVE);
@@ -824,10 +818,11 @@ static void palmas_enable_ldo8_track(struct palmas *palmas)
 	unsigned int reg;
 	unsigned int addr;
 	int ret;
-
 	struct palmas_pmic_driver_data *ddata = palmas->pmic_ddata;
+	struct palmas_regs_info *rinfo;
 
-	addr = ddata->palmas_regs_info[PALMAS_REG_LDO8].ctrl_addr;
+	rinfo = &ddata->palmas_regs_info[PALMAS_REG_LDO8];
+	addr = rinfo->ctrl_addr;
 
 	ret = palmas_ldo_read(palmas, addr, &reg);
 	if (ret) {
@@ -846,7 +841,7 @@ static void palmas_enable_ldo8_track(struct palmas *palmas)
 	 * output is defined by the LDO8_VOLTAGE.VSEL register divided by two,
 	 * and can be set from 0.45 to 1.65 V.
 	 */
-	addr = ddata->palmas_regs_info[PALMAS_REG_LDO8].vsel_addr;
+	addr = rinfo->vsel_addr;
 	ret = palmas_ldo_read(palmas, addr, &reg);
 	if (ret) {
 		dev_err(palmas->dev, "Error in reading ldo8 voltage reg\n");
@@ -870,6 +865,7 @@ static int palmas_ldo_registration(struct palmas_pmic *pmic,
 	int id, ret;
 	struct regulator_dev *rdev;
 	struct palmas_reg_init *reg_init;
+	struct palmas_regs_info *rinfo;
 
 	for (id = ddata->ldo_begin; id < ddata->max_reg; id++) {
 		if (pdata && pdata->reg_init[id])
@@ -877,12 +873,13 @@ static int palmas_ldo_registration(struct palmas_pmic *pmic,
 		else
 			reg_init = NULL;
 
+		rinfo = &ddata->palmas_regs_info[id];
 		/* Miss out regulators which are not available due
 		 * to alternate functions.
 		 */
 
 		/* Register the regulators */
-		pmic->desc[id].name = ddata->palmas_regs_info[id].name;
+		pmic->desc[id].name = rinfo->name;
 		pmic->desc[id].id = id;
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
 		pmic->desc[id].owner = THIS_MODULE;
@@ -900,12 +897,12 @@ static int palmas_ldo_registration(struct palmas_pmic *pmic,
 			pmic->desc[id].enable_time = 500;
 			pmic->desc[id].vsel_reg =
 					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
-							   ddata->palmas_regs_info[id].vsel_addr);
+							   rinfo->vsel_addr);
 			pmic->desc[id].vsel_mask =
 					PALMAS_LDO1_VOLTAGE_VSEL_MASK;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
-							   ddata->palmas_regs_info[id].ctrl_addr);
+							   rinfo->ctrl_addr);
 			pmic->desc[id].enable_mask =
 					PALMAS_LDO1_CTRL_MODE_ACTIVE;
 
@@ -930,7 +927,7 @@ static int palmas_ldo_registration(struct palmas_pmic *pmic,
 				pmic->desc[id].ops = &palmas_ops_extreg;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_RESOURCE_BASE,
-							   ddata->palmas_regs_info[id].ctrl_addr);
+							   rinfo->ctrl_addr);
 			pmic->desc[id].enable_mask =
 					PALMAS_REGEN1_CTRL_MODE_ACTIVE;
 		}
@@ -940,7 +937,7 @@ static int palmas_ldo_registration(struct palmas_pmic *pmic,
 		else
 			config.init_data = NULL;
 
-		pmic->desc[id].supply_name = ddata->palmas_regs_info[id].sname;
+		pmic->desc[id].supply_name = rinfo->sname;
 		config.of_node = ddata->palmas_matches[id].of_node;
 
 		rdev = devm_regulator_register(pmic->dev, &pmic->desc[id],
@@ -983,6 +980,7 @@ static int tps65917_ldo_registration(struct palmas_pmic *pmic,
 	int id, ret;
 	struct regulator_dev *rdev;
 	struct palmas_reg_init *reg_init;
+	struct palmas_regs_info *rinfo;
 
 	for (id = ddata->ldo_begin; id < ddata->max_reg; id++) {
 		if (pdata && pdata->reg_init[id])
@@ -993,9 +991,10 @@ static int tps65917_ldo_registration(struct palmas_pmic *pmic,
 		/* Miss out regulators which are not available due
 		 * to alternate functions.
 		 */
+		rinfo = &ddata->palmas_regs_info[id];
 
 		/* Register the regulators */
-		pmic->desc[id].name = ddata->palmas_regs_info[id].name;
+		pmic->desc[id].name = rinfo->name;
 		pmic->desc[id].id = id;
 		pmic->desc[id].type = REGULATOR_VOLTAGE;
 		pmic->desc[id].owner = THIS_MODULE;
@@ -1013,12 +1012,12 @@ static int tps65917_ldo_registration(struct palmas_pmic *pmic,
 			pmic->desc[id].enable_time = 500;
 			pmic->desc[id].vsel_reg =
 					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
-							   ddata->palmas_regs_info[id].vsel_addr);
+							   rinfo->vsel_addr);
 			pmic->desc[id].vsel_mask =
 					PALMAS_LDO1_VOLTAGE_VSEL_MASK;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_LDO_BASE,
-							   ddata->palmas_regs_info[id].ctrl_addr);
+							   rinfo->ctrl_addr);
 			pmic->desc[id].enable_mask =
 					PALMAS_LDO1_CTRL_MODE_ACTIVE;
 			/*
@@ -1035,7 +1034,7 @@ static int tps65917_ldo_registration(struct palmas_pmic *pmic,
 				pmic->desc[id].ops = &palmas_ops_extreg;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_RESOURCE_BASE,
-							   ddata->palmas_regs_info[id].ctrl_addr);
+							   rinfo->ctrl_addr);
 			pmic->desc[id].enable_mask =
 					PALMAS_REGEN1_CTRL_MODE_ACTIVE;
 		}
@@ -1045,7 +1044,7 @@ static int tps65917_ldo_registration(struct palmas_pmic *pmic,
 		else
 			config.init_data = NULL;
 
-		pmic->desc[id].supply_name = ddata->palmas_regs_info[id].sname;
+		pmic->desc[id].supply_name = rinfo->sname;
 		config.of_node = ddata->palmas_matches[id].of_node;
 
 		rdev = devm_regulator_register(pmic->dev, &pmic->desc[id],
@@ -1089,6 +1088,7 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 	unsigned int addr, reg;
 	struct regulator_dev *rdev;
 	struct palmas_reg_init *reg_init;
+	struct palmas_regs_info *rinfo;
 
 	for (id = ddata->smps_start; id <= ddata->smps_end; id++) {
 		bool ramp_delay_support = false;
@@ -1127,12 +1127,13 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 			if (!PALMAS_PMIC_HAS(pmic->palmas, SMPS10_BOOST))
 				continue;
 		}
+		rinfo = &ddata->palmas_regs_info[id];
 
 		if ((id == PALMAS_REG_SMPS6) || (id == PALMAS_REG_SMPS8))
 			ramp_delay_support = true;
 
 		if (ramp_delay_support) {
-			addr = ddata->palmas_regs_info[id].tstep_addr;
+			addr = rinfo->tstep_addr;
 			ret = palmas_smps_read(pmic->palmas, addr, &reg);
 			if (ret < 0) {
 				dev_err(pmic->dev,
@@ -1155,7 +1156,7 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 		}
 
 		/* Register the regulators */
-		pmic->desc[id].name = ddata->palmas_regs_info[id].name;
+		pmic->desc[id].name = rinfo->name;
 		pmic->desc[id].id = id;
 
 		switch (id) {
@@ -1188,7 +1189,7 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 			 * otherwise we error in probe with unsupportable
 			 * ranges. Read the current smps mode for later use.
 			 */
-			addr = palmas_regs_info[id].vsel_addr;
+			addr = rinfo->vsel_addr;
 			pmic->desc[id].n_linear_ranges = 3;
 
 			ret = palmas_smps_read(pmic->palmas, addr, &reg);
@@ -1209,12 +1210,12 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
 			pmic->desc[id].vsel_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-						palmas_regs_info[id].vsel_addr);
+							   rinfo->vsel_addr);
 			pmic->desc[id].vsel_mask =
 					PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
 
 			/* Read the smps mode for later use. */
-			addr = palmas_regs_info[id].ctrl_addr;
+			addr = rinfo->ctrl_addr;
 			ret = palmas_smps_read(pmic->palmas, addr, &reg);
 			if (ret)
 				return ret;
@@ -1223,7 +1224,7 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-						palmas_regs_info[id].ctrl_addr);
+							   rinfo->ctrl_addr);
 			pmic->desc[id].enable_mask =
 					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 			/* set_mode overrides this value */
@@ -1238,7 +1239,7 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 		else
 			config.init_data = NULL;
 
-		pmic->desc[id].supply_name = ddata->palmas_regs_info[id].sname;
+		pmic->desc[id].supply_name = rinfo->sname;
 		config.of_node = ddata->palmas_matches[id].of_node;
 
 		rdev = devm_regulator_register(pmic->dev, &pmic->desc[id],
@@ -1267,6 +1268,7 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 	unsigned int addr, reg;
 	struct regulator_dev *rdev;
 	struct palmas_reg_init *reg_init;
+	struct palmas_regs_info *rinfo;
 
 	for (id = ddata->smps_start; id <= ddata->smps_end; id++) {
 		/*
@@ -1286,9 +1288,10 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 		} else {
 			reg_init = NULL;
 		}
+		rinfo = &ddata->palmas_regs_info[id];
 
 		/* Register the regulators */
-		pmic->desc[id].name = ddata->palmas_regs_info[id].name;
+		pmic->desc[id].name = rinfo->name;
 		pmic->desc[id].id = id;
 
 		/*
@@ -1297,7 +1300,7 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 		 * otherwise we error in probe with unsupportable
 		 * ranges. Read the current smps mode for later use.
 		 */
-		addr = ddata->palmas_regs_info[id].vsel_addr;
+		addr = rinfo->vsel_addr;
 
 		ret = palmas_smps_read(pmic->palmas, addr, &reg);
 		if (ret)
@@ -1319,14 +1322,14 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 		pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
 		pmic->desc[id].vsel_reg =
 				PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-						   tps65917_regs_info[id].vsel_addr);
+						   rinfo->vsel_addr);
 		pmic->desc[id].vsel_mask =
 				PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
 
 		pmic->desc[id].ramp_delay = 2500;
 
 		/* Read the smps mode for later use. */
-		addr = ddata->palmas_regs_info[id].ctrl_addr;
+		addr = rinfo->ctrl_addr;
 		ret = palmas_smps_read(pmic->palmas, addr, &reg);
 		if (ret)
 			return ret;
@@ -1341,7 +1344,7 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 		else
 			config.init_data = NULL;
 
-		pmic->desc[id].supply_name = ddata->palmas_regs_info[id].sname;
+		pmic->desc[id].supply_name = rinfo->sname;
 		config.of_node = ddata->palmas_matches[id].of_node;
 
 		rdev = devm_regulator_register(pmic->dev, &pmic->desc[id],
-- 
1.7.9.5

