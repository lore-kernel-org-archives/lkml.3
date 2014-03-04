Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaCDTOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:14:46 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:63135 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbaCDTLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:11:21 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tobias.polzer@fau.de, dominik.paulus@fau.de, ly80toro@cip.cs.fau.de,
        shuah.kh@samsung.com, ihadzic@research.bell-labs.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 03/12] staging: usbip: userspace: migrate usbip_unbind to libudev
Date: Tue,  4 Mar 2014 21:10:43 +0200
Message-Id: <1393960252-21247-4-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
References: <1393960252-21247-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies usbip_unbind to use libudev.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/userspace/src/usbip_unbind.c | 92 +++++++---------------
 1 file changed, 29 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_unbind.c b/drivers/staging/usbip/userspace/src/usbip_unbind.c
index cace878..4776068 100644
--- a/drivers/staging/usbip/userspace/src/usbip_unbind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_unbind.c
@@ -16,7 +16,7 @@
  * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
-#include <sysfs/libsysfs.h>
+#include <libudev.h>
 
 #include <errno.h>
 #include <stdio.h>
@@ -27,6 +27,7 @@
 #include "usbip_common.h"
 #include "utils.h"
 #include "usbip.h"
+#include "sysfs_utils.h"
 
 static const char usbip_unbind_usage_string[] =
 	"usbip unbind <args>\n"
@@ -41,92 +42,57 @@ void usbip_unbind_usage(void)
 static int unbind_device(char *busid)
 {
 	char bus_type[] = "usb";
-	struct sysfs_driver *usbip_host_drv;
-	struct sysfs_device *dev;
-	struct dlist *devlist;
-	int verified = 0;
 	int rc, ret = -1;
 
 	char attr_name[] = "unbind";
-	char sysfs_mntpath[SYSFS_PATH_MAX];
 	char unbind_attr_path[SYSFS_PATH_MAX];
-	struct sysfs_attribute *unbind_attr;
-
-	/* verify the busid device is using usbip-host */
-	usbip_host_drv = sysfs_open_driver(bus_type, USBIP_HOST_DRV_NAME);
-	if (!usbip_host_drv) {
-		err("could not open %s driver: %s", USBIP_HOST_DRV_NAME,
-		    strerror(errno));
-		return -1;
-	}
 
-	devlist = sysfs_get_driver_devices(usbip_host_drv);
-	if (!devlist) {
-		err("%s is not in use by any devices", USBIP_HOST_DRV_NAME);
-		goto err_close_usbip_host_drv;
-	}
+	struct udev *udev;
+	struct udev_device *dev;
+	const char *driver;
 
-	dlist_for_each_data(devlist, dev, struct sysfs_device) {
-		if (!strncmp(busid, dev->name, strlen(busid)) &&
-		    !strncmp(dev->driver_name, USBIP_HOST_DRV_NAME,
-			     strlen(USBIP_HOST_DRV_NAME))) {
-			verified = 1;
-			break;
-		}
-	}
+	/* Create libudev context. */
+	udev = udev_new();
 
-	if (!verified) {
-		err("device on busid %s is not using %s", busid,
-		    USBIP_HOST_DRV_NAME);
-		goto err_close_usbip_host_drv;
+	/* Check whether the device with this bus ID exists. */
+	dev = udev_device_new_from_subsystem_sysname(udev, "usb", busid);
+	if (!dev) {
+		err("Device with the specified bus ID does not exist.");
+		goto err_close_udev;
 	}
 
-	/*
-	 * NOTE: A read and write of an attribute value of the device busid
-	 * refers to must be done to start probing. That way a rebind of the
-	 * default driver for the device occurs.
-	 *
-	 * This seems very hackish and adds a lot of pointless code. I think it
-	 * should be done in the kernel by the driver after del_match_busid is
-	 * finished!
-	 */
-
-	rc = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
-	if (rc < 0) {
-		err("sysfs must be mounted: %s", strerror(errno));
-		return -1;
+	/* Check whether the device is using usbip-host driver. */
+	driver = udev_device_get_driver(dev);
+	if (!driver || strcmp(driver, "usbip-host")) {
+		err("Device is not bound to usbip-host driver.");
+		goto err_close_udev;
 	}
 
+	/* Unbind device from driver. */
 	snprintf(unbind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
-		 sysfs_mntpath, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
+		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
 		 USBIP_HOST_DRV_NAME, attr_name);
+	dbg("unbind attribute path: %s", unbind_attr_path);
 
-	/* read a device attribute */
-	unbind_attr = sysfs_open_attribute(unbind_attr_path);
-	if (!unbind_attr) {
-		err("could not open %s/%s: %s", busid, attr_name,
-		    strerror(errno));
-		return -1;
+	rc = write_sysfs_attribute(unbind_attr_path, busid, strlen(busid));
+	if (rc < 0) {
+		dbg("Error unbinding device %s from driver.", busid);
+		goto err_close_udev;
 	}
 
-	/* notify driver of unbind */
+	/* Notify driver of unbind. */
 	rc = modify_match_busid(busid, 0);
 	if (rc < 0) {
 		err("unable to unbind device on %s", busid);
+		goto err_close_udev;
 	}
 
-	rc = sysfs_write_attribute(unbind_attr, busid,
-				   SYSFS_BUS_ID_SIZE);
-		if (rc < 0) {
-			dbg("bind driver at %s failed", busid);
-		}
-	sysfs_close_attribute(unbind_attr);
-
 	ret = 0;
 	printf("unbind device on busid %s: complete\n", busid);
 
-err_close_usbip_host_drv:
-	sysfs_close_driver(usbip_host_drv);
+err_close_udev:
+	udev_device_unref(dev);
+	udev_unref(udev);
 
 	return ret;
 }
-- 
1.8.1.2

