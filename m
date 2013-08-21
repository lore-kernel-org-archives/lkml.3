Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab3HUKcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:32:18 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16132 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3HUKcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:32:15 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 Aug 2013 03:32:14 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@kernel.org>, <sameo@linux.intel.com>
CC: <swarren@wwwdotorg.org>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <rob@landley.net>, <lee.jones@linaro.org>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gg@slimlogic.co.uk>, <kishon@ti.com>, <j-keerthy@ti.com>,
        <ian.campbell@citrix.com>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4] regulator: palmas: add support for external control of rails
Date: Wed, 21 Aug 2013 16:18:16 +0530
Message-ID: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas rails like LDOs, SMPSs, REGENs, SYSENs can be enable and disable
by register programming through I2C communication as well as it can be
enable/disable with the external control input ENABLE1, ENABLE2 and NSLEEP.

Add support for configuring these rails to be controlled by external control
inputs. This is require to configure the rail's control register as well as
configuration of resource register.

Provide the external input names through parameter "roof-floor". Updated the
DT binding document to details different value of the roof-floor.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- Fix typos: palams ->palmas
Changes from V2:
- Make roof-floor with optional argument. If no argument then assume
  NSLEEP control.
Changes from V3:
- Nit changes..
- print warn() if invalid option for roof-floor.
- use siwtch-case for property value checking.

PS: This patch was part of series (3/3)
        regulator: palmas: add support for external control of rail
Patch 1/3 and 2/3 is already applied as 1/3 is in the regulator tree and
Patch 2/3 is in the mfd tree by Samuel.
This patch (was 3/3) very much depends on the 2/3 for compilation and hence
it need to go on same tree as 2/3 to avoid any compilation error.

 .../devicetree/bindings/regulator/palmas-pmic.txt  |   12 +-
 drivers/regulator/palmas-regulator.c               |  164 +++++++++++++++++++-
 2 files changed, 167 insertions(+), 9 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
index 875639a..42e6b6b 100644
--- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
+++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
@@ -26,11 +26,17 @@ Optional nodes:
 
 	       For ti,palmas-pmic - smps12, smps123, smps3 depending on OTP,
 	       smps45, smps457, smps7 depending on variant, smps6, smps[8-9],
-	       smps10_out2, smps10_out1, do[1-9], ldoln, ldousb.
+	       smps10_out2, smps10_out1, ldo[1-9], ldoln, ldousb.
 
 	       Optional sub-node properties:
 	       ti,warm-reset - maintain voltage during warm reset(boolean)
-	       ti,roof-floor - control voltage selection by pin(boolean)
+	       ti,roof-floor - This takes as optional argument on platform supporting
+	       the rail from desired external control. If there is no argument then
+	       it will be assume that it is controlled by NSLEEP pin.
+	       The valid value for external pins are:
+			ENABLE1 then 1,
+			ENABLE2 then 2 or
+			NSLEEP then 3.
 	       ti,mode-sleep - mode to adopt in pmic sleep 0 - off, 1 - auto,
 	       2 - eco, 3 - forced pwm
 	       ti,smps-range - OTP has the wrong range set for the hardware so override
@@ -61,7 +67,7 @@ pmic {
 			regulator-always-on;
 			regulator-boot-on;
 			ti,warm-reset;
-			ti,roof-floor;
+			ti,roof-floor = <1>; /* ENABLE1 control */
 			ti,mode-sleep = <0>;
 			ti,smps-range = <1>;
 		};
diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 488dfe7..3c08e1b 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -33,6 +33,7 @@ struct regs_info {
 	u8	vsel_addr;
 	u8	ctrl_addr;
 	u8	tstep_addr;
+	int	sleep_id;
 };
 
 static const struct regs_info palmas_regs_info[] = {
@@ -42,6 +43,7 @@ static const struct regs_info palmas_regs_info[] = {
 		.vsel_addr	= PALMAS_SMPS12_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS12_CTRL,
 		.tstep_addr	= PALMAS_SMPS12_TSTEP,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS12,
 	},
 	{
 		.name		= "SMPS123",
@@ -49,12 +51,14 @@ static const struct regs_info palmas_regs_info[] = {
 		.vsel_addr	= PALMAS_SMPS12_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS12_CTRL,
 		.tstep_addr	= PALMAS_SMPS12_TSTEP,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS12,
 	},
 	{
 		.name		= "SMPS3",
 		.sname		= "smps3-in",
 		.vsel_addr	= PALMAS_SMPS3_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS3_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS3,
 	},
 	{
 		.name		= "SMPS45",
@@ -62,6 +66,7 @@ static const struct regs_info palmas_regs_info[] = {
 		.vsel_addr	= PALMAS_SMPS45_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS45_CTRL,
 		.tstep_addr	= PALMAS_SMPS45_TSTEP,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS45,
 	},
 	{
 		.name		= "SMPS457",
@@ -69,6 +74,7 @@ static const struct regs_info palmas_regs_info[] = {
 		.vsel_addr	= PALMAS_SMPS45_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS45_CTRL,
 		.tstep_addr	= PALMAS_SMPS45_TSTEP,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS45,
 	},
 	{
 		.name		= "SMPS6",
@@ -76,12 +82,14 @@ static const struct regs_info palmas_regs_info[] = {
 		.vsel_addr	= PALMAS_SMPS6_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS6_CTRL,
 		.tstep_addr	= PALMAS_SMPS6_TSTEP,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS6,
 	},
 	{
 		.name		= "SMPS7",
 		.sname		= "smps7-in",
 		.vsel_addr	= PALMAS_SMPS7_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS7_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS7,
 	},
 	{
 		.name		= "SMPS8",
@@ -89,108 +97,128 @@ static const struct regs_info palmas_regs_info[] = {
 		.vsel_addr	= PALMAS_SMPS8_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS8_CTRL,
 		.tstep_addr	= PALMAS_SMPS8_TSTEP,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS8,
 	},
 	{
 		.name		= "SMPS9",
 		.sname		= "smps9-in",
 		.vsel_addr	= PALMAS_SMPS9_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS9_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS9,
 	},
 	{
 		.name		= "SMPS10_OUT2",
 		.sname		= "smps10-in",
 		.ctrl_addr	= PALMAS_SMPS10_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS10,
 	},
 	{
 		.name		= "SMPS10_OUT1",
 		.sname		= "smps10-out2",
 		.ctrl_addr	= PALMAS_SMPS10_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SMPS10,
 	},
 	{
 		.name		= "LDO1",
 		.sname		= "ldo1-in",
 		.vsel_addr	= PALMAS_LDO1_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO1_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDO1,
 	},
 	{
 		.name		= "LDO2",
 		.sname		= "ldo2-in",
 		.vsel_addr	= PALMAS_LDO2_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO2_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDO2,
 	},
 	{
 		.name		= "LDO3",
 		.sname		= "ldo3-in",
 		.vsel_addr	= PALMAS_LDO3_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO3_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDO3,
 	},
 	{
 		.name		= "LDO4",
 		.sname		= "ldo4-in",
 		.vsel_addr	= PALMAS_LDO4_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO4_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDO4,
 	},
 	{
 		.name		= "LDO5",
 		.sname		= "ldo5-in",
 		.vsel_addr	= PALMAS_LDO5_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO5_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDO5,
 	},
 	{
 		.name		= "LDO6",
 		.sname		= "ldo6-in",
 		.vsel_addr	= PALMAS_LDO6_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO6_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDO6,
 	},
 	{
 		.name		= "LDO7",
 		.sname		= "ldo7-in",
 		.vsel_addr	= PALMAS_LDO7_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO7_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDO7,
 	},
 	{
 		.name		= "LDO8",
 		.sname		= "ldo8-in",
 		.vsel_addr	= PALMAS_LDO8_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO8_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDO8,
 	},
 	{
 		.name		= "LDO9",
 		.sname		= "ldo9-in",
 		.vsel_addr	= PALMAS_LDO9_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO9_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDO9,
 	},
 	{
 		.name		= "LDOLN",
 		.sname		= "ldoln-in",
 		.vsel_addr	= PALMAS_LDOLN_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDOLN_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDOLN,
 	},
 	{
 		.name		= "LDOUSB",
 		.sname		= "ldousb-in",
 		.vsel_addr	= PALMAS_LDOUSB_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDOUSB_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_LDOUSB,
 	},
 	{
 		.name		= "REGEN1",
 		.ctrl_addr	= PALMAS_REGEN1_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_REGEN1,
 	},
 	{
 		.name		= "REGEN2",
 		.ctrl_addr	= PALMAS_REGEN2_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_REGEN2,
 	},
 	{
 		.name		= "REGEN3",
 		.ctrl_addr	= PALMAS_REGEN3_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_REGEN3,
 	},
 	{
 		.name		= "SYSEN1",
 		.ctrl_addr	= PALMAS_SYSEN1_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SYSEN1,
 	},
 	{
 		.name		= "SYSEN2",
 		.ctrl_addr	= PALMAS_SYSEN2_CTRL,
+		.sleep_id	= PALMAS_EXTERNAL_REQSTR_ID_SYSEN2,
 	},
 };
 
@@ -484,6 +512,17 @@ static struct regulator_ops palmas_ops_smps = {
 	.set_ramp_delay		= palmas_smps_set_ramp_delay,
 };
 
+static struct regulator_ops palmas_ops_ext_control_smps = {
+	.set_mode		= palmas_set_mode_smps,
+	.get_mode		= palmas_get_mode_smps,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= palmas_list_voltage_smps,
+	.map_voltage		= palmas_map_voltage_smps,
+	.set_voltage_time_sel	= palma_smps_set_voltage_smps_time_sel,
+	.set_ramp_delay		= palmas_smps_set_ramp_delay,
+};
+
 static struct regulator_ops palmas_ops_smps10 = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
@@ -519,12 +558,37 @@ static struct regulator_ops palmas_ops_ldo = {
 	.map_voltage		= regulator_map_voltage_linear,
 };
 
+static struct regulator_ops palmas_ops_ext_control_ldo = {
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+};
+
 static struct regulator_ops palmas_ops_extreg = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
 };
 
+static struct regulator_ops palmas_ops_ext_control_extreg = {
+};
+
+static int palmas_regulator_config_external(struct palmas *palmas, int id,
+		struct palmas_reg_init *reg_init)
+{
+	int sleep_id = palmas_regs_info[id].sleep_id;
+	int ret;
+
+	ret = palmas_ext_control_req_config(palmas, sleep_id,
+					reg_init->roof_floor, true);
+	if (ret < 0)
+		dev_err(palmas->dev,
+			"Ext control config for regulator %d failed %d\n",
+			id, ret);
+	return ret;
+}
+
 /*
  * setup the hardware based sleep configuration of the SMPS/LDO regulators
  * from the platform data. This is different to the software based control
@@ -583,7 +647,22 @@ static int palmas_smps_init(struct palmas *palmas, int id,
 			return ret;
 	}
 
+	if (reg_init->roof_floor && (id != PALMAS_REG_SMPS10_OUT1) &&
+			(id != PALMAS_REG_SMPS10_OUT2)) {
+		/* Enable externally controlled regulator */
+		addr = palmas_regs_info[id].ctrl_addr;
+		ret = palmas_smps_read(palmas, addr, &reg);
+		if (ret < 0)
+			return ret;
 
+		if (!(reg & PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK)) {
+			reg |= SMPS_CTRL_MODE_ON;
+			ret = palmas_smps_write(palmas, addr, reg);
+			if (ret < 0)
+				return ret;
+		}
+		return palmas_regulator_config_external(palmas, id, reg_init);
+	}
 	return 0;
 }
 
@@ -614,6 +693,20 @@ static int palmas_ldo_init(struct palmas *palmas, int id,
 	if (ret)
 		return ret;
 
+	if (reg_init->roof_floor) {
+		/* Enable externally controlled regulator */
+		addr = palmas_regs_info[id].ctrl_addr;
+		ret = palmas_update_bits(palmas, PALMAS_LDO_BASE,
+				addr, PALMAS_LDO1_CTRL_MODE_ACTIVE,
+				PALMAS_LDO1_CTRL_MODE_ACTIVE);
+		if (ret < 0) {
+			dev_err(palmas->dev,
+				"LDO Register 0x%02x update failed %d\n",
+				addr, ret);
+			return ret;
+		}
+		return palmas_regulator_config_external(palmas, id, reg_init);
+	}
 	return 0;
 }
 
@@ -636,6 +729,21 @@ static int palmas_extreg_init(struct palmas *palmas, int id,
 			addr, ret);
 		return ret;
 	}
+
+	if (reg_init->roof_floor) {
+		/* Enable externally controlled regulator */
+		addr = palmas_regs_info[id].ctrl_addr;
+		ret = palmas_update_bits(palmas, PALMAS_RESOURCE_BASE,
+				addr, PALMAS_REGEN1_CTRL_MODE_ACTIVE,
+				PALMAS_REGEN1_CTRL_MODE_ACTIVE);
+		if (ret < 0) {
+			dev_err(palmas->dev,
+				"Resource Register 0x%02x update failed %d\n",
+				addr, ret);
+			return ret;
+		}
+		return palmas_regulator_config_external(palmas, id, reg_init);
+	}
 	return 0;
 }
 
@@ -746,9 +854,35 @@ static void palmas_dt_to_pdata(struct device *dev,
 			of_property_read_bool(palmas_matches[idx].of_node,
 					     "ti,warm-reset");
 
-		pdata->reg_init[idx]->roof_floor =
-			of_property_read_bool(palmas_matches[idx].of_node,
-					      "ti,roof-floor");
+		ret = of_property_read_u32(palmas_matches[idx].of_node,
+					      "ti,roof-floor", &prop);
+		/* EINVAL: Property not found */
+		if (ret != -EINVAL) {
+			int econtrol;
+
+			/* use default value, when no value is specified */
+			econtrol = PALMAS_EXT_CONTROL_NSLEEP;
+			if (!ret) {
+				switch (prop) {
+				case 1:
+					econtrol = PALMAS_EXT_CONTROL_ENABLE1;
+					break;
+				case 2:
+					econtrol = PALMAS_EXT_CONTROL_ENABLE2;
+					break;
+				case 3:
+					econtrol = PALMAS_EXT_CONTROL_NSLEEP;
+					break;
+				default:
+					WARN_ON(1);
+					dev_warn(dev,
+					"%s: Invalid roof-floor option: %u\n",
+					     palmas_matches[idx].name, prop);
+					break;
+				}
+			}
+			pdata->reg_init[idx]->roof_floor = econtrol;
+		}
 
 		ret = of_property_read_u32(palmas_matches[idx].of_node,
 				"ti,mode-sleep", &prop);
@@ -875,6 +1009,8 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			ret = palmas_smps_init(palmas, id, reg_init);
 			if (ret)
 				goto err_unregister_regulator;
+		} else {
+			reg_init = NULL;
 		}
 
 		/* Register the regulators */
@@ -919,7 +1055,11 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			if (reg & PALMAS_SMPS12_VOLTAGE_RANGE)
 				pmic->range[id] = 1;
 
-			pmic->desc[id].ops = &palmas_ops_smps;
+			if (reg_init && reg_init->roof_floor)
+				pmic->desc[id].ops =
+						&palmas_ops_ext_control_smps;
+			else
+				pmic->desc[id].ops = &palmas_ops_smps;
 			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
 			pmic->desc[id].vsel_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
@@ -962,6 +1102,10 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 
 	/* Start this loop from the id left from previous loop */
 	for (; id < PALMAS_NUM_REGS; id++) {
+		if (pdata && pdata->reg_init[id])
+			reg_init = pdata->reg_init[id];
+		else
+			reg_init = NULL;
 
 		/* Miss out regulators which are not available due
 		 * to alternate functions.
@@ -975,7 +1119,11 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 
 		if (id < PALMAS_REG_REGEN1) {
 			pmic->desc[id].n_voltages = PALMAS_LDO_NUM_VOLTAGES;
-			pmic->desc[id].ops = &palmas_ops_ldo;
+			if (reg_init && reg_init->roof_floor)
+				pmic->desc[id].ops =
+					&palmas_ops_ext_control_ldo;
+			else
+				pmic->desc[id].ops = &palmas_ops_ldo;
 			pmic->desc[id].min_uV = 900000;
 			pmic->desc[id].uV_step = 50000;
 			pmic->desc[id].linear_min_sel = 1;
@@ -999,7 +1147,11 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 			}
 		} else {
 			pmic->desc[id].n_voltages = 1;
-			pmic->desc[id].ops = &palmas_ops_extreg;
+			if (reg_init && reg_init->roof_floor)
+				pmic->desc[id].ops =
+					&palmas_ops_ext_control_extreg;
+			else
+				pmic->desc[id].ops = &palmas_ops_extreg;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_RESOURCE_BASE,
 						palmas_regs_info[id].ctrl_addr);
-- 
1.7.1.1

