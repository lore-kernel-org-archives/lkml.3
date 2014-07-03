Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbaGCPIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:08:21 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:35115 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758605AbaGCPIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:08:15 -0400
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
Subject: [PATCH 05/15] Input: atmel_mxt_ts - download device config using firmware loader
Date: Thu,  3 Jul 2014 16:01:27 +0100
Message-Id: <1404399697-26484-6-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

The existing implementation which encodes the configuration as a binary
blob in platform data is unsatisfactory since it requires a kernel
recompile for the configuration to be changed, and it doesn't deal well
with firmware changes that move values around on the chip.

Atmel define an ASCII format for the configuration which can be exported
from their tools. This patch implements a parser for that format which
loads the configuration via the firmware loader and sends it to the MXT
chip.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c  | 278 ++++++++++++++++++++++--------
 drivers/platform/chrome/chromeos_laptop.c |   4 -
 include/linux/i2c/atmel_mxt_ts.h          |   3 -
 3 files changed, 204 insertions(+), 81 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 5a095f6..e0bd2c1 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2,6 +2,7 @@
  * Atmel maXTouch Touchscreen driver
  *
  * Copyright (C) 2010 Samsung Electronics Co.Ltd
+ * Copyright (C) 2011-2014 Atmel Corporation
  * Copyright (C) 2012 Google, Inc.
  *
  * Author: Joonyoung Shim <jy0922.shim@samsung.com>
@@ -30,8 +31,10 @@
 #define MXT_VER_21		21
 #define MXT_VER_22		22
 
-/* Firmware */
+/* Firmware files */
 #define MXT_FW_NAME		"maxtouch.fw"
+#define MXT_CFG_NAME		"maxtouch.cfg"
+#define MXT_CFG_MAGIC		"OBP_RAW V1"
 
 /* Registers */
 #define MXT_INFO		0x00
@@ -298,37 +301,6 @@ static bool mxt_object_readable(unsigned int type)
 	}
 }
 
-static bool mxt_object_writable(unsigned int type)
-{
-	switch (type) {
-	case MXT_GEN_COMMAND_T6:
-	case MXT_GEN_POWER_T7:
-	case MXT_GEN_ACQUIRE_T8:
-	case MXT_TOUCH_MULTI_T9:
-	case MXT_TOUCH_KEYARRAY_T15:
-	case MXT_TOUCH_PROXIMITY_T23:
-	case MXT_TOUCH_PROXKEY_T52:
-	case MXT_PROCI_GRIPFACE_T20:
-	case MXT_PROCG_NOISE_T22:
-	case MXT_PROCI_ONETOUCH_T24:
-	case MXT_PROCI_TWOTOUCH_T27:
-	case MXT_PROCI_GRIP_T40:
-	case MXT_PROCI_PALM_T41:
-	case MXT_PROCI_TOUCHSUPPRESSION_T42:
-	case MXT_PROCI_STYLUS_T47:
-	case MXT_PROCG_NOISESUPPRESSION_T48:
-	case MXT_SPT_COMMSCONFIG_T18:
-	case MXT_SPT_GPIOPWM_T19:
-	case MXT_SPT_SELFTEST_T25:
-	case MXT_SPT_CTECONFIG_T28:
-	case MXT_SPT_DIGITIZER_T43:
-	case MXT_SPT_CTECONFIG_T46:
-		return true;
-	default:
-		return false;
-	}
-}
-
 static void mxt_dump_message(struct device *dev,
 			     struct mxt_message *message)
 {
@@ -606,7 +578,7 @@ mxt_get_object(struct mxt_data *data, u8 type)
 			return object;
 	}
 
-	dev_err(&data->client->dev, "Invalid object type T%u\n", type);
+	dev_warn(&data->client->dev, "Invalid object type T%u\n", type);
 	return NULL;
 }
 
@@ -877,58 +849,197 @@ static void mxt_update_crc(struct mxt_data *data, u8 cmd, u8 value)
 	mxt_wait_for_completion(data, &data->crc_completion, MXT_CRC_TIMEOUT);
 }
 
-static int mxt_check_reg_init(struct mxt_data *data)
+/*
+ * mxt_update_cfg - download configuration to chip
+ *
+ * Atmel Raw Config File Format
+ *
+ * The first four lines of the raw config file contain:
+ *  1) Version
+ *  2) Chip ID Information (first 7 bytes of device memory)
+ *  3) Chip Information Block 24-bit CRC Checksum
+ *  4) Chip Configuration 24-bit CRC Checksum
+ *
+ * The rest of the file consists of one line per object instance:
+ *   <TYPE> <INSTANCE> <SIZE> <CONTENTS>
+ *
+ *   <TYPE> - 2-byte object type as hex
+ *   <INSTANCE> - 2-byte object instance number as hex
+ *   <SIZE> - 2-byte object size as hex
+ *   <CONTENTS> - array of <SIZE> 1-byte hex values
+ */
+static int mxt_update_cfg(struct mxt_data *data, const struct firmware *cfg)
 {
-	const struct mxt_platform_data *pdata = data->pdata;
-	struct mxt_object *object;
 	struct device *dev = &data->client->dev;
-	int index = 0;
-	int i, size;
+	struct mxt_info cfg_info;
+	struct mxt_object *object;
 	int ret;
+	int offset;
+	int pos;
+	int i;
+	u32 info_crc, config_crc;
+	unsigned int type, instance, size;
+	u8 val;
+	u16 reg;
 
-	if (!pdata->config) {
-		dev_dbg(dev, "No cfg data defined, skipping reg init\n");
-		return 0;
+	mxt_update_crc(data, MXT_COMMAND_REPORTALL, 1);
+
+	if (strncmp(cfg->data, MXT_CFG_MAGIC, strlen(MXT_CFG_MAGIC))) {
+		dev_err(dev, "Unrecognised config file\n");
+		ret = -EINVAL;
+		goto release;
 	}
 
-	mxt_update_crc(data, MXT_COMMAND_REPORTALL, 1);
+	pos = strlen(MXT_CFG_MAGIC);
+
+	/* Load information block and check */
+	for (i = 0; i < sizeof(struct mxt_info); i++) {
+		ret = sscanf(cfg->data + pos, "%hhx%n",
+			     (unsigned char *)&cfg_info + i,
+			     &offset);
+		if (ret != 1) {
+			dev_err(dev, "Bad format\n");
+			ret = -EINVAL;
+			goto release;
+		}
 
-	if (data->config_crc == pdata->config_crc) {
-		dev_info(dev, "Config CRC 0x%06X: OK\n", data->config_crc);
-		return 0;
+		pos += offset;
+	}
+
+	if (cfg_info.family_id != data->info.family_id) {
+		dev_err(dev, "Family ID mismatch!\n");
+		ret = -EINVAL;
+		goto release;
 	}
 
-	dev_info(dev, "Config CRC 0x%06X: does not match 0x%06X\n",
-		 data->config_crc, pdata->config_crc);
+	if (cfg_info.variant_id != data->info.variant_id) {
+		dev_err(dev, "Variant ID mismatch!\n");
+		ret = -EINVAL;
+		goto release;
+	}
 
-	for (i = 0; i < data->info.object_num; i++) {
-		object = data->object_table + i;
+	if (cfg_info.version != data->info.version)
+		dev_err(dev, "Warning: version mismatch!\n");
 
-		if (!mxt_object_writable(object->type))
+	if (cfg_info.build != data->info.build)
+		dev_err(dev, "Warning: build num mismatch!\n");
+
+	ret = sscanf(cfg->data + pos, "%x%n", &info_crc, &offset);
+	if (ret != 1) {
+		dev_err(dev, "Bad format: failed to parse Info CRC\n");
+		ret = -EINVAL;
+		goto release;
+	}
+	pos += offset;
+
+	/* Check config CRC */
+	ret = sscanf(cfg->data + pos, "%x%n", &config_crc, &offset);
+	if (ret != 1) {
+		dev_err(dev, "Bad format: failed to parse Config CRC\n");
+		ret = -EINVAL;
+		goto release;
+	}
+	pos += offset;
+
+	if (data->config_crc == config_crc) {
+		dev_dbg(dev, "Config CRC 0x%06X: OK\n", config_crc);
+		ret = 0;
+		goto release;
+	}
+
+	dev_info(dev, "Config CRC 0x%06X: does not match file 0x%06X\n",
+		 data->config_crc, config_crc);
+
+	while (pos < cfg->size) {
+		/* Read type, instance, length */
+		ret = sscanf(cfg->data + pos, "%x %x %x%n",
+			     &type, &instance, &size, &offset);
+		if (ret == 0) {
+			/* EOF */
+			ret = 1;
+			goto release;
+		} else if (ret != 3) {
+			dev_err(dev, "Bad format: failed to parse object\n");
+			ret = -EINVAL;
+			goto release;
+		}
+		pos += offset;
+
+		object = mxt_get_object(data, type);
+		if (!object) {
+			/* Skip object */
+			for (i = 0; i < size; i++) {
+				ret = sscanf(cfg->data + pos, "%hhx%n",
+					     &val,
+					     &offset);
+				pos += offset;
+			}
 			continue;
+		}
 
-		size = mxt_obj_size(object) * mxt_obj_instances(object);
-		if (index + size > pdata->config_length) {
-			dev_err(dev, "Not enough config data!\n");
-			return -EINVAL;
+		if (size > mxt_obj_size(object)) {
+			dev_err(dev, "Discarding %zu byte(s) in T%u\n",
+				size - mxt_obj_size(object), type);
 		}
 
-		ret = __mxt_write_reg(data->client, object->start_address,
-				size, &pdata->config[index]);
-		if (ret)
-			return ret;
-		index += size;
+		if (instance >= mxt_obj_instances(object)) {
+			dev_err(dev, "Object instances exceeded!\n");
+			ret = -EINVAL;
+			goto release;
+		}
+
+		reg = object->start_address + mxt_obj_size(object) * instance;
+
+		for (i = 0; i < size; i++) {
+			ret = sscanf(cfg->data + pos, "%hhx%n",
+				     &val,
+				     &offset);
+			if (ret != 1) {
+				dev_err(dev, "Bad format in T%d\n", type);
+				ret = -EINVAL;
+				goto release;
+			}
+			pos += offset;
+
+			if (i > mxt_obj_size(object))
+				continue;
+
+			ret = mxt_write_reg(data->client, reg + i, val);
+			if (ret)
+				goto release;
+
+		}
+
+		/*
+		 * If firmware is upgraded, new bytes may be added to end of
+		 * objects. It is generally forward compatible to zero these
+		 * bytes - previous behaviour will be retained. However
+		 * this does invalidate the CRC and will force a config
+		 * download every time until the configuration is updated.
+		 */
+		if (size < mxt_obj_size(object)) {
+			dev_info(dev, "Zeroing %zu byte(s) in T%d\n",
+				 mxt_obj_size(object) - size, type);
+
+			for (i = size + 1; i < mxt_obj_size(object); i++) {
+				ret = mxt_write_reg(data->client, reg + i, 0);
+				if (ret)
+					goto release;
+			}
+		}
 	}
 
 	mxt_update_crc(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE);
 
 	ret = mxt_soft_reset(data);
 	if (ret)
-		return ret;
+		goto release;
 
 	dev_info(dev, "Config successfully updated\n");
 
-	return 0;
+release:
+	release_firmware(cfg);
+	return ret;
 }
 
 static int mxt_make_highchg(struct mxt_data *data)
@@ -1204,10 +1315,17 @@ err_free_mem:
 	return error;
 }
 
+static int mxt_configure_objects(struct mxt_data *data,
+				 const struct firmware *cfg);
+
+static void mxt_config_cb(const struct firmware *cfg, void *ctx)
+{
+	mxt_configure_objects(ctx, cfg);
+}
+
 static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
-	struct mxt_info *info = &data->info;
 	int error;
 
 	error = mxt_get_info(data);
@@ -1225,28 +1343,40 @@ static int mxt_initialize(struct mxt_data *data)
 	if (error)
 		goto err_free_object_table;
 
-	/* Check register init values */
-	error = mxt_check_reg_init(data);
-	if (error) {
-		dev_err(&client->dev, "Error %d initializing configuration\n",
-			error);
-		goto err_free_object_table;
+	request_firmware_nowait(THIS_MODULE, true, MXT_CFG_NAME,
+				&data->client->dev, GFP_KERNEL, data,
+				mxt_config_cb);
+
+	return 0;
+
+err_free_object_table:
+	mxt_free_object_table(data);
+	return error;
+}
+
+static int mxt_configure_objects(struct mxt_data *data,
+				 const struct firmware *cfg)
+{
+	struct device *dev = &data->client->dev;
+	struct mxt_info *info = &data->info;
+	int error;
+
+	if (cfg) {
+		error = mxt_update_cfg(data, cfg);
+		if (error)
+			dev_warn(dev, "Error %d updating config\n", error);
 	}
 
 	error = mxt_initialize_t9_input_device(data);
 	if (error)
-		goto err_free_object_table;
+		return error;
 
-	dev_info(&client->dev,
+	dev_info(dev,
 		 "Family: %u Variant: %u Firmware V%u.%u.%02X Objects: %u\n",
 		 info->family_id, info->variant_id, info->version >> 4,
 		 info->version & 0xf, info->build, info->object_num);
 
 	return 0;
-
-err_free_object_table:
-	mxt_free_object_table(data);
-	return error;
 }
 
 /* Firmware Version is returned as Major.Minor.Build */
diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 7f1a2e2..67b316b 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -97,8 +97,6 @@ static struct mxt_platform_data atmel_224s_tp_platform_data = {
 	.irqflags		= IRQF_TRIGGER_FALLING,
 	.t19_num_keys		= ARRAY_SIZE(mxt_t19_keys),
 	.t19_keymap		= mxt_t19_keys,
-	.config			= NULL,
-	.config_length		= 0,
 };
 
 static struct i2c_board_info atmel_224s_tp_device = {
@@ -109,8 +107,6 @@ static struct i2c_board_info atmel_224s_tp_device = {
 
 static struct mxt_platform_data atmel_1664s_platform_data = {
 	.irqflags		= IRQF_TRIGGER_FALLING,
-	.config			= NULL,
-	.config_length		= 0,
 };
 
 static struct i2c_board_info atmel_1664s_device = {
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index 3891dc1..02bf6ea 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -17,9 +17,6 @@
 
 /* The platform data for the Atmel maXTouch touchscreen driver */
 struct mxt_platform_data {
-	const u8 *config;
-	size_t config_length;
-	u32 config_crc;
 	unsigned long irqflags;
 	u8 t19_num_keys;
 	const unsigned int *t19_keymap;
-- 
2.0.1

