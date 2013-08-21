Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3HUWpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 18:45:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab3HUWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 18:45:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Evgeniy Polyakov <zbr@ioremap.net>,
        Alexander Stein <alexander.stein@informatik.tu-chemnitz.de>
Subject: [PATCH 06/11] w1: slaves: w1_ds2431: convert to use w1_family_ops.groups
Date: Wed, 21 Aug 2013 15:45:00 -0700
Message-Id: <1377125105-25388-6-git-send-email-gregkh@linuxfoundation.org>
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
 drivers/w1/slaves/w1_ds2431.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/drivers/w1/slaves/w1_ds2431.c b/drivers/w1/slaves/w1_ds2431.c
index cef8605e..9c4ff9d2 100644
--- a/drivers/w1/slaves/w1_ds2431.c
+++ b/drivers/w1/slaves/w1_ds2431.c
@@ -96,9 +96,9 @@ static int w1_f2d_readblock(struct w1_slave *sl, int off, int count, char *buf)
 	return -1;
 }
 
-static ssize_t w1_f2d_read_bin(struct file *filp, struct kobject *kobj,
-			       struct bin_attribute *bin_attr,
-			       char *buf, loff_t off, size_t count)
+static ssize_t eeprom_read(struct file *filp, struct kobject *kobj,
+			   struct bin_attribute *bin_attr, char *buf,
+			   loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	int todo = count;
@@ -202,9 +202,9 @@ retry:
 	return 0;
 }
 
-static ssize_t w1_f2d_write_bin(struct file *filp, struct kobject *kobj,
-				struct bin_attribute *bin_attr,
-				char *buf, loff_t off, size_t count)
+static ssize_t eeprom_write(struct file *filp, struct kobject *kobj,
+			    struct bin_attribute *bin_attr, char *buf,
+			    loff_t off, size_t count)
 {
 	struct w1_slave *sl = kobj_to_w1_slave(kobj);
 	int addr, len;
@@ -264,29 +264,24 @@ out_up:
 	return count;
 }
 
-static struct bin_attribute w1_f2d_bin_attr = {
-	.attr = {
-		.name = "eeprom",
-		.mode = S_IRUGO | S_IWUSR,
-	},
-	.size = W1_F2D_EEPROM_SIZE,
-	.read = w1_f2d_read_bin,
-	.write = w1_f2d_write_bin,
+static BIN_ATTR_RW(eeprom, W1_F2D_EEPROM_SIZE);
+
+static struct bin_attribute *w1_f2d_bin_attrs[] = {
+	&bin_attr_eeprom,
+	NULL,
 };
 
-static int w1_f2d_add_slave(struct w1_slave *sl)
-{
-	return sysfs_create_bin_file(&sl->dev.kobj, &w1_f2d_bin_attr);
-}
+static const struct attribute_group w1_f2d_group = {
+	.bin_attrs = w1_f2d_bin_attrs,
+};
 
-static void w1_f2d_remove_slave(struct w1_slave *sl)
-{
-	sysfs_remove_bin_file(&sl->dev.kobj, &w1_f2d_bin_attr);
-}
+static const struct attribute_group *w1_f2d_groups[] = {
+	&w1_f2d_group,
+	NULL,
+};
 
 static struct w1_family_ops w1_f2d_fops = {
-	.add_slave      = w1_f2d_add_slave,
-	.remove_slave   = w1_f2d_remove_slave,
+	.groups		= w1_f2d_groups,
 };
 
 static struct w1_family w1_family_2d = {
-- 
1.8.3.rc0.20.gb99dd2e

