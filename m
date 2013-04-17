Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936295Ab3DQChd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 22:37:33 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:58537 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936226Ab3DQChc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 22:37:32 -0400
Message-ID: <1366166245.9682.1.camel@phoenix>
Subject: [PATCH] regulator: as3711: Use a static of_regulator_match table
 for of_regulator_match
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Apr 2013 10:37:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same table can be used for multiple instance of pdev, so we don't need to
allocate memory for of_regulator_match table per pdev.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/as3711-regulator.c |   46 ++++++++++++++--------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/regulator/as3711-regulator.c b/drivers/regulator/as3711-regulator.c
index 0539b3e..dd1a089 100644
--- a/drivers/regulator/as3711-regulator.c
+++ b/drivers/regulator/as3711-regulator.c
@@ -278,52 +278,44 @@ static struct as3711_regulator_info as3711_reg_info[] = {
 
 #define AS3711_REGULATOR_NUM ARRAY_SIZE(as3711_reg_info)
 
-static const char *as3711_regulator_of_names[AS3711_REGULATOR_NUM] = {
-	[AS3711_REGULATOR_SD_1] = "sd1",
-	[AS3711_REGULATOR_SD_2] = "sd2",
-	[AS3711_REGULATOR_SD_3] = "sd3",
-	[AS3711_REGULATOR_SD_4] = "sd4",
-	[AS3711_REGULATOR_LDO_1] = "ldo1",
-	[AS3711_REGULATOR_LDO_2] = "ldo2",
-	[AS3711_REGULATOR_LDO_3] = "ldo3",
-	[AS3711_REGULATOR_LDO_4] = "ldo4",
-	[AS3711_REGULATOR_LDO_5] = "ldo5",
-	[AS3711_REGULATOR_LDO_6] = "ldo6",
-	[AS3711_REGULATOR_LDO_7] = "ldo7",
-	[AS3711_REGULATOR_LDO_8] = "ldo8",
+static struct of_regulator_match as3711_regulator_matches[] = {
+	{ .name = "sd1" },
+	{ .name = "sd2" },
+	{ .name = "sd3" },
+	{ .name = "sd4" },
+	{ .name = "ldo1" },
+	{ .name = "ldo2" },
+	{ .name = "ldo3" },
+	{ .name = "ldo4" },
+	{ .name = "ldo5" },
+	{ .name = "ldo6" },
+	{ .name = "ldo7" },
+	{ .name = "ldo8" },
 };
 
 static int as3711_regulator_parse_dt(struct device *dev,
 				struct device_node **of_node, const int count)
 {
 	struct as3711_regulator_pdata *pdata = dev_get_platdata(dev);
-	struct device_node *regulators =
-		of_find_node_by_name(dev->parent->of_node, "regulators");
-	struct of_regulator_match *matches, *match;
+	struct device_node *regulators;
+	struct of_regulator_match *match;
 	int ret, i;
 
+	regulators = of_find_node_by_name(dev->parent->of_node, "regulators");
 	if (!regulators) {
 		dev_err(dev, "regulator node not found\n");
 		return -ENODEV;
 	}
 
-	matches = devm_kzalloc(dev, sizeof(*matches) * count, GFP_KERNEL);
-	if (!matches)
-		return -ENOMEM;
-
-	for (i = 0, match = matches; i < count; i++, match++) {
-		match->name = as3711_regulator_of_names[i];
-		match->driver_data = as3711_reg_info + i;
-	}
-
-	ret = of_regulator_match(dev->parent, regulators, matches, count);
+	ret = of_regulator_match(dev->parent, regulators,
+				 as3711_regulator_matches, count);
 	of_node_put(regulators);
 	if (ret < 0) {
 		dev_err(dev, "Error parsing regulator init data: %d\n", ret);
 		return ret;
 	}
 
-	for (i = 0, match = matches; i < count; i++, match++)
+	for (i = 0, match = as3711_regulator_matches; i < count; i++, match++)
 		if (match->of_node) {
 			pdata->init_data[i] = match->init_data;
 			of_node[i] = match->of_node;
-- 
1.7.10.4



