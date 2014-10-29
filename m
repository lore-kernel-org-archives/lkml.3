Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933843AbaJ2PLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:11:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31462 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090AbaJ2PLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:11:04 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-8f-54510385cfe4
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
Subject: [RFT v2 2/8] regulator: max77802: Remove support for board files
Date: Wed, 29 Oct 2014 16:06:40 +0100
Message-id: <1414595206-1437-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
References: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7qtzIEhBqv7RSw2zljPajFp3QEm
	i6kPn7BZXP/ynNVi/pFzrBZHfxdYvH5haNG74CqbxdmmN+wW978eZbT4dqWDyWLT42usFpd3
	zWGzmHF+H5PF7cu8FmuP3GW3ON3N6iDo0dLcw+bx9/l1Fo+/q14we+ycdZfdY9OqTjaPO9f2
	sHnMOxnosXlJvUffllWMHp83yQVwRXHZpKTmZJalFunbJXBlPH0wjb1guUbFlePzmRsYbyh0
	MXJySAiYSPx+9JcRwhaTuHBvPVsXIxeHkMBSRom511ZDOX1MEkuPTWAHqWITMJbYvHwJWEJE
	oJNZoudgLzOIwyywmkni55VTzCBVwgKeEn9mzGEFsVkEVCUutj4Gi/MKuEk8e9QFtU9O4uSx
	yWA1nALuEgtbPoDFhYBq3i6bxDKBkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJAg
	/7KDcfExq0OMAhyMSjy8DhsDQoRYE8uKK3MPMUpwMCuJ8H7+BRTiTUmsrEotyo8vKs1JLT7E
	yMTBKdXAWKekoBy8wtVmb62+/Vw7nxDFybsai/7OFlzw/4XcF322UIFpRxYxnepab1v4YR+P
	180vvjKmsx+kGqyc3Lju44OM3rXvGZXDYpufN/2zXvYpw+PvowVh++JeCx6QO1+a+jz8kc8X
	4VKFF5kyTgvObdnPOblyZ5npi4Y7UoV3//KedLjynblqhhJLcUaioRZzUXEiALOO9IhQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used only on Exynos based boards with DTS support.
Convert the driver to DTS-only version. Parse all regulators at once,
not one-by-one. Remove dependency on data provided by max77686 MFD
driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77802.c | 87 +++++++++++++++++---------------------------
 1 file changed, 34 insertions(+), 53 deletions(-)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index b9958d927297..e3390c7db5ae 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -70,6 +70,7 @@ static unsigned int ramp_table_77802_4bit[] = {
 };
 
 struct max77802_regulator_prv {
+	/* Array indexed by regulator id */
 	unsigned int opmode[MAX77802_REG_MAX];
 };
 
@@ -513,15 +514,14 @@ static struct regulator_desc regulators[] = {
 	regulator_77802_desc_n_ldo(35, 2, 1),
 };
 
-#ifdef CONFIG_OF
-static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
+static int max77802_pmic_dt_parse(struct platform_device *pdev,
+				struct of_regulator_match *rdata)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *pmic_np, *regulators_np;
-	struct max77686_regulator_data *rdata;
-	struct of_regulator_match rmatch;
-	unsigned int i;
+	int ret = 0;
+
+	BUILD_BUG_ON(MAX77802_REG_MAX != ARRAY_SIZE(regulators));
 
 	pmic_np = iodev->dev->of_node;
 	regulators_np = of_get_child_by_name(pmic_np, "regulators");
@@ -530,55 +530,27 @@ static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	pdata->num_regulators = ARRAY_SIZE(regulators);
-	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
-			     pdata->num_regulators, GFP_KERNEL);
-	if (!rdata) {
+	ret = of_regulator_match(&pdev->dev, regulators_np, rdata,
+			MAX77802_REG_MAX);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "error parsing regulators data\n");
 		of_node_put(regulators_np);
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
+		return ret;
 	}
+	/* else: don't care how many regulators were parsed from DTS. */
 
-	pdata->regulators = rdata;
 	of_node_put(regulators_np);
 
 	return 0;
 }
-#else
-static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
-{
-	return 0;
-}
-#endif /* CONFIG_OF */
 
 static int max77802_pmic_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct max77802_regulator_prv *max77802;
 	int i, ret = 0, val;
 	struct regulator_config config = { };
-
-	/* This is allocated by the MFD driver */
-	if (!pdata) {
-		dev_err(&pdev->dev, "no platform data found for regulator\n");
-		return -ENODEV;
-	}
+	struct of_regulator_match *rdata;
 
 	max77802 = devm_kzalloc(&pdev->dev,
 				sizeof(struct max77802_regulator_prv),
@@ -586,24 +558,29 @@ static int max77802_pmic_probe(struct platform_device *pdev)
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
 	platform_set_drvdata(pdev, max77802);
 
+	rdata = kzalloc(sizeof(*rdata) * MAX77802_REG_MAX, GFP_KERNEL);
+	if (!rdata)
+		return -ENOMEM;
+
+	for (i = 0; i < MAX77802_REG_MAX; i++)
+		rdata[i].name = regulators[i].name;
+
+	ret = max77802_pmic_dt_parse(pdev, rdata);
+	if (ret)
+		goto out;
+
 	for (i = 0; i < MAX77802_REG_MAX; i++) {
 		struct regulator_dev *rdev;
-		int id = pdata->regulators[i].id;
+		int id = regulators[i].id;
 		int shift = max77802_get_opmode_shift(id);
 
-		config.init_data = pdata->regulators[i].initdata;
-		config.of_node = pdata->regulators[i].of_node;
+		config.init_data = rdata[i].init_data;
+		config.of_node = rdata[i].of_node;
 
 		ret = regmap_read(iodev->regmap, regulators[i].enable_reg, &val);
 		val = val >> shift & MAX77802_OPMODE_MASK;
@@ -621,13 +598,17 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 		rdev = devm_regulator_register(&pdev->dev,
 					       &regulators[i], &config);
 		if (IS_ERR(rdev)) {
+			ret = PTR_ERR(rdev);
 			dev_err(&pdev->dev,
-				"regulator init failed for %d\n", i);
-			return PTR_ERR(rdev);
+				"regulator init failed for %d: %d\n", i, ret);
+			goto out;
 		}
 	}
 
-	return 0;
+out:
+	kfree(rdata);
+
+	return ret;
 }
 
 static const struct platform_device_id max77802_pmic_id[] = {
-- 
1.9.1

