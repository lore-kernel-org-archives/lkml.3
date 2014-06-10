Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaFJWqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 18:46:03 -0400
Received: from marmot.wormnet.eu ([188.246.204.87]:43352 "EHLO
	marmot.wormnet.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaFJWqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 18:46:01 -0400
X-Greylist: delayed 1250 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2014 18:46:01 EDT
From: Jamie Lentin <jm@lentin.co.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Lentin <jm@lentin.co.uk>
Subject: [PATCH v2 1/2] Loosen seams to allow support of other keyboards
Date: Tue, 10 Jun 2014 23:24:53 +0100
Message-Id: <1402439094-25464-2-git-send-email-jm@lentin.co.uk>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1402439094-25464-1-git-send-email-jm@lentin.co.uk>
References: <1402439094-25464-1-git-send-email-jm@lentin.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
---
 drivers/hid/hid-lenovo-tpkbd.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index 2d25b6c..3bec9f5 100644
--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -1,5 +1,6 @@
 /*
- *  HID driver for Lenovo ThinkPad USB Keyboard with TrackPoint
+ *  HID driver for Lenovo:-
+ *  * ThinkPad USB Keyboard with TrackPoint
  *
  *  Copyright (c) 2012 Bernhard Seibold
  */
@@ -35,7 +36,7 @@ struct tpkbd_data_pointer {
 
 #define map_key_clear(c) hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
 
-static int tpkbd_input_mapping(struct hid_device *hdev,
+static int tpkbd_input_mapping_tp(struct hid_device *hdev,
 		struct hid_input *hi, struct hid_field *field,
 		struct hid_usage *usage, unsigned long **bit, int *max)
 {
@@ -48,6 +49,15 @@ static int tpkbd_input_mapping(struct hid_device *hdev,
 	return 0;
 }
 
+static int tpkbd_input_mapping(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max)
+{
+	if (hdev->product == USB_DEVICE_ID_LENOVO_TPKBD)
+		return tpkbd_input_mapping_tp(hdev, hi, field, usage, bit, max);
+	return 0;
+}
+
 #undef map_key_clear
 
 static int tpkbd_features_set(struct hid_device *hdev)
@@ -338,6 +348,11 @@ static int tpkbd_probe_tp(struct hid_device *hdev)
 	char *name_mute, *name_micmute;
 	int i;
 
+	/* Ignore unless tpkbd_input_mapping_tp marked it as a pointer */
+	if (!hid_get_drvdata(hdev))
+		return 0;
+	hid_set_drvdata(hdev, NULL);
+
 	/* Validate required reports. */
 	for (i = 0; i < 4; i++) {
 		if (!hid_validate_values(hdev, HID_FEATURE_REPORT, 4, i, 1))
@@ -408,12 +423,9 @@ static int tpkbd_probe(struct hid_device *hdev,
 		goto err;
 	}
 
-	if (hid_get_drvdata(hdev)) {
-		hid_set_drvdata(hdev, NULL);
-		ret = tpkbd_probe_tp(hdev);
-		if (ret)
-			goto err_hid;
-	}
+	if (hdev->product == USB_DEVICE_ID_LENOVO_TPKBD
+			&& tpkbd_probe_tp(hdev))
+		goto err_hid;
 
 	return 0;
 err_hid:
@@ -437,7 +449,10 @@ static void tpkbd_remove_tp(struct hid_device *hdev)
 
 static void tpkbd_remove(struct hid_device *hdev)
 {
-	if (hid_get_drvdata(hdev))
+	if (!hid_get_drvdata(hdev))
+		return;
+
+	if (hdev->product == USB_DEVICE_ID_LENOVO_TPKBD)
 		tpkbd_remove_tp(hdev);
 
 	hid_hw_stop(hdev);
-- 
2.0.0.rc2

