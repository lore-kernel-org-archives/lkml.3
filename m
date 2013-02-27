Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541Ab3B0Q4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:56:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760490Ab3B0Q4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:56:32 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] HID: multitouch: append " Pen" to the name of the stylus input
Date: Wed, 27 Feb 2013 17:55:26 +0100
Message-Id: <1361984127-912-7-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not just cosmetics, it can help to write udev and X.org
rules.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index d89f0eb..faeec95 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -44,6 +44,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/input/mt.h>
+#include <linux/string.h>
 
 
 MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
@@ -371,6 +372,15 @@ static int mt_pen_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		unsigned long **bit, int *max)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
+	char *name;
+
+	if (hi->input->name == hdev->name) {
+		name = kzalloc(sizeof(hdev->name) + 5, GFP_KERNEL);
+		if (name) {
+			sprintf(name, "%s Pen", hdev->name);
+			hi->input->name = name;
+		}
+	}
 
 	td->pen_report_id = field->report->id;
 
@@ -914,6 +924,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	int ret, i;
 	struct mt_device *td;
 	struct mt_class *mtclass = mt_classes; /* MT_CLS_DEFAULT */
+	struct hid_input *hi;
 
 	for (i = 0; mt_classes[i].name ; i++) {
 		if (id->driver_data == mt_classes[i].name) {
@@ -964,7 +975,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret)
-		goto fail;
+		goto hid_fail;
 
 	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
 
@@ -976,6 +987,10 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	return 0;
 
+hid_fail:
+	list_for_each_entry(hi, &hdev->inputs, list)
+		if (hi->input->name != hdev->name)
+			kfree(hi->input->name);
 fail:
 	kfree(td->fields);
 	kfree(td);
@@ -1020,8 +1035,15 @@ static int mt_resume(struct hid_device *hdev)
 static void mt_remove(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
+	struct hid_input *hi;
+
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);
+
+	list_for_each_entry(hi, &hdev->inputs, list)
+		if (hi->input->name != hdev->name)
+			kfree(hi->input->name);
+
 	kfree(td);
 	hid_set_drvdata(hdev, NULL);
 }
-- 
1.8.1.2

