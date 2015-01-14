Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbbANVkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:40:31 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37454 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbbANVk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:40:28 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH 1/4] toshiba_acpi: Add support for USB Sleep and Charge function
Date: Wed, 14 Jan 2015 14:40:18 -0700
Message-Id: <1421271621-8330-2-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421271621-8330-1-git-send-email-coproscefalo@gmail.com>
References: <1421271621-8330-1-git-send-email-coproscefalo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer Toshiba models now come with a feature called Sleep and Charge,
where the computer USB ports remain powered when the computer is
asleep or turned off.

This patch adds support to such feature, creating a sysfs entry
called "usb_sleep_charge" to set the desired charging mode or to
disable it.

The sysfs entry accepts three parameters, 0x0, 0x9 and 0x21, beign
disabled, alternate and auto respectively.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 112 ++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 71ac7c12..b03129d 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -122,6 +122,7 @@ MODULE_LICENSE("GPL");
 #define HCI_ECO_MODE			0x0097
 #define HCI_ACCELEROMETER2		0x00a6
 #define SCI_ILLUMINATION		0x014e
+#define SCI_USB_SLEEP_CHARGE		0x0150
 #define SCI_KBD_ILLUM_STATUS		0x015c
 #define SCI_TOUCHPAD			0x050e
 
@@ -146,6 +147,10 @@ MODULE_LICENSE("GPL");
 #define SCI_KBD_MODE_ON			0x8
 #define SCI_KBD_MODE_OFF		0x10
 #define SCI_KBD_TIME_MAX		0x3c001a
+#define SCI_USB_CHARGE_MODE_MASK	0xff
+#define SCI_USB_CHARGE_DISABLED		0x30000
+#define SCI_USB_CHARGE_ALTERNATE	0x30009
+#define SCI_USB_CHARGE_AUTO		0x30021
 
 struct toshiba_acpi_dev {
 	struct acpi_device *acpi_dev;
@@ -177,6 +182,7 @@ struct toshiba_acpi_dev {
 	unsigned int touchpad_supported:1;
 	unsigned int eco_supported:1;
 	unsigned int accelerometer_supported:1;
+	unsigned int usb_sleep_charge_supported:1;
 	unsigned int sysfs_created:1;
 
 	struct mutex mutex;
@@ -761,6 +767,53 @@ static int toshiba_accelerometer_get(struct toshiba_acpi_dev *dev,
 	return 0;
 }
 
+/* Sleep (Charge and Music) utilities support */
+static int toshiba_usb_sleep_charge_get(struct toshiba_acpi_dev *dev,
+					u32 *mode)
+{
+	u32 result;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	result = sci_read(dev, SCI_USB_SLEEP_CHARGE, mode);
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
+static int toshiba_usb_sleep_charge_set(struct toshiba_acpi_dev *dev,
+					u32 mode)
+{
+	u32 result;
+
+	if (!sci_open(dev))
+		return -EIO;
+
+	result = sci_write(dev, SCI_USB_SLEEP_CHARGE, mode);
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
@@ -1314,6 +1367,12 @@ static ssize_t toshiba_touchpad_show(struct device *dev,
 static ssize_t toshiba_position_show(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf);
+static ssize_t toshiba_usb_sleep_charge_show(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf);
+static ssize_t toshiba_usb_sleep_charge_store(struct device *dev,
+					      struct device_attribute *attr,
+					      const char *buf, size_t count);
 
 static DEVICE_ATTR(kbd_backlight_mode, S_IRUGO | S_IWUSR,
 		   toshiba_kbd_bl_mode_show, toshiba_kbd_bl_mode_store);
@@ -1325,6 +1384,9 @@ static DEVICE_ATTR(kbd_backlight_timeout, S_IRUGO | S_IWUSR,
 static DEVICE_ATTR(touchpad, S_IRUGO | S_IWUSR,
 		   toshiba_touchpad_show, toshiba_touchpad_store);
 static DEVICE_ATTR(position, S_IRUGO, toshiba_position_show, NULL);
+static DEVICE_ATTR(usb_sleep_charge, S_IRUGO | S_IWUSR,
+		   toshiba_usb_sleep_charge_show,
+		   toshiba_usb_sleep_charge_store);
 
 static struct attribute *toshiba_attributes[] = {
 	&dev_attr_kbd_backlight_mode.attr,
@@ -1333,6 +1395,7 @@ static struct attribute *toshiba_attributes[] = {
 	&dev_attr_kbd_backlight_timeout.attr,
 	&dev_attr_touchpad.attr,
 	&dev_attr_position.attr,
+	&dev_attr_usb_sleep_charge.attr,
 	NULL,
 };
 
@@ -1550,6 +1613,50 @@ static ssize_t toshiba_position_show(struct device *dev,
 	return sprintf(buf, "%d %d %d\n", x, y, z);
 }
 
+static ssize_t toshiba_usb_sleep_charge_show(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	u32 state;
+	int ret;
+
+	ret = toshiba_usb_sleep_charge_get(toshiba, &state);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%x\n", state & SCI_USB_CHARGE_MODE_MASK);
+}
+
+static ssize_t toshiba_usb_sleep_charge_store(struct device *dev,
+					      struct device_attribute *attr,
+					      const char *buf, size_t count)
+{
+	struct toshiba_acpi_dev *toshiba = dev_get_drvdata(dev);
+	int state;
+	int ret;
+
+	ret = kstrtoint(buf, 0, &state);
+	if (ret)
+		return ret;
+
+	/* Set the USB charging mode where:
+	 * 0x30000 - Disable
+	 * 0x30009 - Alternate
+	 * 0x30021 - Auto
+	 */
+	state |= 0x30000;
+	if (state != SCI_USB_CHARGE_DISABLED && state != SCI_USB_CHARGE_AUTO &&
+	    state != SCI_USB_CHARGE_ALTERNATE)
+		return -EINVAL;
+
+	ret = toshiba_usb_sleep_charge_set(toshiba, state);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
 static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 					struct attribute *attr, int idx)
 {
@@ -1565,6 +1672,8 @@ static umode_t toshiba_sysfs_is_visible(struct kobject *kobj,
 		exists = (drv->touchpad_supported) ? true : false;
 	else if (attr == &dev_attr_position.attr)
 		exists = (drv->accelerometer_supported) ? true : false;
+	else if (attr == &dev_attr_usb_sleep_charge.attr)
+		exists = (drv->usb_sleep_charge_supported) ? true : false;
 
 	return exists ? attr->mode : 0;
 }
@@ -1974,6 +2083,9 @@ static int toshiba_acpi_add(struct acpi_device *acpi_dev)
 	ret = toshiba_accelerometer_supported(dev);
 	dev->accelerometer_supported = !ret;
 
+	ret = toshiba_usb_sleep_charge_get(dev, &dummy);
+	dev->usb_sleep_charge_supported = !ret;
+
 	/* Determine whether or not BIOS supports fan and video interfaces */
 
 	ret = get_video_status(dev, &dummy);
-- 
2.2.1

