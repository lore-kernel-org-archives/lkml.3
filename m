Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaDOMmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:42:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47329 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbaDOMml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:42:41 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH] regulator: core: Use devres for releasing of_regulator_match of_nodes
Date: Tue, 15 Apr 2014 13:34:36 +0100
Message-Id: <1397565276-31288-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than requiring individual drivers to put the of_nodes returned
from of_regulator_match use devres to put them. This also has the
benefit it makes the life-time of the of_nodes match the lifetime of
the init data also contained in the of_regulator_match structure, which
seems more consistent.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/of_regulator.c       |   47 +++++++++++++++++--------------
 include/linux/regulator/of_regulator.h |    7 -----
 2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 188e0cb..4672cd2 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -106,6 +106,20 @@ struct regulator_init_data *of_get_regulator_init_data(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(of_get_regulator_init_data);
 
+struct devm_of_regulator_matches {
+	struct of_regulator_match *matches;
+	unsigned int num_matches;
+};
+
+static void devm_of_regulator_put_matches(struct device *dev, void *res)
+{
+	struct devm_of_regulator_matches *devm_matches = res;
+	int i;
+
+	for (i = 0; i < devm_matches->num_matches; i++)
+		of_node_put(devm_matches->matches[i].of_node);
+}
+
 /**
  * of_regulator_match - extract multiple regulator init data from device tree.
  * @dev: device requesting the data
@@ -132,10 +146,22 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 	unsigned int i;
 	const char *name;
 	struct device_node *child;
+	struct devm_of_regulator_matches *devm_matches;
 
 	if (!dev || !node)
 		return -EINVAL;
 
+	devm_matches = devres_alloc(devm_of_regulator_put_matches,
+				    sizeof(struct devm_of_regulator_matches),
+				    GFP_KERNEL);
+	if (!devm_matches)
+		return -ENOMEM;
+
+	devm_matches->matches = matches;
+	devm_matches->num_matches = num_matches;
+
+	devres_add(dev, devm_matches);
+
 	for (i = 0; i < num_matches; i++) {
 		struct of_regulator_match *match = &matches[i];
 		match->init_data = NULL;
@@ -172,24 +198,3 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 	return count;
 }
 EXPORT_SYMBOL_GPL(of_regulator_match);
-
-/**
- * of_regulator_put_match - put the of_node references from an
- *                          of_regulator_match structure
- * @matches: match table for the regulators
- * @num_matches: number of entries in match table
- *
- * This function goes through a match table and calls of_node_put on each
- * of_node.
- */
-int of_regulator_put_match(struct of_regulator_match *matches,
-			   unsigned int num_matches)
-{
-	int i;
-
-	for (i = 0; i < num_matches; i++)
-		of_node_put(matches[i].of_node);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(of_regulator_put_match);
diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
index a5abd83..f921796 100644
--- a/include/linux/regulator/of_regulator.h
+++ b/include/linux/regulator/of_regulator.h
@@ -20,8 +20,6 @@ extern struct regulator_init_data
 extern int of_regulator_match(struct device *dev, struct device_node *node,
 			      struct of_regulator_match *matches,
 			      unsigned int num_matches);
-extern int of_regulator_put_match(struct of_regulator_match *matches,
-				  unsigned int num_matches);
 #else
 static inline struct regulator_init_data
 	*of_get_regulator_init_data(struct device *dev,
@@ -37,11 +35,6 @@ static inline int of_regulator_match(struct device *dev,
 {
 	return 0;
 }
-static inline int of_regulator_put_match(struct of_regulator_match *matches,
-					 unsigned int num_matches)
-{
-	return 0;
-}
 #endif /* CONFIG_OF */
 
 #endif /* __LINUX_OF_REG_H */
-- 
1.7.2.5

