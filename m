Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaIQNIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:08:22 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44806 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbaIQNIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:08:18 -0400
From: Chris Zhong <zyw@rock-chips.com>
To: dianders@chromium.org, heiko@sntech.de
Cc: huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        Chris Zhong <zyw@rock-chips.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] regulator: st-pwm: get voltage and duty table from dts
Date: Wed, 17 Sep 2014 21:07:59 +0800
Message-Id: <1410959280-29662-2-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
References: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get voltage & duty table from device tree might be better, other platforms can also use this
driver without any modify.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
---

 drivers/regulator/Kconfig  |    1 -
 drivers/regulator/st-pwm.c |   80 +++++++++++++++++++++++---------------------
 2 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index fb32bab..06a9632 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -495,7 +495,6 @@ config REGULATOR_S5M8767
 
 config REGULATOR_ST_PWM
 	tristate "STMicroelectronics PWM voltage regulator"
-	depends on ARCH_STI
 	help
 	 This driver supports ST's PWM controlled voltage regulators.
 
diff --git a/drivers/regulator/st-pwm.c b/drivers/regulator/st-pwm.c
index 5ea78df..877381b 100644
--- a/drivers/regulator/st-pwm.c
+++ b/drivers/regulator/st-pwm.c
@@ -20,16 +20,11 @@
 #include <linux/of_device.h>
 #include <linux/pwm.h>
 
-#define ST_PWM_REG_PERIOD 8448
-
-struct st_pwm_regulator_pdata {
-	const struct regulator_desc *desc;
-	struct st_pwm_voltages *duty_cycle_table;
-};
-
 struct st_pwm_regulator_data {
-	const struct st_pwm_regulator_pdata *pdata;
+	struct regulator_desc *desc;
+	struct st_pwm_voltages *duty_cycle_table;
 	struct pwm_device *pwm;
+	int pwm_reg_period;
 	bool enabled;
 	int state;
 };
@@ -53,10 +48,10 @@ static int st_pwm_regulator_set_voltage_sel(struct regulator_dev *dev,
 	int dutycycle;
 	int ret;
 
-	dutycycle = (ST_PWM_REG_PERIOD / 100) *
-		drvdata->pdata->duty_cycle_table[selector].dutycycle;
+	dutycycle = (drvdata->pwm_reg_period / 100) *
+		    drvdata->duty_cycle_table[selector].dutycycle;
 
-	ret = pwm_config(drvdata->pwm, dutycycle, ST_PWM_REG_PERIOD);
+	ret = pwm_config(drvdata->pwm, dutycycle, drvdata->pwm_reg_period);
 	if (ret) {
 		dev_err(&dev->dev, "Failed to configure PWM\n");
 		return ret;
@@ -84,7 +79,7 @@ static int st_pwm_regulator_list_voltage(struct regulator_dev *dev,
 	if (selector >= dev->desc->n_voltages)
 		return -EINVAL;
 
-	return drvdata->pdata->duty_cycle_table[selector].uV;
+	return drvdata->duty_cycle_table[selector].uV;
 }
 
 static struct regulator_ops st_pwm_regulator_voltage_ops = {
@@ -94,32 +89,16 @@ static struct regulator_ops st_pwm_regulator_voltage_ops = {
 	.map_voltage     = regulator_map_voltage_iterate,
 };
 
-static struct st_pwm_voltages b2105_duty_cycle_table[] = {
-	{ .uV = 1114000, .dutycycle = 0,  },
-	{ .uV = 1095000, .dutycycle = 10, },
-	{ .uV = 1076000, .dutycycle = 20, },
-	{ .uV = 1056000, .dutycycle = 30, },
-	{ .uV = 1036000, .dutycycle = 40, },
-	{ .uV = 1016000, .dutycycle = 50, },
-	/* WARNING: Values above 50% duty-cycle cause boot failures. */
-};
-
-static const struct regulator_desc b2105_desc = {
+static struct regulator_desc b2105_desc = {
 	.name		= "b2105-pwm-regulator",
 	.ops		= &st_pwm_regulator_voltage_ops,
 	.type		= REGULATOR_VOLTAGE,
 	.owner		= THIS_MODULE,
-	.n_voltages	= ARRAY_SIZE(b2105_duty_cycle_table),
 	.supply_name    = "pwm",
 };
 
-static const struct st_pwm_regulator_pdata b2105_info = {
-	.desc		  = &b2105_desc,
-	.duty_cycle_table = b2105_duty_cycle_table,
-};
-
 static const struct of_device_id st_pwm_of_match[] = {
-	{ .compatible = "st,b2105-pwm-regulator", .data = &b2105_info, },
+	{ .compatible = "st,b2105-pwm-regulator" },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, st_pwm_of_match);
@@ -127,10 +106,11 @@ MODULE_DEVICE_TABLE(of, st_pwm_of_match);
 static int st_pwm_regulator_probe(struct platform_device *pdev)
 {
 	struct st_pwm_regulator_data *drvdata;
+	struct property *prop;
 	struct regulator_dev *regulator;
 	struct regulator_config config = { };
 	struct device_node *np = pdev->dev.of_node;
-	const struct of_device_id *of_match;
+	int length, ret;
 
 	if (!np) {
 		dev_err(&pdev->dev, "Device Tree node missing\n");
@@ -141,12 +121,36 @@ static int st_pwm_regulator_probe(struct platform_device *pdev)
 	if (!drvdata)
 		return -ENOMEM;
 
-	of_match = of_match_device(st_pwm_of_match, &pdev->dev);
-	if (!of_match) {
-		dev_err(&pdev->dev, "failed to match of device\n");
-		return -ENODEV;
+	drvdata->desc = &b2105_desc;
+
+	/* determine the number of voltage-table */
+	prop = of_find_property(np, "voltage-table", &length);
+	if (!prop)
+		return -EINVAL;
+
+	drvdata->desc->n_voltages = length / sizeof(*drvdata->duty_cycle_table);
+
+	/* read voltage table from DT property */
+	if (length > 0) {
+		size_t size = sizeof(*drvdata->duty_cycle_table) *
+			      drvdata->desc->n_voltages;
+
+		drvdata->duty_cycle_table = devm_kzalloc(&pdev->dev,
+							 size, GFP_KERNEL);
+		if (!drvdata->duty_cycle_table)
+			return -ENOMEM;
+
+		ret = of_property_read_u32_array(np, "voltage-table",
+				(u32 *)drvdata->duty_cycle_table,
+				length / sizeof(u32));
+		if (ret < 0)
+			return ret;
 	}
-	drvdata->pdata = of_match->data;
+
+	ret = of_property_read_u32(np, "pwm-reg-period",
+				   &drvdata->pwm_reg_period);
+	if (ret)
+		return -EINVAL;
 
 	config.init_data = of_get_regulator_init_data(&pdev->dev, np);
 	if (!config.init_data)
@@ -163,10 +167,10 @@ static int st_pwm_regulator_probe(struct platform_device *pdev)
 	}
 
 	regulator = devm_regulator_register(&pdev->dev,
-					    drvdata->pdata->desc, &config);
+					    drvdata->desc, &config);
 	if (IS_ERR(regulator)) {
 		dev_err(&pdev->dev, "Failed to register regulator %s\n",
-			drvdata->pdata->desc->name);
+			drvdata->desc->name);
 		return PTR_ERR(regulator);
 	}
 
-- 
1.7.9.5

