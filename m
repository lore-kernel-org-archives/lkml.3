Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab3AaPHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:07:32 -0500
Received: from host171.canaca.com ([67.55.55.225]:33533 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab3AaPH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:07:28 -0500
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org, rosegardener@freeode.co.uk
Subject: [PATCH 4/5] USB: HID: Steelseries SRW-S1 Add support controlling all LEDs simultaneously
Date: Thu, 31 Jan 2013 08:07:10 -0700
Message-Id: <1359644830-3274-4-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359644830-3274-1-git-send-email-simon@mungewell.org>
References: <alpine.LNX.2.00.1301291057170.23853@pobox.suse.cz>
 <1359644830-3274-1-git-send-email-simon@mungewell.org>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch to the SRW-S1 driver adds the ability to control all
LEDs simultaneously as testing showed that it was slow (noticably!!)
when seting or clearing all the LEDs in turn.

It adds a 'RPMALL' LED, whose behavoir is asserted to all the LEDs in
the bar graph, individual LEDs can subsequently be turned on/off
individually.

Signed-off-by: Simon Wood <simon@mungewell.org>
Tested-by: John Murphy <rosegardener@freeode.co.uk>
---
 Documentation/ABI/testing/sysfs-driver-hid-srws1 |    1 +
 drivers/hid/hid-steelseries-srws1.c              |   65 ++++++++++++++++++++--
 2 files changed, 62 insertions(+), 4 deletions(-)

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
diff --git a/drivers/hid/hid-steelseries-srws1.c b/drivers/hid/hid-steelseries-srws1.c
index ba2e2c3..ea07a24 100644
--- a/drivers/hid/hid-steelseries-srws1.c
+++ b/drivers/hid/hid-steelseries-srws1.c
@@ -136,6 +136,42 @@ static void steelseries_srws1_set_leds(struct hid_device *hdev, __u16 leds)
 	/* Note: LED change does not show on device until the device is read/polled */
 }
 
+static void steelseries_srws1_led_all_set_brightness(struct led_classdev *led_cdev,
+			enum led_brightness value)
+{
+	struct device *dev = led_cdev->dev->parent;
+	struct hid_device *hid = container_of(dev, struct hid_device, dev);
+	struct steelseries_srws1_data *drv_data = hid_get_drvdata(hid);
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
+	steelseries_srws1_set_leds(hid, drv_data->led_state);
+}
+
+static enum led_brightness steelseries_srws1_led_all_get_brightness(struct led_classdev *led_cdev)
+{
+	struct device *dev = led_cdev->dev->parent;
+	struct hid_device *hid = container_of(dev, struct hid_device, dev);
+	struct steelseries_srws1_data *drv_data;
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
 static void steelseries_srws1_led_set_brightness(struct led_classdev *led_cdev,
 			enum led_brightness value)
 {
@@ -219,13 +255,34 @@ static int steelseries_srws1_probe(struct hid_device *hdev,
 
 	/* register led subsystem */
 	drv_data->led_state = 0;
-	for (i = 0; i < SRWS1_NUMBER_LEDS; i++)
+	for (i = 0; i < SRWS1_NUMBER_LEDS + 1; i++)
 		drv_data->led[i] = NULL;
 
 	steelseries_srws1_set_leds(hdev, 0);
 
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
+	led->brightness_get = steelseries_srws1_led_all_get_brightness;
+	led->brightness_set = steelseries_srws1_led_all_set_brightness;
+
+	drv_data->led[SRWS1_NUMBER_LEDS] = led;
+	ret = led_classdev_register(&hdev->dev, led);
+	if (ret)
+		goto err_led;
 
+	/* Each individual LED */
 	for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
 		led = kzalloc(sizeof(struct led_classdev)+name_sz, GFP_KERNEL);
 		if (!led) {
@@ -248,7 +305,7 @@ static int steelseries_srws1_probe(struct hid_device *hdev,
 			hid_err(hdev, "failed to register LED %d. Aborting.\n", i);
 err_led:
 			/* Deregister all LEDs (if any) */
-			for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
+			for (i = 0; i < SRWS1_NUMBER_LEDS + 1; i++) {
 				led = drv_data->led[i];
 				drv_data->led[i] = NULL;
 				if (!led)
@@ -275,7 +332,7 @@ static void steelseries_srws1_remove(struct hid_device *hdev)
 
 	if (drv_data) {
 		/* Deregister LEDs (if any) */
-		for (i = 0; i < SRWS1_NUMBER_LEDS; i++) {
+		for (i = 0; i < SRWS1_NUMBER_LEDS + 1; i++) {
 			led = drv_data->led[i];
 			drv_data->led[i] = NULL;
 			if (!led)
-- 
1.7.10.4

