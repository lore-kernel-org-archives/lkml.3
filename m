Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab3AYC0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:26:49 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:54839 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab3AYC0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:26:38 -0500
Message-ID: <1359080792.4232.8.camel@phoenix>
Subject: [PATCH 3/3] regulator: max8997: Fix using wrong dev argument at
 various places
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: MyungJoo Ham <myungjoo.ham@smasung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Fri, 25 Jan 2013 10:26:32 +0800
In-Reply-To: <1359080429.4232.3.camel@phoenix>
References: <1359080429.4232.3.camel@phoenix>
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
 drivers/regulator/max8997.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 1a1ae99..5556a15 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -891,7 +891,7 @@ static struct regulator_desc regulators[] = {
 };
 
 #ifdef CONFIG_OF
-static int max8997_pmic_dt_parse_dvs_gpio(struct max8997_dev *iodev,
+static int max8997_pmic_dt_parse_dvs_gpio(struct platform_device *pdev,
 			struct max8997_platform_data *pdata,
 			struct device_node *pmic_np)
 {
@@ -901,7 +901,7 @@ static int max8997_pmic_dt_parse_dvs_gpio(struct max8997_dev *iodev,
 		gpio = of_get_named_gpio(pmic_np,
 					"max8997,pmic-buck125-dvs-gpios", i);
 		if (!gpio_is_valid(gpio)) {
-			dev_err(iodev->dev, "invalid gpio[%d]: %d\n", i, gpio);
+			dev_err(&pdev->dev, "invalid gpio[%d]: %d\n", i, gpio);
 			return -EINVAL;
 		}
 		pdata->buck125_gpios[i] = gpio;
@@ -909,22 +909,23 @@ static int max8997_pmic_dt_parse_dvs_gpio(struct max8997_dev *iodev,
 	return 0;
 }
 
-static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
+static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct max8997_platform_data *pdata)
 {
+	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *pmic_np, *regulators_np, *reg_np;
 	struct max8997_regulator_data *rdata;
 	unsigned int i, dvs_voltage_nr = 1, ret;
 
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
 
@@ -933,11 +934,10 @@ static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
 	for_each_child_of_node(regulators_np, reg_np)
 		pdata->num_regulators++;
 
-	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
+	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 				pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
-		dev_err(iodev->dev, "could not allocate memory for "
-						"regulator data\n");
+		dev_err(&pdev->dev, "could not allocate memory for regulator data\n");
 		return -ENOMEM;
 	}
 
@@ -948,14 +948,14 @@ static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
 				break;
 
 		if (i == ARRAY_SIZE(regulators)) {
-			dev_warn(iodev->dev, "don't know how to configure "
-				"regulator %s\n", reg_np->name);
+			dev_warn(&pdev->dev, "don't know how to configure regulator %s\n",
+				 reg_np->name);
 			continue;
 		}
 
 		rdata->id = i;
-		rdata->initdata = of_get_regulator_init_data(
-						iodev->dev, reg_np);
+		rdata->initdata = of_get_regulator_init_data(&pdev->dev,
+							     reg_np);
 		rdata->reg_node = reg_np;
 		rdata++;
 	}
@@ -971,7 +971,7 @@ static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
 
 	if (pdata->buck1_gpiodvs || pdata->buck2_gpiodvs ||
 						pdata->buck5_gpiodvs) {
-		ret = max8997_pmic_dt_parse_dvs_gpio(iodev, pdata, pmic_np);
+		ret = max8997_pmic_dt_parse_dvs_gpio(pdev, pdata, pmic_np);
 		if (ret)
 			return -EINVAL;
 
@@ -982,8 +982,7 @@ static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
 		} else {
 			if (pdata->buck125_default_idx >= 8) {
 				pdata->buck125_default_idx = 0;
-				dev_info(iodev->dev, "invalid value for "
-				"default dvs index, using 0 instead\n");
+				dev_info(&pdev->dev, "invalid value for default dvs index, using 0 instead\n");
 			}
 		}
 
@@ -997,28 +996,28 @@ static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
 	if (of_property_read_u32_array(pmic_np,
 				"max8997,pmic-buck1-dvs-voltage",
 				pdata->buck1_voltage, dvs_voltage_nr)) {
-		dev_err(iodev->dev, "buck1 voltages not specified\n");
+		dev_err(&pdev->dev, "buck1 voltages not specified\n");
 		return -EINVAL;
 	}
 
 	if (of_property_read_u32_array(pmic_np,
 				"max8997,pmic-buck2-dvs-voltage",
 				pdata->buck2_voltage, dvs_voltage_nr)) {
-		dev_err(iodev->dev, "buck2 voltages not specified\n");
+		dev_err(&pdev->dev, "buck2 voltages not specified\n");
 		return -EINVAL;
 	}
 
 	if (of_property_read_u32_array(pmic_np,
 				"max8997,pmic-buck5-dvs-voltage",
 				pdata->buck5_voltage, dvs_voltage_nr)) {
-		dev_err(iodev->dev, "buck5 voltages not specified\n");
+		dev_err(&pdev->dev, "buck5 voltages not specified\n");
 		return -EINVAL;
 	}
 
 	return 0;
 }
 #else
-static int max8997_pmic_dt_parse_pdata(struct max8997_dev *iodev,
+static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct max8997_platform_data *pdata)
 {
 	return 0;
@@ -1042,7 +1041,7 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	}
 
 	if (iodev->dev->of_node) {
-		ret = max8997_pmic_dt_parse_pdata(iodev, pdata);
+		ret = max8997_pmic_dt_parse_pdata(pdev, pdata);
 		if (ret)
 			return ret;
 	}
-- 
1.7.9.5



