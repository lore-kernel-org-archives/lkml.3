Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab3EHM7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:59:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35511 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754935Ab3EHM7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:59:10 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] regmap: rbtree: Use range information to allocate nodes
Date: Wed,  8 May 2013 13:55:25 +0100
Message-Id: <1368017725-23723-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368017725-23723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1368017725-23723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If range information has been provided then when we allocate a rbnode
within a range allocate the entire range. The goal is to minimise the
number of reallocations done when combining or extending blocks. At
present only readability and yes_ranges are taken into account, this is
expected to cover most cases efficiently.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 47f8047..24b06a4 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -308,13 +308,34 @@ static struct regcache_rbtree_node *
 regcache_rbtree_node_alloc(struct regmap *map, unsigned int reg)
 {
 	struct regcache_rbtree_node *rbnode;
+	const struct regmap_range *range;
+	int i;
 
 	rbnode = kzalloc(sizeof(*rbnode), GFP_KERNEL);
 	if (!rbnode)
 		return NULL;
 
-	rbnode->blklen = sizeof(*rbnode);
-	rbnode->base_reg = reg;
+	/* If there is a read table then use it to guess at an allocation */
+	if (map->rd_table) {
+		for (i = 0; i < map->rd_table->n_yes_ranges; i++) {
+			if (regmap_reg_in_range(reg,
+						&map->rd_table->yes_ranges[i]))
+				break;
+		}
+
+		if (i != map->rd_table->n_yes_ranges) {
+			range = &map->rd_table->yes_ranges[i];
+			rbnode->blklen = range->range_max - range->range_min
+				+ 1;
+			rbnode->base_reg = range->range_min;
+		}
+	}
+
+	if (!rbnode->blklen) {
+		rbnode->blklen = sizeof(*rbnode);
+		rbnode->base_reg = reg;
+	}
+
 	rbnode->block = kmalloc(rbnode->blklen * map->cache_word_size,
 				GFP_KERNEL);
 	if (!rbnode->block) {
-- 
1.7.10.4

