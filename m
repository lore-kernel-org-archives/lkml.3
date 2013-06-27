Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3F0NGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:06:03 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:36964 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752907Ab3F0Muh (ORCPT
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
Subject: [PATCH 09/51] Input: atmel_mxt_ts - Make wait-after-reset period compatible with all chips
Date: Thu, 27 Jun 2013 13:48:44 +0100
Message-Id: <1372337366-9286-10-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iiro Valkonen <iiro.valkonen@atmel.com>

The delay before the chip can be accessed after reset varies between different
chips in maXTouch family. Waiting for an interrupt and a T6 status message
with the RESET bit set is a better behaviour.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  109 ++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 22 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 1e24e54..11ee78a 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -88,6 +88,9 @@
 #define MXT_COMMAND_REPORTALL	3
 #define MXT_COMMAND_DIAGNOSTIC	5
 
+/* Define for T6 status byte */
+#define MXT_T6_STATUS_RESET	(1 << 7)
+
 /* MXT_GEN_POWER_T7 field */
 #define MXT_POWER_IDLEACQINT	0
 #define MXT_POWER_ACTVACQINT	1
@@ -179,9 +182,13 @@
 
 /* Define for MXT_GEN_COMMAND_T6 */
 #define MXT_BOOT_VALUE		0xa5
+#define MXT_RESET_VALUE		0x01
 #define MXT_BACKUP_VALUE	0x55
+
+/* Delay times */
 #define MXT_BACKUP_TIME		50	/* msec */
 #define MXT_RESET_TIME		200	/* msec */
+#define MXT_RESET_TIMEOUT	3000	/* msec */
 #define MXT_FW_RESET_TIME	3000	/* msec */
 #define MXT_FW_CHG_TIMEOUT	300	/* msec */
 
@@ -256,6 +263,7 @@ struct mxt_data {
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
+	u16 T6_address;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 	u8 T19_reportid;
@@ -263,6 +271,9 @@ struct mxt_data {
 	/* for fw update in bootloader */
 	struct completion bl_completion;
 
+	/* for reset handling */
+	struct completion reset_completion;
+
 	/* Enable reporting of input events */
 	bool enable_reporting;
 };
@@ -348,10 +359,10 @@ static void mxt_dump_message(struct device *dev,
 		message->reportid, 7, message->message);
 }
 
-static int mxt_wait_for_chg(struct mxt_data *data, unsigned int timeout_ms)
+static int mxt_wait_for_completion(struct mxt_data *data,
+			struct completion *comp, unsigned int timeout_ms)
 {
 	struct device *dev = &data->client->dev;
-	struct completion *comp = &data->bl_completion;
 	unsigned long timeout = msecs_to_jiffies(timeout_ms);
 	long ret;
 
@@ -380,7 +391,8 @@ recheck:
 		 * CHG assertion before reading the status byte.
 		 * Once the status byte has been read, the line is deasserted.
 		 */
-		ret = mxt_wait_for_chg(data, MXT_FW_CHG_TIMEOUT);
+		ret = mxt_wait_for_completion(data, &data->bl_completion,
+					      MXT_FW_CHG_TIMEOUT);
 		if (ret) {
 			/*
 			 * TODO: handle -EINTR better by terminating fw update
@@ -667,6 +679,9 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 			unsigned csum = mxt_extract_T6_csum(&payload[1]);
 			dev_dbg(dev, "Status: %02x Config Checksum: %06x\n",
 				status, csum);
+
+			if (status & MXT_T6_STATUS_RESET)
+				complete(&data->reset_completion);
 		} else if (mxt_is_T9_message(data, &message)) {
 			int id = reportid - data->T9_reportid_min;
 			mxt_input_touchevent(data, &message, id);
@@ -703,6 +718,59 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 	return mxt_process_messages_until_invalid(data);
 }
 
+static int mxt_t6_command(struct mxt_data *data, u16 cmd_offset,
+			  u8 value, bool wait)
+{
+	u16 reg;
+	u8 command_register;
+	int timeout_counter = 0;
+	int ret;
+
+	reg = data->T6_address + cmd_offset;
+
+	ret = mxt_write_reg(data->client, reg, value);
+	if (ret)
+		return ret;
+
+	if (!wait)
+		return 0;
+
+	do {
+		msleep(20);
+		ret = __mxt_read_reg(data->client, reg, 1, &command_register);
+		if (ret)
+			return ret;
+	} while ((command_register != 0) && (timeout_counter++ <= 100));
+
+	if (timeout_counter > 100) {
+		dev_err(&data->client->dev, "Command failed!\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int mxt_soft_reset(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	int ret = 0;
+
+	dev_info(dev, "Resetting chip\n");
+
+	INIT_COMPLETION(data->reset_completion);
+
+	ret = mxt_t6_command(data, MXT_COMMAND_RESET, MXT_RESET_VALUE, false);
+	if (ret)
+		return ret;
+
+	ret = mxt_wait_for_completion(data, &data->reset_completion,
+				      MXT_RESET_TIMEOUT);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int mxt_check_reg_init(struct mxt_data *data)
 {
 	const struct mxt_platform_data *pdata = data->pdata;
@@ -829,6 +897,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 		switch (object->type) {
 		case MXT_GEN_COMMAND_T6:
 			data->T6_reportid = min_id;
+			data->T6_address = object->start_address;
 			break;
 		case MXT_TOUCH_MULTI_T9:
 			data->T9_reportid_min = min_id;
@@ -887,16 +956,10 @@ static int mxt_initialize(struct mxt_data *data)
 	if (error)
 		goto err_free_object_table;
 
-	/* Backup to memory */
-	mxt_write_object(data, MXT_GEN_COMMAND_T6,
-			MXT_COMMAND_BACKUPNV,
-			MXT_BACKUP_VALUE);
-	msleep(MXT_BACKUP_TIME);
-
-	/* Soft reset */
-	mxt_write_object(data, MXT_GEN_COMMAND_T6,
-			MXT_COMMAND_RESET, 1);
-	msleep(MXT_RESET_TIME);
+	error = mxt_t6_command(data, MXT_COMMAND_BACKUPNV,
+			       MXT_BACKUP_VALUE, false);
+	if (!error)
+		mxt_soft_reset(data);
 
 	/* Update matrix size at info struct */
 	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, &val);
@@ -1040,8 +1103,10 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	/* Change to the bootloader mode */
 	data->in_bootloader = true;
 
-	mxt_write_object(data, MXT_GEN_COMMAND_T6,
-			MXT_COMMAND_RESET, MXT_BOOT_VALUE);
+	ret = mxt_t6_command(data, MXT_COMMAND_RESET, MXT_BOOT_VALUE, false);
+	if (ret)
+		goto release_firmware;
+
 	msleep(MXT_RESET_TIME);
 
 	/* Change to slave address of bootloader */
@@ -1084,18 +1149,21 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	}
 
 	/* Wait for flash. */
-	ret = mxt_wait_for_chg(data, MXT_FW_RESET_TIME);
+	ret = mxt_wait_for_completion(data, &data->bl_completion,
+				MXT_FW_RESET_TIME);
 	if (ret)
 		goto disable_irq;
 
 	/* Wait for device to reset. Some bootloader versions do not assert
 	 * the CHG line after bootloading has finished, so ignore error */
-	mxt_wait_for_chg(data, MXT_FW_RESET_TIME);
+	mxt_wait_for_completion(data, &data->bl_completion,
+				MXT_FW_RESET_TIME);
 
 	data->in_bootloader = false;
 
 disable_irq:
 	disable_irq(data->irq);
+release_firmware:
 	release_firmware(fw);
 
 	/* Change to slave address of application */
@@ -1216,6 +1284,7 @@ static int mxt_probe(struct i2c_client *client,
 	data->irq = client->irq;
 
 	init_completion(&data->bl_completion);
+	init_completion(&data->reset_completion);
 
 	mxt_calc_resolution(data);
 
@@ -1341,11 +1410,7 @@ static int mxt_resume(struct device *dev)
 	struct mxt_data *data = i2c_get_clientdata(client);
 	struct input_dev *input_dev = data->input_dev;
 
-	/* Soft reset */
-	mxt_write_object(data, MXT_GEN_COMMAND_T6,
-			MXT_COMMAND_RESET, 1);
-
-	msleep(MXT_RESET_TIME);
+	mxt_soft_reset(data);
 
 	mutex_lock(&input_dev->mutex);
 
-- 
1.7.10.4

