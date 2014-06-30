Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaF3V0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaF3V0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:50 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 08/15] Input - wacom: remove usb dependency for siblings devices
Date: Mon, 30 Jun 2014 17:26:19 -0400
Message-Id: <1404163586-29582-9-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wacom tablets can share different physical sensors on one physical device.
These are called siblings in the code. The current way of implementation
relies on the USB topology to be able to share data amongs those sensors.

We can replace the code to match a HID subsystem, without involving the USB
topology:
- the first probed sensor does not find any siblings in the list
  wacom_udev_list, so it creates its own wacom_hdev_data with its own
  struct hid_device
- the other sensor checks the current list of siblings in wacom_hdev_data,
  and if there is a match, it associates itself to the matched device.

To be sure that we are not associating different sensors from different
physical devices, we also check for the phys path of the hid device which
contains the USB topology.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_sys.c | 75 +++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 40 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 0d0397d..6fe7a6c 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -488,46 +488,45 @@ static int wacom_retrieve_hid_descriptor(struct hid_device *hdev,
 	return error;
 }
 
-struct wacom_usbdev_data {
+struct wacom_hdev_data {
 	struct list_head list;
 	struct kref kref;
-	struct usb_device *dev;
+	struct hid_device *dev;
 	struct wacom_shared shared;
 };
 
 static LIST_HEAD(wacom_udev_list);
 static DEFINE_MUTEX(wacom_udev_list_lock);
 
-static struct usb_device *wacom_get_sibling(struct usb_device *dev, int vendor, int product)
+static bool wacom_are_sibling(struct hid_device *hdev,
+		struct hid_device *sibling)
 {
-	int port1;
-	struct usb_device *sibling;
-
-	if (vendor == 0 && product == 0)
-		return dev;
-
-	if (dev->parent == NULL)
-		return NULL;
-
-	usb_hub_for_each_child(dev->parent, port1, sibling) {
-		struct usb_device_descriptor *d;
-		if (sibling == NULL)
-			continue;
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_features *features = &wacom->wacom_wac.features;
+	int vid = features->oVid;
+	int pid = features->oPid;
 
-		d = &sibling->descriptor;
-		if (d->idVendor == vendor && d->idProduct == product)
-			return sibling;
+	if (vid == 0 && pid == 0) {
+		vid = hdev->vendor;
+		pid = hdev->product;
 	}
 
-	return NULL;
+	if (vid != sibling->vendor || pid != sibling->product)
+		return false;
+
+	/*
+	 * Compare the physical path.
+	 * Dump the last two chars which should contain the input number.
+	 */
+	return !strncmp(hdev->phys, sibling->phys, strlen(hdev->phys) - 2);
 }
 
-static struct wacom_usbdev_data *wacom_get_usbdev_data(struct usb_device *dev)
+static struct wacom_hdev_data *wacom_get_hdev_data(struct hid_device *hdev)
 {
-	struct wacom_usbdev_data *data;
+	struct wacom_hdev_data *data;
 
 	list_for_each_entry(data, &wacom_udev_list, list) {
-		if (data->dev == dev) {
+		if (wacom_are_sibling(hdev, data->dev)) {
 			kref_get(&data->kref);
 			return data;
 		}
@@ -536,28 +535,29 @@ static struct wacom_usbdev_data *wacom_get_usbdev_data(struct usb_device *dev)
 	return NULL;
 }
 
-static int wacom_add_shared_data(struct wacom_wac *wacom,
-				 struct usb_device *dev)
+static int wacom_add_shared_data(struct hid_device *hdev)
 {
-	struct wacom_usbdev_data *data;
+	struct wacom *wacom = hid_get_drvdata(hdev);
+	struct wacom_wac *wacom_wac = &wacom->wacom_wac;
+	struct wacom_hdev_data *data;
 	int retval = 0;
 
 	mutex_lock(&wacom_udev_list_lock);
 
-	data = wacom_get_usbdev_data(dev);
+	data = wacom_get_hdev_data(hdev);
 	if (!data) {
-		data = kzalloc(sizeof(struct wacom_usbdev_data), GFP_KERNEL);
+		data = kzalloc(sizeof(struct wacom_hdev_data), GFP_KERNEL);
 		if (!data) {
 			retval = -ENOMEM;
 			goto out;
 		}
 
 		kref_init(&data->kref);
-		data->dev = dev;
+		data->dev = hdev;
 		list_add_tail(&data->list, &wacom_udev_list);
 	}
 
-	wacom->shared = &data->shared;
+	wacom_wac->shared = &data->shared;
 
 out:
 	mutex_unlock(&wacom_udev_list_lock);
@@ -566,8 +566,8 @@ out:
 
 static void wacom_release_shared_data(struct kref *kref)
 {
-	struct wacom_usbdev_data *data =
-		container_of(kref, struct wacom_usbdev_data, kref);
+	struct wacom_hdev_data *data =
+		container_of(kref, struct wacom_hdev_data, kref);
 
 	mutex_lock(&wacom_udev_list_lock);
 	list_del(&data->list);
@@ -578,10 +578,10 @@ static void wacom_release_shared_data(struct kref *kref)
 
 static void wacom_remove_shared_data(struct wacom_wac *wacom)
 {
-	struct wacom_usbdev_data *data;
+	struct wacom_hdev_data *data;
 
 	if (wacom->shared) {
-		data = container_of(wacom->shared, struct wacom_usbdev_data, shared);
+		data = container_of(wacom->shared, struct wacom_hdev_data, shared);
 		kref_put(&data->kref, wacom_release_shared_data);
 		wacom->shared = NULL;
 	}
@@ -1311,8 +1311,6 @@ static int wacom_probe(struct hid_device *hdev,
 		"%s Pad", features->name);
 
 	if (features->quirks & WACOM_QUIRK_MULTI_INPUT) {
-		struct usb_device *other_dev;
-
 		/* Append the device type to the name */
 		if (features->device_type != BTN_TOOL_FINGER)
 			strlcat(wacom_wac->name, " Pen", WACOM_NAME_MAX);
@@ -1321,10 +1319,7 @@ static int wacom_probe(struct hid_device *hdev,
 		else
 			strlcat(wacom_wac->name, " Pad", WACOM_NAME_MAX);
 
-		other_dev = wacom_get_sibling(dev, features->oVid, features->oPid);
-		if (other_dev == NULL || wacom_get_usbdev_data(other_dev) == NULL)
-			other_dev = dev;
-		error = wacom_add_shared_data(wacom_wac, other_dev);
+		error = wacom_add_shared_data(hdev);
 		if (error)
 			goto fail1;
 	}
-- 
2.0.0

