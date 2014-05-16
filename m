Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaEPPui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:50:38 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.167]:45316 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755926AbaEPPue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:50:34 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2014 11:50:33 EDT
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-9.tower-38.messagelabs.com!1400255052!2017460!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Fri, 16 May 2014 17:44:12 +0200
Date: Fri, 16 May 2014 18:37:06 +0200
From: Andreas Werner <andreas.werner@men.de>
To: <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>,
        <johannes.thumshirn@men.de>, <thomas.schnuerer@men.de>,
        <wernerandy@gmx.de>
Subject: [PATCH 1/3] drivers/mfd/menf21bmc: introduce MEN 14F021P00 BMC MFD
 Core driver
Message-ID: <58de41a38511a107941d9c3b2cea314c0becfff7.1400258021.git.andreas.werner@men.de>
References: <cover.1400258021.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1400258021.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MEN 14F021P00 Board Management Controller provides an
I2C interface to the host to access the feature implemented in the BMC.
The BMC is a PIC Microntroller assembled on CPCI Card from MEN Mikroelektronik
and on a few Box/Display Computer.

Added MFD Core driver, supporting the I2C communication to the device.

The MFD driver currently supports the following features:
	- Watchdog
	- LEDs

Signed-off-by: Andreas Werner <andreas.werner@men.de>
---
 drivers/mfd/Kconfig           |  12 +++
 drivers/mfd/Makefile          |   1 +
 drivers/mfd/menf21bmc.c       | 193 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/menf21bmc.h |  32 +++++++
 4 files changed, 238 insertions(+)
 create mode 100644 drivers/mfd/menf21bmc.c
 create mode 100644 include/linux/mfd/menf21bmc.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index ab5a43c..7c2e8d2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -427,6 +427,18 @@ config MFD_MAX8998
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
 
+config MFD_MENF21BMC
+	tristate "MEN 14F021P00 Board Management Controller Support"
+	depends on I2C=y
+	select MFD_CORE
+	help
+	  Say yes here to add support for the MEN 14F021P00 BMC
+	  which is a Board Management Controller connected to the I2C bus.
+	  This driver provides common support for accessing the devices;
+	  additional drivers must be enabled in order to use the
+	  functionality of the BMC device.
+
+
 config EZX_PCAP
 	bool "Motorola EZXPCAP Support"
 	depends on SPI_MASTER
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5913208..8f2be38 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -167,3 +167,4 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
 obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
 obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
+obj-$(CONFIG_MFD_MENF21BMC)	+= menf21bmc.o
diff --git a/drivers/mfd/menf21bmc.c b/drivers/mfd/menf21bmc.c
new file mode 100644
index 0000000..77de1a8
--- /dev/null
+++ b/drivers/mfd/menf21bmc.c
@@ -0,0 +1,193 @@
+/*
+ *  MEN 14F021P00 Board Management Controller (BMC) MFD Core Driver.
+ *
+ *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
+ *  Author: Andreas Werner <andreas.werner@men.de>
+ *  All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/menf21bmc.h>
+
+#define BMC_CMD_REV_MAJOR	0x80
+#define BMC_CMD_REV_MINOR	0x81
+#define BMC_CMD_REV_MAIN	0x82
+#define BMC_CMD_REV_BUILD	0x83
+#define BMC_CMD_REV_VERI	0x84
+
+static struct mfd_cell menf21bmc_cell[] = {
+	{
+		.name = "menf21bmc_wd",
+	},
+	{
+		.name = "menf21bmc_led",
+	},
+};
+
+static int
+menf21bmc_read_byte_data(struct i2c_client *client, u8 reg, uint8_t *val)
+{
+	int ret;
+	struct menf21bmc *data = i2c_get_clientdata(client);
+
+	mutex_lock(&data->lock);
+	ret = i2c_smbus_read_byte_data(client, reg);
+	mutex_unlock(&data->lock);
+
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to read byte at 0x%02x\n", reg);
+		return ret;
+	}
+
+	*val = (uint8_t)ret;
+
+	return 0;
+}
+
+static int
+menf21bmc_read_word_data(struct i2c_client *client, u8 reg, uint16_t *val)
+{
+	int ret;
+	struct menf21bmc *data = i2c_get_clientdata(client);
+
+	mutex_lock(&data->lock);
+	ret = i2c_smbus_read_word_data(client, reg);
+	mutex_unlock(&data->lock);
+
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to read word at 0x%02x\n", reg);
+		return ret;
+	}
+	*val = (uint16_t)ret;
+
+	return 0;
+}
+
+static int menf21bmc_write_byte_data(struct i2c_client *client, u8 reg, u8 val)
+{
+	int ret;
+	struct menf21bmc *data = i2c_get_clientdata(client);
+
+	mutex_lock(&data->lock);
+	ret = i2c_smbus_write_byte_data(client, reg, val);
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
+static int menf21bmc_write_word_data(struct i2c_client *client, u8 reg, u16 val)
+{
+	int ret;
+	struct menf21bmc *data = i2c_get_clientdata(client);
+
+	mutex_lock(&data->lock);
+	ret = i2c_smbus_write_word_data(client, reg, val);
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
+static int menf21bmc_write_byte(struct i2c_client *client, u8 val)
+{
+	int ret;
+	struct menf21bmc *data = i2c_get_clientdata(client);
+
+	mutex_lock(&data->lock);
+	ret = i2c_smbus_write_byte(client, val);
+	mutex_unlock(&data->lock);
+
+	return ret;
+}
+
+static int
+menf21bmc_probe(struct i2c_client *client, const struct i2c_device_id *ids)
+{
+	struct menf21bmc *data;
+	uint16_t rev_major, rev_minor, rev_main, rev_build, rev_veri;
+	int ret = 0;
+
+	dev_dbg(&client->dev, "menf21bmc_probe\n");
+
+	if (!i2c_check_functionality(client->adapter,
+						I2C_FUNC_SMBUS_BYTE_DATA |
+						I2C_FUNC_SMBUS_WORD_DATA |
+						I2C_FUNC_SMBUS_BYTE))
+		return -EIO;
+
+	data = devm_kzalloc(&client->dev, sizeof(struct menf21bmc), GFP_KERNEL);
+	if (data == NULL)
+		return -ENOMEM;
+
+	mutex_init(&data->lock);
+
+	i2c_set_clientdata(client, data);
+	data->client = client;
+	data->read_word_data = menf21bmc_read_word_data;
+	data->read_byte_data = menf21bmc_read_byte_data;
+	data->write_word_data = menf21bmc_write_word_data;
+	data->write_byte_data = menf21bmc_write_byte_data;
+	data->write_byte = menf21bmc_write_byte;
+
+	ret |= menf21bmc_read_word_data(client, BMC_CMD_REV_MAJOR, &rev_major);
+	ret |= menf21bmc_read_word_data(client, BMC_CMD_REV_MINOR, &rev_minor);
+	ret |= menf21bmc_read_word_data(client, BMC_CMD_REV_MAIN, &rev_main);
+	ret |= menf21bmc_read_word_data(client, BMC_CMD_REV_BUILD, &rev_build);
+	ret |= menf21bmc_read_word_data(client, BMC_CMD_REV_VERI, &rev_veri);
+
+	if (ret) {
+		dev_err(&client->dev, "Cannot get Firmware Revision\n");
+		return -EIO;
+	}
+
+	dev_info(&client->dev, "FW Revision: %02d.%02d.%02d\n",
+					rev_major, rev_minor, rev_main);
+	dev_info(&client->dev, "Build: %d Verificaton Marker: %d\n",
+							rev_build, rev_veri);
+
+	ret = mfd_add_devices(&client->dev, 0, menf21bmc_cell,
+				ARRAY_SIZE(menf21bmc_cell), NULL, 0, NULL);
+	if (ret < 0) {
+		dev_err(&client->dev, "mfd_add_devices failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int menf21bmc_remove(struct i2c_client *client)
+{
+	mfd_remove_devices(&client->dev);
+	return 0;
+}
+
+static const struct i2c_device_id menf21bmc_id_table[] = {
+	{"menf21bmc", 0},
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, menf21bmc_id_table);
+
+static struct i2c_driver menf21bmc_driver = {
+	.driver		= {
+		.name	= "menf21bmc",
+		.owner	= THIS_MODULE,
+	},
+	.id_table	= menf21bmc_id_table,
+	.probe		= menf21bmc_probe,
+	.remove		= menf21bmc_remove,
+};
+
+module_i2c_driver(menf21bmc_driver);
+
+MODULE_DESCRIPTION("MEN 14F021P00 BMC mfd core driver");
+MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/mfd/menf21bmc.h b/include/linux/mfd/menf21bmc.h
new file mode 100644
index 0000000..49df41fe
--- /dev/null
+++ b/include/linux/mfd/menf21bmc.h
@@ -0,0 +1,32 @@
+/*
+ *  MEN 14F021P00 Board Management Controller (BMC)
+ *
+ *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
+ *  Author: Andreas Werner <andreas.werner@men.de>
+ *  All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef MENF21BMC_H
+#define MENF21BMC_H
+
+struct menf21bmc {
+	struct i2c_client *client;
+	struct mutex lock;
+
+	int (*read_word_data)(struct i2c_client *client,
+						u8 reg, uint16_t *val);
+	int (*read_byte_data)(struct i2c_client *client, u8 reg, uint8_t *val);
+	int (*write_word_data)(struct i2c_client *client, u8 reg, u16 val);
+	int (*write_byte_data)(struct i2c_client *client, u8 reg, u8 val);
+	int (*write_byte)(struct i2c_client *client, u8 val);
+};
+
+#endif /* MENF21BMC_H */
+
+
-- 
1.9.2

