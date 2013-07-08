Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab3GHPVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:21:25 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:33877 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3GHPVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:21:23 -0400
From: Balint Czobor <czoborbalint@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Balint Czobor <czoborbalint@gmail.com>
Subject: [PATCH 1/1] drivers: input: touchscreen: Initial support for ATMEL_MXTS touchscreen
Date: Mon,  8 Jul 2013 17:21:06 +0200
Message-Id: <1373296866-2826-1-git-send-email-czoborbalint@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial support for Atmel mXT S series I2C touchscreen.

Signed-off-by: Balint Czobor <czoborbalint@gmail.com>
---
 drivers/input/touchscreen/Kconfig    |   12 +
 drivers/input/touchscreen/Makefile   |    1 +
 drivers/input/touchscreen/mxts.c     | 2174 ++++++++++++++++++++++++++++++++++
 drivers/input/touchscreen/mxts_sec.c | 1775 +++++++++++++++++++++++++++
 include/linux/i2c/mxts.h             |  579 +++++++++
 5 files changed, 4541 insertions(+)
 create mode 100644 drivers/input/touchscreen/mxts.c
 create mode 100644 drivers/input/touchscreen/mxts_sec.c
 create mode 100644 include/linux/i2c/mxts.h

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3b9758b..4ceb58e 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -98,6 +98,18 @@ config TOUCHSCREEN_ATMEL_MXT
 	  To compile this driver as a module, choose M here: the
 	  module will be called atmel_mxt_ts.
 
+config TOUCHSCREEN_ATMEL_MXTS
+	tristate "Atmel mXTS I2C Touchscreen"
+	depends on I2C
+	help
+	  Say Y here if you have Atmel mXT S series I2C touchscreen
+	  connected to your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mxts.
+
 config TOUCHSCREEN_AUO_PIXCIR
 	tristate "AUO in-cell touchscreen using Pixcir ICs"
 	depends on I2C
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index f5216c1..156a109 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_TOUCHSCREEN_AD7879_I2C)	+= ad7879-i2c.o
 obj-$(CONFIG_TOUCHSCREEN_AD7879_SPI)	+= ad7879-spi.o
 obj-$(CONFIG_TOUCHSCREEN_ADS7846)	+= ads7846.o
 obj-$(CONFIG_TOUCHSCREEN_ATMEL_MXT)	+= atmel_mxt_ts.o
+obj-$(CONFIG_TOUCHSCREEN_ATMEL_MXTS)	+= mxts.o
 obj-$(CONFIG_TOUCHSCREEN_ATMEL_TSADCC)	+= atmel_tsadcc.o
 obj-$(CONFIG_TOUCHSCREEN_AUO_PIXCIR)	+= auo-pixcir-ts.o
 obj-$(CONFIG_TOUCHSCREEN_BU21013)	+= bu21013_ts.o
diff --git a/drivers/input/touchscreen/mxts.c b/drivers/input/touchscreen/mxts.c
new file mode 100644
index 0000000..112f1fe
--- /dev/null
+++ b/drivers/input/touchscreen/mxts.c
@@ -0,0 +1,2174 @@
+/*
+ *  Copyright (C) 2012, Samsung Electronics Co. Ltd. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/input/mt.h>
+#include <linux/interrupt.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/gpio.h>
+#include <linux/i2c/mxts.h>
+#include <asm/unaligned.h>
+#include <linux/firmware.h>
+#include <linux/string.h>
+#ifdef CONFIG_HAS_EARLYSUSPEND
+#include <linux/earlysuspend.h>
+#endif
+
+/*#define dev_dbg(dev, fmt, arg...) dev_info(dev, fmt, ##arg)*/
+
+/* TODO: touch_is_pressed
+ * As I know this global variable has been added to blocking touchkey input
+ * when touch is pressed. I think it is better to check this condition
+ * on upper layer not kernel driver in the feature.....
+ */
+int touch_is_pressed;
+
+static int mxt_read_mem(struct mxt_data *data, u16 reg, u8 len, void *buf)
+{
+	int ret = 0, i = 0;
+	u16 le_reg = cpu_to_le16(reg);
+	struct i2c_msg msg[2] = {
+		{
+			.addr = data->client->addr,
+			.flags = 0,
+			.len = 2,
+			.buf = (u8 *)&le_reg,
+		},
+		{
+			.addr = data->client->addr,
+			.flags = I2C_M_RD,
+			.len = len,
+			.buf = buf,
+		},
+	};
+
+#if TSP_USE_ATMELDBG
+	if (data->atmeldbg.block_access)
+		return 0;
+#endif
+
+	for (i = 0; i < 3 ; i++) {
+		ret = i2c_transfer(data->client->adapter, msg, 2);
+		if (ret < 0)
+			dev_err(&data->client->dev, "%s fail[%d] address[0x%x]\n",
+				__func__, ret, le_reg);
+		else
+			break;
+	}
+	return ret == 2 ? 0 : -EIO;
+}
+
+static int mxt_write_mem(struct mxt_data *data,
+		u16 reg, u8 len, const u8 *buf)
+{
+	int ret = 0, i = 0;
+	u8 tmp[len + 2];
+
+#if TSP_USE_ATMELDBG
+	if (data->atmeldbg.block_access)
+		return 0;
+#endif
+
+	put_unaligned_le16(cpu_to_le16(reg), tmp);
+	memcpy(tmp + 2, buf, len);
+
+	for (i = 0; i < 3 ; i++) {
+		ret = i2c_master_send(data->client, tmp, sizeof(tmp));
+		if (ret < 0)
+			dev_err(&data->client->dev,	"%s %d times write error on address[0x%x,0x%x]\n",
+				__func__, i, tmp[1], tmp[0]);
+		else
+			break;
+	}
+
+	return ret == sizeof(tmp) ? 0 : -EIO;
+}
+
+static struct mxt_object *
+	mxt_get_object(struct mxt_data *data, u8 type)
+{
+	struct mxt_object *object;
+	int i;
+
+	if (!data->objects)
+		return NULL;
+
+	for (i = 0; i < data->info.object_num; i++) {
+		object = data->objects + i;
+		if (object->type == type)
+			return object;
+	}
+
+	dev_err(&data->client->dev, "Invalid object type T%d\n",
+		type);
+
+	return NULL;
+}
+
+static int mxt_read_message(struct mxt_data *data,
+				 struct mxt_message *message)
+{
+	struct mxt_object *object;
+
+	object = mxt_get_object(data, MXT_GEN_MESSAGEPROCESSOR_T5);
+	if (!object)
+		return -EINVAL;
+
+	return mxt_read_mem(data, object->start_address,
+			sizeof(struct mxt_message), message);
+}
+
+static int mxt_read_message_reportid(struct mxt_data *data,
+	struct mxt_message *message, u8 reportid)
+{
+	int try = 0;
+	int error;
+	int fail_count;
+
+	fail_count = data->max_reportid * 2;
+
+	while (++try < fail_count) {
+		error = mxt_read_message(data, message);
+		if (error)
+			return error;
+
+		if (message->reportid == 0xff)
+			continue;
+
+		if (message->reportid == reportid)
+			return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int mxt_read_object(struct mxt_data *data,
+				u8 type, u8 offset, u8 *val)
+{
+	struct mxt_object *object;
+	int error = 0;
+
+	object = mxt_get_object(data, type);
+	if (!object)
+		return -EINVAL;
+
+	error = mxt_read_mem(data, object->start_address + offset, 1, val);
+	if (error)
+		dev_err(&data->client->dev, "Error to read T[%d] offset[%d] val[%d]\n",
+			type, offset, *val);
+	return error;
+}
+
+static int mxt_write_object(struct mxt_data *data,
+				 u8 type, u8 offset, u8 val)
+{
+	struct mxt_object *object;
+	int error = 0;
+	u16 reg;
+
+	object = mxt_get_object(data, type);
+	if (!object)
+		return -EINVAL;
+
+	if (offset >= object->size * object->instances) {
+		dev_err(&data->client->dev, "Tried to write outside object T%d offset:%d, size:%d\n",
+			type, offset, object->size);
+		return -EINVAL;
+	}
+	reg = object->start_address;
+	error = mxt_write_mem(data, reg + offset, 1, &val);
+	if (error)
+		dev_err(&data->client->dev, "Error to write T[%d] offset[%d] val[%d]\n",
+			type, offset, val);
+
+	return error;
+}
+
+static u32 mxt_make_crc24(u32 crc, u8 byte1, u8 byte2)
+{
+	static const u32 crcpoly = 0x80001B;
+	u32 res;
+	u16 data_word;
+
+	data_word = (((u16)byte2) << 8) | byte1;
+	res = (crc << 1) ^ (u32)data_word;
+
+	if (res & 0x1000000)
+		res ^= crcpoly;
+
+	return res;
+}
+
+static int mxt_calculate_infoblock_crc(struct mxt_data *data,
+		u32 *crc_pointer)
+{
+	u32 crc = 0;
+	u8 mem[7 + data->info.object_num * 6];
+	int ret;
+	int i;
+
+	ret = mxt_read_mem(data, 0, sizeof(mem), mem);
+
+	if (ret)
+		return ret;
+
+	for (i = 0; i < sizeof(mem) - 1; i += 2)
+		crc = mxt_make_crc24(crc, mem[i], mem[i + 1]);
+
+	*crc_pointer = mxt_make_crc24(crc, mem[i], 0) & 0x00FFFFFF;
+
+	return 0;
+}
+
+static int mxt_read_info_crc(struct mxt_data *data, u32 *crc_pointer)
+{
+	u16 crc_address;
+	u8 msg[3];
+	int ret;
+
+	/* Read Info block CRC address */
+	crc_address = MXT_OBJECT_TABLE_START_ADDRESS +
+			data->info.object_num * MXT_OBJECT_TABLE_ELEMENT_SIZE;
+
+	ret = mxt_read_mem(data, crc_address, 3, msg);
+	if (ret)
+		return ret;
+
+	*crc_pointer = msg[0] | (msg[1] << 8) | (msg[2] << 16);
+
+	return 0;
+}
+static int mxt_read_config_crc(struct mxt_data *data, u32 *crc)
+{
+	struct device *dev = &data->client->dev;
+	struct mxt_message message;
+	struct mxt_object *object;
+	int error;
+
+	object = mxt_get_object(data, MXT_GEN_COMMANDPROCESSOR_T6);
+	if (!object)
+		return -EIO;
+
+	/* Try to read the config checksum of the existing cfg */
+	mxt_write_object(data, MXT_GEN_COMMANDPROCESSOR_T6,
+		MXT_COMMAND_REPORTALL, 1);
+
+	/* Read message from command processor, which only has one report ID */
+	error = mxt_read_message_reportid(data, &message, object->max_reportid);
+	if (error) {
+		dev_err(dev, "Failed to retrieve CRC\n");
+		return error;
+	}
+
+	/* Bytes 1-3 are the checksum. */
+	*crc = message.message[1] | (message.message[2] << 8) |
+		(message.message[3] << 16);
+
+	return 0;
+}
+
+static int mxt_check_instance(struct mxt_data *data, u8 type)
+{
+	int i;
+
+	for (i = 0; i < data->info.object_num; i++) {
+		if (data->objects[i].type == type)
+			return data->objects[i].instances;
+	}
+	return 0;
+}
+
+static int mxt_init_write_config(struct mxt_data *data,
+		u8 type, const u8 *cfg)
+{
+	struct mxt_object *object;
+	u8 *temp;
+	int ret;
+
+	object = mxt_get_object(data, type);
+	if (!object)
+		return -EINVAL;
+
+	if ((object->size == 0) || (object->start_address == 0)) {
+		dev_err(&data->client->dev,	"%s error T%d\n",
+			 __func__, type);
+		return -ENODEV;
+	}
+
+	ret = mxt_write_mem(data, object->start_address,
+			object->size, cfg);
+	if (ret) {
+		dev_err(&data->client->dev,	"%s write error T%d address[0x%x]\n",
+			__func__, type, object->start_address);
+		return ret;
+	}
+
+	if (mxt_check_instance(data, type)) {
+		temp = kzalloc(object->size, GFP_KERNEL);
+
+		if (temp == NULL)
+			return -ENOMEM;
+
+		ret |= mxt_write_mem(data, object->start_address + object->size,
+			object->size, temp);
+		kfree(temp);
+	}
+
+	return ret;
+}
+
+static int mxt_write_config_from_pdata(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	u8 **tsp_config = (u8 **)data->pdata->config;
+	u8 i;
+	int ret;
+
+	if (!tsp_config) {
+		dev_info(dev, "No cfg data in pdata\n");
+		return 0;
+	}
+
+	for (i = 0; tsp_config[i][0] != MXT_RESERVED_T255; i++) {
+		ret = mxt_init_write_config(data, tsp_config[i][0],
+							tsp_config[i] + 1);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
+static int mxt_write_config(struct mxt_fw_info *fw_info)
+{
+	struct mxt_data *data = fw_info->data;
+	struct device *dev = &data->client->dev;
+	struct mxt_object *object;
+	struct mxt_cfg_data *cfg_data;
+	u32 current_crc;
+	u8 i, val = 0;
+	u16 reg, index;
+	int ret;
+
+	if (!fw_info->cfg_raw_data) {
+		dev_info(dev, "No cfg data in file\n");
+		ret = mxt_write_config_from_pdata(data);
+		return ret;
+	}
+
+	/* Get config CRC from device */
+	ret = mxt_read_config_crc(data, &current_crc);
+	if (ret)
+		return ret;
+
+	/* Check Version information */
+	if (fw_info->fw_ver != data->info.version) {
+		dev_err(dev, "Warning: version mismatch! %s\n", __func__);
+		return 0;
+	}
+	if (fw_info->build_ver != data->info.build) {
+		dev_err(dev, "Warning: build num mismatch! %s\n", __func__);
+		return 0;
+	}
+
+	/* Check config CRC */
+	if (current_crc == fw_info->cfg_crc) {
+		dev_info(dev, "Skip writing Config:[CRC 0x%06X]\n",
+			current_crc);
+		return 0;
+	}
+
+	dev_info(dev, "Writing Config:[CRC 0x%06X!=0x%06X]\n",
+		current_crc, fw_info->cfg_crc);
+
+	/* Write config info */
+	for (index = 0; index < fw_info->cfg_len;) {
+
+		if (index + sizeof(struct mxt_cfg_data) >= fw_info->cfg_len) {
+			dev_err(dev, "index(%d) of cfg_data exceeded total size(%d)!!\n",
+				index + sizeof(struct mxt_cfg_data),
+				fw_info->cfg_len);
+			return -EINVAL;
+		}
+
+		/* Get the info about each object */
+		cfg_data = (struct mxt_cfg_data *)
+					(&fw_info->cfg_raw_data[index]);
+
+		index += sizeof(struct mxt_cfg_data) + cfg_data->size;
+		if (index > fw_info->cfg_len) {
+			dev_err(dev, "index(%d) of cfg_data exceeded total size(%d) in T%d object!!\n",
+				index, fw_info->cfg_len, cfg_data->type);
+			return -EINVAL;
+		}
+
+		object = mxt_get_object(data, cfg_data->type);
+		if (!object) {
+			dev_err(dev, "T%d is Invalid object type\n",
+				cfg_data->type);
+			return -EINVAL;
+		}
+
+		/* Check and compare the size, instance of each object */
+		if (cfg_data->size > object->size) {
+			dev_err(dev, "T%d Object length exceeded!\n",
+				cfg_data->type);
+			return -EINVAL;
+		}
+		if (cfg_data->instance >= object->instances) {
+			dev_err(dev, "T%d Object instances exceeded!\n",
+				cfg_data->type);
+			return -EINVAL;
+		}
+
+		dev_dbg(dev, "Writing config for obj %d len %d instance %d (%d/%d)\n",
+			cfg_data->type, object->size,
+			cfg_data->instance, index, fw_info->cfg_len);
+
+		reg = object->start_address + object->size * cfg_data->instance;
+
+		/* Write register values of each object */
+		ret = mxt_write_mem(data, reg, cfg_data->size,
+					 cfg_data->register_val);
+		if (ret) {
+			dev_err(dev, "Write T%d Object failed\n",
+				object->type);
+			return ret;
+		}
+
+		/*
+		 * If firmware is upgraded, new bytes may be added to end of
+		 * objects. It is generally forward compatible to zero these
+		 * bytes - previous behaviour will be retained. However
+		 * this does invalidate the CRC and will force a config
+		 * download every time until the configuration is updated.
+		 */
+		if (cfg_data->size < object->size) {
+			dev_err(dev, "Warning: zeroing %d byte(s) in T%d\n",
+				 object->size - cfg_data->size, cfg_data->type);
+
+			for (i = cfg_data->size + 1; i < object->size; i++) {
+				ret = mxt_write_mem(data, reg + i, 1, &val);
+				if (ret)
+					return ret;
+			}
+		}
+	}
+	dev_info(dev, "Updated configuration\n");
+
+	return ret;
+}
+
+/* TODO TEMP_ADONIS: need to inspect below functions */
+#if TSP_INFORM_CHARGER
+static int set_charger_config(struct mxt_data *data)
+{
+	dev_info(&data->client->dev, "Current state is %s",
+		data->charging_mode ? "Charging mode" : "Battery mode");
+
+/* if you need to change configuration depend on chager detection,
+ * please insert below line.
+ */
+
+	return 0;
+}
+
+static void inform_charger(struct mxt_callbacks *cb,
+	bool en)
+{
+	struct mxt_data *data = container_of(cb,
+			struct mxt_data, callbacks);
+
+	cancel_delayed_work_sync(&data->noti_dwork);
+	data->charging_mode = en;
+	schedule_delayed_work(&data->noti_dwork, HZ / 5);
+}
+
+static void charger_noti_dwork(struct work_struct *work)
+{
+	struct mxt_data *data =
+		container_of(work, struct mxt_data,
+		noti_dwork.work);
+
+	if (!data->mxt_enabled) {
+		schedule_delayed_work(&data->noti_dwork, HZ / 5);
+		return ;
+	}
+
+	dev_info(&data->client->dev, "%s mode\n",
+		data->charging_mode ? "charging" : "battery");
+
+	set_charger_config(data);
+}
+
+static void inform_charger_init(struct mxt_data *data)
+{
+	INIT_DELAYED_WORK(&data->noti_dwork, charger_noti_dwork);
+}
+#endif
+
+#ifdef TSP_BOOSTER
+static void mxt_set_dvfs_off(struct work_struct *work)
+{
+	struct mxt_data *data =
+		container_of(work, struct mxt_data, work_dvfs_off.work);
+
+	mutex_lock(&data->dvfs_lock);
+	set_freq_limit(DVFS_TOUCH_ID, -1);
+	data->dvfs_lock_status = false;
+	mutex_unlock(&data->dvfs_lock);
+
+	pr_info("[TSP] DVFS Off!\n");
+}
+
+static void mxt_set_dvfs_lock(struct mxt_data *data, uint32_t on)
+{
+	int ret = 0;
+
+	mutex_lock(&data->dvfs_lock);
+	if (on == 0) {
+		if (data->dvfs_lock_status) {
+			schedule_delayed_work(&data->work_dvfs_off,
+				msecs_to_jiffies(TOUCH_BOOSTER_OFF_TIME));
+		}
+	} else if (on == 1) {
+		cancel_delayed_work(&data->work_dvfs_off);
+		if (!data->dvfs_lock_status) {
+			ret = set_freq_limit(DVFS_TOUCH_ID, MIN_TOUCH_LIMIT);
+
+			if (ret < 0)
+				pr_err("%s: cpu lock failed(%d)\n",\
+							__func__, ret);
+
+			data->dvfs_lock_status = true;
+			pr_info("[TSP] DVFS On!\n");
+		}
+	} else if (on == 2) {
+		cancel_delayed_work(&data->work_dvfs_off);
+		schedule_work(&data->work_dvfs_off.work);
+	}
+	mutex_unlock(&data->dvfs_lock);
+}
+
+#endif /* - TOUCH_BOOSTER */
+
+static void mxt_report_input_data(struct mxt_data *data)
+{
+	int i;
+	int count = 0;
+	int report_count = 0;
+
+	for (i = 0; i < MXT_MAX_FINGER; i++) {
+		if (data->fingers[i].state == MXT_STATE_INACTIVE)
+			continue;
+
+		input_mt_slot(data->input_dev, i);
+		if (data->fingers[i].state == MXT_STATE_RELEASE) {
+			input_mt_report_slot_state(data->input_dev,
+					MT_TOOL_FINGER, false);
+		} else {
+			input_mt_report_slot_state(data->input_dev,
+					MT_TOOL_FINGER, true);
+			input_report_abs(data->input_dev, ABS_MT_POSITION_X,
+					data->fingers[i].x);
+			input_report_abs(data->input_dev, ABS_MT_POSITION_Y,
+					data->fingers[i].y);
+			input_report_abs(data->input_dev, ABS_MT_TOUCH_MAJOR,
+					data->fingers[i].w);
+			input_report_abs(data->input_dev, ABS_MT_PRESSURE,
+					 data->fingers[i].z);
+#if TSP_USE_SHAPETOUCH
+			/* Currently revision G firmware do not support it */
+			if (data->pdata->revision == MXT_REVISION_I) {
+				input_report_abs(data->input_dev,
+					ABS_MT_COMPONENT,
+					data->fingers[i].component);
+				input_report_abs(data->input_dev,
+					ABS_MT_SUMSIZE, data->sumsize);
+			}
+#endif
+			input_report_key(data->input_dev,
+				BTN_TOOL_FINGER, 1);
+
+			if (data->fingers[i].type
+				 == MXT_T100_TYPE_HOVERING_FINGER)
+				/* hover is reported */
+				input_report_key(data->input_dev,
+					BTN_TOUCH, 0);
+			else
+				/* finger or passive stylus are reported */
+				input_report_key(data->input_dev,
+					BTN_TOUCH, 1);
+		}
+		report_count++;
+
+#if !defined(CONFIG_SAMSUNG_PRODUCT_SHIP)
+		if (data->fingers[i].state == MXT_STATE_PRESS)
+			dev_info(&data->client->dev, "[P][%d]: T[%d][%d] X[%d],Y[%d]\n",
+				i, data->fingers[i].type,
+				data->fingers[i].event,
+				data->fingers[i].x, data->fingers[i].y);
+#else
+		if (data->fingers[i].state == MXT_STATE_PRESS)
+			dev_info(&data->client->dev, "[P][%d]: T[%d][%d]\n",
+				i, data->fingers[i].type,
+				data->fingers[i].event);
+#endif
+		else if (data->fingers[i].state == MXT_STATE_RELEASE)
+			dev_info(&data->client->dev, "[R][%d]: T[%d][%d] M[%d]\n",
+				i, data->fingers[i].type,
+				data->fingers[i].event,
+				data->fingers[i].mcount);
+
+
+		if (data->fingers[i].state == MXT_STATE_RELEASE) {
+			data->fingers[i].state = MXT_STATE_INACTIVE;
+			data->fingers[i].mcount = 0;
+		} else {
+			data->fingers[i].state = MXT_STATE_MOVE;
+			count++;
+		}
+	}
+
+	if (count == 0) {
+		input_report_key(data->input_dev, BTN_TOUCH, 0);
+		input_report_key(data->input_dev, BTN_TOOL_FINGER, 0);
+	}
+
+	if (report_count > 0) {
+#if TSP_USE_ATMELDBG
+		if (!data->atmeldbg.stop_sync)
+#endif
+			input_sync(data->input_dev);
+	}
+
+#if (TSP_USE_SHAPETOUCH || TSP_BOOSTER)
+	/* all fingers are released */
+	if (count == 0) {
+#if TSP_USE_SHAPETOUCH
+		data->sumsize = 0;
+#endif
+
+	}
+#endif
+	if (count)
+		touch_is_pressed = 1;
+	else
+		touch_is_pressed = 0;
+
+	data->finger_mask = 0;
+
+
+#ifdef TSP_BOOSTER
+	mxt_set_dvfs_lock(data, !!touch_is_pressed);
+#endif
+
+}
+
+static void mxt_release_all_finger(struct mxt_data *data)
+{
+	int i;
+	int count = 0;
+
+	for (i = 0; i < MXT_MAX_FINGER; i++) {
+		if (data->fingers[i].state == MXT_STATE_INACTIVE)
+			continue;
+		data->fingers[i].z = 0;
+		data->fingers[i].state = MXT_STATE_RELEASE;
+		count++;
+	}
+	if (count) {
+		dev_err(&data->client->dev, "%s\n", __func__);
+		mxt_report_input_data(data);
+	}
+
+	touch_is_pressed = 0;
+}
+
+#if TSP_HOVER_WORKAROUND
+static void mxt_current_calibration(struct mxt_data *data)
+{
+	dev_info(&data->client->dev, "%s\n", __func__);
+
+	mxt_write_object(data, MXT_SPT_SELFCAPHOVERCTECONFIG_T102, 1, 1);
+}
+#endif
+
+static void mxt_treat_T6_object(struct mxt_data *data,
+		struct mxt_message *message)
+{
+	/* Normal mode */
+	if (message->message[0] == 0x00) {
+		dev_info(&data->client->dev, "Normal mode\n");
+#if TSP_HOVER_WORKAROUND
+/* TODO HOVER : Below commands should be removed.
+*/
+		if (data->pdata->revision == MXT_REVISION_I
+			&& data->cur_cal_status) {
+			mxt_current_calibration(data);
+			data->cur_cal_status = false;
+		}
+#endif
+	}
+	/* I2C checksum error */
+	if (message->message[0] & 0x04)
+		dev_err(&data->client->dev, "I2C checksum error\n");
+	/* Config error */
+	if (message->message[0] & 0x08)
+		dev_err(&data->client->dev, "Config error\n");
+	/* Calibration */
+	if (message->message[0] & 0x10)
+		dev_info(&data->client->dev, "Calibration is on going !!\n");
+	/* Signal error */
+	if (message->message[0] & 0x20)
+		dev_err(&data->client->dev, "Signal error\n");
+	/* Overflow */
+	if (message->message[0] & 0x40)
+		dev_err(&data->client->dev, "Overflow detected\n");
+	/* Reset */
+	if (message->message[0] & 0x80) {
+		dev_info(&data->client->dev, "Reset is ongoing\n");
+#if TSP_INFORM_CHARGER
+		if (data->charging_mode)
+			set_charger_config(data);
+#endif
+#if TSP_HOVER_WORKAROUND
+/* TODO HOVER : Below commands should be removed.
+ * it added just for hover. Current firmware shoud set the acqusition mode
+ * with free-run and run current calibration after receive reset command
+ * to support hover functionality.
+ * it is bug of firmware. and it will be fixed in firmware level.
+ */
+		if (data->pdata->revision == MXT_REVISION_I) {
+			int error = 0;
+			u8 value = 0;
+
+			error = mxt_read_object(data,
+				MXT_SPT_TOUCHSCREENHOVER_T101, 0, &value);
+
+			if (error) {
+				dev_err(&data->client->dev, "Error read hover enable status[%d]\n"
+					, error);
+			} else {
+				if (value)
+					data->cur_cal_status = true;
+			}
+		}
+#endif
+	}
+}
+
+static void mxt_treat_T9_object(struct mxt_data *data,
+		struct mxt_message *message)
+{
+	int id;
+	u8 *msg = message->message;
+
+	id = data->reportids[message->reportid].index;
+
+	/* If not a touch event, return */
+	if (id >= MXT_MAX_FINGER) {
+		dev_err(&data->client->dev, "MAX_FINGER exceeded!\n");
+		return;
+	}
+	if (msg[0] & MXT_RELEASE_MSG_MASK) {
+		data->fingers[id].z = 0;
+		data->fingers[id].w = msg[4];
+		data->fingers[id].state = MXT_STATE_RELEASE;
+		mxt_report_input_data(data);
+	} else if ((msg[0] & MXT_DETECT_MSG_MASK)
+		&& (msg[0] & (MXT_PRESS_MSG_MASK | MXT_MOVE_MSG_MASK))) {
+		data->fingers[id].x = (msg[1] << 4) | (msg[3] >> 4);
+		data->fingers[id].y = (msg[2] << 4) | (msg[3] & 0xF);
+		data->fingers[id].w = msg[4];
+		data->fingers[id].z = msg[5];
+#if TSP_USE_SHAPETOUCH
+		data->fingers[id].component = msg[6];
+#endif
+
+		if (data->pdata->max_x < 1024)
+			data->fingers[id].x = data->fingers[id].x >> 2;
+		if (data->pdata->max_y < 1024)
+			data->fingers[id].y = data->fingers[id].y >> 2;
+
+		data->finger_mask |= 1U << id;
+
+		if (msg[0] & MXT_PRESS_MSG_MASK) {
+			data->fingers[id].state = MXT_STATE_PRESS;
+			data->fingers[id].mcount = 0;
+		} else if (msg[0] & MXT_MOVE_MSG_MASK) {
+			data->fingers[id].mcount += 1;
+		}
+
+#ifdef TSP_BOOSTER
+	/*	mxt_set_dvfs_on(data, true);*/
+#endif
+	} else if ((msg[0] & MXT_SUPPRESS_MSG_MASK)
+		&& (data->fingers[id].state != MXT_STATE_INACTIVE)) {
+		data->fingers[id].z = 0;
+		data->fingers[id].w = msg[4];
+		data->fingers[id].state = MXT_STATE_RELEASE;
+		data->finger_mask |= 1U << id;
+	} else {
+		/* ignore changed amplitude and vector messsage */
+		if (!((msg[0] & MXT_DETECT_MSG_MASK)
+				&& (msg[0] & MXT_AMPLITUDE_MSG_MASK
+				 || msg[0] & MXT_VECTOR_MSG_MASK)))
+			dev_err(&data->client->dev, "Unknown state %#02x %#02x\n",
+				msg[0], msg[1]);
+	}
+}
+
+static void mxt_treat_T42_object(struct mxt_data *data,
+		struct mxt_message *message)
+{
+	if (message->message[0] & 0x01) {
+		/* Palm Press */
+		touch_is_pressed = 1;
+		dev_info(&data->client->dev, "palm touch detected\n");
+	} else {
+		/* Palm release */
+		touch_is_pressed = 0;
+		dev_info(&data->client->dev, "palm touch released\n");
+	}
+}
+
+static void mxt_treat_T57_object(struct mxt_data *data,
+		struct mxt_message *message)
+{
+#if TSP_USE_SHAPETOUCH
+	data->sumsize = message->message[0] + (message->message[1] << 8);
+#endif	/* TSP_USE_SHAPETOUCH */
+
+}
+
+static void mxt_treat_T100_object(struct mxt_data *data,
+		struct mxt_message *message)
+{
+	u8 id, index;
+	u8 *msg = message->message;
+	u8 touch_type = 0, touch_event = 0, touch_detect = 0;
+
+	index = data->reportids[message->reportid].index;
+
+	/* Treate screen messages */
+	if (index < MXT_T100_SCREEN_MESSAGE_NUM_RPT_ID) {
+		if (index == MXT_T100_SCREEN_MSG_FIRST_RPT_ID)
+			/* TODO: Need to be implemeted after fixed protocol
+			 * This messages will indicate TCHAREA, ATCHAREA
+			 */
+			dev_dbg(&data->client->dev, "SCRSTATUS:[%02X] %02X %04X %04X %04X\n",
+				 msg[0], msg[1], (msg[3] << 8) | msg[2],
+				 (msg[5] << 8) | msg[4],
+				 (msg[7] << 8) | msg[6]);
+#if TSP_USE_SHAPETOUCH
+			data->sumsize = (msg[3] << 8) | msg[2];
+#endif	/* TSP_USE_SHAPETOUCH */
+		return;
+	}
+
+	/* Treate touch status messages */
+	id = index - MXT_T100_SCREEN_MESSAGE_NUM_RPT_ID;
+	touch_detect = msg[0] >> MXT_T100_DETECT_MSG_MASK;
+	touch_type = (msg[0] & 0x70) >> 4;
+	touch_event = msg[0] & 0x0F;
+
+	dev_dbg(&data->client->dev, "TCHSTATUS [%d] : DETECT[%d] TYPE[%d] EVENT[%d] %d,%d,%d,%d,%d\n",
+		id, touch_detect, touch_type, touch_event,
+		msg[1] | (msg[2] << 8),	msg[3] | (msg[4] << 8),
+		msg[5], msg[6], msg[7]);
+
+	switch (touch_type)	{
+	case MXT_T100_TYPE_FINGER:
+	case MXT_T100_TYPE_PASSIVE_STYLUS:
+	case MXT_T100_TYPE_HOVERING_FINGER:
+		/* There are no touch on the screen */
+		if (!touch_detect) {
+			if (touch_event == MXT_T100_EVENT_UP
+				|| touch_event == MXT_T100_EVENT_SUPPESS) {
+
+				data->fingers[id].w = 0;
+				data->fingers[id].z = 0;
+				data->fingers[id].state = MXT_STATE_RELEASE;
+				data->fingers[id].type = touch_type;
+				data->fingers[id].event = touch_event;
+
+				mxt_report_input_data(data);
+			} else {
+				dev_err(&data->client->dev, "Untreated Undetectd touch : type[%d], event[%d]\n",
+					touch_type, touch_event);
+			}
+			break;
+		}
+
+		/* There are touch on the screen */
+		if (touch_event == MXT_T100_EVENT_DOWN
+			|| touch_event == MXT_T100_EVENT_UNSUPPRESS
+			|| touch_event == MXT_T100_EVENT_MOVE
+			|| touch_event == MXT_T100_EVENT_NONE) {
+
+			data->fingers[id].x = msg[1] | (msg[2] << 8);
+			data->fingers[id].y = msg[3] | (msg[4] << 8);
+
+			/* AUXDATA[n]'s order is depended on which values are
+			 * enabled or not.
+			 */
+#if TSP_USE_SHAPETOUCH
+			data->fingers[id].component = msg[5];
+#endif
+			data->fingers[id].z = msg[6];
+			data->fingers[id].w = msg[7];
+
+			if (touch_type == MXT_T100_TYPE_HOVERING_FINGER) {
+				data->fingers[id].w = 0;
+				data->fingers[id].z = 0;
+			}
+
+			if (touch_event == MXT_T100_EVENT_DOWN
+				|| touch_event == MXT_T100_EVENT_UNSUPPRESS) {
+				data->fingers[id].state = MXT_STATE_PRESS;
+				data->fingers[id].mcount = 0;
+			} else {
+				data->fingers[id].state = MXT_STATE_MOVE;
+				data->fingers[id].mcount += 1;
+			}
+			data->fingers[id].type = touch_type;
+			data->fingers[id].event = touch_event;
+
+			mxt_report_input_data(data);
+		} else {
+			dev_err(&data->client->dev, "Untreated Detectd touch : type[%d], event[%d]\n",
+				touch_type, touch_event);
+		}
+		break;
+	case MXT_T100_TYPE_ACTIVE_STYLUS:
+		break;
+	}
+}
+
+static irqreturn_t mxt_irq_thread(int irq, void *ptr)
+{
+	struct mxt_data *data = ptr;
+	struct mxt_message message;
+	struct device *dev = &data->client->dev;
+	u8 reportid, type;
+
+	do {
+		if (mxt_read_message(data, &message)) {
+			dev_err(dev, "Failed to read message\n");
+			goto end;
+		}
+
+#if TSP_USE_ATMELDBG
+		if (data->atmeldbg.display_log) {
+			print_hex_dump(KERN_INFO, "MXT MSG:",
+				DUMP_PREFIX_NONE, 16, 1,
+				&message,
+				sizeof(struct mxt_message), false);
+		}
+#endif
+		reportid = message.reportid;
+
+		if (reportid > data->max_reportid)
+			goto end;
+
+		type = data->reportids[reportid].type;
+
+		switch (type) {
+		case MXT_RESERVED_T0:
+			goto end;
+			break;
+		case MXT_GEN_COMMANDPROCESSOR_T6:
+			mxt_treat_T6_object(data, &message);
+			break;
+		case MXT_TOUCH_MULTITOUCHSCREEN_T9:
+			mxt_treat_T9_object(data, &message);
+			break;
+		case MXT_SPT_SELFTEST_T25:
+			dev_err(dev, "Self test fail [0x%x 0x%x 0x%x 0x%x]\n",
+				message.message[0], message.message[1],
+				message.message[2], message.message[3]);
+			break;
+		case MXT_PROCI_TOUCHSUPPRESSION_T42:
+			mxt_treat_T42_object(data, &message);
+			break;
+		case MXT_PROCI_EXTRATOUCHSCREENDATA_T57:
+			mxt_treat_T57_object(data, &message);
+			break;
+		case MXT_PROCG_NOISESUPPRESSION_T62:
+			break;
+		case MXT_TOUCH_MULTITOUCHSCREEN_T100:
+			mxt_treat_T100_object(data, &message);
+			break;
+
+		default:
+			dev_dbg(dev, "Untreated Object type[%d]\tmessage[0x%x 0x%x 0x%x 0x%x 0x%x 0x%x 0x%x]\n",
+				type, message.message[0],
+				message.message[1], message.message[2],
+				message.message[3], message.message[4],
+				message.message[5], message.message[6]);
+			break;
+		}
+	} while (!data->pdata->read_chg());
+
+	if (data->finger_mask)
+		mxt_report_input_data(data);
+end:
+	return IRQ_HANDLED;
+}
+
+static int mxt_get_bootloader_version(struct i2c_client *client, u8 val)
+{
+	u8 buf[3];
+
+	if (val & MXT_BOOT_EXTENDED_ID) {
+		if (i2c_master_recv(client, buf, sizeof(buf)) != sizeof(buf)) {
+			dev_err(&client->dev, "%s: i2c recv failed\n",
+				 __func__);
+			return -EIO;
+		}
+		dev_info(&client->dev, "Bootloader ID:%d Version:%d",
+			 buf[1], buf[2]);
+	} else {
+		dev_info(&client->dev, "Bootloader ID:%d",
+			 val & MXT_BOOT_ID_MASK);
+	}
+	return 0;
+}
+
+static int mxt_check_bootloader(struct i2c_client *client,
+				     unsigned int state)
+{
+	u8 val;
+
+recheck:
+	if (i2c_master_recv(client, &val, 1) != 1) {
+		dev_err(&client->dev, "%s: i2c recv failed\n", __func__);
+		return -EIO;
+	}
+
+	switch (state) {
+	case MXT_WAITING_BOOTLOAD_CMD:
+		if (mxt_get_bootloader_version(client, val))
+			return -EIO;
+		val &= ~MXT_BOOT_STATUS_MASK;
+		break;
+	case MXT_WAITING_FRAME_DATA:
+	case MXT_APP_CRC_FAIL:
+		val &= ~MXT_BOOT_STATUS_MASK;
+		break;
+	case MXT_FRAME_CRC_PASS:
+		if (val == MXT_FRAME_CRC_CHECK)
+			goto recheck;
+		if (val == MXT_FRAME_CRC_FAIL) {
+			dev_err(&client->dev, "Bootloader CRC fail\n");
+			return -EINVAL;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (val != state) {
+		dev_err(&client->dev,
+			 "Invalid bootloader mode state 0x%X\n", val);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int mxt_unlock_bootloader(struct i2c_client *client)
+{
+	u8 buf[2] = {MXT_UNLOCK_CMD_LSB, MXT_UNLOCK_CMD_MSB};
+
+	if (i2c_master_send(client, buf, 2) != 2) {
+		dev_err(&client->dev, "%s: i2c send failed\n", __func__);
+
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int mxt_probe_bootloader(struct i2c_client *client)
+{
+	u8 val;
+
+	if (i2c_master_recv(client, &val, 1) != 1) {
+		dev_err(&client->dev, "%s: i2c recv failed\n", __func__);
+		return -EIO;
+	}
+
+	if (val & (~MXT_BOOT_STATUS_MASK)) {
+		if (val & MXT_APP_CRC_FAIL)
+			dev_err(&client->dev, "Application CRC failure\n");
+		else
+			dev_err(&client->dev, "Device in bootloader mode\n");
+	} else {
+		dev_err(&client->dev, "%s: Unknow status\n", __func__);
+		return -EIO;
+	}
+	return 0;
+}
+
+static int mxt_fw_write(struct i2c_client *client,
+				const u8 *frame_data, unsigned int frame_size)
+{
+	if (i2c_master_send(client, frame_data, frame_size) != frame_size) {
+		dev_err(&client->dev, "%s: i2c send failed\n", __func__);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+int mxt_verify_fw(struct mxt_fw_info *fw_info, const struct firmware *fw)
+{
+	struct mxt_data *data = fw_info->data;
+	struct device *dev = &data->client->dev;
+	struct mxt_fw_image *fw_img;
+
+	if (!fw) {
+		dev_err(dev, "could not find firmware file\n");
+		return -ENOENT;
+	}
+
+	fw_img = (struct mxt_fw_image *)fw->data;
+
+	if (le32_to_cpu(fw_img->magic_code) != MXT_FW_MAGIC) {
+		/* In case, firmware file only consist of firmware */
+		dev_dbg(dev, "Firmware file only consist of raw firmware\n");
+		fw_info->fw_len = fw->size;
+		fw_info->fw_raw_data = fw->data;
+	} else {
+		/*
+		 * In case, firmware file consist of header,
+		 * configuration, firmware.
+		 */
+		dev_info(dev, "Firmware file consist of header, configuration, firmware\n");
+		fw_info->fw_ver = fw_img->fw_ver;
+		fw_info->build_ver = fw_img->build_ver;
+		fw_info->hdr_len = le32_to_cpu(fw_img->hdr_len);
+		fw_info->cfg_len = le32_to_cpu(fw_img->cfg_len);
+		fw_info->fw_len = le32_to_cpu(fw_img->fw_len);
+		fw_info->cfg_crc = le32_to_cpu(fw_img->cfg_crc);
+
+		/* Check the firmware file with header */
+		if (fw_info->hdr_len != sizeof(struct mxt_fw_image)
+			|| fw_info->hdr_len + fw_info->cfg_len
+				+ fw_info->fw_len != fw->size) {
+			dev_err(dev, "Firmware file is invaild !!hdr size[%d] cfg,fw size[%d,%d] filesize[%d]\n",
+				fw_info->hdr_len, fw_info->cfg_len,
+				fw_info->fw_len, fw->size);
+			return -EINVAL;
+		}
+
+		if (!fw_info->cfg_len) {
+			dev_err(dev, "Firmware file dose not include configuration data\n");
+			return -EINVAL;
+		}
+		if (!fw_info->fw_len) {
+			dev_err(dev, "Firmware file dose not include raw firmware data\n");
+			return -EINVAL;
+		}
+
+		/* Get the address of configuration data */
+		fw_info->cfg_raw_data = fw_img->data;
+
+		/* Get the address of firmware data */
+		fw_info->fw_raw_data = fw_img->data + fw_info->cfg_len;
+
+#if TSP_SEC_FACTORY
+		data->fdata->fw_ver = fw_info->fw_ver;
+		data->fdata->build_ver = fw_info->build_ver;
+#endif
+	}
+
+	return 0;
+}
+
+static int mxt_wait_for_chg(struct mxt_data *data, u16 time)
+{
+	int timeout_counter = 0;
+
+	msleep(time);
+
+	if (data->pdata->read_chg) {
+		while (data->pdata->read_chg()
+			&& timeout_counter++ <= 20) {
+
+			msleep(MXT_RESET_INTEVAL_TIME);
+			dev_err(&data->client->dev, "Spend %d time waiting for chg_high\n",
+				(MXT_RESET_INTEVAL_TIME * timeout_counter)
+				 + time);
+		}
+	}
+
+	return 0;
+}
+
+static int mxt_command_reset(struct mxt_data *data, u8 value)
+{
+	int error;
+
+	mxt_write_object(data, MXT_GEN_COMMANDPROCESSOR_T6,
+			MXT_COMMAND_RESET, value);
+
+	error = mxt_wait_for_chg(data, MXT_SW_RESET_TIME);
+	if (error)
+		dev_err(&data->client->dev, "Not respond after reset command[%d]\n",
+			value);
+
+	return error;
+}
+
+static int mxt_command_backup(struct mxt_data *data, u8 value)
+{
+	mxt_write_object(data, MXT_GEN_COMMANDPROCESSOR_T6,
+			MXT_COMMAND_BACKUPNV, value);
+
+	msleep(MXT_BACKUP_TIME);
+
+	return 0;
+}
+
+static int mxt_flash_fw(struct mxt_fw_info *fw_info)
+{
+	struct mxt_data *data = fw_info->data;
+	struct i2c_client *client = data->client_boot;
+	struct device *dev = &data->client->dev;
+	const u8 *fw_data = fw_info->fw_raw_data;
+	size_t fw_size = fw_info->fw_len;
+	unsigned int frame_size;
+	unsigned int pos = 0;
+	int ret;
+
+	if (!fw_data) {
+		dev_err(dev, "firmware data is Null\n");
+		return -ENOMEM;
+	}
+
+	ret = mxt_check_bootloader(client, MXT_WAITING_BOOTLOAD_CMD);
+	if (ret) {
+		/*may still be unlocked from previous update attempt */
+		ret = mxt_check_bootloader(client, MXT_WAITING_FRAME_DATA);
+		if (ret)
+			goto out;
+	} else {
+		dev_info(dev, "Unlocking bootloader\n");
+		/* Unlock bootloader */
+		mxt_unlock_bootloader(client);
+	}
+	while (pos < fw_size) {
+		ret = mxt_check_bootloader(client,
+					MXT_WAITING_FRAME_DATA);
+		if (ret) {
+			dev_err(dev, "Fail updating firmware. wating_frame_data err\n");
+			goto out;
+		}
+
+		frame_size = ((*(fw_data + pos) << 8) | *(fw_data + pos + 1));
+
+		/*
+		* We should add 2 at frame size as the the firmware data is not
+		* included the CRC bytes.
+		*/
+
+		frame_size += 2;
+
+		/* Write one frame to device */
+		mxt_fw_write(client, fw_data + pos, frame_size);
+
+		ret = mxt_check_bootloader(client,
+						MXT_FRAME_CRC_PASS);
+		if (ret) {
+			dev_err(dev, "Fail updating firmware. frame_crc err\n");
+			goto out;
+		}
+
+		pos += frame_size;
+
+		dev_dbg(dev, "Updated %d bytes / %zd bytes\n",
+				pos, fw_size);
+
+		msleep(20);
+	}
+
+	ret = mxt_wait_for_chg(data, MXT_SW_RESET_TIME);
+	if (ret) {
+		dev_err(dev, "Not respond after F/W  finish reset\n");
+		goto out;
+	}
+
+	dev_info(dev, "success updating firmware\n");
+out:
+	return ret;
+}
+
+static void mxt_handle_init_data(struct mxt_data *data)
+{
+/*
+ * Caution : This function is called before backup NV. So If you write
+ * register vaules directly without config file in this function, it can
+ * be a cause of that configuration CRC mismatch or unintended values are
+ * stored in Non-volatile memory in IC. So I would recommed do not use
+ * this function except for bring up case. Please keep this in your mind.
+ */
+	return;
+}
+
+static int mxt_read_id_info(struct mxt_data *data)
+{
+	int ret = 0;
+	u8 id[MXT_INFOMATION_BLOCK_SIZE];
+
+	/* Read IC information */
+	ret = mxt_read_mem(data, 0, MXT_INFOMATION_BLOCK_SIZE, id);
+	if (ret) {
+		dev_err(&data->client->dev, "Read fail. IC information\n");
+		goto out;
+	} else {
+		dev_info(&data->client->dev,
+			"family: 0x%x variant: 0x%x version: 0x%x"
+			" build: 0x%x matrix X,Y size:  %d,%d"
+			" number of obect: %d\n"
+			, id[0], id[1], id[2], id[3], id[4], id[5], id[6]);
+		data->info.family_id = id[0];
+		data->info.variant_id = id[1];
+		data->info.version = id[2];
+		data->info.build = id[3];
+		data->info.matrix_xsize = id[4];
+		data->info.matrix_ysize = id[5];
+		data->info.object_num = id[6];
+	}
+
+out:
+	return ret;
+}
+
+static int mxt_get_object_table(struct mxt_data *data)
+{
+	int error;
+	int i;
+	u16 reg;
+	u8 reportid = 0;
+	u8 buf[MXT_OBJECT_TABLE_ELEMENT_SIZE];
+
+	for (i = 0; i < data->info.object_num; i++) {
+		struct mxt_object *object = data->objects + i;
+
+		reg = MXT_OBJECT_TABLE_START_ADDRESS +
+				MXT_OBJECT_TABLE_ELEMENT_SIZE * i;
+		error = mxt_read_mem(data, reg,
+				MXT_OBJECT_TABLE_ELEMENT_SIZE, buf);
+		if (error)
+			return error;
+
+		object->type = buf[0];
+		object->start_address = (buf[2] << 8) | buf[1];
+		/* the real size of object is buf[3]+1 */
+		object->size = buf[3] + 1;
+		/* the real instances of object is buf[4]+1 */
+		object->instances = buf[4] + 1;
+		object->num_report_ids = buf[5];
+
+		dev_dbg(&data->client->dev,
+			"Object:T%d\t\t\t Address:0x%x\tSize:%d\tInstance:%d\tReport Id's:%d\n",
+			object->type, object->start_address, object->size,
+			object->instances, object->num_report_ids);
+
+		if (object->num_report_ids) {
+			reportid += object->num_report_ids * object->instances;
+			object->max_reportid = reportid;
+		}
+	}
+
+	/* Store maximum reportid */
+	data->max_reportid = reportid;
+	dev_dbg(&data->client->dev, "maXTouch: %d report ID\n",
+			data->max_reportid);
+
+	return 0;
+}
+
+static void mxt_make_reportid_table(struct mxt_data *data)
+{
+	struct mxt_object *objects = data->objects;
+	struct mxt_reportid *reportids = data->reportids;
+	int i, j;
+	int id = 0;
+
+	for (i = 0; i < data->info.object_num; i++) {
+		for (j = 0; j < objects[i].num_report_ids *
+				objects[i].instances; j++) {
+			id++;
+
+			reportids[id].type = objects[i].type;
+			reportids[id].index = j;
+
+			dev_dbg(&data->client->dev, "Report_id[%d]:\tT%d\tIndex[%d]\n",
+				id, reportids[id].type, reportids[id].index);
+		}
+	}
+}
+
+static int mxt_initialize(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+
+	u32 read_info_crc, calc_info_crc;
+	int ret;
+
+	ret = mxt_read_id_info(data);
+	if (ret)
+		return ret;
+
+	data->objects = kcalloc(data->info.object_num,
+				sizeof(struct mxt_object),
+				GFP_KERNEL);
+	if (!data->objects) {
+		dev_err(&client->dev, "Failed to allocate memory\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Get object table infomation */
+	ret = mxt_get_object_table(data);
+	if (ret)
+		goto out;
+
+	data->reportids = kcalloc(data->max_reportid + 1,
+			sizeof(struct mxt_reportid),
+			GFP_KERNEL);
+	if (!data->reportids) {
+		dev_err(&client->dev, "Failed to allocate memory\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* Make report id table */
+	mxt_make_reportid_table(data);
+
+	/* Verify the info CRC */
+	ret = mxt_read_info_crc(data, &read_info_crc);
+	if (ret)
+		goto out;
+
+	ret = mxt_calculate_infoblock_crc(data, &calc_info_crc);
+	if (ret)
+		goto out;
+
+	if (read_info_crc != calc_info_crc) {
+		dev_err(&data->client->dev, "Infomation CRC error :[CRC 0x%06X!=0x%06X]\n",
+				read_info_crc, calc_info_crc);
+		ret = -EFAULT;
+		goto out;
+	}
+	return 0;
+
+out:
+	return ret;
+}
+
+static int  mxt_rest_initialize(struct mxt_fw_info *fw_info)
+{
+	struct mxt_data *data = fw_info->data;
+	struct device *dev = &data->client->dev;
+	int ret;
+
+	/* Restore memory and stop event handing */
+	ret = mxt_command_backup(data, MXT_DISALEEVT_VALUE);
+	if (ret) {
+		dev_err(dev, "Failed Restore NV and stop event\n");
+		goto out;
+	}
+
+	/* Write config */
+	ret = mxt_write_config(fw_info);
+	if (ret) {
+		dev_err(dev, "Failed to write config from file\n");
+		goto out;
+	}
+
+	/* Handle data for init */
+	mxt_handle_init_data(data);
+
+	/* Backup to memory */
+	ret = mxt_command_backup(data, MXT_BACKUP_VALUE);
+	if (ret) {
+		dev_err(dev, "Failed backup NV data\n");
+		goto out;
+	}
+
+	/* Soft reset */
+	ret = mxt_command_reset(data, MXT_RESET_VALUE);
+	if (ret) {
+		dev_err(dev, "Failed Reset IC\n");
+		goto out;
+	}
+out:
+	return ret;
+}
+
+static int mxt_power_on(struct mxt_data *data)
+{
+/*
+ * If do not turn off the power during suspend, you can use deep sleep
+ * or disable scan to use T7, T9 Object. But to turn on/off the power
+ * is better.
+ */
+	int error = 0;
+
+	if (data->mxt_enabled)
+		return 0;
+
+	if (!data->pdata->power_on) {
+		dev_warn(&data->client->dev, "Power on function is not defined\n");
+		error = -EINVAL;
+		goto out;
+	}
+
+	error = data->pdata->power_on();
+	if (error) {
+		dev_err(&data->client->dev, "Failed to power on\n");
+		goto out;
+	}
+
+	error = mxt_wait_for_chg(data, MXT_HW_RESET_TIME);
+	if (error)
+		dev_err(&data->client->dev, "Not respond after H/W reset\n");
+
+	data->mxt_enabled = true;
+
+out:
+	return error;
+}
+
+static int mxt_power_off(struct mxt_data *data)
+{
+	int error = 0;
+
+	if (!data->mxt_enabled)
+		return 0;
+
+	if (!data->pdata->power_off) {
+		dev_warn(&data->client->dev, "Power off function is not defined\n");
+		error = -EINVAL;
+		goto out;
+	}
+
+	error = data->pdata->power_off();
+	if (error) {
+		dev_err(&data->client->dev, "Failed to power off\n");
+		goto out;
+	}
+
+	data->mxt_enabled = false;
+
+out:
+	return error;
+}
+
+/* Need to be called by function that is blocked with mutex */
+static int mxt_start(struct mxt_data *data)
+{
+	int error = 0;
+
+	if (data->mxt_enabled) {
+		dev_err(&data->client->dev,
+			"%s. but touch already on\n", __func__);
+		return error;
+	}
+
+	error = mxt_power_on(data);
+	if (error)
+		dev_err(&data->client->dev, "Fail to start touch\n");
+	else
+		enable_irq(data->client->irq);
+
+	return error;
+}
+
+/* Need to be called by function that is blocked with mutex */
+static int mxt_stop(struct mxt_data *data)
+{
+	int error = 0;
+
+	if (!data->mxt_enabled) {
+		dev_err(&data->client->dev,
+			"%s. but touch already off\n", __func__);
+		return error;
+	}
+	disable_irq(data->client->irq);
+
+	error = mxt_power_off(data);
+	if (error) {
+		dev_err(&data->client->dev, "Fail to stop touch\n");
+		goto err_power_off;
+	}
+	mxt_release_all_finger(data);
+#ifdef TSP_BOOSTER
+	mxt_set_dvfs_lock(data, 2);
+	pr_info("[TSP] dvfs_lock free.\n");
+#endif
+	return 0;
+
+err_power_off:
+	enable_irq(data->client->irq);
+	return error;
+}
+
+static int mxt_input_open(struct input_dev *dev)
+{
+	struct mxt_data *data = input_get_drvdata(dev);
+	int ret;
+
+	ret = wait_for_completion_interruptible_timeout(&data->init_done,
+			msecs_to_jiffies(90 * MSEC_PER_SEC));
+
+	if (ret < 0) {
+		dev_err(&data->client->dev,
+			"error while waiting for device to init (%d)\n", ret);
+		ret = -ENXIO;
+		goto err_open;
+	}
+	if (ret == 0) {
+		dev_err(&data->client->dev,
+			"timedout while waiting for device to init\n");
+		ret = -ENXIO;
+		goto err_open;
+	}
+
+	ret = mxt_start(data);
+	if (ret)
+		goto err_open;
+
+	dev_dbg(&data->client->dev, "%s\n", __func__);
+
+	return 0;
+
+err_open:
+	return ret;
+}
+
+static void mxt_input_close(struct input_dev *dev)
+{
+	struct mxt_data *data = input_get_drvdata(dev);
+
+	mxt_stop(data);
+
+	dev_dbg(&data->client->dev, "%s\n", __func__);
+}
+
+static int mxt_make_highchg(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	struct mxt_message message;
+	int count = data->max_reportid * 2;
+	int error;
+
+	/* Read dummy message to make high CHG pin */
+	do {
+		error = mxt_read_message(data, &message);
+		if (error)
+			return error;
+	} while (message.reportid != 0xff && --count);
+
+	if (!count) {
+		dev_err(dev, "CHG pin isn't cleared\n");
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int mxt_touch_finish_init(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+	int error;
+
+	error = request_threaded_irq(client->irq, NULL, mxt_irq_thread,
+		data->pdata->irqflags, client->dev.driver->name, data);
+
+	if (error) {
+		dev_err(&client->dev, "Failed to register interrupt\n");
+		goto err_req_irq;
+	}
+
+	error = mxt_make_highchg(data);
+	if (error) {
+		dev_err(&client->dev, "Failed to clear CHG pin\n");
+		goto err_req_irq;
+	}
+
+	dev_info(&client->dev,  "Mxt touch controller initialized\n");
+
+	/*
+	* to prevent unnecessary report of touch event
+	* it will be enabled in open function
+	*/
+
+	mxt_stop(data);
+
+	/* for blocking to be excuted open function untile finishing ts init */
+	complete_all(&data->init_done);
+	return 0;
+
+err_req_irq:
+	return error;
+}
+
+static int mxt_touch_rest_init(struct mxt_fw_info *fw_info)
+{
+	struct mxt_data *data = fw_info->data;
+	struct device *dev = &data->client->dev;
+	int error;
+
+	error = mxt_initialize(data);
+	if (error) {
+		dev_err(dev, "Failed to initialize\n");
+		goto err_free_mem;
+	}
+
+	error = mxt_rest_initialize(fw_info);
+	if (error) {
+		dev_err(dev, "Failed to rest initialize\n");
+		goto err_free_mem;
+	}
+
+	error = mxt_touch_finish_init(data);
+	if (error)
+		goto err_free_mem;
+
+	return 0;
+
+err_free_mem:
+	kfree(data->objects);
+	data->objects = NULL;
+	kfree(data->reportids);
+	data->reportids = NULL;
+	return error;
+}
+
+static int mxt_enter_bootloader(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	int error;
+
+	data->objects = kcalloc(data->info.object_num,
+				     sizeof(struct mxt_object),
+				     GFP_KERNEL);
+	if (!data->objects) {
+		dev_err(dev, "%s Failed to allocate memory\n",
+			__func__);
+		error = -ENOMEM;
+		goto out;
+	}
+
+	/* Get object table information*/
+	error = mxt_get_object_table(data);
+	if (error)
+		goto err_free_mem;
+
+	/* Change to the bootloader mode */
+	error = mxt_command_reset(data, MXT_BOOT_VALUE);
+	if (error)
+		goto err_free_mem;
+
+err_free_mem:
+	kfree(data->objects);
+	data->objects = NULL;
+
+out:
+	return error;
+}
+
+static int mxt_flash_fw_on_probe(struct mxt_fw_info *fw_info)
+{
+	struct mxt_data *data = fw_info->data;
+	struct device *dev = &data->client->dev;
+	int error;
+
+	error = mxt_read_id_info(data);
+
+	if (error) {
+		/* need to check IC is in boot mode */
+		error = mxt_probe_bootloader(data->client_boot);
+		if (error) {
+			dev_err(dev, "Failed to verify bootloader's status\n");
+			goto out;
+		}
+
+		dev_info(dev, "Updating firmware from boot-mode\n");
+		goto load_fw;
+	}
+
+	/* compare the version to verify necessity of firmware updating */
+	if (data->info.version == fw_info->fw_ver
+			&& data->info.build == fw_info->build_ver) {
+		dev_dbg(dev, "Firmware version is same with in IC\n");
+		goto out;
+	}
+
+	dev_info(dev, "Updating firmware from app-mode : IC:0x%x,0x%x =! FW:0x%x,0x%x\n",
+			data->info.version, data->info.build,
+			fw_info->fw_ver, fw_info->build_ver);
+
+	error = mxt_enter_bootloader(data);
+	if (error) {
+		dev_err(dev, "Failed updating firmware\n");
+		goto out;
+	}
+
+load_fw:
+	error = mxt_flash_fw(fw_info);
+	if (error)
+		dev_err(dev, "Failed updating firmware\n");
+	else
+		dev_info(dev, "succeeded updating firmware\n");
+out:
+	return error;
+}
+
+static void mxt_request_firmware_work(const struct firmware *fw,
+		void *context)
+{
+	struct mxt_data *data = context;
+	struct mxt_fw_info fw_info;
+	int error;
+
+	memset(&fw_info, 0, sizeof(struct mxt_fw_info));
+	fw_info.data = data;
+
+	error = mxt_verify_fw(&fw_info, fw);
+	if (error)
+		goto ts_rest_init;
+
+	/* Skip update on boot up if firmware file does not have a header */
+	if (!fw_info.hdr_len)
+		goto ts_rest_init;
+
+	error = mxt_flash_fw_on_probe(&fw_info);
+	if (error)
+		goto out;
+
+ts_rest_init:
+	error = mxt_touch_rest_init(&fw_info);
+out:
+	if (error)
+		/* complete anyway, so open() doesn't get blocked */
+		complete_all(&data->init_done);
+
+	release_firmware(fw);
+}
+
+static int __devinit mxt_touch_init(struct mxt_data *data, bool nowait)
+{
+	struct i2c_client *client = data->client;
+	const char *firmware_name =
+		 data->pdata->firmware_name ?: MXT_DEFAULT_FIRMWARE_NAME;
+	int ret = 0;
+
+#if TSP_INFORM_CHARGER
+	/* Register callbacks */
+	/* To inform tsp , charger connection status*/
+	data->callbacks.inform_charger = inform_charger;
+	if (data->pdata->register_cb) {
+		data->pdata->register_cb(&data->callbacks);
+		inform_charger_init(data);
+	}
+#endif
+
+	if (nowait) {
+		const struct firmware *fw;
+		char fw_path[MXT_MAX_FW_PATH];
+
+		memset(&fw_path, 0, MXT_MAX_FW_PATH);
+
+		snprintf(fw_path, MXT_MAX_FW_PATH, "%s%s",
+			MXT_FIRMWARE_INKERNEL_PATH, firmware_name);
+
+		dev_err(&client->dev, "%s\n", fw_path);
+
+		ret = request_firmware(&fw, fw_path, &client->dev);
+		if (ret) {
+			dev_err(&client->dev,
+				"error requesting built-in firmware\n");
+			goto out;
+		}
+		mxt_request_firmware_work(fw, data);
+	} else {
+		ret = request_firmware_nowait(THIS_MODULE, true, firmware_name,
+				      &client->dev, GFP_KERNEL,
+				      data, mxt_request_firmware_work);
+		if (ret)
+			dev_err(&client->dev,
+				"cannot schedule firmware update (%d)\n", ret);
+	}
+
+out:
+	return ret;
+}
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+#define mxt_suspend	NULL
+#define mxt_resume	NULL
+
+static void mxt_early_suspend(struct early_suspend *h)
+{
+	struct mxt_data *data = container_of(h, struct mxt_data,
+								early_suspend);
+#if TSP_INFORM_CHARGER
+	cancel_delayed_work_sync(&data->noti_dwork);
+#endif
+
+	mutex_lock(&data->input_dev->mutex);
+
+	mxt_stop(data);
+
+	mutex_unlock(&data->input_dev->mutex);
+}
+
+static void mxt_late_resume(struct early_suspend *h)
+{
+	struct mxt_data *data = container_of(h, struct mxt_data,
+								early_suspend);
+	mutex_lock(&data->input_dev->mutex);
+
+	mxt_start(data);
+
+	mutex_unlock(&data->input_dev->mutex);
+}
+#else
+static int mxt_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct mxt_data *data = i2c_get_clientdata(client);
+
+	mutex_lock(&data->input_dev->mutex);
+
+	mxt_stop(data);
+
+	mutex_unlock(&data->input_dev->mutex);
+	return 0;
+}
+
+static int mxt_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct mxt_data *data = i2c_get_clientdata(client);
+
+	mutex_lock(&data->input_dev->mutex);
+
+	mxt_start(data);
+
+	mutex_unlock(&data->input_dev->mutex);
+	return 0;
+}
+#endif
+
+/* Added for samsung dependent codes such as Factory test,
+ * Related debug sysfs.
+ */
+
+#include "mxts_sec.c"
+static int __devinit mxt_probe(struct i2c_client *client,
+		const struct i2c_device_id *id)
+{
+	const struct mxt_platform_data *pdata = client->dev.platform_data;
+	struct mxt_data *data;
+	struct input_dev *input_dev;
+	u16 boot_address;
+	int error = 0;
+
+	if (!pdata) {
+		dev_err(&client->dev, "Platform data is not proper\n");
+		return -EINVAL;
+	}
+
+	data = kzalloc(sizeof(struct mxt_data), GFP_KERNEL);
+	if (!data) {
+		dev_err(&client->dev, "Failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		error = -ENOMEM;
+		dev_err(&client->dev, "Input device allocation failed\n");
+		goto err_allocate_input_device;
+	}
+
+	input_dev->name = "sec_touchscreen";
+	input_dev->id.bustype = BUS_I2C;
+	input_dev->dev.parent = &client->dev;
+	input_dev->open = mxt_input_open;
+	input_dev->close = mxt_input_close;
+
+	data->client = client;
+	data->input_dev = input_dev;
+	data->pdata = pdata;
+	init_completion(&data->init_done);
+
+	set_bit(EV_ABS, input_dev->evbit);
+	set_bit(EV_KEY, input_dev->evbit);
+	set_bit(INPUT_PROP_DIRECT, input_dev->propbit);
+	set_bit(BTN_TOUCH, input_dev->keybit);
+	set_bit(BTN_TOOL_FINGER, input_dev->keybit);
+
+	input_mt_init_slots(input_dev, MXT_MAX_FINGER);
+
+	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
+				0, pdata->max_x, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_POSITION_Y,
+				0, pdata->max_y, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
+				0, MXT_AREA_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_PRESSURE,
+				0, MXT_AMPLITUDE_MAX, 0, 0);
+#if TSP_USE_SHAPETOUCH
+	input_set_abs_params(input_dev, ABS_MT_COMPONENT,
+				0, MXT_COMPONENT_MAX, 0, 0);
+	input_set_abs_params(input_dev, ABS_MT_SUMSIZE,
+				0, MXT_SUMSIZE_MAX, 0, 0);
+#endif
+
+	input_set_drvdata(input_dev, data);
+	i2c_set_clientdata(client, data);
+
+	if (data->pdata->boot_address) {
+		boot_address = data->pdata->boot_address;
+	} else {
+		if (client->addr == MXT_APP_LOW)
+			boot_address = MXT_BOOT_LOW;
+		else
+			boot_address = MXT_BOOT_HIGH;
+	}
+	data->client_boot = i2c_new_dummy(client->adapter, boot_address);
+	if (!data->client_boot) {
+		dev_err(&client->dev, "Fail to register sub client[0x%x]\n",
+			 boot_address);
+		error = -ENODEV;
+		goto err_create_sub_client;
+	}
+
+	/* regist input device */
+	error = input_register_device(input_dev);
+	if (error)
+		goto err_register_input_device;
+#ifdef TSP_BOOSTER
+	mutex_init(&data->dvfs_lock);
+	INIT_DELAYED_WORK(&data->work_dvfs_off, mxt_set_dvfs_off);
+	data->dvfs_lock_status = false;
+#endif
+
+
+	error = mxt_sysfs_init(client);
+	if (error < 0) {
+		dev_err(&client->dev, "Failed to create sysfs\n");
+		goto err_sysfs_init;
+	}
+
+	error = mxt_power_on(data);
+	if (error) {
+		dev_err(&client->dev, "Failed to power_on\n");
+		goto err_power_on;
+	}
+
+	error = mxt_touch_init(data, MXT_FIRMWARE_UPDATE_TYPE);
+	if (error) {
+		dev_err(&client->dev, "Failed to init driver\n");
+		goto err_touch_init;
+	}
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	data->early_suspend.level = EARLY_SUSPEND_LEVEL_BLANK_SCREEN + 1;
+	data->early_suspend.suspend = mxt_early_suspend;
+	data->early_suspend.resume = mxt_late_resume;
+	register_early_suspend(&data->early_suspend);
+#endif
+
+	return 0;
+
+err_touch_init:
+	mxt_power_off(data);
+err_power_on:
+	mxt_sysfs_remove(data);
+
+err_sysfs_init:
+	input_unregister_device(input_dev);
+	input_dev = NULL;
+err_register_input_device:
+	i2c_unregister_device(data->client_boot);
+err_create_sub_client:
+	input_free_device(input_dev);
+err_allocate_input_device:
+	kfree(data);
+
+	return error;
+}
+
+static int __devexit mxt_remove(struct i2c_client *client)
+{
+	struct mxt_data *data = i2c_get_clientdata(client);
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	unregister_early_suspend(&data->early_suspend);
+#endif
+	free_irq(client->irq, data);
+	kfree(data->objects);
+	kfree(data->reportids);
+	input_unregister_device(data->input_dev);
+	i2c_unregister_device(data->client_boot);
+	mxt_sysfs_remove(data);
+	mxt_power_off(data);
+	kfree(data);
+
+	return 0;
+}
+
+static struct i2c_device_id mxt_idtable[] = {
+	{MXT_DEV_NAME, 0},
+};
+
+MODULE_DEVICE_TABLE(i2c, mxt_idtable);
+
+static const struct dev_pm_ops mxt_pm_ops = {
+	.suspend = mxt_suspend,
+	.resume = mxt_resume,
+};
+
+static struct i2c_driver mxt_i2c_driver = {
+	.id_table = mxt_idtable,
+	.probe = mxt_probe,
+	.remove = __devexit_p(mxt_remove),
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= MXT_DEV_NAME,
+#ifdef CONFIG_PM
+		.pm	= &mxt_pm_ops,
+#endif
+	},
+};
+
+module_i2c_driver(mxt_i2c_driver);
+
+MODULE_DESCRIPTION("Atmel MaXTouch driver");
+MODULE_AUTHOR("bumwoo.lee<bw365.lee@samsung.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/mxts_sec.c b/drivers/input/touchscreen/mxts_sec.c
new file mode 100644
index 0000000..531e926
--- /dev/null
+++ b/drivers/input/touchscreen/mxts_sec.c
@@ -0,0 +1,1775 @@
+#if TSP_SEC_FACTORY
+#include <linux/uaccess.h>
+
+static void set_default_result(struct mxt_fac_data *data)
+{
+	char delim = ':';
+
+	memset(data->cmd_result, 0x00, ARRAY_SIZE(data->cmd_result));
+	memcpy(data->cmd_result, data->cmd, strlen(data->cmd));
+	strncat(data->cmd_result, &delim, 1);
+}
+
+static void set_cmd_result(struct mxt_fac_data *data, char *buff, int len)
+{
+	strncat(data->cmd_result, buff, len);
+}
+
+static void not_support_cmd(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[16] = {0};
+
+	set_default_result(fdata);
+	sprintf(buff, "%s", "NA");
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+	fdata->cmd_state = CMD_STATUS_NOT_APPLICABLE;
+	dev_info(&client->dev, "%s: \"%s(%d)\"\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static bool mxt_check_xy_range(struct mxt_data *data, u16 node)
+{
+	u8 x_line = node / data->info.matrix_ysize;
+	u8 y_line = node % data->info.matrix_ysize;
+	return (y_line < data->fdata->num_ynode) ?
+		(x_line < data->fdata->num_xnode) : false;
+}
+
+/* +  Vendor specific helper functions */
+static int mxt_xy_to_node(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[16] = {0};
+	int node;
+
+	/* cmd_param[0][1] : [x][y] */
+	if (fdata->cmd_param[0] < 0
+		|| fdata->cmd_param[0] >= data->fdata->num_xnode
+		|| fdata->cmd_param[1] < 0
+		|| fdata->cmd_param[1] >= data->fdata->num_ynode) {
+		snprintf(buff, sizeof(buff) , "%s", "NG");
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+		fdata->cmd_state = CMD_STATUS_FAIL;
+
+		dev_info(&client->dev, "%s: parameter error: %u,%u\n",
+			__func__, fdata->cmd_param[0], fdata->cmd_param[1]);
+		return -EINVAL;
+	}
+
+	/*
+	 * maybe need to consider orient.
+	 *   --> y number
+	 *  |(0,0) (0,1)
+	 *  |(1,0) (1,1)
+	 *  v
+	 *  x number
+	 */
+	node = fdata->cmd_param[0] * data->fdata->num_ynode
+			+ fdata->cmd_param[1];
+
+	dev_info(&client->dev, "%s: node = %d\n", __func__, node);
+	return node;
+}
+
+static void mxt_node_to_xy(struct mxt_data *data, u16 *x, u16 *y)
+{
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	*x = fdata->delta_max_node / data->fdata->num_ynode;
+	*y = fdata->delta_max_node % data->fdata->num_ynode;
+
+	dev_info(&client->dev, "%s: node[%d] is X,Y=%d,%d\n",
+		__func__, fdata->delta_max_node, *x, *y);
+}
+
+static int mxt_set_diagnostic_mode(struct mxt_data *data, u8 dbg_mode)
+{
+	struct i2c_client *client = data->client;
+	u8 cur_mode;
+	int ret;
+
+	ret = mxt_write_object(data, MXT_GEN_COMMANDPROCESSOR_T6,
+			MXT_COMMAND_DIAGNOSTIC, dbg_mode);
+
+	if (ret) {
+		dev_err(&client->dev, "Failed change diagnositc mode to %d\n",
+			 dbg_mode);
+		goto out;
+	}
+
+	if (dbg_mode & MXT_DIAG_MODE_MASK) {
+		do {
+			ret = mxt_read_object(data, MXT_DEBUG_DIAGNOSTIC_T37,
+				MXT_DIAGNOSTIC_MODE, &cur_mode);
+			if (ret) {
+				dev_err(&client->dev, "Failed getting diagnositc mode\n");
+				goto out;
+			}
+			msleep(20);
+		} while (cur_mode != dbg_mode);
+		dev_dbg(&client->dev, "current dianostic chip mode is %d\n",
+			 cur_mode);
+	}
+
+out:
+	return ret;
+}
+
+
+static void mxt_treat_dbg_data(struct mxt_data *data,
+	struct mxt_object *dbg_object, u8 dbg_mode, u8 read_point, u16 num)
+{
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+	u8 data_buffer[DATA_PER_NODE] = { 0 };
+
+	if (dbg_mode == MXT_DIAG_DELTA_MODE) {
+		/* read delta data */
+		mxt_read_mem(data, dbg_object->start_address + read_point,
+			DATA_PER_NODE, data_buffer);
+
+		fdata->delta[num] =
+			((u16)data_buffer[1]<<8) + (u16)data_buffer[0];
+
+		dev_dbg(&client->dev, "delta[%d] = %d\n",
+			num, fdata->delta[num]);
+
+		if (abs(fdata->delta[num])
+			> abs(fdata->delta_max_data)) {
+			fdata->delta_max_node = num;
+			fdata->delta_max_data = fdata->delta[num];
+		}
+	} else if (dbg_mode == MXT_DIAG_REFERENCE_MODE) {
+		/* read reference data */
+		mxt_read_mem(data, dbg_object->start_address + read_point,
+			DATA_PER_NODE, data_buffer);
+
+		fdata->reference[num] =
+			((u16)data_buffer[1] << 8) + (u16)data_buffer[0]
+			- REF_OFFSET_VALUE;
+
+		/* check that reference is in spec or not */
+		if (fdata->reference[num] < REF_MIN_VALUE
+			|| fdata->reference[num] > REF_MAX_VALUE) {
+			dev_err(&client->dev, "reference[%d] is out of range = %d(%d,%d)\n",
+				num, fdata->reference[num],
+				num / data->fdata->num_ynode,
+				num % data->fdata->num_ynode);
+		}
+
+		if (fdata->reference[num] > fdata->ref_max_data)
+			fdata->ref_max_data = fdata->reference[num];
+		if (fdata->reference[num] < fdata->ref_min_data)
+			fdata->ref_min_data =	fdata->reference[num];
+
+		dev_dbg(&client->dev, "reference[%d] = %d\n",
+				num, fdata->reference[num]);
+	}
+}
+
+static int mxt_read_all_diagnostic_data(struct mxt_data *data, u8 dbg_mode)
+{
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+	struct mxt_object *dbg_object;
+	u8 read_page, cur_page, end_page, read_point;
+	u16 node, num = 0,  cnt = 0;
+	int ret = 0;
+
+	/* to make the Page Num to 0 */
+	ret = mxt_set_diagnostic_mode(data, MXT_DIAG_CTE_MODE);
+	if (ret)
+		goto out;
+
+	/* change the debug mode */
+	ret = mxt_set_diagnostic_mode(data, dbg_mode);
+	if (ret)
+		goto out;
+
+	/* get object info for diagnostic */
+	dbg_object = mxt_get_object(data, MXT_DEBUG_DIAGNOSTIC_T37);
+	if (!dbg_object) {
+		dev_err(&client->dev, "fail to get object_info\n");
+		ret = -EINVAL;
+		goto out;
+	}
+	fdata->ref_min_data = REF_MAX_VALUE;
+	fdata->ref_max_data = REF_MIN_VALUE;
+	fdata->delta_max_data = 0;
+	fdata->delta_max_node = 0;
+	end_page = (data->info.matrix_xsize * data->info.matrix_ysize)
+				/ NODE_PER_PAGE;
+
+	/* read the dbg data */
+	for (read_page = 0 ; read_page < end_page; read_page++) {
+		for (node = 0; node < NODE_PER_PAGE; node++) {
+			read_point = (node * DATA_PER_NODE) + 2;
+
+			if (mxt_check_xy_range(data, cnt)) {
+				mxt_treat_dbg_data(data, dbg_object, dbg_mode,
+					read_point, num);
+				num++;
+			}
+			cnt++;
+		}
+		ret = mxt_set_diagnostic_mode(data, MXT_DIAG_PAGE_UP);
+		if (ret)
+			goto out;
+		do {
+			msleep(20);
+			ret = mxt_read_mem(data,
+				dbg_object->start_address + MXT_DIAGNOSTIC_PAGE,
+				1, &cur_page);
+			if (ret) {
+				dev_err(&client->dev,
+					"%s Read fail page\n", __func__);
+				goto out;
+			}
+		} while (cur_page != read_page + 1);
+	}
+
+	if (dbg_mode == MXT_DIAG_REFERENCE_MODE) {
+		dev_info(&client->dev, "min/max reference is [%d/%d]\n",
+			fdata->ref_min_data, fdata->ref_max_data);
+	} else if (dbg_mode == MXT_DIAG_DELTA_MODE) {
+		dev_info(&client->dev, "max delta node %d=[%d]\n",
+			fdata->delta_max_node, fdata->delta_max_data);
+	}
+out:
+	return ret;
+}
+
+/*
+ * find the x,y position to use maximum delta.
+ * it is diffult to map the orientation and caculate the node number
+ * because layout is always different according to device
+ */
+static void find_delta_node(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct mxt_fac_data *fdata = data->fdata;
+	char buff[16] = {0};
+	u16 x, y;
+	int ret;
+
+	set_default_result(fdata);
+
+	/* read all delta to get the maximum delta value */
+	ret = mxt_read_all_diagnostic_data(data,
+			MXT_DIAG_DELTA_MODE);
+	if (ret) {
+		fdata->cmd_state = CMD_STATUS_FAIL;
+	} else {
+		mxt_node_to_xy(data, &x, &y);
+		snprintf(buff, sizeof(buff), "%d,%d", x, y);
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+
+		fdata->cmd_state = CMD_STATUS_OK;
+	}
+}
+
+/* -  Vendor specific helper functions */
+
+/* + function realted samsung factory test */
+static int mxt_load_fw_from_ums(struct mxt_fw_info *fw_info,
+		const u8 *fw_data)
+{
+	struct mxt_data *data = fw_info->data;
+	struct device *dev = &data->client->dev;
+	struct file *filp = NULL;
+	struct firmware fw;
+	mm_segment_t old_fs = {0};
+	const char *firmware_name =
+		data->pdata->firmware_name ?: MXT_DEFAULT_FIRMWARE_NAME;
+	char *fw_path;
+	int ret = 0;
+
+	memset(&fw, 0, sizeof(struct firmware));
+
+	fw_path = kzalloc(MXT_MAX_FW_PATH, GFP_KERNEL);
+	if (fw_path == NULL) {
+		dev_err(dev, "Failed to allocate firmware path.\n");
+		return -ENOMEM;
+	}
+
+	snprintf(fw_path, MXT_MAX_FW_PATH, "/sdcard/%s", firmware_name);
+
+	old_fs = get_fs();
+	set_fs(get_ds());
+
+	filp = filp_open(fw_path, O_RDONLY, 0);
+	if (IS_ERR(filp)) {
+		dev_err(dev, "Could not open firmware: %s,%d\n",
+			fw_path, (s32)filp);
+		ret = -ENOENT;
+		goto err_open;
+	}
+
+	fw.size = filp->f_path.dentry->d_inode->i_size;
+
+	fw_data = kzalloc(fw.size, GFP_KERNEL);
+	if (!fw_data) {
+		dev_err(dev, "Failed to alloc buffer for fw\n");
+		ret = -ENOMEM;
+		goto err_alloc;
+	}
+	ret = vfs_read(filp, (char __user *)fw_data, fw.size, &filp->f_pos);
+	if (ret != fw.size) {
+		dev_err(dev, "Failed to read file %s (ret = %d)\n",
+			fw_path, ret);
+		ret = -EINVAL;
+		goto err_alloc;
+	}
+	fw.data = fw_data;
+
+	ret = mxt_verify_fw(fw_info, &fw);
+
+err_alloc:
+	filp_close(filp, current->files);
+err_open:
+	set_fs(old_fs);
+	kfree(fw_path);
+
+	return ret;
+}
+
+static int mxt_load_fw_from_req_fw(struct mxt_fw_info *fw_info,
+		const struct firmware *fw)
+{
+	struct mxt_data *data = fw_info->data;
+	struct device *dev = &data->client->dev;
+	const char *firmware_name =
+		data->pdata->firmware_name ?: MXT_DEFAULT_FIRMWARE_NAME;
+	int ret = 0;
+
+	if (MXT_FIRMWARE_UPDATE_TYPE) {
+		char fw_path[MXT_MAX_FW_PATH];
+
+		memset(&fw_path, 0, MXT_MAX_FW_PATH);
+
+		snprintf(fw_path, MXT_MAX_FW_PATH, "%s%s",
+			MXT_FIRMWARE_INKERNEL_PATH, firmware_name);
+
+		dev_err(dev, "%s\n", fw_path);
+
+		ret = request_firmware(&fw, fw_path, dev);
+		if (ret) {
+			dev_err(dev,
+				"Could not request firmware %s\n", fw_path);
+			goto out;
+		}
+	} else {
+		ret = request_firmware_nowait(THIS_MODULE, true, firmware_name,
+					dev, GFP_KERNEL,
+					data, mxt_request_firmware_work);
+		if (ret) {
+			dev_err(dev,
+				"Could not request firmware %s\n",
+				firmware_name);
+			goto out;
+		}
+	}
+
+	ret = mxt_verify_fw(fw_info, fw);
+out:
+	return ret;
+}
+
+static void fw_update(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct device *dev = &data->client->dev;
+	struct mxt_fac_data *fdata = data->fdata;
+	struct mxt_fw_info fw_info;
+	const u8 *fw_data = NULL;
+	const struct firmware *fw = NULL;
+	int ret = 0;
+	char buff[16] = {0};
+
+	memset(&fw_info, 0, sizeof(struct mxt_fw_info));
+	fw_info.data = data;
+
+	set_default_result(fdata);
+	switch (fdata->cmd_param[0]) {
+
+	case MXT_FW_FROM_UMS:
+		ret = mxt_load_fw_from_ums(&fw_info, fw_data);
+		if (ret)
+			goto out;
+	break;
+
+	case MXT_FW_FROM_BUILT_IN:
+	case MXT_FW_FROM_REQ_FW:
+		ret = mxt_load_fw_from_req_fw(&fw_info, fw);
+		if (ret)
+			goto out;
+	break;
+
+	default:
+		dev_err(dev, "invalid fw file type!!\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = wait_for_completion_interruptible_timeout(&data->init_done,
+			msecs_to_jiffies(90 * MSEC_PER_SEC));
+
+	if (ret <= 0) {
+		dev_err(dev, "error while waiting for device to init (%d)\n",
+			ret);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	mutex_lock(&data->input_dev->mutex);
+	disable_irq(data->client->irq);
+
+	/* Change to the bootloader mode */
+	ret = mxt_command_reset(data, MXT_BOOT_VALUE);
+	if (ret)
+		goto irq_enable;
+
+	ret = mxt_flash_fw(&fw_info);
+	if (ret) {
+		dev_err(dev, "The firmware update failed(%d)\n", ret);
+	} else {
+		dev_info(dev, "The firmware update succeeded\n");
+		kfree(data->objects);
+		data->objects = NULL;
+
+		ret = mxt_initialize(data);
+		if (ret) {
+			dev_err(dev, "Failed to initialize\n");
+			goto irq_enable;
+		}
+
+		ret = mxt_rest_initialize(&fw_info);
+		if (ret) {
+			dev_err(dev, "Failed to rest init\n");
+			goto irq_enable;
+		}
+	}
+	ret = mxt_make_highchg(data);
+
+irq_enable:
+	enable_irq(data->client->irq);
+	mutex_unlock(&data->input_dev->mutex);
+out:
+	release_firmware(fw);
+	kfree(fw_data);
+
+	if (ret) {
+		snprintf(buff, sizeof(buff), "FAIL");
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+		fdata->cmd_state = CMD_STATUS_FAIL;
+	} else {
+		snprintf(buff, sizeof(buff), "OK");
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+		fdata->cmd_state = CMD_STATUS_OK;
+	}
+
+	return;
+}
+
+static void get_fw_ver_bin(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct device *dev = &data->client->dev;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[40] = {0};
+
+	set_default_result(fdata);
+
+	if (!fdata->fw_ver && !fdata->build_ver) {
+		snprintf(buff, sizeof(buff), "NG");
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+		fdata->cmd_state = CMD_STATUS_FAIL;
+	} else {
+		/* Format : IC vendor + H/W verion of IC + F/W version
+		 * ex) Atmel : AT00201B
+		 */
+			snprintf(buff, sizeof(buff), "AT00%02x%02x",
+			fdata->fw_ver, fdata->build_ver);
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+		fdata->cmd_state = CMD_STATUS_OK;
+	}
+	dev_info(dev, "%s: %s(%d)\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static void get_fw_ver_ic(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[40] = {0};
+	int ver, build;
+
+	set_default_result(fdata);
+
+	ver = data->info.version;
+	build = data->info.build;
+
+	/* Format : IC vendor + H/W verion of IC + F/W version
+	 * ex) Atmel : AT00201B
+	 */
+	snprintf(buff, sizeof(buff), "AT00%02x%02x", ver, build);
+
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+	fdata->cmd_state = CMD_STATUS_OK;
+	dev_info(&client->dev, "%s: %s(%d)\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static void get_config_ver(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+	struct mxt_object *user_object;
+
+	char buff[50] = {0};
+	char date[30] = {0};
+	int error = 0;
+	u32 current_crc = 0;
+
+	set_default_result(fdata);
+
+	/* Get the config version from userdata */
+	user_object = mxt_get_object(data, MXT_SPT_USERDATA_T38);
+	if (!user_object) {
+		dev_err(&client->dev, "fail to get object_info\n");
+		snprintf(buff, sizeof(buff), "%s", "NG");
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+		fdata->cmd_state = CMD_STATUS_FAIL;
+		return;
+	}
+
+	mxt_read_mem(data, user_object->start_address,
+			MXT_CONFIG_VERSION_LENGTH, date);
+
+	disable_irq(data->client->irq);
+	/* Get config CRC from device */
+	error = mxt_read_config_crc(data, &current_crc);
+	if (error)
+		dev_err(&client->dev, "%s Error getting configuration CRC:%d\n",
+			__func__, error);
+	enable_irq(data->client->irq);
+
+	/* Model number_vendor_date_CRC value */
+#if 1	/* Need to be removed hard cording in date */
+	snprintf(buff, sizeof(buff), "%s_AT_1121_0x%06X",
+		data->pdata->project_name, current_crc);
+#else
+	snprintf(buff, sizeof(buff), "%s-%s-0x%06X",
+		data->pdata->project_name, date, current_crc);
+#endif
+
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+	fdata->cmd_state = CMD_STATUS_OK;
+	dev_info(&client->dev, "%s: %s(%d)\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static void get_threshold(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+	int error;
+
+	char buff[16] = {0};
+	u8 threshold = 0;
+
+	set_default_result(fdata);
+
+	if (data->pdata->revision == MXT_REVISION_I)
+		error = mxt_read_object(data, MXT_TOUCH_MULTITOUCHSCREEN_T100,
+			 30, &threshold);
+	else
+		error = mxt_read_object(data, MXT_TOUCH_MULTITOUCHSCREEN_T9,
+			 7, &threshold);
+
+	if (error) {
+		dev_err(&client->dev, "Failed get the threshold\n");
+		snprintf(buff, sizeof(buff), "%s", "NG");
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+		fdata->cmd_state = CMD_STATUS_FAIL;
+		return;
+	}
+
+	snprintf(buff, sizeof(buff), "%d", threshold);
+
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+	fdata->cmd_state = CMD_STATUS_OK;
+	dev_info(&client->dev, "%s: %s(%d)\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static void module_off_master(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[3] = {0};
+
+	mutex_lock(&data->input_dev->mutex);
+
+	if (mxt_stop(data))
+		snprintf(buff, sizeof(buff), "%s", "NG");
+	else
+		snprintf(buff, sizeof(buff), "%s", "OK");
+
+	mutex_unlock(&data->input_dev->mutex);
+
+	set_default_result(fdata);
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+
+	if (strncmp(buff, "OK", 2) == 0)
+		fdata->cmd_state = CMD_STATUS_OK;
+	else
+		fdata->cmd_state = CMD_STATUS_FAIL;
+
+	dev_info(&client->dev, "%s: %s\n", __func__, buff);
+}
+
+static void module_on_master(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[3] = {0};
+
+	mutex_lock(&data->input_dev->mutex);
+
+	if (mxt_start(data))
+		snprintf(buff, sizeof(buff), "%s", "NG");
+	else
+		snprintf(buff, sizeof(buff), "%s", "OK");
+
+	mutex_unlock(&data->input_dev->mutex);
+
+	set_default_result(fdata);
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+
+	if (strncmp(buff, "OK", 2) == 0)
+		fdata->cmd_state = CMD_STATUS_OK;
+	else
+		fdata->cmd_state = CMD_STATUS_FAIL;
+
+	dev_info(&client->dev, "%s: %s\n", __func__, buff);
+
+}
+
+static void get_chip_vendor(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[16] = {0};
+
+	set_default_result(fdata);
+
+	snprintf(buff, sizeof(buff), "%s", "ATMEL");
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+	fdata->cmd_state = CMD_STATUS_OK;
+	dev_info(&client->dev, "%s: %s(%d)\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static void get_chip_name(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[16] = {0};
+
+	set_default_result(fdata);
+
+	snprintf(buff, sizeof(buff), "%s", MXT_DEV_NAME);
+
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+	fdata->cmd_state = CMD_STATUS_OK;
+	dev_info(&client->dev, "%s: %s(%d)\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static void get_x_num(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[16] = {0};
+	int val;
+
+	set_default_result(fdata);
+	val = fdata->num_xnode;
+	if (val < 0) {
+		snprintf(buff, sizeof(buff), "%s", "NG");
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+		fdata->cmd_state = CMD_STATUS_FAIL;
+
+		dev_info(&client->dev, "%s: fail to read num of x (%d).\n",
+			__func__, val);
+
+		return;
+	}
+	snprintf(buff, sizeof(buff), "%u", val);
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+	fdata->cmd_state = CMD_STATUS_OK;
+
+	dev_info(&client->dev, "%s: %s(%d)\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static void get_y_num(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[16] = {0};
+	int val;
+
+	set_default_result(fdata);
+	val = fdata->num_ynode;
+	if (val < 0) {
+		snprintf(buff, sizeof(buff), "%s", "NG");
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+		fdata->cmd_state = CMD_STATUS_FAIL;
+
+		dev_info(&client->dev, "%s: fail to read num of y (%d).\n",
+			__func__, val);
+
+		return;
+	}
+	snprintf(buff, sizeof(buff), "%u", val);
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+	fdata->cmd_state = CMD_STATUS_OK;
+
+	dev_info(&client->dev, "%s: %s(%d)\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static void run_reference_read(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct mxt_fac_data *fdata = data->fdata;
+	int ret;
+	char buff[16] = {0};
+
+	set_default_result(fdata);
+
+	ret = mxt_read_all_diagnostic_data(data,
+			MXT_DIAG_REFERENCE_MODE);
+	if (ret)
+		fdata->cmd_state = CMD_STATUS_FAIL;
+	else {
+		snprintf(buff, sizeof(buff), "%d,%d",
+			fdata->ref_min_data, fdata->ref_max_data);
+		set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+
+		fdata->cmd_state = CMD_STATUS_OK;
+	}
+}
+
+static void get_reference(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+	char buff[16] = {0};
+	int node;
+
+	set_default_result(fdata);
+	/* add read function */
+
+	node = mxt_xy_to_node(data);
+	if (node < 0) {
+		fdata->cmd_state = CMD_STATUS_FAIL;
+		return;
+	}
+	snprintf(buff, sizeof(buff), "%u", fdata->reference[node]);
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+	fdata->cmd_state = CMD_STATUS_OK;
+
+	dev_info(&client->dev, "%s: %s(%d)\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static void run_delta_read(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct mxt_fac_data *fdata = data->fdata;
+	int ret;
+
+	set_default_result(fdata);
+
+	ret = mxt_read_all_diagnostic_data(data,
+			MXT_DIAG_DELTA_MODE);
+	if (ret)
+		fdata->cmd_state = CMD_STATUS_FAIL;
+	else
+		fdata->cmd_state = CMD_STATUS_OK;
+}
+
+static void get_delta(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+	char buff[16] = {0};
+	int node;
+
+	set_default_result(fdata);
+	/* add read function */
+
+	node = mxt_xy_to_node(data);
+	if (node < 0) {
+		fdata->cmd_state = CMD_STATUS_FAIL;
+		return;
+	}
+	snprintf(buff, sizeof(buff), "%d", fdata->delta[node]);
+	set_cmd_result(fdata, buff, strnlen(buff, sizeof(buff)));
+	fdata->cmd_state = CMD_STATUS_OK;
+
+	dev_info(&client->dev, "%s: %s(%d)\n",
+		__func__, buff, strnlen(buff, sizeof(buff)));
+}
+
+static int mxt_check_fcal_status(struct mxt_data *data, u8 status)
+{
+	struct device *dev = &data->client->dev;
+	int error = -EINVAL;
+
+	dev_info(dev, "FCAL : state[%s]\n",
+		 MXT_FCALSTATE(status) ? (MXT_FCALSTATE(status) == 1 ?
+		 "PRIMED" : "GENERATED") : "IDLE");
+
+	switch (MXT_FCALSTATE(status)) {
+	case MXT_FCALSTATE_IDLE:
+		if (status & MXT_FCALSTATUS_SEQTO) {
+			dev_err(dev, "Sequence Timeout:[0x%x]\n", status);
+			goto out;
+		}
+		if (status & MXT_FCALSTATUS_SEQERR) {
+			dev_err(dev, "Sequence Error:[0x%x]\n", status);
+			goto out;
+		}
+		if (status & MXT_FCALSTATUS_SEQDONE) {
+			dev_info(dev, "Sequence Done:[0x%x]\n", status);
+			error = FCALSEQDONE_MAGIC;
+			goto out;
+		}
+		break;
+	case MXT_FCALSTATE_PRIMED:
+		error = mxt_write_object(data, MXT_SPT_GOLDENREFERENCES_T66,
+				0, MXT_FCALCMD(MXT_FCALCMD_GENERATE) | 0x03);
+		if (error) {
+			dev_err(dev, "Failed to write FALCMD_GENERATE\n");
+			goto out;
+		}
+		break;
+	case MXT_FCALSTATE_GENERATED:
+		if (status & MXT_FCALSTATUS_FAIL) {
+			dev_err(dev, "Calibration Failed:[0x%x]\n", status);
+			goto out;
+		}
+		if (status & MXT_FCALSTATUS_PASS) {
+			dev_info(dev, "Calibration Passed:[0x%x]\n", status);
+			error = mxt_write_object(data,
+					 MXT_SPT_GOLDENREFERENCES_T66, 0,
+					 MXT_FCALCMD(MXT_FCALCMD_STORE) | 0x03);
+			if (error) {
+				dev_err(dev, "Failed to write FCALCMD_STORE\n");
+				goto out;
+			}
+		}
+		break;
+	default:
+		dev_err(dev, "Invaild Factory Calibration status[0x%x]\n",
+				 status);
+	}
+
+out:
+	return error;
+}
+
+static int mxt_read_message_on_fcal(struct mxt_data *data,
+	struct mxt_message *message)
+{
+	struct device *dev = &data->client->dev;
+	u8 report_id = 0, type = 0, fcal_status = 0;
+	int error = 0;
+
+	do {
+		if (mxt_read_message(data, message)) {
+			dev_err(dev, "Failed to read message\n");
+			return -EIO;
+		}
+
+#if TSP_USE_ATMELDBG
+		if (data->atmeldbg.display_log) {
+			print_hex_dump(KERN_INFO, "MXT MSG:",
+				DUMP_PREFIX_NONE, 16, 1,
+				message,
+				sizeof(struct mxt_message), false);
+		}
+#endif
+		report_id = message->reportid;
+		if (report_id > data->max_reportid)
+			goto end;
+
+		type = data->reportids[report_id].type;
+		/* check message is avaiable on Factory calibration */
+		switch (type) {
+		case MXT_SPT_GOLDENREFERENCES_T66:
+			fcal_status = message->message[0];
+
+			dev_dbg(dev, "T%d:\t[0x%x][0x%x][0x%x][0x%x][0x%x]\n",
+				type, message->reportid,
+				message->message[0], message->message[1],
+				message->message[2], message->message[3]);
+
+			error = mxt_check_fcal_status(data, fcal_status);
+			if (error)
+				return error;
+			break;
+
+		/* need to add exception case such as T9 touch message.
+		 * I think T9 message represent that user touch the device
+		 * during Factory calibration
+		 */
+		case MXT_TOUCH_MULTITOUCHSCREEN_T9:
+		case MXT_PROCI_TOUCHSUPPRESSION_T42:
+			dev_err(dev, "Object detected on screen[T%d]\n",
+				type);
+			break;
+
+		default:
+			dev_dbg(dev, "T%d:\t[0x%x][0x%x][0x%x][0x%x][0x%x][0x%x][0x%x][0x%x][0x%x]\n",
+				type, message->reportid,
+				message->message[0], message->message[1],
+				message->message[2], message->message[3],
+				message->message[4], message->message[5],
+				message->message[6], message->message[7]);
+		}
+	} while (!data->pdata->read_chg());
+
+end:
+	return 0;
+}
+
+static void mxt_run_factory_cal(void *device_data)
+{
+	struct mxt_data *data = (struct mxt_data *)device_data;
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+	struct mxt_message message;
+	int error = 0;
+
+	set_default_result(fdata);
+
+	/* To ensure that previous touchs are released */
+	msleep(500);
+
+	/* CTRL : enable RPTEN and ENABLE */
+	error = mxt_write_object(data, MXT_SPT_GOLDENREFERENCES_T66,
+				0, MXT_FCALCMD(MXT_FCALCMD_PRIME) | 0x03);
+
+	if (error) {
+		dev_err(&client->dev, "Failed to write FCALCMD_PRIME\n");
+		fdata->cmd_state = CMD_STATUS_FAIL;
+		return;
+	}
+
+	disable_irq(client->irq);
+
+	do {
+		error = mxt_read_message_on_fcal(data, &message);
+
+		if (!error)
+			msleep(1000);
+	} while (!error);
+
+	enable_irq(client->irq);
+
+	if (error == FCALSEQDONE_MAGIC) {
+		dev_info(&client->dev, "Sucessed Factory Calibration\n");
+		fdata->cmd_state = CMD_STATUS_OK;
+	} else {
+		dev_err(&client->dev, "Failed Factory Calibration [%d]", error);
+		fdata->cmd_state = CMD_STATUS_FAIL;
+	}
+}
+/* - function realted samsung factory test */
+
+#define TSP_CMD(name, func) .cmd_name = name, .cmd_func = func
+
+struct tsp_cmd {
+	struct list_head	list;
+	const char		*cmd_name;
+	void			(*cmd_func)(void *device_data);
+};
+
+static struct tsp_cmd tsp_cmds[] = {
+	{TSP_CMD("fw_update", fw_update),},
+	{TSP_CMD("get_fw_ver_bin", get_fw_ver_bin),},
+	{TSP_CMD("get_fw_ver_ic", get_fw_ver_ic),},
+	{TSP_CMD("get_config_ver", get_config_ver),},
+	{TSP_CMD("get_threshold", get_threshold),},
+	{TSP_CMD("module_off_master", module_off_master),},
+	{TSP_CMD("module_on_master", module_on_master),},
+	{TSP_CMD("module_off_slave", not_support_cmd),},
+	{TSP_CMD("module_on_slave", not_support_cmd),},
+	{TSP_CMD("get_chip_vendor", get_chip_vendor),},
+	{TSP_CMD("get_chip_name", get_chip_name),},
+	{TSP_CMD("get_x_num", get_x_num),},
+	{TSP_CMD("get_y_num", get_y_num),},
+	{TSP_CMD("run_reference_read", run_reference_read),},
+	{TSP_CMD("get_reference", get_reference),},
+	{TSP_CMD("run_delta_read", run_delta_read),},
+	{TSP_CMD("get_delta", get_delta),},
+	{TSP_CMD("find_delta", find_delta_node),},
+	{TSP_CMD("run_factory_cal", mxt_run_factory_cal),},
+	{TSP_CMD("not_support_cmd", not_support_cmd),},
+};
+
+/* Functions related to basic interface */
+static ssize_t store_cmd(struct device *dev, struct device_attribute
+				  *devattr, const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char *cur, *start, *end;
+	char buff[TSP_CMD_STR_LEN] = {0};
+	int len, i;
+	struct tsp_cmd *tsp_cmd_ptr = NULL;
+	char delim = ',';
+	bool cmd_found = false;
+	int param_cnt = 0;
+	int ret;
+
+	if (fdata->cmd_is_running == true) {
+		dev_err(&client->dev, "tsp_cmd: other cmd is running.\n");
+		goto err_out;
+	}
+
+	/* check lock  */
+	mutex_lock(&fdata->cmd_lock);
+	fdata->cmd_is_running = true;
+	mutex_unlock(&fdata->cmd_lock);
+
+	fdata->cmd_state = CMD_STATUS_RUNNING;
+
+	for (i = 0; i < ARRAY_SIZE(fdata->cmd_param); i++)
+		fdata->cmd_param[i] = 0;
+
+	len = (int)count;
+	if (*(buf + len - 1) == '\n')
+		len--;
+	memset(fdata->cmd, 0x00, ARRAY_SIZE(fdata->cmd));
+	memcpy(fdata->cmd, buf, len);
+
+	cur = strchr(buf, (int)delim);
+	if (cur)
+		memcpy(buff, buf, cur - buf);
+	else
+		memcpy(buff, buf, len);
+
+	/* find command */
+	list_for_each_entry(tsp_cmd_ptr, &fdata->cmd_list_head, list) {
+		if (!strcmp(buff, tsp_cmd_ptr->cmd_name)) {
+			cmd_found = true;
+			break;
+		}
+	}
+
+	/* set not_support_cmd */
+	if (!cmd_found) {
+		list_for_each_entry(tsp_cmd_ptr,
+			&fdata->cmd_list_head, list) {
+			if (!strcmp("not_support_cmd", tsp_cmd_ptr->cmd_name))
+				break;
+		}
+	}
+
+	/* parsing parameters */
+	if (cur && cmd_found) {
+		cur++;
+		start = cur;
+		memset(buff, 0x00, ARRAY_SIZE(buff));
+		do {
+			if (*cur == delim || cur - buf == len) {
+				end = cur;
+				memcpy(buff, start, end - start);
+				*(buff + strlen(buff)) = '\0';
+				ret = kstrtoint(buff, 10,\
+					fdata->cmd_param + param_cnt);
+				start = cur + 1;
+				memset(buff, 0x00, ARRAY_SIZE(buff));
+				param_cnt++;
+			}
+			cur++;
+		} while (cur - buf <= len);
+	}
+
+	dev_info(&client->dev, "cmd = %s\n", tsp_cmd_ptr->cmd_name);
+	for (i = 0; i < param_cnt; i++)
+		dev_info(&client->dev, "cmd param %d= %d\n",
+			i, fdata->cmd_param[i]);
+
+	tsp_cmd_ptr->cmd_func(data);
+err_out:
+	return count;
+}
+
+static ssize_t show_cmd_status(struct device *dev,
+		struct device_attribute *devattr, char *buf)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	struct mxt_fac_data *fdata = data->fdata;
+
+	char buff[16] = {0};
+
+	dev_info(&data->client->dev, "tsp cmd: status:%d\n",
+			fdata->cmd_state);
+
+	if (fdata->cmd_state == CMD_STATUS_WAITING)
+		snprintf(buff, sizeof(buff), "WAITING");
+
+	else if (fdata->cmd_state == CMD_STATUS_RUNNING)
+		snprintf(buff, sizeof(buff), "RUNNING");
+
+	else if (fdata->cmd_state == CMD_STATUS_OK)
+		snprintf(buff, sizeof(buff), "OK");
+
+	else if (fdata->cmd_state == CMD_STATUS_FAIL)
+		snprintf(buff, sizeof(buff), "FAIL");
+
+	else if (fdata->cmd_state == CMD_STATUS_NOT_APPLICABLE)
+		snprintf(buff, sizeof(buff), "NOT_APPLICABLE");
+
+	return snprintf(buf, TSP_BUF_SIZE, "%s\n", buff);
+}
+
+static ssize_t show_cmd_result(struct device *dev, struct device_attribute
+				    *devattr, char *buf)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	struct mxt_fac_data *fdata = data->fdata;
+
+	dev_info(&data->client->dev, "tsp cmd: result: %s\n",
+		fdata->cmd_result);
+
+	mutex_lock(&fdata->cmd_lock);
+	fdata->cmd_is_running = false;
+	mutex_unlock(&fdata->cmd_lock);
+
+	fdata->cmd_state = CMD_STATUS_WAITING;
+
+	return snprintf(buf, TSP_BUF_SIZE, "%s\n", fdata->cmd_result);
+}
+
+static DEVICE_ATTR(cmd, S_IWUSR | S_IWGRP, NULL, store_cmd);
+static DEVICE_ATTR(cmd_status, S_IRUGO, show_cmd_status, NULL);
+static DEVICE_ATTR(cmd_result, S_IRUGO, show_cmd_result, NULL);
+
+static struct attribute *touchscreen_factory_attributes[] = {
+	&dev_attr_cmd.attr,
+	&dev_attr_cmd_status.attr,
+	&dev_attr_cmd_result.attr,
+	NULL,
+};
+
+static struct attribute_group touchscreen_factory_attr_group = {
+	.attrs = touchscreen_factory_attributes,
+};
+#endif	/* TSP_SEC_FACTORY*/
+
+#if TSP_USE_ATMELDBG
+static int mxt_atmeldbg_read_block(struct i2c_client *client,
+	   u16 addr, u16 length, u8 *value)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	struct i2c_msg msg[2];
+	__le16 le_addr;
+	struct mxt_data *data = i2c_get_clientdata(client);
+	struct mxt_object *object;
+
+	if (data == NULL) {
+		dev_err(&client->dev, "%s Data is Null\n", __func__);
+		return -EINVAL;
+	}
+
+	object = mxt_get_object(data, MXT_GEN_MESSAGEPROCESSOR_T5);
+
+	if ((data->atmeldbg.last_read_addr == addr) &&
+		(addr == object->start_address)) {
+		if  (i2c_master_recv(client, value, length) == length) {
+			if (data->atmeldbg.display_log)
+				print_hex_dump(KERN_INFO, "MXT RX:",
+					DUMP_PREFIX_NONE, 16, 1,
+					value, length, false);
+			return 0;
+		} else
+			return -EIO;
+	} else {
+		data->atmeldbg.last_read_addr = addr;
+	}
+
+	le_addr = cpu_to_le16(addr);
+	msg[0].addr  = client->addr;
+	msg[0].flags = 0x00;
+	msg[0].len   = 2;
+	msg[0].buf   = (u8 *) &le_addr;
+
+	msg[1].addr  = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len   = length;
+	msg[1].buf   = (u8 *) value;
+	if (i2c_transfer(adapter, msg, 2) == 2) {
+		if (data->atmeldbg.display_log) {
+			print_hex_dump(KERN_INFO, "MXT TX:", DUMP_PREFIX_NONE,
+				16, 1, msg[0].buf, msg[0].len, false);
+			print_hex_dump(KERN_INFO, "MXT RX:", DUMP_PREFIX_NONE,
+				16, 1, msg[1].buf, msg[1].len, false);
+		}
+		return 0;
+	} else
+		return -EIO;
+}
+
+/* Writes a block of bytes (max 256) to given address in mXT chip. */
+static int mxt_atmeldbg_write_block(struct i2c_client *client,
+	    u16 addr, u16 length, u8 *value)
+{
+	int i;
+	struct {
+		__le16	le_addr;
+		u8	data[256];
+
+	} i2c_block_transfer;
+
+	struct mxt_data *data = i2c_get_clientdata(client);
+
+	if (length > 256)
+		return -EINVAL;
+
+	if (data == NULL) {
+		dev_err(&client->dev, "%s Data is Null\n", __func__);
+		return -EINVAL;
+	}
+
+	data->atmeldbg.last_read_addr = -1;
+
+	for (i = 0; i < length; i++)
+		i2c_block_transfer.data[i] = *value++;
+
+	i2c_block_transfer.le_addr = cpu_to_le16(addr);
+
+	i = i2c_master_send(client, (u8 *) &i2c_block_transfer, length + 2);
+
+	if (i == (length + 2)) {
+		if (data->atmeldbg.display_log)
+			print_hex_dump(KERN_INFO, "MXT TX:", DUMP_PREFIX_NONE,
+				16, 1, &i2c_block_transfer, length+2, false);
+		return length;
+	} else
+		return -EIO;
+}
+
+static ssize_t mem_atmeldbg_access_read(struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr, char *buf, loff_t off, size_t count)
+{
+	int ret = 0;
+	struct i2c_client *client =
+		to_i2c_client(container_of(kobj, struct device, kobj));
+
+	dev_info(&client->dev, "%s p=%p off=%lli c=%zi\n",
+			__func__, buf, off, count);
+
+	if (off >= 32768)
+		return -EIO;
+
+	if (off + count > 32768)
+		count = 32768 - off;
+
+	if (count > 256)
+		count = 256;
+
+	if (count > 0)
+		ret = mxt_atmeldbg_read_block(client, off, count, buf);
+
+	return ret >= 0 ? count : ret;
+}
+
+static ssize_t mem_atmeldbg_access_write(struct file *filp,
+	struct kobject *kobj, struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	int ret = 0;
+	struct i2c_client *client =
+		to_i2c_client(container_of(kobj, struct device, kobj));
+
+	dev_info(&client->dev, "%s p=%p off=%lli c=%zi\n",
+			__func__, buf, off, count);
+
+	if (off >= 32768)
+		return -EIO;
+
+	if (off + count > 32768)
+		count = 32768 - off;
+
+	if (count > 256)
+		count = 256;
+
+	if (count > 0)
+		ret = mxt_atmeldbg_write_block(client, off, count, buf);
+
+	return ret >= 0 ? count : 0;
+}
+
+static ssize_t mxt_atmeldbg_pause_driver_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int count = 0;
+
+	count += sprintf(buf + count, "%d", data->atmeldbg.stop_sync);
+	count += sprintf(buf + count, "\n");
+
+	return count;
+}
+
+static ssize_t mxt_atmeldbg_pause_driver_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
+	int i;
+
+	if (sscanf(buf, "%u", &i) == 1 && i < 2) {
+		data->atmeldbg.stop_sync = i;
+
+		dev_info(&client->dev, "%s input sync for Atmel dbug App\n",
+			i ? "Stop" : "Start");
+	} else {
+		dev_info(&client->dev, "Error %s\n", __func__);
+	}
+
+	return count;
+}
+
+static ssize_t mxt_atmeldbg_debug_enable_show(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int count = 0;
+
+	count += sprintf(buf + count, "%d", data->atmeldbg.display_log);
+	count += sprintf(buf + count, "\n");
+
+	return count;
+}
+
+static ssize_t mxt_atmeldbg_debug_enable_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
+
+	int i;
+	if (sscanf(buf, "%u", &i) == 1 && i < 2) {
+		data->atmeldbg.display_log = i;
+		if (i)
+			dmesg_restrict = 0;
+		else
+			dmesg_restrict = 1;
+
+		dev_info(&client->dev, "%s, dmsesg_restricted :%d\n",
+			i ? "debug enabled" : "debug disabled", dmesg_restrict);
+		dev_info(&client->dev, "%s raw data message for Atmel debug App\n",
+			i ? "Display" : "Undisplay");
+	} else {
+		dev_info(&client->dev, "Error %s\n", __func__);
+	}
+
+	return count;
+}
+
+static ssize_t mxt_atmeldbg_command_off_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
+	int i;
+
+	if (sscanf(buf, "%u", &i) == 1 && i < 2) {
+		data->atmeldbg.block_access = i;
+
+		if (data->atmeldbg.block_access)
+			disable_irq(client->irq);
+		else
+			enable_irq(client->irq);
+
+		dev_info(&client->dev, "%s host driver access IC for Atmel dbug App\n",
+			i ? "Stop" : "Start");
+	} else
+		dev_info(&client->dev, "Error %s\n", __func__);
+
+	return count;
+}
+
+
+static ssize_t mxt_atmeldbg_cmd_calibrate_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	/* send calibration command to the chip */
+	ret = mxt_write_object(data, MXT_GEN_COMMANDPROCESSOR_T6,
+		MXT_COMMAND_CALIBRATE, 1);
+
+	return (ret < 0) ? ret : count;
+}
+
+static ssize_t mxt_atmeldbg_cmd_reset_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	/* send reset command to the chip */
+	ret = mxt_write_object(data, MXT_GEN_COMMANDPROCESSOR_T6,
+		MXT_COMMAND_RESET, MXT_RESET_VALUE);
+
+	return (ret < 0) ? ret : count;
+}
+
+static ssize_t mxt_atmeldbg_cmd_backup_store(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	int ret;
+
+	/* send backup command to the chip */
+	ret = mxt_write_object(data, MXT_GEN_COMMANDPROCESSOR_T6,
+		MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE);
+
+	return (ret < 0) ? ret : count;
+}
+#endif
+
+static ssize_t mxt_object_setting(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
+
+	unsigned int type;
+	unsigned int offset;
+	unsigned int value;
+	u8 val;
+	int ret;
+	sscanf(buf, "%u%u%u", &type, &offset, &value);
+	dev_info(&client->dev, "object type T%d", type);
+	dev_info(&client->dev, "data offset %d\n", offset);
+	dev_info(&client->dev, "data value %d\n", value);
+
+	ret = mxt_write_object(data,
+		(u8)type, (u8)offset, (u8)value);
+
+	if (ret) {
+		dev_err(&client->dev, "fail to write T%d index:%d, value:%d\n",
+			type, offset, value);
+		goto out;
+	} else {
+		ret = mxt_read_object(data,
+				(u8)type, (u8)offset, &val);
+
+		if (ret) {
+			dev_err(&client->dev, "fail to read T%d\n",
+				type);
+			goto out;
+		} else
+			dev_info(&client->dev, "T%d Byte%d is %d\n",
+				type, offset, val);
+	}
+out:
+	return count;
+}
+
+static ssize_t mxt_object_show(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct mxt_data *data = dev_get_drvdata(dev);
+	struct i2c_client *client = data->client;
+	struct mxt_object *object;
+	unsigned int type;
+	u8 val;
+	u16 i;
+
+	sscanf(buf, "%u", &type);
+	dev_info(&client->dev, "object type T%d\n", type);
+
+	object = mxt_get_object(data, type);
+	if (!object) {
+		dev_err(&client->dev, "fail to get object_info\n");
+		return -EINVAL;
+	} else {
+		for (i = 0; i < object->size; i++) {
+			mxt_read_mem(data, object->start_address + i,
+				1, &val);
+			dev_info(&client->dev, "Byte %u --> %u\n", i, val);
+		}
+	}
+
+	return count;
+}
+
+#if TSP_USE_ATMELDBG
+/* Functions for mem_access interface */
+static struct bin_attribute mem_access_attr;
+
+/* Sysfs files for libmaxtouch interface */
+static DEVICE_ATTR(pause_driver, S_IRUGO | S_IWUSR | S_IWGRP,
+	mxt_atmeldbg_pause_driver_show, mxt_atmeldbg_pause_driver_store);
+static DEVICE_ATTR(debug_enable, S_IRUGO | S_IWUSR | S_IWGRP,
+	mxt_atmeldbg_debug_enable_show, mxt_atmeldbg_debug_enable_store);
+static DEVICE_ATTR(command_calibrate, S_IRUGO | S_IWUSR | S_IWGRP,
+	NULL, mxt_atmeldbg_cmd_calibrate_store);
+static DEVICE_ATTR(command_reset, S_IRUGO | S_IWUSR | S_IWGRP,
+	NULL, mxt_atmeldbg_cmd_reset_store);
+static DEVICE_ATTR(command_backup, S_IRUGO | S_IWUSR | S_IWGRP,
+	NULL, mxt_atmeldbg_cmd_backup_store);
+static DEVICE_ATTR(command_off, S_IRUGO | S_IWUSR | S_IWGRP,
+	NULL, mxt_atmeldbg_command_off_store);
+#endif
+static DEVICE_ATTR(object_show, S_IWUSR | S_IWGRP, NULL,
+	mxt_object_show);
+static DEVICE_ATTR(object_write, S_IWUSR | S_IWGRP, NULL,
+	mxt_object_setting);
+
+static struct attribute *libmaxtouch_attributes[] = {
+#if TSP_USE_ATMELDBG
+	&dev_attr_pause_driver.attr,
+	&dev_attr_debug_enable.attr,
+	&dev_attr_command_calibrate.attr,
+	&dev_attr_command_reset.attr,
+	&dev_attr_command_backup.attr,
+	&dev_attr_command_off.attr,
+#endif
+	&dev_attr_object_show.attr,
+	&dev_attr_object_write.attr,
+	NULL,
+};
+
+static struct attribute_group libmaxtouch_attr_group = {
+	.attrs = libmaxtouch_attributes,
+};
+
+#if TSP_SEC_FACTORY
+static void mxt_deallocate_factory(struct mxt_data *data)
+{
+	struct mxt_fac_data *fdata = data->fdata;
+
+	kfree(fdata->delta);
+	kfree(fdata->reference);
+	kfree(fdata);
+}
+
+static int mxt_allocate_factory(struct mxt_data *data)
+{
+	const struct mxt_platform_data *pdata = data->pdata;
+	struct mxt_fac_data *fdata = NULL;
+	struct device *dev = &data->client->dev;
+	int error = 0;
+	int i;
+
+	fdata = kzalloc(sizeof(struct mxt_fac_data), GFP_KERNEL);
+	if (fdata == NULL) {
+		dev_err(dev, "Fail to allocate sysfs data.\n");
+		return -ENOMEM;
+	}
+
+	if (!pdata->num_xnode || !pdata->num_ynode) {
+		dev_err(dev, "%s num of x,y is 0\n", __func__);
+		error =  -EINVAL;
+		goto err_get_num_node;
+	}
+
+	fdata->num_xnode = pdata->num_xnode;
+	fdata->num_ynode = pdata->num_ynode;
+	fdata->num_nodes = fdata->num_xnode * fdata->num_ynode;
+#if !defined(CONFIG_SAMSUNG_PRODUCT_SHIP)
+	dev_info(dev, "%s: x=%d, y=%d, total=%d\n",
+		__func__, fdata->num_xnode,
+		fdata->num_ynode, fdata->num_nodes);
+#endif
+
+	fdata->reference = kzalloc(fdata->num_nodes * sizeof(u16),
+				   GFP_KERNEL);
+	if (!fdata->reference) {
+		dev_err(dev, "Fail to alloc reference of fdata\n");
+		error = -ENOMEM;
+		goto err_alloc_reference;
+	}
+
+	fdata->delta = kzalloc(fdata->num_nodes * sizeof(s16), GFP_KERNEL);
+	if (!fdata->delta) {
+		dev_err(dev, "Fail to alloc delta of fdata\n");
+		error = -ENOMEM;
+		goto err_alloc_delta;
+	}
+
+	INIT_LIST_HEAD(&fdata->cmd_list_head);
+	for (i = 0; i < ARRAY_SIZE(tsp_cmds); i++)
+		list_add_tail(&tsp_cmds[i].list, &fdata->cmd_list_head);
+
+	mutex_init(&fdata->cmd_lock);
+	fdata->cmd_is_running = false;
+
+	data->fdata = fdata;
+
+	return error;
+
+err_alloc_delta:
+err_alloc_reference:
+err_get_num_node:
+
+	mxt_deallocate_factory(data);
+
+	return error;
+}
+
+static int mxt_init_factory(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	int error;
+
+	error = mxt_allocate_factory(data);
+	if (error)
+		return -ENOMEM;
+
+	data->fdata->fac_dev_ts = device_create(sec_class,
+			NULL, 0, data, "tsp");
+	if (IS_ERR(data->fdata->fac_dev_ts)) {
+		dev_err(dev, "Failed to create device for the sysfs\n");
+		error = IS_ERR(data->fdata->fac_dev_ts);
+		goto err_create_device;
+	}
+	error = sysfs_create_group(&data->fdata->fac_dev_ts->kobj,
+		&touchscreen_factory_attr_group);
+	if (error) {
+		dev_err(dev, "Failed to create touchscreen sysfs group\n");
+		goto err_create_group;
+	}
+
+	return 0;
+
+err_create_group:
+err_create_device:
+	mxt_deallocate_factory(data);
+
+	return error;
+}
+
+static void mxt_exit_factory(struct mxt_data *data)
+{
+	struct mxt_fac_data *fdata = data->fdata;
+
+	sysfs_remove_group(&fdata->fac_dev_ts->kobj,
+		&touchscreen_factory_attr_group);
+	mxt_deallocate_factory(data);
+}
+#endif
+
+#if TSP_USE_ATMELDBG
+static int __devinit mxt_sysfs_init_for_ATMELDBG(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+
+	sysfs_bin_attr_init(&mem_access_attr);
+	mem_access_attr.attr.name = "mem_access";
+	mem_access_attr.attr.mode = S_IRUGO | S_IWUGO;
+	mem_access_attr.read = mem_atmeldbg_access_read;
+	mem_access_attr.write = mem_atmeldbg_access_write;
+	mem_access_attr.size = 65535;
+	data->atmeldbg.display_log = 0;
+
+	if (sysfs_create_bin_file(&client->dev.kobj, &mem_access_attr) < 0) {
+		dev_err(&client->dev, "Failed to create device file(%s)!\n",
+				mem_access_attr.attr.name);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+#endif
+
+static int  __devinit mxt_sysfs_init(struct i2c_client *client)
+{
+	struct mxt_data *data = i2c_get_clientdata(client);
+	int error;
+
+	error = sysfs_create_group(&client->dev.kobj, &libmaxtouch_attr_group);
+	if (error) {
+		dev_err(&client->dev, "Failed to create libmaxtouch sysfs group\n");
+		return -EINVAL;
+	}
+#if TSP_USE_ATMELDBG
+	error = mxt_sysfs_init_for_ATMELDBG(data);
+#endif
+	if (error)
+		goto err_sysfs_init_for_ATMELDBG;
+
+#if TSP_SEC_FACTORY
+	error = mxt_init_factory(data);
+#endif
+	if (error)
+		goto err_mxt_init_factory;
+
+	return 0;
+
+err_mxt_init_factory:
+#if TSP_USE_ATMELDBG
+	sysfs_remove_bin_file(&client->dev.kobj, &mem_access_attr);
+#endif
+
+err_sysfs_init_for_ATMELDBG:
+	sysfs_remove_group(&client->dev.kobj, &libmaxtouch_attr_group);
+
+	return error;
+}
+
+static void  mxt_sysfs_remove(struct mxt_data *data)
+{
+	sysfs_remove_group(&data->client->dev.kobj, &libmaxtouch_attr_group);
+
+#if TSP_USE_ATMELDBG
+	sysfs_remove_bin_file(&data->client->dev.kobj, &mem_access_attr);
+#endif
+#if TSP_SEC_FACTORY
+	mxt_exit_factory(data);
+#endif
+}
diff --git a/include/linux/i2c/mxts.h b/include/linux/i2c/mxts.h
new file mode 100644
index 0000000..536781b
--- /dev/null
+++ b/include/linux/i2c/mxts.h
@@ -0,0 +1,579 @@
+/*
+ *  Copyright (C) 2012, Samsung Electronics Co. Ltd. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#ifndef __MXT_H__
+#define __MXT_H__
+
+#ifdef CONFIG_HAS_EARLYSUSPEND
+#include <linux/earlysuspend.h>
+#endif
+
+#if defined(CONFIG_TOUCHSCREEN_ATMEL_MXT224S)
+#define MXT_DEV_NAME	"Atmel MXT224S"
+#elif defined(CONFIG_TOUCHSCREEN_ATMEL_MXTS)
+#define MXT_DEV_NAME	"Atmel MXT540S"
+#elif defined(CONFIG_TOUCHSCREEN_ATMEL_MXT1664S)
+#define MXT_DEV_NAME	"Atmel MXT1664S"
+#else
+#define MXT_DEV_NAME	"MXTXXXS"
+#endif
+#include <asm/system_info.h>
+
+#define MXT_DEFAULT_FIRMWARE_NAME	"MXTS.fw"
+
+#define MXT_FIRMWARE_INKERNEL_PATH	"tsp_atmel/"
+#define MXT_MAX_FW_PATH				30
+#define MXT_FIRMWARE_UPDATE_TYPE	true
+
+#define MXT_BACKUP_TIME			25	/* msec */
+#define MXT_RESET_INTEVAL_TIME	50	/* msec */
+
+#define MXT_SW_RESET_TIME		300	/* msec */
+#define MXT_HW_RESET_TIME		80	/* msec */
+
+enum {
+	MXT_RESERVED_T0 = 0,
+	MXT_RESERVED_T1,
+	MXT_DEBUG_DELTAS_T2,
+	MXT_DEBUG_REFERENCES_T3,
+	MXT_DEBUG_SIGNALS_T4,
+	MXT_GEN_MESSAGEPROCESSOR_T5,
+	MXT_GEN_COMMANDPROCESSOR_T6,
+	MXT_GEN_POWERCONFIG_T7,
+	MXT_GEN_ACQUISITIONCONFIG_T8,
+	MXT_TOUCH_MULTITOUCHSCREEN_T9,
+	MXT_TOUCH_SINGLETOUCHSCREEN_T10,
+	MXT_TOUCH_XSLIDER_T11,
+	MXT_TOUCH_YSLIDER_T12,
+	MXT_TOUCH_XWHEEL_T13,
+	MXT_TOUCH_YWHEEL_T14,
+	MXT_TOUCH_KEYARRAY_T15,
+	MXT_PROCG_SIGNALFILTER_T16,
+	MXT_PROCI_LINEARIZATIONTABLE_T17,
+	MXT_SPT_COMCONFIG_T18,
+	MXT_SPT_GPIOPWM_T19,
+	MXT_PROCI_GRIPFACESUPPRESSION_T20,
+	MXT_RESERVED_T21,
+	MXT_PROCG_NOISESUPPRESSION_T22,
+	MXT_TOUCH_PROXIMITY_T23,
+	MXT_PROCI_ONETOUCHGESTUREPROCESSOR_T24,
+	MXT_SPT_SELFTEST_T25,
+	MXT_DEBUG_CTERANGE_T26,
+	MXT_PROCI_TWOTOUCHGESTUREPROCESSOR_T27,
+	MXT_SPT_CTECONFIG_T28,
+	MXT_SPT_GPI_T29,
+	MXT_SPT_GATE_T30,
+	MXT_TOUCH_KEYSET_T31,
+	MXT_TOUCH_XSLIDERSET_T32,
+	MXT_RESERVED_T33,
+	MXT_GEN_MESSAGEBLOCK_T34,
+	MXT_SPT_GENERICDATA_T35,
+	MXT_RESERVED_T36,
+	MXT_DEBUG_DIAGNOSTIC_T37,
+	MXT_SPT_USERDATA_T38,
+	MXT_SPARE_T39,
+	MXT_PROCI_GRIPSUPPRESSION_T40,
+	MXT_SPARE_T41,
+	MXT_PROCI_TOUCHSUPPRESSION_T42,
+	MXT_SPT_DIGITIZER_T43,
+	MXT_SPARE_T44,
+	MXT_SPARE_T45,
+	MXT_SPT_CTECONFIG_T46,
+	MXT_PROCI_STYLUS_T47,
+	MXT_PROCG_NOISESUPPRESSION_T48,
+	MXT_SPARE_T49,
+	MXT_SPARE_T50,
+	MXT_SPARE_T51,
+	MXT_TOUCH_PROXIMITY_KEY_T52,
+	MXT_GEN_DATASOURCE_T53,
+	MXT_SPARE_T54,
+	MXT_ADAPTIVE_T55,
+	MXT_PROCI_SHIELDLESS_T56,
+	MXT_PROCI_EXTRATOUCHSCREENDATA_T57,
+	MXT_SPARE_T58,
+	MXT_SPARE_T59,
+	MXT_SPARE_T60,
+	MXT_SPT_TIMER_T61,
+	MXT_PROCG_NOISESUPPRESSION_T62,
+	MXT_PROCI_ACTIVESTYLUS_T63,
+	MXT_SPARE_T64,
+	MXT_PROCI_LENSBENDING_T65,
+	MXT_SPT_GOLDENREFERENCES_T66,
+	MXT_SPARE_T67,
+	MXT_SPARE_T68,
+	MXT_PROCI_PALMGESTUREPROCESSOR_T69,
+	MXT_SPT_DYNAMICCONFIGURATIONCONTROLLER_T70,
+	MXT_SPT_DYNAMICCONFIGURATIONCONTAINER_T71,
+	MXT_PROCG_NOISESUPPRESSION_T72,
+	MXT_TOUCH_MULTITOUCHSCREEN_T100 = 100,
+	MXT_SPT_TOUCHSCREENHOVER_T101,
+	MXT_SPT_SELFCAPHOVERCTECONFIG_T102,
+	MXT_RESERVED_T255 = 255,
+};
+
+#define MXT_INFOMATION_BLOCK_SIZE		7
+#define MXT_OBJECT_TABLE_ELEMENT_SIZE	6
+#define MXT_OBJECT_TABLE_START_ADDRESS	7
+
+#define MXT_MAX_FINGER		10
+#define MXT_AREA_MAX		255
+#define MXT_AMPLITUDE_MAX	255
+
+/* Information of each Object */
+
+/* MXT_GEN_COMMAND_T6 Field */
+#define MXT_COMMAND_RESET		0
+#define MXT_COMMAND_BACKUPNV	1
+#define MXT_COMMAND_CALIBRATE	2
+#define MXT_COMMAND_REPORTALL	3
+#define MXT_COMMAND_DEBUGCTL	4
+#define MXT_COMMAND_DIAGNOSTIC	5
+
+/* Define for MXT_GEN_COMMAND_T6 */
+#define MXT_RESET_VALUE		0x01
+#define MXT_BOOT_VALUE		0xa5
+/*
+ * If the firmware can support dynamic configuration,
+ * 0x55 : backup configuration data and resume event handling.
+ * 0x44 : restore configuration data
+ * 0x33 : restore configuration data and stop event handiling.
+ *
+ * if the firmware did not support dynamic configuration,
+ * 0x33, 0x44 is not affect.
+ */
+#define MXT_BACKUP_VALUE		0x55
+#define MXT_RESTORE_VALUE		0x44
+#define MXT_DISALEEVT_VALUE		0x33
+
+/* MXT_GEN_POWER_T7 Field */
+#define MXT_POWER_IDLEACQINT	0
+#define MXT_POWER_ACTACQINT		1
+
+/* MXT_TOUCH_MULTI_T9 Field */
+#define MXT_TOUCH_CTRL			0
+#define MXT_TOUCH_XSIZE			3
+#define MXT_TOUCH_YSIZE			4
+#define MXT_TOUCH_ORIENT		9
+#define MXT_TOUCH_XRANGE_LSB	18
+#define MXT_TOUCH_XRANGE_MSB	19
+#define MXT_TOUCH_YRANGE_LSB	20
+#define MXT_TOUCH_YRANGE_MSB	21
+
+/* MXT_TOUCH_KEYARRAY_T15 Field */
+#define MXT_KEYARRY_CTRL		0
+#define MXT_KEYARRY_XORIGIN		1
+#define MXT_KEYARRY_YORIGIN		1
+
+/* Touch message bit masking value */
+#define MXT_SUPPRESS_MSG_MASK	(1 << 1)
+#define MXT_AMPLITUDE_MSG_MASK	(1 << 2)
+#define MXT_VECTOR_MSG_MASK		(1 << 3)
+#define MXT_MOVE_MSG_MASK		(1 << 4)
+#define MXT_RELEASE_MSG_MASK	(1 << 5)
+#define MXT_PRESS_MSG_MASK		(1 << 6)
+#define MXT_DETECT_MSG_MASK		(1 << 7)
+
+/* Slave addresses */
+#define MXT_APP_LOW			0x4a
+#define MXT_APP_HIGH		0x4b
+#define MXT_BOOT_LOW		0x24
+#define MXT_BOOT_HIGH		0x25
+
+/* Bootloader mode status */
+#define MXT_WAITING_BOOTLOAD_CMD	0xc0
+#define MXT_WAITING_FRAME_DATA		0x80
+#define MXT_FRAME_CRC_CHECK			0x02
+#define MXT_FRAME_CRC_FAIL			0x03
+#define MXT_FRAME_CRC_PASS			0x04
+#define MXT_APP_CRC_FAIL			0x40
+#define MXT_BOOT_STATUS_MASK		0x3f
+
+/* Bootloader ID */
+#define MXT_BOOT_EXTENDED_ID		0x20
+#define MXT_BOOT_ID_MASK			0x1f
+
+/* Command to unlock bootloader */
+#define MXT_UNLOCK_CMD_MSB			0xaa
+#define MXT_UNLOCK_CMD_LSB			0xdc
+
+#define MXT_STATE_INACTIVE		0
+#define MXT_STATE_RELEASE		1
+#define MXT_STATE_PRESS			2
+#define MXT_STATE_MOVE			3
+
+/* Diagnostic command defines  */
+#define MXT_DIAG_PAGE_UP				0x01
+#define MXT_DIAG_PAGE_DOWN				0x02
+#define MXT_DIAG_DELTA_MODE				0x10
+#define MXT_DIAG_REFERENCE_MODE			0x11
+#define MXT_DIAG_CTE_MODE				0x31
+#define MXT_DIAG_IDENTIFICATION_MODE	0x80
+#define MXT_DIAG_TOCH_THRESHOLD_MODE	0xF4
+
+#define MXT_DIAG_MODE_MASK				0xFC
+#define MXT_DIAGNOSTIC_MODE				0
+#define MXT_DIAGNOSTIC_PAGE				1
+
+#define MXT_CONFIG_VERSION_LENGTH	30
+
+/* Touchscreen configuration infomation */
+#define MXT_FW_MAGIC		0x4D3C2B1A
+
+/* Message type of T100 object */
+#define MXT_T100_SCREEN_MSG_FIRST_RPT_ID	0
+#define MXT_T100_SCREEN_MSG_SECOND_RPT_ID	1
+#define MXT_T100_SCREEN_MESSAGE_NUM_RPT_ID	2
+
+/* Event Types of T100 object */
+#define MXT_T100_DETECT_MSG_MASK	7
+
+#define MXT_T100_EVENT_NONE			0
+#define MXT_T100_EVENT_MOVE			1
+#define MXT_T100_EVENT_UNSUPPRESS	2
+#define MXT_T100_EVENT_SUPPESS		3
+#define MXT_T100_EVENT_DOWN			4
+#define MXT_T100_EVENT_UP			5
+#define MXT_T100_EVENT_UNSUPSUP		6
+#define MXT_T100_EVENT_UNSUPUP		7
+#define MXT_T100_EVENT_DOWNSUP		8
+#define MXT_T100_EVENT_DOWNUP		9
+
+/* Tool types of T100 object */
+#define MXT_T100_TYPE_RESERVED			0
+#define MXT_T100_TYPE_FINGER			1
+#define MXT_T100_TYPE_PASSIVE_STYLUS	2
+#define MXT_T100_TYPE_ACTIVE_STYLUS		3
+#define MXT_T100_TYPE_HOVERING_FINGER	4
+
+/* Revision info of Touch IC
+ *
+ * Revision	/	Bootloader ID
+ * G			0x2103
+ * I			0x3303
+ */
+#define MXT_REVISION_G	0
+#define MXT_REVISION_I	1	/* Support hovering */
+
+/************** Feature + **************/
+#ifdef CONFIG_SEC_DVFS_BOOSTER
+#define TSP_BOOSTER				1
+#endif
+#define TSP_SEC_FACTORY			1
+#define TSP_INFORM_CHARGER		1
+#define TSP_USE_SHAPETOUCH		1
+
+/* TODO TEMP_HOVER : Need to check and modify
+ * it can be changed related potocol of hover So current
+ * implementation is temporary code.
+ */
+#define TSP_HOVER_WORKAROUND			1
+
+/* TSP_USE_ATMELDBG feature just for atmel tunning app
+* so it should be disabled after finishing tunning
+* because it use other write permission. it will be cause
+* failure of CTS
+*/
+#if !defined(CONFIG_SAMSUNG_PRODUCT_SHIP)
+#define TSP_USE_ATMELDBG		1
+#else
+#define TSP_USE_ATMELDBG		0
+#endif
+/************** Feature - **************/
+
+#if TSP_USE_SHAPETOUCH
+#define MXT_COMPONENT_MAX	255
+#define MXT_SUMSIZE_MAX		(16 * 26)
+#endif
+#if TSP_SEC_FACTORY
+#define TSP_BUF_SIZE	 1024
+
+#define NODE_PER_PAGE	64
+#define DATA_PER_NODE	2
+
+#define REF_OFFSET_VALUE	16384
+#define REF_MIN_VALUE		(19744 - REF_OFFSET_VALUE)
+#define REF_MAX_VALUE		(28884 - REF_OFFSET_VALUE)
+
+#define TSP_CMD_STR_LEN			32
+#define TSP_CMD_RESULT_STR_LEN	512
+#define TSP_CMD_PARAM_NUM		8
+
+/* Related Golden Reference */
+#define MXT_FCALCMD(x)			((x) << 2)
+#define MXT_FCALCMD_NONE		0
+#define MXT_FCALCMD_PRIME		1
+#define MXT_FCALCMD_GENERATE	2
+#define MXT_FCALCMD_STORE		3
+
+#define MXT_FCALSTATE(x)		(((x) & 0x06) >> 1)
+#define MXT_FCALSTATE_IDLE		0
+#define MXT_FCALSTATE_PRIMED	1
+#define MXT_FCALSTATE_GENERATED	2
+
+#define MXT_FCALSTATUS_FAIL			0x80
+#define MXT_FCALSTATUS_PASS			0x40
+#define MXT_FCALSTATUS_SEQDONE		0x20
+#define MXT_FCALSTATUS_SEQTO		0x10
+#define MXT_FCALSTATUS_SEQERR		0x08
+#define MXT_FCALSTATUS_BADSTORED	0x01
+
+#define FCALSEQDONE_MAGIC			0x7777
+
+enum CMD_STATUS {
+	CMD_STATUS_WAITING = 0,
+	CMD_STATUS_RUNNING,
+	CMD_STATUS_OK,
+	CMD_STATUS_FAIL,
+	CMD_STATUS_NOT_APPLICABLE,
+};
+
+enum {
+	MXT_FW_FROM_BUILT_IN = 0,
+	MXT_FW_FROM_UMS,
+	MXT_FW_FROM_REQ_FW,
+};
+#endif
+
+#ifdef TSP_BOOSTER
+#include <linux/cpufreq.h>
+#define TOUCH_BOOSTER_OFF_TIME	100
+#define TOUCH_BOOSTER_CHG_TIME	200
+
+#endif
+
+struct mxt_callbacks {
+	void (*inform_charger)(struct mxt_callbacks *, bool);
+};
+
+struct mxt_platform_data {
+	unsigned char num_xnode;
+	unsigned char num_ynode;
+	unsigned int max_x;
+	unsigned int max_y;
+	unsigned long irqflags;
+	unsigned char boot_address;
+	unsigned char revision;
+	const char *firmware_name;
+	const char *project_name;
+	const char *dev_name;
+	const u8 **config;
+	bool (*read_chg)(void);
+	int (*power_on) (void);
+	int (*power_off) (void);
+	int (*power_reset) (void);
+	void (*register_cb) (void *);
+};
+
+struct mxt_object {
+	u8 type;
+	u16 start_address;
+	u8 size;
+	u8 instances;
+	u8 num_report_ids;
+
+	/* added for mapping obj to report id*/
+	u8 max_reportid;
+};
+
+struct mxt_info {
+	u8 family_id;
+	u8 variant_id;
+	u8 version;
+	u8 build;
+	u8 matrix_xsize;
+	u8 matrix_ysize;
+	u8 object_num;
+};
+
+struct mxt_message {
+	u8 reportid;
+	u8 message[8];
+};
+
+/**
+ * struct mxt_finger - Represents fingers.
+ * @ x: x position.
+ * @ y: y position.
+ * @ w: size of touch.
+ * @ z: touch amplitude(sum of measured deltas).
+ * @ component: vector info.
+ * @ state: finger status.
+ * @ type: type of touch. if firmware can support.
+ * @ mcount: moving counter for debug.
+ */
+struct mxt_finger {
+	u16 x;
+	u16 y;
+	u16 w;
+	u16 z;
+#if TSP_USE_SHAPETOUCH
+	u16 component;
+#endif
+	u8 state;
+	u8 type;
+	u8 event;
+	u16 mcount;
+};
+
+struct mxt_reportid {
+	u8 type;
+	u8 index;
+};
+
+#ifdef TSP_BOOSTER
+struct touch_booster {
+	bool touch_cpu_lock_status;
+	int cpu_lv;
+	struct delayed_work dvfs_dwork;
+	struct device *bus_dev;
+	struct device *dev;
+};
+#endif
+
+#if TSP_USE_ATMELDBG
+struct atmel_dbg {
+	u16 last_read_addr;
+	u8 stop_sync;	/* to disable input sync report */
+	u8 display_log;	/* to display raw message */
+	u8 block_access;	/* to prevent access IC with I2c */
+};
+#endif
+
+#if TSP_SEC_FACTORY
+struct mxt_fac_data {
+	struct device *fac_dev_ts;
+	struct list_head cmd_list_head;
+	u8 cmd_state;
+	char	cmd[TSP_CMD_STR_LEN];
+	int cmd_param[TSP_CMD_PARAM_NUM];
+	char cmd_result[TSP_CMD_RESULT_STR_LEN];
+	struct mutex	cmd_lock;
+	bool	cmd_is_running;
+
+	u8 num_xnode;
+	u8 num_ynode;
+	u16 num_nodes;
+	u16 *reference;
+	s16 *delta;
+
+	u32 ref_max_data;
+	u32 ref_min_data;
+	s16 delta_max_data;
+	u16 delta_max_node;
+
+	u8 fw_ver;
+	u8 build_ver;
+};
+#endif
+
+struct mxt_data {
+	struct i2c_client *client;
+	struct i2c_client *client_boot;
+	struct input_dev *input_dev;
+	const struct mxt_platform_data *pdata;
+	struct mxt_info info;
+	struct mxt_object *objects;
+	struct mxt_reportid *reportids;
+	struct completion init_done;
+	struct mxt_finger fingers[MXT_MAX_FINGER];
+	u8 max_reportid;
+	u8 finger_mask ;
+	bool mxt_enabled;
+#ifdef CONFIG_HAS_EARLYSUSPEND
+	struct early_suspend early_suspend;
+#endif
+#ifdef TSP_BOOSTER
+	struct delayed_work work_dvfs_off;
+	bool	dvfs_lock_status;
+	struct mutex dvfs_lock;
+#endif
+
+
+#if TSP_USE_ATMELDBG
+	struct atmel_dbg atmeldbg;
+#endif
+#if TSP_SEC_FACTORY
+	struct mxt_fac_data *fdata;
+#endif
+#if TSP_USE_SHAPETOUCH
+	u16 sumsize;
+#endif
+#if TSP_INFORM_CHARGER
+	struct mxt_callbacks callbacks;
+	struct delayed_work noti_dwork;
+	bool charging_mode;
+#endif
+#if TSP_HOVER_WORKAROUND
+/* TODO HOVER : Current firmware need to current calibration for hover manually
+ * I think it is should to move into IC level, and it is completed,
+ *  remove below boolean...*/
+	bool cur_cal_status;
+#endif
+};
+
+/**
+ * struct mxt_fw_image - Represents a firmware file.
+ * @ magic_code: Identifier of file type.
+ * @ hdr_len: Size of file header (struct mxt_fw_image).
+ * @ cfg_len: Size of configuration data.
+ * @ fw_len: Size of firmware data.
+ * @ cfg_crc: CRC of configuration settings.
+ * @ fw_ver: Version of firmware.
+ * @ build_ver: Build version of firmware.
+ * @ data: Configuration data followed by firmware image.
+ */
+struct mxt_fw_image {
+	__le32 magic_code;
+	__le32 hdr_len;
+	__le32 cfg_len;
+	__le32 fw_len;
+	__le32 cfg_crc;
+	u8 fw_ver;
+	u8 build_ver;
+	u8 data[0];
+} __packed;
+
+/**
+ * struct mxt_cfg_data - Represents a configuration data item.
+ * @ type: Type of object.
+ * @ instance: Instance number of object.
+ * @ size: Size of object.
+ * @ register_val: Series of register values for object.
+ */
+struct mxt_cfg_data {
+	u8 type;
+	u8 instance;
+	u8 size;
+	u8 register_val[0];
+} __packed;
+
+struct mxt_fw_info {
+	u8 fw_ver;
+	u8 build_ver;
+	u32 hdr_len;
+	u32 cfg_len;
+	u32 fw_len;
+	u32 cfg_crc;
+	const u8 *cfg_raw_data;	/* start address of configuration data */
+	const u8 *fw_raw_data;	/* start address of firmware data */
+	struct mxt_data *data;
+};
+
+#if TSP_SEC_FACTORY
+extern struct class *sec_class;
+#endif
+
+extern int touch_is_pressed;
+#endif
-- 
1.8.3.2

