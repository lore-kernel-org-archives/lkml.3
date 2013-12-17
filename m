Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab3LQI1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:27:30 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:39890 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab3LQI12 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:27:28 -0500
From: "duson" <dusonlin@emc.com.tw>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <phoenix@emc.com.tw>, <bleung@chromium.org>, <agnescheng@chromium.org>
References: <1385099816-2873-1-git-send-email-dusonlin@emc.com.tw> <20131216210011.GC8884@core.coreip.homeip.net>
Subject: RE: [PATCH] Input: add i2c/smbus driver for elan touchpad
Date: Tue, 17 Dec 2013 16:26:48 +0800
Message-ID: <EA76F9233EFB42B6B2AE32679DD88498@elan.corp>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20131216210011.GC8884@core.coreip.homeip.net>
thread-index: Ac76yn5SOCs1/9AGTW+IsJ118L0R3wANUNuA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add BLeung in mail loop.

Hi Dmitry:

Thanks for your review and suggestions.
First at all, I should say sorry to you because I had shrink and only reserved necessary basic functions from original source code and re-uploaded it before got your mail yesterday. To avoid your persecution, I pasted the newest patch and added your recommends again in this mail. Please see my responses as below and give me more recommends.

Thank you, 
Duson

This driver adds support for elan i2c/smbus touchpad found on some laptops PC

Signed-off-by: Duson Lin <dusonlin@emc.com.tw>
---
 drivers/input/mouse/Kconfig    |   10 +
 drivers/input/mouse/Makefile   |    1 +
 drivers/input/mouse/elan_i2c.c |  908 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 919 insertions(+)
 create mode 100644 drivers/input/mouse/elan_i2c.c

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig index effa9c5..095eccc 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -215,6 +215,16 @@ config MOUSE_CYAPA
 	  To compile this driver as a module, choose M here: the module will be
 	  called cyapa.
 
+config MOUSE_ELAN_I2C
+	tristate "ELAN I2C Touchpad support"
+	depends on I2C
+	help
+	  This driver adds support for Elan I2C Trackpads.
+	  Say Y here if you have a ELAN I2C Touchpad.
+
+	  To compile this driver as a module, choose M here: the module will be
+	  called elan_i2c.
+
 config MOUSE_INPORT
 	tristate "InPort/MS/ATIXL busmouse"
 	depends on ISA
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile index c25efdb..24a12a6 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_MOUSE_APPLETOUCH)		+= appletouch.o
 obj-$(CONFIG_MOUSE_ATARI)		+= atarimouse.o
 obj-$(CONFIG_MOUSE_BCM5974)		+= bcm5974.o
 obj-$(CONFIG_MOUSE_CYAPA)		+= cyapa.o
+obj-$(CONFIG_MOUSE_ELAN_I2C)		+= elan_i2c.o
 obj-$(CONFIG_MOUSE_GPIO)		+= gpio_mouse.o
 obj-$(CONFIG_MOUSE_INPORT)		+= inport.o
 obj-$(CONFIG_MOUSE_LOGIBM)		+= logibm.o
diff --git a/drivers/input/mouse/elan_i2c.c b/drivers/input/mouse/elan_i2c.c new file mode 100644 index 0000000..a5a11bb
--- /dev/null
+++ b/drivers/input/mouse/elan_i2c.c
@@ -0,0 +1,908 @@
+?/*
+ * Elan I2C/SMBus Touchpad driver
+ *
+ * Copyright (c) 2013 ELAN Microelectronics Corp.
+ *
+ * Author: 林政維 (Duson Lin) <dusonlin@emc.com.tw>
+ * Version: 1.4.6
+ *
+ * Based on cyapa driver:
+ * copyright (c) 2011-2012 Cypress Semiconductor, Inc.
+ * copyright (c) 2011-2012 Google, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify 
+it
+ * under the terms of the GNU General Public License version 2 as 
+published
+ * by the Free Software Foundation.
+ *
+ * Trademarks are the property of their respective owners.
+ */
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/input/mt.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/cdev.h>
+#include <linux/kernel.h>
+#include <linux/major.h>
+#include <linux/sched.h>
+#include <linux/input.h>
+#include <linux/uaccess.h>
+#include <linux/jiffies.h>
+
+#define DRIVER_NAME		"elan_i2c"
+#define ELAN_DRIVER_VERSION	"1.4.6"
+#define ETP_PRESSURE_OFFSET	25
+#define ETP_MAX_PRESSURE	255
+#define ETP_FWIDTH_REDUCE	90
+#define ETP_FINGER_WIDTH	15
+
+#define ELAN_ADAPTER_FUNC_NONE   0
+#define ELAN_ADAPTER_FUNC_I2C    1
+#define ELAN_ADAPTER_FUNC_SMBUS  2
+#define ELAN_ADAPTER_FUNC_BOTH   3
+
+/* Length of Elan touchpad information */
+#define ETP_INF_LENGTH		2
+#define ETP_MAX_FINGERS		5
+#define ETP_FINGER_DATA_LEN	5
+#define ETP_REPORT_ID		0x5D
+#define ETP_MAX_REPORT_LEN	34
+#define ETP_ENABLE_ABS		0x0001
+#define ETP_ENABLE_CALIBRATE	0x0002
+#define ETP_DISABLE_CALIBRATE	0x0000
+
+/* Elan smbus command */
+#define ETP_SMBUS_IAP_CMD		0x00
+#define ETP_SMBUS_ENABLE_TP		0x20
+#define ETP_SMBUS_SLEEP_CMD		0x21
+#define ETP_SMBUS_IAP_PASSWORD_WRITE	0x29
+#define ETP_SMBUS_IAP_PASSWORD_READ	0x80
+#define ETP_SMBUS_WRITE_FW_BLOCK	0x2A
+#define ETP_SMBUS_IAP_RESET_CMD		0x2B
+#define ETP_SMBUS_RANGE_CMD		0xA0
+#define ETP_SMBUS_FW_VERSION_CMD	0xA1
+#define ETP_SMBUS_XY_TRACENUM_CMD	0xA2
+#define ETP_SMBUS_SM_VERSION_CMD	0xA3
+#define ETP_SMBUS_UNIQUEID_CMD		0xA3
+#define ETP_SMBUS_RESOLUTION_CMD	0xA4
+#define ETP_SMBUS_HELLOPACKET_CMD	0xA7
+#define ETP_SMBUS_PACKET_QUERY		0xA8
+#define ETP_SMBUS_IAP_VERSION_CMD	0xAC
+#define ETP_SMBUS_IAP_CTRL_CMD		0xAD
+#define ETP_SMBUS_IAP_CHECKSUM_CMD	0xAE
+#define ETP_SMBUS_FW_CHECKSUM_CMD	0xAF
+#define ETP_SMBUS_MAX_BASELINE_CMD	0xC3
+#define ETP_SMBUS_MIN_BASELINE_CMD	0xC4
+#define ETP_SMBUS_CALIBRATE_QUERY	0xC5
+#define ETP_SMBUS_REPORT_LEN		32
+#define ETP_SMBUS_FINGER_DATA_OFFSET	2
+#define ETP_SMBUS_HELLOPACKET_LEN	5
+#define ETP_SMBUS_IAP_PASSWORD		0x1234
+#define ETP_SMBUS_IAP_MODE_ON		(1<<6)
+
+/* Elan i2c command */
+#define ETP_I2C_RESET			0x0100
+#define ETP_I2C_WAKE_UP			0x0800
+#define ETP_I2C_SLEEP			0x0801
+#define ETP_I2C_DESC_CMD		0x0001
+#define ETP_I2C_REPORT_DESC_CMD		0x0002
+#define ETP_I2C_STAND_CMD		0x0005
+#define ETP_I2C_UNIQUEID_CMD		0x0101
+#define ETP_I2C_FW_VERSION_CMD		0x0102
+#define ETP_I2C_SM_VERSION_CMD		0x0103
+#define ETP_I2C_XY_TRACENUM_CMD		0x0105
+#define ETP_I2C_MAX_X_AXIS_CMD		0x0106
+#define ETP_I2C_MAX_Y_AXIS_CMD		0x0107
+#define ETP_I2C_RESOLUTION_CMD		0x0108
+#define ETP_I2C_IAP_VERSION_CMD		0x0110
+#define ETP_I2C_SET_CMD			0x0300
+#define ETP_I2C_MAX_BASELINE_CMD	0x0306
+#define ETP_I2C_MIN_BASELINE_CMD	0x0307
+#define ETP_I2C_FW_CHECKSUM_CMD		0x030F
+#define ETP_I2C_IAP_CTRL_CMD		0x0310
+#define ETP_I2C_IAP_CMD			0x0311
+#define ETP_I2C_IAP_RESET_CMD		0x0314
+#define ETP_I2C_IAP_CHECKSUM_CMD	0x0315
+#define ETP_I2C_CALIBRATE_CMD		0x0316
+#define ETP_I2C_REPORT_LEN		34
+#define ETP_I2C_FINGER_DATA_OFFSET	4
+#define ETP_I2C_REPORT_ID_OFFSET	2
+#define ETP_I2C_DESC_LENGTH		30
+#define ETP_I2C_REPORT_DESC_LENGTH	158
+#define ETP_I2C_IAP_PASSWORD		0x1EA5
+#define ETP_I2C_IAP_RESET		0xF0F0
+#define ETP_I2C_MAIN_MODE_ON		(1<<9)
+#define ETP_I2C_IAP_REG_L		0x01
+#define ETP_I2C_IAP_REG_H		0x06
+
+/* The main device structure */
+struct elan_tp_data {
+	struct i2c_client	*client;
+	struct input_dev	*input;
+	unsigned int		max_x;
+	unsigned int		max_y;
+	unsigned int		width_x;
+	unsigned int		width_y;
+	unsigned int		irq;
+	u16			unique_id;
+	u16			fw_version;
+	u16			sm_version;
+	u16			iap_version;
+	bool			smbus;
+};
+
+/*
+ *******************************************************************
+ * Elan smbus interface
+ *******************************************************************
+ */
+static int elan_smbus_initialize(struct i2c_client *client) {
+	u8 check[ETP_SMBUS_HELLOPACKET_LEN] = {0x55, 0x55, 0x55, 0x55, 0x55};
+	u8 values[ETP_SMBUS_HELLOPACKET_LEN] = {0, 0, 0, 0, 0};
+	int ret;
+
+	/* Get hello packet */
+	ret = i2c_smbus_read_block_data(client,
+					ETP_SMBUS_HELLOPACKET_CMD, values);
+	if (ret != ETP_SMBUS_HELLOPACKET_LEN) {
+		dev_err(&client->dev, "hello packet length fail\n");
+		return -1;
+	}
+
+	/* compare hello packet */
+	if (memcmp(values, check, ETP_SMBUS_HELLOPACKET_LEN)) {
+		dev_err(&client->dev, "hello packet fail [%x %x %x %x %x]\n",
+			values[0], values[1], values[2], values[3], values[4]);
+		return -1;
+	}
+
+	/* enable tp */
+	ret = i2c_smbus_write_byte(client, ETP_SMBUS_ENABLE_TP);
+	return ret;
+}
+
+static int elan_smbus_enable_absolute_mode(struct i2c_client *client) {
+	u8 cmd[4] = {0x00, 0x07, 0x00, ETP_ENABLE_ABS};
+
+	return i2c_smbus_write_block_data(client, ETP_SMBUS_IAP_CMD, 4, cmd); 
+}
+
+/*
+ ******************************************************************
+ * Elan i2c interface
+ ******************************************************************
+ */
+static int elan_i2c_read_block(struct i2c_client *client,
+			       u16 reg, u8 *val, u16 len)
+{
+	struct i2c_msg msgs[2];
+	u8 buf[2];
+	int ret;
+
+	buf[0] = reg & 0xff;
+	buf[1] = (reg >> 8) & 0xff;
+
+	msgs[0].addr = client->addr;
+	msgs[0].flags = client->flags & I2C_M_TEN;
+	msgs[0].len = 2;
+	msgs[0].buf = buf;
+
+	msgs[1].addr = client->addr;
+	msgs[1].flags = client->flags & I2C_M_TEN;
+	msgs[1].flags |= I2C_M_RD;
+	msgs[1].len = len;
+	msgs[1].buf = val;
+
+	ret = i2c_transfer(client->adapter, msgs, 2);
+	return ret != 2 ? -EIO : 0;
+}
+
+static int elan_i2c_read_cmd(struct i2c_client *client, u16 reg, u8 
+*val) {
+	int retval;
+
+	retval = elan_i2c_read_block(client, reg, val, ETP_INF_LENGTH);
+	if (retval < 0) {
+		dev_err(&client->dev, "reading cmd (0x%04x) fail.\n", reg);
+		return retval;
+	}
+	return 0;
+}
+
+static int elan_i2c_write_cmd(struct i2c_client *client, u16 reg, u16 
+cmd) {
+	struct i2c_msg msg;
+	u8 buf[4];
+	int ret;
+
+	buf[0] = reg & 0xff;
+	buf[1] = (reg >> 8) & 0xff;
+	buf[2] = cmd & 0xff;
+	buf[3] = (cmd >> 8) & 0xff;
+
+	msg.addr = client->addr;
+	msg.flags = client->flags & I2C_M_TEN;
+	msg.len = 4;
+	msg.buf = buf;
+
+	ret = i2c_transfer(client->adapter, &msg, 1);
+	return ret != 1 ? -EIO : 0;
+}
+
+static int elan_i2c_reset(struct i2c_client *client) {
+	return elan_i2c_write_cmd(client, ETP_I2C_STAND_CMD,
+				  ETP_I2C_RESET);
+}
+
+static int elan_i2c_wake_up(struct i2c_client *client) {
+	return elan_i2c_write_cmd(client, ETP_I2C_STAND_CMD,
+				  ETP_I2C_WAKE_UP);
+}
+
+static int elan_i2c_sleep(struct i2c_client *client) {
+	return elan_i2c_write_cmd(client, ETP_I2C_STAND_CMD,
+				  ETP_I2C_SLEEP);
+}
+
+static int elan_i2c_enable_absolute_mode(struct i2c_client *client) {
+	return elan_i2c_write_cmd(client, ETP_I2C_SET_CMD,
+				  ETP_ENABLE_ABS);
+}
+
+static int elan_i2c_get_desc(struct i2c_client *client, u8 *val) {
+	return elan_i2c_read_block(client, ETP_I2C_DESC_CMD, val,
+				   ETP_I2C_DESC_LENGTH);
+}
+
+static int elan_i2c_get_report_desc(struct i2c_client *client, u8 *val) 
+{
+	return elan_i2c_read_block(client, ETP_I2C_REPORT_DESC_CMD,
+				   val, ETP_I2C_REPORT_DESC_LENGTH); }
+
+static int elan_i2c_initialize(struct i2c_client *client) {
+	struct device *dev = &client->dev;
+	int rc;
+	u8 val[256];
+
+	rc = elan_i2c_reset(client);
+	if (rc < 0) {
+		dev_err(dev, "device reset failed.\n");
+		return -1;
+	}
+
+	/* wait for get reset return flag */
+	msleep(100);
+	/* get reset return flag 0000 */
+	rc = i2c_master_recv(client, val, ETP_INF_LENGTH);
+	if (rc < 0) {
+		dev_err(dev, "get device reset return value failed.\n");
+		return -1;
+	}
+
+	rc = elan_i2c_get_desc(client, val);
+	if (rc < 0) {
+		dev_err(dev, "cannot get device descriptor.\n");
+		return -1;
+	}
+
+	rc = elan_i2c_get_report_desc(client, val);
+	if (rc < 0) {
+		dev_err(dev, "fetching report descriptor failed.\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ ******************************************************************
+ * General functions
+ ******************************************************************
+ */
+/*
+ * (value from firmware) * 10 + 790 = dpi
+ * we also have to convert dpi to dots/mm (*10/254 to avoid floating 
+point)  */ static unsigned int elan_convert_res(char val) {
+	int res;
+	if (val & 0x80) {
+		val = ~val + 1;
+		res = (790 - val * 10) * 10 / 254;
+	} else
+		res = (val * 10 + 790) * 10 / 254;
+	return res;
+}
+
+static int elan_get_iap_version(struct elan_tp_data *data) {
+	int ret;
+	u8 val[3];
+	if (data->smbus) {
+		i2c_smbus_read_block_data(data->client,
+					  ETP_SMBUS_IAP_VERSION_CMD, val);
+		ret = val[2];
+	} else {
+		elan_i2c_read_cmd(data->client,
+				  ETP_I2C_IAP_VERSION_CMD, val);
+		ret = val[0];
+	}
+	return ret;
+}
+
+static int elan_get_x_max(struct elan_tp_data *data) {
+	int ret;
+	u8 val[3];
+	if (data->smbus) {
+		i2c_smbus_read_block_data(data->client,
+					  ETP_SMBUS_RANGE_CMD, val);
+		ret = (0x0f & val[0]) << 8 | val[1];
+	} else {
+		elan_i2c_read_cmd(data->client,
+				  ETP_I2C_MAX_X_AXIS_CMD, val);
+		ret = (0x0f & val[1]) << 8 | val[0];
+	}
+	return ret;
+}
+
+static int elan_get_y_max(struct elan_tp_data *data) {
+	int ret;
+	u8 val[3];
+	if (data->smbus) {
+		i2c_smbus_read_block_data(data->client,
+					  ETP_SMBUS_RANGE_CMD, val);
+		ret = (0xf0 & val[0]) << 4 | val[2];
+	} else {
+		elan_i2c_read_cmd(data->client,
+				  ETP_I2C_MAX_Y_AXIS_CMD, val);
+		ret = (0x0f & val[1]) << 8 | val[0];
+	}
+	return ret;
+}
+
+static int elan_get_x_tracenum(struct elan_tp_data *data) {
+	int ret;
+	u8 val[3];
+	if (data->smbus) {
+		i2c_smbus_read_block_data(data->client,
+					  ETP_SMBUS_XY_TRACENUM_CMD, val);
+		ret = (val[1] - 1);
+	} else {
+		elan_i2c_read_cmd(data->client,
+				  ETP_I2C_XY_TRACENUM_CMD, val);
+		ret = (val[0] - 1);
+	}
+	return ret;
+}
+
+static int elan_get_y_tracenum(struct elan_tp_data *data) {
+	int ret;
+	u8 val[3];
+	if (data->smbus) {
+		i2c_smbus_read_block_data(data->client,
+					  ETP_SMBUS_XY_TRACENUM_CMD, val);
+		ret = (val[2] - 1);
+	} else {
+		ret = elan_i2c_read_cmd(data->client,
+					ETP_I2C_XY_TRACENUM_CMD, val);
+		ret = (val[1] - 1);
+	}
+	return ret;
+}
+
+static int elan_get_fw_version(struct elan_tp_data *data) {
+	int ret;
+	u8 val[3];
+	if (data->smbus) {
+		i2c_smbus_read_block_data(data->client,
+					  ETP_SMBUS_FW_VERSION_CMD, val);
+		ret = val[2];
+	} else {
+		elan_i2c_read_cmd(data->client,
+				  ETP_I2C_FW_VERSION_CMD, val);
+		ret = val[0];
+	}
+	return ret;
+}
+
+static int elan_get_sm_version(struct elan_tp_data *data) {
+	int ret;
+	u8 val[3];
+	if (data->smbus)
+		i2c_smbus_read_block_data(data->client,
+					  ETP_SMBUS_SM_VERSION_CMD, val);
+	else
+		elan_i2c_read_block(data->client,
+				    ETP_I2C_SM_VERSION_CMD, val, 1);
+	ret = val[0];
+	return ret;
+}
+
+static int elan_get_unique_id(struct elan_tp_data *data) {
+	int ret;
+	u8 val[3];
+	if (data->smbus) {
+		i2c_smbus_read_block_data(data->client,
+					  ETP_SMBUS_UNIQUEID_CMD, val);
+		ret = val[1];
+	} else {
+		elan_i2c_read_cmd(data->client,
+				  ETP_I2C_UNIQUEID_CMD, val);
+		ret = val[0];
+	}
+	return ret;
+}
+
+static int elan_get_x_resolution(struct elan_tp_data *data) {
+	int ret;
+	u8 val[3];
+	if (data->smbus) {
+		i2c_smbus_read_block_data(data->client,
+					  ETP_SMBUS_RESOLUTION_CMD, val);
+		ret = elan_convert_res(val[1] & 0x0F);
+	} else {
+		elan_i2c_read_cmd(data->client,
+				  ETP_I2C_RESOLUTION_CMD, val);
+		ret = elan_convert_res(val[0]);
+	}
+	return ret;
+}
+
+static int elan_get_y_resolution(struct elan_tp_data *data) {
+	int ret;
+	u8 val[3];
+	if (data->smbus) {
+		i2c_smbus_read_block_data(data->client,
+					  ETP_SMBUS_RESOLUTION_CMD, val);
+		ret = elan_convert_res((val[1] & 0xF0) >> 4);
+	} else {
+		elan_i2c_read_cmd(data->client,
+				  ETP_I2C_RESOLUTION_CMD, val);
+		ret = elan_convert_res(val[1]);
+	}
+	return ret;
+}
+
+static int elan_initialize(struct elan_tp_data *data) {
+	int ret;
+	if (data->smbus) {
+		ret = elan_smbus_initialize(data->client);
+		if (ret < 0) {
+			dev_err(&data->client->dev,
+				"device initialize failed.\n");
+			goto err_initialize;
+		}
+
+		ret = elan_smbus_enable_absolute_mode(data->client);
+		if (ret < 0)
+			dev_err(&data->client->dev,
+				"cannot switch to absolute mode.\n");
+	} else {
+		ret = elan_i2c_initialize(data->client);
+		if (ret < 0) {
+			dev_err(&data->client->dev,
+				"device initialize failed.\n");
+			goto err_initialize;
+		}
+
+		ret = elan_i2c_enable_absolute_mode(data->client);
+		if (ret < 0) {
+			dev_err(&data->client->dev,
+				"cannot switch to absolute mode.\n");
+			goto err_initialize;
+		}
+
+		ret = elan_i2c_wake_up(data->client);
+		if (ret < 0)
+			dev_err(&data->client->dev,
+				"device wake up failed.\n");
+	}
+err_initialize:
+	return ret;
+}
+
+
+/*
+ ******************************************************************
+ * Elan isr functions
+ ******************************************************************
+ */
+static int elan_check_packet(struct elan_tp_data *data, u8 *packet) {
+	u8 rid;
+
+	if (data->smbus)
+		rid = packet[0];
+	else
+		rid = packet[ETP_I2C_REPORT_ID_OFFSET];
+
+	/* check report id */
+	if (rid != ETP_REPORT_ID) {
+		dev_err(&data->client->dev, "report id [%x] fail.\n", rid);
+		return -1;
+	}
+	return 0;
+}
+
+static void elan_report_absolute(struct elan_tp_data *data, u8 *packet) 
+{
+	struct input_dev *input = data->input;
+	u8 *finger_data;
+	bool finger_on;
+	int pos_x, pos_y;
+	int pressure, mk_x, mk_y;
+	int i, area_x, area_y, major, minor, new_pressure;
+	int finger_count = 0;
+	int btn_click;
+	u8  tp_info;
+
+	if (data->smbus) {
+		finger_data = &packet[ETP_SMBUS_FINGER_DATA_OFFSET];
+		tp_info = packet[1];
+	} else {
+		finger_data = &packet[ETP_I2C_FINGER_DATA_OFFSET];
+		tp_info = packet[3];
+	}
+
+	btn_click = (tp_info & 0x01);
+	for (i = 0; i < ETP_MAX_FINGERS; i++) {
+		finger_on = (tp_info >> (3 + i)) & 0x01;
+
+		/* analyze touched finger raw data*/
+		if (finger_on) {
+			pos_x = ((finger_data[0] & 0xf0) << 4) |
+							finger_data[1];
+			pos_y = ((finger_data[0] & 0x0f) << 8) |
+							finger_data[2];
+			pos_y =  data->max_y - pos_y;
+			mk_x = (finger_data[3] & 0x0f);
+			mk_y = (finger_data[3] >> 4);
+			pressure = finger_data[4];
+
+			/*
+			 * to avoid fat finger be as palm, so reduce the
+			 * width x and y per trace
+			 */
+			area_x = mk_x * (data->width_x - ETP_FWIDTH_REDUCE);
+			area_y = mk_y * (data->width_y - ETP_FWIDTH_REDUCE);
+
+			major = max(area_x, area_y);
+			minor = min(area_x, area_y);
+
+			new_pressure = pressure + ETP_PRESSURE_OFFSET;
+			if (new_pressure > ETP_MAX_PRESSURE)
+				new_pressure = ETP_MAX_PRESSURE;
+
+			input_mt_slot(input, i);
+			input_mt_report_slot_state(input, MT_TOOL_FINGER,
+						   true);
+			input_report_abs(input, ABS_MT_POSITION_X, pos_x);
+			input_report_abs(input, ABS_MT_POSITION_Y, pos_y);
+			input_report_abs(input, ABS_MT_PRESSURE, new_pressure);
+			input_report_abs(input, ABS_TOOL_WIDTH, mk_x);
+			input_report_abs(input, ABS_MT_TOUCH_MAJOR, major);
+			input_report_abs(input, ABS_MT_TOUCH_MINOR, minor);
+			finger_data += ETP_FINGER_DATA_LEN;
+			finger_count++;
+		} else {
+			input_mt_slot(input, i);
+			input_mt_report_slot_state(input,
+						   MT_TOOL_FINGER, false);
+		}
+	}
+
+	input_report_key(input, BTN_LEFT, (btn_click == 1));
+	input_mt_report_pointer_emulation(input, true);
+	input_sync(input);
+}
+
+static irqreturn_t elan_isr(int irq, void *dev_id) {
+	struct elan_tp_data *data = dev_id;
+	u8 raw[ETP_MAX_REPORT_LEN];
+	int retval;
+	int report_len;
+
+	if (data->smbus) {
+		report_len = ETP_SMBUS_REPORT_LEN;
+		retval = i2c_smbus_read_block_data(data->client,
+						   ETP_SMBUS_PACKET_QUERY,
+						   raw);
+	} else {
+		report_len = ETP_I2C_REPORT_LEN;
+		retval = i2c_master_recv(data->client, raw, report_len);
+	}
+
+	if (retval != report_len) {
+		dev_err(&data->client->dev, "wrong packet len(%d)", retval);
+		goto elan_isr_end;
+	}
+
+	if (elan_check_packet(data, raw) < 0) {
+		dev_err(&data->client->dev, "wrong packet format.");
+		goto elan_isr_end;
+	}
+	elan_report_absolute(data, raw);
+
+elan_isr_end:
+	return IRQ_HANDLED;
+}
+
+/*
+ ******************************************************************
+ * Elan initial functions
+ ******************************************************************
+ */
+static int elan_input_dev_create(struct elan_tp_data *data) {
+	struct i2c_client *client = data->client;
+	struct input_dev *input;
+	unsigned int x_res, y_res;
+	int ret, max_width, min_width;
+
+	data->input = input = input_allocate_device();
+	if (!input)
+		return -ENOMEM;
+	input->name = "Elan Touchpad";
+	input->id.bustype = BUS_I2C;
+	input->dev.parent = &data->client->dev;
+
+	__set_bit(EV_ABS, input->evbit);
+	__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
+	__set_bit(BTN_LEFT, input->keybit);
+
+	data->unique_id = elan_get_unique_id(data);
+	data->fw_version = elan_get_fw_version(data);
+	data->sm_version = elan_get_sm_version(data);
+	data->iap_version = elan_get_iap_version(data);
+	data->max_x = elan_get_x_max(data);
+	data->max_y = elan_get_y_max(data);
+	data->width_x = data->max_x / elan_get_x_tracenum(data);
+	data->width_y = data->max_y / elan_get_y_tracenum(data);
+	x_res = elan_get_x_resolution(data);
+	y_res = elan_get_y_resolution(data);
+	max_width = max(data->width_x, data->width_y);
+	min_width = min(data->width_x, data->width_y);
+
+	dev_dbg(&client->dev,
+		"Elan Touchpad Information:\n"
+		"    Module unique ID:  0x%04x\n"
+		"    Firmware Version:  0x%04x\n"
+		"    Sample Version:  0x%04x\n"
+		"    IAP Version:  0x%04x\n"
+		"    Max ABS X,Y:   %d,%d\n"
+		"    Width X,Y:   %d,%d\n"
+		"    Resolution X,Y:   %d,%d (dots/mm)\n",
+		data->unique_id,
+		data->fw_version,
+		data->sm_version,
+		data->iap_version,
+		data->max_x, data->max_y,
+		data->width_x, data->width_y,
+		(char)x_res, (char)y_res);
+


Why cast to char?
Ans: OK. I will remove char type.


+	input_set_abs_params(input, ABS_X, 0, data->max_x, 0, 0);
+	input_set_abs_params(input, ABS_Y, 0, data->max_y, 0, 0);
+	input_abs_set_res(input, ABS_X, x_res);
+	input_abs_set_res(input, ABS_Y, y_res);
+	input_set_abs_params(input, ABS_PRESSURE, 0, ETP_MAX_PRESSURE, 0, 0);
+	input_set_abs_params(input, ABS_TOOL_WIDTH, 0, ETP_FINGER_WIDTH, 0, 
+0);
+
+	/* handle pointer emulation and unused slots in core */
+	ret = input_mt_init_slots(input, ETP_MAX_FINGERS,
+				  INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED);
+	if (ret) {
+		dev_err(&client->dev, "allocate MT slots failed, %d\n", ret);
+		goto err_free_device;
+	}
+	input_set_abs_params(input, ABS_MT_POSITION_X, 0, data->max_x, 0, 0);
+	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, data->max_y, 0, 0);
+	input_abs_set_res(input, ABS_MT_POSITION_X, x_res);
+	input_abs_set_res(input, ABS_MT_POSITION_Y, y_res);
+	input_set_abs_params(input, ABS_MT_PRESSURE, 0,
+			     ETP_MAX_PRESSURE, 0, 0);
+	input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0,
+			     ETP_FINGER_WIDTH * max_width, 0, 0);
+	input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0,
+			     ETP_FINGER_WIDTH * min_width, 0, 0);
+
+	/* Register the device in input subsystem */
+	ret = input_register_device(input);
+	if (ret) {
+		dev_err(&client->dev, "input_dev register failed, %d\n", ret);
+		goto err_free_device;
+	}
+
+	return 0;
+
+err_free_device:
+	input_free_device(input);
+	return ret;
+}
+
+static u8 elan_check_adapter_functionality(struct i2c_client *client) {
+	u8 ret = ELAN_ADAPTER_FUNC_NONE;
+
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		ret |= ELAN_ADAPTER_FUNC_I2C;
+	if (i2c_check_functionality(client->adapter,
+				    I2C_FUNC_SMBUS_BYTE_DATA |
+				    I2C_FUNC_SMBUS_BLOCK_DATA |
+				    I2C_FUNC_SMBUS_I2C_BLOCK))
+		ret |= ELAN_ADAPTER_FUNC_SMBUS;
+	return ret;
+}
+
+static int elan_probe(struct i2c_client *client,
+		      const struct i2c_device_id *dev_id) {
+	struct elan_tp_data *data;
+	int ret;
+	u8 adapter_func;
+	union i2c_smbus_data dummy;
+	struct device *dev = &client->dev;
+
+	adapter_func = elan_check_adapter_functionality(client);
+	if (adapter_func == ELAN_ADAPTER_FUNC_NONE) {
+		dev_err(dev, "not a supported I2C/SMBus adapter\n");
+		return -EIO;
+	}
+
+	/* Make sure there is something at this address */
+	if (i2c_smbus_xfer(client->adapter, client->addr, 0,
+			   I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &dummy) < 0)
+		return -ENODEV;
+
+	data = kzalloc(sizeof(struct elan_tp_data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	/* check protocol type */
+	if (adapter_func == ELAN_ADAPTER_FUNC_SMBUS)
+		data->smbus = true;
+	else
+		data->smbus = false;
+	data->client = client;
+	data->irq = client->irq;
+
+	ret = request_threaded_irq(client->irq, NULL, elan_isr,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   client->name, data);
+	if (ret < 0) {
+		dev_err(&client->dev, "cannot register irq=%d\n",
+				client->irq);
+		goto err_irq;
+	}
+
+	/* initial elan touch pad */
+	ret = elan_initialize(data);
+	if (ret < 0)
+		goto err_init;
+
+	/* create input device */
+	ret = elan_input_dev_create(data);
+	if (ret < 0)
+		goto err_input_dev;
+
+	device_init_wakeup(&client->dev, 1);
+	i2c_set_clientdata(client, data);
+	return 0;
+
+err_input_dev:
+err_init:
+	free_irq(data->irq, data);
+err_irq:
+	kfree(data);
+	dev_err(&client->dev, "Elan Trackpad probe fail!\n");
+	return ret;
+}
+
+static int elan_remove(struct i2c_client *client) {
+	struct elan_tp_data *data = i2c_get_clientdata(client);
+	free_irq(data->irq, data);
+	input_free_device(data->input);


Not needed (and harmful here).

Ans: OK. I will remove this.

+	input_unregister_device(data->input);
+	kfree(data);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int elan_suspend(struct device *dev) {
+	int ret = 0;
+	struct elan_tp_data *data = dev_get_drvdata(dev);
+
+	disable_irq(data->irq);
+	if (data->smbus)
+		ret = i2c_smbus_write_byte(data->client,
+					   ETP_SMBUS_SLEEP_CMD);
+	else
+		ret = elan_i2c_sleep(data->client);
+
+	if (ret < 0)
+		dev_err(dev, "suspend mode failed, %d\n", ret);
+
+	return ret;
+}
+
+static int elan_resume(struct device *dev) {
+	int ret = 0;
+	struct elan_tp_data *data = dev_get_drvdata(dev);
+
+	ret = elan_initialize(data);
+	if (ret < 0)
+		dev_err(dev, "resume active power failed, %d\n", ret);
+
+	enable_irq(data->irq);
+	return ret;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(elan_pm_ops, elan_suspend, elan_resume);
+
+static const struct i2c_device_id elan_id[] = {
+	{ DRIVER_NAME, 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, elan_id);
+
+static struct i2c_driver elan_driver = {
+	.driver = {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &elan_pm_ops,
+	},
+	.probe		= elan_probe,
+	.remove		= elan_remove,
+	.id_table	= elan_id,
+};
+
+
+static int __init elan_init(void)
+{
+	int ret;
+	ret = i2c_add_driver(&elan_driver);
+	if (ret)
+		pr_err("elan driver register FAILED.\n");
+
+	return ret;
+}
+
+static void __exit elan_exit(void)
+{
+	i2c_del_driver(&elan_driver);
+}
+
+module_init(elan_init);
+module_exit(elan_exit);
+

module_i2c_driver().
Ans: OK. I will modify this.


+MODULE_AUTHOR("Duson Lin <dusonlin@emc.com.tw>"); 
+MODULE_DESCRIPTION("Elan I2C/SMBus Touchpad driver"); 
+MODULE_LICENSE("GPL");
--
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-input" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

















> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Tuesday, December 17, 2013 5:00 AM
> To: Duson Lin
> Cc: linux-input@vger.kernel.org; linux-kernel@vger.kernel.org;
> agnescheng@google.com; phoenix@emc.com.tw
> Subject: Re: [PATCH] Input: add i2c/smbus driver for elan touchpad
> 
> Hi Duson,
> 
> On Fri, Nov 22, 2013 at 01:56:55PM +0800, Duson Lin wrote:
> > This driver adds support for elan i2c/smbus touchpad found on some laptops PC
> > ---
> >  drivers/input/mouse/Kconfig    |   10 +
> >  drivers/input/mouse/Makefile   |    1 +
> >  drivers/input/mouse/elan_i2c.c | 1846
> ++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 1857 insertions(+)
> >  create mode 100644 drivers/input/mouse/elan_i2c.c
> >
> > diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> > index effa9c5..8ad4b38 100644
> > --- a/drivers/input/mouse/Kconfig
> > +++ b/drivers/input/mouse/Kconfig
> > @@ -215,6 +215,16 @@ config MOUSE_CYAPA
> >  	  To compile this driver as a module, choose M here: the module will be
> >  	  called cyapa.
> >
> > +config MOUSE_ELAN_I2C
> > +	tristate "ELAN I2C Touchpad support"
> > +	depends on I2C
> > +	help
> > +	  This driver adds support for Elan I2C Trackpads.
> > +	  Say y here if you have a ELAN I2C Touchpad.
> > +
> > +	  To compile this driver as a module, choose M here: the module will be
> > +	  called elan_i2c.
> > +
> >  config MOUSE_INPORT
> >  	tristate "InPort/MS/ATIXL busmouse"
> >  	depends on ISA
> > diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
> > index c25efdb..24a12a6 100644
> > --- a/drivers/input/mouse/Makefile
> > +++ b/drivers/input/mouse/Makefile
> > @@ -9,6 +9,7 @@ obj-$(CONFIG_MOUSE_APPLETOUCH)		+=
> appletouch.o
> >  obj-$(CONFIG_MOUSE_ATARI)		+= atarimouse.o
> >  obj-$(CONFIG_MOUSE_BCM5974)		+= bcm5974.o
> >  obj-$(CONFIG_MOUSE_CYAPA)		+= cyapa.o
> > +obj-$(CONFIG_MOUSE_ELAN_I2C)		+= elan_i2c.o
> >  obj-$(CONFIG_MOUSE_GPIO)		+= gpio_mouse.o
> >  obj-$(CONFIG_MOUSE_INPORT)		+= inport.o
> >  obj-$(CONFIG_MOUSE_LOGIBM)		+= logibm.o
> > diff --git a/drivers/input/mouse/elan_i2c.c b/drivers/input/mouse/elan_i2c.c
> > new file mode 100644
> > index 0000000..9892ee1
> > --- /dev/null
> > +++ b/drivers/input/mouse/elan_i2c.c
> > @@ -0,0 +1,1846 @@
> > +﻿/*
> > + * Elan I2C/SMBus Touchpad driver
> > + *
> > + * Copyright (c) 2013 ELAN Microelectronics Corp.
> > + *
> > + * Author: 林政維 (Duson Lin) <dusonlin@emc.com.tw>
> > + * Version: 1.4.6
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2 as published
> > + * by the Free Software Foundation.
> > + *
> > + * Trademarks are the property of their respective owners.
> > + */
> > +
> > +#include <linux/delay.h>
> > +#include <linux/device.h>
> > +#include <linux/firmware.h>
> > +#include <linux/i2c.h>
> > +#include <linux/init.h>
> > +#include <linux/input/mt.h>
> > +#include <linux/interrupt.h>
> > +#include <linux/module.h>
> > +#include <linux/slab.h>
> > +#include <linux/debugfs.h>
> > +#include <linux/cdev.h>
> > +#include <linux/kernel.h>
> > +#include <linux/major.h>
> > +#include <linux/sched.h>
> > +#include <linux/input.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/jiffies.h>
> > +
> > +#define DRIVER_NAME		"elan_i2c"
> > +#define ELAN_DRIVER_VERSION	"1.4.6"
> > +#define ETP_PRESSURE_OFFSET	25
> > +#define ETP_MAX_PRESSURE	255
> > +#define ETP_FWIDTH_REDUCE	90
> > +#define ETP_FINGER_WIDTH	15
> > +
> > +#define ELAN_ADAPTER_FUNC_NONE   0
> > +#define ELAN_ADAPTER_FUNC_I2C    1
> > +#define ELAN_ADAPTER_FUNC_SMBUS  2
> > +#define ELAN_ADAPTER_FUNC_BOTH   3
> > +
> > +/* Length of Elan touchpad information */
> > +#define ETP_INF_LENGTH		2
> > +#define ETP_MAX_FINGERS		5
> > +#define ETP_FINGER_DATA_LEN	5
> > +#define ETP_REPORT_ID		0x5D
> > +#define ETP_MAX_REPORT_LEN	34
> > +#define ETP_ENABLE_ABS		0x0001
> > +#define ETP_ENABLE_CALIBRATE	0x0002
> > +#define ETP_DISABLE_CALIBRATE	0x0000
> > +
> > +/* Elan smbus command */
> > +#define ETP_SMBUS_IAP_CMD		0x00
> > +#define ETP_SMBUS_ENABLE_TP		0x20
> > +#define ETP_SMBUS_DISABLE_TP		0x21
> > +#define ETP_SMBUS_IAP_PASSWORD_WRITE	0x29
> > +#define ETP_SMBUS_IAP_PASSWORD_READ	0x80
> > +#define ETP_SMBUS_WRITE_FW_BLOCK	0x2A
> > +#define ETP_SMBUS_IAP_RESET_CMD		0x2B
> > +#define ETP_SMBUS_RANGE_CMD		0xA0
> > +#define ETP_SMBUS_FW_VERSION_CMD	0xA1
> > +#define ETP_SMBUS_XY_TRACENUM_CMD	0xA2
> > +#define ETP_SMBUS_SM_VERSION_CMD	0xA3
> > +#define ETP_SMBUS_UNIQUEID_CMD		0xA3
> > +#define ETP_SMBUS_RESOLUTION_CMD	0xA4
> > +#define ETP_SMBUS_HELLOPACKET_CMD	0xA7
> > +#define ETP_SMBUS_PACKET_QUERY		0xA8
> > +#define ETP_SMBUS_IAP_VERSION_CMD	0xAC
> > +#define ETP_SMBUS_IAP_CTRL_CMD		0xAD
> > +#define ETP_SMBUS_IAP_CHECKSUM_CMD	0xAE
> > +#define ETP_SMBUS_FW_CHECKSUM_CMD	0xAF
> > +#define ETP_SMBUS_MAX_BASELINE_CMD	0xC3
> > +#define ETP_SMBUS_MIN_BASELINE_CMD	0xC4
> > +#define ETP_SMBUS_CALIBRATE_QUERY	0xC5
> > +#define ETP_SMBUS_REPORT_LEN		32
> > +#define ETP_SMBUS_FINGER_DATA_OFFSET	2
> > +#define ETP_SMBUS_HELLOPACKET_LEN	5
> > +#define ETP_SMBUS_IAP_PASSWORD		0x1234
> > +#define ETP_SMBUS_IAP_MODE_ON		(1<<6)
> > +
> > +/* Elan i2c command */
> > +#define ETP_I2C_RESET			0x0100
> > +#define ETP_I2C_WAKE_UP			0x0800
> > +#define ETP_I2C_SLEEP			0x0801
> > +#define ETP_I2C_DESC_CMD		0x0001
> > +#define ETP_I2C_REPORT_DESC_CMD		0x0002
> > +#define ETP_I2C_STAND_CMD		0x0005
> > +#define ETP_I2C_UNIQUEID_CMD		0x0101
> > +#define ETP_I2C_FW_VERSION_CMD		0x0102
> > +#define ETP_I2C_SM_VERSION_CMD		0x0103
> > +#define ETP_I2C_XY_TRACENUM_CMD		0x0105
> > +#define ETP_I2C_MAX_X_AXIS_CMD		0x0106
> > +#define ETP_I2C_MAX_Y_AXIS_CMD		0x0107
> > +#define ETP_I2C_RESOLUTION_CMD		0x0108
> > +#define ETP_I2C_IAP_VERSION_CMD		0x0110
> > +#define ETP_I2C_SET_CMD			0x0300
> > +#define ETP_I2C_MAX_BASELINE_CMD	0x0306
> > +#define ETP_I2C_MIN_BASELINE_CMD	0x0307
> > +#define ETP_I2C_FW_CHECKSUM_CMD		0x030F
> > +#define ETP_I2C_IAP_CTRL_CMD		0x0310
> > +#define ETP_I2C_IAP_CMD			0x0311
> > +#define ETP_I2C_IAP_RESET_CMD		0x0314
> > +#define ETP_I2C_IAP_CHECKSUM_CMD	0x0315
> > +#define ETP_I2C_CALIBRATE_CMD		0x0316
> > +#define ETP_I2C_REPORT_LEN		34
> > +#define ETP_I2C_FINGER_DATA_OFFSET	4
> > +#define ETP_I2C_REPORT_ID_OFFSET	2
> > +#define ETP_I2C_DESC_LENGTH		30
> > +#define ETP_I2C_REPORT_DESC_LENGTH	158
> > +#define ETP_I2C_IAP_PASSWORD		0x1EA5
> > +#define ETP_I2C_IAP_RESET		0xF0F0
> > +#define ETP_I2C_MAIN_MODE_ON		(1<<9)
> > +#define ETP_I2C_IAP_REG_L		0x01
> > +#define ETP_I2C_IAP_REG_H		0x06
> > +
> > +/* IAP F/W updater */
> > +#define ETP_FW_NAME		"elan_i2c.bin"
> > +#define ETP_IAP_VERSION_ADDR	0x0082
> > +#define ETP_IAP_START_ADDR	0x0083
> > +#define ETP_FW_IAP_PAGE_ERR	(1<<5)
> > +#define ETP_FW_IAP_INTERFACE_ERR (1<<4)
> > +#define ETP_FW_PAGE_SIZE	64
> > +#define ETP_FW_PAGE_COUNT	768
> > +#define ETP_FW_SIZE		(ETP_FW_PAGE_SIZE *
> ETP_FW_PAGE_COUNT)
> > +enum {UNKNOWN_MODE, IAP_MODE, MAIN_MODE};
> > +
> > +struct dbfs_data {
> > +	bool	bfetch;
> > +	u8	buffer[ETP_MAX_REPORT_LEN];
> > +};
> > +
> > +/* The main device structure */
> > +struct elan_tp_data {
> > +	struct i2c_client	*client;
> > +	struct input_dev	*input;
> > +	unsigned int		max_x;
> > +	unsigned int		max_y;
> > +	unsigned int		width_x;
> > +	unsigned int		width_y;
> > +	unsigned int		irq;
> > +
> > +	/* fields required for IAP firmware updater */
> > +	u16			unique_id;
> > +	u16			fw_version;
> > +	u16			sm_version;
> > +	u16			iap_version;
> > +	bool			updated_fw;
> > +	u16			iap_start_addr;
> > +
> > +	/* irq wake is enabled */
> > +	bool			irq_wake;
> > +	bool			smbus;
> > +	bool			enable_detail_info;
> > +
> > +	/* fields required for debug fs */
> > +	struct mutex		dbfs_mutex;
> > +	struct dentry		*dbfs_root;
> > +	struct dbfs_data	dbfs_buffer;
> > +};
> > +
> > +u8 val[256];
> > +static int elan_i2c_read_cmd(struct i2c_client *client, u16 reg, u8 *val);
> > +static int elan_i2c_write_cmd(struct i2c_client *client, u16 reg, u16 cmd);
> > +static int elan_initialize(struct elan_tp_data *data);
> > +
> > +/*
> > + **************************************************************
> > + * debugfs interface
> > + **************************************************************
> > +*/
> > +static int elan_dbfs_open(struct inode *inode, struct file *file)
> > +{
> > +	int retval;
> > +	struct elan_tp_data *data = inode->i_private;
> > +
> > +	if (!data)
> > +		return -ENODEV;
> > +
> > +	retval = mutex_lock_interruptible(&data->dbfs_mutex);
> > +	if (retval)
> > +		return retval;
> > +
> > +	if (!kobject_get(&data->client->dev.kobj)) {
> 
> Why are you pinning I2C device kobject? It will not prevent unbinding
> the driver if that's what you are aiming for.
> 
> > +		retval = -ENODEV;
> > +		goto dbfs_out;
> > +	}
> > +
> > +	file->private_data = data;
> > +dbfs_out:
> > +	mutex_unlock(&data->dbfs_mutex);
> > +	return 0;
> > +}
> > +
> > +static int elan_dbfs_release(struct inode *inode, struct file *file)
> > +{
> > +	struct elan_tp_data *data = file->private_data;
> > +	int retval;
> > +	if (!data)
> > +		return -ENODEV;
> > +
> > +	retval = mutex_lock_interruptible(&data->dbfs_mutex);
> > +	if (retval)
> > +		return retval;
> > +	file->private_data = NULL;
> > +	kobject_put(&data->client->dev.kobj);
> > +	mutex_unlock(&data->dbfs_mutex);
> > +	return 0;
> > +}
> > +
> > +
> > +static ssize_t elan_dbfs_read(struct file *file,
> > +		char __user *buffer, size_t count, loff_t *ppos)
> > +{
> > +	struct elan_tp_data *data = file->private_data;
> > +	int retval;
> > +	if (!data)
> > +		return -ENODEV;
> > +
> > +	retval = mutex_lock_interruptible(&data->dbfs_mutex);
> > +	if (retval)
> > +		return -EFAULT;
> > +	if (data->dbfs_buffer.bfetch == false) {
> > +		if (!copy_to_user(buffer, data->dbfs_buffer.buffer, count)) {
> > +			data->dbfs_buffer.bfetch = true;
> > +			retval = count;
> > +		} else {
> > +			retval = -2;
> 
> -ENOENT? Why?
> 
> > +		}
> > +	} else {
> > +		retval = -4;
> 
> -EINTR???
> 
> > +	}
> > +	mutex_unlock(&data->dbfs_mutex);
> > +	return retval;
> > +}
> > +
> > +static ssize_t elan_dbfs_write(struct file *file,
> > +		const char __user *buffer, size_t count, loff_t *ppos)
> > +{
> > +	struct elan_tp_data *data = file->private_data;
> > +	int retval;
> > +	if (!data)
> > +		return -ENODEV;
> > +
> > +	retval = mutex_lock_interruptible(&data->dbfs_mutex);
> > +	if (retval)
> > +		return -EFAULT;
> > +	retval = count;
> > +	mutex_unlock(&data->dbfs_mutex);
> > +	return retval;
> > +}
> 
> This looks like an unneeded stub.
> 
> > +
> > +static long elan_dbfs_ioctrl(struct file *file,
> > +		unsigned int cmd, unsigned long arg)
> > +{
> > +	int retval = 0;
> > +	struct elan_tp_data *data = file->private_data;
> > +
> > +	retval = mutex_lock_interruptible(&data->dbfs_mutex);
> > +	if (retval)
> > +		return retval;
> > +	mutex_unlock(&data->dbfs_mutex);
> > +	return retval;
> > +}
> 
> Same here.
> 
> > +
> > +static const struct file_operations elan_debug_fops = {
> > +	.open = elan_dbfs_open,
> > +	.release = elan_dbfs_release,
> > +	.read = elan_dbfs_read,
> > +	.write = elan_dbfs_write,
> > +	.unlocked_ioctl = elan_dbfs_ioctrl
> > +};
> > +
> > +static int elan_dbfs_init(struct elan_tp_data *data)
> > +{
> > +	/* Create a global debugfs root for all elan devices */
> > +	/* sys/kernel/debug/elan */
> > +	data->dbfs_root = debugfs_create_dir("elan", NULL);
> > +	if (!data->dbfs_root) {
> > +		dev_err(&data->client->dev, "cannot create dbfs_root.\n");
> > +		return -ENODEV;
> > +	}
> 
> That should not be done in per-device code. That said, do you really
> need to dump your packets - looks like you are done with the driver
> development?
> 
> > +	mutex_init(&data->dbfs_mutex);
> > +
> > +	debugfs_create_file(DRIVER_NAME, 0777,
> > +				data->dbfs_root, data, &elan_debug_fops);
> > +	data->dbfs_buffer.bfetch = false;
> > +	return 0;
> > +}
> > +
> > +/**********************************************************
> > + * IAP firmware updater related routines                  *
> > + **********************************************************
> > +*/
> > +
> > +static int elan_iap_getmode(struct elan_tp_data *data)
> > +{
> > +	u16 constant;
> > +	int retval;
> > +	struct i2c_client *client = data->client;
> > +
> > +	if (data->smbus) {
> > +		retval = i2c_smbus_read_block_data(client,
> > +					ETP_SMBUS_IAP_CTRL_CMD, val);
> > +		if (retval < 0) {
> > +			dev_err(&client->dev, "read iap ctrol fail.\n");
> > +			return UNKNOWN_MODE;
> > +		}
> > +		constant = be16_to_cpup((__be16 *)val);
> > +		dev_dbg(&client->dev, "smbus iap control reg: 0x%04x.\n",
> > +								constant);
> > +		if ((constant & ETP_SMBUS_IAP_MODE_ON) == 0x00)
> > +			return MAIN_MODE;
> > +	} else {
> > +		retval = elan_i2c_read_cmd(client, ETP_I2C_IAP_CTRL_CMD, val);
> > +		if (retval < 0) {
> > +			dev_err(&client->dev, "read iap ctrol fail.\n");
> > +			return UNKNOWN_MODE;
> > +		}
> > +		constant = le16_to_cpup((__le16 *)val);
> > +		dev_dbg(&client->dev, "i2c iap control reg: 0x%04x.\n",
> > +								constant);
> > +		if (constant & ETP_I2C_MAIN_MODE_ON)
> > +			return MAIN_MODE;
> > +	}
> 
> Instead of doing
> 
> 	if (smbus)
> 		do_this();
> 	else
> 		do_that();
> 
> everywhere maybe you could define transport functions and invoke them
> through a pointer to transport ops?
> 
> 
> > +
> > +	return IAP_MODE;
> > +}
> > +
> > +static int elan_iap_checksum(struct elan_tp_data *data)
> > +{
> > +	int retval = 0;
> > +	u16 checksum = -1;
> > +	struct i2c_client *client = data->client;
> > +
> > +	if (data->smbus) {
> > +		retval = i2c_smbus_read_block_data(client,
> > +					ETP_SMBUS_IAP_CHECKSUM_CMD, val);
> > +		if (retval < 0) {
> > +			dev_err(&client->dev, "Read checksum fail, %d\n",
> > +								retval);
> > +			return -1;
> > +		}
> > +		checksum = be16_to_cpup((__be16 *)val);
> > +	} else {
> > +		retval = elan_i2c_read_cmd(client,
> > +					ETP_I2C_IAP_CHECKSUM_CMD, val);
> > +		if (retval < 0) {
> > +			dev_err(&client->dev, "Read checksum fail, %d\n",
> > +								retval);
> > +			return -1;
> > +		}
> > +		checksum = le16_to_cpup((__le16 *)val);
> > +	}
> > +	return checksum;
> > +}
> > +
> > +static bool elan_iap_reset(struct elan_tp_data *data)
> > +{
> > +	int retval = 0;
> > +	struct i2c_client *client = data->client;
> > +
> > +	if (data->smbus)
> > +		retval = i2c_smbus_write_byte(client,
> > +						ETP_SMBUS_IAP_RESET_CMD);
> > +	else
> > +		retval = elan_i2c_write_cmd(client, ETP_I2C_IAP_RESET_CMD,
> > +						ETP_I2C_IAP_RESET);
> > +	if (retval < 0) {
> > +		dev_err(&client->dev, "cannot reset IC, %d\n", retval);
> > +		return false;
> > +	}
> > +	return true;
> > +}
> > +
> > +static bool elan_iap_setflashkey(struct elan_tp_data *data)
> > +{
> > +	int retval = 0;
> > +	struct i2c_client *client = data->client;
> > +	u8 smbus_cmd[4] = {0x00, 0x0B, 0x00, 0x5A};
> > +
> > +	if (data->smbus)
> > +		retval = i2c_smbus_write_block_data(client,
> > +				ETP_SMBUS_IAP_CMD, 4, smbus_cmd);
> > +	else
> > +		retval = elan_i2c_write_cmd(client, ETP_I2C_IAP_CMD,
> > +					ETP_I2C_IAP_PASSWORD);
> > +	if (retval < 0) {
> > +		dev_err(&client->dev, "cannot set flash key, %d\n", retval);
> > +		return false;
> > +	}
> > +
> > +	return true;
> > +}
> > +
> > +static int elan_check_fw(struct elan_tp_data *data,
> > +				const struct firmware *fw)
> > +{
> > +	struct device *dev = &data->client->dev;
> > +
> > +	/* Firmware must match exact PAGE_NUM * PAGE_SIZE bytes */
> > +	if (fw->size != ETP_FW_SIZE) {
> > +		dev_err(dev, "invalid firmware size = %zu, expected %d.\n",
> > +					fw->size, ETP_FW_SIZE);
> > +		return -EBADF;
> > +	}
> > +
> > +	/* Get IAP Start Address*/
> > +	memcpy(val, &fw->data[ETP_IAP_START_ADDR * 2], 2);
> > +	data->iap_start_addr = le16_to_cpup((__le16 *)val);
> > +	return 0;
> > +}
> > +
> > +
> > +static int elan_smbus_prepare_fw_update(struct elan_tp_data *data)
> > +{
> > +	struct i2c_client *client = data->client;
> > +	struct device *dev = &data->client->dev;
> > +	u16 password;
> > +	u8 cmd[4] = {0x0F, 0x78, 0x00, 0x06};
> > +
> > +	/* Get FW in which mode	(IAP_MODE/MAIN_MODE)  */
> > +	int mode = elan_iap_getmode(data);
> > +	if (mode == UNKNOWN_MODE)
> > +		return -1;
> > +
> > +	if (mode == MAIN_MODE) {
> > +
> > +		/* set flash key*/
> > +		if (elan_iap_setflashkey(data) == false) {
> > +			dev_err(dev, "cannot set flash key\n");
> > +			return -1;
> > +		}
> > +
> > +		/* write iap password */
> > +		if (i2c_smbus_write_byte(client,
> > +				ETP_SMBUS_IAP_PASSWORD_WRITE) < 0) {
> > +			dev_err(dev, "cannot write iap password\n");
> > +			return -1;
> 
> Would be nice using appropriate error codes. EIO?
> 
> > +		}
> > +
> > +		if (i2c_smbus_write_block_data(client,
> > +				ETP_SMBUS_IAP_CMD, 4, cmd) < 0) {
> > +			dev_err(dev, "cannot write cmd\n");
> > +			return -1;
> > +		}
> > +
> > +		/* read password to check we enabled successfully. */
> > +		if (i2c_smbus_read_block_data(client,
> > +				ETP_SMBUS_IAP_PASSWORD_READ, val) < 0) {
> > +			dev_err(dev, "cannot get iap password\n");
> > +			return -1;
> > +		}
> > +		password = be16_to_cpup((__be16 *)val);
> > +
> > +		if (password != ETP_SMBUS_IAP_PASSWORD) {
> > +			dev_err(dev, "wrong iap password = 0x%X\n", password);
> > +			return -1;
> > +		}
> > +		/* wait 30ms, from MAIN_MODE change to IAP_MODE*/
> > +		msleep(30);
> > +	}
> > +
> > +	/* set flash key*/
> > +	if (elan_iap_setflashkey(data) == false) {
> > +		dev_err(dev, "cannot set flash key\n");
> > +		return -1;
> > +	}
> > +
> > +	/* Reset IC */
> > +	if (elan_iap_reset(data) == false) {
> > +		dev_err(dev, "iap reset fail.\n");
> > +		return -1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int elan_i2c_prepare_fw_update(struct elan_tp_data *data)
> > +{
> > +	struct i2c_client *client = data->client;
> > +	struct device *dev = &data->client->dev;
> > +	u16 password;
> > +
> > +	/* Get FW in which mode	(IAP_MODE/MAIN_MODE)  */
> > +	int mode = elan_iap_getmode(data);
> > +	if (mode == UNKNOWN_MODE)
> > +		return -1;
> > +
> > +	if (mode == IAP_MODE) {
> > +		/* Reset IC */
> > +		if (elan_iap_reset(data) == false)
> > +			return -1;
> > +		msleep(30);
> > +	}
> > +
> > +	/* set flash key*/
> > +	if (elan_iap_setflashkey(data) == false) {
> > +		dev_err(dev, "cannot set flash key\n");
> > +		return -1;
> > +	}
> > +
> > +	/* Wait for F/W IAP initialization */
> > +	if (mode == MAIN_MODE)
> > +		msleep(100);
> > +	else
> > +		msleep(30);
> > +
> > +	/* check is in iap mode or not*/
> > +	if (elan_iap_getmode(data) == MAIN_MODE) {
> > +		dev_err(dev, "status wrong.\n");
> > +		return -1;
> > +	}
> > +
> > +	/* set flash key again */
> > +	if (elan_iap_setflashkey(data) == false) {
> > +		dev_err(dev, "cannot set flash key\n");
> > +		return -1;
> > +	}
> > +
> > +	/* Wait for F/W IAP initialization */
> > +	if (mode == MAIN_MODE)
> > +		msleep(100);
> > +	else
> > +		msleep(30);
> > +
> > +	/* read back to check we actually enabled successfully. */
> > +	if (elan_i2c_read_cmd(client, ETP_I2C_IAP_CMD, val) < 0) {
> > +		dev_err(dev, "cannot get iap register\n");
> > +		return -1;
> > +	}
> > +	password = le16_to_cpup((__le16 *)val);
> > +
> > +	if (password != ETP_I2C_IAP_PASSWORD) {
> > +		dev_err(dev, "wrong iap password = 0x%X\n", password);
> > +		return -1;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static bool elan_iap_page_write_ok(struct elan_tp_data *data)
> > +{
> > +	u16 constant;
> > +	int retval = 0;
> > +	struct i2c_client *client = data->client;
> > +
> > +
> > +	if (data->smbus) {
> > +		retval = i2c_smbus_read_block_data(client,
> > +					ETP_SMBUS_IAP_CTRL_CMD, val);
> > +		if (retval < 0)
> > +			return false;
> > +		constant = be16_to_cpup((__be16 *)val);
> > +	} else {
> > +		retval = elan_i2c_read_cmd(client,
> > +					ETP_I2C_IAP_CTRL_CMD, val);
> > +		if (retval < 0)
> > +			return false;
> > +		constant = le16_to_cpup((__le16 *)val);
> > +	}
> > +
> > +	if (constant & ETP_FW_IAP_PAGE_ERR)
> > +		return false;
> > +
> > +	if (constant & ETP_FW_IAP_INTERFACE_ERR)
> > +		return false;
> > +	return true;
> > +}
> > +
> > +static int elan_smbus_write_fw_block(struct elan_tp_data *data,
> > +				const u8 *page, u16 checksum, int idx)
> > +{
> > +	struct device *dev = &data->client->dev;
> > +	int half_page_size = ETP_FW_PAGE_SIZE / 2;
> > +	int repeat = 3;
> > +
> > +	do {
> > +		/* due to smbus can write 32 bytes one time,
> > +		so, we must write data 2 times.
> > +		*/
> > +		i2c_smbus_write_block_data(data->client,
> > +					ETP_SMBUS_WRITE_FW_BLOCK,
> > +					half_page_size,
> > +					page);
> > +		i2c_smbus_write_block_data(data->client,
> > +					ETP_SMBUS_WRITE_FW_BLOCK,
> > +					half_page_size,
> > +					(page + half_page_size));
> > +		/* Wait for F/W to update one page ROM data. */
> > +		usleep_range(8000, 10000);
> > +		if (elan_iap_page_write_ok(data))
> > +			break;
> > +		dev_info(dev, "IAP retry this page! [%d]\n", idx);
> > +		repeat--;
> > +	} while (repeat == 0);
> > +
> > +	if (repeat > 0)
> > +		return 0;
> > +	return -1;
> > +
> > +}
> > +
> > +static int elan_i2c_write_fw_block(struct elan_tp_data *data,
> > +				const u8 *page, u16 checksum, int idx)
> > +{
> > +	struct device *dev = &data->client->dev;
> > +	int ret;
> > +	int repeat = 3;
> > +	u8 page_store[ETP_FW_PAGE_SIZE + 4];
> > +
> > +	page_store[0] = ETP_I2C_IAP_REG_L;
> > +	page_store[1] = ETP_I2C_IAP_REG_H;
> > +	memcpy(&page_store[2], page, ETP_FW_PAGE_SIZE);
> > +
> > +	/* recode checksum at last two bytes */
> > +	page_store[ETP_FW_PAGE_SIZE+2] = (u8)(checksum & 0xFF);
> > +	page_store[ETP_FW_PAGE_SIZE+3] = (u8)((checksum >> 8)&0xFF);
> > +
> > +	do {
> > +		ret = i2c_master_send(data->client, page_store,
> > +						ETP_FW_PAGE_SIZE + 4);
> > +
> > +		/* Wait for F/W to update one page ROM data. */
> > +		msleep(20);
> > +
> > +		if (ret == (ETP_FW_PAGE_SIZE + 4)) {
> > +			if (elan_iap_page_write_ok(data))
> > +				break;
> > +		}
> > +		dev_dbg(dev, "IAP retry this page! [%d]\n", idx);
> > +		repeat--;
> > +	} while (repeat == 0);
> > +
> > +	if (repeat > 0)
> > +		return 0;
> > +	return -1;
> > +}
> > +
> > +static int elan_write_fw_block(struct elan_tp_data *data,
> > +				const u8 *page, u16 checksum, int idx)
> > +{
> > +	int ret;
> > +	if (data->smbus)
> > +		ret = elan_smbus_write_fw_block(data, page, checksum, idx);
> > +	else
> > +		ret = elan_i2c_write_fw_block(data, page, checksum, idx);
> > +	return ret;
> > +}
> > +
> > +static int elan_prepare_fw_update(struct elan_tp_data *data)
> > +{
> > +	int ret = 0;
> > +	if (data->smbus)
> > +		ret = elan_smbus_prepare_fw_update(data);
> > +	else
> > +		ret = elan_i2c_prepare_fw_update(data);
> > +	return ret;
> > +}
> > +
> > +static int elan_firmware(struct elan_tp_data *data)
> > +{
> > +	struct device *dev = &data->client->dev;
> > +	const struct firmware *fw;
> > +	const char *fw_name = ETP_FW_NAME;
> > +	int i, j, ret;
> > +	u16 boot_page_count;
> > +	u16 sw_checksum, fw_checksum;
> > +	data->updated_fw = true;
> > +
> > +	dev_info(dev, "Start firmware update....\n");
> > +
> > +	ret = request_firmware(&fw, ETP_FW_NAME, dev);
> > +	if (ret) {
> > +		dev_err(dev, "cannot load firmware from %s, %d\n",
> > +							fw_name, ret);
> > +		goto done;
> > +	}
> > +	/* check fw data match current iap version */
> > +	ret = elan_check_fw(data, fw);
> > +	if (ret) {
> > +		dev_err(dev, "Invalid Elan firmware from %s, %d\n",
> > +							fw_name, ret);
> > +		goto done;
> > +	}
> > +	/* setup IAP status */
> > +	ret = elan_prepare_fw_update(data);
> > +	if (ret)
> > +		goto done;
> > +	sw_checksum = 0;
> > +	fw_checksum = 0;
> > +	boot_page_count = (data->iap_start_addr * 2) / ETP_FW_PAGE_SIZE;
> > +	for (i = boot_page_count; i < ETP_FW_PAGE_COUNT; i++) {
> > +		u16 checksum = 0;
> > +		const u8 *page = &fw->data[i * ETP_FW_PAGE_SIZE];
> > +
> > +		for (j = 0; j < ETP_FW_PAGE_SIZE; j += 2)
> > +			checksum += ((page[j + 1] << 8) | page[j]);
> > +
> > +		ret = elan_write_fw_block(data, page, checksum, i);
> > +		if (ret) {
> > +			dev_err(dev, "write page %d fail\n", i);
> > +			goto done;
> > +		}
> > +		sw_checksum += checksum;
> > +	}
> > +
> > +	/* Wait WDT reset and power on reset */
> > +	msleep(600);
> > +
> > +	/* check checksum */
> > +	fw_checksum = elan_iap_checksum(data);
> > +	if (sw_checksum != fw_checksum) {
> > +		dev_err(dev, "checksum diff sw=[%04X], fw=[%04X]\n",
> > +					sw_checksum, fw_checksum);
> > +		ret = -1;
> > +		goto done;
> > +	}
> > +	ret = 0;
> > +done:
> > +	if (ret != 0) {
> > +		elan_iap_reset(data);
> > +		data->updated_fw = false;
> > +	} else {
> > +		if (data->smbus) {
> > +			data->updated_fw = false;
> > +			elan_initialize(data);
> > +		}
> > +	}
> > +	release_firmware(fw);
> > +	return ret;
> > +}
> > +
> > +/******************************************************************
> > +* Elan smbus interface
> > +*******************************************************************
> > +*/
> > +static int elan_smbus_initialize(struct i2c_client *client)
> > +{
> > +	u8 check[ETP_SMBUS_HELLOPACKET_LEN] = {0x55, 0x55, 0x55, 0x55,
> 0x55};
> > +	u8 values[ETP_SMBUS_HELLOPACKET_LEN] = {0, 0, 0, 0, 0};
> > +	int ret;
> > +
> > +	/* Get hello packet */
> > +	ret = i2c_smbus_read_block_data(client,
> > +				ETP_SMBUS_HELLOPACKET_CMD, values);
> > +	if (ret != ETP_SMBUS_HELLOPACKET_LEN) {
> > +		dev_err(&client->dev, "hello packet length fail\n");
> > +		return -1;
> > +	}
> > +
> > +	/* compare hello packet */
> > +	if (memcmp(values, check, ETP_SMBUS_HELLOPACKET_LEN)) {
> > +		dev_err(&client->dev, "hello packet fail [%x %x %x %x %x]\n",
> > +		values[0], values[1], values[2], values[3], values[4]);
> > +		return -1;
> > +	}
> > +
> > +	/* enable tp */
> > +	ret = i2c_smbus_write_byte(client, ETP_SMBUS_ENABLE_TP);
> > +	return ret;
> > +}
> > +
> > +static int elan_smbus_enable_calibrate(struct i2c_client *client)
> > +{
> > +	u8 cmd[4] = {0x00, 0x07, 0x00,
> ETP_ENABLE_ABS|ETP_ENABLE_CALIBRATE};
> > +
> > +	return i2c_smbus_write_block_data(client,
> > +				ETP_SMBUS_IAP_CMD, 4, cmd);
> > +}
> > +
> > +static int elan_smbus_disable_calibrate(struct i2c_client *client)
> > +{
> > +	u8 cmd[4] = {0x00, 0x07, 0x00,
> ETP_ENABLE_ABS|ETP_DISABLE_CALIBRATE};
> > +
> > +	return i2c_smbus_write_block_data(client,
> > +				ETP_SMBUS_IAP_CMD, 4, cmd);
> > +}
> > +
> > +static int elan_smbus_enable_absolute_mode(struct i2c_client *client)
> > +{
> > +	u8 cmd[4] = {0x00, 0x07, 0x00, ETP_ENABLE_ABS};
> > +
> > +	return i2c_smbus_write_block_data(client, ETP_SMBUS_IAP_CMD, 4, cmd);
> > +}
> > +
> > +/*****************************************************************
> > +* Elan i2c interface
> > +******************************************************************
> > +*/
> > +static int elan_i2c_read_block(struct i2c_client *client,
> > +				 u16 reg, u8 *val, u16 len)
> > +{
> > +	struct i2c_msg msgs[2];
> > +	u8 buf[2];
> > +	int ret;
> > +
> > +	buf[0] = reg & 0xff;
> > +	buf[1] = (reg >> 8) & 0xff;
> > +
> > +	msgs[0].addr = client->addr;
> > +	msgs[0].flags = client->flags & I2C_M_TEN;
> > +	msgs[0].len = 2;
> > +	msgs[0].buf = buf;
> > +
> > +	msgs[1].addr = client->addr;
> > +	msgs[1].flags = client->flags & I2C_M_TEN;
> > +	msgs[1].flags |= I2C_M_RD;
> > +	msgs[1].len = len;
> > +	msgs[1].buf = val;
> > +
> > +	ret = i2c_transfer(client->adapter, msgs, 2);
> > +	return ret != 2 ? -EIO : 0;
> > +}
> > +
> > +static int elan_i2c_read_cmd(struct i2c_client *client, u16 reg, u8 *val)
> > +{
> > +	int retval;
> > +
> > +	retval = elan_i2c_read_block(client, reg, val, ETP_INF_LENGTH);
> > +	if (retval < 0) {
> > +		dev_err(&client->dev, "reading cmd (0x%04x) fail.\n", reg);
> > +		return retval;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int elan_i2c_write_cmd(struct i2c_client *client, u16 reg, u16 cmd)
> > +{
> > +	struct i2c_msg msg;
> > +	u8 buf[4];
> > +	int ret;
> > +
> > +	buf[0] = reg & 0xff;
> > +	buf[1] = (reg >> 8) & 0xff;
> > +	buf[2] = cmd & 0xff;
> > +	buf[3] = (cmd >> 8) & 0xff;
> > +
> > +	msg.addr = client->addr;
> > +	msg.flags = client->flags & I2C_M_TEN;
> > +	msg.len = 4;
> > +	msg.buf = buf;
> > +
> > +	ret = i2c_transfer(client->adapter, &msg, 1);
> > +	return ret != 1 ? -EIO : 0;
> > +}
> > +
> > +static int elan_i2c_reset(struct i2c_client *client)
> > +{
> > +	return elan_i2c_write_cmd(client, ETP_I2C_STAND_CMD,
> > +						ETP_I2C_RESET);
> > +}
> > +
> > +static int elan_i2c_wake_up(struct i2c_client *client)
> > +{
> > +	return elan_i2c_write_cmd(client, ETP_I2C_STAND_CMD,
> > +						ETP_I2C_WAKE_UP);
> > +}
> > +
> > +static int elan_i2c_sleep(struct i2c_client *client)
> > +{
> > +	return elan_i2c_write_cmd(client, ETP_I2C_STAND_CMD,
> > +						ETP_I2C_SLEEP);
> > +}
> > +
> > +static int elan_i2c_enable_absolute_mode(struct i2c_client *client)
> > +{
> > +	return elan_i2c_write_cmd(client, ETP_I2C_SET_CMD,
> > +						ETP_ENABLE_ABS);
> > +}
> > +
> > +static int elan_i2c_enable_calibrate(struct i2c_client *client)
> > +{
> > +	return elan_i2c_write_cmd(client, ETP_I2C_SET_CMD,
> > +			ETP_ENABLE_ABS|ETP_ENABLE_CALIBRATE);
> > +}
> > +
> > +static int elan_i2c_disable_calibrate(struct i2c_client *client)
> > +{
> > +	return elan_i2c_write_cmd(client, ETP_I2C_SET_CMD,
> > +			ETP_ENABLE_ABS|ETP_DISABLE_CALIBRATE);
> > +}
> > +
> > +static int elan_i2c_get_desc(struct i2c_client *client, u8 *val)
> > +{
> > +	return elan_i2c_read_block(client, ETP_I2C_DESC_CMD, val,
> > +					ETP_I2C_DESC_LENGTH);
> > +}
> > +
> > +static int elan_i2c_get_report_desc(struct i2c_client *client, u8 *val)
> > +{
> > +	return elan_i2c_read_block(client, ETP_I2C_REPORT_DESC_CMD,
> > +				 val, ETP_I2C_REPORT_DESC_LENGTH);
> > +}
> > +
> > +static int elan_i2c_initialize(struct i2c_client *client)
> > +{
> > +	struct device *dev = &client->dev;
> > +	int rc;
> > +
> > +	rc = elan_i2c_reset(client);
> > +	if (rc < 0) {
> > +		dev_err(dev, "device reset failed.\n");
> > +		return -1;
> > +	}
> > +
> > +	/* wait for get reset return flag */
> > +	msleep(100);
> > +	/* get reset return flag 0000 */
> > +	rc = i2c_master_recv(client, val, ETP_INF_LENGTH);
> > +	if (rc < 0) {
> > +		dev_err(dev, "get device reset return value failed.\n");
> > +		return -1;
> > +	}
> > +
> > +	rc = elan_i2c_get_desc(client, val);
> > +	if (rc < 0) {
> > +		dev_err(dev, "cannot get device descriptor.\n");
> > +		return -1;
> > +	}
> > +
> > +	rc = elan_i2c_get_report_desc(client, val);
> > +	if (rc < 0) {
> > +		dev_err(dev, "fetching report descriptor failed.\n");
> > +		return -1;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**************************************************************************
> > +* Genernal functions
> > +***************************************************************************
> > +*/
> > +
> > +/*
> > + * (value from firmware) * 10 + 790 = dpi
> > + * we also have to convert dpi to dots/mm (*10/254 to avoid floating point)
> > + */
> > +static unsigned int elan_convert_res(char val)
> > +{
> > +	int res;
> > +	if (val & 0x80) {
> > +		val = ~val + 1;
> > +		res = (790 - val * 10) * 10 / 254;
> > +	} else
> > +		res = (val * 10 + 790) * 10 / 254;
> > +	return res;
> > +}
> > +
> > +static int elan_get_iap_version(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +					ETP_SMBUS_IAP_VERSION_CMD, val);
> > +		ret = val[2];
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +				ETP_I2C_IAP_VERSION_CMD, val);
> > +		ret = val[0];
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_x_max(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +					ETP_SMBUS_RANGE_CMD, val);
> > +		ret = (0x0f & val[0]) << 8 | val[1];
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +					ETP_I2C_MAX_X_AXIS_CMD, val);
> > +		ret = (0x0f & val[1]) << 8 | val[0];
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_y_max(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +					ETP_SMBUS_RANGE_CMD, val);
> > +		ret = (0xf0 & val[0]) << 4 | val[2];
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +					ETP_I2C_MAX_Y_AXIS_CMD, val);
> > +		ret = (0x0f & val[1]) << 8 | val[0];
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_x_tracenum(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +				ETP_SMBUS_XY_TRACENUM_CMD, val);
> > +		ret = (val[1] - 1);
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +				ETP_I2C_XY_TRACENUM_CMD, val);
> > +		ret = (val[0] - 1);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_y_tracenum(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +				ETP_SMBUS_XY_TRACENUM_CMD, val);
> > +		ret = (val[2] - 1);
> > +	} else {
> > +		ret = elan_i2c_read_cmd(data->client,
> > +				ETP_I2C_XY_TRACENUM_CMD, val);
> > +		ret = (val[1] - 1);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_fw_version(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +				ETP_SMBUS_FW_VERSION_CMD, val);
> > +		ret = val[2];
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +				ETP_I2C_FW_VERSION_CMD, val);
> > +		ret = val[0];
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_sm_version(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus)
> > +		i2c_smbus_read_block_data(data->client,
> > +				ETP_SMBUS_SM_VERSION_CMD, val);
> > +	else
> > +		elan_i2c_read_block(data->client,
> > +				ETP_I2C_SM_VERSION_CMD, val, 1);
> > +	ret = val[0];
> > +	return ret;
> > +}
> > +
> > +static int elan_get_unique_id(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +				ETP_SMBUS_UNIQUEID_CMD, val);
> > +		ret = val[1];
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +				ETP_I2C_UNIQUEID_CMD, val);
> > +		ret = val[0];
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_x_resolution(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +				ETP_SMBUS_RESOLUTION_CMD, val);
> > +		ret = elan_convert_res(val[1] & 0x0F);
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +				ETP_I2C_RESOLUTION_CMD, val);
> > +		ret = elan_convert_res(val[0]);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_y_resolution(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +				ETP_SMBUS_RESOLUTION_CMD, val);
> > +		ret = elan_convert_res((val[1] & 0xF0) >> 4);
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +				ETP_I2C_RESOLUTION_CMD, val);
> > +		ret = elan_convert_res(val[1]);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_fw_checksum(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +				ETP_SMBUS_FW_CHECKSUM_CMD, val);
> > +		ret = be16_to_cpup((__be16 *)val);
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +				ETP_I2C_FW_CHECKSUM_CMD, val);
> > +		ret = le16_to_cpup((__le16 *)val);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_max_baseline(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +				ETP_SMBUS_MAX_BASELINE_CMD, val);
> > +		ret = be16_to_cpup((__be16 *)val);
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +				ETP_I2C_MAX_BASELINE_CMD, val);
> > +		ret = le16_to_cpup((__le16 *)val);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_get_min_baseline(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		i2c_smbus_read_block_data(data->client,
> > +				ETP_SMBUS_MIN_BASELINE_CMD, val);
> > +		ret = be16_to_cpup((__be16 *)val);
> > +	} else {
> > +		elan_i2c_read_cmd(data->client,
> > +			ETP_I2C_MIN_BASELINE_CMD, val);
> > +		ret = le16_to_cpup((__le16 *)val);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int elan_enable_calibrate(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus)
> > +		ret = elan_smbus_enable_calibrate(data->client);
> > +	else
> > +		ret = elan_i2c_enable_calibrate(data->client);
> > +	return ret;
> > +}
> > +
> > +static int elan_disable_calibrate(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus)
> > +		ret = elan_smbus_disable_calibrate(data->client);
> > +	else
> > +		ret = elan_i2c_disable_calibrate(data->client);
> > +	return ret;
> > +}
> > +
> > +static int elan_initialize(struct elan_tp_data *data)
> > +{
> > +	int ret;
> > +	if (data->smbus) {
> > +		ret = elan_smbus_initialize(data->client);
> > +		if (ret < 0) {
> > +			dev_err(&data->client->dev,
> > +				"device initialize failed.\n");
> > +			goto err_initialize;
> > +		}
> > +
> > +		ret = elan_smbus_enable_absolute_mode(data->client);
> > +		if (ret < 0)
> > +			dev_err(&data->client->dev,
> > +				"cannot switch to absolute mode.\n");
> > +	} else {
> > +		ret = elan_i2c_initialize(data->client);
> > +		if (ret < 0) {
> > +			dev_err(&data->client->dev,
> > +				"device initialize failed.\n");
> > +			goto err_initialize;
> > +		}
> > +
> > +		ret = elan_i2c_enable_absolute_mode(data->client);
> > +		if (ret < 0) {
> > +			dev_err(&data->client->dev,
> > +				"cannot switch to absolute mode.\n");
> > +			goto err_initialize;
> > +		}
> > +
> > +		ret = elan_i2c_wake_up(data->client);
> > +		if (ret < 0)
> > +			dev_err(&data->client->dev,
> > +					"device wake up failed.\n");
> > +	}
> > +err_initialize:
> > +	return ret;
> > +}
> > +
> > +/********************************************************************
> > + * below routines export interfaces to sysfs file system.
> > + * so user can get firmware/driver/hardware information using cat command.
> > + * e.g.: use below command to get firmware version
> > + *      cat /sys/bus/i2c/drivers/elan_i2c/1-0015/firmware_version
> > + *******************************************************************
> > + */
> > +static ssize_t elan_sysfs_enable_detailinfo(struct device *dev,
> > +					struct device_attribute *attr,
> > +					char *buf)
> > +{
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +	data->enable_detail_info = true;
> 
> What is this for?
> 
> > +	return sprintf(buf, "enable\n");
> > +}
> > +
> > +static ssize_t elan_sysfs_read_fw_checksum(struct device *dev,
> > +					struct device_attribute *attr,
> > +					char *buf)
> > +{
> > +	unsigned int checksum = 0;
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +	if (data->enable_detail_info == true) {
> > +		checksum = elan_get_fw_checksum(data);
> > +		data->enable_detail_info = false;
> > +	}
> > +	return sprintf(buf, "0x%04x\n", checksum);
> > +}
> > +
> > +static ssize_t elan_sysfs_read_unique_id(struct device *dev,
> > +					struct device_attribute *attr,
> > +					char *buf)
> > +{
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +	data->unique_id = elan_get_unique_id(data);
> > +	return sprintf(buf, "0x%04x\n", data->unique_id);
> > +}
> > +
> > +static ssize_t elan_sysfs_read_driver_ver(struct device *dev,
> > +					struct device_attribute *attr,
> > +					char *buf)
> > +{
> > +	return sprintf(buf, "%s\n", ELAN_DRIVER_VERSION);
> 
> This should be reported in MODULE_VERSION if you need it.
> 
> > +}
> > +
> > +static ssize_t elan_sysfs_read_fw_ver(struct device *dev,
> > +				    struct device_attribute *attr,
> > +				    char *buf)
> > +{
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +	data->fw_version = elan_get_fw_version(data);
> > +	return sprintf(buf, "0x%04x\n", data->fw_version);
> > +}
> > +
> > +static ssize_t elan_sysfs_read_sm_ver(struct device *dev,
> > +				    struct device_attribute *attr,
> > +				    char *buf)
> > +{
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +	data->sm_version = elan_get_sm_version(data);
> > +	return sprintf(buf, "0x%04x\n", data->sm_version);
> > +}
> > +
> > +static ssize_t elan_sysfs_read_iap_ver(struct device *dev,
> > +				     struct device_attribute *attr,
> > +				     char *buf)
> > +{
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +	data->iap_version = elan_get_iap_version(data);
> > +	return sprintf(buf, "0x%04x\n", data->iap_version);
> > +}
> > +
> > +
> > +static ssize_t elan_sysfs_update_fw(struct device *dev,
> > +				  struct device_attribute *attr,
> > +				  const char *buf, size_t count)
> > +{
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +	int ret;
> > +	ret = elan_firmware(data);
> > +	if (ret)
> > +		dev_err(dev, "firmware update failed.\n");
> > +	else
> > +		dev_info(dev, "firmware update succeeded.\n");
> > +	return ret ? ret : count;
> > +}
> > +
> > +static ssize_t elan_sysfs_calibrate(struct device *dev,
> > +				struct device_attribute *attr,
> > +				char *buf)
> > +{
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +	/* start calibarate cmd */
> > +	u8 smbus_cmd[4] = {0x00, 0x08, 0x00, 0x01};
> > +	int tries = 20;
> > +	int ret = 0;
> > +	val[0] = 0;
> > +
> > +	disable_irq(data->irq);
> > +	elan_enable_calibrate(data);
> > +	if (data->smbus)
> > +		i2c_smbus_write_block_data(data->client,
> > +				ETP_SMBUS_IAP_CMD, 4, smbus_cmd);
> > +	else
> > +		elan_i2c_write_cmd(data->client,
> > +					ETP_I2C_CALIBRATE_CMD, 1);
> > +
> > +	do {
> > +		/* wait 250ms and check finish or not */
> > +		msleep(250);
> > +
> > +		if (data->smbus)
> > +			i2c_smbus_read_block_data(data->client,
> > +					ETP_SMBUS_CALIBRATE_QUERY, val);
> > +		else
> > +			elan_i2c_read_block(data->client,
> > +					ETP_I2C_CALIBRATE_CMD, val, 1);
> > +
> > +		/* calibrate finish */
> > +		if (val[0] == 0)
> > +			break;
> > +	} while (--tries);
> > +
> > +	elan_disable_calibrate(data);
> > +	enable_irq(data->irq);
> > +
> > +	if (tries == 0) {
> > +		dev_err(dev, "Failed to calibrate. Timeout.\n");
> > +		ret = -ETIMEDOUT;
> > +	}
> > +	return sprintf(buf, "calibration finish\n");
> > +}
> > +
> > +
> > +static ssize_t elan_sysfs_read_baseline(struct device *dev,
> > +				   struct device_attribute *attr,
> > +				   char *buf)
> > +{
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +	int max_baseline, min_baseline;
> > +
> > +	disable_irq(data->irq);
> > +	elan_enable_calibrate(data);
> > +	msleep(250);
> > +	max_baseline = elan_get_max_baseline(data);
> > +	min_baseline = elan_get_min_baseline(data);
> > +	elan_disable_calibrate(data);
> > +	enable_irq(data->irq);
> > +	return sprintf(buf, "max:%d min:%d\n", max_baseline, min_baseline);
> > +}
> > +
> > +static ssize_t elan_sysfs_reinitialize(struct device *dev,
> > +				struct device_attribute *attr,
> > +				char *buf)
> > +{
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +	int ret;
> > +
> > +	disable_irq(data->irq);
> > +	ret = elan_initialize(data);
> > +	enable_irq(data->irq);
> > +
> > +	if (ret < 0)
> > +		return sprintf(buf, "reinitialize fail\n");
> > +
> > +	return sprintf(buf, "reinitialize success\n");
> 
> This actually should be a write method and instead of returning strings
> you should use return code to indicate success/failure.
> 
> > +}
> > +
> > +static DEVICE_ATTR(unique_id, S_IRUGO, elan_sysfs_read_unique_id, NULL);
> > +static DEVICE_ATTR(firmware_version, S_IRUGO, elan_sysfs_read_fw_ver,
> NULL);
> > +static DEVICE_ATTR(sample_version, S_IRUGO, elan_sysfs_read_sm_ver,
> NULL);
> > +static DEVICE_ATTR(driver_version, S_IRUGO, elan_sysfs_read_driver_ver,
> NULL);
> > +static DEVICE_ATTR(iap_version, S_IRUGO, elan_sysfs_read_iap_ver, NULL);
> > +static DEVICE_ATTR(fw_checksum, S_IRUGO, elan_sysfs_read_fw_checksum,
> NULL);
> > +static DEVICE_ATTR(open_info, S_IRUGO, elan_sysfs_enable_detailinfo,
> NULL);
> > +static DEVICE_ATTR(baseline, S_IRUGO, elan_sysfs_read_baseline, NULL);
> > +static DEVICE_ATTR(reinitialize, S_IRUGO, elan_sysfs_reinitialize, NULL);
> > +static DEVICE_ATTR(calibrate, S_IRUGO, elan_sysfs_calibrate, NULL);
> > +static DEVICE_ATTR(update_fw, S_IWUSR, NULL, elan_sysfs_update_fw);
> > +
> > +static struct attribute *elan_sysfs_entries[] = {
> > +	&dev_attr_unique_id.attr,
> > +	&dev_attr_firmware_version.attr,
> > +	&dev_attr_sample_version.attr,
> > +	&dev_attr_driver_version.attr,
> > +	&dev_attr_iap_version.attr,
> > +	&dev_attr_fw_checksum.attr,
> > +	&dev_attr_open_info.attr,
> > +	&dev_attr_baseline.attr,
> > +	&dev_attr_reinitialize.attr,
> > +	&dev_attr_calibrate.attr,
> > +	&dev_attr_update_fw.attr,
> > +	NULL,
> 
> Please add documentation for sysfs entries to Documentation/...
> 
> > +};
> > +
> > +static const struct attribute_group elan_sysfs_group = {
> > +	.attrs = elan_sysfs_entries,
> > +};
> > +
> > +/*****************************************************************
> > +* Elan isr functions
> > +******************************************************************
> > +*/
> > +
> > +static int elan_check_packet(struct elan_tp_data *data, u8 *packet)
> > +{
> > +	u8 rid;
> > +
> > +	if (data->smbus)
> > +		rid = packet[0];
> > +	else
> > +		rid = packet[ETP_I2C_REPORT_ID_OFFSET];
> > +
> > +	/* check report id */
> > +	if (rid != ETP_REPORT_ID) {
> > +		dev_err(&data->client->dev, "report id [%x] fail.\n", rid);
> > +		return -1;
> > +	}
> > +	return 0;
> > +}
> > +
> > +static void elan_report_absolute(struct elan_tp_data *data, u8 *packet)
> > +{
> > +	struct input_dev *input = data->input;
> > +	u8 *finger_data;
> > +	bool finger_on;
> > +	int pos_x, pos_y;
> > +	int pressure, mk_x, mk_y;
> > +	int i, area_x, area_y, major, minor, new_pressure;
> > +	int finger_count = 0;
> > +	int btn_click;
> > +	u8  tp_info;
> > +
> > +	if (data->smbus) {
> > +		finger_data = &packet[ETP_SMBUS_FINGER_DATA_OFFSET];
> > +		tp_info = packet[1];
> > +	} else {
> > +		finger_data = &packet[ETP_I2C_FINGER_DATA_OFFSET];
> > +		tp_info = packet[3];
> > +	}
> > +
> > +	btn_click = (tp_info & 0x01);
> > +	for (i = 0; i < ETP_MAX_FINGERS; i++) {
> > +		finger_on = (tp_info >> (3 + i)) & 0x01;
> > +
> > +		/* analyze touched finger raw data*/
> > +		if (finger_on) {
> > +			pos_x = ((finger_data[0] & 0xf0) << 4) |
> > +				finger_data[1];
> > +			pos_y = ((finger_data[0] & 0x0f) << 8) |
> > +				finger_data[2];
> > +			pos_y =  data->max_y - pos_y;
> > +			mk_x = (finger_data[3] & 0x0f);
> > +			mk_y = (finger_data[3] >> 4);
> > +			pressure = finger_data[4];
> > +
> > +			/*
> > +			to avoid fat finger be as palm, so reduce the
> > +			width x and y per trace
> > +			*/
> > +			area_x = mk_x * (data->width_x - ETP_FWIDTH_REDUCE);
> > +			area_y = mk_y * (data->width_y - ETP_FWIDTH_REDUCE);
> > +
> > +			major = max(area_x, area_y);
> > +			minor = min(area_x, area_y);
> > +
> > +			new_pressure = pressure + ETP_PRESSURE_OFFSET;
> > +			if (new_pressure > ETP_MAX_PRESSURE)
> > +				new_pressure = ETP_MAX_PRESSURE;
> > +
> > +			input_mt_slot(input, i);
> > +			input_mt_report_slot_state(input, MT_TOOL_FINGER,
> > +									true);
> > +			input_report_abs(input, ABS_MT_POSITION_X, pos_x);
> > +			input_report_abs(input, ABS_MT_POSITION_Y, pos_y);
> > +			input_report_abs(input, ABS_MT_PRESSURE, new_pressure);
> > +			input_report_abs(input, ABS_TOOL_WIDTH, mk_x);
> > +			input_report_abs(input, ABS_MT_TOUCH_MAJOR, major);
> > +			input_report_abs(input, ABS_MT_TOUCH_MINOR, minor);
> > +			finger_data += ETP_FINGER_DATA_LEN;
> > +			finger_count++;
> > +		} else {
> > +			input_mt_slot(input, i);
> > +			input_mt_report_slot_state(input,
> > +						MT_TOOL_FINGER, false);
> > +		}
> > +	}
> > +
> > +	input_report_key(input, BTN_LEFT, (btn_click == 1));
> > +	input_mt_report_pointer_emulation(input, true);
> > +	input_sync(input);
> > +}
> > +
> > +static irqreturn_t elan_isr(int irq, void *dev_id)
> > +{
> > +	struct elan_tp_data *data = dev_id;
> > +	u8 raw[ETP_MAX_REPORT_LEN];
> > +	int retval;
> > +	int report_len;
> > +
> > +	retval = mutex_lock_interruptible(&data->dbfs_mutex);
> > +	if (retval)
> > +		return IRQ_HANDLED;
> > +
> > +	/*
> > +	Only in I2C protocol, when IAP all page wrote finish, driver will
> > +	get one INT signal from high to low, and driver must get 0000
> > +	to confirm IAP is finished.
> > +	*/
> > +	if (data->updated_fw) {
> > +		retval = i2c_master_recv(data->client, raw,
> > +						ETP_INF_LENGTH);
> > +		if (retval == 2 && !le16_to_cpup((__le16 *)raw)) {
> > +			dev_info(&data->client->dev,
> > +				"reinitializing after F/W update...");
> > +			elan_initialize(data);
> > +		}
> > +		data->updated_fw = false;
> > +		goto elan_isr_end;
> > +	}
> > +
> > +	if (data->smbus) {
> > +		report_len = ETP_SMBUS_REPORT_LEN;
> > +		retval = i2c_smbus_read_block_data(data->client,
> > +					ETP_SMBUS_PACKET_QUERY, raw);
> > +	} else {
> > +		report_len = ETP_I2C_REPORT_LEN;
> > +		retval = i2c_master_recv(data->client, raw, report_len);
> > +	}
> > +
> > +	if (retval != report_len) {
> > +		dev_err(&data->client->dev, "wrong packet len(%d)", retval);
> > +		goto elan_isr_end;
> > +	}
> > +
> > +	if (elan_check_packet(data, raw) < 0) {
> > +		dev_err(&data->client->dev, "wrong packet format.");
> > +		goto elan_isr_end;
> > +	}
> > +	elan_report_absolute(data, raw);
> > +	data->dbfs_buffer.bfetch = false;
> > +	memcpy(data->dbfs_buffer.buffer, raw, report_len);
> > +
> > +elan_isr_end:
> > +	mutex_unlock(&data->dbfs_mutex);
> > +	return IRQ_HANDLED;
> > +}
> > +
> > +
> > +static int elan_input_dev_create(struct elan_tp_data *data)
> > +{
> > +	struct i2c_client *client = data->client;
> > +	struct input_dev *input;
> > +	unsigned int x_res, y_res;
> > +	int ret;
> > +
> > +	data->input = input = input_allocate_device();
> > +	if (!input)
> > +		return -ENOMEM;
> > +	input->name = "Elan Touchpad";
> > +	input->id.bustype = BUS_I2C;
> > +	input->dev.parent = &data->client->dev;
> > +
> > +	__set_bit(INPUT_PROP_POINTER, input->propbit);
> > +	__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
> > +	__set_bit(EV_KEY, input->evbit);
> > +	__set_bit(EV_ABS, input->evbit);
> > +
> > +	__set_bit(BTN_LEFT, input->keybit);
> > +	__set_bit(BTN_TOUCH, input->keybit);
> > +	__set_bit(BTN_TOOL_FINGER, input->keybit);
> > +	__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
> > +	__set_bit(BTN_TOOL_TRIPLETAP, input->keybit);
> > +	__set_bit(BTN_TOOL_QUADTAP, input->keybit);
> > +	__set_bit(BTN_TOOL_QUINTTAP, input->keybit);
> > +
> > +	__set_bit(ABS_MT_TOUCH_MAJOR, input->absbit);
> > +	__set_bit(ABS_MT_TOUCH_MINOR, input->absbit);
> > +	__set_bit(ABS_MT_POSITION_X, input->absbit);
> > +	__set_bit(ABS_MT_POSITION_Y, input->absbit);
> > +
> > +	data->unique_id = elan_get_unique_id(data);
> > +	data->fw_version = elan_get_fw_version(data);
> > +	data->sm_version = elan_get_sm_version(data);
> > +	data->iap_version = elan_get_iap_version(data);
> > +	data->max_x = elan_get_x_max(data);
> > +	data->max_y = elan_get_y_max(data);
> > +	data->width_x = data->max_x / elan_get_x_tracenum(data);
> > +	data->width_y = data->max_y / elan_get_y_tracenum(data);
> > +	x_res = elan_get_x_resolution(data);
> > +	y_res = elan_get_y_resolution(data);
> > +
> > +	dev_info(&client->dev,
> > +		"Elan Touchpad Information:\n"
> > +		"    Module unique ID:  0x%04x\n"
> > +		"    Firmware Version:  0x%04x\n"
> > +		"    Sample Version:  0x%04x\n"
> > +		"    IAP Version:  0x%04x\n"
> > +		"    Max ABS X,Y:   %d,%d\n"
> > +		"    Width X,Y:   %d,%d\n"
> > +		"    Resolution X,Y:   %d,%d (dots/mm)\n",
> > +		data->unique_id,
> > +		data->fw_version,
> > +		data->sm_version,
> > +		data->iap_version,
> > +		data->max_x, data->max_y,
> > +		data->width_x, data->width_y,
> > +		(char)x_res, (char)y_res);
> 
> Why cast to char?
> 
> > +
> > +	input_set_abs_params(input, ABS_X, 0, data->max_x, 0, 0);
> > +	input_set_abs_params(input, ABS_Y, 0, data->max_y, 0, 0);
> > +	input_abs_set_res(input, ABS_X, x_res);
> > +	input_abs_set_res(input, ABS_Y, y_res);
> > +	input_set_abs_params(input, ABS_PRESSURE, 0, ETP_MAX_PRESSURE,
> 0, 0);
> > +	input_set_abs_params(input, ABS_TOOL_WIDTH, 0, ETP_FINGER_WIDTH,
> 0, 0);
> > +
> > +	/* handle pointer emulation and unused slots in core */
> > +	ret = input_mt_init_slots(input, ETP_MAX_FINGERS,
> > +				  INPUT_MT_POINTER | INPUT_MT_DROP_UNUSED);
> > +	if (ret) {
> > +		dev_info(&client->dev, "allocate MT slots failed, %d\n", ret);
> > +		goto err_free_device;
> > +	}
> > +	input_set_abs_params(input, ABS_MT_POSITION_X, 0, data->max_x, 0, 0);
> > +	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, data->max_y, 0, 0);
> > +	input_abs_set_res(input, ABS_MT_POSITION_X, x_res);
> > +	input_abs_set_res(input, ABS_MT_POSITION_Y, y_res);
> > +	input_set_abs_params(input, ABS_MT_PRESSURE, 0,
> > +				ETP_MAX_PRESSURE, 0, 0);
> > +	input_set_abs_params(input, ABS_MT_TOUCH_MAJOR, 0,
> > +		ETP_FINGER_WIDTH * max(data->width_x, data->width_y), 0, 0);
> > +	input_set_abs_params(input, ABS_MT_TOUCH_MINOR, 0,
> > +		ETP_FINGER_WIDTH * min(data->width_x, data->width_y), 0, 0);
> > +
> > +	/* Register the device in input subsystem */
> > +	ret = input_register_device(input);
> > +	if (ret) {
> > +		dev_err(&client->dev, "input device register failed, %d\n",
> > +			ret);
> > +		goto err_free_device;
> > +	}
> > +
> > +	return 0;
> > +
> > +err_free_device:
> > +	input_free_device(input);
> > +	return ret;
> > +}
> > +
> > +static u8 elan_check_adapter_functionality(struct i2c_client *client)
> > +{
> > +	u8 ret = ELAN_ADAPTER_FUNC_NONE;
> > +
> > +	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
> > +		ret |= ELAN_ADAPTER_FUNC_I2C;
> > +	if (i2c_check_functionality(client->adapter,
> > +					I2C_FUNC_SMBUS_BYTE_DATA |
> > +					I2C_FUNC_SMBUS_BLOCK_DATA |
> > +					I2C_FUNC_SMBUS_I2C_BLOCK))
> > +		ret |= ELAN_ADAPTER_FUNC_SMBUS;
> > +	return ret;
> > +}
> > +
> > +static int elan_probe(struct i2c_client *client,
> > +				    const struct i2c_device_id *dev_id)
> > +{
> > +	struct elan_tp_data *data;
> > +	int ret;
> > +	u8 adapter_func;
> > +	union i2c_smbus_data dummy;
> > +	struct device *dev = &client->dev;
> > +
> > +	adapter_func = elan_check_adapter_functionality(client);
> > +	if (adapter_func == ELAN_ADAPTER_FUNC_NONE) {
> > +		dev_err(dev, "not a supported I2C/SMBus adapter\n");
> > +		return -EIO;
> > +	}
> > +
> > +	/* Make sure there is something at this address */
> > +	if (dev->of_node && i2c_smbus_xfer(client->adapter, client->addr, 0,
> > +			 I2C_SMBUS_READ, 0, I2C_SMBUS_BYTE, &dummy) < 0)
> > +		return -ENODEV;
> > +
> > +	data = kzalloc(sizeof(struct elan_tp_data), GFP_KERNEL);
> > +	if (!data)
> > +		return -ENOMEM;
> > +
> > +	/* check protocol type */
> > +	if (adapter_func == ELAN_ADAPTER_FUNC_SMBUS)
> > +		data->smbus = true;
> > +	else
> > +		data->smbus = false;
> > +	data->client = client;
> > +	data->updated_fw = false;
> > +	data->enable_detail_info = false;
> > +	data->irq = client->irq;
> > +
> > +	ret = elan_dbfs_init(data);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "error create elan debugfs.\n");
> > +		goto err_dbfs_init;
> > +	}
> > +	ret = request_threaded_irq(client->irq, NULL, elan_isr,
> > +				  IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
> > +				  client->name, data);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "cannot register irq=%d\n",
> > +							 client->irq);
> > +		goto err_irq;
> > +	}
> > +
> > +	/* initial elan touch pad */
> > +	ret = elan_initialize(data);
> > +	if (ret < 0)
> > +		goto err_init;
> > +
> > +	/* create input device */
> > +	ret = elan_input_dev_create(data);
> > +	if (ret < 0)
> > +		goto err_input_dev;
> > +
> > +	device_init_wakeup(&client->dev, 1);
> > +	ret = sysfs_create_group(&client->dev.kobj, &elan_sysfs_group);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "cannot register dev attribute %d", ret);
> > +		goto err_create_group;
> > +	}
> > +	i2c_set_clientdata(client, data);
> > +	return 0;
> > +
> > +err_create_group:
> > +	input_free_device(data->input);
> 
> The device is registered here so you need to call unregister, not free.
> 
> > +err_input_dev:
> > +err_init:
> > +	free_irq(data->irq, data);
> > +err_irq:
> > +	debugfs_remove_recursive(data->dbfs_root);
> > +	mutex_destroy(&data->dbfs_mutex);
> > +err_dbfs_init:
> > +	kfree(data);
> > +	dev_err(&client->dev, "Elan Trackpad probe fail!\n");
> > +	return ret;
> > +}
> > +
> > +static int elan_remove(struct i2c_client *client)
> > +{
> > +	struct elan_tp_data *data = i2c_get_clientdata(client);
> > +
> > +	free_irq(data->irq, data);
> > +	debugfs_remove_recursive(data->dbfs_root);
> > +	mutex_destroy(&data->dbfs_mutex);
> > +
> > +	input_free_device(data->input);
> 
> Not needed (and harmful here).
> 
> > +	input_unregister_device(data->input);
> > +	kfree(data);
> > +	sysfs_remove_group(&client->dev.kobj, &elan_sysfs_group);
> 
> I'd start with removing sysfs attributes as first thing in remove().
> 
> > +
> > +	return 0;
> > +}
> > +
> > +#ifdef CONFIG_PM_SLEEP
> > +static int elan_suspend(struct device *dev)
> > +{
> > +	int ret;
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +
> > +	disable_irq(data->irq);
> > +	if (data->smbus)
> > +		ret = i2c_smbus_write_byte(data->client,
> > +					ETP_SMBUS_DISABLE_TP);
> > +	else
> > +		ret = elan_i2c_sleep(data->client);
> > +
> > +	if (ret < 0) {
> > +		dev_err(dev, "suspend mode failed, %d\n", ret);
> > +	} else {
> > +		if (device_may_wakeup(dev))
> > +			data->irq_wake = (enable_irq_wake(data->irq) == 0);
> > +	}
> > +	return 0;
> > +}
> > +
> > +static int elan_resume(struct device *dev)
> > +{
> > +	int ret = 0;
> > +	struct elan_tp_data *data = dev_get_drvdata(dev);
> > +
> > +	if (device_may_wakeup(dev) && data->irq_wake)
> > +		disable_irq_wake(data->irq);
> > +
> > +	ret = elan_initialize(data);
> > +	if (ret < 0)
> > +		dev_err(dev, "resume active power failed, %d\n", ret);
> > +
> > +	enable_irq(data->irq);
> > +	return 0;
> > +}
> > +#endif
> > +
> > +static SIMPLE_DEV_PM_OPS(elan_pm_ops, elan_suspend, elan_resume);
> > +
> > +static const struct i2c_device_id elan_id[] = {
> > +	{ DRIVER_NAME, 0 },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(i2c, elan_id);
> > +
> > +static struct i2c_driver elan_driver = {
> > +	.driver = {
> > +		.name	= DRIVER_NAME,
> > +		.owner	= THIS_MODULE,
> > +		.pm	= &elan_pm_ops,
> > +	},
> > +	.probe		= elan_probe,
> > +	.remove		= elan_remove,
> > +	.id_table	= elan_id,
> > +};
> > +
> > +
> > +static int __init elan_init(void)
> > +{
> > +	int ret;
> > +	ret = i2c_add_driver(&elan_driver);
> > +	if (ret) {
> > +		pr_err("elan driver register FAILED.\n");
> > +		return ret;
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static void __exit elan_exit(void)
> > +{
> > +	i2c_del_driver(&elan_driver);
> > +}
> > +
> > +module_init(elan_init);
> > +module_exit(elan_exit);
> 
> module_i2c_driver().
> 
> > +
> > +MODULE_AUTHOR("Duson Lin <dusonlin@emc.com.tw>");
> > +MODULE_DESCRIPTION("Elan I2C/SMBus Touchpad driver");
> > +MODULE_LICENSE("GPL");
> > --
> > 1.7.10.4
> >
> 
> Thanks.
> 
> --
> Dmitry

