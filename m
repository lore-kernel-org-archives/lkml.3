Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3JHCRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:17:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3JHCRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:17:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 8/8] i2o: convert bus code to use dev_groups
Date: Mon,  7 Oct 2013 18:27:42 -0700
Message-Id: <1381195662-28009-9-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the i2o bus code to use the
correct field.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/message/i2o/core.h   |  2 +-
 drivers/message/i2o/device.c | 32 +++++++++++++++++++++-----------
 drivers/message/i2o/driver.c |  2 +-
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/message/i2o/core.h b/drivers/message/i2o/core.h
index cbe384f..91614f1 100644
--- a/drivers/message/i2o/core.h
+++ b/drivers/message/i2o/core.h
@@ -33,7 +33,7 @@ extern int __init i2o_pci_init(void);
 extern void __exit i2o_pci_exit(void);
 
 /* device */
-extern struct device_attribute i2o_device_attrs[];
+extern const struct attribute_group *i2o_device_groups[];
 
 extern void i2o_device_remove(struct i2o_device *);
 extern int i2o_device_parse_lct(struct i2o_controller *);
diff --git a/drivers/message/i2o/device.c b/drivers/message/i2o/device.c
index 4547db9..98348f4 100644
--- a/drivers/message/i2o/device.c
+++ b/drivers/message/i2o/device.c
@@ -138,45 +138,55 @@ static void i2o_device_release(struct device *dev)
 }
 
 /**
- *	i2o_device_show_class_id - Displays class id of I2O device
+ *	class_id_show - Displays class id of I2O device
  *	@dev: device of which the class id should be displayed
  *	@attr: pointer to device attribute
  *	@buf: buffer into which the class id should be printed
  *
  *	Returns the number of bytes which are printed into the buffer.
  */
-static ssize_t i2o_device_show_class_id(struct device *dev,
-					struct device_attribute *attr,
-					char *buf)
+static ssize_t class_id_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
 {
 	struct i2o_device *i2o_dev = to_i2o_device(dev);
 
 	sprintf(buf, "0x%03x\n", i2o_dev->lct_data.class_id);
 	return strlen(buf) + 1;
 }
+static DEVICE_ATTR_RO(class_id);
 
 /**
- *	i2o_device_show_tid - Displays TID of I2O device
+ *	tid_show - Displays TID of I2O device
  *	@dev: device of which the TID should be displayed
  *	@attr: pointer to device attribute
  *	@buf: buffer into which the TID should be printed
  *
  *	Returns the number of bytes which are printed into the buffer.
  */
-static ssize_t i2o_device_show_tid(struct device *dev,
-				   struct device_attribute *attr, char *buf)
+static ssize_t tid_show(struct device *dev, struct device_attribute *attr,
+			char *buf)
 {
 	struct i2o_device *i2o_dev = to_i2o_device(dev);
 
 	sprintf(buf, "0x%03x\n", i2o_dev->lct_data.tid);
 	return strlen(buf) + 1;
 }
+static DEVICE_ATTR_RO(tid);
 
 /* I2O device attributes */
-struct device_attribute i2o_device_attrs[] = {
-	__ATTR(class_id, S_IRUGO, i2o_device_show_class_id, NULL),
-	__ATTR(tid, S_IRUGO, i2o_device_show_tid, NULL),
-	__ATTR_NULL
+static struct attribute *i2o_device_attrs[] = {
+	&dev_attr_class_id.attr,
+	&dev_attr_tid.attr,
+	NULL,
+};
+
+static const struct attribute_group i2o_device_group = {
+	.attrs = i2o_device_attrs,
+};
+
+const struct attribute_group *i2o_device_groups[] = {
+	&i2o_device_group,
+	NULL,
 };
 
 /**
diff --git a/drivers/message/i2o/driver.c b/drivers/message/i2o/driver.c
index 813eaa3..b6b92d7 100644
--- a/drivers/message/i2o/driver.c
+++ b/drivers/message/i2o/driver.c
@@ -62,7 +62,7 @@ static int i2o_bus_match(struct device *dev, struct device_driver *drv)
 struct bus_type i2o_bus_type = {
 	.name = "i2o",
 	.match = i2o_bus_match,
-	.dev_attrs = i2o_device_attrs
+	.dev_groups = i2o_device_groups,
 };
 
 /**
-- 
1.8.4.6.g82e253f.dirty

