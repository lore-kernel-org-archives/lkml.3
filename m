Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaDNSuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:50:44 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:57029 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaDNSul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:50:41 -0400
From: Matt Porter <mporter@linaro.org>
To: Devicetree List <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Tim Kryger <tim.kryger@linaro.org>, Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 3/4] regulator: bcm590xx: add support for regulators on secondary i2c slave
Date: Mon, 14 Apr 2014 14:50:27 -0400
Message-Id: <1397501428-8857-4-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1397501428-8857-1-git-send-email-mporter@linaro.org>
References: <1397501428-8857-1-git-send-email-mporter@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bcm590xx mfd driver now exposes a second regmap descriptor making
the registers for regulators on the secondary i2c slave address
available.  Add support for GPLDO1-6 and VBUS regulators found within
this register range.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 drivers/regulator/bcm590xx-regulator.c | 92 ++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
index c3750c5..4f0b5d9 100644
--- a/drivers/regulator/bcm590xx-regulator.c
+++ b/drivers/regulator/bcm590xx-regulator.c
@@ -22,7 +22,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/slab.h>
 
-/* Register defs */
+/* I2C slave 0 registers */
 #define BCM590XX_RFLDOPMCTRL1	0x60
 #define BCM590XX_IOSR1PMCTRL1	0x7a
 #define BCM590XX_IOSR2PMCTRL1	0x7c
@@ -31,13 +31,34 @@
 #define BCM590XX_SDSR2PMCTRL1	0x86
 #define BCM590XX_MSRPMCTRL1	0x8a
 #define BCM590XX_VSRPMCTRL1	0x8e
-#define BCM590XX_REG_ENABLE	BIT(7)
-
 #define BCM590XX_RFLDOCTRL	0x96
 #define BCM590XX_CSRVOUT1	0xc0
+
+/* I2C slave 1 registers */
+#define BCM590XX_GPLDO5PMCTRL1	0x16
+#define BCM590XX_GPLDO6PMCTRL1	0x18
+#define BCM590XX_GPLDO1CTRL	0x1a
+#define BCM590XX_GPLDO2CTRL	0x1b
+#define BCM590XX_GPLDO3CTRL	0x1c
+#define BCM590XX_GPLDO4CTRL	0x1d
+#define BCM590XX_GPLDO5CTRL	0x1e
+#define BCM590XX_GPLDO6CTRL	0x1f
+#define BCM590XX_OTG_CTRL	0x40
+#define BCM590XX_GPLDO1PMCTRL1	0x57
+#define BCM590XX_GPLDO2PMCTRL1	0x59
+#define BCM590XX_GPLDO3PMCTRL1	0x5b
+#define BCM590XX_GPLDO4PMCTRL1	0x5d
+
+#define BCM590XX_REG_ENABLE	BIT(7)
+#define BCM590XX_VBUS_ENABLE	BIT(2)
 #define BCM590XX_LDO_VSEL_MASK	GENMASK(5, 3)
 #define BCM590XX_SR_VSEL_MASK	GENMASK(5, 0)
 
+/*
+ * RFLDO to VSR regulators are
+ * accessed via I2C slave 0
+ */
+
 /* LDO regulator IDs */
 #define BCM590XX_REG_RFLDO	0
 #define BCM590XX_REG_CAMLDO1	1
@@ -62,9 +83,25 @@
 #define BCM590XX_REG_SDSR2	18
 #define BCM590XX_REG_VSR	19
 
-#define BCM590XX_NUM_REGS	20
+/*
+ * GPLDO1 to VBUS regulators are
+ * accessed via I2C slave 1
+ */
+
+#define BCM590XX_REG_GPLDO1	20
+#define BCM590XX_REG_GPLDO2	21
+#define BCM590XX_REG_GPLDO3	22
+#define BCM590XX_REG_GPLDO4	23
+#define BCM590XX_REG_GPLDO5	24
+#define BCM590XX_REG_GPLDO6	25
+#define BCM590XX_REG_VBUS	26
+
+#define BCM590XX_NUM_REGS	27
 
 #define BCM590XX_REG_IS_LDO(n)	(n < BCM590XX_REG_CSR)
+#define BCM590XX_REG_IS_GPLDO(n) \
+	((n > BCM590XX_REG_VSR) && (n < BCM590XX_REG_VBUS))
+#define BCM590XX_REG_IS_VBUS(n)	(n == BCM590XX_REG_VBUS)
 
 struct bcm590xx_board {
 	struct regulator_init_data *bcm590xx_pmu_init_data[BCM590XX_NUM_REGS];
@@ -149,6 +186,12 @@ static struct bcm590xx_info bcm590xx_regs[] = {
 	BCM590XX_REG_RANGES(sdsr1, dcdc_sdsr1_ranges),
 	BCM590XX_REG_RANGES(sdsr2, dcdc_iosr1_ranges),
 	BCM590XX_REG_RANGES(vsr, dcdc_iosr1_ranges),
+	BCM590XX_REG_TABLE(gpldo1, ldo_a_table),
+	BCM590XX_REG_TABLE(gpldo2, ldo_a_table),
+	BCM590XX_REG_TABLE(gpldo3, ldo_a_table),
+	BCM590XX_REG_TABLE(gpldo4, ldo_a_table),
+	BCM590XX_REG_TABLE(gpldo5, ldo_a_table),
+	BCM590XX_REG_TABLE(gpldo6, ldo_a_table),
 };
 
 struct bcm590xx_reg {
@@ -161,6 +204,8 @@ static int bcm590xx_get_vsel_register(int id)
 {
 	if (BCM590XX_REG_IS_LDO(id))
 		return BCM590XX_RFLDOCTRL + id;
+	else if (BCM590XX_REG_IS_GPLDO(id))
+		return BCM590XX_GPLDO1CTRL + id;
 	else
 		return BCM590XX_CSRVOUT1 + (id - BCM590XX_REG_CSR) * 3;
 }
@@ -171,6 +216,8 @@ static int bcm590xx_get_enable_register(int id)
 
 	if (BCM590XX_REG_IS_LDO(id))
 		reg = BCM590XX_RFLDOPMCTRL1 + id * 2;
+	else if (BCM590XX_REG_IS_GPLDO(id))
+		reg = BCM590XX_GPLDO1PMCTRL1 + id * 2;
 	else
 		switch (id) {
 		case BCM590XX_REG_CSR:
@@ -191,8 +238,11 @@ static int bcm590xx_get_enable_register(int id)
 		case BCM590XX_REG_SDSR2:
 			reg = BCM590XX_SDSR2PMCTRL1;
 			break;
+		case BCM590XX_REG_VBUS:
+			reg = BCM590XX_OTG_CTRL;
 		};
 
+
 	return reg;
 }
 
@@ -216,6 +266,12 @@ static struct regulator_ops bcm590xx_ops_dcdc = {
 	.map_voltage		= regulator_map_voltage_linear_range,
 };
 
+static struct regulator_ops bcm590xx_ops_vbus = {
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+};
+
 #define BCM590XX_MATCH(_name, _id) \
 	{ \
 		.name = #_name, \
@@ -243,6 +299,13 @@ static struct of_regulator_match bcm590xx_matches[] = {
 	BCM590XX_MATCH(sdsr1, SDSR1),
 	BCM590XX_MATCH(sdsr2, SDSR2),
 	BCM590XX_MATCH(vsr, VSR),
+	BCM590XX_MATCH(gpldo1, GPLDO1),
+	BCM590XX_MATCH(gpldo2, GPLDO2),
+	BCM590XX_MATCH(gpldo3, GPLDO3),
+	BCM590XX_MATCH(gpldo4, GPLDO4),
+	BCM590XX_MATCH(gpldo5, GPLDO5),
+	BCM590XX_MATCH(gpldo6, GPLDO6),
+	BCM590XX_MATCH(vbus, VBUS),
 };
 
 static struct bcm590xx_board *bcm590xx_parse_dt_reg_data(
@@ -353,17 +416,23 @@ static int bcm590xx_probe(struct platform_device *pdev)
 		pmu->desc[i].linear_ranges = info->linear_ranges;
 		pmu->desc[i].n_linear_ranges = info->n_linear_ranges;
 
-		if (BCM590XX_REG_IS_LDO(i)) {
+		if ((BCM590XX_REG_IS_LDO(i)) || (BCM590XX_REG_IS_GPLDO(i))) {
 			pmu->desc[i].ops = &bcm590xx_ops_ldo;
 			pmu->desc[i].vsel_mask = BCM590XX_LDO_VSEL_MASK;
-		} else {
+		} else if (BCM590XX_REG_IS_VBUS(i))
+			pmu->desc[i].ops = &bcm590xx_ops_vbus;
+		else {
 			pmu->desc[i].ops = &bcm590xx_ops_dcdc;
 			pmu->desc[i].vsel_mask = BCM590XX_SR_VSEL_MASK;
 		}
 
-		pmu->desc[i].vsel_reg = bcm590xx_get_vsel_register(i);
-		pmu->desc[i].enable_is_inverted = true;
-		pmu->desc[i].enable_mask = BCM590XX_REG_ENABLE;
+		if (BCM590XX_REG_IS_VBUS(i))
+			pmu->desc[i].enable_mask = BCM590XX_VBUS_ENABLE;
+		else {
+			pmu->desc[i].vsel_reg = bcm590xx_get_vsel_register(i);
+			pmu->desc[i].enable_is_inverted = true;
+			pmu->desc[i].enable_mask = BCM590XX_REG_ENABLE;
+		}
 		pmu->desc[i].enable_reg = bcm590xx_get_enable_register(i);
 		pmu->desc[i].type = REGULATOR_VOLTAGE;
 		pmu->desc[i].owner = THIS_MODULE;
@@ -371,7 +440,10 @@ static int bcm590xx_probe(struct platform_device *pdev)
 		config.dev = bcm590xx->dev;
 		config.init_data = reg_data;
 		config.driver_data = pmu;
-		config.regmap = bcm590xx->regmap;
+		if (BCM590XX_REG_IS_GPLDO(i) || BCM590XX_REG_IS_VBUS(i))
+			config.regmap = bcm590xx->regmap1;
+		else
+			config.regmap = bcm590xx->regmap0;
 
 		if (bcm590xx_reg_matches)
 			config.of_node = bcm590xx_reg_matches[i].of_node;
-- 
1.8.4

