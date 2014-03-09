Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaCIHca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 03:32:30 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37892 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbaCIHc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 03:32:28 -0400
Message-ID: <1394350339.19772.5.camel@phoenix>
Subject: [PATCH 3/3] regulator: max8998: Remove unnecessary **rdev from
 struct max8998_data
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Mar 2014 15:32:19 +0800
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
 drivers/regulator/max8998.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index ce22d4f..961091b 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -40,7 +40,6 @@ struct max8998_data {
 	struct device		*dev;
 	struct max8998_dev	*iodev;
 	int			num_regulators;
-	struct regulator_dev	**rdev;
 	u8                      buck1_vol[4]; /* voltages for selection */
 	u8                      buck2_vol[2];
 	unsigned int		buck1_idx; /* index to last changed voltage */
@@ -746,10 +745,10 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 	struct max8998_dev *iodev = dev_get_drvdata(pdev->dev.parent);
 	struct max8998_platform_data *pdata = iodev->pdata;
 	struct regulator_config config = { };
-	struct regulator_dev **rdev;
+	struct regulator_dev *rdev;
 	struct max8998_data *max8998;
 	struct i2c_client *i2c;
-	int i, ret, size;
+	int i, ret;
 	unsigned int v;
 
 	if (!pdata) {
@@ -768,12 +767,6 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 	if (!max8998)
 		return -ENOMEM;
 
-	size = sizeof(struct regulator_dev *) * pdata->num_regulators;
-	max8998->rdev = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
-	if (!max8998->rdev)
-		return -ENOMEM;
-
-	rdev = max8998->rdev;
 	max8998->dev = &pdev->dev;
 	max8998->iodev = iodev;
 	max8998->num_regulators = pdata->num_regulators;
@@ -877,13 +870,12 @@ static int max8998_pmic_probe(struct platform_device *pdev)
 		config.init_data = pdata->regulators[i].initdata;
 		config.driver_data = max8998;
 
-		rdev[i] = devm_regulator_register(&pdev->dev,
-						  &regulators[index], &config);
-		if (IS_ERR(rdev[i])) {
-			ret = PTR_ERR(rdev[i]);
+		rdev = devm_regulator_register(&pdev->dev, &regulators[index],
+					       &config);
+		if (IS_ERR(rdev)) {
+			ret = PTR_ERR(rdev);
 			dev_err(max8998->dev, "regulator %s init failed (%d)\n",
 						regulators[index].name, ret);
-			rdev[i] = NULL;
 			return ret;
 		}
 	}
-- 
1.8.1.2



