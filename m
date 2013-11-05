Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab3KEDtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:49:01 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:61665 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab3KEDs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:48:57 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: azael.avalos@gmail.com
Subject: [PATCH 7/8] toshiba_acpi: Add touchpad enable/disable support
Date: Mon,  4 Nov 2013 20:48:44 -0700
Message-Id: <1383623325-4004-8-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
References: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiba laptops have two ways of enabling/disabling the
touchpad, one with a hardwired button on top of the touchpad
that simply emmits scancodes to let userspace know it has changed,
and another with a SCI call that triggers (on Windows drivers)
whenever the user press the Fn-F9 (touchpad toggle) hotkey.

This patch adds support to enable/disable the touchpad
by exposing the _touchpad_ file in sysfs.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 81 +++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 9c718eb..0e14e9c 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -120,6 +120,7 @@ MODULE_LICENSE("GPL");
 #define HCI_ACCELEROMETER2		0x00a6
 #define SCI_ILLUMINATION		0x014e
 #define SCI_KBD_ILLUM_STATUS		0x015c
+#define SCI_TOUCHPAD			0x050e
 
 /* field definitions */
 #define HCI_ACCEL_MASK			0x7fff
@@ -168,6 +169,7 @@ struct toshiba_acpi_dev {
 	unsigned int kbd_led_registered:1;
 	unsigned int eco_supported:1;
 	unsigned int accelerometer_supported:1;
+	unsigned int touchpad_supported:1;
 	unsigned int sysfs_created:1;
 
 	struct mutex mutex;
@@ -643,6 +645,47 @@ static int toshiba_accelerometer_get(struct toshiba_acpi_dev *dev,
 	return 0;
 }
 
+/* TouchPad support */
+static int toshiba_touchpad_set(struct toshiba_acpi_dev *dev, u32 state)
+{
+	u32 result;
+	acpi_status status;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	status = sci_write(dev, SCI_TOUCHPAD, state, &result);
+	sci_close(dev);
+	if (ACPI_FAILURE(status)) {
+		pr_err("ACPI call to set the touchpad failed\n");
+		return -EIO;
+	} else if (result == NOT_SUPPORTED) {
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int toshiba_touchpad_get(struct toshiba_acpi_dev *dev, u32 *state)
+{
+	u32 result;
+	acpi_status status;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	status = sci_read(dev, SCI_TOUCHPAD, state, &result);
+	sci_close(dev);
+	if (ACPI_FAILURE(status)) {
+		pr_err("ACPI call to query the touchpad failed\n");
+		return -EIO;
+	} else if (result == NOT_SUPPORTED) {
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 /* Bluetooth rfkill handlers */
 
 static u32 hci_get_bt_present(struct toshiba_acpi_dev *dev, bool *present)
@@ -1267,16 +1310,49 @@ static ssize_t toshiba_position_show(struct device *dev,
 	return sprintf(buf, "%d %d %d\n", x, y, z);
 }
 
+static ssize_t toshiba_touchpad_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	int state;
+
+	/* Set the TouchPad on/off, 0 - Disable | 1 - Enable */
+	if (sscanf(buf, "%i", &state) == 1 && (state == 0 || state == 1)) {
+		if (toshiba_touchpad_set(toshiba, state) < 0)
+			return -EIO;
+	}
+
+	return count;
+}
+
+static ssize_t toshiba_touchpad_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	u32 state;
+	int ret;
+
+	ret = toshiba_touchpad_get(toshiba, &state);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%i\n", state);
+}
+
 static DEVICE_ATTR(kbd_backlight_mode, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_mode_show, toshiba_kbd_bl_mode_store);
 static DEVICE_ATTR(kbd_backlight_timeout, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_timeout_show, toshiba_kbd_bl_timeout_store);
 static DEVICE_ATTR(position, S_IRUGO, toshiba_position_show, NULL);
+static DEVICE_ATTR(touchpad, S_IRUGO | S_IWUSR,
+		   toshiba_touchpad_show, toshiba_touchpad_store);
 
 static struct attribute *toshiba_attributes[] = {
 	&dev_attr_kbd_backlight_mode.attr,
 	&dev_attr_kbd_backlight_timeout.attr,
 	&dev_attr_position.attr,
+	&dev_attr_touchpad.attr,
 	NULL,
 };
 
@@ -1294,6 +1370,8 @@ static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 		exists = (driver->kbd_mode == SCI_KBD_MODE_AUTO) ? true : false;
 	else if (attr == &dev_attr_position.attr)
 		exists = (driver->accelerometer_supported) ? true : false;
+	else if (attr == &dev_attr_touchpad.attr)
+		exists = (driver->touchpad_supported) ? true : false;
 
 	return exists ? attr->mode : 0;
 }
@@ -1679,6 +1757,9 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 	ret = toshiba_accelerometer_supported(dev);
 	dev->accelerometer_supported = !ret;
 
+	ret = toshiba_touchpad_get(dev, &dummy);
+	dev->touchpad_supported = !ret;
+
 	/* Determine whether or not BIOS supports fan and video interfaces */
 
 	ret = get_video_status(dev, &dummy);
-- 
1.8.1.4

