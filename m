Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab3CGCX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:23:27 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55906 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab3CGCX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:23:26 -0500
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, joe@perches.com
Cc: shangw@linux.vnet.ibm.com, linuxram@us.ibm.com,
        Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH 1/2] driver core: remove device_add_attrs() in drivers/base/bus.c
Date: Thu,  7 Mar 2013 10:22:45 +0800
Message-Id: <1362622966-20003-2-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1362622966-20003-1-git-send-email-weiyang@linux.vnet.ibm.com>
References: <1362622966-20003-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030702-4790-0000-0000-00000739BD31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally, we have two functions named device_add_attrs() in
drivers/base/bus.c and drivers/base/core.c. This will cause some confusion
when reading the code.

And the one in drivers/base/bus.c do the same action as device_add_attributes()
in drivers/base/core.c. That would be better to reuse this code.

This patch just do some cleanup. Remove the device_add_attrs() in
drivers/base/bus.c and call device_add_attributes() directly.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Reviewed-by: Gavin Shan <shangw@linux.vnet.ibm.com>
---
 drivers/base/bus.c     |   21 +--------------------
 drivers/base/core.c    |    2 +-
 include/linux/device.h |    2 ++
 3 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 24eb078..79c2a48 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -452,25 +452,6 @@ int bus_for_each_drv(struct bus_type *bus, struct device_driver *start,
 }
 EXPORT_SYMBOL_GPL(bus_for_each_drv);
 
-static int device_add_attrs(struct bus_type *bus, struct device *dev)
-{
-	int error = 0;
-	int i;
-
-	if (!bus->dev_attrs)
-		return 0;
-
-	for (i = 0; attr_name(bus->dev_attrs[i]); i++) {
-		error = device_create_file(dev, &bus->dev_attrs[i]);
-		if (error) {
-			while (--i >= 0)
-				device_remove_file(dev, &bus->dev_attrs[i]);
-			break;
-		}
-	}
-	return error;
-}
-
 static void device_remove_attrs(struct bus_type *bus, struct device *dev)
 {
 	int i;
@@ -496,7 +477,7 @@ int bus_add_device(struct device *dev)
 
 	if (bus) {
 		pr_debug("bus: '%s': add device %s\n", bus->name, dev_name(dev));
-		error = device_add_attrs(bus, dev);
+		error = device_add_attributes(dev, bus->dev_attrs);
 		if (error)
 			goto out_put;
 		error = sysfs_create_link(&bus->p->devices_kset->kobj,
diff --git a/drivers/base/core.c b/drivers/base/core.c
index a235085..369ae4e 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -397,7 +397,7 @@ static ssize_t store_uevent(struct device *dev, struct device_attribute *attr,
 static struct device_attribute uevent_attr =
 	__ATTR(uevent, S_IRUGO | S_IWUSR, show_uevent, store_uevent);
 
-static int device_add_attributes(struct device *dev,
+int device_add_attributes(struct device *dev,
 				 struct device_attribute *attrs)
 {
 	int error = 0;
diff --git a/include/linux/device.h b/include/linux/device.h
index 43dcda9..9cfe8e6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -518,6 +518,8 @@ ssize_t device_store_bool(struct device *dev, struct device_attribute *attr,
 	struct device_attribute dev_attr_##_name =		\
 		__ATTR_IGNORE_LOCKDEP(_name, _mode, _show, _store)
 
+extern int device_add_attributes(struct device *dev,
+				 struct device_attribute *attrs);
 extern int device_create_file(struct device *device,
 			      const struct device_attribute *entry);
 extern void device_remove_file(struct device *dev,
-- 
1.7.5.4

