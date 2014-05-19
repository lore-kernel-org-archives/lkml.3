Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaESLOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 07:14:42 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:60551 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaESLOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 07:14:40 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH 1/2] regulator: tps6586x: Prepare supporting fixed regulators
Date: Mon, 19 May 2014 13:14:20 +0200
Message-Id: <1400498061-1071-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.9.3
X-Provags-ID: V02:K0:tLDlldJ66S8GZq/d2FwTU7NaJuEy3zNTwk7vXjdmNsz
 rxUeOcU5YKG+L1quPR+MczCrRhNVQJbjZG9s4C+QiYYgdSIe/1
 2GFYcsHNaxIHPQYwY79hGQ8L2bPkN7m+6UXd5S3IK5y0aETJrl
 cNL1h7HZNCSVESeJvR6HLHApWe3A/lWYm7H5DrgZjUVOm7mWEa
 yi64Z777EPeVqdWsXpzVoW3bd06/wGpc3MHygBW+BUxMNUac0N
 t6pqvxRaKcVPPWBOVUWC9W9mpRL8nHA9OcJ3stkSgdfMDmek1H
 fs/MUPo0qibWVVnvIIgDp+O7OZQLCIijQbiTi822Hdw44DD1Vb
 l3ekhfrqNCUDPdN7OdI8ti3LaXM7v02znodXgaOFgb4EEkCC+x
 xzAL+n2DBo+vHtqtq+GPZ1FTQvwRTMwaxNcxqbenhYhXPS1npy
 tcyL3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the required definitions and macros to allow easily adding fixed
regulators. This required for the TPS658640 that doesn't allow setting
the LDO_RTC output voltage.

Signed-off-by: Alban Bedel <alban.bedel@avionic-design.de>
---
 drivers/regulator/tps6586x-regulator.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index 32f38a6..da8ee02 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -68,7 +68,7 @@ static inline struct device *to_tps6586x_dev(struct regulator_dev *rdev)
 	return rdev_get_dev(rdev)->parent;
 }
 
-static struct regulator_ops tps6586x_regulator_ops = {
+static struct regulator_ops tps6586x_rw_regulator_ops = {
 	.list_voltage = regulator_list_voltage_table,
 	.map_voltage = regulator_map_voltage_ascend,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
@@ -79,6 +79,16 @@ static struct regulator_ops tps6586x_regulator_ops = {
 	.disable = regulator_disable_regmap,
 };
 
+static struct regulator_ops tps6586x_ro_regulator_ops = {
+	.list_voltage = regulator_list_voltage_table,
+	.map_voltage = regulator_map_voltage_ascend,
+	.get_voltage_sel = regulator_get_voltage_sel_regmap,
+
+	.is_enabled = regulator_is_enabled_regmap,
+	.enable = regulator_enable_regmap,
+	.disable = regulator_disable_regmap,
+};
+
 static struct regulator_ops tps6586x_sys_regulator_ops = {
 };
 
@@ -120,12 +130,12 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 	1325000, 1350000, 1375000, 1400000, 1425000, 1450000, 1475000, 1500000,
 };
 
-#define TPS6586X_REGULATOR(_id, _pin_name, vdata, vreg, shift, nbits,	\
+#define TPS6586X_REGULATOR(_id, _ops, _pin_name, vdata, vreg, shift, nbits, \
 			   ereg0, ebit0, ereg1, ebit1, goreg, gobit)	\
 	.desc	= {							\
 		.supply_name = _pin_name,				\
 		.name	= "REG-" #_id,					\
-		.ops	= &tps6586x_regulator_ops,			\
+		.ops	= &tps6586x_## _ops ## _regulator_ops,		\
 		.type	= REGULATOR_VOLTAGE,				\
 		.id	= TPS6586X_ID_##_id,				\
 		.n_voltages = ARRAY_SIZE(vdata##_voltages),		\
@@ -146,14 +156,21 @@ static const unsigned int tps6586x_dvm_voltages[] = {
 #define TPS6586X_LDO(_id, _pname, vdata, vreg, shift, nbits,		\
 		     ereg0, ebit0, ereg1, ebit1)			\
 {									\
-	TPS6586X_REGULATOR(_id, _pname, vdata, vreg, shift, nbits,	\
+	TPS6586X_REGULATOR(_id, rw, _pname, vdata, vreg, shift, nbits,	\
+			   ereg0, ebit0, ereg1, ebit1, 0, 0)		\
+}
+
+#define TPS6586X_FIXED_LDO(_id, _pname, vdata, vreg, shift, nbits,	\
+			  ereg0, ebit0, ereg1, ebit1)			\
+{									\
+	TPS6586X_REGULATOR(_id, ro, _pname, vdata, vreg, shift, nbits,	\
 			   ereg0, ebit0, ereg1, ebit1, 0, 0)		\
 }
 
 #define TPS6586X_DVM(_id, _pname, vdata, vreg, shift, nbits,		\
 		     ereg0, ebit0, ereg1, ebit1, goreg, gobit)		\
 {									\
-	TPS6586X_REGULATOR(_id, _pname, vdata, vreg, shift, nbits,	\
+	TPS6586X_REGULATOR(_id, rw, _pname, vdata, vreg, shift, nbits,	\
 			   ereg0, ebit0, ereg1, ebit1, goreg, gobit)	\
 }
 
-- 
1.9.3

