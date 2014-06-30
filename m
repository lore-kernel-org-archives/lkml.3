Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaF3V0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:26:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaF3V0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:44 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 02/15] Input - wacom: switch from an USB driver to a HID driver
Date: Mon, 30 Jun 2014 17:26:13 -0400
Message-Id: <1404163586-29582-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All USB Wacom tablets are actually HID devices.
For historical reasons, they are handled as plain USB devices.
The current code makes more and more reference to the HID subsystem
like implementing its own HID report descriptor parser to handle new
devices.

>From the user point of view, we can transparently switch from this state
to a driver handled in the HID subsystem and clean up a lot of USB specific
code in the wacom.ko driver.

The other benefit once the USB dependecies have been removed is that we can
use a tool like uhid to make regression tests and allow further cleanup or
new implementations without risking breaking current behaviors.

To match the current handling of devices in wacom_wac.c, we rely on the
hid_type set by usbhid. usbhid sets the hid_type to HID_TYPE_USBMOUSE when
it sees a USB boot mouse protocol declared and HID_TYPE_USBNONE when the
device is plain HID. There is thus a one to one matching between the list
of supported devices before and after the switch from USB to HID.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c           |  15 ++-
 drivers/hid/hid-wacom.c          |   2 +-
 drivers/input/tablet/wacom.h     |   6 +-
 drivers/input/tablet/wacom_sys.c | 223 ++++++++++++++-------------------------
 drivers/input/tablet/wacom_wac.c |  80 +++++++-------
 drivers/input/tablet/wacom_wac.h |   4 +-
 include/linux/hid.h              |   1 +
 7 files changed, 139 insertions(+), 192 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2ce3f7a..9db1f42 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -782,10 +782,16 @@ static int hid_scan_report(struct hid_device *hid)
 	/*
 	* Vendor specific handlings
 	*/
-	if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS) &&
-	    (hid->group == HID_GROUP_GENERIC))
-		/* hid-rmi should take care of them, not hid-generic */
-		hid->group = HID_GROUP_RMI;
+	switch (hid->vendor) {
+	case USB_VENDOR_ID_SYNAPTICS:
+		if (hid->group == HID_GROUP_GENERIC)
+			/* hid-rmi should take care of them, not hid-generic */
+			hid->group = HID_GROUP_RMI;
+		break;
+	case USB_VENDOR_ID_WACOM:
+		hid->group = HID_GROUP_WACOM;
+		break;
+	}
 
 	vfree(parser);
 	return 0;
@@ -2340,7 +2346,6 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_SKIP) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_CYCLOPS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_VERNIER, USB_DEVICE_ID_VERNIER_LCSPEC) },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_WACOM, HID_ANY_ID) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_4_PHIDGETSERVO_20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_1_PHIDGETSERVO_20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP, USB_DEVICE_ID_8_8_4_IF_KIT) },
diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
index 902013e..4874f4e 100644
--- a/drivers/hid/hid-wacom.c
+++ b/drivers/hid/hid-wacom.c
@@ -960,7 +960,7 @@ static const struct hid_device_id wacom_devices[] = {
 MODULE_DEVICE_TABLE(hid, wacom_devices);
 
 static struct hid_driver wacom_driver = {
-	.name = "wacom",
+	.name = "hid-wacom",
 	.id_table = wacom_devices,
 	.probe = wacom_probe,
 	.remove = wacom_remove,
diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
index 2386ad4..a931221 100644
--- a/drivers/input/tablet/wacom.h
+++ b/drivers/input/tablet/wacom.h
@@ -106,14 +106,12 @@ MODULE_LICENSE(DRIVER_LICENSE);
 #define USB_VENDOR_ID_LENOVO	0x17ef
 
 struct wacom {
-	dma_addr_t data_dma;
 	struct usb_device *usbdev;
 	struct usb_interface *intf;
-	struct urb *irq;
 	struct wacom_wac wacom_wac;
+	struct hid_device *hdev;
 	struct mutex lock;
 	struct work_struct work;
-	bool open;
 	char phys[32];
 	struct wacom_led {
 		u8 select[2]; /* status led selector (0..3) */
@@ -131,7 +129,7 @@ static inline void wacom_schedule_work(struct wacom_wac *wacom_wac)
 	schedule_work(&wacom->work);
 }
 
-extern const struct usb_device_id wacom_ids[];
+extern const struct hid_device_id wacom_ids[];
 
 void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len);
 void wacom_setup_device_quirks(struct wacom_features *features);
diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index e0c1cb2..aa2a4d7 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -83,86 +83,40 @@ static int wacom_set_report(struct usb_interface *intf, u8 type, u8 id,
 	return retval;
 }
 
-static void wacom_sys_irq(struct urb *urb)
+static int wacom_raw_event(struct hid_device *hdev, struct hid_report *report,
+		u8 *raw_data, int size)
 {
-	struct wacom *wacom = urb->context;
-	struct device *dev = &wacom->intf->dev;
-	int retval;
+	struct wacom *wacom = hid_get_drvdata(hdev);
 
-	switch (urb->status) {
-	case 0:
-		/* success */
-		break;
-	case -ECONNRESET:
-	case -ENOENT:
-	case -ESHUTDOWN:
-		/* this urb is terminated, clean up */
-		dev_dbg(dev, "%s - urb shutting down with status: %d\n",
-			__func__, urb->status);
-		return;
-	default:
-		dev_dbg(dev, "%s - nonzero urb status received: %d\n",
-			__func__, urb->status);
-		goto exit;
-	}
+	if (size > WACOM_PKGLEN_MAX)
+		return 1;
+
+	memcpy(wacom->wacom_wac.data, raw_data, size);
 
-	wacom_wac_irq(&wacom->wacom_wac, urb->actual_length);
+	wacom_wac_irq(&wacom->wacom_wac, size);
 
- exit:
-	usb_mark_last_busy(wacom->usbdev);
-	retval = usb_submit_urb(urb, GFP_ATOMIC);
-	if (retval)
-		dev_err(dev, "%s - usb_submit_urb failed with result %d\n",
-			__func__, retval);
+	return 0;
 }
 
 static int wacom_open(struct input_dev *dev)
 {
 	struct wacom *wacom = input_get_drvdata(dev);
-	int retval = 0;
-
-	if (usb_autopm_get_interface(wacom->intf) < 0)
-		return -EIO;
+	int retval;
 
 	mutex_lock(&wacom->lock);
-
-	if (wacom->open)
-		goto out;
-
-	if (usb_submit_urb(wacom->irq, GFP_KERNEL)) {
-		retval = -EIO;
-		goto out;
-	}
-
-	wacom->open = true;
-	wacom->intf->needs_remote_wakeup = 1;
-
-out:
+	retval = hid_hw_open(wacom->hdev);
 	mutex_unlock(&wacom->lock);
-	usb_autopm_put_interface(wacom->intf);
+
 	return retval;
 }
 
 static void wacom_close(struct input_dev *dev)
 {
 	struct wacom *wacom = input_get_drvdata(dev);
-	int autopm_error;
-
-	autopm_error = usb_autopm_get_interface(wacom->intf);
 
 	mutex_lock(&wacom->lock);
-	if (!wacom->open)
-		goto out;
-
-	usb_kill_urb(wacom->irq);
-	wacom->open = false;
-	wacom->intf->needs_remote_wakeup = 0;
-
-out:
+	hid_hw_close(wacom->hdev);
 	mutex_unlock(&wacom->lock);
-
-	if (!autopm_error)
-		usb_autopm_put_interface(wacom->intf);
 }
 
 /*
@@ -807,7 +761,8 @@ out:
 static ssize_t wacom_led_select_store(struct device *dev, int set_id,
 				      const char *buf, size_t count)
 {
-	struct wacom *wacom = dev_get_drvdata(dev);
+	struct hid_device *hdev = dev_get_drvdata(dev);
+	struct wacom *wacom = hid_get_drvdata(hdev);
 	unsigned int id;
 	int err;
 
@@ -834,7 +789,8 @@ static ssize_t wacom_led##SET_ID##_select_store(struct device *dev,	\
 static ssize_t wacom_led##SET_ID##_select_show(struct device *dev,	\
 	struct device_attribute *attr, char *buf)			\
 {									\
-	struct wacom *wacom = dev_get_drvdata(dev);			\
+	struct hid_device *hdev = dev_get_drvdata(dev);			\
+	struct wacom *wacom = hid_get_drvdata(hdev);			\
 	return snprintf(buf, 2, "%d\n", wacom->led.select[SET_ID]);	\
 }									\
 static DEVICE_ATTR(status_led##SET_ID##_select, S_IWUSR | S_IRUSR,	\
@@ -868,7 +824,8 @@ static ssize_t wacom_luminance_store(struct wacom *wacom, u8 *dest,
 static ssize_t wacom_##name##_luminance_store(struct device *dev,	\
 	struct device_attribute *attr, const char *buf, size_t count)	\
 {									\
-	struct wacom *wacom = dev_get_drvdata(dev);			\
+	struct hid_device *hdev = dev_get_drvdata(dev);			\
+	struct wacom *wacom = hid_get_drvdata(hdev);			\
 									\
 	return wacom_luminance_store(wacom, &wacom->led.field,		\
 				     buf, count);			\
@@ -883,7 +840,8 @@ DEVICE_LUMINANCE_ATTR(buttons, img_lum);
 static ssize_t wacom_button_image_store(struct device *dev, int button_id,
 					const char *buf, size_t count)
 {
-	struct wacom *wacom = dev_get_drvdata(dev);
+	struct hid_device *hdev = dev_get_drvdata(dev);
+	struct wacom *wacom = hid_get_drvdata(hdev);
 	int err;
 
 	if (count != 1024)
@@ -1197,6 +1155,7 @@ static void wacom_wireless_work(struct work_struct *work)
 	struct wacom *wacom = container_of(work, struct wacom, work);
 	struct usb_device *usbdev = wacom->usbdev;
 	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+	struct hid_device *hdev1, *hdev2;
 	struct wacom *wacom1, *wacom2;
 	struct wacom_wac *wacom_wac1, *wacom_wac2;
 	int error;
@@ -1209,14 +1168,16 @@ static void wacom_wireless_work(struct work_struct *work)
 	wacom_destroy_battery(wacom);
 
 	/* Stylus interface */
-	wacom1 = usb_get_intfdata(usbdev->config->interface[1]);
+	hdev1 = usb_get_intfdata(usbdev->config->interface[1]);
+	wacom1 = hid_get_drvdata(hdev1);
 	wacom_wac1 = &(wacom1->wacom_wac);
 	if (wacom_wac1->input)
 		input_unregister_device(wacom_wac1->input);
 	wacom_wac1->input = NULL;
 
 	/* Touch interface */
-	wacom2 = usb_get_intfdata(usbdev->config->interface[2]);
+	hdev2 = usb_get_intfdata(usbdev->config->interface[2]);
+	wacom2 = hid_get_drvdata(hdev2);
 	wacom_wac2 = &(wacom2->wacom_wac);
 	if (wacom_wac2->input)
 		input_unregister_device(wacom_wac2->input);
@@ -1225,20 +1186,20 @@ static void wacom_wireless_work(struct work_struct *work)
 	if (wacom_wac->pid == 0) {
 		dev_info(&wacom->intf->dev, "wireless tablet disconnected\n");
 	} else {
-		const struct usb_device_id *id = wacom_ids;
+		const struct hid_device_id *id = wacom_ids;
 
 		dev_info(&wacom->intf->dev,
 			 "wireless tablet connected with PID %x\n",
 			 wacom_wac->pid);
 
-		while (id->match_flags) {
-			if (id->idVendor == USB_VENDOR_ID_WACOM &&
-			    id->idProduct == wacom_wac->pid)
+		while (id->bus) {
+			if (id->vendor == USB_VENDOR_ID_WACOM &&
+			    id->product == wacom_wac->pid)
 				break;
 			id++;
 		}
 
-		if (!id->match_flags) {
+		if (!id->bus) {
 			dev_info(&wacom->intf->dev,
 				 "ignoring unknown PID.\n");
 			return;
@@ -1246,7 +1207,7 @@ static void wacom_wireless_work(struct work_struct *work)
 
 		/* Stylus interface */
 		wacom_wac1->features =
-			*((struct wacom_features *)id->driver_info);
+			*((struct wacom_features *)id->driver_data);
 		wacom_wac1->features.device_type = BTN_TOOL_PEN;
 		snprintf(wacom_wac1->name, WACOM_NAME_MAX, "%s (WL) Pen",
 			 wacom_wac1->features.name);
@@ -1260,7 +1221,7 @@ static void wacom_wireless_work(struct work_struct *work)
 		if (wacom_wac1->features.touch_max ||
 		    wacom_wac1->features.type == INTUOSHT) {
 			wacom_wac2->features =
-				*((struct wacom_features *)id->driver_info);
+				*((struct wacom_features *)id->driver_data);
 			wacom_wac2->features.pktlen = WACOM_PKGLEN_BBTOUCH3;
 			wacom_wac2->features.device_type = BTN_TOOL_FINGER;
 			wacom_wac2->features.x_max = wacom_wac2->features.y_max = 4096;
@@ -1326,8 +1287,10 @@ static void wacom_calculate_res(struct wacom_features *features)
 						    features->unitExpo);
 }
 
-static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *id)
+static int wacom_probe(struct hid_device *hdev,
+		const struct hid_device_id *id)
 {
+	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
 	struct usb_device *dev = interface_to_usbdev(intf);
 	struct usb_endpoint_descriptor *endpoint;
 	struct wacom *wacom;
@@ -1335,34 +1298,29 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	struct wacom_features *features;
 	int error;
 
-	if (!id->driver_info)
+	if (!id->driver_data)
 		return -EINVAL;
 
 	wacom = kzalloc(sizeof(struct wacom), GFP_KERNEL);
 	if (!wacom)
 		return -ENOMEM;
 
+	hid_set_drvdata(hdev, wacom);
+	wacom->hdev = hdev;
+
 	wacom_wac = &wacom->wacom_wac;
-	wacom_wac->features = *((struct wacom_features *)id->driver_info);
+	wacom_wac->features = *((struct wacom_features *)id->driver_data);
 	features = &wacom_wac->features;
 	if (features->pktlen > WACOM_PKGLEN_MAX) {
 		error = -EINVAL;
 		goto fail1;
 	}
 
-	wacom_wac->data = usb_alloc_coherent(dev, WACOM_PKGLEN_MAX,
-					     GFP_KERNEL, &wacom->data_dma);
-	if (!wacom_wac->data) {
-		error = -ENOMEM;
+	if (features->check_for_hid_type && features->hid_type != hdev->type) {
+		error = -ENODEV;
 		goto fail1;
 	}
 
-	wacom->irq = usb_alloc_urb(0, GFP_KERNEL);
-	if (!wacom->irq) {
-		error = -ENOMEM;
-		goto fail2;
-	}
-
 	wacom->usbdev = dev;
 	wacom->intf = intf;
 	mutex_init(&wacom->lock);
@@ -1378,7 +1336,7 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 	/* Retrieve the physical and logical size for touch devices */
 	error = wacom_retrieve_hid_descriptor(intf, features);
 	if (error)
-		goto fail3;
+		goto fail1;
 
 	/*
 	 * Intuos5 has no useful data about its touch interface in its
@@ -1426,38 +1384,38 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 			other_dev = dev;
 		error = wacom_add_shared_data(wacom_wac, other_dev);
 		if (error)
-			goto fail3;
+			goto fail1;
 	}
 
-	usb_fill_int_urb(wacom->irq, dev,
-			 usb_rcvintpipe(dev, endpoint->bEndpointAddress),
-			 wacom_wac->data, features->pktlen,
-			 wacom_sys_irq, wacom, endpoint->bInterval);
-	wacom->irq->transfer_dma = wacom->data_dma;
-	wacom->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
-
 	error = wacom_initialize_leds(wacom);
 	if (error)
-		goto fail4;
+		goto fail2;
 
 	if (!(features->quirks & WACOM_QUIRK_NO_INPUT)) {
 		error = wacom_register_input(wacom);
 		if (error)
-			goto fail5;
+			goto fail3;
 	}
 
 	/* Note that if query fails it is not a hard failure */
 	wacom_query_tablet_data(intf, features);
 
-	usb_set_intfdata(intf, wacom);
+	/* Regular HID work starts now */
+	error = hid_parse(hdev);
+	if (error) {
+		hid_err(hdev, "parse failed\n");
+		goto fail4;
+	}
 
-	if (features->quirks & WACOM_QUIRK_MONITOR) {
-		if (usb_submit_urb(wacom->irq, GFP_KERNEL)) {
-			error = -EIO;
-			goto fail5;
-		}
+	error = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
+	if (error) {
+		hid_err(hdev, "hw start failed\n");
+		goto fail4;
 	}
 
+	if (features->quirks & WACOM_QUIRK_MONITOR)
+		error = hid_hw_open(hdev);
+
 	if (wacom_wac->features.type == INTUOSHT && wacom_wac->features.touch_max) {
 		if (wacom_wac->features.device_type == BTN_TOOL_FINGER)
 			wacom_wac->shared->touch_input = wacom_wac->input;
@@ -1465,21 +1423,21 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
 
 	return 0;
 
- fail5: wacom_destroy_leds(wacom);
- fail4:	wacom_remove_shared_data(wacom_wac);
- fail3:	usb_free_urb(wacom->irq);
- fail2:	usb_free_coherent(dev, WACOM_PKGLEN_MAX, wacom_wac->data, wacom->data_dma);
+ fail4:	if (wacom->wacom_wac.input)
+		input_unregister_device(wacom->wacom_wac.input);
+ fail3:	wacom_destroy_leds(wacom);
+ fail2:	wacom_remove_shared_data(wacom_wac);
  fail1:	kfree(wacom);
+	hid_set_drvdata(hdev, NULL);
 	return error;
 }
 
-static void wacom_disconnect(struct usb_interface *intf)
+static void wacom_remove(struct hid_device *hdev)
 {
-	struct wacom *wacom = usb_get_intfdata(intf);
+	struct wacom *wacom = hid_get_drvdata(hdev);
 
-	usb_set_intfdata(intf, NULL);
+	hid_hw_stop(hdev);
 
-	usb_kill_urb(wacom->irq);
 	cancel_work_sync(&wacom->work);
 	if (wacom->wacom_wac.input)
 		input_unregister_device(wacom->wacom_wac.input);
@@ -1487,59 +1445,42 @@ static void wacom_disconnect(struct usb_interface *intf)
 		input_unregister_device(wacom->wacom_wac.pad_input);
 	wacom_destroy_battery(wacom);
 	wacom_destroy_leds(wacom);
-	usb_free_urb(wacom->irq);
-	usb_free_coherent(interface_to_usbdev(intf), WACOM_PKGLEN_MAX,
-			wacom->wacom_wac.data, wacom->data_dma);
 	wacom_remove_shared_data(&wacom->wacom_wac);
-	kfree(wacom);
-}
-
-static int wacom_suspend(struct usb_interface *intf, pm_message_t message)
-{
-	struct wacom *wacom = usb_get_intfdata(intf);
-
-	mutex_lock(&wacom->lock);
-	usb_kill_urb(wacom->irq);
-	mutex_unlock(&wacom->lock);
 
-	return 0;
+	hid_set_drvdata(hdev, NULL);
+	kfree(wacom);
 }
 
-static int wacom_resume(struct usb_interface *intf)
+static int wacom_resume(struct hid_device *hdev)
 {
-	struct wacom *wacom = usb_get_intfdata(intf);
+	struct wacom *wacom = hid_get_drvdata(hdev);
 	struct wacom_features *features = &wacom->wacom_wac.features;
-	int rv = 0;
 
 	mutex_lock(&wacom->lock);
 
 	/* switch to wacom mode first */
-	wacom_query_tablet_data(intf, features);
+	wacom_query_tablet_data(wacom->intf, features);
 	wacom_led_control(wacom);
 
-	if ((wacom->open || (features->quirks & WACOM_QUIRK_MONITOR)) &&
-	    usb_submit_urb(wacom->irq, GFP_NOIO) < 0)
-		rv = -EIO;
-
 	mutex_unlock(&wacom->lock);
 
-	return rv;
+	return 0;
 }
 
-static int wacom_reset_resume(struct usb_interface *intf)
+static int wacom_reset_resume(struct hid_device *hdev)
 {
-	return wacom_resume(intf);
+	return wacom_resume(hdev);
 }
 
-static struct usb_driver wacom_driver = {
+static struct hid_driver wacom_driver = {
 	.name =		"wacom",
 	.id_table =	wacom_ids,
 	.probe =	wacom_probe,
-	.disconnect =	wacom_disconnect,
-	.suspend =	wacom_suspend,
+	.remove =	wacom_remove,
+#ifdef CONFIG_PM
 	.resume =	wacom_resume,
 	.reset_resume =	wacom_reset_resume,
-	.supports_autosuspend = 1,
+#endif
+	.raw_event =	wacom_raw_event,
 };
-
-module_usb_driver(wacom_driver);
+module_hid_driver(wacom_driver);
diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index f170277..1c95ce7 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -2197,15 +2197,18 @@ static const struct wacom_features wacom_features_0x2A =
 static const struct wacom_features wacom_features_0x314 =
 	{ "Wacom Intuos Pro S", WACOM_PKGLEN_INTUOS,  31496, 19685, 2047,
 	  63, INTUOSPS, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES,
-	  .touch_max = 16 };
+	  .touch_max = 16,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 static const struct wacom_features wacom_features_0x315 =
 	{ "Wacom Intuos Pro M", WACOM_PKGLEN_INTUOS,  44704, 27940, 2047,
 	  63, INTUOSPM, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES,
-	  .touch_max = 16 };
+	  .touch_max = 16,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 static const struct wacom_features wacom_features_0x317 =
 	{ "Wacom Intuos Pro L", WACOM_PKGLEN_INTUOS,  65024, 40640, 2047,
 	  63, INTUOSPL, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES,
-	  .touch_max = 16 };
+	  .touch_max = 16,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 static const struct wacom_features wacom_features_0xF4 =
 	{ "Wacom Cintiq 24HD",       WACOM_PKGLEN_INTUOS,   104280, 65400, 2047,
 	  63, WACOM_24HD, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES, 200, 200 };
@@ -2215,7 +2218,8 @@ static const struct wacom_features wacom_features_0xF8 =
 	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0xf6 };
 static const struct wacom_features wacom_features_0xF6 =
 	{ "Wacom Cintiq 24HD touch", .type = WACOM_24HDT, /* Touch */
-	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0xf8, .touch_max = 10 };
+	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0xf8, .touch_max = 10,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 static const struct wacom_features wacom_features_0x3F =
 	{ "Wacom Cintiq 21UX",    WACOM_PKGLEN_INTUOS,    87200, 65600, 1023,
 	  63, CINTIQ, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES };
@@ -2233,7 +2237,8 @@ static const struct wacom_features wacom_features_0xC7 =
 	  0, PL, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
 static const struct wacom_features wacom_features_0xCE =
 	{ "Wacom DTU2231",        WACOM_PKGLEN_GRAPHIRE,  47864, 27011,  511,
-	  0, DTU, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
+	  0, DTU, WACOM_INTUOS_RES, WACOM_INTUOS_RES,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBMOUSE };
 static const struct wacom_features wacom_features_0xF0 =
 	{ "Wacom DTU1631",        WACOM_PKGLEN_GRAPHIRE,  34623, 19553,  511,
 	  0, DTU, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
@@ -2249,7 +2254,8 @@ static const struct wacom_features wacom_features_0x59 = /* Pen */
 	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x5D };
 static const struct wacom_features wacom_features_0x5D = /* Touch */
 	{ "Wacom DTH2242",       .type = WACOM_24HDT,
-	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x59, .touch_max = 10 };
+	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x59, .touch_max = 10,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 static const struct wacom_features wacom_features_0xCC =
 	{ "Wacom Cintiq 21UX2",   WACOM_PKGLEN_INTUOS,    87000, 65400, 2047,
 	  63, WACOM_21UX2, WACOM_INTUOS3_RES, WACOM_INTUOS3_RES, 200, 200 };
@@ -2262,7 +2268,8 @@ static const struct wacom_features wacom_features_0x5B =
 	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x5e };
 static const struct wacom_features wacom_features_0x5E =
 	{ "Wacom Cintiq 22HDT", .type = WACOM_24HDT,
-	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x5b, .touch_max = 10 };
+	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x5b, .touch_max = 10,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 static const struct wacom_features wacom_features_0x90 =
 	{ "Wacom ISDv4 90",       WACOM_PKGLEN_GRAPHIRE,  26202, 16325,  255,
 	  0, TABLETPC, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
@@ -2400,14 +2407,17 @@ static const struct wacom_features wacom_features_0x301 =
 static const struct wacom_features wacom_features_0x302 =
 	{ "Wacom Intuos PT S",     WACOM_PKGLEN_BBPEN,    15200,  9500, 1023,
 	  31, INTUOSHT, WACOM_INTUOS_RES, WACOM_INTUOS_RES,
-	  .touch_max = 16 };
+	  .touch_max = 16,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 static const struct wacom_features wacom_features_0x303 =
 	{ "Wacom Intuos PT M",     WACOM_PKGLEN_BBPEN,    21600, 13500, 1023,
 	  31, INTUOSHT, WACOM_INTUOS_RES, WACOM_INTUOS_RES,
-	  .touch_max = 16 };
+	  .touch_max = 16,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 static const struct wacom_features wacom_features_0x30E =
 	{ "Wacom Intuos S",        WACOM_PKGLEN_BBPEN,    15200,  9500, 1023,
-	  31, INTUOSHT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
+	  31, INTUOSHT, WACOM_INTUOS_RES, WACOM_INTUOS_RES,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 static const struct wacom_features wacom_features_0x6004 =
 	{ "ISD-V4",               WACOM_PKGLEN_GRAPHIRE,  12800,  8000,  255,
 	  0, TABLETPC, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
@@ -2417,22 +2427,18 @@ static const struct wacom_features wacom_features_0x0307 =
 	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x309 };
 static const struct wacom_features wacom_features_0x0309 =
 	{ "Wacom ISDv5 309", .type = WACOM_24HDT, /* Touch */
-	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x0307, .touch_max = 10 };
-
-#define USB_DEVICE_WACOM(prod)					\
-	USB_DEVICE(USB_VENDOR_ID_WACOM, prod),			\
-	.driver_info = (kernel_ulong_t)&wacom_features_##prod
+	  .oVid = USB_VENDOR_ID_WACOM, .oPid = 0x0307, .touch_max = 10,
+	  .check_for_hid_type = true, .hid_type = HID_TYPE_USBNONE };
 
-#define USB_DEVICE_DETAILED(prod, class, sub, proto)			\
-	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_WACOM, prod, class,	\
-				      sub, proto),			\
-	.driver_info = (kernel_ulong_t)&wacom_features_##prod
+#define USB_DEVICE_WACOM(prod)						\
+	HID_DEVICE(BUS_USB, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
+	.driver_data = (kernel_ulong_t)&wacom_features_##prod
 
 #define USB_DEVICE_LENOVO(prod)					\
-	USB_DEVICE(USB_VENDOR_ID_LENOVO, prod),			\
-	.driver_info = (kernel_ulong_t)&wacom_features_##prod
+	HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, prod),			\
+	.driver_data = (kernel_ulong_t)&wacom_features_##prod
 
-const struct usb_device_id wacom_ids[] = {
+const struct hid_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x00) },
 	{ USB_DEVICE_WACOM(0x10) },
 	{ USB_DEVICE_WACOM(0x11) },
@@ -2478,9 +2484,9 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x45) },
 	{ USB_DEVICE_WACOM(0x57) },
 	{ USB_DEVICE_WACOM(0x59) },
-	{ USB_DEVICE_DETAILED(0x5D, USB_CLASS_HID, 0, 0) },
+	{ USB_DEVICE_WACOM(0x5D) },
 	{ USB_DEVICE_WACOM(0x5B) },
-	{ USB_DEVICE_DETAILED(0x5E, USB_CLASS_HID, 0, 0) },
+	{ USB_DEVICE_WACOM(0x5E) },
 	{ USB_DEVICE_WACOM(0xB0) },
 	{ USB_DEVICE_WACOM(0xB1) },
 	{ USB_DEVICE_WACOM(0xB2) },
@@ -2502,13 +2508,7 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0xC5) },
 	{ USB_DEVICE_WACOM(0xC6) },
 	{ USB_DEVICE_WACOM(0xC7) },
-	/*
-	 * DTU-2231 has two interfaces on the same configuration,
-	 * only one is used.
-	 */
-	{ USB_DEVICE_DETAILED(0xCE, USB_CLASS_HID,
-			      USB_INTERFACE_SUBCLASS_BOOT,
-			      USB_INTERFACE_PROTOCOL_MOUSE) },
+	{ USB_DEVICE_WACOM(0xCE) },
 	{ USB_DEVICE_WACOM(0x84) },
 	{ USB_DEVICE_WACOM(0xD0) },
 	{ USB_DEVICE_WACOM(0xD1) },
@@ -2546,13 +2546,13 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x116) },
 	{ USB_DEVICE_WACOM(0x300) },
 	{ USB_DEVICE_WACOM(0x301) },
-	{ USB_DEVICE_DETAILED(0x302, USB_CLASS_HID, 0, 0) },
-	{ USB_DEVICE_DETAILED(0x303, USB_CLASS_HID, 0, 0) },
-	{ USB_DEVICE_DETAILED(0x30E, USB_CLASS_HID, 0, 0) },
+	{ USB_DEVICE_WACOM(0x302) },
+	{ USB_DEVICE_WACOM(0x303) },
+	{ USB_DEVICE_WACOM(0x30E) },
 	{ USB_DEVICE_WACOM(0x304) },
-	{ USB_DEVICE_DETAILED(0x314, USB_CLASS_HID, 0, 0) },
-	{ USB_DEVICE_DETAILED(0x315, USB_CLASS_HID, 0, 0) },
-	{ USB_DEVICE_DETAILED(0x317, USB_CLASS_HID, 0, 0) },
+	{ USB_DEVICE_WACOM(0x314) },
+	{ USB_DEVICE_WACOM(0x315) },
+	{ USB_DEVICE_WACOM(0x317) },
 	{ USB_DEVICE_WACOM(0x4001) },
 	{ USB_DEVICE_WACOM(0x4004) },
 	{ USB_DEVICE_WACOM(0x5000) },
@@ -2560,12 +2560,12 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x47) },
 	{ USB_DEVICE_WACOM(0xF4) },
 	{ USB_DEVICE_WACOM(0xF8) },
-	{ USB_DEVICE_DETAILED(0xF6, USB_CLASS_HID, 0, 0) },
+	{ USB_DEVICE_WACOM(0xF6) },
 	{ USB_DEVICE_WACOM(0xFA) },
 	{ USB_DEVICE_WACOM(0xFB) },
 	{ USB_DEVICE_WACOM(0x0307) },
-	{ USB_DEVICE_DETAILED(0x0309, USB_CLASS_HID, 0, 0) },
+	{ USB_DEVICE_WACOM(0x0309) },
 	{ USB_DEVICE_LENOVO(0x6004) },
 	{ }
 };
-MODULE_DEVICE_TABLE(usb, wacom_ids);
+MODULE_DEVICE_TABLE(hid, wacom_ids);
diff --git a/drivers/input/tablet/wacom_wac.h b/drivers/input/tablet/wacom_wac.h
index f48164c..8821a51 100644
--- a/drivers/input/tablet/wacom_wac.h
+++ b/drivers/input/tablet/wacom_wac.h
@@ -137,6 +137,8 @@ struct wacom_features {
 	unsigned touch_max;
 	int oVid;
 	int oPid;
+	bool check_for_hid_type;
+	int hid_type;
 };
 
 struct wacom_shared {
@@ -151,7 +153,7 @@ struct wacom_shared {
 struct wacom_wac {
 	char name[WACOM_NAME_MAX];
 	char pad_name[WACOM_NAME_MAX];
-	unsigned char *data;
+	unsigned char data[WACOM_PKGLEN_MAX];
 	int tool[2];
 	int id[2];
 	__u32 serial[2];
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 77632cf..9732299 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -309,6 +309,7 @@ struct hid_item {
  * Vendor specific HID device groups
  */
 #define HID_GROUP_RMI				0x0100
+#define HID_GROUP_WACOM				0x0101
 
 /*
  * This is the global environment of the parser. This information is
-- 
2.0.0

