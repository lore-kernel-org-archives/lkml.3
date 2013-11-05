Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3KEDs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:48:59 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:39224 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab3KEDs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:48:56 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: azael.avalos@gmail.com
Subject: [PATCH 6/8] toshiba_acpi: Add accelerometer support
Date: Mon,  4 Nov 2013 20:48:43 -0700
Message-Id: <1383623325-4004-7-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
References: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent Toshiba laptops now come equiped with a built in
accelerometer (TOS620A), but such device does not
expose the axis information, however, HCI calls 0x006d
and 0x00a6 can be used to query such info.

This patch adds support to read the axis values and
exposing them through the _position_ sysfs file.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 79 +++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 022c6e6..9c718eb 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -103,6 +103,8 @@ MODULE_LICENSE("GPL");
 #define INPUT_DATA_ERROR		0x8300
 #define NOT_PRESENT			0x8600
 #define FIFO_EMPTY			0x8c00
+#define DATA_NOT_AVAILABLE		0x8d20
+#define NOT_INITIALIZED			0x8d50
 
 /* registers */
 #define HCI_FAN				0x0004
@@ -112,12 +114,15 @@ MODULE_LICENSE("GPL");
 #define HCI_HOTKEY_EVENT		0x001e
 #define HCI_LCD_BRIGHTNESS		0x002a
 #define HCI_WIRELESS			0x0056
+#define HCI_ACCELEROMETER		0x006d
 #define HCI_KBD_ILLUMINATION		0x0095
 #define HCI_ECO_MODE			0x0097
+#define HCI_ACCELEROMETER2		0x00a6
 #define SCI_ILLUMINATION		0x014e
 #define SCI_KBD_ILLUM_STATUS		0x015c
 
 /* field definitions */
+#define HCI_ACCEL_MASK			0x7fff
 #define HCI_HOTKEY_DISABLE		0x0b
 #define HCI_HOTKEY_ENABLE		0x09
 #define HCI_LCD_BRIGHTNESS_BITS		3
@@ -162,6 +167,7 @@ struct toshiba_acpi_dev {
 	unsigned int kbd_illum_supported:1;
 	unsigned int kbd_led_registered:1;
 	unsigned int eco_supported:1;
+	unsigned int accelerometer_supported:1;
 	unsigned int sysfs_created:1;
 
 	struct mutex mutex;
@@ -592,6 +598,51 @@ static void toshiba_eco_mode_set_status(struct led_classdev *cdev,
 	}
 }
 
+/* Accelerometer support */
+static int toshiba_accelerometer_supported(struct toshiba_acpi_dev *dev)
+{
+	u32 in[HCI_WORDS] = { HCI_GET, HCI_ACCELEROMETER2, 0, 0, 0, 0 };
+	u32 out[HCI_WORDS];
+	acpi_status status;
+
+	/* Check if the accelerometer call exists,
+	 * this call also serves as initialization
+	 */
+	status = hci_raw(dev, in, out);
+	if (ACPI_FAILURE(status) || out[0] == INPUT_DATA_ERROR) {
+		pr_err("ACPI call to query the accelerometer failed\n");
+		return -EIO;
+	} else if (out[0] == DATA_NOT_AVAILABLE || out[0] == NOT_INITIALIZED) {
+		pr_err("Accelerometer not initialized\n");
+		return -EIO;
+	} else if (out[0] == NOT_SUPPORTED) {
+		pr_info("Accelerometer not supported\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int toshiba_accelerometer_get(struct toshiba_acpi_dev *dev,
+				      u32 *xy, u32 *z)
+{
+	u32 in[HCI_WORDS] = { HCI_GET, HCI_ACCELEROMETER, 0, 1, 0, 0 };
+	u32 out[HCI_WORDS];
+	acpi_status status;
+
+	/* Check the Accelerometer status */
+	status = hci_raw(dev, in, out);
+	if (ACPI_FAILURE(status) || out[0] == INPUT_DATA_ERROR) {
+		pr_err("ACPI call to query the accelerometer failed\n");
+		return -EIO;
+	}
+
+	*xy = out[2];
+	*z = out[4];
+
+	return 0;
+}
+
 /* Bluetooth rfkill handlers */
 
 static u32 hci_get_bt_present(struct toshiba_acpi_dev *dev, bool *present)
@@ -1195,14 +1246,37 @@ static ssize_t toshiba_kbd_bl_timeout_show(struct device *dev,
 	return sprintf(buf, "%i\n", time >> HCI_MISC_SHIFT);
 }
 
+static ssize_t toshiba_position_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	u32 xyval, zval, tmp;
+	u16 x, y, z;
+	int ret;
+
+	xyval = zval = 0;
+	ret = toshiba_accelerometer_get(toshiba, &xyval, &zval);
+	if (ret < 0)
+		return ret;
+
+	x = xyval & HCI_ACCEL_MASK;
+	tmp = xyval >> HCI_MISC_SHIFT;
+	y = tmp & HCI_ACCEL_MASK;
+	z = zval & HCI_ACCEL_MASK;
+
+	return sprintf(buf, "%d %d %d\n", x, y, z);
+}
+
 static DEVICE_ATTR(kbd_backlight_mode, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_mode_show, toshiba_kbd_bl_mode_store);
 static DEVICE_ATTR(kbd_backlight_timeout, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_timeout_show, toshiba_kbd_bl_timeout_store);
+static DEVICE_ATTR(position, S_IRUGO, toshiba_position_show, NULL);
 
 static struct attribute *toshiba_attributes[] = {
 	&dev_attr_kbd_backlight_mode.attr,
 	&dev_attr_kbd_backlight_timeout.attr,
+	&dev_attr_position.attr,
 	NULL,
 };
 
@@ -1218,6 +1292,8 @@ static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 		exists = (driver->kbd_illum_supported) ? true : false;
 	else if (attr == &dev_attr_kbd_backlight_timeout.attr)
 		exists = (driver->kbd_mode == SCI_KBD_MODE_AUTO) ? true : false;
+	else if (attr == &dev_attr_position.attr)
+		exists = (driver->accelerometer_supported) ? true : false;
 
 	return exists ? attr->mode : 0;
 }
@@ -1600,6 +1676,9 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 			dev->kbd_led_registered = 1;
 	}
 
+	ret = toshiba_accelerometer_supported(dev);
+	dev->accelerometer_supported = !ret;
+
 	/* Determine whether or not BIOS supports fan and video interfaces */
 
 	ret = get_video_status(dev, &dummy);
-- 
1.8.1.4

