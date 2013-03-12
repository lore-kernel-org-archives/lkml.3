Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab3CLR0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 13:26:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33270 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960Ab3CLR0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 13:26:51 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH v2] regmap: Expose total memory consumption in the rbtree debugfs entry
Date: Tue, 12 Mar 2013 17:26:49 +0000
Message-Id: <1363109209-23170-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a feel of how much overhead the rbtree cache adds to
the game.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 Print the size in bytes instead of kB.

 drivers/base/regmap/regcache-rbtree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 461cff8..11011ec 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -138,15 +138,20 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	struct regcache_rbtree_node *n;
 	struct rb_node *node;
 	unsigned int base, top;
+	size_t mem_size;
 	int nodes = 0;
 	int registers = 0;
 	int this_registers, average;
 
 	map->lock(map);
 
+	mem_size = sizeof(*rbtree_ctx);
+
 	for (node = rb_first(&rbtree_ctx->root); node != NULL;
 	     node = rb_next(node)) {
 		n = container_of(node, struct regcache_rbtree_node, node);
+		mem_size += sizeof(*n);
+		mem_size += (n->blklen * map->cache_word_size);
 
 		regcache_rbtree_get_base_top_reg(map, n, &base, &top);
 		this_registers = ((top - base) / map->reg_stride) + 1;
@@ -161,8 +166,8 @@ static int rbtree_show(struct seq_file *s, void *ignored)
 	else
 		average = 0;
 
-	seq_printf(s, "%d nodes, %d registers, average %d registers\n",
-		   nodes, registers, average);
+	seq_printf(s, "%d nodes, %d registers, average %d registers, memory overhead %zuB\n",
+		   nodes, registers, average, mem_size);
 
 	map->unlock(map);
 
-- 
1.8.1.5

