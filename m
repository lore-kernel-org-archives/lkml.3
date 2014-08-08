Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491AbaHHP6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:58:14 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:42207 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755887AbaHHP6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:58:11 -0400
From: nick.dyer@itdev.co.uk
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 1/2] Input: atmel_mxt_ts - simplify mxt_initialize a bit
Date: Fri,  8 Aug 2014 16:58:02 +0100
Message-Id: <1407513483-30050-2-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407513483-30050-1-git-send-email-nick.dyer@itdev.co.uk>
References: <20140807165932.GA23198@core.coreip.homeip.net>
 <1407513483-30050-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

I think having control flow with 2 goto/labels/flags is quite hard to read,
this version is a bit more readable IMO.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 81 +++++++++++++++++---------------
 1 file changed, 42 insertions(+), 39 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index d50c614..a5f943d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -359,7 +359,6 @@ static int mxt_bootloader_read(struct mxt_data *data,
 	msg.buf = val;
 
 	ret = i2c_transfer(data->client->adapter, &msg, 1);
-
 	if (ret == 1) {
 		ret = 0;
 	} else {
@@ -414,6 +413,7 @@ static int mxt_lookup_bootloader_address(struct mxt_data *data, bool retry)
 	case 0x5b:
 		bootloader = appmode - 0x26;
 		break;
+
 	default:
 		dev_err(&data->client->dev,
 			"Appmode i2c address 0x%02x not found\n",
@@ -425,20 +425,20 @@ static int mxt_lookup_bootloader_address(struct mxt_data *data, bool retry)
 	return 0;
 }
 
-static int mxt_probe_bootloader(struct mxt_data *data, bool retry)
+static int mxt_probe_bootloader(struct mxt_data *data, bool alt_address)
 {
 	struct device *dev = &data->client->dev;
-	int ret;
+	int error;
 	u8 val;
 	bool crc_failure;
 
-	ret = mxt_lookup_bootloader_address(data, retry);
-	if (ret)
-		return ret;
+	error = mxt_lookup_bootloader_address(data, alt_address);
+	if (error)
+		return error;
 
-	ret = mxt_bootloader_read(data, &val, 1);
-	if (ret)
-		return ret;
+	error = mxt_bootloader_read(data, &val, 1);
+	if (error)
+		return error;
 
 	/* Check app crc fail mode */
 	crc_failure = (val & ~MXT_BOOT_STATUS_MASK) == MXT_APP_CRC_FAIL;
@@ -1645,41 +1645,39 @@ static void mxt_config_cb(const struct firmware *cfg, void *ctx)
 static int mxt_initialize(struct mxt_data *data)
 {
 	struct i2c_client *client = data->client;
+	int recovery_attempts = 0;
 	int error;
-	bool alt_bootloader_addr = false;
-	bool retry = false;
 
-retry_info:
-	error = mxt_get_info(data);
-	if (error) {
-retry_bootloader:
-		error = mxt_probe_bootloader(data, alt_bootloader_addr);
+	while (1) {
+		error = mxt_get_info(data);
+		if (!error)
+			break;
+
+		/* Check bootloader state */
+		error = mxt_probe_bootloader(data, false);
 		if (error) {
-			if (alt_bootloader_addr) {
+			dev_info(&client->dev, "Trying alternate bootloader address\n");
+			error = mxt_probe_bootloader(data, true);
+			if (error) {
 				/* Chip is not in appmode or bootloader mode */
 				return error;
 			}
+		}
 
-			dev_info(&client->dev, "Trying alternate bootloader address\n");
-			alt_bootloader_addr = true;
-			goto retry_bootloader;
-		} else {
-			if (retry) {
-				dev_err(&client->dev, "Could not recover from bootloader mode\n");
-				/*
-				 * We can reflash from this state, so do not
-				 * abort init
-				 */
-				data->in_bootloader = true;
-				return 0;
-			}
-
-			/* Attempt to exit bootloader into app mode */
-			mxt_send_bootloader_cmd(data, false);
-			msleep(MXT_FW_RESET_TIME);
-			retry = true;
-			goto retry_info;
+		/* OK, we are in bootloader, see if we can recover */
+		if (++recovery_attempts > 1) {
+			dev_err(&client->dev, "Could not recover from bootloader mode\n");
+			/*
+			 * We can reflash from this state, so do not
+			 * abort initialization.
+			 */
+			data->in_bootloader = true;
+			return 0;
 		}
+
+		/* Attempt to exit bootloader into app mode */
+		mxt_send_bootloader_cmd(data, false);
+		msleep(MXT_FW_RESET_TIME);
 	}
 
 	/* Get object table information */
@@ -1693,9 +1691,14 @@ retry_bootloader:
 	if (error)
 		goto err_free_object_table;
 
-	request_firmware_nowait(THIS_MODULE, true, MXT_CFG_NAME,
-				&data->client->dev, GFP_KERNEL, data,
-				mxt_config_cb);
+	error = request_firmware_nowait(THIS_MODULE, true, MXT_CFG_NAME,
+					&client->dev, GFP_KERNEL, data,
+					mxt_config_cb);
+	if (error) {
+		dev_err(&client->dev, "Failed to invoke firmware loader: %d\n",
+			error);
+		goto err_free_object_table;
+	}
 
 	return 0;
 
-- 
1.9.1

