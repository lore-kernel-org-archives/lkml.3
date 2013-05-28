Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3E1TEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:04:11 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:49274 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3E1TEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:04:10 -0400
From: Nikolay Balandin <n.a.balandin@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, Jingoo Han <jg1.han@samsung.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Nikolay Balandin <nbalandin@dev.rtsoft.ru>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] drivers/misc: at2x: use devm_kzalloc() to make cleanup paths simpler
Date: Tue, 28 May 2013 12:03:20 -0700
Message-Id: <1369767800-31895-1-git-send-email-n.a.balandin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Use devm_kzalloc() instead of kzalloc. Get rid of the "goto" statements
and useless dev_dbg() calls when driver probe fails.

Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
---
 drivers/misc/eeprom/at24.c |   50 +++++++++++++++-----------------------------
 drivers/misc/eeprom/at25.c |   25 +++++++---------------
 2 files changed, 25 insertions(+), 50 deletions(-)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index 2baeec5..6f0174b 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -492,10 +492,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (client->dev.platform_data) {
 		chip = *(struct at24_platform_data *)client->dev.platform_data;
 	} else {
-		if (!id->driver_data) {
-			err = -ENODEV;
-			goto err_out;
-		}
+		if (!id->driver_data)
+			return -ENODEV;
+
 		magic = id->driver_data;
 		chip.byte_len = BIT(magic & AT24_BITMASK(AT24_SIZE_BYTELEN));
 		magic >>= AT24_SIZE_BYTELEN;
@@ -519,8 +518,7 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			"byte_len looks suspicious (no power of 2)!\n");
 	if (!chip.page_size) {
 		dev_err(&client->dev, "page_size must not be 0!\n");
-		err = -EINVAL;
-		goto err_out;
+		return -EINVAL;
 	}
 	if (!is_power_of_2(chip.page_size))
 		dev_warn(&client->dev,
@@ -528,10 +526,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	/* Use I2C operations unless we're stuck with SMBus extensions. */
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
-		if (chip.flags & AT24_FLAG_ADDR16) {
-			err = -EPFNOSUPPORT;
-			goto err_out;
-		}
+		if (chip.flags & AT24_FLAG_ADDR16)
+			return -EPFNOSUPPORT;
+
 		if (i2c_check_functionality(client->adapter,
 				I2C_FUNC_SMBUS_READ_I2C_BLOCK)) {
 			use_smbus = I2C_SMBUS_I2C_BLOCK_DATA;
@@ -541,10 +538,8 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		} else if (i2c_check_functionality(client->adapter,
 				I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
 			use_smbus = I2C_SMBUS_BYTE_DATA;
-		} else {
-			err = -EPFNOSUPPORT;
-			goto err_out;
-		}
+		} else
+			return -EPFNOSUPPORT;
 	}
 
 	if (chip.flags & AT24_FLAG_TAKE8ADDR)
@@ -553,12 +548,10 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		num_addresses =	DIV_ROUND_UP(chip.byte_len,
 			(chip.flags & AT24_FLAG_ADDR16) ? 65536 : 256);
 
-	at24 = kzalloc(sizeof(struct at24_data) +
+	at24 = devm_kzalloc(&client->dev, sizeof(struct at24_data) +
 		num_addresses * sizeof(struct i2c_client *), GFP_KERNEL);
-	if (!at24) {
-		err = -ENOMEM;
-		goto err_out;
-	}
+	if (!at24)
+		return -ENOMEM;
 
 	mutex_init(&at24->lock);
 	at24->use_smbus = use_smbus;
@@ -596,11 +589,11 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			at24->write_max = write_max;
 
 			/* buffer (data + address at the beginning) */
-			at24->writebuf = kmalloc(write_max + 2, GFP_KERNEL);
-			if (!at24->writebuf) {
-				err = -ENOMEM;
-				goto err_struct;
-			}
+			at24->writebuf = devm_kzalloc(&client->dev,
+				write_max + 2, GFP_KERNEL);
+
+			if (!at24->writebuf)
+				return -ENOMEM;
 		} else {
 			dev_warn(&client->dev,
 				"cannot write due to controller restrictions.");
@@ -647,12 +640,6 @@ err_clients:
 	for (i = 1; i < num_addresses; i++)
 		if (at24->client[i])
 			i2c_unregister_device(at24->client[i]);
-
-	kfree(at24->writebuf);
-err_struct:
-	kfree(at24);
-err_out:
-	dev_dbg(&client->dev, "probe error %d\n", err);
 	return err;
 }
 
@@ -666,9 +653,6 @@ static int at24_remove(struct i2c_client *client)
 
 	for (i = 1; i < at24->num_addresses; i++)
 		i2c_unregister_device(at24->client[i]);
-
-	kfree(at24->writebuf);
-	kfree(at24);
 	return 0;
 }
 
diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index ad8fd8e..840b359 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -371,11 +371,10 @@ static int at25_probe(struct spi_device *spi)
 		if (np) {
 			err = at25_np_to_chip(&spi->dev, np, &chip);
 			if (err)
-				goto fail;
+				return err;
 		} else {
 			dev_err(&spi->dev, "Error: no chip description\n");
-			err = -ENODEV;
-			goto fail;
+			return -ENODEV;
 		}
 	} else
 		chip = *(struct spi_eeprom *)spi->dev.platform_data;
@@ -389,8 +388,7 @@ static int at25_probe(struct spi_device *spi)
 		addrlen = 3;
 	else {
 		dev_dbg(&spi->dev, "unsupported address type\n");
-		err = -EINVAL;
-		goto fail;
+		return -EINVAL;
 	}
 
 	/* Ping the chip ... the status register is pretty portable,
@@ -400,14 +398,12 @@ static int at25_probe(struct spi_device *spi)
 	sr = spi_w8r8(spi, AT25_RDSR);
 	if (sr < 0 || sr & AT25_SR_nRDY) {
 		dev_dbg(&spi->dev, "rdsr --> %d (%02x)\n", sr, sr);
-		err = -ENXIO;
-		goto fail;
+		return -ENXIO;
 	}
 
-	if (!(at25 = kzalloc(sizeof *at25, GFP_KERNEL))) {
-		err = -ENOMEM;
-		goto fail;
-	}
+	at25 = devm_kzalloc(&spi->dev, sizeof(struct at25_data), GFP_KERNEL);
+	if (!at25)
+		return -ENOMEM;
 
 	mutex_init(&at25->lock);
 	at25->chip = chip;
@@ -439,7 +435,7 @@ static int at25_probe(struct spi_device *spi)
 
 	err = sysfs_create_bin_file(&spi->dev.kobj, &at25->bin);
 	if (err)
-		goto fail;
+		return err;
 
 	if (chip.setup)
 		chip.setup(&at25->mem, chip.context);
@@ -453,10 +449,6 @@ static int at25_probe(struct spi_device *spi)
 		(chip.flags & EE_READONLY) ? " (readonly)" : "",
 		at25->chip.page_size);
 	return 0;
-fail:
-	dev_dbg(&spi->dev, "probe err %d\n", err);
-	kfree(at25);
-	return err;
 }
 
 static int at25_remove(struct spi_device *spi)
@@ -465,7 +457,6 @@ static int at25_remove(struct spi_device *spi)
 
 	at25 = spi_get_drvdata(spi);
 	sysfs_remove_bin_file(&spi->dev.kobj, &at25->bin);
-	kfree(at25);
 	return 0;
 }
 
-- 
1.7.9.5

