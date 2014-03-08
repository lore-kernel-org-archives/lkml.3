Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaCHNQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 08:16:10 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61869 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaCHNQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 08:16:06 -0500
Message-ID: <1394284559.12881.1.camel@phoenix>
Subject: [PATCH] regulator: tps6586x: Remove unnecessary rdev[] array
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Stefan Agner <stefan@agner.ch>, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 08 Mar 2014 21:15:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we are using devm_regulator_register(), so we don't need the rdev[] array
to store return value of devm_regulator_register. Use a *rdev variable is
enough for checking return status.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/tps6586x-regulator.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/tps6586x-regulator.c b/drivers/regulator/tps6586x-regulator.c
index e36f3569..32f38a6 100644
--- a/drivers/regulator/tps6586x-regulator.c
+++ b/drivers/regulator/tps6586x-regulator.c
@@ -396,7 +396,7 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 {
 	struct tps6586x_regulator *ri = NULL;
 	struct regulator_config config = { };
-	struct regulator_dev **rdev;
+	struct regulator_dev *rdev;
 	struct regulator_init_data *reg_data;
 	struct tps6586x_platform_data *pdata;
 	struct of_regulator_match *tps6586x_reg_matches = NULL;
@@ -416,11 +416,6 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	rdev = devm_kzalloc(&pdev->dev, TPS6586X_ID_MAX_REGULATOR *
-				sizeof(*rdev), GFP_KERNEL);
-	if (!rdev)
-		return -ENOMEM;
-
 	version = tps6586x_get_version(pdev->dev.parent);
 
 	for (id = 0; id < TPS6586X_ID_MAX_REGULATOR; ++id) {
@@ -447,12 +442,11 @@ static int tps6586x_regulator_probe(struct platform_device *pdev)
 		if (tps6586x_reg_matches)
 			config.of_node = tps6586x_reg_matches[id].of_node;
 
-		rdev[id] = devm_regulator_register(&pdev->dev, &ri->desc,
-						   &config);
-		if (IS_ERR(rdev[id])) {
+		rdev = devm_regulator_register(&pdev->dev, &ri->desc, &config);
+		if (IS_ERR(rdev)) {
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 					ri->desc.name);
-			return PTR_ERR(rdev[id]);
+			return PTR_ERR(rdev);
 		}
 
 		if (reg_data) {
-- 
1.8.1.2



