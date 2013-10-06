Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3JFGNO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 02:13:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3JFGNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 02:13:12 -0400
Date: Sat, 5 Oct 2013 18:25:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Subject: driver core: remove dev_attrs from struct class
Message-ID: <20131006012502.GA8331@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Now that all in-kernel users of the dev_attrs field are converted to use
dev_groups, we can safely remove dev_attrs from struct class.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c    |   38 +-------------------------------------
 include/linux/device.h |    2 --
 2 files changed, 1 insertion(+), 39 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -455,35 +455,6 @@ static ssize_t online_store(struct devic
 }
 static DEVICE_ATTR_RW(online);
 
-static int device_add_attributes(struct device *dev,
-				 struct device_attribute *attrs)
-{
-	int error = 0;
-	int i;
-
-	if (attrs) {
-		for (i = 0; attrs[i].attr.name; i++) {
-			error = device_create_file(dev, &attrs[i]);
-			if (error)
-				break;
-		}
-		if (error)
-			while (--i >= 0)
-				device_remove_file(dev, &attrs[i]);
-	}
-	return error;
-}
-
-static void device_remove_attributes(struct device *dev,
-				     struct device_attribute *attrs)
-{
-	int i;
-
-	if (attrs)
-		for (i = 0; attrs[i].attr.name; i++)
-			device_remove_file(dev, &attrs[i]);
-}
-
 static int device_add_bin_attributes(struct device *dev,
 				     struct bin_attribute *attrs)
 {
@@ -534,12 +505,9 @@ static int device_add_attrs(struct devic
 		error = device_add_groups(dev, class->dev_groups);
 		if (error)
 			return error;
-		error = device_add_attributes(dev, class->dev_attrs);
-		if (error)
-			goto err_remove_class_groups;
 		error = device_add_bin_attributes(dev, class->dev_bin_attrs);
 		if (error)
-			goto err_remove_class_attrs;
+			goto err_remove_class_groups;
 	}
 
 	if (type) {
@@ -566,9 +534,6 @@ static int device_add_attrs(struct devic
  err_remove_class_bin_attrs:
 	if (class)
 		device_remove_bin_attributes(dev, class->dev_bin_attrs);
- err_remove_class_attrs:
-	if (class)
-		device_remove_attributes(dev, class->dev_attrs);
  err_remove_class_groups:
 	if (class)
 		device_remove_groups(dev, class->dev_groups);
@@ -588,7 +553,6 @@ static void device_remove_attrs(struct d
 		device_remove_groups(dev, type->groups);
 
 	if (class) {
-		device_remove_attributes(dev, class->dev_attrs);
 		device_remove_bin_attributes(dev, class->dev_bin_attrs);
 		device_remove_groups(dev, class->dev_groups);
 	}
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -325,7 +325,6 @@ int subsys_virtual_register(struct bus_t
  * @owner:	The module owner.
  * @class_attrs: Default attributes of this class.
  * @dev_groups:	Default attributes of the devices that belong to the class.
- * @dev_attrs:	Default attributes of the devices belong to the class.
  * @dev_bin_attrs: Default binary attributes of the devices belong to the class.
  * @dev_kobj:	The kobject that represents this class and links it into the hierarchy.
  * @dev_uevent:	Called when a device is added, removed from this class, or a
@@ -354,7 +353,6 @@ struct class {
 	struct module		*owner;
 
 	struct class_attribute		*class_attrs;
-	struct device_attribute		*dev_attrs;	/* use dev_groups instead */
 	const struct attribute_group	**dev_groups;
 	struct bin_attribute		*dev_bin_attrs;
 	struct kobject			*dev_kobj;
