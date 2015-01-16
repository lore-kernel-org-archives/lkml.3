Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbbAPSuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:50:10 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48112 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbbAPSuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:50:04 -0500
From: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Subject: [PATCH 1/4] uio: Simplify the lifetime logic of struct uio_device.
Date: Fri, 16 Jan 2015 10:49:36 -0800
Message-Id: <1421434179-3650-2-git-send-email-mandeep.sandhu@cyaninc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421434179-3650-1-git-send-email-mandeep.sandhu@cyaninc.com>
References: <1421434179-3650-1-git-send-email-mandeep.sandhu@cyaninc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Embed struct device into struct uio_device, and use
the refcounting and the release method of struct device
to control struct uio_device.

This allows device_create and device_destroy to be replaced
with the more standard device_register and device_unregister,
and allows the struct device reference count to act as a
reference count on struct idev as well.

Tested-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Signed-off-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
---
 drivers/uio/uio.c          | 41 ++++++++++++++++++++++++++---------------
 include/linux/uio_driver.h |  3 ++-
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 6276f13..350b81b 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -16,7 +16,6 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/poll.h>
-#include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/idr.h>
@@ -270,7 +269,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		if (!map_found) {
 			map_found = 1;
 			idev->map_dir = kobject_create_and_add("maps",
-							&idev->dev->kobj);
+							&idev->device.kobj);
 			if (!idev->map_dir)
 				goto err_map;
 		}
@@ -295,7 +294,7 @@ static int uio_dev_add_attributes(struct uio_device *idev)
 		if (!portio_found) {
 			portio_found = 1;
 			idev->portio_dir = kobject_create_and_add("portio",
-							&idev->dev->kobj);
+							&idev->device.kobj);
 			if (!idev->portio_dir)
 				goto err_portio;
 		}
@@ -334,7 +333,7 @@ err_map_kobj:
 		kobject_put(&map->kobj);
 	}
 	kobject_put(idev->map_dir);
-	dev_err(idev->dev, "error creating sysfs files (%d)\n", ret);
+	dev_err(&idev->device, "error creating sysfs files (%d)\n", ret);
 	return ret;
 }
 
@@ -371,7 +370,7 @@ static int uio_get_minor(struct uio_device *idev)
 		idev->minor = retval;
 		retval = 0;
 	} else if (retval == -ENOSPC) {
-		dev_err(idev->dev, "too many uio devices\n");
+		dev_err(&idev->device, "too many uio devices\n");
 		retval = -EINVAL;
 	}
 	mutex_unlock(&minor_lock);
@@ -785,6 +784,13 @@ static void release_uio_class(void)
 	uio_major_cleanup();
 }
 
+static void uio_device_release(struct device *dev)
+{
+	struct uio_device *idev = dev_get_drvdata(dev);
+
+	devm_kfree(dev->parent, idev);
+}
+
 /**
  * uio_register_device - register a new userspace IO device
  * @owner:	module that creates the new device
@@ -819,14 +825,19 @@ int __uio_register_device(struct module *owner,
 	if (ret)
 		return ret;
 
-	idev->dev = device_create(&uio_class, parent,
-				  MKDEV(uio_major, idev->minor), idev,
-				  "uio%d", idev->minor);
-	if (IS_ERR(idev->dev)) {
-		printk(KERN_ERR "UIO: device register failed\n");
-		ret = PTR_ERR(idev->dev);
+	idev->device.devt = MKDEV(uio_major, idev->minor);
+	idev->device.class = &uio_class;
+	idev->device.parent = parent;
+	idev->device.release = uio_device_release;
+	dev_set_drvdata(&idev->device, idev);
+
+	ret = kobject_set_name(&idev->device.kobj, "uio%d", idev->minor);
+	if (ret)
+		goto err_device_create;
+
+	ret = device_register(&idev->device);
+	if (ret)
 		goto err_device_create;
-	}
 
 	ret = uio_dev_add_attributes(idev);
 	if (ret)
@@ -835,7 +846,7 @@ int __uio_register_device(struct module *owner,
 	info->uio_dev = idev;
 
 	if (info->irq && (info->irq != UIO_IRQ_CUSTOM)) {
-		ret = devm_request_irq(idev->dev, info->irq, uio_interrupt,
+		ret = devm_request_irq(&idev->device, info->irq, uio_interrupt,
 				  info->irq_flags, info->name, idev);
 		if (ret)
 			goto err_request_irq;
@@ -846,7 +857,7 @@ int __uio_register_device(struct module *owner,
 err_request_irq:
 	uio_dev_del_attributes(idev);
 err_uio_dev_add_attributes:
-	device_destroy(&uio_class, MKDEV(uio_major, idev->minor));
+	device_unregister(&idev->device);
 err_device_create:
 	uio_free_minor(idev);
 	return ret;
@@ -871,7 +882,7 @@ void uio_unregister_device(struct uio_info *info)
 
 	uio_dev_del_attributes(idev);
 
-	device_destroy(&uio_class, MKDEV(uio_major, idev->minor));
+	device_unregister(&idev->device);
 
 	return;
 }
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 32c0e83..e8f7f82 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -14,6 +14,7 @@
 #ifndef _UIO_DRIVER_H_
 #define _UIO_DRIVER_H_
 
+#include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
 
@@ -65,7 +66,7 @@ struct uio_port {
 
 struct uio_device {
         struct module           *owner;
-        struct device           *dev;
+	struct device           device;
         int                     minor;
         atomic_t                event;
         struct fasync_struct    *async_queue;
-- 
1.9.1

