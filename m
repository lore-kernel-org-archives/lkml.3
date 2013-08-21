Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3HUWsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:48:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3HUWpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: [PATCH 07/11] w1: slaves: w1_ds2433: convert to use w1_family_ops.groups
Date: Wed, 21 Aug 2013 15:45:01 -0700
Message-Id: <1377125105-25388-7-git-send-email-gregkh@linuxfoundation.org>
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
 drivers/w1/slaves/w1_ds2433.c | 47 ++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2433.c b/drivers/w1/slaves/w1_ds2433.c
index 10cc1b61..72319a96 100644
--- a/drivers/w1/slaves/w1_ds2433.c
+++ b/drivers/w1/slaves/w1_ds2433.c
@@ -93,9 +93,9 @@ static int w1_f23_refresh_block(struct w1_slave *sl, struct w1_f23_data *data,
 }
 #endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
 
-static ssize_t w1_f23_read_bin(struct file *filp, struct kobject *kobj,
-			       struct bin_attribute *bin_attr,
-			       char *buf, loff_t off, size_t count)
+static ssize_t eeprom_read(struct file *filp, struct kobject *kobj,
+			   struct bin_attribute *bin_attr, char *buf,
+			   loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 #ifdef CONFIG_W1_SLAVE_DS2433_CRC
@@ -207,9 +207,9 @@ static int w1_f23_write(struct w1_slave *sl, int addr, int len, const u8 *data)
 	return 0;
 }
 
-static ssize_t w1_f23_write_bin(struct file *filp, struct kobject *kobj,
-				struct bin_attribute *bin_attr,
-				char *buf, loff_t off, size_t count)
+static ssize_t eeprom_write(struct file *filp, struct kobject *kobj,
+			    struct bin_attribute *bin_attr, char *buf,
+			    loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	int addr, len, idx;
@@ -257,19 +257,24 @@ out_up:
 	return count;
 }
 
-static struct bin_attribute w1_f23_bin_attr = {
-	.attr = {
-		.name = "eeprom",
-		.mode = S_IRUGO | S_IWUSR,
-	},
-	.size = W1_EEPROM_SIZE,
-	.read = w1_f23_read_bin,
-	.write = w1_f23_write_bin,
+static BIN_ATTR_RW(eeprom, W1_EEPROM_SIZE);
+
+static struct bin_attribute *w1_f23_bin_attributes[] = {
+	&bin_attr_eeprom,
+	NULL,
+};
+
+static const struct attribute_group w1_f23_group = {
+	.bin_attrs = w1_f23_bin_attributes,
+};
+
+static const struct attribute_group *w1_f23_groups[] = {
+	&w1_f23_group,
+	NULL,
 };
 
 static int w1_f23_add_slave(struct w1_slave *sl)
 {
-	int err;
 #ifdef CONFIG_W1_SLAVE_DS2433_CRC
 	struct w1_f23_data *data;
 
@@ -279,15 +284,7 @@ static int w1_f23_add_slave(struct w1_slave *sl)
 	sl->family_data = data;
 
 #endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
-
-	err = sysfs_create_bin_file(&sl->dev.kobj, &w1_f23_bin_attr);
-
-#ifdef CONFIG_W1_SLAVE_DS2433_CRC
-	if (err)
-		kfree(data);
-#endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
-
-	return err;
+	return 0;
 }
 
 static void w1_f23_remove_slave(struct w1_slave *sl)
@@ -296,12 +293,12 @@ static void w1_f23_remove_slave(struct w1_slave *sl)
 	kfree(sl->family_data);
 	sl->family_data = NULL;
 #endif	/* CONFIG_W1_SLAVE_DS2433_CRC */
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f23_bin_attr);
 }
 
 static struct w1_family_ops w1_f23_fops = {
 	.add_slave      = w1_f23_add_slave,
 	.remove_slave   = w1_f23_remove_slave,
+	.groups		= w1_f23_groups,
 };
 
 static struct w1_family w1_family_23 = {
-- 
1.8.3.rc0.20.gb99dd2e

