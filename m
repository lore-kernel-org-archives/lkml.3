Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347Ab3BVSLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:11:46 -0500
Received: from [89.21.227.133] ([89.21.227.133]:26704 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759075Ab3BVSIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:37 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 07/40] Input: atmel_mxt_ts - Implement CRC check for configuration data.
Date: Fri, 22 Feb 2013 17:57:54 +0000
Message-Id: <1361555907-19840-8-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The configuration is stored in NVRAM on the maXTouch chip. When the device is
reset it reports a CRC of the stored configuration values. Therefore it isn't
necessary to send the configuration on each probe - we can check the CRC
matches and avoid a timeconsuming backup/reset cycle.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   61 ++++++++++++++++++++++++------
 include/linux/i2c/atmel_mxt_ts.h         |    1 +
 2 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index fa294d1..6f30713 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -261,6 +261,7 @@ struct mxt_data {
 	unsigned int max_y;
 	struct bin_attribute mem_access_attr;
 	bool debug_enabled;
+	u32 config_crc;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
@@ -528,6 +529,10 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	int area;
 	int pressure;
 
+	/* do not report events if input device not yet registered */
+	if (!input_dev)
+		return;
+
 	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
 	y = (message->message[2] << 4) | ((message->message[3] & 0xf));
 	if (data->max_x < 1024)
@@ -563,7 +568,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	}
 }
 
-static unsigned mxt_extract_T6_csum(const u8 *csum)
+static u16 mxt_extract_T6_csum(const u8 *csum)
 {
 	return csum[0] | (csum[1] << 8) | (csum[2] << 16);
 }
@@ -574,9 +579,8 @@ static bool mxt_is_T9_message(struct mxt_data *data, struct mxt_message *msg)
 	return (id >= data->T9_reportid_min && id <= data->T9_reportid_max);
 }
 
-static irqreturn_t mxt_interrupt(int irq, void *dev_id)
+static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 {
-	struct mxt_data *data = dev_id;
 	struct mxt_message message;
 	const u8 *payload = &message.message[0];
 	struct device *dev = &data->client->dev;
@@ -587,7 +591,7 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 	do {
 		if (mxt_read_message(data, &message)) {
 			dev_err(dev, "Failed to read message\n");
-			goto end;
+			return IRQ_NONE;
 		}
 
 		reportid = message.reportid;
@@ -595,9 +599,9 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 
 		if (reportid == data->T6_reportid) {
 			u8 status = payload[0];
-			unsigned csum = mxt_extract_T6_csum(&payload[1]);
+			data->config_crc = mxt_extract_T6_csum(&payload[1]);
 			dev_dbg(dev, "Status: %02x Config Checksum: %06x\n",
-				status, csum);
+				status, data->config_crc);
 			handled = true;
 		} else if (mxt_is_T9_message(data, &message)) {
 			int id = reportid - data->T9_reportid_min;
@@ -615,10 +619,16 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 		input_sync(data->input_dev);
 	}
 
-end:
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t mxt_interrupt(int irq, void *dev_id)
+{
+	struct mxt_data *data = dev_id;
+
+	return mxt_process_messages_until_invalid(data);
+}
+
 static int mxt_t6_command(struct mxt_data *data, u16 cmd_offset, u8 value, bool wait)
 {
 	u16 reg;
@@ -679,6 +689,19 @@ static int mxt_soft_reset(struct mxt_data *data, u8 value)
 	return 0;
 }
 
+static void mxt_read_current_crc(struct mxt_data *data)
+{
+	/* on failure, CRC is set to 0 and config will always be downloaded */
+	data->config_crc = 0;
+
+	mxt_t6_command(data, MXT_COMMAND_REPORTALL, 1, true);
+
+	/* Read all messages until invalid, this will update the config crc
+	 * stored in mxt_data. On failure, CRC is set to 0 and config will
+	 * always be downloaded */
+	mxt_process_messages_until_invalid(data);
+}
+
 static int mxt_check_reg_init(struct mxt_data *data)
 {
 	const struct mxt_platform_data *pdata = data->pdata;
@@ -693,6 +716,16 @@ static int mxt_check_reg_init(struct mxt_data *data)
 		return 0;
 	}
 
+	mxt_read_current_crc(data);
+
+	if (data->config_crc == pdata->config_crc) {
+		dev_info(dev, "Config CRC 0x%06X: OK\n", data->config_crc);
+		return 0;
+	} else {
+		dev_info(dev, "Config CRC 0x%06X: does not match 0x%06X\n",
+				data->config_crc, pdata->config_crc);
+	}
+
 	for (i = 0; i < data->info.object_num; i++) {
 		object = data->object_table + i;
 
@@ -712,6 +745,16 @@ static int mxt_check_reg_init(struct mxt_data *data)
 		index += size;
 	}
 
+	ret = mxt_t6_command(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE, false);
+	if (ret)
+		return ret;
+
+	ret = mxt_soft_reset(data, MXT_RESET_VALUE);
+	if (ret)
+		return ret;
+
+	dev_info(dev, "Config written\n");
+
 	return 0;
 }
 
@@ -855,10 +898,6 @@ static int mxt_initialize(struct mxt_data *data)
 		return error;
 	}
 
-	error = mxt_t6_command(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE, false);
-	if (!error)
-		mxt_soft_reset(data, MXT_RESET_VALUE);
-
 	/* Update matrix size at info struct */
 	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, &val);
 	if (error)
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index 6a879a6..1d5a664 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -29,6 +29,7 @@
 struct mxt_platform_data {
 	const u8 *config;
 	size_t config_length;
+	u32 config_crc;
 
 	unsigned int x_size;
 	unsigned int y_size;
-- 
1.7.10.4

