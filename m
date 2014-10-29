Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933940AbaJ2PMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:12:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10181 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933744AbaJ2PLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:11:08 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-f4-54510388a2d4
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
Subject: [PATCH v2 6/8] regulator: max77686: Add GPIO control
Date: Wed, 29 Oct 2014 16:06:44 +0100
Message-id: <1414595206-1437-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
References: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xy7odzIEhBruXCllsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKeLpqFXvBLNuKxwvrGxg/GnYx
	cnJICJhIzHp+ixHCFpO4cG89WxcjF4eQwFJGiUX7bzNBOH1MEv+2/WQBqWITMJbYvHwJWJWI
	QCezRM/BXmYQh1lgNZPEzyunmEGqhAVsJb7deswOYrMIqEp077vPBmLzCrhJvFuylQVin5zE
	yWOTWUFsTgF3iYUtH8DuEAKqebtsEssERt4FjAyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3
	MUJC/OsOxqXHrA4xCnAwKvHwRhwLCBFiTSwrrsw9xCjBwawkwvv5F1CINyWxsiq1KD++qDQn
	tfgQIxMHp1QDY+yGaaqZcgozov5yWj91F8rLmuYyZ4fweiMN4eknbDUXZb7t+Rn37GHzNEFZ
	E+H9TdvnzT+RWhjOd+LV8b9vexW8sszc+x2m79MJfXqC41YL3xu1ape4jUUnNKeYrw30rsgv
	6Bc8/qm+tUNNgs3xZqxv86Et+9K/vz/C92uD6HOd05pW2w06lFiKMxINtZiLihMBlBxOU08C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add enable control over GPIO for regulators supporting this: LDO20,
LDO21, LDO22, buck8 and buck9.

This is needed for proper (and full) configuration of the Maxim 77686
PMIC without creating redundant 'regulator-fixed' entries.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/Kconfig    |  1 +
 drivers/regulator/max77686.c | 97 ++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 90 insertions(+), 8 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 55d7b7b0f2e0..156ab8032ea4 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -391,6 +391,7 @@ config REGULATOR_MAX8998
 config REGULATOR_MAX77686
 	tristate "Maxim 77686 regulator"
 	depends on MFD_MAX77686
+	depends on GPIOLIB
 	help
 	  This driver controls a Maxim 77686 regulator
 	  via I2C bus. The provided regulator is suitable for
diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 5497e10b9659..9446509e7325 100644
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
 };
@@ -100,6 +109,25 @@ static unsigned int max77686_get_opmode_shift(int id)
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
@@ -428,8 +456,46 @@ static const struct regulator_desc regulators[] = {
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
+					struct max77686_data *max77686,
+					struct of_regulator_match *rdata)
+{
+	unsigned int i;
+	unsigned int valid_regulators[5] = { MAX77686_LDO20, MAX77686_LDO21,
+		MAX77686_LDO22, MAX77686_BUCK8, MAX77686_BUCK9 };
+
+	/*
+	 * 0 is a valid GPIO so initialize all GPIOs to negative value
+	 * to indicate that GPIO control won't be used for this regulator.
+	 */
+	for (i = 0; i < MAX77686_REGULATORS; i++)
+		max77686->gpio[i] = -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(valid_regulators); i++) {
+		unsigned int id = valid_regulators[i];
+		int *gpio = &max77686->gpio[id];
+
+		/* Assuming that index of rdata matches 'id' */
+		if (!rdata[id].init_data || !rdata[id].of_node)
+			continue;
+
+		*gpio = of_get_named_gpio(rdata[id].of_node, "gpio", 0);
+		if (gpio_is_valid(*gpio))
+			dev_dbg(&pdev->dev, "Using GPIO %d for ext-control over %d/%s\n",
+				*gpio, id, rdata[id].of_node->name);
+	}
+}
+
 static int max77686_pmic_dt_parse(struct platform_device *pdev,
-				struct of_regulator_match *rdata)
+					struct max77686_data *max77686,
+					struct of_regulator_match *rdata)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *pmic_np, *regulators_np;
@@ -444,7 +510,6 @@ static int max77686_pmic_dt_parse(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-
 	ret = of_regulator_match(&pdev->dev, regulators_np, rdata,
 			MAX77686_REGULATORS);
 	if (ret < 0) {
@@ -454,6 +519,8 @@ static int max77686_pmic_dt_parse(struct platform_device *pdev,
 	}
 	/* else: don't care how many regulators were parsed from DTS. */
 
+	max77686_pmic_dt_parse_gpio_control(pdev, max77686, rdata);
+
 	of_node_put(regulators_np);
 
 	return 0;
@@ -477,6 +544,8 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 	config.dev = &pdev->dev;
 	config.regmap = iodev->regmap;
 	config.driver_data = max77686;
+	config.ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
+	config.ena_gpio_initialized = true;
 	platform_set_drvdata(pdev, max77686);
 
 	rdata = kzalloc(sizeof(*rdata) * MAX77686_REGULATORS, GFP_KERNEL);
@@ -486,7 +555,7 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 	for (i = 0; i < MAX77686_REGULATORS; i++)
 		rdata[i].name = regulators[i].name;
 
-	ret = max77686_pmic_dt_parse(pdev, rdata);
+	ret = max77686_pmic_dt_parse(pdev, max77686, rdata);
 	if (ret)
 		goto out;
 
@@ -496,6 +565,7 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 
 		config.init_data = rdata[i].init_data;
 		config.of_node = rdata[i].of_node;
+		config.ena_gpio = max77686->gpio[id];
 
 		max77686->opmode[id] = MAX77686_NORMAL;
 
@@ -507,6 +577,17 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 				"regulator init failed for %d: %d\n", i, ret);
 			goto out;
 		}
+
+		if (gpio_is_valid(config.ena_gpio)) {
+			ret = max77686_enable_gpio_control(rdev);
+
+			if (ret < 0) {
+				dev_err(&pdev->dev,
+					"regulator enable ext control failed for %d\n",
+					i);
+				goto out;
+			}
+		}
 	}
 
 out:
-- 
1.9.1

