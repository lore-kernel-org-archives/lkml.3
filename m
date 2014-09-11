Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaIKDCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 23:02:07 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60466 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaIKDCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 23:02:05 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2 4/5] toshiba_acpi: Support new keyboard backlight type
Date: Wed, 10 Sep 2014 21:01:56 -0600
Message-Id: <1410404517-4209-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Toshiba models now come with a new (and different) keyboard
backlight implementation with three modes of operation: TIMER,
ON and OFF, and the LED is controlled internally by the firmware.

This patch adds support for that type of backlight, changing the
existing code to accomodate the new implementation.

The timeout value range is now 1-60 seconds, and the accepted
modes are now: 1 (FN-Z), 2 (AUTO or TIMER), 8(ON) and 10 (OFF),
this adds two new entries keyboard_type and available_kbd_modes,
the first shows the keyboard type and the latter shows the
supported modes depending on the type.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 117 +++++++++++++++++++++++++++++++-----
 1 file changed, 102 insertions(+), 15 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 4c8fa7b..08147c5 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -140,6 +140,10 @@ MODULE_LICENSE("GPL");
 #define HCI_WIRELESS_BT_POWER		0x80
 #define SCI_KBD_MODE_FNZ		0x1
 #define SCI_KBD_MODE_AUTO		0x2
+#define SCI_KBD_MODE_ON			0x8
+#define SCI_KBD_MODE_OFF		0x10
+#define SCI_KBD_MODE_MAX		SCI_KBD_MODE_OFF
+#define SCI_KBD_TIME_MAX		0x3c001a
 
 struct toshiba_acpi_dev {
 	struct acpi_device *acpi_dev;
@@ -155,6 +159,7 @@ struct toshiba_acpi_dev {
 	int force_fan;
 	int last_key_event;
 	int key_event_valid;
+	int kbd_type;
 	int kbd_mode;
 	int kbd_time;
 
@@ -495,6 +500,42 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
 }
 
 /* KBD Illumination */
+static int toshiba_kbd_illum_available(struct toshiba_acpi_dev *dev)
+{
+	u32 in[HCI_WORDS] = { SCI_GET, SCI_KBD_ILLUM_STATUS, 0, 0, 0, 0 };
+	u32 out[HCI_WORDS];
+	acpi_status status;
+
+	if (!sci_open(dev))
+		return 0;
+
+	status = hci_raw(dev, in, out);
+	sci_close(dev);
+	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
+		pr_err("ACPI call to query kbd illumination support failed\n");
+		return 0;
+	} else if (out[0] == HCI_NOT_SUPPORTED) {
+		pr_info("Keyboard illumination not available\n");
+		return 0;
+	}
+
+	/* Check for keyboard backlight timeout max value,
+	/* previous kbd backlight implementation set this to
+	 * 0x3c0003, and now the new implementation set this
+	 * to 0x3c001a, use this to distinguish between them
+	 */
+	if (out[3] == SCI_KBD_TIME_MAX)
+		dev->kbd_type = 2;
+	else
+		dev->kbd_type = 1;
+	/* Get the current keyboard backlight mode */
+	dev->kbd_mode = out[2] & SCI_KBD_MODE_MASK;
+	/* Get the current time (1-60 seconds) */
+	dev->kbd_time = out[2] >> HCI_MISC_SHIFT;
+
+	return 1;
+}
+
 static int toshiba_kbd_illum_status_set(struct toshiba_acpi_dev *dev, u32 time)
 {
 	u32 result;
@@ -1268,20 +1309,46 @@ static ssize_t toshiba_kbd_bl_mode_store(struct device *dev,
 	ret = kstrtoint(buf, 0, &mode);
 	if (ret)
 		return ret;
-	if (mode != SCI_KBD_MODE_FNZ && mode != SCI_KBD_MODE_AUTO)
+	if (mode != SCI_KBD_MODE_FNZ && mode != SCI_KBD_MODE_AUTO &&
+	    mode != SCI_KBD_MODE_ON && mode != SCI_KBD_MODE_OFF)
 		return -EINVAL;
 
+	/* Check for supported modes depending on keyboard backlight type */
+	if (toshiba->kbd_type == 1) {
+		/* Type 1 supports SCI_KBD_MODE_FNZ and SCI_KBD_MODE_AUTO */
+		if (mode == SCI_KBD_MODE_ON || mode == SCI_KBD_MODE_OFF)
+			return -EINVAL;
+	} else if (toshiba->kbd_type == 2) {
+		/* Type 2 doesn't support SCI_KBD_MODE_FNZ */
+		if (mode == SCI_KBD_MODE_FNZ)
+			return -EINVAL;
+	}
+
 	/* Set the Keyboard Backlight Mode where:
-	 * Mode - Auto (2) | FN-Z (1)
 	 *	Auto - KBD backlight turns off automatically in given time
 	 *	FN-Z - KBD backlight "toggles" when hotkey pressed
+	 *	ON   - KBD backlight is always on
+	 *	OFF  - KBD backlight is always off
 	 */
+
+	/* Only make a change if the actual mode has changed */
 	if (toshiba->kbd_mode != mode) {
+		/* Shift the time to "base time" (0x3c0000 == 60 seconds) */
 		time = toshiba->kbd_time << HCI_MISC_SHIFT;
-		time = time + toshiba->kbd_mode;
+
+		/* OR the "base time" to the actual method format */
+		if (toshiba->kbd_type == 1) {
+			/* Type 1 requires the current mode */
+			time |= toshiba->kbd_mode;
+		} else if (toshiba->kbd_type == 2) {
+			/* Type 2 requires the desired mode */
+			time |= mode;
+		}
+
 		ret = toshiba_kbd_illum_status_set(toshiba, time);
 		if (ret)
 			return ret;
+
 		toshiba->kbd_mode = mode;
 	}
 
@@ -1293,12 +1360,31 @@ static ssize_t toshiba_kbd_bl_mode_show(struct device *dev,
 					char *buf)
 {
 	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
-	u32 time;
 
-	if (toshiba_kbd_illum_status_get(toshiba, &time) < 0)
-		return -EIO;
+	return sprintf(buf, "%x\n", toshiba->kbd_mode);
+}
 
-	return sprintf(buf, "%i\n", time & 0x07);
+static ssize_t toshiba_kbd_type_show(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", toshiba->kbd_type);
+}
+
+static ssize_t toshiba_available_kbd_modes_show(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+
+	if (toshiba->kbd_type == 1)
+		return sprintf(buf, "%x %x\n",
+			       SCI_KBD_MODE_FNZ, SCI_KBD_MODE_AUTO);
+
+	return sprintf(buf, "%x %x %x\n",
+		       SCI_KBD_MODE_AUTO, SCI_KBD_MODE_ON, SCI_KBD_MODE_OFF);
 }
 
 static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
@@ -1390,6 +1476,9 @@ static ssize_t toshiba_position_show(struct device *dev,
 
 static DEVICE_ATTR(kbd_backlight_mode, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_mode_show, toshiba_kbd_bl_mode_store);
+static DEVICE_ATTR(keyboard_type, S_IRUGO, toshiba_kbd_type_show, NULL);
+static DEVICE_ATTR(available_kbd_modes, S_IRUGO,
+		   toshiba_available_kbd_modes_show, NULL);
 static DEVICE_ATTR(kbd_backlight_timeout, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_timeout_show, toshiba_kbd_bl_timeout_store);
 static DEVICE_ATTR(touchpad, S_IRUGO | S_IWUSR,
@@ -1398,6 +1487,8 @@ static DEVICE_ATTR(position, S_IRUGO, toshiba_position_show, NULL);
 
 static struct attribute *toshiba_attributes[] = {
 	&dev_attr_kbd_backlight_mode.attr,
+	&dev_attr_keyboard_type.attr,
+	&dev_attr_available_kbd_modes.attr,
 	&dev_attr_kbd_backlight_timeout.attr,
 	&dev_attr_touchpad.attr,
 	&dev_attr_position.attr,
@@ -1414,7 +1505,7 @@ static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 	if (attr == &dev_attr_kbd_backlight_mode.attr)
 		exists = (drv->kbd_illum_supported) ? true : false;
 	else if (attr == &dev_attr_kbd_backlight_timeout.attr)
-		exists = (drv->kbd_mode == SCI_KBD_MODE_AUTO) ? true : false;
+		exists = (drv->kbd_mode == SCI_KBD_MODE_FNZ) ? false : true;
 	else if (attr == &dev_attr_touchpad.attr)
 		exists = (drv->touchpad_supported) ? true : false;
 	else if (attr == &dev_attr_position.attr)
@@ -1759,15 +1850,11 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 			dev->eco_supported = 1;
 	}
 
-	ret = toshiba_kbd_illum_status_get(dev, &dummy);
-	if (!ret) {
-		dev->kbd_time = dummy >> HCI_MISC_SHIFT;
-		dev->kbd_mode = dummy & 0x07;
-	}
-	dev->kbd_illum_supported = !ret;
+	dev->kbd_illum_supported = toshiba_kbd_illum_available(dev);
 	/*
 	 * Only register the LED if KBD illumination is supported
-	 * and the keyboard backlight operation mode is set to FN-Z
+	 * and the keyboard backlight operation mode is set to FN-Z,
+	 * keyboard backlight type 2 returns 0x8400 (HCI WRITE PROTECTED)
 	 */
 	if (dev->kbd_illum_supported && dev->kbd_mode == SCI_KBD_MODE_FNZ) {
 		dev->kbd_led.name = "toshiba::kbd_backlight";
-- 
2.0.0

