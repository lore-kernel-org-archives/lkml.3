Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3BKKvD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:51:03 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43524 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab3BKKvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:51:02 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] regmap: debugfs: Factor out debugfs_tot_len calc into a function
Date: Mon, 11 Feb 2013 10:50:59 +0000
Message-Id: <1360579859-26684-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to support the regmap debugfs ranges functionality
factor this code out to a separate function.  We'll need to ensure
that the value has been correctly calculated from two separate places
in the code.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 246f459..78d5f20 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -155,6 +155,19 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	return ret;
 }
 
+static inline void regmap_calc_tot_len(struct regmap *map,
+				       void *buf, size_t count)
+{
+	/* Calculate the length of a fixed format  */
+	if (!map->debugfs_tot_len) {
+		map->debugfs_reg_len = regmap_calc_reg_len(map->max_register,
+							   buf, count);
+		map->debugfs_val_len = 2 * map->format.val_bytes;
+		map->debugfs_tot_len = map->debugfs_reg_len +
+			map->debugfs_val_len + 3;      /* : \n */
+	}
+}
+
 static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
 				   unsigned int to, char __user *user_buf,
 				   size_t count, loff_t *ppos)
@@ -173,14 +186,7 @@ static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
 	if (!buf)
 		return -ENOMEM;
 
-	/* Calculate the length of a fixed format  */
-	if (!map->debugfs_tot_len) {
-		map->debugfs_reg_len = regmap_calc_reg_len(map->max_register,
-							   buf, count);
-		map->debugfs_val_len = 2 * map->format.val_bytes;
-		map->debugfs_tot_len = map->debugfs_reg_len +
-			map->debugfs_val_len + 3;      /* : \n */
-	}
+	regmap_calc_tot_len(map, buf, count);
 
 	/* Work out which register we're starting at */
 	start_reg = regmap_debugfs_get_dump_start(map, from, *ppos, &p);
-- 
1.8.1.3

