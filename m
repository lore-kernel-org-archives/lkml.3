Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaCGPnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:43:22 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64833 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbaCGPnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:43:21 -0500
Message-ID: <1394206993.17867.3.camel@phoenix>
Subject: [PATCH 2/3] regulator: pbias: Convert to use regmap helper functions
From: Axel Lin <axel.lin@ingics.com>
To: Chris Ball <chris@printf.net>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Balaji T K <balajitk@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Date: Fri, 07 Mar 2014 23:43:13 +0800
In-Reply-To: <1394206897.17867.1.camel@phoenix>
References: <1394206897.17867.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts this driver to use the regmap helper functions provided by
regulator core.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/pbias-regulator.c | 74 ++++++++++---------------------------
 1 file changed, 19 insertions(+), 55 deletions(-)

diff --git a/drivers/regulator/pbias-regulator.c b/drivers/regulator/pbias-regulator.c
index d89a1d8..6d38be3 100644
--- a/drivers/regulator/pbias-regulator.c
+++ b/drivers/regulator/pbias-regulator.c
@@ -38,66 +38,24 @@ struct pbias_reg_info {
 struct pbias_regulator_data {
 	struct regulator_desc desc;
 	void __iomem *pbias_addr;
-	unsigned int pbias_reg;
 	struct regulator_dev *dev;
 	struct regmap *syscon;
 	const struct pbias_reg_info *info;
 	int voltage;
 };
 
-static int pbias_regulator_set_voltage(struct regulator_dev *dev,
-			int min_uV, int max_uV, unsigned *selector)
-{
-	struct pbias_regulator_data *data = rdev_get_drvdata(dev);
-	const struct pbias_reg_info *info = data->info;
-	int ret, vmode;
-
-	if (min_uV <= 1800000)
-		vmode = 0;
-	else if (min_uV > 1800000)
-		vmode = info->vmode;
-
-	ret = regmap_update_bits(data->syscon, data->pbias_reg,
-						info->vmode, vmode);
-
-	return ret;
-}
-
-static int pbias_regulator_get_voltage(struct regulator_dev *rdev)
-{
-	struct pbias_regulator_data *data = rdev_get_drvdata(rdev);
-	const struct pbias_reg_info *info = data->info;
-	int value, voltage;
-
-	regmap_read(data->syscon, data->pbias_reg, &value);
-	value &= info->vmode;
-
-	voltage = value ? 3000000 : 1800000;
-
-	return voltage;
-}
+static const unsigned int pbias_volt_table[] = {
+	1800000,
+	3000000
+};
 
 static int pbias_regulator_enable(struct regulator_dev *rdev)
 {
 	struct pbias_regulator_data *data = rdev_get_drvdata(rdev);
 	const struct pbias_reg_info *info = data->info;
-	int ret;
-
-	ret = regmap_update_bits(data->syscon, data->pbias_reg,
-					info->enable_mask, info->enable);
-
-	return ret;
-}
-
-static int pbias_regulator_disable(struct regulator_dev *rdev)
-{
-	struct pbias_regulator_data *data = rdev_get_drvdata(rdev);
-	const struct pbias_reg_info *info = data->info;
-	int ret;
 
-	ret = regmap_update_bits(data->syscon, data->pbias_reg,
-						info->enable_mask, 0);
-	return ret;
+	return regmap_update_bits(data->syscon, rdev->desc->enable_reg,
+				  info->enable_mask, info->enable);
 }
 
 static int pbias_regulator_is_enable(struct regulator_dev *rdev)
@@ -106,17 +64,18 @@ static int pbias_regulator_is_enable(struct regulator_dev *rdev)
 	const struct pbias_reg_info *info = data->info;
 	int value;
 
-	regmap_read(data->syscon, data->pbias_reg, &value);
+	regmap_read(data->syscon, rdev->desc->enable_reg, &value);
 
 	return (value & info->enable_mask) == info->enable;
 }
 
 static struct regulator_ops pbias_regulator_voltage_ops = {
-	.set_voltage	= pbias_regulator_set_voltage,
-	.get_voltage	= pbias_regulator_get_voltage,
-	.enable		= pbias_regulator_enable,
-	.disable	= pbias_regulator_disable,
-	.is_enabled	= pbias_regulator_is_enable,
+	.list_voltage = regulator_list_voltage_table,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.enable = pbias_regulator_enable,
+	.disable = regulator_disable_regmap,
+	.is_enabled = pbias_regulator_is_enable,
 };
 
 static const struct pbias_reg_info pbias_mmc_omap2430 = {
@@ -192,6 +151,7 @@ static int pbias_regulator_probe(struct platform_device *pdev)
 	if (IS_ERR(syscon))
 		return PTR_ERR(syscon);
 
+	cfg.regmap = syscon;
 	cfg.dev = &pdev->dev;
 
 	for (idx = 0; idx < PBIAS_NUM_REGS && data_idx < count; idx++) {
@@ -207,15 +167,19 @@ static int pbias_regulator_probe(struct platform_device *pdev)
 		if (!res)
 			return -EINVAL;
 
-		drvdata[data_idx].pbias_reg = res->start;
 		drvdata[data_idx].syscon = syscon;
 		drvdata[data_idx].info = info;
 		drvdata[data_idx].desc.name = info->name;
 		drvdata[data_idx].desc.owner = THIS_MODULE;
 		drvdata[data_idx].desc.type = REGULATOR_VOLTAGE;
 		drvdata[data_idx].desc.ops = &pbias_regulator_voltage_ops;
+		drvdata[data_idx].desc.volt_table = pbias_volt_table;
 		drvdata[data_idx].desc.n_voltages = 2;
 		drvdata[data_idx].desc.enable_time = info->enable_time;
+		drvdata[data_idx].desc.vsel_reg = res->start;
+		drvdata[data_idx].desc.vsel_mask = info->vmode;
+		drvdata[data_idx].desc.enable_reg = res->start;
+		drvdata[data_idx].desc.enable_mask = info->enable_mask;
 
 		cfg.init_data = pbias_matches[idx].init_data;
 		cfg.driver_data = &drvdata[data_idx];
-- 
1.8.1.2



