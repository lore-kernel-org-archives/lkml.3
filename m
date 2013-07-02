Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab3GBWwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 18:52:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48330 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab3GBWwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 18:52:08 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>, Yi Zhang <yizhang@marvell.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Tue,  2 Jul 2013 23:51:53 +0100
Message-Id: <1372805514-11498-3-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372805514-11498-1-git-send-email-broonie@kernel.org>
References: <1372805514-11498-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 3/4] regulator: wm831x-ldo: Convert to use linear ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm831x-ldo.c | 104 ++++++++++-------------------------------
 1 file changed, 24 insertions(+), 80 deletions(-)

diff --git a/drivers/regulator/wm831x-ldo.c b/drivers/regulator/wm831x-ldo.c
index 9ff883f..76792c7 100644
--- a/drivers/regulator/wm831x-ldo.c
+++ b/drivers/regulator/wm831x-ldo.c
@@ -62,41 +62,12 @@ static irqreturn_t wm831x_ldo_uv_irq(int irq, void *data)
  * General purpose LDOs
  */
 
-#define WM831X_GP_LDO_SELECTOR_LOW 0xe
-#define WM831X_GP_LDO_MAX_SELECTOR 0x1f
-
-static int wm831x_gp_ldo_list_voltage(struct regulator_dev *rdev,
-				      unsigned int selector)
-{
-	/* 0.9-1.6V in 50mV steps */
-	if (selector <= WM831X_GP_LDO_SELECTOR_LOW)
-		return 900000 + (selector * 50000);
-	/* 1.7-3.3V in 100mV steps */
-	if (selector <= WM831X_GP_LDO_MAX_SELECTOR)
-		return 1600000 + ((selector - WM831X_GP_LDO_SELECTOR_LOW)
-				  * 100000);
-	return -EINVAL;
-}
-
-static int wm831x_gp_ldo_map_voltage(struct regulator_dev *rdev,
-				     int min_uV, int max_uV)
-{
-	int volt, vsel;
-
-	if (min_uV < 900000)
-		vsel = 0;
-	else if (min_uV < 1700000)
-		vsel = ((min_uV - 900000) / 50000);
-	else
-		vsel = ((min_uV - 1700000) / 100000)
-			+ WM831X_GP_LDO_SELECTOR_LOW + 1;
-
-	volt = wm831x_gp_ldo_list_voltage(rdev, vsel);
-	if (volt < min_uV || volt > max_uV)
-		return -EINVAL;
-
-	return vsel;
-}
+static const struct regulator_linear_range wm831x_gp_ldo_ranges[] = {
+	{ .min_uV =  900000, .max_uV = 1650000, .min_sel =  0, .max_sel = 14,
+	  .uV_step =  50000 },
+	{ .min_uV = 1700000, .max_uV = 3300000, .min_sel = 15, .max_sel = 31,
+	  .uV_step = 100000 },
+};
 
 static int wm831x_gp_ldo_set_suspend_voltage(struct regulator_dev *rdev,
 					     int uV)
@@ -105,7 +76,7 @@ static int wm831x_gp_ldo_set_suspend_voltage(struct regulator_dev *rdev,
 	struct wm831x *wm831x = ldo->wm831x;
 	int sel, reg = ldo->base + WM831X_LDO_SLEEP_CONTROL;
 
-	sel = wm831x_gp_ldo_map_voltage(rdev, uV, uV);
+	sel = regulator_map_voltage_linear_range(rdev, uV, uV);
 	if (sel < 0)
 		return sel;
 
@@ -230,8 +201,8 @@ static unsigned int wm831x_gp_ldo_get_optimum_mode(struct regulator_dev *rdev,
 
 
 static struct regulator_ops wm831x_gp_ldo_ops = {
-	.list_voltage = wm831x_gp_ldo_list_voltage,
-	.map_voltage = wm831x_gp_ldo_map_voltage,
+	.list_voltage = regulator_list_voltage_linear_range,
+	.map_voltage = regulator_map_voltage_linear_range,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.set_suspend_voltage = wm831x_gp_ldo_set_suspend_voltage,
@@ -290,7 +261,7 @@ static int wm831x_gp_ldo_probe(struct platform_device *pdev)
 
 	ldo->desc.id = id;
 	ldo->desc.type = REGULATOR_VOLTAGE;
-	ldo->desc.n_voltages = WM831X_GP_LDO_MAX_SELECTOR + 1;
+	ldo->desc.n_voltages = 32;
 	ldo->desc.ops = &wm831x_gp_ldo_ops;
 	ldo->desc.owner = THIS_MODULE;
 	ldo->desc.vsel_reg = ldo->base + WM831X_LDO_ON_CONTROL;
@@ -299,6 +270,8 @@ static int wm831x_gp_ldo_probe(struct platform_device *pdev)
 	ldo->desc.enable_mask = 1 << id;
 	ldo->desc.bypass_reg = ldo->base;
 	ldo->desc.bypass_mask = WM831X_LDO1_SWI;
+	ldo->desc.linear_ranges = wm831x_gp_ldo_ranges;
+	ldo->desc.n_linear_ranges = ARRAY_SIZE(wm831x_gp_ldo_ranges);
 
 	config.dev = pdev->dev.parent;
 	if (pdata)
@@ -358,43 +331,12 @@ static struct platform_driver wm831x_gp_ldo_driver = {
  * Analogue LDOs
  */
 
-
-#define WM831X_ALDO_SELECTOR_LOW 0xc
-#define WM831X_ALDO_MAX_SELECTOR 0x1f
-
-static int wm831x_aldo_list_voltage(struct regulator_dev *rdev,
-				      unsigned int selector)
-{
-	/* 1-1.6V in 50mV steps */
-	if (selector <= WM831X_ALDO_SELECTOR_LOW)
-		return 1000000 + (selector * 50000);
-	/* 1.7-3.5V in 100mV steps */
-	if (selector <= WM831X_ALDO_MAX_SELECTOR)
-		return 1600000 + ((selector - WM831X_ALDO_SELECTOR_LOW)
-				  * 100000);
-	return -EINVAL;
-}
-
-static int wm831x_aldo_map_voltage(struct regulator_dev *rdev,
-				   int min_uV, int max_uV)
-{
-	int volt, vsel;
-
-	if (min_uV < 1000000)
-		vsel = 0;
-	else if (min_uV < 1700000)
-		vsel = ((min_uV - 1000000) / 50000);
-	else
-		vsel = ((min_uV - 1700000) / 100000)
-			+ WM831X_ALDO_SELECTOR_LOW + 1;
-
-	volt = wm831x_aldo_list_voltage(rdev, vsel);
-	if (volt < min_uV || volt > max_uV)
-		return -EINVAL;
-
-	return vsel;
-
-}
+static const struct regulator_linear_range wm831x_aldo_ranges[] = {
+	{ .min_uV = 1000000, .max_uV = 1650000, .min_sel =  0, .max_sel = 12,
+	  .uV_step =  50000 },
+	{ .min_uV = 1700000, .max_uV = 3500000, .min_sel = 13, .max_sel = 31,
+	  .uV_step = 100000 },
+};
 
 static int wm831x_aldo_set_suspend_voltage(struct regulator_dev *rdev,
 					     int uV)
@@ -403,7 +345,7 @@ static int wm831x_aldo_set_suspend_voltage(struct regulator_dev *rdev,
 	struct wm831x *wm831x = ldo->wm831x;
 	int sel, reg = ldo->base + WM831X_LDO_SLEEP_CONTROL;
 
-	sel = wm831x_aldo_map_voltage(rdev, uV, uV);
+	sel = regulator_map_voltage_linear_range(rdev, uV, uV);
 	if (sel < 0)
 		return sel;
 
@@ -486,8 +428,8 @@ static int wm831x_aldo_get_status(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops wm831x_aldo_ops = {
-	.list_voltage = wm831x_aldo_list_voltage,
-	.map_voltage = wm831x_aldo_map_voltage,
+	.list_voltage = regulator_list_voltage_linear_range,
+	.map_voltage = regulator_map_voltage_linear_range,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.set_suspend_voltage = wm831x_aldo_set_suspend_voltage,
@@ -545,7 +487,9 @@ static int wm831x_aldo_probe(struct platform_device *pdev)
 
 	ldo->desc.id = id;
 	ldo->desc.type = REGULATOR_VOLTAGE;
-	ldo->desc.n_voltages = WM831X_ALDO_MAX_SELECTOR + 1;
+	ldo->desc.n_voltages = 32;
+	ldo->desc.linear_ranges = wm831x_aldo_ranges;
+	ldo->desc.n_linear_ranges = ARRAY_SIZE(wm831x_aldo_ranges);
 	ldo->desc.ops = &wm831x_aldo_ops;
 	ldo->desc.owner = THIS_MODULE;
 	ldo->desc.vsel_reg = ldo->base + WM831X_LDO_ON_CONTROL;
-- 
1.8.3.1

