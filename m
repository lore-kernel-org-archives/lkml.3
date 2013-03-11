Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3CKSF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:05:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54058 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab3CKSFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:05:23 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH] regmap: Expose total memory consumption in the rbtree debugfs entry
Date: Mon, 11 Mar 2013 18:05:21 +0000
Message-Id: <1363025121-10167-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a feel of how much overhead the rbtree cache adds to
the game.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 461cff8..7b732ad 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -138,6 +138,7 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	struct regcache_rbtree_node *n;
 	struct rb_node *node;
 	unsigned int base, top;
+	size_t mem_size = sizeof(*rbtree_ctx);
 	int nodes = 0;
 	int registers = 0;
 	int this_registers, average;
@@ -147,6 +148,8 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	for (node = rb_first(&rbtree_ctx->root); node != NULL;
 	     node = rb_next(node)) {
 		n = container_of(node, struct regcache_rbtree_node, node);
+		mem_size += sizeof(*n);
+		mem_size += (n->blklen * map->cache_word_size);
 
 		regcache_rbtree_get_base_top_reg(map, n, &base, &top);
 		this_registers = ((top - base) / map->reg_stride) + 1;
@@ -161,8 +164,13 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	else
 		average = 0;
 
-	seq_printf(s, "%d nodes, %d registers, average %d registers\n",
-		   nodes, registers, average);
+	if (mem_size > 1024)
+		mem_size /= 1024;
+	else
+		mem_size = 1;
+
+	seq_printf(s, "%d nodes, %d registers, average %d registers, memory overhead %zukB\n",
+		   nodes, registers, average, mem_size);
 
 	map->unlock(map);
 
-- 
1.8.1.5

