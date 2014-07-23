Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbaGWXaD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:30:03 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61574 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758148AbaGWXaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:30:00 -0400
Date: Wed, 23 Jul 2014 16:29:55 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Yufeng Shen <miletus@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: atmel_mxt_ts - split config update a bit
Message-ID: <20140723232954.GA13095@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's split config update code a bit so it is hopefully a bit easier to
read. Also, the firmware update callback should be the entity releasing
firmware blob, not lower layers.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

As always, not tested...

 drivers/input/touchscreen/atmel_mxt_ts.c | 270 +++++++++++++++++--------------
 1 file changed, 145 insertions(+), 125 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 5882352..9e0181a 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1074,6 +1074,133 @@ static u32 mxt_calculate_crc(u8 *base, off_t start_off, off_t end_off)
 	return crc;
 }
 
+static int mxt_prepare_cfg_mem(struct mxt_data *data,
+			       const struct firmware *cfg,
+			       unsigned int data_pos,
+			       unsigned int cfg_start_ofs,
+			       u8 *config_mem,
+			       size_t config_mem_size)
+{
+	struct device *dev = &data->client->dev;
+	struct mxt_object *object;
+	unsigned int type, instance, size, byte_offset;
+	int offset;
+	int ret;
+	int i;
+	u16 reg;
+	u8 val;
+
+	while (data_pos < cfg->size) {
+		/* Read type, instance, length */
+		ret = sscanf(cfg->data + data_pos, "%x %x %x%n",
+			     &type, &instance, &size, &offset);
+		if (ret == 0) {
+			/* EOF */
+			break;
+		} else if (ret != 3) {
+			dev_err(dev, "Bad format: failed to parse object\n");
+			return -EINVAL;
+		}
+		data_pos += offset;
+
+		object = mxt_get_object(data, type);
+		if (!object) {
+			/* Skip object */
+			for (i = 0; i < size; i++) {
+				ret = sscanf(cfg->data + data_pos, "%hhx%n",
+					     &val,
+					     &offset);
+				data_pos += offset;
+			}
+			continue;
+		}
+
+		if (size > mxt_obj_size(object)) {
+			/*
+			 * Either we are in fallback mode due to wrong
+			 * config or config from a later fw version,
+			 * or the file is corrupt or hand-edited.
+			 */
+			dev_warn(dev, "Discarding %zu byte(s) in T%u\n",
+				 size - mxt_obj_size(object), type);
+		} else if (mxt_obj_size(object) > size) {
+			/*
+			 * If firmware is upgraded, new bytes may be added to
+			 * end of objects. It is generally forward compatible
+			 * to zero these bytes - previous behaviour will be
+			 * retained. However this does invalidate the CRC and
+			 * will force fallback mode until the configuration is
+			 * updated. We warn here but do nothing else - the
+			 * malloc has zeroed the entire configuration.
+			 */
+			dev_warn(dev, "Zeroing %zu byte(s) in T%d\n",
+				 mxt_obj_size(object) - size, type);
+		}
+
+		if (instance >= mxt_obj_instances(object)) {
+			dev_err(dev, "Object instances exceeded!\n");
+			return -EINVAL;
+		}
+
+		reg = object->start_address + mxt_obj_size(object) * instance;
+
+		for (i = 0; i < size; i++) {
+			ret = sscanf(cfg->data + data_pos, "%hhx%n",
+				     &val,
+				     &offset);
+			if (ret != 1) {
+				dev_err(dev, "Bad format in T%d\n", type);
+				return -EINVAL;
+			}
+			data_pos += offset;
+
+			if (i > mxt_obj_size(object))
+				continue;
+
+			byte_offset = reg + i - cfg_start_ofs;
+
+			if (byte_offset >= 0 &&
+			    byte_offset <= config_mem_size) {
+				*(config_mem + byte_offset) = val;
+			} else {
+				dev_err(dev, "Bad object: reg:%d, T%d, ofs=%d\n",
+					reg, object->type, byte_offset);
+				return -EINVAL;
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int mxt_upload_cfg_mem(struct mxt_data *data, unsigned int cfg_start,
+			      u8 *config_mem, size_t config_mem_size)
+{
+	unsigned int byte_offset = 0;
+	int error;
+
+	/* Write configuration as blocks */
+	while (byte_offset < config_mem_size) {
+		unsigned int size = config_mem_size - byte_offset;
+
+		if (size > MXT_MAX_BLOCK_WRITE)
+			size = MXT_MAX_BLOCK_WRITE;
+
+		error = __mxt_write_reg(data->client,
+					cfg_start + byte_offset,
+					size, config_mem + byte_offset);
+		if (error) {
+			dev_err(&data->client->dev,
+				"Config write error, ret=%d\n", error);
+			return error;
+		}
+
+		byte_offset += size;
+	}
+
+	return 0;
+}
+
 /*
  * mxt_update_cfg - download configuration to chip
  *
@@ -1097,26 +1224,20 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 {
 	struct device *dev = &data->client->dev;
 	struct mxt_info cfg_info;
-	struct mxt_object *object;
 	int ret;
 	int offset;
 	int data_pos;
-	int byte_offset;
 	int i;
 	int cfg_start_ofs;
 	u32 info_crc, config_crc, calculated_crc;
 	u8 *config_mem;
 	size_t config_mem_size;
-	unsigned int type, instance, size;
-	u8 val;
-	u16 reg;
 
 	mxt_update_crc(data, MXT_COMMAND_REPORTALL, 1);
 
 	if (strncmp(cfg->data, MXT_CFG_MAGIC, strlen(MXT_CFG_MAGIC))) {
 		dev_err(dev, "Unrecognised config file\n");
-		ret = -EINVAL;
-		goto release;
+		return -EINVAL;
 	}
 
 	data_pos = strlen(MXT_CFG_MAGIC);
@@ -1128,8 +1249,7 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 			     &offset);
 		if (ret != 1) {
 			dev_err(dev, "Bad format\n");
-			ret = -EINVAL;
-			goto release;
+			return -EINVAL;
 		}
 
 		data_pos += offset;
@@ -1137,30 +1257,26 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 
 	if (cfg_info.family_id != data->info.family_id) {
 		dev_err(dev, "Family ID mismatch!\n");
-		ret = -EINVAL;
-		goto release;
+		return -EINVAL;
 	}
 
 	if (cfg_info.variant_id != data->info.variant_id) {
 		dev_err(dev, "Variant ID mismatch!\n");
-		ret = -EINVAL;
-		goto release;
+		return -EINVAL;
 	}
 
 	/* Read CRCs */
 	ret = sscanf(cfg->data + data_pos, "%x%n", &info_crc, &offset);
 	if (ret != 1) {
 		dev_err(dev, "Bad format: failed to parse Info CRC\n");
-		ret = -EINVAL;
-		goto release;
+		return -EINVAL;
 	}
 	data_pos += offset;
 
 	ret = sscanf(cfg->data + data_pos, "%x%n", &config_crc, &offset);
 	if (ret != 1) {
 		dev_err(dev, "Bad format: failed to parse Config CRC\n");
-		ret = -EINVAL;
-		goto release;
+		return -EINVAL;
 	}
 	data_pos += offset;
 
@@ -1176,8 +1292,7 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 		} else if (config_crc == data->config_crc) {
 			dev_dbg(dev, "Config CRC 0x%06X: OK\n",
 				 data->config_crc);
-			ret = 0;
-			goto release;
+			return 0;
 		} else {
 			dev_info(dev, "Config CRC 0x%06X: does not match file 0x%06X\n",
 				 data->config_crc, config_crc);
@@ -1196,93 +1311,13 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 	config_mem = kzalloc(config_mem_size, GFP_KERNEL);
 	if (!config_mem) {
 		dev_err(dev, "Failed to allocate memory\n");
-		ret = -ENOMEM;
-		goto release;
+		return -ENOMEM;
 	}
 
-	while (data_pos < cfg->size) {
-		/* Read type, instance, length */
-		ret = sscanf(cfg->data + data_pos, "%x %x %x%n",
-			     &type, &instance, &size, &offset);
-		if (ret == 0) {
-			/* EOF */
-			break;
-		} else if (ret != 3) {
-			dev_err(dev, "Bad format: failed to parse object\n");
-			ret = -EINVAL;
-			goto release_mem;
-		}
-		data_pos += offset;
-
-		object = mxt_get_object(data, type);
-		if (!object) {
-			/* Skip object */
-			for (i = 0; i < size; i++) {
-				ret = sscanf(cfg->data + data_pos, "%hhx%n",
-					     &val,
-					     &offset);
-				data_pos += offset;
-			}
-			continue;
-		}
-
-		if (size > mxt_obj_size(object)) {
-			/*
-			 * Either we are in fallback mode due to wrong
-			 * config or config from a later fw version,
-			 * or the file is corrupt or hand-edited.
-			 */
-			dev_warn(dev, "Discarding %zu byte(s) in T%u\n",
-				 size - mxt_obj_size(object), type);
-		} else if (mxt_obj_size(object) > size) {
-			/*
-			 * If firmware is upgraded, new bytes may be added to
-			 * end of objects. It is generally forward compatible
-			 * to zero these bytes - previous behaviour will be
-			 * retained. However this does invalidate the CRC and
-			 * will force fallback mode until the configuration is
-			 * updated. We warn here but do nothing else - the
-			 * malloc has zeroed the entire configuration.
-			 */
-			dev_warn(dev, "Zeroing %zu byte(s) in T%d\n",
-				 mxt_obj_size(object) - size, type);
-		}
-
-		if (instance >= mxt_obj_instances(object)) {
-			dev_err(dev, "Object instances exceeded!\n");
-			ret = -EINVAL;
-			goto release_mem;
-		}
-
-		reg = object->start_address + mxt_obj_size(object) * instance;
-
-		for (i = 0; i < size; i++) {
-			ret = sscanf(cfg->data + data_pos, "%hhx%n",
-				     &val,
-				     &offset);
-			if (ret != 1) {
-				dev_err(dev, "Bad format in T%d\n", type);
-				ret = -EINVAL;
-				goto release_mem;
-			}
-			data_pos += offset;
-
-			if (i > mxt_obj_size(object))
-				continue;
-
-			byte_offset = reg + i - cfg_start_ofs;
-
-			if ((byte_offset >= 0)
-			    && (byte_offset <= config_mem_size)) {
-				*(config_mem + byte_offset) = val;
-			} else {
-				dev_err(dev, "Bad object: reg:%d, T%d, ofs=%d\n",
-					reg, object->type, byte_offset);
-				ret = -EINVAL;
-				goto release_mem;
-			}
-		}
-	}
+	ret = mxt_prepare_cfg_mem(data, cfg, data_pos, cfg_start_ofs,
+				  config_mem, config_mem_size);
+	if (ret)
+		goto release_mem;
 
 	/* Calculate crc of the received configs (not the raw config file) */
 	if (data->T7_address < cfg_start_ofs) {
@@ -1296,28 +1331,14 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 					   data->T7_address - cfg_start_ofs,
 					   config_mem_size);
 
-	if (config_crc > 0 && (config_crc != calculated_crc))
+	if (config_crc > 0 && config_crc != calculated_crc)
 		dev_warn(dev, "Config CRC error, calculated=%06X, file=%06X\n",
 			 calculated_crc, config_crc);
 
-	/* Write configuration as blocks */
-	byte_offset = 0;
-	while (byte_offset < config_mem_size) {
-		size = config_mem_size - byte_offset;
-
-		if (size > MXT_MAX_BLOCK_WRITE)
-			size = MXT_MAX_BLOCK_WRITE;
-
-		ret = __mxt_write_reg(data->client,
-				      cfg_start_ofs + byte_offset,
-				      size, config_mem + byte_offset);
-		if (ret != 0) {
-			dev_err(dev, "Config write error, ret=%d\n", ret);
-			goto release_mem;
-		}
-
-		byte_offset += size;
-	}
+	ret = mxt_upload_cfg_mem(data, cfg_start_ofs,
+				 config_mem, config_mem_size);
+	if (ret)
+		goto release_mem;
 
 	mxt_update_crc(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE);
 
@@ -1329,8 +1350,6 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 
 release_mem:
 	kfree(config_mem);
-release:
-	release_firmware(cfg);
 	return ret;
 }
 
@@ -1648,6 +1667,7 @@ static int mxt_configure_objects(struct mxt_data *data,
 static void mxt_config_cb(const struct firmware *cfg, void *ctx)
 {
 	mxt_configure_objects(ctx, cfg);
+	release_firmware(cfg);
 }
 
 static int mxt_initialize(struct mxt_data *data)
-- 
2.0.0.526.g5318336


-- 
Dmitry
