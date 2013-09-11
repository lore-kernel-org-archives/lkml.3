Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab3IKUMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:12:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26674 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757459Ab3IKUMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:12:34 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] HID: lenovo-tpkbd: remove usb dependency
Date: Wed, 11 Sep 2013 22:12:24 +0200
Message-Id: <1378930345-6670-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1378930345-6670-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1378930345-6670-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lenovo tpkbd currently relies on the usb interface number to detect
if it is dealing with the touchpad interface or not.
As the report descriptors of the interface 0 does not contain the
button 3, we can use this to remove the need to check for usb.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

I am not 100% happy with the trick required to differenciate the 2 interfaces.
It is working, but I don't really like setting "hid_set_drvdata(hdev, (void *)1);"
to avoid a kzalloc (and some more indirections later in the led part).

Any comments welcome :)

Cheers,
Benjamin

 drivers/hid/Kconfig            |  2 +-
 drivers/hid/hid-lenovo-tpkbd.c | 20 ++++++--------------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 3d7c9f6..4b70800 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -322,7 +322,7 @@ config HID_LCPOWER
 
 config HID_LENOVO_TPKBD
 	tristate "Lenovo ThinkPad USB Keyboard with TrackPoint"
-	depends on USB_HID
+	depends on HID
 	select NEW_LEDS
 	select LEDS_CLASS
 	---help---
diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index 0d9a276..2d25b6c 100644
--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -14,11 +14,9 @@
 #include <linux/module.h>
 #include <linux/sysfs.h>
 #include <linux/device.h>
-#include <linux/usb.h>
 #include <linux/hid.h>
 #include <linux/input.h>
 #include <linux/leds.h>
-#include "usbhid/usbhid.h"
 
 #include "hid-ids.h"
 
@@ -41,10 +39,9 @@ static int tpkbd_input_mapping(struct hid_device *hdev,
 		struct hid_input *hi, struct hid_field *field,
 		struct hid_usage *usage, unsigned long **bit, int *max)
 {
-	struct usbhid_device *uhdev;
-
-	uhdev = (struct usbhid_device *) hdev->driver_data;
-	if (uhdev->ifnum == 1 && usage->hid == (HID_UP_BUTTON | 0x0010)) {
+	if (usage->hid == (HID_UP_BUTTON | 0x0010)) {
+		/* mark the device as pointer */
+		hid_set_drvdata(hdev, (void *)1);
 		map_key_clear(KEY_MICMUTE);
 		return 1;
 	}
@@ -398,7 +395,6 @@ static int tpkbd_probe(struct hid_device *hdev,
 		const struct hid_device_id *id)
 {
 	int ret;
-	struct usbhid_device *uhdev;
 
 	ret = hid_parse(hdev);
 	if (ret) {
@@ -412,9 +408,8 @@ static int tpkbd_probe(struct hid_device *hdev,
 		goto err;
 	}
 
-	uhdev = (struct usbhid_device *) hdev->driver_data;
-
-	if (uhdev->ifnum == 1) {
+	if (hid_get_drvdata(hdev)) {
+		hid_set_drvdata(hdev, NULL);
 		ret = tpkbd_probe_tp(hdev);
 		if (ret)
 			goto err_hid;
@@ -442,10 +437,7 @@ static void tpkbd_remove_tp(struct hid_device *hdev)
 
 static void tpkbd_remove(struct hid_device *hdev)
 {
-	struct usbhid_device *uhdev;
-
-	uhdev = (struct usbhid_device *) hdev->driver_data;
-	if (uhdev->ifnum == 1)
+	if (hid_get_drvdata(hdev))
 		tpkbd_remove_tp(hdev);
 
 	hid_hw_stop(hdev);
-- 
1.8.3.1

