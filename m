Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3AYGpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 01:45:12 -0500
Received: from smtp-out-02.shaw.ca ([64.59.136.138]:50296 "EHLO
	smtp-out-02.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3AYGpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 01:45:07 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=3f4U5fHrZLLPCzJ96ldNbjtja1zQ0ih230F6vdsLr5s= c=1 sm=1
 a=4nMGD83CQFQA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=47LbCVvxAAAA:8 a=auE1FfZpAAAA:8
 a=eW77HSo60n9A7VLgepAA:9 a=CdcXBqxaGooA:10 a=QhNQsjeWOoAA:10
 a=Ux_uGsAPmqgA:10 a=nkARASpMrCrbf6z3:21 a=JNoUd3K9UA9UJkRR:21
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, rosegardener@freeode.co.uk
Subject: [PATCH 3/4] USB: HID: SRW-S1 Add support for LEDs
Date: Thu, 24 Jan 2013 23:34:46 -0700
Message-Id: <1359095687-13398-3-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359095687-13398-1-git-send-email-simon@mungewell.org>
References: <1359095687-13398-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: simon <simon@simon-virtual-machine.(none)>

This patch to the SRW-S1 driver adds support for the LED RPM
meter on the front of the device. The LEDs are controlled via
/sys/class/leds interface, with an individual control for each
of the 15 LEDs.

Signed-off-by: Simon Wood <simon@mungewell.org>
tested-by: John Murphy <rosegardener@freeode.co.uk>

---
 Documentation/ABI/testing/sysfs-driver-hid-srws1 |   20 +++
 drivers/hid/hid-srws1.c                          |  199 ++++++++++++++++++++++
 2 files changed, 219 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-srws1

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-srws1 b/Documentation/ABI/testing/sysfs-driver-hid-srws1
new file mode 100644
index 0000000..c27b34d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-srws1
@@ -0,0 +1,20 @@
+What:		/sys/class/leds/SRWS1::<serial>::RPM1
+What:		/sys/class/leds/SRWS1::<serial>::RPM2
+What:		/sys/class/leds/SRWS1::<serial>::RPM3
+What:		/sys/class/leds/SRWS1::<serial>::RPM4
+What:		/sys/class/leds/SRWS1::<serial>::RPM5
+What:		/sys/class/leds/SRWS1::<serial>::RPM6
+What:		/sys/class/leds/SRWS1::<serial>::RPM7
+What:		/sys/class/leds/SRWS1::<serial>::RPM8
+What:		/sys/class/leds/SRWS1::<serial>::RPM9
+What:		/sys/class/leds/SRWS1::<serial>::RPM10
+What:		/sys/class/leds/SRWS1::<serial>::RPM11
+What:		/sys/class/leds/SRWS1::<serial>::RPM12
+What:		/sys/class/leds/SRWS1::<serial>::RPM13
+What:		/sys/class/leds/SRWS1::<serial>::RPM14
+What:		/sys/class/leds/SRWS1::<serial>::RPM15
+Date:		Jan 2013
+KernelVersion:	3.9
+Contact:	Simon Wood <simon@mungewell.org>
+Description:	Provides a control for turning on/off the LEDs which form
+		an RPM meter on the front of the controller
diff --git a/drivers/hid/hid-srws1.c b/drivers/hid/hid-srws1.c
index 4d8a86b..6005b84 100644
--- a/drivers/hid/hid-srws1.c
+++ b/drivers/hid/hid-srws1.c
@@ -12,11 +12,21 @@
  */
 
 #include <linux/device.h>
+#include <linux/usb.h>
 #include <linux/hid.h>
 #include <linux/module.h>
 
+#include "usbhid/usbhid.h"
 #include "hid-ids.h"
 
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#define SRWS1_NUMBER_LEDS 15
+struct srws1_data {
+	__u16 led_state;
+	struct led_classdev *led[SRWS1_NUMBER_LEDS];
+};
+#endif
+
 /* Fixed report descriptor for Steelseries SRW-S1 wheel controller
  *
  * The original descriptor hides the sensitivity and assists dials
@@ -97,6 +107,191 @@ static __u8 srws1_rdesc_fixed[] = {
 0xC0                /*  End Collection                      */
 };
 
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+static void srws1_set_leds(struct hid_device *hdev, __u16 leds)
+{
+	struct list_head *report_list = &hdev->report_enum[HID_OUTPUT_REPORT].report_list;
+	struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
+	__s32 *value = report->field[0]->value;
+
+	value[0] = 0x40;
+	value[1] = leds;
+	value[2] = leds >> 8;
+	value[3] = 0x00;
+	value[4] = 0x00;
+	value[5] = 0x00;
+	value[6] = 0x00;
+	value[7] = 0x00;
+	value[8] = 0x00;
+	value[9] = 0x00;
+	value[10] = 0x00;
+	value[11] = 0x00;
+	value[12] = 0x00;
+	value[13] = 0x00;
+	value[14] = 0x00;
+	value[15] = 0x00;
+
+	usbhid_submit_report(hdev, report, USB_DIR_OUT);
+
+	/* Note: LED change does not show on device until the device is read/polled */
+}
+
+static void srws1_led_set_brightness(struct led_classdev *led_cdev,
+			enum led_brightness value)
+{
+	struct device *dev = led_cdev->dev->parent;
+	struct hid_device *hid = container_of(dev, struct hid_device, dev);
+	struct srws1_data *drv_data = hid_get_drvdata(hid);
+	int i, state = 0;
+
+	if (!drv_data) {
+		hid_err(hid, "Device data not found.");
+		return;
+	}
+
+	for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
+		if (led_cdev != drv_data->led[i])
+			continue;
+
+		state = (drv_data->led_state >> i) & 1;
+		if (value == LED_OFF && state) {
+			drv_data->led_state &= ~(1 << i);
+			srws1_set_leds(hid, drv_data->led_state);
+		} else if (value != LED_OFF && !state) {
+			drv_data->led_state |= 1 << i;
+			srws1_set_leds(hid, drv_data->led_state);
+		}
+		break;
+	}
+}
+
+static enum led_brightness srws1_led_get_brightness(struct led_classdev *led_cdev)
+{
+	struct device *dev = led_cdev->dev->parent;
+	struct hid_device *hid = container_of(dev, struct hid_device, dev);
+	struct srws1_data *drv_data;
+	int i, value = 0;
+
+	drv_data = hid_get_drvdata(hid);
+
+	if (!drv_data) {
+		hid_err(hid, "Device data not found.");
+		return LED_OFF;
+	}
+
+	for (i = 0; i < SRWS1_NUMBER_LEDS; i++)
+		if (led_cdev == drv_data->led[i]) {
+			value = (drv_data->led_state >> i) & 1;
+			break;
+		}
+
+	return value ? LED_FULL : LED_OFF;
+}
+
+static int srws1_probe(struct hid_device *hdev,
+		const struct hid_device_id *id)
+{
+	int ret, i;
+	struct led_classdev *led;
+	size_t name_sz;
+	char *name;
+
+	struct srws1_data *drv_data = kzalloc(sizeof(*drv_data), GFP_KERNEL);
+
+	if (drv_data == NULL) {
+		hid_err(hdev, "can't alloc SRW-S1 memory\n");
+		return -ENOMEM;
+	}
+
+	hid_set_drvdata(hdev, drv_data);
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		hid_err(hdev, "parse failed\n");
+		goto err_free;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (ret) {
+		hid_err(hdev, "hw start failed\n");
+		goto err_free;
+	}
+
+	/* register led subsystem */
+	drv_data->led_state = 0;
+	for (i = 0; i < SRWS1_NUMBER_LEDS; i++)
+		drv_data->led[i] = NULL;
+
+	srws1_set_leds(hdev, 0);
+
+	name_sz = strlen(hdev->uniq) + 15;
+
+	for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
+		led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
+		if (!led) {
+			hid_err(hdev, "can't allocate memory for LED %d\n", i);
+			goto err_led;
+		}
+
+		name = (void *)(&led[1]);
+		snprintf(name, name_sz, "SRWS1::%s::RPM%d", hdev->uniq, i+1);
+		led->name = name;
+		led->brightness = 0;
+		led->max_brightness = 1;
+		led->brightness_get = srws1_led_get_brightness;
+		led->brightness_set = srws1_led_set_brightness;
+
+		drv_data->led[i] = led;
+		ret = led_classdev_register(&hdev->dev, led);
+
+		if (ret) {
+			hid_err(hdev, "failed to register LED %d. Aborting.\n", i);
+err_led:
+			/* Deregister all LEDs (if any) */
+			for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
+				led = drv_data->led[i];
+				drv_data->led[i] = NULL;
+				if (!led)
+					continue;
+				led_classdev_unregister(led);
+				kfree(led);
+			}
+			goto out;	/* but let the driver continue without LEDs */
+		}
+	}
+out:
+	return 0;
+err_free:
+	kfree(drv_data);
+	return ret;
+}
+
+static void srws1_remove(struct hid_device *hdev)
+{
+	int i;
+	struct led_classdev *led;
+
+	struct srws1_data *drv_data = hid_get_drvdata(hdev);
+
+	if (drv_data) {
+		/* Deregister LEDs (if any) */
+		for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
+			led = drv_data->led[i];
+			drv_data->led[i] = NULL;
+			if (!led)
+				continue;
+			led_classdev_unregister(led);
+			kfree(led);
+		}
+
+	}
+
+	hid_hw_stop(hdev);
+	kfree(drv_data);
+	return;
+}
+#endif
+
 static __u8 *srws1_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		unsigned int *rsize)
 {
@@ -118,6 +313,10 @@ MODULE_DEVICE_TABLE(hid, srws1_devices);
 static struct hid_driver srws1_driver = {
 	.name = "srws1",
 	.id_table = srws1_devices,
+#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+	.probe = srws1_probe,
+	.remove = srws1_remove,
+#endif
 	.report_fixup = srws1_report_fixup
 };
 
-- 
1.7.10.4

