Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3GXWGP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55340 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3GXWFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: [PATCH 12/36] c2port: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:15 -0700
Message-Id: <1374703539-9705-13-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the c2port class code to use the
correct field.

Cc: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/c2port/core.c | 50 +++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index a3b8370c..abe6e251 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -311,6 +311,7 @@ static ssize_t c2port_show_name(struct device *dev,
 
 	return sprintf(buf, "%s\n", c2dev->name);
 }
+static DEVICE_ATTR(name, 0444, c2port_show_name, NULL);
 
 static ssize_t c2port_show_flash_blocks_num(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -320,6 +321,7 @@ static ssize_t c2port_show_flash_blocks_num(struct device *dev,
 
 	return sprintf(buf, "%d\n", ops->blocks_num);
 }
+static DEVICE_ATTR(flash_blocks_num, 0444, c2port_show_flash_blocks_num, NULL);
 
 static ssize_t c2port_show_flash_block_size(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -329,6 +331,7 @@ static ssize_t c2port_show_flash_block_size(struct device *dev,
 
 	return sprintf(buf, "%d\n", ops->block_size);
 }
+static DEVICE_ATTR(flash_block_size, 0444, c2port_show_flash_block_size, NULL);
 
 static ssize_t c2port_show_flash_size(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -338,18 +341,18 @@ static ssize_t c2port_show_flash_size(struct device *dev,
 
 	return sprintf(buf, "%d\n", ops->blocks_num * ops->block_size);
 }
+static DEVICE_ATTR(flash_size, 0444, c2port_show_flash_size, NULL);
 
-static ssize_t c2port_show_access(struct device *dev,
-				struct device_attribute *attr, char *buf)
+static ssize_t access_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
 {
 	struct c2port_device *c2dev = dev_get_drvdata(dev);
 
 	return sprintf(buf, "%d\n", c2dev->access);
 }
 
-static ssize_t c2port_store_access(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
+static ssize_t access_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
 {
 	struct c2port_device *c2dev = dev_get_drvdata(dev);
 	struct c2port_ops *ops = c2dev->ops;
@@ -375,6 +378,7 @@ static ssize_t c2port_store_access(struct device *dev,
 
 	return count;
 }
+static DEVICE_ATTR_RW(access);
 
 static ssize_t c2port_store_reset(struct device *dev,
 				struct device_attribute *attr,
@@ -395,6 +399,7 @@ static ssize_t c2port_store_reset(struct device *dev,
 
 	return count;
 }
+static DEVICE_ATTR(reset, 0200, NULL, c2port_store_reset);
 
 static ssize_t __c2port_show_dev_id(struct c2port_device *dev, char *buf)
 {
@@ -431,6 +436,7 @@ static ssize_t c2port_show_dev_id(struct device *dev,
 
 	return ret;
 }
+static DEVICE_ATTR(dev_id, 0444, c2port_show_dev_id, NULL);
 
 static ssize_t __c2port_show_rev_id(struct c2port_device *dev, char *buf)
 {
@@ -467,6 +473,7 @@ static ssize_t c2port_show_rev_id(struct device *dev,
 
 	return ret;
 }
+static DEVICE_ATTR(rev_id, 0444, c2port_show_rev_id, NULL);
 
 static ssize_t c2port_show_flash_access(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -536,6 +543,8 @@ static ssize_t c2port_store_flash_access(struct device *dev,
 
 	return count;
 }
+static DEVICE_ATTR(flash_access, 0644, c2port_show_flash_access,
+		   c2port_store_flash_access);
 
 static ssize_t __c2port_write_flash_erase(struct c2port_device *dev)
 {
@@ -616,6 +625,7 @@ static ssize_t c2port_store_flash_erase(struct device *dev,
 
 	return count;
 }
+static DEVICE_ATTR(flash_erase, 0200, NULL, c2port_store_flash_erase);
 
 static ssize_t __c2port_read_flash_data(struct c2port_device *dev,
 				char *buffer, loff_t offset, size_t count)
@@ -850,22 +860,20 @@ static ssize_t c2port_write_flash_data(struct file *filp, struct kobject *kobj,
 /*
  * Class attributes
  */
-
-static struct device_attribute c2port_attrs[] = {
-	__ATTR(name, 0444, c2port_show_name, NULL),
-	__ATTR(flash_blocks_num, 0444, c2port_show_flash_blocks_num, NULL),
-	__ATTR(flash_block_size, 0444, c2port_show_flash_block_size, NULL),
-	__ATTR(flash_size, 0444, c2port_show_flash_size, NULL),
-	__ATTR(access, 0644, c2port_show_access, c2port_store_access),
-	__ATTR(reset, 0200, NULL, c2port_store_reset),
-	__ATTR(dev_id, 0444, c2port_show_dev_id, NULL),
-	__ATTR(rev_id, 0444, c2port_show_rev_id, NULL),
-
-	__ATTR(flash_access, 0644, c2port_show_flash_access,
-					c2port_store_flash_access),
-	__ATTR(flash_erase, 0200, NULL, c2port_store_flash_erase),
-	__ATTR_NULL,
+static struct attribute *c2port_attrs[] = {
+	&dev_attr_name.attr,
+	&dev_attr_flash_blocks_num.attr,
+	&dev_attr_flash_block_size.attr,
+	&dev_attr_flash_size.attr,
+	&dev_attr_access.attr,
+	&dev_attr_reset.attr,
+	&dev_attr_dev_id.attr,
+	&dev_attr_rev_id.attr,
+	&dev_attr_flash_access.attr,
+	&dev_attr_flash_erase.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(c2port);
 
 static struct bin_attribute c2port_bin_attrs[] = {
 	{
@@ -979,7 +987,7 @@ static int __init c2port_init(void)
 		printk(KERN_ERR "c2port: failed to allocate class\n");
 		return PTR_ERR(c2port_class);
 	}
-	c2port_class->dev_attrs = c2port_attrs;
+	c2port_class->dev_groups = c2port_groups;
 	c2port_class->dev_bin_attrs = c2port_bin_attrs;
 
 	return 0;
-- 
1.8.3.rc0.20.gb99dd2e

