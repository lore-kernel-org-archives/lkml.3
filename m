Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaCFNKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 08:10:43 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:52971 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaCFNKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 08:10:40 -0500
Message-ID: <1394111433.21007.2.camel@phoenix>
Subject: [PATCH RFT] regulator: pbias: Convert to use regmap helper functions
From: Axel Lin <axel.lin@ingics.com>
To: Chris Ball <chris@printf.net>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc: Balaji T K <balajitk@ti.com>, Florian Vaussard <florian.vaussard@epfl.ch>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Date: Thu, 06 Mar 2014 21:10:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts this driver to use the regmap helper functions provided by
regulator core.

This fixes a few issues in current implementation:

1) In original code, the set voltage does not check max_uV,
   which means if request max_uV < 1800000, it will still set the voltage
   to 1800000.

2) The is_enable implementation is wrong in some cases:
   e.g. for pbias_mmc_omap5: emable_mask is : BIT(27) | BIT(25) | BIT(26)
   However, pbias_regulator_enable() only sets BIT(26) | BIT(22) bits.
   So is_enable always return false in this case.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Balaji,
I don't have this h/w, so please test if it works.
Regards,
Axel
 drivers/regulator/pbias-regulator.c | 86 ++++++++++---------------------------
 1 file changed, 23 insertions(+), 63 deletions(-)

diff --git a/drivers/regulator/pbias-regulator.c b/drivers/regulator/pbias-regulator.c
index ded3b35..f25c91e 100644
--- a/drivers/regulator/pbias-regulator.c
+++ b/drivers/regulator/pbias-regulator.c
@@ -38,85 +38,41 @@ struct pbias_reg_info {
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
+static int pbias_regulator_list_voltage(struct regulator_dev *rdev,
+					unsigned int selector)
 {
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
+	switch (selector) {
+	case 0:
+		return 1800000;
+	case 1:
+		return 3000000;
+	default:
+		return -EINVAL;
+	}
 }
 
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
-
-	ret = regmap_update_bits(data->syscon, data->pbias_reg,
-						info->enable_mask, 0);
-	return ret;
-}
-
-static int pbias_regulator_is_enable(struct regulator_dev *rdev)
-{
-	struct pbias_regulator_data *data = rdev_get_drvdata(rdev);
-	const struct pbias_reg_info *info = data->info;
-	int value;
-
-	regmap_read(data->syscon, data->pbias_reg, &value);
 
-	return (value & info->enable_mask) == info->enable_mask;
+	return regmap_update_bits(data->syscon, rdev->desc->enable_reg,
+				  info->enable_mask, info->enable);
 }
 
 static struct regulator_ops pbias_regulator_voltage_ops = {
-	.set_voltage	= pbias_regulator_set_voltage,
-	.get_voltage	= pbias_regulator_get_voltage,
-	.enable		= pbias_regulator_enable,
-	.disable	= pbias_regulator_disable,
-	.is_enabled	= pbias_regulator_is_enable,
+	.list_voltage = pbias_regulator_list_voltage,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+	.enable = pbias_regulator_enable,
+	.disable = regulator_disable_regmap,
+	.is_enabled = regulator_is_enabled_regmap,
 };
 
 static const struct pbias_reg_info pbias_mmc_omap2430 = {
@@ -192,6 +148,7 @@ static int pbias_regulator_probe(struct platform_device *pdev)
 	if (IS_ERR(syscon))
 		return PTR_ERR(syscon);
 
+	cfg.regmap = syscon;
 	cfg.dev = &pdev->dev;
 
 	for (idx = 0; idx < PBIAS_NUM_REGS && data_idx < count; idx++) {
@@ -207,7 +164,6 @@ static int pbias_regulator_probe(struct platform_device *pdev)
 		if (!res)
 			return -EINVAL;
 
-		drvdata[data_idx].pbias_reg = res->start;
 		drvdata[data_idx].syscon = syscon;
 		drvdata[data_idx].info = info;
 		drvdata[data_idx].desc.name = info->name;
@@ -216,6 +172,10 @@ static int pbias_regulator_probe(struct platform_device *pdev)
 		drvdata[data_idx].desc.ops = &pbias_regulator_voltage_ops;
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



