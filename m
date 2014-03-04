Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbaCDTLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:11:41 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:58657 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbaCDTLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:11:35 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 09/12] staging: usbip: userspace: remove class device infrastructure in vhci_driver
Date: Tue,  4 Mar 2014 21:10:49 +0200
Message-Id: <1393960252-21247-10-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The class device lists were used only when being initialized,
being populated and being destroyed. They had no real meaning
and thus the code was useless.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 .../staging/usbip/userspace/libsrc/vhci_driver.c   | 178 ---------------------
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   4 -
 2 files changed, 182 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index d5839a5..73a163aa 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -28,26 +28,6 @@ imported_device_init(struct usbip_imported_device *idev, char *busid)
 	read_usb_device(sudev, &idev->udev);
 	udev_device_unref(sudev);
 
-	/* add class devices of this imported device */
-	struct usbip_class_device *cdev;
-	dlist_for_each_data(vhci_driver->cdev_list, cdev,
-			    struct usbip_class_device) {
-		if (!strncmp(cdev->dev_path, idev->udev.path,
-			     strlen(idev->udev.path))) {
-			struct usbip_class_device *new_cdev;
-			/*
-			 * alloc and copy because dlist is linked
-			 * from only one list
-			 */
-			new_cdev = calloc(1, sizeof(*new_cdev));
-			if (!new_cdev)
-				goto err;
-
-			memcpy(new_cdev, cdev, sizeof(*new_cdev));
-			dlist_unshift(idev->cdev_list, (void *) new_cdev);
-		}
-	}
-
 	return idev;
 
 err:
@@ -103,12 +83,6 @@ static int parse_status(char *value)
 			idev->busnum	= (devid >> 16);
 			idev->devnum	= (devid & 0x0000ffff);
 
-			idev->cdev_list = dlist_new(sizeof(struct usbip_class_device));
-			if (!idev->cdev_list) {
-				dbg("dlist_new failed");
-				return -1;
-			}
-
 			if (idev->status != VDEV_ST_NULL
 			    && idev->status != VDEV_ST_NOTASSIGNED) {
 				idev = imported_device_init(idev, lbusid);
@@ -132,118 +106,6 @@ static int parse_status(char *value)
 	return 0;
 }
 
-
-static int check_usbip_device(struct sysfs_class_device *cdev)
-{
-	/* /sys/class/video4linux/video0/device */
-	char class_path[SYSFS_PATH_MAX];
-	/* /sys/devices/platform/vhci_hcd/usb6/6-1:1.1 */
-	char dev_path[SYSFS_PATH_MAX];
-	int ret;
-	struct usbip_class_device *usbip_cdev;
-
-	snprintf(class_path, sizeof(class_path), "%s/device", cdev->path);
-
-	ret = sysfs_get_link(class_path, dev_path, sizeof(dev_path));
-	if (ret == 0) {
-		if (!strncmp(dev_path, vhci_driver->hc_device->path,
-			     strlen(vhci_driver->hc_device->path))) {
-			/* found usbip device */
-			usbip_cdev = calloc(1, sizeof(*usbip_cdev));
-			if (!usbip_cdev) {
-				dbg("calloc failed");
-				return -1;
-			}
-			dlist_unshift(vhci_driver->cdev_list, usbip_cdev);
-			strncpy(usbip_cdev->class_path, class_path,
-				sizeof(usbip_cdev->class_path));
-			strncpy(usbip_cdev->dev_path, dev_path,
-				sizeof(usbip_cdev->dev_path));
-			dbg("found: %s %s", class_path, dev_path);
-		}
-	}
-
-	return 0;
-}
-
-
-static int search_class_for_usbip_device(char *cname)
-{
-	struct sysfs_class *class;
-	struct dlist *cdev_list;
-	struct sysfs_class_device *cdev;
-	int ret = 0;
-
-	class = sysfs_open_class(cname);
-	if (!class) {
-		dbg("sysfs_open_class failed");
-		return -1;
-	}
-
-	dbg("class: %s", class->name);
-
-	cdev_list = sysfs_get_class_devices(class);
-	if (!cdev_list)
-		/* nothing */
-		goto out;
-
-	dlist_for_each_data(cdev_list, cdev, struct sysfs_class_device) {
-		dbg("cdev: %s", cdev->name);
-		ret = check_usbip_device(cdev);
-		if (ret < 0)
-			goto out;
-	}
-
-out:
-	sysfs_close_class(class);
-
-	return ret;
-}
-
-
-static int refresh_class_device_list(void)
-{
-	int ret;
-	struct dlist *cname_list;
-	char *cname;
-	char sysfs_mntpath[SYSFS_PATH_MAX];
-	char class_path[SYSFS_PATH_MAX];
-
-	ret = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
-	if (ret < 0) {
-		dbg("sysfs_get_mnt_path failed");
-		return -1;
-	}
-
-	snprintf(class_path, sizeof(class_path), "%s/%s", sysfs_mntpath,
-		 SYSFS_CLASS_NAME);
-
-	/* search under /sys/class */
-	cname_list = sysfs_open_directory_list(class_path);
-	if (!cname_list) {
-		dbg("sysfs_open_directory failed");
-		return -1;
-	}
-
-	dlist_for_each_data(cname_list, cname, char) {
-		ret = search_class_for_usbip_device(cname);
-		if (ret < 0) {
-			sysfs_close_list(cname_list);
-			return -1;
-		}
-	}
-
-	sysfs_close_list(cname_list);
-
-	/* search under /sys/block */
-	ret = search_class_for_usbip_device(SYSFS_BLOCK_NAME);
-	if (ret < 0)
-		return -1;
-
-	return 0;
-}
-
-
 static int refresh_imported_device_list(void)
 {
 	struct sysfs_attribute *attr_status;
@@ -447,13 +309,6 @@ int usbip_vhci_driver_open(void)
 
 	dbg("available ports: %d", vhci_driver->nports);
 
-	vhci_driver->cdev_list = dlist_new(sizeof(struct usbip_class_device));
-	if (!vhci_driver->cdev_list)
-		goto err;
-
-	if (refresh_class_device_list())
-		goto err;
-
 	if (refresh_imported_device_list())
 		goto err;
 
@@ -462,8 +317,6 @@ int usbip_vhci_driver_open(void)
 
 
 err:
-	if (vhci_driver->cdev_list)
-		dlist_destroy(vhci_driver->cdev_list);
 	if (vhci_driver->hc_device)
 		sysfs_close_device(vhci_driver->hc_device);
 	if (vhci_driver)
@@ -482,14 +335,6 @@ void usbip_vhci_driver_close()
 	if (!vhci_driver)
 		return;
 
-	if (vhci_driver->cdev_list)
-		dlist_destroy(vhci_driver->cdev_list);
-
-	for (int i = 0; i < vhci_driver->nports; i++) {
-		if (vhci_driver->idev[i].cdev_list)
-			dlist_destroy(vhci_driver->idev[i].cdev_list);
-	}
-
 	if (vhci_driver->hc_device)
 		sysfs_close_device(vhci_driver->hc_device);
 	free(vhci_driver);
@@ -502,35 +347,12 @@ void usbip_vhci_driver_close()
 
 int usbip_vhci_refresh_device_list(void)
 {
-	if (vhci_driver->cdev_list)
-		dlist_destroy(vhci_driver->cdev_list);
-
-
-	for (int i = 0; i < vhci_driver->nports; i++) {
-		if (vhci_driver->idev[i].cdev_list)
-			dlist_destroy(vhci_driver->idev[i].cdev_list);
-	}
-
-	vhci_driver->cdev_list = dlist_new(sizeof(struct usbip_class_device));
-	if (!vhci_driver->cdev_list)
-		goto err;
-
-	if (refresh_class_device_list())
-		goto err;
 
 	if (refresh_imported_device_list())
 		goto err;
 
 	return 0;
 err:
-	if (vhci_driver->cdev_list)
-		dlist_destroy(vhci_driver->cdev_list);
-
-	for (int i = 0; i < vhci_driver->nports; i++) {
-		if (vhci_driver->idev[i].cdev_list)
-			dlist_destroy(vhci_driver->idev[i].cdev_list);
-	}
-
 	dbg("failed to refresh device list");
 	return -1;
 }
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
index e071f80..e72baa0 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
@@ -28,7 +28,6 @@ struct usbip_imported_device {
 	uint8_t devnum;
 
 	/* usbip_class_device list */
-	struct dlist *cdev_list;
 	struct usbip_usb_device udev;
 };
 
@@ -38,9 +37,6 @@ struct usbip_vhci_driver {
 	/* /sys/devices/platform/vhci_hcd */
 	struct sysfs_device *hc_device;
 
-	/* usbip_class_device list */
-	struct dlist *cdev_list;
-
 	int nports;
 	struct usbip_imported_device idev[MAXNPORT];
 };
-- 
1.8.1.2

