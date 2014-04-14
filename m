Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbaDNKzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 06:55:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaDNKyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:54:50 -0400
Date: Mon, 14 Apr 2014 12:54:47 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] driver core: Move driver_data back to struct device
Message-ID: <20140414125447.168b3837@endymion.delvare>
In-Reply-To: <20140414124802.2859439e@endymion.delvare>
References: <20140414124802.2859439e@endymion.delvare>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having to allocate memory as part of dev_set_drvdata() is a problem
because that memory may never get freed if the device itself is not
created. So move driver_data back to struct device.

This is a partial revert of commit b4028437.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/base.h    |    3 ---
 drivers/base/dd.c      |   13 +++----------
 include/linux/device.h |    3 +++
 3 files changed, 6 insertions(+), 13 deletions(-)

--- linux-3.15-rc1.orig/drivers/base/base.h	2014-04-14 09:28:47.122857147 +0200
+++ linux-3.15-rc1/drivers/base/base.h	2014-04-14 09:42:50.026552544 +0200
@@ -63,8 +63,6 @@ struct driver_private {
  *	binding of drivers which were unable to get all the resources needed by
  *	the device; typically because it depends on another driver getting
  *	probed first.
- * @driver_data - private pointer for driver specific info.  Will turn into a
- * list soon.
  * @device - pointer back to the struct class that this structure is
  * associated with.
  *
@@ -76,7 +74,6 @@ struct device_private {
 	struct klist_node knode_driver;
 	struct klist_node knode_bus;
 	struct list_head deferred_probe;
-	void *driver_data;
 	struct device *device;
 };
 #define to_device_private_parent(obj)	\
--- linux-3.15-rc1.orig/drivers/base/dd.c	2014-04-14 09:28:47.122857147 +0200
+++ linux-3.15-rc1/drivers/base/dd.c	2014-04-14 12:52:52.957743343 +0200
@@ -577,22 +577,15 @@ void driver_detach(struct device_driver
  */
 void *dev_get_drvdata(const struct device *dev)
 {
-	if (dev && dev->p)
-		return dev->p->driver_data;
+	if (dev)
+		return dev->driver_data;
 	return NULL;
 }
 EXPORT_SYMBOL(dev_get_drvdata);
 
 int dev_set_drvdata(struct device *dev, void *data)
 {
-	int error;
-
-	if (!dev->p) {
-		error = device_private_init(dev);
-		if (error)
-			return error;
-	}
-	dev->p->driver_data = data;
+	dev->driver_data = data;
 	return 0;
 }
 EXPORT_SYMBOL(dev_set_drvdata);
--- linux-3.15-rc1.orig/include/linux/device.h	2014-04-14 09:42:31.772119674 +0200
+++ linux-3.15-rc1/include/linux/device.h	2014-04-14 12:53:10.284166917 +0200
@@ -679,6 +679,7 @@ struct acpi_dev_node {
  * 		variants, which GPIO pins act in what additional roles, and so
  * 		on.  This shrinks the "Board Support Packages" (BSPs) and
  * 		minimizes board-specific #ifdefs in drivers.
+ * @driver_data: Private pointer for driver specific info.
  * @power:	For device power management.
  * 		See Documentation/power/devices.txt for details.
  * @pm_domain:	Provide callbacks that are executed during system suspend,
@@ -740,6 +741,8 @@ struct device {
 					   device */
 	void		*platform_data;	/* Platform specific data, device
 					   core doesn't touch it */
+	void		*driver_data;	/* Driver data, set and get with
+					   dev_set/get_drvdata */
 	struct dev_pm_info	power;
 	struct dev_pm_domain	*pm_domain;
 

-- 
Jean Delvare
SUSE L3 Support
