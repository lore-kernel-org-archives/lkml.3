Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaANKrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 05:47:36 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.176]:5832 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751329AbaANKrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 05:47:33 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jan 2014 05:47:33 EST
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-15.tower-38.messagelabs.com!1389696068!6586048!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 14 Jan 2014 11:41:08 +0100
Date: Tue, 14 Jan 2014 11:41:02 +0100
From: Andreas Werner <andreas.werner@men.de>
To: <a.zummo@towertech.it>
CC: <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>,
        <andreas.werner@men.de>
Subject: [PATCH] rtc: Add SMBus-only adapters support to rtc-rx8581
Message-ID: <20140114104057.GA27529@ubuntu1310>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.168.3.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for SMBus-only adapters (e.g. i2c-piix4).
The driver has implementet only support for I2C adapter
which implements the I2C_FUNC_SMBUS_I2C_BLOCK functionality before.

With this patch it is possible to load and use the RTC driver with
I2C and SMBUS adapters like the rtc-ds1307 does.

Tested on AMD G Series Platform (i2c-piix4 adapter driver).

Signed-off-by: Andreas Werner <andreas.werner@men.de>
---
 drivers/rtc/rtc-rx8581.c | 81 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 68 insertions(+), 13 deletions(-)

diff --git a/drivers/rtc/rtc-rx8581.c b/drivers/rtc/rtc-rx8581.c
index 00b0eb7..de8d9c4 100644
--- a/drivers/rtc/rtc-rx8581.c
+++ b/drivers/rtc/rtc-rx8581.c
@@ -52,8 +52,45 @@
 #define RX8581_CTRL_STOP	0x02 /* STOP bit */
 #define RX8581_CTRL_RESET	0x01 /* RESET bit */
 
+struct rx8581 {
+	struct i2c_client	*client;
+	struct rtc_device	*rtc;
+	s32 (*read_block_data)(const struct i2c_client *client, u8 command,
+				u8 length, u8 *values);
+	s32 (*write_block_data)(const struct i2c_client *client, u8 command,
+				u8 length, const u8 *values);
+};
+
 static struct i2c_driver rx8581_driver;
 
+static int rx8581_read_block_data(const struct i2c_client *client, u8 command,
+					u8 length, u8 *values)
+{
+	s32 i, data;
+
+	for (i = 0; i < length; i++) {
+		data = i2c_smbus_read_byte_data(client, command + i);
+		if (data < 0)
+			return data;
+		values[i] = data;
+	}
+	return i;
+}
+
+static int rx8581_write_block_data(const struct i2c_client *client, u8 command,
+					u8 length, const u8 *values)
+{
+	s32 i, ret;
+
+	for (i = 0; i < length; i++) {
+		ret = i2c_smbus_write_byte_data(client, command + i,
+						values[i]);
+		if (ret < 0)
+			return ret;
+	}
+	return length;
+}
+
 /*
  * In the routines that deal directly with the rx8581 hardware, we use
  * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.
@@ -62,6 +99,7 @@ static int rx8581_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
 	unsigned char date[7];
 	int data, err;
+	struct rx8581 *rx8581 = i2c_get_clientdata(client);
 
 	/* First we ensure that the "update flag" is not set, we read the
 	 * time and date then re-read the "update flag". If the update flag
@@ -80,14 +118,13 @@ static int rx8581_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 			err = i2c_smbus_write_byte_data(client,
 				RX8581_REG_FLAG, (data & ~RX8581_FLAG_UF));
 			if (err != 0) {
-				dev_err(&client->dev, "Unable to write device "
-					"flags\n");
+				dev_err(&client->dev, "Unable to write device flags\n");
 				return -EIO;
 			}
 		}
 
 		/* Now read time and date */
-		err = i2c_smbus_read_i2c_block_data(client, RX8581_REG_SC,
+		err = rx8581->read_block_data(client, RX8581_REG_SC,
 			7, date);
 		if (err < 0) {
 			dev_err(&client->dev, "Unable to read date\n");
@@ -140,6 +177,7 @@ static int rx8581_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
 	int data, err;
 	unsigned char buf[7];
+	struct rx8581 *rx8581 = i2c_get_clientdata(client);
 
 	dev_dbg(&client->dev, "%s: secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
@@ -176,7 +214,7 @@ static int rx8581_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 	}
 
 	/* write register's data */
-	err = i2c_smbus_write_i2c_block_data(client, RX8581_REG_SC, 7, buf);
+	err = rx8581->write_block_data(client, RX8581_REG_SC, 7, buf);
 	if (err < 0) {
 		dev_err(&client->dev, "Unable to write to date registers\n");
 		return -EIO;
@@ -231,22 +269,39 @@ static const struct rtc_class_ops rx8581_rtc_ops = {
 static int rx8581_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	struct rtc_device *rtc;
+	struct rx8581	  *rx8581;
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
-		return -ENODEV;
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA)
+		&& !i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
+		return -EIO;
 
-	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
+	rx8581 = devm_kzalloc(&client->dev, sizeof(struct rx8581), GFP_KERNEL);
+	if (!rx8581)
+		return -ENOMEM;
 
-	rtc = devm_rtc_device_register(&client->dev, rx8581_driver.driver.name,
-					&rx8581_rtc_ops, THIS_MODULE);
+	i2c_set_clientdata(client, rx8581);
+	rx8581->client = client;
 
-	if (IS_ERR(rtc))
-		return PTR_ERR(rtc);
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_I2C_BLOCK)) {
+		rx8581->read_block_data = i2c_smbus_read_i2c_block_data;
+		rx8581->write_block_data = i2c_smbus_write_i2c_block_data;
+	} else {
+		rx8581->read_block_data = rx8581_read_block_data;
+		rx8581->write_block_data = rx8581_write_block_data;
+	}
 
-	i2c_set_clientdata(client, rtc);
+	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
+
+	rx8581->rtc = devm_rtc_device_register(&client->dev,
+		rx8581_driver.driver.name, &rx8581_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(rx8581->rtc)) {
+		dev_err(&client->dev,
+			"unable to register the class device\n");
+		return PTR_ERR(rx8581->rtc);
+	}
 
 	return 0;
 }
-- 
1.8.3.2

