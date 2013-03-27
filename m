Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3C0NGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:06:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34734 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569Ab3C0NGW (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Wed, 27 Mar 2013 09:06:22 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regmap: cache: Use raw I/O to sync rbtrees if we can
Date: Wed, 27 Mar 2013 13:06:18 +0000
Message-Id: <1364389578-8714-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364389578-8714-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1364389578-8714-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will bring no meaningful benefit by itself, it is done as a separate
commit to aid bisection if there are problems with the following commits
adding support for coalescing adjacent writes.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-rbtree.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 792a760..382a6de 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -55,6 +55,12 @@ static unsigned int regcache_rbtree_get_register(struct regmap *map,
 	return regcache_get_val(map, rbnode->block, idx);
 }
 
+static const void *regcache_rbtree_get_reg_addr(struct regmap *map,
+	struct regcache_rbtree_node *rbnode, unsigned int idx)
+{
+	return regcache_get_val_addr(map, rbnode->block, idx);
+}
+
 static void regcache_rbtree_set_register(struct regmap *map,
 					 struct regcache_rbtree_node *rbnode,
 					 unsigned int idx, unsigned int val)
@@ -442,6 +448,7 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 	struct regcache_rbtree_node *rbnode;
 	unsigned int regtmp;
 	unsigned int val;
+	const void *addr;
 	int ret;
 	int i, base, end;
 
@@ -480,7 +487,17 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 				continue;
 
 			map->cache_bypass = 1;
-			ret = _regmap_write(map, regtmp, val);
+
+			if (regmap_can_raw_write(map)) {
+				addr = regcache_rbtree_get_reg_addr(map,
+								    rbnode, i);
+				ret = _regmap_raw_write(map, regtmp, addr,
+							map->format.val_bytes,
+							false);
+			} else {
+				ret = _regmap_write(map, regtmp, val);
+			}
+
 			map->cache_bypass = 0;
 			if (ret)
 				return ret;
-- 
1.7.10.4

