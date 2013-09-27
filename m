Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134Ab3I0CgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 22:36:19 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:63714 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3I0CgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 22:36:17 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v2] i2c: i2c-dev: Create 'name' attribute automatically
Date: Thu, 26 Sep 2013 19:36:11 -0700
Message-Id: <1380249371-32430-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'name' attribute is needed for all i2c-dev class devices, meaning
it can be created automatically by pointing to it in the class data
structure. This simplifies the code and reduces the probability for race
conditions (the name attribute should exist by the time the device is
announced to user space).

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2: Use class->dev_groups instead of class->dev_attrs
    Better use of device macros
    Simplify changes: there is no need to declare i2c_dev_class statically,
    so revert to use class_create/class_destroy.

Test results:

$ grep . /sys/class/i2c-dev/*/name
/sys/class/i2c-dev/i2c-0/name:i915 gmbus ssc
/sys/class/i2c-dev/i2c-1/name:i915 gmbus vga
/sys/class/i2c-dev/i2c-2/name:i915 gmbus panel
/sys/class/i2c-dev/i2c-3/name:i915 gmbus dpc
/sys/class/i2c-dev/i2c-4/name:i915 gmbus dpb
/sys/class/i2c-dev/i2c-5/name:i915 gmbus dpd
/sys/class/i2c-dev/i2c-6/name:DPDDC-B
/sys/class/i2c-dev/i2c-7/name:DPDDC-C
/sys/class/i2c-dev/i2c-8/name:DPDDC-D
/sys/class/i2c-dev/i2c-9/name:SMBus I801 adapter at f040

 drivers/i2c/i2c-dev.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index c3ccdea..80b47e8 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -102,8 +102,8 @@ static void return_i2c_dev(struct i2c_dev *i2c_dev)
 	kfree(i2c_dev);
 }
 
-static ssize_t show_adapter_name(struct device *dev,
-				 struct device_attribute *attr, char *buf)
+static ssize_t name_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
 {
 	struct i2c_dev *i2c_dev = i2c_dev_get_by_minor(MINOR(dev->devt));
 
@@ -111,7 +111,13 @@ static ssize_t show_adapter_name(struct device *dev,
 		return -ENODEV;
 	return sprintf(buf, "%s\n", i2c_dev->adap->name);
 }
-static DEVICE_ATTR(name, S_IRUGO, show_adapter_name, NULL);
+static DEVICE_ATTR_RO(name);
+
+static struct attribute *i2c_attrs[] = {
+	&dev_attr_name.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(i2c);
 
 /* ------------------------------------------------------------------------- */
 
@@ -562,15 +568,10 @@ static int i2cdev_attach_adapter(struct device *dev, void *dummy)
 		res = PTR_ERR(i2c_dev->dev);
 		goto error;
 	}
-	res = device_create_file(i2c_dev->dev, &dev_attr_name);
-	if (res)
-		goto error_destroy;
 
 	pr_debug("i2c-dev: adapter [%s] registered as minor %d\n",
 		 adap->name, adap->nr);
 	return 0;
-error_destroy:
-	device_destroy(i2c_dev_class, MKDEV(I2C_MAJOR, adap->nr));
 error:
 	return_i2c_dev(i2c_dev);
 	return res;
@@ -589,7 +590,6 @@ static int i2cdev_detach_adapter(struct device *dev, void *dummy)
 	if (!i2c_dev) /* attach_adapter must have failed */
 		return 0;
 
-	device_remove_file(i2c_dev->dev, &dev_attr_name);
 	return_i2c_dev(i2c_dev);
 	device_destroy(i2c_dev_class, MKDEV(I2C_MAJOR, adap->nr));
 
@@ -637,6 +637,7 @@ static int __init i2c_dev_init(void)
 		res = PTR_ERR(i2c_dev_class);
 		goto out_unreg_chrdev;
 	}
+	i2c_dev_class->dev_groups = i2c_groups;
 
 	/* Keep track of adapters which will be added or removed later */
 	res = bus_register_notifier(&i2c_bus_type, &i2cdev_notifier);
-- 
1.7.9.7

