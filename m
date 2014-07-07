Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaGGVm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 17:42:26 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:49396 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaGGVmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 17:42:25 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: Axel Lin <axel.lin@ingics.com>, Wenyou Yang <wenyou.yang@atmel.com>,
        linux-kernel@vger.kernel.org, Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH] regulator:act8865: fix build when OF is not enabled
Date: Mon,  7 Jul 2014 23:40:47 +0200
Message-Id: <1404769247-12648-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

act8846_matches and act8865_matches are defined only when OF is
enabled. Move references to them to the act8865_pdata_from_dt()
function to avoid a build error when OF is disabled.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/regulator/act8865-regulator.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index a5ad69a..afd06f9 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -198,12 +198,12 @@ static struct of_regulator_match act8865_matches[] = {
 static int act8865_pdata_from_dt(struct device *dev,
 				 struct device_node **of_node,
 				 struct act8865_platform_data *pdata,
-				 struct of_regulator_match *matches,
-				 int num_matches)
+				 unsigned long type)
 {
-	int matched, i;
+	int matched, i, num_matches;
 	struct device_node *np;
 	struct act8865_regulator_data *regulator;
+	struct of_regulator_match *matches;
 
 	np = of_get_child_by_name(dev->of_node, "regulators");
 	if (!np) {
@@ -211,6 +211,20 @@ static int act8865_pdata_from_dt(struct device *dev,
 		return -EINVAL;
 	}
 
+	switch (type) {
+	case ACT8846:
+		matches = act8846_matches;
+		num_matches = ARRAY_SIZE(act8846_matches);
+		break;
+	case ACT8865:
+		matches = act8865_matches;
+		num_matches = ARRAY_SIZE(act8865_matches);
+		break;
+	default:
+		dev_err(dev, "invalid device id %lu\n", type);
+		return -EINVAL;
+	}
+
 	matched = of_regulator_match(dev, np, matches, num_matches);
 	of_node_put(np);
 	if (matched <= 0)
@@ -238,7 +252,8 @@ static int act8865_pdata_from_dt(struct device *dev,
 #else
 static inline int act8865_pdata_from_dt(struct device *dev,
 					struct device_node **of_node,
-					struct act8865_platform_data *pdata)
+					struct act8865_platform_data *pdata,
+					unsigned long type)
 {
 	return 0;
 }
@@ -265,7 +280,6 @@ static int act8865_pmic_probe(struct i2c_client *client,
 {
 	static const struct regulator_desc *regulators;
 	struct act8865_platform_data pdata_of, *pdata;
-	struct of_regulator_match *matches;
 	struct device *dev = &client->dev;
 	struct device_node **of_node;
 	int i, ret, num_regulators;
@@ -288,12 +302,10 @@ static int act8865_pmic_probe(struct i2c_client *client,
 
 	switch (type) {
 	case ACT8846:
-		matches = act8846_matches;
 		regulators = act8846_regulators;
 		num_regulators = ARRAY_SIZE(act8846_regulators);
 		break;
 	case ACT8865:
-		matches = act8865_matches;
 		regulators = act8865_regulators;
 		num_regulators = ARRAY_SIZE(act8865_regulators);
 		break;
@@ -308,8 +320,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	if (dev->of_node && !pdata) {
-		ret = act8865_pdata_from_dt(dev, of_node, &pdata_of, matches,
-					    num_regulators);
+		ret = act8865_pdata_from_dt(dev, of_node, &pdata_of, type);
 		if (ret < 0)
 			return ret;
 
-- 
1.7.10.4

