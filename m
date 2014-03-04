Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbaCDTLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:11:39 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:49081 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbaCDTLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:11:33 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 08/12] staging: usbip: userspace: migrate usbip_host_driver to libudev
Date: Tue,  4 Mar 2014 21:10:48 +0200
Message-Id: <1393960252-21247-9-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies usbip_host_driver to use libudev.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 .../staging/usbip/userspace/libsrc/usbip_common.c  |  74 ++----
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   5 +-
 .../usbip/userspace/libsrc/usbip_host_driver.c     | 282 ++++++---------------
 .../usbip/userspace/libsrc/usbip_host_driver.h     |   7 +-
 .../staging/usbip/userspace/libsrc/vhci_driver.c   |  22 +-
 drivers/staging/usbip/userspace/src/usbipd.c       |  10 +-
 6 files changed, 138 insertions(+), 262 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
index 6620d18..8d675a9 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
@@ -2,6 +2,7 @@
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
 
+#include <libudev.h>
 #include "usbip_common.h"
 #include "names.h"
 
@@ -12,6 +13,8 @@ int usbip_use_syslog;
 int usbip_use_stderr;
 int usbip_use_debug;
 
+extern struct udev *udev_context;
+
 struct speed_string {
 	int num;
 	char *speed;
@@ -111,75 +114,48 @@ void dump_usb_device(struct usbip_usb_device *udev)
 }
 
 
-int read_attr_value(struct sysfs_device *dev, const char *name,
+int read_attr_value(struct udev_device *dev, const char *name,
 		    const char *format)
 {
-	char attrpath[SYSFS_PATH_MAX];
-	struct sysfs_attribute *attr;
+	const char *attr;
 	int num = 0;
 	int ret;
 
-	snprintf(attrpath, sizeof(attrpath), "%s/%s", dev->path, name);
-
-	attr = sysfs_open_attribute(attrpath);
+	attr = udev_device_get_sysattr_value(dev, name);
 	if (!attr) {
-		dbg("sysfs_open_attribute failed: %s", attrpath);
-		return 0;
-	}
-
-	ret = sysfs_read_attribute(attr);
-	if (ret < 0) {
-		dbg("sysfs_read_attribute failed");
+		dbg("udev_device_get_sysattr_value failed");
 		goto err;
 	}
 
-	ret = sscanf(attr->value, format, &num);
+	ret = sscanf(attr, format, &num);
 	if (ret < 1) {
 		dbg("sscanf failed");
 		goto err;
 	}
 
 err:
-	sysfs_close_attribute(attr);
 
 	return num;
 }
 
 
-int read_attr_speed(struct sysfs_device *dev)
+int read_attr_speed(struct udev_device *dev)
 {
-	char attrpath[SYSFS_PATH_MAX];
-	struct sysfs_attribute *attr;
-	char speed[100];
-	int ret;
+	const char *speed;
 
-	snprintf(attrpath, sizeof(attrpath), "%s/%s", dev->path, "speed");
-
-	attr = sysfs_open_attribute(attrpath);
-	if (!attr) {
-		dbg("sysfs_open_attribute failed: %s", attrpath);
-		return 0;
-	}
-
-	ret = sysfs_read_attribute(attr);
-	if (ret < 0) {
-		dbg("sysfs_read_attribute failed");
+	speed = udev_device_get_sysattr_value(dev, "speed");
+	if (!speed) {
+		dbg("udev_device_get_sysattr_value failed");
 		goto err;
 	}
 
-	ret = sscanf(attr->value, "%99s\n", speed);
-	if (ret < 1) {
-		dbg("sscanf failed");
-		goto err;
-	}
-err:
-	sysfs_close_attribute(attr);
-
 	for (int i = 0; speed_strings[i].speed != NULL; i++) {
 		if (!strcmp(speed, speed_strings[i].speed))
 			return speed_strings[i].num;
 	}
 
+err:
+
 	return USB_SPEED_UNKNOWN;
 }
 
@@ -190,9 +166,10 @@ err:
 	} while (0)
 
 
-int read_usb_device(struct sysfs_device *sdev, struct usbip_usb_device *udev)
+int read_usb_device(struct udev_device *sdev, struct usbip_usb_device *udev)
 {
 	uint32_t busnum, devnum;
+	const char *path, *name;
 
 	READ_ATTR(udev, uint8_t,  sdev, bDeviceClass,		"%02x\n");
 	READ_ATTR(udev, uint8_t,  sdev, bDeviceSubClass,	"%02x\n");
@@ -209,10 +186,13 @@ int read_usb_device(struct sysfs_device *sdev, struct usbip_usb_device *udev)
 	READ_ATTR(udev, uint8_t,  sdev, devnum,			"%d\n");
 	udev->speed = read_attr_speed(sdev);
 
-	strncpy(udev->path,  sdev->path,  SYSFS_PATH_MAX);
-	strncpy(udev->busid, sdev->name, SYSFS_BUS_ID_SIZE);
+	path = udev_device_get_syspath(sdev);
+	name = udev_device_get_sysname(sdev);
 
-	sscanf(sdev->name, "%u-%u", &busnum, &devnum);
+	strncpy(udev->path,  path,  SYSFS_PATH_MAX);
+	strncpy(udev->busid, name, SYSFS_BUS_ID_SIZE);
+
+	sscanf(name, "%u-%u", &busnum, &devnum);
 	udev->busnum = busnum;
 
 	return 0;
@@ -222,13 +202,13 @@ int read_usb_interface(struct usbip_usb_device *udev, int i,
 		       struct usbip_usb_interface *uinf)
 {
 	char busid[SYSFS_BUS_ID_SIZE];
-	struct sysfs_device *sif;
+	struct udev_device *sif;
 
 	sprintf(busid, "%s:%d.%d", udev->busid, udev->bConfigurationValue, i);
 
-	sif = sysfs_open_device("usb", busid);
+	sif = udev_device_new_from_subsystem_sysname(udev_context, "usb", busid);
 	if (!sif) {
-		dbg("sysfs_open_device(\"usb\", \"%s\") failed", busid);
+		dbg("udev_device_new_from_subsystem_sysname %s failed", busid);
 		return -1;
 	}
 
@@ -236,8 +216,6 @@ int read_usb_interface(struct usbip_usb_device *udev, int i,
 	READ_ATTR(uinf, uint8_t,  sif, bInterfaceSubClass,	"%02x\n");
 	READ_ATTR(uinf, uint8_t,  sif, bInterfaceProtocol,	"%02x\n");
 
-	sysfs_close_device(sif);
-
 	return 0;
 }
 
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 565ac78..9c11060 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -6,6 +6,7 @@
 #define __USBIP_COMMON_H
 
 #include <sysfs/libsysfs.h>
+#include <libudev.h>
 
 #include <stdint.h>
 #include <stdio.h>
@@ -134,8 +135,8 @@ struct usbip_usb_device {
 
 void dump_usb_interface(struct usbip_usb_interface *);
 void dump_usb_device(struct usbip_usb_device *);
-int read_usb_device(struct sysfs_device *sdev, struct usbip_usb_device *udev);
-int read_attr_value(struct sysfs_device *dev, const char *name,
+int read_usb_device(struct udev_device *sdev, struct usbip_usb_device *udev);
+int read_attr_value(struct udev_device *dev, const char *name,
 		    const char *format);
 int read_usb_interface(struct usbip_usb_device *udev, int i,
 		       struct usbip_usb_interface *uinf);
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
index 86a8675..3f34642 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
@@ -18,101 +18,64 @@
 
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <fcntl.h>
 
 #include <errno.h>
 #include <unistd.h>
 
+#include <libudev.h>
+
 #include "usbip_common.h"
 #include "usbip_host_driver.h"
+#include "list.h"
+#include "sysfs_utils.h"
 
 #undef  PROGNAME
 #define PROGNAME "libusbip"
 
 struct usbip_host_driver *host_driver;
-
-#define SYSFS_OPEN_RETRIES 100
+struct udev *udev_context;
 
 static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 {
-	char attrpath[SYSFS_PATH_MAX];
-	struct sysfs_attribute *attr;
+	char status_attr_path[SYSFS_PATH_MAX];
+	int fd;
+	int length;
+	char status;
 	int value = 0;
-	int rc;
-	struct stat s;
-	int retries = SYSFS_OPEN_RETRIES;
-
-	/* This access is racy!
-	 *
-	 * Just after detach, our driver removes the sysfs
-	 * files and recreates them.
-	 *
-	 * We may try and fail to open the usbip_status of
-	 * an exported device in the (short) window where
-	 * it has been removed and not yet recreated.
-	 *
-	 * This is a bug in the interface. Nothing we can do
-	 * except work around it here by polling for the sysfs
-	 * usbip_status to reappear.
-	 */
-
-	snprintf(attrpath, SYSFS_PATH_MAX, "%s/usbip_status",
-		 udev->path);
-
-	while (retries > 0) {
-		if (stat(attrpath, &s) == 0)
-			break;
-
-		if (errno != ENOENT) {
-			dbg("stat failed: %s", attrpath);
-			return -1;
-		}
 
-		usleep(10000); /* 10ms */
-		retries--;
-	}
-
-	if (retries == 0)
-		dbg("usbip_status not ready after %d retries",
-		    SYSFS_OPEN_RETRIES);
-	else if (retries < SYSFS_OPEN_RETRIES)
-		dbg("warning: usbip_status ready after %d retries",
-		    SYSFS_OPEN_RETRIES - retries);
+	snprintf(status_attr_path, SYSFS_PATH_MAX, "%s/usbip_status",
+		 udev->path);
 
-	attr = sysfs_open_attribute(attrpath);
-	if (!attr) {
-		dbg("sysfs_open_attribute failed: %s", attrpath);
+	if ((fd = open(status_attr_path, O_RDONLY)) < 0) {
+		dbg("Error opening attribute %s.", status_attr_path);
 		return -1;
 	}
 
-	rc = sysfs_read_attribute(attr);
-	if (rc) {
-		dbg("sysfs_read_attribute failed: %s", attrpath);
-		sysfs_close_attribute(attr);
+	length = read(fd, &status, 1);
+	if (length < 0) {
+		dbg("Error reading attribute %s.", status_attr_path);
+		close(fd);
 		return -1;
 	}
 
-	value = atoi(attr->value);
-
-	sysfs_close_attribute(attr);
+	value = atoi(&status);
 
 	return value;
 }
 
-static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
+static
+struct usbip_exported_device *usbip_exported_device_new(const char *sdevpath)
 {
 	struct usbip_exported_device *edev = NULL;
 	size_t size;
 	int i;
 
-	edev = calloc(1, sizeof(*edev));
-	if (!edev) {
-		dbg("calloc failed");
-		return NULL;
-	}
+	edev = calloc(1, sizeof(struct usbip_exported_device));
 
-	edev->sudev = sysfs_open_device_path(sdevpath);
+	edev->sudev = udev_device_new_from_syspath(udev_context, sdevpath);
 	if (!edev->sudev) {
-		dbg("sysfs_open_device_path failed: %s", sdevpath);
+		dbg("udev_device_new_from_syspath: %s", sdevpath);
 		goto err;
 	}
 
@@ -123,130 +86,80 @@ static struct usbip_exported_device *usbip_exported_device_new(char *sdevpath)
 		goto err;
 
 	/* reallocate buffer to include usb interface data */
-	size = sizeof(*edev) + edev->udev.bNumInterfaces *
+	size = sizeof(struct usbip_exported_device) + edev->udev.bNumInterfaces *
 		sizeof(struct usbip_usb_interface);
 
 	edev = realloc(edev, size);
-	if (!edev) {
-		dbg("realloc failed");
-		goto err;
-	}
 
 	for (i = 0; i < edev->udev.bNumInterfaces; i++)
 		read_usb_interface(&edev->udev, i, &edev->uinf[i]);
 
 	return edev;
 err:
-	if (edev && edev->sudev)
-		sysfs_close_device(edev->sudev);
+	if (edev->sudev)
+		udev_device_unref(edev->sudev);
 	if (edev)
 		free(edev);
 
 	return NULL;
 }
 
-static int check_new(struct dlist *dlist, struct sysfs_device *target)
-{
-	struct sysfs_device *dev;
-
-	dlist_for_each_data(dlist, dev, struct sysfs_device) {
-		if (!strncmp(dev->bus_id, target->bus_id, SYSFS_BUS_ID_SIZE))
-			/* device found and is not new */
-			return 0;
-	}
-	return 1;
-}
-
-static void delete_nothing(void *unused_data)
-{
-	/*
-	 * NOTE: Do not delete anything, but the container will be deleted.
-	 */
-	(void) unused_data;
-}
-
 static int refresh_exported_devices(void)
 {
-	/* sysfs_device of usb_device */
-	struct sysfs_device	*sudev;
-	struct dlist		*sudev_list;
-	struct dlist		*sudev_unique_list;
 	struct usbip_exported_device *edev;
-
-	sudev_unique_list = dlist_new_with_delete(sizeof(struct sysfs_device),
-						  delete_nothing);
-
-	sudev_list = sysfs_get_driver_devices(host_driver->sysfs_driver);
-
-	if (!sudev_list) {
-		/*
-		 * Not an error condition. There are simply no devices bound to
-		 * the driver yet.
-		 */
-		dbg("bind " USBIP_HOST_DRV_NAME ".ko to a usb device to be "
-		    "exportable!");
-		return 0;
-	}
-
-	dlist_for_each_data(sudev_list, sudev, struct sysfs_device)
-		if (check_new(sudev_unique_list, sudev))
-			dlist_unshift(sudev_unique_list, sudev);
-
-	dlist_for_each_data(sudev_unique_list, sudev, struct sysfs_device) {
-		edev = usbip_exported_device_new(sudev->path);
-
-		if (!edev) {
-			dbg("usbip_exported_device_new failed");
-			continue;
+	struct udev_enumerate *enumerate;
+	struct udev_list_entry *devices, *dev_list_entry;
+	struct udev_device *dev;
+	const char *path;
+
+	enumerate = udev_enumerate_new(udev_context);
+	udev_enumerate_add_match_subsystem(enumerate, "usb");
+	udev_enumerate_scan_devices(enumerate);
+
+	devices = udev_enumerate_get_list_entry(enumerate);
+
+	udev_list_entry_foreach(dev_list_entry, devices) {
+		path = udev_list_entry_get_name(dev_list_entry);
+		dev = udev_device_new_from_syspath(udev_context, path);
+
+		/* Check whether device uses usbip-host driver. */
+		if (!strcmp(udev_device_get_driver(dev),
+			    USBIP_HOST_DRV_NAME)) {
+			edev = usbip_exported_device_new(path);
+			if (!edev) {
+				dbg("usbip_exported_device_new failed");
+				continue;
+			}
+
+			list_add(&host_driver->edev_list, &edev->node);
+			host_driver->ndevs++;
 		}
-
-		dlist_unshift(host_driver->edev_list, edev);
-		host_driver->ndevs++;
 	}
 
-	dlist_destroy(sudev_unique_list);
-
 	return 0;
 }
 
-static struct sysfs_driver *open_sysfs_host_driver(void)
+static void usbip_exported_device_destroy(void)
 {
-	char bus_type[] = "usb";
-	char sysfs_mntpath[SYSFS_PATH_MAX];
-	char host_drv_path[SYSFS_PATH_MAX];
-	struct sysfs_driver *host_drv;
-	int rc;
-
-	rc = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
-	if (rc < 0) {
-		dbg("sysfs_get_mnt_path failed");
-		return NULL;
-	}
+	struct usbip_exported_device *edev, *edev_next;
 
-	snprintf(host_drv_path, SYSFS_PATH_MAX, "%s/%s/%s/%s/%s",
-		 sysfs_mntpath, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
-		 USBIP_HOST_DRV_NAME);
-
-	host_drv = sysfs_open_driver_path(host_drv_path);
-	if (!host_drv) {
-		dbg("sysfs_open_driver_path failed");
-		return NULL;
+	list_for_each_safe(&host_driver->edev_list, edev,
+			   edev_next, node) {
+		list_del(&edev->node);
+		free(edev);
 	}
-
-	return host_drv;
-}
-
-static void usbip_exported_device_delete(void *dev)
-{
-	struct usbip_exported_device *edev = dev;
-	sysfs_close_device(edev->sudev);
-	free(dev);
 }
 
 int usbip_host_driver_open(void)
 {
 	int rc;
 
+	udev_context = udev_new();
+	if (!udev_context) {
+		dbg("udev_new failed");
+		return -1;
+	}
+
 	host_driver = calloc(1, sizeof(*host_driver));
 	if (!host_driver) {
 		dbg("calloc failed");
@@ -254,32 +167,20 @@ int usbip_host_driver_open(void)
 	}
 
 	host_driver->ndevs = 0;
-	host_driver->edev_list =
-		dlist_new_with_delete(sizeof(struct usbip_exported_device),
-				      usbip_exported_device_delete);
-	if (!host_driver->edev_list) {
-		dbg("dlist_new_with_delete failed");
-		goto err_free_host_driver;
-	}
-
-	host_driver->sysfs_driver = open_sysfs_host_driver();
-	if (!host_driver->sysfs_driver)
-		goto err_destroy_edev_list;
+	list_head_init(&host_driver->edev_list);
 
 	rc = refresh_exported_devices();
 	if (rc < 0)
-		goto err_close_sysfs_driver;
+		goto err_free_host_driver;
 
 	return 0;
 
-err_close_sysfs_driver:
-	sysfs_close_driver(host_driver->sysfs_driver);
-err_destroy_edev_list:
-	dlist_destroy(host_driver->edev_list);
 err_free_host_driver:
 	free(host_driver);
 	host_driver = NULL;
 
+	udev_unref(udev_context);
+
 	return -1;
 }
 
@@ -288,30 +189,22 @@ void usbip_host_driver_close(void)
 	if (!host_driver)
 		return;
 
-	if (host_driver->edev_list)
-		dlist_destroy(host_driver->edev_list);
-	if (host_driver->sysfs_driver)
-		sysfs_close_driver(host_driver->sysfs_driver);
+	usbip_exported_device_destroy();
 
 	free(host_driver);
 	host_driver = NULL;
+
+	udev_unref(udev_context);
 }
 
 int usbip_host_refresh_device_list(void)
 {
 	int rc;
 
-	if (host_driver->edev_list)
-		dlist_destroy(host_driver->edev_list);
+	usbip_exported_device_destroy();
 
 	host_driver->ndevs = 0;
-	host_driver->edev_list =
-		dlist_new_with_delete(sizeof(struct usbip_exported_device),
-				      usbip_exported_device_delete);
-	if (!host_driver->edev_list) {
-		dbg("dlist_new_with_delete failed");
-		return -1;
-	}
+	list_head_init(&host_driver->edev_list);
 
 	rc = refresh_exported_devices();
 	if (rc < 0)
@@ -323,8 +216,7 @@ int usbip_host_refresh_device_list(void)
 int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd)
 {
 	char attr_name[] = "usbip_sockfd";
-	char attr_path[SYSFS_PATH_MAX];
-	struct sysfs_attribute *attr;
+	char sockfd_attr_path[SYSFS_PATH_MAX];
 	char sockfd_buff[30];
 	int ret;
 
@@ -344,40 +236,32 @@ int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd)
 	}
 
 	/* only the first interface is true */
-	snprintf(attr_path, sizeof(attr_path), "%s/%s",
+	snprintf(sockfd_attr_path, sizeof(sockfd_attr_path), "%s/%s",
 		 edev->udev.path, attr_name);
-
-	attr = sysfs_open_attribute(attr_path);
-	if (!attr) {
-		dbg("sysfs_open_attribute failed: %s", attr_path);
-		return -1;
-	}
+	dbg("usbip_sockfd attribute path: %s", sockfd_attr_path);
 
 	snprintf(sockfd_buff, sizeof(sockfd_buff), "%d\n", sockfd);
 	dbg("write: %s", sockfd_buff);
 
-	ret = sysfs_write_attribute(attr, sockfd_buff, strlen(sockfd_buff));
+	ret = write_sysfs_attribute(sockfd_attr_path, sockfd_buff,
+				    strlen(sockfd_buff));
 	if (ret < 0) {
-		dbg("sysfs_write_attribute failed: sockfd %s to %s",
-		    sockfd_buff, attr_path);
-		goto err_write_sockfd;
+		dbg("write_sysfs_attribute failed: sockfd %s to %s",
+		    sockfd_buff, sockfd_attr_path);
+		return ret;
 	}
 
 	dbg("connect: %s", edev->udev.busid);
 
-err_write_sockfd:
-	sysfs_close_attribute(attr);
-
 	return ret;
 }
 
 struct usbip_exported_device *usbip_host_get_device(int num)
 {
 	struct usbip_exported_device *edev;
-	struct dlist *dlist = host_driver->edev_list;
 	int cnt = 0;
 
-	dlist_for_each_data(dlist, edev, struct usbip_exported_device) {
+	list_for_each(&host_driver->edev_list, edev, node) {
 		if (num == cnt)
 			return edev;
 		else
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
index 34fd14c..8d5ffe3 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.h
@@ -21,18 +21,19 @@
 
 #include <stdint.h>
 #include "usbip_common.h"
+#include "list.h"
 
 struct usbip_host_driver {
 	int ndevs;
-	struct sysfs_driver *sysfs_driver;
 	/* list of exported device */
-	struct dlist *edev_list;
+	struct list_head edev_list;
 };
 
 struct usbip_exported_device {
-	struct sysfs_device *sudev;
+	struct udev_device *sudev;
 	int32_t status;
 	struct usbip_usb_device udev;
+	struct list_node node;
 	struct usbip_usb_interface uinf[];
 };
 
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index d80d37c..d5839a5 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -6,24 +6,27 @@
 #include "vhci_driver.h"
 #include <limits.h>
 #include <netdb.h>
+#include <libudev.h>
 
 #undef  PROGNAME
 #define PROGNAME "libusbip"
 
 struct usbip_vhci_driver *vhci_driver;
+struct udev *udev_context;
 
 static struct usbip_imported_device *
 imported_device_init(struct usbip_imported_device *idev, char *busid)
 {
-	struct sysfs_device *sudev;
+	struct udev_device *sudev;
 
-	sudev = sysfs_open_device("usb", busid);
+	sudev = udev_device_new_from_subsystem_sysname(udev_context,
+						       "usb", busid);
 	if (!sudev) {
-		dbg("sysfs_open_device failed: %s", busid);
+		dbg("udev_device_new_from_subsystem_sysname failed: %s", busid);
 		goto err;
 	}
 	read_usb_device(sudev, &idev->udev);
-	sysfs_close_device(sudev);
+	udev_device_unref(sudev);
 
 	/* add class devices of this imported device */
 	struct usbip_class_device *cdev;
@@ -410,6 +413,12 @@ int usbip_vhci_driver_open(void)
 	int ret;
 	char hc_busid[SYSFS_BUS_ID_SIZE];
 
+	udev_context = udev_new();
+	if (!udev_context) {
+		dbg("udev_new failed");
+		return -1;
+	}
+
 	vhci_driver = (struct usbip_vhci_driver *) calloc(1, sizeof(*vhci_driver));
 	if (!vhci_driver) {
 		dbg("calloc failed");
@@ -461,6 +470,9 @@ err:
 		free(vhci_driver);
 
 	vhci_driver = NULL;
+
+	udev_unref(udev_context);
+
 	return -1;
 }
 
@@ -483,6 +495,8 @@ void usbip_vhci_driver_close()
 	free(vhci_driver);
 
 	vhci_driver = NULL;
+
+	udev_unref(udev_context);
 }
 
 
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index b2230f7..9d9360e 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -43,6 +43,7 @@
 #include "usbip_host_driver.h"
 #include "usbip_common.h"
 #include "usbip_network.h"
+#include "list.h"
 
 #undef  PROGNAME
 #define PROGNAME "usbipd"
@@ -107,8 +108,7 @@ static int recv_request_import(int sockfd)
 	}
 	PACK_OP_IMPORT_REQUEST(0, &req);
 
-	dlist_for_each_data(host_driver->edev_list, edev,
-			    struct usbip_exported_device) {
+	list_for_each(&host_driver->edev_list, edev, node) {
 		if (!strncmp(req.busid, edev->udev.busid, SYSFS_BUS_ID_SIZE)) {
 			info("found requested device: %s", req.busid);
 			found = 1;
@@ -165,8 +165,7 @@ static int send_reply_devlist(int connfd)
 
 	reply.ndev = 0;
 	/* number of exported devices */
-	dlist_for_each_data(host_driver->edev_list, edev,
-			    struct usbip_exported_device) {
+	list_for_each(&host_driver->edev_list, edev, node) {
 		reply.ndev += 1;
 	}
 	info("exportable devices: %d", reply.ndev);
@@ -184,8 +183,7 @@ static int send_reply_devlist(int connfd)
 		return -1;
 	}
 
-	dlist_for_each_data(host_driver->edev_list, edev,
-			    struct usbip_exported_device) {
+	list_for_each(&host_driver->edev_list, edev, node) {
 		dump_usb_device(&edev->udev);
 		memcpy(&pdu_udev, &edev->udev, sizeof(pdu_udev));
 		usbip_net_pack_usb_device(1, &pdu_udev);
-- 
1.8.1.2

