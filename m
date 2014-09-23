Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192AbaIWQIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:08:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbaIWQIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:08:17 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        killertofu@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] HID: wacom: rename failN with some meaningful information
Date: Tue, 23 Sep 2014 12:08:05 -0400
Message-Id: <1411488489-10625-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1411488489-10625-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we have to deal with new elements in probe, having the exit labels
named sequencially is a pain to maintain. Put a meaningful name instead
so that we do not have to renumber them on inserts.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/wacom_sys.c | 49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 2508628..97e1fef 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -1075,7 +1075,7 @@ static int wacom_register_inputs(struct wacom *wacom)
 	pad_input_dev = wacom_allocate_input(wacom);
 	if (!input_dev || !pad_input_dev) {
 		error = -ENOMEM;
-		goto fail1;
+		goto fail_allocate_input;
 	}
 
 	wacom_wac->input = input_dev;
@@ -1084,11 +1084,11 @@ static int wacom_register_inputs(struct wacom *wacom)
 
 	error = wacom_setup_input_capabilities(input_dev, wacom_wac);
 	if (error)
-		goto fail2;
+		goto fail_input_cap;
 
 	error = input_register_device(input_dev);
 	if (error)
-		goto fail2;
+		goto fail_register_input;
 
 	error = wacom_setup_pad_input_capabilities(pad_input_dev, wacom_wac);
 	if (error) {
@@ -1099,25 +1099,26 @@ static int wacom_register_inputs(struct wacom *wacom)
 	} else {
 		error = input_register_device(pad_input_dev);
 		if (error)
-			goto fail3;
+			goto fail_register_pad_input;
 
 		error = wacom_initialize_leds(wacom);
 		if (error)
-			goto fail4;
+			goto fail_leds;
 	}
 
 	return 0;
 
-fail4:
+fail_leds:
 	input_unregister_device(pad_input_dev);
 	pad_input_dev = NULL;
-fail3:
+fail_register_pad_input:
 	input_unregister_device(input_dev);
 	input_dev = NULL;
-fail2:
+fail_register_input:
+fail_input_cap:
 	wacom_wac->input = NULL;
 	wacom_wac->pad_input = NULL;
-fail1:
+fail_allocate_input:
 	if (input_dev)
 		input_free_device(input_dev);
 	if (pad_input_dev)
@@ -1305,7 +1306,7 @@ static int wacom_probe(struct hid_device *hdev,
 	error = hid_parse(hdev);
 	if (error) {
 		hid_err(hdev, "parse failed\n");
-		goto fail1;
+		goto fail_parse;
 	}
 
 	wacom_wac = &wacom->wacom_wac;
@@ -1314,12 +1315,12 @@ static int wacom_probe(struct hid_device *hdev,
 	features->pktlen = wacom_compute_pktlen(hdev);
 	if (features->pktlen > WACOM_PKGLEN_MAX) {
 		error = -EINVAL;
-		goto fail1;
+		goto fail_pktlen;
 	}
 
 	if (features->check_for_hid_type && features->hid_type != hdev->type) {
 		error = -ENODEV;
-		goto fail1;
+		goto fail_type;
 	}
 
 	wacom->usbdev = dev;
@@ -1388,20 +1389,20 @@ static int wacom_probe(struct hid_device *hdev,
 
 		error = wacom_add_shared_data(hdev);
 		if (error)
-			goto fail1;
+			goto fail_shared_data;
 	}
 
 	if (!(features->quirks & WACOM_QUIRK_MONITOR) &&
 	     (features->quirks & WACOM_QUIRK_BATTERY)) {
 		error = wacom_initialize_battery(wacom);
 		if (error)
-			goto fail2;
+			goto fail_battery;
 	}
 
 	if (!(features->quirks & WACOM_QUIRK_NO_INPUT)) {
 		error = wacom_register_inputs(wacom);
 		if (error)
-			goto fail3;
+			goto fail_register_inputs;
 	}
 
 	if (hdev->bus == BUS_BLUETOOTH) {
@@ -1419,7 +1420,7 @@ static int wacom_probe(struct hid_device *hdev,
 	error = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
 	if (error) {
 		hid_err(hdev, "hw start failed\n");
-		goto fail4;
+		goto fail_hw_start;
 	}
 
 	if (features->quirks & WACOM_QUIRK_MONITOR)
@@ -1432,12 +1433,20 @@ static int wacom_probe(struct hid_device *hdev,
 
 	return 0;
 
- fail4:	if (hdev->bus == BUS_BLUETOOTH)
+fail_hw_start:
+	wacom_unregister_inputs(wacom);
+	if (hdev->bus == BUS_BLUETOOTH)
 		device_remove_file(&hdev->dev, &dev_attr_speed);
+fail_register_inputs:
 	wacom_unregister_inputs(wacom);
- fail3:	wacom_destroy_battery(wacom);
- fail2:	wacom_remove_shared_data(wacom_wac);
- fail1:	kfree(wacom);
+	wacom_destroy_battery(wacom);
+fail_battery:
+	wacom_remove_shared_data(wacom_wac);
+fail_shared_data:
+fail_type:
+fail_pktlen:
+fail_parse:
+	kfree(wacom);
 	hid_set_drvdata(hdev, NULL);
 	return error;
 }
-- 
2.1.0

