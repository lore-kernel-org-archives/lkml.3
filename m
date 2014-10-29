Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933883AbaJ2PLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:11:15 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47969 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933587AbaJ2PLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:11:05 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-94-545103867f60
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
Subject: [PATCH v2 3/8] regulator: max77686: Remove support for board files
Date: Wed, 29 Oct 2014 16:06:41 +0100
Message-id: <1414595206-1437-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
References: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xy7ptzIEhBlfesVhsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DK+PZ4NUvBR5WKl8u3MzUwTpbr
	YuTkkBAwkVj2/xwThC0mceHeerYuRi4OIYGljBKXbn9ihXD6mCSWHpvADlLFJmAssXn5ErAq
	EYFOZomeg73MIA6zwGomiZ9XTjGDVAkLeEtMnbGAFcRmEVCVOHPkLVAHBwevgJvEh/niEOvk
	JE4emwxWwingLrGw5QMjiC0EVPJ22SSWCYy8CxgZVjGKppYmFxQnpeca6hUn5haX5qXrJefn
	bmKEhPiXHYyLj1kdYhTgYFTi4XXYGBAixJpYVlyZe4hRgoNZSYT38y+gEG9KYmVValF+fFFp
	TmrxIUYmDk6pBsYKnu72k613lLYb3PRzUlbad0Blw7aVJo+vr7I/OTdv1ffUH92bn35M6bwc
	wVvkeYV5+dftAm9cl0+RX+J29y3/zwrTrooVi9c8DfmiOz9jv5pUpFBCRFTq7d0LPc2E3z3I
	8nN+P69CQs87bU69l5ac5YW+9ORi53XJzU7LprpYMQpoLuNefkuJpTgj0VCLuag4EQBHVT6E
	TwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is used only on Exynos based boards with DTS support.
Convert the driver to DTS-only version. Parse all regulators at once,
not one-by-one. Remove dependency on data provided by max77686 MFD
driver.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max77686.c | 84 +++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 51 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 27c5f4556044..7ec9b4e5b917 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -428,15 +428,14 @@ static const struct regulator_desc regulators[] = {
 	regulator_desc_buck(9),
 };
 
-#ifdef CONFIG_OF
-static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
+static int max77686_pmic_dt_parse(struct platform_device *pdev,
+				struct of_regulator_match *rdata)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *pmic_np, *regulators_np;
-	struct max77686_regulator_data *rdata;
-	struct of_regulator_match rmatch;
-	unsigned int i;
+	int ret = 0;
+
+	BUILD_BUG_ON(MAX77686_REGULATORS != ARRAY_SIZE(regulators));
 
 	pmic_np = iodev->dev->of_node;
 	regulators_np = of_get_child_by_name(pmic_np, "voltage-regulators");
@@ -445,63 +444,31 @@ static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
-	pdata->num_regulators = ARRAY_SIZE(regulators);
-	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
-			     pdata->num_regulators, GFP_KERNEL);
-	if (!rdata) {
-		of_node_put(regulators_np);
-		return -ENOMEM;
-	}
 
-	for (i = 0; i < pdata->num_regulators; i++) {
-		rmatch.name = regulators[i].name;
-		rmatch.init_data = NULL;
-		rmatch.of_node = NULL;
-		of_regulator_match(&pdev->dev, regulators_np, &rmatch, 1);
-		rdata[i].initdata = rmatch.init_data;
-		rdata[i].of_node = rmatch.of_node;
+	ret = of_regulator_match(&pdev->dev, regulators_np, rdata,
+			MAX77686_REGULATORS);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "error parsing regulators data\n");
+		of_node_put(regulators_np);
+		return ret;
 	}
+	/* else: don't care how many regulators were parsed from DTS. */
 
-	pdata->regulators = rdata;
 	of_node_put(regulators_np);
 
 	return 0;
 }
-#else
-static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
-					struct max77686_platform_data *pdata)
-{
-	return 0;
-}
-#endif /* CONFIG_OF */
 
 static int max77686_pmic_probe(struct platform_device *pdev)
 {
 	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
-	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
 	struct max77686_data *max77686;
 	int i, ret = 0;
 	struct regulator_config config = { };
+	struct of_regulator_match *rdata;
 
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
@@ -512,25 +479,40 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 	config.driver_data = max77686;
 	platform_set_drvdata(pdev, max77686);
 
+	rdata = kzalloc(sizeof(*rdata) * MAX77686_REGULATORS, GFP_KERNEL);
+	if (!rdata)
+		return -ENOMEM;
+
+	for (i = 0; i < MAX77686_REGULATORS; i++)
+		rdata[i].name = regulators[i].name;
+
+	ret = max77686_pmic_dt_parse(pdev, rdata);
+	if (ret)
+		goto out;
+
 	for (i = 0; i < MAX77686_REGULATORS; i++) {
 		struct regulator_dev *rdev;
 		int id = regulators[i].id;
 
-		config.init_data = pdata->regulators[i].initdata;
-		config.of_node = pdata->regulators[i].of_node;
+		config.init_data = rdata[i].init_data;
+		config.of_node = rdata[i].of_node;
 
 		max77686->opmode[id] = regulators[i].enable_mask >>
 						max77686_get_opmode_shift(id);
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
 
 static const struct platform_device_id max77686_pmic_id[] = {
-- 
1.9.1

