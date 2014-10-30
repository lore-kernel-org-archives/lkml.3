Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbaJ3LY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:24:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23538 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759126AbaJ3LVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:25 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-a0-54521f33e115
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
Subject: [PATCH v3 07/14] regulator: max77686: Remove support for board files
Date: Thu, 30 Oct 2014 12:20:46 +0100
Message-id: <1414668053-31370-8-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xq7rG8kEhBm8vq1psnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKeH3pK2vBUcuKHXNnMTUwPtXt
	YuTkkBAwkTi67jQzhC0mceHeerYuRi4OIYGljBLP+t6wQjh9TBJPNnSxg1SxCRhLbF6+BKxK
	RKCTWaLnYC8ziMMssJpJ4ueVU0AOB4ewgK/E1cduIA0sAqoSGyd9AlvBK+Au8fnJIXaIdXIS
	J49NZgWxOQU8JNZ8bGcFaRUCqrn3TXsCI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmb
	GCEB/nUH49JjVocYBTgYlXh4I44FhAixJpYVV+YeYpTgYFYS4V0tFhQixJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgdE2QdIpOzzrwLW3i3iLt1YtvxZcqOJ57bDsWqa7e//V8s26cyT0dN/KCdYV
	97e6BSvVfOB53nhUReld8U51yUOmK9QOixu3yizmzlZdXcq5Z8mHfv3aQHexDH+TC5ee5AaX
	nVxRM1uooDvW/RvvXwbbgCd1D5hCshlsd0SHPi5N2tN++J7JNiWW4oxEQy3mouJEAPrVezdO	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used only on Exynos based boards with DTS support.
Convert the driver to DTS-only version. Parse all regulators at once,
not one-by-one. Remove dependency on data provided by max77686 MFD
driver.

Use new DT style parsing method for regulators init data. The regulator
driver now should have its own of_compatible property. If it is not
present then it will use "voltage-regulators" sub-node of parent's
node.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c | 110 +++++++++++++++----------------------------
 1 file changed, 39 insertions(+), 71 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 27c5f4556044..ac05b318e405 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -84,6 +84,7 @@ enum max77686_ramp_rate {
 struct max77686_data {
 	/* Array indexed by regulator id */
 	unsigned int opmode[MAX77686_REGULATORS];
+	bool missing_of_node;
 };
 
 static unsigned int max77686_get_opmode_shift(int id)
@@ -281,6 +282,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 
 #define regulator_desc_ldo(num)		{				\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
 	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -297,6 +299,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_lpm_ldo(num)	{				\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
 	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ldo_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -313,6 +316,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_ldo_low(num)		{			\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
 	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ldo_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -329,6 +333,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_ldo1_low(num)		{			\
 	.name		= "LDO"#num,					\
+	.of_match	= of_match_ptr("LDO"#num),			\
 	.id		= MAX77686_LDO##num,				\
 	.ops		= &max77686_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -345,6 +350,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_buck(num)		{			\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
 	.id		= MAX77686_BUCK##num,				\
 	.ops		= &max77686_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -360,6 +366,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_buck1(num)		{			\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
 	.id		= MAX77686_BUCK##num,				\
 	.ops		= &max77686_buck1_ops,				\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -375,6 +382,7 @@ static struct regulator_ops max77686_buck_dvs_ops = {
 }
 #define regulator_desc_buck_dvs(num)		{			\
 	.name		= "BUCK"#num,					\
+	.of_match	= of_match_ptr("BUCK"#num),			\
 	.id		= MAX77686_BUCK##num,				\
 	.ops		= &max77686_buck_dvs_ops,			\
 	.type		= REGULATOR_VOLTAGE,				\
@@ -428,85 +436,34 @@ static const struct regulator_desc regulators[] = {
 	regulator_desc_buck(9),
 };
 
-#ifdef CONFIG_OF
-static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
-{
-	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct device_node *pmic_np, *regulators_np;
-	struct max77686_regulator_data *rdata;
-	struct of_regulator_match rmatch;
-	unsigned int i;
-
-	pmic_np = iodev->dev->of_node;
-	regulators_np = of_get_child_by_name(pmic_np, "voltage-regulators");
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
-		of_regulator_match(&pdev->dev, regulators_np, &rmatch, 1);
-		rdata[i].initdata = rmatch.init_data;
-		rdata[i].of_node = rmatch.of_node;
-	}
-
-	pdata->regulators = rdata;
-	of_node_put(regulators_np);
-
-	return 0;
-}
-#else
-static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
-{
-	return 0;
-}
-#endif /* CONFIG_OF */
-
 static int max77686_pmic_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct max77686_data *max77686;
-	int i, ret = 0;
+	int i;
 	struct regulator_config config = { };
 
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
-	if (!pdata) {
-		dev_err(&pdev->dev, "no platform data found for regulator\n");
-		return -ENODEV;
-	}
-
-	if (iodev->dev->of_node) {
-		ret = max77686_pmic_dt_parse_pdata(pdev, pdata);
-		if (ret)
-			return ret;
-	}
-
-	if (pdata->num_regulators != MAX77686_REGULATORS) {
-		dev_err(&pdev->dev,
-			"Invalid initial data for regulator's initialiation\n");
-		return -EINVAL;
-	}
-
 	max77686 = devm_kzalloc(&pdev->dev, sizeof(struct max77686_data),
 				GFP_KERNEL);
 	if (!max77686)
 		return -ENOMEM;
 
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
+				"voltage-regulators");
+		max77686->missing_of_node = true;
+	}
+
 	config.dev = &pdev->dev;
 	config.regmap = iodev->regmap;
 	config.driver_data = max77686;
@@ -516,23 +473,33 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 		struct regulator_dev *rdev;
 		int id = regulators[i].id;
 
-		config.init_data = pdata->regulators[i].initdata;
-		config.of_node = pdata->regulators[i].of_node;
-
 		max77686->opmode[id] = regulators[i].enable_mask >>
 						max77686_get_opmode_shift(id);
 		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
 		if (IS_ERR(rdev)) {
+			int ret = PTR_ERR(rdev);
 			dev_err(&pdev->dev,
-				"regulator init failed for %d\n", i);
-			return PTR_ERR(rdev);
+				"regulator init failed for %d: %d\n", i, ret);
+			if (max77686->missing_of_node)
+				of_node_put(pdev->dev.of_node);
+			return ret;
 		}
 	}
 
 	return 0;
 }
 
+static int max77686_pmic_remove(struct platform_device *pdev)
+{
+	struct max77686_data *max77686 = platform_get_drvdata(pdev);
+
+	if (max77686->missing_of_node)
+		of_node_put(pdev->dev.of_node);
+
+	return 0;
+}
+
 static const struct platform_device_id max77686_pmic_id[] = {
 	{"max77686-pmic", 0},
 	{ },
@@ -545,6 +512,7 @@ static struct platform_driver max77686_pmic_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = max77686_pmic_probe,
+	.remove = max77686_pmic_remove,
 	.id_table = max77686_pmic_id,
 };
 
-- 
1.9.1

