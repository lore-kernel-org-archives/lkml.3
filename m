Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936430Ab3DQRjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:39:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936385Ab3DQRjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:39:18 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 2/4] HID: core: break out hid_find_max_report() in hid-core
Date: Wed, 17 Apr 2013 19:38:14 +0200
Message-Id: <1366220296-14346-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hid_find_max_report() was used both in usbhid and i2c-hid.
Put it in core to avoid code duplication.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c        | 29 +++++++++++++++++++++++++++++
 drivers/hid/i2c-hid/i2c-hid.c | 15 +++------------
 drivers/hid/usbhid/hid-core.c | 16 ----------------
 include/linux/hid.h           |  2 ++
 4 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 34c53fc..25d7903 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1145,6 +1145,35 @@ void hid_output_report(struct hid_report *report, __u8 *data)
 EXPORT_SYMBOL_GPL(hid_output_report);
 
 /*
+ * Return the length (in bytes) of a report
+ */
+int hid_get_report_length(struct hid_report *report)
+{
+	return report->size ? ((report->size - 1) >> 3) + 1 +
+		report->device->report_enum[report->type].numbered : 0;
+}
+EXPORT_SYMBOL_GPL(hid_get_report_length);
+
+/*
+ * Traverse the supplied list of reports and find the longest
+ */
+void hid_find_max_report(struct hid_device *hid, unsigned int type,
+		unsigned int *max)
+{
+	struct hid_report *report;
+	unsigned int size;
+
+	/* We should not rely on wMaxInputLength, as some devices may set it to
+	 * a wrong length. */
+	list_for_each_entry(report, &hid->report_enum[type].report_list, list) {
+		size = hid_get_report_length(report);
+		if (*max < size)
+			*max = size;
+	}
+}
+EXPORT_SYMBOL_GPL(hid_find_max_report);
+
+/*
  * Set a field value. The report this field belongs to has to be
  * created and transferred to the device, to set this value in the
  * device.
diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index 2b1799a..5aa1dc0 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -390,8 +390,7 @@ static irqreturn_t i2c_hid_irq(int irq, void *dev_id)
 
 static int i2c_hid_get_report_length(struct hid_report *report)
 {
-	return ((report->size - 1) >> 3) + 1 +
-		report->device->report_enum[report->type].numbered + 2;
+	return hid_get_report_length(report) + 2;
 }
 
 static void i2c_hid_init_report(struct hid_report *report, u8 *buffer,
@@ -456,16 +455,8 @@ static void i2c_hid_init_reports(struct hid_device *hid)
 static void i2c_hid_find_max_report(struct hid_device *hid, unsigned int type,
 		unsigned int *max)
 {
-	struct hid_report *report;
-	unsigned int size;
-
-	/* We should not rely on wMaxInputLength, as some devices may set it to
-	 * a wrong length. */
-	list_for_each_entry(report, &hid->report_enum[type].report_list, list) {
-		size = i2c_hid_get_report_length(report);
-		if (*max < size)
-			*max = size;
-	}
+	hid_find_max_report(hid, type, max);
+	*max += 2;
 }
 
 static void i2c_hid_free_buffers(struct i2c_hid *ihid)
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index effcd3d..5cf7ddb 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -869,22 +869,6 @@ void usbhid_set_leds(struct hid_device *hid)
 }
 EXPORT_SYMBOL_GPL(usbhid_set_leds);
 
-/*
- * Traverse the supplied list of reports and find the longest
- */
-static void hid_find_max_report(struct hid_device *hid, unsigned int type,
-		unsigned int *max)
-{
-	struct hid_report *report;
-	unsigned int size;
-
-	list_for_each_entry(report, &hid->report_enum[type].report_list, list) {
-		size = ((report->size - 1) >> 3) + 1 + hid->report_enum[type].numbered;
-		if (*max < size)
-			*max = size;
-	}
-}
-
 static int hid_alloc_buffers(struct usb_device *dev, struct hid_device *hid)
 {
 	struct usbhid_device *usbhid = hid->driver_data;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index b7b5ff2..9b6c71c 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -736,6 +736,8 @@ extern void hidinput_report_event(struct hid_device *hid, struct hid_report *rep
 extern int hidinput_connect(struct hid_device *hid, unsigned int force);
 extern void hidinput_disconnect(struct hid_device *);
 
+int hid_get_report_length(struct hid_report *);
+void hid_find_max_report(struct hid_device *, unsigned int, unsigned int *);
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *, int type, u8 *, int, int);
 int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int code, struct hid_field **field);
-- 
1.8.1.4

