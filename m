Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3H2IZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 04:25:15 -0400
Received: from smtp-out-004.synserver.de ([212.40.185.4]:1084 "EHLO
	smtp-out-004.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab3H2IZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 04:25:11 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18054
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        David Jander <david.jander@protonic.nl>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 2/3] regmap: rbtree: Reduce number of nodes, take 2
Date: Thu, 29 Aug 2013 10:26:33 +0200
Message-Id: <1377764794-12090-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1377764794-12090-1-git-send-email-lars@metafoo.de>
References: <1377764794-12090-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for reducing the number of nodes and memory consumption of the rbtree
cache by allowing for small unused holes in the node's register cache block was
initially added in commit 0c7ed856 ("regmap: Cut down on the average # of nodes
in the rbtree cache"). But the commit had problems and so its effect was
reverted again in commit 4e67fb5 ("regmap: rbtree: Fix overlapping rbnodes.").
This patch brings the feature back of reducing the average number of nodes,
which will speedup node look-up, while at the same time also reducing the memory
usage of the rbtree cache. This patch takes a slightly different approach than
the original patch though. It modifies the adjacent node look-up to not only
consider nodes that are just one to the left or the right of the register but
any node that falls in a certain range around the register. The range is
calculated based on how much memory it would take to allocate a new node
compared to how much memory it takes adding a set of unused registers to an
existing node. E.g. if a node takes up 24 bytes and each register in a block
uses 1 byte the range will be from the register address - 24 to the register
address + 24. If we find a node that falls within this range it is cheaper or as
expensive to add the register to the existing node and have a couple of unused
registers in the node's cache compared to allocating a new node.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
Changes since v1:
	* Repair commit message
---
 drivers/base/regmap/regcache-rbtree.c | 53 ++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 6982128..dfce35a 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -278,27 +278,34 @@ static int regcache_rbtree_read(struct regmap *map,
 
 static int regcache_rbtree_insert_to_block(struct regmap *map,
 					   struct regcache_rbtree_node *rbnode,
-					   unsigned int pos, unsigned int reg,
+					   unsigned int base_reg,
+					   unsigned int top_reg,
+					   unsigned int reg,
 					   unsigned int value)
 {
+	unsigned int blklen;
+	unsigned int pos, offset;
 	u8 *blk;
 
+	blklen = (top_reg - base_reg) / map->reg_stride + 1;
+	pos = (reg - base_reg) / map->reg_stride;
+	offset = (rbnode->base_reg - base_reg) / map->reg_stride;
+
 	blk = krealloc(rbnode->block,
-		       (rbnode->blklen + 1) * map->cache_word_size,
+		       blklen * map->cache_word_size,
 		       GFP_KERNEL);
 	if (!blk)
 		return -ENOMEM;
 
 	/* insert the register value in the correct place in the rbnode block */
-	memmove(blk + (pos + 1) * map->cache_word_size,
-		blk + pos * map->cache_word_size,
-		(rbnode->blklen - pos) * map->cache_word_size);
+	if (pos == 0)
+		memmove(blk + offset * map->cache_word_size,
+			blk, rbnode->blklen * map->cache_word_size);
 
 	/* update the rbnode block, its size and the base register */
 	rbnode->block = blk;
-	rbnode->blklen++;
-	if (!pos)
-		rbnode->base_reg = reg;
+	rbnode->blklen = blklen;
+	rbnode->base_reg = base_reg;
 
 	regcache_rbtree_set_register(map, rbnode, pos, value);
 	return 0;
@@ -352,9 +359,7 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	struct regcache_rbtree_ctx *rbtree_ctx;
 	struct regcache_rbtree_node *rbnode, *rbnode_tmp;
 	struct rb_node *node;
-	unsigned int base_reg, top_reg;
 	unsigned int reg_tmp;
-	unsigned int pos;
 	int ret;
 
 	rbtree_ctx = map->cache;
@@ -371,6 +376,19 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
 		regcache_rbtree_set_register(map, rbnode, reg_tmp, value);
 	} else {
+		unsigned int base_reg, top_reg;
+		unsigned int new_base_reg, new_top_reg;
+		unsigned int min, max;
+		unsigned int max_dist;
+
+		max_dist = map->reg_stride * sizeof(*rbnode_tmp) /
+			map->cache_word_size;
+		if (reg < max_dist)
+			min = 0;
+		else
+			min = reg - max_dist;
+		max = reg + max_dist;
+
 		/* look for an adjacent register to the one we are about to add */
 		for (node = rb_first(&rbtree_ctx->root); node;
 		     node = rb_next(node)) {
@@ -380,16 +398,17 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 			regcache_rbtree_get_base_top_reg(map, rbnode_tmp,
 				&base_reg, &top_reg);
 
-			/* decide where in the block to place our register */
-			if (base_reg > 0 && reg == base_reg - map->reg_stride)
-				pos = 0;
-			else if (reg > 0 && reg - map->reg_stride == top_reg)
-				pos = rbnode_tmp->blklen;
-			else
+			if (base_reg <= max && top_reg >= min) {
+				new_base_reg = min(reg, base_reg);
+				new_top_reg = max(reg, top_reg);
+			} else {
 				continue;
+			}
 
 			ret = regcache_rbtree_insert_to_block(map, rbnode_tmp,
-							      pos, reg, value);
+							      new_base_reg,
+							      new_top_reg, reg,
+							      value);
 			if (ret)
 				return ret;
 			rbtree_ctx->cached_rbnode = rbnode_tmp;
-- 
1.8.0

