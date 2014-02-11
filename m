Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaBKNGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:06:16 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32478 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaBKNET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:04:19 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-a2-52fa1fd0a3b3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 09/14] regulator: s2mps11: Add support for S2MPS14 regulators
Date: Tue, 11 Feb 2014 14:03:52 +0100
Message-id: <1392123837-5517-10-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e/4Fd0L8r+CDI4sFrbYOGM9q8XUh0/Y
	LF6/MLQ42/SG3eL+16OMFt+udDBZXN41h81ixvl9TBZrj9xltzjdzWpxccUXJgduj52z7rJ7
	bFrVyeZx59oeNo95JwM9+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK2NBwwOmgk9JFb//aTYw
	PgrqYuTkkBAwkVj0rIsNwhaTuHBvPZDNxSEksJRRov/3FnYIp49JounOZ2aQKjYBY4nNy5eA
	VYkIbGaUWPz9KiuIwyzQyySxYsVOpi5GDg5hAV+JmQ9VQUwWAVWJAx+lQXp5BdwlDiw8zwIS
	lhBQkJgzyQYkzAkU7vv0nw0kLCTgJrG8P3YCI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ
	+bmbGCHB92UH4+JjVocYBTgYlXh4Nyj+DBJiTSwrrsw9xCjBwawkwvtF+FeQEG9KYmVValF+
	fFFpTmrxIUYmDk6pBkbn1qKjH4QufTe6p7HAMS37EJ/0xPWfstI4I703nJjfd+3CL8fUlQkv
	5LQST4fkv9jt8uYYl4z+p7Jd0Wo9TWWX4+XC3/7qF98pO33X76WRyb+lZy7ODSldPv2dQpLv
	4j4+dh1Bn65D/R8yFj9NXnHh3iKnqKZPYmnh07N38qR8/j1zn4tUvrESS3FGoqEWc1FxIgCR
	ySRzHAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for S2MPS14 PMIC regulators to s2mps11 driver. The S2MPS14
has fewer BUCK-s and LDO-s than S2MPS11. It also does not support
controlling the BUCK ramp delay.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
---
 drivers/regulator/s2mps11.c |  251 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 190 insertions(+), 61 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index 43a2eefb9aa4..c37869fb6c7a 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -1,13 +1,18 @@
 /*
  * s2mps11.c
  *
- * Copyright (c) 2012 Samsung Electronics Co., Ltd
+ * Copyright (c) 2012-2014 Samsung Electronics Co., Ltd
  *              http://www.samsung.com
  *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
  *
  */
 
@@ -24,6 +29,7 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/mfd/samsung/core.h>
 #include <linux/mfd/samsung/s2mps11.h>
+#include <linux/mfd/samsung/s2mps14.h>
 
 struct s2mps11_info {
 	struct regulator_dev **rdev;
@@ -235,7 +241,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.set_ramp_delay		= s2mps11_set_ramp_delay,
 };
 
-#define regulator_desc_ldo1(num)	{		\
+#define regulator_desc_s2mps11_ldo1(num)	{		\
 	.name		= "LDO"#num,			\
 	.id		= S2MPS11_LDO##num,		\
 	.ops		= &s2mps11_ldo_ops,		\
@@ -249,7 +255,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_reg	= S2MPS11_REG_L1CTRL + num - 1,	\
 	.enable_mask	= S2MPS11_ENABLE_MASK		\
 }
-#define regulator_desc_ldo2(num)	{		\
+#define regulator_desc_s2mps11_ldo2(num) {		\
 	.name		= "LDO"#num,			\
 	.id		= S2MPS11_LDO##num,		\
 	.ops		= &s2mps11_ldo_ops,		\
@@ -264,7 +270,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK		\
 }
 
-#define regulator_desc_buck1_4(num)	{			\
+#define regulator_desc_s2mps11_buck1_4(num) {			\
 	.name		= "BUCK"#num,				\
 	.id		= S2MPS11_BUCK##num,			\
 	.ops		= &s2mps11_buck_ops,			\
@@ -280,7 +286,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-#define regulator_desc_buck5	{				\
+#define regulator_desc_s2mps11_buck5 {				\
 	.name		= "BUCK5",				\
 	.id		= S2MPS11_BUCK5,			\
 	.ops		= &s2mps11_buck_ops,			\
@@ -296,7 +302,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-#define regulator_desc_buck6_8(num)	{			\
+#define regulator_desc_s2mps11_buck6_8(num) {			\
 	.name		= "BUCK"#num,				\
 	.id		= S2MPS11_BUCK##num,			\
 	.ops		= &s2mps11_buck_ops,			\
@@ -312,7 +318,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-#define regulator_desc_buck9	{				\
+#define regulator_desc_s2mps11_buck9 {				\
 	.name		= "BUCK9",				\
 	.id		= S2MPS11_BUCK9,			\
 	.ops		= &s2mps11_buck_ops,			\
@@ -328,7 +334,7 @@ static struct regulator_ops s2mps11_buck_ops = {
 	.enable_mask	= S2MPS11_ENABLE_MASK			\
 }
 
-#define regulator_desc_buck10	{				\
+#define regulator_desc_s2mps11_buck10 {				\
 	.name		= "BUCK10",				\
 	.id		= S2MPS11_BUCK10,			\
 	.ops		= &s2mps11_buck_ops,			\
@@ -345,54 +351,172 @@ static struct regulator_ops s2mps11_buck_ops = {
 }
 
 static const struct regulator_desc s2mps11_regulators[] = {
-	regulator_desc_ldo2(1),
-	regulator_desc_ldo1(2),
-	regulator_desc_ldo1(3),
-	regulator_desc_ldo1(4),
-	regulator_desc_ldo1(5),
-	regulator_desc_ldo2(6),
-	regulator_desc_ldo1(7),
-	regulator_desc_ldo1(8),
-	regulator_desc_ldo1(9),
-	regulator_desc_ldo1(10),
-	regulator_desc_ldo2(11),
-	regulator_desc_ldo1(12),
-	regulator_desc_ldo1(13),
-	regulator_desc_ldo1(14),
-	regulator_desc_ldo1(15),
-	regulator_desc_ldo1(16),
-	regulator_desc_ldo1(17),
-	regulator_desc_ldo1(18),
-	regulator_desc_ldo1(19),
-	regulator_desc_ldo1(20),
-	regulator_desc_ldo1(21),
-	regulator_desc_ldo2(22),
-	regulator_desc_ldo2(23),
-	regulator_desc_ldo1(24),
-	regulator_desc_ldo1(25),
-	regulator_desc_ldo1(26),
-	regulator_desc_ldo2(27),
-	regulator_desc_ldo1(28),
-	regulator_desc_ldo1(29),
-	regulator_desc_ldo1(30),
-	regulator_desc_ldo1(31),
-	regulator_desc_ldo1(32),
-	regulator_desc_ldo1(33),
-	regulator_desc_ldo1(34),
-	regulator_desc_ldo1(35),
-	regulator_desc_ldo1(36),
-	regulator_desc_ldo1(37),
-	regulator_desc_ldo1(38),
-	regulator_desc_buck1_4(1),
-	regulator_desc_buck1_4(2),
-	regulator_desc_buck1_4(3),
-	regulator_desc_buck1_4(4),
-	regulator_desc_buck5,
-	regulator_desc_buck6_8(6),
-	regulator_desc_buck6_8(7),
-	regulator_desc_buck6_8(8),
-	regulator_desc_buck9,
-	regulator_desc_buck10,
+	regulator_desc_s2mps11_ldo2(1),
+	regulator_desc_s2mps11_ldo1(2),
+	regulator_desc_s2mps11_ldo1(3),
+	regulator_desc_s2mps11_ldo1(4),
+	regulator_desc_s2mps11_ldo1(5),
+	regulator_desc_s2mps11_ldo2(6),
+	regulator_desc_s2mps11_ldo1(7),
+	regulator_desc_s2mps11_ldo1(8),
+	regulator_desc_s2mps11_ldo1(9),
+	regulator_desc_s2mps11_ldo1(10),
+	regulator_desc_s2mps11_ldo2(11),
+	regulator_desc_s2mps11_ldo1(12),
+	regulator_desc_s2mps11_ldo1(13),
+	regulator_desc_s2mps11_ldo1(14),
+	regulator_desc_s2mps11_ldo1(15),
+	regulator_desc_s2mps11_ldo1(16),
+	regulator_desc_s2mps11_ldo1(17),
+	regulator_desc_s2mps11_ldo1(18),
+	regulator_desc_s2mps11_ldo1(19),
+	regulator_desc_s2mps11_ldo1(20),
+	regulator_desc_s2mps11_ldo1(21),
+	regulator_desc_s2mps11_ldo2(22),
+	regulator_desc_s2mps11_ldo2(23),
+	regulator_desc_s2mps11_ldo1(24),
+	regulator_desc_s2mps11_ldo1(25),
+	regulator_desc_s2mps11_ldo1(26),
+	regulator_desc_s2mps11_ldo2(27),
+	regulator_desc_s2mps11_ldo1(28),
+	regulator_desc_s2mps11_ldo1(29),
+	regulator_desc_s2mps11_ldo1(30),
+	regulator_desc_s2mps11_ldo1(31),
+	regulator_desc_s2mps11_ldo1(32),
+	regulator_desc_s2mps11_ldo1(33),
+	regulator_desc_s2mps11_ldo1(34),
+	regulator_desc_s2mps11_ldo1(35),
+	regulator_desc_s2mps11_ldo1(36),
+	regulator_desc_s2mps11_ldo1(37),
+	regulator_desc_s2mps11_ldo1(38),
+	regulator_desc_s2mps11_buck1_4(1),
+	regulator_desc_s2mps11_buck1_4(2),
+	regulator_desc_s2mps11_buck1_4(3),
+	regulator_desc_s2mps11_buck1_4(4),
+	regulator_desc_s2mps11_buck5,
+	regulator_desc_s2mps11_buck6_8(6),
+	regulator_desc_s2mps11_buck6_8(7),
+	regulator_desc_s2mps11_buck6_8(8),
+	regulator_desc_s2mps11_buck9,
+	regulator_desc_s2mps11_buck10,
+};
+
+static struct regulator_ops s2mps14_reg_ops = {
+	.list_voltage		= regulator_list_voltage_linear,
+	.map_voltage		= regulator_map_voltage_linear,
+	.is_enabled		= regulator_is_enabled_regmap,
+	.enable			= regulator_enable_regmap,
+	.disable		= regulator_disable_regmap,
+	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
+	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.set_voltage_time_sel	= regulator_set_voltage_time_sel,
+};
+
+#define regulator_desc_s2mps14_ldo1(num) {		\
+	.name		= "LDO"#num,			\
+	.id		= S2MPS14_LDO##num,		\
+	.ops		= &s2mps14_reg_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.min_uV		= S2MPS14_LDO_MIN_800MV,	\
+	.uV_step	= S2MPS14_LDO_STEP_25MV,	\
+	.n_voltages	= S2MPS14_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
+	.vsel_mask	= S2MPS14_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
+	.enable_mask	= S2MPS14_ENABLE_MASK		\
+}
+#define regulator_desc_s2mps14_ldo2(num) {		\
+	.name		= "LDO"#num,			\
+	.id		= S2MPS14_LDO##num,		\
+	.ops		= &s2mps14_reg_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.min_uV		= S2MPS14_LDO_MIN_1800MV,	\
+	.uV_step	= S2MPS14_LDO_STEP_25MV,	\
+	.n_voltages	= S2MPS14_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
+	.vsel_mask	= S2MPS14_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
+	.enable_mask	= S2MPS14_ENABLE_MASK		\
+}
+#define regulator_desc_s2mps14_ldo3(num) {		\
+	.name		= "LDO"#num,			\
+	.id		= S2MPS14_LDO##num,		\
+	.ops		= &s2mps14_reg_ops,		\
+	.type		= REGULATOR_VOLTAGE,		\
+	.owner		= THIS_MODULE,			\
+	.min_uV		= S2MPS14_LDO_MIN_800MV,	\
+	.uV_step	= S2MPS14_LDO_STEP_12_5MV,	\
+	.n_voltages	= S2MPS14_LDO_N_VOLTAGES,	\
+	.vsel_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
+	.vsel_mask	= S2MPS14_LDO_VSEL_MASK,	\
+	.enable_reg	= S2MPS14_REG_L1CTRL + num - 1,	\
+	.enable_mask	= S2MPS14_ENABLE_MASK		\
+}
+#define regulator_desc_s2mps14_buck1235(num) {			\
+	.name		= "BUCK"#num,				\
+	.id		= S2MPS14_BUCK##num,			\
+	.ops		= &s2mps14_reg_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPS14_BUCK1235_MIN_600MV,		\
+	.uV_step	= S2MPS14_BUCK1235_STEP_6_25MV,		\
+	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
+	.linear_min_sel = S2MPS14_BUCK1235_START_SEL,		\
+	.ramp_delay	= S2MPS14_BUCK_RAMP_DELAY,		\
+	.vsel_reg	= S2MPS14_REG_B1CTRL2 + (num - 1) * 2,	\
+	.vsel_mask	= S2MPS14_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPS14_REG_B1CTRL1 + (num - 1) * 2,	\
+	.enable_mask	= S2MPS14_ENABLE_MASK			\
+}
+#define regulator_desc_s2mps14_buck4(num) {			\
+	.name		= "BUCK"#num,				\
+	.id		= S2MPS14_BUCK##num,			\
+	.ops		= &s2mps14_reg_ops,			\
+	.type		= REGULATOR_VOLTAGE,			\
+	.owner		= THIS_MODULE,				\
+	.min_uV		= S2MPS14_BUCK4_MIN_1400MV,		\
+	.uV_step	= S2MPS14_BUCK4_STEP_12_5MV,		\
+	.n_voltages	= S2MPS14_BUCK_N_VOLTAGES,		\
+	.linear_min_sel = S2MPS14_BUCK4_START_SEL,		\
+	.ramp_delay	= S2MPS14_BUCK_RAMP_DELAY,		\
+	.vsel_reg	= S2MPS14_REG_B1CTRL2 + (num - 1) * 2,	\
+	.vsel_mask	= S2MPS14_BUCK_VSEL_MASK,		\
+	.enable_reg	= S2MPS14_REG_B1CTRL1 + (num - 1) * 2,	\
+	.enable_mask	= S2MPS14_ENABLE_MASK			\
+}
+static const struct regulator_desc s2mps14_regulators[] = {
+	regulator_desc_s2mps14_ldo3(1),
+	regulator_desc_s2mps14_ldo3(2),
+	regulator_desc_s2mps14_ldo1(3),
+	regulator_desc_s2mps14_ldo1(4),
+	regulator_desc_s2mps14_ldo3(5),
+	regulator_desc_s2mps14_ldo3(6),
+	regulator_desc_s2mps14_ldo1(7),
+	regulator_desc_s2mps14_ldo2(8),
+	regulator_desc_s2mps14_ldo3(9),
+	regulator_desc_s2mps14_ldo3(10),
+	regulator_desc_s2mps14_ldo1(11),
+	regulator_desc_s2mps14_ldo2(12),
+	regulator_desc_s2mps14_ldo2(13),
+	regulator_desc_s2mps14_ldo2(14),
+	regulator_desc_s2mps14_ldo2(15),
+	regulator_desc_s2mps14_ldo2(16),
+	regulator_desc_s2mps14_ldo2(17),
+	regulator_desc_s2mps14_ldo2(18),
+	regulator_desc_s2mps14_ldo1(19),
+	regulator_desc_s2mps14_ldo1(20),
+	regulator_desc_s2mps14_ldo1(21),
+	regulator_desc_s2mps14_ldo3(22),
+	regulator_desc_s2mps14_ldo1(23),
+	regulator_desc_s2mps14_ldo2(24),
+	regulator_desc_s2mps14_ldo2(25),
+	regulator_desc_s2mps14_buck1235(1),
+	regulator_desc_s2mps14_buck1235(2),
+	regulator_desc_s2mps14_buck1235(3),
+	regulator_desc_s2mps14_buck4(4),
+	regulator_desc_s2mps14_buck1235(5),
 };
 
 static int s2mps11_pmic_probe(struct platform_device *pdev)
@@ -418,6 +542,10 @@ static int s2mps11_pmic_probe(struct platform_device *pdev)
 		s2mps11->rdev_num = ARRAY_SIZE(s2mps11_regulators);
 		regulators = s2mps11_regulators;
 		break;
+	case S2MPS14X:
+		s2mps11->rdev_num = ARRAY_SIZE(s2mps14_regulators);
+		regulators = s2mps14_regulators;
+		break;
 	default:
 		dev_err(&pdev->dev, "Invalid device type: %u\n", dev_type);
 		return -EINVAL;
@@ -488,6 +616,7 @@ common_reg:
 
 static const struct platform_device_id s2mps11_pmic_id[] = {
 	{ "s2mps11-pmic", S2MPS11X},
+	{ "s2mps14-pmic", S2MPS14X},
 	{ },
 };
 MODULE_DEVICE_TABLE(platform, s2mps11_pmic_id);
@@ -515,5 +644,5 @@ module_exit(s2mps11_pmic_exit);
 
 /* Module information */
 MODULE_AUTHOR("Sangbeom Kim <sbkim73@samsung.com>");
-MODULE_DESCRIPTION("SAMSUNG S2MPS11 Regulator Driver");
+MODULE_DESCRIPTION("SAMSUNG S2MPS11/S2MPS14 Regulator Driver");
 MODULE_LICENSE("GPL");
-- 
1.7.9.5

