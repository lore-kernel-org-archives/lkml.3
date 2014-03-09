Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaCIH3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 03:29:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57038 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaCIH3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 03:29:38 -0400
Message-ID: <1394350171.19772.3.camel@phoenix>
Subject: [PATCH 2/3] regulator: max8997: Remove unnecessary **rdev from
 struct max8997_data
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Mar 2014 15:29:31 +0800
In-Reply-To: <1394350032.19772.1.camel@phoenix>
References: <1394350032.19772.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we are using devm_regulator_register(), so we don't need to allocate *rdev[]
array to store return value of devm_regulator_register. Use a *rdev variable is
enough for checking return status.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/max8997.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index f657d8d..90b4c53 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -38,7 +38,6 @@ struct max8997_data {
 	struct device *dev;
 	struct max8997_dev *iodev;
 	int num_regulators;
-	struct regulator_dev **rdev;
 	int ramp_delay; /* in mV/us */
 
 	bool buck1_gpiodvs;
@@ -1029,10 +1028,10 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	struct max8997_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct max8997_platform_data *pdata = iodev->pdata;
 	struct regulator_config config = { };
-	struct regulator_dev **rdev;
+	struct regulator_dev *rdev;
 	struct max8997_data *max8997;
 	struct i2c_client *i2c;
-	int i, ret, size, nr_dvs;
+	int i, ret, nr_dvs;
 	u8 max_buck1 = 0, max_buck2 = 0, max_buck5 = 0;
 
 	if (!pdata) {
@@ -1051,12 +1050,6 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 	if (!max8997)
 		return -ENOMEM;
 
-	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
-	max8997->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
-	if (!max8997->rdev)
-		return -ENOMEM;
-
-	rdev = max8997->rdev;
 	max8997->dev = &pdev->dev;
 	max8997->iodev = iodev;
 	max8997->num_regulators = pdata->num_regulators;
@@ -1204,12 +1197,12 @@ static int max8997_pmic_probe(struct platform_device *pdev)
 		config.driver_data = max8997;
 		config.of_node = pdata->regulators[i].reg_node;
 
-		rdev[i] = devm_regulator_register(&pdev->dev, &regulators[id],
-						  &config);
-		if (IS_ERR(rdev[i])) {
+		rdev = devm_regulator_register(&pdev->dev, &regulators[id],
+					       &config);
+		if (IS_ERR(rdev)) {
 			dev_err(max8997->dev, "regulator init failed for %d\n",
 					id);
-			return PTR_ERR(rdev[i]);
+			return PTR_ERR(rdev);
 		}
 	}
 
-- 
1.8.1.2



