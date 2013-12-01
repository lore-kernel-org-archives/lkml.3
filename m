Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3LAP7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 10:59:40 -0500
Received: from mail.kmu-office.ch ([178.209.48.102]:52456 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3LAP7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 10:59:37 -0500
From: Stefan Agner <stefan@agner.ch>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, dev@lynxeye.de,
        lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org
Cc: kai.poggensee@avionic-design.de, sameo@linux.intel.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 2/3] regulator: tps6586x: add and use correct voltage table
Date: Sun,  1 Dec 2013 16:59:14 +0100
Message-Id: <77c960e6e3a91cf39bc866ccb9cd578ccc5acc95.1385913228.git.stefan@agner.ch>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <cover.1385913227.git.stefan@agner.ch>
References: <cover.1385913227.git.stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Depending on the regulator version, the voltage table might be
different. Use version specific regulator tables in order to select
correct voltage table. For the following regulator versions different
voltage tables are now used:

  * TPS658623: Use correct voltage table for SM2
  * TPS658643: New voltage table for SM2

Both versions are in use on the Colibri T20 module. Make use of the
correct tables by requesting the correct SM2 voltage of 1.8V.

This change is not backward compatible since an old driver is not able
to correctly set that value. The value 1.8V is out of range for the old
driver and will refuse to probe the device. The regulator starts with
default settings and the driver shows appropriate error messages.

On Colibri T20, the old value used to work with TPS658623 since the
driver applied a wrong voltage table too. However, the TPS658643 used
on V1.2 devices uses yet another voltage table and those broke that
pseudo-compatibility. The regulator driver now has the correct voltage
table for both regulator versions and those the correct voltage can be
used in the device tree.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 arch/arm/boot/dts/tegra20-colibri-512.dtsi |  4 +-
 drivers/regulator/tps6586x-regulator.c     | 89 +++++++++++++++++++++++-------
 2 files changed, 70 insertions(+), 23 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-colibri-512.dtsi b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
index d5c9bca..cbe89ff 100644
--- a/arch/arm/boot/dts/tegra20-colibri-512.dtsi
+++ b/arch/arm/boot/dts/tegra20-colibri-512.dtsi
@@ -268,8 +268,8 @@
 					reg = <3>;
 					regulator-compatible = "sm2";
 					regulator-name = "vdd_sm2,vin_ldo*";
-					regulator-min-microvolt = <3700000>;
-					regulator-max-microvolt = <3700000>;
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
 					regulator-always-on;
 				};
 
diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index e8e3a8a..c09cf35 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -86,6 +86,7 @@ static const unsigned int tps6586x_ldo0_voltages[] = {
 	1200000, 1500000, 1800000, 2500000, 2700000, 2850000, 3100000, 3300000,
 };
 
+#define tps658623_sm2_voltages tps6586x_ldo4_voltages
 static const unsigned int tps6586x_ldo4_voltages[] = {
 	1700000, 1725000, 1750000, 1775000, 1800000, 1825000, 1850000, 1875000,
 	1900000, 1925000, 1950000, 1975000, 2000000, 2025000, 2050000, 2075000,
@@ -104,6 +105,13 @@ static const unsigned int tps6586x_sm2_voltages[] = {
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
@@ -119,8 +127,8 @@ static const unsigned int tps6586x_dvm_voltages[] = {
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
@@ -162,27 +170,47 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 
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
+	TPS6586X_LDO(LDO_0, "vinldo01", tps6586x_ldo0, SUPPLYV1, 5, 3, ENC, 0,
+					END, 0),
+	TPS6586X_LDO(LDO_3, "vinldo23", tps6586x_ldo, SUPPLYV4, 0, 3, ENC, 2,
+					END, 2),
+	TPS6586X_LDO(LDO_5, "REG-SYS", tps6586x_ldo, SUPPLYV6, 0, 3, ENE, 6,
+					ENE, 6),
+	TPS6586X_LDO(LDO_6, "vinldo678", tps6586x_ldo, SUPPLYV3, 0, 3, ENC, 4,
+					END, 4),
+	TPS6586X_LDO(LDO_7, "vinldo678", tps6586x_ldo, SUPPLYV3, 3, 3, ENC, 5,
+					END, 5),
+	TPS6586X_LDO(LDO_8, "vinldo678", tps6586x_ldo, SUPPLYV2, 5, 3, ENC, 6,
+					END, 6),
+	TPS6586X_LDO(LDO_9, "vinldo9", tps6586x_ldo, SUPPLYV6, 3, 3, ENE, 7,
+					ENE, 7),
+	TPS6586X_LDO(LDO_RTC, "REG-SYS", tps6586x_ldo, SUPPLYV4, 3, 3, V4, 7,
+					V4, 7),
+	TPS6586X_LDO(LDO_1, "vinldo01", tps6586x_dvm, SUPPLYV1, 0, 5, ENC, 1,
+					END, 1),
+	TPS6586X_LDO(SM_2, "vin-sm2", tps6586x_sm2, SUPPLYV2, 0, 5, ENC, 7,
+					END, 7),
+
+	TPS6586X_DVM(LDO_2, "vinldo23", tps6586x_dvm, LDO2BV1, 0, 5, ENA, 3,
 					ENB, 3, TPS6586X_VCC2, BIT(6)),
-	TPS6586X_DVM(LDO_4, "vinldo4", ldo4, LDO4V1, 0, 5, ENC, 3,
+	TPS6586X_DVM(LDO_4, "vinldo4", tps6586x_ldo4, LDO4V1, 0, 5, ENC, 3,
 					END, 3, TPS6586X_VCC1, BIT(6)),
-	TPS6586X_DVM(SM_0, "vin-sm0", dvm, SM0V1, 0, 5, ENA, 1,
+	TPS6586X_DVM(SM_0, "vin-sm0", tps6586x_dvm, SM0V1, 0, 5, ENA, 1,
 					ENB, 1, TPS6586X_VCC1, BIT(2)),
-	TPS6586X_DVM(SM_1, "vin-sm1", dvm, SM1V1, 0, 5, ENA, 0,
+	TPS6586X_DVM(SM_1, "vin-sm1", tps6586x_dvm, SM1V1, 0, 5, ENA, 0,
 					ENB, 0, TPS6586X_VCC1, BIT(0)),
 };
 
+static struct tps6586x_regulator tps658623_regulator[] = {
+	TPS6586X_LDO(SM_2, "vin-sm2", tps658623_sm2, SUPPLYV2, 0, 5, ENC, 7,
+					END, 7),
+};
+
+static struct tps6586x_regulator tps658643_regulator[] = {
+	TPS6586X_LDO(SM_2, "vin-sm2", tps658643_sm2, SUPPLYV2, 0, 5, ENC, 7,
+					END, 7),
+};
+
 /*
  * TPS6586X has 2 enable bits that are OR'ed to determine the actual
  * regulator state. Clearing one of this bits allows switching
@@ -254,13 +282,14 @@ static int tps6586x_regulator_set_slew_rate(struct platform_device *pdev,
 			setting->slew_rate & TPS6586X_SLEW_RATE_MASK);
 }
 
-static inline struct tps6586x_regulator *find_regulator_info(int id)
+static inline struct tps6586x_regulator *find_regulator_info(int id,
+			struct tps6586x_regulator regulator_info[], int num)
 {
 	struct tps6586x_regulator *ri;
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(tps6586x_regulator); i++) {
-		ri = &tps6586x_regulator[i];
+	for (i = 0; i < num; i++) {
+		ri = &regulator_info[i];
 		if (ri->desc.id == id)
 			return ri;
 	}
@@ -351,6 +380,7 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 	struct regulator_init_data *reg_data;
 	struct tps6586x_platform_data *pdata;
 	struct of_regulator_match *tps6586x_reg_matches = NULL;
+	int reg_version;
 	int id;
 	int err;
 
@@ -373,10 +403,27 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	reg_version = tps6586x_get_version(pdev->dev.parent);
+
 	for (id = 0; id < TPS6586X_ID_MAX_REGULATOR; ++id) {
 		reg_data = pdata->reg_init_data[id];
 
-		ri = find_regulator_info(id);
+		switch(reg_version) {
+		case TPS658623:
+			ri = find_regulator_info(id, tps658623_regulator,
+					ARRAY_SIZE(tps658623_regulator));
+			break;
+		case TPS658643:
+			ri = find_regulator_info(id, tps658643_regulator,
+					ARRAY_SIZE(tps658643_regulator));
+			break;
+		}
+
+		/* Search fallback table if necessary */
+		if (!ri)
+			ri = find_regulator_info(id, tps6586x_regulator,
+					ARRAY_SIZE(tps6586x_regulator));
+
 		if (!ri) {
 			dev_err(&pdev->dev, "invalid regulator ID specified\n");
 			return -EINVAL;
-- 
1.8.4.2

