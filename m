Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797AbaH0RlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:41:09 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.175]:41985 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934955AbaH0RlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:41:07 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-13.tower-38.messagelabs.com!1409158788!23522395!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 27 Aug 2014 18:59:48 +0200
Date: Wed, 27 Aug 2014 19:51:45 +0200
From: Andreas Werner <andreas.werner@men.de>
To: <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <linux@roeck-us.net>,
        <lm-sensors@lm-sensors.org>, <wim@iguana.be>,
        <linux-watchdog@vger.kernel.org>, <cooloney@gmail.com>,
        <rpurdie@rpsys.net>, <linux-leds@vger.kernel.org>
Subject: [PATCH v6 1/4] drivers/mfd/menf21bmc: introduce MEN 14F021P00 BMC
 MFD Core driver
Message-ID: <71aa7a1bbed06f0ec840b3a00664dfd8214fa49a.1409161615.git.andreas.werner@men.de>
References: <cover.1409161615.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1409161615.git.andreas.werner@men.de>
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
	- Hwmon (voltage monitoring)

Signed-off-by: Andreas Werner <andreas.werner@men.de>
---
 drivers/mfd/Kconfig     |  15 ++++++
 drivers/mfd/Makefile    |   1 +
 drivers/mfd/menf21bmc.c | 132 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 148 insertions(+)
 create mode 100644 drivers/mfd/menf21bmc.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index b8d9ca0..1020725 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -453,6 +453,21 @@ config MFD_MAX8998
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
 
+config MFD_MENF21BMC
+	tristate "MEN 14F021P00 Board Management Controller Support"
+	depends on I2C
+	select MFD_CORE
+	help
+	  Say yes here to add support for the MEN 14F021P00 BMC
+	  which is a Board Management Controller connected to the I2C bus.
+	  The device supports multiple sub-devices like LED, HWMON and WDT.
+	  This driver provides common support for accessing the devices;
+	  additional drivers must be enabled in order to use the
+	  functionality of the BMC device.
+
+	  This driver can also be built as a module. If so the module
+	  will be called menf21bmc.
+
 config EZX_PCAP
 	bool "Motorola EZXPCAP Support"
 	depends on SPI_MASTER
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 4e2bc25..37bf336 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -169,6 +169,7 @@ obj-$(CONFIG_MFD_AS3711)	+= as3711.o
 obj-$(CONFIG_MFD_AS3722)	+= as3722.o
 obj-$(CONFIG_MFD_STW481X)	+= stw481x.o
 obj-$(CONFIG_MFD_IPAQ_MICRO)	+= ipaq-micro.o
+obj-$(CONFIG_MFD_MENF21BMC)	+= menf21bmc.o
 
 intel-soc-pmic-objs		:= intel_soc_pmic_core.o intel_soc_pmic_crc.o
 obj-$(CONFIG_INTEL_SOC_PMIC)	+= intel-soc-pmic.o
diff --git a/drivers/mfd/menf21bmc.c b/drivers/mfd/menf21bmc.c
new file mode 100644
index 0000000..1c27434
--- /dev/null
+++ b/drivers/mfd/menf21bmc.c
@@ -0,0 +1,132 @@
+/*
+ *  MEN 14F021P00 Board Management Controller (BMC) MFD Core Driver.
+ *
+ *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/mfd/core.h>
+
+#define BMC_CMD_WDT_EXIT_PROD	0x18
+#define BMC_CMD_WDT_PROD_STAT	0x19
+#define BMC_CMD_REV_MAJOR	0x80
+#define BMC_CMD_REV_MINOR	0x81
+#define BMC_CMD_REV_MAIN	0x82
+
+static struct mfd_cell menf21bmc_cell[] = {
+	{ .name = "menf21bmc_wdt", },
+	{ .name = "menf21bmc_led", },
+	{ .name = "menf21bmc_hwmon", }
+};
+
+static int menf21bmc_wdt_exit_prod_mode(struct i2c_client *client)
+{
+	int val, ret;
+
+	val = i2c_smbus_read_byte_data(client, BMC_CMD_WDT_PROD_STAT);
+	if (val < 0)
+		return val;
+
+	/*
+	 * Production mode should be not active after delivery of the Board.
+	 * To be sure we check it, inform the user and exit the mode
+	 * if active.
+	 */
+	if (val == 0x00) {
+		dev_info(&client->dev,
+			"BMC in production mode. Exit production mode\n");
+
+		ret = i2c_smbus_write_byte(client, BMC_CMD_WDT_EXIT_PROD);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int
+menf21bmc_probe(struct i2c_client *client, const struct i2c_device_id *ids)
+{
+	int rev_major, rev_minor, rev_main;
+	int ret;
+
+	ret = i2c_check_functionality(client->adapter,
+				      I2C_FUNC_SMBUS_BYTE_DATA |
+				      I2C_FUNC_SMBUS_WORD_DATA |
+				      I2C_FUNC_SMBUS_BYTE);
+	if (!ret)
+		return -ENODEV;
+
+	rev_major = i2c_smbus_read_word_data(client, BMC_CMD_REV_MAJOR);
+	if (rev_major < 0) {
+		dev_err(&client->dev, "failed to get BMC major revision\n");
+		return rev_major;
+	}
+
+	rev_minor = i2c_smbus_read_word_data(client, BMC_CMD_REV_MINOR);
+	if (rev_minor < 0) {
+		dev_err(&client->dev, "failed to get BMC minor revision\n");
+		return rev_minor;
+	}
+
+	rev_main = i2c_smbus_read_word_data(client, BMC_CMD_REV_MAIN);
+	if (rev_main < 0) {
+		dev_err(&client->dev, "failed to get BMC main revision\n");
+		return rev_main;
+	}
+
+	dev_info(&client->dev, "FW Revision: %02d.%02d.%02d\n",
+		 rev_major, rev_minor, rev_main);
+
+	/*
+	 * We have to exit the Production Mode of the BMC to activate the
+	 * Watchdog functionality and the BIOS life sign monitoring.
+	 */
+	ret = menf21bmc_wdt_exit_prod_mode(client);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to leave production mode\n");
+		return ret;
+	}
+
+	ret = mfd_add_devices(&client->dev, 0, menf21bmc_cell,
+			      ARRAY_SIZE(menf21bmc_cell), NULL, 0, NULL);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to add BMC sub-devices\n");
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
+	{ "menf21bmc" },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, menf21bmc_id_table);
+
+static struct i2c_driver menf21bmc_driver = {
+	.driver.name	= "menf21bmc",
+	.id_table	= menf21bmc_id_table,
+	.probe		= menf21bmc_probe,
+	.remove		= menf21bmc_remove,
+};
+
+module_i2c_driver(menf21bmc_driver);
+
+MODULE_DESCRIPTION("MEN 14F021P00 BMC mfd core driver");
+MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de>");
+MODULE_LICENSE("GPL v2");
-- 
2.0.4

