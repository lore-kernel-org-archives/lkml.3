Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaDCOlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:41:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50289 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbaDCOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:41:08 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: [PATCH 2/3] regulator: core: Add helper to put of_nodes from matches
Date: Thu,  3 Apr 2014 15:32:16 +0100
Message-Id: <1396535537-1352-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1396535537-1352-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1396535537-1352-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of_regulator_match will take an of_node reference to each matched
regulator, it makes sense to provide a helper to put all those
references. This patch does that.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/regulator/of_regulator.c       |   21 +++++++++++++++++++++
 include/linux/regulator/of_regulator.h |    7 +++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index c58c8d1..188e0cb 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -172,3 +172,24 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 	return count;
 }
 EXPORT_SYMBOL_GPL(of_regulator_match);
+
+/**
+ * of_regulator_put_match - put the of_node references from an
+ *                          of_regulator_match structure
+ * @matches: match table for the regulators
+ * @num_matches: number of entries in match table
+ *
+ * This function goes through a match table and calls of_node_put on each
+ * of_node.
+ */
+int of_regulator_put_match(struct of_regulator_match *matches,
+			   unsigned int num_matches)
+{
+	int i;
+
+	for (i = 0; i < num_matches; i++)
+		of_node_put(matches[i].of_node);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_regulator_put_match);
diff --git a/include/linux/regulator/of_regulator.h b/include/linux/regulator/of_regulator.h
index f921796..0652851 100644
--- a/include/linux/regulator/of_regulator.h
+++ b/include/linux/regulator/of_regulator.h
@@ -20,6 +20,8 @@ extern struct regulator_init_data
 extern int of_regulator_match(struct device *dev, struct device_node *node,
 			      struct of_regulator_match *matches,
 			      unsigned int num_matches);
+extern int of_regulator_put_match(struct of_regulator_match *matches,
+				  unsigned int num_matches);
 #else
 static inline struct regulator_init_data
 	*of_get_regulator_init_data(struct device *dev,
@@ -35,6 +37,11 @@ static inline int of_regulator_match(struct device *dev,
 {
 	return 0;
 }
+static inline int of_regulator_put_match(struct of_regulator_match *matches,
+					 unsigned int num_matches);
+{
+	return 0;
+}
 #endif /* CONFIG_OF */
 
 #endif /* __LINUX_OF_REG_H */
-- 
1.7.2.5

