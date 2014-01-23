Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaAWShJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:37:09 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:40106 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaAWShG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:37:06 -0500
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ly80toro@cip.cs.fau.de, ke42caxa@cip.cs.fau.de, peterhuewe@gmx.de,
        navinp@cdac.in, josh@joshtriplett.org, anthony.foiani@gmail.com,
        stern@rowland.harvard.edu, tulinizer@gmail.com,
        yacine.belkadi.1@gmail.com, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org,
        Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH] staging: usbip: convert usbip-host driver to usb_device_driver
Date: Thu, 23 Jan 2014 20:36:46 +0200
Message-Id: <1390502206-28684-1-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver was previously an interface driver. Since USB/IP
exports a whole device, not just an interface, it would make
sense to be a device driver.

This patch also modifies the way userspace sees and uses a
shared device - dealing with interfaces is no longer required.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/usbip/stub.h                       |   2 +-
 drivers/staging/usbip/stub_dev.c                   | 150 ++++++++-------------
 drivers/staging/usbip/stub_main.c                  |   6 +-
 drivers/staging/usbip/stub_rx.c                    |   2 +-
 .../usbip/userspace/libsrc/usbip_host_driver.c     |  50 ++-----
 drivers/staging/usbip/userspace/src/usbip_bind.c   | 142 ++++++++-----------
 drivers/staging/usbip/userspace/src/usbip_list.c   |  19 +--
 drivers/staging/usbip/userspace/src/usbip_unbind.c |  51 ++-----
 drivers/staging/usbip/userspace/src/usbipd.c       |  15 ---
 drivers/usb/core/generic.c                         |   1 +
 drivers/usb/core/message.c                         |   1 +
 include/linux/usb.h                                |   4 +
 12 files changed, 148 insertions(+), 295 deletions(-)

diff --git a/drivers/staging/usbip/stub.h b/drivers/staging/usbip/stub.h
index a73e437..82e539a 100644
--- a/drivers/staging/usbip/stub.h
+++ b/drivers/staging/usbip/stub.h
@@ -93,7 +93,7 @@ struct bus_id_priv {
 extern struct kmem_cache *stub_priv_cache;
 
 /* stub_dev.c */
-extern struct usb_driver stub_driver;
+extern struct usb_device_driver stub_driver;
 
 /* stub_main.c */
 struct bus_id_priv *get_busid_priv(const char *busid);
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 76a1ff0..b0bfd34 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -279,21 +279,19 @@ static void stub_device_unusable(struct usbip_device *ud)
  *
  * Allocates and initializes a new stub_device struct.
  */
-static struct stub_device *stub_device_alloc(struct usb_device *udev,
-					     struct usb_interface *interface)
+static struct stub_device *stub_device_alloc(struct usb_device *udev)
 {
 	struct stub_device *sdev;
-	int busnum = interface_to_busnum(interface);
-	int devnum = interface_to_devnum(interface);
+	int busnum = udev->bus->busnum;
+	int devnum = udev->devnum;
 
-	dev_dbg(&interface->dev, "allocating stub device");
+	dev_dbg(&udev->dev, "allocating stub device");
 
 	/* yes, it's a new device */
 	sdev = kzalloc(sizeof(struct stub_device), GFP_KERNEL);
 	if (!sdev)
 		return NULL;
 
-	sdev->interface = usb_get_intf(interface);
 	sdev->udev = usb_get_dev(udev);
 
 	/*
@@ -322,7 +320,7 @@ static struct stub_device *stub_device_alloc(struct usb_device *udev,
 
 	usbip_start_eh(&sdev->ud);
 
-	dev_dbg(&interface->dev, "register new interface\n");
+	dev_dbg(&udev->dev, "register new device\n");
 
 	return sdev;
 }
@@ -332,32 +330,20 @@ static void stub_device_free(struct stub_device *sdev)
 	kfree(sdev);
 }
 
-/*
- * If a usb device has multiple active interfaces, this driver is bound to all
- * the active interfaces. However, usbip exports *a* usb device (i.e., not *an*
- * active interface). Currently, a userland program must ensure that it
- * looks at the usbip's sysfs entries of only the first active interface.
- *
- * TODO: use "struct usb_device_driver" to bind a usb device.
- * However, it seems it is not fully supported in mainline kernel yet
- * (2.6.19.2).
- */
-static int stub_probe(struct usb_interface *interface,
-		      const struct usb_device_id *id)
+static int stub_probe(struct usb_device *udev)
 {
-	struct usb_device *udev = interface_to_usbdev(interface);
 	struct stub_device *sdev = NULL;
-	const char *udev_busid = dev_name(interface->dev.parent);
-	int err = 0;
+	const char *udev_busid = dev_name(&udev->dev);
+	int err = 0, config;
 	struct bus_id_priv *busid_priv;
 
-	dev_dbg(&interface->dev, "Enter\n");
+	dev_dbg(&udev->dev, "Enter\n");
 
 	/* check we should claim or not by busid_table */
 	busid_priv = get_busid_priv(udev_busid);
 	if (!busid_priv || (busid_priv->status == STUB_BUSID_REMOV) ||
 	    (busid_priv->status == STUB_BUSID_OTHER)) {
-		dev_info(&interface->dev,
+		dev_info(&udev->dev,
 			"%s is not in match_busid table... skip!\n",
 			udev_busid);
 
@@ -383,60 +369,36 @@ static int stub_probe(struct usb_interface *interface,
 		return -ENODEV;
 	}
 
-	if (busid_priv->status == STUB_BUSID_ALLOC) {
-		sdev = busid_priv->sdev;
-		if (!sdev)
-			return -ENODEV;
-
-		busid_priv->interf_count++;
-		dev_info(&interface->dev,
-			"usbip-host: register new interface (bus %u dev %u ifn %u)\n",
-			udev->bus->busnum, udev->devnum,
-			interface->cur_altsetting->desc.bInterfaceNumber);
-
-		/* set private data to usb_interface */
-		usb_set_intfdata(interface, sdev);
-
-		err = stub_add_files(&interface->dev);
-		if (err) {
-			dev_err(&interface->dev, "stub_add_files for %s\n",
-				udev_busid);
-			usb_set_intfdata(interface, NULL);
-			busid_priv->interf_count--;
-			return err;
-		}
-
-		usb_get_intf(interface);
-		return 0;
-	}
-
 	/* ok, this is my device */
-	sdev = stub_device_alloc(udev, interface);
+	sdev = stub_device_alloc(udev);
 	if (!sdev)
 		return -ENOMEM;
 
-	dev_info(&interface->dev,
-		"usbip-host: register new device (bus %u dev %u ifn %u)\n",
-		udev->bus->busnum, udev->devnum,
-		interface->cur_altsetting->desc.bInterfaceNumber);
+	dev_info(&udev->dev,
+		"usbip-host: register new device (bus %u dev %u)\n",
+		udev->bus->busnum, udev->devnum);
 
-	busid_priv->interf_count = 0;
 	busid_priv->shutdown_busid = 0;
 
-	/* set private data to usb_interface */
-	usb_set_intfdata(interface, sdev);
-	busid_priv->interf_count++;
+	config = usb_choose_configuration(udev);
+	if (config >= 0) {
+		err = usb_set_configuration(udev, config);
+		if (err && err != -ENODEV)
+			dev_err(&udev->dev, "can't set config #%d, error %d\n",
+				config, err);
+	}
+
+	/* set private data to usb_device */
+	dev_set_drvdata(&udev->dev, sdev);
 	busid_priv->sdev = sdev;
 
-	err = stub_add_files(&interface->dev);
+	err = stub_add_files(&udev->dev);
 	if (err) {
-		dev_err(&interface->dev, "stub_add_files for %s\n", udev_busid);
-		usb_set_intfdata(interface, NULL);
-		usb_put_intf(interface);
+		dev_err(&udev->dev, "stub_add_files for %s\n", udev_busid);
+		dev_set_drvdata(&udev->dev, NULL);
 		usb_put_dev(udev);
 		kthread_stop_put(sdev->ud.eh);
 
-		busid_priv->interf_count = 0;
 		busid_priv->sdev = NULL;
 		stub_device_free(sdev);
 		return err;
@@ -461,13 +423,13 @@ static void shutdown_busid(struct bus_id_priv *busid_priv)
  * called in usb_disconnect() or usb_deregister()
  * but only if actconfig(active configuration) exists
  */
-static void stub_disconnect(struct usb_interface *interface)
+static void stub_disconnect(struct usb_device *udev)
 {
 	struct stub_device *sdev;
-	const char *udev_busid = dev_name(interface->dev.parent);
+	const char *udev_busid = dev_name(&udev->dev);
 	struct bus_id_priv *busid_priv;
 
-	dev_dbg(&interface->dev, "Enter\n");
+	dev_dbg(&udev->dev, "Enter\n");
 
 	busid_priv = get_busid_priv(udev_busid);
 	if (!busid_priv) {
@@ -475,41 +437,29 @@ static void stub_disconnect(struct usb_interface *interface)
 		return;
 	}
 
-	sdev = usb_get_intfdata(interface);
+	sdev = dev_get_drvdata(&udev->dev);
 
 	/* get stub_device */
 	if (!sdev) {
-		dev_err(&interface->dev, "could not get device");
+		dev_err(&udev->dev, "could not get device");
 		return;
 	}
 
-	usb_set_intfdata(interface, NULL);
+	dev_set_drvdata(&udev->dev, NULL);
 
 	/*
 	 * NOTE: rx/tx threads are invoked for each usb_device.
 	 */
-	stub_remove_files(&interface->dev);
+	stub_remove_files(&udev->dev);
 
 	/* If usb reset is called from event handler */
-	if (busid_priv->sdev->ud.eh == current) {
-		busid_priv->interf_count--;
+	if (busid_priv->sdev->ud.eh == current)
 		return;
-	}
-
-	if (busid_priv->interf_count > 1) {
-		busid_priv->interf_count--;
-		shutdown_busid(busid_priv);
-		usb_put_intf(interface);
-		return;
-	}
-
-	busid_priv->interf_count = 0;
 
 	/* shutdown the current connection */
 	shutdown_busid(busid_priv);
 
 	usb_put_dev(sdev->udev);
-	usb_put_intf(interface);
 
 	/* free sdev */
 	busid_priv->sdev = NULL;
@@ -523,28 +473,34 @@ static void stub_disconnect(struct usb_interface *interface)
 	}
 }
 
-/*
- * Presence of pre_reset and post_reset prevents the driver from being unbound
- * when the device is being reset
- */
+#ifdef CONFIG_PM
 
-static int stub_pre_reset(struct usb_interface *interface)
+/* These functions need usb_port_suspend and usb_port_resume,
+ * which reside in drivers/usb/core/usb.h. Skip for now. */
+
+static int stub_suspend(struct usb_device *udev, pm_message_t message)
 {
-	dev_dbg(&interface->dev, "pre_reset\n");
+	dev_dbg(&udev->dev, "stub_suspend\n");
+
 	return 0;
 }
 
-static int stub_post_reset(struct usb_interface *interface)
+static int stub_resume(struct usb_device *udev, pm_message_t message)
 {
-	dev_dbg(&interface->dev, "post_reset\n");
+	dev_dbg(&udev->dev, "stub_resume\n");
+
 	return 0;
 }
 
-struct usb_driver stub_driver = {
+#endif	/* CONFIG_PM */
+
+struct usb_device_driver stub_driver = {
 	.name		= "usbip-host",
 	.probe		= stub_probe,
 	.disconnect	= stub_disconnect,
-	.id_table	= stub_table,
-	.pre_reset	= stub_pre_reset,
-	.post_reset	= stub_post_reset,
+#ifdef CONFIG_PM
+	.suspend	= stub_suspend,
+	.resume		= stub_resume,
+#endif
+	.supports_autosuspend	=	0,
 };
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/staging/usbip/stub_main.c
index baf857f..bd7b83a 100644
--- a/drivers/staging/usbip/stub_main.c
+++ b/drivers/staging/usbip/stub_main.c
@@ -254,7 +254,7 @@ static int __init usbip_host_init(void)
 		return -ENOMEM;
 	}
 
-	ret = usb_register(&stub_driver);
+	ret = usb_register_device_driver(&stub_driver, THIS_MODULE);
 	if (ret) {
 		pr_err("usb_register failed %d\n", ret);
 		goto err_usb_register;
@@ -271,7 +271,7 @@ static int __init usbip_host_init(void)
 	return ret;
 
 err_create_file:
-	usb_deregister(&stub_driver);
+	usb_deregister_device_driver(&stub_driver);
 err_usb_register:
 	kmem_cache_destroy(stub_priv_cache);
 	return ret;
@@ -286,7 +286,7 @@ static void __exit usbip_host_exit(void)
 	 * deregister() calls stub_disconnect() for all devices. Device
 	 * specific data is cleared in stub_disconnect().
 	 */
-	usb_deregister(&stub_driver);
+	usb_deregister_device_driver(&stub_driver);
 
 	kmem_cache_destroy(stub_priv_cache);
 }
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 5d1d4a1..76e44d9 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -550,7 +550,7 @@ static void stub_rx_pdu(struct usbip_device *ud)
 	int ret;
 	struct usbip_header pdu;
 	struct stub_device *sdev = container_of(ud, struct stub_device, ud);
-	struct device *dev = &sdev->interface->dev;
+	struct device *dev = &sdev->udev->dev;
 
 	usbip_dbg_stub_rx("Enter\n");
 
diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
index 71a449c..f421606 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
@@ -56,8 +56,8 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 	 * usbip_status to reappear.
 	 */
 
-	snprintf(attrpath, SYSFS_PATH_MAX, "%s/%s:%d.%d/usbip_status",
-		 udev->path, udev->busid, udev->bConfigurationValue, 0);
+	snprintf(attrpath, SYSFS_PATH_MAX, "%s/usbip_status",
+		 udev->path);
 
 	while (retries > 0) {
 		if (stat(attrpath, &s) == 0)
@@ -168,45 +168,24 @@ static void delete_nothing(void *unused_data)
 
 static int refresh_exported_devices(void)
 {
-	/* sysfs_device of usb_interface */
-	struct sysfs_device	*suintf;
-	struct dlist		*suintf_list;
 	/* sysfs_device of usb_device */
 	struct sysfs_device	*sudev;
 	struct dlist		*sudev_list;
+	struct dlist		*sudev_unique_list;
 	struct usbip_exported_device *edev;
 
-	sudev_list = dlist_new_with_delete(sizeof(struct sysfs_device),
-					   delete_nothing);
-
-	suintf_list = sysfs_get_driver_devices(host_driver->sysfs_driver);
-	if (!suintf_list) {
-		/*
-		 * Not an error condition. There are simply no devices bound to
-		 * the driver yet.
-		 */
-		dbg("bind " USBIP_HOST_DRV_NAME ".ko to a usb device to be "
-		    "exportable!");
-		return 0;
-	}
+	sudev_unique_list = dlist_new_with_delete(sizeof(struct sysfs_device),
+						  delete_nothing);
 
-	/* collect unique USB devices (not interfaces) */
-	dlist_for_each_data(suintf_list, suintf, struct sysfs_device) {
-		/* get usb device of this usb interface */
-		sudev = sysfs_get_device_parent(suintf);
-		if (!sudev) {
-			dbg("sysfs_get_device_parent failed: %s", suintf->name);
-			continue;
-		}
+	sudev_list = sysfs_get_driver_devices(host_driver->sysfs_driver);
 
-		if (check_new(sudev_list, sudev)) {
-			/* insert item at head of list */
-			dlist_unshift(sudev_list, sudev);
-		}
-	}
+	dlist_for_each_data(sudev_list, sudev, struct sysfs_device)
+		if (check_new(sudev_unique_list, sudev))
+			dlist_unshift(sudev_unique_list, sudev);
 
-	dlist_for_each_data(sudev_list, sudev, struct sysfs_device) {
+	dlist_for_each_data(sudev_unique_list, sudev, struct sysfs_device) {
 		edev = usbip_exported_device_new(sudev->path);
+
 		if (!edev) {
 			dbg("usbip_exported_device_new failed");
 			continue;
@@ -216,7 +195,7 @@ static int refresh_exported_devices(void)
 		host_driver->ndevs++;
 	}
 
-	dlist_destroy(sudev_list);
+	dlist_destroy(sudev_unique_list);
 
 	return 0;
 }
@@ -356,9 +335,8 @@ int usbip_host_export_device(struct usbip_exported_device *edev, int sockfd)
 	}
 
 	/* only the first interface is true */
-	snprintf(attr_path, sizeof(attr_path), "%s/%s:%d.%d/%s",
-		 edev->udev.path, edev->udev.busid,
-		 edev->udev.bConfigurationValue, 0, attr_name);
+	snprintf(attr_path, sizeof(attr_path), "%s/%s",
+		 edev->udev.path, attr_name);
 
 	attr = sysfs_open_attribute(attr_path);
 	if (!attr) {
diff --git a/drivers/staging/usbip/userspace/src/usbip_bind.c b/drivers/staging/usbip/userspace/src/usbip_bind.c
index 9ecaf6e..8cfd2db 100644
--- a/drivers/staging/usbip/userspace/src/usbip_bind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_bind.c
@@ -52,12 +52,8 @@ static int bind_usbip(char *busid)
 	char attr_name[] = "bind";
 	char sysfs_mntpath[SYSFS_PATH_MAX];
 	char bind_attr_path[SYSFS_PATH_MAX];
-	char intf_busid[SYSFS_BUS_ID_SIZE];
-	struct sysfs_device *busid_dev;
 	struct sysfs_attribute *bind_attr;
-	struct sysfs_attribute *bConfValue;
-	struct sysfs_attribute *bNumIntfs;
-	int i, failed = 0;
+	int failed = 0;
 	int rc, ret = -1;
 
 	rc = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
@@ -76,39 +72,15 @@ static int bind_usbip(char *busid)
 		return -1;
 	}
 
-	busid_dev = sysfs_open_device(bus_type, busid);
-	if (!busid_dev) {
-		dbg("sysfs_open_device %s failed: %s", busid, strerror(errno));
-		goto err_close_bind_attr;
-	}
-
-	bConfValue = sysfs_get_device_attr(busid_dev, "bConfigurationValue");
-	bNumIntfs  = sysfs_get_device_attr(busid_dev, "bNumInterfaces");
-
-	if (!bConfValue || !bNumIntfs) {
-		dbg("problem getting device attributes: %s",
-		    strerror(errno));
-		goto err_close_busid_dev;
-	}
-
-	for (i = 0; i < atoi(bNumIntfs->value); i++) {
-		snprintf(intf_busid, SYSFS_BUS_ID_SIZE, "%s:%.1s.%d", busid,
-			 bConfValue->value, i);
-
-		rc = sysfs_write_attribute(bind_attr, intf_busid,
-					   SYSFS_BUS_ID_SIZE);
-		if (rc < 0) {
-			dbg("bind driver at %s failed", intf_busid);
-			failed = 1;
-		}
+	rc = sysfs_write_attribute(bind_attr, busid, SYSFS_BUS_ID_SIZE);
+	if (rc < 0) {
+		dbg("bind driver at %s failed", busid);
+		failed = 1;
 	}
 
 	if (!failed)
 		ret = 0;
 
-err_close_busid_dev:
-	sysfs_close_device(busid_dev);
-err_close_bind_attr:
 	sysfs_close_attribute(bind_attr);
 
 	return ret;
@@ -118,15 +90,12 @@ err_close_bind_attr:
 static int unbind_other(char *busid)
 {
 	char bus_type[] = "usb";
-	char intf_busid[SYSFS_BUS_ID_SIZE];
 	struct sysfs_device *busid_dev;
-	struct sysfs_device *intf_dev;
-	struct sysfs_driver *intf_drv;
+	struct sysfs_device *dev;
+	struct sysfs_driver *drv;
 	struct sysfs_attribute *unbind_attr;
-	struct sysfs_attribute *bConfValue;
 	struct sysfs_attribute *bDevClass;
-	struct sysfs_attribute *bNumIntfs;
-	int i, rc;
+	int rc;
 	enum unbind_status status = UNBIND_ST_OK;
 
 	busid_dev = sysfs_open_device(bus_type, busid);
@@ -134,12 +103,11 @@ static int unbind_other(char *busid)
 		dbg("sysfs_open_device %s failed: %s", busid, strerror(errno));
 		return -1;
 	}
+	dbg("busid path: %s", busid_dev->path);
 
-	bConfValue = sysfs_get_device_attr(busid_dev, "bConfigurationValue");
 	bDevClass  = sysfs_get_device_attr(busid_dev, "bDeviceClass");
-	bNumIntfs  = sysfs_get_device_attr(busid_dev, "bNumInterfaces");
-	if (!bConfValue || !bDevClass || !bNumIntfs) {
-		dbg("problem getting device attributes: %s",
+	if (!bDevClass) {
+		dbg("problem getting device attribute: %s",
 		    strerror(errno));
 		goto err_close_busid_dev;
 	}
@@ -149,62 +117,62 @@ static int unbind_other(char *busid)
 		goto err_close_busid_dev;
 	}
 
-	for (i = 0; i < atoi(bNumIntfs->value); i++) {
-		snprintf(intf_busid, SYSFS_BUS_ID_SIZE, "%s:%.1s.%d", busid,
-			 bConfValue->value, i);
-		intf_dev = sysfs_open_device(bus_type, intf_busid);
-		if (!intf_dev) {
-			dbg("could not open interface device: %s",
-			    strerror(errno));
-			goto err_close_busid_dev;
-		}
-
-		dbg("%s -> %s", intf_dev->name,  intf_dev->driver_name);
+	dev = sysfs_open_device(bus_type, busid);
+	if (!dev) {
+		dbg("could not open device: %s",
+				strerror(errno));
+		goto err_close_busid_dev;
+	}
 
-		if (!strncmp("unknown", intf_dev->driver_name, SYSFS_NAME_LEN))
-			/* unbound interface */
-			continue;
+	dbg("%s -> %s", dev->name,  dev->driver_name);
 
-		if (!strncmp(USBIP_HOST_DRV_NAME, intf_dev->driver_name,
-			     SYSFS_NAME_LEN)) {
-			/* already bound to usbip-host */
-			status = UNBIND_ST_USBIP_HOST;
-			continue;
-		}
+	if (!strncmp("unknown", dev->driver_name, SYSFS_NAME_LEN)) {
+		/* unbound interface */
+		sysfs_close_device(dev);
+		goto out;
+	}
 
-		/* unbinding */
-		intf_drv = sysfs_open_driver(bus_type, intf_dev->driver_name);
-		if (!intf_drv) {
-			dbg("could not open interface driver on %s: %s",
-			    intf_dev->name, strerror(errno));
-			goto err_close_intf_dev;
-		}
+	if (!strncmp(USBIP_HOST_DRV_NAME, dev->driver_name,
+				SYSFS_NAME_LEN)) {
+		/* already bound to usbip-host */
+		status = UNBIND_ST_USBIP_HOST;
+		sysfs_close_device(dev);
+		goto out;
+	}
 
-		unbind_attr = sysfs_get_driver_attr(intf_drv, "unbind");
-		if (!unbind_attr) {
-			dbg("problem getting interface driver attribute: %s",
-			    strerror(errno));
-			goto err_close_intf_drv;
-		}
+	/* unbinding */
+	drv = sysfs_open_driver(bus_type, dev->driver_name);
+	if (!drv) {
+		dbg("could not open device driver on %s: %s",
+				dev->name, strerror(errno));
+		goto err_close_intf_dev;
+	}
+	dbg("device driver: %s", drv->path);
 
-		rc = sysfs_write_attribute(unbind_attr, intf_dev->bus_id,
-					   SYSFS_BUS_ID_SIZE);
-		if (rc < 0) {
-			/* NOTE: why keep unbinding other interfaces? */
-			dbg("unbind driver at %s failed", intf_dev->bus_id);
-			status = UNBIND_ST_FAILED;
-		}
+	unbind_attr = sysfs_get_driver_attr(drv, "unbind");
+	if (!unbind_attr) {
+		dbg("problem getting device driver attribute: %s",
+				strerror(errno));
+		goto err_close_intf_drv;
+	}
 
-		sysfs_close_driver(intf_drv);
-		sysfs_close_device(intf_dev);
+	rc = sysfs_write_attribute(unbind_attr, dev->bus_id,
+			SYSFS_BUS_ID_SIZE);
+	if (rc < 0) {
+		/* NOTE: why keep unbinding other interfaces? */
+		dbg("unbind driver at %s failed", dev->bus_id);
+		status = UNBIND_ST_FAILED;
 	}
 
+	sysfs_close_driver(drv);
+	sysfs_close_device(dev);
+
 	goto out;
 
 err_close_intf_drv:
-	sysfs_close_driver(intf_drv);
+	sysfs_close_driver(drv);
 err_close_intf_dev:
-	sysfs_close_device(intf_dev);
+	sysfs_close_device(dev);
 err_close_busid_dev:
 	status = UNBIND_ST_FAILED;
 out:
diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index 237e099..8864fa2 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -52,9 +52,8 @@ static int get_exported_devices(char *host, int sockfd)
 	struct op_devlist_reply reply;
 	uint16_t code = OP_REP_DEVLIST;
 	struct usbip_usb_device udev;
-	struct usbip_usb_interface uintf;
 	unsigned int i;
-	int j, rc;
+	int rc;
 
 	rc = usbip_net_send_op_common(sockfd, OP_REQ_DEVLIST, 0);
 	if (rc < 0) {
@@ -104,22 +103,6 @@ static int get_exported_devices(char *host, int sockfd)
 		printf("%11s: %s\n", "", udev.path);
 		printf("%11s: %s\n", "", class_name);
 
-		for (j = 0; j < udev.bNumInterfaces; j++) {
-			rc = usbip_net_recv(sockfd, &uintf, sizeof(uintf));
-			if (rc < 0) {
-				dbg("usbip_net_recv failed: usbip_usb_intf[%d]",
-				    j);
-
-				return -1;
-			}
-			usbip_net_pack_usb_interface(0, &uintf);
-
-			usbip_names_get_class(class_name, sizeof(class_name),
-					      uintf.bInterfaceClass,
-					      uintf.bInterfaceSubClass,
-					      uintf.bInterfaceProtocol);
-			printf("%11s: %2d - %s\n", "", j, class_name);
-		}
 		printf("\n");
 	}
 
diff --git a/drivers/staging/usbip/userspace/src/usbip_unbind.c b/drivers/staging/usbip/userspace/src/usbip_unbind.c
index d5a9ab6..cace878 100644
--- a/drivers/staging/usbip/userspace/src/usbip_unbind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_unbind.c
@@ -47,12 +47,10 @@ static int unbind_device(char *busid)
 	int verified = 0;
 	int rc, ret = -1;
 
-	char attr_name[] = "bConfigurationValue";
+	char attr_name[] = "unbind";
 	char sysfs_mntpath[SYSFS_PATH_MAX];
-	char busid_attr_path[SYSFS_PATH_MAX];
-	struct sysfs_attribute *busid_attr;
-	char *val = NULL;
-	int len;
+	char unbind_attr_path[SYSFS_PATH_MAX];
+	struct sysfs_attribute *unbind_attr;
 
 	/* verify the busid device is using usbip-host */
 	usbip_host_drv = sysfs_open_driver(bus_type, USBIP_HOST_DRV_NAME);
@@ -99,55 +97,34 @@ static int unbind_device(char *busid)
 		return -1;
 	}
 
-	snprintf(busid_attr_path, sizeof(busid_attr_path), "%s/%s/%s/%s/%s/%s",
-		 sysfs_mntpath, SYSFS_BUS_NAME, bus_type, SYSFS_DEVICES_NAME,
-		 busid, attr_name);
+	snprintf(unbind_attr_path, sizeof(unbind_attr_path), "%s/%s/%s/%s/%s/%s",
+		 sysfs_mntpath, SYSFS_BUS_NAME, bus_type, SYSFS_DRIVERS_NAME,
+		 USBIP_HOST_DRV_NAME, attr_name);
 
 	/* read a device attribute */
-	busid_attr = sysfs_open_attribute(busid_attr_path);
-	if (!busid_attr) {
+	unbind_attr = sysfs_open_attribute(unbind_attr_path);
+	if (!unbind_attr) {
 		err("could not open %s/%s: %s", busid, attr_name,
 		    strerror(errno));
 		return -1;
 	}
 
-	if (sysfs_read_attribute(busid_attr) < 0) {
-		err("problem reading attribute: %s", strerror(errno));
-		goto err_out;
-	}
-
-	len = busid_attr->len;
-	val = malloc(len);
-	*val = *busid_attr->value;
-	sysfs_close_attribute(busid_attr);
-
 	/* notify driver of unbind */
 	rc = modify_match_busid(busid, 0);
 	if (rc < 0) {
 		err("unable to unbind device on %s", busid);
-		goto err_out;
-	}
-
-	/* write the device attribute */
-	busid_attr = sysfs_open_attribute(busid_attr_path);
-	if (!busid_attr) {
-		err("could not open %s/%s: %s", busid, attr_name,
-		    strerror(errno));
-		return -1;
 	}
 
-	rc = sysfs_write_attribute(busid_attr, val, len);
-	if (rc < 0) {
-		err("problem writing attribute: %s", strerror(errno));
-		goto err_out;
-	}
-	sysfs_close_attribute(busid_attr);
+	rc = sysfs_write_attribute(unbind_attr, busid,
+				   SYSFS_BUS_ID_SIZE);
+		if (rc < 0) {
+			dbg("bind driver at %s failed", busid);
+		}
+	sysfs_close_attribute(unbind_attr);
 
 	ret = 0;
 	printf("unbind device on busid %s: complete\n", busid);
 
-err_out:
-	free(val);
 err_close_usbip_host_drv:
 	sysfs_close_driver(usbip_host_drv);
 
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 7980f8b..c2b3ced 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -159,9 +159,7 @@ static int send_reply_devlist(int connfd)
 {
 	struct usbip_exported_device *edev;
 	struct usbip_usb_device pdu_udev;
-	struct usbip_usb_interface pdu_uinf;
 	struct op_devlist_reply reply;
-	int i;
 	int rc;
 
 	reply.ndev = 0;
@@ -196,19 +194,6 @@ static int send_reply_devlist(int connfd)
 			dbg("usbip_net_send failed: pdu_udev");
 			return -1;
 		}
-
-		for (i = 0; i < edev->udev.bNumInterfaces; i++) {
-			dump_usb_interface(&edev->uinf[i]);
-			memcpy(&pdu_uinf, &edev->uinf[i], sizeof(pdu_uinf));
-			usbip_net_pack_usb_interface(1, &pdu_uinf);
-
-			rc = usbip_net_send(connfd, &pdu_uinf,
-					    sizeof(pdu_uinf));
-			if (rc < 0) {
-				dbg("usbip_net_send failed: pdu_uinf");
-				return -1;
-			}
-		}
 	}
 
 	return 0;
diff --git a/drivers/usb/core/generic.c b/drivers/usb/core/generic.c
index acbfeb0..2770d55 100644
--- a/drivers/usb/core/generic.c
+++ b/drivers/usb/core/generic.c
@@ -155,6 +155,7 @@ int usb_choose_configuration(struct usb_device *udev)
 	}
 	return i;
 }
+EXPORT_SYMBOL(usb_choose_configuration);
 
 static int generic_probe(struct usb_device *udev)
 {
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index bb31597..fb0a555 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1921,6 +1921,7 @@ free_interfaces:
 	usb_autosuspend_device(dev);
 	return 0;
 }
+EXPORT_SYMBOL(usb_set_configuration);
 
 static LIST_HEAD(set_config_list);
 static DEFINE_SPINLOCK(set_config_lock);
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 512ab16..839d668 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1667,6 +1667,10 @@ extern void usb_reset_endpoint(struct usb_device *dev, unsigned int epaddr);
 /* this request isn't really synchronous, but it belongs with the others */
 extern int usb_driver_set_configuration(struct usb_device *udev, int config);
 
+/* choose and set configuration for device */
+extern int usb_choose_configuration(struct usb_device *udev);
+extern int usb_set_configuration(struct usb_device *dev, int configuration);
+
 /*
  * timeouts, in milliseconds, used for sending/receiving control messages
  * they typically complete within a few frames (msec) after they're issued
-- 
1.8.1.2

