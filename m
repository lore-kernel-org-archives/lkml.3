Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab3BVSO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:14:27 -0500
Received: from [89.21.227.133] ([89.21.227.133]:62537 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759042Ab3BVSIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:34 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 09/40] Input: atmel_mxt_ts - Calculate and check CRC in config file
Date: Fri, 22 Feb 2013 17:57:56 +0000
Message-Id: <1361555907-19840-10-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By validating the checksum, we can identify if the configuration is corrupt.
In addition, this patch writes the configuration in a short series of block
writes rather than as many individual values.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  237 +++++++++++++++++++++---------
 1 file changed, 168 insertions(+), 69 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index d015168..302c03e 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -264,10 +264,12 @@ struct mxt_data {
 	struct bin_attribute mem_access_attr;
 	bool debug_enabled;
 	u32 config_crc;
+	u32 info_crc;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
 	u16 T6_address;
+	u16 T7_address;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 };
@@ -673,6 +675,45 @@ static void mxt_read_current_crc(struct mxt_data *data)
 	mxt_process_messages_until_invalid(data);
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
 static int mxt_check_reg_init(struct mxt_data *data)
 {
 	struct device *dev = &data->client->dev;
@@ -681,9 +722,13 @@ static int mxt_check_reg_init(struct mxt_data *data)
 	const struct firmware *cfg = NULL;
 	int ret;
 	int offset;
-	int pos;
+	int data_pos;
+	int byte_offset;
 	int i;
-	u32 info_crc, config_crc;
+	int config_start_offset;
+	u32 info_crc, config_crc, calculated_crc;
+	u8 *config_mem;
+	size_t config_mem_size;
 	unsigned int type, instance, size;
 	u8 val;
 	u16 reg;
@@ -703,11 +748,11 @@ static int mxt_check_reg_init(struct mxt_data *data)
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
@@ -716,132 +761,183 @@ static int mxt_check_reg_init(struct mxt_data *data)
 			goto release;
 		}
 
-		pos += offset;
+		data_pos += offset;
 	}
 
-	if (cfg_info.family_id != data->info.family_id) {
-		dev_err(dev, "Family ID mismatch!\n");
-		ret = -EINVAL;
-		goto release;
-	}
-
-	if (cfg_info.variant_id != data->info.variant_id) {
-		dev_err(dev, "Variant ID mismatch!\n");
-		ret = -EINVAL;
-		goto release;
-	}
-
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
+
+	/* The Info Block CRC is calculated over mxt_info and the object table
+	 * If it does not match then we are trying to load the configuration
+	 * from a different chip or firmware version, so the configuration CRC
+	 * is invalid anyway. */
+	if (info_crc == data->info_crc) {
+		if (config_crc == 0 || data->config_crc == 0) {
+			dev_info(dev, "CRC zero, attempting to apply config\n");
+		} else if (config_crc == data->config_crc) {
+			dev_info(dev, "Config CRC 0x%06X: OK\n", data->config_crc);
+			ret = 0;
+			goto release;
+		} else {
+			dev_info(dev, "Config CRC 0x%06X: does not match file 0x%06X\n",
+				 data->config_crc, config_crc);
+		}
+	} else {
+		dev_warn(dev,
+			 "Warning: Info CRC error - device=0x%06X file=0x%06X\n",
+			data->info_crc, info_crc);
+	}
 
-	if (data->config_crc == config_crc) {
-		dev_info(dev, "Config CRC 0x%06X: OK\n", config_crc);
-		ret = 0;
+	/* Malloc memory to store configuration */
+	config_start_offset = MXT_OBJECT_START
+		+ data->info.object_num * sizeof(struct mxt_object);
+	config_mem_size = data->mem_size - config_start_offset;
+	config_mem = kzalloc(config_mem_size, GFP_KERNEL);
+	if (!config_mem) {
+		dev_err(dev, "Failed to allocate memory\n");
+		ret = -ENOMEM;
 		goto release;
-	} else {
-		dev_info(dev, "Config CRC 0x%06X: does not match file 0x%06X\n",
-			 data->config_crc, config_crc);
 	}
 
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
 			ret = -EINVAL;
-			goto release;
-		}
-
-		if (size > OBP_SIZE(object)) {
-			dev_err(dev, "Object length exceeded!\n");
-			ret = -EINVAL;
-			goto release;
+			goto release_mem;
 		}
 
 		if (instance >= OBP_INSTANCES(object)) {
 			dev_err(dev, "Object instances exceeded!\n");
 			ret = -EINVAL;
-			goto release;
+			goto release_mem;
 		}
 
 		reg = object->start_address + OBP_SIZE(object) * instance;
 
+		if (size > OBP_SIZE(object)) {
+			/* Either we are in fallback mode due to wrong
+			 * config or config from a later fw version,
+			 * or the file is corrupt or hand-edited */
+			dev_warn(dev, "Discarding %u bytes in T%u!\n",
+				 size - OBP_SIZE(object), type);
+
+			size = OBP_SIZE(object);
+		} else if (OBP_SIZE(object) > size) {
+			/* If firmware is upgraded, new bytes may be added to
+			 * end of objects. It is generally forward compatible
+			 * to zero these bytes - previous behaviour will be
+			 * retained. However this does invalidate the CRC and
+			 * will force fallback mode until the configuration is
+			 * updated. We warn here but do nothing else - the
+			 * malloc has zeroed the entire configuration. */
+			dev_warn(dev, "Zeroing %d byte(s) in T%d\n",
+				 OBP_SIZE(object) - size, type);
+		}
+
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
 
-			ret = mxt_write_reg(data->client, reg + i, val);
-			if (ret)
-				goto release;
+			byte_offset = reg + i - config_start_offset;
+
+			if ((byte_offset >= 0)
+			    && (byte_offset <= config_mem_size)) {
+				*(config_mem + byte_offset) = val;
+			} else {
+				dev_err(dev, "Bad object: reg:%d, T%d, ofs=%d\n",
+					reg, object->type, byte_offset);
+				ret = -EINVAL;
+				goto release_mem;
+			}
 
-			pos += offset;
+			data_pos += offset;
 		}
 
-		/* If firmware is upgraded, new bytes may be added to end of
-		 * objects. It is generally forward compatible to zero these
-		 * bytes - previous behaviour will be retained. However
-		 * this does invalidate the CRC and will force a config
-		 * download every time until the configuration is updated */
-		if (size < OBP_SIZE(object)) {
-			dev_info(dev, "Warning: zeroing %d byte(s) in T%d\n",
-				 OBP_SIZE(object) - size, type);
+	}
 
-			for (i = size + 1; i < OBP_SIZE(object); i++) {
-				ret = mxt_write_reg(data->client, reg + i, 0);
-				if (ret)
-					goto release;
-			}
+	/* calculate crc of the received configs (not the raw config file) */
+	if (data->T7_address < config_start_offset) {
+		dev_err(dev, "Bad T7 address, T7addr = %x, config offset %x\n",
+				data->T7_address, config_start_offset);
+		ret = 0;
+		goto release_mem;
+	}
+
+	calculated_crc = mxt_calculate_crc(config_mem,
+			data->T7_address - config_start_offset, config_mem_size);
+
+	/* check the crc, calculated should same as what's in file */
+	if (config_crc > 0 && (config_crc != calculated_crc)) {
+		dev_err(dev, "CRC mismatch in config file, calculated=%06X, file=%06X\n",
+				calculated_crc, config_crc);
+		ret = 0;
+		goto release_mem;
+	}
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
+				      config_start_offset + byte_offset,
+				      size, config_mem + byte_offset);
+		if (ret != 0) {
+			dev_err(dev, "Config write error, ret=%d\n", ret);
+			goto release_mem;
 		}
+
+		byte_offset += size;
 	}
 
 	ret = mxt_t6_command(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE, false);
 	if (ret)
-		goto release;
+		goto release_mem;
 
 	ret = mxt_soft_reset(data, MXT_RESET_VALUE);
 	if (ret)
-		goto release;
+		goto release_mem;
 
 	dev_info(dev, "Config written\n");
 
+release_mem:
+	kfree(config_mem);
 release:
 	release_firmware(cfg);
 	return ret;
@@ -927,6 +1023,9 @@ static int mxt_get_object_table(struct mxt_data *data)
 			data->T6_reportid = min_id;
 			data->T6_address = object->start_address;
 			break;
+		case MXT_GEN_POWER_T7:
+			data->T7_address = object->start_address;
+			break;
 		case MXT_TOUCH_MULTI_T9:
 			data->T9_reportid_min = min_id;
 			data->T9_reportid_max = max_id;
-- 
1.7.10.4

