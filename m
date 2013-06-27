Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937Ab3F0NII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:08:08 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:12379 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752791Ab3F0Muf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:35 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 06/51] Input: atmel_mxt_ts - wait for CHG assert in mxt_check_bootloader
Date: Thu, 27 Jun 2013 13:48:41 +0100
Message-Id: <1372337366-9286-7-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benson Leung <bleung@chromium.org>

The driver should not immediately read bootloader status when
in Application Update Mode. The CHG line will assert when the device
has made a state transition and is ready to report a new status
via i2c.

This change adds a wait for completion in mxt_check_bootloader,
and changes the mxt_interrupt handler to signal the completion.

Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  102 ++++++++++++++++++++++++------
 1 file changed, 81 insertions(+), 21 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 7de3b47..3f75e8c 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -15,6 +15,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
@@ -247,16 +248,19 @@ struct mxt_data {
 	const struct mxt_platform_data *pdata;
 	struct mxt_object *object_table;
 	struct mxt_info info;
-
 	unsigned int irq;
 	unsigned int max_x;
 	unsigned int max_y;
+	bool in_bootloader;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 	u8 T19_reportid;
+
+	/* for fw update in bootloader */
+	struct completion bl_completion;
 };
 
 static inline size_t mxt_obj_size(const struct mxt_object *obj)
@@ -340,12 +344,51 @@ static void mxt_dump_message(struct device *dev,
 		message->reportid, 7, message->message);
 }
 
-static int mxt_check_bootloader(struct i2c_client *client,
-				     unsigned int state)
+static int mxt_wait_for_chg(struct mxt_data *data, unsigned int timeout_ms)
+{
+	struct device *dev = &data->client->dev;
+	struct completion *comp = &data->bl_completion;
+	unsigned long timeout = msecs_to_jiffies(timeout_ms);
+	long ret;
+
+	ret = wait_for_completion_interruptible_timeout(comp, timeout);
+	if (ret < 0) {
+		dev_err(dev, "Wait for completion interrupted.\n");
+		return -EINTR;
+	} else if (ret == 0) {
+		dev_err(dev, "Wait for completion timed out.\n");
+		return -ETIMEDOUT;
+	}
+	return 0;
+}
+
+static int mxt_check_bootloader(struct mxt_data *data, unsigned int state)
 {
+	struct i2c_client *client = data->client;
 	u8 val;
+	int ret;
 
 recheck:
+	if (state != MXT_WAITING_BOOTLOAD_CMD) {
+		/*
+		 * In application update mode, the interrupt
+		 * line signals state transitions. We must wait for the
+		 * CHG assertion before reading the status byte.
+		 * Once the status byte has been read, the line is deasserted.
+		 */
+		ret = mxt_wait_for_chg(data, 300);
+		if (ret) {
+			/*
+			 * TODO: handle -EINTR better by terminating fw update
+			 * process before returning to userspace by writing
+			 * length 0x000 to device (iff we are in
+			 * WAITING_FRAME_DATA state).
+			 */
+			dev_err(&client->dev, "Update wait error %d\n", ret);
+			return ret;
+		}
+	}
+
 	if (i2c_master_recv(client, &val, 1) != 1) {
 		dev_err(&client->dev, "%s: i2c recv failed\n", __func__);
 		return -EIO;
@@ -591,9 +634,8 @@ static bool mxt_is_T9_message(struct mxt_data *data, struct mxt_message *msg)
 	return (id >= data->T9_reportid_min && id <= data->T9_reportid_max);
 }
 
-static irqreturn_t mxt_interrupt(int irq, void *dev_id)
+static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
 {
-	struct mxt_data *data = dev_id;
 	struct mxt_message message;
 	const u8 *payload = &message.message[0];
 	struct device *dev = &data->client->dev;
@@ -633,6 +675,19 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t mxt_interrupt(int irq, void *dev_id)
+{
+	struct mxt_data *data = dev_id;
+
+	if (data->in_bootloader) {
+		/* bootloader state transition completion */
+		complete(&data->bl_completion);
+		return IRQ_HANDLED;
+	}
+
+	return mxt_process_messages_until_invalid(data);
+}
+
 static int mxt_check_reg_init(struct mxt_data *data)
 {
 	const struct mxt_platform_data *pdata = data->pdata;
@@ -948,6 +1003,8 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	}
 
 	/* Change to the bootloader mode */
+	data->in_bootloader = true;
+
 	mxt_write_object(data, MXT_GEN_COMMAND_T6,
 			MXT_COMMAND_RESET, MXT_BOOT_VALUE);
 	msleep(MXT_RESET_TIME);
@@ -958,18 +1015,19 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	else
 		client->addr = MXT_BOOT_HIGH;
 
-	ret = mxt_check_bootloader(client, MXT_WAITING_BOOTLOAD_CMD);
+	INIT_COMPLETION(data->bl_completion);
+
+	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD);
 	if (ret)
-		goto out;
+		goto disable_irq;
 
 	/* Unlock bootloader */
 	mxt_unlock_bootloader(client);
 
 	while (pos < fw->size) {
-		ret = mxt_check_bootloader(client,
-						MXT_WAITING_FRAME_DATA);
+		ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA);
 		if (ret)
-			goto out;
+			goto disable_irq;
 
 		frame_size = ((*(fw->data + pos) << 8) | *(fw->data + pos + 1));
 
@@ -981,17 +1039,19 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		/* Write one frame to device */
 		mxt_fw_write(client, fw->data + pos, frame_size);
 
-		ret = mxt_check_bootloader(client,
-						MXT_FRAME_CRC_PASS);
+		ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS);
 		if (ret)
-			goto out;
+			goto disable_irq;
 
 		pos += frame_size;
 
 		dev_dbg(dev, "Updated %d bytes / %zd bytes\n", pos, fw->size);
 	}
 
-out:
+	data->in_bootloader = false;
+
+disable_irq:
+	disable_irq(data->irq);
 	release_firmware(fw);
 
 	/* Change to slave address of application */
@@ -1010,8 +1070,6 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	struct mxt_data *data = dev_get_drvdata(dev);
 	int error;
 
-	disable_irq(data->irq);
-
 	error = mxt_load_fw(dev, MXT_FW_NAME);
 	if (error) {
 		dev_err(dev, "The firmware update failed(%d)\n", error);
@@ -1025,13 +1083,13 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		mxt_free_object_table(data);
 
 		mxt_initialize(data);
-	}
 
-	enable_irq(data->irq);
+		enable_irq(data->irq);
 
-	error = mxt_make_highchg(data);
-	if (error)
-		return error;
+		error = mxt_make_highchg(data);
+		if (error)
+			return error;
+	}
 
 	return count;
 }
@@ -1121,6 +1179,8 @@ static int mxt_probe(struct i2c_client *client,
 	data->pdata = pdata;
 	data->irq = client->irq;
 
+	init_completion(&data->bl_completion);
+
 	mxt_calc_resolution(data);
 
 	error = mxt_initialize(data);
-- 
1.7.10.4

