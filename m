Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaLINwI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:52:08 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40226 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956AbaLINwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:52:04 -0500
From: Chris Zhong <zyw@rock-chips.com>
To: heiko@sntech.de, dianders@chromium.org, broonie@kernel.org
Cc: linux-rockchip@lists.infradead.org, Chris Zhong <zyw@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] regulator: rk808: add dvs support
Date: Tue,  9 Dec 2014 21:51:45 +0800
Message-Id: <1418133106-5634-2-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418133106-5634-1-git-send-email-zyw@rock-chips.com>
References: <1418133106-5634-1-git-send-email-zyw@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rk808 has a dvs function, there are 3 pins for dvs, dvs1 & dvs2 & dvsok.
Normally, the voltage of DCDC1/DCDC2 are controlled by BUCKn_ON_VSEL, when
we pull dvs1/dvs2 pin to active, they would be controlled by BUCKn_DVS_VSEL.
And the dvsok pin is used to indicate whether regulating has been completed.
When dvs1/dvs2 pin change, dvsok would be pull down, and it would be pull up
once the regulating is complete.

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
---

 drivers/regulator/rk808-regulator.c | 192 +++++++++++++++++++++++++++++++++---
 1 file changed, 180 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index c94a3e0..f415188 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -16,10 +16,13 @@
  * more details.
  */
 
-#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/gpio.h>
 #include <linux/i2c.h>
-#include <linux/mfd/rk808.h>
+#include <linux/module.h>
 #include <linux/of_device.h>
+#include <linux/of_gpio.h>
+#include <linux/mfd/rk808.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/of_regulator.h>
 
@@ -36,12 +39,23 @@
 #define RK808_RAMP_RATE_6MV_PER_US	(2 << RK808_RAMP_RATE_OFFSET)
 #define RK808_RAMP_RATE_10MV_PER_US	(3 << RK808_RAMP_RATE_OFFSET)
 
+#define RK808_DVS2_POL		BIT(2)
+#define RK808_DVS1_POL		BIT(1)
+
 /* Offset from XXX_ON_VSEL to XXX_SLP_VSEL */
 #define RK808_SLP_REG_OFFSET 1
 
+/* Offset from XXX_ON_VSEL to XXX_DVS_VSEL */
+#define RK808_DVS_REG_OFFSET 2
+
 /* Offset from XXX_EN_REG to SLEEP_SET_OFF_XXX */
 #define RK808_SLP_SET_OFF_REG_OFFSET 2
 
+struct rk808_regulator_data {
+	struct gpio_desc *dvsok_gpio;
+	struct gpio_desc *dvs_gpio[2];
+};
+
 static const int rk808_buck_config_regs[] = {
 	RK808_BUCK1_CONFIG_REG,
 	RK808_BUCK2_CONFIG_REG,
@@ -70,6 +84,96 @@ static const struct regulator_linear_range rk808_ldo6_voltage_ranges[] = {
 	REGULATOR_LINEAR_RANGE(800000, 0, 17, 100000),
 };
 
+int rk808_buck1_2_get_voltage_sel_regmap(struct regulator_dev *rdev)
+{
+	struct rk808_regulator_data *pdata = rdev_get_drvdata(rdev);
+	int id = rdev->desc->id - RK808_ID_DCDC1;
+	struct gpio_desc *gpio = pdata->dvs_gpio[id];
+	unsigned int val;
+	int ret;
+
+	if (IS_ERR(gpio) || gpiod_get_value(gpio) == 0)
+		return regulator_get_voltage_sel_regmap(rdev);
+
+	ret = regmap_read(rdev->regmap,
+			  rdev->desc->vsel_reg + RK808_DVS_REG_OFFSET,
+			  &val);
+	if (ret != 0)
+		return ret;
+
+	val &= rdev->desc->vsel_mask;
+	val >>= ffs(rdev->desc->vsel_mask) - 1;
+
+	return val;
+}
+
+int rk808_buck1_2_set_voltage_sel(struct regulator_dev *rdev, unsigned sel)
+{
+	struct rk808_regulator_data *pdata = rdev_get_drvdata(rdev);
+	int id = rdev->desc->id - RK808_ID_DCDC1;
+	struct gpio_desc *gpio = pdata->dvs_gpio[id];
+	unsigned int reg = rdev->desc->vsel_reg;
+	unsigned long timeout;
+	unsigned old_sel;
+	int ret, gpio_level;
+
+	if (IS_ERR(gpio))
+		return regulator_set_voltage_sel_regmap(rdev, sel);
+
+	gpio_level = gpiod_get_value(gpio);
+	if (gpio_level == 0) {
+		reg += RK808_DVS_REG_OFFSET;
+		ret = regmap_read(rdev->regmap, rdev->desc->vsel_reg, &old_sel);
+	} else {
+		ret = regmap_read(rdev->regmap,
+				  reg + RK808_DVS_REG_OFFSET,
+				  &old_sel);
+	}
+
+	if (ret != 0)
+		return ret;
+
+	sel <<= ffs(rdev->desc->vsel_mask) - 1;
+	sel |= old_sel & ~rdev->desc->vsel_mask;
+
+	ret = regmap_write(rdev->regmap, reg, sel);
+	if (ret)
+		return ret;
+
+	gpiod_set_value(gpio, !gpio_level);
+
+	/* dvsok pin would be pull down when dvs1/2 pin changed, and
+	 * it would be pull up once the voltage regulate complete.
+	 * No need to wait dvsok signal when voltage falling.
+	 */
+	if (old_sel < sel && !IS_ERR(pdata->dvsok_gpio)) {
+		timeout = jiffies + msecs_to_jiffies(1);
+		while (!time_after(jiffies, timeout)) {
+			udelay(1);
+			if (gpiod_get_value(pdata->dvsok_gpio))
+				return 0;
+		}
+		gpiod_set_value(gpio, gpio_level);
+		pr_err("%s wait dvsok timeout\n", rdev->desc->name);
+		ret = -EBUSY;
+	}
+
+	return ret;
+}
+
+int rk808_buck1_2_set_voltage_time_sel(struct regulator_dev *rdev,
+				       unsigned int old_selector,
+				       unsigned int new_selector)
+{
+	struct rk808_regulator_data *pdata = rdev_get_drvdata(rdev);
+
+	/* if there is a dvsok pin, we don't need wait extra time here */
+	if (!IS_ERR(pdata->dvsok_gpio))
+		return 0;
+
+	return regulator_set_voltage_time_sel(rdev, old_selector, new_selector);
+}
+
 static int rk808_set_ramp_delay(struct regulator_dev *rdev, int ramp_delay)
 {
 	unsigned int ramp_value = RK808_RAMP_RATE_10MV_PER_US;
@@ -137,8 +241,9 @@ int rk808_set_suspend_disable(struct regulator_dev *rdev)
 static struct regulator_ops rk808_buck1_2_ops = {
 	.list_voltage		= regulator_list_voltage_linear_range,
 	.map_voltage		= regulator_map_voltage_linear_range,
-	.get_voltage_sel	= regulator_get_voltage_sel_regmap,
-	.set_voltage_sel	= regulator_set_voltage_sel_regmap,
+	.get_voltage_sel	= rk808_buck1_2_get_voltage_sel_regmap,
+	.set_voltage_sel	= rk808_buck1_2_set_voltage_sel,
+	.set_voltage_time_sel	= rk808_buck1_2_set_voltage_time_sel,
 	.enable			= regulator_enable_regmap,
 	.disable		= regulator_disable_regmap,
 	.is_enabled		= regulator_is_enabled_regmap,
@@ -372,25 +477,71 @@ static struct of_regulator_match rk808_reg_matches[] = {
 	[RK808_ID_SWITCH2]	= { .name = "SWITCH_REG2" },
 };
 
+int rk808_regulator_dt_parse_pdata(struct device *dev,
+				   struct device *client_dev,
+				   struct regmap *map,
+				   struct rk808_regulator_data *pdata)
+{
+	struct device_node *np;
+	int tmp, ret, i;
+
+	np = of_get_child_by_name(client_dev->of_node, "regulators");
+	if (!np)
+		return -ENXIO;
+
+	ret = of_regulator_match(dev, np, rk808_reg_matches,
+				 RK808_NUM_REGULATORS);
+	if (ret < 0)
+		goto dt_parse_end;
+
+	for (i = 0; i < ARRAY_SIZE(pdata->dvs_gpio); i++) {
+		pdata->dvs_gpio[i] = gpiod_get_index(client_dev, "dvs", i);
+		if (IS_ERR(pdata->dvs_gpio[i])) {
+			dev_warn(dev, "there is no dvs%d gpio\n", i);
+			continue;
+		}
+
+		gpiod_direction_output(pdata->dvs_gpio[i], 0);
+
+		tmp = i ? RK808_DVS2_POL : RK808_DVS1_POL;
+		ret = regmap_update_bits(map, RK808_IO_POL_REG, tmp,
+				gpiod_is_active_low(pdata->dvs_gpio[i]) ?
+				0 : tmp);
+	}
+
+	pdata->dvsok_gpio = gpiod_get_index(client_dev, "dvsok", 0);
+	if (IS_ERR(pdata->dvsok_gpio)) {
+		dev_warn(dev, "there is no dvs ok gpio\n");
+		goto dt_parse_end;
+	}
+
+	gpiod_direction_input(pdata->dvsok_gpio);
+
+dt_parse_end:
+	of_node_put(np);
+	return ret;
+}
+
 static int rk808_regulator_probe(struct platform_device *pdev)
 {
 	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
 	struct i2c_client *client = rk808->i2c;
-	struct device_node *reg_np;
 	struct regulator_config config = {};
 	struct regulator_dev *rk808_rdev;
+	struct rk808_regulator_data *pdata;
 	int ret, i;
 
-	reg_np = of_get_child_by_name(client->dev.of_node, "regulators");
-	if (!reg_np)
-		return -ENXIO;
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
 
-	ret = of_regulator_match(&pdev->dev, reg_np, rk808_reg_matches,
-				 RK808_NUM_REGULATORS);
-	of_node_put(reg_np);
+	ret = rk808_regulator_dt_parse_pdata(&pdev->dev, &client->dev,
+					     rk808->regmap, pdata);
 	if (ret < 0)
 		return ret;
 
+	platform_set_drvdata(pdev, pdata);
+
 	/* Instantiate the regulators */
 	for (i = 0; i < RK808_NUM_REGULATORS; i++) {
 		if (!rk808_reg_matches[i].init_data ||
@@ -398,7 +549,7 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 			continue;
 
 		config.dev = &client->dev;
-		config.driver_data = rk808;
+		config.driver_data = pdata;
 		config.regmap = rk808->regmap;
 		config.of_node = rk808_reg_matches[i].of_node;
 		config.init_data = rk808_reg_matches[i].init_data;
@@ -415,10 +566,27 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static int rk808_regulator_remove(struct platform_device *pdev)
+{
+	struct rk808_regulator_data *pdata = platform_get_drvdata(pdev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(pdata->dvs_gpio); i++) {
+		if (!IS_ERR(pdata->dvs_gpio[i]))
+			gpiod_put(pdata->dvs_gpio[i]);
+	}
+
+	if (!IS_ERR(pdata->dvsok_gpio))
+			gpiod_put(pdata->dvsok_gpio);
+	return 0;
+}
+
 static struct platform_driver rk808_regulator_driver = {
 	.probe = rk808_regulator_probe,
+	.remove = rk808_regulator_remove,
 	.driver = {
 		.name = "rk808-regulator",
+		.owner = THIS_MODULE,
 	},
 };
 
-- 
1.9.1

