Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3F0M7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:59:48 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:40495 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753457Ab3F0Mup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:45 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 27/51] Input: atmel_mxt_ts - Handle APP_CRC_FAIL on startup
Date: Thu, 27 Jun 2013 13:49:02 +0100
Message-Id: <1372337366-9286-28-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the bootloader fails to start the appmode image on the touch controller, it
stays in bootloader mode. It is possible to reflash a working firmware image
from this state.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   61 +++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 13 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 030ebc5..0c0df6c 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -410,6 +410,30 @@ static int mxt_lookup_bootloader_address(struct mxt_data *data)
 	return 0;
 }
 
+static int mxt_probe_bootloader(struct mxt_data *data)
+{
+	struct device *dev = &data->client->dev;
+	int ret;
+	u8 val;
+	bool crc_failure;
+
+	ret = mxt_lookup_bootloader_address(data);
+	if (ret)
+		return ret;
+
+	ret = mxt_bootloader_read(data, &val, 1);
+	if (ret)
+		return ret;
+
+	/* Check app crc fail mode */
+	crc_failure = (val & ~MXT_BOOT_STATUS_MASK) == MXT_APP_CRC_FAIL;
+
+	dev_err(dev, "Detected bootloader, status:%02X%s\n",
+			val, crc_failure ? ", APP_CRC_FAIL" : "");
+
+	return 0;
+}
+
 static u8 mxt_get_bootloader_version(struct mxt_data *data, u8 val)
 {
 	struct device *dev = &data->client->dev;
@@ -469,6 +493,7 @@ recheck:
 	switch (state) {
 	case MXT_WAITING_BOOTLOAD_CMD:
 	case MXT_WAITING_FRAME_DATA:
+	case MXT_APP_CRC_FAIL:
 		val &= ~MXT_BOOT_STATUS_MASK;
 		break;
 	case MXT_FRAME_CRC_PASS:
@@ -1378,8 +1403,14 @@ static int mxt_initialize(struct mxt_data *data)
 	int error;
 
 	error = mxt_get_info(data);
-	if (error)
-		return error;
+	if (error) {
+		error = mxt_probe_bootloader(data);
+		if (error)
+			return error;
+
+		data->in_bootloader = true;
+		return 0;
+	}
 
 	data->object_table = kcalloc(info->object_num,
 				     sizeof(struct mxt_object),
@@ -1561,15 +1592,19 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	if (ret)
 		goto release_firmware;
 
-	/* Change to the bootloader mode */
-	data->in_bootloader = true;
+	if (!data->in_bootloader) {
+		/* Change to the bootloader mode */
+		data->in_bootloader = true;
 
-	ret = mxt_t6_command(data, MXT_COMMAND_RESET, MXT_BOOT_VALUE, false);
-	if (ret)
-		goto release_firmware;
+		ret = mxt_t6_command(data, MXT_COMMAND_RESET,
+				     MXT_BOOT_VALUE, false);
+		if (ret)
+			goto release_firmware;
 
-	msleep(MXT_RESET_TIME);
+		msleep(MXT_RESET_TIME);
+	}
 
+	mxt_free_object_table(data);
 	INIT_COMPLETION(data->bl_completion);
 
 	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD);
@@ -1652,8 +1687,6 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	} else {
 		dev_info(dev, "The firmware update succeeded\n");
 
-		mxt_free_object_table(data);
-
 		error = mxt_initialize(data);
 		if (error)
 			return error;
@@ -1857,9 +1890,11 @@ static int mxt_probe(struct i2c_client *client,
 	if (error)
 		goto err_free_irq;
 
-	error = mxt_initialize_t9_input_device(data);
-	if (error)
-		goto err_free_object;
+	if (!data->in_bootloader) {
+		error = mxt_initialize_t9_input_device(data);
+		if (error)
+			goto err_free_object;
+	}
 
 	error = sysfs_create_group(&client->dev.kobj, &mxt_attr_group);
 	if (error) {
-- 
1.7.10.4

