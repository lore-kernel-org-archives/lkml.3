Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3I1EqM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 00:46:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3I1EqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 00:46:10 -0400
Date: Fri, 27 Sep 2013 21:47:21 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] driver-core: remove struct bus_type.drv_attrs
Message-ID: <20130928044721.GB25063@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Now that all in-kernel users of bus_type.drv_attrs have been converted
to use drv_groups instead, the drv_attrs field, and logic surrounding
it, can be removed.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/bus.c     |   40 ++--------------------------------------
 include/linux/device.h |    2 --
 2 files changed, 2 insertions(+), 40 deletions(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -591,37 +591,6 @@ void bus_remove_device(struct device *de
 	bus_put(dev->bus);
 }
 
-static int driver_add_attrs(struct bus_type *bus, struct device_driver *drv)
-{
-	int error = 0;
-	int i;
-
-	if (bus->drv_attrs) {
-		for (i = 0; bus->drv_attrs[i].attr.name; i++) {
-			error = driver_create_file(drv, &bus->drv_attrs[i]);
-			if (error)
-				goto err;
-		}
-	}
-done:
-	return error;
-err:
-	while (--i >= 0)
-		driver_remove_file(drv, &bus->drv_attrs[i]);
-	goto done;
-}
-
-static void driver_remove_attrs(struct bus_type *bus,
-				struct device_driver *drv)
-{
-	int i;
-
-	if (bus->drv_attrs) {
-		for (i = 0; bus->drv_attrs[i].attr.name; i++)
-			driver_remove_file(drv, &bus->drv_attrs[i]);
-	}
-}
-
 static int __must_check add_bind_files(struct device_driver *drv)
 {
 	int ret;
@@ -720,16 +689,12 @@ int bus_add_driver(struct device_driver
 		printk(KERN_ERR "%s: uevent attr (%s) failed\n",
 			__func__, drv->name);
 	}
-	error = driver_add_attrs(bus, drv);
+	error = driver_add_groups(drv, bus->drv_groups);
 	if (error) {
 		/* How the hell do we get out of this pickle? Give up */
-		printk(KERN_ERR "%s: driver_add_attrs(%s) failed\n",
-			__func__, drv->name);
-	}
-	error = driver_add_groups(drv, bus->drv_groups);
-	if (error)
 		printk(KERN_ERR "%s: driver_create_groups(%s) failed\n",
 			__func__, drv->name);
+	}
 
 	if (!drv->suppress_bind_attrs) {
 		error = add_bind_files(drv);
@@ -766,7 +731,6 @@ void bus_remove_driver(struct device_dri
 
 	if (!drv->suppress_bind_attrs)
 		remove_bind_files(drv);
-	driver_remove_attrs(drv->bus, drv);
 	driver_remove_groups(drv, drv->bus->drv_groups);
 	driver_remove_file(drv, &driver_attr_uevent);
 	klist_remove(&drv->p->knode_bus);
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -64,7 +64,6 @@ extern void bus_remove_file(struct bus_t
  * @dev_name:	Used for subsystems to enumerate devices like ("foo%u", dev->id).
  * @dev_root:	Default device to use as the parent.
  * @dev_attrs:	Default attributes of the devices on the bus.
- * @drv_attrs:	Default attributes of the device drivers on the bus.
  * @bus_groups:	Default attributes of the bus.
  * @dev_groups:	Default attributes of the devices on the bus.
  * @drv_groups: Default attributes of the device drivers on the bus.
@@ -106,7 +105,6 @@ struct bus_type {
 	const char		*dev_name;
 	struct device		*dev_root;
 	struct device_attribute	*dev_attrs;	/* use dev_groups instead */
-	struct driver_attribute	*drv_attrs;	/* use drv_groups instead */
 	const struct attribute_group **bus_groups;
 	const struct attribute_group **dev_groups;
 	const struct attribute_group **drv_groups;
