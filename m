Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759516Ab3BMBaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 20:30:22 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:60404 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3BMBaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 20:30:21 -0500
Message-ID: <1360718985.14930.1.camel@phoenix>
Subject: [PATCH 1/2] regulator: s5m8767: Fix dev argument for devm_kzalloc
 and of_get_regulator_init_data
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Sangbeom Kim <sbkim73@samsung.com>, LiamGirdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2013 09:29:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use &pdev->dev rather than iodev->dev for devm_kzalloc() and
of_get_regulator_init_data(), this fixes memory leak.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/s5m8767.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 194b5dd..ef0532d 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -515,9 +515,10 @@ static int s5m8767_pmic_dt_parse_ds_gpio(struct sec_pmic_dev *iodev,
 	return 0;
 }
 
-static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
+static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct sec_platform_data *pdata)
 {
+	struct sec_pmic_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct device_node *pmic_np, *regulators_np, *reg_np;
 	struct sec_regulator_data *rdata;
 	struct sec_opmode_data *rmode;
@@ -538,7 +539,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
 	/* count the number of regulators to be supported in pmic */
 	pdata->num_regulators = of_get_child_count(regulators_np);
 
-	rdata = devm_kzalloc(iodev->dev, sizeof(*rdata) *
+	rdata = devm_kzalloc(&pdev->dev, sizeof(*rdata) *
 				pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
 		dev_err(iodev->dev,
@@ -546,7 +547,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
 		return -ENOMEM;
 	}
 
-	rmode = devm_kzalloc(iodev->dev, sizeof(*rmode) *
+	rmode = devm_kzalloc(&pdev->dev, sizeof(*rmode) *
 				pdata->num_regulators, GFP_KERNEL);
 	if (!rdata) {
 		dev_err(iodev->dev,
@@ -570,7 +571,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
 
 		rdata->id = i;
 		rdata->initdata = of_get_regulator_init_data(
-						iodev->dev, reg_np);
+						&pdev->dev, reg_np);
 		rdata->reg_node = reg_np;
 		rdata++;
 		rmode->id = i;
@@ -642,7 +643,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
 	return 0;
 }
 #else
-static int s5m8767_pmic_dt_parse_pdata(struct sec_pmic_dev *iodev,
+static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 					struct sec_platform_data *pdata)
 {
 	return 0;
@@ -659,7 +660,7 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 	int i, ret, size, buck_init;
 
 	if (iodev->dev->of_node) {
-		ret = s5m8767_pmic_dt_parse_pdata(iodev, pdata);
+		ret = s5m8767_pmic_dt_parse_pdata(pdev, pdata);
 		if (ret)
 			return ret;
 	}
-- 
1.7.9.5



