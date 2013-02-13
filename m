Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759143Ab3BMJBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:01:24 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:37902 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3BMJBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:01:22 -0500
Message-ID: <1360746069.8799.2.camel@phoenix>
Subject: [PATCH] regulator: tps51632: Use
 regulator_[get|set]_voltage_sel_regmap
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2013 17:01:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps51632-regulator.c |   52 +++++---------------------------
 1 file changed, 8 insertions(+), 44 deletions(-)

diff --git a/drivers/regulator/tps51632-regulator.c b/drivers/regulator/tps51632-regulator.c
index 7560d07..6e67be7 100644
--- a/drivers/regulator/tps51632-regulator.c
+++ b/drivers/regulator/tps51632-regulator.c
@@ -88,49 +88,8 @@ struct tps51632_chip {
 	struct regulator_desc desc;
 	struct regulator_dev *rdev;
 	struct regmap *regmap;
-	bool enable_pwm_dvfs;
 };
 
-static int tps51632_dcdc_get_voltage_sel(struct regulator_dev *rdev)
-{
-	struct tps51632_chip *tps = rdev_get_drvdata(rdev);
-	unsigned int data;
-	int ret;
-	unsigned int reg = TPS51632_VOLTAGE_SELECT_REG;
-	int vsel;
-
-	if (tps->enable_pwm_dvfs)
-		reg = TPS51632_VOLTAGE_BASE_REG;
-
-	ret = regmap_read(tps->regmap, reg, &data);
-	if (ret < 0) {
-		dev_err(tps->dev, "reg read failed, err %d\n", ret);
-		return ret;
-	}
-
-	vsel = data & TPS51632_VOUT_MASK;
-	return vsel;
-}
-
-static int tps51632_dcdc_set_voltage_sel(struct regulator_dev *rdev,
-		unsigned selector)
-{
-	struct tps51632_chip *tps = rdev_get_drvdata(rdev);
-	int ret;
-	unsigned int reg = TPS51632_VOLTAGE_SELECT_REG;
-
-	if (tps->enable_pwm_dvfs)
-		reg = TPS51632_VOLTAGE_BASE_REG;
-
-	if (selector > TPS51632_MAX_VSEL)
-		return -EINVAL;
-
-	ret = regmap_write(tps->regmap, reg, selector);
-	if (ret < 0)
-		dev_err(tps->dev, "reg write failed, err %d\n", ret);
-	return ret;
-}
-
 static int tps51632_dcdc_set_ramp_delay(struct regulator_dev *rdev,
 		int ramp_delay)
 {
@@ -147,8 +106,8 @@ static int tps51632_dcdc_set_ramp_delay(struct regulator_dev *rdev,
 }
 
 static struct regulator_ops tps51632_dcdc_ops = {
-	.get_voltage_sel	= tps51632_dcdc_get_voltage_sel,
-	.set_voltage_sel	= tps51632_dcdc_set_voltage_sel,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.list_voltage		= regulator_list_voltage_linear,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_ramp_delay		= tps51632_dcdc_set_ramp_delay,
@@ -165,7 +124,6 @@ static int tps51632_init_dcdc(struct tps51632_chip *tps,
 		goto skip_pwm_config;
 
 	control |= TPS51632_DVFS_PWMEN;
-	tps->enable_pwm_dvfs = pdata->enable_pwm_dvfs;
 	vsel = TPS51632_VOLT_VSEL(pdata->base_voltage_uV);
 	ret = regmap_write(tps->regmap, TPS51632_VOLTAGE_BASE_REG, vsel);
 	if (ret < 0) {
@@ -358,6 +316,12 @@ static int tps51632_probe(struct i2c_client *client,
 	tps->desc.type = REGULATOR_VOLTAGE;
 	tps->desc.owner = THIS_MODULE;
 
+	if (pdata->enable_pwm_dvfs)
+		tps->desc.vsel_reg = TPS51632_VOLTAGE_BASE_REG;
+	else
+		tps->desc.vsel_reg = TPS51632_VOLTAGE_SELECT_REG;
+	tps->desc.vsel_mask = TPS51632_VOUT_MASK;
+
 	tps->regmap = devm_regmap_init_i2c(client, &tps51632_regmap_config);
 	if (IS_ERR(tps->regmap)) {
 		ret = PTR_ERR(tps->regmap);
-- 
1.7.9.5



