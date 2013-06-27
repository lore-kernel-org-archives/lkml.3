Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab3F0NEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:04:44 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:12379 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753213Ab3F0Muj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:50:39 -0400
From: Nick Dyer <nick.dyer@itdev.co.uk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>, Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Nick Dyer <nick.dyer@itdev.co.uk>
Subject: [PATCH 14/51] Input: atmel_mxt_ts - Add additional bootloader addresses
Date: Thu, 27 Jun 2013 13:48:49 +0100
Message-Id: <1372337366-9286-15-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move bootloaders reads/writes into separate functions. Instead of switching
client->addr, define new field bootloader_addr in mxt_data. Implement lookup
calculation for bootloader addresses.

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
Acked-by: Benson Leung <bleung@chromium.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |  138 ++++++++++++++++++++----------
 1 file changed, 93 insertions(+), 45 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 751f446..82327e6 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -30,12 +30,6 @@
 #define MXT_VER_21		21
 #define MXT_VER_22		22
 
-/* Slave addresses */
-#define MXT_APP_LOW		0x4a
-#define MXT_APP_HIGH		0x4b
-#define MXT_BOOT_LOW		0x24
-#define MXT_BOOT_HIGH		0x25
-
 /* Firmware files */
 #define MXT_FW_NAME		"maxtouch.fw"
 #define MXT_CFG_NAME		"maxtouch.cfg"
@@ -268,6 +262,7 @@ struct mxt_data {
 	u16 mem_size;
 	u32 config_crc;
 	u32 info_crc;
+	u8 bootloader_addr;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
@@ -358,9 +353,82 @@ static int mxt_wait_for_completion(struct mxt_data *data,
 	return 0;
 }
 
+static int mxt_bootloader_read(struct mxt_data *data,
+			       u8 *val, unsigned int count)
+{
+	int ret;
+	struct i2c_msg msg;
+
+	msg.addr = data->bootloader_addr;
+	msg.flags = data->client->flags & I2C_M_TEN;
+	msg.flags |= I2C_M_RD;
+	msg.len = count;
+	msg.buf = val;
+
+	ret = i2c_transfer(data->client->adapter, &msg, 1);
+
+	if (ret == 1) {
+		ret = 0;
+	} else {
+		ret = (ret < 0) ? ret : -EIO;
+		dev_err(&data->client->dev, "%s: i2c recv failed (%d)\n",
+			__func__, ret);
+	}
+
+	return ret;
+}
+
+static int mxt_bootloader_write(struct mxt_data *data,
+				const u8 * const val, unsigned int count)
+{
+	int ret;
+	struct i2c_msg msg;
+
+	msg.addr = data->bootloader_addr;
+	msg.flags = data->client->flags & I2C_M_TEN;
+	msg.len = count;
+	msg.buf = (u8 *)val;
+
+	ret = i2c_transfer(data->client->adapter, &msg, 1);
+	if (ret == 1) {
+		ret = 0;
+	} else {
+		ret = (ret < 0) ? ret : -EIO;
+		dev_err(&data->client->dev, "%s: i2c send failed (%d)\n",
+			__func__, ret);
+	}
+
+	return ret;
+}
+
+static int mxt_lookup_bootloader_address(struct mxt_data *data)
+{
+	u8 appmode = data->client->addr;
+	u8 bootloader;
+
+	switch (appmode) {
+	case 0x4a:
+	case 0x4b:
+	case 0x4c:
+	case 0x4d:
+	case 0x5a:
+	case 0x5b:
+		bootloader = appmode - 0x26;
+		break;
+	default:
+		dev_err(&data->client->dev,
+			"Appmode i2c address 0x%02x not found\n",
+			appmode);
+		return -EINVAL;
+	}
+
+	data->bootloader_addr = bootloader;
+	return 0;
+}
+
 static int mxt_check_bootloader(struct mxt_data *data, unsigned int state)
 {
-	struct i2c_client *client = data->client;
+	struct device *dev = &data->client->dev;
 	u8 val;
 	int ret;
 
@@ -381,15 +449,14 @@ recheck:
 			 * length 0x000 to device (iff we are in
 			 * WAITING_FRAME_DATA state).
 			 */
-			dev_err(&client->dev, "Update wait error %d\n", ret);
+			dev_err(dev, "Update wait error %d\n", ret);
 			return ret;
 		}
 	}
 
-	if (i2c_master_recv(client, &val, 1) != 1) {
-		dev_err(&client->dev, "%s: i2c recv failed\n", __func__);
-		return -EIO;
-	}
+	ret = mxt_bootloader_read(data, &val, 1);
+	if (ret)
+		return ret;
 
 	switch (state) {
 	case MXT_WAITING_BOOTLOAD_CMD:
@@ -405,7 +472,7 @@ recheck:
 	}
 
 	if (val != state) {
-		dev_err(&client->dev, "Invalid bootloader state %02X != %02X\n",
+		dev_err(dev, "Invalid bootloader state %02X != %02X\n",
 			val, state);
 		return -EINVAL;
 	}
@@ -413,28 +480,17 @@ recheck:
 	return 0;
 }
 
-static int mxt_unlock_bootloader(struct i2c_client *client)
+static int mxt_unlock_bootloader(struct mxt_data *data)
 {
+	int ret;
 	u8 buf[2];
 
 	buf[0] = MXT_UNLOCK_CMD_LSB;
 	buf[1] = MXT_UNLOCK_CMD_MSB;
 
-	if (i2c_master_send(client, buf, 2) != 2) {
-		dev_err(&client->dev, "%s: i2c send failed\n", __func__);
-		return -EIO;
-	}
-
-	return 0;
-}
-
-static int mxt_fw_write(struct i2c_client *client,
-			     const u8 *data, unsigned int frame_size)
-{
-	if (i2c_master_send(client, data, frame_size) != frame_size) {
-		dev_err(&client->dev, "%s: i2c send failed\n", __func__);
-		return -EIO;
-	}
+	ret = mxt_bootloader_write(data, buf, 2);
+	if (ret)
+		return ret;
 
 	return 0;
 }
@@ -1366,7 +1422,6 @@ done:
 static int mxt_load_fw(struct device *dev, const char *fn)
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
 	const struct firmware *fw = NULL;
 	unsigned int frame_size;
 	unsigned int pos = 0;
@@ -1378,6 +1433,10 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		return ret;
 	}
 
+	ret = mxt_lookup_bootloader_address(data);
+	if (ret)
+		goto release_firmware;
+
 	/* Change to the bootloader mode */
 	data->in_bootloader = true;
 
@@ -1387,12 +1446,6 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 
 	msleep(MXT_RESET_TIME);
 
-	/* Change to slave address of bootloader */
-	if (client->addr == MXT_APP_LOW)
-		client->addr = MXT_BOOT_LOW;
-	else
-		client->addr = MXT_BOOT_HIGH;
-
 	INIT_COMPLETION(data->bl_completion);
 
 	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD);
@@ -1400,7 +1453,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		goto disable_irq;
 
 	/* Unlock bootloader */
-	mxt_unlock_bootloader(client);
+	mxt_unlock_bootloader(data);
 
 	while (pos < fw->size) {
 		ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA);
@@ -1415,7 +1468,9 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 		frame_size += 2;
 
 		/* Write one frame to device */
-		mxt_fw_write(client, fw->data + pos, frame_size);
+		ret = mxt_bootloader_write(data, fw->data + pos, frame_size);
+		if (ret)
+			goto disable_irq;
 
 		ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS);
 		if (ret)
@@ -1443,13 +1498,6 @@ disable_irq:
 	disable_irq(data->irq);
 release_firmware:
 	release_firmware(fw);
-
-	/* Change to slave address of application */
-	if (client->addr == MXT_BOOT_LOW)
-		client->addr = MXT_APP_LOW;
-	else
-		client->addr = MXT_APP_HIGH;
-
 	return ret;
 }
 
-- 
1.7.10.4

