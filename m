Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965494AbaDJERR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:17:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41049 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934688AbaDJDWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 048/134] usb: Add quirk detection based on interface information
Date: Wed,  9 Apr 2014 20:22:44 -0700
Message-Id: <20140410032306.248663810@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 80da2e0df5af700518611b7d1cc4fc9945bcaf95 upstream.

When a whole class of devices (possibly from a specific vendor, or
across multiple vendors) require a quirk, explictly listing all devices
in the class make the quirks table unnecessarily large. Fix this by
allowing matching devices based on interface information.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/driver.c |   38 +++++++++++-------
 drivers/usb/core/hub.c    |   10 +++-
 drivers/usb/core/quirks.c |   93 +++++++++++++++++++++++++++++++++++-----------
 drivers/usb/core/usb.h    |    4 +
 4 files changed, 106 insertions(+), 39 deletions(-)

--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -530,22 +530,10 @@ int usb_match_device(struct usb_device *
 }
 
 /* returns 0 if no match, 1 if match */
-int usb_match_one_id(struct usb_interface *interface,
-		     const struct usb_device_id *id)
+int usb_match_one_id_intf(struct usb_device *dev,
+			  struct usb_host_interface *intf,
+			  const struct usb_device_id *id)
 {
-	struct usb_host_interface *intf;
-	struct usb_device *dev;
-
-	/* proc_connectinfo in devio.c may call us with id == NULL. */
-	if (id == NULL)
-		return 0;
-
-	intf = interface->cur_altsetting;
-	dev = interface_to_usbdev(interface);
-
-	if (!usb_match_device(dev, id))
-		return 0;
-
 	/* The interface class, subclass, and protocol should never be
 	 * checked for a match if the device class is Vendor Specific,
 	 * unless the match record specifies the Vendor ID. */
@@ -570,6 +558,26 @@ int usb_match_one_id(struct usb_interfac
 
 	return 1;
 }
+
+/* returns 0 if no match, 1 if match */
+int usb_match_one_id(struct usb_interface *interface,
+		     const struct usb_device_id *id)
+{
+	struct usb_host_interface *intf;
+	struct usb_device *dev;
+
+	/* proc_connectinfo in devio.c may call us with id == NULL. */
+	if (id == NULL)
+		return 0;
+
+	intf = interface->cur_altsetting;
+	dev = interface_to_usbdev(interface);
+
+	if (!usb_match_device(dev, id))
+		return 0;
+
+	return usb_match_one_id_intf(dev, intf, id);
+}
 EXPORT_SYMBOL_GPL(usb_match_one_id);
 
 /**
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1916,7 +1916,7 @@ static int usb_enumerate_device(struct u
 		if (err < 0) {
 			dev_err(&udev->dev, "can't read configurations, error %d\n",
 				err);
-			goto fail;
+			return err;
 		}
 	}
 
@@ -1927,8 +1927,12 @@ static int usb_enumerate_device(struct u
 	udev->serial = usb_cache_string(udev, udev->descriptor.iSerialNumber);
 
 	err = usb_enumerate_device_otg(udev);
-fail:
-	return err;
+	if (err < 0)
+		return err;
+
+	usb_detect_interface_quirks(udev);
+
+	return 0;
 }
 
 static void set_usb_port_removable(struct usb_device *udev)
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -15,17 +15,22 @@
 #include <linux/usb/quirks.h>
 #include "usb.h"
 
-/* List of quirky USB devices.  Please keep this list ordered by:
+/* Lists of quirky USB devices, split in device quirks and interface quirks.
+ * Device quirks are applied at the very beginning of the enumeration process,
+ * right after reading the device descriptor. They can thus only match on device
+ * information.
+ *
+ * Interface quirks are applied after reading all the configuration descriptors.
+ * They can match on both device and interface information.
+ *
+ * Note that the DELAY_INIT and HONOR_BNUMINTERFACES quirks do not make sense as
+ * interface quirks, as they only influence the enumeration process which is run
+ * before processing the interface quirks.
+ *
+ * Please keep the lists ordered by:
  * 	1) Vendor ID
  * 	2) Product ID
  * 	3) Class ID
- *
- * as we want specific devices to be overridden first, and only after that, any
- * class specific quirks.
- *
- * Right now the logic aborts if it finds a valid device in the table, we might
- * want to change that in the future if it turns out that a whole class of
- * devices is broken...
  */
 static const struct usb_device_id usb_quirk_list[] = {
 	/* CBM - Flash disk */
@@ -178,16 +183,53 @@ static const struct usb_device_id usb_qu
 	{ }  /* terminating entry must be last */
 };
 
-static const struct usb_device_id *find_id(struct usb_device *udev)
+static const struct usb_device_id usb_interface_quirk_list[] = {
+	{ }  /* terminating entry must be last */
+};
+
+static bool usb_match_any_interface(struct usb_device *udev,
+				    const struct usb_device_id *id)
+{
+	unsigned int i;
+
+	for (i = 0; i < udev->descriptor.bNumConfigurations; ++i) {
+		struct usb_host_config *cfg = &udev->config[i];
+		unsigned int j;
+
+		for (j = 0; j < cfg->desc.bNumInterfaces; ++j) {
+			struct usb_interface_cache *cache;
+			struct usb_host_interface *intf;
+
+			cache = cfg->intf_cache[j];
+			if (cache->num_altsetting == 0)
+				continue;
+
+			intf = &cache->altsetting[0];
+			if (usb_match_one_id_intf(udev, intf, id))
+				return true;
+		}
+	}
+
+	return false;
+}
+
+static u32 __usb_detect_quirks(struct usb_device *udev,
+			       const struct usb_device_id *id)
 {
-	const struct usb_device_id *id = usb_quirk_list;
+	u32 quirks = 0;
 
-	for (; id->idVendor || id->bDeviceClass || id->bInterfaceClass ||
-			id->driver_info; id++) {
-		if (usb_match_device(udev, id))
-			return id;
+	for (; id->match_flags; id++) {
+		if (!usb_match_device(udev, id))
+			continue;
+
+		if ((id->match_flags & USB_DEVICE_ID_MATCH_INT_INFO) &&
+		    !usb_match_any_interface(udev, id))
+			continue;
+
+		quirks |= (u32)(id->driver_info);
 	}
-	return NULL;
+
+	return quirks;
 }
 
 /*
@@ -195,14 +237,10 @@ static const struct usb_device_id *find_
  */
 void usb_detect_quirks(struct usb_device *udev)
 {
-	const struct usb_device_id *id = usb_quirk_list;
-
-	id = find_id(udev);
-	if (id)
-		udev->quirks = (u32)(id->driver_info);
+	udev->quirks = __usb_detect_quirks(udev, usb_quirk_list);
 	if (udev->quirks)
 		dev_dbg(&udev->dev, "USB quirks for this device: %x\n",
-				udev->quirks);
+			udev->quirks);
 
 	/* For the present, all devices default to USB-PERSIST enabled */
 #if 0		/* was: #ifdef CONFIG_PM */
@@ -219,3 +257,16 @@ void usb_detect_quirks(struct usb_device
 		udev->persist_enabled = 1;
 #endif	/* CONFIG_PM */
 }
+
+void usb_detect_interface_quirks(struct usb_device *udev)
+{
+	u32 quirks;
+
+	quirks = __usb_detect_quirks(udev, usb_interface_quirk_list);
+	if (quirks == 0)
+		return;
+
+	dev_dbg(&udev->dev, "USB interface quirks for this device: %x\n",
+		quirks);
+	udev->quirks |= quirks;
+}
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -24,6 +24,7 @@ extern void usb_disable_device(struct us
 extern int usb_deauthorize_device(struct usb_device *);
 extern int usb_authorize_device(struct usb_device *);
 extern void usb_detect_quirks(struct usb_device *udev);
+extern void usb_detect_interface_quirks(struct usb_device *udev);
 extern int usb_remove_device(struct usb_device *udev);
 
 extern int usb_get_device_descriptor(struct usb_device *dev,
@@ -35,6 +36,9 @@ extern int usb_set_configuration(struct
 extern int usb_choose_configuration(struct usb_device *udev);
 
 extern void usb_kick_khubd(struct usb_device *dev);
+extern int usb_match_one_id_intf(struct usb_device *dev,
+				 struct usb_host_interface *intf,
+				 const struct usb_device_id *id);
 extern int usb_match_device(struct usb_device *dev,
 			    const struct usb_device_id *id);
 extern void usb_forced_unbind_intf(struct usb_interface *intf);


