Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3JIMbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:31:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46258 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab3JIMbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:31:18 -0400
From: Mark Brown <broonie@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Wed,  9 Oct 2013 13:30:47 +0100
Message-Id: <1381321847-5766-2-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381321847-5766-1-git-send-email-broonie@kernel.org>
References: <1381321847-5766-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 2/2] regmap: Provide asynchronous write and update bits operations
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Make it easier for drivers to include single register writes in
asynchronous sequences by providing async versions of the write
and update bits operations. The update bits operations are only
likely to be effective when used with devices that have caches
but this is common enough to be useful.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/base/regmap/regmap.c | 103 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/regmap.h       |  31 +++++++++++++
 2 files changed, 134 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6f15519..ccdac61 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1340,6 +1340,37 @@ int regmap_write(struct regmap *map, unsigned int reg, unsigned int val)
 EXPORT_SYMBOL_GPL(regmap_write);
 
 /**
+ * regmap_write_async(): Write a value to a single register asynchronously
+ *
+ * @map: Register map to write to
+ * @reg: Register to write to
+ * @val: Value to be written
+ *
+ * A value of zero will be returned on success, a negative errno will
+ * be returned in error cases.
+ */
+int regmap_write_async(struct regmap *map, unsigned int reg, unsigned int val)
+{
+	int ret;
+
+	if (reg % map->reg_stride)
+		return -EINVAL;
+
+	map->lock(map->lock_arg);
+
+	map->async = true;
+
+	ret = _regmap_write(map, reg, val);
+
+	map->async = false;
+
+	map->unlock(map->lock_arg);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_write_async);
+
+/**
  * regmap_raw_write(): Write raw values to one or more registers
  *
  * @map: Register map to write to
@@ -1914,6 +1945,41 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 EXPORT_SYMBOL_GPL(regmap_update_bits);
 
 /**
+ * regmap_update_bits_async: Perform a read/modify/write cycle on the register
+ *                           map asynchronously
+ *
+ * @map: Register map to update
+ * @reg: Register to update
+ * @mask: Bitmask to change
+ * @val: New value for bitmask
+ *
+ * With most buses the read must be done synchronously so this is most
+ * useful for devices with a cache which do not need to interact with
+ * the hardware to determine the current register value.
+ *
+ * Returns zero for success, a negative number on error.
+ */
+int regmap_update_bits_async(struct regmap *map, unsigned int reg,
+			     unsigned int mask, unsigned int val)
+{
+	bool change;
+	int ret;
+
+	map->lock(map->lock_arg);
+
+	map->async = true;
+
+	ret = _regmap_update_bits(map, reg, mask, val, &change);
+
+	map->async = false;
+
+	map->unlock(map->lock_arg);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_update_bits_async);
+
+/**
  * regmap_update_bits_check: Perform a read/modify/write cycle on the
  *                           register map and report if updated
  *
@@ -1938,6 +2004,43 @@ int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 }
 EXPORT_SYMBOL_GPL(regmap_update_bits_check);
 
+/**
+ * regmap_update_bits_check_async: Perform a read/modify/write cycle on the
+ *                                 register map asynchronously and report if
+ *                                 updated
+ *
+ * @map: Register map to update
+ * @reg: Register to update
+ * @mask: Bitmask to change
+ * @val: New value for bitmask
+ * @change: Boolean indicating if a write was done
+ *
+ * With most buses the read must be done synchronously so this is most
+ * useful for devices with a cache which do not need to interact with
+ * the hardware to determine the current register value.
+ *
+ * Returns zero for success, a negative number on error.
+ */
+int regmap_update_bits_check_async(struct regmap *map, unsigned int reg,
+				   unsigned int mask, unsigned int val,
+				   bool *change)
+{
+	int ret;
+
+	map->lock(map->lock_arg);
+
+	map->async = true;
+
+	ret = _regmap_update_bits(map, reg, mask, val, change);
+
+	map->async = false;
+
+	map->unlock(map->lock_arg);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(regmap_update_bits_check_async);
+
 void regmap_async_complete_cb(struct regmap_async *async, int ret)
 {
 	struct regmap *map = async->map;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 9b313f0..8267680 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -388,6 +388,7 @@ int regmap_reinit_cache(struct regmap *map,
 			const struct regmap_config *config);
 struct regmap *dev_get_regmap(struct device *dev, const char *name);
 int regmap_write(struct regmap *map, unsigned int reg, unsigned int val);
+int regmap_write_async(struct regmap *map, unsigned int reg, unsigned int val);
 int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len);
 int regmap_bulk_write(struct regmap *map, unsigned int reg, const void *val,
@@ -401,9 +402,14 @@ int regmap_bulk_read(struct regmap *map, unsigned int reg, void *val,
 		     size_t val_count);
 int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val);
+int regmap_update_bits_async(struct regmap *map, unsigned int reg,
+			     unsigned int mask, unsigned int val);
 int regmap_update_bits_check(struct regmap *map, unsigned int reg,
 			     unsigned int mask, unsigned int val,
 			     bool *change);
+int regmap_update_bits_check_async(struct regmap *map, unsigned int reg,
+				   unsigned int mask, unsigned int val,
+				   bool *change);
 int regmap_get_val_bytes(struct regmap *map);
 int regmap_async_complete(struct regmap *map);
 bool regmap_can_raw_write(struct regmap *map);
@@ -554,6 +560,13 @@ static inline int regmap_write(struct regmap *map, unsigned int reg,
 	return -EINVAL;
 }
 
+static inline int regmap_write_async(struct regmap *map, unsigned int reg,
+				     unsigned int val)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 static inline int regmap_raw_write(struct regmap *map, unsigned int reg,
 				   const void *val, size_t val_len)
 {
@@ -603,6 +616,14 @@ static inline int regmap_update_bits(struct regmap *map, unsigned int reg,
 	return -EINVAL;
 }
 
+static inline int regmap_update_bits_async(struct regmap *map,
+					   unsigned int reg,
+					   unsigned int mask, unsigned int val)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 static inline int regmap_update_bits_check(struct regmap *map,
 					   unsigned int reg,
 					   unsigned int mask, unsigned int val,
@@ -612,6 +633,16 @@ static inline int regmap_update_bits_check(struct regmap *map,
 	return -EINVAL;
 }
 
+static inline int regmap_update_bits_check_async(struct regmap *map,
+						 unsigned int reg,
+						 unsigned int mask,
+						 unsigned int val,
+						 bool *change)
+{
+	WARN_ONCE(1, "regmap API is disabled");
+	return -EINVAL;
+}
+
 static inline int regmap_get_val_bytes(struct regmap *map)
 {
 	WARN_ONCE(1, "regmap API is disabled");
-- 
1.8.4.rc3

