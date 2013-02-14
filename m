Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759946Ab3BNMeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:34:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56573 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934608Ab3BNMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:34:13 -0500
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH 2/2] regmap: debugfs: Ensure proper locking of `debugfs_off_cache' list
Date: Thu, 14 Feb 2013 12:31:48 +0000
Message-Id: <1360845108-30428-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a possible race between the read operations of the `registers'
file and the `range' file.  Close that down by taking the appropriate
locks when modifying/accessing the list.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h       |  1 +
 drivers/base/regmap/regmap-debugfs.c | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index b4e55a0..640c5a4 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -77,6 +77,7 @@ struct regmap {
 	unsigned int debugfs_tot_len;
 
 	struct list_head debugfs_off_cache;
+	struct mutex cache_lock;
 #endif
 
 	unsigned int max_register;
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 5843eb1..89a5a85 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -76,6 +76,7 @@ static inline unsigned int regmap_attr_bitmap(struct regmap *map,
 	return reg_attr;
 }
 
+/* Called with `cache_lock' held */
 static void regmap_debugfs_free_dump_cache(struct regmap *map)
 {
 	struct regmap_debugfs_off_cache *c;
@@ -108,6 +109,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 	 * If we don't have a cache build one so we don't have to do a
 	 * linear scan each time.
 	 */
+	mutex_lock(&map->cache_lock);
 	if (list_empty(&map->debugfs_off_cache)) {
 		for (i = base; i <= map->max_register; i += map->reg_stride) {
 			/* Skip unprinted registers, closing off cache entry */
@@ -130,6 +132,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 				c = kzalloc(sizeof(*c), GFP_KERNEL);
 				if (!c) {
 					regmap_debugfs_free_dump_cache(map);
+					mutex_unlock(&map->cache_lock);
 					return base;
 				}
 				c->min = p;
@@ -163,12 +166,14 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
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
@@ -392,6 +397,7 @@ static ssize_t regmap_reg_ranges_read_file(struct file *file,
 	/* Reset file pointer as the fixed-format of the `registers'
 	 * file is not compatible with the `range' file */
 	p = 0;
+	mutex_lock(&map->cache_lock);
 	list_for_each_entry(c, &map->debugfs_off_cache, list) {
 		regmap_range_format_line(map, c, entry, PAGE_SIZE);
 		if (p >= *ppos) {
@@ -405,6 +411,7 @@ static ssize_t regmap_reg_ranges_read_file(struct file *file,
 		}
 		p += strlen(entry) + 1;
 	}
+	mutex_unlock(&map->cache_lock);
 
 	kfree(entry);
 	ret = buf_pos;
@@ -500,6 +507,7 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 	struct regmap_range_node *range_node;
 
 	INIT_LIST_HEAD(&map->debugfs_off_cache);
+	mutex_init(&map->cache_lock);
 
 	if (name) {
 		map->debugfs_name = kasprintf(GFP_KERNEL, "%s-%s",
@@ -553,7 +561,9 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
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

