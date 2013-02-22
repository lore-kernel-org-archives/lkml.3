Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3BVSMu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:12:50 -0500
Received: from [89.21.227.133] ([89.21.227.133]:40598 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759071Ab3BVSIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:36 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 30/40] Input: atmel_mxt_ts - recover from bootloader on probe
Date: Fri, 22 Feb 2013 17:58:17 +0000
Message-Id: <1361555907-19840-31-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MXT device may be in bootloader mode on probe, due to:
1) APP CRC failure, either:
  a) flash corruption
  b) bad power or other intermittent problem in checking CRC
2) If the device has been reset 10 or more times without accessing comms
3) Warm probe, device was in bootloader mode already

This code attempts to recover from 1(b) and 3.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   33 +++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 96c961e..02fce62 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -519,13 +519,18 @@ recheck:
 	return 0;
 }
 
-static int mxt_unlock_bootloader(struct mxt_data *data)
+static int mxt_send_bootloader_cmd(struct mxt_data *data, bool unlock)
 {
 	int ret;
 	u8 buf[2];
 
-	buf[0] = MXT_UNLOCK_CMD_LSB;
-	buf[1] = MXT_UNLOCK_CMD_MSB;
+	if (unlock) {
+		buf[0] = MXT_UNLOCK_CMD_LSB;
+		buf[1] = MXT_UNLOCK_CMD_MSB;
+	} else {
+		buf[0] = 0x01;
+		buf[1] = 0x01;
+	}
 
 	ret = mxt_bootloader_write(data, buf, 2);
 	if (ret) {
@@ -1601,16 +1606,30 @@ static int mxt_initialize(struct mxt_data *data)
 	struct i2c_client *client = data->client;
 	struct mxt_info *info = &data->info;
 	int error;
+	u8 retry_count = 0;
 
+retry_probe:
 	error = mxt_get_info(data);
 	if (error) {
 		error = mxt_probe_bootloader(data);
-
 		if (error) {
+			/* Chip is not in appmode or bootloader mode */
 			return error;
 		} else {
-			data->state = BOOTLOADER;
-			return 0;
+			if (++retry_count > 10) {
+				dev_err(&client->dev,
+					"Could not recover device from "
+					"bootloader mode\n");
+				data->state = BOOTLOADER;
+				/* this is not an error state, we can reflash
+				 * from here */
+				return 0;
+			}
+
+			/* Attempt to exit bootloader into app mode */
+			mxt_send_bootloader_cmd(data, false);
+			msleep(MXT_FWRESET_TIME);
+			goto retry_probe;
 		}
 	}
 
@@ -1807,7 +1826,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		dev_info(dev, "Unlocking bootloader\n");
 
 		/* Unlock bootloader */
-		ret = mxt_unlock_bootloader(data);
+		ret = mxt_send_bootloader_cmd(data, true);
 		if (ret) {
 			data->state = FAILED;
 			goto release_firmware;
-- 
1.7.10.4

