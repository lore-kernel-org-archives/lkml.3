Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030AbaGCPKT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:10:19 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:46567 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758592AbaGCPIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:08:14 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 08/15] Input: atmel_mxt_ts - handle APP_CRC_FAIL on startup
Date: Thu,  3 Jul 2014 16:01:30 +0100
Message-Id: <1404399697-26484-9-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

If the bootloader on the touchscreen controller fails to initialise the
firmware image, it stays in bootloader mode and reports a failure. It is
possible to reflash a working firmware image from this state.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
Acked-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 53 ++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 9b0cccd..aa957d2 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -408,6 +408,30 @@ static int mxt_lookup_bootloader_address(struct mxt_data *data)
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
@@ -467,6 +491,7 @@ recheck:
 	switch (state) {
 	case MXT_WAITING_BOOTLOAD_CMD:
 	case MXT_WAITING_FRAME_DATA:
+	case MXT_APP_CRC_FAIL:
 		val &= ~MXT_BOOT_STATUS_MASK;
 		break;
 	case MXT_FRAME_CRC_PASS:
@@ -1495,8 +1520,14 @@ static int mxt_initialize(struct mxt_data *data)
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
 
 	/* Get object table information */
 	error = mxt_get_object_table(data);
@@ -1680,15 +1711,19 @@ static int mxt_load_fw(struct device *dev, const char *fn)
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
 	reinit_completion(&data->bl_completion);
 
 	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD);
@@ -1773,8 +1808,6 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 	} else {
 		dev_info(dev, "The firmware update succeeded\n");
 
-		mxt_free_object_table(data);
-
 		error = mxt_initialize(data);
 		if (error)
 			return error;
-- 
2.0.1

