Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab3BAIMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:12:39 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:56619 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab3BAIM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:12:29 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org
Subject: [PATCH 08/10] Input: atmel_mxt_ts - wait for CHG assert in mxt_check_bootloader
Date: Fri,  1 Feb 2013 16:11:50 +0800
Message-Id: <1359706312-24642-9-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
References: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
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
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 63 ++++++++++++++++++++++++++++----
 1 file changed, 55 insertions(+), 8 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index be96be3..d0f91ff 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
 #include <linux/i2c.h>
@@ -251,6 +252,9 @@ struct mxt_data {
 	u8 T6_reportid;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
+
+	/* for fw update in bootloader */
+	struct completion bl_completion;
 };
 
 static void mxt_free_object_table(struct mxt_data *data);
@@ -381,19 +385,58 @@ static int mxt_i2c_transfer(struct i2c_client *client, struct i2c_msg *msgs,
 	return ret;
 }
 
-static int mxt_check_bootloader(struct i2c_client *client,
-				     unsigned int state)
+static int mxt_wait_for_chg(struct mxt_data *data, unsigned int timeout_ms)
 {
+	struct device *dev = &data->client->dev;
+	struct completion *comp = &data->bl_completion;
+	unsigned long timeout = msecs_to_jiffies(timeout_ms);
+	long ret;
+
+	ret = wait_for_completion_interruptible_timeout(comp, timeout);
+	if (ret < 0) {
+		dev_err(dev, "Wait for completion interrupted.\n");
+		/*
+		 * TODO: handle -EINTR better by terminating fw update process
+		 * before returning to userspace by writing length 0x000 to
+		 * device (iff we are in WAITING_FRAME_DATA state).
+		 */
+		return -EINTR;
+	} else if (ret == 0) {
+		dev_err(dev, "Wait for completion timed out.\n");
+		return -ETIMEDOUT;
+	}
+	return 0;
+}
+
+static int mxt_check_bootloader(struct mxt_data *data, unsigned int state)
+{
+	struct i2c_client *client = data->client;
 	u8 val;
 	int ret;
 
 recheck:
+	if (state != MXT_WAITING_BOOTLOAD_CMD) {
+		/*
+		 * In application update mode, the interrupt
+		 * line signals state transitions. We must wait for the
+		 * CHG assertion before reading the status byte.
+		 * Once the status byte has been read, the line is deasserted.
+		 */
+		int ret = mxt_wait_for_chg(data, 300);
+		if (ret) {
+			dev_err(&client->dev, "Update wait error %d\n", ret);
+			return ret;
+		}
+	}
+
 	ret = mxt_i2c_recv(client, &val, 1);
 	if (ret)
 		return ret;
 
 	switch (state) {
 	case MXT_WAITING_BOOTLOAD_CMD:
+		dev_info(&client->dev, "bootloader version: %d\n",
+			 val & MXT_BOOT_STATUS_MASK);
 	case MXT_WAITING_FRAME_DATA:
 		val &= ~MXT_BOOT_STATUS_MASK;
 		break;
@@ -672,8 +715,11 @@ static irqreturn_t mxt_interrupt(int irq, void *dev_id)
 	u8 reportid;
 	bool update_input = false;
 
-	if (mxt_in_bootloader(data))
+	if (mxt_in_bootloader(data)) {
+		/* bootloader state transition completion */
+		complete(&data->bl_completion);
 		goto end;
+	}
 
 	do {
 		if (mxt_read_message(data, &message)) {
@@ -1072,18 +1118,18 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		goto out;
 	}
 
-	ret = mxt_check_bootloader(client, MXT_WAITING_BOOTLOAD_CMD);
+	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD);
 	if (ret)
 		goto out;
 
+	INIT_COMPLETION(data->bl_completion);
 	/* Unlock bootloader */
 	ret = mxt_unlock_bootloader(client);
 	if (ret)
 		goto out;
 
 	while (pos < fw->size) {
-		ret = mxt_check_bootloader(client,
-						MXT_WAITING_FRAME_DATA);
+		ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA);
 		if (ret)
 			goto out;
 
@@ -1099,8 +1145,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		if (ret)
 			goto out;
 
-		ret = mxt_check_bootloader(client,
-						MXT_FRAME_CRC_PASS);
+		ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS);
 		if (ret)
 			goto out;
 
@@ -1264,6 +1309,8 @@ static int __devinit mxt_probe(struct i2c_client *client,
 	data->pdata = pdata;
 	data->irq = client->irq;
 
+	init_completion(&data->bl_completion);
+
 	mxt_calc_resolution(data);
 
 	if (mxt_in_bootloader(data)) {
-- 
1.8.1

