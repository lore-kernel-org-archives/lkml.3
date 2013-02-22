Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab3BVSOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:14:32 -0500
Received: from [89.21.227.133] ([89.21.227.133]:10930 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759039Ab3BVSIe (ORCPT
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
Subject: [PATCH 08/40] Input: atmel_mxt_ts - Download device config using firmware loader
Date: Fri, 22 Feb 2013 17:57:55 +0000
Message-Id: <1361555907-19840-9-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
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
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  207 +++++++++++++++++++++---------
 include/linux/i2c/atmel_mxt_ts.h         |    4 -
 2 files changed, 148 insertions(+), 63 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 6f30713..d015168 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -33,8 +33,10 @@
 #define MXT_BOOT_LOW		0x24
 #define MXT_BOOT_HIGH		0x25
 
-/* Firmware */
+/* Firmware files */
 #define MXT_FW_NAME		"maxtouch.fw"
+#define MXT_CFG_NAME		"maxtouch.cfg"
+#define MXT_CFG_MAGIC		"OBP_RAW V1"
 
 /* Registers */
 #define MXT_INFO		0x00
@@ -303,37 +305,6 @@ static bool mxt_object_readable(unsigned int type)
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
 static void mxt_dump_message(struct device *dev, struct mxt_message *message)
 {
 	dev_dbg(dev, "MXT MSG: %*ph\n",
@@ -704,58 +675,176 @@ static void mxt_read_current_crc(struct mxt_data *data)
 
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
 
 	mxt_read_current_crc(data);
 
-	if (data->config_crc == pdata->config_crc) {
-		dev_info(dev, "Config CRC 0x%06X: OK\n", data->config_crc);
-		return 0;
+	if (strncmp(cfg->data, MXT_CFG_MAGIC, strlen(MXT_CFG_MAGIC))) {
+		dev_err(dev, "Unrecognised config file\n");
+		ret = -EINVAL;
+		goto release;
+	}
+
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
+
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
 	} else {
-		dev_info(dev, "Config CRC 0x%06X: does not match 0x%06X\n",
-				data->config_crc, pdata->config_crc);
+		dev_info(dev, "Config CRC 0x%06X: does not match file 0x%06X\n",
+			 data->config_crc, config_crc);
 	}
 
-	for (i = 0; i < data->info.object_num; i++) {
-		object = data->object_table + i;
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
 
-		if (!mxt_object_writable(object->type))
-			continue;
+		object = mxt_get_object(data, type);
+		if (!object) {
+			ret = -EINVAL;
+			goto release;
+		}
 
-		size = OBP_SIZE(object) * OBP_INSTANCES(object);
-		if (index + size > pdata->config_length) {
-			dev_err(dev, "Not enough config data!\n");
-			return -EINVAL;
+		if (size > OBP_SIZE(object)) {
+			dev_err(dev, "Object length exceeded!\n");
+			ret = -EINVAL;
+			goto release;
 		}
 
-		ret = __mxt_write_reg(data->client, object->start_address,
-				size, &pdata->config[index]);
-		if (ret)
-			return ret;
-		index += size;
+		if (instance >= OBP_INSTANCES(object)) {
+			dev_err(dev, "Object instances exceeded!\n");
+			ret = -EINVAL;
+			goto release;
+		}
+
+		reg = object->start_address + OBP_SIZE(object) * instance;
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
+
+			ret = mxt_write_reg(data->client, reg + i, val);
+			if (ret)
+				goto release;
+
+			pos += offset;
+		}
+
+		/* If firmware is upgraded, new bytes may be added to end of
+		 * objects. It is generally forward compatible to zero these
+		 * bytes - previous behaviour will be retained. However
+		 * this does invalidate the CRC and will force a config
+		 * download every time until the configuration is updated */
+		if (size < OBP_SIZE(object)) {
+			dev_info(dev, "Warning: zeroing %d byte(s) in T%d\n",
+				 OBP_SIZE(object) - size, type);
+
+			for (i = size + 1; i < OBP_SIZE(object); i++) {
+				ret = mxt_write_reg(data->client, reg + i, 0);
+				if (ret)
+					goto release;
+			}
+		}
 	}
 
 	ret = mxt_t6_command(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE, false);
 	if (ret)
-		return ret;
+		goto release;
 
 	ret = mxt_soft_reset(data, MXT_RESET_VALUE);
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
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index 1d5a664..1ebb8fd 100644
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

