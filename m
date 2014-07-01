Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbaGAHD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:03:27 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:22530 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbaGAHCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:02:21 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-cf-53b25cf96d4d
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Jenny Tc <jenny.tc@intel.com>
Subject: [RESEND PATCH 3/5] charger: max14577: Configure battery-dependent
 settings from DTS
Date: Tue, 01 Jul 2014 09:01:58 +0200
Message-id: <1404198121-22989-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1404198121-22989-1-git-send-email-k.kozlowski@samsung.com>
References: <1404198121-22989-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xq7o/YzYFG7w4ZG2xccZ6VoupD5+w
	WUx68p7ZYuLKycwW/W8Wslqce7WS0WLt1x52i9cvDC3ONr1ht7j/9SijxbcrHUwWl3fNYbNY
	e+Quu8XS6xeZLCZMX8ti0br3CLvF6W5WB0GPNfPWMHpc7utl8tg56y67x8rlX9g8Nq/Q8li8
	5yWTx6ZVnWwed67tYfOYdzLQo2/LKkaPz5vkArijuGxSUnMyy1KL9O0SuDLm7I0ueBRX0fD/
	ElMD4xK/LkYODgkBE4m73QVdjJxAppjEhXvr2boYuTiEBJYySrT2zGaGcPqYJBqPTGcGqWIT
	MJbYvHwJG4gtIlAp8e30CRaQImaBrSwSnadvsoMkhAXiJJ4e/cMKYrMIqEqcv38arIFXwF3i
	5L11jBDr5CROHpsMVsMp4CFxsv8pWFwIqObCnT+MExh5FzAyrGIUTS1NLihOSs811CtOzC0u
	zUvXS87P3cQICfYvOxgXH7M6xCjAwajEw9u4YkOwEGtiWXFl7iFGCQ5mJRFeTr9NwUK8KYmV
	ValF+fFFpTmpxYcYmTg4pRoYJzBFrfURUNFf9UegNvFI52XDYMUDM4J/THM1Omx6Yn2E0jfb
	/4/u3D6nzfm0ba7Gmh9TPcsCm68ueOmlsH3uhfX76viPuh67lJpzbUec1L1FW9asmfb349zw
	jrkaRrv75jiKHMv8dShpX+CHAwxFTkovjC77KF99UdzfZzFHZql5hZv0zeZLUkosxRmJhlrM
	RcWJAAloy/VUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove hard-coded values for:
 - Fast Charge current,
 - End Of Charge current,
 - Fast Charge timer,
 - Overvoltage Protection Threshold,
 - Battery Constant Voltage,
and use DTS to configure them. This allows using the max14577 charger
driver with different batteries.

Now the charger driver requires valid configuration data from DTS. In
case of wrong configuration data it fails during probe. Patch adds
of_compatible to the charger mfd cell in MFD driver core.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jenny Tc <jenny.tc@intel.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max14577.c               |   5 +-
 drivers/power/max14577_charger.c     | 232 +++++++++++++++++++++++++++++++----
 include/linux/mfd/max14577-private.h |  16 +++
 include/linux/mfd/max14577.h         |   8 ++
 4 files changed, 233 insertions(+), 28 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index e6f25aa0ded8..b8af263be594 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -116,7 +116,10 @@ static const struct mfd_cell max14577_devs[] = {
 		.name = "max14577-regulator",
 		.of_compatible = "maxim,max14577-regulator",
 	},
-	{ .name = "max14577-charger", },
+	{
+		.name = "max14577-charger",
+		.of_compatible = "maxim,max14577-charger",
+	},
 };
 
 static const struct mfd_cell max77836_devs[] = {
diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
index 19c8f42abf24..f32f94a9a144 100644
--- a/drivers/power/max14577_charger.c
+++ b/drivers/power/max14577_charger.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/mfd/max14577-private.h>
+#include <linux/mfd/max14577.h>
 
 struct max14577_charger {
 	struct device *dev;
@@ -27,6 +28,8 @@ struct max14577_charger {
 
 	unsigned int		charging_state;
 	unsigned int		battery_state;
+
+	struct max14577_charger_platform_data	*pdata;
 };
 
 /*
@@ -178,15 +181,107 @@ static int max14577_get_present(struct max14577_charger *chg)
 	return 1;
 }
 
+static inline int max14577_init_constant_voltage(struct max14577_charger *chg,
+		unsigned int uvolt)
+{
+	u8 reg_data;
+
+	if (uvolt < MAXIM_CHARGER_CONSTANT_VOLTAGE_MIN ||
+			uvolt > MAXIM_CHARGER_CONSTANT_VOLTAGE_MAX)
+		return -EINVAL;
+
+	if (uvolt == 4200000)
+		reg_data = 0x0;
+	else if (uvolt == MAXIM_CHARGER_CONSTANT_VOLTAGE_MAX)
+		reg_data = 0x1f;
+	else if (uvolt <= 4280000) {
+		unsigned int val = uvolt;
+
+		val -= MAXIM_CHARGER_CONSTANT_VOLTAGE_MIN;
+		val /= MAXIM_CHARGER_CONSTANT_VOLTAGE_STEP;
+		if (uvolt <= 4180000)
+			reg_data = 0x1 + val;
+		else
+			reg_data = val; /* Fix for gap between 4.18V and 4.22V */
+	} else
+		return -EINVAL;
+
+	reg_data <<= CHGCTRL3_MBCCVWRC_SHIFT;
+
+	return max14577_write_reg(chg->max14577->regmap,
+			MAX14577_CHG_REG_CHG_CTRL3, reg_data);
+}
+
+static inline int max14577_init_eoc(struct max14577_charger *chg,
+		unsigned int uamp)
+{
+	unsigned int current_bits = 0xf;
+	u8 reg_data;
+
+	switch (chg->max14577->dev_type) {
+	case MAXIM_DEVICE_TYPE_MAX77836:
+		if (uamp < 5000)
+			return -EINVAL; /* Requested current is too low */
+
+		if (uamp >= 7500 && uamp < 10000)
+			current_bits = 0x0;
+		else if (uamp <= 50000) {
+			/* <5000, 7499> and <10000, 50000> */
+			current_bits = uamp / 5000;
+		} else {
+			uamp = min(uamp, 100000U) - 50000U;
+			current_bits = 0xa + uamp / 10000;
+		}
+		break;
+
+	case MAXIM_DEVICE_TYPE_MAX14577:
+	default:
+		if (uamp < MAX14577_CHARGER_EOC_CURRENT_LIMIT_MIN)
+			return -EINVAL; /* Requested current is too low */
+
+		uamp = min(uamp, MAX14577_CHARGER_EOC_CURRENT_LIMIT_MAX);
+		uamp -= MAX14577_CHARGER_EOC_CURRENT_LIMIT_MIN;
+		current_bits = uamp / MAX14577_CHARGER_EOC_CURRENT_LIMIT_STEP;
+		break;
+	}
+
+	reg_data = current_bits << CHGCTRL5_EOCS_SHIFT;
+
+	return max14577_update_reg(chg->max14577->regmap,
+			MAX14577_CHG_REG_CHG_CTRL5, CHGCTRL5_EOCS_MASK,
+			reg_data);
+}
+
+static inline int max14577_init_fast_charge(struct max14577_charger *chg,
+		unsigned int uamp)
+{
+	u8 reg_data;
+	int ret;
+	const struct maxim_charger_current *limits =
+		&maxim_charger_currents[chg->max14577->dev_type];
+
+	ret = maxim_charger_calc_reg_current(limits, uamp, uamp, &reg_data);
+	if (ret) {
+		dev_err(chg->dev, "Wrong value for fast charge: %u\n", uamp);
+		return ret;
+	}
+
+	return max14577_update_reg(chg->max14577->regmap,
+			MAX14577_CHG_REG_CHG_CTRL4,
+			CHGCTRL4_MBCICHWRCL_MASK | CHGCTRL4_MBCICHWRCH_MASK,
+			reg_data);
+}
+
 /*
  * Sets charger registers to proper and safe default values.
  * Some of these values are equal to defaults in MAX14577E
  * data sheet but there are minor differences.
  */
-static void max14577_charger_reg_init(struct max14577_charger *chg)
+static int max14577_charger_reg_init(struct max14577_charger *chg)
 {
 	struct regmap *rmap = chg->max14577->regmap;
 	u8 reg_data;
+	int ret;
 
 	/*
 	 * Charger-Type Manual Detection, default off (set CHGTYPMAN to 0)
@@ -198,10 +293,6 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 			CDETCTRL1_CHGDETEN_MASK | CDETCTRL1_CHGTYPMAN_MASK,
 			reg_data);
 
-	/* Battery Fast-Charge Timer, set to: 6hrs */
-	reg_data = 0x3 << CHGCTRL1_TCHW_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL1, reg_data);
-
 	/*
 	 * Wall-Adapter Rapid Charge, default on
 	 * Battery-Charger, default on
@@ -210,32 +301,57 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 	reg_data |= 0x1 << CHGCTRL2_MBCHOSTEN_SHIFT;
 	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL2, reg_data);
 
-	/* Battery-Charger Constant Voltage (CV) Mode, set to: 4.35V */
-	reg_data = 0xf << CHGCTRL3_MBCCVWRC_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL3, reg_data);
-
-	/*
-	 * Fast Battery-Charge Current Low,
-	 * default 200-950mA (max14577) / 100-475mA (max77836)
-	 *
-	 * Fast Battery-Charge Current High,
-	 * set to 450mA (max14577) / 225mA (max77836)
-	 */
-	reg_data = 0x1 << CHGCTRL4_MBCICHWRCL_SHIFT;
-	reg_data |= 0x5 << CHGCTRL4_MBCICHWRCH_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL4, reg_data);
-
-	/* End-of-Charge Current, set to 50mA (max14577) / 7.5mA (max77836) */
-	reg_data = 0x0 << CHGCTRL5_EOCS_SHIFT;
-	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL5, reg_data);
-
 	/* Auto Charging Stop, default off */
 	reg_data = 0x0 << CHGCTRL6_AUTOSTOP_SHIFT;
 	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL6, reg_data);
 
-	/* Overvoltage-Protection Threshold, set to 6.5V */
-	reg_data = 0x2 << CHGCTRL7_OTPCGHCVS_SHIFT;
+	ret = max14577_init_constant_voltage(chg, chg->pdata->constant_uvolt);
+	if (ret)
+		return ret;
+
+	ret = max14577_init_eoc(chg, chg->pdata->eoc_uamp);
+	if (ret)
+		return ret;
+
+	ret = max14577_init_fast_charge(chg, chg->pdata->fast_charge_uamp);
+	if (ret)
+		return ret;
+
+	/* Initialize Battery Fast-Charge Timer */
+	switch (chg->pdata->fast_charge_timer) {
+	case 5 ... 7:
+		reg_data = chg->pdata->fast_charge_timer - 3;
+		break;
+	case 0:
+		/* Disable */
+		reg_data = 0x7;
+	default:
+		dev_err(chg->dev, "Wrong value for Fast-Charge Timer: %u\n",
+				chg->pdata->fast_charge_timer);
+		return -EINVAL;
+	}
+	reg_data <<= CHGCTRL1_TCHW_SHIFT;
+	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL1, reg_data);
+
+	/* Initialize Overvoltage-Protection Threshold */
+	switch (chg->pdata->ovp_uvolt) {
+	case 7500000:
+		reg_data = 0x0;
+		break;
+	case 6000000:
+	case 6500000:
+	case 7000000:
+		reg_data = 0x1 + (chg->pdata->ovp_uvolt - 6000000) / 500000;
+		break;
+	default:
+		dev_err(chg->dev, "Wrong value for OVP: %u\n",
+				chg->pdata->ovp_uvolt);
+		return -EINVAL;
+	}
+	reg_data <<= CHGCTRL7_OTPCGHCVS_SHIFT;
 	max14577_write_reg(rmap, MAX14577_REG_CHGCTRL7, reg_data);
+
+	return 0;
 }
 
 /* Support property from charger */
@@ -295,6 +411,58 @@ static int max14577_charger_get_property(struct power_supply *psy,
 	return ret;
 }
 
+#ifdef CONFIG_OF
+static struct max14577_charger_platform_data *max14577_charger_dt_init(
+		struct platform_device *pdev)
+{
+	struct max14577_charger_platform_data *pdata;
+	struct device_node *np = pdev->dev.of_node;
+	int ret;
+
+	if (!np) {
+		dev_err(&pdev->dev, "No charger OF node\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		dev_err(&pdev->dev, "Memory alloc for charger pdata failed\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	ret = of_property_read_u32(np, "maxim,fast-charge-timer",
+			&pdata->fast_charge_timer);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_property_read_u32(np, "maxim,constant-uvolt",
+			&pdata->constant_uvolt);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_property_read_u32(np, "maxim,fast-charge-uamp",
+			&pdata->fast_charge_uamp);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_property_read_u32(np, "maxim,eoc-uamp", &pdata->eoc_uamp);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_property_read_u32(np, "maxim,ovp-uvolt", &pdata->ovp_uvolt);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return pdata;
+}
+#else /* CONFIG_OF */
+static struct max14577_charger_platform_data *max14577_charger_dt_init(
+		struct platform_device *pdev)
+{
+	return NULL;
+}
+#endif /* CONFIG_OF */
+
 static int max14577_charger_probe(struct platform_device *pdev)
 {
 	struct max14577_charger *chg;
@@ -309,7 +477,13 @@ static int max14577_charger_probe(struct platform_device *pdev)
 	chg->dev = &pdev->dev;
 	chg->max14577 = max14577;
 
-	max14577_charger_reg_init(chg);
+	chg->pdata = max14577_charger_dt_init(pdev);
+	if (IS_ERR_OR_NULL(chg->pdata))
+		return PTR_ERR(chg->pdata);
+
+	ret = max14577_charger_reg_init(chg);
+	if (ret)
+		return ret;
 
 	chg->charger.name = "max14577-charger",
 	chg->charger.type = POWER_SUPPLY_TYPE_BATTERY,
@@ -323,6 +497,10 @@ static int max14577_charger_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Check for valid values for charger */
+	BUILD_BUG_ON(MAX14577_CHARGER_EOC_CURRENT_LIMIT_MIN +
+			MAX14577_CHARGER_EOC_CURRENT_LIMIT_STEP * 0xf !=
+			MAX14577_CHARGER_EOC_CURRENT_LIMIT_MAX);
 	return 0;
 }
 
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 7d514839c764..5c842f3b6da5 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -293,6 +293,22 @@ enum max14577_charger_reg {
 #define MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP	 25000U
 #define MAX77836_CHARGER_CURRENT_LIMIT_MAX		475000U
 
+/*
+ * MAX14577 charger End-Of-Charge current limits
+ * (as in CHGCTRL5 register), uA
+ */
+#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_MIN		50000U
+#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_STEP		10000U
+#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_MAX		200000U
+
+/*
+ * MAX14577/MAX77836 Battery Constant Voltage
+ * (as in CHGCTRL3 register), uV
+ */
+#define MAXIM_CHARGER_CONSTANT_VOLTAGE_MIN		4000000U
+#define MAXIM_CHARGER_CONSTANT_VOLTAGE_STEP		20000U
+#define MAXIM_CHARGER_CONSTANT_VOLTAGE_MAX		4350000U
+
 /* MAX14577 regulator SFOUT LDO voltage, fixed, uV */
 #define MAX14577_REGULATOR_SAFEOUT_VOLTAGE		4900000
 
diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
index 3c098d57b1d1..d068846a13cf 100644
--- a/include/linux/mfd/max14577.h
+++ b/include/linux/mfd/max14577.h
@@ -54,6 +54,14 @@ struct max14577_regulator_platform_data {
 	struct device_node *of_node;
 };
 
+struct max14577_charger_platform_data {
+	unsigned int fast_charge_timer;
+	unsigned int constant_uvolt;
+	unsigned int fast_charge_uamp;
+	unsigned int eoc_uamp;
+	unsigned int ovp_uvolt;
+};
+
 /*
  * MAX14577 MFD platform data
  */
-- 
1.9.1

