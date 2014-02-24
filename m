Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaBXKNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:13:44 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53234 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbaBXKLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:11:23 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-fa-530b1ac9a55f
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 13/16] regulator/mfd: max14577: Export symbols for
 calculating charger current
Date: Mon, 24 Feb 2014 11:10:38 +0100
Message-id: <1393236641-14977-14-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t/xy7onpbiDDXYd5rDYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1u8fmFocbbpDbvF/a9HGS02Pb7GanF51xw2i7VH7rJbnO5mtVg/
	4zWLA6/Hzll32T02r9Dy2LSqk83jzrU9bB7zTgZ6bF5S79G3ZRWjx+dNcgEcUVw2Kak5mWWp
	Rfp2CVwZG2+uZyy4nlSx++JcpgbGD0FdjJwcEgImEqv27GeFsMUkLtxbz9bFyMUhJLCUUWJN
	02wmCKePSaJr9z02kCo2AWOJzcuXgFWJCGxhkuj98IURxGEWeM4o8XHRTHaQKmGBZInTs7cy
	gdgsAqoSP6esBiri4OAV8JDo7LUAMSUEFCTmTLIBqeAEit5teQB2hZCAu8S3eddZJjDyLmBk
	WMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREqZfdzAuPWZ1iFGAg1GJh1eimitYiDWxrLgy
	9xCjBAezkgivGS93sBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG7wXNnLLL8qVOehQ9lWNRcnEO
	a373cY1JjZa685TFjQqVqYvvFce8n5PQwWxeud+rKkwkYtG3/9/1Ur8XWE+/JNdaxcKu2NHk
	GpaVsvZb2i7eQ5Hz7AsmHlJQTrvkyvDDXLMkua9hCv/6BwbH7d//ulC36MXDmD1eX3wYjnz/
	WtIu+I7Bq1KJpTgj0VCLuag4EQDZlq42MQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares for changing the max14577 charger driver to allow
configuring battery-dependent settings from DTS.

The patch moves from regulator driver to MFD core driver and exports:
 - function for calculating register value for charger's current;
 - table of limits for chargers (MAX14577, MAX77836).

Previously they were used only by the max14577 regulator driver. In next
patch the charger driver will use them as well. Exporting them will
reduce unnecessary code duplication.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Mark Brown <broonie@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max14577.c               |   95 ++++++++++++++++++++++++++++++++++
 drivers/regulator/max14577.c         |   84 +++---------------------------
 include/linux/mfd/max14577-private.h |   22 ++++----
 include/linux/mfd/max14577.h         |   23 ++++++++
 4 files changed, 135 insertions(+), 89 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index b2bd963f9e0c..03fde3e5d1fb 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -25,6 +25,87 @@
 #include <linux/mfd/max14577.h>
 #include <linux/mfd/max14577-private.h>
 
+/*
+ * Table of valid charger currents for different Maxim chipsets.
+ * It is placed here because it is used by both charger and regulator driver.
+ */
+const struct maxim_charger_current maxim_charger_currents[] = {
+	[MAXIM_DEVICE_TYPE_UNKNOWN] = { 0, 0, 0, 0 },
+	[MAXIM_DEVICE_TYPE_MAX14577] = {
+		.min		= MAX14577_CHARGER_CURRENT_LIMIT_MIN,
+		.high_start	= MAX14577_CHARGER_CURRENT_LIMIT_HIGH_START,
+		.high_step	= MAX14577_CHARGER_CURRENT_LIMIT_HIGH_STEP,
+		.max		= MAX14577_CHARGER_CURRENT_LIMIT_MAX,
+	},
+	[MAXIM_DEVICE_TYPE_MAX77836] = {
+		.min		= MAX77836_CHARGER_CURRENT_LIMIT_MIN,
+		.high_start	= MAX77836_CHARGER_CURRENT_LIMIT_HIGH_START,
+		.high_step	= MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP,
+		.max		= MAX77836_CHARGER_CURRENT_LIMIT_MAX,
+	},
+};
+EXPORT_SYMBOL_GPL(maxim_charger_currents);
+
+/*
+ * maxim_charger_calc_reg_current - Calculate register value for current
+ * @limits:	constraints for charger, matching the MBCICHWRC register
+ * @min_ua:	minimal requested current, micro Amps
+ * @max_ua:	maximum requested current, micro Amps
+ * @dst:	destination to store calculated register value
+ *
+ * Calculates the value of MBCICHWRC (Fast Battery Charge Current) register
+ * for given current and stores it under pointed 'dst'. The stored value
+ * combines low bit (MBCICHWRCL) and high bits (MBCICHWRCH). It is also
+ * properly shifted.
+ *
+ * The calculated register value matches the current which:
+ *  - is always between <limits.min, limits.max>;
+ *  - is always less or equal to max_ua;
+ *  - is the highest possible value;
+ *  - may be lower than min_ua.
+ *
+ * On success returns 0. On error returns -EINVAL (requested min/max current
+ * is outside of given charger limits) and 'dst' is not set.
+ */
+int maxim_charger_calc_reg_current(const struct maxim_charger_current *limits,
+		unsigned int min_ua, unsigned int max_ua, u8 *dst)
+{
+	unsigned int current_bits = 0xf;
+
+	if (min_ua > max_ua)
+		return -EINVAL;
+
+	if (min_ua > limits->max || max_ua < limits->min)
+		return -EINVAL;
+
+	if (max_ua < limits->high_start) {
+		/*
+		 * Less than high_start, so set the minimal current
+		 * (turn Low Bit off, 0 as high bits).
+		 */
+		*dst = 0x0;
+		return 0;
+	}
+
+	/* max_ua is in range: <high_start, infinite>, cut it to limits.max */
+	max_ua = min(limits->max, max_ua);
+	max_ua -= limits->high_start;
+	/*
+	 * There is no risk of overflow 'max_ua' here because:
+	 *  - max_ua >= limits.high_start
+	 *  - BUILD_BUG checks that 'limits' are: max >= high_start + high_step
+	 */
+	current_bits = max_ua / limits->high_step;
+
+	/* Turn Low Bit on (use range <limits.high_start, limits.max>) ... */
+	*dst = 0x1 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT;
+	/* and set proper High Bits */
+	*dst |= current_bits << MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(maxim_charger_calc_reg_current);
+
 static struct mfd_cell max14577_devs[] = {
 	{
 		.name = "max14577-muic",
@@ -464,6 +545,20 @@ static int __init max14577_i2c_init(void)
 	BUILD_BUG_ON(ARRAY_SIZE(max14577_i2c_id) != MAXIM_DEVICE_TYPE_NUM);
 	BUILD_BUG_ON(ARRAY_SIZE(max14577_dt_match) != MAXIM_DEVICE_TYPE_NUM);
 
+	/* Valid charger current values must be provided for each chipset */
+	BUILD_BUG_ON(ARRAY_SIZE(maxim_charger_currents) != MAXIM_DEVICE_TYPE_NUM);
+
+	/* Check for valid values for charger */
+	BUILD_BUG_ON(MAX14577_CHARGER_CURRENT_LIMIT_HIGH_START +
+			MAX14577_CHARGER_CURRENT_LIMIT_HIGH_STEP * 0xf !=
+			MAX14577_CHARGER_CURRENT_LIMIT_MAX);
+	BUILD_BUG_ON(MAX14577_CHARGER_CURRENT_LIMIT_HIGH_STEP == 0);
+
+	BUILD_BUG_ON(MAX77836_CHARGER_CURRENT_LIMIT_HIGH_START +
+			MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP * 0xf !=
+			MAX77836_CHARGER_CURRENT_LIMIT_MAX);
+	BUILD_BUG_ON(MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP == 0);
+
 	return i2c_add_driver(&max14577_i2c_driver);
 }
 subsys_initcall(max14577_i2c_init);
diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 70f2c453934a..6547cb3146e3 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -22,42 +22,6 @@
 #include <linux/mfd/max14577-private.h>
 #include <linux/regulator/of_regulator.h>
 
-/*
- * Valid limits of current for max14577 and max77836 chargers.
- * They must correspond to MBCICHWRCL and MBCICHWRCH fields in CHGCTRL4
- * register for given chipset.
- */
-struct maxim_charger_current {
-	/* Minimal current, set in CHGCTRL4/MBCICHWRCL, uA */
-	unsigned int min;
-	/*
-	 * Minimal current when high setting is active,
-	 * set in CHGCTRL4/MBCICHWRCH, uA
-	 */
-	unsigned int high_start;
-	/* Value of one step in high setting, uA */
-	unsigned int high_step;
-	/* Maximum current of high setting, uA */
-	unsigned int max;
-};
-
-/* Table of valid charger currents for different Maxim chipsets */
-static const struct maxim_charger_current maxim_charger_currents[] = {
-	[MAXIM_DEVICE_TYPE_UNKNOWN] = { 0, 0, 0, 0 },
-	[MAXIM_DEVICE_TYPE_MAX14577] = {
-		.min		= MAX14577_REGULATOR_CURRENT_LIMIT_MIN,
-		.high_start	= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START,
-		.high_step	= MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP,
-		.max		= MAX14577_REGULATOR_CURRENT_LIMIT_MAX,
-	},
-	[MAXIM_DEVICE_TYPE_MAX77836] = {
-		.min		= MAX77836_REGULATOR_CURRENT_LIMIT_MIN,
-		.high_start	= MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_START,
-		.high_step	= MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_STEP,
-		.max		= MAX77836_REGULATOR_CURRENT_LIMIT_MAX,
-	},
-};
-
 static int max14577_reg_is_enabled(struct regulator_dev *rdev)
 {
 	int rid = rdev_get_id(rdev);
@@ -103,8 +67,8 @@ static int max14577_reg_get_current_limit(struct regulator_dev *rdev)
 static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
 		int min_uA, int max_uA)
 {
-	int i, current_bits = 0xf;
 	u8 reg_data;
+	int ret;
 	struct maxim_core *maxim_core = rdev_get_drvdata(rdev);
 	const struct maxim_charger_current *limits =
 		&maxim_charger_currents[maxim_core->dev_type];
@@ -112,39 +76,13 @@ static int max14577_reg_set_current_limit(struct regulator_dev *rdev,
 	if (rdev_get_id(rdev) != MAX14577_CHARGER)
 		return -EINVAL;
 
-	if (min_uA > limits->max || max_uA < limits->min)
-		return -EINVAL;
-
-	if (max_uA < limits->high_start) {
-		/*
-		 * Less than high_start,
-		 * so set the minimal current (turn only Low Bit off)
-		 */
-		u8 reg_data = 0x0 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT;
-		return max14577_update_reg(rdev->regmap,
-				MAXIM_CHG_REG_CHGCTRL4,
-				MAXIM_CHGCTRL4_MBCICHWRCL_MASK, reg_data);
-	}
-
-	/*
-	 * max_uA is in range: <high_start, inifinite>, so search for
-	 * valid current starting from maximum current.
-	 */
-	for (i = limits->max; i >= limits->high_start; i -= limits->high_step) {
-		if (i <= max_uA)
-			break;
-		current_bits--;
-	}
-	BUG_ON(current_bits < 0); /* Cannot happen */
-
-	/* Turn Low Bit on (use range high_start-max)... */
-	reg_data = 0x1 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT;
-	/* and set proper High Bits */
-	reg_data |= current_bits << MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT;
+	ret = maxim_charger_calc_reg_current(limits, min_uA, max_uA, &reg_data);
+	if (ret)
+		return ret;
 
 	return max14577_update_reg(rdev->regmap, MAXIM_CHG_REG_CHGCTRL4,
-		MAXIM_CHGCTRL4_MBCICHWRCL_MASK | MAXIM_CHGCTRL4_MBCICHWRCH_MASK,
-		reg_data);
+			MAXIM_CHGCTRL4_MBCICHWRCL_MASK | MAXIM_CHGCTRL4_MBCICHWRCH_MASK,
+			reg_data);
 }
 
 static struct regulator_ops max14577_safeout_ops = {
@@ -444,16 +382,6 @@ static struct platform_driver max14577_regulator_driver = {
 
 static int __init max14577_regulator_init(void)
 {
-	/* Check for valid values for charger */
-	BUILD_BUG_ON(MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START +
-			MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP * 0xf !=
-			MAX14577_REGULATOR_CURRENT_LIMIT_MAX);
-	BUILD_BUG_ON(MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_START +
-			MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_STEP * 0xf !=
-			MAX77836_REGULATOR_CURRENT_LIMIT_MAX);
-	/* Valid charger current values must be provided for each chipset */
-	BUILD_BUG_ON(ARRAY_SIZE(maxim_charger_currents) != MAXIM_DEVICE_TYPE_NUM);
-
 	BUILD_BUG_ON(ARRAY_SIZE(max14577_supported_regulators) != MAX14577_REG_NUM);
 	BUILD_BUG_ON(ARRAY_SIZE(max77836_supported_regulators) != MAX77836_REG_NUM);
 
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 21c6dd785563..a8cd7de3526a 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -257,17 +257,17 @@ enum maxim_muic_charger_type {
 #define MAXIM_CHGCTRL7_OTPCGHCVS_SHIFT	0
 #define MAXIM_CHGCTRL7_OTPCGHCVS_MASK	(0x3 << MAXIM_CHGCTRL7_OTPCGHCVS_SHIFT)
 
-/* MAX14577 regulator current limits (as in MAXIM_CHGCTRL4 register), uA */
-#define MAX14577_REGULATOR_CURRENT_LIMIT_MIN		 90000
-#define MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_START	200000
-#define MAX14577_REGULATOR_CURRENT_LIMIT_HIGH_STEP	 50000
-#define MAX14577_REGULATOR_CURRENT_LIMIT_MAX		950000
-
-/* MAX77836 regulator current limits (as in MAXIM_CHGCTRL4 register), uA */
-#define MAX77836_REGULATOR_CURRENT_LIMIT_MIN		 45000
-#define MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_START	100000
-#define MAX77836_REGULATOR_CURRENT_LIMIT_HIGH_STEP	 25000
-#define MAX77836_REGULATOR_CURRENT_LIMIT_MAX		475000
+/* MAX14577 charger current limits (as in MAXIM_CHGCTRL4 register), uA */
+#define MAX14577_CHARGER_CURRENT_LIMIT_MIN		 90000U
+#define MAX14577_CHARGER_CURRENT_LIMIT_HIGH_START	200000U
+#define MAX14577_CHARGER_CURRENT_LIMIT_HIGH_STEP	 50000U
+#define MAX14577_CHARGER_CURRENT_LIMIT_MAX		950000U
+
+/* MAX77836 charger current limits (as in MAXIM_CHGCTRL4 register), uA */
+#define MAX77836_CHARGER_CURRENT_LIMIT_MIN		 45000U
+#define MAX77836_CHARGER_CURRENT_LIMIT_HIGH_START	100000U
+#define MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP	 25000U
+#define MAX77836_CHARGER_CURRENT_LIMIT_MAX		475000U
 
 /* MAX14577 regulator SFOUT LDO voltage, fixed, uV */
 #define MAX14577_REGULATOR_SAFEOUT_VOLTAGE		4900000
diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
index 0070c69481ef..0df2fe329b83 100644
--- a/include/linux/mfd/max14577.h
+++ b/include/linux/mfd/max14577.h
@@ -74,4 +74,27 @@ struct max14577_platform_data {
 	struct max14577_regulator_platform_data *regulators;
 };
 
+/*
+ * Valid limits of current for max14577 and max77836 chargers.
+ * They must correspond to MBCICHWRCL and MBCICHWRCH fields in CHGCTRL4
+ * register for given chipset.
+ */
+struct maxim_charger_current {
+	/* Minimal current, set in CHGCTRL4/MBCICHWRCL, uA */
+	unsigned int min;
+	/*
+	 * Minimal current when high setting is active,
+	 * set in CHGCTRL4/MBCICHWRCH, uA
+	 */
+	unsigned int high_start;
+	/* Value of one step in high setting, uA */
+	unsigned int high_step;
+	/* Maximum current of high setting, uA */
+	unsigned int max;
+};
+
+extern const struct maxim_charger_current maxim_charger_currents[];
+extern int maxim_charger_calc_reg_current(const struct maxim_charger_current *limits,
+		unsigned int min_ua, unsigned int max_ua, u8 *dst);
+
 #endif /* __MAX14577_H__ */
-- 
1.7.9.5

