Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaKPXnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 18:43:13 -0500
Received: from [140.232.255.14] ([140.232.255.14]:47108 "EHLO mail.abrij.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaKPXnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 18:43:11 -0500
X-Greylist: delayed 4201 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Nov 2014 18:43:10 EST
Date: Sun, 16 Nov 2014 13:18:46 -0500
From: bri <bri@abrij.org>
To: Frank Praznik <frank.praznik@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH 001/001] hid-sony.c: add sysfs provisioning
Message-ID: <20141116181846.GA31516@abrij.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some sysfs interfaces to cover some corner use cases when provisioning:

1) Allow read access to the IDA index through device/gamepad_number.  The
IDA index is used to identify the device to the user as the "controller number"
and is reflected via the initial LED states when plugged in.  This sysfs
attribute could be used by userspace for a more seamless transition to
userspace drivers without controller numbers changing.  Write access is not
addressed as it raises the issue of a global IDA that works across different
gamepad drivers.  Internally, remove the use of the term "device_id" for
the gamepad number for code grepability purposes.

2) Allow manual provisioning of the Sixaxis/Dualshock3 USB "pairing" process
through device/master_bdaddr.  The bluez plugin has removed the need for
sixpair.c or other such utilities for the common use case of autoprovisioning.
Under less usual situations, the bluez behavior may not be desired, e.g.
if you need to pair a gamepad with a different machine, see what machine
a pad is paired to, or restore old pairings after use.  This removes
the need to use sixpair.c or roll-your-own libusb code for that sort
of thing.

Signed-off-by: Brian S. Julin <bri@abrij.org>
Tested-by: Brian S. Julin <bri@abrij.org>

---

I've tested with both SixAxis and Dualshock 3 on stock Debian kernel 3.16.5.
I've also tested a copy of the 3.18 git version inserted into the 3.16.5
kernel.  The patch should apply to both (with fuzz on the newer version.)
Tests are still needed on pure 3.18.

I do not have access to the non-Sony pads handled by this driver, but did
test the with a Dualshock4 to ensure that the sysfs files are harmless
vestigials for such devices.

It has been a long time since I popped the hood on the kernel and much
has changed.  I'm unclear as to under what conditions hid-core relieves
the need to lock.  Some review is definitely needed there.

General comment on the driver: when a gamepad being used over
BT is plugged back in to USB, it continues to use BT rather than
switching to USB.  This has both benefits and disadvantages.

On the bright side, this prevents the evdev and js devices from being
destroyed and recreated.  Some applications, many closed-source, may
not respond well to that even when udev rules are used to pin the
device names.

On the other hand this is not the behavior gamers expect and will not
help matters if the reason for plugging the pad in was to decrease
latency due to RF contention.

I notice that sysfs-rules.txt mentions that a device's parentage in
the tree may change, and teaching the hid core to allow graceful
takeover of a device by a different host/bus driver for these
devices might be a use case for that.

--- drivers/hid/hid-sony.c.orig	2014-11-05 20:32:47.387599486 -0500
+++ drivers/hid/hid-sony.c	2014-11-14 20:35:28.327053036 -0500
@@ -8,6 +8,7 @@
  *  Copyright (c) 2012 David Dillow <dave@thedillows.org>
  *  Copyright (c) 2006-2013 Jiri Kosina
  *  Copyright (c) 2013 Colin Leitner <colin.leitner@gmail.com>
+ *  Copyright (c) 2014 Brian S. Julin <bri@abrij.org>
  */
 
 /*
@@ -35,6 +36,9 @@
 #include <linux/list.h>
 #include <linux/idr.h>
 #include <linux/input/mt.h>
+#include <linux/ctype.h>
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
 
 #include "hid-ids.h"
 
@@ -750,7 +754,7 @@ union sixaxis_output_report_01 {
 
 static spinlock_t sony_dev_list_lock;
 static LIST_HEAD(sony_device_list);
-static DEFINE_IDA(sony_device_id_allocator);
+static DEFINE_IDA(sony_gamepad_number_allocator);
 
 struct sony_sc {
 	spinlock_t lock;
@@ -760,7 +764,7 @@ struct sony_sc {
 	unsigned long quirks;
 	struct work_struct state_worker;
 	struct power_supply battery;
-	int device_id;
+	int gamepad_number;
 
 #ifdef CONFIG_SONY_FF
 	__u8 left;
@@ -1321,7 +1325,8 @@ static int sony_leds_init(struct sony_sc
 		if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, 0, 0, 7))
 			return -ENODEV;
 	} else if (sc->quirks & DUALSHOCK4_CONTROLLER) {
-		dualshock4_set_leds_from_id(sc->device_id, initial_values);
+		dualshock4_set_leds_from_id(sc->gamepad_number,
+					    initial_values);
 		initial_values[3] = 1;
 		sc->led_count = 4;
 		memset(max_brightness, 255, 3);
@@ -1330,7 +1335,7 @@ static int sony_leds_init(struct sony_sc
 		name_len = 0;
 		name_fmt = "%s:%s";
 	} else {
-		sixaxis_set_leds_from_id(sc->device_id, initial_values);
+		sixaxis_set_leds_from_id(sc->gamepad_number, initial_values);
 		sc->led_count = 4;
 		memset(use_hw_blink, 1, 4);
 		use_ds4_names = 0;
@@ -1758,38 +1763,209 @@ static int sony_check_add(struct sony_sc
 	return sony_check_add_dev_list(sc);
 }
 
-static int sony_set_device_id(struct sony_sc *sc)
+/* PS3 pads do not pair over bluetooth; Instead a USB handshake is used. */
+static ssize_t sony_master_bdaddr_show(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct sony_sc *sc = hid_get_drvdata(hdev);
+	size_t count;
+	unsigned char msg[8];
+	int ret;
+
+	if (!sc) {
+		hid_err(hdev, "No device data\n");
+		return 0;
+	}
+
+	if (sc->quirks & SIXAXIS_CONTROLLER_BT) {
+		struct device *parent;
+
+		parent = dev->parent;
+		if (!parent)
+			return 0;
+		parent = parent->parent;
+		if (!parent || !parent->type
+		    || strcmp(parent->type->name, "host"))
+			return 0;
+
+		count = scnprintf(buf, PAGE_SIZE, "%pMR\n",
+				  &(to_hci_dev(parent)->bdaddr));
+		return count;
+	}
+
+	if (!(sc->quirks & SIXAXIS_CONTROLLER_USB))
+		return 0;
+
+	ret = hid_hw_raw_request(hdev, 0xf5, msg, sizeof(msg),
+				 HID_FEATURE_REPORT, HID_REQ_GET_REPORT);
+	if (ret < 0) {
+		/* This matches bluez error message */
+		hid_err(hdev, "failed to read master address\n");
+		return 0;
+	}
+
+	count = scnprintf(buf, PAGE_SIZE, "%pM\n", msg + 2);
+	return count;
+}
+
+/*
+ * This could probably be useful in lib/.
+ *
+ * Convert a string to a MAC address, accepting multiple formats.
+ *
+ * Will take most commonly cut-and-pasted formats without being too liberal.
+ * Accepts any hex with delims [-:.] between any octets, no mixing delims,
+ * no splitting octets.
+ *
+ * *buf should have at least 6 bytes of space and will not be altered on fail
+ * Will halt at null terminator or before reading more than lim chars from *c
+ * Return code is sscanf-style: number of non-null bytes read, or 0 on failure
+ */
+static int sony_kstrntomac(const char *c, u8 *buf, size_t lim)
+{
+	int cnt = 0;
+	int dcnt = 0;
+	char delim = '\0';
+	u8 octet[6];
+
+	while (cnt < 6) {
+		if (lim < 2 || !isxdigit(*c) || !isxdigit(*(c+1)))
+			return 0;
+
+		lim -= 2;
+
+		if (isdigit(*c))
+			octet[cnt] = (*c - '0') << 4;
+		else
+			octet[cnt] = (tolower(*c) - 'a' + 10) << 4;
+		c++;
+
+		if (isdigit(*c))
+			octet[cnt] |= *c - '0';
+		else
+			octet[cnt] |= tolower(*c) - 'a' + 10;
+		c++;
+
+		if (cnt < 5) {
+			if (!lim)
+				return 0;
+			if (!delim && (*c == '-' || *c == ':' || *c == '.'))
+				delim = *c;
+			if (delim && *c == delim) {
+				dcnt++;
+				c++;
+				lim--;
+			}
+		}
+		cnt++;
+	}
+
+	memcpy(buf, octet, 6);
+
+	return cnt * 2 + dcnt;
+}
+
+static ssize_t sony_master_bdaddr_store(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct sony_sc *sc = hid_get_drvdata(hdev);
+	u8 msg[8];
+	int ret;
+
+	if (!sc) {
+		hid_err(hdev, "No device data\n");
+		return -EBADFD;
+	}
+
+	if (!(sc->quirks & SIXAXIS_CONTROLLER_USB)) {
+		if (sc->quirks & SIXAXIS_CONTROLLER_BT) {
+			hid_err(hdev,
+				"To set master disconnect BT then use USB\n");
+			return -EOPNOTSUPP;
+		}
+		return -ENOTSUPP;
+	}
+
+	msg[0] = 0x01;
+	msg[1] = 0x00;
+
+	if (!sony_kstrntomac(buf, msg + 2, count))
+		return -EINVAL;
+
+	ret = hid_hw_raw_request(hdev, 0xf5, msg, sizeof(msg),
+				 HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
+	if (ret < 0) {
+		/* This matches bluez error message */
+		hid_err(hdev, "failed to write master address\n");
+		return count;
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR(master_bdaddr, S_IRUGO | S_IWUSR,
+		   sony_master_bdaddr_show, sony_master_bdaddr_store);
+
+static int sony_set_gamepad_number(struct sony_sc *sc)
 {
 	int ret;
 
 	/*
-	 * Only DualShock 4 or Sixaxis controllers get an id.
+	 * Only DualShock 4 or Sixaxis controllers get a number.
 	 * All others are set to -1.
 	 */
 	if ((sc->quirks & SIXAXIS_CONTROLLER) ||
 	    (sc->quirks & DUALSHOCK4_CONTROLLER)) {
-		ret = ida_simple_get(&sony_device_id_allocator, 0, 0,
-					GFP_KERNEL);
+		ret = ida_simple_get(&sony_gamepad_number_allocator, 0, 0,
+				     GFP_KERNEL);
 		if (ret < 0) {
-			sc->device_id = -1;
+			sc->gamepad_number = -1;
 			return ret;
 		}
-		sc->device_id = ret;
+		sc->gamepad_number = ret;
 	} else {
-		sc->device_id = -1;
+		sc->gamepad_number = -1;
 	}
 
 	return 0;
 }
 
-static void sony_release_device_id(struct sony_sc *sc)
+static void sony_release_gamepad_number(struct sony_sc *sc)
 {
-	if (sc->device_id >= 0) {
-		ida_simple_remove(&sony_device_id_allocator, sc->device_id);
-		sc->device_id = -1;
+	if (sc->gamepad_number >= 0) {
+		ida_simple_remove(&sony_gamepad_number_allocator,
+				  sc->gamepad_number);
+		sc->gamepad_number = -1;
 	}
 }
 
+static ssize_t sony_gamepad_number_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct sony_sc *sc = hid_get_drvdata(hdev);
+	size_t count;
+
+	if (!sc) {
+		hid_err(hdev, "No device data\n");
+		return 0;
+	}
+
+	if (sc->gamepad_number < 0)
+		return 0;
+
+	/* Add one to match console user expectations */
+	count = scnprintf(buf, PAGE_SIZE, "%i\n", sc->gamepad_number + 1);
+	return count;
+}
+
+static DEVICE_ATTR(gamepad_number, S_IRUGO, sony_gamepad_number_show, NULL);
+
 static inline void sony_init_work(struct sony_sc *sc,
 					void (*worker)(struct work_struct *))
 {
@@ -1841,10 +2017,22 @@ static int sony_probe(struct hid_device
 		return ret;
 	}
 
-	ret = sony_set_device_id(sc);
+	ret = sony_set_gamepad_number(sc);
 	if (ret < 0) {
-		hid_err(hdev, "failed to allocate the device id\n");
-		goto err_stop;
+		hid_err(hdev, "failed to allocate the gamepad number\n");
+		goto err_nosysfs2;
+	}
+
+	ret = device_create_file(&hdev->dev, &dev_attr_gamepad_number);
+	if (ret) {
+		hid_err(hdev, "failed to create gamepad_number sysfs file\n");
+		goto err_nosysfs2;
+	}
+
+	ret = device_create_file(&hdev->dev, &dev_attr_master_bdaddr);
+	if (ret) {
+		hid_err(hdev, "failed to create master_bdaddr sysfs file\n");
+		goto err_nosysfs1;
 	}
 
 	if (sc->quirks & SIXAXIS_CONTROLLER_USB) {
@@ -1932,13 +2120,17 @@ static int sony_probe(struct hid_device
 err_close:
 	hid_hw_close(hdev);
 err_stop:
+	device_remove_file(&hdev->dev, &dev_attr_master_bdaddr);
+err_nosysfs1:
+	device_remove_file(&hdev->dev, &dev_attr_gamepad_number);
+err_nosysfs2:
 	if (sc->quirks & SONY_LED_SUPPORT)
 		sony_leds_remove(sc);
 	if (sc->quirks & SONY_BATTERY_SUPPORT)
 		sony_battery_remove(sc);
 	sony_cancel_work_sync(sc);
 	sony_remove_dev_list(sc);
-	sony_release_device_id(sc);
+	sony_release_gamepad_number(sc);
 	hid_hw_stop(hdev);
 	return ret;
 }
@@ -1959,7 +2151,11 @@ static void sony_remove(struct hid_devic
 
 	sony_remove_dev_list(sc);
 
-	sony_release_device_id(sc);
+	device_remove_file(&hdev->dev, &dev_attr_master_bdaddr);
+
+	device_remove_file(&hdev->dev, &dev_attr_gamepad_number);
+
+	sony_release_gamepad_number(sc);
 
 	hid_hw_stop(hdev);
 }
@@ -2017,7 +2213,7 @@ static void __exit sony_exit(void)
 {
 	dbg_hid("Sony:%s\n", __func__);
 
-	ida_destroy(&sony_device_id_allocator);
+	ida_destroy(&sony_gamepad_number_allocator);
 	hid_unregister_driver(&sony_driver);
 }
 module_init(sony_init);
