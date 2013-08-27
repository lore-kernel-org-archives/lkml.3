Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab3H0LC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 07:02:29 -0400
Received: from smtp-out-185.synserver.de ([212.40.185.185]:1088 "EHLO
	smtp-out-185.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3H0LC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 07:02:28 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1409
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regcache-rbtree: Fix reg_stride != 1
Date: Tue, 27 Aug 2013 13:03:03 +0200
Message-Id: <1377601383-591-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of calculations, which convert between register addresses and
block indices, in regcache_rbtree_sync() and regcache_rbtree_node_alloc() which
assume that reg_stride is 1. This will break the rb cache for configurations
which do not use a reg_stride of 1.

Also rename 'base' in regcache_rbtree_sync() to 'start' to avoid confusion with
'base_reg'.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache-rbtree.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 0fccc99..87aa318 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -325,8 +325,8 @@ regcache_rbtree_node_alloc(struct regmap *map, unsigned int reg)
 
 		if (i != map->rd_table->n_yes_ranges) {
 			range = &map->rd_table->yes_ranges[i];
-			rbnode->blklen = range->range_max - range->range_min
-				+ 1;
+			rbnode->blklen = (range->range_max - range->range_min) /
+				map->reg_stride	+ 1;
 			rbnode->base_reg = range->range_min;
 		}
 	}
@@ -418,30 +418,33 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 	struct regcache_rbtree_ctx *rbtree_ctx;
 	struct rb_node *node;
 	struct regcache_rbtree_node *rbnode;
+	unsigned int base_reg, top_reg;
+	unsigned int start, end;
 	int ret;
-	int base, end;
 
 	rbtree_ctx = map->cache;
 	for (node = rb_first(&rbtree_ctx->root); node; node = rb_next(node)) {
 		rbnode = rb_entry(node, struct regcache_rbtree_node, node);
 
-		if (rbnode->base_reg > max)
+		regcache_rbtree_get_base_top_reg(map, rbnode, &base_reg,
+			&top_reg);
+		if (base_reg > max)
 			break;
-		if (rbnode->base_reg + rbnode->blklen < min)
+		if (top_reg < min)
 			continue;
 
-		if (min > rbnode->base_reg)
-			base = min - rbnode->base_reg;
+		if (min > base_reg)
+			start = (min - base_reg) / map->reg_stride;
 		else
-			base = 0;
+			start = 0;
 
-		if (max < rbnode->base_reg + rbnode->blklen)
-			end = max - rbnode->base_reg + 1;
+		if (max < top_reg)
+			end = (max - base_reg) / map->reg_stride + 1;
 		else
 			end = rbnode->blklen;
 
 		ret = regcache_sync_block(map, rbnode->block, rbnode->base_reg,
-					  base, end);
+					  start, end);
 		if (ret != 0)
 			return ret;
 	}
-- 
1.8.0

