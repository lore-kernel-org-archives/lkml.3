Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3GNXG4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:06:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3GNXGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:06:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, oliver@schinagl.nl, linux@roeck-us.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 08/10] driver core: add default groups to struct class
Date: Sun, 14 Jul 2013 16:05:58 -0700
Message-Id: <1373843160-3990-9-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be using groups, not attribute lists, for classes to allow
subdirectories, and soon, binary files.  Groups are just more flexible
overall, so add them.

The dev_attrs list will go away after all in-kernel users are converted
to use dev_groups.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c    | 9 ++++++++-
 include/linux/device.h | 4 +++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index a8aae182..8856d745 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -528,9 +528,12 @@ static int device_add_attrs(struct device *dev)
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
@@ -563,6 +566,9 @@ static int device_add_attrs(struct device *dev)
  err_remove_class_attrs:
 	if (class)
 		device_remove_attributes(dev, class->dev_attrs);
+ err_remove_class_groups:
+	if (class)
+		device_remove_groups(dev, class->dev_groups);
 
 	return error;
 }
@@ -581,6 +587,7 @@ static void device_remove_attrs(struct device *dev)
 	if (class) {
 		device_remove_attributes(dev, class->dev_attrs);
 		device_remove_bin_attributes(dev, class->dev_bin_attrs);
+		device_remove_groups(dev, class->dev_groups);
 	}
 }
 
diff --git a/include/linux/device.h b/include/linux/device.h
index bd5931e8..22b546a5 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -320,6 +320,7 @@ int subsys_virtual_register(struct bus_type *subsys,
  * @name:	Name of the class.
  * @owner:	The module owner.
  * @class_attrs: Default attributes of this class.
+ * @dev_groups:	Default attributes of the devices that belong to the class.
  * @dev_attrs:	Default attributes of the devices belong to the class.
  * @dev_bin_attrs: Default binary attributes of the devices belong to the class.
  * @dev_kobj:	The kobject that represents this class and links it into the hierarchy.
@@ -349,7 +350,8 @@ struct class {
 	struct module		*owner;
 
 	struct class_attribute		*class_attrs;
-	struct device_attribute		*dev_attrs;
+	struct device_attribute		*dev_attrs;	/* use dev_groups instead */
+	const struct attribute_group	**dev_groups;
 	struct bin_attribute		*dev_bin_attrs;
 	struct kobject			*dev_kobj;
 
-- 
1.8.3.rc0.20.gb99dd2e

