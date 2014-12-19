Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaLSJ3l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:29:41 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63310 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaLSJ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:29:38 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-cb-5493f0005dbe
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] regulator: max77693: Let core parse DT and drop board
 files support
Date: Fri, 19 Dec 2014 10:29:18 +0100
Message-id: <1418981359-16457-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418981359-16457-1-git-send-email-k.kozlowski@samsung.com>
References: <1418981359-16457-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xq7oMHyaHGMz6bGEx9eETNovXLwwt
	7n89ymjx7UoHk8XlXXPYLE53szqweeycdZfdY9OqTjaPO9f2sHnMOxno0bdlFaPH501yAWxR
	XDYpqTmZZalF+nYJXBmb3lxlLDipUNF2fg1LA+MaqS5GTg4JAROJju8P2CBsMYkL99YD2Vwc
	QgJLGSXuz5nEDuH0MUm0vvjBCFLFJmAssXn5ErAqEYFNjBIdjxeDJZgFDCV+vvvDDmILC0RJ
	bFi8Gmwsi4CqxL8/08HivALuEkuPnIVaJydx8thkVhCbU8BD4s2OiWBxIaCavfvvMk1g5F3A
	yLCKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIySkvu5gXHrM6hCjAAejEg/vh8bJIUKsiWXF
	lbmHGCU4mJVEeB2PA4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUwMkQeTz5r+2DVv+hb5lWZhXPW
	60vdW/VyhXBxZeCC3F5l/YWiTydqvti47PreNdcmWVQejimMCLrH97w8INd/z6zdJSq1DwuP
	+RZGHOzTv2H9r8X+4TXtJcvDZkbOeMTytDAhba5BeNVKZ8XF3/ertcW6Gb9ad6pB7vTfnrZP
	7XJpAcEJu10/K7EUZyQaajEXFScCAAVuVecHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify the driver by removing board file support and letting
regulator core to parse DT.

The max77693 regulator driver is used only on Exynos based boards which
are DT-only. Board files are not supported.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77693.c | 93 +++++---------------------------------------
 1 file changed, 9 insertions(+), 84 deletions(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index 07b313e51b21..9665a488e2f1 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -128,6 +128,8 @@ static struct regulator_ops max77693_charger_ops = {
 #define regulator_desc_esafeout(_num)	{			\
 	.name		= "ESAFEOUT"#_num,			\
 	.id		= MAX77693_ESAFEOUT##_num,		\
+	.of_match	= of_match_ptr("ESAFEOUT"#_num),	\
+	.regulators_node	= of_match_ptr("regulators"),	\
 	.n_voltages	= 4,					\
 	.ops		= &max77693_safeout_ops,		\
 	.type		= REGULATOR_VOLTAGE,			\
@@ -145,6 +147,8 @@ static const struct regulator_desc regulators[] = {
 	{
 		.name = "CHARGER",
 		.id = MAX77693_CHARGER,
+		.of_match = of_match_ptr("CHARGER"),
+		.regulators_node = of_match_ptr("regulators"),
 		.ops = &max77693_charger_ops,
 		.type = REGULATOR_CURRENT,
 		.owner = THIS_MODULE,
@@ -154,102 +158,23 @@ static const struct regulator_desc regulators[] = {
 	},
 };
 
-#ifdef CONFIG_OF
-static int max77693_pmic_dt_parse_rdata(struct device *dev,
-					struct max77693_regulator_data **rdata)
-{
-	struct device_node *np;
-	struct of_regulator_match *rmatch;
-	struct max77693_regulator_data *tmp;
-	int i, matched = 0;
-
-	np = of_get_child_by_name(dev->parent->of_node, "regulators");
-	if (!np)
-		return -EINVAL;
-
-	rmatch = devm_kzalloc(dev,
-		 sizeof(*rmatch) * ARRAY_SIZE(regulators), GFP_KERNEL);
-	if (!rmatch) {
-		of_node_put(np);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(regulators); i++)
-		rmatch[i].name = regulators[i].name;
-
-	matched = of_regulator_match(dev, np, rmatch, ARRAY_SIZE(regulators));
-	of_node_put(np);
-	if (matched <= 0)
-		return matched;
-	*rdata = devm_kzalloc(dev, sizeof(**rdata) * matched, GFP_KERNEL);
-	if (!(*rdata))
-		return -ENOMEM;
-
-	tmp = *rdata;
-
-	for (i = 0; i < matched; i++) {
-		tmp->initdata = rmatch[i].init_data;
-		tmp->of_node = rmatch[i].of_node;
-		tmp->id = regulators[i].id;
-		tmp++;
-	}
-
-	return matched;
-}
-#else
-static int max77693_pmic_dt_parse_rdata(struct device *dev,
-					struct max77693_regulator_data **rdata)
-{
-	return 0;
-}
-#endif /* CONFIG_OF */
-
-static int max77693_pmic_init_rdata(struct device *dev,
-				    struct max77693_regulator_data **rdata)
-{
-	struct max77693_platform_data *pdata;
-	int num_regulators = 0;
-
-	pdata = dev_get_platdata(dev->parent);
-	if (pdata) {
-		*rdata = pdata->regulators;
-		num_regulators = pdata->num_regulators;
-	}
-
-	if (!(*rdata) && dev->parent->of_node)
-		num_regulators = max77693_pmic_dt_parse_rdata(dev, rdata);
-
-	return num_regulators;
-}
-
 static int max77693_pmic_probe(struct platform_device *pdev)
 {
 	struct max77693_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max77693_regulator_data *rdata = NULL;
-	int num_rdata, i;
+	int i;
 	struct regulator_config config = { };
 
-	num_rdata = max77693_pmic_init_rdata(&pdev->dev, &rdata);
-	if (!rdata || num_rdata <= 0) {
-		dev_err(&pdev->dev, "No init data supplied.\n");
-		return -ENODEV;
-	}
-
-	config.dev = &pdev->dev;
+	config.dev = iodev->dev;
 	config.regmap = iodev->regmap;
 
-	for (i = 0; i < num_rdata; i++) {
-		int id = rdata[i].id;
+	for (i = 0; i < ARRAY_SIZE(regulators); i++) {
 		struct regulator_dev *rdev;
 
-		config.init_data = rdata[i].initdata;
-		config.of_node = rdata[i].of_node;
-
 		rdev = devm_regulator_register(&pdev->dev,
-						&regulators[id], &config);
+						&regulators[i], &config);
 		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev,
-				"Failed to initialize regulator-%d\n", id);
+				"Failed to initialize regulator-%d\n", i);
 			return PTR_ERR(rdev);
 		}
 	}
-- 
1.9.1

