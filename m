Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab3BVNvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:51:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52439 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab3BVNvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:51:23 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regmap: rbtree: Don't bother checking for noop updates
Date: Fri, 22 Feb 2013 13:51:16 +0000
Message-Id: <1361541078-31614-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we're updating a value in place it's more work to read the value and
compare the value with what we're about to set than it is to just write
the value into the cache; there are no further operations after writing
in the code even though there's an early return here.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index e6732cf..3f21c6a 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -302,7 +302,6 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	struct regcache_rbtree_ctx *rbtree_ctx;
 	struct regcache_rbtree_node *rbnode, *rbnode_tmp;
 	struct rb_node *node;
-	unsigned int val;
 	unsigned int reg_tmp;
 	unsigned int pos;
 	int i;
@@ -315,10 +314,6 @@ static int regcache_rbtree_write(struct regmap *map, unsigned int reg,
 	rbnode = regcache_rbtree_lookup(map, reg);
 	if (rbnode) {
 		reg_tmp = (reg - rbnode->base_reg) / map->reg_stride;
-		val = regcache_rbtree_get_register(rbnode, reg_tmp,
-						   map->cache_word_size);
-		if (val == value)
-			return 0;
 		regcache_rbtree_set_register(rbnode, reg_tmp, value,
 					     map->cache_word_size);
 	} else {
-- 
1.7.10.4

