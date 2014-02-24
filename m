Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaBXKLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:11:34 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64032 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbaBXKLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:11:24 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-fd-530b1ac969f5
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
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Jenny Tc <jenny.tc@intel.com>
Subject: [PATCH v4 14/16] charger: max14577: Configure battery-dependent
 settings from DTS
Date: Mon, 24 Feb 2014 11:10:39 +0100
Message-id: <1393236641-14977-15-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
References: <1393236641-14977-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsVy+t/xy7onpbiDDVbPtrbYOGM9q8XUh0/Y
	LK5/ec5qMenJe2aLiSsnM1us/drDbvH6haHF2aY37Bb3vx5ltNj0+BqrxeVdc9gs1h65y25x
	upvVYv2M1ywOfB47Z91l99i8Qstj8Z6XTB6bVnWyedy5tofNY97JQI/NS+o9+rasYvT4vEku
	gDOKyyYlNSezLLVI3y6BK2P3wsssBYsTK27PWMLewHg2oIuRk0NCwESi92orM4QtJnHh3nq2
	LkYuDiGBpYwSH9deY4Jw+pgkunbfYwOpYhMwlti8fAlYlYjAFiaJ3g9fGEESzAJtTBKLPpmD
	2MICMRJL7i9nAbFZBFQlPv2fDFTDwcEr4CEx40IRiCkhoCAxZ5INSAUnUPRuywNWEFtIwF3i
	27zrLBMYeRcwMqxiFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAncrzsYlx6zOsQowMGoxMMr
	Uc0VLMSaWFZcmXuIUYKDWUmE14yXO1iINyWxsiq1KD++qDQntfgQIxMHp1QDY6TnEhdTT1Wu
	+mX7OyqibbY3M135mpUrlWf8yu9AeIxlwLJD6dfZeQKrKiOmFX5p3Gq+3Hj9dzGfA0prbiYn
	x0SdXnmu2ae9WfgUw8YbV5t2e0UVCnImmy7/9PfWIo4bt5h5m1LlNteckJVNEpQo4Xj90ic1
	/VyOkVx3+u1Hx/ymd93a1ntViaU4I9FQi7moOBEAApLEezoCAAA=
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
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jenny Tc <jenny.tc@intel.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max14577.c               |    5 +-
 drivers/power/max14577_charger.c     |  235 +++++++++++++++++++++++++++++-----
 include/linux/mfd/max14577-private.h |   16 +++
 include/linux/mfd/max14577.h         |    8 ++
 4 files changed, 234 insertions(+), 30 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 03fde3e5d1fb..1017d562b09d 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -115,7 +115,10 @@ static struct mfd_cell max14577_devs[] = {
 		.name = "max14577-regulator",
 		.of_compatible = "maxim,max14577-regulator",
 	},
-	{ .name = "max14577-charger", },
+	{
+		.name = "max14577-charger",
+		.of_compatible = "maxim,max14577-charger",
+	},
 };
 
 static struct mfd_cell max77836_devs[] = {
diff --git a/drivers/power/max14577_charger.c b/drivers/power/max14577_charger.c
index 405f4d736337..bdad6d42f33e 100644
--- a/drivers/power/max14577_charger.c
+++ b/drivers/power/max14577_charger.c
@@ -19,6 +19,7 @@
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
 #include <linux/mfd/max14577-private.h>
+#include <linux/mfd/max14577.h>
 
 struct max14577_charger {
 	struct device		*dev;
@@ -27,6 +28,8 @@ struct max14577_charger {
 
 	unsigned int		charging_state;
 	unsigned int		battery_state;
+
+	struct max14577_charger_platform_data	*pdata;
 };
 
 /*
@@ -180,15 +183,107 @@ static int max14577_get_present(struct max14577_charger *chg)
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
+	reg_data <<= MAXIM_CHGCTRL3_MBCCVWRC_SHIFT;
+
+	return max14577_write_reg(chg->maxim_core->regmap_muic,
+			MAXIM_CHG_REG_CHGCTRL3, reg_data);
+}
+
+static inline int max14577_init_eoc(struct max14577_charger *chg,
+		unsigned int uamp)
+{
+	unsigned int current_bits = 0xf;
+	u8 reg_data;
+
+	switch (chg->maxim_core->dev_type) {
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
+	reg_data = current_bits << MAXIM_CHGCTRL5_EOCS_SHIFT;
+
+	return max14577_update_reg(chg->maxim_core->regmap_muic,
+			MAXIM_CHG_REG_CHGCTRL5, MAXIM_CHGCTRL5_EOCS_MASK,
+			reg_data);
+}
+
+static inline int max14577_init_fast_charge(struct max14577_charger *chg,
+		unsigned int uamp)
+{
+	u8 reg_data;
+	int ret;
+	const struct maxim_charger_current *limits =
+		&maxim_charger_currents[chg->maxim_core->dev_type];
+
+	ret = maxim_charger_calc_reg_current(limits, uamp, uamp, &reg_data);
+	if (ret) {
+		dev_err(chg->dev, "Wrong value for fast charge: %u\n", uamp);
+		return ret;
+	}
+
+	return max14577_update_reg(chg->maxim_core->regmap_muic,
+			MAXIM_CHG_REG_CHGCTRL4,
+			MAXIM_CHGCTRL4_MBCICHWRCL_MASK | MAXIM_CHGCTRL4_MBCICHWRCH_MASK,
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
 	struct regmap *rmap = chg->maxim_core->regmap_muic;
 	u8 reg_data;
+	int ret;
 
 	/*
 	 * Charger-Type Manual Detection, default off (set CHGTYPMAN to 0)
@@ -198,12 +293,7 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 	reg_data = 0x1 << MAXIM_CDETCTRL1_CHGDETEN_SHIFT;
 	max14577_update_reg(rmap, MAXIM_MUIC_REG_CDETCTRL1,
 			MAXIM_CDETCTRL1_CHGDETEN_MASK |
-				MAXIM_CDETCTRL1_CHGTYPMAN_MASK,
-			reg_data);
-
-	/* Battery Fast-Charge Timer, set to: 6hrs */
-	reg_data = 0x3 << MAXIM_CHGCTRL1_TCHW_SHIFT;
-	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL1, reg_data);
+				MAXIM_CDETCTRL1_CHGTYPMAN_MASK, reg_data);
 
 	/*
 	 * Wall-Adapter Rapid Charge, default on
@@ -213,32 +303,57 @@ static void max14577_charger_reg_init(struct max14577_charger *chg)
 	reg_data |= 0x1 << MAXIM_CHGCTRL2_MBCHOSTEN_SHIFT;
 	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL2, reg_data);
 
-	/* Battery-Charger Constant Voltage (CV) Mode, set to: 4.35V */
-	reg_data = 0xf << MAXIM_CHGCTRL3_MBCCVWRC_SHIFT;
-	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL3, reg_data);
-
-	/*
-	 * Fast Battery-Charge Current Low,
-	 * default 200-950mA (max14577) / 100-475mA (max77836)
-	 *
-	 * Fast Battery-Charge Current High,
-	 * set to 450mA (max14577) / 225mA (max77836)
-	 */
-	reg_data = 0x1 << MAXIM_CHGCTRL4_MBCICHWRCL_SHIFT;
-	reg_data |= 0x5 << MAXIM_CHGCTRL4_MBCICHWRCH_SHIFT;
-	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL4, reg_data);
-
-	/* End-of-Charge Current, set to 50mA (max14577) / 7.5mA (max77836) */
-	reg_data = 0x0 << MAXIM_CHGCTRL5_EOCS_SHIFT;
-	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL5, reg_data);
-
 	/* Auto Charging Stop, default off */
 	reg_data = 0x0 << MAXIM_CHGCTRL6_AUTOSTOP_SHIFT;
 	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL6, reg_data);
 
-	/* Overvoltage-Protection Threshold, set to 6.5V */
-	reg_data = 0x2 << MAXIM_CHGCTRL7_OTPCGHCVS_SHIFT;
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
+	reg_data <<= MAXIM_CHGCTRL1_TCHW_SHIFT;
+	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL1, reg_data);
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
+	reg_data <<= MAXIM_CHGCTRL7_OTPCGHCVS_SHIFT;
 	max14577_write_reg(rmap, MAXIM_CHG_REG_CHGCTRL7, reg_data);
+
+	return 0;
 }
 
 /* Support property from charger */
@@ -298,6 +413,58 @@ static int max14577_charger_get_property(struct power_supply *psy,
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
@@ -312,7 +479,13 @@ static int max14577_charger_probe(struct platform_device *pdev)
 	chg->dev = &pdev->dev;
 	chg->maxim_core = maxim_core;
 
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
@@ -326,6 +499,10 @@ static int max14577_charger_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Check for valid values for charger */
+	BUILD_BUG_ON(MAX14577_CHARGER_EOC_CURRENT_LIMIT_MIN +
+			MAX14577_CHARGER_EOC_CURRENT_LIMIT_STEP * 0xf !=
+			MAX14577_CHARGER_EOC_CURRENT_LIMIT_MAX);
 	return 0;
 }
 
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index a8cd7de3526a..33700662fbb4 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -269,6 +269,22 @@ enum maxim_muic_charger_type {
 #define MAX77836_CHARGER_CURRENT_LIMIT_HIGH_STEP	 25000U
 #define MAX77836_CHARGER_CURRENT_LIMIT_MAX		475000U
 
+/*
+ * MAX14577 charger End-Of-Charge current limits
+ * (as in MAXIM_CHGCTRL5 register), uA
+ */
+#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_MIN		50000U
+#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_STEP		10000U
+#define MAX14577_CHARGER_EOC_CURRENT_LIMIT_MAX		200000U
+
+/*
+ * MAX14577/MAX77836 Battery Constant Voltage
+ * (as in MAXIM_CHGCTRL3 register), uV
+ */
+#define MAXIM_CHARGER_CONSTANT_VOLTAGE_MIN		4000000U
+#define MAXIM_CHARGER_CONSTANT_VOLTAGE_STEP		20000U
+#define MAXIM_CHARGER_CONSTANT_VOLTAGE_MAX		4350000U
+
 /* MAX14577 regulator SFOUT LDO voltage, fixed, uV */
 #define MAX14577_REGULATOR_SAFEOUT_VOLTAGE		4900000
 
diff --git a/include/linux/mfd/max14577.h b/include/linux/mfd/max14577.h
index 0df2fe329b83..b60febd6c53f 100644
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
1.7.9.5

