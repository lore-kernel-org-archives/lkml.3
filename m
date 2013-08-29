Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab3H2I0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 04:26:06 -0400
Received: from smtp-out-004.synserver.de ([212.40.185.4]:1095 "EHLO
	smtp-out-004.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878Ab3H2IZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 04:25:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18054
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        David Jander <david.jander@protonic.nl>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 3/3] regmap: rbtree: Make cache_present bitmap per node
Date: Thu, 29 Aug 2013 10:26:34 +0200
Message-Id: <1377764794-12090-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1377764794-12090-1-git-send-email-lars@metafoo.de>
References: <1377764794-12090-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With devices which have a dense and small register map but placed at a large
offset the global cache_present bitmap imposes a huge memory overhead. Making
the cache_present per rbtree node avoids the issue and easily reduces the memory
footprint by a factor of ten. For devices with a more sparse map or without a
large base register offset the memory usage might increase slightly by a few
bytes, but not significantly. E.g. for a device which has ~50 registers at
offset 0x4000 the memory footprint of the register cache goes down form 2496
bytes to 175 bytes.

Moving the bitmap to a per node basis means that the handling of the bitmap is
now cache implementation specific and can no longer be managed by the core. The
regcache_sync_block() function is extended by a additional parameter so that the
cache implementation can tell the core which registers in the block are set and
which are not. The parameter is optional and if NULL the core assumes that all
registers are set. The rbtree cache also needs to implement its own drop
callback instead of relying on the core to handle this.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
No changes since v1
---
 drivers/base/regmap/internal.h        | 14 +-----
 drivers/base/regmap/regcache-rbtree.c | 86 +++++++++++++++++++++++++++++------
 drivers/base/regmap/regcache.c        | 72 ++++++++---------------------
 3 files changed, 92 insertions(+), 80 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 5308e3e..57f7778 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -128,9 +128,6 @@ struct regmap {
 	void *cache;
 	u32 cache_dirty;
 
-	unsigned long *cache_present;
-	unsigned int cache_present_nbits;
-
 	struct reg_default *patch;
 	int patch_regs;
 
@@ -203,6 +200,7 @@ int regcache_write(struct regmap *map,
 			unsigned int reg, unsigned int value);
 int regcache_sync(struct regmap *map);
 int regcache_sync_block(struct regmap *map, void *block,
+			unsigned long *cache_present,
 			unsigned int block_base, unsigned int start,
 			unsigned int end);
 
@@ -218,16 +216,6 @@ unsigned int regcache_get_val(struct regmap *map, const void *base,
 bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
 		      unsigned int val);
 int regcache_lookup_reg(struct regmap *map, unsigned int reg);
-int regcache_set_reg_present(struct regmap *map, unsigned int reg);
-
-static inline bool regcache_reg_present(struct regmap *map, unsigned int reg)
-{
-	if (!map->cache_present)
-		return false;
-	if (reg > map->cache_present_nbits)
-		return false;
-	return map->cache_present[BIT_WORD(reg)] & BIT_MASK(reg);
-}
 
 int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		      const void *val, size_t val_len, bool async);
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index dfce35a..930cad4 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -29,6 +29,8 @@ struct regcache_rbtree_node {
 	unsigned int base_reg;
 	/* block of adjacent registers */
 	void *block;
+	/* Which registers are present */
+	long *cache_present;
 	/* number of registers available in the block */
 	unsigned int blklen;
 } __attribute__ ((packed));
@@ -57,6 +59,7 @@ static void regcache_rbtree_set_register(struct regmap *map,
 					 struct regcache_rbtree_node *rbnode,
 					 unsigned int idx, unsigned int val)
 {
+	set_bit(idx, rbnode->cache_present);
 	regcache_set_val(map, rbnode->block, idx, val);
 }
 
@@ -146,13 +149,13 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	map->lock(map->lock_arg);
 
 	mem_size = sizeof(*rbtree_ctx);
-	mem_size += BITS_TO_LONGS(map->cache_present_nbits) * sizeof(long);
 
 	for (node = rb_first(&rbtree_ctx->root); node != NULL;
 	     node = rb_next(node)) {
 		n = container_of(node, struct regcache_rbtree_node, node);
 		mem_size += sizeof(*n);
 		mem_size += (n->blklen * map->cache_word_size);
+		mem_size += BITS_TO_LONGS(n->blklen) * sizeof(long);
 
 		regcache_rbtree_get_base_top_reg(map, n, &base, &top);
 		this_registers = ((top - base) / map->reg_stride) + 1;
@@ -245,6 +248,7 @@ static int regcache_rbtree_exit(struct regmap *map)
 		rbtree_node = rb_entry(next, struct regcache_rbtree_node, node);
 		next = rb_next(&rbtree_node->node);
 		rb_erase(&rbtree_node->node, &rbtree_ctx->root);
+		kfree(rbtree_node->cache_present);
 		kfree(rbtree_node->block);
 		kfree(rbtree_node);
 	}
@@ -265,7 +269,7 @@ static int regcache_rbtree_read(struct regmap *map,
 	rbnode = regcache_rbtree_lookup(map, reg);
 	if (rbnode) {
 		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
-		if (!regcache_reg_present(map, reg))
+		if (!test_bit(reg_tmp, rbnode->cache_present))
 			return -ENOENT;
 		*value = regcache_rbtree_get_register(map, rbnode, reg_tmp);
 	} else {
@@ -285,6 +289,7 @@ static int regcache_rbtree_insert_to_block(struct regmap *map,
 {
 	unsigned int blklen;
 	unsigned int pos, offset;
+	unsigned long *present;
 	u8 *blk;
 
 	blklen = (top_reg - base_reg) / map->reg_stride + 1;
@@ -297,15 +302,25 @@ static int regcache_rbtree_insert_to_block(struct regmap *map,
 	if (!blk)
 		return -ENOMEM;
 
+	present = krealloc(rbnode->cache_present,
+		    BITS_TO_LONGS(blklen) * sizeof(*present), GFP_KERNEL);
+	if (!present) {
+		kfree(blk);
+		return -ENOMEM;
+	}
+
 	/* insert the register value in the correct place in the rbnode block */
-	if (pos == 0)
+	if (pos == 0) {
 		memmove(blk + offset * map->cache_word_size,
 			blk, rbnode->blklen * map->cache_word_size);
+		bitmap_shift_right(present, present, offset, blklen);
+	}
 
 	/* update the rbnode block, its size and the base register */
 	rbnode->block = blk;
 	rbnode->blklen = blklen;
 	rbnode->base_reg = base_reg;
+	rbnode->cache_present = present;
 
 	regcache_rbtree_set_register(map, rbnode, pos, value);
 	return 0;
@@ -345,12 +360,21 @@ regcache_rbtree_node_alloc(struct regmap *map, unsigned int reg)
 
 	rbnode->block = kmalloc(rbnode->blklen * map->cache_word_size,
 				GFP_KERNEL);
-	if (!rbnode->block) {
-		kfree(rbnode);
-		return NULL;
-	}
+	if (!rbnode->block)
+		goto err_free;
+
+	rbnode->cache_present = kzalloc(BITS_TO_LONGS(rbnode->blklen) *
+		sizeof(*rbnode->cache_present), GFP_KERNEL);
+	if (!rbnode->cache_present)
+		goto err_free_block;
 
 	return rbnode;
+
+err_free_block:
+	kfree(rbnode->block);
+err_free:
+	kfree(rbnode);
+	return NULL;
 }
 
 static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
@@ -363,10 +387,6 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	int ret;
 
 	rbtree_ctx = map->cache;
-	/* update the reg_present bitmap, make space if necessary */
-	ret = regcache_set_reg_present(map, reg);
-	if (ret < 0)
-		return ret;
 
 	/* if we can't locate it in the cached rbnode we'll have
 	 * to traverse the rbtree looking for it.
@@ -461,8 +481,9 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 		else
 			end = rbnode->blklen;
 
-		ret = regcache_sync_block(map, rbnode->block, rbnode->base_reg,
-					  start, end);
+		ret = regcache_sync_block(map, rbnode->block,
+					  rbnode->cache_present,
+					  rbnode->base_reg, start, end);
 		if (ret != 0)
 			return ret;
 	}
@@ -470,6 +491,42 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 	return regmap_async_complete(map);
 }
 
+static int regcache_rbtree_drop(struct regmap *map, unsigned int min,
+				unsigned int max)
+{
+	struct regcache_rbtree_ctx *rbtree_ctx;
+	struct regcache_rbtree_node *rbnode;
+	struct rb_node *node;
+	unsigned int base_reg, top_reg;
+	unsigned int start, end;
+
+	rbtree_ctx = map->cache;
+	for (node = rb_first(&rbtree_ctx->root); node; node = rb_next(node)) {
+		rbnode = rb_entry(node, struct regcache_rbtree_node, node);
+
+		regcache_rbtree_get_base_top_reg(map, rbnode, &base_reg,
+			&top_reg);
+		if (base_reg > max)
+			break;
+		if (top_reg < min)
+			continue;
+
+		if (min > base_reg)
+			start = (min - base_reg) / map->reg_stride;
+		else
+			start = 0;
+
+		if (max < top_reg)
+			end = (max - base_reg) / map->reg_stride + 1;
+		else
+			end = rbnode->blklen;
+
+		bitmap_clear(rbnode->cache_present, start, end - start);
+	}
+
+	return 0;
+}
+
 struct regcache_ops regcache_rbtree_ops = {
 	.type = REGCACHE_RBTREE,
 	.name = "rbtree",
@@ -477,5 +534,6 @@ struct regcache_ops regcache_rbtree_ops = {
 	.exit = regcache_rbtree_exit,
 	.read = regcache_rbtree_read,
 	.write = regcache_rbtree_write,
-	.sync = regcache_rbtree_sync
+	.sync = regcache_rbtree_sync,
+	.drop = regcache_rbtree_drop,
 };
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index e2abd05..d6c2d69 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -121,8 +121,6 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 	map->reg_defaults_raw = config->reg_defaults_raw;
 	map->cache_word_size = DIV_ROUND_UP(config->val_bits, 8);
 	map->cache_size_raw = map->cache_word_size * config->num_reg_defaults_raw;
-	map->cache_present = NULL;
-	map->cache_present_nbits = 0;
 
 	map->cache = NULL;
 	map->cache_ops = cache_types[i];
@@ -181,7 +179,6 @@ void regcache_exit(struct regmap *map)
 
 	BUG_ON(!map->cache_ops);
 
-	kfree(map->cache_present);
 	kfree(map->reg_defaults);
 	if (map->cache_free)
 		kfree(map->reg_defaults_raw);
@@ -407,22 +404,16 @@ EXPORT_SYMBOL_GPL(regcache_sync_region);
 int regcache_drop_region(struct regmap *map, unsigned int min,
 			 unsigned int max)
 {
-	unsigned int reg;
 	int ret = 0;
 
-	if (!map->cache_present && !(map->cache_ops && map->cache_ops->drop))
+	if (!map->cache_ops || !map->cache_ops->drop)
 		return -EINVAL;
 
 	map->lock(map->lock_arg);
 
 	trace_regcache_drop_region(map->dev, min, max);
 
-	if (map->cache_present)
-		for (reg = min; reg < max + 1; reg++)
-			clear_bit(reg, map->cache_present);
-
-	if (map->cache_ops && map->cache_ops->drop)
-		ret = map->cache_ops->drop(map, min, max);
+	ret = map->cache_ops->drop(map, min, max);
 
 	map->unlock(map->lock_arg);
 
@@ -490,42 +481,6 @@ void regcache_cache_bypass(struct regmap *map, bool enable)
 }
 EXPORT_SYMBOL_GPL(regcache_cache_bypass);
 
-int regcache_set_reg_present(struct regmap *map, unsigned int reg)
-{
-	unsigned long *cache_present;
-	unsigned int cache_present_size;
-	unsigned int nregs;
-	int i;
-
-	nregs = reg + 1;
-	cache_present_size = BITS_TO_LONGS(nregs);
-	cache_present_size *= sizeof(long);
-
-	if (!map->cache_present) {
-		cache_present = kmalloc(cache_present_size, GFP_KERNEL);
-		if (!cache_present)
-			return -ENOMEM;
-		bitmap_zero(cache_present, nregs);
-		map->cache_present = cache_present;
-		map->cache_present_nbits = nregs;
-	}
-
-	if (nregs > map->cache_present_nbits) {
-		cache_present = krealloc(map->cache_present,
-					 cache_present_size, GFP_KERNEL);
-		if (!cache_present)
-			return -ENOMEM;
-		for (i = 0; i < nregs; i++)
-			if (i >= map->cache_present_nbits)
-				clear_bit(i, cache_present);
-		map->cache_present = cache_present;
-		map->cache_present_nbits = nregs;
-	}
-
-	set_bit(reg, map->cache_present);
-	return 0;
-}
-
 bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
 		      unsigned int val)
 {
@@ -617,7 +572,16 @@ int regcache_lookup_reg(struct regmap *map, unsigned int reg)
 		return -ENOENT;
 }
 
+static bool regcache_reg_present(unsigned long *cache_present, unsigned int idx)
+{
+	if (!cache_present)
+		return true;
+
+	return test_bit(idx, cache_present);
+}
+
 static int regcache_sync_block_single(struct regmap *map, void *block,
+				      unsigned long *cache_present,
 				      unsigned int block_base,
 				      unsigned int start, unsigned int end)
 {
@@ -627,7 +591,7 @@ static int regcache_sync_block_single(struct regmap *map, void *block,
 	for (i = start; i < end; i++) {
 		regtmp = block_base + (i * map->reg_stride);
 
-		if (!regcache_reg_present(map, regtmp))
+		if (!regcache_reg_present(cache_present, i))
 			continue;
 
 		val = regcache_get_val(map, block, i);
@@ -678,6 +642,7 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
 }
 
 static int regcache_sync_block_raw(struct regmap *map, void *block,
+			    unsigned long *cache_present,
 			    unsigned int block_base, unsigned int start,
 			    unsigned int end)
 {
@@ -690,7 +655,7 @@ static int regcache_sync_block_raw(struct regmap *map, void *block,
 	for (i = start; i < end; i++) {
 		regtmp = block_base + (i * map->reg_stride);
 
-		if (!regcache_reg_present(map, regtmp)) {
+		if (!regcache_reg_present(cache_present, i)) {
 			ret = regcache_sync_block_raw_flush(map, &data,
 							    base, regtmp);
 			if (ret != 0)
@@ -721,13 +686,14 @@ static int regcache_sync_block_raw(struct regmap *map, void *block,
 }
 
 int regcache_sync_block(struct regmap *map, void *block,
+			unsigned long *cache_present,
 			unsigned int block_base, unsigned int start,
 			unsigned int end)
 {
 	if (regmap_can_raw_write(map))
-		return regcache_sync_block_raw(map, block, block_base,
-					       start, end);
+		return regcache_sync_block_raw(map, block, cache_present,
+					       block_base, start, end);
 	else
-		return regcache_sync_block_single(map, block, block_base,
-						  start, end);
+		return regcache_sync_block_single(map, block, cache_present,
+						  block_base, start, end);
 }
-- 
1.8.0

