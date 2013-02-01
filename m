Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab3BAIOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:14:00 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36156 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab3BAIM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:12:27 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 07/10] Input: atmel_mxt_ts - refactor bootloader entry/exit
Date: Fri,  1 Feb 2013 16:11:49 +0800
Message-Id: <1359706312-24642-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
References: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benson Leung <bleung@chromium.org>

Refactor bootloading into a three parts:
 1) bl enter that only happens when device is not yet in bl.
    bl enter frees old driver state and switches to BL i2c addr.
 2) the actual fw_update
 3) bl exit that only happens if fw update is successful.
    bl exit switches to APP i2c addr and reloads object table and creates
    a new input device.

Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 128 +++++++++++++++++++++----------
 1 file changed, 87 insertions(+), 41 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index c74f5a5..be96be3 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -253,6 +253,11 @@ struct mxt_data {
 	u8 T9_reportid_max;
 };
 
+static void mxt_free_object_table(struct mxt_data *data);
+static int mxt_initialize(struct mxt_data *data);
+static int mxt_input_dev_create(struct mxt_data *data);
+static int mxt_make_highchg(struct mxt_data *data);
+
 static bool mxt_object_readable(unsigned int type)
 {
 	switch (type) {
@@ -402,6 +407,8 @@ recheck:
 
 	if (val != state) {
 		dev_err(&client->dev, "Unvalid bootloader mode state\n");
+		dev_err(&client->dev, "Invalid bootloader mode state %d, %d\n",
+			val, state);
 		return -EINVAL;
 	}
 
@@ -581,6 +588,81 @@ static bool mxt_is_T9_message(struct mxt_data *data, struct mxt_message *msg)
 	return (id >= data->T9_reportid_min && id <= data->T9_reportid_max);
 }
 
+static int mxt_enter_bl(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+	int ret;
+
+	if (mxt_in_bootloader(data))
+		return 0;
+
+	disable_irq(data->irq);
+
+	/* Change to the bootloader mode */
+	ret = mxt_write_object(data, MXT_GEN_COMMAND_T6,
+			       MXT_COMMAND_RESET, MXT_BOOT_VALUE);
+	if (ret) {
+		enable_irq(data->irq);
+		return ret;
+	}
+
+	/* Change to slave address of bootloader */
+	if (client->addr == MXT_APP_LOW)
+		client->addr = MXT_BOOT_LOW;
+	else
+		client->addr = MXT_BOOT_HIGH;
+
+	/* Free any driver state. It will get reinitialized after fw update. */
+	mxt_free_object_table(data);
+	if (data->input_dev) {
+		input_unregister_device(data->input_dev);
+		data->input_dev = NULL;
+	}
+
+	enable_irq(data->irq);
+	msleep(MXT_RESET_TIME);
+	return 0;
+}
+
+static void mxt_exit_bl(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+	struct device *dev = &client->dev;
+	int error;
+
+	if (!mxt_in_bootloader(data))
+		return;
+
+	disable_irq(data->irq);
+	/* Wait for reset */
+	msleep(MXT_FWRESET_TIME);
+
+	if (client->addr == MXT_BOOT_LOW)
+		client->addr = MXT_APP_LOW;
+	else
+		client->addr = MXT_APP_HIGH;
+
+	error = mxt_initialize(data);
+	if (error) {
+		dev_err(dev, "Failed to initialize on exit bl. error = %d\n",
+			error);
+		return;
+	}
+
+	error = mxt_input_dev_create(data);
+	if (error) {
+		dev_err(dev, "Create input dev failed after init. error = %d\n",
+			error);
+		return;
+	}
+
+	error = mxt_make_highchg(data);
+	if (error)
+		dev_err(dev, "Failed to clear CHG after init. error = %d\n",
+			error);
+	enable_irq(data->irq);
+}
+
 static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 {
 	struct mxt_data *data = dev_id;
@@ -984,28 +1066,10 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		return ret;
 	}
 
-	if (mxt_in_bootloader(data))
-		goto bootloader_ready;
-
-	/* Change to the bootloader mode */
-	ret = mxt_write_object(data, MXT_GEN_COMMAND_T6,
-			MXT_COMMAND_RESET, MXT_BOOT_VALUE);
-	if (ret)
+	ret = mxt_enter_bl(data);
+	if (ret) {
+		dev_err(dev, "Failed to reset to bootloader.\n");
 		goto out;
-	msleep(MXT_RESET_TIME);
-
-	/* Change to slave address of bootloader */
-	if (client->addr == MXT_APP_LOW)
-		client->addr = MXT_BOOT_LOW;
-	else
-		client->addr = MXT_BOOT_HIGH;
-
-bootloader_ready:
-	/* Free any driver state. It will get reinitialized after fw update. */
-	mxt_free_object_table(data);
-	if (data->input_dev) {
-		input_unregister_device(data->input_dev);
-		data->input_dev = NULL;
 	}
 
 	ret = mxt_check_bootloader(client, MXT_WAITING_BOOTLOAD_CMD);
@@ -1045,11 +1109,8 @@ bootloader_ready:
 		dev_dbg(dev, "Updated %d bytes / %zd bytes\n", pos, fw->size);
 	}
 
-	/* Change to slave address of application */
-	if (client->addr == MXT_BOOT_LOW)
-		client->addr = MXT_APP_LOW;
-	else
-		client->addr = MXT_APP_HIGH;
+	/* Device exits bl mode to app mode only if successful */
+	mxt_exit_bl(data);
 out:
 	release_firmware(fw);
 
@@ -1060,31 +1121,16 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t count)
 {
-	struct mxt_data *data = dev_get_drvdata(dev);
 	int error;
 
-	disable_irq(data->irq);
-
 	error = mxt_load_fw(dev, MXT_FW_NAME);
 	if (error) {
 		dev_err(dev, "The firmware update failed(%d)\n", error);
 		count = error;
 	} else {
 		dev_dbg(dev, "The firmware update succeeded\n");
-
-		/* Wait for reset */
-		msleep(MXT_FWRESET_TIME);
-
-		mxt_initialize(data);
-		mxt_input_dev_create(data);
 	}
 
-	enable_irq(data->irq);
-
-	error = mxt_make_highchg(data);
-	if (error)
-		return error;
-
 	return count;
 }
 
-- 
1.8.1

