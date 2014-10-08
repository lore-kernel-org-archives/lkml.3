Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbaJHVUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:20:51 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:53050 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbaJHVUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:20:50 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH] regulator: rn5t618: Convert to new style DT parsing
Date: Wed,  8 Oct 2014 23:19:08 +0200
Message-Id: <1412803148-21255-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the simplified DT parsing method to remove some duplicated
code.

Since this is a MFD subdevice and its device object doesn't have an
associated DT node, the configuration instance used to register the
regulators has been changed to point to the parent device.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/regulator/rn5t618-regulator.c | 51 +++--------------------------------
 1 file changed, 4 insertions(+), 47 deletions(-)

diff --git a/drivers/regulator/rn5t618-regulator.c b/drivers/regulator/rn5t618-regulator.c
index e58d79a..b85ceb8 100644
--- a/drivers/regulator/rn5t618-regulator.c
+++ b/drivers/regulator/rn5t618-regulator.c
@@ -31,6 +31,8 @@ static struct regulator_ops rn5t618_reg_ops = {
 #define REG(rid, ereg, emask, vreg, vmask, min, max, step)		\
 	[RN5T618_##rid] = {						\
 		.name		= #rid,					\
+		.of_match	= of_match_ptr(#rid),			\
+		.regulators_node = of_match_ptr("regulators"),		\
 		.id		= RN5T618_##rid,			\
 		.type		= REGULATOR_VOLTAGE,			\
 		.owner		= THIS_MODULE,				\
@@ -60,60 +62,15 @@ static struct regulator_desc rn5t618_regulators[] = {
 	REG(LDORTC2, LDOEN2, BIT(5), LDORTC2DAC, 0x7f, 900000, 3500000, 25000),
 };
 
-static struct of_regulator_match rn5t618_matches[] = {
-	[RN5T618_DCDC1]		= { .name = "DCDC1" },
-	[RN5T618_DCDC2]		= { .name = "DCDC2" },
-	[RN5T618_DCDC3]		= { .name = "DCDC3" },
-	[RN5T618_LDO1]		= { .name = "LDO1" },
-	[RN5T618_LDO2]		= { .name = "LDO2" },
-	[RN5T618_LDO3]		= { .name = "LDO3" },
-	[RN5T618_LDO4]		= { .name = "LDO4" },
-	[RN5T618_LDO5]		= { .name = "LDO5" },
-	[RN5T618_LDORTC1]	= { .name = "LDORTC1" },
-	[RN5T618_LDORTC2]	= { .name = "LDORTC2" },
-};
-
-static int rn5t618_regulator_parse_dt(struct platform_device *pdev)
-{
-	struct device_node *np, *regulators;
-	int ret;
-
-	np = of_node_get(pdev->dev.parent->of_node);
-	if (!np)
-		return 0;
-
-	regulators = of_get_child_by_name(np, "regulators");
-	if (!regulators) {
-		dev_err(&pdev->dev, "regulators node not found\n");
-		return -EINVAL;
-	}
-
-	ret = of_regulator_match(&pdev->dev, regulators, rn5t618_matches,
-				 ARRAY_SIZE(rn5t618_matches));
-	of_node_put(regulators);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "error parsing regulator init data: %d\n",
-			ret);
-	}
-
-	return 0;
-}
-
 static int rn5t618_regulator_probe(struct platform_device *pdev)
 {
 	struct rn5t618 *rn5t618 = dev_get_drvdata(pdev->dev.parent);
 	struct regulator_config config = { };
 	struct regulator_dev *rdev;
-	int ret, i;
-
-	ret = rn5t618_regulator_parse_dt(pdev);
-	if (ret)
-		return ret;
+	int i;
 
 	for (i = 0; i < RN5T618_REG_NUM; i++) {
-		config.dev = &pdev->dev;
-		config.init_data = rn5t618_matches[i].init_data;
-		config.of_node = rn5t618_matches[i].of_node;
+		config.dev = pdev->dev.parent;
 		config.regmap = rn5t618->regmap;
 
 		rdev = devm_regulator_register(&pdev->dev,
-- 
1.9.1

