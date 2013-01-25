Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3AYCYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 21:24:31 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:60786 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab3AYCYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 21:24:24 -0500
Message-ID: <1359080658.4232.6.camel@phoenix>
Subject: [PATCH 2/3] regulator: max77686: Fix using wrong dev argument at
 various places
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Fri, 25 Jan 2013 10:24:18 +0800
In-Reply-To: <1359080429.4232.3.camel@phoenix>
References: <1359080429.4232.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use &pdev->dev rather than iodev->dev for dev_err().
Use &pdev->dev rather than iodev->dev for devm_kzalloc() and
of_regulator_match(), this fixes memory leak.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max77686.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index b85040c..cca18a3 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -379,9 +379,10 @@ static struct regulator_desc regulators[] = {
 };
 
 #ifdef CONFIG_OF
-static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
+static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct max77686_platform_data *pdata)
 {
+	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *pmic_np, *regulators_np;
 	struct max77686_regulator_data *rdata;
 	struct of_regulator_match rmatch;
@@ -390,15 +391,15 @@ static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
 	pmic_np = iodev->dev->of_node;
 	regulators_np = of_find_node_by_name(pmic_np, "voltage-regulators");
 	if (!regulators_np) {
-		dev_err(iodev->dev, "could not find regulators sub-node\n");
+		dev_err(&pdev->dev, "could not find regulators sub-node\n");
 		return -EINVAL;
 	}
 
 	pdata->num_regulators = ARRAY_SIZE(regulators);
-	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
+	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 			     pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
-		dev_err(iodev->dev,
+		dev_err(&pdev->dev,
 			"could not allocate memory for regulator data\n");
 		return -ENOMEM;
 	}
@@ -407,7 +408,7 @@ static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
 		rmatch.name = regulators[i].name;
 		rmatch.init_data = NULL;
 		rmatch.of_node = NULL;
-		of_regulator_match(iodev->dev, regulators_np, &rmatch, 1);
+		of_regulator_match(&pdev->dev, regulators_np, &rmatch, 1);
 		rdata[i].initdata = rmatch.init_data;
 		rdata[i].of_node = rmatch.of_node;
 	}
@@ -417,7 +418,7 @@ static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
 	return 0;
 }
 #else
-static int max77686_pmic_dt_parse_pdata(struct max77686_dev *iodev,
+static int max77686_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct max77686_platform_data *pdata)
 {
 	return 0;
@@ -440,7 +441,7 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 	}
 
 	if (iodev->dev->of_node) {
-		ret = max77686_pmic_dt_parse_pdata(iodev, pdata);
+		ret = max77686_pmic_dt_parse_pdata(pdev, pdata);
 		if (ret)
 			return ret;
 	}
-- 
1.7.9.5



