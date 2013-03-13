Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822Ab3CMLxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 07:53:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53100 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109Ab3CMLxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 07:53:46 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: Cut down on the average # of nodes in the rbtree cache
Date: Wed, 13 Mar 2013 11:53:43 +0000
Message-Id: <1363175623-2716-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch aims to bring down the average number of nodes
in the rbtree cache and increase the average number of registers
per node.  This should improve general lookup and traversal times.
This is achieved by setting the minimum size of a block within the
rbnode to the size of the rbnode itself.  This will essentially
cache possibly non-existent registers so to combat this scenario,
we keep a separate bitmap in memory which keeps track of which register
exists.  The memory overhead of this change is likely in the order of
~5-10%, possibly less depending on the register file layout.  On my test
system with a bitmap of ~4300 bits and a relatively sparse register
layout, the memory requirements for the entire cache did not increase
(the cutting down of nodes which was about 50% of the original number
compensated the situation).

A second patch that can be built on top of this can look at the
ratio `sizeof(*rbnode) / map->cache_word_size' in order to suitably
adjust the block length of each block.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c | 42 +++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 11011ec..acd63cd 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -36,6 +36,8 @@ struct regcache_rbtree_node {
 struct regcache_rbtree_ctx {
 	struct rb_root root;
 	struct regcache_rbtree_node *cached_rbnode;
+	unsigned long *reg_bitmap;
+	unsigned int reg_bitmap_nbits;
 };
 
 static inline void regcache_rbtree_get_base_top_reg(
@@ -146,6 +148,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	map->lock(map);
 
 	mem_size = sizeof(*rbtree_ctx);
+	mem_size += BITS_TO_LONGS(rbtree_ctx->reg_bitmap_nbits) * sizeof(long);
 
 	for (node = rb_first(&rbtree_ctx->root); node != NULL;
 	     node = rb_next(node)) {
@@ -199,6 +202,8 @@ static void rbtree_debugfs_init(struct regmap *map)
 static int regcache_rbtree_init(struct regmap *map)
 {
 	struct regcache_rbtree_ctx *rbtree_ctx;
+	void *reg_bitmap;
+	unsigned int bitmap_size;
 	int i;
 	int ret;
 
@@ -210,18 +215,36 @@ static int regcache_rbtree_init(struct regmap *map)
 	rbtree_ctx->root = RB_ROOT;
 	rbtree_ctx->cached_rbnode = NULL;
 
+	for (bitmap_size = 0, i = 0; i < map->num_reg_defaults; i++)
+		if (map->reg_defaults[i].reg > bitmap_size)
+			bitmap_size = map->reg_defaults[i].reg;
+	bitmap_size++;
+
+	reg_bitmap = kmalloc(BITS_TO_LONGS(bitmap_size) * sizeof(long),
+			     GFP_KERNEL);
+	if (!reg_bitmap) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	bitmap_zero(reg_bitmap, bitmap_size);
+	rbtree_ctx->reg_bitmap = reg_bitmap;
+	rbtree_ctx->reg_bitmap_nbits = bitmap_size;
+
 	for (i = 0; i < map->num_reg_defaults; i++) {
 		ret = regcache_rbtree_write(map,
 					    map->reg_defaults[i].reg,
 					    map->reg_defaults[i].def);
 		if (ret)
-			goto err;
+			goto err_bitmap;
+		set_bit(map->reg_defaults[i].reg, reg_bitmap);
 	}
 
 	rbtree_debugfs_init(map);
 
 	return 0;
 
+err_bitmap:
+	kfree(reg_bitmap);
 err:
 	regcache_rbtree_exit(map);
 	return ret;
@@ -238,6 +261,8 @@ static int regcache_rbtree_exit(struct regmap *map)
 	if (!rbtree_ctx)
 		return 0;
 
+	kfree(rbtree_ctx->reg_bitmap);
+
 	/* free up the rbtree */
 	next = rb_first(&rbtree_ctx->root);
 	while (next) {
@@ -258,11 +283,17 @@ static int regcache_rbtree_exit(struct regmap *map)
 static int regcache_rbtree_read(struct regmap *map,
 				unsigned int reg, unsigned int *value)
 {
+	struct regcache_rbtree_ctx *rbtree_ctx = map->cache;
 	struct regcache_rbtree_node *rbnode;
+	unsigned long *bitmap;
 	unsigned int reg_tmp;
 
+	bitmap = rbtree_ctx->reg_bitmap;
 	rbnode = regcache_rbtree_lookup(map, reg);
 	if (rbnode) {
+		/* Does this register exist?  If not bail out. */
+		if (!(bitmap[BIT_WORD(reg)] & BIT_MASK(reg)))
+			return -ENOENT;
 		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
 		*value = regcache_rbtree_get_register(map, rbnode, reg_tmp);
 	} else {
@@ -354,7 +385,7 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 		rbnode = kzalloc(sizeof *rbnode, GFP_KERNEL);
 		if (!rbnode)
 			return -ENOMEM;
-		rbnode->blklen = 1;
+		rbnode->blklen = sizeof(*rbnode);
 		rbnode->base_reg = reg;
 		rbnode->block = kmalloc(rbnode->blklen * map->cache_word_size,
 					GFP_KERNEL);
@@ -376,12 +407,14 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 	struct regcache_rbtree_ctx *rbtree_ctx;
 	struct rb_node *node;
 	struct regcache_rbtree_node *rbnode;
+	unsigned long *bitmap;
 	unsigned int regtmp;
 	unsigned int val;
 	int ret;
 	int i, base, end;
 
 	rbtree_ctx = map->cache;
+	bitmap = rbtree_ctx->reg_bitmap;
 	for (node = rb_first(&rbtree_ctx->root); node; node = rb_next(node)) {
 		rbnode = rb_entry(node, struct regcache_rbtree_node, node);
 
@@ -404,6 +437,11 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 
 		for (i = base; i < end; i++) {
 			regtmp = rbnode->base_reg + (i * map->reg_stride);
+
+			/* Does this register exist?  If not skip. */
+			if (!(bitmap[BIT_WORD(regtmp)] & BIT_MASK(regtmp)))
+				continue;
+
 			val = regcache_rbtree_get_register(map, rbnode, i);
 
 			/* Is this the hardware default?  If so skip. */
-- 
1.8.1.5

