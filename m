Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaF0RPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:15:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57858 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbaF0RPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:15:07 -0400
Date: Fri, 27 Jun 2014 12:15:03 -0500
From: Nishanth Menon <nm@ti.com>
To: Keerthy <a0393675@ti.com>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Keerthy <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <t-kristo@ti.com>
Subject: Re: [PATCH] regulator: tps65917: Fix SMPS enable/disable/is_enable
Message-ID: <20140627171503.GA26734@kahuna>
References: <1403807494-23907-1-git-send-email-nm@ti.com>
 <53AD36E1.1010700@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53AD36E1.1010700@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:48-20140627, Keerthy wrote:
> Hello Nishanth,
> 
> On Friday 27 June 2014 12:01 AM, Nishanth Menon wrote:
> >We use regmap regulator ops to enable/disable and check if regulator
> >is enabled for various SMPS. However, these depend on valid
> >enable_reg, enable_mask and enable_value in regulator descriptor.
> >
> >So, similar to fix we did in commit 318dbb02b50c
> >("regulator: palmas: Fix SMPS enable/disable/is_enabled"), populate the
> >same for TPS65917 SMPS registration. LDO definitions are already in place.
> >
> >Fixes: d6f83370ed97 ("regulator: palmas: Add tps65917 PMIC support")
> >Signed-off-by: Nishanth Menon <nm@ti.com>
> >---
> >
> >Applies on:
> >	git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
> >branch: topic/palmas (4c0c9ca Merge remote-tracking branch 'regulator/fix/palmas' into regulator-palmas)
> >
> >Note: Ignored the minor style check from checkpatch --strict as fixing
> >it would create an 80 char warning
> >
> >  drivers/regulator/palmas-regulator.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> >diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> >index 7c8b441..c7aa1b1 100644
> >--- a/drivers/regulator/palmas-regulator.c
> >+++ b/drivers/regulator/palmas-regulator.c
> >@@ -1333,6 +1333,14 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
> >  		pmic->current_reg_mode[id] = reg &
> >  				PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
> >+		pmic->desc[id].enable_reg =
> >+				PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
> >+					palmas_regs_info[id].ctrl_addr);
> 
> This is wrong. Please change palmas_regs_info[id].ctrl_addr to
> ddata->palmas_regs_info[id].ctrl_addr. The palmas_regs_info
> should come from the driver data for specific instances as the regmap
> is different for the different PMICs we support.
> 
> Once you make the above changes please feel free to add

Uggh.. just realized... since I was testing CPUFREQ with SMPS1 never
realized it. and searched elsewhere on topic/palmas branch as well..
Looks like we should make the following changes? since the register data
is now a parameter and it so happened that palmas_reg_info was mapping
back to a valid variable and the error is easily missed - so rename the
variable as well - I can break this up as proper series of patches for
topic/palmas - let me know what you think..


diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 7c8b441..86fefdfb 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -41,7 +41,7 @@ static const struct regulator_linear_range smps_high_ranges[] = {
 	REGULATOR_LINEAR_RANGE(3300000, 0x7A, 0x7f, 0),
 };
 
-static struct regs_info palmas_regs_info[] = {
+static struct regs_info palmas_generic_regs_info[] = {
 	{
 		.name		= "SMPS12",
 		.sname		= "smps1-in",
@@ -1165,18 +1165,18 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 			pmic->desc[id].ops = &palmas_ops_smps10;
 			pmic->desc[id].vsel_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_CTRL);
+					        ddata->palmas_regs_info[id].ctrl_addr);
 			pmic->desc[id].vsel_mask = SMPS10_VSEL;
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_CTRL);
+					        ddata->palmas_regs_info[id].ctrl_addr);
 			if (id == PALMAS_REG_SMPS10_OUT1)
 				pmic->desc[id].enable_mask = SMPS10_SWITCH_EN;
 			else
 				pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
 			pmic->desc[id].bypass_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-							PALMAS_SMPS10_CTRL);
+					        ddata->palmas_regs_info[id].ctrl_addr);
 			pmic->desc[id].bypass_mask = SMPS10_BYPASS_EN;
 			pmic->desc[id].min_uV = 3750000;
 			pmic->desc[id].uV_step = 1250000;
@@ -1188,7 +1188,7 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 			 * otherwise we error in probe with unsupportable
 			 * ranges. Read the current smps mode for later use.
 			 */
-			addr = palmas_regs_info[id].vsel_addr;
+			addr = ddata->palmas_regs_info[id].vsel_addr;
 			pmic->desc[id].n_linear_ranges = 3;
 
 			ret = palmas_smps_read(pmic->palmas, addr, &reg);
@@ -1209,12 +1209,12 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
 			pmic->desc[id].vsel_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-						palmas_regs_info[id].vsel_addr);
+						ddata->palmas_regs_info[id].vsel_addr);
 			pmic->desc[id].vsel_mask =
 					PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
 
 			/* Read the smps mode for later use. */
-			addr = palmas_regs_info[id].ctrl_addr;
+			addr = ddata->palmas_regs_info[id].ctrl_addr;
 			ret = palmas_smps_read(pmic->palmas, addr, &reg);
 			if (ret)
 				return ret;
@@ -1223,7 +1223,7 @@ static int palmas_smps_registration(struct palmas_pmic *pmic,
 
 			pmic->desc[id].enable_reg =
 					PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-						palmas_regs_info[id].ctrl_addr);
+						ddata->palmas_regs_info[id].ctrl_addr);
 			pmic->desc[id].enable_mask =
 					PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 			/* set_mode overrides this value */
@@ -1319,7 +1319,7 @@ static int tps65917_smps_registration(struct palmas_pmic *pmic,
 		pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
 		pmic->desc[id].vsel_reg =
 				PALMAS_BASE_TO_REG(PALMAS_SMPS_BASE,
-						   tps65917_regs_info[id].vsel_addr);
+					        ddata->palmas_regs_info[id].vsel_addr);
 		pmic->desc[id].vsel_mask =
 				PALMAS_SMPS12_VOLTAGE_VSEL_MASK;
 
@@ -1414,7 +1414,7 @@ struct palmas_pmic_driver_data palmas_ddata = {
 	.ldo_begin = PALMAS_REG_LDO1,
 	.ldo_end = PALMAS_REG_LDOUSB,
 	.max_reg = PALMAS_NUM_REGS,
-	.palmas_regs_info = palmas_regs_info,
+	.palmas_regs_info = palmas_generic_regs_info,
 	.palmas_matches = palmas_matches,
 	.sleep_req_info = palma_sleep_req_info,
 	.smps_register = palmas_smps_registration,
-- 
Regards,
Nishanth Menon
