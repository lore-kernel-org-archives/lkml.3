Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383Ab3KZX4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:56:04 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:40336 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3KZXzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:55:05 -0500
From: Stefan Agner <stefan@agner.ch>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, sameo@linux.intel.com,
        dev@lynxeye.de
Cc: mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH 2/3] regulator: tps6586x: add voltage table for tps658643
Date: Wed, 27 Nov 2013 00:45:44 +0100
Message-Id: <8be2fe8560cc19f03d5be40ad3dc21d5979c8358.1385508112.git.stefan@agner.ch>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1385508112.git.stefan@agner.ch>
References: <cover.1385508112.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on version, the voltage table might be different. Add version
compatibility to the regulator information in order to select correct
voltage table.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/regulator/tps6586x-regulator.c | 97 ++++++++++++++++++++++------------
 1 file changed, 64 insertions(+), 33 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index e8e3a8a..4fe844c 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -57,6 +57,8 @@
 #define TPS6586X_SMODE2		0x48
 
 struct tps6586x_regulator {
+	enum tps6586x_version version;
+
 	struct regulator_desc desc;
 
 	int enable_bit[2];
@@ -86,7 +88,7 @@ static const unsigned int tps6586x_ldo0_voltages[] = {
 	1200000, 1500000, 1800000, 2500000, 2700000, 2850000, 3100000, 3300000,
 };
 
-static const unsigned int tps6586x_ldo4_voltages[] = {
+static const unsigned int tps6586x_ldo4_sm2_voltages[] = {
 	1700000, 1725000, 1750000, 1775000, 1800000, 1825000, 1850000, 1875000,
 	1900000, 1925000, 1950000, 1975000, 2000000, 2025000, 2050000, 2075000,
 	2100000, 2125000, 2150000, 2175000, 2200000, 2225000, 2250000, 2275000,
@@ -104,6 +106,13 @@ static const unsigned int tps6586x_sm2_voltages[] = {
 	4200000, 4250000, 4300000, 4350000, 4400000, 4450000, 4500000, 4550000,
 };
 
+static const unsigned int tps658643_sm2_voltages[] = {
+	1025000, 1050000, 1075000, 1100000, 1125000, 1150000, 1175000, 1200000,
+	1225000, 1250000, 1275000, 1300000, 1325000, 1350000, 1375000, 1400000,
+	1425000, 1450000, 1475000, 1500000, 1525000, 1550000, 1575000, 1600000,
+	1625000, 1650000, 1675000, 1700000, 1725000, 1750000, 1775000, 1800000,
+};
+
 static const unsigned int tps6586x_dvm_voltages[] = {
 	 725000,  750000,  775000,  800000,  825000,  850000,  875000,  900000,
 	 925000,  950000,  975000, 1000000, 1025000, 1050000, 1075000, 1100000,
@@ -111,16 +120,16 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 	1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000, 1500000,
 };
 
-#define TPS6586X_REGULATOR(_id, _pin_name, vdata, vreg, shift, nbits,	\
-			   ereg0, ebit0, ereg1, ebit1, goreg, gobit)	\
+#define TPS6586X_REG(_ver, _id, _pin_name, vdata, vreg, shift,	nbits,	\
+		     ereg0, ebit0, ereg1, ebit1, goreg, gobit)		\
 	.desc	= {							\
 		.supply_name = _pin_name,				\
 		.name	= "REG-" #_id,					\
 		.ops	= &tps6586x_regulator_ops,			\
 		.type	= REGULATOR_VOLTAGE,				\
 		.id	= TPS6586X_ID_##_id,				\
-		.n_voltages = ARRAY_SIZE(tps6586x_##vdata##_voltages),	\
-		.volt_table = tps6586x_##vdata##_voltages,		\
+		.n_voltages = ARRAY_SIZE(vdata##_voltages),		\
+		.volt_table = vdata##_voltages,				\
 		.owner	= THIS_MODULE,					\
 		.enable_reg = TPS6586X_SUPPLY##ereg0,			\
 		.enable_mask = 1 << (ebit0),				\
@@ -129,23 +138,24 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 		.apply_reg = (goreg),				\
 		.apply_bit = (gobit),				\
 	},								\
+	.version	= _ver,						\
 	.enable_reg[0]	= TPS6586X_SUPPLY##ereg0,			\
 	.enable_bit[0]	= (ebit0),					\
 	.enable_reg[1]	= TPS6586X_SUPPLY##ereg1,			\
 	.enable_bit[1]	= (ebit1),
 
-#define TPS6586X_LDO(_id, _pname, vdata, vreg, shift, nbits,		\
+#define TPS6586X_LDO(_ver, _id, _pname, vdata, vreg, shift, nbits,	\
 		     ereg0, ebit0, ereg1, ebit1)			\
 {									\
-	TPS6586X_REGULATOR(_id, _pname, vdata, vreg, shift, nbits,	\
-			   ereg0, ebit0, ereg1, ebit1, 0, 0)		\
+	TPS6586X_REG(_ver, _id, _pname, vdata, vreg, shift, nbits,	\
+		     ereg0, ebit0, ereg1, ebit1, 0, 0)	\
 }
 
-#define TPS6586X_DVM(_id, _pname, vdata, vreg, shift, nbits,		\
+#define TPS6586X_DVM(_ver, _id, _pname, vdata, vreg, shift, nbits,	\
 		     ereg0, ebit0, ereg1, ebit1, goreg, gobit)		\
 {									\
-	TPS6586X_REGULATOR(_id, _pname, vdata, vreg, shift, nbits,	\
-			   ereg0, ebit0, ereg1, ebit1, goreg, gobit)	\
+	TPS6586X_REG(_ver, _id, _pname, vdata, vreg, shift, nbits,	\
+		     ereg0, ebit0, ereg1, ebit1, goreg, gobit)		\
 }
 
 #define TPS6586X_SYS_REGULATOR()					\
@@ -158,29 +168,45 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 		.id	= TPS6586X_ID_SYS,				\
 		.owner	= THIS_MODULE,					\
 	},								\
+	.version	= TPS6586X_ANY,					\
 }
 
+/* Add version specific entries before any */
 static struct tps6586x_regulator tps6586x_regulator[] = {
 	TPS6586X_SYS_REGULATOR(),
-	TPS6586X_LDO(LDO_0, "vinldo01", ldo0, SUPPLYV1, 5, 3, ENC, 0, END, 0),
-	TPS6586X_LDO(LDO_3, "vinldo23", ldo, SUPPLYV4, 0, 3, ENC, 2, END, 2),
-	TPS6586X_LDO(LDO_5, "REG-SYS", ldo, SUPPLYV6, 0, 3, ENE, 6, ENE, 6),
-	TPS6586X_LDO(LDO_6, "vinldo678", ldo, SUPPLYV3, 0, 3, ENC, 4, END, 4),
-	TPS6586X_LDO(LDO_7, "vinldo678", ldo, SUPPLYV3, 3, 3, ENC, 5, END, 5),
-	TPS6586X_LDO(LDO_8, "vinldo678", ldo, SUPPLYV2, 5, 3, ENC, 6, END, 6),
-	TPS6586X_LDO(LDO_9, "vinldo9", ldo, SUPPLYV6, 3, 3, ENE, 7, ENE, 7),
-	TPS6586X_LDO(LDO_RTC, "REG-SYS", ldo, SUPPLYV4, 3, 3, V4, 7, V4, 7),
-	TPS6586X_LDO(LDO_1, "vinldo01", dvm, SUPPLYV1, 0, 5, ENC, 1, END, 1),
-	TPS6586X_LDO(SM_2, "vin-sm2", sm2, SUPPLYV2, 0, 5, ENC, 7, END, 7),
-
-	TPS6586X_DVM(LDO_2, "vinldo23", dvm, LDO2BV1, 0, 5, ENA, 3,
-					ENB, 3, TPS6586X_VCC2, BIT(6)),
-	TPS6586X_DVM(LDO_4, "vinldo4", ldo4, LDO4V1, 0, 5, ENC, 3,
-					END, 3, TPS6586X_VCC1, BIT(6)),
-	TPS6586X_DVM(SM_0, "vin-sm0", dvm, SM0V1, 0, 5, ENA, 1,
-					ENB, 1, TPS6586X_VCC1, BIT(2)),
-	TPS6586X_DVM(SM_1, "vin-sm1", dvm, SM1V1, 0, 5, ENA, 0,
-					ENB, 0, TPS6586X_VCC1, BIT(0)),
+	TPS6586X_LDO(TPS6586X_ANY, LDO_0, "vinldo01", tps6586x_ldo0, SUPPLYV1,
+			5, 3, ENC, 0, END, 0),
+	TPS6586X_LDO(TPS6586X_ANY, LDO_3, "vinldo23", tps6586x_ldo, SUPPLYV4,
+			0, 3, ENC, 2, END, 2),
+	TPS6586X_LDO(TPS6586X_ANY, LDO_5, "REG-SYS", tps6586x_ldo, SUPPLYV6,
+			0, 3, ENE, 6, ENE, 6),
+	TPS6586X_LDO(TPS6586X_ANY, LDO_6, "vinldo678", tps6586x_ldo, SUPPLYV3,
+			0, 3, ENC, 4, END, 4),
+	TPS6586X_LDO(TPS6586X_ANY, LDO_7, "vinldo678", tps6586x_ldo, SUPPLYV3,
+			3, 3, ENC, 5, END, 5),
+	TPS6586X_LDO(TPS6586X_ANY, LDO_8, "vinldo678", tps6586x_ldo, SUPPLYV2,
+			5, 3, ENC, 6, END, 6),
+	TPS6586X_LDO(TPS6586X_ANY, LDO_9, "vinldo9", tps6586x_ldo, SUPPLYV6,
+			3, 3, ENE, 7, ENE, 7),
+	TPS6586X_LDO(TPS6586X_ANY, LDO_RTC, "REG-SYS", tps6586x_ldo, SUPPLYV4,
+			3, 3, V4, 7, V4, 7),
+	TPS6586X_LDO(TPS6586X_ANY, LDO_1, "vinldo01", tps6586x_dvm, SUPPLYV1,
+			0, 5, ENC, 1, END, 1),
+	TPS6586X_LDO(TPS658623, SM_2, "vin-sm2", tps6586x_ldo4_sm2, SUPPLYV2,
+			0, 5, ENC, 7, END, 7),
+	TPS6586X_LDO(TPS658643, SM_2, "vin-sm2", tps658643_sm2, SUPPLYV2,
+			0, 5, ENC, 7, END, 7),
+	TPS6586X_LDO(TPS6586X_ANY, SM_2, "vin-sm2", tps6586x_sm2, SUPPLYV2,
+			0, 5, ENC, 7, END, 7),
+
+	TPS6586X_DVM(TPS6586X_ANY, LDO_2, "vinldo23", tps6586x_dvm, LDO2BV1,
+			0, 5, ENA, 3, ENB, 3, TPS6586X_VCC2, BIT(6)),
+	TPS6586X_DVM(TPS6586X_ANY, LDO_4, "vinldo4", tps6586x_ldo4_sm2, LDO4V1,
+			0, 5, ENC, 3, END, 3, TPS6586X_VCC1, BIT(6)),
+	TPS6586X_DVM(TPS6586X_ANY, SM_0, "vin-sm0", tps6586x_dvm, SM0V1,
+			0, 5, ENA, 1, ENB, 1, TPS6586X_VCC1, BIT(2)),
+	TPS6586X_DVM(TPS6586X_ANY, SM_1, "vin-sm1", tps6586x_dvm, SM1V1,
+			0, 5, ENA, 0, ENB, 0, TPS6586X_VCC1, BIT(0)),
 };
 
 /*
@@ -254,14 +280,16 @@ static int tps6586x_regulator_set_slew_rate(struct platform_device *pdev,
 			setting->slew_rate & TPS6586X_SLEW_RATE_MASK);
 }
 
-static inline struct tps6586x_regulator *find_regulator_info(int id)
+static inline struct tps6586x_regulator *find_regulator_info(int id,
+			enum tps6586x_version version)
 {
 	struct tps6586x_regulator *ri;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(tps6586x_regulator); i++) {
 		ri = &tps6586x_regulator[i];
-		if (ri->desc.id == id)
+		if (ri->desc.id == id && ((ri->version == version) ||
+					  (ri->version == TPS6586X_ANY)))
 			return ri;
 	}
 	return NULL;
@@ -351,6 +379,7 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 	struct regulator_init_data *reg_data;
 	struct tps6586x_platform_data *pdata;
 	struct of_regulator_match *tps6586x_reg_matches = NULL;
+	enum tps6586x_version reg_version;
 	int id;
 	int err;
 
@@ -373,10 +402,12 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	reg_version = tps6586x_get_version(pdev->dev.parent);
+
 	for (id = 0; id < TPS6586X_ID_MAX_REGULATOR; ++id) {
 		reg_data = pdata->reg_init_data[id];
 
-		ri = find_regulator_info(id);
+		ri = find_regulator_info(id, reg_version);
 		if (!ri) {
 			dev_err(&pdev->dev, "invalid regulator ID specified\n");
 			return -EINVAL;
-- 
1.8.4.2

