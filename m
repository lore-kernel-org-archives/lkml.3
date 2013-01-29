Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3A2Eb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:31:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44040 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753431Ab3A2Ebo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:31:44 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regmap: Add asynchronous I/O support
Date: Tue, 29 Jan 2013 12:31:32 +0800
Message-Id: <1359433894-28154-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some use cases like firmware download can transfer a lot of data in quick
succession. With high speed buses these use cases can benefit from having
multiple transfers scheduled at once since this allows the bus to minimise
the delay between transfers.

Support this by adding regmap_raw_write_async(), allowing raw transfers to
be scheduled, and regmap_async_complete() to wait for them to finish.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h |   15 ++++
 drivers/base/regmap/regmap.c   |  182 +++++++++++++++++++++++++++++++++++++---
 include/linux/regmap.h         |   28 +++++++
 3 files changed, 215 insertions(+), 10 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 51f0574..2025186 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -16,6 +16,7 @@
 #include <linux/regmap.h>
 #include <linux/fs.h>
 #include <linux/list.h>
+#include <linux/wait.h>
 
 struct regmap;
 struct regcache_ops;
@@ -39,6 +40,13 @@ struct regmap_format {
 	unsigned int (*parse_val)(void *buf);
 };
 
+struct regmap_async {
+	struct list_head list;
+	struct work_struct cleanup;
+	struct regmap *map;
+	void *work_buf;
+};
+
 struct regmap {
 	struct mutex mutex;
 	spinlock_t spinlock;
@@ -53,6 +61,11 @@ struct regmap {
 	void *bus_context;
 	const char *name;
 
+	spinlock_t async_lock;
+	wait_queue_head_t async_waitq;
+	struct list_head async_list;
+	int async_ret;
+
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *debugfs;
 	const char *debugfs_name;
@@ -178,6 +191,8 @@ bool regcache_set_val(void *base, unsigned int idx,
 		      unsigned int val, unsigned int word_size);
 int regcache_lookup_reg(struct regmap *map, unsigned int reg);
 
+void regmap_async_complete_cb(struct regmap_async *async, int ret);
+
 extern struct regcache_ops regcache_rbtree_ops;
 extern struct regcache_ops regcache_lzo_ops;
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6845a07..e57b7bc 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -41,6 +41,15 @@ static int _regmap_bus_formatted_write(void *context, unsigned int reg,
 static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				 unsigned int val);
 
+static void async_cleanup(struct work_struct *work)
+{
+	struct regmap_async *async = container_of(work, struct regmap_async,
+						  cleanup);
+
+	kfree(async->work_buf);
+	kfree(async);
+}
+
 bool regmap_reg_in_ranges(unsigned int reg,
 			  const struct regmap_range *ranges,
 			  unsigned int nranges)
@@ -430,6 +439,10 @@ struct regmap *regmap_init(struct device *dev,
 	map->cache_type = config->cache_type;
 	map->name = config->name;
 
+	spin_lock_init(&map->async_lock);
+	INIT_LIST_HEAD(&map->async_list);
+	init_waitqueue_head(&map->async_waitq);
+
 	if (config->read_flag_mask || config->write_flag_mask) {
 		map->read_flag_mask = config->read_flag_mask;
 		map->write_flag_mask = config->write_flag_mask;
@@ -884,10 +897,13 @@ static int _regmap_select_page(struct regmap *map, unsigned int *reg,
 }
 
 static int _regmap_raw_write(struct regmap *map, unsigned int reg,
-			     const void *val, size_t val_len)
+			     const void *val, size_t val_len, bool async)
 {
 	struct regmap_range_node *range;
+	unsigned long flags;
 	u8 *u8 = map->work_buf;
+	void *work_val = map->work_buf + map->format.reg_bytes +
+		map->format.pad_bytes;
 	void *buf;
 	int ret = -ENOTSUPP;
 	size_t len;
@@ -932,7 +948,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 			dev_dbg(map->dev, "Writing window %d/%zu\n",
 				win_residue, val_len / map->format.val_bytes);
 			ret = _regmap_raw_write(map, reg, val, win_residue *
-						map->format.val_bytes);
+						map->format.val_bytes, async);
 			if (ret != 0)
 				return ret;
 
@@ -955,6 +971,50 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	u8[0] |= map->write_flag_mask;
 
+	if (async && map->bus->async_write) {
+		struct regmap_async *async = map->bus->async_alloc();
+		if (!async)
+			return -ENOMEM;
+
+		async->work_buf = kzalloc(map->format.buf_size,
+					  GFP_KERNEL | GFP_DMA);
+		if (!async->work_buf) {
+			kfree(async);
+			return -ENOMEM;
+		}
+
+		INIT_WORK(&async->cleanup, async_cleanup);
+		async->map = map;
+
+		/* If the caller supplied the value we can use it safely. */
+		memcpy(async->work_buf, map->work_buf, map->format.pad_bytes +
+		       map->format.reg_bytes + map->format.val_bytes);
+		if (val == work_val)
+			val = async->work_buf + map->format.pad_bytes +
+				map->format.reg_bytes;
+
+		spin_lock_irqsave(&map->async_lock, flags);
+		list_add_tail(&async->list, &map->async_list);
+		spin_unlock_irqrestore(&map->async_lock, flags);
+
+		ret = map->bus->async_write(map->bus_context, async->work_buf,
+					    map->format.reg_bytes +
+					    map->format.pad_bytes,
+					    val, val_len, async);
+
+		if (ret != 0) {
+			dev_err(map->dev, "Failed to schedule write: %d\n",
+				ret);
+
+			spin_lock_irqsave(&map->async_lock, flags);
+			list_del(&async->list);
+			spin_unlock_irqrestore(&map->async_lock, flags);
+
+			kfree(async->work_buf);
+			kfree(async);
+		}
+	}
+
 	trace_regmap_hw_write_start(map->dev, reg,
 				    val_len / map->format.val_bytes);
 
@@ -962,8 +1022,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	 * send the work_buf directly, otherwise try to do a gather
 	 * write.
 	 */
-	if (val == (map->work_buf + map->format.pad_bytes +
-		    map->format.reg_bytes))
+	if (val == work_val)
 		ret = map->bus->write(map->bus_context, map->work_buf,
 				      map->format.reg_bytes +
 				      map->format.pad_bytes +
@@ -1036,7 +1095,7 @@ static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				 map->work_buf +
 				 map->format.reg_bytes +
 				 map->format.pad_bytes,
-				 map->format.val_bytes);
+				 map->format.val_bytes, false);
 }
 
 int _regmap_write(struct regmap *map, unsigned int reg,
@@ -1119,7 +1178,7 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	map->lock(map->lock_arg);
 
-	ret = _regmap_raw_write(map, reg, val, val_len);
+	ret = _regmap_raw_write(map, reg, val, val_len, false);
 
 	map->unlock(map->lock_arg);
 
@@ -1175,14 +1234,15 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	if (map->use_single_rw) {
 		for (i = 0; i < val_count; i++) {
 			ret = regmap_raw_write(map,
-						reg + (i * map->reg_stride),
-						val + (i * val_bytes),
-						val_bytes);
+					       reg + (i * map->reg_stride),
+					       val + (i * val_bytes),
+					       val_bytes);
 			if (ret != 0)
 				return ret;
 		}
 	} else {
-		ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count);
+		ret = _regmap_raw_write(map, reg, wval, val_bytes * val_count,
+					false);
 	}
 
 	if (val_bytes != 1)
@@ -1194,6 +1254,48 @@ out:
 }
 EXPORT_SYMBOL_GPL(regmap_bulk_write);
 
+/**
+ * regmap_raw_write_async(): Write raw values to one or more registers
+ *                           asynchronously
+ *
+ * @map: Register map to write to
+ * @reg: Initial register to write to
+ * @val: Block of data to be written, laid out for direct transmission to the
+ *       device.  Must be valid until regmap_async_complete() is called.
+ * @val_len: Length of data pointed to by val.
+ *
+ * This function is intended to be used for things like firmware
+ * download where a large block of data needs to be transferred to the
+ * device.  No formatting will be done on the data provided.
+ *
+ * If supported by the underlying bus the write will be scheduled
+ * asynchronously, helping maximise I/O speed on higher speed buses
+ * like SPI.  regmap_async_complete() can be called to ensure that all
+ * asynchrnous writes have been completed.
+ *
+ * A value of zero will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+int regmap_raw_write_async(struct regmap *map, unsigned int reg,
+			   const void *val, size_t val_len)
+{
+	int ret;
+
+	if (val_len % map->format.val_bytes)
+		return -EINVAL;
+	if (reg % map->reg_stride)
+		return -EINVAL;
+
+	map->lock(map->lock_arg);
+
+	ret = _regmap_raw_write(map, reg, val, val_len, true);
+
+	map->unlock(map->lock_arg);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_raw_write_async);
+
 static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 			    unsigned int val_len)
 {
@@ -1492,6 +1594,66 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
 
+void regmap_async_complete_cb(struct regmap_async *async, int ret)
+{
+	struct regmap *map = async->map;
+	bool wake;
+
+	spin_lock(&map->async_lock);
+
+	list_del(&async->list);
+	wake = list_empty(&map->async_list);
+
+	if (ret != 0)
+		map->async_ret = ret;
+
+	spin_unlock(&map->async_lock);
+
+	schedule_work(&async->cleanup);
+
+	if (wake)
+		wake_up(&map->async_waitq);
+}
+
+static int regmap_async_is_done(struct regmap *map)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&map->async_lock, flags);
+	ret = list_empty(&map->async_list);
+	spin_unlock_irqrestore(&map->async_lock, flags);
+
+	return ret;
+}
+
+/**
+ * regmap_async_complete: Ensure all asynchronous I/O has completed.
+ *
+ * @map: Map to operate on.
+ *
+ * Blocks until any pending asynchronous I/O has completed.  Returns
+ * an error code for any failed I/O operations.
+ */
+int regmap_async_complete(struct regmap *map)
+{
+	unsigned long flags;
+	int ret;
+
+	/* Nothing to do with no async support */
+	if (!map->bus->async_write)
+		return 0;
+
+	wait_event(map->async_waitq, regmap_async_is_done(map));
+
+	spin_lock_irqsave(&map->async_lock, flags);
+	ret = map->async_ret;
+	map->async_ret = 0;
+	spin_unlock_irqrestore(&map->async_lock, flags);
+
+	return ret;
+}
+
 /**
  * regmap_register_patch: Register and apply register updates to be applied
  *                        on device initialistion
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index b7e95bf..f9b7fbe 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -235,14 +235,21 @@ struct regmap_range_cfg {
 	unsigned int window_len;
 };
 
+struct regmap_async;
+
 typedef int (*regmap_hw_write)(void *context, const void *data,
 			       size_t count);
 typedef int (*regmap_hw_gather_write)(void *context,
 				      const void *reg, size_t reg_len,
 				      const void *val, size_t val_len);
+typedef int (*regmap_hw_async_write)(void *context,
+				     const void *reg, size_t reg_len,
+				     const void *val, size_t val_len,
+				     struct regmap_async *async);
 typedef int (*regmap_hw_read)(void *context,
 			      const void *reg_buf, size_t reg_size,
 			      void *val_buf, size_t val_size);
+typedef struct regmap_async *(*regmap_hw_async_alloc)(void);
 typedef void (*regmap_hw_free_context)(void *context);
 
 /**
@@ -255,8 +262,11 @@ typedef void (*regmap_hw_free_context)(void *context);
  * @write: Write operation.
  * @gather_write: Write operation with split register/value, return -ENOTSUPP
  *                if not implemented  on a given device.
+ * @async_write: Write operation which completes asynchronously, optional and
+ *               must serialise with respect to non-async I/O.
  * @read: Read operation.  Data is returned in the buffer used to transmit
  *         data.
+ * @async_alloc: Allocate a regmap_async() structure.
  * @read_flag_mask: Mask to be set in the top byte of the register when doing
  *                  a read.
  * @reg_format_endian_default: Default endianness for formatted register
@@ -265,13 +275,16 @@ typedef void (*regmap_hw_free_context)(void *context);
  * @val_format_endian_default: Default endianness for formatted register
  *     values. Used when the regmap_config specifies DEFAULT. If this is
  *     DEFAULT, BIG is assumed.
+ * @async_size: Size of struct used for async work.
  */
 struct regmap_bus {
 	bool fast_io;
 	regmap_hw_write write;
 	regmap_hw_gather_write gather_write;
+	regmap_hw_async_write async_write;
 	regmap_hw_read read;
 	regmap_hw_free_context free_context;
+	regmap_hw_async_alloc async_alloc;
 	u8 read_flag_mask;
 	enum regmap_endian reg_format_endian_default;
 	enum regmap_endian val_format_endian_default;
@@ -310,6 +323,8 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len);
 int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 			size_t val_count);
+int regmap_raw_write_async(struct regmap *map, unsigned int reg,
+			   const void *val, size_t val_len);
 int regmap_read(struct regmap *map, unsigned int reg, unsigned int *val);
 int regmap_raw_read(struct regmap *map, unsigned int reg,
 		    void *val, size_t val_len);
@@ -321,6 +336,7 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val,
 			     bool *change);
 int regmap_get_val_bytes(struct regmap *map);
+int regmap_async_complete(struct regmap *map);
 
 int regcache_sync(struct regmap *map);
 int regcache_sync_region(struct regmap *map, unsigned int min,
@@ -422,6 +438,13 @@ static inline int regmap_raw_write(struct regmap *map, unsigned int reg,
 	return -EINVAL;
 }
 
+static inline int regmap_raw_write_async(struct regmap *map, unsigned int reg,
+					 const void *val, size_t val_len)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 static inline int regmap_bulk_write(struct regmap *map, unsigned int reg,
 				    const void *val, size_t val_count)
 {
@@ -500,6 +523,11 @@ static inline void regcache_mark_dirty(struct regmap *map)
 	WARN_ONCE(1, "regmap API is disabled");
 }
 
+static inline void regmap_async_complete(struct regmap *map)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+}
+
 static inline int regmap_register_patch(struct regmap *map,
 					const struct reg_default *regs,
 					int num_regs)
-- 
1.7.10.4

