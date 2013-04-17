Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966379Ab3DQNnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 09:43:45 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:33735 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966116Ab3DQNnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 09:43:43 -0400
Message-ID: <1366206219.3305.5.camel@phoenix>
Subject: [RFT][PATCH 2/2] regulator: tps80031: Convert tps80031_dcdc_ops to
 [get|set]_voltage_sel_regmap
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Apr 2013 21:43:39 +0800
In-Reply-To: <1366206143.3305.4.camel@phoenix>
References: <1366206143.3305.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps80031-regulator.c |   39 +++++---------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff --git a/drivers/regulator/tps80031-regulator.c b/drivers/regulator/tps80031-regulator.c
index 6430789..6511d0b 100644
--- a/drivers/regulator/tps80031-regulator.c
+++ b/drivers/regulator/tps80031-regulator.c
@@ -282,37 +282,6 @@ static int tps80031_ldo_map_voltage(struct regulator_dev *rdev,
 	return regulator_map_voltage_linear(rdev, min_uV, max_uV);
 }
 
-static int tps80031_ldo_set_voltage_sel(struct regulator_dev *rdev,
-		unsigned sel)
-{
-	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps80031_dev(rdev);
-	int ret;
-
-	ret = tps80031_write(parent, ri->rinfo->volt_id,
-			ri->rinfo->volt_reg, sel);
-	if (ret < 0)
-		dev_err(ri->dev, "Error in writing reg 0x%02x, e = %d\n",
-			ri->rinfo->volt_reg, ret);
-	return ret;
-}
-
-static int tps80031_ldo_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
-	struct device *parent = to_tps80031_dev(rdev);
-	uint8_t vsel;
-	int ret;
-
-	ret = tps80031_read(parent, ri->rinfo->volt_id,
-				ri->rinfo->volt_reg, &vsel);
-	if (ret < 0) {
-		dev_err(ri->dev, "Error in writing the Voltage register\n");
-		return ret;
-	}
-	return vsel & rdev->desc->vsel_mask;
-}
-
 static int tps80031_vbus_is_enabled(struct regulator_dev *rdev)
 {
 	struct tps80031_regulator *ri = rdev_get_drvdata(rdev);
@@ -421,8 +390,8 @@ static struct regulator_ops tps80031_dcdc_ops = {
 static struct regulator_ops tps80031_ldo_ops = {
 	.list_voltage		= tps80031_ldo_list_voltage,
 	.map_voltage		= tps80031_ldo_map_voltage,
-	.set_voltage_sel	= tps80031_ldo_set_voltage_sel,
-	.get_voltage_sel	= tps80031_ldo_get_voltage_sel,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.enable			= tps80031_reg_enable,
 	.disable		= tps80031_reg_disable,
 	.is_enabled		= tps80031_reg_is_enabled,
@@ -489,6 +458,7 @@ static struct regulator_ops tps80031_ext_reg_ops = {
 		.uV_step = 100000,				\
 		.linear_min_sel = 1,				\
 		.n_voltages = 25,				\
+		.vsel_reg = TPS80031_##_id##_CFG_VOLTAGE,	\
 		.vsel_mask = LDO_VSEL_MASK,			\
 		.enable_time = 500,				\
 	},							\
@@ -710,6 +680,7 @@ static int tps80031_regulator_probe(struct platform_device *pdev)
 	struct tps80031_regulator *pmic;
 	struct regulator_dev *rdev;
 	struct regulator_config config = { };
+	struct tps80031 *tps80031_mfd = dev_get_drvdata(pdev->dev.parent);
 	int ret;
 	int num;
 
@@ -737,6 +708,8 @@ static int tps80031_regulator_probe(struct platform_device *pdev)
 		config.dev = &pdev->dev;
 		config.init_data = NULL;
 		config.driver_data = ri;
+		config.regmap = tps80031_mfd->regmap[ri->rinfo->volt_id];
+
 		if (tps_pdata) {
 			config.init_data = tps_pdata->reg_init_data;
 			ri->config_flags = tps_pdata->config_flags;
-- 
1.7.10.4



