Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab3IKUMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757331Ab3IKUMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:12:33 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] HID: lenovo-tpkbd: devm conversion
Date: Wed, 11 Sep 2013 22:12:23 +0200
Message-Id: <1378930345-6670-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1378930345-6670-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1378930345-6670-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use the devres API in hid modules, so use it to avoid some kfree
and potential leaks.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-lenovo-tpkbd.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
index 31cf29a..0d9a276 100644
--- a/drivers/hid/hid-lenovo-tpkbd.c
+++ b/drivers/hid/hid-lenovo-tpkbd.c
@@ -339,7 +339,7 @@ static int tpkbd_probe_tp(struct hid_device *hdev)
 	struct tpkbd_data_pointer *data_pointer;
 	size_t name_sz = strlen(dev_name(dev)) + 16;
 	char *name_mute, *name_micmute;
-	int i, ret;
+	int i;
 
 	/* Validate required reports. */
 	for (i = 0; i < 4; i++) {
@@ -354,7 +354,9 @@ static int tpkbd_probe_tp(struct hid_device *hdev)
 		hid_warn(hdev, "Could not create sysfs group\n");
 	}
 
-	data_pointer = kzalloc(sizeof(struct tpkbd_data_pointer), GFP_KERNEL);
+	data_pointer = devm_kzalloc(&hdev->dev,
+				    sizeof(struct tpkbd_data_pointer),
+				    GFP_KERNEL);
 	if (data_pointer == NULL) {
 		hid_err(hdev, "Could not allocate memory for driver data\n");
 		return -ENOMEM;
@@ -364,20 +366,13 @@ static int tpkbd_probe_tp(struct hid_device *hdev)
 	data_pointer->sensitivity = 0xa0;
 	data_pointer->press_speed = 0x38;
 
-	name_mute = kzalloc(name_sz, GFP_KERNEL);
-	if (name_mute == NULL) {
+	name_mute = devm_kzalloc(&hdev->dev, name_sz, GFP_KERNEL);
+	name_micmute = devm_kzalloc(&hdev->dev, name_sz, GFP_KERNEL);
+	if (name_mute == NULL || name_micmute == NULL) {
 		hid_err(hdev, "Could not allocate memory for led data\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 	snprintf(name_mute, name_sz, "%s:amber:mute", dev_name(dev));
-
-	name_micmute = kzalloc(name_sz, GFP_KERNEL);
-	if (name_micmute == NULL) {
-		hid_err(hdev, "Could not allocate memory for led data\n");
-		ret = -ENOMEM;
-		goto err2;
-	}
 	snprintf(name_micmute, name_sz, "%s:amber:micmute", dev_name(dev));
 
 	hid_set_drvdata(hdev, data_pointer);
@@ -397,12 +392,6 @@ static int tpkbd_probe_tp(struct hid_device *hdev)
 	tpkbd_features_set(hdev);
 
 	return 0;
-
-err2:
-	kfree(name_mute);
-err:
-	kfree(data_pointer);
-	return ret;
 }
 
 static int tpkbd_probe(struct hid_device *hdev,
@@ -449,9 +438,6 @@ static void tpkbd_remove_tp(struct hid_device *hdev)
 	led_classdev_unregister(&data_pointer->led_mute);
 
 	hid_set_drvdata(hdev, NULL);
-	kfree(data_pointer->led_micmute.name);
-	kfree(data_pointer->led_mute.name);
-	kfree(data_pointer);
 }
 
 static void tpkbd_remove(struct hid_device *hdev)
-- 
1.8.3.1

