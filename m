Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3F0Muk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:50:40 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:62414 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753089Ab3F0Mui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:38 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 12/51] Input: atmel_mxt_ts - Download device config using firmware loader
Date: Thu, 27 Jun 2013 13:48:47 +0100
Message-Id: <1372337366-9286-13-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing implementation which encodes the configuration as a binary blob
in platform data is unsatisfactory since it requires a kernel recompile for
the configuration to be changed, and it doesn't deal well with firmware
changes that move values around on the chip.

Atmel define an ASCII format for the configuration which can be exported from
their tools. This patch implements a parser for that format which loads the
configuration via the firmware loader and sends it to the MXT chip.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  234 ++++++++++++++++++++++--------
 drivers/platform/x86/chromeos_laptop.c   |    4 -
 include/linux/i2c/atmel_mxt_ts.h         |    4 -
 3 files changed, 175 insertions(+), 67 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index ad9fc91..2054c64 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -36,8 +36,10 @@
 #define MXT_BOOT_LOW		0x24
 #define MXT_BOOT_HIGH		0x25
 
-/* Firmware */
+/* Firmware files */
 #define MXT_FW_NAME		"maxtouch.fw"
+#define MXT_CFG_NAME		"maxtouch.cfg"
+#define MXT_CFG_MAGIC		"OBP_RAW V1"
 
 /* Registers */
 #define MXT_INFO		0x00
@@ -326,37 +328,6 @@ static bool mxt_object_readable(unsigned int type)
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
@@ -550,7 +521,7 @@ mxt_get_object(struct mxt_data *data, u8 type)
 			return object;
 	}
 
-	dev_err(&data->client->dev, "Invalid object type T%u\n", type);
+	dev_warn(&data->client->dev, "Invalid object type T%u\n", type);
 	return NULL;
 }
 
@@ -797,58 +768,203 @@ static void mxt_update_crc(struct mxt_data *data, u8 cmd, u8 value)
 	mxt_wait_for_completion(data, &data->crc_completion, MXT_CRC_TIMEOUT);
 }
 
+/*
+ * mxt_check_reg_init - download configuration to chip
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
 static int mxt_check_reg_init(struct mxt_data *data)
 {
-	const struct mxt_platform_data *pdata = data->pdata;
-	struct mxt_object *object;
 	struct device *dev = &data->client->dev;
-	int index = 0;
-	int i, size;
+	struct mxt_info cfg_info;
+	struct mxt_object *object;
+	const struct firmware *cfg = NULL;
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
+	ret = request_firmware(&cfg, MXT_CFG_NAME, dev);
+	if (ret < 0) {
+		dev_err(dev, "Failure to request config file %s\n",
+			MXT_CFG_NAME);
 		return 0;
 	}
 
 	mxt_update_crc(data, MXT_COMMAND_REPORTALL, 1);
 
-	if (data->config_crc == pdata->config_crc) {
-		dev_info(dev, "Config CRC 0x%06X: OK\n", data->config_crc);
-		return 0;
-	} else {
-		dev_info(dev, "Config CRC 0x%06X: does not match 0x%06X\n",
-				data->config_crc, pdata->config_crc);
+	if (strncmp(cfg->data, MXT_CFG_MAGIC, strlen(MXT_CFG_MAGIC))) {
+		dev_err(dev, "Unrecognised config file\n");
+		ret = -EINVAL;
+		goto release;
 	}
 
-	for (i = 0; i < data->info.object_num; i++) {
-		object = data->object_table + i;
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
+
+		pos += offset;
+	}
+
+	if (cfg_info.family_id != data->info.family_id) {
+		dev_err(dev, "Family ID mismatch!\n");
+		ret = -EINVAL;
+		goto release;
+	}
 
-		if (!mxt_object_writable(object->type))
+	if (cfg_info.variant_id != data->info.variant_id) {
+		dev_err(dev, "Variant ID mismatch!\n");
+		ret = -EINVAL;
+		goto release;
+	}
+
+	if (cfg_info.version != data->info.version)
+		dev_err(dev, "Warning: version mismatch!\n");
+
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
+		dev_info(dev, "Config CRC 0x%06X: OK\n", config_crc);
+		ret = 0;
+		goto release;
+	} else {
+		dev_info(dev, "Config CRC 0x%06X: does not match file 0x%06X\n",
+			 data->config_crc, config_crc);
+	}
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
+			dev_err(dev, "Discarding %u byte(s) in T%u\n",
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
+		/* If firmware is upgraded, new bytes may be added to end of
+		 * objects. It is generally forward compatible to zero these
+		 * bytes - previous behaviour will be retained. However
+		 * this does invalidate the CRC and will force a config
+		 * download every time until the configuration is updated */
+		if (size < mxt_obj_size(object)) {
+			dev_info(dev, "Zeroing %u byte(s) in T%d\n",
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
 
 	dev_info(dev, "Config written\n");
 
-	return 0;
+release:
+	release_firmware(cfg);
+	return ret;
 }
 
 static int mxt_make_highchg(struct mxt_data *data)
diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index 8026554..4f6f0b8 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -86,8 +86,6 @@ static struct mxt_platform_data atmel_224s_tp_platform_data = {
 	.irqflags		= IRQF_TRIGGER_FALLING,
 	.t19_num_keys		= ARRAY_SIZE(mxt_t19_keys),
 	.t19_keymap		= mxt_t19_keys,
-	.config			= NULL,
-	.config_length		= 0,
 };
 
 static struct i2c_board_info __initdata atmel_224s_tp_device = {
@@ -101,8 +99,6 @@ static struct mxt_platform_data atmel_1664s_platform_data = {
 	.y_size			= 2560,
 	.orient			= MXT_ROTATED_90_COUNTER,
 	.irqflags		= IRQF_TRIGGER_FALLING,
-	.config			= NULL,
-	.config_length		= 0,
 };
 
 static struct i2c_board_info __initdata atmel_1664s_device = {
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index 9f92135..b569bb8 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -27,10 +27,6 @@
 
 /* The platform data for the Atmel maXTouch touchscreen driver */
 struct mxt_platform_data {
-	const u8 *config;
-	size_t config_length;
-	u32 config_crc;
-
 	unsigned int x_size;
 	unsigned int y_size;
 	unsigned char orient;
-- 
1.7.10.4

