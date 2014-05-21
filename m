Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaEUGxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 02:53:16 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52450 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaEUGxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 02:53:08 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-4c-537c4d4a4d5f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v3 RESEND 1/2] mfd: max77693: remove unnecessary wrapper
 functions
Date: Wed, 21 May 2014 08:52:47 +0200
Message-id: <1400655168-19739-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKJMWRmVeSWpSXmKPExsVy+t/xK7pevjXBBpu2i1lMffiEzeL6l+es
	Fve/HmW0+Halg8ni8q45bBa3G1ewWTw4vJPd4nQ3qwOHx85Zd9k9Nq3qZPO4c20Pm8e8k4Ee
	fVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlbH6wy2mgrsZFWu3yjQwvgjrYuTkkBAwkfj6sIsJ
	whaTuHBvPVsXIxeHkMBSRom7PxZCOX1MEi/uXgCrYhMwlti8fAlYQkSgmUmipe8sYxcjBwez
	gJZE53wBkBphgRCJ65sfsYHYLAKqEvs/HAfr5RVwl5h2uZsdYpucxMljk1knMHIvYGRYxSia
	WppcUJyUnmuoV5yYW1yal66XnJ+7iRESNF92MC4+ZnWIUYCDUYmHV+BqdbAQa2JZcWXuIUYJ
	DmYlEd7lYjXBQrwpiZVVqUX58UWlOanFhxiZODilGhi1TEs5/Gbs/6ew53n0B3HWufu57qrd
	e1/Nym218NUHV/2/P3MP3AgzsZotb+877XWr9pdORWGjXXxdC82Vz57iFX6qWeFx5cI5kb/a
	ryelrV1VInisxfa045Jr/hxzw7xqNeRq5mQHZh+b2Gn2PcvZd20OY73vij4JO/GQG7XGdoXx
	LyLzfZVYijMSDbWYi4oTAUqr/4v4AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Baldyga <r.baldyga@samsung.com>

This patch removes wrapper functions used to access regmap, and
make driver using regmap_*() functions instead.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>

[For extcon part]
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-max77693.c     | 32 ++++++++++-----------
 drivers/mfd/max77693-irq.c           | 50 +++++++++++++++++++-------------
 drivers/mfd/max77693.c               | 56 ++----------------------------------
 drivers/regulator/max77693.c         | 12 ++++----
 include/linux/mfd/max77693-private.h |  8 ------
 5 files changed, 54 insertions(+), 104 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index da268fbc901b..0b09bf3785c7 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -255,10 +255,10 @@ static int max77693_muic_set_debounce_time(struct max77693_muic_info *info,
 	case ADC_DEBOUNCE_TIME_10MS:
 	case ADC_DEBOUNCE_TIME_25MS:
 	case ADC_DEBOUNCE_TIME_38_62MS:
-		ret = max77693_update_reg(info->max77693->regmap_muic,
+		ret = regmap_update_bits(info->max77693->regmap_muic,
 					  MAX77693_MUIC_REG_CTRL3,
-					  time << CONTROL3_ADCDBSET_SHIFT,
-					  CONTROL3_ADCDBSET_MASK);
+					  CONTROL3_ADCDBSET_MASK,
+					  time << CONTROL3_ADCDBSET_SHIFT);
 		if (ret) {
 			dev_err(info->dev, "failed to set ADC debounce time\n");
 			return ret;
@@ -286,15 +286,15 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
 		u8 val, bool attached)
 {
 	int ret = 0;
-	u8 ctrl1, ctrl2 = 0;
+	unsigned int ctrl1, ctrl2 = 0;
 
 	if (attached)
 		ctrl1 = val;
 	else
 		ctrl1 = CONTROL1_SW_OPEN;
 
-	ret = max77693_update_reg(info->max77693->regmap_muic,
-			MAX77693_MUIC_REG_CTRL1, ctrl1, COMP_SW_MASK);
+	ret = regmap_update_bits(info->max77693->regmap_muic,
+			MAX77693_MUIC_REG_CTRL1, COMP_SW_MASK, ctrl1);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
 		return ret;
@@ -305,9 +305,9 @@ static int max77693_muic_set_path(struct max77693_muic_info *info,
 	else
 		ctrl2 |= CONTROL2_LOWPWR_MASK;	/* LowPwr=1, CPEn=0 */
 
-	ret = max77693_update_reg(info->max77693->regmap_muic,
-			MAX77693_MUIC_REG_CTRL2, ctrl2,
-			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK);
+	ret = regmap_update_bits(info->max77693->regmap_muic,
+			MAX77693_MUIC_REG_CTRL2,
+			CONTROL2_LOWPWR_MASK | CONTROL2_CPEN_MASK, ctrl2);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to update MUIC register\n");
 		return ret;
@@ -969,8 +969,8 @@ static void max77693_muic_irq_work(struct work_struct *work)
 		if (info->irq == muic_irqs[i].virq)
 			irq_type = muic_irqs[i].irq;
 
-	ret = max77693_bulk_read(info->max77693->regmap_muic,
-			MAX77693_MUIC_REG_STATUS1, 2, info->status);
+	ret = regmap_bulk_read(info->max77693->regmap_muic,
+			MAX77693_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
 		mutex_unlock(&info->mutex);
@@ -1042,8 +1042,8 @@ static int max77693_muic_detect_accessory(struct max77693_muic_info *info)
 	mutex_lock(&info->mutex);
 
 	/* Read STATUSx register to detect accessory */
-	ret = max77693_bulk_read(info->max77693->regmap_muic,
-			MAX77693_MUIC_REG_STATUS1, 2, info->status);
+	ret = regmap_bulk_read(info->max77693->regmap_muic,
+			MAX77693_MUIC_REG_STATUS1, info->status, 2);
 	if (ret) {
 		dev_err(info->dev, "failed to read MUIC register\n");
 		mutex_unlock(&info->mutex);
@@ -1095,7 +1095,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	int delay_jiffies;
 	int ret;
 	int i;
-	u8 id;
+	unsigned int id;
 
 	info = devm_kzalloc(&pdev->dev, sizeof(struct max77693_muic_info),
 				   GFP_KERNEL);
@@ -1205,7 +1205,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 		enum max77693_irq_source irq_src
 				= MAX77693_IRQ_GROUP_NR;
 
-		max77693_write_reg(info->max77693->regmap_muic,
+		regmap_write(info->max77693->regmap_muic,
 				init_data[i].addr,
 				init_data[i].data);
 
@@ -1263,7 +1263,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	 max77693_muic_set_path(info, info->path_uart, true);
 
 	/* Check revision number of MUIC device*/
-	ret = max77693_read_reg(info->max77693->regmap_muic,
+	ret = regmap_read(info->max77693->regmap_muic,
 			MAX77693_MUIC_REG_ID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
diff --git a/drivers/mfd/max77693-irq.c b/drivers/mfd/max77693-irq.c
index 66b58fe77094..7d8f99f94f27 100644
--- a/drivers/mfd/max77693-irq.c
+++ b/drivers/mfd/max77693-irq.c
@@ -30,8 +30,9 @@
 #include <linux/irqdomain.h>
 #include <linux/mfd/max77693.h>
 #include <linux/mfd/max77693-private.h>
+#include <linux/regmap.h>
 
-static const u8 max77693_mask_reg[] = {
+static const unsigned int max77693_mask_reg[] = {
 	[LED_INT] = MAX77693_LED_REG_FLASH_INT_MASK,
 	[TOPSYS_INT] = MAX77693_PMIC_REG_TOPSYS_INT_MASK,
 	[CHG_INT] = MAX77693_CHG_REG_CHG_INT_MASK,
@@ -118,7 +119,7 @@ static void max77693_irq_sync_unlock(struct irq_data *data)
 			continue;
 		max77693->irq_masks_cache[i] = max77693->irq_masks_cur[i];
 
-		max77693_write_reg(map, max77693_mask_reg[i],
+		regmap_write(map, max77693_mask_reg[i],
 				max77693->irq_masks_cur[i]);
 	}
 
@@ -178,11 +179,11 @@ static irqreturn_t max77693_irq_thread(int irq, void *data)
 {
 	struct max77693_dev *max77693 = data;
 	u8 irq_reg[MAX77693_IRQ_GROUP_NR] = {};
-	u8 irq_src;
+	unsigned int irq_src;
 	int ret;
 	int i, cur_irq;
 
-	ret = max77693_read_reg(max77693->regmap, MAX77693_PMIC_REG_INTSRC,
+	ret = regmap_read(max77693->regmap, MAX77693_PMIC_REG_INTSRC,
 				&irq_src);
 	if (ret < 0) {
 		dev_err(max77693->dev, "Failed to read interrupt source: %d\n",
@@ -190,25 +191,34 @@ static irqreturn_t max77693_irq_thread(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	if (irq_src & MAX77693_IRQSRC_CHG)
+	if (irq_src & MAX77693_IRQSRC_CHG) {
 		/* CHG_INT */
-		ret = max77693_read_reg(max77693->regmap, MAX77693_CHG_REG_CHG_INT,
-				&irq_reg[CHG_INT]);
+		unsigned int data;
+		ret = regmap_read(max77693->regmap,
+				MAX77693_CHG_REG_CHG_INT, &data);
+		irq_reg[CHG_INT] = data;
+	}
 
-	if (irq_src & MAX77693_IRQSRC_TOP)
+	if (irq_src & MAX77693_IRQSRC_TOP) {
 		/* TOPSYS_INT */
-		ret = max77693_read_reg(max77693->regmap,
-			MAX77693_PMIC_REG_TOPSYS_INT, &irq_reg[TOPSYS_INT]);
+		unsigned int data;
+		ret = regmap_read(max77693->regmap,
+			MAX77693_PMIC_REG_TOPSYS_INT, &data);
+		irq_reg[TOPSYS_INT] = data;
+	}
 
-	if (irq_src & MAX77693_IRQSRC_FLASH)
+	if (irq_src & MAX77693_IRQSRC_FLASH) {
 		/* LED_INT */
-		ret = max77693_read_reg(max77693->regmap,
-			MAX77693_LED_REG_FLASH_INT, &irq_reg[LED_INT]);
+		unsigned int data;
+		ret = regmap_read(max77693->regmap,
+			MAX77693_LED_REG_FLASH_INT, &data);
+		irq_reg[LED_INT] = data;
+	}
 
 	if (irq_src & MAX77693_IRQSRC_MUIC)
 		/* MUIC INT1 ~ INT3 */
-		max77693_bulk_read(max77693->regmap_muic, MAX77693_MUIC_REG_INT1,
-			MAX77693_NUM_IRQ_MUIC_REGS, &irq_reg[MUIC_INT1]);
+		regmap_bulk_read(max77693->regmap_muic, MAX77693_MUIC_REG_INT1,
+			&irq_reg[MUIC_INT1], MAX77693_NUM_IRQ_MUIC_REGS);
 
 	/* Apply masking */
 	for (i = 0; i < MAX77693_IRQ_GROUP_NR; i++) {
@@ -263,7 +273,7 @@ int max77693_irq_init(struct max77693_dev *max77693)
 	struct irq_domain *domain;
 	int i;
 	int ret = 0;
-	u8 intsrc_mask;
+	unsigned int intsrc_mask;
 
 	mutex_init(&max77693->irqlock);
 
@@ -286,9 +296,9 @@ int max77693_irq_init(struct max77693_dev *max77693)
 		if (max77693_mask_reg[i] == MAX77693_REG_INVALID)
 			continue;
 		if (i >= MUIC_INT1 && i <= MUIC_INT3)
-			max77693_write_reg(map, max77693_mask_reg[i], 0x00);
+			regmap_write(map, max77693_mask_reg[i], 0x00);
 		else
-			max77693_write_reg(map, max77693_mask_reg[i], 0xff);
+			regmap_write(map, max77693_mask_reg[i], 0xff);
 	}
 
 	domain = irq_domain_add_linear(NULL, MAX77693_IRQ_NR,
@@ -301,7 +311,7 @@ int max77693_irq_init(struct max77693_dev *max77693)
 	max77693->irq_domain = domain;
 
 	/* Unmask max77693 interrupt */
-	ret = max77693_read_reg(max77693->regmap,
+	ret = regmap_read(max77693->regmap,
 			MAX77693_PMIC_REG_INTSRC_MASK, &intsrc_mask);
 	if (ret < 0) {
 		dev_err(max77693->dev, "fail to read PMIC register\n");
@@ -311,7 +321,7 @@ int max77693_irq_init(struct max77693_dev *max77693)
 	intsrc_mask &= ~(MAX77693_IRQSRC_CHG);
 	intsrc_mask &= ~(MAX77693_IRQSRC_FLASH);
 	intsrc_mask &= ~(MAX77693_IRQSRC_MUIC);
-	ret = max77693_write_reg(max77693->regmap,
+	ret = regmap_write(max77693->regmap,
 			MAX77693_PMIC_REG_INTSRC_MASK, intsrc_mask);
 	if (ret < 0) {
 		dev_err(max77693->dev, "fail to write PMIC register\n");
diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index c5535f018466..6336251a7079 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -49,58 +49,6 @@ static const struct mfd_cell max77693_devs[] = {
 	{ .name = "max77693-haptic", },
 };
 
-int max77693_read_reg(struct regmap *map, u8 reg, u8 *dest)
-{
-	unsigned int val;
-	int ret;
-
-	ret = regmap_read(map, reg, &val);
-	*dest = val;
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(max77693_read_reg);
-
-int max77693_bulk_read(struct regmap *map, u8 reg, int count, u8 *buf)
-{
-	int ret;
-
-	ret = regmap_bulk_read(map, reg, buf, count);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(max77693_bulk_read);
-
-int max77693_write_reg(struct regmap *map, u8 reg, u8 value)
-{
-	int ret;
-
-	ret = regmap_write(map, reg, value);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(max77693_write_reg);
-
-int max77693_bulk_write(struct regmap *map, u8 reg, int count, u8 *buf)
-{
-	int ret;
-
-	ret = regmap_bulk_write(map, reg, buf, count);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(max77693_bulk_write);
-
-int max77693_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask)
-{
-	int ret;
-
-	ret = regmap_update_bits(map, reg, mask, val);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(max77693_update_reg);
-
 static const struct regmap_config max77693_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
@@ -117,7 +65,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
 	struct max77693_dev *max77693;
-	u8 reg_data;
+	unsigned int reg_data;
 	int ret = 0;
 
 	max77693 = devm_kzalloc(&i2c->dev,
@@ -139,7 +87,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 		return ret;
 	}
 
-	ret = max77693_read_reg(max77693->regmap, MAX77693_PMIC_REG_PMIC_ID2,
+	ret = regmap_read(max77693->regmap, MAX77693_PMIC_REG_PMIC_ID2,
 				&reg_data);
 	if (ret < 0) {
 		dev_err(max77693->dev, "device not found on this channel\n");
diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index 653a58b49cdf..c67ff05fc1dd 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -31,6 +31,7 @@
 #include <linux/mfd/max77693.h>
 #include <linux/mfd/max77693-private.h>
 #include <linux/regulator/of_regulator.h>
+#include <linux/regmap.h>
 
 #define CHGIN_ILIM_STEP_20mA			20000
 
@@ -39,9 +40,9 @@
 static int max77693_chg_is_enabled(struct regulator_dev *rdev)
 {
 	int ret;
-	u8 val;
+	unsigned int val;
 
-	ret = max77693_read_reg(rdev->regmap, rdev->desc->enable_reg, &val);
+	ret = regmap_read(rdev->regmap, rdev->desc->enable_reg, &val);
 	if (ret)
 		return ret;
 
@@ -57,12 +58,11 @@ static int max77693_chg_get_current_limit(struct regulator_dev *rdev)
 {
 	unsigned int chg_min_uA = rdev->constraints->min_uA;
 	unsigned int chg_max_uA = rdev->constraints->max_uA;
-	u8 reg, sel;
+	unsigned int reg, sel;
 	unsigned int val;
 	int ret;
 
-	ret = max77693_read_reg(rdev->regmap,
-				MAX77693_CHG_REG_CHG_CNFG_09, &reg);
+	ret = regmap_read(rdev->regmap, MAX77693_CHG_REG_CHG_CNFG_09, &reg);
 	if (ret < 0)
 		return ret;
 
@@ -96,7 +96,7 @@ static int max77693_chg_set_current_limit(struct regulator_dev *rdev,
 	/* the first four codes for charger current are all 60mA */
 	sel += 3;
 
-	return max77693_write_reg(rdev->regmap,
+	return regmap_write(rdev->regmap,
 				MAX77693_CHG_REG_CHG_CNFG_09, sel);
 }
 /* end of CHARGER regulator ops */
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 3e050b933dd0..80ec31d561c4 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -332,14 +332,6 @@ enum max77693_types {
 	TYPE_MAX77693,
 };
 
-extern int max77693_read_reg(struct regmap *map, u8 reg, u8 *dest);
-extern int max77693_bulk_read(struct regmap *map, u8 reg, int count,
-				u8 *buf);
-extern int max77693_write_reg(struct regmap *map, u8 reg, u8 value);
-extern int max77693_bulk_write(struct regmap *map, u8 reg, int count,
-				u8 *buf);
-extern int max77693_update_reg(struct regmap *map, u8 reg, u8 val, u8 mask);
-
 extern int max77693_irq_init(struct max77693_dev *max77686);
 extern void max77693_irq_exit(struct max77693_dev *max77686);
 extern int max77693_irq_resume(struct max77693_dev *max77686);
-- 
1.9.1

