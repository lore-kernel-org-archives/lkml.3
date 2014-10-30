Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199AbaJ3LZC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:25:02 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42895 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157AbaJ3LVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:25 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-3f-54521f3267f8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFT v3 06/14] regulator: max77802: Remove support for board files
Date: Thu, 30 Oct 2014 12:20:45 +0100
Message-id: <1414668053-31370-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xq7pG8kEhBv/2GVlsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK2LzsKXNBs1XFsfO3WBsY5+p1
	MXJySAiYSMx5s4cdwhaTuHBvPVsXIxeHkMBSRom3S3cxQzh9TBLTv3WzgFSxCRhLbF6+BKxK
	RKCTWaLnYC9YFbPAaiaJn1dOMYNUCQt4S7xY18cGYrMIqEo0XHoLZvMKuEtcPPOHDWKfnMTJ
	Y5NZQWxOAQ+JNR/bgWwOoHXuEve+aU9g5F3AyLCKUTS1NLmgOCk911CvODG3uDQvXS85P3cT
	IyTEv+xgXHzM6hCjAAejEg+vw8aAECHWxLLiytxDjBIczEoivKvFgkKEeFMSK6tSi/Lji0pz
	UosPMTJxcEo1MHb/ZnJasvPaBG7GMi2b1MuZjwq0nx7tZtmS/Nil7+zSqf/4flSoSTLnrr3Y
	1qqTePhfSOTioxIJmoZZ3ZXh5Q82bHGt7rGoz2m4uY7NxoTvssq1ad1GQX7TT1wO7eepd3xU
	3+lxUU741HuZMqHdTWf8LVqM3n/i3DV7umzwDFV2M5ZLhRvylFiKMxINtZiLihMBmBQVe08C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used only on Exynos based boards with DTS support.
Convert the driver to DTS-only version. Parse all regulators at once,
not one-by-one. Remove dependency on data provided by max77686 MFD
driver.

Use new DT style parsing method for regulators init data. The regulator
driver now should have its own of_compatible property. If it is not
present then it will use "regulators" sub-node of parent's node.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77802.c | 108 +++++++++++++++----------------------------
 1 file changed, 37 insertions(+), 71 deletions(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 60daca2028e9..2cb938610230 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -70,7 +70,9 @@ static unsigned int ramp_table_77802_4bit[] = {
 };
 
 struct max77802_regulator_prv {
+	/* Array indexed by regulator id */
 	unsigned int opmode[MAX77802_REG_MAX];
+	bool missing_of_node;
 };
 
 static inline int max77802_map_mode(int mode)
@@ -362,6 +364,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* LDOs 3-7, 9-14, 18-26, 28, 29, 32-34 */
 #define regulator_77802_desc_p_ldo(num, supply, log)	{		\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
 	.id		= MAX77802_LDO##num,				\
 	.supply_name	= "inl"#supply,					\
 	.ops		= &max77802_ldo_ops_logic##log,			\
@@ -380,6 +383,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* LDOs 1, 2, 8, 15, 17, 27, 30, 35 */
 #define regulator_77802_desc_n_ldo(num, supply, log)   {		\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
 	.id		= MAX77802_LDO##num,				\
 	.supply_name	= "inl"#supply,					\
 	.ops		= &max77802_ldo_ops_logic##log,			\
@@ -398,6 +402,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* BUCKs 1, 6 */
 #define regulator_77802_desc_16_buck(num)	{		\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
 	.id		= MAX77802_BUCK##num,				\
 	.supply_name	= "inb"#num,					\
 	.ops		= &max77802_buck_16_dvs_ops,			\
@@ -416,6 +421,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* BUCKS 2-4 */
 #define regulator_77802_desc_234_buck(num)	{		\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
 	.id		= MAX77802_BUCK##num,				\
 	.supply_name	= "inb"#num,					\
 	.ops		= &max77802_buck_234_ops,			\
@@ -435,6 +441,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* BUCK 5 */
 #define regulator_77802_desc_buck5(num)		{		\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
 	.id		= MAX77802_BUCK##num,				\
 	.supply_name	= "inb"#num,					\
 	.ops		= &max77802_buck_dvs_ops,			\
@@ -453,6 +460,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* BUCKs 7-10 */
 #define regulator_77802_desc_buck7_10(num)	{		\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
 	.id		= MAX77802_BUCK##num,				\
 	.supply_name	= "inb"#num,					\
 	.ops		= &max77802_buck_dvs_ops,			\
@@ -513,83 +521,31 @@ static struct regulator_desc regulators[] = {
 	regulator_77802_desc_n_ldo(35, 2, 1),
 };
 
-#ifdef CONFIG_OF
-static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
-{
-	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct device_node *pmic_np, *regulators_np;
-	struct max77686_regulator_data *rdata;
-	struct of_regulator_match rmatch;
-	unsigned int i;
-
-	pmic_np = iodev->dev->of_node;
-	regulators_np = of_get_child_by_name(pmic_np, "regulators");
-	if (!regulators_np) {
-		dev_err(&pdev->dev, "could not find regulators sub-node\n");
-		return -EINVAL;
-	}
-
-	pdata->num_regulators = ARRAY_SIZE(regulators);
-	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
-			     pdata->num_regulators, GFP_KERNEL);
-	if (!rdata) {
-		of_node_put(regulators_np);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < pdata->num_regulators; i++) {
-		rmatch.name = regulators[i].name;
-		rmatch.init_data = NULL;
-		rmatch.of_node = NULL;
-		if (of_regulator_match(&pdev->dev, regulators_np, &rmatch,
-				       1) != 1) {
-			dev_warn(&pdev->dev, "No matching regulator for '%s'\n",
-				 rmatch.name);
-			continue;
-		}
-		rdata[i].initdata = rmatch.init_data;
-		rdata[i].of_node = rmatch.of_node;
-		rdata[i].id = regulators[i].id;
-	}
-
-	pdata->regulators = rdata;
-	of_node_put(regulators_np);
-
-	return 0;
-}
-#else
-static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
-{
-	return 0;
-}
-#endif /* CONFIG_OF */
-
 static int max77802_pmic_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct max77802_regulator_prv *max77802;
-	int i, ret = 0, val;
+	int i, val;
 	struct regulator_config config = { };
 
-	/* This is allocated by the MFD driver */
-	if (!pdata) {
-		dev_err(&pdev->dev, "no platform data found for regulator\n");
-		return -ENODEV;
-	}
-
 	max77802 = devm_kzalloc(&pdev->dev,
 				sizeof(struct max77802_regulator_prv),
 				GFP_KERNEL);
 	if (!max77802)
 		return -ENOMEM;
 
-	if (iodev->dev->of_node) {
-		ret = max77802_pmic_dt_parse_pdata(pdev, pdata);
-		if (ret)
-			return ret;
+	if (!pdev->dev.of_node) {
+		/*
+		 * Backward DTS compatiblity where regulator driver had not
+		 * a compatible property for itself.
+		 */
+		if (!iodev->dev->of_node) {
+			dev_err(&pdev->dev, "No OF node for driver and its parent\n");
+			return -EINVAL;
+		}
+		pdev->dev.of_node = of_get_child_by_name(iodev->dev->of_node,
+								"regulators");
+		max77802->missing_of_node = true;
 	}
 
 	config.dev = iodev->dev;
@@ -599,11 +555,9 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX77802_REG_MAX; i++) {
 		struct regulator_dev *rdev;
-		int id = pdata->regulators[i].id;
+		int id = regulators[i].id;
 		int shift = max77802_get_opmode_shift(id);
-
-		config.init_data = pdata->regulators[i].initdata;
-		config.of_node = pdata->regulators[i].of_node;
+		int ret;
 
 		ret = regmap_read(iodev->regmap, regulators[i].enable_reg, &val);
 		if (ret < 0) {
@@ -627,15 +581,26 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 		rdev = devm_regulator_register(&pdev->dev,
 					       &regulators[i], &config);
 		if (IS_ERR(rdev)) {
+			ret = PTR_ERR(rdev);
 			dev_err(&pdev->dev,
-				"regulator init failed for %d\n", i);
-			return PTR_ERR(rdev);
+				"regulator init failed for %d: %d\n", i, ret);
+			return ret;
 		}
 	}
 
 	return 0;
 }
 
+static int max77802_pmic_remove(struct platform_device *pdev)
+{
+	struct max77802_regulator_prv *max77802 = platform_get_drvdata(pdev);
+
+	if (max77802->missing_of_node)
+		of_node_put(pdev->dev.of_node);
+
+	return 0;
+}
+
 static const struct platform_device_id max77802_pmic_id[] = {
 	{"max77802-pmic", 0},
 	{ },
@@ -648,6 +613,7 @@ static struct platform_driver max77802_pmic_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = max77802_pmic_probe,
+	.remove = max77802_pmic_remove,
 	.id_table = max77802_pmic_id,
 };
 
-- 
1.9.1

