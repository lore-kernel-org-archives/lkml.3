Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751046AbaDOECS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:02:18 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:49552 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaDOECR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:02:17 -0400
Message-ID: <1397534528.23871.1.camel@phoenix>
Subject: [PATCH] regulator: pbias: Convert to use
 regulator_[enable|is_enabled]_regmap
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Balaji T K <balajitk@ti.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 12:02:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ca5d1b3524b4d
"regulator: helpers: Modify helpers enabling multi-bit control",
we can set enable_val setting for device that use multiple bits for control
when using regmap enable/disable/bypass ops.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Tested-by: Balaji T K <balajitk@ti.com>
---
 drivers/regulator/pbias-regulator.c | 25 +++----------------------
 1 file changed, 3 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/pbias-regulator.c b/drivers/regulator/pbias-regulator.c
index 6d38be3..708ddbb 100644
--- a/drivers/regulator/pbias-regulator.c
+++ b/drivers/regulator/pbias-regulator.c
@@ -49,33 +49,13 @@ static const unsigned int pbias_volt_table[] = {
 	3000000
 };
 
-static int pbias_regulator_enable(struct regulator_dev *rdev)
-{
-	struct pbias_regulator_data *data = rdev_get_drvdata(rdev);
-	const struct pbias_reg_info *info = data->info;
-
-	return regmap_update_bits(data->syscon, rdev->desc->enable_reg,
-				  info->enable_mask, info->enable);
-}
-
-static int pbias_regulator_is_enable(struct regulator_dev *rdev)
-{
-	struct pbias_regulator_data *data = rdev_get_drvdata(rdev);
-	const struct pbias_reg_info *info = data->info;
-	int value;
-
-	regmap_read(data->syscon, rdev->desc->enable_reg, &value);
-
-	return (value & info->enable_mask) == info->enable;
-}
-
 static struct regulator_ops pbias_regulator_voltage_ops = {
 	.list_voltage = regulator_list_voltage_table,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
-	.enable = pbias_regulator_enable,
+	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
-	.is_enabled = pbias_regulator_is_enable,
+	.is_enabled = regulator_is_enabled_regmap,
 };
 
 static const struct pbias_reg_info pbias_mmc_omap2430 = {
@@ -180,6 +160,7 @@ static int pbias_regulator_probe(struct platform_device *pdev)
 		drvdata[data_idx].desc.vsel_mask = info->vmode;
 		drvdata[data_idx].desc.enable_reg = res->start;
 		drvdata[data_idx].desc.enable_mask = info->enable_mask;
+		drvdata[data_idx].desc.enable_val = info->enable;
 
 		cfg.init_data = pbias_matches[idx].init_data;
 		cfg.driver_data = &drvdata[data_idx];
-- 
1.8.1.2



