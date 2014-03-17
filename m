Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbaCQRed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:34:33 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:18656 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756277AbaCQRdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:33:31 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 08/22] Input: atmel_mxt_ts - make wait-after-reset period compatible with all chips
Date: Mon, 17 Mar 2014 17:26:41 +0000
Message-Id: <1395077215-10922-9-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1395077215-10922-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iiro Valkonen <iiro.valkonen@atmel.com>

The delay before the chip can be accessed after reset varies between
different chips in maXTouch family. Waiting for an interrupt and a T6
status message with the RESET bit set is a better behaviour.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 109 ++++++++++++++++++++++++-------
 1 file changed, 87 insertions(+), 22 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index d5b3043..d3aef87 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -87,6 +87,9 @@
 #define MXT_COMMAND_REPORTALL	3
 #define MXT_COMMAND_DIAGNOSTIC	5
 
+/* Define for T6 status byte */
+#define MXT_T6_STATUS_RESET	(1 << 7)
+
 /* MXT_GEN_POWER_T7 field */
 #define MXT_POWER_IDLEACQINT	0
 #define MXT_POWER_ACTVACQINT	1
@@ -178,9 +181,13 @@
 
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
 
@@ -255,12 +262,16 @@ struct mxt_data {
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
+	u16 T6_address;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 	u8 T19_reportid;
 
 	/* for fw update in bootloader */
 	struct completion bl_completion;
+
+	/* for reset handling */
+	struct completion reset_completion;
 };
 
 static size_t mxt_obj_size(const struct mxt_object *obj)
@@ -344,10 +355,11 @@ static void mxt_dump_message(struct device *dev,
 		message->reportid, 7, message->message);
 }
 
-static int mxt_wait_for_chg(struct mxt_data *data, unsigned int timeout_ms)
+static int mxt_wait_for_completion(struct mxt_data *data,
+				   struct completion *comp,
+				   unsigned int timeout_ms)
 {
 	struct device *dev = &data->client->dev;
-	struct completion *comp = &data->bl_completion;
 	unsigned long timeout = msecs_to_jiffies(timeout_ms);
 	long ret;
 
@@ -375,7 +387,8 @@ recheck:
 		 * CHG assertion before reading the status byte.
 		 * Once the status byte has been read, the line is deasserted.
 		 */
-		ret = mxt_wait_for_chg(data, MXT_FW_CHG_TIMEOUT);
+		ret = mxt_wait_for_completion(data, &data->bl_completion,
+					      MXT_FW_CHG_TIMEOUT);
 		if (ret) {
 			/*
 			 * TODO: handle -ERESTARTSYS better by terminating
@@ -654,6 +667,9 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 			unsigned csum = mxt_extract_T6_csum(&payload[1]);
 			dev_dbg(dev, "Status: %02x Config Checksum: %06x\n",
 				status, csum);
+
+			if (status & MXT_T6_STATUS_RESET)
+				complete(&data->reset_completion);
 		} else if (mxt_is_T9_message(data, &message)) {
 			int id = reportid - data->T9_reportid_min;
 			mxt_input_touchevent(data, &message, id);
@@ -687,6 +703,59 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
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
+	} while (command_register != 0 && timeout_counter++ <= 100);
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
+	reinit_completion(&data->reset_completion);
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
@@ -800,6 +869,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 		switch (object->type) {
 		case MXT_GEN_COMMAND_T6:
 			data->T6_reportid = min_id;
+			data->T6_address = object->start_address;
 			break;
 		case MXT_TOUCH_MULTI_T9:
 			data->T9_reportid_min = min_id;
@@ -853,16 +923,10 @@ static int mxt_initialize(struct mxt_data *data)
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
@@ -1004,8 +1068,10 @@ static int mxt_load_fw(struct device *dev, const char *fn)
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
@@ -1048,7 +1114,8 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	}
 
 	/* Wait for flash. */
-	ret = mxt_wait_for_chg(data, MXT_FW_RESET_TIME);
+	ret = mxt_wait_for_completion(data, &data->bl_completion,
+				      MXT_FW_RESET_TIME);
 	if (ret)
 		goto disable_irq;
 
@@ -1057,12 +1124,13 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	 * the CHG line after bootloading has finished, so ignore potential
 	 * errors.
 	 */
-	mxt_wait_for_chg(data, MXT_FW_RESET_TIME);
+	mxt_wait_for_completion(data, &data->bl_completion, MXT_FW_RESET_TIME);
 
 	data->in_bootloader = false;
 
 disable_irq:
 	disable_irq(data->irq);
+release_firmware:
 	release_firmware(fw);
 
 	/* Change to slave address of application */
@@ -1187,6 +1255,7 @@ static int mxt_probe(struct i2c_client *client,
 	data->irq = client->irq;
 
 	init_completion(&data->bl_completion);
+	init_completion(&data->reset_completion);
 
 	mxt_calc_resolution(data);
 
@@ -1314,11 +1383,7 @@ static int mxt_resume(struct device *dev)
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
1.8.3.2

