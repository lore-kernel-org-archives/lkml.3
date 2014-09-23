Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbaIWQIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:08:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144AbaIWQIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:08:21 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        killertofu@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] HID: wacom: split out input allocation and registration
Date: Tue, 23 Sep 2014 12:08:06 -0400
Message-Id: <1411488489-10625-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the input can be created earlier during probe, we can already populate
them while reading the report descriptor. This way, we can rely on the
hid subsystem directly for tablets which already provide a meaningful
report descriptor (like ISDv4-5).

This patch only splits the allocation and registration, but do not
change where we allocate the input. This will come in a later patch.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_sys.c | 96 ++++++++++++++++++++++++++++++++-----------------
 drivers/hid/wacom_wac.h |  1 +
 2 files changed, 64 insertions(+), 33 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 97e1fef..62f3c89 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -1054,41 +1054,75 @@ static struct input_dev *wacom_allocate_input(struct wacom *wacom)
 	return input_dev;
 }
 
-static void wacom_unregister_inputs(struct wacom *wacom)
+static void wacom_free_inputs(struct wacom *wacom)
 {
-	if (wacom->wacom_wac.input)
-		input_unregister_device(wacom->wacom_wac.input);
-	if (wacom->wacom_wac.pad_input)
-		input_unregister_device(wacom->wacom_wac.pad_input);
-	wacom->wacom_wac.input = NULL;
-	wacom->wacom_wac.pad_input = NULL;
-	wacom_destroy_leds(wacom);
+	struct wacom_wac *wacom_wac = &(wacom->wacom_wac);
+
+	if (wacom_wac->input)
+		input_free_device(wacom_wac->input);
+	if (wacom_wac->pad_input)
+		input_free_device(wacom_wac->pad_input);
+	wacom_wac->input = NULL;
+	wacom_wac->pad_input = NULL;
 }
 
-static int wacom_register_inputs(struct wacom *wacom)
+static int wacom_allocate_inputs(struct wacom *wacom)
 {
 	struct input_dev *input_dev, *pad_input_dev;
 	struct wacom_wac *wacom_wac = &(wacom->wacom_wac);
-	int error;
 
 	input_dev = wacom_allocate_input(wacom);
 	pad_input_dev = wacom_allocate_input(wacom);
 	if (!input_dev || !pad_input_dev) {
-		error = -ENOMEM;
-		goto fail_allocate_input;
+		wacom_free_inputs(wacom);
+		return -ENOMEM;
 	}
 
 	wacom_wac->input = input_dev;
 	wacom_wac->pad_input = pad_input_dev;
 	wacom_wac->pad_input->name = wacom_wac->pad_name;
 
+	return 0;
+}
+
+static void wacom_clean_inputs(struct wacom *wacom)
+{
+	if (wacom->wacom_wac.input) {
+		if (wacom->wacom_wac.input_registered)
+			input_unregister_device(wacom->wacom_wac.input);
+		else
+			input_free_device(wacom->wacom_wac.input);
+	}
+	if (wacom->wacom_wac.pad_input) {
+		if (wacom->wacom_wac.input_registered)
+			input_unregister_device(wacom->wacom_wac.pad_input);
+		else
+			input_free_device(wacom->wacom_wac.pad_input);
+	}
+	wacom->wacom_wac.input = NULL;
+	wacom->wacom_wac.pad_input = NULL;
+	wacom_destroy_leds(wacom);
+}
+
+static int wacom_register_inputs(struct wacom *wacom)
+{
+	struct input_dev *input_dev, *pad_input_dev;
+	struct wacom_wac *wacom_wac = &(wacom->wacom_wac);
+	int error;
+
+	input_dev = wacom_wac->input;
+	pad_input_dev = wacom_wac->pad_input;
+
+	if (!input_dev || !pad_input_dev)
+		return -EINVAL;
+
 	error = wacom_setup_input_capabilities(input_dev, wacom_wac);
 	if (error)
-		goto fail_input_cap;
+		return error;
 
 	error = input_register_device(input_dev);
 	if (error)
-		goto fail_register_input;
+		return error;
 
 	error = wacom_setup_pad_input_capabilities(pad_input_dev, wacom_wac);
 	if (error) {
@@ -1106,6 +1140,8 @@ static int wacom_register_inputs(struct wacom *wacom)
 			goto fail_leds;
 	}
 
+	wacom_wac->input_registered = true;
+
 	return 0;
 
 fail_leds:
@@ -1113,16 +1149,7 @@ fail_leds:
 	pad_input_dev = NULL;
 fail_register_pad_input:
 	input_unregister_device(input_dev);
-	input_dev = NULL;
-fail_register_input:
-fail_input_cap:
 	wacom_wac->input = NULL;
-	wacom_wac->pad_input = NULL;
-fail_allocate_input:
-	if (input_dev)
-		input_free_device(input_dev);
-	if (pad_input_dev)
-		input_free_device(pad_input_dev);
 	return error;
 }
 
@@ -1147,13 +1174,13 @@ static void wacom_wireless_work(struct work_struct *work)
 	hdev1 = usb_get_intfdata(usbdev->config->interface[1]);
 	wacom1 = hid_get_drvdata(hdev1);
 	wacom_wac1 = &(wacom1->wacom_wac);
-	wacom_unregister_inputs(wacom1);
+	wacom_clean_inputs(wacom1);
 
 	/* Touch interface */
 	hdev2 = usb_get_intfdata(usbdev->config->interface[2]);
 	wacom2 = hid_get_drvdata(hdev2);
 	wacom_wac2 = &(wacom2->wacom_wac);
-	wacom_unregister_inputs(wacom2);
+	wacom_clean_inputs(wacom2);
 
 	if (wacom_wac->pid == 0) {
 		hid_info(wacom->hdev, "wireless tablet disconnected\n");
@@ -1187,7 +1214,8 @@ static void wacom_wireless_work(struct work_struct *work)
 		wacom_wac1->shared->touch_max = wacom_wac1->features.touch_max;
 		wacom_wac1->shared->type = wacom_wac1->features.type;
 		wacom_wac1->pid = wacom_wac->pid;
-		error = wacom_register_inputs(wacom1);
+		error = wacom_allocate_inputs(wacom1) ||
+			wacom_register_inputs(wacom1);
 		if (error)
 			goto fail;
 
@@ -1208,7 +1236,8 @@ static void wacom_wireless_work(struct work_struct *work)
 			snprintf(wacom_wac2->pad_name, WACOM_NAME_MAX,
 				 "%s (WL) Pad", wacom_wac2->features.name);
 			wacom_wac2->pid = wacom_wac->pid;
-			error = wacom_register_inputs(wacom2);
+			error = wacom_allocate_inputs(wacom2) ||
+				wacom_register_inputs(wacom2);
 			if (error)
 				goto fail;
 
@@ -1225,8 +1254,8 @@ static void wacom_wireless_work(struct work_struct *work)
 	return;
 
 fail:
-	wacom_unregister_inputs(wacom1);
-	wacom_unregister_inputs(wacom2);
+	wacom_clean_inputs(wacom1);
+	wacom_clean_inputs(wacom2);
 	return;
 }
 
@@ -1400,7 +1429,8 @@ static int wacom_probe(struct hid_device *hdev,
 	}
 
 	if (!(features->quirks & WACOM_QUIRK_NO_INPUT)) {
-		error = wacom_register_inputs(wacom);
+		error = wacom_allocate_inputs(wacom) ||
+			wacom_register_inputs(wacom);
 		if (error)
 			goto fail_register_inputs;
 	}
@@ -1434,11 +1464,11 @@ static int wacom_probe(struct hid_device *hdev,
 	return 0;
 
 fail_hw_start:
-	wacom_unregister_inputs(wacom);
+	wacom_clean_inputs(wacom);
 	if (hdev->bus == BUS_BLUETOOTH)
 		device_remove_file(&hdev->dev, &dev_attr_speed);
 fail_register_inputs:
-	wacom_unregister_inputs(wacom);
+	wacom_clean_inputs(wacom);
 	wacom_destroy_battery(wacom);
 fail_battery:
 	wacom_remove_shared_data(wacom_wac);
@@ -1458,7 +1488,7 @@ static void wacom_remove(struct hid_device *hdev)
 	hid_hw_stop(hdev);
 
 	cancel_work_sync(&wacom->work);
-	wacom_unregister_inputs(wacom);
+	wacom_clean_inputs(wacom);
 	if (hdev->bus == BUS_BLUETOOTH)
 		device_remove_file(&hdev->dev, &dev_attr_speed);
 	wacom_destroy_battery(wacom);
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 339ab5d..72f9ca8 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -167,6 +167,7 @@ struct wacom_wac {
 	struct wacom_shared *shared;
 	struct input_dev *input;
 	struct input_dev *pad_input;
+	bool input_registered;
 	int pid;
 	int battery_capacity;
 	int num_contacts_left;
-- 
2.1.0

