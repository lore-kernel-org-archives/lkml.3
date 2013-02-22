Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3BVNvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:51:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52441 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183Ab3BVNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:51:23 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] regmap: cache: Pass the map rather than the word size when updating values
Date: Fri, 22 Feb 2013 13:51:17 +0000
Message-Id: <1361541078-31614-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361541078-31614-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1361541078-31614-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's more idiomatic to pass the map structure around and this means we
can use other bits of information from the map.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h        |    8 +++---
 drivers/base/regmap/regcache-lzo.c    |    6 ++--
 drivers/base/regmap/regcache-rbtree.c |   51 ++++++++++++++++-----------------
 drivers/base/regmap/regcache.c        |   18 ++++++------
 4 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 5a22bd3..582d7fd 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -188,10 +188,10 @@ int regcache_write(struct regmap *map,
 			unsigned int reg, unsigned int value);
 int regcache_sync(struct regmap *map);
 
-unsigned int regcache_get_val(const void *base, unsigned int idx,
-			      unsigned int word_size);
-bool regcache_set_val(void *base, unsigned int idx,
-		      unsigned int val, unsigned int word_size);
+unsigned int regcache_get_val(struct regmap *map, const void *base,
+			      unsigned int idx);
+bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
+		      unsigned int val);
 int regcache_lookup_reg(struct regmap *map, unsigned int reg);
 
 void regmap_async_complete_cb(struct regmap_async *async, int ret);
diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index afd6aa9..e210a6d 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -260,8 +260,7 @@ static int regcache_lzo_read(struct regmap *map,
 	ret = regcache_lzo_decompress_cache_block(map, lzo_block);
 	if (ret >= 0)
 		/* fetch the value from the cache */
-		*value = regcache_get_val(lzo_block->dst, blkpos,
-					  map->cache_word_size);
+		*value = regcache_get_val(map, lzo_block->dst, blkpos);
 
 	kfree(lzo_block->dst);
 	/* restore the pointer and length of the compressed block */
@@ -304,8 +303,7 @@ static int regcache_lzo_write(struct regmap *map,
 	}
 
 	/* write the new value to the cache */
-	if (regcache_set_val(lzo_block->dst, blkpos, value,
-			     map->cache_word_size)) {
+	if (regcache_set_val(map, lzo_block->dst, blkpos, value)) {
 		kfree(lzo_block->dst);
 		goto out;
 	}
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 3f21c6a..461cff8 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -47,22 +47,21 @@ static inline void regcache_rbtree_get_base_top_reg(
 	*top = rbnode->base_reg + ((rbnode->blklen - 1) * map->reg_stride);
 }
 
-static unsigned int regcache_rbtree_get_register(
-	struct regcache_rbtree_node *rbnode, unsigned int idx,
-	unsigned int word_size)
+static unsigned int regcache_rbtree_get_register(struct regmap *map,
+	struct regcache_rbtree_node *rbnode, unsigned int idx)
 {
-	return regcache_get_val(rbnode->block, idx, word_size);
+	return regcache_get_val(map, rbnode->block, idx);
 }
 
-static void regcache_rbtree_set_register(struct regcache_rbtree_node *rbnode,
-					 unsigned int idx, unsigned int val,
-					 unsigned int word_size)
+static void regcache_rbtree_set_register(struct regmap *map,
+					 struct regcache_rbtree_node *rbnode,
+					 unsigned int idx, unsigned int val)
 {
-	regcache_set_val(rbnode->block, idx, val, word_size);
+	regcache_set_val(map, rbnode->block, idx, val);
 }
 
 static struct regcache_rbtree_node *regcache_rbtree_lookup(struct regmap *map,
-	unsigned int reg)
+							   unsigned int reg)
 {
 	struct regcache_rbtree_ctx *rbtree_ctx = map->cache;
 	struct rb_node *node;
@@ -260,8 +259,7 @@ static int regcache_rbtree_read(struct regmap *map,
 	rbnode = regcache_rbtree_lookup(map, reg);
 	if (rbnode) {
 		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
-		*value = regcache_rbtree_get_register(rbnode, reg_tmp,
-						      map->cache_word_size);
+		*value = regcache_rbtree_get_register(map, rbnode, reg_tmp);
 	} else {
 		return -ENOENT;
 	}
@@ -270,21 +268,23 @@ static int regcache_rbtree_read(struct regmap *map,
 }
 
 
-static int regcache_rbtree_insert_to_block(struct regcache_rbtree_node *rbnode,
+static int regcache_rbtree_insert_to_block(struct regmap *map,
+					   struct regcache_rbtree_node *rbnode,
 					   unsigned int pos, unsigned int reg,
-					   unsigned int value, unsigned int word_size)
+					   unsigned int value)
 {
 	u8 *blk;
 
 	blk = krealloc(rbnode->block,
-		       (rbnode->blklen + 1) * word_size, GFP_KERNEL);
+		       (rbnode->blklen + 1) * map->cache_word_size,
+		       GFP_KERNEL);
 	if (!blk)
 		return -ENOMEM;
 
 	/* insert the register value in the correct place in the rbnode block */
-	memmove(blk + (pos + 1) * word_size,
-		blk + pos * word_size,
-		(rbnode->blklen - pos) * word_size);
+	memmove(blk + (pos + 1) * map->cache_word_size,
+		blk + pos * map->cache_word_size,
+		(rbnode->blklen - pos) * map->cache_word_size);
 
 	/* update the rbnode block, its size and the base register */
 	rbnode->block = blk;
@@ -292,7 +292,7 @@ static int regcache_rbtree_insert_to_block(struct regcache_rbtree_node *rbnode,
 	if (!pos)
 		rbnode->base_reg = reg;
 
-	regcache_rbtree_set_register(rbnode, pos, value, word_size);
+	regcache_rbtree_set_register(map, rbnode, pos, value);
 	return 0;
 }
 
@@ -314,8 +314,7 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	rbnode = regcache_rbtree_lookup(map, reg);
 	if (rbnode) {
 		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
-		regcache_rbtree_set_register(rbnode, reg_tmp, value,
-					     map->cache_word_size);
+		regcache_rbtree_set_register(map, rbnode, reg_tmp, value);
 	} else {
 		/* look for an adjacent register to the one we are about to add */
 		for (node = rb_first(&rbtree_ctx->root); node;
@@ -332,9 +331,10 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 					pos = i + 1;
 				else
 					pos = i;
-				ret = regcache_rbtree_insert_to_block(rbnode_tmp, pos,
-								      reg, value,
-								      map->cache_word_size);
+				ret = regcache_rbtree_insert_to_block(map,
+								      rbnode_tmp,
+								      pos, reg,
+								      value);
 				if (ret)
 					return ret;
 				rbtree_ctx->cached_rbnode = rbnode_tmp;
@@ -357,7 +357,7 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 			kfree(rbnode);
 			return -ENOMEM;
 		}
-		regcache_rbtree_set_register(rbnode, 0, value, map->cache_word_size);
+		regcache_rbtree_set_register(map, rbnode, 0, value);
 		regcache_rbtree_insert(map, &rbtree_ctx->root, rbnode);
 		rbtree_ctx->cached_rbnode = rbnode;
 	}
@@ -399,8 +399,7 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 
 		for (i = base; i < end; i++) {
 			regtmp = rbnode->base_reg + (i * map->reg_stride);
-			val = regcache_rbtree_get_register(rbnode, i,
-							   map->cache_word_size);
+			val = regcache_rbtree_get_register(map, rbnode, i);
 
 			/* Is this the hardware default?  If so skip. */
 			ret = regcache_lookup_reg(map, regtmp);
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index e69ff3e..f0a3db6 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -58,8 +58,7 @@ static int regcache_hw_init(struct regmap *map)
 
 	/* calculate the size of reg_defaults */
 	for (count = 0, i = 0; i < map->num_reg_defaults_raw; i++) {
-		val = regcache_get_val(map->reg_defaults_raw,
-				       i, map->cache_word_size);
+		val = regcache_get_val(map, map->reg_defaults_raw, i);
 		if (regmap_volatile(map, i * map->reg_stride))
 			continue;
 		count++;
@@ -75,8 +74,7 @@ static int regcache_hw_init(struct regmap *map)
 	/* fill the reg_defaults */
 	map->num_reg_defaults = count;
 	for (i = 0, j = 0; i < map->num_reg_defaults_raw; i++) {
-		val = regcache_get_val(map->reg_defaults_raw,
-				       i, map->cache_word_size);
+		val = regcache_get_val(map, map->reg_defaults_raw, i);
 		if (regmap_volatile(map, i * map->reg_stride))
 			continue;
 		map->reg_defaults[j].reg = i * map->reg_stride;
@@ -417,10 +415,10 @@ void regcache_cache_bypass(struct regmap *map, bool enable)
 }
 EXPORT_SYMBOL_GPL(regcache_cache_bypass);
 
-bool regcache_set_val(void *base, unsigned int idx,
-		      unsigned int val, unsigned int word_size)
+bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
+		      unsigned int val)
 {
-	switch (word_size) {
+	switch (map->cache_word_size) {
 	case 1: {
 		u8 *cache = base;
 		if (cache[idx] == val)
@@ -448,13 +446,13 @@ bool regcache_set_val(void *base, unsigned int idx,
 	return false;
 }
 
-unsigned int regcache_get_val(const void *base, unsigned int idx,
-			      unsigned int word_size)
+unsigned int regcache_get_val(struct regmap *map, const void *base,
+			      unsigned int idx)
 {
 	if (!base)
 		return -EINVAL;
 
-	switch (word_size) {
+	switch (map->cache_word_size) {
 	case 1: {
 		const u8 *cache = base;
 		return cache[idx];
-- 
1.7.10.4

