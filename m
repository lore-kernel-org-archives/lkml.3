Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab3FNFX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:23:59 -0400
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:49982 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839Ab3FNFX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:23:56 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <yizhang@marvell.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH V2 7/9] mfd: 88pm80x: Changes chip id definition and detection
Date: Fri, 14 Jun 2013 01:21:51 -0400
Message-ID: <1371187313-5776-8-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
References: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the chip id definition and detection.
It brings the benefits
1. do not need add PM800_CHIP_XXX for the coming revision.
2. do not need pass driver_data in i2c_device_id because we
   can distinguish the chips by CHIP_ID register.

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 drivers/mfd/88pm800.c       |   42 +++++--------------------------------
 drivers/mfd/88pm805.c       |   16 ++-----------
 drivers/mfd/88pm80x.c       |   47 ++++++++++++++++++++++++++++++++++++------
 include/linux/mfd/88pm80x.h |    7 +----
 4 files changed, 51 insertions(+), 61 deletions(-)

diff --git a/drivers/mfd/88pm800.c b/drivers/mfd/88pm800.c
index 932ebe8..16faad6 100644
--- a/drivers/mfd/88pm800.c
+++ b/drivers/mfd/88pm800.c
@@ -27,8 +27,6 @@
 #include <linux/mfd/88pm80x.h>
 #include <linux/slab.h>
 
-#define PM800_CHIP_ID			(0x00)
-
 /* Interrupt Registers */
 #define PM800_INT_STATUS1		(0x05)
 #define PM800_ONKEY_INT_STS1		(1 << 0)
@@ -113,20 +111,11 @@ enum {
 	PM800_MAX_IRQ,
 };
 
-enum {
-	/* Procida */
-	PM800_CHIP_A0  = 0x60,
-	PM800_CHIP_A1  = 0x61,
-	PM800_CHIP_B0  = 0x62,
-	PM800_CHIP_C0  = 0x63,
-	PM800_CHIP_END = PM800_CHIP_C0,
-
-	/* Make sure to update this to the last stepping */
-	PM8XXX_CHIP_END = PM800_CHIP_END
-};
+/* PM800: generation identification number */
+#define PM800_CHIP_GEN_ID_NUM	0x3
 
 static const struct i2c_device_id pm80x_id_table[] = {
-	{"88PM800", CHIP_PM800},
+	{"88PM800", 0},
 	{} /* NULL terminated */
 };
 MODULE_DEVICE_TABLE(i2c, pm80x_id_table);
@@ -433,28 +422,9 @@ static void pm800_pages_exit(struct pm80x_chip *chip)
 static int device_800_init(struct pm80x_chip *chip,
 				     struct pm80x_platform_data *pdata)
 {
-	int ret, pmic_id;
+	int ret;
 	unsigned int val;
 
-	ret = regmap_read(chip->regmap, PM800_CHIP_ID, &val);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to read CHIP ID: %d\n", ret);
-		goto out;
-	}
-
-	pmic_id = val & PM80X_VERSION_MASK;
-
-	if ((pmic_id >= PM800_CHIP_A0) && (pmic_id <= PM800_CHIP_END)) {
-		chip->version = val;
-		dev_info(chip->dev,
-			 "88PM80x:Marvell 88PM800 (ID:0x%x) detected\n", val);
-	} else {
-		dev_err(chip->dev,
-			"Failed to detect Marvell 88PM800:ChipID[0x%x]\n", val);
-		ret = -EINVAL;
-		goto out;
-	}
-
 	/*
 	 * alarm wake up bit will be clear in device_irq_init(),
 	 * read before that
@@ -522,7 +492,7 @@ static int pm800_probe(struct i2c_client *client,
 	struct pm80x_platform_data *pdata = client->dev.platform_data;
 	struct pm80x_subchip *subchip;
 
-	ret = pm80x_init(client, id);
+	ret = pm80x_init(client);
 	if (ret) {
 		dev_err(&client->dev, "pm800_init fail\n");
 		goto out_init;
@@ -552,7 +522,7 @@ static int pm800_probe(struct i2c_client *client,
 
 	ret = device_800_init(chip, pdata);
 	if (ret) {
-		dev_err(chip->dev, "%s id 0x%x failed!\n", __func__, chip->id);
+		dev_err(chip->dev, "Failed to initialize 88pm800 devices\n");
 		goto err_device_init;
 	}
 
diff --git a/drivers/mfd/88pm805.c b/drivers/mfd/88pm805.c
index 0e82c2a..5216022 100644
--- a/drivers/mfd/88pm805.c
+++ b/drivers/mfd/88pm805.c
@@ -29,10 +29,8 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 
-#define PM805_CHIP_ID			(0x00)
-
 static const struct i2c_device_id pm80x_id_table[] = {
-	{"88PM805", CHIP_PM805},
+	{"88PM805", 0},
 	{} /* NULL terminated */
 };
 MODULE_DEVICE_TABLE(i2c, pm80x_id_table);
@@ -192,7 +190,6 @@ static struct regmap_irq_chip pm805_irq_chip = {
 static int device_805_init(struct pm80x_chip *chip)
 {
 	int ret = 0;
-	unsigned int val;
 	struct regmap *map = chip->regmap;
 
 	if (!map) {
@@ -200,13 +197,6 @@ static int device_805_init(struct pm80x_chip *chip)
 		return -EINVAL;
 	}
 
-	ret = regmap_read(map, PM805_CHIP_ID, &val);
-	if (ret < 0) {
-		dev_err(chip->dev, "Failed to read CHIP ID: %d\n", ret);
-		goto out_irq_init;
-	}
-	chip->version = val;
-
 	chip->regmap_irq_chip = &pm805_irq_chip;
 
 	ret = device_irq_init_805(chip);
@@ -239,7 +229,7 @@ static int pm805_probe(struct i2c_client *client,
 	struct pm80x_chip *chip;
 	struct pm80x_platform_data *pdata = client->dev.platform_data;
 
-	ret = pm80x_init(client, id);
+	ret = pm80x_init(client);
 	if (ret) {
 		dev_err(&client->dev, "pm805_init fail!\n");
 		goto out_init;
@@ -249,7 +239,7 @@ static int pm805_probe(struct i2c_client *client,
 
 	ret = device_805_init(chip);
 	if (ret) {
-		dev_err(chip->dev, "%s id 0x%x failed!\n", __func__, chip->id);
+		dev_err(chip->dev, "Failed to initialize 88pm805 devices\n");
 		goto err_805_init;
 	}
 
diff --git a/drivers/mfd/88pm80x.c b/drivers/mfd/88pm80x.c
index f736a46..5e72f65 100644
--- a/drivers/mfd/88pm80x.c
+++ b/drivers/mfd/88pm80x.c
@@ -18,6 +18,23 @@
 #include <linux/uaccess.h>
 #include <linux/err.h>
 
+/* 88pm80x chips have same definition for chip id register. */
+#define PM80X_CHIP_ID			(0x00)
+#define PM80X_CHIP_ID_NUM(x)		(((x) >> 5) & 0x7)
+#define PM80X_CHIP_ID_REVISION(x)	((x) & 0x1F)
+
+struct pm80x_chip_mapping {
+	unsigned int	id;
+	int		type;
+};
+
+static struct pm80x_chip_mapping chip_mapping[] = {
+	/* 88PM800 chip id number */
+	{0x3,	CHIP_PM800},
+	/* 88PM805 chip id number */
+	{0x0,	CHIP_PM805},
+};
+
 /*
  * workaround: some registers needed by pm805 are defined in pm800, so
  * need to use this global variable to maintain the relation between
@@ -31,12 +48,13 @@ const struct regmap_config pm80x_regmap_config = {
 };
 EXPORT_SYMBOL_GPL(pm80x_regmap_config);
 
-int pm80x_init(struct i2c_client *client,
-				 const struct i2c_device_id *id)
+
+int pm80x_init(struct i2c_client *client)
 {
 	struct pm80x_chip *chip;
 	struct regmap *map;
-	int ret = 0;
+	unsigned int val;
+	int i, ret = 0;
 
 	chip =
 	    devm_kzalloc(&client->dev, sizeof(struct pm80x_chip), GFP_KERNEL);
@@ -51,10 +69,6 @@ int pm80x_init(struct i2c_client *client,
 		return ret;
 	}
 
-	chip->id = id->driver_data;
-	if (chip->id < CHIP_PM800 || chip->id > CHIP_PM805)
-		return -EINVAL;
-
 	chip->client = client;
 	chip->regmap = map;
 
@@ -64,6 +78,25 @@ int pm80x_init(struct i2c_client *client,
 	dev_set_drvdata(chip->dev, chip);
 	i2c_set_clientdata(chip->client, chip);
 
+	ret = regmap_read(chip->regmap, PM80X_CHIP_ID, &val);
+	if (ret < 0) {
+		dev_err(chip->dev, "Failed to read CHIP ID: %d\n", ret);
+		return ret;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(chip_mapping); i++) {
+		if (chip_mapping[i].id == PM80X_CHIP_ID_NUM(val)) {
+			chip->type = chip_mapping[i].type;
+			break;
+		}
+	}
+
+	if (i == ARRAY_SIZE(chip_mapping)) {
+		dev_err(chip->dev,
+			"Failed to detect Marvell 88PM800:ChipID[0x%x]\n", val);
+		return -EINVAL;
+	}
+
 	device_init_wakeup(&client->dev, 1);
 
 	/*
diff --git a/include/linux/mfd/88pm80x.h b/include/linux/mfd/88pm80x.h
index 023e639..4a66a56 100644
--- a/include/linux/mfd/88pm80x.h
+++ b/include/linux/mfd/88pm80x.h
@@ -17,7 +17,6 @@
 #include <linux/regmap.h>
 #include <linux/atomic.h>
 
-#define PM80X_VERSION_MASK		(0xFF)	/* 80X chip ID mask */
 enum {
 	CHIP_INVALID = 0,
 	CHIP_PM800,
@@ -299,8 +298,7 @@ struct pm80x_chip {
 	struct regmap *regmap;
 	struct regmap_irq_chip *regmap_irq_chip;
 	struct regmap_irq_chip_data *irq_data;
-	unsigned char version;
-	int id;
+	int type;
 	int irq;
 	int irq_mode;
 	unsigned long wu_flag;
@@ -361,7 +359,6 @@ static inline int pm80x_dev_resume(struct device *dev)
 }
 #endif
 
-extern int pm80x_init(struct i2c_client *client,
-		      const struct i2c_device_id *id);
+extern int pm80x_init(struct i2c_client *client);
 extern int pm80x_deinit(void);
 #endif /* __LINUX_MFD_88PM80X_H */
-- 
1.7.4.1

