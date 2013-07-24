Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3GXRid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:38:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3GXRib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:38:31 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] HID: trivial devm conversion for special hid drivers
Date: Wed, 24 Jul 2013 19:38:04 +0200
Message-Id: <1374687485-31440-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1374687485-31440-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1374687485-31440-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is safe to use devres allocation within the hid subsystem:
- the devres release is called _after_ the call to .remove(), meaning
  that no freed pointers will exists while removing the device
- if a .probe() fails, devres releases all the allocated ressources
  before going to the next driver: there will not be ghost ressources
  attached to a hid device if several drivers are probed.

Given that, we can clean up a little some of the HID drivers. These ones
are trivial:
- there is only one kzalloc in the driver
- the .remove() callback contains only one kfree on top of hid_hw_stop()
- the error path in the probe is easy enough to be manually checked

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-a4tech.c     | 21 ++++-----------------
 drivers/hid/hid-apple.c      | 16 +++-------------
 drivers/hid/hid-magicmouse.c | 17 +++--------------
 drivers/hid/hid-sony.c       |  9 +++------
 drivers/hid/hid-zydacron.c   | 19 +++----------------
 5 files changed, 16 insertions(+), 66 deletions(-)

diff --git a/drivers/hid/hid-a4tech.c b/drivers/hid/hid-a4tech.c
index 7c5507e..9428ea7 100644
--- a/drivers/hid/hid-a4tech.c
+++ b/drivers/hid/hid-a4tech.c
@@ -90,11 +90,10 @@ static int a4_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct a4tech_sc *a4;
 	int ret;
 
-	a4 = kzalloc(sizeof(*a4), GFP_KERNEL);
+	a4 = devm_kzalloc(&hdev->dev, sizeof(*a4), GFP_KERNEL);
 	if (a4 == NULL) {
 		hid_err(hdev, "can't alloc device descriptor\n");
-		ret = -ENOMEM;
-		goto err_free;
+		return -ENOMEM;
 	}
 
 	a4->quirks = id->driver_data;
@@ -104,27 +103,16 @@ static int a4_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed\n");
-		goto err_free;
+		return ret;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
-		goto err_free;
+		return ret;
 	}
 
 	return 0;
-err_free:
-	kfree(a4);
-	return ret;
-}
-
-static void a4_remove(struct hid_device *hdev)
-{
-	struct a4tech_sc *a4 = hid_get_drvdata(hdev);
-
-	hid_hw_stop(hdev);
-	kfree(a4);
 }
 
 static const struct hid_device_id a4_devices[] = {
@@ -144,7 +132,6 @@ static struct hid_driver a4_driver = {
 	.input_mapped = a4_input_mapped,
 	.event = a4_event,
 	.probe = a4_probe,
-	.remove = a4_remove,
 };
 module_hid_driver(a4_driver);
 
diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index c7710b5..881cf7b 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -349,7 +349,7 @@ static int apple_probe(struct hid_device *hdev,
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 	int ret;
 
-	asc = kzalloc(sizeof(*asc), GFP_KERNEL);
+	asc = devm_kzalloc(&hdev->dev, sizeof(*asc), GFP_KERNEL);
 	if (asc == NULL) {
 		hid_err(hdev, "can't alloc apple descriptor\n");
 		return -ENOMEM;
@@ -362,7 +362,7 @@ static int apple_probe(struct hid_device *hdev,
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed\n");
-		goto err_free;
+		return ret;
 	}
 
 	if (quirks & APPLE_HIDDEV)
@@ -373,19 +373,10 @@ static int apple_probe(struct hid_device *hdev,
 	ret = hid_hw_start(hdev, connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
-		goto err_free;
+		return ret;
 	}
 
 	return 0;
-err_free:
-	kfree(asc);
-	return ret;
-}
-
-static void apple_remove(struct hid_device *hdev)
-{
-	hid_hw_stop(hdev);
-	kfree(hid_get_drvdata(hdev));
 }
 
 static const struct hid_device_id apple_devices[] = {
@@ -551,7 +542,6 @@ static struct hid_driver apple_driver = {
 	.id_table = apple_devices,
 	.report_fixup = apple_report_fixup,
 	.probe = apple_probe,
-	.remove = apple_remove,
 	.event = apple_event,
 	.input_mapping = apple_input_mapping,
 	.input_mapped = apple_input_mapped,
diff --git a/drivers/hid/hid-magicmouse.c b/drivers/hid/hid-magicmouse.c
index 5bc3734..d393eb7 100644
--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -484,7 +484,7 @@ static int magicmouse_probe(struct hid_device *hdev,
 	struct hid_report *report;
 	int ret;
 
-	msc = kzalloc(sizeof(*msc), GFP_KERNEL);
+	msc = devm_kzalloc(&hdev->dev, sizeof(*msc), GFP_KERNEL);
 	if (msc == NULL) {
 		hid_err(hdev, "can't alloc magicmouse descriptor\n");
 		return -ENOMEM;
@@ -498,13 +498,13 @@ static int magicmouse_probe(struct hid_device *hdev,
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "magicmouse hid parse failed\n");
-		goto err_free;
+		return ret;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
 		hid_err(hdev, "magicmouse hw start failed\n");
-		goto err_free;
+		return ret;
 	}
 
 	if (!msc->input) {
@@ -548,19 +548,9 @@ static int magicmouse_probe(struct hid_device *hdev,
 	return 0;
 err_stop_hw:
 	hid_hw_stop(hdev);
-err_free:
-	kfree(msc);
 	return ret;
 }
 
-static void magicmouse_remove(struct hid_device *hdev)
-{
-	struct magicmouse_sc *msc = hid_get_drvdata(hdev);
-
-	hid_hw_stop(hdev);
-	kfree(msc);
-}
-
 static const struct hid_device_id magic_mice[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE,
 		USB_DEVICE_ID_APPLE_MAGICMOUSE), .driver_data = 0 },
@@ -574,7 +564,6 @@ static struct hid_driver magicmouse_driver = {
 	.name = "magicmouse",
 	.id_table = magic_mice,
 	.probe = magicmouse_probe,
-	.remove = magicmouse_remove,
 	.raw_event = magicmouse_raw_event,
 	.input_mapping = magicmouse_input_mapping,
 	.input_configured = magicmouse_input_configured,
diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
index 87fbe29..30dbb6b 100644
--- a/drivers/hid/hid-sony.c
+++ b/drivers/hid/hid-sony.c
@@ -624,7 +624,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct sony_sc *sc;
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 
-	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
+	sc = devm_kzalloc(&hdev->dev, sizeof(*sc), GFP_KERNEL);
 	if (sc == NULL) {
 		hid_err(hdev, "can't alloc sony descriptor\n");
 		return -ENOMEM;
@@ -636,7 +636,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed\n");
-		goto err_free;
+		return ret;
 	}
 
 	if (sc->quirks & VAIO_RDESC_CONSTANT)
@@ -649,7 +649,7 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	ret = hid_hw_start(hdev, connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
-		goto err_free;
+		return ret;
 	}
 
 	if (sc->quirks & SIXAXIS_CONTROLLER_USB) {
@@ -669,8 +669,6 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	return 0;
 err_stop:
 	hid_hw_stop(hdev);
-err_free:
-	kfree(sc);
 	return ret;
 }
 
@@ -682,7 +680,6 @@ static void sony_remove(struct hid_device *hdev)
 		buzz_remove(hdev);
 
 	hid_hw_stop(hdev);
-	kfree(sc);
 }
 
 static const struct hid_device_id sony_devices[] = {
diff --git a/drivers/hid/hid-zydacron.c b/drivers/hid/hid-zydacron.c
index e4cddec..1a660bd 100644
--- a/drivers/hid/hid-zydacron.c
+++ b/drivers/hid/hid-zydacron.c
@@ -169,7 +169,7 @@ static int zc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	int ret;
 	struct zc_device *zc;
 
-	zc = kzalloc(sizeof(*zc), GFP_KERNEL);
+	zc = devm_kzalloc(&hdev->dev, sizeof(*zc), GFP_KERNEL);
 	if (zc == NULL) {
 		hid_err(hdev, "can't alloc descriptor\n");
 		return -ENOMEM;
@@ -180,28 +180,16 @@ static int zc_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	ret = hid_parse(hdev);
 	if (ret) {
 		hid_err(hdev, "parse failed\n");
-		goto err_free;
+		return ret;
 	}
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
-		goto err_free;
+		return ret;
 	}
 
 	return 0;
-err_free:
-	kfree(zc);
-
-	return ret;
-}
-
-static void zc_remove(struct hid_device *hdev)
-{
-	struct zc_device *zc = hid_get_drvdata(hdev);
-
-	hid_hw_stop(hdev);
-	kfree(zc);
 }
 
 static const struct hid_device_id zc_devices[] = {
@@ -217,7 +205,6 @@ static struct hid_driver zc_driver = {
 	.input_mapping = zc_input_mapping,
 	.raw_event = zc_raw_event,
 	.probe = zc_probe,
-	.remove = zc_remove,
 };
 module_hid_driver(zc_driver);
 
-- 
1.8.3.1

