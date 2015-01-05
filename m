Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbbAELwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:52:15 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41973 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbbAELuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:50:52 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-78-54aa7a996811
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene@kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 3/5] regulator: max77686: Add GPIO control
Date: Mon, 05 Jan 2015 12:48:43 +0100
Message-id: <1420458525-22576-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
References: <1420458525-22576-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e/4Zd2ZVatCDPrnMVtsnLGe1WLqwyds
	FvOPnGO1eP3C0KL/8Wtmi7NNb9gtvl3pYLLY9Pgaq8XlXXPYLGac38fkwOWxc9Zddo9NqzrZ
	PDYvqffo27KK0ePzJrkA1igum5TUnMyy1CJ9uwSujJ7dF9gKGnUqFq7cxNrA+EC5i5GTQ0LA
	RGLLwg9sELaYxIV764FsLg4hgaWMEpc6frFAOH1MEhfm7WIHqWITMJbYvHwJWJWIwAdGiVWT
	frCCOMwC0xglLpz6zgxSJSxgK3F05WEwm0VAVWLLgi6wbl4Bd4lbbXdYIPbJSZw8NpkVxOYU
	8JDoevoJrF4IqGbazmbmCYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefnbmKEBN2XHYyL
	j1kdYhTgYFTi4fU4sTJEiDWxrLgy9xCjBAezkgjvq/RVIUK8KYmVValF+fFFpTmpxYcYmTg4
	pRoY46ZeeFu353tG5hL+iccMn2kkt/gKl4Qp/1EpzFtUuGLiarufvv3p00+t75G7/uer8vbk
	A73L1r+v+li+Oc6i2+zOnCM3HQSyutiDaj5YzNYSeWgRt13JxZu9XPzTWt99imJNy5bF/FVv
	4vogExx69g5TvVH7faOo6iM3pn4PzPlZmXTxjaumEktxRqKhFnNRcSIAV4+37RgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add enable control over GPIO for regulators supporting this: LDO20,
LDO21, LDO22, buck8 and buck9.

This is needed for proper (and full) configuration of the Maxim 77686
PMIC without creating redundant 'regulator-fixed' entries.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c | 70 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 10d206266ac2..15fb1416bfbd 100644
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
+	u64 gpio_enabled:MAX77686_REGULATORS;
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
@@ -229,6 +257,36 @@ static int max77686_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 				  MAX77686_RAMP_RATE_MASK, ramp_value << 6);
 }
 
+static int max77686_of_parse_cb(struct device_node *np,
+		const struct regulator_desc *desc,
+		struct regulator_config *config)
+{
+	struct max77686_data *max77686 = config->driver_data;
+
+	switch (desc->id) {
+	case MAX77686_BUCK8:
+	case MAX77686_BUCK9:
+	case MAX77686_LDO20 ... MAX77686_LDO22:
+		config->ena_gpio = of_get_named_gpio(np,
+					"maxim,ena-gpios", 0);
+		config->ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
+		config->ena_gpio_initialized = true;
+		break;
+	default:
+		return 0;
+	}
+
+	if (gpio_is_valid(config->ena_gpio)) {
+		max77686->gpio_enabled |= (1 << desc->id);
+
+		return regmap_update_bits(config->regmap, desc->enable_reg,
+					  desc->enable_mask,
+					  MAX77686_GPIO_CONTROL);
+	}
+
+	return 0;
+}
+
 static struct regulator_ops max77686_ops = {
 	.list_voltage		= regulator_list_voltage_linear,
 	.map_voltage		= regulator_map_voltage_linear,
@@ -283,6 +341,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.name		= "LDO"#num,					\
 	.of_match	= of_match_ptr("LDO"#num),			\
 	.regulators_node	= of_match_ptr("voltage-regulators"),	\
+	.of_parse_cb	= max77686_of_parse_cb,				\
 	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -355,6 +414,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 	.name		= "BUCK"#num,					\
 	.of_match	= of_match_ptr("BUCK"#num),			\
 	.regulators_node	= of_match_ptr("voltage-regulators"),	\
+	.of_parse_cb	= max77686_of_parse_cb,				\
 	.id		= MAX77686_BUCK##num,				\
 	.ops		= &max77686_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
-- 
1.9.1

