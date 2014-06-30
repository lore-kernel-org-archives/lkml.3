Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbaF3V3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:29:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754239AbaF3V0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:49 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 06/15] Input - wacom: install LED/OLED sysfs files in the HID device instead of USB
Date: Mon, 30 Jun 2014 17:26:17 -0400
Message-Id: <1404163586-29582-7-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes one more dependency over USB, but requires some changes in
the user space to find the sysfs files correctly.

This patch breaks the user space. However, the number of program
accessing the LEDs is quite limited and we can easily patch them
to handle the new HID behavior.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_sys.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 3f1cee6..6f4bf6d 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -675,7 +675,7 @@ out:
 static ssize_t wacom_led_select_store(struct device *dev, int set_id,
 				      const char *buf, size_t count)
 {
-	struct hid_device *hdev = dev_get_drvdata(dev);
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	unsigned int id;
 	int err;
@@ -703,7 +703,7 @@ static ssize_t wacom_led##SET_ID##_select_store(struct device *dev,	\
 static ssize_t wacom_led##SET_ID##_select_show(struct device *dev,	\
 	struct device_attribute *attr, char *buf)			\
 {									\
-	struct hid_device *hdev = dev_get_drvdata(dev);			\
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);\
 	struct wacom *wacom = hid_get_drvdata(hdev);			\
 	return snprintf(buf, 2, "%d\n", wacom->led.select[SET_ID]);	\
 }									\
@@ -738,7 +738,7 @@ static ssize_t wacom_luminance_store(struct wacom *wacom, u8 *dest,
 static ssize_t wacom_##name##_luminance_store(struct device *dev,	\
 	struct device_attribute *attr, const char *buf, size_t count)	\
 {									\
-	struct hid_device *hdev = dev_get_drvdata(dev);			\
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);\
 	struct wacom *wacom = hid_get_drvdata(hdev);			\
 									\
 	return wacom_luminance_store(wacom, &wacom->led.field,		\
@@ -754,7 +754,7 @@ DEVICE_LUMINANCE_ATTR(buttons, img_lum);
 static ssize_t wacom_button_image_store(struct device *dev, int button_id,
 					const char *buf, size_t count)
 {
-	struct hid_device *hdev = dev_get_drvdata(dev);
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
 	struct wacom *wacom = hid_get_drvdata(hdev);
 	int err;
 
@@ -845,7 +845,7 @@ static int wacom_initialize_leds(struct wacom *wacom)
 		wacom->led.llv = 10;
 		wacom->led.hlv = 20;
 		wacom->led.img_lum = 10;
-		error = sysfs_create_group(&wacom->intf->dev.kobj,
+		error = sysfs_create_group(&wacom->hdev->dev.kobj,
 					   &intuos4_led_attr_group);
 		break;
 
@@ -857,7 +857,7 @@ static int wacom_initialize_leds(struct wacom *wacom)
 		wacom->led.hlv = 0;
 		wacom->led.img_lum = 0;
 
-		error = sysfs_create_group(&wacom->intf->dev.kobj,
+		error = sysfs_create_group(&wacom->hdev->dev.kobj,
 					   &cintiq_led_attr_group);
 		break;
 
@@ -874,7 +874,7 @@ static int wacom_initialize_leds(struct wacom *wacom)
 			wacom->led.hlv = 0;
 			wacom->led.img_lum = 0;
 
-			error = sysfs_create_group(&wacom->intf->dev.kobj,
+			error = sysfs_create_group(&wacom->hdev->dev.kobj,
 						  &intuos5_led_attr_group);
 		} else
 			return 0;
@@ -885,7 +885,7 @@ static int wacom_initialize_leds(struct wacom *wacom)
 	}
 
 	if (error) {
-		dev_err(&wacom->intf->dev,
+		hid_err(wacom->hdev,
 			"cannot create sysfs group err: %d\n", error);
 		return error;
 	}
@@ -906,13 +906,13 @@ static void wacom_destroy_leds(struct wacom *wacom)
 	case INTUOS4S:
 	case INTUOS4:
 	case INTUOS4L:
-		sysfs_remove_group(&wacom->intf->dev.kobj,
+		sysfs_remove_group(&wacom->hdev->dev.kobj,
 				   &intuos4_led_attr_group);
 		break;
 
 	case WACOM_24HD:
 	case WACOM_21UX2:
-		sysfs_remove_group(&wacom->intf->dev.kobj,
+		sysfs_remove_group(&wacom->hdev->dev.kobj,
 				   &cintiq_led_attr_group);
 		break;
 
@@ -923,7 +923,7 @@ static void wacom_destroy_leds(struct wacom *wacom)
 	case INTUOSPM:
 	case INTUOSPL:
 		if (wacom->wacom_wac.features.device_type == BTN_TOOL_PEN)
-			sysfs_remove_group(&wacom->intf->dev.kobj,
+			sysfs_remove_group(&wacom->hdev->dev.kobj,
 					   &intuos5_led_attr_group);
 		break;
 	}
-- 
2.0.0

