Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab3EYPzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 11:55:08 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:35409 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab3EYPzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 11:55:06 -0400
From: Nikolay Balandin <n.a.balandin@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>, akpm@linux-foundation.org,
        devendra.aaru@gmail.com, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Subject: [PATCH 1/1] rtc: rtc-ds1307: use devm_*() functions
Date: Sat, 25 May 2013 08:54:28 -0700
Message-Id: <1369497268-10019-1-git-send-email-n.a.balandin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
---
 drivers/rtc/rtc-ds1307.c |   38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index b53992a..dbfb2a3 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -683,7 +683,9 @@ static int ds1307_probe(struct i2c_client *client,
 	    && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
-	ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL);
+	ds1307 = devm_kzalloc(&client->dev, sizeof(struct ds1307),
+						GFP_KERNEL);
+
 	if (!ds1307)
 		return -ENOMEM;
 
@@ -714,8 +716,7 @@ static int ds1307_probe(struct i2c_client *client,
 				DS1337_REG_CONTROL, 2, buf);
 		if (tmp != 2) {
 			dev_dbg(&client->dev, "read error %d\n", tmp);
-			err = -EIO;
-			goto exit_free;
+			return -EIO;
 		}
 
 		/* oscillator off?  turn it on, so clock can tick. */
@@ -753,8 +754,7 @@ static int ds1307_probe(struct i2c_client *client,
 				RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
 		if (tmp != 2) {
 			dev_dbg(&client->dev, "read error %d\n", tmp);
-			err = -EIO;
-			goto exit_free;
+			return -EIO;
 		}
 
 		/* oscillator off?  turn it on, so clock can tick. */
@@ -797,8 +797,7 @@ static int ds1307_probe(struct i2c_client *client,
 					RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
 			if (tmp != 2) {
 				dev_dbg(&client->dev, "read error %d\n", tmp);
-				err = -EIO;
-				goto exit_free;
+				return -EIO;
 			}
 
 			/* correct hour */
@@ -825,8 +824,7 @@ read_rtc:
 	tmp = ds1307->read_block_data(ds1307->client, ds1307->offset, 8, buf);
 	if (tmp != 8) {
 		dev_dbg(&client->dev, "read error %d\n", tmp);
-		err = -EIO;
-		goto exit_free;
+		return -EIO;
 	}
 
 	/*
@@ -867,8 +865,7 @@ read_rtc:
 		tmp = i2c_smbus_read_byte_data(client, DS1340_REG_FLAG);
 		if (tmp < 0) {
 			dev_dbg(&client->dev, "read error %d\n", tmp);
-			err = -EIO;
-			goto exit_free;
+			return -EIO;
 		}
 
 		/* oscillator fault?  clear flag, and warn */
@@ -933,7 +930,7 @@ read_rtc:
 		err = PTR_ERR(ds1307->rtc);
 		dev_err(&client->dev,
 			"unable to register the class device\n");
-		goto exit_free;
+		return err;
 	}
 
 	if (want_irq) {
@@ -951,8 +948,9 @@ read_rtc:
 	}
 
 	if (chip->nvram_size) {
-		ds1307->nvram = kzalloc(sizeof(struct bin_attribute),
-							GFP_KERNEL);
+		ds1307->nvram =	devm_kzalloc(&client->dev,
+			sizeof(struct bin_attribute), GFP_KERNEL);
+
 		if (!ds1307->nvram) {
 			err = -ENOMEM;
 			goto exit_nvram;
@@ -965,10 +963,9 @@ read_rtc:
 		ds1307->nvram->size = chip->nvram_size;
 		ds1307->nvram_offset = chip->nvram_offset;
 		err = sysfs_create_bin_file(&client->dev.kobj, ds1307->nvram);
-		if (err) {
-			kfree(ds1307->nvram);
+		if (err)
 			goto exit_nvram;
-		}
+
 		set_bit(HAS_NVRAM, &ds1307->flags);
 		dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);
 	}
@@ -978,8 +975,6 @@ read_rtc:
 exit_nvram:
 exit_irq:
 	rtc_device_unregister(ds1307->rtc);
-exit_free:
-	kfree(ds1307);
 	return err;
 }
 
@@ -992,13 +987,10 @@ static int ds1307_remove(struct i2c_client *client)
 		cancel_work_sync(&ds1307->work);
 	}
 
-	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags)) {
+	if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags))
 		sysfs_remove_bin_file(&client->dev.kobj, ds1307->nvram);
-		kfree(ds1307->nvram);
-	}
 
 	rtc_device_unregister(ds1307->rtc);
-	kfree(ds1307);
 	return 0;
 }
 
-- 
1.7.9.5

