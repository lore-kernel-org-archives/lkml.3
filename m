Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3EHM7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:59:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35512 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354Ab3EHM7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:59:10 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/4] regmap: rbtree: Factor out node allocation
Date: Wed,  8 May 2013 13:55:24 +0100
Message-Id: <1368017725-23723-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368017725-23723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1368017725-23723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for being slightly smarter about how we allocate memory
factor out the node allocation.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c |   41 ++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index e9316b3..47f8047 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -304,6 +304,27 @@ static int regcache_rbtree_insert_to_block(struct regmap *map,
 	return 0;
 }
 
+static struct regcache_rbtree_node *
+regcache_rbtree_node_alloc(struct regmap *map, unsigned int reg)
+{
+	struct regcache_rbtree_node *rbnode;
+
+	rbnode = kzalloc(sizeof(*rbnode), GFP_KERNEL);
+	if (!rbnode)
+		return NULL;
+
+	rbnode->blklen = sizeof(*rbnode);
+	rbnode->base_reg = reg;
+	rbnode->block = kmalloc(rbnode->blklen * map->cache_word_size,
+				GFP_KERNEL);
+	if (!rbnode->block) {
+		kfree(rbnode);
+		return NULL;
+	}
+
+	return rbnode;
+}
+
 static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 				 unsigned int value)
 {
@@ -354,23 +375,15 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 				return 0;
 			}
 		}
-		/* we did not manage to find a place to insert it in an existing
-		 * block so create a new rbnode with a single register in its block.
-		 * This block will get populated further if any other adjacent
-		 * registers get modified in the future.
+
+		/* We did not manage to find a place to insert it in
+		 * an existing block so create a new rbnode.
 		 */
-		rbnode = kzalloc(sizeof *rbnode, GFP_KERNEL);
+		rbnode = regcache_rbtree_node_alloc(map, reg);
 		if (!rbnode)
 			return -ENOMEM;
-		rbnode->blklen = sizeof(*rbnode);
-		rbnode->base_reg = reg;
-		rbnode->block = kmalloc(rbnode->blklen * map->cache_word_size,
-					GFP_KERNEL);
-		if (!rbnode->block) {
-			kfree(rbnode);
-			return -ENOMEM;
-		}
-		regcache_rbtree_set_register(map, rbnode, 0, value);
+		regcache_rbtree_set_register(map, rbnode,
+					     reg - rbnode->base_reg, value);
 		regcache_rbtree_insert(map, &rbtree_ctx->root, rbnode);
 		rbtree_ctx->cached_rbnode = rbnode;
 	}
-- 
1.7.10.4

