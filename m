Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaHWLPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:15:20 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:40109 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbaHWLPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:15:19 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <fc4e7e4b1837b88a874f67850751ac3e>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Chris Zhong <zyw@rock-chips.com>
To: broonie@kernel.org
Cc: cf@rock-chips.com, zhangqing@rock-chips.com, dianders@chromium.org,
        heiko@sntech.de, olof@lixom.net, sonnyrao@chromium.org,
        dtor@chromium.org, javier.martinez@collabora.co.uk,
        Chris Zhong <zyw@rock-chips.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Regulator: RK808: modify for struct rk808 change
Date: Sat, 23 Aug 2014 19:13:02 +0800
Message-Id: <1408792382-17795-1-git-send-email-zyw@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use &client->dev replace rk808->dev

Signed-off-by: Chris Zhong <zyw@rock-chips.com>
---

 drivers/regulator/rk808-regulator.c |   34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 94753fd..e098efc 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -296,13 +296,14 @@ static struct of_regulator_match rk808_reg_matches[] = {
 
 static int rk808_regulator_dts(struct rk808 *rk808)
 {
-	struct rk808_board *pdata = rk808->pdata;
 	struct device_node *np, *reg_np;
+	struct i2c_client *client = rk808->i2c;
+	struct rk808_board *pdata = rk808->pdata;
 	int i, ret;
 
-	np = rk808->dev->of_node;
+	np = client->dev.of_node;
 	if (!np) {
-		dev_err(rk808->dev, "could not find pmic sub-node\n");
+		dev_err(&client->dev, "could not find pmic sub-node\n");
 		return -ENXIO;
 	}
 
@@ -310,10 +311,10 @@ static int rk808_regulator_dts(struct rk808 *rk808)
 	if (!reg_np)
 		return -ENXIO;
 
-	ret = of_regulator_match(rk808->dev, reg_np, rk808_reg_matches,
+	ret = of_regulator_match(&client->dev, reg_np, rk808_reg_matches,
 				 RK808_NUM_REGULATORS);
-	if (ret  < 0) {
-		dev_err(rk808->dev,
+	if (ret < 0) {
+		dev_err(&client->dev,
 			"failed to parse regulator data: %d\n", ret);
 		return ret;
 	}
@@ -333,24 +334,17 @@ static int rk808_regulator_dts(struct rk808 *rk808)
 static int rk808_regulator_probe(struct platform_device *pdev)
 {
 	struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
-	struct rk808_board *pdata;
+	struct i2c_client *client = rk808->i2c;
+	struct rk808_board *pdata = rk808->pdata;
 	struct regulator_config config;
 	struct regulator_dev *rk808_rdev;
 	struct regulator_init_data *reg_data;
 	int i = 0;
 	int ret = 0;
 
-	dev_dbg(rk808->dev, "%s\n", __func__);
-
-	if (!rk808) {
-		dev_err(rk808->dev, "%s no rk808\n", __func__);
-		return -ENODEV;
-	}
-
-	pdata = rk808->pdata;
 	if (!pdata) {
-		dev_warn(rk808->dev, "%s no pdata, create it\n", __func__);
-		pdata = devm_kzalloc(rk808->dev, sizeof(*pdata), GFP_KERNEL);
+		dev_warn(&client->dev, "%s no pdata, create it\n", __func__);
+		pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
 		if (!pdata)
 			return -ENOMEM;
 	}
@@ -371,11 +365,11 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 		if (!reg_data)
 			continue;
 
-		config.dev = rk808->dev;
+		config.dev = &client->dev;
 		config.driver_data = rk808;
 		config.regmap = rk808->regmap;
 
-		if (rk808->dev->of_node)
+		if (client->dev.of_node)
 			config.of_node = pdata->of_node[i];
 
 		reg_data->supply_regulator = rk808_reg[i].name;
@@ -384,7 +378,7 @@ static int rk808_regulator_probe(struct platform_device *pdev)
 		rk808_rdev = devm_regulator_register(&pdev->dev,
 						     &rk808_reg[i], &config);
 		if (IS_ERR(rk808_rdev)) {
-			dev_err(rk808->dev,
+			dev_err(&client->dev,
 				"failed to register %d regulator\n", i);
 			return PTR_ERR(rk808_rdev);
 		}
-- 
1.7.9.5


