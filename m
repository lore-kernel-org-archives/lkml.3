Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3HUWrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:47:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36044 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3HUWpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: [PATCH 08/11] w1: slaves: w1_ds28e04: convert to use w1_family_ops.groups
Date: Wed, 21 Aug 2013 15:45:02 -0700
Message-Id: <1377125105-25388-8-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377125105-25388-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the sysfs file creation/removal to the w1 core by using the
.groups field, saving code in the slave driver.

Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/w1/slaves/w1_ds28e04.c | 112 ++++++++++++++++-------------------------
 1 file changed, 42 insertions(+), 70 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds28e04.c b/drivers/w1/slaves/w1_ds28e04.c
index cd30a6d9..365d6dff 100644
--- a/drivers/w1/slaves/w1_ds28e04.c
+++ b/drivers/w1/slaves/w1_ds28e04.c
@@ -118,9 +118,9 @@ static int w1_f1C_read(struct w1_slave *sl, int addr, int len, char *data)
 	return w1_read_block(sl->master, data, len);
 }
 
-static ssize_t w1_f1C_read_bin(struct file *filp, struct kobject *kobj,
-			       struct bin_attribute *bin_attr,
-			       char *buf, loff_t off, size_t count)
+static ssize_t eeprom_read(struct file *filp, struct kobject *kobj,
+			   struct bin_attribute *bin_attr, char *buf,
+			   loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	struct w1_f1C_data *data = sl->family_data;
@@ -226,9 +226,9 @@ static int w1_f1C_write(struct w1_slave *sl, int addr, int len, const u8 *data)
 	return 0;
 }
 
-static ssize_t w1_f1C_write_bin(struct file *filp, struct kobject *kobj,
-			       struct bin_attribute *bin_attr,
-			       char *buf, loff_t off, size_t count)
+static ssize_t eeprom_write(struct file *filp, struct kobject *kobj,
+			    struct bin_attribute *bin_attr, char *buf,
+			    loff_t off, size_t count)
 
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
@@ -280,9 +280,11 @@ out_up:
 	return count;
 }
 
-static ssize_t w1_f1C_read_pio(struct file *filp, struct kobject *kobj,
-			       struct bin_attribute *bin_attr,
-			       char *buf, loff_t off, size_t count)
+static BIN_ATTR_RW(eeprom, W1_EEPROM_SIZE);
+
+static ssize_t pio_read(struct file *filp, struct kobject *kobj,
+			struct bin_attribute *bin_attr, char *buf, loff_t off,
+			size_t count)
 
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
@@ -299,9 +301,9 @@ static ssize_t w1_f1C_read_pio(struct file *filp, struct kobject *kobj,
 	return ret;
 }
 
-static ssize_t w1_f1C_write_pio(struct file *filp, struct kobject *kobj,
-				struct bin_attribute *bin_attr,
-				char *buf, loff_t off, size_t count)
+static ssize_t pio_write(struct file *filp, struct kobject *kobj,
+			 struct bin_attribute *bin_attr, char *buf, loff_t off,
+			 size_t count)
 
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
@@ -339,8 +341,10 @@ static ssize_t w1_f1C_write_pio(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
-static ssize_t w1_f1C_show_crccheck(struct device *dev,
-				    struct device_attribute *attr, char *buf)
+static BIN_ATTR_RW(pio, 1);
+
+static ssize_t crccheck_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
 {
 	if (put_user(w1_enable_crccheck + 0x30, buf))
 		return -EFAULT;
@@ -348,9 +352,8 @@ static ssize_t w1_f1C_show_crccheck(struct device *dev,
 	return sizeof(w1_enable_crccheck);
 }
 
-static ssize_t w1_f1C_store_crccheck(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
+static ssize_t crccheck_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
 {
 	char val;
 
@@ -371,35 +374,31 @@ static ssize_t w1_f1C_store_crccheck(struct device *dev,
 	return sizeof(w1_enable_crccheck);
 }
 
-#define NB_SYSFS_BIN_FILES 2
-static struct bin_attribute w1_f1C_bin_attr[NB_SYSFS_BIN_FILES] = {
-	{
-		.attr = {
-			.name = "eeprom",
-			.mode = S_IRUGO | S_IWUSR,
-		},
-		.size = W1_EEPROM_SIZE,
-		.read = w1_f1C_read_bin,
-		.write = w1_f1C_write_bin,
-	},
-	{
-		.attr = {
-			.name = "pio",
-			.mode = S_IRUGO | S_IWUSR,
-		},
-		.size = 1,
-		.read = w1_f1C_read_pio,
-		.write = w1_f1C_write_pio,
-	}
+static DEVICE_ATTR_RW(crccheck);
+
+static struct attribute *w1_f1C_attrs[] = {
+	&dev_attr_crccheck.attr,
+	NULL,
 };
 
-static DEVICE_ATTR(crccheck, S_IWUSR | S_IRUGO,
-		   w1_f1C_show_crccheck, w1_f1C_store_crccheck);
+static struct bin_attribute *w1_f1C_bin_attrs[] = {
+	&bin_attr_eeprom,
+	&bin_attr_pio,
+	NULL,
+};
+
+static const struct attribute_group w1_f1C_group = {
+	.attrs		= w1_f1C_attrs,
+	.bin_attrs	= w1_f1C_bin_attrs,
+};
+
+static const struct attribute_group *w1_f1C_groups[] = {
+	&w1_f1C_group,
+	NULL,
+};
 
 static int w1_f1C_add_slave(struct w1_slave *sl)
 {
-	int err = 0;
-	int i;
 	struct w1_f1C_data *data = NULL;
 
 	if (w1_enable_crccheck) {
@@ -409,46 +408,19 @@ static int w1_f1C_add_slave(struct w1_slave *sl)
 		sl->family_data = data;
 	}
 
-	/* create binary sysfs attributes */
-	for (i = 0; i < NB_SYSFS_BIN_FILES && !err; ++i)
-		err = sysfs_create_bin_file(
-			&sl->dev.kobj, &(w1_f1C_bin_attr[i]));
-
-	if (!err) {
-		/* create device attributes */
-		err = device_create_file(&sl->dev, &dev_attr_crccheck);
-	}
-
-	if (err) {
-		/* remove binary sysfs attributes */
-		for (i = 0; i < NB_SYSFS_BIN_FILES; ++i)
-			sysfs_remove_bin_file(
-				&sl->dev.kobj, &(w1_f1C_bin_attr[i]));
-
-		kfree(data);
-	}
-
-	return err;
+	return 0;
 }
 
 static void w1_f1C_remove_slave(struct w1_slave *sl)
 {
-	int i;
-
 	kfree(sl->family_data);
 	sl->family_data = NULL;
-
-	/* remove device attributes */
-	device_remove_file(&sl->dev, &dev_attr_crccheck);
-
-	/* remove binary sysfs attributes */
-	for (i = 0; i < NB_SYSFS_BIN_FILES; ++i)
-		sysfs_remove_bin_file(&sl->dev.kobj, &(w1_f1C_bin_attr[i]));
 }
 
 static struct w1_family_ops w1_f1C_fops = {
 	.add_slave      = w1_f1C_add_slave,
 	.remove_slave   = w1_f1C_remove_slave,
+	.groups		= w1_f1C_groups,
 };
 
 static struct w1_family w1_family_1C = {
-- 
1.8.3.rc0.20.gb99dd2e

