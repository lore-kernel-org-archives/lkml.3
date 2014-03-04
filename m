Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbaCDTYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:24:12 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:38569 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbaCDTYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:24:09 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ly80toro@cip.cs.fau.de, ke42caxa@cip.cs.fau.de, eladwexler77@yahoo.com,
        oat.elena@gmail.com, josh@joshtriplett.org, himangi774@gmail.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, andy.grover@gmail.com,
        firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH] staging: usbip: trigger driver probing after unbinding from usbip-host
Date: Tue,  4 Mar 2014 21:23:56 +0200
Message-Id: <1393961037-21792-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A sysfs attribute is used to announce kernel space that a
new driver probing session should be triggered for the just
unbinded device.

In order to have the address of struct device associated to this
USB device, a new member has been added to struct bus_id_priv.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/stub.h                       |  1 +
 drivers/staging/usbip/stub_dev.c                   |  1 +
 drivers/staging/usbip/stub_main.c                  | 39 ++++++++++++++++++++++
 drivers/staging/usbip/userspace/src/usbip_unbind.c | 18 ++++++++--
 4 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
index 82e539a..266e2b0 100644
--- a/drivers/staging/usbip/stub.h
+++ b/drivers/staging/usbip/stub.h
@@ -86,6 +86,7 @@ struct bus_id_priv {
 	char status;
 	int interf_count;
 	struct stub_device *sdev;
+	struct usb_device *udev;
 	char shutdown_busid;
 };
 
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 1bd13cf..ee899f0 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -386,6 +386,7 @@ static int stub_probe(struct usb_device *udev)
 	/* set private data to usb_device */
 	dev_set_drvdata(&udev->dev, sdev);
 	busid_priv->sdev = sdev;
+	busid_priv->udev = udev;
 
 	err = stub_add_files(&udev->dev);
 	if (err) {
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index bd7b83a..9c5832a 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -19,6 +19,7 @@
 
 #include <linux/string.h>
 #include <linux/module.h>
+#include <linux/device.h>
 
 #include "usbip_common.h"
 #include "stub.h"
@@ -187,6 +188,34 @@ static ssize_t store_match_busid(struct device_driver *dev, const char *buf,
 static DRIVER_ATTR(match_busid, S_IRUSR | S_IWUSR, show_match_busid,
 		   store_match_busid);
 
+static ssize_t rebind_store(struct device_driver *dev, const char *buf,
+				 size_t count)
+{
+	int ret;
+	int len;
+	struct bus_id_priv *bid;
+
+	/* buf length should be less that BUSID_SIZE */
+	len = strnlen(buf, BUSID_SIZE);
+
+	if (!(len < BUSID_SIZE))
+		return -EINVAL;
+
+	bid = get_busid_priv(buf);
+	if (!bid)
+		return -ENODEV;
+
+	ret = device_attach(&bid->udev->dev);
+	if (ret < 0) {
+		dev_err(&bid->udev->dev, "rebind failed\n");
+		return ret;
+	}
+
+	return count;
+}
+
+static DRIVER_ATTR_WO(rebind);
+
 static struct stub_priv *stub_priv_pop_from_listhead(struct list_head *listhead)
 {
 	struct stub_priv *priv, *tmp;
@@ -267,6 +296,13 @@ static int __init usbip_host_init(void)
 		goto err_create_file;
 	}
 
+	ret = driver_create_file(&stub_driver.drvwrap.driver,
+				 &driver_attr_rebind);
+	if (ret) {
+		pr_err("driver_create_file failed\n");
+		goto err_create_file;
+	}
+
 	pr_info(DRIVER_DESC " v" USBIP_VERSION "\n");
 	return ret;
 
@@ -282,6 +318,9 @@ static void __exit usbip_host_exit(void)
 	driver_remove_file(&stub_driver.drvwrap.driver,
 			   &driver_attr_match_busid);
 
+	driver_remove_file(&stub_driver.drvwrap.driver,
+			   &driver_attr_rebind);
+
 	/*
 	 * deregister() calls stub_disconnect() for all devices. Device
 	 * specific data is cleared in stub_disconnect().
diff --git a/drivers/staging/usbip/userspace/src/usbip_unbind.c b/drivers/staging/usbip/userspace/src/usbip_unbind.c
index 4776068..ba0a563 100644
--- a/drivers/staging/usbip/userspace/src/usbip_unbind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_unbind.c
@@ -44,8 +44,10 @@ static int unbind_device(char *busid)
 	char bus_type[] = "usb";
 	int rc, ret = -1;
 
-	char attr_name[] = "unbind";
+	char unbind_attr_name[] = "unbind";
 	char unbind_attr_path[SYSFS_PATH_MAX];
+	char rebind_attr_name[] = "rebind";
+	char rebind_attr_path[SYSFS_PATH_MAX];
 
 	struct udev *udev;
 	struct udev_device *dev;
@@ -71,7 +73,7 @@ static int unbind_device(char *busid)
 	/* Unbind device from driver. */
 	snprintf(unbind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
 		 SYSFS_MNT_PATH, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
-		 USBIP_HOST_DRV_NAME, attr_name);
+		 USBIP_HOST_DRV_NAME, unbind_attr_name);
 	dbg("unbind attribute path: %s", unbind_attr_path);
 
 	rc = write_sysfs_attribute(unbind_attr_path, busid, strlen(busid));
@@ -87,6 +89,18 @@ static int unbind_device(char *busid)
 		goto err_close_udev;
 	}
 
+	/* Trigger new probing. */
+	snprintf(rebind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
+			SYSFS_MNT_PATH, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
+			USBIP_HOST_DRV_NAME, rebind_attr_name);
+	dbg("rebind attribute path: %s", rebind_attr_path);
+
+	rc = write_sysfs_attribute(rebind_attr_path, busid, strlen(busid));
+	if (rc < 0) {
+		dbg("Error rebinding.");
+		goto err_close_udev;
+	}
+
 	ret = 0;
 	printf("unbind device on busid %s: complete\n", busid);
 
-- 
1.8.1.2

