Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbaCDTL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:11:26 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:40618 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbaCDTLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:11:23 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 04/12] staging: usbip: userspace: migrate usbip_list to libudev
Date: Tue,  4 Mar 2014 21:10:44 +0200
Message-Id: <1393960252-21247-5-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies usbip_list to use libudev.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/src/usbip_list.c | 137 +++++++++--------------
 1 file changed, 51 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index 8864fa2..2255107 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -17,7 +17,7 @@
  */
 
 #include <sys/types.h>
-#include <sysfs/libsysfs.h>
+#include <libudev.h>
 
 #include <errno.h>
 #include <stdbool.h>
@@ -133,8 +133,8 @@ static int list_exported_devices(char *host)
 	return 0;
 }
 
-static void print_device(char *busid, char *vendor, char *product,
-			 bool parsable)
+static void print_device(const char *busid, const char *vendor,
+			 const char *product, bool parsable)
 {
 	if (parsable)
 		printf("busid=%s#usbid=%.4s:%.4s#", busid, vendor, product);
@@ -148,106 +148,71 @@ static void print_product_name(char *product_name, bool parsable)
 		printf("   %s\n", product_name);
 }
 
-static void print_interface(char *busid, char *driver, bool parsable)
-{
-	if (parsable)
-		printf("%s=%s#", busid, driver);
-	else
-		printf("%9s%s -> %s\n", "", busid, driver);
-}
-
-static int is_device(void *x)
-{
-	struct sysfs_attribute *devpath;
-	struct sysfs_device *dev = x;
-	int ret = 0;
-
-	devpath = sysfs_get_device_attr(dev, "devpath");
-	if (devpath && *devpath->value != '0')
-		ret = 1;
-
-	return ret;
-}
-
-static int devcmp(void *a, void *b)
-{
-	return strcmp(a, b);
-}
-
 static int list_devices(bool parsable)
 {
-	char bus_type[] = "usb";
-	char busid[SYSFS_BUS_ID_SIZE];
+	struct udev *udev;
+	struct udev_enumerate *enumerate;
+	struct udev_list_entry *devices, *dev_list_entry;
+	struct udev_device *dev;
+	const char *path;
+	const char *idVendor;
+	const char *idProduct;
+	const char *bConfValue;
+	const char *bNumIntfs;
+	const char *busid;
 	char product_name[128];
-	struct sysfs_bus *ubus;
-	struct sysfs_device *dev;
-	struct sysfs_device *intf;
-	struct sysfs_attribute *idVendor;
-	struct sysfs_attribute *idProduct;
-	struct sysfs_attribute *bConfValue;
-	struct sysfs_attribute *bNumIntfs;
-	struct dlist *devlist;
-	int i;
 	int ret = -1;
 
-	ubus = sysfs_open_bus(bus_type);
-	if (!ubus) {
-		err("could not open %s bus: %s", bus_type, strerror(errno));
-		return -1;
-	}
-
-	devlist = sysfs_get_bus_devices(ubus);
-	if (!devlist) {
-		err("could not get %s bus devices: %s", bus_type,
-		    strerror(errno));
-		goto err_out;
-	}
-
-	/* remove interfaces and root hubs from device list */
-	dlist_filter_sort(devlist, is_device, devcmp);
-
-	if (!parsable) {
-		printf("Local USB devices\n");
-		printf("=================\n");
-	}
-	dlist_for_each_data(devlist, dev, struct sysfs_device) {
-		idVendor   = sysfs_get_device_attr(dev, "idVendor");
-		idProduct  = sysfs_get_device_attr(dev, "idProduct");
-		bConfValue = sysfs_get_device_attr(dev, "bConfigurationValue");
-		bNumIntfs  = sysfs_get_device_attr(dev, "bNumInterfaces");
+	/* Create libudev context. */
+	udev = udev_new();
+
+	/* Create libudev device enumeration. */
+	enumerate = udev_enumerate_new(udev);
+
+	/* Take only USB devices that are not hubs and do not have
+	 * the bInterfaceNumber attribute, i.e. are not interfaces.
+	 */
+	udev_enumerate_add_match_subsystem(enumerate, "usb");
+	udev_enumerate_add_nomatch_sysattr(enumerate, "bDeviceClass", "09");
+	udev_enumerate_add_nomatch_sysattr(enumerate, "bInterfaceNumber", NULL);
+	udev_enumerate_scan_devices(enumerate);
+
+	devices = udev_enumerate_get_list_entry(enumerate);
+
+	/* Show information about each device. */
+	udev_list_entry_foreach(dev_list_entry, devices) {
+		path = udev_list_entry_get_name(dev_list_entry);
+		dev = udev_device_new_from_syspath(udev, path);
+
+		/* Get device information. */
+		idVendor = udev_device_get_sysattr_value(dev, "idVendor");
+		idProduct = udev_device_get_sysattr_value(dev, "idProduct");
+		bConfValue = udev_device_get_sysattr_value(dev, "bConfigurationValue");
+		bNumIntfs = udev_device_get_sysattr_value(dev, "bNumInterfaces");
+		busid = udev_device_get_sysname(dev);
 		if (!idVendor || !idProduct || !bConfValue || !bNumIntfs) {
-			err("problem getting device attributes: %s",
+			err("Problem getting device attributes: %s",
 			    strerror(errno));
 			goto err_out;
 		}
 
-		/* get product name */
+		/* Get product name. */
 		usbip_names_get_product(product_name, sizeof(product_name),
-					strtol(idVendor->value, NULL, 16),
-					strtol(idProduct->value, NULL, 16));
-		print_device(dev->bus_id, idVendor->value, idProduct->value,
-			     parsable);
+					strtol(idVendor, NULL, 16),
+					strtol(idProduct, NULL, 16));
+
+		/* Print information. */
+		print_device(busid, idVendor, idProduct, parsable);
 		print_product_name(product_name, parsable);
 
-		for (i = 0; i < atoi(bNumIntfs->value); i++) {
-			snprintf(busid, sizeof(busid), "%s:%.1s.%d",
-				 dev->bus_id, bConfValue->value, i);
-			intf = sysfs_open_device(bus_type, busid);
-			if (!intf) {
-				err("could not open device interface: %s",
-				    strerror(errno));
-				goto err_out;
-			}
-			print_interface(busid, intf->driver_name, parsable);
-			sysfs_close_device(intf);
-		}
 		printf("\n");
-	}
 
-	ret = 0;
+		udev_device_unref(dev);
+	}
 
 err_out:
-	sysfs_close_bus(ubus);
+	udev_enumerate_unref(enumerate);
+	udev_unref(udev);
 
 	return ret;
 }
-- 
1.8.1.2

