Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3AYGpD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 01:45:03 -0500
Received: from smtp-out-02.shaw.ca ([64.59.136.138]:50296 "EHLO
	smtp-out-02.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab3AYGpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 01:45:00 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=3f4U5fHrZLLPCzJ96ldNbjtja1zQ0ih230F6vdsLr5s= c=1 sm=1
 a=_DZGuAVSYwkA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=47LbCVvxAAAA:8 a=auE1FfZpAAAA:8
 a=9w5ZgiHSwaCj67AWmJIA:9 a=CdcXBqxaGooA:10 a=QhNQsjeWOoAA:10
 a=Ux_uGsAPmqgA:10 a=ygRhHD9AWpQLCRi-:21 a=g_a13MI3Ici81B9k:21
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, rosegardener@freeode.co.uk
Subject: [PATCH 4/4] USB: HID: SRW-S1 Add support controlling all LEDs simultaneously
Date: Thu, 24 Jan 2013 23:34:47 -0700
Message-Id: <1359095687-13398-4-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359095687-13398-1-git-send-email-simon@mungewell.org>
References: <1359095687-13398-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: simon <simon@simon-virtual-machine.(none)>

This patch to the SRW-S1 driver adds the ability to control all
LEDs simultaneously as testing showed that it was slow (noticably!!)
when seting or clearing all the LEDs in turn.

It adds a 'RPMALL' LED, whose behavoir is asserted to all the LEDs in
the bar graph, individual LEDs can subsequently be turned on/off
individually.

Signed-off-by: Simon Wood <simon@mungewell.org>
tested-by: John Murphy <rosegardener@freeode.co.uk>

---
 Documentation/ABI/testing/sysfs-driver-hid-srws1 |    1 +
 drivers/hid/hid-srws1.c                          |   67 ++++++++++++++++++++--
 2 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-srws1 b/Documentation/ABI/testing/sysfs-driver-hid-srws1
index c27b34d..d0eba70 100644
--- a/Documentation/ABI/testing/sysfs-driver-hid-srws1
+++ b/Documentation/ABI/testing/sysfs-driver-hid-srws1
@@ -13,6 +13,7 @@ What:		/sys/class/leds/SRWS1::<serial>::RPM12
 What:		/sys/class/leds/SRWS1::<serial>::RPM13
 What:		/sys/class/leds/SRWS1::<serial>::RPM14
 What:		/sys/class/leds/SRWS1::<serial>::RPM15
+What:		/sys/class/leds/SRWS1::<serial>::RPMALL
 Date:		Jan 2013
 KernelVersion:	3.9
 Contact:	Simon Wood <simon@mungewell.org>
diff --git a/drivers/hid/hid-srws1.c b/drivers/hid/hid-srws1.c
index 6005b84..2604e4e 100644
--- a/drivers/hid/hid-srws1.c
+++ b/drivers/hid/hid-srws1.c
@@ -23,7 +23,7 @@
 #define SRWS1_NUMBER_LEDS 15
 struct srws1_data {
 	__u16 led_state;
-	struct led_classdev *led[SRWS1_NUMBER_LEDS];
+	struct led_classdev *led[SRWS1_NUMBER_LEDS + 1]; /* including 'ALL' led */
 };
 #endif
 
@@ -136,6 +136,42 @@ static void srws1_set_leds(struct hid_device *hdev, __u16 leds)
 	/* Note: LED change does not show on device until the device is read/polled */
 }
 
+static void srws1_led_all_set_brightness(struct led_classdev *led_cdev,
+			enum led_brightness value)
+{
+	struct device *dev = led_cdev->dev->parent;
+	struct hid_device *hid = container_of(dev, struct hid_device, dev);
+	struct srws1_data *drv_data = hid_get_drvdata(hid);
+
+	if (!drv_data) {
+		hid_err(hid, "Device data not found.");
+		return;
+	}
+
+	if (value == LED_OFF)
+		drv_data->led_state = 0;
+	else
+		drv_data->led_state = (1 << (SRWS1_NUMBER_LEDS + 1)) - 1;
+
+	srws1_set_leds(hid, drv_data->led_state);
+}
+
+static enum led_brightness srws1_led_all_get_brightness(struct led_classdev *led_cdev)
+{
+	struct device *dev = led_cdev->dev->parent;
+	struct hid_device *hid = container_of(dev, struct hid_device, dev);
+	struct srws1_data *drv_data;
+
+	drv_data = hid_get_drvdata(hid);
+
+	if (!drv_data) {
+		hid_err(hid, "Device data not found.");
+		return LED_OFF;
+	}
+
+	return (drv_data->led_state >> SRWS1_NUMBER_LEDS) ? LED_FULL : LED_OFF;
+}
+
 static void srws1_led_set_brightness(struct led_classdev *led_cdev,
 			enum led_brightness value)
 {
@@ -219,13 +255,34 @@ static int srws1_probe(struct hid_device *hdev,
 
 	/* register led subsystem */
 	drv_data->led_state = 0;
-	for (i = 0; i < SRWS1_NUMBER_LEDS; i++)
+	for (i = 0; i < SRWS1_NUMBER_LEDS + 1; i++)
 		drv_data->led[i] = NULL;
 
 	srws1_set_leds(hdev, 0);
 
-	name_sz = strlen(hdev->uniq) + 15;
+	name_sz = strlen(hdev->uniq) + 16;
+
+	/* 'ALL', for setting all LEDs simultaneously */
+	led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
+	if (!led) {
+		hid_err(hdev, "can't allocate memory for LED ALL\n");
+		goto err_led;
+	}
+
+	name = (void *)(&led[1]);
+	snprintf(name, name_sz, "SRWS1::%s::RPMALL", hdev->uniq);
+	led->name = name;
+	led->brightness = 0;
+	led->max_brightness = 1;
+	led->brightness_get = srws1_led_all_get_brightness;
+	led->brightness_set = srws1_led_all_set_brightness;
+
+	drv_data->led[SRWS1_NUMBER_LEDS] = led;
+	ret = led_classdev_register(&hdev->dev, led);
+	if (ret)
+		goto err_led;
 
+	/* Each individual LED */
 	for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
 		led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
 		if (!led) {
@@ -248,7 +305,7 @@ static int srws1_probe(struct hid_device *hdev,
 			hid_err(hdev, "failed to register LED %d. Aborting.\n", i);
 err_led:
 			/* Deregister all LEDs (if any) */
-			for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
+			for (i = 0; i < SRWS1_NUMBER_LEDS + 1; i++) {
 				led = drv_data->led[i];
 				drv_data->led[i] = NULL;
 				if (!led)
@@ -275,7 +332,7 @@ static void srws1_remove(struct hid_device *hdev)
 
 	if (drv_data) {
 		/* Deregister LEDs (if any) */
-		for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
+		for (i = 0; i < SRWS1_NUMBER_LEDS + 1; i++) {
 			led = drv_data->led[i];
 			drv_data->led[i] = NULL;
 			if (!led)
-- 
1.7.10.4

