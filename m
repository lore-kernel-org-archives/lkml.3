Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084Ab3DGRCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 13:02:21 -0400
Received: from smtp1.mail.ru ([94.100.176.129]:50882 "EHLO smtp1.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934059Ab3DGRCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 13:02:20 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <s.hauer@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH] regulator: mc13783: Add device tree probe support
Date: Sun,  7 Apr 2013 21:02:11 +0400
Message-Id: <1365354131-9770-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.1.5
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch adds device tree probe support for mc13783-regulator driver.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/regulator/mc13783-regulator.c      | 55 ++++++++++++++++++++++--------
 drivers/regulator/mc13xxx-regulator-core.c |  2 ++
 2 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/drivers/regulator/mc13783-regulator.c b/drivers/regulator/mc13783-regulator.c
index c46c670..fba8d5e 100644
--- a/drivers/regulator/mc13783-regulator.c
+++ b/drivers/regulator/mc13783-regulator.c
@@ -398,33 +398,62 @@ static int mc13783_regulator_probe(struct platform_device *pdev)
 	struct mc13xxx *mc13783 = dev_get_drvdata(pdev->dev.parent);
 	struct mc13xxx_regulator_platform_data *pdata =
 		dev_get_platdata(&pdev->dev);
-	struct mc13xxx_regulator_init_data *init_data;
+	struct mc13xxx_regulator_init_data *mc13xxx_data;
 	struct regulator_config config = { };
-	int i, ret;
+	int i, ret, num_regulators, num_parsed;
 
-	dev_dbg(&pdev->dev, "%s id %d\n", __func__, pdev->id);
+	num_regulators = mc13xxx_get_num_regulators_dt(pdev);
 
-	if (!pdata)
+	if (num_regulators <= 0 && pdata)
+		num_regulators = pdata->num_regulators;
+	if (num_regulators <= 0)
 		return -EINVAL;
 
+	num_parsed = num_regulators;
+
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv) +
-			pdata->num_regulators * sizeof(priv->regulators[0]),
+			num_regulators * sizeof(priv->regulators[0]),
 			GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	priv->num_regulators = num_regulators;
 	priv->mc13xxx_regulators = mc13783_regulators;
 	priv->mc13xxx = mc13783;
+	platform_set_drvdata(pdev, priv);
 
-	for (i = 0; i < pdata->num_regulators; i++) {
-		struct regulator_desc *desc;
+	mc13xxx_data = mc13xxx_parse_regulators_dt(pdev, mc13783_regulators,
+					ARRAY_SIZE(mc13783_regulators),
+					&num_parsed);
+	if (num_parsed != num_regulators) {
+		dev_warn(&pdev->dev,
+		"parsed %d != regulators %d - check your device tree!\n",
+			num_parsed, num_regulators);
 
-		init_data = &pdata->regulators[i];
-		desc = &mc13783_regulators[init_data->id].desc;
+		num_regulators = num_parsed;
+		priv->num_regulators = num_regulators;
+	}
+
+	for (i = 0; i < num_regulators; i++) {
+		struct regulator_init_data *init_data;
+		struct regulator_desc *desc;
+		struct device_node *node = NULL;
+		int id;
+
+		if (mc13xxx_data) {
+			id = mc13xxx_data[i].id;
+			init_data = mc13xxx_data[i].init_data;
+			node = mc13xxx_data[i].node;
+		} else {
+			id = pdata->regulators[i].id;
+			init_data = pdata->regulators[i].init_data;
+		}
+		desc = &mc13783_regulators[id].desc;
 
 		config.dev = &pdev->dev;
-		config.init_data = init_data->init_data;
+		config.init_data = init_data;
 		config.driver_data = priv;
+		config.of_node = node;
 
 		priv->regulators[i] = regulator_register(desc, &config);
 		if (IS_ERR(priv->regulators[i])) {
@@ -435,8 +464,6 @@ static int mc13783_regulator_probe(struct platform_device *pdev)
 		}
 	}
 
-	platform_set_drvdata(pdev, priv);
-
 	return 0;
 err:
 	while (--i >= 0)
@@ -448,13 +475,11 @@ err:
 static int mc13783_regulator_remove(struct platform_device *pdev)
 {
 	struct mc13xxx_regulator_priv *priv = platform_get_drvdata(pdev);
-	struct mc13xxx_regulator_platform_data *pdata =
-		dev_get_platdata(&pdev->dev);
 	int i;
 
 	platform_set_drvdata(pdev, NULL);
 
-	for (i = 0; i < pdata->num_regulators; i++)
+	for (i = 0; i < priv->num_regulators; i++)
 		regulator_unregister(priv->regulators[i]);
 
 	return 0;
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index 23cf9f9..836e21e 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -205,6 +205,8 @@ struct mc13xxx_regulator_init_data *mc13xxx_parse_regulators_dt(
 
 	for_each_child_of_node(parent, child) {
 		for (i = 0; i < num_regulators; i++) {
+			if (!regulators[i].desc.name)
+				continue;
 			if (!of_node_cmp(child->name,
 					 regulators[i].desc.name)) {
 
-- 
1.8.1.5

