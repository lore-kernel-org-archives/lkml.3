Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3GJWUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 18:20:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab3GJWUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 18:20:32 -0400
Date: Wed, 10 Jul 2013 15:20:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: oliver+list@schinagl.nl, linux@roeck-us.net, khali@linux-fr.org,
        gregkh@linuxfoundation.org
Subject: [PATCH 7/6 v2] driver core: add default groups to struct class
Message-ID: <20130710222031.GA3644@kroah.com>
References: <1373486714-14531-1-git-send-email-gregkh@linuxfoundation.org>
 <20130710220531.GA4210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710220531.GA4210@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be using groups, not attribute lists, for classes to allow
subdirectories, and soon, binary files.  Groups are just more flexible
overall, so add them.

The dev_attrs list will go away after all in-kernel users are converted
to use dev_groups.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

v2: forgot to remove groups from classes when the device is removed, it
    still worked fine, but it's nice to clean up things properly.

 drivers/base/core.c    |    9 ++++++++-
 include/linux/device.h |    4 +++-
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -528,9 +528,12 @@ static int device_add_attrs(struct devic
 	int error;
 
 	if (class) {
-		error = device_add_attributes(dev, class->dev_attrs);
+		error = device_add_groups(dev, class->dev_groups);
 		if (error)
 			return error;
+		error = device_add_attributes(dev, class->dev_attrs);
+		if (error)
+			goto err_remove_class_groups;
 		error = device_add_bin_attributes(dev, class->dev_bin_attrs);
 		if (error)
 			goto err_remove_class_attrs;
@@ -563,6 +566,9 @@ static int device_add_attrs(struct devic
  err_remove_class_attrs:
 	if (class)
 		device_remove_attributes(dev, class->dev_attrs);
+ err_remove_class_groups:
+	if (class)
+		device_remove_groups(dev, class->dev_groups);
 
 	return error;
 }
@@ -581,6 +587,7 @@ static void device_remove_attrs(struct d
 	if (class) {
 		device_remove_attributes(dev, class->dev_attrs);
 		device_remove_bin_attributes(dev, class->dev_bin_attrs);
+		device_remove_groups(dev, class->dev_groups);
 	}
 }
 
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -313,6 +313,7 @@ int subsys_virtual_register(struct bus_t
  * @name:	Name of the class.
  * @owner:	The module owner.
  * @class_attrs: Default attributes of this class.
+ * @dev_groups:	Default attributes of the devices that belong to the class.
  * @dev_attrs:	Default attributes of the devices belong to the class.
  * @dev_bin_attrs: Default binary attributes of the devices belong to the class.
  * @dev_kobj:	The kobject that represents this class and links it into the hierarchy.
@@ -342,7 +343,8 @@ struct class {
 	struct module		*owner;
 
 	struct class_attribute		*class_attrs;
-	struct device_attribute		*dev_attrs;
+	struct device_attribute		*dev_attrs;	/* use dev_groups instead */
+	const struct attribute_group	**dev_groups;
 	struct bin_attribute		*dev_bin_attrs;
 	struct kobject			*dev_kobj;
 
