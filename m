Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbaJ3LWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:22:40 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42895 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262AbaJ3LV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:28 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-ac-54521f35b188
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 10/14] regulator: max77686: Add GPIO control
Date: Thu, 30 Oct 2014 12:20:49 +0100
Message-id: <1414668053-31370-11-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xq7qm8kEhBstaLCw2zljPajFp3QEm
	i6kPn7BZXP/ynNVi/pFzrBZHfxdYvH5haNG74CqbxdmmN+wW978eZbT4dqWDyWLT42usFpd3
	zWGzmHF+H5PF7cu8FmuP3GW3ON3N6iDo0dLcw+bx9/l1Fo+/q14we+ycdZfdY9OqTjaPO9f2
	sHnMOxnosXlJvUffllWMHp83yQVwRXHZpKTmZJalFunbJXBl9H5YxljQZ1DR8Ps+cwPjRvUu
	Rk4OCQETibZJz5ghbDGJC/fWs3UxcnEICSxllGh7vYIZwuljkmhqP8sIUsUmYCyxefkSsCoR
	gU5miZ6DvWBVzAKrmSR+XjkFNktYwF6i4/lJMJtFQFViXtdkFhCbV8BDYtfGq6wQ++QkTh6b
	DGZzAsXXfGwHsjmA1rlL3PumPYGRdwEjwypG0dTS5ILipPRcI73ixNzi0rx0veT83E2MkBD/
	uoNx6TGrQ4wCHIxKPLwRxwJChFgTy4orcw8xSnAwK4nwrhYLChHiTUmsrEotyo8vKs1JLT7E
	yMTBKdXAqLShOjr/8V+PV2farc4eXZLWYlDA7Psz/sipb+wfT7bzN5zk4uY4UvrC9JfQqdyf
	N5aEz5hSMGML+7HJKlJPzk5cYFIcfj4+r7cyY4rSx0XuN6avkpSvPfllu/m+89r+3C8ke3ke
	/T2Qp2018c90tZBjxxtKpkvzfDxwZWNsR5zGS/711/UjpimxFGckGmoxFxUnAgBsinxPTwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add enable control over GPIO for regulators supporting this: LDO20,
LDO21, LDO22, buck8 and buck9.

This is needed for proper (and full) configuration of the Maxim 77686
PMIC without creating redundant 'regulator-fixed' entries.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c | 83 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 78 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 2c276d147c90..9108cde069fe 100644
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
@@ -82,6 +88,9 @@ enum max77686_ramp_rate {
 };
 
 struct max77686_data {
+	/* GPIO control over regulators */
+	int gpio[MAX77686_REGULATORS];
+
 	/* Array indexed by regulator id */
 	unsigned int opmode[MAX77686_REGULATORS];
 	bool missing_of_node;
@@ -101,6 +110,25 @@ static unsigned int max77686_get_opmode_shift(int id)
 	}
 }
 
+/*
+ * When regulator is configured for GPIO control then it
+ * replaces "normal" mode. Any change from low power mode to normal
+ * should actually change to GPIO control.
+ * Map normal mode to proper value for such regulators.
+ */
+static int max77686_map_normal_mode(struct max77686_data *max77686, int id)
+{
+	switch (id) {
+	case MAX77686_BUCK8:
+	case MAX77686_BUCK9:
+	case MAX77686_LDO20 ... MAX77686_LDO22:
+		if (gpio_is_valid(max77686->gpio[id]))
+			return MAX77686_GPIO_CONTROL;
+	}
+
+	return MAX77686_NORMAL;
+}
+
 /* Some BUCKs and LDOs supports Normal[ON/OFF] mode during suspend */
 static int max77686_set_suspend_disable(struct regulator_dev *rdev)
 {
@@ -137,7 +165,7 @@ static int max77686_set_suspend_mode(struct regulator_dev *rdev,
 		val = MAX77686_LDO_LOWPOWER_PWRREQ;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = MAX77686_NORMAL;
+		val = max77686_map_normal_mode(max77686, id);
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
@@ -161,7 +189,7 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 {
 	unsigned int val;
 	struct max77686_data *max77686 = rdev_get_drvdata(rdev);
-	int ret;
+	int ret, id = rdev_get_id(rdev);
 
 	switch (mode) {
 	case REGULATOR_MODE_STANDBY:			/* switch off */
@@ -171,7 +199,7 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 		val = MAX77686_LDO_LOWPOWER_PWRREQ;
 		break;
 	case REGULATOR_MODE_NORMAL:			/* ON in Normal Mode */
-		val = MAX77686_NORMAL;
+		val = max77686_map_normal_mode(max77686, id);
 		break;
 	default:
 		pr_warn("%s: regulator_suspend_mode : 0x%x not supported\n",
@@ -185,7 +213,7 @@ static int max77686_ldo_set_suspend_mode(struct regulator_dev *rdev,
 	if (ret)
 		return ret;
 
-	max77686->opmode[rdev_get_id(rdev)] = val;
+	max77686->opmode[id] = val;
 	return 0;
 }
 
@@ -198,7 +226,7 @@ static int max77686_enable(struct regulator_dev *rdev)
 	shift = max77686_get_opmode_shift(id);
 
 	if (max77686->opmode[id] == MAX77686_OFF_PWRREQ)
-		max77686->opmode[id] = MAX77686_NORMAL;
+		max77686->opmode[id] = max77686_map_normal_mode(max77686, id);
 
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask,
@@ -436,6 +464,33 @@ static const struct regulator_desc regulators[] = {
 	regulator_desc_buck(9),
 };
 
+static int max77686_enable_gpio_control(struct regulator_dev *rdev)
+{
+	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
+					rdev->desc->enable_mask,
+					MAX77686_GPIO_CONTROL);
+}
+
+static void max77686_pmic_dt_parse_gpio_control(struct platform_device *pdev,
+					int *gpio)
+{
+	struct device_node *np = pdev->dev.of_node;
+	int i;
+
+	/*
+	 * 0 is a valid GPIO so initialize all GPIOs to negative value
+	 * to indicate that GPIO control won't be used for this regulator.
+	 */
+	for (i = 0; i < MAX77686_REGULATORS; i++)
+		gpio[i] = -EINVAL;
+
+	gpio[MAX77686_LDO20] = of_get_named_gpio(np, "ldo20-gpio", 0);
+	gpio[MAX77686_LDO21] = of_get_named_gpio(np, "ldo21-gpio", 0);
+	gpio[MAX77686_LDO22] = of_get_named_gpio(np, "ldo22-gpio", 0);
+	gpio[MAX77686_BUCK8] = of_get_named_gpio(np, "buck8-gpio", 0);
+	gpio[MAX77686_BUCK9] = of_get_named_gpio(np, "buck9-gpio", 0);
+}
+
 static int max77686_pmic_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
@@ -467,12 +522,17 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 	config.dev = &pdev->dev;
 	config.regmap = iodev->regmap;
 	config.driver_data = max77686;
+	config.ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
+	config.ena_gpio_initialized = true;
 	platform_set_drvdata(pdev, max77686);
 
+	max77686_pmic_dt_parse_gpio_control(pdev, max77686->gpio);
+
 	for (i = 0; i < MAX77686_REGULATORS; i++) {
 		struct regulator_dev *rdev;
 		int id = regulators[i].id;
 
+		config.ena_gpio = max77686->gpio[id];
 		max77686->opmode[id] = MAX77686_NORMAL;
 
 		rdev = devm_regulator_register(&pdev->dev,
@@ -485,6 +545,19 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 				of_node_put(pdev->dev.of_node);
 			return ret;
 		}
+
+		if (gpio_is_valid(config.ena_gpio)) {
+			int ret = max77686_enable_gpio_control(rdev);
+
+			if (ret < 0) {
+				dev_err(&pdev->dev,
+					"regulator enable ext control failed for %d\n",
+					i);
+				if (max77686->missing_of_node)
+					of_node_put(pdev->dev.of_node);
+				return ret;
+			}
+		}
 	}
 
 	return 0;
-- 
1.9.1

