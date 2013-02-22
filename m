Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab3BVLpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 06:45:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49201 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876Ab3BVLpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 06:45:08 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: async: Add tracepoints for async I/O
Date: Fri, 22 Feb 2013 11:45:02 +0000
Message-Id: <1361533502-25974-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace when we start and complete async writes, and when we start and
finish blocking for their completion. This is useful for performance
analysis of the resulting I/O patterns.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c  |    8 +++++++
 include/trace/events/regmap.h |   48 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 3d23675..7c6d3be 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -999,6 +999,8 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		if (!async)
 			return -ENOMEM;
 
+		trace_regmap_async_write_start(map->dev, reg, val_len);
+
 		async->work_buf = kzalloc(map->format.buf_size,
 					  GFP_KERNEL | GFP_DMA);
 		if (!async->work_buf) {
@@ -1640,6 +1642,8 @@ void regmap_async_complete_cb(struct regmap_async *async, int ret)
 	struct regmap *map = async->map;
 	bool wake;
 
+	trace_regmap_async_io_complete(map->dev);
+
 	spin_lock(&map->async_lock);
 
 	list_del(&async->list);
@@ -1686,6 +1690,8 @@ int regmap_async_complete(struct regmap *map)
 	if (!map->bus->async_write)
 		return 0;
 
+	trace_regmap_async_complete_start(map->dev);
+
 	wait_event(map->async_waitq, regmap_async_is_done(map));
 
 	spin_lock_irqsave(&map->async_lock, flags);
@@ -1693,6 +1699,8 @@ int regmap_async_complete(struct regmap *map)
 	map->async_ret = 0;
 	spin_unlock_irqrestore(&map->async_lock, flags);
 
+	trace_regmap_async_complete_done(map->dev);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regmap_async_complete);
diff --git a/include/trace/events/regmap.h b/include/trace/events/regmap.h
index 41a7dbd..a43a2f6 100644
--- a/include/trace/events/regmap.h
+++ b/include/trace/events/regmap.h
@@ -175,6 +175,54 @@ DEFINE_EVENT(regmap_bool, regmap_cache_bypass,
 
 );
 
+DECLARE_EVENT_CLASS(regmap_async,
+
+	TP_PROTO(struct device *dev),
+
+	TP_ARGS(dev),
+
+	TP_STRUCT__entry(
+		__string(	name,		dev_name(dev)	)
+	),
+
+	TP_fast_assign(
+		__assign_str(name, dev_name(dev));
+	),
+
+	TP_printk("%s", __get_str(name))
+);
+
+DEFINE_EVENT(regmap_block, regmap_async_write_start,
+
+	TP_PROTO(struct device *dev, unsigned int reg, int count),
+
+	TP_ARGS(dev, reg, count)
+);
+
+DEFINE_EVENT(regmap_async, regmap_async_io_complete,
+
+	TP_PROTO(struct device *dev),
+
+	TP_ARGS(dev)
+
+);
+
+DEFINE_EVENT(regmap_async, regmap_async_complete_start,
+
+	TP_PROTO(struct device *dev),
+
+	TP_ARGS(dev)
+
+);
+
+DEFINE_EVENT(regmap_async, regmap_async_complete_done,
+
+	TP_PROTO(struct device *dev),
+
+	TP_ARGS(dev)
+
+);
+
 #endif /* _TRACE_REGMAP_H */
 
 /* This part must be outside protection */
-- 
1.7.10.4

