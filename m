Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab3J1Rwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:52:35 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:54092 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206Ab3J1RwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:52:09 -0400
X-Greylist: Passed host: 88.66.243.220
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net A46421AB52F
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
Subject: [PATCH 2/3] HID: roccat: Generalized some common code
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Stefan Achatz <erazor_de@users.sourceforge.net>,
        Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Oct 2013 18:52:05 +0100
Message-ID: <1382982725.2453.10.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduced some duplicate code by moving it to hid-roccat-common.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-common.c   |   53 ++++++++++++
 drivers/hid/hid-roccat-common.h   |   62 ++++++++++++++
 drivers/hid/hid-roccat-konepure.c |  158 +++++++++----------------------------
 drivers/hid/hid-roccat-konepure.h |   72 -----------------
 drivers/hid/hid-roccat-savu.c     |  123 ++++-------------------------
 drivers/hid/hid-roccat-savu.h     |   32 --------
 6 files changed, 167 insertions(+), 333 deletions(-)
 delete mode 100644 drivers/hid/hid-roccat-konepure.h

diff --git a/drivers/hid/hid-roccat-common.c b/drivers/hid/hid-roccat-common.c
index e840899..02e28e9 100644
--- a/drivers/hid/hid-roccat-common.c
+++ b/drivers/hid/hid-roccat-common.c
@@ -122,6 +122,59 @@ int roccat_common2_send_with_status(struct usb_device *usb_dev,
 }
 EXPORT_SYMBOL_GPL(roccat_common2_send_with_status);
 
+int roccat_common2_device_init_struct(struct usb_device *usb_dev,
+		struct roccat_common2_device *dev)
+{
+	mutex_init(&dev->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(roccat_common2_device_init_struct);
+
+ssize_t roccat_common2_sysfs_read(struct file *fp, struct kobject *kobj,
+		char *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct roccat_common2_device *roccat_dev = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off >= real_size)
+		return 0;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&roccat_dev->lock);
+	retval = roccat_common2_receive(usb_dev, command, buf, real_size);
+	mutex_unlock(&roccat_dev->lock);
+
+	return retval ? retval : real_size;
+}
+EXPORT_SYMBOL_GPL(roccat_common2_sysfs_read);
+
+ssize_t roccat_common2_sysfs_write(struct file *fp, struct kobject *kobj,
+		void const *buf, loff_t off, size_t count,
+		size_t real_size, uint command)
+{
+	struct device *dev =
+			container_of(kobj, struct device, kobj)->parent->parent;
+	struct roccat_common2_device *roccat_dev = hid_get_drvdata(dev_get_drvdata(dev));
+	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
+	int retval;
+
+	if (off != 0 || count != real_size)
+		return -EINVAL;
+
+	mutex_lock(&roccat_dev->lock);
+	retval = roccat_common2_send_with_status(usb_dev, command, buf, real_size);
+	mutex_unlock(&roccat_dev->lock);
+
+	return retval ? retval : real_size;
+}
+EXPORT_SYMBOL_GPL(roccat_common2_sysfs_write);
+
 MODULE_AUTHOR("Stefan Achatz");
 MODULE_DESCRIPTION("USB Roccat common driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/hid/hid-roccat-common.h b/drivers/hid/hid-roccat-common.h
index a97746a..eaa56eb 100644
--- a/drivers/hid/hid-roccat-common.h
+++ b/drivers/hid/hid-roccat-common.h
@@ -32,4 +32,66 @@ int roccat_common2_send(struct usb_device *usb_dev, uint report_id,
 int roccat_common2_send_with_status(struct usb_device *usb_dev,
 		uint command, void const *buf, uint size);
 
+struct roccat_common2_device {
+	int roccat_claimed;
+	int chrdev_minor;
+	struct mutex lock;
+};
+
+int roccat_common2_device_init_struct(struct usb_device *usb_dev,
+		struct roccat_common2_device *dev);
+ssize_t roccat_common2_sysfs_read(struct file *fp, struct kobject *kobj,
+		char *buf, loff_t off, size_t count,
+		size_t real_size, uint command);
+ssize_t roccat_common2_sysfs_write(struct file *fp, struct kobject *kobj,
+		void const *buf, loff_t off, size_t count,
+		size_t real_size, uint command);
+
+#define ROCCAT_COMMON2_SYSFS_W(thingy, COMMAND, SIZE) \
+static ssize_t roccat_common2_sysfs_write_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return roccat_common2_sysfs_write(fp, kobj, buf, off, count, \
+			SIZE, COMMAND); \
+}
+
+#define ROCCAT_COMMON2_SYSFS_R(thingy, COMMAND, SIZE) \
+static ssize_t roccat_common2_sysfs_read_ ## thingy(struct file *fp, \
+		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
+		loff_t off, size_t count) \
+{ \
+	return roccat_common2_sysfs_read(fp, kobj, buf, off, count, \
+			SIZE, COMMAND); \
+}
+
+#define ROCCAT_COMMON2_SYSFS_RW(thingy, COMMAND, SIZE) \
+ROCCAT_COMMON2_SYSFS_W(thingy, COMMAND, SIZE) \
+ROCCAT_COMMON2_SYSFS_R(thingy, COMMAND, SIZE)
+
+#define ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(thingy, COMMAND, SIZE) \
+ROCCAT_COMMON2_SYSFS_RW(thingy, COMMAND, SIZE); \
+static struct bin_attribute bin_attr_ ## thingy = { \
+	.attr = { .name = #thingy, .mode = 0660 }, \
+	.size = SIZE, \
+	.read = roccat_common2_sysfs_read_ ## thingy, \
+	.write = roccat_common2_sysfs_write_ ## thingy \
+}
+
+#define ROCCAT_COMMON2_BIN_ATTRIBUTE_R(thingy, COMMAND, SIZE) \
+ROCCAT_COMMON2_SYSFS_R(thingy, COMMAND, SIZE); \
+static struct bin_attribute bin_attr_ ## thingy = { \
+	.attr = { .name = #thingy, .mode = 0440 }, \
+	.size = SIZE, \
+	.read = roccat_common2_sysfs_read_ ## thingy, \
+}
+
+#define ROCCAT_COMMON2_BIN_ATTRIBUTE_W(thingy, COMMAND, SIZE) \
+ROCCAT_COMMON2_SYSFS_W(thingy, COMMAND, SIZE); \
+static struct bin_attribute bin_attr_ ## thingy = { \
+	.attr = { .name = #thingy, .mode = 0220 }, \
+	.size = SIZE, \
+	.write = roccat_common2_sysfs_write_ ## thingy \
+}
+
 #endif
diff --git a/drivers/hid/hid-roccat-konepure.c b/drivers/hid/hid-roccat-konepure.c
index 99a605e..07de2f9 100644
--- a/drivers/hid/hid-roccat-konepure.c
+++ b/drivers/hid/hid-roccat-konepure.c
@@ -15,6 +15,7 @@
  * Roccat KonePure is a smaller version of KoneXTD with less buttons and lights.
  */
 
+#include <linux/types.h>
 #include <linux/device.h>
 #include <linux/input.h>
 #include <linux/hid.h>
@@ -23,128 +24,50 @@
 #include <linux/hid-roccat.h>
 #include "hid-ids.h"
 #include "hid-roccat-common.h"
-#include "hid-roccat-konepure.h"
 
-static struct class *konepure_class;
-
-static ssize_t konepure_sysfs_read(struct file *fp, struct kobject *kobj,
-		char *buf, loff_t off, size_t count,
-		size_t real_size, uint command)
-{
-	struct device *dev =
-			container_of(kobj, struct device, kobj)->parent->parent;
-	struct konepure_device *konepure = hid_get_drvdata(dev_get_drvdata(dev));
-	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval;
-
-	if (off >= real_size)
-		return 0;
-
-	if (off != 0 || count != real_size)
-		return -EINVAL;
-
-	mutex_lock(&konepure->konepure_lock);
-	retval = roccat_common2_receive(usb_dev, command, buf, real_size);
-	mutex_unlock(&konepure->konepure_lock);
-
-	return retval ? retval : real_size;
-}
-
-static ssize_t konepure_sysfs_write(struct file *fp, struct kobject *kobj,
-		void const *buf, loff_t off, size_t count,
-		size_t real_size, uint command)
-{
-	struct device *dev =
-			container_of(kobj, struct device, kobj)->parent->parent;
-	struct konepure_device *konepure = hid_get_drvdata(dev_get_drvdata(dev));
-	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval;
-
-	if (off != 0 || count != real_size)
-		return -EINVAL;
-
-	mutex_lock(&konepure->konepure_lock);
-	retval = roccat_common2_send_with_status(usb_dev, command,
-			(void *)buf, real_size);
-	mutex_unlock(&konepure->konepure_lock);
-
-	return retval ? retval : real_size;
-}
-
-#define KONEPURE_SYSFS_W(thingy, THINGY) \
-static ssize_t konepure_sysfs_write_ ## thingy(struct file *fp, \
-		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
-		loff_t off, size_t count) \
-{ \
-	return konepure_sysfs_write(fp, kobj, buf, off, count, \
-			KONEPURE_SIZE_ ## THINGY, KONEPURE_COMMAND_ ## THINGY); \
-}
-
-#define KONEPURE_SYSFS_R(thingy, THINGY) \
-static ssize_t konepure_sysfs_read_ ## thingy(struct file *fp, \
-		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
-		loff_t off, size_t count) \
-{ \
-	return konepure_sysfs_read(fp, kobj, buf, off, count, \
-			KONEPURE_SIZE_ ## THINGY, KONEPURE_COMMAND_ ## THINGY); \
-}
+enum {
+	KONEPURE_MOUSE_REPORT_NUMBER_BUTTON = 3,
+};
 
-#define KONEPURE_SYSFS_RW(thingy, THINGY) \
-KONEPURE_SYSFS_W(thingy, THINGY) \
-KONEPURE_SYSFS_R(thingy, THINGY)
-
-#define KONEPURE_BIN_ATTRIBUTE_RW(thingy, THINGY) \
-KONEPURE_SYSFS_RW(thingy, THINGY); \
-static struct bin_attribute bin_attr_##thingy = { \
-	.attr = { .name = #thingy, .mode = 0660 }, \
-	.size = KONEPURE_SIZE_ ## THINGY, \
-	.read = konepure_sysfs_read_ ## thingy, \
-	.write = konepure_sysfs_write_ ## thingy \
-}
+struct konepure_mouse_report_button {
+	uint8_t report_number; /* always KONEPURE_MOUSE_REPORT_NUMBER_BUTTON */
+	uint8_t zero;
+	uint8_t type;
+	uint8_t data1;
+	uint8_t data2;
+	uint8_t zero2;
+	uint8_t unknown[2];
+} __packed;
 
-#define KONEPURE_BIN_ATTRIBUTE_R(thingy, THINGY) \
-KONEPURE_SYSFS_R(thingy, THINGY); \
-static struct bin_attribute bin_attr_##thingy = { \
-	.attr = { .name = #thingy, .mode = 0440 }, \
-	.size = KONEPURE_SIZE_ ## THINGY, \
-	.read = konepure_sysfs_read_ ## thingy, \
-}
-
-#define KONEPURE_BIN_ATTRIBUTE_W(thingy, THINGY) \
-KONEPURE_SYSFS_W(thingy, THINGY); \
-static struct bin_attribute bin_attr_##thingy = { \
-	.attr = { .name = #thingy, .mode = 0220 }, \
-	.size = KONEPURE_SIZE_ ## THINGY, \
-	.write = konepure_sysfs_write_ ## thingy \
-}
+static struct class *konepure_class;
 
-KONEPURE_BIN_ATTRIBUTE_RW(actual_profile, ACTUAL_PROFILE);
-KONEPURE_BIN_ATTRIBUTE_RW(info, INFO);
-KONEPURE_BIN_ATTRIBUTE_RW(sensor, SENSOR);
-KONEPURE_BIN_ATTRIBUTE_RW(tcu, TCU);
-KONEPURE_BIN_ATTRIBUTE_RW(profile_settings, PROFILE_SETTINGS);
-KONEPURE_BIN_ATTRIBUTE_RW(profile_buttons, PROFILE_BUTTONS);
-KONEPURE_BIN_ATTRIBUTE_W(control, CONTROL);
-KONEPURE_BIN_ATTRIBUTE_W(talk, TALK);
-KONEPURE_BIN_ATTRIBUTE_W(macro, MACRO);
-KONEPURE_BIN_ATTRIBUTE_R(tcu_image, TCU_IMAGE);
-
-static struct bin_attribute *konepure_bin_attributes[] = {
+ROCCAT_COMMON2_BIN_ATTRIBUTE_W(control, 0x04, 0x03);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(actual_profile, 0x05, 0x03);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(profile_settings, 0x06, 0x1f);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(profile_buttons, 0x07, 0x3b);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_W(macro, 0x08, 0x0822);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(info, 0x09, 0x06);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(tcu, 0x0c, 0x04);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_R(tcu_image, 0x0c, 0x0404);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(sensor, 0x0f, 0x06);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_W(talk, 0x10, 0x10);
+
+static struct bin_attribute *konepure_bin_attrs[] = {
 	&bin_attr_actual_profile,
+	&bin_attr_control,
 	&bin_attr_info,
+	&bin_attr_talk,
+	&bin_attr_macro,
 	&bin_attr_sensor,
 	&bin_attr_tcu,
+	&bin_attr_tcu_image,
 	&bin_attr_profile_settings,
 	&bin_attr_profile_buttons,
-	&bin_attr_control,
-	&bin_attr_talk,
-	&bin_attr_macro,
-	&bin_attr_tcu_image,
 	NULL,
 };
 
 static const struct attribute_group konepure_group = {
-	.bin_attrs = konepure_bin_attributes,
+	.bin_attrs = konepure_bin_attrs,
 };
 
 static const struct attribute_group *konepure_groups[] = {
@@ -152,20 +75,11 @@ static const struct attribute_group *konepure_groups[] = {
 	NULL,
 };
 
-
-static int konepure_init_konepure_device_struct(struct usb_device *usb_dev,
-		struct konepure_device *konepure)
-{
-	mutex_init(&konepure->konepure_lock);
-
-	return 0;
-}
-
 static int konepure_init_specials(struct hid_device *hdev)
 {
 	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
-	struct konepure_device *konepure;
+	struct roccat_common2_device *konepure;
 	int retval;
 
 	if (intf->cur_altsetting->desc.bInterfaceProtocol
@@ -181,9 +95,9 @@ static int konepure_init_specials(struct hid_device *hdev)
 	}
 	hid_set_drvdata(hdev, konepure);
 
-	retval = konepure_init_konepure_device_struct(usb_dev, konepure);
+	retval = roccat_common2_device_init_struct(usb_dev, konepure);
 	if (retval) {
-		hid_err(hdev, "couldn't init struct konepure_device\n");
+		hid_err(hdev, "couldn't init KonePure device\n");
 		goto exit_free;
 	}
 
@@ -205,7 +119,7 @@ exit_free:
 static void konepure_remove_specials(struct hid_device *hdev)
 {
 	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	struct konepure_device *konepure;
+	struct roccat_common2_device *konepure;
 
 	if (intf->cur_altsetting->desc.bInterfaceProtocol
 			!= USB_INTERFACE_PROTOCOL_MOUSE)
@@ -258,7 +172,7 @@ static int konepure_raw_event(struct hid_device *hdev,
 		struct hid_report *report, u8 *data, int size)
 {
 	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	struct konepure_device *konepure = hid_get_drvdata(hdev);
+	struct roccat_common2_device *konepure = hid_get_drvdata(hdev);
 
 	if (intf->cur_altsetting->desc.bInterfaceProtocol
 			!= USB_INTERFACE_PROTOCOL_MOUSE)
diff --git a/drivers/hid/hid-roccat-konepure.h b/drivers/hid/hid-roccat-konepure.h
deleted file mode 100644
index 2cd24e9..0000000
--- a/drivers/hid/hid-roccat-konepure.h
+++ /dev/null
@@ -1,72 +0,0 @@
-#ifndef __HID_ROCCAT_KONEPURE_H
-#define __HID_ROCCAT_KONEPURE_H
-
-/*
- * Copyright (c) 2012 Stefan Achatz <erazor_de@users.sourceforge.net>
- */
-
-/*
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- */
-
-#include <linux/types.h>
-
-enum {
-	KONEPURE_SIZE_ACTUAL_PROFILE = 0x03,
-	KONEPURE_SIZE_CONTROL = 0x03,
-	KONEPURE_SIZE_FIRMWARE_WRITE = 0x0402,
-	KONEPURE_SIZE_INFO = 0x06,
-	KONEPURE_SIZE_MACRO = 0x0822,
-	KONEPURE_SIZE_PROFILE_SETTINGS = 0x1f,
-	KONEPURE_SIZE_PROFILE_BUTTONS = 0x3b,
-	KONEPURE_SIZE_SENSOR = 0x06,
-	KONEPURE_SIZE_TALK = 0x10,
-	KONEPURE_SIZE_TCU = 0x04,
-	KONEPURE_SIZE_TCU_IMAGE = 0x0404,
-};
-
-enum konepure_control_requests {
-	KONEPURE_CONTROL_REQUEST_GENERAL = 0x80,
-	KONEPURE_CONTROL_REQUEST_BUTTONS = 0x90,
-};
-
-enum konepure_commands {
-	KONEPURE_COMMAND_CONTROL = 0x04,
-	KONEPURE_COMMAND_ACTUAL_PROFILE = 0x05,
-	KONEPURE_COMMAND_PROFILE_SETTINGS = 0x06,
-	KONEPURE_COMMAND_PROFILE_BUTTONS = 0x07,
-	KONEPURE_COMMAND_MACRO = 0x08,
-	KONEPURE_COMMAND_INFO = 0x09,
-	KONEPURE_COMMAND_TCU = 0x0c,
-	KONEPURE_COMMAND_TCU_IMAGE = 0x0c,
-	KONEPURE_COMMAND_E = 0x0e,
-	KONEPURE_COMMAND_SENSOR = 0x0f,
-	KONEPURE_COMMAND_TALK = 0x10,
-	KONEPURE_COMMAND_FIRMWARE_WRITE = 0x1b,
-	KONEPURE_COMMAND_FIRMWARE_WRITE_CONTROL = 0x1c,
-};
-
-enum {
-	KONEPURE_MOUSE_REPORT_NUMBER_BUTTON = 3,
-};
-
-struct konepure_mouse_report_button {
-	uint8_t report_number; /* always KONEPURE_MOUSE_REPORT_NUMBER_BUTTON */
-	uint8_t zero;
-	uint8_t type;
-	uint8_t data1;
-	uint8_t data2;
-	uint8_t zero2;
-	uint8_t unknown[2];
-} __packed;
-
-struct konepure_device {
-	int roccat_claimed;
-	int chrdev_minor;
-	struct mutex konepure_lock;
-};
-
-#endif
diff --git a/drivers/hid/hid-roccat-savu.c b/drivers/hid/hid-roccat-savu.c
index 0332267..6dbf6e0 100644
--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -27,98 +27,15 @@
 
 static struct class *savu_class;
 
-static ssize_t savu_sysfs_read(struct file *fp, struct kobject *kobj,
-		char *buf, loff_t off, size_t count,
-		size_t real_size, uint command)
-{
-	struct device *dev =
-			container_of(kobj, struct device, kobj)->parent->parent;
-	struct savu_device *savu = hid_get_drvdata(dev_get_drvdata(dev));
-	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval;
-
-	if (off >= real_size)
-		return 0;
-
-	if (off != 0 || count != real_size)
-		return -EINVAL;
-
-	mutex_lock(&savu->savu_lock);
-	retval = roccat_common2_receive(usb_dev, command, buf, real_size);
-	mutex_unlock(&savu->savu_lock);
-
-	return retval ? retval : real_size;
-}
-
-static ssize_t savu_sysfs_write(struct file *fp, struct kobject *kobj,
-		void const *buf, loff_t off, size_t count,
-		size_t real_size, uint command)
-{
-	struct device *dev =
-			container_of(kobj, struct device, kobj)->parent->parent;
-	struct savu_device *savu = hid_get_drvdata(dev_get_drvdata(dev));
-	struct usb_device *usb_dev = interface_to_usbdev(to_usb_interface(dev));
-	int retval;
-
-	if (off != 0 || count != real_size)
-		return -EINVAL;
-
-	mutex_lock(&savu->savu_lock);
-	retval = roccat_common2_send_with_status(usb_dev, command,
-			(void *)buf, real_size);
-	mutex_unlock(&savu->savu_lock);
-
-	return retval ? retval : real_size;
-}
-
-#define SAVU_SYSFS_W(thingy, THINGY) \
-static ssize_t savu_sysfs_write_ ## thingy(struct file *fp, \
-		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
-		loff_t off, size_t count) \
-{ \
-	return savu_sysfs_write(fp, kobj, buf, off, count, \
-			SAVU_SIZE_ ## THINGY, SAVU_COMMAND_ ## THINGY); \
-}
-
-#define SAVU_SYSFS_R(thingy, THINGY) \
-static ssize_t savu_sysfs_read_ ## thingy(struct file *fp, \
-		struct kobject *kobj, struct bin_attribute *attr, char *buf, \
-		loff_t off, size_t count) \
-{ \
-	return savu_sysfs_read(fp, kobj, buf, off, count, \
-			SAVU_SIZE_ ## THINGY, SAVU_COMMAND_ ## THINGY); \
-}
-
-#define SAVU_SYSFS_RW(thingy, THINGY) \
-SAVU_SYSFS_W(thingy, THINGY) \
-SAVU_SYSFS_R(thingy, THINGY)
-
-#define SAVU_BIN_ATTRIBUTE_RW(thingy, THINGY) \
-SAVU_SYSFS_RW(thingy, THINGY); \
-static struct bin_attribute bin_attr_##thingy = { \
-	.attr = { .name = #thingy, .mode = 0660 }, \
-	.size = SAVU_SIZE_ ## THINGY, \
-	.read = savu_sysfs_read_ ## thingy, \
-	.write = savu_sysfs_write_ ## thingy \
-}
-
-#define SAVU_BIN_ATTRIBUTE_W(thingy, THINGY) \
-SAVU_SYSFS_W(thingy, THINGY); \
-static struct bin_attribute bin_attr_##thingy = { \
-	.attr = { .name = #thingy, .mode = 0220 }, \
-	.size = SAVU_SIZE_ ## THINGY, \
-	.write = savu_sysfs_write_ ## thingy \
-}
-
-SAVU_BIN_ATTRIBUTE_W(control, CONTROL);
-SAVU_BIN_ATTRIBUTE_RW(profile, PROFILE);
-SAVU_BIN_ATTRIBUTE_RW(general, GENERAL);
-SAVU_BIN_ATTRIBUTE_RW(buttons, BUTTONS);
-SAVU_BIN_ATTRIBUTE_RW(macro, MACRO);
-SAVU_BIN_ATTRIBUTE_RW(info, INFO);
-SAVU_BIN_ATTRIBUTE_RW(sensor, SENSOR);
-
-static struct bin_attribute *savu_bin_attributes[] = {
+ROCCAT_COMMON2_BIN_ATTRIBUTE_W(control, 0x4, 0x03);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(profile, 0x5, 0x03);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(general, 0x6, 0x10);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(buttons, 0x7, 0x2f);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(macro, 0x8, 0x0823);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(info, 0x9, 0x08);
+ROCCAT_COMMON2_BIN_ATTRIBUTE_RW(sensor, 0xc, 0x04);
+
+static struct bin_attribute *savu_bin_attrs[] = {
 	&bin_attr_control,
 	&bin_attr_profile,
 	&bin_attr_general,
@@ -130,7 +47,7 @@ static struct bin_attribute *savu_bin_attributes[] = {
 };
 
 static const struct attribute_group savu_group = {
-	.bin_attrs = savu_bin_attributes,
+	.bin_attrs = savu_bin_attrs,
 };
 
 static const struct attribute_group *savu_groups[] = {
@@ -138,19 +55,11 @@ static const struct attribute_group *savu_groups[] = {
 	NULL,
 };
 
-static int savu_init_savu_device_struct(struct usb_device *usb_dev,
-		struct savu_device *savu)
-{
-	mutex_init(&savu->savu_lock);
-
-	return 0;
-}
-
 static int savu_init_specials(struct hid_device *hdev)
 {
 	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
-	struct savu_device *savu;
+	struct roccat_common2_device *savu;
 	int retval;
 
 	if (intf->cur_altsetting->desc.bInterfaceProtocol
@@ -166,9 +75,9 @@ static int savu_init_specials(struct hid_device *hdev)
 	}
 	hid_set_drvdata(hdev, savu);
 
-	retval = savu_init_savu_device_struct(usb_dev, savu);
+	retval = roccat_common2_device_init_struct(usb_dev, savu);
 	if (retval) {
-		hid_err(hdev, "couldn't init struct savu_device\n");
+		hid_err(hdev, "couldn't init Savu device\n");
 		goto exit_free;
 	}
 
@@ -190,7 +99,7 @@ exit_free:
 static void savu_remove_specials(struct hid_device *hdev)
 {
 	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	struct savu_device *savu;
+	struct roccat_common2_device *savu;
 
 	if (intf->cur_altsetting->desc.bInterfaceProtocol
 			!= USB_INTERFACE_PROTOCOL_MOUSE)
@@ -239,7 +148,7 @@ static void savu_remove(struct hid_device *hdev)
 	hid_hw_stop(hdev);
 }
 
-static void savu_report_to_chrdev(struct savu_device const *savu,
+static void savu_report_to_chrdev(struct roccat_common2_device const *savu,
 		u8 const *data)
 {
 	struct savu_roccat_report roccat_report;
@@ -261,7 +170,7 @@ static int savu_raw_event(struct hid_device *hdev,
 		struct hid_report *report, u8 *data, int size)
 {
 	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	struct savu_device *savu = hid_get_drvdata(hdev);
+	struct roccat_common2_device *savu = hid_get_drvdata(hdev);
 
 	if (intf->cur_altsetting->desc.bInterfaceProtocol
 			!= USB_INTERFACE_PROTOCOL_MOUSE)
diff --git a/drivers/hid/hid-roccat-savu.h b/drivers/hid/hid-roccat-savu.h
index 9120ba7..d23217b 100644
--- a/drivers/hid/hid-roccat-savu.h
+++ b/drivers/hid/hid-roccat-savu.h
@@ -14,31 +14,6 @@
 
 #include <linux/types.h>
 
-enum {
-	SAVU_SIZE_CONTROL = 0x03,
-	SAVU_SIZE_PROFILE = 0x03,
-	SAVU_SIZE_GENERAL = 0x10,
-	SAVU_SIZE_BUTTONS = 0x2f,
-	SAVU_SIZE_MACRO = 0x0823,
-	SAVU_SIZE_INFO = 0x08,
-	SAVU_SIZE_SENSOR = 0x04,
-};
-
-enum savu_control_requests {
-	SAVU_CONTROL_REQUEST_GENERAL = 0x80,
-	SAVU_CONTROL_REQUEST_BUTTONS = 0x90,
-};
-
-enum savu_commands {
-	SAVU_COMMAND_CONTROL = 0x4,
-	SAVU_COMMAND_PROFILE = 0x5,
-	SAVU_COMMAND_GENERAL = 0x6,
-	SAVU_COMMAND_BUTTONS = 0x7,
-	SAVU_COMMAND_MACRO = 0x8,
-	SAVU_COMMAND_INFO = 0x9,
-	SAVU_COMMAND_SENSOR = 0xc,
-};
-
 struct savu_mouse_report_special {
 	uint8_t report_number; /* always 3 */
 	uint8_t zero;
@@ -77,11 +52,4 @@ struct savu_roccat_report {
 	uint8_t data[2];
 } __packed;
 
-struct savu_device {
-	int roccat_claimed;
-	int chrdev_minor;
-
-	struct mutex savu_lock;
-};
-
 #endif
-- 
1.7.3.4



