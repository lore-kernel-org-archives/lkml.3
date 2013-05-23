Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab3EWPYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:24:11 -0400
Received: from smtp-out-100.synserver.de ([212.40.185.100]:1090 "EHLO
	smtp-out-100.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab3EWPYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:24:08 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 3223
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH for 3.10-rc2] regmap: regcache: Fixup locking for custom lock callbacks
Date: Thu, 23 May 2013 17:23:49 +0200
Message-Id: <1369322629-25157-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The parameter passed to the regmap lock/unlock callbacks needs to be
map->lock_arg, regcache passes just map. This works fine in the case that no
custom locking callbacks are used since in this case map->lock_arg equals map,
but will break when custom locking callbacks are used. The issue was introduced
in commit 0d4529c5("regmap: make lock/unlock functions customizable") and is
fixed by this patch.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache-rbtree.c |  4 ++--
 drivers/base/regmap/regcache.c        | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index aa0875f..b4e343b 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -143,7 +143,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	int registers = 0;
 	int this_registers, average;
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 
 	mem_size = sizeof(*rbtree_ctx);
 	mem_size += BITS_TO_LONGS(map->cache_present_nbits) * sizeof(long);
@@ -170,7 +170,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	seq_printf(s, "%d nodes, %d registers, average %d registers, used %zu bytes\n",
 		   nodes, registers, average, mem_size);
 
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 
 	return 0;
 }
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 75923f2..507ee2d 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -270,7 +270,7 @@ int regcache_sync(struct regmap *map)
 
 	BUG_ON(!map->cache_ops || !map->cache_ops->sync);
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 	/* Remember the initial bypass state */
 	bypass = map->cache_bypass;
 	dev_dbg(map->dev, "Syncing %s cache\n",
@@ -306,7 +306,7 @@ out:
 	trace_regcache_sync(map->dev, name, "stop");
 	/* Restore the bypass state */
 	map->cache_bypass = bypass;
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 
 	return ret;
 }
@@ -333,7 +333,7 @@ int regcache_sync_region(struct regmap *map, unsigned int min,
 
 	BUG_ON(!map->cache_ops || !map->cache_ops->sync);
 
-	map->lock(map);
+	map->lock(map->lock_arg);
 
 	/* Remember the initial bypass state */
 	bypass = map->cache_bypass;
@@ -352,7 +352,7 @@ out:
 	trace_regcache_sync(map->dev, name, "stop region");
 	/* Restore the bypass state */
 	map->cache_bypass = bypass;
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 
 	return ret;
 }
@@ -372,11 +372,11 @@ EXPORT_SYMBOL_GPL(regcache_sync_region);
  */
 void regcache_cache_only(struct regmap *map, bool enable)
 {
-	map->lock(map);
+	map->lock(map->lock_arg);
 	WARN_ON(map->cache_bypass && enable);
 	map->cache_only = enable;
 	trace_regmap_cache_only(map->dev, enable);
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_only);
 
@@ -391,9 +391,9 @@ EXPORT_SYMBOL_GPL(regcache_cache_only);
  */
 void regcache_mark_dirty(struct regmap *map)
 {
-	map->lock(map);
+	map->lock(map->lock_arg);
 	map->cache_dirty = true;
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 }
 EXPORT_SYMBOL_GPL(regcache_mark_dirty);
 
@@ -410,11 +410,11 @@ EXPORT_SYMBOL_GPL(regcache_mark_dirty);
  */
 void regcache_cache_bypass(struct regmap *map, bool enable)
 {
-	map->lock(map);
+	map->lock(map->lock_arg);
 	WARN_ON(map->cache_only && enable);
 	map->cache_bypass = enable;
 	trace_regmap_cache_bypass(map->dev, enable);
-	map->unlock(map);
+	map->unlock(map->lock_arg);
 }
 EXPORT_SYMBOL_GPL(regcache_cache_bypass);
 
-- 
1.8.0

