Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaK0LWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:22:22 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10326 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670AbaK0LVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:21:16 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-2b-54770929ed85
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 5/7] regulator: max77686: Add GPIO control
Date: Thu, 27 Nov 2014 12:20:51 +0100
Message-id: <1417087253-12306-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
References: <1417087253-12306-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnluLIzCtJLcpLzFFi42I5/e/4FV1NzvIQgzt3hC02zljPajH14RM2
	i/lHzrFavH5haNH/+DWzxdmmN+wW978eZbT4dqWDyWLT42usFpd3zWGzmHF+H5PF2iN32R14
	PHbOusvusWlVJ5vHnWt72Dw2L6n36NuyitHj8ya5ALYoLpuU1JzMstQifbsEroz3C30KmtQr
	tpzpYGtg7FboYuTgkBAwkVj5SqKLkRPIFJO4cG89WxcjF4eQwFJGiSkzzzFDOH1MEpu3vmQG
	qWITMJbYvHwJG4gtIrCCUeL4DUUQm1lgPZPEg21OILawgK3E0ol/WUFsFgFViRMH9jKDLOMV
	cJfYcMcXYpmcxMljk8FKOAU8JPbeus0CYgsBlex5dYdlAiPvAkaGVYyiqaXJBcVJ6blGesWJ
	ucWleel6yfm5mxghgfh1B+PSY1aHGAU4GJV4eBlulYUIsSaWFVfmHmKU4GBWEuHlYiwPEeJN
	SaysSi3Kjy8qzUktPsTIxMEp1cC4Nv2dSpdbw+3FTWtTypU/rQ6o3m9aNnPClw1ZU+bfPSp9
	NmRx6a8YDjN5rjuaEsxhR1ZkuF5+mmfkO+2vYMjkCQ0ndjfdKfLb72B9rdlXX2fevsk/Gvfp
	OV3myNNlFZQoiFGcZBB+eTv7Cx8d++Iy990qPvNKdK5//Ja95VDFnI5DnY9V5bKUWIozEg21
	mIuKEwGy+F1+IgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add enable control over GPIO for regulators supporting this: LDO20,
LDO21, LDO22, buck8 and buck9.

This is needed for proper (and full) configuration of the Maxim 77686
PMIC without creating redundant 'regulator-fixed' entries.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c | 58 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 10d206266ac2..0d6bddad0ef4 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -26,6 +26,7 @@
 #include <linux/bug.h>
 #include <linux/err.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #include <linux/slab.h>
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
@@ -46,6 +47,11 @@
 #define MAX77686_DVS_UVSTEP	12500
 
 /*
+ * Value for configuring buck[89] and LDO{20,21,22} as GPIO control.
+ * It is the same as 'off' for other regulators.
+ */
+#define MAX77686_GPIO_CONTROL		0x0
+/*
  * Values used for configuring LDOs and bucks.
  * Forcing low power mode: LDO1, 3-5, 9, 13, 17-26
  */
@@ -82,6 +88,8 @@ enum max77686_ramp_rate {
 };
 
 struct max77686_data {
+	unsigned long long gpio_enabled:MAX77686_REGULATORS;
+
 	/* Array indexed by regulator id */
 	unsigned int opmode[MAX77686_REGULATORS];
 };
@@ -100,6 +108,26 @@ static unsigned int max77686_get_opmode_shift(int id)
 	}
 }
 
+/*
+ * When regulator is configured for GPIO control then it
+ * replaces "normal" mode. Any change from low power mode to normal
+ * should actually change to GPIO control.
+ * Map normal mode to proper value for such regulators.
+ */
+static unsigned int max77686_map_normal_mode(struct max77686_data *max77686,
+					     int id)
+{
+	switch (id) {
+	case MAX77686_BUCK8:
+	case MAX77686_BUCK9:
+	case MAX77686_LDO20 ... MAX77686_LDO22:
+		if (max77686->gpio_enabled & (1 << id))
+			return MAX77686_GPIO_CONTROL;
+	}
+
+	return MAX77686_NORMAL;
+}
+
 /* Some BUCKs and LDOs supports Normal[ON/OFF] mode during suspend */
 static int max77686_set_suspend_disable(struct regulator_dev *rdev)
 {
@@ -136,7 +164,7 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 		val = MAX77686_LDO_LOWPOWER_PWRREQ;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = MAX77686_NORMAL;
+		val = max77686_map_normal_mode(max77686, id);
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
@@ -160,7 +188,7 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 {
 	unsigned int val;
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
-	int ret;
+	int ret, id = rdev_get_id(rdev);
 
 	switch (mode) {
 	case REGULATOR_MODE_STANDBY:			/* switch off */
@@ -170,7 +198,7 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 		val = MAX77686_LDO_LOWPOWER_PWRREQ;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = MAX77686_NORMAL;
+		val = max77686_map_normal_mode(max77686, id);
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
@@ -184,7 +212,7 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 	if (ret)
 		return ret;
 
-	max77686->opmode[rdev_get_id(rdev)] = val;
+	max77686->opmode[id] = val;
 	return 0;
 }
 
@@ -197,7 +225,7 @@ static int max77686_enable(struct regulator_dev *rdev)
 	shift = max77686_get_opmode_shift(id);
 
 	if (max77686->opmode[id] == MAX77686_OFF_PWRREQ)
-		max77686->opmode[id] = MAX77686_NORMAL;
+		max77686->opmode[id] = max77686_map_normal_mode(max77686, id);
 
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
@@ -229,6 +257,25 @@ static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 				  MAX77686_RAMP_RATE_MASK, ramp_value << 6);
 }
 
+static int max77686_enable_gpio_control(struct regulator_dev *rdev)
+{
+	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
+	int id = rdev_get_id(rdev);
+
+	switch (id) {
+	case MAX77686_BUCK8:
+	case MAX77686_BUCK9:
+	case MAX77686_LDO20 ... MAX77686_LDO22:
+		max77686->gpio_enabled |= (1 << id);
+
+		return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+					rdev->desc->enable_mask,
+					MAX77686_GPIO_CONTROL);
+	}
+
+	return -EINVAL;
+}
+
 static struct regulator_ops max77686_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
@@ -239,6 +286,7 @@ static struct regulator_ops max77686_ops = {
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
 	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
 	.set_suspend_mode	= max77686_set_suspend_mode,
+	.set_ena_gpio		= max77686_enable_gpio_control,
 };
 
 static struct regulator_ops max77686_ldo_ops = {
-- 
1.9.1

