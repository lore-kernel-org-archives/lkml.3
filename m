Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768Ab3BNQcs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:32:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57784 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755903Ab3BNQcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:32:19 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 2/3] regmap: debugfs: Ensure proper locking of `debugfs_off_cache' list
Date: Thu, 14 Feb 2013 16:30:00 +0000
Message-Id: <1360859401-752-2-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360859401-752-1-git-send-email-dp@opensource.wolfsonmicro.com>
References: <1360859401-752-1-git-send-email-dp@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a possible race between the read operations of the `registers'
file and the `range' file.  Close that down by taking the appropriate
locks when modifying/accessing the list.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h       | 1 +
 drivers/base/regmap/regmap-debugfs.c | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 5a22bd3..dc23508 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -76,6 +76,7 @@ struct regmap {
 	unsigned int debugfs_tot_len;
 
 	struct list_head debugfs_off_cache;
+	struct mutex cache_lock;
 #endif
 
 	unsigned int max_register;
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index e14cb2d..a6b5606 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -88,6 +88,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	 * If we don't have a cache build one so we don't have to do a
 	 * linear scan each time.
 	 */
+	mutex_lock(&map->cache_lock);
 	i = base;
 	if (list_empty(&map->debugfs_off_cache)) {
 		for (; i <= map->max_register; i += map->reg_stride) {
@@ -110,6 +111,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 				c = kzalloc(sizeof(*c), GFP_KERNEL);
 				if (!c) {
 					regmap_debugfs_free_dump_cache(map);
+					mutex_unlock(&map->cache_lock);
 					return base;
 				}
 				c->min = p;
@@ -142,12 +144,14 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 			fpos_offset = from - c->min;
 			reg_offset = fpos_offset / map->debugfs_tot_len;
 			*pos = c->min + (reg_offset * map->debugfs_tot_len);
+			mutex_unlock(&map->cache_lock);
 			return c->base_reg + reg_offset;
 		}
 
 		*pos = c->max;
 		ret = c->max_reg;
 	}
+	mutex_unlock(&map->cache_lock);
 
 	return ret;
 }
@@ -382,6 +386,7 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 	struct regmap_range_node *range_node;
 
 	INIT_LIST_HEAD(&map->debugfs_off_cache);
+	mutex_init(&map->cache_lock);
 
 	if (name) {
 		map->debugfs_name = kasprintf(GFP_KERNEL, "%s-%s",
@@ -432,7 +437,9 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 void regmap_debugfs_exit(struct regmap *map)
 {
 	debugfs_remove_recursive(map->debugfs);
+	mutex_lock(&map->cache_lock);
 	regmap_debugfs_free_dump_cache(map);
+	mutex_unlock(&map->cache_lock);
 	kfree(map->debugfs_name);
 }
 
-- 
1.8.1.3

