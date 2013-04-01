Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab3DAP2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:28:55 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:47587 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344Ab3DAP2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:28:54 -0400
Message-ID: <1364830128.17176.3.camel@phoenix>
Subject: [PATCH 2/2] regulator: lp8788: Implement list_voltage for
 lp8788_ldo_voltage_fixed_ops
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 23:28:48 +0800
In-Reply-To: <1364829984.17176.1.camel@phoenix>
References: <1364829984.17176.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For fixed voltage, we can just set min_uV and use regulator_list_voltage_linear
for list_voltage callback. Regulator core will call list_voltage(rdev, 0) if
both get_voltage get_voltage_sel are not implemented. Thus we can also remove
lp8788_ldo_fixed_get_voltage() function.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8788-ldo.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index c29aeae..0ce2c4c 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -170,23 +170,6 @@ static int lp8788_ldo_enable_time(struct regulator_dev *rdev)
 	return ENABLE_TIME_USEC * val;
 }
 
-static int lp8788_ldo_fixed_get_voltage(struct regulator_dev *rdev)
-{
-	enum lp8788_ldo_id id = rdev_get_id(rdev);
-
-	switch (id) {
-	case ALDO2 ... ALDO5:
-		return 2850000;
-	case DLDO12:
-	case ALDO8 ... ALDO9:
-		return 2500000;
-	case ALDO10:
-		return 1100000;
-	default:
-		return -EINVAL;
-	}
-}
-
 static struct regulator_ops lp8788_ldo_voltage_table_ops = {
 	.list_voltage = regulator_list_voltage_table,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
@@ -198,7 +181,7 @@ static struct regulator_ops lp8788_ldo_voltage_table_ops = {
 };
 
 static struct regulator_ops lp8788_ldo_voltage_fixed_ops = {
-	.get_voltage = lp8788_ldo_fixed_get_voltage,
+	.list_voltage = regulator_list_voltage_linear,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
 	.is_enabled = regulator_is_enabled_regmap,
@@ -358,6 +341,7 @@ static struct regulator_desc lp8788_dldo_desc[] = {
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_B,
 		.enable_mask = LP8788_EN_DLDO12_M,
+		.min_uV = 2500000,
 	},
 };
 
@@ -384,6 +368,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_B,
 		.enable_mask = LP8788_EN_ALDO2_M,
+		.min_uV = 2850000,
 	},
 	{
 		.name = "aldo3",
@@ -394,6 +379,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_B,
 		.enable_mask = LP8788_EN_ALDO3_M,
+		.min_uV = 2850000,
 	},
 	{
 		.name = "aldo4",
@@ -404,6 +390,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_B,
 		.enable_mask = LP8788_EN_ALDO4_M,
+		.min_uV = 2850000,
 	},
 	{
 		.name = "aldo5",
@@ -414,6 +401,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_C,
 		.enable_mask = LP8788_EN_ALDO5_M,
+		.min_uV = 2850000,
 	},
 	{
 		.name = "aldo6",
@@ -450,6 +438,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_C,
 		.enable_mask = LP8788_EN_ALDO8_M,
+		.min_uV = 2500000,
 	},
 	{
 		.name = "aldo9",
@@ -460,6 +449,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_C,
 		.enable_mask = LP8788_EN_ALDO9_M,
+		.min_uV = 2500000,
 	},
 	{
 		.name = "aldo10",
@@ -470,6 +460,7 @@ static struct regulator_desc lp8788_aldo_desc[] = {
 		.owner = THIS_MODULE,
 		.enable_reg = LP8788_EN_LDO_C,
 		.enable_mask = LP8788_EN_ALDO10_M,
+		.min_uV = 1100000,
 	},
 };
 
-- 
1.7.10.4



