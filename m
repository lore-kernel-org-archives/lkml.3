Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbaCJIdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 04:33:00 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17379 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbaCJIc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 04:32:59 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-a8-531d78b95973
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/8] regulator: max1586: Remove regulator_dev pointer from
 state container
Date: Mon, 10 Mar 2014 09:32:44 +0100
Message-id: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t/xK7o7K2SDDbZM1raY+vAJm8XrF4YW
	3650MFlc3jWHzYHFY+esu+wem1Z1snn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxsMvkxgL
	/vNV/Fm2m7GBcQFPFyMnh4SAiURv404WCFtM4sK99WxdjFwcQgJLGSUOzDnLAuH0MUnM/LCE
	EaSKTcBYYvPyJWwgtohAhsTmeVNZQWxmAUOJn+/+sIPYwgIxErMndTCD2CwCqhITTq0HinNw
	8Aq4S/xtNAAxJQQUJOZMspnAyL2AkWEVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRojnv+5g
	XHrM6hCjAAejEg/vgbcywUKsiWXFlbmHGCU4mJVEeDPiZIOFeFMSK6tSi/Lji0pzUosPMTJx
	cEo1MHpc4lSUffaV7djEquJi8zXH5fZ7by269d5+9v6XLAsWZtrMrfw0RfrStMtz2haVic24
	cuPyNp7mhMVFU2UYz/JUaEnyRAoZun3mPhzZPiUl/eH02l+O+VMyG9777NFL1Xmx1rYxjKkq
	mXW6W8nqad+ff986+0G71euWV4/auVZods7efEzzkYYSS3FGoqEWc1FxIgCwCJR02gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't store pointer to regulator_dev returned by
devm_regulator_register() in state container. It isn't used anywhere
outside of max1586_pmic_probe() function.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max1586.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/max1586.c b/drivers/regulator/max1586.c
index e242dd316d36..c2a40a1a9e3e 100644
--- a/drivers/regulator/max1586.c
+++ b/drivers/regulator/max1586.c
@@ -46,8 +46,6 @@ struct max1586_data {
 
 	unsigned int v3_curr_sel;
 	unsigned int v6_curr_sel;
-
-	struct regulator_dev *rdev[0];
 };
 
 /*
@@ -162,7 +160,6 @@ static struct regulator_desc max1586_reg[] = {
 static int max1586_pmic_probe(struct i2c_client *client,
 					const struct i2c_device_id *i2c_id)
 {
-	struct regulator_dev **rdev;
 	struct max1586_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct regulator_config config = { };
 	struct max1586_data *max1586;
@@ -186,8 +183,9 @@ static int max1586_pmic_probe(struct i2c_client *client,
 	max1586->v3_curr_sel = 24; /* 1.3V */
 	max1586->v6_curr_sel = 0;
 
-	rdev = max1586->rdev;
 	for (i = 0; i < pdata->num_subdevs && i <= MAX1586_V6; i++) {
+		struct regulator_dev *rdev;
+
 		id = pdata->subdevs[i].id;
 		if (!pdata->subdevs[i].platform_data)
 			continue;
@@ -207,12 +205,12 @@ static int max1586_pmic_probe(struct i2c_client *client,
 		config.init_data = pdata->subdevs[i].platform_data;
 		config.driver_data = max1586;
 
-		rdev[i] = devm_regulator_register(&client->dev,
+		rdev = devm_regulator_register(&client->dev,
 						  &max1586_reg[id], &config);
-		if (IS_ERR(rdev[i])) {
+		if (IS_ERR(rdev)) {
 			dev_err(&client->dev, "failed to register %s\n",
 				max1586_reg[id].name);
-			return PTR_ERR(rdev[i]);
+			return PTR_ERR(rdev);
 		}
 	}
 
-- 
1.7.9.5

