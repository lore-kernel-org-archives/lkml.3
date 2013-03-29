Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3C2VEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:04:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52872 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756894Ab3C2VDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:03:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: dp@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] regmap: cache: Factor out reg_present support from rbtree cache
Date: Fri, 29 Mar 2013 21:03:42 +0000
Message-Id: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea of maintaining a bitmap of present registers is something that
can usefully be used by other cache types that maintain blocks of cached
registers so move the code out of the rbtree cache and into the generic
regcache code.

Refactor the interface slightly as we go to wrap the set bit and enlarge
bitmap operations (since we never do one without the other) and make it
more robust for reads of uncached registers by bounds checking before we
look at the bitmap.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h        |   13 +++++++
 drivers/base/regmap/regcache-rbtree.c |   60 ++-------------------------------
 drivers/base/regmap/regcache.c        |   39 +++++++++++++++++++++
 3 files changed, 54 insertions(+), 58 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 663abf0..bd9e164 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -127,6 +127,9 @@ struct regmap {
 	void *cache;
 	u32 cache_dirty;
 
+	unsigned long *cache_present;
+	unsigned int cache_present_nbits;
+
 	struct reg_default *patch;
 	int patch_regs;
 
@@ -202,6 +205,16 @@ unsigned int regcache_get_val(struct regmap *map, const void *base,
 bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
 		      unsigned int val);
 int regcache_lookup_reg(struct regmap *map, unsigned int reg);
+int regcache_set_reg_present(struct regmap *map, unsigned int reg);
+
+static inline bool regcache_reg_present(struct regmap *map, unsigned int reg)
+{
+	if (!map->cache_present)
+		return true;
+	if (reg > map->cache_present_nbits)
+		return false;
+	return map->cache_present[BIT_WORD(reg)] & BIT_MASK(reg);
+}
 
 int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		      const void *val, size_t val_len, bool async);
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 2635a8f..545153a 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -36,8 +36,6 @@ struct regcache_rbtree_node {
 struct regcache_rbtree_ctx {
 	struct rb_root root;
 	struct regcache_rbtree_node *cached_rbnode;
-	unsigned long *reg_present;
-	unsigned int reg_present_nbits;
 };
 
 static inline void regcache_rbtree_get_base_top_reg(
@@ -154,7 +152,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	map->lock(map);
 
 	mem_size = sizeof(*rbtree_ctx);
-	mem_size += BITS_TO_LONGS(rbtree_ctx->reg_present_nbits) * sizeof(long);
+	mem_size += BITS_TO_LONGS(map->cache_present_nbits) * sizeof(long);
 
 	for (node = rb_first(&rbtree_ctx->root); node != NULL;
 	     node = rb_next(node)) {
@@ -205,44 +203,6 @@ static void rbtree_debugfs_init(struct regmap *map)
 }
 #endif
 
-static int enlarge_reg_present_bitmap(struct regmap *map, unsigned int reg)
-{
-	struct regcache_rbtree_ctx *rbtree_ctx;
-	unsigned long *reg_present;
-	unsigned int reg_present_size;
-	unsigned int nregs;
-	int i;
-
-	rbtree_ctx = map->cache;
-	nregs = reg + 1;
-	reg_present_size = BITS_TO_LONGS(nregs);
-	reg_present_size *= sizeof(long);
-
-	if (!rbtree_ctx->reg_present) {
-		reg_present = kmalloc(reg_present_size, GFP_KERNEL);
-		if (!reg_present)
-			return -ENOMEM;
-		bitmap_zero(reg_present, nregs);
-		rbtree_ctx->reg_present = reg_present;
-		rbtree_ctx->reg_present_nbits = nregs;
-		return 0;
-	}
-
-	if (nregs > rbtree_ctx->reg_present_nbits) {
-		reg_present = krealloc(rbtree_ctx->reg_present,
-				       reg_present_size, GFP_KERNEL);
-		if (!reg_present)
-			return -ENOMEM;
-		for (i = 0; i < nregs; i++)
-			if (i >= rbtree_ctx->reg_present_nbits)
-				clear_bit(i, reg_present);
-		rbtree_ctx->reg_present = reg_present;
-		rbtree_ctx->reg_present_nbits = nregs;
-	}
-
-	return 0;
-}
-
 static int regcache_rbtree_init(struct regmap *map)
 {
 	struct regcache_rbtree_ctx *rbtree_ctx;
@@ -256,8 +216,6 @@ static int regcache_rbtree_init(struct regmap *map)
 	rbtree_ctx = map->cache;
 	rbtree_ctx->root = RB_ROOT;
 	rbtree_ctx->cached_rbnode = NULL;
-	rbtree_ctx->reg_present = NULL;
-	rbtree_ctx->reg_present_nbits = 0;
 
 	for (i = 0; i < map->num_reg_defaults; i++) {
 		ret = regcache_rbtree_write(map,
@@ -287,8 +245,6 @@ static int regcache_rbtree_exit(struct regmap *map)
 	if (!rbtree_ctx)
 		return 0;
 
-	kfree(rbtree_ctx->reg_present);
-
 	/* free up the rbtree */
 	next = rb_first(&rbtree_ctx->root);
 	while (next) {
@@ -306,17 +262,6 @@ static int regcache_rbtree_exit(struct regmap *map)
 	return 0;
 }
 
-static int regcache_reg_present(struct regmap *map, unsigned int reg)
-{
-	struct regcache_rbtree_ctx *rbtree_ctx;
-
-	rbtree_ctx = map->cache;
-	if (!(rbtree_ctx->reg_present[BIT_WORD(reg)] & BIT_MASK(reg)))
-		return 0;
-	return 1;
-
-}
-
 static int regcache_rbtree_read(struct regmap *map,
 				unsigned int reg, unsigned int *value)
 {
@@ -378,10 +323,9 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 
 	rbtree_ctx = map->cache;
 	/* update the reg_present bitmap, make space if necessary */
-	ret = enlarge_reg_present_bitmap(map, reg);
+	ret = regcache_set_reg_present(map, reg);
 	if (ret < 0)
 		return ret;
-	set_bit(reg, rbtree_ctx->reg_present);
 
 	/* if we can't locate it in the cached rbnode we'll have
 	 * to traverse the rbtree looking for it.
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 229c804..0fedf4f 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -121,6 +121,8 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 	map->reg_defaults_raw = config->reg_defaults_raw;
 	map->cache_word_size = DIV_ROUND_UP(config->val_bits, 8);
 	map->cache_size_raw = map->cache_word_size * config->num_reg_defaults_raw;
+	map->cache_present = NULL;
+	map->cache_present_nbits = 0;
 
 	map->cache = NULL;
 	map->cache_ops = cache_types[i];
@@ -179,6 +181,7 @@ void regcache_exit(struct regmap *map)
 
 	BUG_ON(!map->cache_ops);
 
+	kfree(map->cache_present);
 	kfree(map->reg_defaults);
 	if (map->cache_free)
 		kfree(map->reg_defaults_raw);
@@ -415,6 +418,42 @@ void regcache_cache_bypass(struct regmap *map, bool enable)
 }
 EXPORT_SYMBOL_GPL(regcache_cache_bypass);
 
+int regcache_set_reg_present(struct regmap *map, unsigned int reg)
+{
+	unsigned long *cache_present;
+	unsigned int cache_present_size;
+	unsigned int nregs;
+	int i;
+
+	nregs = reg + 1;
+	cache_present_size = BITS_TO_LONGS(nregs);
+	cache_present_size *= sizeof(long);
+
+	if (!map->cache_present) {
+		cache_present = kmalloc(cache_present_size, GFP_KERNEL);
+		if (!cache_present)
+			return -ENOMEM;
+		bitmap_zero(cache_present, nregs);
+		map->cache_present = cache_present;
+		map->cache_present_nbits = nregs;
+	}
+
+	if (nregs > map->cache_present_nbits) {
+		cache_present = krealloc(map->cache_present,
+					 cache_present_size, GFP_KERNEL);
+		if (!cache_present)
+			return -ENOMEM;
+		for (i = 0; i < nregs; i++)
+			if (i >= map->cache_present_nbits)
+				clear_bit(i, cache_present);
+		map->cache_present = cache_present;
+		map->cache_present_nbits = nregs;
+	}
+
+	set_bit(reg, map->cache_present);
+	return 0;
+}
+
 bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
 		      unsigned int val)
 {
-- 
1.7.10.4

