Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3JGWBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:01:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38885 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3JGWBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:01:22 -0400
From: Mark Brown <broonie@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Mon,  7 Oct 2013 23:00:55 +0100
Message-Id: <1381183255-14449-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regmap: Cache async work structures
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Rather than allocating and deallocating the structures used to manage async
transfers each time we do one keep the structures around as long as the
regmap is around. This should provide a small performance improvement.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/internal.h |  2 +-
 drivers/base/regmap/regmap.c   | 59 +++++++++++++++++++++++-------------------
 2 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 9010614..63c22bc 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -44,7 +44,6 @@ struct regmap_format {
 
 struct regmap_async {
 	struct list_head list;
-	struct work_struct cleanup;
 	struct regmap *map;
 	void *work_buf;
 };
@@ -67,6 +66,7 @@ struct regmap {
 	spinlock_t async_lock;
 	wait_queue_head_t async_waitq;
 	struct list_head async_list;
+	struct list_head async_free;
 	int async_ret;
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 00152bf..5754513 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -42,15 +42,6 @@ static int _regmap_bus_formatted_write(void *context, unsigned int reg,
 static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				 unsigned int val);
 
-static void async_cleanup(struct work_struct *work)
-{
-	struct regmap_async *async = container_of(work, struct regmap_async,
-						  cleanup);
-
-	kfree(async->work_buf);
-	kfree(async);
-}
-
 bool regmap_reg_in_ranges(unsigned int reg,
 			  const struct regmap_range *ranges,
 			  unsigned int nranges)
@@ -465,6 +456,7 @@ struct regmap *regmap_init(struct device *dev,
 
 	spin_lock_init(&map->async_lock);
 	INIT_LIST_HEAD(&map->async_list);
+	INIT_LIST_HEAD(&map->async_free);
 	init_waitqueue_head(&map->async_waitq);
 
 	if (config->read_flag_mask || config->write_flag_mask) {
@@ -944,12 +936,22 @@ EXPORT_SYMBOL_GPL(regmap_reinit_cache);
  */
 void regmap_exit(struct regmap *map)
 {
+	struct regmap_async *async;
+
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 	regmap_range_exit(map);
 	if (map->bus && map->bus->free_context)
 		map->bus->free_context(map->bus_context);
 	kfree(map->work_buf);
+	while (!list_empty(&map->async_free)) {
+		async = list_first_entry_or_null(&map->async_free,
+						 struct regmap_async,
+						 list);
+		list_del(&async->list);
+		kfree(async->work_buf);
+		kfree(async);
+	}
 	kfree(map);
 }
 EXPORT_SYMBOL_GPL(regmap_exit);
@@ -1117,20 +1119,31 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	u8[0] |= map->write_flag_mask;
 
 	if (async && map->bus->async_write) {
-		struct regmap_async *async = map->bus->async_alloc();
-		if (!async)
-			return -ENOMEM;
+		struct regmap_async *async;
 
 		trace_regmap_async_write_start(map->dev, reg, val_len);
 
-		async->work_buf = kzalloc(map->format.buf_size,
-					  GFP_KERNEL | GFP_DMA);
-		if (!async->work_buf) {
-			kfree(async);
-			return -ENOMEM;
+		spin_lock_irqsave(&map->async_lock, flags);
+		async = list_first_entry_or_null(&map->async_free,
+						 struct regmap_async,
+						 list);
+		if (async)
+			list_del(&async->list);
+		spin_unlock_irqrestore(&map->async_lock, flags);
+
+		if (!async) {
+			async = map->bus->async_alloc();
+			if (!async)
+				return -ENOMEM;
+
+			async->work_buf = kzalloc(map->format.buf_size,
+						  GFP_KERNEL | GFP_DMA);
+			if (!async->work_buf) {
+				kfree(async);
+				return -ENOMEM;
+			}
 		}
 
-		INIT_WORK(&async->cleanup, async_cleanup);
 		async->map = map;
 
 		/* If the caller supplied the value we can use it safely. */
@@ -1154,11 +1167,8 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 				ret);
 
 			spin_lock_irqsave(&map->async_lock, flags);
-			list_del(&async->list);
+			list_move(&async->list, &map->async_free);
 			spin_unlock_irqrestore(&map->async_lock, flags);
-
-			kfree(async->work_buf);
-			kfree(async);
 		}
 
 		return ret;
@@ -1923,8 +1933,7 @@ void regmap_async_complete_cb(struct regmap_async *async, int ret)
 	trace_regmap_async_io_complete(map->dev);
 
 	spin_lock(&map->async_lock);
-
-	list_del(&async->list);
+	list_move(&async->list, &map->async_free);
 	wake = list_empty(&map->async_list);
 
 	if (ret != 0)
@@ -1932,8 +1941,6 @@ void regmap_async_complete_cb(struct regmap_async *async, int ret)
 
 	spin_unlock(&map->async_lock);
 
-	schedule_work(&async->cleanup);
-
 	if (wake)
 		wake_up(&map->async_waitq);
 }
-- 
1.8.4.rc3

