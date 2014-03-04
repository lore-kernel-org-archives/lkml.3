Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbaCDTNH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:13:07 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:60356 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbaCDTLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:11:37 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 10/12] staging: usbip: userspace: migrate vhci_driver to libudev
Date: Tue,  4 Mar 2014 21:10:50 +0200
Message-Id: <1393960252-21247-11-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch migrates vhci_driver to libudev.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   1 -
 .../staging/usbip/userspace/libsrc/vhci_driver.c   | 154 ++++++---------------
 .../staging/usbip/userspace/libsrc/vhci_driver.h   |   5 +-
 3 files changed, 44 insertions(+), 116 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 9c11060..c4a72c3 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -5,7 +5,6 @@
 #ifndef __USBIP_COMMON_H
 #define __USBIP_COMMON_H
 
-#include <sysfs/libsysfs.h>
 #include <libudev.h>
 
 #include <stdint.h>
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
index 73a163aa..e7839a0 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
@@ -7,6 +7,7 @@
 #include <limits.h>
 #include <netdb.h>
 #include <libudev.h>
+#include "sysfs_utils.h"
 
 #undef  PROGNAME
 #define PROGNAME "libusbip"
@@ -36,7 +37,7 @@ err:
 
 
 
-static int parse_status(char *value)
+static int parse_status(const char *value)
 {
 	int ret = 0;
 	char *c;
@@ -108,42 +109,33 @@ static int parse_status(char *value)
 
 static int refresh_imported_device_list(void)
 {
-	struct sysfs_attribute *attr_status;
+	const char *attr_status;
 
-
-	attr_status = sysfs_get_device_attr(vhci_driver->hc_device, "status");
+	attr_status = udev_device_get_sysattr_value(vhci_driver->hc_device,
+					       "status");
 	if (!attr_status) {
-		dbg("sysfs_get_device_attr(\"status\") failed: %s",
-		    vhci_driver->hc_device->name);
+		dbg("udev_device_get_sysattr_value failed");
 		return -1;
 	}
 
-	dbg("name: %s  path: %s  len: %d  method: %d  value: %s",
-	    attr_status->name, attr_status->path, attr_status->len,
-	    attr_status->method, attr_status->value);
-
-	return parse_status(attr_status->value);
+	return parse_status(attr_status);
 }
 
 static int get_nports(void)
 {
 	char *c;
 	int nports = 0;
-	struct sysfs_attribute *attr_status;
+	const char *attr_status;
 
-	attr_status = sysfs_get_device_attr(vhci_driver->hc_device, "status");
+	attr_status = udev_device_get_sysattr_value(vhci_driver->hc_device,
+					       "status");
 	if (!attr_status) {
-		dbg("sysfs_get_device_attr(\"status\") failed: %s",
-		    vhci_driver->hc_device->name);
+		dbg("udev_device_get_sysattr_value failed");
 		return -1;
 	}
 
-	dbg("name: %s  path: %s  len: %d  method: %d  value: %s",
-	    attr_status->name, attr_status->path, attr_status->len,
-	    attr_status->method, attr_status->value);
-
 	/* skip a header line */
-	c = strchr(attr_status->value, '\n');
+	c = strchr(attr_status, '\n');
 	if (!c)
 		return 0;
 	c++;
@@ -160,50 +152,6 @@ static int get_nports(void)
 	return nports;
 }
 
-static int get_hc_busid(char *sysfs_mntpath, char *hc_busid)
-{
-	struct sysfs_driver *sdriver;
-	char sdriver_path[SYSFS_PATH_MAX];
-
-	struct sysfs_device *hc_dev;
-	struct dlist *hc_devs;
-
-	int found = 0;
-
-	snprintf(sdriver_path, SYSFS_PATH_MAX, "%s/%s/%s/%s/%s", sysfs_mntpath,
-	SYSFS_BUS_NAME, USBIP_VHCI_BUS_TYPE, SYSFS_DRIVERS_NAME,
-	USBIP_VHCI_DRV_NAME);
-
-	sdriver = sysfs_open_driver_path(sdriver_path);
-	if (!sdriver) {
-		dbg("sysfs_open_driver_path failed: %s", sdriver_path);
-		dbg("make sure " USBIP_CORE_MOD_NAME ".ko and "
-		    USBIP_VHCI_DRV_NAME ".ko are loaded!");
-		return -1;
-	}
-
-	hc_devs = sysfs_get_driver_devices(sdriver);
-	if (!hc_devs) {
-		dbg("sysfs_get_driver failed");
-		goto err;
-	}
-
-	/* assume only one vhci_hcd */
-	dlist_for_each_data(hc_devs, hc_dev, struct sysfs_device) {
-		strncpy(hc_busid, hc_dev->bus_id, SYSFS_BUS_ID_SIZE);
-		found = 1;
-	}
-
-err:
-	sysfs_close_driver(sdriver);
-
-	if (found)
-		return 0;
-
-	dbg("%s not found", hc_busid);
-	return -1;
-}
-
 /*
  * Read the given port's record.
  *
@@ -215,7 +163,6 @@ err:
  */
 static int read_record(int rhport, char *host, unsigned long host_len,
 		char *port, unsigned long port_len, char *busid)
-
 {
 	int part;
 	FILE *file;
@@ -272,36 +219,21 @@ static int read_record(int rhport, char *host, unsigned long host_len,
 
 int usbip_vhci_driver_open(void)
 {
-	int ret;
-	char hc_busid[SYSFS_BUS_ID_SIZE];
-
 	udev_context = udev_new();
 	if (!udev_context) {
 		dbg("udev_new failed");
 		return -1;
 	}
 
-	vhci_driver = (struct usbip_vhci_driver *) calloc(1, sizeof(*vhci_driver));
-	if (!vhci_driver) {
-		dbg("calloc failed");
-		return -1;
-	}
-
-	ret = sysfs_get_mnt_path(vhci_driver->sysfs_mntpath, SYSFS_PATH_MAX);
-	if (ret < 0) {
-		dbg("sysfs_get_mnt_path failed");
-		goto err;
-	}
-
-	ret = get_hc_busid(vhci_driver->sysfs_mntpath, hc_busid);
-	if (ret < 0)
-		goto err;
+	vhci_driver = calloc(1, sizeof(struct usbip_vhci_driver));
 
 	/* will be freed in usbip_driver_close() */
-	vhci_driver->hc_device = sysfs_open_device(USBIP_VHCI_BUS_TYPE,
-						   hc_busid);
+	vhci_driver->hc_device =
+		udev_device_new_from_subsystem_sysname(udev_context,
+						       USBIP_VHCI_BUS_TYPE,
+						       USBIP_VHCI_DRV_NAME);
 	if (!vhci_driver->hc_device) {
-		dbg("sysfs_open_device failed");
+		dbg("udev_device_new_from_subsystem_sysname");
 		goto err;
 	}
 
@@ -312,13 +244,11 @@ int usbip_vhci_driver_open(void)
 	if (refresh_imported_device_list())
 		goto err;
 
-
 	return 0;
 
-
 err:
-	if (vhci_driver->hc_device)
-		sysfs_close_device(vhci_driver->hc_device);
+	udev_device_unref(vhci_driver->hc_device);
+
 	if (vhci_driver)
 		free(vhci_driver);
 
@@ -335,8 +265,8 @@ void usbip_vhci_driver_close()
 	if (!vhci_driver)
 		return;
 
-	if (vhci_driver->hc_device)
-		sysfs_close_device(vhci_driver->hc_device);
+	udev_device_unref(vhci_driver->hc_device);
+
 	free(vhci_driver);
 
 	vhci_driver = NULL;
@@ -370,24 +300,24 @@ int usbip_vhci_get_free_port(void)
 
 int usbip_vhci_attach_device2(uint8_t port, int sockfd, uint32_t devid,
 		uint32_t speed) {
-	struct sysfs_attribute *attr_attach;
 	char buff[200]; /* what size should be ? */
+	char attach_attr_path[SYSFS_PATH_MAX];
+	char attr_attach[] = "attach";
+	const char *path;
 	int ret;
 
-	attr_attach = sysfs_get_device_attr(vhci_driver->hc_device, "attach");
-	if (!attr_attach) {
-		dbg("sysfs_get_device_attr(\"attach\") failed: %s",
-		    vhci_driver->hc_device->name);
-		return -1;
-	}
-
 	snprintf(buff, sizeof(buff), "%u %d %u %u",
 			port, sockfd, devid, speed);
 	dbg("writing: %s", buff);
 
-	ret = sysfs_write_attribute(attr_attach, buff, strlen(buff));
+	path = udev_device_get_syspath(vhci_driver->hc_device);
+	snprintf(attach_attr_path, sizeof(attach_attr_path), "%s/%s",
+		 path, attr_attach);
+	dbg("attach attribute path: %s", attach_attr_path);
+
+	ret = write_sysfs_attribute(attach_attr_path, buff, strlen(buff));
 	if (ret < 0) {
-		dbg("sysfs_write_attribute failed");
+		dbg("write_sysfs_attribute failed");
 		return -1;
 	}
 
@@ -412,23 +342,23 @@ int usbip_vhci_attach_device(uint8_t port, int sockfd, uint8_t busnum,
 
 int usbip_vhci_detach_device(uint8_t port)
 {
-	struct sysfs_attribute  *attr_detach;
+	char detach_attr_path[SYSFS_PATH_MAX];
+	char attr_detach[] = "detach";
 	char buff[200]; /* what size should be ? */
+	const char *path;
 	int ret;
 
-	attr_detach = sysfs_get_device_attr(vhci_driver->hc_device, "detach");
-	if (!attr_detach) {
-		dbg("sysfs_get_device_attr(\"detach\") failed: %s",
-		    vhci_driver->hc_device->name);
-		return -1;
-	}
-
 	snprintf(buff, sizeof(buff), "%u", port);
 	dbg("writing: %s", buff);
 
-	ret = sysfs_write_attribute(attr_detach, buff, strlen(buff));
+	path = udev_device_get_syspath(vhci_driver->hc_device);
+	snprintf(detach_attr_path, sizeof(detach_attr_path), "%s/%s",
+		 path, attr_detach);
+	dbg("detach attribute path: %s", detach_attr_path);
+
+	ret = write_sysfs_attribute(detach_attr_path, buff, strlen(buff));
 	if (ret < 0) {
-		dbg("sysfs_write_attribute failed");
+		dbg("write_sysfs_attribute failed");
 		return -1;
 	}
 
diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
index e72baa0..8a84fdf 100644
--- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
+++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.h
@@ -5,7 +5,7 @@
 #ifndef __VHCI_DRIVER_H
 #define __VHCI_DRIVER_H
 
-#include <sysfs/libsysfs.h>
+#include <libudev.h>
 #include <stdint.h>
 
 #include "usbip_common.h"
@@ -32,10 +32,9 @@ struct usbip_imported_device {
 };
 
 struct usbip_vhci_driver {
-	char sysfs_mntpath[SYSFS_PATH_MAX];
 
 	/* /sys/devices/platform/vhci_hcd */
-	struct sysfs_device *hc_device;
+	struct udev_device *hc_device;
 
 	int nports;
 	struct usbip_imported_device idev[MAXNPORT];
-- 
1.8.1.2

