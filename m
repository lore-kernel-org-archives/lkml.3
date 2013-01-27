Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3A0StT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 13:49:19 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:47488 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3A0StQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 13:49:16 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrey.smirnov@convergeddevices.net
Cc: broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] regmap: Add "no-bus" option for regmap API
Date: Sun, 27 Jan 2013 10:49:05 -0800
Message-Id: <1359312545-4159-1-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds provision for "no-bus" usage of the regmap API. In
this configuration user can provide API with two callbacks 'reg_read'
and 'reg_write' which are to be called when reads and writes to one of
device's registers is performed. This is useful for devices that
expose registers but whose register access sequence does not fit the 'bus'
abstraction.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
---
 drivers/base/regmap/internal.h |    2 ++
 drivers/base/regmap/regmap.c   |   58 +++++++++++++++++++++++++++++++---------
 include/linux/regmap.h         |   18 ++++++++++++-
 3 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 51f0574..b55fde5 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -77,6 +77,8 @@ struct regmap {
 	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
 	int (*reg_write)(void *context, unsigned int reg, unsigned int val);
 
+	bool defer_caching;
+
 	u8 read_flag_mask;
 	u8 write_flag_mask;
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6845a07..9592030 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -379,7 +379,7 @@ struct regmap *regmap_init(struct device *dev,
 	enum regmap_endian reg_endian, val_endian;
 	int i, j;
 
-	if (!bus || !config)
+	if (!config)
 		goto err;
 
 	map = kzalloc(sizeof(*map), GFP_KERNEL);
@@ -393,7 +393,8 @@ struct regmap *regmap_init(struct device *dev,
 		map->unlock = config->unlock;
 		map->lock_arg = config->lock_arg;
 	} else {
-		if (bus->fast_io) {
+		if ((bus && bus->fast_io) ||
+		    config->fast_io) {
 			spin_lock_init(&map->spinlock);
 			map->lock = regmap_lock_spinlock;
 			map->unlock = regmap_unlock_spinlock;
@@ -433,11 +434,19 @@ struct regmap *regmap_init(struct device *dev,
 	if (config->read_flag_mask || config->write_flag_mask) {
 		map->read_flag_mask = config->read_flag_mask;
 		map->write_flag_mask = config->write_flag_mask;
-	} else {
+	} else if (bus) {
 		map->read_flag_mask = bus->read_flag_mask;
 	}
 
-	map->reg_read = _regmap_bus_read;
+	if (!bus) {
+		map->reg_read  = config->reg_read;
+		map->reg_write = config->reg_write;
+
+		map->defer_caching = false;
+		goto skip_format_initialization;
+	} else {
+		map->reg_read  = _regmap_bus_read;
+	}
 
 	reg_endian = config->reg_format_endian;
 	if (reg_endian == REGMAP_ENDIAN_DEFAULT)
@@ -584,10 +593,15 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_map;
 	}
 
-	if (map->format.format_write)
+	if (map->format.format_write) {
+		map->defer_caching = false;
 		map->reg_write = _regmap_bus_formatted_write;
-	else if (map->format.format_val)
+	} else if (map->format.format_val) {
+		map->defer_caching = true;
 		map->reg_write = _regmap_bus_raw_write;
+	}
+
+skip_format_initialization:
 
 	map->range_tree = RB_ROOT;
 	for (i = 0; i < config->num_ranges; i++) {
@@ -790,7 +804,7 @@ void regmap_exit(struct regmap *map)
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 	regmap_range_exit(map);
-	if (map->bus->free_context)
+	if (map->bus && map->bus->free_context)
 		map->bus->free_context(map->bus_context);
 	kfree(map->work_buf);
 	kfree(map);
@@ -893,6 +907,8 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	size_t len;
 	int i;
 
+	BUG_ON(!map->bus);
+
 	/* Check for unwritable registers before we start */
 	if (map->writeable_reg)
 		for (i = 0; i < val_len / map->format.val_bytes; i++)
@@ -1002,7 +1018,7 @@ static int _regmap_bus_formatted_write(void *context, unsigned int reg,
 	struct regmap_range_node *range;
 	struct regmap *map = context;
 
-	BUG_ON(!map->format.format_write);
+	BUG_ON(!map->bus || !map->format.format_write);
 
 	range = _regmap_range_lookup(map, reg);
 	if (range) {
@@ -1028,7 +1044,7 @@ static int _regmap_bus_raw_write(void *context, unsigned int reg,
 {
 	struct regmap *map = context;
 
-	BUG_ON(!map->format.format_val);
+	BUG_ON(!map->bus || !map->format.format_val);
 
 	map->format.format_val(map->work_buf + map->format.reg_bytes
 			       + map->format.pad_bytes, val, 0);
@@ -1039,12 +1055,18 @@ static int _regmap_bus_raw_write(void *context, unsigned int reg,
 				 map->format.val_bytes);
 }
 
+static inline void *_regmap_map_get_context(struct regmap *map)
+{
+	return (map->bus) ? map : map->bus_context;
+}
+
 int _regmap_write(struct regmap *map, unsigned int reg,
 		  unsigned int val)
 {
 	int ret;
+	void *context = _regmap_map_get_context(map);
 
-	if (!map->cache_bypass && map->format.format_write) {
+	if (!map->cache_bypass && !map->defer_caching) {
 		ret = regcache_write(map, reg, val);
 		if (ret != 0)
 			return ret;
@@ -1061,7 +1083,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 
 	trace_regmap_reg_write(map->dev, reg, val);
 
-	return map->reg_write(map, reg, val);
+	return map->reg_write(context, reg, val);
 }
 
 /**
@@ -1112,6 +1134,8 @@ int regmap_raw_write(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
+	if (!map->bus)
+		return -EINVAL;
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
 	if (reg % map->reg_stride)
@@ -1148,6 +1172,8 @@ int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
 	size_t val_bytes = map->format.val_bytes;
 	void *wval;
 
+	if (!map->bus)
+		return -EINVAL;
 	if (!map->format.parse_val)
 		return -EINVAL;
 	if (reg % map->reg_stride)
@@ -1201,6 +1227,8 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	u8 *u8 = map->work_buf;
 	int ret;
 
+	BUG_ON(!map->bus);
+
 	range = _regmap_range_lookup(map, reg);
 	if (range) {
 		ret = _regmap_select_page(map, &reg, range,
@@ -1252,6 +1280,8 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 			unsigned int *val)
 {
 	int ret;
+	void *context = _regmap_map_get_context(map);
+
 	BUG_ON(!map->reg_read);
 
 	if (!map->cache_bypass) {
@@ -1263,7 +1293,7 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	if (map->cache_only)
 		return -EBUSY;
 
-	ret = map->reg_read(map, reg, val);
+	ret = map->reg_read(context, reg, val);
 	if (ret == 0) {
 #ifdef LOG_DEVICE
 		if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
@@ -1325,6 +1355,8 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	unsigned int v;
 	int ret, i;
 
+	if (!map->bus)
+		return -EINVAL;
 	if (val_len % map->format.val_bytes)
 		return -EINVAL;
 	if (reg % map->reg_stride)
@@ -1376,6 +1408,8 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 	size_t val_bytes = map->format.val_bytes;
 	bool vol = regmap_volatile_range(map, reg, val_count);
 
+	if (!map->bus)
+		return -EINVAL;
 	if (!map->format.parse_val)
 		return -EINVAL;
 	if (reg % map->reg_stride)
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index b7e95bf..28dde94 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -127,7 +127,18 @@ typedef void (*regmap_unlock)(void *);
  * @lock_arg:	  this field is passed as the only argument of lock/unlock
  *		  functions (ignored in case regular lock/unlock functions
  *		  are not overridden).
- *
+ * @reg_read:	  Optional callback that if filled will be used to perform
+ *           	  all the reads from the registers. Should only be provided for
+ *		  devices whos read operation cannot be represented as a simple read
+ *		  operation on a bus such as SPI, I2C, etc. Most of the devices do
+ * 		  not need this.
+ * @reg_write:	  Same as above for writing.
+ * @fast_io:	  Register IO is fast. Use a spinlock instead of a mutex
+ *	     	  to perform locking. This field is ignored if custom lock/unlock
+ *	     	  functions are used (see fields lock/unlock of struct regmap_config).
+ *		  This field is a duplicate of a similar file in
+ *		  'struct regmap_bus' and serves exact same purpose.
+ *		   Use it only for "no-bus" cases.
  * @max_register: Optional, specifies the maximum valid register index.
  * @wr_table:     Optional, points to a struct regmap_access_table specifying
  *                valid ranges for write access.
@@ -177,6 +188,11 @@ struct regmap_config {
 	regmap_unlock unlock;
 	void *lock_arg;
 
+	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
+	int (*reg_write)(void *context, unsigned int reg, unsigned int val);
+
+	bool fast_io;
+
 	unsigned int max_register;
 	const struct regmap_access_table *wr_table;
 	const struct regmap_access_table *rd_table;
-- 
1.7.9.5

