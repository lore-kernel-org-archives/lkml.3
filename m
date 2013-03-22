Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab3CVQQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:16:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56756 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704Ab3CVQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:16:07 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        devicetree-discuss@lists.ozlabs.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v3 2/3] regulator: as3711: add OF support
Date: Fri, 22 Mar 2013 17:15:48 +0100
Message-Id: <1363968949-12151-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
References: <1363968949-12151-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:1MjF/hgnUROfM9EgsXsrBr+mh3RkoH2OxabQxX4WwZf
 gxmuepXu6tVbFmaAwi2O3e32RFboJIm8/nDf0BHZ2Shprxt4hi
 3ybjtdjFO67FiJgV4ZhdXBD90GXGOQK/Fbb3/BKf3ieR7nutKd
 kGmEsK12xlx/0FvZz5/P6VYP6a0QeAnLPwSIetfbtw7lsHVBKJ
 yi864KUOg2NQT16UL+lPxs44ojp04lzJ/Pjg05Tfphsdo6S+pt
 qEqV2tJLikr/XMQJB9DVe4n2Wttxlbzfz1+OreMInLx9H2BrUQ
 ZzYr6wE1Ihg+AUmErXRcKsC13DI8cJnxk+T4AH2Z42HfRlSiSk
 jqCnZvaclyWxRny6RRbIAiN1v/XkBXQlLuxapy5h36RmmcG7c8
 HGwL2gbG9I+DA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AS3711 regulator OF support only evaluates standard regulator DT
properties.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/as3711-regulator.c |   74 ++++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index f0ba8c4..0539b3e 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -13,9 +13,11 @@
 #include <linux/init.h>
 #include <linux/mfd/as3711.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <linux/regulator/driver.h>
+#include <linux/regulator/of_regulator.h>
 #include <linux/slab.h>
 
 struct as3711_regulator_info {
@@ -276,6 +278,60 @@ static struct as3711_regulator_info as3711_reg_info[] = {
 
 #define AS3711_REGULATOR_NUM ARRAY_SIZE(as3711_reg_info)
 
+static const char *as3711_regulator_of_names[AS3711_REGULATOR_NUM] = {
+	[AS3711_REGULATOR_SD_1] = "sd1",
+	[AS3711_REGULATOR_SD_2] = "sd2",
+	[AS3711_REGULATOR_SD_3] = "sd3",
+	[AS3711_REGULATOR_SD_4] = "sd4",
+	[AS3711_REGULATOR_LDO_1] = "ldo1",
+	[AS3711_REGULATOR_LDO_2] = "ldo2",
+	[AS3711_REGULATOR_LDO_3] = "ldo3",
+	[AS3711_REGULATOR_LDO_4] = "ldo4",
+	[AS3711_REGULATOR_LDO_5] = "ldo5",
+	[AS3711_REGULATOR_LDO_6] = "ldo6",
+	[AS3711_REGULATOR_LDO_7] = "ldo7",
+	[AS3711_REGULATOR_LDO_8] = "ldo8",
+};
+
+static int as3711_regulator_parse_dt(struct device *dev,
+				struct device_node **of_node, const int count)
+{
+	struct as3711_regulator_pdata *pdata = dev_get_platdata(dev);
+	struct device_node *regulators =
+		of_find_node_by_name(dev->parent->of_node, "regulators");
+	struct of_regulator_match *matches, *match;
+	int ret, i;
+
+	if (!regulators) {
+		dev_err(dev, "regulator node not found\n");
+		return -ENODEV;
+	}
+
+	matches = devm_kzalloc(dev, sizeof(*matches) * count, GFP_KERNEL);
+	if (!matches)
+		return -ENOMEM;
+
+	for (i = 0, match = matches; i < count; i++, match++) {
+		match->name = as3711_regulator_of_names[i];
+		match->driver_data = as3711_reg_info + i;
+	}
+
+	ret = of_regulator_match(dev->parent, regulators, matches, count);
+	of_node_put(regulators);
+	if (ret < 0) {
+		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
+		return ret;
+	}
+
+	for (i = 0, match = matches; i < count; i++, match++)
+		if (match->of_node) {
+			pdata->init_data[i] = match->init_data;
+			of_node[i] = match->of_node;
+		}
+
+	return 0;
+}
+
 static int as3711_regulator_probe(struct platform_device *pdev)
 {
 	struct as3711_regulator_pdata *pdata = dev_get_platdata(&pdev->dev);
@@ -284,13 +340,24 @@ static int as3711_regulator_probe(struct platform_device *pdev)
 	struct regulator_config config = {.dev = &pdev->dev,};
 	struct as3711_regulator *reg = NULL;
 	struct as3711_regulator *regs;
+	struct device_node *of_node[AS3711_REGULATOR_NUM] = {};
 	struct regulator_dev *rdev;
 	struct as3711_regulator_info *ri;
 	int ret;
 	int id;
 
-	if (!pdata)
-		dev_dbg(&pdev->dev, "No platform data...\n");
+	if (!pdata) {
+		dev_err(&pdev->dev, "No platform data...\n");
+		return -ENODEV;
+	}
+
+	if (pdev->dev.parent->of_node) {
+		ret = as3711_regulator_parse_dt(&pdev->dev, of_node, AS3711_REGULATOR_NUM);
+		if (ret < 0) {
+			dev_err(&pdev->dev, "DT parsing failed: %d\n", ret);
+			return ret;
+		}
+	}
 
 	regs = devm_kzalloc(&pdev->dev, AS3711_REGULATOR_NUM *
 			sizeof(struct as3711_regulator), GFP_KERNEL);
@@ -300,7 +367,7 @@ static int as3711_regulator_probe(struct platform_device *pdev)
 	}
 
 	for (id = 0, ri = as3711_reg_info; id < AS3711_REGULATOR_NUM; ++id, ri++) {
-		reg_data = pdata ? pdata->init_data[id] : NULL;
+		reg_data = pdata->init_data[id];
 
 		/* No need to register if there is no regulator data */
 		if (!reg_data)
@@ -312,6 +379,7 @@ static int as3711_regulator_probe(struct platform_device *pdev)
 		config.init_data = reg_data;
 		config.driver_data = reg;
 		config.regmap = as3711->regmap;
+		config.of_node = of_node[id];
 
 		rdev = regulator_register(&ri->desc, &config);
 		if (IS_ERR(rdev)) {
-- 
1.7.2.5

