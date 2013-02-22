Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566Ab3BVSML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 13:12:11 -0500
Received: from [89.21.227.133] ([89.21.227.133]:43159 "EHLO
	mail.kdh.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759070Ab3BVSIg (ORCPT
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
Subject: [PATCH 10/40] Input: atmel_mxt_ts - Improve bootloader support
Date: Fri, 22 Feb 2013 17:57:57 +0000
Message-Id: <1361555907-19840-11-git-send-email-nick.dyer@itdev.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
References: <1361555907-19840-1-git-send-email-nick.dyer@itdev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Add additional bootloader addresses
    Read and report bootloader version
    Increase fw reset time for greater reliability
    Further bootloader improvements
    Handle APP_CRC_FAIL on startup
    Handle bootloader frame CRC failure
    Recover gracefully from flash aborted halfway through

Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
---
 drivers/input/touchscreen/Kconfig        |    1 +
 drivers/input/touchscreen/atmel_mxt_ts.c |  318 +++++++++++++++++++++++-------
 2 files changed, 244 insertions(+), 75 deletions(-)

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 9a647ee..a4f98c8 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -89,6 +89,7 @@ config TOUCHSCREEN_AD7879_SPI
 config TOUCHSCREEN_ATMEL_MXT
 	tristate "Atmel mXT I2C Touchscreen"
 	depends on I2C
+	select FW_LOADER
 	help
 	  Say Y here if you have Atmel mXT series I2C touchscreen,
 	  such as AT42QT602240/ATMXT224, connected to your system.
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 302c03e..16af68d 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -27,12 +27,6 @@
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
@@ -204,6 +198,8 @@
 #define MXT_FRAME_CRC_PASS	0x04
 #define MXT_APP_CRC_FAIL	0x40	/* valid 7 8 bit only */
 #define MXT_BOOT_STATUS_MASK	0x3f
+#define MXT_BOOT_EXTENDED_ID	(1 << 5)
+#define MXT_BOOT_ID_MASK	0x1f
 
 /* Touch status */
 #define MXT_UNGRIP		(1 << 0)
@@ -249,12 +245,15 @@ struct mxt_message {
 	u8 message[7];
 };
 
+enum mxt_device_state { INIT, APPMODE, BOOTLOADER, FAILED };
+
 /* Each client has this additional data */
 struct mxt_data {
 	struct i2c_client *client;
 	struct input_dev *input_dev;
 	char phys[64];		/* device physical location */
 	const struct mxt_platform_data *pdata;
+	enum mxt_device_state state;
 	struct mxt_object *object_table;
 	u16 mem_size;
 	struct mxt_info info;
@@ -265,6 +264,7 @@ struct mxt_data {
 	bool debug_enabled;
 	u32 config_crc;
 	u32 info_crc;
+	u8 bootloader_addr;
 
 	/* Cached parameters from object table */
 	u8 T6_reportid;
@@ -274,6 +274,21 @@ struct mxt_data {
 	u8 T9_reportid_max;
 };
 
+/* I2C slave address pairs */
+struct mxt_i2c_address_pair {
+	u8 bootloader;
+	u8 application;
+};
+
+static const struct mxt_i2c_address_pair mxt_i2c_addresses[] = {
+	{ 0x24, 0x4a },
+	{ 0x25, 0x4b },
+	{ 0x26, 0x4c },
+	{ 0x27, 0x4d },
+	{ 0x34, 0x5a },
+	{ 0x35, 0x5b },
+};
+
 static bool mxt_object_readable(unsigned int type)
 {
 	switch (type) {
@@ -313,59 +328,165 @@ static void mxt_dump_message(struct device *dev, struct mxt_message *message)
 		       sizeof(struct mxt_message), message);
 }
 
-static int mxt_check_bootloader(struct i2c_client *client,
-				     unsigned int state)
+static int mxt_bootloader_read(struct mxt_data *data, u8 *val, unsigned int count)
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
+	return (ret == 1) ? 0 : ret;
+}
+
+static int mxt_bootloader_write(struct mxt_data *data, const u8 * const val,
+	unsigned int count)
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
+
+	return (ret == 1) ? 0 : ret;
+}
+
+static int mxt_get_bootloader_address(struct mxt_data *data)
+{
+	struct i2c_client *client = data->client;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(mxt_i2c_addresses); i++) {
+		if (mxt_i2c_addresses[i].application == client->addr) {
+			data->bootloader_addr = mxt_i2c_addresses[i].bootloader;
+
+			dev_info(&client->dev, "Bootloader i2c addr: 0x%02x\n",
+				data->bootloader_addr);
+
+			return 0;
+		}
+	}
+
+	dev_err(&client->dev, "Address 0x%02x not found in address table\n",
+		client->addr);
+	return -EINVAL;
+}
+
+static int mxt_probe_bootloader(struct mxt_data *data)
 {
+	struct device *dev = &data->client->dev;
+	int ret;
 	u8 val;
+	bool crc_failure;
 
-recheck:
-	if (i2c_master_recv(client, &val, 1) != 1) {
-		dev_err(&client->dev, "%s: i2c recv failed\n", __func__);
+	ret = mxt_get_bootloader_address(data);
+	if (ret)
+		return ret;
+
+	ret = mxt_bootloader_read(data, &val, 1);
+	if (ret) {
+		dev_err(dev, "%s: i2c recv failed\n", __func__);
 		return -EIO;
 	}
 
+	/* Check app crc fail mode */
+	crc_failure = (val & ~MXT_BOOT_STATUS_MASK) == MXT_APP_CRC_FAIL;
+
+	dev_err(dev, "Detected bootloader, status:%02X%s\n",
+		val, crc_failure ? ", APP_CRC_FAIL" : "");
+
+	return 0;
+}
+
+static u8 mxt_get_bootloader_version(struct mxt_data *data, u8 val)
+{
+	struct device *dev = &data->client->dev;
+	u8 buf[3];
+
+	if (val & MXT_BOOT_EXTENDED_ID) {
+		if (mxt_bootloader_read(data, &buf[0], 3) != 0) {
+			dev_err(dev, "%s: i2c failure\n", __func__);
+			return -EIO;
+		}
+
+		dev_info(dev, "Bootloader ID:%d Version:%d\n", buf[1], buf[2]);
+
+		return buf[0];
+	} else {
+		dev_info(dev, "Bootloader ID:%d\n", val & MXT_BOOT_ID_MASK);
+
+		return val;
+	}
+}
+
+static int mxt_check_bootloader(struct mxt_data *data,
+				unsigned int state)
+{
+	struct device *dev = &data->client->dev;
+	int ret;
+	u8 val;
+
+recheck:
+	ret = mxt_bootloader_read(data, &val, 1);
+	if (ret) {
+		dev_err(dev, "%s: i2c recv failed, ret=%d\n",
+			__func__, ret);
+		return ret;
+	}
+
+	if (state == MXT_WAITING_BOOTLOAD_CMD)
+		val = mxt_get_bootloader_version(data, val);
+
 	switch (state) {
 	case MXT_WAITING_BOOTLOAD_CMD:
+		val &= ~MXT_BOOT_STATUS_MASK;
+		break;
 	case MXT_WAITING_FRAME_DATA:
+	case MXT_APP_CRC_FAIL:
 		val &= ~MXT_BOOT_STATUS_MASK;
 		break;
 	case MXT_FRAME_CRC_PASS:
 		if (val == MXT_FRAME_CRC_CHECK)
 			goto recheck;
+		if (val == MXT_FRAME_CRC_FAIL) {
+			dev_err(dev, "Bootloader CRC fail\n");
+			return -EINVAL;
+		}
 		break;
 	default:
 		return -EINVAL;
 	}
 
 	if (val != state) {
-		dev_err(&client->dev, "Invalid bootloader mode state\n");
+		dev_err(dev, "Invalid bootloader mode state 0x%02X\n", val);
 		return -EINVAL;
 	}
 
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
+	ret = mxt_bootloader_write(data, buf, 2);
+	if (ret) {
+		dev_err(&data->client->dev, "%s: i2c send failed, ret=%d\n",
+				__func__, ret);
+		return ret;
 	}
 
 	return 0;
@@ -1060,8 +1181,18 @@ static int mxt_initialize(struct mxt_data *data)
 	u8 val;
 
 	error = mxt_get_info(data);
-	if (error)
-		return error;
+	if (error) {
+		error = mxt_probe_bootloader(data);
+
+		if (error) {
+			return error;
+		} else {
+			data->state = BOOTLOADER;
+			return 0;
+		}
+	}
+
+	data->state = APPMODE;
 
 	data->object_table = kcalloc(info->object_num,
 				     sizeof(struct mxt_object),
@@ -1211,71 +1342,99 @@ done:
 static int mxt_load_fw(struct device *dev, const char *fn)
 {
 	struct mxt_data *data = dev_get_drvdata(dev);
-	struct i2c_client *client = data->client;
 	const struct firmware *fw = NULL;
 	unsigned int frame_size;
 	unsigned int pos = 0;
+	unsigned int retry = 0;
+	unsigned int frame = 0;
 	int ret;
 
 	ret = request_firmware(&fw, fn, dev);
-	if (ret) {
+	if (ret < 0) {
 		dev_err(dev, "Unable to open firmware %s\n", fn);
 		return ret;
 	}
 
-	/* Change to the bootloader mode */
-	ret = mxt_soft_reset(data, MXT_BOOT_VALUE);
-	if (ret)
-		return ret;
+	if (data->state != BOOTLOADER) {
+		/* Change to the bootloader mode */
+		ret = mxt_soft_reset(data, MXT_BOOT_VALUE);
+		if (ret)
+			goto release_firmware;
 
-	/* Change to slave address of bootloader */
-	if (client->addr == MXT_APP_LOW)
-		client->addr = MXT_BOOT_LOW;
-	else
-		client->addr = MXT_BOOT_HIGH;
+		ret = mxt_get_bootloader_address(data);
+		if (ret)
+			goto release_firmware;
 
-	ret = mxt_check_bootloader(client, MXT_WAITING_BOOTLOAD_CMD);
-	if (ret)
-		goto out;
+		data->state = BOOTLOADER;
+	}
+
+	ret = mxt_check_bootloader(data, MXT_WAITING_BOOTLOAD_CMD);
+	if (ret) {
+		/* Bootloader may still be unlocked from previous update
+		 * attempt */
+		ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA);
+		if (ret) {
+			data->state = FAILED;
+			goto release_firmware;
+		}
+	} else {
+		dev_info(dev, "Unlocking bootloader\n");
 
-	/* Unlock bootloader */
-	mxt_unlock_bootloader(client);
+		/* Unlock bootloader */
+		ret = mxt_unlock_bootloader(data);
+		if (ret) {
+			data->state = FAILED;
+			goto release_firmware;
+		}
+	}
 
 	while (pos < fw->size) {
-		ret = mxt_check_bootloader(client,
-						MXT_WAITING_FRAME_DATA);
-		if (ret)
-			goto out;
+		ret = mxt_check_bootloader(data, MXT_WAITING_FRAME_DATA);
+		if (ret) {
+			data->state = FAILED;
+			goto release_firmware;
+		}
 
 		frame_size = ((*(fw->data + pos) << 8) | *(fw->data + pos + 1));
 
-		/* We should add 2 at frame size as the the firmware data is not
-		 * included the CRC bytes.
-		 */
+		/* Take account of CRC bytes */
 		frame_size += 2;
 
 		/* Write one frame to device */
-		mxt_fw_write(client, fw->data + pos, frame_size);
+		ret = mxt_bootloader_write(data, fw->data + pos, frame_size);
+		if (ret) {
+			data->state = FAILED;
+			goto release_firmware;
+		}
 
-		ret = mxt_check_bootloader(client,
-						MXT_FRAME_CRC_PASS);
-		if (ret)
-			goto out;
+		ret = mxt_check_bootloader(data, MXT_FRAME_CRC_PASS);
+		if (ret) {
+			retry++;
 
-		pos += frame_size;
+			/* Back off by 20ms per retry */
+			msleep(retry * 20);
 
-		dev_dbg(dev, "Updated %d bytes / %zd bytes\n", pos, fw->size);
+			if (retry > 20) {
+				data->state = FAILED;
+				goto release_firmware;
+			}
+		} else {
+			retry = 0;
+			pos += frame_size;
+			frame++;
+		}
+
+		if (frame % 10 == 0)
+			dev_info(dev, "Updated %d frames, %d/%zd bytes\n",
+				 frame, pos, fw->size);
 	}
 
-out:
-	release_firmware(fw);
+	dev_info(dev, "Finished, sent %d frames, %zd bytes\n", frame, pos);
 
-	/* Change to slave address of application */
-	if (client->addr == MXT_BOOT_LOW)
-		client->addr = MXT_APP_LOW;
-	else
-		client->addr = MXT_APP_HIGH;
+	data->state = INIT;
 
+release_firmware:
+	release_firmware(fw);
 	return ret;
 }
 
@@ -1293,7 +1452,7 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		dev_err(dev, "The firmware update failed(%d)\n", error);
 		count = error;
 	} else {
-		dev_dbg(dev, "The firmware update succeeded\n");
+		dev_info(dev, "The firmware update succeeded\n");
 
 		/* Wait for reset */
 		msleep(MXT_FWRESET_TIME);
@@ -1303,11 +1462,13 @@ static ssize_t mxt_update_fw_store(struct device *dev,
 		mxt_initialize(data);
 	}
 
-	enable_irq(data->irq);
+	if (data->state == APPMODE) {
+		enable_irq(data->irq);
 
-	error = mxt_make_highchg(data);
-	if (error)
-		return error;
+		error = mxt_make_highchg(data);
+		if (error)
+			return error;
+	}
 
 	return count;
 }
@@ -1345,6 +1506,11 @@ static ssize_t mxt_debug_enable_store(struct device *dev,
 static int mxt_check_mem_access_params(struct mxt_data *data, loff_t off,
 				       size_t *count)
 {
+	if (data->state != APPMODE) {
+		dev_err(&data->client->dev, "Not in APPMODE\n");
+		return -EINVAL;
+	}
+
 	if (off >= data->mem_size)
 		return -EIO;
 
@@ -1462,6 +1628,8 @@ static int mxt_probe(struct i2c_client *client,
 		goto err_free_mem;
 	}
 
+	data->state = INIT;
+
 	input_dev->name = "Atmel maXTouch Touchscreen";
 	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
 		 client->adapter->nr, client->addr);
@@ -1520,10 +1688,10 @@ static int mxt_probe(struct i2c_client *client,
 		goto err_free_object;
 	}
 
-	error = mxt_make_highchg(data);
-	if (error) {
-		dev_err(&client->dev, "Error %d clearing messages\n", error);
-		goto err_free_irq;
+	if (data->state == APPMODE) {
+		error = mxt_make_highchg(data);
+		if (error)
+			goto err_free_irq;
 	}
 
 	error = input_register_device(input_dev);
-- 
1.7.10.4

