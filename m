Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaD2FtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 01:49:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37948 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaD2FtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 01:49:01 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-fa-535f3d4bdc44
From: Robert Baldyga <r.baldyga@samsung.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: a.zummo@towertech.it, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 1/2] mfd: max77693: remove unnecessary wrapper functions
Date: Tue, 29 Apr 2014 07:48:46 +0200
Message-id: <1398750527-20715-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1398750527-20715-1-git-send-email-r.baldyga@samsung.com>
References: <1398750527-20715-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQV1v2/hggxs3DC2WXLzKbvH6haHF
	/a9HGS0u75rDZrH2yF12iweHd7Jb7O/sYLQ43c3qwOGxZ+JJNo871/awecw7GejRt2UVo8f0
	eT+ZPD5vkgtgi+KySUnNySxLLdK3S+DK+H1CqeBcWsWhi6+ZGxi/hnQxcnJICJhIfP/5hhnC
	FpO4cG89WxcjF4eQwHRGiabdf1ghnHYmiXVLv7KCVLEJ6Ehs+T6BEcQWEdCX+LDjKjNIEbPA
	RkaJiTM/go0SFvCWeNE1ix3EZhFQlXi7aBfQWA4OXgFXiVf7PSG2yUmcPDaZFSTMKeAmMasl
	ESQsBFQxYd8slgmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfYM6kdjCsbLA4x
	CnAwKvHwGkTFBQuxJpYVV+YeYpTgYFYS4c23ig8W4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug
	1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwLj5n66C18LNmk4bAooWf2prEvEU1apMn+u93Gv9snUx
	3/ce8LXV/9njzVwcccuw6ee9iaJedYal6RyM0ybxC+r5aVwod5frvrrP6c/W0zNbiz+FJl4o
	Y7sy/4b4WedtYepWSS+uPn9afTXGO8bS98XMYmn2gC+uQuwfu1wW1Oswb/4tIuneq8RSnJFo
	qMVcVJwIADCVrrwsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes wrapper functions used to access regmap, and
make driver using regmap_*() functions instead.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
---
 drivers/extcon/extcon-max77693.c     | 32 ++++++++++-----------
 drivers/mfd/max77693-irq.c           | 50 +++++++++++++++++++-------------
 drivers/mfd/max77693.c               | 56 ++----------------------------------
 drivers/regulator/max77693.c         | 12 ++++----
 include/linux/mfd/max77693-private.h |  8 ------
 5 files changed, 54 insertions(+), 104 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index da268fb..0b09bf3 100644
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
index 66b58fe..7d8f99f 100644
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
index c5535f0..6336251 100644
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
index 653a58b..c67ff05 100644
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
index 3e050b9..80ec31d 100644
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

