Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaCDTLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:11:23 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:40934 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332AbaCDTLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:11:17 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 01/12] staging: usbip: userspace: migrate usbip_bind to libudev
Date: Tue,  4 Mar 2014 21:10:41 +0200
Message-Id: <1393960252-21247-2-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds autoconf check for libudev and migrates
usbip_bind to the new library.

libsysfs will still be used until all userspace is modified.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/configure.ac       |   6 +
 .../staging/usbip/userspace/libsrc/usbip_common.h  |   9 ++
 drivers/staging/usbip/userspace/src/Makefile.am    |   3 +-
 drivers/staging/usbip/userspace/src/sysfs_utils.c  |  36 +++++
 drivers/staging/usbip/userspace/src/sysfs_utils.h  |   8 ++
 drivers/staging/usbip/userspace/src/usbip_bind.c   | 149 +++++++++------------
 drivers/staging/usbip/userspace/src/utils.c        |  51 +++----
 7 files changed, 136 insertions(+), 126 deletions(-)
 create mode 100644 drivers/staging/usbip/userspace/src/sysfs_utils.c
 create mode 100644 drivers/staging/usbip/userspace/src/sysfs_utils.h

diff --git a/drivers/staging/usbip/userspace/configure.ac b/drivers/staging/usbip/userspace/configure.ac
index 0ee5d92..a5193c6 100644
--- a/drivers/staging/usbip/userspace/configure.ac
+++ b/drivers/staging/usbip/userspace/configure.ac
@@ -50,6 +50,12 @@ AC_CHECK_HEADER([sysfs/libsysfs.h],
 			      [AC_MSG_ERROR([Missing sysfs2 library!])])],
 		[AC_MSG_ERROR([Missing /usr/include/sysfs/libsysfs.h])])
 
+AC_CHECK_HEADER([libudev.h],
+		[AC_CHECK_LIB([udev], [udev_new],
+			      [LIBS="$LIBS -ludev"],
+			      [AC_MSG_ERROR([Missing udev library!])])],
+		[AC_MSG_ERROR([Missing /usr/include/libudev.h])])
+
 # Checks for libwrap library.
 AC_MSG_CHECKING([whether to use the libwrap (TCP wrappers) library])
 AC_ARG_WITH([tcp-wrappers],
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.h b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
index 2cb81b3..565ac78 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_common.h
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.h
@@ -29,6 +29,15 @@
 #define USBIP_HOST_DRV_NAME	"usbip-host"
 #define USBIP_VHCI_DRV_NAME	"vhci_hcd"
 
+/* sysfs constants */
+#define SYSFS_MNT_PATH         "/sys"
+#define SYSFS_BUS_NAME         "bus"
+#define SYSFS_BUS_TYPE         "usb"
+#define SYSFS_DRIVERS_NAME     "drivers"
+
+#define SYSFS_PATH_MAX		256
+#define SYSFS_BUS_ID_SIZE	32
+
 extern int usbip_use_syslog;
 extern int usbip_use_stderr;
 extern int usbip_use_debug ;
diff --git a/drivers/staging/usbip/userspace/src/Makefile.am b/drivers/staging/usbip/userspace/src/Makefile.am
index b4f8c4b..6c91bcb 100644
--- a/drivers/staging/usbip/userspace/src/Makefile.am
+++ b/drivers/staging/usbip/userspace/src/Makefile.am
@@ -6,7 +6,8 @@ sbin_PROGRAMS := usbip usbipd
 
 usbip_SOURCES := usbip.h utils.h usbip.c utils.c usbip_network.c \
 		 usbip_attach.c usbip_detach.c usbip_list.c \
-		 usbip_bind.c usbip_unbind.c usbip_port.c
+		 usbip_bind.c usbip_unbind.c usbip_port.c \
+		 sysfs_utils.c
 
 
 usbipd_SOURCES := usbip_network.h usbipd.c usbip_network.c
diff --git a/drivers/staging/usbip/userspace/src/sysfs_utils.c b/drivers/staging/usbip/userspace/src/sysfs_utils.c
new file mode 100644
index 0000000..2c362d1
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/sysfs_utils.c
@@ -0,0 +1,36 @@
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include "sysfs_utils.h"
+#include "usbip_common.h"
+
+int write_sysfs_attribute(const char *attr_path, const char *new_value,
+			  size_t len)
+{
+	int fd;
+	int length;
+
+	if (attr_path == NULL || new_value == NULL || len == 0) {
+		dbg("Invalid values provided for attribute %s.", attr_path);
+		errno = EINVAL;
+		return -1;
+	}
+
+	if ((fd = open(attr_path, O_WRONLY)) < 0) {
+		dbg("Error opening attribute %s.", attr_path);
+		return -1;
+	}
+
+	length = write(fd, new_value, len);
+	if (length < 0) {
+		dbg("Error writing to attribute %s.", attr_path);
+		close(fd);
+		return -1;
+	}
+
+	close(fd);
+
+	return 0;
+}
diff --git a/drivers/staging/usbip/userspace/src/sysfs_utils.h b/drivers/staging/usbip/userspace/src/sysfs_utils.h
new file mode 100644
index 0000000..32ac1d1
--- /dev/null
+++ b/drivers/staging/usbip/userspace/src/sysfs_utils.h
@@ -0,0 +1,8 @@
+
+#ifndef __SYSFS_UTILS_H
+#define __SYSFS_UTILS_H
+
+int write_sysfs_attribute(const char *attr_path, const char *new_value,
+			  size_t len);
+
+#endif
diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/drivers/staging/usbip/userspace/src/usbip_bind.c
index 8cfd2db..d122089 100644
--- a/drivers/staging/usbip/userspace/src/usbip_bind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_bind.c
@@ -16,7 +16,7 @@
  * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <sysfs/libsysfs.h>
+#include <libudev.h>
 
 #include <errno.h>
 #include <stdio.h>
@@ -28,6 +28,7 @@
 #include "usbip_common.h"
 #include "utils.h"
 #include "usbip.h"
+#include "sysfs_utils.h"
 
 enum unbind_status {
 	UNBIND_ST_OK,
@@ -48,135 +49,94 @@ void usbip_bind_usage(void)
 /* call at unbound state */
 static int bind_usbip(char *busid)
 {
-	char bus_type[] = "usb";
 	char attr_name[] = "bind";
-	char sysfs_mntpath[SYSFS_PATH_MAX];
 	char bind_attr_path[SYSFS_PATH_MAX];
-	struct sysfs_attribute *bind_attr;
-	int failed = 0;
-	int rc, ret = -1;
-
-	rc = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
-	if (rc < 0) {
-		err("sysfs must be mounted: %s", strerror(errno));
-		return -1;
-	}
+	int rc = -1;
 
 	snprintf(bind_attr_path, sizeof(bind_attr_path), "%s/%s/%s/%s/%s/%s",
-		 sysfs_mntpath, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
-		 USBIP_HOST_DRV_NAME, attr_name);
+		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, SYSFS_BUS_TYPE,
+		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME, attr_name);
+	dbg("bind attribute path: %s", bind_attr_path);
 
-	bind_attr = sysfs_open_attribute(bind_attr_path);
-	if (!bind_attr) {
-		dbg("problem getting bind attribute: %s", strerror(errno));
-		return -1;
-	}
-
-	rc = sysfs_write_attribute(bind_attr, busid, SYSFS_BUS_ID_SIZE);
+	rc = write_sysfs_attribute(bind_attr_path, busid, strlen(busid));
 	if (rc < 0) {
-		dbg("bind driver at %s failed", busid);
-		failed = 1;
+		dbg("Error binding device %s to driver: %s", busid,
+		    strerror(errno));
+		return -1;
 	}
 
-	if (!failed)
-		ret = 0;
-
-	sysfs_close_attribute(bind_attr);
-
-	return ret;
+	return 0;
 }
 
 /* buggy driver may cause dead lock */
 static int unbind_other(char *busid)
 {
-	char bus_type[] = "usb";
-	struct sysfs_device *busid_dev;
-	struct sysfs_device *dev;
-	struct sysfs_driver *drv;
-	struct sysfs_attribute *unbind_attr;
-	struct sysfs_attribute *bDevClass;
-	int rc;
 	enum unbind_status status = UNBIND_ST_OK;
 
-	busid_dev = sysfs_open_device(bus_type, busid);
-	if (!busid_dev) {
-		dbg("sysfs_open_device %s failed: %s", busid, strerror(errno));
-		return -1;
-	}
-	dbg("busid path: %s", busid_dev->path);
+	char attr_name[] = "unbind";
+	char unbind_attr_path[SYSFS_PATH_MAX];
+	int rc = -1;
 
-	bDevClass  = sysfs_get_device_attr(busid_dev, "bDeviceClass");
-	if (!bDevClass) {
-		dbg("problem getting device attribute: %s",
-		    strerror(errno));
+	struct udev *udev;
+	struct udev_device *dev;
+	const char *driver;
+	const char *bDevClass;
+
+	/* Create libudev context. */
+	udev = udev_new();
+
+	/* Get the device. */
+	dev = udev_device_new_from_subsystem_sysname(udev, "usb", busid);
+	if (!dev) {
+		dbg("Unable to find device with bus ID %s.", busid);
 		goto err_close_busid_dev;
 	}
 
-	if (!strncmp(bDevClass->value, "09", bDevClass->len)) {
-		dbg("skip unbinding of hub");
+	/* Check what kind of device it is. */
+	bDevClass  = udev_device_get_sysattr_value(dev, "bDeviceClass");
+	if (!bDevClass) {
+		dbg("Unable to get bDevClass device attribute.");
 		goto err_close_busid_dev;
 	}
 
-	dev = sysfs_open_device(bus_type, busid);
-	if (!dev) {
-		dbg("could not open device: %s",
-				strerror(errno));
+	if (!strncmp(bDevClass, "09", strlen(bDevClass))) {
+		dbg("Skip unbinding of hub.");
 		goto err_close_busid_dev;
 	}
 
-	dbg("%s -> %s", dev->name,  dev->driver_name);
-
-	if (!strncmp("unknown", dev->driver_name, SYSFS_NAME_LEN)) {
-		/* unbound interface */
-		sysfs_close_device(dev);
+	/* Get the device driver. */
+	driver = udev_device_get_driver(dev);
+	if (!driver) {
+		/* No driver bound to this device. */
 		goto out;
 	}
 
-	if (!strncmp(USBIP_HOST_DRV_NAME, dev->driver_name,
-				SYSFS_NAME_LEN)) {
-		/* already bound to usbip-host */
+	if (!strncmp(USBIP_HOST_DRV_NAME, driver,
+				strlen(USBIP_HOST_DRV_NAME))) {
+		/* Already bound to usbip-host. */
 		status = UNBIND_ST_USBIP_HOST;
-		sysfs_close_device(dev);
 		goto out;
 	}
 
-	/* unbinding */
-	drv = sysfs_open_driver(bus_type, dev->driver_name);
-	if (!drv) {
-		dbg("could not open device driver on %s: %s",
-				dev->name, strerror(errno));
-		goto err_close_intf_dev;
-	}
-	dbg("device driver: %s", drv->path);
-
-	unbind_attr = sysfs_get_driver_attr(drv, "unbind");
-	if (!unbind_attr) {
-		dbg("problem getting device driver attribute: %s",
-				strerror(errno));
-		goto err_close_intf_drv;
-	}
+	/* Unbind device from driver. */
+	snprintf(unbind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
+		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, SYSFS_BUS_TYPE,
+		 SYSFS_DRIVERS_NAME, driver, attr_name);
+	dbg("unbind attribute path: %s", unbind_attr_path);
 
-	rc = sysfs_write_attribute(unbind_attr, dev->bus_id,
-			SYSFS_BUS_ID_SIZE);
+	rc = write_sysfs_attribute(unbind_attr_path, busid, strlen(busid));
 	if (rc < 0) {
-		/* NOTE: why keep unbinding other interfaces? */
-		dbg("unbind driver at %s failed", dev->bus_id);
-		status = UNBIND_ST_FAILED;
+		dbg("Error unbinding device %s from driver.", busid);
+		goto err_close_busid_dev;
 	}
 
-	sysfs_close_driver(drv);
-	sysfs_close_device(dev);
-
 	goto out;
 
-err_close_intf_drv:
-	sysfs_close_driver(drv);
-err_close_intf_dev:
-	sysfs_close_device(dev);
 err_close_busid_dev:
 	status = UNBIND_ST_FAILED;
 out:
-	sysfs_close_device(busid_dev);
+	udev_device_unref(dev);
+	udev_unref(udev);
 
 	return status;
 }
@@ -184,6 +144,17 @@ out:
 static int bind_device(char *busid)
 {
 	int rc;
+	struct udev *udev;
+	struct udev_device *dev;
+
+	/* Check whether the device with this bus ID exists. */
+	udev = udev_new();
+	dev = udev_device_new_from_subsystem_sysname(udev, "usb", busid);
+	if (!dev) {
+		err("Device with the specified bus ID does not exist.");
+		return -1;
+	}
+	udev_unref(udev);
 
 	rc = unbind_other(busid);
 	if (rc == UNBIND_ST_FAILED) {
diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
index 2d4966e..c75acac 100644
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -16,61 +16,40 @@
  * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <sysfs/libsysfs.h>
-
 #include <errno.h>
 #include <stdio.h>
 #include <string.h>
 
 #include "usbip_common.h"
 #include "utils.h"
+#include "sysfs_utils.h"
 
 int modify_match_busid(char *busid, int add)
 {
-	char bus_type[] = "usb";
 	char attr_name[] = "match_busid";
-	char buff[SYSFS_BUS_ID_SIZE + 4];
-	char sysfs_mntpath[SYSFS_PATH_MAX];
+	char command[SYSFS_BUS_ID_SIZE + 4];
 	char match_busid_attr_path[SYSFS_PATH_MAX];
-	struct sysfs_attribute *match_busid_attr;
-	int rc, ret = 0;
-
-	if (strnlen(busid, SYSFS_BUS_ID_SIZE) > SYSFS_BUS_ID_SIZE - 1) {
-		dbg("busid is too long");
-		return -1;
-	}
-
-	rc = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
-	if (rc < 0) {
-		err("sysfs must be mounted: %s", strerror(errno));
-		return -1;
-	}
+	int rc;
 
 	snprintf(match_busid_attr_path, sizeof(match_busid_attr_path),
-		 "%s/%s/%s/%s/%s/%s", sysfs_mntpath, SYSFS_BUS_NAME, bus_type,
-		 SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME, attr_name);
-
-	match_busid_attr = sysfs_open_attribute(match_busid_attr_path);
-	if (!match_busid_attr) {
-		dbg("problem getting match_busid attribute: %s",
-		    strerror(errno));
-		return -1;
-	}
+		 "%s/%s/%s/%s/%s/%s", SYSFS_MNT_PATH, SYSFS_BUS_NAME,
+		 SYSFS_BUS_TYPE, SYSFS_DRIVERS_NAME, USBIP_HOST_DRV_NAME,
+		 attr_name);
+	dbg("match_busid attribute path: %s", match_busid_attr_path);
 
 	if (add)
-		snprintf(buff, SYSFS_BUS_ID_SIZE + 4, "add %s", busid);
+		snprintf(command, SYSFS_BUS_ID_SIZE + 4, "add %s", busid);
 	else
-		snprintf(buff, SYSFS_BUS_ID_SIZE + 4, "del %s", busid);
+		snprintf(command, SYSFS_BUS_ID_SIZE + 4, "del %s", busid);
 
-	dbg("write \"%s\" to %s", buff, match_busid_attr->path);
+	dbg("write \"%s\" to %s", command, match_busid_attr_path);
 
-	rc = sysfs_write_attribute(match_busid_attr, buff, sizeof(buff));
+	rc = write_sysfs_attribute(match_busid_attr_path, command,
+				   sizeof(command));
 	if (rc < 0) {
-		dbg("failed to write match_busid: %s", strerror(errno));
-		ret = -1;
+		dbg("Failed to write match_busid: %s", strerror(errno));
+		return -1;
 	}
 
-	sysfs_close_attribute(match_busid_attr);
-
-	return ret;
+	return 0;
 }
-- 
1.8.1.2

