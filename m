Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab3H1Qxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:53:48 -0400
Received: from smtp-out-189.synserver.de ([212.40.185.189]:1093 "EHLO
	smtp-out-189.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab3H1Qxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:53:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 11941
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        David Jander <david.jander@protonic.nl>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/3] regmap: rbtree: Simplify adjacent node lookup
Date: Wed, 28 Aug 2013 18:55:09 +0200
Message-Id: <1377708911-694-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A register which is adjacent to a node will either be left to the first
register or right to the last register. It will not be within the node's range,
so there is no point in checking for each register in the register node whether
the new register is next to it. It is sufficient to check whether the register
comes before the first register or after the last register of the node.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache-rbtree.c | 39 +++++++++++++++++------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 87aa318..6982128 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -352,9 +352,9 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	struct regcache_rbtree_ctx *rbtree_ctx;
 	struct regcache_rbtree_node *rbnode, *rbnode_tmp;
 	struct rb_node *node;
+	unsigned int base_reg, top_reg;
 	unsigned int reg_tmp;
 	unsigned int pos;
-	int i;
 	int ret;
 
 	rbtree_ctx = map->cache;
@@ -376,25 +376,24 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 		     node = rb_next(node)) {
 			rbnode_tmp = rb_entry(node, struct regcache_rbtree_node,
 					      node);
-			for (i = 0; i < rbnode_tmp->blklen; i++) {
-				reg_tmp = rbnode_tmp->base_reg +
-						(i * map->reg_stride);
-				if (abs(reg_tmp - reg) != map->reg_stride)
-					continue;
-				/* decide where in the block to place our register */
-				if (reg_tmp + map->reg_stride == reg)
-					pos = i + 1;
-				else
-					pos = i;
-				ret = regcache_rbtree_insert_to_block(map,
-								      rbnode_tmp,
-								      pos, reg,
-								      value);
-				if (ret)
-					return ret;
-				rbtree_ctx->cached_rbnode = rbnode_tmp;
-				return 0;
-			}
+
+			regcache_rbtree_get_base_top_reg(map, rbnode_tmp,
+				&base_reg, &top_reg);
+
+			/* decide where in the block to place our register */
+			if (base_reg > 0 && reg == base_reg - map->reg_stride)
+				pos = 0;
+			else if (reg > 0 && reg - map->reg_stride == top_reg)
+				pos = rbnode_tmp->blklen;
+			else
+				continue;
+
+			ret = regcache_rbtree_insert_to_block(map, rbnode_tmp,
+							      pos, reg, value);
+			if (ret)
+				return ret;
+			rbtree_ctx->cached_rbnode = rbnode_tmp;
+			return 0;
 		}
 
 		/* We did not manage to find a place to insert it in
-- 
1.8.0

