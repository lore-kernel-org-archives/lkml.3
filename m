Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935259Ab3BTMP0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:15:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36026 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935029Ab3BTMPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:15:25 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 1/2 v2] regmap: debugfs: Simplify calculation of `c->max_reg'
Date: Wed, 20 Feb 2013 12:15:22 +0000
Message-Id: <1361362523-8120-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to use any of the file position information
to calculate the base and max register of each block.  Just
use the counter directly.

Set `i = base' at the top to avoid GCC flow analysis bugs.  The
value of `i' can never be undefined or 0 in the if (c) { ... }.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 78d5f20..e14cb2d 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -88,16 +88,15 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	 * If we don't have a cache build one so we don't have to do a
 	 * linear scan each time.
 	 */
+	i = base;
 	if (list_empty(&map->debugfs_off_cache)) {
-		for (i = base; i <= map->max_register; i += map->reg_stride) {
+		for (; i <= map->max_register; i += map->reg_stride) {
 			/* Skip unprinted registers, closing off cache entry */
 			if (!regmap_readable(map, i) ||
 			    regmap_precious(map, i)) {
 				if (c) {
 					c->max = p - 1;
-					fpos_offset = c->max - c->min;
-					reg_offset = fpos_offset / map->debugfs_tot_len;
-					c->max_reg = c->base_reg + reg_offset;
+					c->max_reg = i - map->reg_stride;
 					list_add_tail(&c->list,
 						      &map->debugfs_off_cache);
 					c = NULL;
@@ -124,9 +123,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	/* Close the last entry off if we didn't scan beyond it */
 	if (c) {
 		c->max = p - 1;
-		fpos_offset = c->max - c->min;
-		reg_offset = fpos_offset / map->debugfs_tot_len;
-		c->max_reg = c->base_reg + reg_offset;
+		c->max_reg = i - map->reg_stride;
 		list_add_tail(&c->list,
 			      &map->debugfs_off_cache);
 	}
-- 
1.8.1.3

