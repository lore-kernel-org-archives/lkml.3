Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195Ab3BVSNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:13:39 -0500
Received: from [89.21.227.133] ([89.21.227.133]:7283 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759067Ab3BVSIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 13:08:35 -0500
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 38/40] Input: atmel_mxt_ts - Initialize power config before and after downloading cfg
Date: Fri, 22 Feb 2013 17:58:25 +0000
Message-Id: <1361555907-19840-39-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the power configuration is zero then the configuration download may fail to
work properly, so initialize T7 before config download. The downloaded
configuration may reset the T7 power configuration so it must be
re-initialized afterwards.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |   46 ++++++++++++++++--------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 870ad65..1c878fb 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -149,7 +149,7 @@ static unsigned long mxt_t15_keystatus;
 /* Delay times */
 #define MXT_BACKUP_TIME		25	/* msec */
 #define MXT_RESET_TIME		200	/* msec */
-#define MXT_RESET_NOCHGREAD	400	/* msec */
+#define MXT_RESET_NOCHGREAD	200	/* msec */
 #define MXT_FWRESET_TIME	1000	/* msec */
 #define MXT_WAKEUP_TIME		25	/* msec */
 
@@ -220,6 +220,7 @@ struct mxt_data {
 	u8 last_message_count;
 	u8 num_touchids;
 	u8 num_stylusids;
+	u8(*read_chg) (void);
 
 	/* Cached parameters from object table */
 	u16 T5_address;
@@ -377,17 +378,17 @@ static int mxt_probe_bootloader(struct mxt_data *data)
 	return 0;
 }
 
-static int mxt_wait_for_chg(struct mxt_data *data)
+static int mxt_wait_for_chg(struct mxt_data *data, int fallback_ms)
 {
 	int timeout_counter = 0;
 	int count = 1E6;
 
-	if (data->pdata->read_chg == NULL) {
-		msleep(20);
+	if (data->read_chg == NULL) {
+		msleep(fallback_ms);
 		return 0;
 	}
 
-	while ((timeout_counter++ <= count) && data->pdata->read_chg())
+	while ((timeout_counter++ <= count) && data->read_chg())
 		udelay(20);
 
 	if (timeout_counter > count) {
@@ -447,7 +448,7 @@ recheck:
 		break;
 	case MXT_FRAME_CRC_PASS:
 		if (val == MXT_FRAME_CRC_CHECK) {
-			mxt_wait_for_chg(data);
+			mxt_wait_for_chg(data, 20);
 			goto recheck;
 		} else if (val == MXT_FRAME_CRC_FAIL) {
 			dev_err(dev, "Bootloader CRC fail\n");
@@ -1050,12 +1051,9 @@ static int mxt_soft_reset(struct mxt_data *data, u8 value)
 	if (ret)
 		return ret;
 
-	if (data->pdata->read_chg == NULL) {
-		msleep(MXT_RESET_NOCHGREAD);
-	} else {
-		msleep(MXT_RESET_TIME);
-		mxt_wait_for_chg(data);
-	}
+	msleep(MXT_RESET_TIME);
+
+	mxt_wait_for_chg(data, MXT_RESET_NOCHGREAD);
 
 	return 0;
 }
@@ -1112,6 +1110,8 @@ static u32 mxt_calculate_crc(u8 *base, off_t start_off, off_t end_off)
 	return crc;
 }
 
+static int mxt_init_t7_power_cfg(struct mxt_data *data);
+
 static int mxt_check_reg_init(struct mxt_data *data)
 {
 	struct device *dev = &data->client->dev;
@@ -1334,6 +1334,9 @@ static int mxt_check_reg_init(struct mxt_data *data)
 
 	dev_info(dev, "Config written\n");
 
+	/* T7 config may have changed */
+	mxt_init_t7_power_cfg(data);
+
 release_mem:
 	kfree(config_mem);
 release:
@@ -1687,17 +1690,17 @@ retry_probe:
 
 	data->state = APPMODE;
 
-	/* Check register init values */
-	error = mxt_check_reg_init(data);
+	error = mxt_init_t7_power_cfg(data);
 	if (error) {
-		dev_err(&client->dev, "Error %d initialising configuration\n",
-			error);
+		dev_err(&client->dev, "Failed to initialize power cfg\n");
 		return error;
 	}
 
-	error = mxt_init_t7_power_cfg(data);
+	/* Check register init values */
+	error = mxt_check_reg_init(data);
 	if (error) {
-		dev_err(&client->dev, "Failed to initialize power cfg\n");
+		dev_err(&client->dev, "Error %d initialising configuration\n",
+			error);
 		return error;
 	}
 
@@ -1840,7 +1843,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 
 	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD);
 	if (ret) {
-		mxt_wait_for_chg(data);
+		mxt_wait_for_chg(data, 20);
 		/* Bootloader may still be unlocked from previous update
 		 * attempt */
 		ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA);
@@ -1860,7 +1863,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 	}
 
 	while (pos < fw->size) {
-		mxt_wait_for_chg(data);
+		mxt_wait_for_chg(data, 20);
 		ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA);
 		if (ret) {
 			data->state = FAILED;
@@ -1879,7 +1882,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 			goto release_firmware;
 		}
 
-		mxt_wait_for_chg(data);
+		mxt_wait_for_chg(data, 20);
 		ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS);
 		if (ret) {
 			retry++;
@@ -2219,6 +2222,7 @@ static int mxt_probe(struct i2c_client *client,
 
 	data->client = client;
 	data->pdata = pdata;
+	data->read_chg = pdata->read_chg;
 	data->irq = client->irq;
 	i2c_set_clientdata(client, data);
 
-- 
1.7.10.4

