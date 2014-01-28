Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139AbaA1MU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:20:28 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30713 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205AbaA1MTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:12 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-73-52e7a03e472e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 16/18] charger: max14577: Add support for MAX77836 charger
Date: Tue, 28 Jan 2014 13:18:40 +0100
Message-id: <1390911522-28209-17-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xa7p2C54HGfz5rWpxcKumxdSHT9gs
	rn95zmox6cl7ZouJKyczW7x+YWhxtukNu8X9r0cZLb5d6WCy2PT4GqvF5V1z2CzWHrnLbnG7
	cQWbxeluVgc+jwn9nxg9ds66y+6xeYWWx6ZVnWwed67tYfOYdzLQY/OSeo++LasYPT5vkgvg
	jOKySUnNySxLLdK3S+DKuHL2CnPB9+yKK9euMjcw7onpYuTkkBAwkZj89A07hC0mceHeerYu
	Ri4OIYGljBKLDp6EcvqYJPYv/ghWxSZgLLF5+RKwhIjAaiaJNQumsoA4zCBVi28dB6sSFvCS
	aJ9znhXEZhFQldi5cgtQnIODV8BD4v/XWBBTQkBBYs4kG5AKTqDoq6uNTCC2kIC7xKnj71gm
	MPIuYGRYxSiaWppcUJyUnmuoV5yYW1yal66XnJ+7iRESuF92MC4+ZnWIUYCDUYmHt6PzWZAQ
	a2JZcWXuIUYJDmYlEd7E2c+DhHhTEiurUovy44tKc1KLDzEycXBKNTBWrnu24Uia26Z1Tf5G
	rp12UvpzoxrPG0g3eiY8Ls5NO+7b8XRVOfs7qZ75GY/T9Zsj1neumhMwybX1sf4a73iB+weu
	nmA7M/k3v/lF8cCC+WmvD6SEX1h0dr1Y5snAHe9UdrxqNE9x4n/8Mu/Iif+G9ws3szYx3Gd8
	3KDT5sz0vyqJ803IRAElluKMREMt5qLiRAAQPhu0OgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for MAX77836 charger to the max14577 driver. The MAX77836
charger is almost the same as 14577 model except:
 - No dead-battery detection;
 - Support for special charger (like in max77693);
 - Support for DX over-voltage protection (like in max77693);
 - Lower values of charging current (two times lower current for
   slow/fast charge, much lower EOC current);
 - Slightly different values in ChgTyp field of STATUS2 register. On
   MAX14577 0x6 is reserved and 0x7 dead battery. On the MAX77836 the
   0x6 means special charger and 0x7 is reserved. Regardless of these
   differences the driver maps them to one enum maxim_muic_charger_type.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/extcon/extcon-max14577.c     |    2 +-
 drivers/power/max14577_charger.c     |   81 +++++++++++++++++++++++++++-------
 include/linux/mfd/max14577-private.h |   57 +++++++++++++++++-------
 3 files changed, 106 insertions(+), 34 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 440b19ac5fba..9390471f1a56 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -498,7 +498,7 @@ static int max14577_muic_chg_handler(struct max14577_muic_info *info)
 		extcon_set_cable_state(info->edev, "Fast-charger", attached);
 		break;
 	case MAXIM_CHARGER_TYPE_NONE:
-	case MAXIM_CHARGER_TYPE_DEAD_BATTERY:
+	case MAX14577_CHARGER_TYPE_DEAD_BATTERY:
 		break;
 	default:
 		dev_err(info->dev,
diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
index 58cddc3b15d6..405f4d736337 100644
--- a/drivers/power/max14577_charger.c
+++ b/drivers/power/max14577_charger.c
@@ -1,7 +1,7 @@
 /*
- * Battery charger driver for the Maxim 14577
+ * max14577_charger.c - Battery charger driver for the Maxim 14577/77836
  *
- * Copyright (C) 2013 Samsung Electronics
+ * Copyright (C) 2013,2014 Samsung Electronics
  * Krzysztof Kozlowski <k.kozlowski@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -25,10 +25,35 @@ struct max14577_charger {
 	struct maxim_core	*maxim_core;
 	struct power_supply	charger;
 
-	unsigned int	charging_state;
-	unsigned int	battery_state;
+	unsigned int		charging_state;
+	unsigned int		battery_state;
 };
 
+/*
+ * Helper function for mapping values of STATUS2/CHGTYP register on max14577
+ * and max77836 chipsets to enum maxim_muic_charger_type.
+ */
+static enum maxim_muic_charger_type maxim_get_charger_type(
+		enum maxim_device_type dev_type, u8 val) {
+	switch (val) {
+	case MAXIM_CHARGER_TYPE_NONE:
+	case MAXIM_CHARGER_TYPE_USB:
+	case MAXIM_CHARGER_TYPE_DOWNSTREAM_PORT:
+	case MAXIM_CHARGER_TYPE_DEDICATED_CHG:
+	case MAXIM_CHARGER_TYPE_SPECIAL_500MA:
+	case MAXIM_CHARGER_TYPE_SPECIAL_1A:
+		return val;
+	case MAX14577_CHARGER_TYPE_DEAD_BATTERY:
+	case MAX14577_CHARGER_TYPE_RESERVED:
+		if (dev_type == MAXIM_DEVICE_TYPE_MAX77836)
+			val |= 0x8;
+		return val;
+	default:
+		WARN_ONCE(1, "max14577: Unsupported chgtyp register value 0x%02x", val);
+		return val;
+	}
+}
+
 static int max14577_get_charger_state(struct max14577_charger *chg)
 {
 	struct regmap *rmap = chg->maxim_core->regmap_muic;
@@ -89,20 +114,24 @@ static int max14577_get_online(struct max14577_charger *chg)
 {
 	struct regmap *rmap = chg->maxim_core->regmap_muic;
 	u8 reg_data;
+	enum maxim_muic_charger_type chg_type;
 
 	max14577_read_reg(rmap, MAXIM_MUIC_REG_STATUS2, &reg_data);
 	reg_data = reg_data & MAXIM_STATUS2_CHGTYP_MASK;
 	reg_data >>= MAXIM_STATUS2_CHGTYP_SHIFT;
-	switch (reg_data) {
+	chg_type = maxim_get_charger_type(chg->maxim_core->dev_type, reg_data);
+	switch (chg_type) {
 	case MAXIM_CHARGER_TYPE_USB:
 	case MAXIM_CHARGER_TYPE_DEDICATED_CHG:
 	case MAXIM_CHARGER_TYPE_SPECIAL_500MA:
 	case MAXIM_CHARGER_TYPE_SPECIAL_1A:
-	case MAXIM_CHARGER_TYPE_DEAD_BATTERY:
+	case MAX14577_CHARGER_TYPE_DEAD_BATTERY:
+	case MAX77836_CHARGER_TYPE_SPECIAL_BIAS:
 		return 1;
 	case MAXIM_CHARGER_TYPE_NONE:
 	case MAXIM_CHARGER_TYPE_DOWNSTREAM_PORT:
-	case MAXIM_CHARGER_TYPE_RESERVED:
+	case MAX14577_CHARGER_TYPE_RESERVED:
+	case MAX77836_CHARGER_TYPE_RESERVED:
 	default:
 		return 0;
 	}
@@ -119,11 +148,13 @@ static int max14577_get_battery_health(struct max14577_charger *chg)
 	struct regmap *rmap = chg->maxim_core->regmap_muic;
 	int state = POWER_SUPPLY_HEALTH_GOOD;
 	u8 reg_data;
+	enum maxim_muic_charger_type chg_type;
 
 	max14577_read_reg(rmap, MAXIM_MUIC_REG_STATUS2, &reg_data);
 	reg_data = reg_data & MAXIM_STATUS2_CHGTYP_MASK;
 	reg_data >>= MAXIM_STATUS2_CHGTYP_SHIFT;
-	if (reg_data == MAXIM_CHARGER_TYPE_DEAD_BATTERY) {
+	chg_type = maxim_get_charger_type(chg->maxim_core->dev_type, reg_data);
+	if (chg_type == MAX14577_CHARGER_TYPE_DEAD_BATTERY) {
 		state = POWER_SUPPLY_HEALTH_DEAD;
 		goto state_set;
 	}
@@ -170,7 +201,7 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 				MAXIM_CDETCTRL1_CHGTYPMAN_MASK,
 			reg_data);
 
-	/* Battery Fast-Charge Timer, from SM-V700: 6hrs */
+	/* Battery Fast-Charge Timer, set to: 6hrs */
 	reg_data = 0x3 << MAXIM_CHGCTRL1_TCHW_SHIFT;
 	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL1, reg_data);
 
@@ -182,19 +213,22 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 	reg_data |= 0x1 << MAXIM_CHGCTRL2_MBCHOSTEN_SHIFT;
 	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL2, reg_data);
 
-	/* Battery-Charger Constant Voltage (CV) Mode, from SM-V700: 4.35V */
+	/* Battery-Charger Constant Voltage (CV) Mode, set to: 4.35V */
 	reg_data = 0xf << MAXIM_CHGCTRL3_MBCCVWRC_SHIFT;
 	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL3, reg_data);
 
 	/*
-	 * Fast Battery-Charge Current Low, default 200-950mA
-	 * Fast Battery-Charge Current High, from SM-V700: 450mA
+	 * Fast Battery-Charge Current Low,
+	 * default 200-950mA (max14577) / 100-475mA (max77836)
+	 *
+	 * Fast Battery-Charge Current High,
+	 * set to 450mA (max14577) / 225mA (max77836)
 	 */
 	reg_data = 0x1 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT;
 	reg_data |= 0x5 << MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT;
 	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL4, reg_data);
 
-	/* End-of-Charge Current, from SM-V700: 50mA */
+	/* End-of-Charge Current, set to 50mA (max14577) / 7.5mA (max77836) */
 	reg_data = 0x0 << MAXIM_CHGCTRL5_EOCS_SHIFT;
 	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL5, reg_data);
 
@@ -202,7 +236,7 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 	reg_data = 0x0 << MAXIM_CHGCTRL6_AUTOSTOP_SHIFT;
 	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL6, reg_data);
 
-	/* Overvoltage-Protection Threshold, from SM-V700: 6.5V */
+	/* Overvoltage-Protection Threshold, set to 6.5V */
 	reg_data = 0x2 << MAXIM_CHGCTRL7_OTPCGHCVS_SHIFT;
 	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL7, reg_data);
 }
@@ -218,7 +252,11 @@ static enum power_supply_property max14577_charger_props[] = {
 	POWER_SUPPLY_PROP_MANUFACTURER,
 };
 
-static const char *model_name = "MAX14577";
+static const char * const model_names[] = {
+	[MAXIM_DEVICE_TYPE_UNKNOWN]	= "MAX14577-like",
+	[MAXIM_DEVICE_TYPE_MAX14577]	= "MAX14577",
+	[MAXIM_DEVICE_TYPE_MAX77836]	= "MAX77836",
+};
 static const char *manufacturer = "Maxim Integrated";
 
 static int max14577_charger_get_property(struct power_supply *psy,
@@ -247,7 +285,8 @@ static int max14577_charger_get_property(struct power_supply *psy,
 		val->intval = max14577_get_online(chg);
 		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
-		val->strval = model_name;
+		BUILD_BUG_ON(ARRAY_SIZE(model_names) != MAXIM_DEVICE_TYPE_NUM);
+		val->strval = model_names[chg->maxim_core->dev_type];
 		break;
 	case POWER_SUPPLY_PROP_MANUFACTURER:
 		val->strval = manufacturer;
@@ -299,6 +338,13 @@ static int max14577_charger_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct platform_device_id max14577_charger_id[] = {
+	{ "max14577-charger", MAXIM_DEVICE_TYPE_MAX14577, },
+	{ "max77836-charger", MAXIM_DEVICE_TYPE_MAX77836, },
+	{ }
+};
+MODULE_DEVICE_TABLE(platform, max14577_regulator_id);
+
 static struct platform_driver max14577_charger_driver = {
 	.driver = {
 		.owner	= THIS_MODULE,
@@ -306,9 +352,10 @@ static struct platform_driver max14577_charger_driver = {
 	},
 	.probe		= max14577_charger_probe,
 	.remove		= max14577_charger_remove,
+	.id_table	= max14577_charger_id,
 };
 module_platform_driver(max14577_charger_driver);
 
 MODULE_AUTHOR("Krzysztof Kozlowski <k.kozlowski@samsung.com>");
-MODULE_DESCRIPTION("MAXIM 14577 charger driver");
+MODULE_DESCRIPTION("Maxim 14577/77836 charger driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 621e24fc45df..6f45bcf804d3 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -62,15 +62,32 @@ enum maxim_muic_reg {
 	MAXIM_MUIC_REG_END,
 };
 
+/*
+ * Combined charger types for max14577 and max77836.
+ *
+ * On max14577 three lower bits map to STATUS2/CHGTYP field.
+ * On max77836 two values of this field are bitwise OR-ed with 0x8 to indicate
+ * the difference.
+ */
 enum maxim_muic_charger_type {
-	MAXIM_CHARGER_TYPE_NONE			= 0,
-	MAXIM_CHARGER_TYPE_USB,
-	MAXIM_CHARGER_TYPE_DOWNSTREAM_PORT,
-	MAXIM_CHARGER_TYPE_DEDICATED_CHG,
-	MAXIM_CHARGER_TYPE_SPECIAL_500MA,
-	MAXIM_CHARGER_TYPE_SPECIAL_1A,
-	MAXIM_CHARGER_TYPE_RESERVED,
-	MAXIM_CHARGER_TYPE_DEAD_BATTERY		= 7,
+	MAXIM_CHARGER_TYPE_NONE			= 0x0,
+	MAXIM_CHARGER_TYPE_USB			= 0x1,
+	MAXIM_CHARGER_TYPE_DOWNSTREAM_PORT	= 0x2,
+	MAXIM_CHARGER_TYPE_DEDICATED_CHG	= 0x3,
+	MAXIM_CHARGER_TYPE_SPECIAL_500MA	= 0x4,
+	/* Special 1A or 2A charger */
+	MAXIM_CHARGER_TYPE_SPECIAL_1A		= 0x5,
+	/* max14577: reserved, used on max77836 */
+	MAX14577_CHARGER_TYPE_RESERVED		= 0x6,
+	/* max14577: dead-battery charing with maximum current 100mA */
+	MAX14577_CHARGER_TYPE_DEAD_BATTERY	= 0x7,
+	/*
+	 * max77836: special charger (bias on D+/D-),
+	 * register value 0x6 | 0x8 (4th bit set)
+	 */
+	MAX77836_CHARGER_TYPE_SPECIAL_BIAS	= 0xe,
+	/* max77836: reserved, register value 0x7 | 0x8 (4th bit set) */
+	MAX77836_CHARGER_TYPE_RESERVED		= 0xf,
 };
 
 /* MAX14577 interrupts */
@@ -111,13 +128,15 @@ enum maxim_muic_charger_type {
 #define MAXIM_STATUS2_CHGTYP_SHIFT	0
 #define MAXIM_STATUS2_CHGDETRUN_SHIFT	3
 #define MAXIM_STATUS2_DCDTMR_SHIFT	4
-#define MAXIM_STATUS2_DBCHG_SHIFT	5
+#define MAX14577_STATUS2_DBCHG_SHIFT	5
+#define MAX77836_STATUS2_DXOVP_SHIFT	5
 #define MAXIM_STATUS2_VBVOLT_SHIFT	6
 #define MAX77836_STATUS2_VIDRM_SHIFT	7
 #define MAXIM_STATUS2_CHGTYP_MASK	(0x7 << MAXIM_STATUS2_CHGTYP_SHIFT)
 #define MAXIM_STATUS2_CHGDETRUN_MASK	(0x1 << MAXIM_STATUS2_CHGDETRUN_SHIFT)
 #define MAXIM_STATUS2_DCDTMR_MASK	(0x1 << MAXIM_STATUS2_DCDTMR_SHIFT)
-#define MAXIM_STATUS2_DBCHG_MASK	(0x1 << MAXIM_STATUS2_DBCHG_SHIFT)
+#define MAX14577_STATUS2_DBCHG_MASK	(0x1 << MAX14577_STATUS2_DBCHG_SHIFT)
+#define MAX77836_STATUS2_DXOVP_MASK	(0x1 << MAX77836_STATUS2_DXOVP_SHIFT)
 #define MAXIM_STATUS2_VBVOLT_MASK	(0x1 << MAXIM_STATUS2_VBVOLT_SHIFT)
 #define MAX77836_STATUS2_VIDRM_MASK	(0x1 << MAX77836_STATUS2_VIDRM_SHIFT)
 
@@ -178,26 +197,32 @@ enum maxim_muic_charger_type {
 #define MAXIM_CONTROL3_JIGSET_SHIFT	0
 #define MAXIM_CONTROL3_BOOTSET_SHIFT	2
 #define MAXIM_CONTROL3_ADCDBSET_SHIFT	4
+#define MAX14577_CONTROL3_WBTH_SHIFT	6
 #define MAXIM_CONTROL3_JIGSET_MASK	(0x3 << MAXIM_CONTROL3_JIGSET_SHIFT)
 #define MAXIM_CONTROL3_BOOTSET_MASK	(0x3 << MAXIM_CONTROL3_BOOTSET_SHIFT)
 #define MAXIM_CONTROL3_ADCDBSET_MASK	(0x3 << MAXIM_CONTROL3_ADCDBSET_SHIFT)
+#define MAX14577_CONTROL3_WBTH_MASK	(0x3 << MAX14577_CONTROL3_WBTH_SHIFT)
 
 /* MAX14577 CDETCTRL1 register */
 #define MAXIM_CDETCTRL1_CHGDETEN_SHIFT	0
 #define MAXIM_CDETCTRL1_CHGTYPMAN_SHIFT	1
 #define MAXIM_CDETCTRL1_DCDEN_SHIFT	2
 #define MAXIM_CDETCTRL1_DCD2SCT_SHIFT	3
-#define MAXIM_CDETCTRL1_DCHKTM_SHIFT	4
-#define MAXIM_CDETCTRL1_DBEXIT_SHIFT	5
-#define MAXIM_CDETCTRL1_DBIDLE_SHIFT	6
+#define MAX14577_CDETCTRL1_DCHKTM_SHIFT	4
+#define MAX77836_CDETCTRL1_CDLY_SHIFT	4
+#define MAX14577_CDETCTRL1_DBEXIT_SHIFT	5
+#define MAX77836_CDETCTRL1_DCDCPL_SHIFT	5
+#define MAX14577_CDETCTRL1_DBIDLE_SHIFT	6
 #define MAXIM_CDETCTRL1_CDPDET_SHIFT	7
 #define MAXIM_CDETCTRL1_CHGDETEN_MASK	(0x1 << MAXIM_CDETCTRL1_CHGDETEN_SHIFT)
 #define MAXIM_CDETCTRL1_CHGTYPMAN_MASK	(0x1 << MAXIM_CDETCTRL1_CHGTYPMAN_SHIFT)
 #define MAXIM_CDETCTRL1_DCDEN_MASK	(0x1 << MAXIM_CDETCTRL1_DCDEN_SHIFT)
 #define MAXIM_CDETCTRL1_DCD2SCT_MASK	(0x1 << MAXIM_CDETCTRL1_DCD2SCT_SHIFT)
-#define MAXIM_CDETCTRL1_DCHKTM_MASK	(0x1 << MAXIM_CDETCTRL1_DCHKTM_SHIFT)
-#define MAXIM_CDETCTRL1_DBEXIT_MASK	(0x1 << MAXIM_CDETCTRL1_DBEXIT_SHIFT)
-#define MAXIM_CDETCTRL1_DBIDLE_MASK	(0x1 << MAXIM_CDETCTRL1_DBIDLE_SHIFT)
+#define MAX14577_CDETCTRL1_DCHKTM_MASK	(0x1 << MAX14577_CDETCTRL1_DCHKTM_SHIFT)
+#define MAX77836_CDETCTRL1_CDDLY_MASK	(0x1 << MAX77836_CDETCTRL1_CDDLY_SHIFT)
+#define MAX14577_CDETCTRL1_DBEXIT_MASK	(0x1 << MAX14577_CDETCTRL1_DBEXIT_SHIFT)
+#define MAX77836_CDETCTRL1_DCDCPL_MASK	(0x1 << MAX77836_CDETCTRL1_DCDCPL_SHIFT)
+#define MAX14577_CDETCTRL1_DBIDLE_MASK	(0x1 << MAX14577_CDETCTRL1_DBIDLE_SHIFT)
 #define MAXIM_CDETCTRL1_CDPDET_MASK	(0x1 << MAXIM_CDETCTRL1_CDPDET_SHIFT)
 
 /* MAX14577 MAXIM_CHGCTRL1 register */
-- 
1.7.9.5

