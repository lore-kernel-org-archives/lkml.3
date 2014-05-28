Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbaE1RM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:12:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46285 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752573AbaE1RL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:11:28 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        lee.jones@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 3/5] regulator: axp20x: Update the bindings to use a local parent regulator
Date: Wed, 28 May 2014 19:11:07 +0200
Message-Id: <1401297069-7423-4-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the regulator core is now able to handle parent regulators that are tied
to the regulator nodes themselves instead of the parent device in the DT,
update the bindings and the regulator code to use a vin-supply property for
each regulator.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 Documentation/devicetree/bindings/mfd/axp20x.txt | 22 +++++--------
 drivers/regulator/axp20x-regulator.c             | 42 ++++++++++++++----------
 2 files changed, 34 insertions(+), 30 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/axp20x.txt b/Documentation/devicetree/bindings/mfd/axp20x.txt
index cc9e01b32715..b21164f882ef 100644
--- a/Documentation/devicetree/bindings/mfd/axp20x.txt
+++ b/Documentation/devicetree/bindings/mfd/axp20x.txt
@@ -11,12 +11,6 @@ Required properties:
 - interrupts: Interrupt specifiers for interrupt sources
 - interrupt-controller: axp20x has its own internal IRQs
 - #interrupt-cells: Should be set to 1
-- acin-supply: The input supply for LDO1
-- vin2-supply: The input supply for DCDC2
-- vin3-supply: The input supply for DCDC3
-- ldo24in-supply: The input supply for LDO2, LDO4
-- ldo3in-supply: The input supply for LDO3
-- ldo5in-supply: The input supply for LDO5
 
 - regulators: A node that houses a sub-node for each regulator. The regulators are
 	      bound using their name as listed here: dcdc2, dcdc3, ldo1, ldo2,
@@ -24,6 +18,8 @@ Required properties:
 	      device can be found in:
 	      Documentation/devicetree/bindings/regulator/regulator.txt with
 	      the exception of x-powers,dcdc-freq
+	      Parent regulators must be set in the vin-supply property
+
 - x-powers,dcdc-freq: defines the work frequency of DC-DC in KHz
 		      (range: 750-1875). Default: 1.5MHz
 
@@ -42,49 +38,49 @@ axp209: pmic@34 {
 	interrupt-controller;
 	#interrupt-cells = <1>;
 
-	acin-supply = <&axp_ipsout_reg>;
-	vin2-supply = <&axp_ipsout_reg>;
-	vin3-supply = <&axp_ipsout_reg>;
-	ldo24in-supply = <&axp_ipsout_reg>;
-	ldo3in-supply = <&axp_ipsout_reg>;
-	ldo5in-supply = <&axp_ipsout_reg>;
-
 	regulators {
 		x-powers,dcdc-freq = <1500>;
 
 		axp_vcore_reg: dcdc2 {
+			vin-supply = <&axp_ipsout_reg>;
 			regulator-min-microvolt = <700000>;
 			regulator-max-microvolt = <2275000>;
 			regulator-always-on;
 		};
 
 		axp_ddr_reg: dcdc3 {
+			vin-supply = <&axp_ipsout_reg>;
 			regulator-min-microvolt = <700000>;
 			regulator-max-microvolt = <3500000>;
 			regulator-always-on;
 		};
 
 		axp_rtc_reg: ldo1 {
+			vin-supply = <&axp_ipsout_reg>;
 			regulator-always-on;
 		};
 
 		axp_analog_reg: ldo2 {
+			vin-supply = <&axp_ipsout_reg>;
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <3300000>;
 			regulator-always-on;
 		};
 
 		axp_pll_reg: ldo3 {
+			vin-supply = <&axp_ipsout_reg>;
 			regulator-min-microvolt = <700000>;
 			regulator-max-microvolt = <3500000>;
 		};
 
 		axp_hdmi_reg: ldo4 {
+			vin-supply = <&axp_ipsout_reg>;
 			regulator-min-microvolt = <1250000>;
 			regulator-max-microvolt = <3300000>;
 		};
 
 		axp_mic_reg: ldo5 {
+			vin-supply = <&axp_ipsout_reg>;
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <3300000>;
 		};
diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index 78a29e60f53a..0a260df50314 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -22,6 +22,7 @@
 #include <linux/regmap.h>
 #include <linux/mfd/axp20x.h>
 #include <linux/regulator/driver.h>
+#include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
 
 #define AXP20X_IO_ENABLED		0x03
@@ -32,11 +33,10 @@
 
 #define AXP20X_FREQ_DCDC_MASK		0x0f
 
-#define AXP20X_DESC_IO(_id, _supply, _min, _max, _step, _vreg, _vmask, _ereg,   \
+#define AXP20X_DESC_IO(_id, _min, _max, _step, _vreg, _vmask, _ereg,		\
 		       _emask, _enable_val, _disable_val)			\
 	[AXP20X_##_id] = {							\
 		.name		= #_id,						\
-		.supply_name	= (_supply),					\
 		.type		= REGULATOR_VOLTAGE,				\
 		.id		= AXP20X_##_id,					\
 		.n_voltages	= (((_max) - (_min)) / (_step) + 1),		\
@@ -52,11 +52,9 @@
 		.ops		= &axp20x_ops,					\
 	}
 
-#define AXP20X_DESC(_id, _supply, _min, _max, _step, _vreg, _vmask, _ereg,	\
-		    _emask) 							\
+#define AXP20X_DESC(_id, _min, _max, _step, _vreg, _vmask, _ereg, _emask)	\
 	[AXP20X_##_id] = {							\
 		.name		= #_id,						\
-		.supply_name	= (_supply),					\
 		.type		= REGULATOR_VOLTAGE,				\
 		.id		= AXP20X_##_id,					\
 		.n_voltages	= (((_max) - (_min)) / (_step) + 1),		\
@@ -70,10 +68,9 @@
 		.ops		= &axp20x_ops,					\
 	}
 
-#define AXP20X_DESC_FIXED(_id, _supply, _volt)					\
+#define AXP20X_DESC_FIXED(_id, _volt)						\
 	[AXP20X_##_id] = {							\
 		.name		= #_id,						\
-		.supply_name	= (_supply),					\
 		.type		= REGULATOR_VOLTAGE,				\
 		.id		= AXP20X_##_id,					\
 		.n_voltages	= 1,						\
@@ -82,10 +79,9 @@
 		.ops		= &axp20x_ops_fixed				\
 	}
 
-#define AXP20X_DESC_TABLE(_id, _supply, _table, _vreg, _vmask, _ereg, _emask)	\
+#define AXP20X_DESC_TABLE(_id, _table, _vreg, _vmask, _ereg, _emask)		\
 	[AXP20X_##_id] = {							\
 		.name		= #_id,						\
-		.supply_name	= (_supply),					\
 		.type		= REGULATOR_VOLTAGE,				\
 		.id		= AXP20X_##_id,					\
 		.n_voltages	= ARRAY_SIZE(_table),				\
@@ -126,18 +122,18 @@ static struct regulator_ops axp20x_ops = {
 };
 
 static const struct regulator_desc axp20x_regulators[] = {
-	AXP20X_DESC(DCDC2, "vin2", 700, 2275, 25, AXP20X_DCDC2_V_OUT, 0x3f,
+	AXP20X_DESC(DCDC2, 700, 2275, 25, AXP20X_DCDC2_V_OUT, 0x3f,
 		    AXP20X_PWR_OUT_CTRL, 0x10),
-	AXP20X_DESC(DCDC3, "vin3", 700, 3500, 25, AXP20X_DCDC3_V_OUT, 0x7f,
+	AXP20X_DESC(DCDC3, 700, 3500, 25, AXP20X_DCDC3_V_OUT, 0x7f,
 		    AXP20X_PWR_OUT_CTRL, 0x02),
-	AXP20X_DESC_FIXED(LDO1, "acin", 1300),
-	AXP20X_DESC(LDO2, "ldo24in", 1800, 3300, 100, AXP20X_LDO24_V_OUT, 0xf0,
+	AXP20X_DESC_FIXED(LDO1, 1300),
+	AXP20X_DESC(LDO2, 1800, 3300, 100, AXP20X_LDO24_V_OUT, 0xf0,
 		    AXP20X_PWR_OUT_CTRL, 0x04),
-	AXP20X_DESC(LDO3, "ldo3in", 700, 3500, 25, AXP20X_LDO3_V_OUT, 0x7f,
+	AXP20X_DESC(LDO3, 700, 3500, 25, AXP20X_LDO3_V_OUT, 0x7f,
 		    AXP20X_PWR_OUT_CTRL, 0x40),
-	AXP20X_DESC_TABLE(LDO4, "ldo24in", axp20x_ldo4_data, AXP20X_LDO24_V_OUT, 0x0f,
+	AXP20X_DESC_TABLE(LDO4, axp20x_ldo4_data, AXP20X_LDO24_V_OUT, 0x0f,
 			  AXP20X_PWR_OUT_CTRL, 0x08),
-	AXP20X_DESC_IO(LDO5, "ldo5in", 1800, 3300, 100, AXP20X_LDO5_V_OUT, 0xf0,
+	AXP20X_DESC_IO(LDO5, 1800, 3300, 100, AXP20X_LDO5_V_OUT, 0xf0,
 		       AXP20X_GPIO0_CTRL, 0x07, AXP20X_IO_ENABLED,
 		       AXP20X_IO_DISABLED),
 };
@@ -181,7 +177,8 @@ static int axp20x_set_dcdc_freq(struct platform_device *pdev, u32 dcdcfreq)
 static int axp20x_regulator_parse_dt(struct platform_device *pdev)
 {
 	struct device_node *np, *regulators;
-	int ret;
+	struct device_node *child;
+	int ret, i;
 	u32 dcdcfreq;
 
 	np = of_node_get(pdev->dev.parent->of_node);
@@ -207,6 +204,17 @@ static int axp20x_regulator_parse_dt(struct platform_device *pdev)
 			return ret;
 		}
 
+		for_each_child_of_node(regulators, child) {
+			for (i = 0; i < ARRAY_SIZE(axp20x_matches); i++) {
+				struct of_regulator_match *match = &axp20x_matches[i];
+				if (!match->of_node)
+					continue;
+
+				if (of_get_property(child, "vin-supply", NULL))
+					match->init_data->supply_regulator = "vin";
+			}
+		}
+
 		of_node_put(regulators);
 	}
 
-- 
1.9.3

