Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab3JIMbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:31:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46265 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab3JIMbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:31:00 -0400
From: Mark Brown <broonie@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Wed,  9 Oct 2013 13:30:46 +0100
Message-Id: <1381321847-5766-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/2] regmap: Simplify the initiation of async I/O
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Rather than passing a flag around through the entire call stack store it
in the regmap struct and read it when required. This minimises the
visibility of the feature through the API, minimising the code updates
needed to use it more widely.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/internal.h |  3 ++-
 drivers/base/regmap/regcache.c |  3 +--
 drivers/base/regmap/regmap.c   | 19 +++++++++++--------
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 63c22bc..33414b1 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -63,6 +63,7 @@ struct regmap {
 	void *bus_context;
 	const char *name;
 
+	bool async;
 	spinlock_t async_lock;
 	wait_queue_head_t async_waitq;
 	struct list_head async_list;
@@ -221,7 +222,7 @@ bool regcache_set_val(struct regmap *map, void *base, unsigned int idx,
 int regcache_lookup_reg(struct regmap *map, unsigned int reg);
 
 int _regmap_raw_write(struct regmap *map, unsigned int reg,
-		      const void *val, size_t val_len, bool async);
+		      const void *val, size_t val_len);
 
 void regmap_async_complete_cb(struct regmap_async *async, int ret);
 
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d6c2d69..a36112a 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -631,8 +631,7 @@ static int regcache_sync_block_raw_flush(struct regmap *map, const void **data,
 
 	map->cache_bypass = 1;
 
-	ret = _regmap_raw_write(map, base, *data, count * val_bytes,
-				false);
+	ret = _regmap_raw_write(map, base, *data, count * val_bytes);
 
 	map->cache_bypass = 0;
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 4866ae5..6f15519 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1043,7 +1043,7 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 }
 
 int _regmap_raw_write(struct regmap *map, unsigned int reg,
-		      const void *val, size_t val_len, bool async)
+		      const void *val, size_t val_len)
 {
 	struct regmap_range_node *range;
 	unsigned long flags;
@@ -1095,7 +1095,7 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 			dev_dbg(map->dev, "Writing window %d/%zu\n",
 				win_residue, val_len / map->format.val_bytes);
 			ret = _regmap_raw_write(map, reg, val, win_residue *
-						map->format.val_bytes, async);
+						map->format.val_bytes);
 			if (ret != 0)
 				return ret;
 
@@ -1128,7 +1128,7 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		val = work_val;
 	}
 
-	if (async && map->bus->async_write) {
+	if (map->async && map->bus->async_write) {
 		struct regmap_async *async;
 
 		trace_regmap_async_write_start(map->dev, reg, val_len);
@@ -1275,7 +1275,7 @@ static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				 map->work_buf +
 				 map->format.reg_bytes +
 				 map->format.pad_bytes,
-				 map->format.val_bytes, false);
+				 map->format.val_bytes);
 }
 
 static inline void *_regmap_map_get_context(struct regmap *map)
@@ -1367,7 +1367,7 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	map->lock(map->lock_arg);
 
-	ret = _regmap_raw_write(map, reg, val, val_len, false);
+	ret = _regmap_raw_write(map, reg, val, val_len);
 
 	map->unlock(map->lock_arg);
 
@@ -1516,8 +1516,7 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 				return ret;
 		}
 	} else {
-		ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count,
-					false);
+		ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count);
 	}
 
 	if (val_bytes != 1)
@@ -1563,7 +1562,11 @@ int regmap_raw_write_async(struct regmap *map, unsigned int reg,
 
 	map->lock(map->lock_arg);
 
-	ret = _regmap_raw_write(map, reg, val, val_len, true);
+	map->async = true;
+
+	ret = _regmap_raw_write(map, reg, val, val_len);
+
+	map->async = false;
 
 	map->unlock(map->lock_arg);
 
-- 
1.8.4.rc3

