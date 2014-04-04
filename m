Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaDDROv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 13:14:51 -0400
Received: from smtp04.udag.de ([62.146.106.30]:34912 "EHLO smtp04.udag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbaDDRNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 13:13:25 -0400
From: Tolga Cakir <tolga@cevel.net>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Derya <derya.kiran@yahoo.de>, Jiri Kosina <jkosina@suse.cz>,
        Reyad Attiyat <reyad.attiyat@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tolga Cakir <tolga@cevel.net>
Subject: [PATCH 3/4] HID: microsoft: added Sidewinder X4 / X6 sysfs support
Date: Fri,  4 Apr 2014 19:07:07 +0200
Message-Id: <1396631227-11770-1-git-send-email-tolga@cevel.net>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables us to set the profile, LEDs and read the key mask via sysfs. Documentation is included in this patch.

Signed-off-by: Tolga Cakir <tolga@cevel.net>
---
 .../ABI/testing/sysfs-driver-hid-microsoft         |  30 +++
 drivers/hid/hid-microsoft.c                        | 231 +++++++++++++++++++++
 2 files changed, 261 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-microsoft

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-microsoft b/Documentation/ABI/testing/sysfs-driver-hid-microsoft
new file mode 100644
index 0000000..9fdfad7
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-microsoft
@@ -0,0 +1,30 @@
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/auto_led
+Date:		April 2014
+Contact:	Tolga Cakir <tolga@cevel.net>
+Description:	This file allows you to set and view the Auto LED status.
+		Valid values are 0 and 1.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/profile
+Date:		April 2014
+Contact:	Tolga Cakir <tolga@cevel.net>
+Description:	Both, the Sidewinder X4 and the X6 can handle profiles.
+		They can be switched by writing to this file. Profile LEDs will be
+		set accordingly.
+		Valid values are 1 - 3.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/key_mask
+Date:		April 2014
+Contact:	Tolga Cakir <tolga@cevel.net>
+Description:	This file is read-only and outputs an unsigned long integer.
+		Every bit represents one of the S1 - S6 extra keys on the Sidewinder
+		X4 and S1 - S30 on the Sidewinder X6. The least significant bit
+		represents S1 on both gaming keyboards, the most significant bit
+		represents the Bank switch button on both keyboards. Multiple
+		special keys can be pressed at the same time.
+
+What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/record_led
+Date:		April 2014
+Contact:	Tolga Cakir <tolga@cevel.net>
+Description:	This file allows you to set and view the Record LED status.
+		Valid values are 0 - 2. 0 stands for off, 1 for solid mode and 2
+		for blinking mode.
diff --git a/drivers/hid/hid-microsoft.c b/drivers/hid/hid-microsoft.c
index 5b5d40f..5674c0c 100644
--- a/drivers/hid/hid-microsoft.c
+++ b/drivers/hid/hid-microsoft.c
@@ -19,6 +19,8 @@
 #include <linux/input.h>
 #include <linux/hid.h>
 #include <linux/module.h>
+#include <linux/sysfs.h>
+#include <linux/usb.h>
 
 #include "hid-ids.h"
 
@@ -209,6 +211,219 @@ static int ms_sidewinder_kb_quirk(struct hid_input *hi, struct hid_usage *usage,
 	return 1;
 }
 
+static int ms_sidewinder_control(struct hid_device *hdev, __u8 setup)
+{
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+	struct hid_report *report =
+			hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[7];
+
+	/*
+	 * LEDs 1 - 3 should not be set simultaneously, however
+	 * they can be set in any combination with Auto or Record LEDs.
+	 */
+	report->field[0]->value[0] = (setup & 0x01) ? 0x01 : 0x00;	/* X6 only: Macro Pad toggle */
+	report->field[0]->value[1] = (setup & 0x02) ? 0x01 : 0x00;	/* LED Auto */
+	report->field[0]->value[2] = (setup & 0x04) ? 0x01 : 0x00;	/* LED 1 */
+	report->field[0]->value[3] = (setup & 0x08) ? 0x01 : 0x00;	/* LED 2 */
+	report->field[0]->value[4] = (setup & 0x10) ? 0x01 : 0x00;	/* LED 3 */
+	report->field[1]->value[0] = 0x00;	/* Clear Record LED */
+
+	switch (setup & 0x60) {
+	case 0x40: report->field[1]->value[0] = 0x02;	break;	/* Record LED Blink */
+	case 0x20: report->field[1]->value[0] = 0x03;	break;	/* Record LED Solid */
+	}
+
+	hid_hw_request(hdev, report, HID_REQ_SET_REPORT);
+	sidewinder->status = setup;
+
+	return 0;
+}
+
+/*
+ * Sidewinder sysfs
+ * @key_mask: show pressed special keys
+ * @profile: show and set profile count and LED status
+ * @auto_led: show and set LED Auto
+ * @record_led: show and set Record LED
+ */
+static ssize_t ms_sidewinder_key_mask_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+
+	return snprintf(buf, PAGE_SIZE, "%lu\n", sidewinder->key_mask);
+}
+
+static struct device_attribute dev_attr_ms_sidewinder_key_mask = {
+	.attr = { .name = __stringify(key_mask), .mode = S_IRUGO },
+	.show = ms_sidewinder_key_mask_show
+};
+
+static ssize_t ms_sidewinder_profile_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+
+	return snprintf(buf, PAGE_SIZE, "%1u\n", sidewinder->profile);
+}
+
+static ssize_t ms_sidewinder_profile_store(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+	__u8 setup = sidewinder->status & ~(0x1c);	/* Clear Profile LEDs */
+
+	if (sscanf(buf, "%1u", &sidewinder->profile) != 1)
+		return -EINVAL;
+
+	if (sidewinder->profile < 1 || sidewinder->profile > 3) {
+		return -EINVAL;
+	} else {
+		setup |= 0x02 << sidewinder->profile;
+		ms_sidewinder_control(hdev, setup);
+		return strnlen(buf, PAGE_SIZE);
+	}
+}
+
+static struct device_attribute dev_attr_ms_sidewinder_profile =
+	__ATTR(profile, S_IWUSR | S_IRUGO,
+		ms_sidewinder_profile_show,
+		ms_sidewinder_profile_store);
+
+static ssize_t ms_sidewinder_macro_pad_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+
+	return snprintf(buf, PAGE_SIZE, "%1u\n", (sidewinder->status & 0x01));
+}
+
+static ssize_t ms_sidewinder_macro_pad_store(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+	unsigned int value;
+	__u8 setup;
+
+	if (sscanf(buf, "%1u", &value) != 1)
+		return -EINVAL;
+
+	if (value < 0 || value > 1) {
+		return -EINVAL;
+	} else {
+		setup = sidewinder->status & ~(0x01);	/* Clear Macro Pad */
+		if (value)
+			setup |= 0x01;
+		ms_sidewinder_control(hdev, setup);
+		return strnlen(buf, PAGE_SIZE);
+	}
+}
+
+static struct device_attribute dev_attr_ms_sidewinder_macro_pad =
+	__ATTR(macro_pad, S_IWUSR | S_IRUGO,
+		ms_sidewinder_macro_pad_show,
+		ms_sidewinder_macro_pad_store);
+
+static ssize_t ms_sidewinder_record_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+
+	return snprintf(buf, PAGE_SIZE, "%1d\n", (sidewinder->status & 0x60) >> 5);
+}
+
+static ssize_t ms_sidewinder_record_store(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+	unsigned int value;
+	__u8 setup;
+
+	if (sscanf(buf, "%1u", &value) != 1)
+		return -EINVAL;
+
+	if (value < 0 || value > 2) {
+		return -EINVAL;
+	} else {
+		setup = sidewinder->status & ~(0xe0);	/* Clear Record LED */
+		if (value)
+			setup |= 0x10 << value;
+		ms_sidewinder_control(hdev, setup);
+		return strnlen(buf, PAGE_SIZE);
+	}
+}
+
+static struct device_attribute dev_attr_ms_sidewinder_record =
+	__ATTR(record_led, S_IWUSR | S_IRUGO,
+		ms_sidewinder_record_show,
+		ms_sidewinder_record_store);
+
+static ssize_t ms_sidewinder_auto_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+
+	return snprintf(buf, PAGE_SIZE, "%1d\n", (sidewinder->status & 0x02) >> 1);
+}
+
+static ssize_t ms_sidewinder_auto_store(struct device *dev,
+		struct device_attribute *attr, char const *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct ms_data *sc = hid_get_drvdata(hdev);
+	struct ms_sidewinder_extra *sidewinder = sc->extra;
+	unsigned int value;
+	__u8 setup;
+
+	if (sscanf(buf, "%1d", &value) != 1)
+		return -EINVAL;
+
+	if (value < 0 || value > 1) {
+		return -EINVAL;
+	} else {
+		setup = sidewinder->status & ~(0x02);	/* Clear Auto LED */
+		if (value)
+			setup |= 0x02;
+		ms_sidewinder_control(hdev, setup);
+		return strnlen(buf, PAGE_SIZE);
+	}
+}
+
+static struct device_attribute dev_attr_ms_sidewinder_auto =
+	__ATTR(auto_led, S_IWUSR | S_IRUGO,
+		ms_sidewinder_auto_show,
+		ms_sidewinder_auto_store);
+
+static struct attribute *ms_attributes[] = {
+	&dev_attr_ms_sidewinder_key_mask.attr,
+	&dev_attr_ms_sidewinder_profile.attr,
+	&dev_attr_ms_sidewinder_macro_pad.attr,
+	&dev_attr_ms_sidewinder_record.attr,
+	&dev_attr_ms_sidewinder_auto.attr,
+	NULL
+};
+
+static const struct attribute_group ms_attr_group = {
+	.attrs = ms_attributes,
+};
+
 static int ms_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		struct hid_field *field, struct hid_usage *usage,
 		unsigned long **bit, int *max)
@@ -357,6 +572,13 @@ static int ms_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			return -ENOMEM;
 		}
 		sc->extra = sidewinder;
+
+		/* Create sysfs files for the Consumer Control Device only */
+		if (hdev->type == 2) {
+			if (sysfs_create_group(&hdev->dev.kobj, &ms_attr_group)) {
+				hid_warn(hdev, "Could not create sysfs group\n");
+			}
+		}
 	}
 
 	ret = hid_parse(hdev);
@@ -377,6 +599,14 @@ err_free:
 	return ret;
 }
 
+static void ms_remove(struct hid_device *hdev)
+{
+	sysfs_remove_group(&hdev->dev.kobj,
+		&ms_attr_group);
+
+	hid_hw_stop(hdev);
+}
+
 static const struct hid_device_id ms_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_SIDEWINDER_GV),
 		.driver_data = MS_HIDINPUT },
@@ -419,6 +649,7 @@ static struct hid_driver ms_driver = {
 	.input_mapped = ms_input_mapped,
 	.event = ms_event,
 	.probe = ms_probe,
+	.remove = ms_remove,
 };
 module_hid_driver(ms_driver);
 
-- 
1.9.1

