Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3BAIOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:14:30 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:49185 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3BAIMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:12:19 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 05/10] Input: atmel_mxt_ts - handle errors during fw update
Date: Fri,  1 Feb 2013 16:11:47 +0800
Message-Id: <1359706312-24642-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
References: <1359706312-24642-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are any (i2c) errors during fw update, abort the update, but
leave the i2c address assigned to the bootloader address.

Note that an error when trying to reset the device into the bootloader
will leave the i2c address assigned to the application address.

Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 6c2c712..76a25d3 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -988,8 +988,10 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		goto bootloader_ready;
 
 	/* Change to the bootloader mode */
-	mxt_write_object(data, MXT_GEN_COMMAND_T6,
+	ret = mxt_write_object(data, MXT_GEN_COMMAND_T6,
 			MXT_COMMAND_RESET, MXT_BOOT_VALUE);
+	if (ret)
+		goto out;
 	msleep(MXT_RESET_TIME);
 
 	/* Change to slave address of bootloader */
@@ -1004,7 +1006,9 @@ bootloader_ready:
 		goto out;
 
 	/* Unlock bootloader */
-	mxt_unlock_bootloader(client);
+	ret = mxt_unlock_bootloader(client);
+	if (ret)
+		goto out;
 
 	while (pos < fw->size) {
 		ret = mxt_check_bootloader(client,
@@ -1020,7 +1024,9 @@ bootloader_ready:
 		frame_size += 2;
 
 		/* Write one frame to device */
-		mxt_fw_write(client, fw->data + pos, frame_size);
+		ret = mxt_fw_write(client, fw->data + pos, frame_size);
+		if (ret)
+			goto out;
 
 		ret = mxt_check_bootloader(client,
 						MXT_FRAME_CRC_PASS);
@@ -1032,14 +1038,13 @@ bootloader_ready:
 		dev_dbg(dev, "Updated %d bytes / %zd bytes\n", pos, fw->size);
 	}
 
-out:
-	release_firmware(fw);
-
 	/* Change to slave address of application */
 	if (client->addr == MXT_BOOT_LOW)
 		client->addr = MXT_APP_LOW;
 	else
 		client->addr = MXT_APP_HIGH;
+out:
+	release_firmware(fw);
 
 	return ret;
 }
-- 
1.8.1

