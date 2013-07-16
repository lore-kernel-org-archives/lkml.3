Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab3GPIeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:34:50 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51360 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3GPIeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:34:46 -0400
Message-ID: <1373963679.27956.2.camel@phoenix>
Subject: [PATCH RFT] regulator: as3711: Convert to use linear ranges
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 16 Jul 2013 16:34:39 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SD, ALDO, and DLDO vlotage tables are composed of linear ranges.
This patch converts as3711 to use newly introduced helpers for multiple
linear ranges.

Below is the voltage table on datasheet:

SD:
00h:     DC/DC powered down
01h-40h: Volt = 0.6V + sdx_vsel * 12.5mV
41h-70h: Volt = 1.4V + (sdx_vsel - 40h) * 25mV
71h-7Fh: Volt = 2.6V + (sdx_vsel - 70h) * 50mV

ALDO:
0h-0Fh:  1.2V + ldox_vsel * 50mV
10h-1Fh: 1.8V + (ldox_vsel - 10h) * 100mV

DLDO:
00h-10h: Volt = 0.9V + ldox_vsel * 50mV
11h-1fh: Do not use
20h-3fh: Volt = 1.75V + (ldox_vsel - 20h) * 50mV

Note, when convert to use linear ranges APIs, the equation for SD needs below
adjustment because the linear ranges APIs wiil substract range->min_sel when
apply the equation.

SD ( the equation to be used with linear ranges APIs )
01h-40h: Volt = 0.6125V + (sdx_vsel - 1h) * 12.5mV
41h-70h: Volt = 1.425V + (sdx_vsel - 41h) * 25mV
71h-7Fh: Volt = 2.650V + (sdx_vsel - 71h) * 50mV

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/as3711-regulator.c | 163 +++++++----------------------------
 1 file changed, 31 insertions(+), 132 deletions(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index 3da6bd6..7b7da90 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -30,102 +30,6 @@ struct as3711_regulator {
 	struct regulator_dev *rdev;
 };
 
-static int as3711_list_voltage_sd(struct regulator_dev *rdev,
-				  unsigned int selector)
-{
-	if (selector >= rdev->desc->n_voltages)
-		return -EINVAL;
-
-	if (!selector)
-		return 0;
-	if (selector < 0x41)
-		return 600000 + selector * 12500;
-	if (selector < 0x71)
-		return 1400000 + (selector - 0x40) * 25000;
-	return 2600000 + (selector - 0x70) * 50000;
-}
-
-static int as3711_list_voltage_aldo(struct regulator_dev *rdev,
-				    unsigned int selector)
-{
-	if (selector >= rdev->desc->n_voltages)
-		return -EINVAL;
-
-	if (selector < 0x10)
-		return 1200000 + selector * 50000;
-	return 1800000 + (selector - 0x10) * 100000;
-}
-
-static int as3711_list_voltage_dldo(struct regulator_dev *rdev,
-				    unsigned int selector)
-{
-	if (selector >= rdev->desc->n_voltages ||
-	    (selector > 0x10 && selector < 0x20))
-		return -EINVAL;
-
-	if (selector < 0x11)
-		return 900000 + selector * 50000;
-	return 1750000 + (selector - 0x20) * 50000;
-}
-
-static int as3711_bound_check(struct regulator_dev *rdev,
-			      int *min_uV, int *max_uV)
-{
-	struct as3711_regulator *reg = rdev_get_drvdata(rdev);
-	struct as3711_regulator_info *info = reg->reg_info;
-
-	dev_dbg(&rdev->dev, "%s(), %d, %d, %d\n", __func__,
-		*min_uV, rdev->desc->min_uV, info->max_uV);
-
-	if (*max_uV < *min_uV ||
-	    *min_uV > info->max_uV || rdev->desc->min_uV > *max_uV)
-		return -EINVAL;
-
-	if (rdev->desc->n_voltages == 1)
-		return 0;
-
-	if (*max_uV > info->max_uV)
-		*max_uV = info->max_uV;
-
-	if (*min_uV < rdev->desc->min_uV)
-		*min_uV = rdev->desc->min_uV;
-
-	return *min_uV;
-}
-
-static int as3711_sel_check(int min, int max, int bottom, int step)
-{
-	int sel, voltage;
-
-	/* Round up min, when dividing: keeps us within the range */
-	sel = DIV_ROUND_UP(min - bottom, step);
-	voltage = sel * step + bottom;
-	pr_debug("%s(): select %d..%d in %d+N*%d: %d\n", __func__,
-	       min, max, bottom, step, sel);
-	if (voltage > max)
-		return -EINVAL;
-
-	return sel;
-}
-
-static int as3711_map_voltage_sd(struct regulator_dev *rdev,
-				 int min_uV, int max_uV)
-{
-	int ret;
-
-	ret = as3711_bound_check(rdev, &min_uV, &max_uV);
-	if (ret <= 0)
-		return ret;
-
-	if (min_uV <= 1400000)
-		return as3711_sel_check(min_uV, max_uV, 600000, 12500);
-
-	if (min_uV <= 2600000)
-		return as3711_sel_check(min_uV, max_uV, 1400000, 25000) + 0x40;
-
-	return as3711_sel_check(min_uV, max_uV, 2600000, 50000) + 0x70;
-}
-
 /*
  * The regulator API supports 4 modes of operataion: FAST, NORMAL, IDLE and
  * STANDBY. We map them in the following way to AS3711 SD1-4 DCDC modes:
@@ -180,44 +84,14 @@ static unsigned int as3711_get_mode_sd(struct regulator_dev *rdev)
 	return -EINVAL;
 }
 
-static int as3711_map_voltage_aldo(struct regulator_dev *rdev,
-				  int min_uV, int max_uV)
-{
-	int ret;
-
-	ret = as3711_bound_check(rdev, &min_uV, &max_uV);
-	if (ret <= 0)
-		return ret;
-
-	if (min_uV <= 1800000)
-		return as3711_sel_check(min_uV, max_uV, 1200000, 50000);
-
-	return as3711_sel_check(min_uV, max_uV, 1800000, 100000) + 0x10;
-}
-
-static int as3711_map_voltage_dldo(struct regulator_dev *rdev,
-				  int min_uV, int max_uV)
-{
-	int ret;
-
-	ret = as3711_bound_check(rdev, &min_uV, &max_uV);
-	if (ret <= 0)
-		return ret;
-
-	if (min_uV <= 1700000)
-		return as3711_sel_check(min_uV, max_uV, 900000, 50000);
-
-	return as3711_sel_check(min_uV, max_uV, 1750000, 50000) + 0x20;
-}
-
 static struct regulator_ops as3711_sd_ops = {
 	.is_enabled		= regulator_is_enabled_regmap,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.list_voltage		= as3711_list_voltage_sd,
-	.map_voltage		= as3711_map_voltage_sd,
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
 	.get_mode		= as3711_get_mode_sd,
 	.set_mode		= as3711_set_mode_sd,
 };
@@ -228,8 +102,8 @@ static struct regulator_ops as3711_aldo_ops = {
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.list_voltage		= as3711_list_voltage_aldo,
-	.map_voltage		= as3711_map_voltage_aldo,
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
 };
 
 static struct regulator_ops as3711_dldo_ops = {
@@ -238,8 +112,31 @@ static struct regulator_ops as3711_dldo_ops = {
 	.disable		= regulator_disable_regmap,
 	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
 	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
-	.list_voltage		= as3711_list_voltage_dldo,
-	.map_voltage		= as3711_map_voltage_dldo,
+	.list_voltage		= regulator_list_voltage_linear_range,
+	.map_voltage		= regulator_map_voltage_linear_range,
+};
+
+static const struct regulator_linear_range as3711_sd_ranges[] = {
+	{ .min_uV = 612500, .max_uV = 1400000,
+	  .min_sel = 0x1, .max_sel = 0x40, .uV_step = 12500 },
+	{ .min_uV = 1425000, .max_uV = 2600000,
+	  .min_sel = 0x41, .max_sel = 0x70, .uV_step = 25000 },
+	{ .min_uV = 2650000, .max_uV = 3350000,
+	  .min_sel = 0x71, .max_sel = 0x7f, .uV_step = 50000 },
+};
+
+static const struct regulator_linear_range as3711_aldo_ranges[] = {
+	{ .min_uV = 1200000, .max_uV = 1950000,
+	  .min_sel = 0, .max_sel = 0xf, .uV_step = 50000 },
+	{ .min_uV = 1800000, .max_uV = 3300000,
+	  .min_sel = 0x10, .max_sel = 0x1f, .uV_step = 100000 },
+};
+
+static const struct regulator_linear_range as3711_dldo_ranges[] = {
+	{ .min_uV = 900000, .max_uV = 1700000,
+	  .min_sel = 0, .max_sel = 0x10, .uV_step = 50000 },
+	{ .min_uV = 1750000, .max_uV = 3300000,
+	  .min_sel = 0x20, .max_sel = 0x3f, .uV_step = 50000 },
 };
 
 #define AS3711_REG(_id, _en_reg, _en_bit, _vmask, _vshift, _min_uV, _max_uV, _sfx)	\
@@ -256,6 +153,8 @@ static struct regulator_ops as3711_dldo_ops = {
 		.enable_reg = AS3711_ ## _en_reg,					\
 		.enable_mask = BIT(_en_bit),						\
 		.min_uV	= _min_uV,							\
+		.linear_ranges = as3711_ ## _sfx ## _ranges,				\
+		.n_linear_ranges = ARRAY_SIZE(as3711_ ## _sfx ## _ranges),		\
 	},										\
 	.max_uV = _max_uV,								\
 }
-- 
1.8.1.2



