Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933984Ab3E1NAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 09:00:32 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:57023 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933906Ab3E1NAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 09:00:31 -0400
From: Nikolay Balandin <n.a.balandin@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, Jingoo Han <jg1.han@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Subject: [PATCH 1/1] drivers/misc: at2x: use devm_kzalloc() to make cleanup paths simpler
Date: Tue, 28 May 2013 17:00:13 +0400
Message-Id: <1369746013-29162-1-git-send-email-n.a.balandin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
---
 drivers/misc/eeprom/at24.c |   15 +++++----------
 drivers/misc/eeprom/at25.c |    5 ++---
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 2baeec5..e110662 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -553,7 +553,7 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		num_addresses =	DIV_ROUND_UP(chip.byte_len,
 			(chip.flags & AT24_FLAG_ADDR16) ? 65536 : 256);
 
-	at24 = kzalloc(sizeof(struct at24_data) +
+	at24 = devm_kzalloc(&client->dev, sizeof(struct at24_data) +
 		num_addresses * sizeof(struct i2c_client *), GFP_KERNEL);
 	if (!at24) {
 		err = -ENOMEM;
@@ -596,10 +596,12 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			at24->write_max = write_max;
 
 			/* buffer (data + address at the beginning) */
-			at24->writebuf = kmalloc(write_max + 2, GFP_KERNEL);
+			at24->writebuf = devm_kzalloc(&client->dev,
+				write_max + 2, GFP_KERNEL);
+
 			if (!at24->writebuf) {
 				err = -ENOMEM;
-				goto err_struct;
+				goto err_out;
 			}
 		} else {
 			dev_warn(&client->dev,
@@ -647,10 +649,6 @@ err_clients:
 	for (i = 1; i < num_addresses; i++)
 		if (at24->client[i])
 			i2c_unregister_device(at24->client[i]);
-
-	kfree(at24->writebuf);
-err_struct:
-	kfree(at24);
 err_out:
 	dev_dbg(&client->dev, "probe error %d\n", err);
 	return err;
@@ -666,9 +664,6 @@ static int at24_remove(struct i2c_client *client)
 
 	for (i = 1; i < at24->num_addresses; i++)
 		i2c_unregister_device(at24->client[i]);
-
-	kfree(at24->writebuf);
-	kfree(at24);
 	return 0;
 }
 
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index ad8fd8e..f9d35c9 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -404,7 +404,8 @@ static int at25_probe(struct spi_device *spi)
 		goto fail;
 	}
 
-	if (!(at25 = kzalloc(sizeof *at25, GFP_KERNEL))) {
+	at25 = devm_kzalloc(&spi->dev, sizeof(struct at25_data), GFP_KERNEL);
+	if (!at25) {
 		err = -ENOMEM;
 		goto fail;
 	}
@@ -455,7 +456,6 @@ static int at25_probe(struct spi_device *spi)
 	return 0;
 fail:
 	dev_dbg(&spi->dev, "probe err %d\n", err);
-	kfree(at25);
 	return err;
 }
 
@@ -465,7 +465,6 @@ static int at25_remove(struct spi_device *spi)
 
 	at25 = spi_get_drvdata(spi);
 	sysfs_remove_bin_file(&spi->dev.kobj, &at25->bin);
-	kfree(at25);
 	return 0;
 }
 
-- 
1.7.9.5

