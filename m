Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbbASBbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 20:31:18 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:37397 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbbASBbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 20:31:14 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v2 4/4] toshiba_acpi: Add support for USB Sleep and Music
Date: Sun, 18 Jan 2015 18:30:25 -0700
Message-Id: <1421631025-27895-5-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421631025-27895-1-git-send-email-coproscefalo@gmail.com>
References: <1421631025-27895-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Toshiba laptops now come with a feature called USB Sleep and
Music, where the laptop speakers remain powered and the line-in jack
is used to connect an external device to use the laptop speakers when
the computer is asleep or turned off.

This patchs adds support to such feature, by creating a sysfs entry
named "usb_sleep_music", accepting only two values, 0 to disable and
1 to enable.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 97 +++++++++++++++++++++++++++++++++++++
 1 file changed, 97 insertions(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index ab08d00..4811a90 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -124,6 +124,7 @@ MODULE_LICENSE("GPL");
 #define SCI_ILLUMINATION		0x014e
 #define SCI_USB_SLEEP_CHARGE		0x0150
 #define SCI_KBD_ILLUM_STATUS		0x015c
+#define SCI_USB_SLEEP_MUSIC		0x015e
 #define SCI_TOUCHPAD			0x050e
 
 /* field definitions */
@@ -190,6 +191,7 @@ struct toshiba_acpi_dev {
 	unsigned int accelerometer_supported:1;
 	unsigned int usb_sleep_charge_supported:1;
 	unsigned int usb_rapid_charge_supported:1;
+	unsigned int usb_sleep_music_supported:1;
 	unsigned int sysfs_created:1;
 
 	struct mutex mutex;
@@ -930,6 +932,50 @@ static int toshiba_usb_rapid_charge_set(struct toshiba_acpi_dev *dev,
 	return 0;
 }
 
+static int toshiba_usb_sleep_music_get(struct toshiba_acpi_dev *dev, u32 *state)
+{
+	u32 result;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	result = sci_read(dev, SCI_USB_SLEEP_MUSIC, state);
+	sci_close(dev);
+	if (result == TOS_FAILURE) {
+		pr_err("ACPI call to set USB S&C mode failed\n");
+		return -EIO;
+	} else if (result == TOS_NOT_SUPPORTED) {
+		pr_info("USB Sleep and Charge not supported\n");
+		return -ENODEV;
+	} else if (result == TOS_INPUT_DATA_ERROR) {
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int toshiba_usb_sleep_music_set(struct toshiba_acpi_dev *dev, u32 state)
+{
+	u32 result;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	result = sci_write(dev, SCI_USB_SLEEP_MUSIC, state);
+	sci_close(dev);
+	if (result == TOS_FAILURE) {
+		pr_err("ACPI call to set USB S&C mode failed\n");
+		return -EIO;
+	} else if (result == TOS_NOT_SUPPORTED) {
+		pr_info("USB Sleep and Charge not supported\n");
+		return -ENODEV;
+	} else if (result == TOS_INPUT_DATA_ERROR) {
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /* Bluetooth rfkill handlers */
 
 static u32 hci_get_bt_present(struct toshiba_acpi_dev *dev, bool *present)
@@ -1501,6 +1547,12 @@ static ssize_t toshiba_usb_rapid_charge_show(struct device *dev,
 static ssize_t toshiba_usb_rapid_charge_store(struct device *dev,
 					      struct device_attribute *attr,
 					      const char *buf, size_t count);
+static ssize_t toshiba_usb_sleep_music_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf);
+static ssize_t toshiba_usb_sleep_music_store(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count);
 
 static DEVICE_ATTR(kbd_backlight_mode, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_mode_show, toshiba_kbd_bl_mode_store);
@@ -1521,6 +1573,9 @@ static DEVICE_ATTR(sleep_functions_on_battery, S_IRUGO | S_IWUSR,
 static DEVICE_ATTR(usb_rapid_charge, S_IRUGO | S_IWUSR,
 		   toshiba_usb_rapid_charge_show,
 		   toshiba_usb_rapid_charge_store);
+static DEVICE_ATTR(usb_sleep_music, S_IRUGO | S_IWUSR,
+		   toshiba_usb_sleep_music_show,
+		   toshiba_usb_sleep_music_store);
 
 static struct attribute *toshiba_attributes[] = {
 	&dev_attr_kbd_backlight_mode.attr,
@@ -1532,6 +1587,7 @@ static struct attribute *toshiba_attributes[] = {
 	&dev_attr_usb_sleep_charge.attr,
 	&dev_attr_sleep_functions_on_battery.attr,
 	&dev_attr_usb_rapid_charge.attr,
+	&dev_attr_usb_sleep_music.attr,
 	NULL,
 };
 
@@ -1896,6 +1952,42 @@ static ssize_t toshiba_usb_rapid_charge_store(struct device *dev,
 	return count;
 }
 
+static ssize_t toshiba_usb_sleep_music_show(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	u32 state;
+	int ret;
+
+	ret = toshiba_usb_sleep_music_get(toshiba, &state);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", state);
+}
+
+static ssize_t toshiba_usb_sleep_music_store(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	int state;
+	int ret;
+
+	ret = kstrtoint(buf, 0, &state);
+	if (ret)
+		return ret;
+	if (state != 0 && state != 1)
+		return -EINVAL;
+
+	ret = toshiba_usb_sleep_music_set(toshiba, state);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
 static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 					struct attribute *attr, int idx)
 {
@@ -1917,6 +2009,8 @@ static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 		exists = (drv->usb_sleep_charge_supported) ? true : false;
 	else if (attr == &dev_attr_usb_rapid_charge.attr)
 		exists = (drv->usb_rapid_charge_supported) ? true : false;
+	else if (attr == &dev_attr_usb_sleep_music.attr)
+		exists = (drv->usb_sleep_music_supported) ? true : false;
 
 	return exists ? attr->mode : 0;
 }
@@ -2332,6 +2426,9 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 	ret = toshiba_usb_rapid_charge_get(dev, &dummy);
 	dev->usb_rapid_charge_supported = !ret;
 
+	ret = toshiba_usb_sleep_music_get(dev, &dummy);
+	dev->usb_sleep_music_supported = !ret;
+
 	/* Determine whether or not BIOS supports fan and video interfaces */
 
 	ret = get_video_status(dev, &dummy);
-- 
2.2.1

