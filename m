Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaGMHYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 03:24:40 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:48935 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaGMHYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 03:24:33 -0400
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>, Antonio Ospite <ao2@ao2.it>,
        Hans de Goede <hdegoede@redhat.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH v4 2/4] Make all base functions switch depending on product ID
Date: Sun, 13 Jul 2014 08:24:20 +0100
Message-Id: <1405236262-8070-3-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1405236262-8070-1-git-send-email-jm@lentin.co.uk>
References: <1405236262-8070-1-git-send-email-jm@lentin.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
---
 drivers/hid/hid-lenovo.c | 45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index 0320b96..d11e337 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -1,5 +1,6 @@
 /*
- *  HID driver for Lenovo ThinkPad USB Keyboard with TrackPoint
+ *  HID driver for Lenovo:
+ *  - ThinkPad USB Keyboard with TrackPoint (tpkbd)
  *
  *  Copyright (c) 2012 Bernhard Seibold
  */
@@ -47,6 +48,19 @@ static int lenovo_input_mapping_tpkbd(struct hid_device *hdev,
 	return 0;
 }
 
+static int lenovo_input_mapping(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max)
+{
+	switch (hdev->product) {
+	case USB_DEVICE_ID_LENOVO_TPKBD:
+		return lenovo_input_mapping_tpkbd(hdev, hi, field,
+							usage, bit, max);
+	}
+
+	return 0;
+}
+
 #undef map_key_clear
 
 static int lenovo_features_set_tpkbd(struct hid_device *hdev)
@@ -337,6 +351,16 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
 	char *name_mute, *name_micmute;
 	int i;
 
+	/*
+	 * If this is the pointer half of the keyboard, input_mapping should
+	 * have set drvdata to 1. Otherwise, it's the keyboard which needs
+	 * nothing special doing to it.
+	 */
+	if (!hid_get_drvdata(hdev))
+		return 0;
+
+	hid_set_drvdata(hdev, NULL);
+
 	/* Validate required reports. */
 	for (i = 0; i < 4; i++) {
 		if (!hid_validate_values(hdev, HID_FEATURE_REPORT, 4, i, 1))
@@ -409,12 +433,13 @@ static int lenovo_probe(struct hid_device *hdev,
 		goto err;
 	}
 
-	if (hid_get_drvdata(hdev)) {
-		hid_set_drvdata(hdev, NULL);
+	switch (hdev->product) {
+	case USB_DEVICE_ID_LENOVO_TPKBD:
 		ret = lenovo_probe_tpkbd(hdev);
-		if (ret)
-			goto err_hid;
+		break;
 	}
+	if (ret)
+		goto err_hid;
 
 	return 0;
 err_hid:
@@ -430,6 +455,9 @@ static void lenovo_remove_tpkbd(struct hid_device *hdev)
 	sysfs_remove_group(&hdev->dev.kobj,
 			&lenovo_attr_group_tpkbd);
 
+	if (data_pointer == NULL)
+		return;
+
 	led_classdev_unregister(&data_pointer->led_micmute);
 	led_classdev_unregister(&data_pointer->led_mute);
 
@@ -438,8 +466,11 @@ static void lenovo_remove_tpkbd(struct hid_device *hdev)
 
 static void lenovo_remove(struct hid_device *hdev)
 {
-	if (hid_get_drvdata(hdev))
+	switch (hdev->product) {
+	case USB_DEVICE_ID_LENOVO_TPKBD:
 		lenovo_remove_tpkbd(hdev);
+		break;
+	}
 
 	hid_hw_stop(hdev);
 }
@@ -454,7 +485,7 @@ MODULE_DEVICE_TABLE(hid, lenovo_devices);
 static struct hid_driver lenovo_driver = {
 	.name = "lenovo",
 	.id_table = lenovo_devices,
-	.input_mapping = lenovo_input_mapping_tpkbd,
+	.input_mapping = lenovo_input_mapping,
 	.probe = lenovo_probe,
 	.remove = lenovo_remove,
 };
-- 
2.0.0

