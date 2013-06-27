Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab3F0NE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:04:59 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:40495 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752264Ab3F0Muh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:37 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 11/51] Input: atmel_mxt_ts - Implement CRC check for configuration data
Date: Thu, 27 Jun 2013 13:48:46 +0100
Message-Id: <1372337366-9286-12-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The configuration is stored in NVRAM on the maXTouch chip. When the device is
reset it reports a CRC of the stored configuration values. Therefore it isn't
necessary to send the configuration on each probe - we can check the CRC
matches and avoid a timeconsuming backup/reset cycle.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   55 +++++++++++++++++++++++++-----
 include/linux/i2c/atmel_mxt_ts.h         |    1 +
 2 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 471bc4d..ad9fc91 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -189,6 +189,7 @@
 #define MXT_BACKUP_TIME		50	/* msec */
 #define MXT_RESET_TIME		200	/* msec */
 #define MXT_RESET_TIMEOUT	3000	/* msec */
+#define MXT_CRC_TIMEOUT		1000	/* msec */
 #define MXT_FW_RESET_TIME	3000	/* msec */
 #define MXT_FW_CHG_TIMEOUT	300	/* msec */
 
@@ -260,6 +261,7 @@ struct mxt_data {
 	unsigned int max_x;
 	unsigned int max_y;
 	bool in_bootloader;
+	u32 config_crc;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
@@ -274,6 +276,9 @@ struct mxt_data {
 	/* for reset handling */
 	struct completion reset_completion;
 
+	/* for reset handling */
+	struct completion crc_completion;
+
 	/* Enable reporting of input events */
 	bool enable_reporting;
 };
@@ -648,7 +653,7 @@ static void mxt_input_touchevent(struct mxt_data *data,
 	}
 }
 
-static unsigned mxt_extract_T6_csum(const u8 *csum)
+static u16 mxt_extract_T6_csum(const u8 *csum)
 {
 	return csum[0] | (csum[1] << 8) | (csum[2] << 16);
 }
@@ -666,6 +671,7 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 	struct device *dev = &data->client->dev;
 	u8 reportid;
 	bool update_input = false;
+	u32 crc;
 
 	do {
 		if (mxt_read_message(data, &message)) {
@@ -677,9 +683,15 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 
 		if (reportid == data->T6_reportid) {
 			u8 status = payload[0];
-			unsigned csum = mxt_extract_T6_csum(&payload[1]);
+
+			crc = mxt_extract_T6_csum(&payload[1]);
+			if (crc != data->config_crc) {
+				data->config_crc = crc;
+				complete(&data->crc_completion);
+			}
+
 			dev_dbg(dev, "Status: %02x Config Checksum: %06x\n",
-				status, csum);
+				status, data->config_crc);
 
 			if (status & MXT_T6_STATUS_RESET)
 				complete(&data->reset_completion);
@@ -772,6 +784,19 @@ static int mxt_soft_reset(struct mxt_data *data)
 	return 0;
 }
 
+static void mxt_update_crc(struct mxt_data *data, u8 cmd, u8 value)
+{
+	/* on failure, CRC is set to 0 and config will always be downloaded */
+	data->config_crc = 0;
+	INIT_COMPLETION(data->crc_completion);
+
+	mxt_t6_command(data, cmd, value, true);
+
+	/* Wait for crc message. On failure, CRC is set to 0 and config will
+	 * always be downloaded */
+	mxt_wait_for_completion(data, &data->crc_completion, MXT_CRC_TIMEOUT);
+}
+
 static int mxt_check_reg_init(struct mxt_data *data)
 {
 	const struct mxt_platform_data *pdata = data->pdata;
@@ -786,6 +811,16 @@ static int mxt_check_reg_init(struct mxt_data *data)
 		return 0;
 	}
 
+	mxt_update_crc(data, MXT_COMMAND_REPORTALL, 1);
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
 
@@ -805,6 +840,14 @@ static int mxt_check_reg_init(struct mxt_data *data)
 		index += size;
 	}
 
+	mxt_update_crc(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE);
+
+	ret = mxt_soft_reset(data);
+	if (ret)
+		return ret;
+
+	dev_info(dev, "Config written\n");
+
 	return 0;
 }
 
@@ -962,11 +1005,6 @@ static int mxt_initialize(struct mxt_data *data)
 		goto err_free_object_table;
 	}
 
-	error = mxt_t6_command(data, MXT_COMMAND_BACKUPNV,
-			       MXT_BACKUP_VALUE, false);
-	if (!error)
-		mxt_soft_reset(data);
-
 	/* Update matrix size at info struct */
 	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, &val);
 	if (error)
@@ -1292,6 +1330,7 @@ static int mxt_probe(struct i2c_client *client,
 
 	init_completion(&data->bl_completion);
 	init_completion(&data->reset_completion);
+	init_completion(&data->crc_completion);
 
 	mxt_calc_resolution(data);
 
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index d26080d..9f92135 100644
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

