Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422818Ab3CVRjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:39:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422740Ab3CVRjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:39:37 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/7] HID: multitouch: append " Pen" to the name of the stylus input
Date: Fri, 22 Mar 2013 18:38:33 +0100
Message-Id: <1363973914-5661-7-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1363973914-5661-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1363973914-5661-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not just cosmetics, it can help to write udev and X.org
rules.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 099a7ad..5555174 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -44,6 +44,7 @@
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/input/mt.h>
+#include <linux/string.h>
 
 
 MODULE_AUTHOR("Stephane Chatty <chatty@enac.fr>");
@@ -260,6 +261,14 @@ static struct mt_class mt_classes[] = {
 	{ }
 };
 
+static void mt_free_input_name(struct hid_input *hi)
+{
+	struct hid_device *hdev = hi->report->device;
+
+	if (hi->input->name != hdev->name)
+		kfree(hi->input->name);
+}
+
 static ssize_t mt_show_quirks(struct device *dev,
 			   struct device_attribute *attr,
 			   char *buf)
@@ -403,6 +412,12 @@ static void mt_pen_report(struct hid_device *hid, struct hid_report *report)
 static void mt_pen_input_configured(struct hid_device *hdev,
 					struct hid_input *hi)
 {
+	char *name = kzalloc(strlen(hi->input->name) + 5, GFP_KERNEL);
+	if (name) {
+		sprintf(name, "%s Pen", hi->input->name);
+		mt_free_input_name(hi);
+		hi->input->name = name;
+	}
 }
 
 static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
@@ -903,6 +918,10 @@ static void mt_post_parse(struct mt_device *td)
 static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
+	char *name = kstrdup(hdev->name, GFP_KERNEL);
+
+	if (name)
+		hi->input->name = name;
 
 	if (hi->report->id == td->mt_report_id)
 		mt_touch_input_configured(hdev, hi);
@@ -916,6 +935,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	int ret, i;
 	struct mt_device *td;
 	struct mt_class *mtclass = mt_classes; /* MT_CLS_DEFAULT */
+	struct hid_input *hi;
 
 	for (i = 0; mt_classes[i].name ; i++) {
 		if (id->driver_data == mt_classes[i].name) {
@@ -966,7 +986,7 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
 	if (ret)
-		goto fail;
+		goto hid_fail;
 
 	ret = sysfs_create_group(&hdev->dev.kobj, &mt_attribute_group);
 
@@ -978,6 +998,9 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	return 0;
 
+hid_fail:
+	list_for_each_entry(hi, &hdev->inputs, list)
+		mt_free_input_name(hi);
 fail:
 	kfree(td->fields);
 	kfree(td);
@@ -1007,8 +1030,14 @@ static int mt_resume(struct hid_device *hdev)
 static void mt_remove(struct hid_device *hdev)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
+	struct hid_input *hi;
+
 	sysfs_remove_group(&hdev->dev.kobj, &mt_attribute_group);
 	hid_hw_stop(hdev);
+
+	list_for_each_entry(hi, &hdev->inputs, list)
+		mt_free_input_name(hi);
+
 	kfree(td);
 	hid_set_drvdata(hdev, NULL);
 }
-- 
1.8.1.4

