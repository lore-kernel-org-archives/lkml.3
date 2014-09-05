Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaIERPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:15:00 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:61300 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbaIEROd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:14:33 -0400
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Darren Hart <dvhart@infradead.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 4/5] toshiba_acpi: Support new keyboard backlight type
Date: Fri,  5 Sep 2014 11:14:06 -0600
Message-Id: <1409937247-2525-5-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
References: <1409937247-2525-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Toshiba models now come with a new (and different) keyboard
backlight implementation whith three modes of operation: TIMER,
ON and OFF, and the LED is controlled internally by the firmware.

This patch adds support for that type of backlight, changing the
existing code to accomodate the new implementation.

The timeout value range is now 1-60 seconds, and the accepted
modes are now: 0 (OFF), 1 (ON or FN-Z) and 2 (AUTO or TIMER), and
the keyboard_backlight_mode entry now displays two values, the
keyboard backlight type (either 1 or 2) and the current mode.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 145 ++++++++++++++++++++++++------------
 1 file changed, 98 insertions(+), 47 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index ac1503c..1738171 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -142,6 +142,8 @@ MODULE_LICENSE("GPL");
 #define HCI_WIRELESS_BT_POWER		0x80
 #define SCI_KBD_MODE_FNZ		0x1
 #define SCI_KBD_MODE_AUTO		0x2
+#define SCI_KBD_MODE_ON			0x8
+#define SCI_KBD_MODE_OFF		0x10
 
 struct toshiba_acpi_dev {
 	struct acpi_device *acpi_dev;
@@ -158,6 +160,7 @@ struct toshiba_acpi_dev {
 	int force_fan;
 	int last_key_event;
 	int key_event_valid;
+	int kbd_type;
 	int kbd_mode;
 	int kbd_time;
 
@@ -499,28 +502,36 @@ static enum led_brightness toshiba_illumination_get(struct led_classdev *cdev)
 }
 
 /* KBD Illumination */
-static int toshiba_kbd_illum_status_set(struct toshiba_acpi_dev *dev, u32 time)
+static int toshiba_kbd_illum_available(struct toshiba_acpi_dev *dev)
 {
-	u32 result;
+	u32 in[HCI_WORDS] = { SCI_GET, SCI_KBD_ILLUM_STATUS, 0, 0, 0, 0 };
+	u32 out[HCI_WORDS];
 	acpi_status status;
 
 	if (!sci_open(dev))
-		return -EIO;
+		return 0;
 
-	status = sci_write(dev, SCI_KBD_ILLUM_STATUS, time, &result);
+	status = hci_raw(dev, in, out);
 	sci_close(dev);
-	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
-		pr_err("ACPI call to set KBD backlight status failed\n");
-		return -EIO;
-	} else if (result == HCI_NOT_SUPPORTED) {
-		pr_info("Keyboard backlight status not supported\n");
-		return -ENODEV;
+	if (ACPI_FAILURE(status) || out[0] == SCI_INPUT_DATA_ERROR) {
+		pr_err("ACPI call to query kbd illumination support failed\n");
+		return 0;
+	} else if (out[0] == HCI_NOT_SUPPORTED) {
+		pr_info("Keyboard illumination not available\n");
+		return 0;
 	}
 
-	return 0;
+	if (out[3] == 0x3c001a)
+		dev->kbd_type = 2;
+	else
+		dev->kbd_type = 1;
+	dev->kbd_mode = out[2] & 0x1f;
+	dev->kbd_time = out[2] >> HCI_MISC_SHIFT;
+
+	return 1;
 }
 
-static int toshiba_kbd_illum_status_get(struct toshiba_acpi_dev *dev, u32 *time)
+static int toshiba_kbd_illum_status_set(struct toshiba_acpi_dev *dev, u32 time)
 {
 	u32 result;
 	acpi_status status;
@@ -528,10 +539,10 @@ static int toshiba_kbd_illum_status_get(struct toshiba_acpi_dev *dev, u32 *time)
 	if (!sci_open(dev))
 		return -EIO;
 
-	status = sci_read(dev, SCI_KBD_ILLUM_STATUS, time, &result);
+	status = sci_write(dev, SCI_KBD_ILLUM_STATUS, time, &result);
 	sci_close(dev);
 	if (ACPI_FAILURE(status) || result == SCI_INPUT_DATA_ERROR) {
-		pr_err("ACPI call to get KBD backlight status failed\n");
+		pr_err("ACPI call to set KBD backlight status failed\n");
 		return -EIO;
 	} else if (result == HCI_NOT_SUPPORTED) {
 		pr_info("Keyboard backlight status not supported\n");
@@ -1264,22 +1275,54 @@ static ssize_t toshiba_kbd_bl_mode_store(struct device *dev,
 					 const char *buf, size_t count)
 {
 	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
-	int mode = -1;
-	int time = -1;
+	int mode;
+	int time;
+	int ret;
 
-	if (sscanf(buf, "%i", &mode) != 1 && (mode != 2 || mode != 1))
+	ret = kstrtoint(buf, 0, &mode);
+	if (ret)
+		return ret;
+	if (mode > 2 || mode < 0)
 		return -EINVAL;
 
 	/* Set the Keyboard Backlight Mode where:
-	 * Mode - Auto (2) | FN-Z (1)
+	 * Mode - Auto (2) | FN-Z or ON (1) | OFF (0)
 	 *	Auto - KBD backlight turns off automatically in given time
 	 *	FN-Z - KBD backlight "toggles" when hotkey pressed
+	 *	ON   - KBD backlight is always on
+	 *	OFF  - KBD backlight is always off
+	 */
+
+	/* Convert userspace values to internal ones,
+	 * depending on the keyboard backlight type detected
 	 */
-	if (mode != -1 && toshiba->kbd_mode != mode) {
+	if (mode == 0)
+		mode = SCI_KBD_MODE_OFF;
+	else if (mode == 1 && toshiba->kbd_type == 1)
+		mode = SCI_KBD_MODE_FNZ;
+	else if (mode == 1 && toshiba->kbd_type == 2)
+		mode = SCI_KBD_MODE_ON;
+	else if (mode == 2)
+		mode = SCI_KBD_MODE_AUTO;
+
+	/* Only make a change if the actual mode has changed */
+	if (toshiba->kbd_mode != mode) {
+		/* KBD backlight type 1 doesn't support SCI_KBD_MODE_OFF,
+		 * bailout silently if set to it
+		 */
+		if (toshiba->kbd_type == 1 && mode == SCI_KBD_MODE_OFF)
+			return count;
+
 		time = toshiba->kbd_time << HCI_MISC_SHIFT;
-		time = time + toshiba->kbd_mode;
-		if (toshiba_kbd_illum_status_set(toshiba, time) < 0)
-			return -EIO;
+		if (toshiba->kbd_type == 1)
+			time |= toshiba->kbd_mode;
+		else if (toshiba->kbd_type == 2)
+			time |= mode;
+
+		ret = toshiba_kbd_illum_status_set(toshiba, time);
+		if (ret)
+			return ret;
+
 		toshiba->kbd_mode = mode;
 	}
 
@@ -1291,12 +1334,17 @@ static ssize_t toshiba_kbd_bl_mode_show(struct device *dev,
 					char *buf)
 {
 	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
-	u32 time;
+	int mode;
 
-	if (toshiba_kbd_illum_status_get(toshiba, &time) < 0)
-		return -EIO;
+	if (toshiba->kbd_mode == SCI_KBD_MODE_OFF)
+		mode = 0;
+	else if (toshiba->kbd_mode == SCI_KBD_MODE_FNZ ||
+		 toshiba->kbd_mode == SCI_KBD_MODE_ON)
+		mode = 1;
+	else if (toshiba->kbd_mode == SCI_KBD_MODE_AUTO)
+		mode = 2;
 
-	return sprintf(buf, "%i\n", time & 0x07);
+	return sprintf(buf, "%i %i\n", toshiba->kbd_type, mode);
 }
 
 static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
@@ -1304,18 +1352,29 @@ static ssize_t toshiba_kbd_bl_timeout_store(struct device *dev,
 					    const char *buf, size_t count)
 {
 	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
-	int time = -1;
+	int time;
+	int ret;
 
-	if (sscanf(buf, "%i", &time) != 1 && (time < 0 || time > 60))
+	ret = kstrtoint(buf, 0, &time);
+	if (ret)
+		return ret;
+	if (time < 1 || time > 60)
 		return -EINVAL;
 
-	/* Set the Keyboard Backlight Timeout: 0-60 seconds */
-	if (time != -1 && toshiba->kbd_time != time) {
+	/* Set the Keyboard Backlight Timeout: 1-60 seconds
+	 * Only make the change if the actual timeout has changed
+	 */
+	if (toshiba->kbd_time != time) {
 		time = time << HCI_MISC_SHIFT;
-		time = (toshiba->kbd_mode == SCI_KBD_MODE_AUTO) ?
-							time + 1 : time + 2;
-		if (toshiba_kbd_illum_status_set(toshiba, time) < 0)
-			return -EIO;
+		if (toshiba->kbd_type == 1)
+			time |= SCI_KBD_MODE_FNZ;
+		else if (toshiba->kbd_type == 2)
+			time |= SCI_KBD_MODE_AUTO;
+
+		ret = toshiba_kbd_illum_status_set(toshiba, time);
+		if (ret)
+			return ret;
+
 		toshiba->kbd_time = time >> HCI_MISC_SHIFT;
 	}
 
@@ -1327,12 +1386,8 @@ static ssize_t toshiba_kbd_bl_timeout_show(struct device *dev,
 					   char *buf)
 {
 	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
-	u32 time;
-
-	if (toshiba_kbd_illum_status_get(toshiba, &time) < 0)
-		return -EIO;
 
-	return sprintf(buf, "%i\n", time >> HCI_MISC_SHIFT);
+	return sprintf(buf, "%i\n", toshiba->kbd_time);
 }
 
 static ssize_t toshiba_touchpad_store(struct device *dev,
@@ -1389,7 +1444,7 @@ static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 	if (attr == &dev_attr_kbd_backlight_mode.attr)
 		exists = (drv->kbd_illum_supported) ? true : false;
 	else if (attr == &dev_attr_kbd_backlight_timeout.attr)
-		exists = (drv->kbd_mode == SCI_KBD_MODE_AUTO) ? true : false;
+		exists = (drv->kbd_mode == SCI_KBD_MODE_FNZ) ? false : true;
 	else if (attr == &dev_attr_touchpad.attr)
 		exists = (drv->touchpad_supported) ? true : false;
 
@@ -1806,15 +1861,11 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
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

