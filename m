Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3A0NRF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 08:17:05 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34784 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712Ab3A0NRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 08:17:02 -0500
Message-ID: <1359292616.11083.7.camel@phoenix>
Subject: [RFT][PATCH v2] regulator: Add missing of_node_put()
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        David Dajun Chen <dchen@diasemi.com>,
        Gyungoh Yoo <jack.yoo@maxim-ic.com>,
        MyungJoo Ham <myungjoo.ham@smasung.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Shawn Guo <shawn.guo@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 27 Jan 2013 21:16:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name() returns a node pointer with refcount incremented, use
of_node_put() on it when done.

of_find_node_by_name() will call of_node_put() against from parameter,
thus we also need to call of_node_get(from) before calling
of_find_node_by_name().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: David Dajun Chen <dchen@diasemi.com>
Cc: Gyungoh Yoo <jack.yoo@maxim-ic.com>
Cc: MyungJoo Ham <myungjoo.ham@smasung.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
v2:
need to call of_node_get() for the node to start searching from before calling
of_find_node_by_name().

 drivers/regulator/88pm8607.c               |    3 ++-
 drivers/regulator/da9052-regulator.c       |    5 +++--
 drivers/regulator/max8907-regulator.c      |    7 ++++---
 drivers/regulator/max8925-regulator.c      |    3 ++-
 drivers/regulator/max8997.c                |    4 +++-
 drivers/regulator/mc13xxx-regulator-core.c |    7 ++++++-
 drivers/regulator/palmas-regulator.c       |    2 ++
 drivers/regulator/tps65910-regulator.c     |    6 ++++--
 8 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index a957e8c..c79ab84 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -347,7 +347,7 @@ static int pm8607_regulator_dt_init(struct platform_device *pdev,
 				    struct regulator_config *config)
 {
 	struct device_node *nproot, *np;
-	nproot = pdev->dev.parent->of_node;
+	nproot = of_node_get(pdev->dev.parent->of_node);
 	if (!nproot)
 		return -ENODEV;
 	nproot = of_find_node_by_name(nproot, "regulators");
@@ -363,6 +363,7 @@ static int pm8607_regulator_dt_init(struct platform_device *pdev,
 			break;
 		}
 	}
+	of_node_put(nproot);
 	return 0;
 }
 #else
diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index c6d8651..96b569a 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -366,9 +366,9 @@ static int da9052_regulator_probe(struct platform_device *pdev)
 		config.init_data = pdata->regulators[pdev->id];
 	} else {
 #ifdef CONFIG_OF
-		struct device_node *nproot = da9052->dev->of_node;
-		struct device_node *np;
+		struct device_node *nproot, *np;
 
+		nproot = of_node_get(da9052->dev->of_node);
 		if (!nproot)
 			return -ENODEV;
 
@@ -385,6 +385,7 @@ static int da9052_regulator_probe(struct platform_device *pdev)
 				break;
 			}
 		}
+		of_node_put(nproot);
 #endif
 	}
 
diff --git a/drivers/regulator/max8907-regulator.c b/drivers/regulator/max8907-regulator.c
index d40cf7f..4568c15 100644
--- a/drivers/regulator/max8907-regulator.c
+++ b/drivers/regulator/max8907-regulator.c
@@ -224,11 +224,11 @@ static struct of_regulator_match max8907_matches[] = {
 
 static int max8907_regulator_parse_dt(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.parent->of_node;
-	struct device_node *regulators;
+	struct device_node *np, *regulators;
 	int ret;
 
-	if (!pdev->dev.parent->of_node)
+	np = of_node_get(pdev->dev.parent->of_node);
+	if (!np)
 		return 0;
 
 	regulators = of_find_node_by_name(np, "regulators");
@@ -239,6 +239,7 @@ static int max8907_regulator_parse_dt(struct platform_device *pdev)
 
 	ret = of_regulator_match(&pdev->dev, regulators, max8907_matches,
 				 ARRAY_SIZE(max8907_matches));
+	of_node_put(regulators);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
 			ret);
diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index 446a854..0d5f64a 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -252,7 +252,7 @@ static int max8925_regulator_dt_init(struct platform_device *pdev,
 {
 	struct device_node *nproot, *np;
 	int rcount;
-	nproot = pdev->dev.parent->of_node;
+	nproot = of_node_get(pdev->dev.parent->of_node);
 	if (!nproot)
 		return -ENODEV;
 	np = of_find_node_by_name(nproot, "regulators");
@@ -263,6 +263,7 @@ static int max8925_regulator_dt_init(struct platform_device *pdev,
 
 	rcount = of_regulator_match(&pdev->dev, np,
 				&max8925_regulator_matches[ridx], 1);
+	of_node_put(np);
 	if (rcount < 0)
 		return -ENODEV;
 	config->init_data =	max8925_regulator_matches[ridx].init_data;
diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 5556a15..91f38d8 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -917,7 +917,7 @@ static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 	struct max8997_regulator_data *rdata;
 	unsigned int i, dvs_voltage_nr = 1, ret;
 
-	pmic_np = iodev->dev->of_node;
+	pmic_np = of_node_get(iodev->dev->of_node);
 	if (!pmic_np) {
 		dev_err(&pdev->dev, "could not find pmic sub-node\n");
 		return -ENODEV;
@@ -937,6 +937,7 @@ static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 				pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
+		of_node_put(regulators_np);
 		dev_err(&pdev->dev, "could not allocate memory for regulator data\n");
 		return -ENOMEM;
 	}
@@ -959,6 +960,7 @@ static int max8997_pmic_dt_parse_pdata(struct platform_device *pdev,
 		rdata->reg_node = reg_np;
 		rdata++;
 	}
+	of_node_put(regulators_np);
 
 	if (of_get_property(pmic_np, "max8997,pmic-buck1-uses-gpio-dvs", NULL))
 		pdata->buck1_gpiodvs = true;
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 2ecf1d8..5d2ab2e 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -175,6 +175,7 @@ int mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
 	for_each_child_of_node(parent, child)
 		num++;
 
+	of_node_put(parent);
 	return num;
 }
 EXPORT_SYMBOL_GPL(mc13xxx_get_num_regulators_dt);
@@ -197,8 +198,11 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data) * priv->num_regulators,
 			    GFP_KERNEL);
-	if (!data)
+	if (!data) {
+		of_node_put(parent);
 		return NULL;
+	}
+
 	p = data;
 
 	for_each_child_of_node(parent, child) {
@@ -217,6 +221,7 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 			}
 		}
 	}
+	of_node_put(parent);
 
 	*num_parsed = parsed;
 	return data;
diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index c9e912f..cbaf226 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -527,6 +527,7 @@ static void palmas_dt_to_pdata(struct device *dev,
 	u32 prop;
 	int idx, ret;
 
+	node = of_node_get(node);
 	regulators = of_find_node_by_name(node, "regulators");
 	if (!regulators) {
 		dev_info(dev, "regulator node not found\n");
@@ -535,6 +536,7 @@ static void palmas_dt_to_pdata(struct device *dev,
 
 	ret = of_regulator_match(dev, regulators, palmas_matches,
 			PALMAS_NUM_REGS);
+	of_node_put(regulators);
 	if (ret < 0) {
 		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
 		return;
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index b0e4c0b..6ba6931 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -964,8 +964,7 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 {
 	struct tps65910_board *pmic_plat_data;
 	struct tps65910 *tps65910 = dev_get_drvdata(pdev->dev.parent);
-	struct device_node *np = pdev->dev.parent->of_node;
-	struct device_node *regulators;
+	struct device_node *np, *regulators;
 	struct of_regulator_match *matches;
 	unsigned int prop;
 	int idx = 0, ret, count;
@@ -978,6 +977,7 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 		return NULL;
 	}
 
+	np = of_node_get(pdev->dev.parent->of_node);
 	regulators = of_find_node_by_name(np, "regulators");
 	if (!regulators) {
 		dev_err(&pdev->dev, "regulator node not found\n");
@@ -994,11 +994,13 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 		matches = tps65911_matches;
 		break;
 	default:
+		of_node_put(regulators);
 		dev_err(&pdev->dev, "Invalid tps chip version\n");
 		return NULL;
 	}
 
 	ret = of_regulator_match(&pdev->dev, regulators, matches, count);
+	of_node_put(regulators);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
 			ret);
-- 
1.7.9.5



