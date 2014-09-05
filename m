Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbaIEROf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:14:35 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:39284 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaIEROb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:14:31 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 3/5] toshiba_acpi: Add accelerometer input polled device
Date: Fri,  5 Sep 2014 11:14:05 -0600
Message-Id: <1409937247-2525-4-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The accelerometer sensor is very sensitive, and having userspace
poll the sysfs position entry is not very battery friendly.

This patch removes the sysfs entry and instead, it creates an
input polled device (joystick) for the built-in accelerometer.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 109 +++++++++++++++++++++++++++---------
 1 file changed, 84 insertions(+), 25 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 4803e7b..ac1503c 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -50,6 +50,7 @@
 #include <linux/backlight.h>
 #include <linux/rfkill.h>
 #include <linux/input.h>
+#include <linux/input-polldev.h>
 #include <linux/input/sparse-keymap.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
@@ -124,6 +125,7 @@ MODULE_LICENSE("GPL");
 #define SCI_TOUCHPAD			0x050e
 
 /* field definitions */
+#define HCI_ACCEL_DIRECTION_MASK	0x8000
 #define HCI_ACCEL_MASK			0x7fff
 #define HCI_HOTKEY_DISABLE		0x0b
 #define HCI_HOTKEY_ENABLE		0x09
@@ -146,6 +148,7 @@ struct toshiba_acpi_dev {
 	const char *method_hci;
 	struct rfkill *bt_rfk;
 	struct input_dev *hotkey_dev;
+	struct input_polled_dev *ip_dev;
 	struct work_struct hotkey_work;
 	struct backlight_device *backlight_dev;
 	struct led_classdev led_dev;
@@ -170,6 +173,7 @@ struct toshiba_acpi_dev {
 	unsigned int touchpad_supported:1;
 	unsigned int eco_supported:1;
 	unsigned int accelerometer_supported:1;
+	unsigned int joystick_registered:1;
 	unsigned int sysfs_created:1;
 
 	struct mutex mutex;
@@ -1361,40 +1365,17 @@ static ssize_t toshiba_touchpad_show(struct device *dev,
 	return sprintf(buf, "%i\n", state);
 }
 
-static ssize_t toshiba_position_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
-{
-	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
-	u32 xyval, zval, tmp;
-	u16 x, y, z;
-	int ret;
-
-	xyval = zval = 0;
-	ret = toshiba_accelerometer_get(toshiba, &xyval, &zval);
-	if (ret < 0)
-		return ret;
-
-	x = xyval & HCI_ACCEL_MASK;
-	tmp = xyval >> HCI_MISC_SHIFT;
-	y = tmp & HCI_ACCEL_MASK;
-	z = zval & HCI_ACCEL_MASK;
-
-	return sprintf(buf, "%d %d %d\n", x, y, z);
-}
-
 static DEVICE_ATTR(kbd_backlight_mode, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_mode_show, toshiba_kbd_bl_mode_store);
 static DEVICE_ATTR(kbd_backlight_timeout, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_timeout_show, toshiba_kbd_bl_timeout_store);
 static DEVICE_ATTR(touchpad, S_IRUGO | S_IWUSR,
 		   toshiba_touchpad_show, toshiba_touchpad_store);
-static DEVICE_ATTR(position, S_IRUGO, toshiba_position_show, NULL);
 
 static struct attribute *toshiba_attributes[] = {
 	&dev_attr_kbd_backlight_mode.attr,
 	&dev_attr_kbd_backlight_timeout.attr,
 	&dev_attr_touchpad.attr,
-	&dev_attr_position.attr,
 	NULL,
 };
 
@@ -1411,8 +1392,6 @@ static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 		exists = (drv->kbd_mode == SCI_KBD_MODE_AUTO) ? true : false;
 	else if (attr == &dev_attr_touchpad.attr)
 		exists = (drv->touchpad_supported) ? true : false;
-	else if (attr == &dev_attr_position.attr)
-		exists = (drv->accelerometer_supported) ? true : false;
 
 	return exists ? attr->mode : 0;
 }
@@ -1621,6 +1600,75 @@ static int toshiba_acpi_setup_backlight(struct toshiba_acpi_dev *dev)
 	return 0;
 }
 
+static void toshiba_acpi_joystick_poll(struct input_polled_dev *ip_dev)
+{
+	struct toshiba_acpi_dev *dev = ip_dev->private;
+	u32 xy, zval;
+	int x, y, z;
+
+	mutex_lock(&dev->mutex);
+
+	if (toshiba_accelerometer_get(dev, &xy, &zval) < 0) {
+		pr_err("Could not get accelerometer axes");
+		mutex_unlock(&dev->mutex);
+		return;
+	}
+
+	/* Accelerometer values */
+	x = xy & HCI_ACCEL_MASK;
+	y = (xy >> HCI_MISC_SHIFT) & HCI_ACCEL_MASK;
+	z = zval & HCI_ACCEL_MASK;
+	/* Movement direction */
+	x *= xy & HCI_ACCEL_DIRECTION_MASK ? -1 : 1;
+	y *= (xy >> HCI_MISC_SHIFT) & HCI_ACCEL_DIRECTION_MASK ? -1 : 1;
+	z *= zval & HCI_ACCEL_DIRECTION_MASK ? -1 : 1;
+
+	input_report_abs(ip_dev->input, ABS_X, x);
+	input_report_abs(ip_dev->input, ABS_Y, y);
+	input_report_abs(ip_dev->input, ABS_Z, z);
+	input_sync(ip_dev->input);
+
+	mutex_unlock(&dev->mutex);
+}
+
+static int toshiba_acpi_setup_joystick(struct toshiba_acpi_dev *dev)
+{
+	struct input_dev *idev;
+	int ret;
+
+	if (dev->ip_dev)
+		return -EINVAL;
+
+	dev->ip_dev = input_allocate_polled_device();
+	if (!dev->ip_dev)
+		return -ENOMEM;
+
+	dev->ip_dev->poll = toshiba_acpi_joystick_poll;
+	dev->ip_dev->poll_interval = 50;
+	dev->ip_dev->poll_interval_min = 0;
+	dev->ip_dev->poll_interval_max = 2000;
+	dev->ip_dev->private = dev;
+	idev = dev->ip_dev->input;
+
+	idev->name = "Toshiba HAPS Accelerometer";
+	idev->phys = "toshiba_acpi/input1";
+	idev->id.bustype = BUS_HOST;
+
+	set_bit(EV_ABS, idev->evbit);
+
+	input_set_abs_params(idev, ABS_X, -512, 512, 0, 0);
+	input_set_abs_params(idev, ABS_Y, -512, 512, 0, 0);
+	input_set_abs_params(idev, ABS_Z, -716, 716, 0, 0);
+
+	ret = input_register_polled_device(dev->ip_dev);
+	if (ret) {
+		input_free_polled_device(dev->ip_dev);
+		dev->ip_dev = NULL;
+	}
+
+	return ret;
+}
+
 static int toshiba_acpi_remove(struct acpi_device *acpi_dev)
 {
 	struct toshiba_acpi_dev *dev = acpi_driver_data(acpi_dev);
@@ -1658,6 +1706,11 @@ static int toshiba_acpi_remove(struct acpi_device *acpi_dev)
 	if (dev->eco_supported)
 		led_classdev_unregister(&dev->eco_led);
 
+	if (dev->joystick_registered) {
+		input_unregister_polled_device(dev->ip_dev);
+		input_free_polled_device(dev->ip_dev);
+	}
+
 	if (toshiba_acpi)
 		toshiba_acpi = NULL;
 
@@ -1777,6 +1830,12 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 
 	ret = toshiba_accelerometer_supported(dev);
 	dev->accelerometer_supported = !ret;
+	if (dev->accelerometer_supported) {
+		if (toshiba_acpi_setup_joystick(dev) < 0)
+			pr_err("Unable to activate joystick");
+		else
+			dev->joystick_registered = 1;
+	}
 
 	/* Determine whether or not BIOS supports fan and video interfaces */
 
-- 
2.0.0

