Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbaGCPNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:13:20 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:26470 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758091AbaGCPNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:13:14 -0400
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
Subject: [PATCH 11/15] Input: atmel_mxt_ts - recover from bootloader on probe
Date: Thu,  3 Jul 2014 16:01:33 +0100
Message-Id: <1404399697-26484-12-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Dyer <nick.dyer@itdev.co.uk>

The MXT device may be in bootloader mode on probe, due to:
1) APP CRC failure, either:
  a) flash corruption
  b) bad power or other intermittent problem while checking CRC
2) If the device has been reset 10 or more times without accessing comms
3) Warm probe, device was in bootloader mode already

This code attempts to recover from 1(b) and 3.

There is an additional complexity: we have to try two possible bootloader
addresses because the mapping is not one-to-one and we don't know the exact
model yet.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Yufeng Shen <miletus@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 67 ++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 17 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 5fe3285..8bcf21c 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -383,7 +383,7 @@ static int mxt_bootloader_write(struct mxt_data *data,
 	return ret;
 }
 
-static int mxt_lookup_bootloader_address(struct mxt_data *data)
+static int mxt_lookup_bootloader_address(struct mxt_data *data, bool retry)
 {
 	u8 appmode = data->client->addr;
 	u8 bootloader;
@@ -392,7 +392,7 @@ static int mxt_lookup_bootloader_address(struct mxt_data *data)
 	case 0x4a:
 	case 0x4b:
 		/* Chips after 1664S use different scheme */
-		if (data->info.family_id >= 0xa2) {
+		if (retry || data->info.family_id >= 0xa2) {
 			bootloader = appmode - 0x24;
 			break;
 		}
@@ -414,14 +414,14 @@ static int mxt_lookup_bootloader_address(struct mxt_data *data)
 	return 0;
 }
 
-static int mxt_probe_bootloader(struct mxt_data *data)
+static int mxt_probe_bootloader(struct mxt_data *data, bool retry)
 {
 	struct device *dev = &data->client->dev;
 	int ret;
 	u8 val;
 	bool crc_failure;
 
-	ret = mxt_lookup_bootloader_address(data);
+	ret = mxt_lookup_bootloader_address(data, retry);
 	if (ret)
 		return ret;
 
@@ -522,13 +522,18 @@ recheck:
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
 	if (ret)
@@ -1525,15 +1530,40 @@ static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
 	int error;
+	bool alt_bootloader_addr = false;
+	bool retry = false;
 
+retry_info:
 	error = mxt_get_info(data);
 	if (error) {
-		error = mxt_probe_bootloader(data);
-		if (error)
-			return error;
+retry_bootloader:
+		error = mxt_probe_bootloader(data, alt_bootloader_addr);
+		if (error) {
+			if (alt_bootloader_addr) {
+				/* Chip is not in appmode or bootloader mode */
+				return error;
+			}
 
-		data->in_bootloader = true;
-		return 0;
+			dev_info(&client->dev, "Trying alternate bootloader address\n");
+			alt_bootloader_addr = true;
+			goto retry_bootloader;
+		} else {
+			if (retry) {
+				dev_err(&client->dev, "Could not recover from bootloader mode\n");
+				/*
+				 * We can reflash from this state, so do not
+				 * abort init
+				 */
+				data->in_bootloader = true;
+				return 0;
+			}
+
+			/* Attempt to exit bootloader into app mode */
+			mxt_send_bootloader_cmd(data, false);
+			msleep(MXT_FW_RESET_TIME);
+			retry = true;
+			goto retry_info;
+		}
 	}
 
 	/* Get object table information */
@@ -1714,10 +1744,6 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	if (ret)
 		goto release_firmware;
 
-	ret = mxt_lookup_bootloader_address(data);
-	if (ret)
-		goto release_firmware;
-
 	if (!data->in_bootloader) {
 		/* Change to the bootloader mode */
 		data->in_bootloader = true;
@@ -1728,6 +1754,13 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 			goto release_firmware;
 
 		msleep(MXT_RESET_TIME);
+
+		/* Do not need to scan since we know family ID */
+		ret = mxt_lookup_bootloader_address(data, 0);
+		if (ret)
+			goto release_firmware;
+	} else {
+		enable_irq(data->irq);
 	}
 
 	mxt_free_object_table(data);
@@ -1743,7 +1776,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		dev_info(dev, "Unlocking bootloader\n");
 
 		/* Unlock bootloader */
-		ret = mxt_unlock_bootloader(data);
+		ret = mxt_send_bootloader_cmd(data, true);
 		if (ret)
 			goto disable_irq;
 	}
-- 
2.0.1

