Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaGJQvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:51:52 -0400
Received: from dmz4.rosetechnology.dk ([5.206.196.244]:57667 "EHLO
	dmz4.rosetechnology.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaGJQvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:51:50 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jul 2014 12:51:50 EDT
Message-ID: <1405010731.8161.11.camel@sanws1.rosetechnology.dk>
Subject: [PATCH] rtc: Add pcf85063 support
From: =?ISO-8859-1?Q?S=F8ren?= Andersen <san@rosetechnology.dk>
To: a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Date: Thu, 10 Jul 2014 18:45:31 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to add support for the pcf85063 rtc chip

Signed-off-by: Soeren Andersen <san at rosetechnology.dk>
---
 Documentation/devicetree/bindings/i2c/trivial-devices.txt |   1 +
 drivers/rtc/Kconfig                                       |   8 ++++++
 drivers/rtc/Makefile                                      |   1 +
 drivers/rtc/rtc-pcf85063.c                                | 204 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 214 insertions(+)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index bef86e5..c75046a 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -69,6 +69,7 @@ nuvoton,npct501		i2c trusted platform module (TPM)
 nxp,pca9556		Octal SMBus and I2C registered interface
 nxp,pca9557		8-bit I2C-bus and SMBus I/O port with reset
 nxp,pcf8563		Real-time clock/calendar
+nxp,pcf85063		Tiny Real-Time Clock
 ovti,ov5642		OV5642: Color CMOS QSXGA (5-megapixel) Image Sensor with OmniBSI and Embedded TrueFocus
 pericom,pt7c4338	Real-time Clock Module
 plx,pex8648		48-Lane, 12-Port PCI Express Gen 2 (5.0 GT/s) Switch
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 0754f5c..07df2f1 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -373,6 +373,14 @@ config RTC_DRV_PCF8563
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-pcf8563.
 
+config RTC_DRV_PCF85063
+	tristate "nxp PCF85063"
+	help
+	  If you say yes here you get support for the PCF85063 RTC chip
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-pcf85063.
+
 config RTC_DRV_PCF8583
 	tristate "Philips PCF8583"
 	help
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 70347d0..2a56d63 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_RTC_DRV_PCAP)	+= rtc-pcap.o
 obj-$(CONFIG_RTC_DRV_PCF2127)	+= rtc-pcf2127.o
 obj-$(CONFIG_RTC_DRV_PCF8523)	+= rtc-pcf8523.o
 obj-$(CONFIG_RTC_DRV_PCF8563)	+= rtc-pcf8563.o
+obj-$(CONFIG_RTC_DRV_PCF85063)	+= rtc-pcf85063.o
 obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
 obj-$(CONFIG_RTC_DRV_PCF2123)	+= rtc-pcf2123.o
 obj-$(CONFIG_RTC_DRV_PCF50633)	+= rtc-pcf50633.o
diff --git a/drivers/rtc/rtc-pcf85063.c b/drivers/rtc/rtc-pcf85063.c
new file mode 100644
index 0000000..9bc43e1
--- /dev/null
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -0,0 +1,204 @@
+/*
+ * An I2C driver for the PCF85063 RTC
+ * Copyright 2014 Rose Technology
+ *
+ * Author: Søren Andersen <san@rosetechnology.dk>
+ * Maintainers: http://www.nslu2-linux.org/
+ *
+ * based on the other drivers in this same directory.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/i2c.h>
+#include <linux/bcd.h>
+#include <linux/rtc.h>
+#include <linux/module.h>
+
+#define DRV_VERSION "0.0.1"
+
+#define PCF85063_REG_CTRL1		0x00 /* status */
+#define PCF85063_REG_CTRL2		0x01
+
+#define PCF85063_REG_SC			0x04 /* datetime */
+#define PCF85063_REG_MN			0x05
+#define PCF85063_REG_HR			0x06
+#define PCF85063_REG_DM			0x07
+#define PCF85063_REG_DW			0x08
+#define PCF85063_REG_MO			0x09
+#define PCF85063_REG_YR			0x0A
+
+#define PCF85063_MO_C			0x80 /* century */
+
+static struct i2c_driver pcf85063_driver;
+
+struct pcf85063 {
+	struct rtc_device *rtc;
+	int c_polarity;	/* 0: MO_C=1 means 19xx, otherwise MO_C=1 means 20xx */
+	int voltage_low; /* incicates if a low_voltage was detected */
+};
+
+/*
+ * In the routines that deal directly with the pcf85063 hardware, we use
+ * rtc_time -- month 0-11, hour 0-23, yr = calendar year-epoch.
+ */
+static int pcf85063_get_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	struct pcf85063 *pcf85063 = i2c_get_clientdata(client);
+	unsigned char buf[13] = { PCF85063_REG_CTRL1 };
+
+	struct i2c_msg msgs[] = {
+		{/* setup read ptr */
+			.addr = client->addr,
+			.len = 1,
+			.buf = buf
+		},
+		{/* read status + date */
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = 13,
+			.buf = buf
+		},
+	};
+	/* read registers */
+	if ((i2c_transfer(client->adapter, msgs, 2)) != 2) {
+		dev_err(&client->dev, "%s: read error\n", __func__);
+		return -EIO;
+	}
+
+	tm->tm_sec = bcd2bin(buf[PCF85063_REG_SC] & 0x7F);
+	tm->tm_min = bcd2bin(buf[PCF85063_REG_MN] & 0x7F);
+	tm->tm_hour = bcd2bin(buf[PCF85063_REG_HR] & 0x3F); /* rtc hr 0-23 */
+	tm->tm_mday = bcd2bin(buf[PCF85063_REG_DM] & 0x3F);
+	tm->tm_wday = buf[PCF85063_REG_DW] & 0x07;
+	tm->tm_mon = bcd2bin(buf[PCF85063_REG_MO] & 0x1F) - 1; /* rtc mn 1-12 */
+	tm->tm_year = bcd2bin(buf[PCF85063_REG_YR]);
+	if (tm->tm_year < 70)
+		tm->tm_year += 100;	/* assume we are in 1970...2069 */
+	/* detect the polarity heuristically. see note above. */
+	pcf85063->c_polarity = (buf[PCF85063_REG_MO] & PCF85063_MO_C) ?
+		(tm->tm_year >= 100) : (tm->tm_year < 100);
+
+	/* the clock can give out invalid datetime, but we cannot return
+	 * -EINVAL otherwise hwclock will refuse to set the time on bootup.
+	 */
+	if (rtc_valid_tm(tm) < 0)
+		dev_err(&client->dev, "retrieved date/time is not valid.\n");
+
+	return 0;
+}
+
+static int pcf85063_set_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	int i = 0, err = 0;
+	unsigned char buf[11];
+
+	/* Control & status */
+	buf[PCF85063_REG_CTRL1] = 0;
+	buf[PCF85063_REG_CTRL2] = 5;
+
+	/* hours, minutes and seconds */
+	buf[PCF85063_REG_SC] = bin2bcd(tm->tm_sec) & 0x7F;
+
+	buf[PCF85063_REG_MN] = bin2bcd(tm->tm_min);
+	buf[PCF85063_REG_HR] = bin2bcd(tm->tm_hour);
+
+	/* Day of month, 1 - 31 */
+	buf[PCF85063_REG_DM] = bin2bcd(tm->tm_mday);
+
+	/* Day, 0 - 6 */
+	buf[PCF85063_REG_DW] = tm->tm_wday & 0x07;
+
+	/* month, 1 - 12 */
+	buf[PCF85063_REG_MO] = bin2bcd(tm->tm_mon + 1);
+
+	/* year and century */
+	buf[PCF85063_REG_YR] = bin2bcd(tm->tm_year % 100);
+
+	/* write register's data */
+	for (i = 0; i < sizeof(buf); i++) {
+		unsigned char data[2] = { i, buf[i] };
+
+		err = i2c_master_send(client, data, sizeof(data));
+		if (err != sizeof(data)) {
+			dev_err(&client->dev, "%s: err=%d addr=%02x, data=%02x\n",
+					__func__, err, data[0], data[1]);
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+static int pcf85063_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	return pcf85063_get_datetime(to_i2c_client(dev), tm);
+}
+
+static int pcf85063_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	return pcf85063_set_datetime(to_i2c_client(dev), tm);
+}
+
+static const struct rtc_class_ops pcf85063_rtc_ops = {
+	.read_time	= pcf85063_rtc_read_time,
+	.set_time	= pcf85063_rtc_set_time
+};
+
+static int pcf85063_probe(struct i2c_client *client,
+				const struct i2c_device_id *id)
+{
+	struct pcf85063 *pcf85063;
+
+	dev_dbg(&client->dev, "%s\n", __func__);
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return -ENODEV;
+
+	pcf85063 = devm_kzalloc(&client->dev, sizeof(struct pcf85063),
+				GFP_KERNEL);
+	if (!pcf85063)
+		return -ENOMEM;
+
+	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
+
+	i2c_set_clientdata(client, pcf85063);
+
+	pcf85063->rtc = devm_rtc_device_register(&client->dev,
+				pcf85063_driver.driver.name,
+				&pcf85063_rtc_ops, THIS_MODULE);
+
+	return PTR_ERR_OR_ZERO(pcf85063->rtc);
+}
+
+static const struct i2c_device_id pcf85063_id[] = {
+	{ "pcf85063", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, pcf85063_id);
+
+#ifdef CONFIG_OF
+static const struct of_device_id pcf85063_of_match[] = {
+	{ .compatible = "nxp,pcf85063" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, pcf85063_of_match);
+#endif
+
+static struct i2c_driver pcf85063_driver = {
+	.driver		= {
+		.name	= "rtc-pcf85063",
+		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(pcf85063_of_match),
+	},
+	.probe		= pcf85063_probe,
+	.id_table	= pcf85063_id,
+};
+
+module_i2c_driver(pcf85063_driver);
+
+MODULE_AUTHOR("Søren Andersen <san@rosetechnology.dk>");
+MODULE_DESCRIPTION("PCF85063 RTC driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);


