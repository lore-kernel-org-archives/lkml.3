Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3BFC5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 21:57:00 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:64759 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab3BFC47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 21:56:59 -0500
Message-ID: <1360119412.8965.3.camel@phoenix>
Subject: [PATCH 2/3] regulator: s5m8767: Fix using wrong dev argument at
 various places
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, LiamGirdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 10:56:52 +0800
In-Reply-To: <1360119305.8965.1.camel@phoenix>
References: <1360119305.8965.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use &pdev->dev rather than iodev->dev for dev_err(), dev_warn() and dev_info().
Use &pdev->dev rather than iodev->dev for devm_kzalloc() and
of_get_regulator_init_data(), this fixes memory leak.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s5m8767.c |   47 ++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 194b5dd..4cb65e3 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -479,7 +479,7 @@ static struct regulator_desc regulators[] = {
 };
 
 #ifdef CONFIG_OF
-static int s5m8767_pmic_dt_parse_dvs_gpio(struct sec_pmic_dev *iodev,
+static int s5m8767_pmic_dt_parse_dvs_gpio(struct platform_device *pdev,
 			struct sec_platform_data *pdata,
 			struct device_node *pmic_np)
 {
@@ -489,7 +489,7 @@ static int s5m8767_pmic_dt_parse_dvs_gpio(struct sec_pmic_dev *iodev,
 		gpio = of_get_named_gpio(pmic_np,
 					"s5m8767,pmic-buck-dvs-gpios", i);
 		if (!gpio_is_valid(gpio)) {
-			dev_err(iodev->dev, "invalid gpio[%d]: %d\n", i, gpio);
+			dev_err(&pdev->dev, "invalid gpio[%d]: %d\n", i, gpio);
 			return -EINVAL;
 		}
 		pdata->buck_gpios[i] = gpio;
@@ -497,7 +497,7 @@ static int s5m8767_pmic_dt_parse_dvs_gpio(struct sec_pmic_dev *iodev,
 	return 0;
 }
 
-static int s5m8767_pmic_dt_parse_ds_gpio(struct sec_pmic_dev *iodev,
+static int s5m8767_pmic_dt_parse_ds_gpio(struct platform_device *pdev,
 			struct sec_platform_data *pdata,
 			struct device_node *pmic_np)
 {
@@ -507,7 +507,7 @@ static int s5m8767_pmic_dt_parse_ds_gpio(struct sec_pmic_dev *iodev,
 		gpio = of_get_named_gpio(pmic_np,
 					"s5m8767,pmic-buck-ds-gpios", i);
 		if (!gpio_is_valid(gpio)) {
-			dev_err(iodev->dev, "invalid gpio[%d]: %d\n", i, gpio);
+			dev_err(&pdev->dev, "invalid gpio[%d]: %d\n", i, gpio);
 			return -EINVAL;
 		}
 		pdata->buck_ds[i] = gpio;
@@ -515,9 +515,10 @@ static int s5m8767_pmic_dt_parse_ds_gpio(struct sec_pmic_dev *iodev,
 	return 0;
 }
 
-static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
+static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct sec_platform_data *pdata)
 {
+	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *pmic_np, *regulators_np, *reg_np;
 	struct sec_regulator_data *rdata;
 	struct sec_opmode_data *rmode;
@@ -525,31 +526,31 @@ static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
 
 	pmic_np = iodev->dev->of_node;
 	if (!pmic_np) {
-		dev_err(iodev->dev, "could not find pmic sub-node\n");
+		dev_err(&pdev->dev, "could not find pmic sub-node\n");
 		return -ENODEV;
 	}
 
 	regulators_np = of_find_node_by_name(pmic_np, "regulators");
 	if (!regulators_np) {
-		dev_err(iodev->dev, "could not find regulators sub-node\n");
+		dev_err(&pdev->dev, "could not find regulators sub-node\n");
 		return -EINVAL;
 	}
 
 	/* count the number of regulators to be supported in pmic */
 	pdata->num_regulators = of_get_child_count(regulators_np);
 
-	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
+	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 				pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
-		dev_err(iodev->dev,
+		dev_err(&pdev->dev,
 			"could not allocate memory for regulator data\n");
 		return -ENOMEM;
 	}
 
-	rmode = devm_kzalloc(iodev->dev, sizeof(*rmode) *
+	rmode = devm_kzalloc(&pdev->dev, sizeof(*rmode) *
 				pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
-		dev_err(iodev->dev,
+		dev_err(&pdev->dev,
 			"could not allocate memory for regulator mode\n");
 		return -ENOMEM;
 	}
@@ -562,7 +563,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
 				break;
 
 		if (i == ARRAY_SIZE(regulators)) {
-			dev_warn(iodev->dev,
+			dev_warn(&pdev->dev,
 			"don't know how to configure regulator %s\n",
 			reg_np->name);
 			continue;
@@ -570,13 +571,13 @@ static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
 
 		rdata->id = i;
 		rdata->initdata = of_get_regulator_init_data(
-						iodev->dev, reg_np);
+						&pdev->dev, reg_np);
 		rdata->reg_node = reg_np;
 		rdata++;
 		rmode->id = i;
 		if (of_property_read_u32(reg_np, "op_mode",
 				&rmode->mode)) {
-			dev_warn(iodev->dev,
+			dev_warn(&pdev->dev,
 				"no op_mode property property at %s\n",
 				reg_np->full_name);
 
@@ -596,7 +597,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
 
 	if (pdata->buck2_gpiodvs || pdata->buck3_gpiodvs ||
 						pdata->buck4_gpiodvs) {
-		ret = s5m8767_pmic_dt_parse_dvs_gpio(iodev, pdata, pmic_np);
+		ret = s5m8767_pmic_dt_parse_dvs_gpio(pdev, pdata, pmic_np);
 		if (ret)
 			return -EINVAL;
 
@@ -607,42 +608,42 @@ static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
 		} else {
 			if (pdata->buck_default_idx >= 8) {
 				pdata->buck_default_idx = 0;
-				dev_info(iodev->dev,
+				dev_info(&pdev->dev,
 				"invalid value for default dvs index, use 0\n");
 			}
 		}
 		dvs_voltage_nr = 8;
 	}
 
-	ret = s5m8767_pmic_dt_parse_ds_gpio(iodev, pdata, pmic_np);
+	ret = s5m8767_pmic_dt_parse_ds_gpio(pdev, pdata, pmic_np);
 	if (ret)
 		return -EINVAL;
 
 	if (of_property_read_u32_array(pmic_np,
 				"s5m8767,pmic-buck2-dvs-voltage",
 				pdata->buck2_voltage, dvs_voltage_nr)) {
-		dev_err(iodev->dev, "buck2 voltages not specified\n");
+		dev_err(&pdev->dev, "buck2 voltages not specified\n");
 		return -EINVAL;
 	}
 
 	if (of_property_read_u32_array(pmic_np,
 				"s5m8767,pmic-buck3-dvs-voltage",
 				pdata->buck3_voltage, dvs_voltage_nr)) {
-		dev_err(iodev->dev, "buck3 voltages not specified\n");
+		dev_err(&pdev->dev, "buck3 voltages not specified\n");
 		return -EINVAL;
 	}
 
 	if (of_property_read_u32_array(pmic_np,
 				"s5m8767,pmic-buck4-dvs-voltage",
 				pdata->buck4_voltage, dvs_voltage_nr)) {
-		dev_err(iodev->dev, "buck4 voltages not specified\n");
+		dev_err(&pdev->dev, "buck4 voltages not specified\n");
 		return -EINVAL;
 	}
 
 	return 0;
 }
 #else
-static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
+static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct sec_platform_data *pdata)
 {
 	return 0;
@@ -659,13 +660,13 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	int i, ret, size, buck_init;
 
 	if (iodev->dev->of_node) {
-		ret = s5m8767_pmic_dt_parse_pdata(iodev, pdata);
+		ret = s5m8767_pmic_dt_parse_pdata(pdev, pdata);
 		if (ret)
 			return ret;
 	}
 
 	if (!pdata) {
-		dev_err(pdev->dev.parent, "Platform data not supplied\n");
+		dev_err(&pdev->dev, "Platform data not supplied\n");
 		return -ENODEV;
 	}
 
-- 
1.7.9.5



