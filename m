Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaCIH1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 03:27:19 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:50238 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaCIH1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 03:27:18 -0400
Message-ID: <1394350032.19772.1.camel@phoenix>
Subject: [PATCH 1/3] regulator: max77693: Remove unnecessary **rdev from
 struct max77693_pmic_dev
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sun, 09 Mar 2014 15:27:12 +0800
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
 drivers/regulator/max77693.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/max77693.c b/drivers/regulator/max77693.c
index d6807fd..f5f85c2 100644
--- a/drivers/regulator/max77693.c
+++ b/drivers/regulator/max77693.c
@@ -38,7 +38,6 @@ struct max77693_pmic_dev {
 	struct device *dev;
 	struct max77693_dev *iodev;
 	int num_regulators;
-	struct regulator_dev **rdev;
 };
 
 /* CHARGER regulator ops */
@@ -249,12 +248,6 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 	if (!max77693_pmic)
 		return -ENOMEM;
 
-	max77693_pmic->rdev = devm_kzalloc(&pdev->dev,
-				sizeof(struct regulator_dev *) * num_rdata,
-				GFP_KERNEL);
-	if (!max77693_pmic->rdev)
-		return -ENOMEM;
-
 	max77693_pmic->dev = &pdev->dev;
 	max77693_pmic->iodev = iodev;
 	max77693_pmic->num_regulators = num_rdata;
@@ -265,17 +258,18 @@ static int max77693_pmic_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, max77693_pmic);
 
 	for (i = 0; i < max77693_pmic->num_regulators; i++) {
+		struct regulator_dev *rdev;
 		int id = rdata[i].id;
 
 		config.init_data = rdata[i].initdata;
 		config.of_node = rdata[i].of_node;
 
-		max77693_pmic->rdev[i] = devm_regulator_register(&pdev->dev,
-						&regulators[id], &config);
-		if (IS_ERR(max77693_pmic->rdev[i])) {
+		rdev = devm_regulator_register(&pdev->dev, &regulators[id],
+					       &config);
+		if (IS_ERR(rdev)) {
 			dev_err(max77693_pmic->dev,
 				"Failed to initialize regulator-%d\n", id);
-			return PTR_ERR(max77693_pmic->rdev[i]);
+			return PTR_ERR(rdev);
 		}
 	}
 
-- 
1.8.1.2



