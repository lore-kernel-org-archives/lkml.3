Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbaFDMoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 08:44:14 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:60006 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbaFDMoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 08:44:10 -0400
Message-ID: <1401885843.15873.3.camel@phoenix>
Subject: [RFT][PATCH] regulator: tps6586x: Use regulator_list_voltage_linear
 for dvm/ldo4/sw2
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Alban Bedel <alban.bedel@avionic-design.de>,
        Stefan Agner <stefan@agner.ch>, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 04 Jun 2014 20:44:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage tables for dvm/ldo4/sw2 are actually linear mapping.
Thus convert dvm/ldo4/sw2 to use regulator_list_voltage_linear.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps6586x-regulator.c | 129 +++++++++++++++++----------------
 1 file changed, 68 insertions(+), 61 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 0a3bb3a..ccbb9f1 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -74,6 +74,16 @@ static struct regulator_ops tps6586x_rw_regulator_ops = {
 	.disable = regulator_disable_regmap,
 };
 
+static struct regulator_ops tps6586x_rw_linear_regulator_ops = {
+	.list_voltage = regulator_list_voltage_linear,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+	.set_voltage_sel = regulator_set_voltage_sel_regmap,
+
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+};
+
 static struct regulator_ops tps6586x_ro_regulator_ops = {
 	.list_voltage = regulator_list_voltage_table,
 	.map_voltage = regulator_map_voltage_ascend,
@@ -91,48 +101,11 @@ static const unsigned int tps6586x_ldo0_voltages[] = {
 	1200000, 1500000, 1800000, 2500000, 2700000, 2850000, 3100000, 3300000,
 };
 
-static const unsigned int tps6586x_ldo4_voltages[] = {
-	1700000, 1725000, 1750000, 1775000, 1800000, 1825000, 1850000, 1875000,
-	1900000, 1925000, 1950000, 1975000, 2000000, 2025000, 2050000, 2075000,
-	2100000, 2125000, 2150000, 2175000, 2200000, 2225000, 2250000, 2275000,
-	2300000, 2325000, 2350000, 2375000, 2400000, 2425000, 2450000, 2475000,
-};
-
-#define tps658623_sm2_voltages tps6586x_ldo4_voltages
-
 static const unsigned int tps6586x_ldo_voltages[] = {
 	1250000, 1500000, 1800000, 2500000, 2700000, 2850000, 3100000, 3300000,
 };
 
-static const unsigned int tps6586x_sm2_voltages[] = {
-	3000000, 3050000, 3100000, 3150000, 3200000, 3250000, 3300000, 3350000,
-	3400000, 3450000, 3500000, 3550000, 3600000, 3650000, 3700000, 3750000,
-	3800000, 3850000, 3900000, 3950000, 4000000, 4050000, 4100000, 4150000,
-	4200000, 4250000, 4300000, 4350000, 4400000, 4450000, 4500000, 4550000,
-};
-
-static int tps658640_sm2_voltages[] = {
-	2150000, 2200000, 2250000, 2300000, 2350000, 2400000, 2450000, 2500000,
-	2550000, 2600000, 2650000, 2700000, 2750000, 2800000, 2850000, 2900000,
-	2950000, 3000000, 3050000, 3100000, 3150000, 3200000, 3250000, 3300000,
-	3350000, 3400000, 3450000, 3500000, 3550000, 3600000, 3650000, 3700000,
-};
-
-static const unsigned int tps658643_sm2_voltages[] = {
-	1025000, 1050000, 1075000, 1100000, 1125000, 1150000, 1175000, 1200000,
-	1225000, 1250000, 1275000, 1300000, 1325000, 1350000, 1375000, 1400000,
-	1425000, 1450000, 1475000, 1500000, 1525000, 1550000, 1575000, 1600000,
-	1625000, 1650000, 1675000, 1700000, 1725000, 1750000, 1775000, 1800000,
-};
-
-static const unsigned int tps6586x_dvm_voltages[] = {
-	 725000,  750000,  775000,  800000,  825000,  850000,  875000,  900000,
-	 925000,  950000,  975000, 1000000, 1025000, 1050000, 1075000, 1100000,
-	1125000, 1150000, 1175000, 1200000, 1225000, 1250000, 1275000, 1300000,
-	1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000, 1500000,
-};
-
-static int tps658640_rtc_voltages[] = {
+static const unsigned int tps658640_rtc_voltages[] = {
 	2500000, 2850000, 3100000, 3300000,
 };
 
@@ -159,6 +132,31 @@ static int tps658640_rtc_voltages[] = {
 	.enable_reg[1]	= TPS6586X_SUPPLY##ereg1,			\
 	.enable_bit[1]	= (ebit1),
 
+#define TPS6586X_REGULATOR_LINEAR(_id, _ops, _pin_name, n_volt, min_uv,	\
+				  uv_step, vreg, shift, nbits, ereg0,	\
+				  ebit0, ereg1, ebit1, goreg, gobit)	\
+	.desc	= {							\
+		.supply_name = _pin_name,				\
+		.name	= "REG-" #_id,					\
+		.ops	= &tps6586x_## _ops ## _regulator_ops,		\
+		.type	= REGULATOR_VOLTAGE,				\
+		.id	= TPS6586X_ID_##_id,				\
+		.n_voltages = n_volt,					\
+		.min_uV = min_uv,					\
+		.uV_step = uv_step,					\
+		.owner	= THIS_MODULE,					\
+		.enable_reg = TPS6586X_SUPPLY##ereg0,			\
+		.enable_mask = 1 << (ebit0),				\
+		.vsel_reg = TPS6586X_##vreg,				\
+		.vsel_mask = ((1 << (nbits)) - 1) << (shift),		\
+		.apply_reg = (goreg),				\
+		.apply_bit = (gobit),				\
+	},								\
+	.enable_reg[0]	= TPS6586X_SUPPLY##ereg0,			\
+	.enable_bit[0]	= (ebit0),					\
+	.enable_reg[1]	= TPS6586X_SUPPLY##ereg1,			\
+	.enable_bit[1]	= (ebit1),
+
 #define TPS6586X_LDO(_id, _pname, vdata, vreg, shift, nbits,		\
 		     ereg0, ebit0, ereg1, ebit1)			\
 {									\
@@ -166,6 +164,14 @@ static int tps658640_rtc_voltages[] = {
 			   ereg0, ebit0, ereg1, ebit1, 0, 0)		\
 }
 
+#define TPS6586X_LDO_LINEAR(_id, _pname, n_volt, min_uv, uv_step, vreg,	\
+			    shift, nbits, ereg0, ebit0, ereg1, ebit1)	\
+{									\
+	TPS6586X_REGULATOR_LINEAR(_id, rw_linear, _pname, n_volt,	\
+				  min_uv, uv_step, vreg, shift, nbits,	\
+				  ereg0, ebit0, ereg1, ebit1, 0, 0)	\
+}
+
 #define TPS6586X_FIXED_LDO(_id, _pname, vdata, vreg, shift, nbits,	\
 			  ereg0, ebit0, ereg1, ebit1)			\
 {									\
@@ -173,11 +179,13 @@ static int tps658640_rtc_voltages[] = {
 			   ereg0, ebit0, ereg1, ebit1, 0, 0)		\
 }
 
-#define TPS6586X_DVM(_id, _pname, vdata, vreg, shift, nbits,		\
-		     ereg0, ebit0, ereg1, ebit1, goreg, gobit)		\
+#define TPS6586X_DVM(_id, _pname, n_volt, min_uv, uv_step, vreg, shift,	\
+		     nbits, ereg0, ebit0, ereg1, ebit1, goreg, gobit)	\
 {									\
-	TPS6586X_REGULATOR(_id, rw, _pname, vdata, vreg, shift, nbits,	\
-			   ereg0, ebit0, ereg1, ebit1, goreg, gobit)	\
+	TPS6586X_REGULATOR_LINEAR(_id, rw_linear, _pname, n_volt,	\
+				  min_uv, uv_step, vreg, shift, nbits,	\
+				  ereg0, ebit0, ereg1, ebit1, goreg,	\
+				  gobit)				\
 }
 
 #define TPS6586X_SYS_REGULATOR()					\
@@ -210,24 +218,23 @@ static struct tps6586x_regulator tps6586x_regulator[] = {
 					ENE, 7),
 	TPS6586X_LDO(LDO_RTC, "REG-SYS", tps6586x_ldo, SUPPLYV4, 3, 3, V4, 7,
 					V4, 7),
-	TPS6586X_LDO(LDO_1, "vinldo01", tps6586x_dvm, SUPPLYV1, 0, 5, ENC, 1,
-					END, 1),
-	TPS6586X_LDO(SM_2, "vin-sm2", tps6586x_sm2, SUPPLYV2, 0, 5, ENC, 7,
-					END, 7),
-
-	TPS6586X_DVM(LDO_2, "vinldo23", tps6586x_dvm, LDO2BV1, 0, 5, ENA, 3,
-					ENB, 3, TPS6586X_VCC2, BIT(6)),
-	TPS6586X_DVM(LDO_4, "vinldo4", tps6586x_ldo4, LDO4V1, 0, 5, ENC, 3,
-					END, 3, TPS6586X_VCC1, BIT(6)),
-	TPS6586X_DVM(SM_0, "vin-sm0", tps6586x_dvm, SM0V1, 0, 5, ENA, 1,
-					ENB, 1, TPS6586X_VCC1, BIT(2)),
-	TPS6586X_DVM(SM_1, "vin-sm1", tps6586x_dvm, SM1V1, 0, 5, ENA, 0,
-					ENB, 0, TPS6586X_VCC1, BIT(0)),
+	TPS6586X_LDO_LINEAR(LDO_1, "vinldo01", 32, 725000, 25000, SUPPLYV1,
+			    0, 5, ENC, 1, END, 1),
+	TPS6586X_LDO_LINEAR(SM_2, "vin-sm2", 32, 3000000, 50000, SUPPLYV2,
+			    0, 5, ENC, 7, END, 7),
+	TPS6586X_DVM(LDO_2, "vinldo23", 32, 725000, 25000, LDO2BV1, 0, 5,
+		     ENA, 3, ENB, 3, TPS6586X_VCC2, BIT(6)),
+	TPS6586X_DVM(LDO_4, "vinldo4", 32, 1700000, 25000, LDO4V1, 0, 5,
+		     ENC, 3, END, 3, TPS6586X_VCC1, BIT(6)),
+	TPS6586X_DVM(SM_0, "vin-sm0", 32, 725000, 25000, SM0V1, 0, 5,
+		     ENA, 1, ENB, 1, TPS6586X_VCC1, BIT(2)),
+	TPS6586X_DVM(SM_1, "vin-sm1", 32, 725000, 25000, SM1V1, 0, 5,
+		     ENA, 0, ENB, 0, TPS6586X_VCC1, BIT(0)),
 };
 
 static struct tps6586x_regulator tps658623_regulator[] = {
-	TPS6586X_LDO(SM_2, "vin-sm2", tps658623_sm2, SUPPLYV2, 0, 5, ENC, 7,
-					END, 7),
+	TPS6586X_LDO_LINEAR(SM_2, "vin-sm2", 32, 1700000, 25000, SUPPLYV2,
+			    0, 5, ENC, 7, END, 7),
 };
 
 static struct tps6586x_regulator tps658640_regulator[] = {
@@ -243,16 +250,16 @@ static struct tps6586x_regulator tps658640_regulator[] = {
 					ENC, 6, END, 6),
 	TPS6586X_LDO(LDO_9, "vinldo9", tps6586x_ldo0, SUPPLYV6, 3, 3,
 					ENE, 7, ENE, 7),
-	TPS6586X_LDO(SM_2, "vin-sm2", tps658640_sm2, SUPPLYV2, 0, 5,
-					ENC, 7, END, 7),
+	TPS6586X_LDO_LINEAR(SM_2, "vin-sm2", 32, 2150000, 50000, SUPPLYV2,
+			    0, 5, ENC, 7, END, 7),
 
 	TPS6586X_FIXED_LDO(LDO_RTC, "REG-SYS", tps658640_rtc, SUPPLYV4, 3, 2,
 					V4, 7, V4, 7),
 };
 
 static struct tps6586x_regulator tps658643_regulator[] = {
-	TPS6586X_LDO(SM_2, "vin-sm2", tps658643_sm2, SUPPLYV2, 0, 5, ENC, 7,
-					END, 7),
+	TPS6586X_LDO_LINEAR(SM_2, "vin-sm2", 32, 1025000, 25000, SUPPLYV2,
+			    0, 5, ENC, 7, END, 7),
 };
 
 /*
-- 
1.8.3.2



