Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3COOyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 10:54:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46832 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754703Ab3COOyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 10:54:37 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3] regmap: Cut down on the average # of nodes in the rbtree cache
Date: Fri, 15 Mar 2013 14:54:35 +0000
Message-Id: <1363359275-634-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.2
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
 drivers/base/regmap/regcache-rbtree.c | 70 ++++++++++++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 11011ec..fe59b40 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -36,6 +36,8 @@ struct regcache_rbtree_node {
 struct regcache_rbtree_ctx {
 	struct rb_root root;
 	struct regcache_rbtree_node *cached_rbnode;
+	unsigned long *reg_present;
+	unsigned int reg_present_nbits;
 };
 
 static inline void regcache_rbtree_get_base_top_reg(
@@ -146,6 +148,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	map->lock(map);
 
 	mem_size = sizeof(*rbtree_ctx);
+	mem_size += BITS_TO_LONGS(rbtree_ctx->reg_present_nbits) * sizeof(long);
 
 	for (node = rb_first(&rbtree_ctx->root); node != NULL;
 	     node = rb_next(node)) {
@@ -196,6 +199,44 @@ static void rbtree_debugfs_init(struct regmap *map)
 }
 #endif
 
+static int enlarge_reg_present_bitmap(struct regmap *map, unsigned int reg)
+{
+	struct regcache_rbtree_ctx *rbtree_ctx;
+	unsigned long *reg_present;
+	unsigned int reg_present_size;
+	unsigned int nregs;
+	int i;
+
+	rbtree_ctx = map->cache;
+	nregs = reg + 1;
+	reg_present_size = BITS_TO_LONGS(nregs);
+	reg_present_size *= sizeof(long);
+
+	if (!rbtree_ctx->reg_present) {
+		reg_present = kmalloc(reg_present_size, GFP_KERNEL);
+		if (!reg_present)
+			return -ENOMEM;
+		bitmap_zero(reg_present, nregs);
+		rbtree_ctx->reg_present = reg_present;
+		rbtree_ctx->reg_present_nbits = nregs;
+		return 0;
+	}
+
+	if (nregs > rbtree_ctx->reg_present_nbits) {
+		reg_present = krealloc(rbtree_ctx->reg_present,
+				       reg_present_size, GFP_KERNEL);
+		if (!reg_present)
+			return -ENOMEM;
+		for (i = 0; i < nregs; i++)
+			if (i >= rbtree_ctx->reg_present_nbits)
+				clear_bit(i, reg_present);
+		rbtree_ctx->reg_present = reg_present;
+		rbtree_ctx->reg_present_nbits = nregs;
+	}
+
+	return 0;
+}
+
 static int regcache_rbtree_init(struct regmap *map)
 {
 	struct regcache_rbtree_ctx *rbtree_ctx;
@@ -209,6 +250,8 @@ static int regcache_rbtree_init(struct regmap *map)
 	rbtree_ctx = map->cache;
 	rbtree_ctx->root = RB_ROOT;
 	rbtree_ctx->cached_rbnode = NULL;
+	rbtree_ctx->reg_present = NULL;
+	rbtree_ctx->reg_present_nbits = 0;
 
 	for (i = 0; i < map->num_reg_defaults; i++) {
 		ret = regcache_rbtree_write(map,
@@ -238,6 +281,8 @@ static int regcache_rbtree_exit(struct regmap *map)
 	if (!rbtree_ctx)
 		return 0;
 
+	kfree(rbtree_ctx->reg_present);
+
 	/* free up the rbtree */
 	next = rb_first(&rbtree_ctx->root);
 	while (next) {
@@ -255,6 +300,17 @@ static int regcache_rbtree_exit(struct regmap *map)
 	return 0;
 }
 
+static int regcache_reg_present(struct regmap *map, unsigned int reg)
+{
+	struct regcache_rbtree_ctx *rbtree_ctx;
+
+	rbtree_ctx = map->cache;
+	if (!(rbtree_ctx->reg_present[BIT_WORD(reg)] & BIT_MASK(reg)))
+		return 0;
+	return 1;
+
+}
+
 static int regcache_rbtree_read(struct regmap *map,
 				unsigned int reg, unsigned int *value)
 {
@@ -264,6 +320,8 @@ static int regcache_rbtree_read(struct regmap *map,
 	rbnode = regcache_rbtree_lookup(map, reg);
 	if (rbnode) {
 		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
+		if (!regcache_reg_present(map, reg))
+			return -ENOENT;
 		*value = regcache_rbtree_get_register(map, rbnode, reg_tmp);
 	} else {
 		return -ENOENT;
@@ -313,6 +371,12 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	int ret;
 
 	rbtree_ctx = map->cache;
+	/* update the reg_present bitmap, make space if necessary */
+	ret = enlarge_reg_present_bitmap(map, reg);
+	if (ret < 0)
+		return ret;
+	set_bit(reg, rbtree_ctx->reg_present);
+
 	/* if we can't locate it in the cached rbnode we'll have
 	 * to traverse the rbtree looking for it.
 	 */
@@ -354,7 +418,7 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 		rbnode = kzalloc(sizeof *rbnode, GFP_KERNEL);
 		if (!rbnode)
 			return -ENOMEM;
-		rbnode->blklen = 1;
+		rbnode->blklen = sizeof(*rbnode);
 		rbnode->base_reg = reg;
 		rbnode->block = kmalloc(rbnode->blklen * map->cache_word_size,
 					GFP_KERNEL);
@@ -404,6 +468,10 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 
 		for (i = base; i < end; i++) {
 			regtmp = rbnode->base_reg + (i * map->reg_stride);
+
+			if (!regcache_reg_present(map, regtmp))
+				continue;
+
 			val = regcache_rbtree_get_register(map, rbnode, i);
 
 			/* Is this the hardware default?  If so skip. */
-- 
1.8.2

