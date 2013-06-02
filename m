Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3FBWQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 18:16:35 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3191 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3FBWQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 18:16:29 -0400
From: Maarten ter Huurne <maarten@treewalker.org>
To: Mark Brown <broonie@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        Maarten ter Huurne <maarten@treewalker.org>
Subject: [PATCH] regmap: Implemented default cache sync operation
Date: Mon,  3 Jun 2013 00:15:26 +0200
Message-Id: <1370211326-32115-1-git-send-email-maarten@treewalker.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130601190850.GN16790@sirena.org.uk>
References: <20130601190850.GN16790@sirena.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be used for cache types for which syncing values one by one is
equally efficient as syncing a range, such as the flat cache.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
---
 drivers/base/regmap/regcache.c |   46 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index e69ff3e..e1c23464 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -249,6 +249,38 @@ int regcache_write(struct regmap *map,
 	return 0;
 }
 
+static int regcache_default_sync(struct regmap *map, unsigned int min,
+				 unsigned int max)
+{
+	unsigned int reg;
+
+	for (reg = min; reg <= max; reg++) {
+		unsigned int val;
+		int ret;
+
+		if (regmap_volatile(map, reg))
+			continue;
+
+		ret = regcache_read(map, reg, &val);
+		if (ret)
+			return ret;
+
+		/* Is this the hardware default?  If so skip. */
+		ret = regcache_lookup_reg(map, reg);
+		if (ret >= 0 && val == map->reg_defaults[ret].def)
+			continue;
+
+		map->cache_bypass = 1;
+		ret = _regmap_write(map, reg, val);
+		map->cache_bypass = 0;
+		if (ret)
+			return ret;
+		dev_dbg(map->dev, "Synced register %#x, value %#x\n", reg, val);
+	}
+
+	return 0;
+}
+
 /**
  * regcache_sync: Sync the register cache with the hardware.
  *
@@ -267,7 +299,7 @@ int regcache_sync(struct regmap *map)
 	const char *name;
 	unsigned int bypass;
 
-	BUG_ON(!map->cache_ops || !map->cache_ops->sync);
+	BUG_ON(!map->cache_ops);
 
 	map->lock(map);
 	/* Remember the initial bypass state */
@@ -296,7 +328,10 @@ int regcache_sync(struct regmap *map)
 	}
 	map->cache_bypass = 0;
 
-	ret = map->cache_ops->sync(map, 0, map->max_register);
+	if (map->cache_ops->sync)
+		ret = map->cache_ops->sync(map, 0, map->max_register);
+	else
+		ret = regcache_default_sync(map, 0, map->max_register);
 
 	if (ret == 0)
 		map->cache_dirty = false;
@@ -330,7 +365,7 @@ int regcache_sync_region(struct regmap *map, unsigned int min,
 	const char *name;
 	unsigned int bypass;
 
-	BUG_ON(!map->cache_ops || !map->cache_ops->sync);
+	BUG_ON(!map->cache_ops);
 
 	map->lock(map);
 
@@ -345,7 +380,10 @@ int regcache_sync_region(struct regmap *map, unsigned int min,
 	if (!map->cache_dirty)
 		goto out;
 
-	ret = map->cache_ops->sync(map, min, max);
+	if (map->cache_ops->sync)
+		ret = map->cache_ops->sync(map, min, max);
+	else
+		ret = regcache_default_sync(map, min, max);
 
 out:
 	trace_regcache_sync(map->dev, name, "stop region");
-- 
1.7.10.4

