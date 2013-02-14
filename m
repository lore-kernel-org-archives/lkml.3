Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269Ab3BNOG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:06:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54286 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757544Ab3BNOG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:06:27 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH v2] regmap: debugfs: Simplify calculation of `c->max_reg'
Date: Thu, 14 Feb 2013 14:04:04 +0000
Message-Id: <1360850644-15581-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to use any of the file position information
to calculate the base and max register of each block.  Just
use the counter directly.

Ensure that in the limiting case where there is a single
register in the register file we handle that properly in
the if (c) { ... } code after the loop without causing
an integer wrap-around.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 78d5f20..d804b74 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -80,7 +80,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 {
 	struct regmap_debugfs_off_cache *c = NULL;
 	loff_t p = 0;
-	unsigned int i, ret;
+	unsigned int i = 0, ret;
 	unsigned int fpos_offset;
 	unsigned int reg_offset;
 
@@ -95,9 +95,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 			    regmap_precious(map, i)) {
 				if (c) {
 					c->max = p - 1;
-					fpos_offset = c->max - c->min;
-					reg_offset = fpos_offset / map->debugfs_tot_len;
-					c->max_reg = c->base_reg + reg_offset;
+					c->max_reg = i - 1;
 					list_add_tail(&c->list,
 						      &map->debugfs_off_cache);
 					c = NULL;
@@ -124,9 +122,10 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	/* Close the last entry off if we didn't scan beyond it */
 	if (c) {
 		c->max = p - 1;
-		fpos_offset = c->max - c->min;
-		reg_offset = fpos_offset / map->debugfs_tot_len;
-		c->max_reg = c->base_reg + reg_offset;
+		if (!i)
+			c->max_reg = 0;
+		else
+			c->max_reg = i - 1;
 		list_add_tail(&c->list,
 			      &map->debugfs_off_cache);
 	}
-- 
1.8.1.3

