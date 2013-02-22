Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab3BVSSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:18:08 -0500
Received: from [89.21.227.133] ([89.21.227.133]:7983 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758812Ab3BVSIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:30 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Iiro Valkonen <iiro.valkonen@atmel.com>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 01/40] Input: atmel_mxt_ts - Make wait-after-reset period compatible with all chips
Date: Fri, 22 Feb 2013 17:57:48 +0000
Message-Id: <1361555907-19840-2-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Iiro Valkonen <iiro.valkonen@atmel.com>

The delay before the chip can be accessed after reset varies between different
chips in maXTouch family. Waiting for 200ms and then monitoring the CHG (chip
is ready when the line is low) is guaranteed to work with all chips.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   91 ++++++++++++++++++++++++------
 include/linux/i2c/atmel_mxt_ts.h         |    1 +
 2 files changed, 76 insertions(+), 16 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index d04f810..b4bf946 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2,6 +2,7 @@
  * Atmel maXTouch Touchscreen driver
  *
  * Copyright (C) 2010 Samsung Electronics Co.Ltd
+ * Copyright (C) 2011 Atmel Corporation
  * Author: Joonyoung Shim <jy0922.shim@samsung.com>
  *
  * This program is free software; you can redistribute  it and/or modify it
@@ -175,11 +176,14 @@
 
 /* Define for MXT_GEN_COMMAND_T6 */
 #define MXT_BOOT_VALUE		0xa5
+#define MXT_RESET_VALUE		0x01
 #define MXT_BACKUP_VALUE	0x55
-#define MXT_BACKUP_TIME		25	/* msec */
-#define MXT_RESET_TIME		65	/* msec */
 
-#define MXT_FWRESET_TIME	175	/* msec */
+/* Delay times */
+#define MXT_BACKUP_TIME		25	/* msec */
+#define MXT_RESET_TIME		200	/* msec */
+#define MXT_RESET_NOCHGREAD	400	/* msec */
+#define MXT_FWRESET_TIME	1000	/* msec */
 
 /* Command to unlock bootloader */
 #define MXT_UNLOCK_CMD_MSB	0xaa
@@ -249,6 +253,7 @@ struct mxt_data {
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
+	u16 T6_address;
 	u8 T9_reportid_min;
 	u8 T9_reportid_max;
 };
@@ -599,6 +604,66 @@ end:
 	return IRQ_HANDLED;
 }
 
+static int mxt_t6_command(struct mxt_data *data, u16 cmd_offset, u8 value, bool wait)
+{
+	u16 reg;
+	u8 command_register;
+	int ret;
+	int timeout_counter = 0;
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
+static int mxt_soft_reset(struct mxt_data *data, u8 value)
+{
+	int ret;
+	int timeout_counter = 0;
+	struct device *dev = &data->client->dev;
+
+	dev_info(dev, "Resetting chip\n");
+
+	ret = mxt_t6_command(data, MXT_COMMAND_RESET, value, false);
+	if (ret)
+		return ret;
+
+	if (data->pdata->read_chg == NULL) {
+		msleep(MXT_RESET_NOCHGREAD);
+	} else {
+		msleep(MXT_RESET_TIME);
+
+		timeout_counter = 0;
+		while ((timeout_counter++ <= 100) && data->pdata->read_chg())
+			msleep(20);
+		if (timeout_counter > 100) {
+			dev_err(dev, "No response after reset!\n");
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
 static int mxt_check_reg_init(struct mxt_data *data)
 {
 	const struct mxt_platform_data *pdata = data->pdata;
@@ -759,6 +824,7 @@ static int mxt_get_object_table(struct mxt_data *data)
 		switch (object->type) {
 		case MXT_GEN_COMMAND_T6:
 			data->T6_reportid = min_id;
+			data->T6_address = object->start_address;
 			break;
 		case MXT_TOUCH_MULTI_T9:
 			data->T9_reportid_min = min_id;
@@ -811,16 +877,9 @@ static int mxt_initialize(struct mxt_data *data)
 
 	mxt_handle_pdata(data);
 
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
+	error = mxt_t6_command(data, MXT_COMMAND_BACKUPNV, MXT_BACKUP_VALUE, false);
+	if (!error)
+		mxt_soft_reset(data, MXT_RESET_VALUE);
 
 	/* Update matrix size at info struct */
 	error = mxt_read_reg(client, MXT_MATRIX_X_SIZE, &val);
@@ -960,9 +1019,9 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	}
 
 	/* Change to the bootloader mode */
-	mxt_write_object(data, MXT_GEN_COMMAND_T6,
-			MXT_COMMAND_RESET, MXT_BOOT_VALUE);
-	msleep(MXT_RESET_TIME);
+	ret = mxt_soft_reset(data, MXT_BOOT_VALUE);
+	if (ret)
+		return ret;
 
 	/* Change to slave address of bootloader */
 	if (client->addr == MXT_APP_LOW)
diff --git a/include/linux/i2c/atmel_mxt_ts.h b/include/linux/i2c/atmel_mxt_ts.h
index f027f7a..ef59c22 100644
--- a/include/linux/i2c/atmel_mxt_ts.h
+++ b/include/linux/i2c/atmel_mxt_ts.h
@@ -39,6 +39,7 @@ struct mxt_platform_data {
 	unsigned int voltage;
 	unsigned char orient;
 	unsigned long irqflags;
+	u8(*read_chg) (void);
 };
 
 #endif /* __LINUX_ATMEL_MXT_TS_H */
-- 
1.7.10.4

