Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab3HUNYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:24:51 -0400
Received: from protonic.xs4all.nl ([213.84.116.84]:17668 "EHLO
	protonic.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3HUNYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:24:50 -0400
X-Greylist: delayed 1325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Aug 2013 09:24:49 EDT
From: David Jander <david@protonic.nl>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH] drivers: regmap: bugfix in regcache-rbtree.c
Date: Wed, 21 Aug 2013 15:02:35 +0200
Message-Id: <1377090155-3443-1-git-send-email-david@protonic.nl>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functionality of rbtree_ctx->cached_rbnode is broken. Remove it to
avoid hitting the wrong rbnode when locating a register.
rbnode register ranges can overlap, which is not a problem as long as
every lookup for a register returns the same rbnode. Therefor we need
to start searching from the top of the rb-tree _always_.

Signed-off-by: David Jander <david@protonic.nl>
---
 drivers/base/regmap/regcache-rbtree.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 5c1435c..2f9783f 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -35,7 +35,6 @@ struct regcache_rbtree_node {
 
 struct regcache_rbtree_ctx {
 	struct rb_root root;
-	struct regcache_rbtree_node *cached_rbnode;
 };
 
 static inline void regcache_rbtree_get_base_top_reg(
@@ -68,21 +67,12 @@ static struct regcache_rbtree_node *regcache_rbtree_lookup(struct regmap *map,
 	struct regcache_rbtree_node *rbnode;
 	unsigned int base_reg, top_reg;
 
-	rbnode = rbtree_ctx->cached_rbnode;
-	if (rbnode) {
-		regcache_rbtree_get_base_top_reg(map, rbnode, &base_reg,
-						 &top_reg);
-		if (reg >= base_reg && reg <= top_reg)
-			return rbnode;
-	}
-
 	node = rbtree_ctx->root.rb_node;
 	while (node) {
 		rbnode = container_of(node, struct regcache_rbtree_node, node);
 		regcache_rbtree_get_base_top_reg(map, rbnode, &base_reg,
 						 &top_reg);
 		if (reg >= base_reg && reg <= top_reg) {
-			rbtree_ctx->cached_rbnode = rbnode;
 			return rbnode;
 		} else if (reg > top_reg) {
 			node = node->rb_right;
@@ -209,7 +199,6 @@ static int regcache_rbtree_init(struct regmap *map)
 
 	rbtree_ctx = map->cache;
 	rbtree_ctx->root = RB_ROOT;
-	rbtree_ctx->cached_rbnode = NULL;
 
 	for (i = 0; i < map->num_reg_defaults; i++) {
 		ret = regcache_rbtree_write(map,
@@ -392,7 +381,6 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 								      value);
 				if (ret)
 					return ret;
-				rbtree_ctx->cached_rbnode = rbnode_tmp;
 				return 0;
 			}
 		}
@@ -406,7 +394,6 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 		regcache_rbtree_set_register(map, rbnode,
 					     reg - rbnode->base_reg, value);
 		regcache_rbtree_insert(map, &rbtree_ctx->root, rbnode);
-		rbtree_ctx->cached_rbnode = rbnode;
 	}
 
 	return 0;
-- 
1.8.1.2

