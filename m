Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbaETKOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:14:43 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:62003 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaETKOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:14:39 -0400
From: Alban Bedel <alban.bedel@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: [PATCH v2 1/2] regulator: tps6586x: Prepare supporting fixed regulators
Date: Tue, 20 May 2014 12:14:02 +0200
Message-Id: <1400580843-29484-1-git-send-email-alban.bedel@avionic-design.de>
X-Mailer: git-send-email 1.9.3
X-Provags-ID: V02:K0:CvCvPTuHxNUGbbS4ul0XJ/mslEa3claubYD/IUletgo
 3iVkG5DhYaNDk2IwrF2YGFasv3H4SjyM8QFZr704iMaS+Jusv9
 o92d2gi/xuVhEzobkuzc6GQS12YkUI/udSBI6YzE3BFxtaP+S9
 BxisaVuQt1e1D1+zHcohd3XqZlDJiiP/bUsrd17jw2OfXIO+av
 ODv1MU6vFRNv2/2l3FET2MF26ClE78ilTG1kNoILArKytbTfDf
 6SvILYa8ClU416r9aJ+GO8AOROJArDmHhbbSVFWcN1BTcujY1N
 l08Tq+VpwAdIeix0Mlvrt9esB1bD2hrzV0Fmdjki3Pa+fLatvf
 vfzwpfSFQURXYbNbk/uw3rZ7YeZcMH3+7MfWwdTJMCUcgdiWL9
 I9l6iFZYkiOFFFIY5ItS0zJy2syW60Dh0x2spC6We8XVukvOvp
 IeDIl
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

