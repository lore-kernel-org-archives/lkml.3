Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbaHEBGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:06:40 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.108]:26843 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753441AbaHEBGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:06:38 -0400
X-Env-Sender: James.Ban.opensource@diasemi.com
X-Msg-Ref: server-15.tower-194.messagelabs.com!1407200794!19707530!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <201408050102.s7512cAr016807@krsrvapps-01.diasemi.com>
From: James Ban <james.ban.opensource@diasemi.com>
Date: Tue, 5 Aug 2014 09:56:45 +0900
Subject: [PATCH V1] regulator: DA9211 : support DA9213
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: David Dajun Chen <david.chen@diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch for supporting DA9213.

Signed-off-by: James Ban <james.ban.opensource@diasemi.com>
---

This patch is relative to linux-next repository tag next-20140729.
 drivers/regulator/Kconfig            |    9 ++--
 drivers/regulator/da9211-regulator.c |   78 ++++++++++++++++++++++++----------
 drivers/regulator/da9211-regulator.h |    7 ++-
 include/linux/regulator/da9211.h     |    7 ++-
 4 files changed, 71 insertions(+), 30 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 2dc8289..1344aa8 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -199,13 +199,14 @@ config REGULATOR_DA9210
 	  interface.
 
 config REGULATOR_DA9211
-	tristate "Dialog Semiconductor DA9211/DA9212 regulator"
+	tristate "Dialog Semiconductor DA9211/DA9212/DA9213/DA9214 regulator"
 	depends on I2C
 	select REGMAP_I2C
 	help
-	  Say y here to support for the Dialog Semiconductor DA9211/DA9212.
-	  The DA9211/DA9212 is a multi-phase synchronous step down
-	  converter 12A DC-DC Buck controlled through an I2C
+	  Say y here to support for the Dialog Semiconductor DA9211/DA9212
+	  /DA9213/DA9214.
+	  The DA9211/DA9212/DA9213/DA9214 is a multi-phase synchronous
+	  step down converter 12A or 16A DC-DC Buck controlled through an I2C
 	  interface.
 
 config REGULATOR_DBX500_PRCMU
diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index 1482ada..bbafe62 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -1,5 +1,5 @@
 /*
- * da9211-regulator.c - Regulator device driver for DA9211
+ * da9211-regulator.c - Regulator device driver for DA9211/DA9213
  * Copyright (C) 2014  Dialog Semiconductor Ltd.
  *
  * This library is free software; you can redistribute it and/or
@@ -27,6 +27,10 @@
 #include <linux/regulator/da9211.h>
 #include "da9211-regulator.h"
 
+/* DEVICE IDs */
+#define DA9211_DEVICE_ID	0x22
+#define DA9213_DEVICE_ID	0x23
+
 #define DA9211_BUCK_MODE_SLEEP	1
 #define DA9211_BUCK_MODE_SYNC	2
 #define DA9211_BUCK_MODE_AUTO	3
@@ -42,6 +46,7 @@ struct da9211 {
 	struct regulator_dev *rdev[DA9211_MAX_REGULATORS];
 	int num_regulator;
 	int chip_irq;
+	int chip_id;
 };
 
 static const struct regmap_range_cfg da9211_regmap_range[] = {
@@ -52,14 +57,14 @@ static const struct regmap_range_cfg da9211_regmap_range[] = {
 		.window_start = 0,
 		.window_len = 256,
 		.range_min = 0,
-		.range_max = 2*256,
+		.range_max = 5*128,
 	},
 };
 
 static const struct regmap_config da9211_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
-	.max_register = 2 * 256,
+	.max_register = 5 * 128,
 	.ranges = da9211_regmap_range,
 	.num_ranges = ARRAY_SIZE(da9211_regmap_range),
 };
@@ -69,10 +74,16 @@ static const struct regmap_config da9211_regmap_config = {
 #define DA9211_MAX_MV		1570
 #define DA9211_STEP_MV		10
 
-/* Current limits for buck (uA) indices corresponds with register values */
-static const int da9211_current_limits[] = {
-	2000000, 2200000, 2400000, 2600000, 2800000, 3000000, 3200000, 3400000,
-	3600000, 3800000, 4000000, 4200000, 4400000, 4600000, 4800000, 5000000
+/* Current limits for DA9211/DA9213 buck (uA) indices
+ *corresponds with register values
+ */
+static const int da9211_current_limits[2][16] = {
+	/* DA9211 current limits */
+	{2000000, 2200000, 2400000, 2600000, 2800000, 3000000, 3200000, 3400000,
+	3600000, 3800000, 4000000, 4200000, 4400000, 4600000, 4800000, 5000000},
+	/* DA9213 current limits */
+	{3000000, 3200000, 3400000, 3600000, 3800000, 4000000, 4200000, 4400000,
+	4600000, 4800000, 5000000, 5200000, 5400000, 5600000, 5800000, 6000000},
 };
 
 static unsigned int da9211_buck_get_mode(struct regulator_dev *rdev)
@@ -129,12 +140,15 @@ static int da9211_set_current_limit(struct regulator_dev *rdev, int min,
 {
 	int id = rdev_get_id(rdev);
 	struct da9211 *chip = rdev_get_drvdata(rdev);
-	int i;
+	int i, row = 0;
+
+	if (chip->chip_id == DA9213)
+		row = 1;
 
 	/* search for closest to maximum */
-	for (i = ARRAY_SIZE(da9211_current_limits)-1; i >= 0; i--) {
-		if (min <= da9211_current_limits[i] &&
-		    max >= da9211_current_limits[i]) {
+	for (i = ARRAY_SIZE(da9211_current_limits[row])-1; i >= 0; i--) {
+		if (min <= da9211_current_limits[row][i] &&
+		    max >= da9211_current_limits[row][i]) {
 				return regmap_update_bits(chip->regmap,
 					DA9211_REG_BUCK_ILIM,
 					(0x0F << id*4), (i << id*4));
@@ -149,15 +163,20 @@ static int da9211_get_current_limit(struct regulator_dev *rdev)
 	int id = rdev_get_id(rdev);
 	struct da9211 *chip = rdev_get_drvdata(rdev);
 	unsigned int data;
-	int ret;
+	int ret, row = 0;
+
+	if (chip->chip_id == DA9213)
+		row = 1;
 
 	ret = regmap_read(chip->regmap, DA9211_REG_BUCK_ILIM, &data);
 	if (ret < 0)
 		return ret;
 
-	/* select one of 16 values: 0000 (2000mA) to 1111 (5000mA) */
+	/* select one of 16 values: 0000 (2000mA or 3000mA)
+	 * to 1111 (5000mA or 6000mA).
+	 */
 	data = (data >> id*4) & 0x0F;
-	return da9211_current_limits[data];
+	return da9211_current_limits[row][data];
 }
 
 static struct regulator_ops da9211_buck_ops = {
@@ -264,10 +283,7 @@ static int da9211_regulator_init(struct da9211 *chip)
 	}
 
 	for (i = 0; i < chip->num_regulator; i++) {
-		if (chip->pdata)
-			config.init_data =
-				&(chip->pdata->init_data[i]);
-
+		config.init_data = &(chip->pdata->init_data[i]);
 		config.dev = chip->dev;
 		config.driver_data = chip;
 		config.regmap = chip->regmap;
@@ -301,6 +317,7 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 {
 	struct da9211 *chip;
 	int error, ret;
+	unsigned int data;
 
 	chip = devm_kzalloc(&i2c->dev, sizeof(struct da9211), GFP_KERNEL);
 
@@ -308,7 +325,7 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 	chip->regmap = devm_regmap_init_i2c(i2c, &da9211_regmap_config);
 	if (IS_ERR(chip->regmap)) {
 		error = PTR_ERR(chip->regmap);
-		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
+		dev_err(chip->dev, "Failed to allocate register map: %d\n",
 			error);
 		return error;
 	}
@@ -316,8 +333,22 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 	i2c_set_clientdata(i2c, chip);
 
 	chip->pdata = i2c->dev.platform_data;
+	chip->chip_id = id->driver_data;
+
+	ret = regmap_read(chip->regmap, DA9211_REG_DEVICE_ID, &data);
+	if (ret < 0) {
+		dev_err(chip->dev, "Failed to read DEVICE_ID reg: %d\n", ret);
+		return ret;
+	}
+
+	if (!(chip->chip_id == DA9211 && data == DA9211_DEVICE_ID)
+		&& !(chip->chip_id == DA9213 && data == DA9213_DEVICE_ID)) {
+		dev_err(chip->dev, "Chip ID and configuration is mismatched\n");
+		ret = -ENODEV;
+		return ret;
+	}
 	if (!chip->pdata) {
-		dev_err(&i2c->dev, "No platform init data supplied\n");
+		dev_err(chip->dev, "No platform init data supplied\n");
 		return -ENODEV;
 	}
 
@@ -340,13 +371,14 @@ static int da9211_i2c_probe(struct i2c_client *i2c,
 	ret = da9211_regulator_init(chip);
 
 	if (ret < 0)
-		dev_err(&i2c->dev, "Failed to initialize regulator: %d\n", ret);
+		dev_err(chip->dev, "Failed to initialize regulator: %d\n", ret);
 
 	return ret;
 }
 
 static const struct i2c_device_id da9211_i2c_id[] = {
-	{"da9211", 0},
+	{"da9211", DA9211},
+	{"da9213", DA9213},
 	{},
 };
 
@@ -364,5 +396,5 @@ static struct i2c_driver da9211_regulator_driver = {
 module_i2c_driver(da9211_regulator_driver);
 
 MODULE_AUTHOR("James Ban <James.Ban.opensource@diasemi.com>");
-MODULE_DESCRIPTION("Regulator device driver for Dialog DA9211");
+MODULE_DESCRIPTION("Regulator device driver for Dialog DA9211/DA9213");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/regulator/da9211-regulator.h b/drivers/regulator/da9211-regulator.h
index 88b1769..93fa9df 100644
--- a/drivers/regulator/da9211-regulator.h
+++ b/drivers/regulator/da9211-regulator.h
@@ -1,5 +1,5 @@
 /*
- * da9211-regulator.h - Regulator definitions for DA9211
+ * da9211-regulator.h - Regulator definitions for DA9211/DA9213
  * Copyright (C) 2014  Dialog Semiconductor Ltd.
  *
  * This library is free software; you can redistribute it and/or
@@ -53,12 +53,15 @@
 /* BUCK Phase Selection*/
 #define DA9211_REG_CONFIG_E			0x147
 
+/* Device ID */
+#define	DA9211_REG_DEVICE_ID			0x201
+
 /*
  * Registers bits
  */
 /* DA9211_REG_PAGE_CON (addr=0x00) */
 #define	DA9211_REG_PAGE_SHIFT			1
-#define	DA9211_REG_PAGE_MASK			0x02
+#define	DA9211_REG_PAGE_MASK			0x06
 /* On I2C registers 0x00 - 0xFF */
 #define	DA9211_REG_PAGE0			0
 /* On I2C registers 0x100 - 0x1FF */
diff --git a/include/linux/regulator/da9211.h b/include/linux/regulator/da9211.h
index 0981ce0..658c3c3 100644
--- a/include/linux/regulator/da9211.h
+++ b/include/linux/regulator/da9211.h
@@ -1,5 +1,5 @@
 /*
- * da9211.h - Regulator device driver for DA9211
+ * da9211.h - Regulator device driver for DA9211/DA9213
  * Copyright (C) 2014  Dialog Semiconductor Ltd.
  *
  * This library is free software; you can redistribute it and/or
@@ -20,6 +20,11 @@
 
 #define DA9211_MAX_REGULATORS	2
 
+enum da9211_chip_id {
+	DA9211,
+	DA9213,
+};
+
 struct da9211_pdata {
 	/*
 	 * Number of buck
-- 
end-of-patch for regulator: DA9211 : support DA9213 V1

