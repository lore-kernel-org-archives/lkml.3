Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaKEJsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 04:48:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23130 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbaKEJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 04:48:10 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-cb-5459f257defd
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/3] regulator: max77802: Remove support for board files
Date: Wed, 05 Nov 2014 10:47:49 +0100
Message-id: <1415180871-25293-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
References: <1415180871-25293-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e/4Nd3wT5EhBg1PTSw2zljPajH14RM2
	i6O/CyxevzC0ONv0ht3i/tejjBbfrnQwWVzeNYfNYu2Ru+wWp7tZHbg8/j6/zuKxc9Zddo9N
	qzrZPO5c28PmMe9koEffllWMHp83yQWwR3HZpKTmZJalFunbJXBl3Pzwkr1gi0nF08NHmRoY
	v2p2MXJySAiYSHw4spwVwhaTuHBvPVsXIxeHkMBSRok99z4zQTh9TBLTe/ezg1SxCRhLbF6+
	BKxKRGATo8Sk/itg7cwCzUwSp9/ngNjCAt4SO7fcAmtgEVCVuN7/gg3E5hVwl7hzvocNYp2c
	xMljk8F6OQU8JE7d/sgMYgsB1TTuvMA8gZF3ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95Pzc
	TYyQEPyyg3HxMatDjAIcjEo8vB5NkSFCrIllxZW5hxglOJiVRHg5LwGFeFMSK6tSi/Lji0pz
	UosPMTJxcEo1MPbW1N2OEZwrGmu0+hjrG+brJe+uH7wqq/tumpXIavf2XutDGUHq5o1PKzxS
	FvN3m/Mdbu7Zc7z7961DH461XljoybJX9OqPz7EGxwRzbBb83XDf8/v1bW9Wn+Kbzb5wplKC
	ycnpd/ytxSuj5nWxLnk2MXzGqvfv2sSnrWPrt3Eweft49leJuSJKLMUZiYZazEXFiQC8kdv1
	HwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used only on Exynos based boards with DTS support.
Simplify the driver and remove dead (unused) entries in platform_data
structure.

Convert the driver to DTS-only version. Parse all regulators at once,
not one-by-one. Remove dependency on data provided by max77686 MFD
driver. Use new DT style parsing method for regulators init data.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77802.c | 92 +++++++++-----------------------------------
 1 file changed, 19 insertions(+), 73 deletions(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 8168dbfc532f..9b4d127387b9 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -70,6 +70,7 @@ static unsigned int ramp_table_77802_4bit[] = {
 };
 
 struct max77802_regulator_prv {
+	/* Array indexed by regulator id */
 	unsigned int opmode[MAX77802_REG_MAX];
 };
 
@@ -362,6 +363,8 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* LDOs 3-7, 9-14, 18-26, 28, 29, 32-34 */
 #define regulator_77802_desc_p_ldo(num, supply, log)	{		\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
+	.regulators_node	= of_match_ptr("regulators"),		\
 	.id		= MAX77802_LDO##num,				\
 	.supply_name	= "inl"#supply,					\
 	.ops		= &max77802_ldo_ops_logic##log,			\
@@ -380,6 +383,8 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* LDOs 1, 2, 8, 15, 17, 27, 30, 35 */
 #define regulator_77802_desc_n_ldo(num, supply, log)   {		\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
+	.regulators_node	= of_match_ptr("regulators"),		\
 	.id		= MAX77802_LDO##num,				\
 	.supply_name	= "inl"#supply,					\
 	.ops		= &max77802_ldo_ops_logic##log,			\
@@ -398,6 +403,8 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* BUCKs 1, 6 */
 #define regulator_77802_desc_16_buck(num)	{		\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
+	.regulators_node	= of_match_ptr("regulators"),		\
 	.id		= MAX77802_BUCK##num,				\
 	.supply_name	= "inb"#num,					\
 	.ops		= &max77802_buck_16_dvs_ops,			\
@@ -416,6 +423,8 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* BUCKS 2-4 */
 #define regulator_77802_desc_234_buck(num)	{		\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
+	.regulators_node	= of_match_ptr("regulators"),		\
 	.id		= MAX77802_BUCK##num,				\
 	.supply_name	= "inb"#num,					\
 	.ops		= &max77802_buck_234_ops,			\
@@ -435,6 +444,8 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* BUCK 5 */
 #define regulator_77802_desc_buck5(num)		{		\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
+	.regulators_node	= of_match_ptr("regulators"),		\
 	.id		= MAX77802_BUCK##num,				\
 	.supply_name	= "inb"#num,					\
 	.ops		= &max77802_buck_dvs_ops,			\
@@ -453,6 +464,8 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 /* BUCKs 7-10 */
 #define regulator_77802_desc_buck7_10(num)	{		\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
+	.regulators_node	= of_match_ptr("regulators"),		\
 	.id		= MAX77802_BUCK##num,				\
 	.supply_name	= "inb"#num,					\
 	.ops		= &max77802_buck_dvs_ops,			\
@@ -513,85 +526,19 @@ static const struct regulator_desc regulators[] = {
 	regulator_77802_desc_n_ldo(35, 2, 1),
 };
 
-#ifdef CONFIG_OF
-static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
-{
-	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct device_node *pmic_np, *regulators_np;
-	struct max77686_regulator_data *rdata;
-	struct of_regulator_match rmatch = { };
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
-	}
-
 	config.dev = iodev->dev;
 	config.regmap = iodev->regmap;
 	config.driver_data = max77802;
@@ -599,11 +546,9 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 
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
@@ -627,9 +572,10 @@ static int max77802_pmic_probe(struct platform_device *pdev)
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
 
-- 
1.9.1

