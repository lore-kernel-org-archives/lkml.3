Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051Ab3LWQ3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:29:43 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39384 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757391Ab3LWQYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:24:05 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC 06/18] regmap: Formalise use of non-bus context
Date: Mon, 23 Dec 2013 16:23:38 +0000
Message-Id: <1387815830-8794-7-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 23 Dec 2013 16:24:03.0212 (UTC) FILETIME=[64BA2CC0:01CEFFFB]
X-MC-Unique: 113122316240321701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rBNGUsn8026701

Bus-less maps (ones with reg_read and reg_write functions
defined in regmap_config) were given the context passed
in regmap_init(), but it was still called "bus_context".

This patch formalises this aspect by renaming it to simple
"context" and adds the missing link, free_context function
in regmap_config, which allows bus-less maps to use the
context in classic way.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/regmap/internal.h |  3 ++-
 drivers/base/regmap/regmap.c   | 34 ++++++++++++++++++----------------
 include/linux/regmap.h         |  6 ++++--
 3 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 33414b1..3a8527d 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -60,7 +60,7 @@ struct regmap {
 	void *work_buf;     /* Scratch buffer used to format I/O */
 	struct regmap_format format;  /* Buffer format */
 	const struct regmap_bus *bus;
-	void *bus_context;
+	void *context;
 	const char *name;
 
 	bool async;
@@ -94,6 +94,7 @@ struct regmap {
 
 	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
 	int (*reg_write)(void *context, unsigned int reg, unsigned int val);
+	void (*free_context)(void *context);
 
 	bool defer_caching;
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c2e0021..9b00531 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -385,7 +385,7 @@ static void regmap_range_exit(struct regmap *map)
  *
  * @dev: Device that will be interacted with
  * @bus: Bus-specific callbacks to use with device
- * @bus_context: Data passed to bus-specific callbacks
+ * @context: Data passed to callbacks
  * @config: Configuration for register map
  *
  * The return value will be an ERR_PTR() on error or a valid pointer to
@@ -394,7 +394,7 @@ static void regmap_range_exit(struct regmap *map)
  */
 struct regmap *regmap_init(struct device *dev,
 			   const struct regmap_bus *bus,
-			   void *bus_context,
+			   void *context,
 			   const struct regmap_config *config)
 {
 	struct regmap *map, **m;
@@ -441,7 +441,7 @@ struct regmap *regmap_init(struct device *dev,
 	map->use_single_rw = config->use_single_rw;
 	map->dev = dev;
 	map->bus = bus;
-	map->bus_context = bus_context;
+	map->context = context;
 	map->max_register = config->max_register;
 	map->wr_table = config->wr_table;
 	map->rd_table = config->rd_table;
@@ -469,11 +469,13 @@ struct regmap *regmap_init(struct device *dev,
 	if (!bus) {
 		map->reg_read  = config->reg_read;
 		map->reg_write = config->reg_write;
+		map->free_context = config->free_context;
 
 		map->defer_caching = false;
 		goto skip_format_initialization;
 	} else {
 		map->reg_read  = _regmap_bus_read;
+		map->free_context = bus->free_context;
 	}
 
 	reg_endian = config->reg_format_endian;
@@ -774,7 +776,7 @@ static void devm_regmap_release(struct device *dev, void *res)
  *
  * @dev: Device that will be interacted with
  * @bus: Bus-specific callbacks to use with device
- * @bus_context: Data passed to bus-specific callbacks
+ * @context: Data passed to callbacks
  * @config: Configuration for register map
  *
  * The return value will be an ERR_PTR() on error or a valid pointer
@@ -784,7 +786,7 @@ static void devm_regmap_release(struct device *dev, void *res)
  */
 struct regmap *devm_regmap_init(struct device *dev,
 				const struct regmap_bus *bus,
-				void *bus_context,
+				void *context,
 				const struct regmap_config *config)
 {
 	struct regmap **ptr, *regmap;
@@ -793,7 +795,7 @@ struct regmap *devm_regmap_init(struct device *dev,
 	if (!ptr)
 		return ERR_PTR(-ENOMEM);
 
-	regmap = regmap_init(dev, bus, bus_context, config);
+	regmap = regmap_init(dev, bus, context, config);
 	if (!IS_ERR(regmap)) {
 		*ptr = regmap;
 		devres_add(dev, ptr);
@@ -941,8 +943,8 @@ void regmap_exit(struct regmap *map)
 	regcache_exit(map);
 	regmap_debugfs_exit(map);
 	regmap_range_exit(map);
-	if (map->bus && map->bus->free_context)
-		map->bus->free_context(map->bus_context);
+	if (map->free_context)
+		map->free_context(map->context);
 	kfree(map->work_buf);
 	while (!list_empty(&map->async_free)) {
 		async = list_first_entry_or_null(&map->async_free,
@@ -1165,13 +1167,13 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		spin_unlock_irqrestore(&map->async_lock, flags);
 
 		if (val != work_val)
-			ret = map->bus->async_write(map->bus_context,
+			ret = map->bus->async_write(map->context,
 						    async->work_buf,
 						    map->format.reg_bytes +
 						    map->format.pad_bytes,
 						    val, val_len, async);
 		else
-			ret = map->bus->async_write(map->bus_context,
+			ret = map->bus->async_write(map->context,
 						    async->work_buf,
 						    map->format.reg_bytes +
 						    map->format.pad_bytes +
@@ -1197,12 +1199,12 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	 * write.
 	 */
 	if (val == work_val)
-		ret = map->bus->write(map->bus_context, map->work_buf,
+		ret = map->bus->write(map->context, map->work_buf,
 				      map->format.reg_bytes +
 				      map->format.pad_bytes +
 				      val_len);
 	else if (map->bus->gather_write)
-		ret = map->bus->gather_write(map->bus_context, map->work_buf,
+		ret = map->bus->gather_write(map->context, map->work_buf,
 					     map->format.reg_bytes +
 					     map->format.pad_bytes,
 					     val, val_len);
@@ -1217,7 +1219,7 @@ int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		memcpy(buf, map->work_buf, map->format.reg_bytes);
 		memcpy(buf + map->format.reg_bytes + map->format.pad_bytes,
 		       val, val_len);
-		ret = map->bus->write(map->bus_context, buf, len);
+		ret = map->bus->write(map->context, buf, len);
 
 		kfree(buf);
 	}
@@ -1259,7 +1261,7 @@ static int _regmap_bus_formatted_write(void *context, unsigned int reg,
 
 	trace_regmap_hw_write_start(map->dev, reg, 1);
 
-	ret = map->bus->write(map->bus_context, map->work_buf,
+	ret = map->bus->write(map->context, map->work_buf,
 			      map->format.buf_size);
 
 	trace_regmap_hw_write_done(map->dev, reg, 1);
@@ -1285,7 +1287,7 @@ static int _regmap_bus_raw_write(void *context, unsigned int reg,
 
 static inline void *_regmap_map_get_context(struct regmap *map)
 {
-	return (map->bus) ? map : map->bus_context;
+	return (map->bus) ? map : map->context;
 }
 
 int _regmap_write(struct regmap *map, unsigned int reg,
@@ -1681,7 +1683,7 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	trace_regmap_hw_read_start(map->dev, reg,
 				   val_len / map->format.val_bytes);
 
-	ret = map->bus->read(map->bus_context, map->work_buf,
+	ret = map->bus->read(map->context, map->work_buf,
 			     map->format.reg_bytes + map->format.pad_bytes,
 			     val, val_len);
 
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index e559078..376b6bf 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -140,6 +140,7 @@ typedef void (*regmap_unlock)(void *);
  *		  operation on a bus such as SPI, I2C, etc. Most of the devices do
  * 		  not need this.
  * @reg_write:	  Same as above for writing.
+ * @free_context: Same as above, called when regmap is destroyed.
  * @fast_io:	  Register IO is fast. Use a spinlock instead of a mutex
  *	     	  to perform locking. This field is ignored if custom lock/unlock
  *	     	  functions are used (see fields lock/unlock of struct regmap_config).
@@ -197,6 +198,7 @@ struct regmap_config {
 
 	int (*reg_read)(void *context, unsigned int reg, unsigned int *val);
 	int (*reg_write)(void *context, unsigned int reg, unsigned int val);
+	void (*free_context)(void *context);
 
 	bool fast_io;
 
@@ -315,7 +317,7 @@ struct regmap_bus {
 
 struct regmap *regmap_init(struct device *dev,
 			   const struct regmap_bus *bus,
-			   void *bus_context,
+			   void *context,
 			   const struct regmap_config *config);
 struct regmap *regmap_init_i2c(struct i2c_client *i2c,
 			       const struct regmap_config *config);
@@ -329,7 +331,7 @@ struct regmap *regmap_init_mmio_clk(struct device *dev, const char *clk_id,
 
 struct regmap *devm_regmap_init(struct device *dev,
 				const struct regmap_bus *bus,
-				void *bus_context,
+				void *context,
 				const struct regmap_config *config);
 struct regmap *devm_regmap_init_i2c(struct i2c_client *i2c,
 				    const struct regmap_config *config);
-- 
1.8.3.2


