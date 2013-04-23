Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3DWDy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 23:54:56 -0400
Received: from mail-da0-f51.google.com ([209.85.210.51]:47422 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478Ab3DWDyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 23:54:54 -0400
Message-ID: <1366689288.25625.3.camel@phoenix>
Subject: [PATCH] regulator: tps65023: Use [set|get]_voltage_sel_regmap
 instead of open coded
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>
Date: Tue, 23 Apr 2013 11:54:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply the [get|set]_voltage_sel implementation by using
regulator_[set|get]_voltage_sel_regmap instead of open coded.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps65023-regulator.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 9b9af6d..d91e230 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -154,20 +154,15 @@ struct tps_driver_data {
 static int tps65023_dcdc_get_voltage_sel(struct regulator_dev *dev)
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
-	int ret;
-	int data, dcdc = rdev_get_id(dev);
+	int dcdc = rdev_get_id(dev);
 
 	if (dcdc < TPS65023_DCDC_1 || dcdc > TPS65023_DCDC_3)
 		return -EINVAL;
 
-	if (dcdc == tps->core_regulator) {
-		ret = regmap_read(tps->regmap, TPS65023_REG_DEF_CORE, &data);
-		if (ret != 0)
-			return ret;
-		data &= (tps->info[dcdc]->table_len - 1);
-		return data;
-	} else
+	if (dcdc != tps->core_regulator)
 		return 0;
+
+	return regulator_get_voltage_sel_regmap(dev);
 }
 
 static int tps65023_dcdc_set_voltage_sel(struct regulator_dev *dev,
@@ -175,23 +170,11 @@ static int tps65023_dcdc_set_voltage_sel(struct regulator_dev *dev,
 {
 	struct tps_pmic *tps = rdev_get_drvdata(dev);
 	int dcdc = rdev_get_id(dev);
-	int ret;
 
 	if (dcdc != tps->core_regulator)
 		return -EINVAL;
 
-	ret = regmap_write(tps->regmap, TPS65023_REG_DEF_CORE, selector);
-	if (ret)
-		goto out;
-
-	/* Tell the chip that we have changed the value in DEFCORE
-	 * and its time to update the core voltage
-	 */
-	ret = regmap_update_bits(tps->regmap, TPS65023_REG_CON_CTRL2,
-				 TPS65023_REG_CTRL2_GO, TPS65023_REG_CTRL2_GO);
-
-out:
-	return ret;
+	return regulator_set_voltage_sel_regmap(dev, selector);
 }
 
 /* Operations permitted on VDCDCx */
@@ -285,6 +268,10 @@ static int tps_65023_probe(struct i2c_client *client,
 		default: /* DCDCx */
 			tps->desc[i].enable_mask =
 					1 << (TPS65023_NUM_REGULATOR - i);
+			tps->desc[i].vsel_reg = TPS65023_REG_DEF_CORE;
+			tps->desc[i].vsel_mask = info->table_len - 1;
+			tps->desc[i].apply_reg = TPS65023_REG_CON_CTRL2;
+			tps->desc[i].apply_bit = TPS65023_REG_CTRL2_GO;
 		}
 
 		config.dev = &client->dev;
-- 
1.7.10.4



