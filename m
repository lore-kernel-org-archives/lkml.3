Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169Ab3C2VDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:03:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52871 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756994Ab3C2VDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:03:52 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: dp@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/4] regmap: cache: Factor out block sync
Date: Fri, 29 Mar 2013 21:03:43 +0000
Message-Id: <1364591025-18525-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1364591025-18525-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea of holding blocks of registers in device format is shared between
at least rbtree and lzo cache formats so split out the loop that does the
sync from the rbtree code so optimisations on it can be reused.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h        |    3 +++
 drivers/base/regmap/regcache-rbtree.c |   48 +++++----------------------------
 drivers/base/regmap/regcache.c        |   42 +++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 42 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index bd9e164..c130536 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -192,6 +192,9 @@ int regcache_read(struct regmap *map,
 int regcache_write(struct regmap *map,
 			unsigned int reg, unsigned int value);
 int regcache_sync(struct regmap *map);
+int regcache_sync_block(struct regmap *map, void *block,
+			unsigned int block_base, unsigned int start,
+			unsigned int end);
 
 static inline const void *regcache_get_val_addr(struct regmap *map,
 						const void *base,
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index 545153a..aa0875f 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -53,12 +53,6 @@ static unsigned int regcache_rbtree_get_register(struct regmap *map,
 	return regcache_get_val(map, rbnode->block, idx);
 }
 
-static const void *regcache_rbtree_get_reg_addr(struct regmap *map,
-	struct regcache_rbtree_node *rbnode, unsigned int idx)
-{
-	return regcache_get_val_addr(map, rbnode->block, idx);
-}
-
 static void regcache_rbtree_set_register(struct regmap *map,
 					 struct regcache_rbtree_node *rbnode,
 					 unsigned int idx, unsigned int val)
@@ -390,11 +384,8 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 	struct regcache_rbtree_ctx *rbtree_ctx;
 	struct rb_node *node;
 	struct regcache_rbtree_node *rbnode;
-	unsigned int regtmp;
-	unsigned int val;
-	const void *addr;
 	int ret;
-	int i, base, end;
+	int base, end;
 
 	rbtree_ctx = map->cache;
 	for (node = rb_first(&rbtree_ctx->root); node; node = rb_next(node)) {
@@ -417,40 +408,13 @@ static int regcache_rbtree_sync(struct regmap *map, unsigned int min,
 		else
 			end = rbnode->blklen;
 
-		for (i = base; i < end; i++) {
-			regtmp = rbnode->base_reg + (i * map->reg_stride);
-
-			if (!regcache_reg_present(map, regtmp))
-				continue;
-
-			val = regcache_rbtree_get_register(map, rbnode, i);
-
-			/* Is this the hardware default?  If so skip. */
-			ret = regcache_lookup_reg(map, regtmp);
-			if (ret >= 0 && val == map->reg_defaults[ret].def)
-				continue;
-
-			map->cache_bypass = 1;
-
-			if (regmap_can_raw_write(map)) {
-				addr = regcache_rbtree_get_reg_addr(map,
-								    rbnode, i);
-				ret = _regmap_raw_write(map, regtmp, addr,
-							map->format.val_bytes,
-							false);
-			} else {
-				ret = _regmap_write(map, regtmp, val);
-			}
-
-			map->cache_bypass = 0;
-			if (ret)
-				return ret;
-			dev_dbg(map->dev, "Synced register %#x, value %#x\n",
-				regtmp, val);
-		}
+		ret = regcache_sync_block(map, rbnode->block, rbnode->base_reg,
+					  base, end);
+		if (ret != 0)
+			return ret;
 	}
 
-	return 0;
+	return regmap_async_complete(map);
 }
 
 struct regcache_ops regcache_rbtree_ops = {
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 0fedf4f..bb317db 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -544,3 +544,45 @@ int regcache_lookup_reg(struct regmap *map, unsigned int reg)
 	else
 		return -ENOENT;
 }
+
+int regcache_sync_block(struct regmap *map, void *block,
+			unsigned int block_base, unsigned int start,
+			unsigned int end)
+{
+	unsigned int i, regtmp, val;
+	const void *addr;
+	int ret;
+
+	for (i = start; i < end; i++) {
+		regtmp = block_base + (i * map->reg_stride);
+
+		if (!regcache_reg_present(map, regtmp))
+			continue;
+
+		val = regcache_get_val(map, block, i);
+
+		/* Is this the hardware default?  If so skip. */
+		ret = regcache_lookup_reg(map, regtmp);
+		if (ret >= 0 && val == map->reg_defaults[ret].def)
+			continue;
+
+		map->cache_bypass = 1;
+
+		if (regmap_can_raw_write(map)) {
+			addr = regcache_get_val_addr(map, block, i);
+			ret = _regmap_raw_write(map, regtmp, addr,
+						map->format.val_bytes,
+						false);
+		} else {
+			ret = _regmap_write(map, regtmp, val);
+		}
+
+		map->cache_bypass = 0;
+		if (ret != 0)
+			return ret;
+		dev_dbg(map->dev, "Synced register %#x, value %#x\n",
+			regtmp, val);
+	}
+
+	return 0;
+}
-- 
1.7.10.4

