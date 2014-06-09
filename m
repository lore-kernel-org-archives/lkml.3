Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840AbaFIRaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:30:10 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:44651 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbaFIRaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:30:07 -0400
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
To: a.zummo@towertech.it, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Raghavendra Ganiga <ravi23ganiga@gmail.com>
Subject: [PATCH] rtc: add support of nvram for maxim dallas rtc ds1343
Date: Mon,  9 Jun 2014 22:59:52 +0530
Message-Id: <1402334992-3945-1-git-send-email-ravi23ganiga@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to add support of nvram for maxim dallas
rtc ds1343

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
---
 drivers/rtc/rtc-ds1343.c | 75 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds1343.c b/drivers/rtc/rtc-ds1343.c
index c371918..ae9f997 100644
--- a/drivers/rtc/rtc-ds1343.c
+++ b/drivers/rtc/rtc-ds1343.c
@@ -4,6 +4,7 @@
  * Real Time Clock
  *
  * Author : Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
+ *	    Ankur Srivastava <sankurece@gmail.com> : DS1343 Nvram Support
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -45,6 +46,9 @@
 #define DS1343_CONTROL_REG	0x0F
 #define DS1343_STATUS_REG	0x10
 #define DS1343_TRICKLE_REG	0x11
+#define DS1343_NVRAM		0x20
+
+#define DS1343_NVRAM_LEN	96
 
 /* DS1343 Control Registers bits */
 #define DS1343_EOSC		0x80
@@ -149,6 +153,64 @@ static ssize_t ds1343_store_glitchfilter(struct device *dev,
 static DEVICE_ATTR(glitch_filter, S_IRUGO | S_IWUSR, ds1343_show_glitchfilter,
 			ds1343_store_glitchfilter);
 
+static ssize_t ds1343_nvram_write(struct file *filp, struct kobject *kobj,
+			struct bin_attribute *attr,
+			char *buf, loff_t off, size_t count)
+{
+	int ret;
+	unsigned char address;
+	struct device *dev = kobj_to_dev(kobj);
+	struct ds1343_priv *priv = dev_get_drvdata(dev);
+
+	if (unlikely(!count))
+		return count;
+
+	if ((count + off) > DS1343_NVRAM_LEN)
+		count = DS1343_NVRAM_LEN - off;
+
+	address = DS1343_NVRAM + off;
+
+	ret = regmap_bulk_write(priv->map, address, buf, count);
+	if (ret < 0)
+		dev_err(&priv->spi->dev, "Error in nvram write %d", ret);
+
+	return (ret < 0) ? ret : count;
+}
+
+
+static ssize_t ds1343_nvram_read(struct file *filp, struct kobject *kobj,
+				struct bin_attribute *attr,
+				char *buf, loff_t off, size_t count)
+{
+	int ret;
+	unsigned char address;
+	struct device *dev = kobj_to_dev(kobj);
+	struct ds1343_priv *priv = dev_get_drvdata(dev);
+
+	if (unlikely(!count))
+		return count;
+
+	if ((count + off) > DS1343_NVRAM_LEN)
+		count = DS1343_NVRAM_LEN - off;
+
+	address = DS1343_NVRAM + off;
+
+	ret = regmap_bulk_read(priv->map, address, buf, count);
+	if (ret < 0)
+		dev_err(&priv->spi->dev, "Error in nvram read %d\n", ret);
+
+	return (ret < 0) ? ret : count;
+}
+
+
+static struct bin_attribute nvram_attr = {
+	.attr.name	= "nvram",
+	.attr.mode	= S_IRUGO | S_IWUSR,
+	.read		= ds1343_nvram_read,
+	.write		= ds1343_nvram_write,
+	.size		= DS1343_NVRAM_LEN,
+};
+
 static ssize_t ds1343_show_alarmstatus(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -274,12 +336,16 @@ static int ds1343_sysfs_register(struct device *dev)
 	if (err)
 		goto error1;
 
+	err = device_create_bin_file(dev, &nvram_attr);
+	if (err)
+		goto error2;
+
 	if (priv->irq <= 0)
 		return err;
 
 	err = device_create_file(dev, &dev_attr_alarm_mode);
 	if (err)
-		goto error2;
+		goto error3;
 
 	err = device_create_file(dev, &dev_attr_alarm_status);
 	if (!err)
@@ -287,6 +353,9 @@ static int ds1343_sysfs_register(struct device *dev)
 
 	device_remove_file(dev, &dev_attr_alarm_mode);
 
+error3:
+	device_remove_bin_file(dev, &nvram_attr);
+
 error2:
 	device_remove_file(dev, &dev_attr_trickle_charger);
 
@@ -302,6 +371,7 @@ static void ds1343_sysfs_unregister(struct device *dev)
 
 	device_remove_file(dev, &dev_attr_glitch_filter);
 	device_remove_file(dev, &dev_attr_trickle_charger);
+	device_remove_bin_file(dev, &nvram_attr);
 
 	if (priv->irq <= 0)
 		return;
@@ -684,6 +754,7 @@ static struct spi_driver ds1343_driver = {
 module_spi_driver(ds1343_driver);
 
 MODULE_DESCRIPTION("DS1343 RTC SPI Driver");
-MODULE_AUTHOR("Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>");
+MODULE_AUTHOR("Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>,"
+		"Ankur Srivastava <sankurece@gmail.com>");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DS1343_DRV_VERSION);
-- 
1.9.1

