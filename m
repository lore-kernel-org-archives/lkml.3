Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaGGPmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:42:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:42340 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbaGGPmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:42:21 -0400
Date: Mon, 7 Jul 2014 21:12:14 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] regulator: lp8755: Use devm_regulator_register
Message-ID: <20140707154214.GA9212@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using regulator_register to
devm_regulator_register and does away with the calls to
regulator_unregister. Also some labels are removed and a new labelerr is
introduced which is less specific to context.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/regulator/lp8755.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
index 785a25e..4a415d4 100644
--- a/drivers/regulator/lp8755.c
+++ b/drivers/regulator/lp8755.c
@@ -339,22 +339,18 @@ static int lp8755_regulator_init(struct lp8755_chip *pchip)
 		rconfig.init_data = pdata->buck_data[buck_num];
 		rconfig.of_node = pchip->dev->of_node;
 		pchip->rdev[buck_num] =
-		    regulator_register(&lp8755_regulators[buck_num], &rconfig);
+		    devm_regulator_register(pchip->dev,
+				    &lp8755_regulators[buck_num], &rconfig);
 		if (IS_ERR(pchip->rdev[buck_num])) {
 			ret = PTR_ERR(pchip->rdev[buck_num]);
 			pchip->rdev[buck_num] = NULL;
 			dev_err(pchip->dev, "regulator init failed: buck %d\n",
 				buck_num);
-			goto err_buck;
+			return ret;
 		}
 	}
 
 	return 0;
-
-err_buck:
-	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
-		regulator_unregister(pchip->rdev[icnt]);
-	return ret;
 }
 
 static irqreturn_t lp8755_irq_handler(int irq, void *data)
@@ -490,23 +486,19 @@ static int lp8755_probe(struct i2c_client *client,
 	ret = lp8755_regulator_init(pchip);
 	if (ret < 0) {
 		dev_err(&client->dev, "fail to initialize regulators\n");
-		goto err_regulator;
+		goto err;
 	}
 
 	pchip->irq = client->irq;
 	ret = lp8755_int_config(pchip);
 	if (ret < 0) {
 		dev_err(&client->dev, "fail to irq config\n");
-		goto err_irq;
+		goto err;
 	}
 
 	return ret;
 
-err_irq:
-	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++)
-		regulator_unregister(pchip->rdev[icnt]);
-
-err_regulator:
+err:
 	/* output disable */
 	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
 		lp8755_write(pchip, icnt, 0x00);
@@ -519,9 +511,6 @@ static int lp8755_remove(struct i2c_client *client)
 	int icnt;
 	struct lp8755_chip *pchip = i2c_get_clientdata(client);
 
-	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++)
-		regulator_unregister(pchip->rdev[icnt]);
-
 	for (icnt = 0; icnt < LP8755_BUCK_MAX; icnt++)
 		lp8755_write(pchip, icnt, 0x00);
 
-- 
1.9.1

