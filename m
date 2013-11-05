Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3KEDuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:50:07 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:54713 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754346Ab3KEDsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:48:53 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: azael.avalos@gmail.com
Subject: [PATCH 4/8] toshiba_acpi: Add kbd backlight support and sysfs files
Date: Mon,  4 Nov 2013 20:48:41 -0700
Message-Id: <1383623325-4004-5-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
References: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toshiba laptops equiped with an illuminated keyboard
can operate in two different modes: Auto and FN-Z.

The Auto mode turns on the led on keystrokes and
automatically turns it off after some (configurable)
time the last key was pressed.

The FN-Z mode is used to toggle the keyboard led on/off
by userspace.

This patch adds support to set the desired KBD mode and
timeout via sysfs, creates and registers toshiba::kbd_backlight
led device whenever the mode is set to FN-Z.

The acceptable values for mode are: 1 (Auto) and 2 (Fn-Z)
The time values range are: 1-60 seconds

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 242 ++++++++++++++++++++++++++++++++++++
 1 file changed, 242 insertions(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 226e0b5..f97f942 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -112,7 +112,9 @@ MODULE_LICENSE("GPL");
 #define HCI_HOTKEY_EVENT		0x001e
 #define HCI_LCD_BRIGHTNESS		0x002a
 #define HCI_WIRELESS			0x0056
+#define HCI_KBD_ILLUMINATION		0x0095
 #define SCI_ILLUMINATION		0x014e
+#define SCI_KBD_ILLUM_STATUS		0x015c
 
 /* field definitions */
 #define HCI_HOTKEY_DISABLE		0x0b
@@ -120,6 +122,7 @@ MODULE_LICENSE("GPL");
 #define HCI_LCD_BRIGHTNESS_BITS		3
 #define HCI_LCD_BRIGHTNESS_SHIFT	(16-HCI_LCD_BRIGHTNESS_BITS)
 #define HCI_LCD_BRIGHTNESS_LEVELS	(1 << HCI_LCD_BRIGHTNESS_BITS)
+#define HCI_MISC_SHIFT			0x10
 #define HCI_VIDEO_OUT_LCD		0x1
 #define HCI_VIDEO_OUT_CRT		0x2
 #define HCI_VIDEO_OUT_TV		0x4
@@ -127,6 +130,8 @@ MODULE_LICENSE("GPL");
 #define HCI_WIRELESS_BT_PRESENT		0x0f
 #define HCI_WIRELESS_BT_ATTACH		0x40
 #define HCI_WIRELESS_BT_POWER		0x80
+#define SCI_KBD_MODE_FNZ		0x1
+#define SCI_KBD_MODE_AUTO		0x2
 
 struct toshiba_acpi_dev {
 	struct acpi_device *acpi_dev;
@@ -137,10 +142,13 @@ struct toshiba_acpi_dev {
 	struct work_struct hotkey_work;
 	struct backlight_device *backlight_dev;
 	struct led_classdev led_dev;
+	struct led_classdev kbd_led;
 
 	int force_fan;
 	int last_key_event;
 	int key_event_valid;
+	int kbd_mode;
+	int kbd_time;
 
 	unsigned int illumination_supported:1;
 	unsigned int video_supported:1;
@@ -149,6 +157,9 @@ struct toshiba_acpi_dev {
 	unsigned int ntfy_supported:1;
 	unsigned int info_supported:1;
 	unsigned int tr_backlight_supported:1;
+	unsigned int kbd_illum_supported:1;
+	unsigned int kbd_led_registered:1;
+	unsigned int sysfs_created:1;
 
 	struct mutex mutex;
 };
@@ -444,6 +455,89 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
 	return state ? LED_FULL : LED_OFF;
 }
 
+/* KBD Illumination */
+static int toshiba_kbd_illum_status_set(struct toshiba_acpi_dev *dev, u32 time)
+{
+	u32 result;
+	acpi_status status;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	status = sci_write(dev, SCI_KBD_ILLUM_STATUS, time, &result);
+	if (ACPI_FAILURE(status) || result == INPUT_DATA_ERROR) {
+		pr_err("ACPI call to set KBD backlight status failed\n");
+		return -EIO;
+	} else if (result == NOT_SUPPORTED) {
+		pr_info("Keyboard backlight status not supported\n");
+		return -ENODEV;
+	}
+	sci_close(dev);
+
+	return 0;
+}
+
+static int toshiba_kbd_illum_status_get(struct toshiba_acpi_dev *dev, u32 *time)
+{
+	u32 result;
+	acpi_status status;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	status = sci_read(dev, SCI_KBD_ILLUM_STATUS, time, &result);
+	if (ACPI_FAILURE(status) || result == INPUT_DATA_ERROR) {
+		pr_err("ACPI call to get KBD backlight status failed\n");
+		return -EIO;
+	} else if (result == NOT_SUPPORTED) {
+		pr_info("Keyboard backlight status not supported\n");
+		return -ENODEV;
+	}
+	sci_close(dev);
+
+	return 0;
+}
+
+static enum led_brightness toshiba_kbd_backlight_get(struct led_classdev *cdev)
+{
+	struct toshiba_acpi_dev *dev = container_of(cdev,
+			struct toshiba_acpi_dev, kbd_led);
+	u32 state, result;
+	acpi_status status;
+
+	/* Check the keyboard backlight state */
+	status = hci_read1(dev, HCI_KBD_ILLUMINATION, &state, &result);
+	if (ACPI_FAILURE(status) || result == INPUT_DATA_ERROR) {
+		pr_err("ACPI call to get the keyboard backlight failed\n");
+		return LED_OFF;
+	} else if (result == NOT_SUPPORTED) {
+		pr_info("Keyboard backlight not supported\n");
+		return LED_OFF;
+	}
+
+	return state ? LED_FULL : LED_OFF;
+}
+
+static void toshiba_kbd_backlight_set(struct led_classdev *cdev,
+				     enum led_brightness brightness)
+{
+	struct toshiba_acpi_dev *dev = container_of(cdev,
+			struct toshiba_acpi_dev, kbd_led);
+	u32 state, result;
+	acpi_status status;
+
+	/* Set the keyboard backlight state */
+	state = brightness ? 1 : 0;
+	status = hci_write1(dev, HCI_KBD_ILLUMINATION, state, &result);
+	if (ACPI_FAILURE(status) || result == INPUT_DATA_ERROR) {
+		pr_err("ACPI call to set KBD Illumination mode failed\n");
+		return;
+	} else if (result == NOT_SUPPORTED) {
+		pr_info("Keyboard backlight not supported\n");
+		return;
+	}
+}
+
 /* Bluetooth rfkill handlers */
 
 static u32 hci_get_bt_present(struct toshiba_acpi_dev *dev, bool *present)
@@ -967,6 +1061,118 @@ static const struct backlight_ops toshiba_backlight_data = {
 	.update_status  = set_lcd_status,
 };
 
+/*
+ * Sysfs files
+ */
+
+static ssize_t toshiba_kbd_bl_mode_store(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	int mode = -1;
+	int time = -1;
+
+	if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
+		return -EINVAL;
+
+	/* Set the Keyboard Backlight Mode where:
+	 * Mode - Auto (2) | FN-Z (1)
+	 *	Auto - KBD backlight turns off automatically in given time
+	 *	FN-Z - KBD backlight "toggles" when hotkey pressed
+	 */
+	if (mode != -1 && toshiba->kbd_mode != mode) {
+		time = toshiba->kbd_time << HCI_MISC_SHIFT;
+		time = time + toshiba->kbd_mode;
+		if (toshiba_kbd_illum_status_set(toshiba, time) < 0)
+			return -EIO;
+		toshiba->kbd_mode = mode;
+	}
+
+	return count;
+}
+
+static ssize_t toshiba_kbd_bl_mode_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	u32 time;
+
+	if (toshiba_kbd_illum_status_get(toshiba, &time) < 0)
+		return -EIO;
+
+	return sprintf(buf, "%i\n", time & 0x07);
+}
+
+static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	int time = -1;
+
+	if (sscanf(buf, "%i", &time) != 1 && (time < 0 || time > 60))
+		return -EINVAL;
+
+	/* Set the Keyboard Backlight Timeout: 0-60 seconds */
+	if (time != -1 && toshiba->kbd_time != time) {
+		time = time << HCI_MISC_SHIFT;
+		time = (toshiba->kbd_mode == SCI_KBD_MODE_AUTO) ?
+							time + 1 : time + 2;
+		if (toshiba_kbd_illum_status_set(toshiba, time) < 0)
+			return -EIO;
+		toshiba->kbd_time = time >> HCI_MISC_SHIFT;
+	}
+
+	return count;
+}
+
+static ssize_t toshiba_kbd_bl_timeout_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	u32 time;
+
+	if (toshiba_kbd_illum_status_get(toshiba, &time) < 0)
+		return -EIO;
+
+	return sprintf(buf, "%i\n", time >> HCI_MISC_SHIFT);
+}
+
+static DEVICE_ATTR(kbd_backlight_mode, S_IRUGO | S_IWUSR,
+		   toshiba_kbd_bl_mode_show, toshiba_kbd_bl_mode_store);
+static DEVICE_ATTR(kbd_backlight_timeout, S_IRUGO | S_IWUSR,
+		   toshiba_kbd_bl_timeout_show, toshiba_kbd_bl_timeout_store);
+
+static struct attribute *toshiba_attributes[] = {
+	&dev_attr_kbd_backlight_mode.attr,
+	&dev_attr_kbd_backlight_timeout.attr,
+	NULL,
+};
+
+static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
+					struct attribute *attr, int idx)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct toshiba_acpi_dev *driver = platform_get_drvdata(pdev);
+	bool exists = true;
+
+	if (attr == &dev_attr_kbd_backlight_mode.attr)
+		exists = (driver->kbd_illum_supported) ? true : false;
+	else if (attr == &dev_attr_kbd_backlight_timeout.attr)
+		exists = (driver->kbd_mode == SCI_KBD_MODE_AUTO) ? true : false;
+
+	return exists ? attr->mode : 0;
+}
+
+static struct attribute_group toshiba_attr_group = {
+	.is_visible = toshiba_sysfs_is_visible,
+	.attrs = toshiba_attributes,
+};
+
 static bool toshiba_acpi_i8042_filter(unsigned char data, unsigned char str,
 				      struct serio *port)
 {
@@ -1179,6 +1385,10 @@ static int toshiba_acpi_remove(struct acpi_device *acpi_dev)
 
 	remove_toshiba_proc_entries(dev);
 
+	if (dev->sysfs_created)
+		sysfs_remove_group(&dev->pf_dev->dev.kobj,
+				   &toshiba_attr_group);
+
 	if (dev->ntfy_supported) {
 		i8042_remove_filter(toshiba_acpi_i8042_filter);
 		cancel_work_sync(&dev->hotkey_work);
@@ -1200,6 +1410,9 @@ static int toshiba_acpi_remove(struct acpi_device *acpi_dev)
 	if (dev->illumination_supported)
 		led_classdev_unregister(&dev->led_dev);
 
+	if (dev->kbd_led_registered)
+		led_classdev_unregister(&dev->kbd_led);
+
 	if (dev->pf_dev)
 		platform_device_unregister(dev->pf_dev);
 
@@ -1302,6 +1515,25 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 			dev->illumination_supported = 1;
 	}
 
+	ret = toshiba_kbd_illum_status_get(dev, &dummy);
+	if (!ret) {
+		dev->kbd_time = dummy >> HCI_MISC_SHIFT;
+		dev->kbd_mode = dummy & 0x07;
+	}
+	dev->kbd_illum_supported = !ret;
+	/*
+	 * Only register the LED if KBD illumination is supported
+	 * and the keyboard backlight operation mode is set to FN-Z
+	 */
+	if (dev->kbd_illum_supported && dev->kbd_mode == SCI_KBD_MODE_FNZ) {
+		dev->kbd_led.name = "toshiba::kbd_backlight";
+		dev->kbd_led.max_brightness = 1;
+		dev->kbd_led.brightness_set = toshiba_kbd_backlight_set;
+		dev->kbd_led.brightness_get = toshiba_kbd_backlight_get;
+		if (!led_classdev_register(&dev->pf_dev->dev, &dev->kbd_led))
+			dev->kbd_led_registered = 1;
+	}
+
 	/* Determine whether or not BIOS supports fan and video interfaces */
 
 	ret = get_video_status(dev, &dummy);
@@ -1310,6 +1542,16 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 	ret = get_fan_status(dev, &dummy);
 	dev->fan_supported = !ret;
 
+	ret = sysfs_create_group(&dev->pf_dev->dev.kobj,
+				 &toshiba_attr_group);
+	if (ret) {
+		platform_device_del(dev->pf_dev);
+		platform_device_put(dev->pf_dev);
+		dev->sysfs_created = 0;
+		goto error;
+	}
+	dev->sysfs_created = !ret;
+
 	create_toshiba_proc_entries(dev);
 
 	toshiba_acpi = dev;
-- 
1.8.1.4

