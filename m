Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbaGCPJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:09:27 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:27395 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758609AbaGCPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:08:14 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 06/15] Input: atmel_mxt_ts - calculate and check CRC in config file
Date: Thu,  3 Jul 2014 16:01:28 +0100
Message-Id: <1404399697-26484-7-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

By validating the checksum, we can identify if the configuration is
corrupt.  In addition, this patch writes the configuration in a short
series of block writes rather than as many individual values.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 232 +++++++++++++++++++++++--------
 1 file changed, 177 insertions(+), 55 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index e0bd2c1..90c2c4b 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -48,6 +48,8 @@
 #define MXT_OBJECT_START	0x07
 
 #define MXT_OBJECT_SIZE		6
+#define MXT_INFO_CHECKSUM_SIZE	3
+#define MXT_MAX_BLOCK_WRITE	256
 
 /* Object types */
 #define MXT_DEBUG_DIAGNOSTIC_T37	37
@@ -238,12 +240,15 @@ struct mxt_data {
 	unsigned int max_x;
 	unsigned int max_y;
 	bool in_bootloader;
+	u16 mem_size;
 	u32 config_crc;
+	u32 info_crc;
 	u8 bootloader_addr;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
 	u16 T6_address;
+	u16 T7_address;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 	u8 T19_reportid;
@@ -849,6 +854,45 @@ static void mxt_update_crc(struct mxt_data *data, u8 cmd, u8 value)
 	mxt_wait_for_completion(data, &data->crc_completion, MXT_CRC_TIMEOUT);
 }
 
+static void mxt_calc_crc24(u32 *crc, u8 firstbyte, u8 secondbyte)
+{
+	static const unsigned int crcpoly = 0x80001B;
+	u32 result;
+	u32 data_word;
+
+	data_word = (secondbyte << 8) | firstbyte;
+	result = ((*crc << 1) ^ data_word);
+
+	if (result & 0x1000000)
+		result ^= crcpoly;
+
+	*crc = result;
+}
+
+static u32 mxt_calculate_crc(u8 *base, off_t start_off, off_t end_off)
+{
+	u32 crc = 0;
+	u8 *ptr = base + start_off;
+	u8 *last_val = base + end_off - 1;
+
+	if (end_off < start_off)
+		return -EINVAL;
+
+	while (ptr < last_val) {
+		mxt_calc_crc24(&crc, *ptr, *(ptr + 1));
+		ptr += 2;
+	}
+
+	/* if len is odd, fill the last byte with 0 */
+	if (ptr == last_val)
+		mxt_calc_crc24(&crc, *ptr, 0);
+
+	/* Mask to 24-bit */
+	crc &= 0x00FFFFFF;
+
+	return crc;
+}
+
 /*
  * mxt_update_cfg - download configuration to chip
  *
@@ -875,9 +919,13 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 	struct mxt_object *object;
 	int ret;
 	int offset;
-	int pos;
+	int data_pos;
+	int byte_offset;
 	int i;
-	u32 info_crc, config_crc;
+	int cfg_start_ofs;
+	u32 info_crc, config_crc, calculated_crc;
+	u8 *config_mem;
+	size_t config_mem_size;
 	unsigned int type, instance, size;
 	u8 val;
 	u16 reg;
@@ -890,11 +938,11 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 		goto release;
 	}
 
-	pos = strlen(MXT_CFG_MAGIC);
+	data_pos = strlen(MXT_CFG_MAGIC);
 
 	/* Load information block and check */
 	for (i = 0; i < sizeof(struct mxt_info); i++) {
-		ret = sscanf(cfg->data + pos, "%hhx%n",
+		ret = sscanf(cfg->data + data_pos, "%hhx%n",
 			     (unsigned char *)&cfg_info + i,
 			     &offset);
 		if (ret != 1) {
@@ -903,7 +951,7 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 			goto release;
 		}
 
-		pos += offset;
+		data_pos += offset;
 	}
 
 	if (cfg_info.family_id != data->info.family_id) {
@@ -918,125 +966,188 @@ static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 		goto release;
 	}
 
-	if (cfg_info.version != data->info.version)
-		dev_err(dev, "Warning: version mismatch!\n");
-
-	if (cfg_info.build != data->info.build)
-		dev_err(dev, "Warning: build num mismatch!\n");
-
-	ret = sscanf(cfg->data + pos, "%x%n", &info_crc, &offset);
+	/* Read CRCs */
+	ret = sscanf(cfg->data + data_pos, "%x%n", &info_crc, &offset);
 	if (ret != 1) {
 		dev_err(dev, "Bad format: failed to parse Info CRC\n");
 		ret = -EINVAL;
 		goto release;
 	}
-	pos += offset;
+	data_pos += offset;
 
-	/* Check config CRC */
-	ret = sscanf(cfg->data + pos, "%x%n", &config_crc, &offset);
+	ret = sscanf(cfg->data + data_pos, "%x%n", &config_crc, &offset);
 	if (ret != 1) {
 		dev_err(dev, "Bad format: failed to parse Config CRC\n");
 		ret = -EINVAL;
 		goto release;
 	}
-	pos += offset;
+	data_pos += offset;
 
-	if (data->config_crc == config_crc) {
-		dev_dbg(dev, "Config CRC 0x%06X: OK\n", config_crc);
-		ret = 0;
-		goto release;
+	/*
+	 * The Info Block CRC is calculated over mxt_info and the object
+	 * table. If it does not match then we are trying to load the
+	 * configuration from a different chip or firmware version, so
+	 * the configuration CRC is invalid anyway.
+	 */
+	if (info_crc == data->info_crc) {
+		if (config_crc == 0 || data->config_crc == 0) {
+			dev_info(dev, "CRC zero, attempting to apply config\n");
+		} else if (config_crc == data->config_crc) {
+			dev_dbg(dev, "Config CRC 0x%06X: OK\n",
+				 data->config_crc);
+			ret = 0;
+			goto release;
+		} else {
+			dev_info(dev, "Config CRC 0x%06X: does not match file 0x%06X\n",
+				 data->config_crc, config_crc);
+		}
+	} else {
+		dev_warn(dev,
+			 "Warning: Info CRC error - device=0x%06X file=0x%06X\n",
+			 data->info_crc, info_crc);
 	}
 
-	dev_info(dev, "Config CRC 0x%06X: does not match file 0x%06X\n",
-		 data->config_crc, config_crc);
+	/* Malloc memory to store configuration */
+	cfg_start_ofs = MXT_OBJECT_START +
+			data->info.object_num * sizeof(struct mxt_object) +
+			MXT_INFO_CHECKSUM_SIZE;
+	config_mem_size = data->mem_size - cfg_start_ofs;
+	config_mem = kzalloc(config_mem_size, GFP_KERNEL);
+	if (!config_mem) {
+		dev_err(dev, "Failed to allocate memory\n");
+		ret = -ENOMEM;
+		goto release;
+	}
 
-	while (pos < cfg->size) {
+	while (data_pos < cfg->size) {
 		/* Read type, instance, length */
-		ret = sscanf(cfg->data + pos, "%x %x %x%n",
+		ret = sscanf(cfg->data + data_pos, "%x %x %x%n",
 			     &type, &instance, &size, &offset);
 		if (ret == 0) {
 			/* EOF */
-			ret = 1;
-			goto release;
+			break;
 		} else if (ret != 3) {
 			dev_err(dev, "Bad format: failed to parse object\n");
 			ret = -EINVAL;
-			goto release;
+			goto release_mem;
 		}
-		pos += offset;
+		data_pos += offset;
 
 		object = mxt_get_object(data, type);
 		if (!object) {
 			/* Skip object */
 			for (i = 0; i < size; i++) {
-				ret = sscanf(cfg->data + pos, "%hhx%n",
+				ret = sscanf(cfg->data + data_pos, "%hhx%n",
 					     &val,
 					     &offset);
-				pos += offset;
+				data_pos += offset;
 			}
 			continue;
 		}
 
 		if (size > mxt_obj_size(object)) {
-			dev_err(dev, "Discarding %zu byte(s) in T%u\n",
-				size - mxt_obj_size(object), type);
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
 		}
 
 		if (instance >= mxt_obj_instances(object)) {
 			dev_err(dev, "Object instances exceeded!\n");
 			ret = -EINVAL;
-			goto release;
+			goto release_mem;
 		}
 
 		reg = object->start_address + mxt_obj_size(object) * instance;
 
 		for (i = 0; i < size; i++) {
-			ret = sscanf(cfg->data + pos, "%hhx%n",
+			ret = sscanf(cfg->data + data_pos, "%hhx%n",
 				     &val,
 				     &offset);
 			if (ret != 1) {
 				dev_err(dev, "Bad format in T%d\n", type);
 				ret = -EINVAL;
-				goto release;
+				goto release_mem;
 			}
-			pos += offset;
+			data_pos += offset;
 
 			if (i > mxt_obj_size(object))
 				continue;
 
-			ret = mxt_write_reg(data->client, reg + i, val);
-			if (ret)
-				goto release;
+			byte_offset = reg + i - cfg_start_ofs;
 
+			if ((byte_offset >= 0)
+			    && (byte_offset <= config_mem_size)) {
+				*(config_mem + byte_offset) = val;
+			} else {
+				dev_err(dev, "Bad object: reg:%d, T%d, ofs=%d\n",
+					reg, object->type, byte_offset);
+				ret = -EINVAL;
+				goto release_mem;
+			}
 		}
+	}
 
-		/*
-		 * If firmware is upgraded, new bytes may be added to end of
-		 * objects. It is generally forward compatible to zero these
-		 * bytes - previous behaviour will be retained. However
-		 * this does invalidate the CRC and will force a config
-		 * download every time until the configuration is updated.
-		 */
-		if (size < mxt_obj_size(object)) {
-			dev_info(dev, "Zeroing %zu byte(s) in T%d\n",
-				 mxt_obj_size(object) - size, type);
+	/* Calculate crc of the received configs (not the raw config file) */
+	if (data->T7_address < cfg_start_ofs) {
+		dev_err(dev, "Bad T7 address, T7addr = %x, config offset %x\n",
+			data->T7_address, cfg_start_ofs);
+		ret = 0;
+		goto release_mem;
+	}
 
-			for (i = size + 1; i < mxt_obj_size(object); i++) {
-				ret = mxt_write_reg(data->client, reg + i, 0);
-				if (ret)
-					goto release;
-			}
+	calculated_crc = mxt_calculate_crc(config_mem,
+					   data->T7_address - cfg_start_ofs,
+					   config_mem_size);
+
+	if (config_crc > 0 && (config_crc != calculated_crc))
+		dev_warn(dev, "Config CRC error, calculated=%06X, file=%06X\n",
+			 calculated_crc, config_crc);
+
+	/* Write configuration as blocks */
+	byte_offset = 0;
+	while (byte_offset < config_mem_size) {
+		size = config_mem_size - byte_offset;
+
+		if (size > MXT_MAX_BLOCK_WRITE)
+			size = MXT_MAX_BLOCK_WRITE;
+
+		ret = __mxt_write_reg(data->client,
+				      cfg_start_ofs + byte_offset,
+				      size, config_mem + byte_offset);
+		if (ret != 0) {
+			dev_err(dev, "Config write error, ret=%d\n", ret);
+			goto release_mem;
 		}
+
+		byte_offset += size;
 	}
 
 	mxt_update_crc(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE);
 
 	ret = mxt_soft_reset(data);
 	if (ret)
-		goto release;
+		goto release_mem;
 
 	dev_info(dev, "Config successfully updated\n");
 
+release_mem:
+	kfree(config_mem);
 release:
 	release_firmware(cfg);
 	return ret;
@@ -1099,6 +1210,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 	int error;
 	int i;
 	u8 reportid;
+	u16 end_address;
 
 	table_size = data->info.object_num * sizeof(struct mxt_object);
 	object_table = kzalloc(table_size, GFP_KERNEL);
@@ -1116,6 +1228,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 
 	/* Valid Report IDs start counting from 1 */
 	reportid = 1;
+	data->mem_size = 0;
 	for (i = 0; i < data->info.object_num; i++) {
 		struct mxt_object *object = object_table + i;
 		u8 min_id, max_id;
@@ -1143,6 +1256,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->T6_reportid = min_id;
 			data->T6_address = object->start_address;
 			break;
+		case MXT_GEN_POWER_T7:
+			data->T7_address = object->start_address;
+			break;
 		case MXT_TOUCH_MULTI_T9:
 			data->T9_reportid_min = min_id;
 			data->T9_reportid_max = max_id;
@@ -1151,6 +1267,12 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->T19_reportid = min_id;
 			break;
 		}
+
+		end_address = object->start_address
+			+ mxt_obj_size(object) * mxt_obj_instances(object) - 1;
+
+		if (end_address >= data->mem_size)
+			data->mem_size = end_address + 1;
 	}
 
 	data->object_table = object_table;
-- 
2.0.1

