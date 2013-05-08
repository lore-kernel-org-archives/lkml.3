Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab3EHM7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:59:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35509 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754502Ab3EHM7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:59:10 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] regmap: Add support for discarding parts of the register cache
Date: Wed,  8 May 2013 13:55:22 +0100
Message-Id: <1368017725-23723-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow drivers to discard parts of the register cache, for example if part
of the hardware has been reset.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |    1 +
 drivers/base/regmap/regcache.c |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h         |    9 +++++++++
 include/trace/events/regmap.h  |   23 +++++++++++++++++++++++
 4 files changed, 70 insertions(+)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index c130536..b33a4ff 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -148,6 +148,7 @@ struct regcache_ops {
 	int (*read)(struct regmap *map, unsigned int reg, unsigned int *value);
 	int (*write)(struct regmap *map, unsigned int reg, unsigned int value);
 	int (*sync)(struct regmap *map, unsigned int min, unsigned int max);
+	int (*drop)(struct regmap *map, unsigned int min, unsigned int max);
 };
 
 bool regmap_writeable(struct regmap *map, unsigned int reg);
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 1196c21..14c6eef 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -359,6 +359,43 @@ out:
 EXPORT_SYMBOL_GPL(regcache_sync_region);
 
 /**
+ * regcache_drop_region: Discard part of the register cache
+ *
+ * @map: map to operate on
+ * @min: first register to discard
+ * @max: last register to discard
+ *
+ * Discard part of the register cache.
+ *
+ * Return a negative value on failure, 0 on success.
+ */
+int regcache_drop_region(struct regmap *map, unsigned int min,
+			 unsigned int max)
+{
+	unsigned int reg;
+	int ret = 0;
+
+	if (!map->cache_present && !(map->cache_ops && map->cache_ops->drop))
+		return -EINVAL;
+
+	map->lock(map);
+
+	trace_regcache_drop_region(map->dev, min, max);
+
+	if (map->cache_present)
+		for (reg = min; reg < max + 1; reg++)
+			clear_bit(reg, map->cache_present);
+
+	if (map->cache_ops && map->cache_ops->drop)
+		ret = map->cache_ops->drop(map, min, max);
+
+	map->unlock(map);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regcache_drop_region);
+
+/**
  * regcache_cache_only: Put a register map into cache only mode
  *
  * @map: map to configure
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 02d84e2..5067ee9 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -394,6 +394,8 @@ bool regmap_can_raw_write(struct regmap *map);
 int regcache_sync(struct regmap *map);
 int regcache_sync_region(struct regmap *map, unsigned int min,
 			 unsigned int max);
+int regcache_drop_region(struct regmap *map, unsigned int min,
+			 unsigned int max);
 void regcache_cache_only(struct regmap *map, bool enable);
 void regcache_cache_bypass(struct regmap *map, bool enable);
 void regcache_mark_dirty(struct regmap *map);
@@ -562,6 +564,13 @@ static inline int regcache_sync_region(struct regmap *map, unsigned int min,
 	return -EINVAL;
 }
 
+static inline int regcache_drop_region(struct regmap *map, unsigned int min,
+				       unsigned int max)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 static inline void regcache_cache_only(struct regmap *map, bool enable)
 {
 	WARN_ONCE(1, "regmap API is disabled");
diff --git a/include/trace/events/regmap.h b/include/trace/events/regmap.h
index a43a2f6..23d5615 100644
--- a/include/trace/events/regmap.h
+++ b/include/trace/events/regmap.h
@@ -223,6 +223,29 @@ DEFINE_EVENT(regmap_async, regmap_async_complete_done,
 
 );
 
+TRACE_EVENT(regcache_drop_region,
+
+	TP_PROTO(struct device *dev, unsigned int from,
+		 unsigned int to),
+
+	TP_ARGS(dev, from, to),
+
+	TP_STRUCT__entry(
+		__string(       name,           dev_name(dev)   )
+		__field(	unsigned int,	from		)
+		__field(	unsigned int,	to		)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+		__entry->from = from;
+		__entry->to = to;
+	),
+
+	TP_printk("%s %u-%u", __get_str(name), (unsigned int)__entry->from,
+		  (unsigned int)__entry->to)
+);
+
 #endif /* _TRACE_REGMAP_H */
 
 /* This part must be outside protection */
-- 
1.7.10.4

