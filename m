Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936420Ab3DQRjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:39:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936327Ab3DQRjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:39:22 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4/4] HID: debug: allocate the output buffer with an estimate
Date: Wed, 17 Apr 2013 19:38:16 +0200
Message-Id: <1366220296-14346-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many multitouch device reports a lot of usage in their reports.
The size of the report can be quite big, and as we are dumping both
the report and the parsing in plain text format, the chosen size of
512 is much of the time not big enough.

For instance, one Elan 04f3:0732 gives a report of size 116 and an usage
count of 92. The result is that the ring buffer is not big enough to
contain the whole output, giving a partial debug information.

This estimate gives:
- 512 for a regular keyboard
- 524 for a regular mouse
- 2648 for Elan 04f3:0732

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Conflicts:
	drivers/hid/hid-debug.c
---
 drivers/hid/hid-core.c    | 30 ++++++++++++++++++++++++++++++
 drivers/hid/hid-debug.c   | 36 ++++++++++++++++++++++++++++++------
 include/linux/hid-debug.h |  1 +
 include/linux/hid.h       |  3 +++
 4 files changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 25d7903..3569ce8 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1174,6 +1174,36 @@ void hid_find_max_report(struct hid_device *hid, unsigned int type,
 EXPORT_SYMBOL_GPL(hid_find_max_report);
 
 /*
+ * Return the count of different usages in a report
+ */
+int hid_get_report_count(struct hid_report *report)
+{
+	int n = 0;
+	int i;
+	for (i = 0; i < report->maxfield; i++)
+		n += report->field[i]->report_count;
+	return n;
+}
+EXPORT_SYMBOL_GPL(hid_get_report_count);
+
+/*
+ * Traverse the supplied list of reports and find the longest usage count
+ */
+void hid_find_max_report_count(struct hid_device *hid, unsigned int type,
+		unsigned int *max)
+{
+	struct hid_report *report;
+	unsigned int size;
+
+	list_for_each_entry(report, &hid->report_enum[type].report_list, list) {
+		size = hid_get_report_count(report);
+		if (*max < size)
+			*max = size;
+	}
+}
+EXPORT_SYMBOL_GPL(hid_find_max_report_count);
+
+/*
  * Set a field value. The report this field belongs to has to be
  * created and transferred to the device, to set this value in the
  * device.
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 1dc8104..cc2e81e 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -582,9 +582,9 @@ void hid_debug_event(struct hid_device *hdev, char *buf)
 
 	list_for_each_entry(list, &hdev->debug_list, node) {
 		for (i = 0; i < strlen(buf); i++)
-			list->hid_debug_buf[(list->tail + i) % HID_DEBUG_BUFSIZE] =
+			list->hid_debug_buf[(list->tail + i) % list->size] =
 				buf[i];
-		list->tail = (list->tail + i) % HID_DEBUG_BUFSIZE;
+		list->tail = (list->tail + i) % list->size;
         }
 
 	wake_up_interruptible(&hdev->debug_wait);
@@ -971,6 +971,25 @@ static int hid_debug_rdesc_open(struct inode *inode, struct file *file)
 	return single_open(file, hid_debug_rdesc_show, inode->i_private);
 }
 
+static int hid_debug_estimate_buffer_size(struct hid_device *hdev)
+{
+	int max_report_size = 0;
+	int max_report_count = 0;
+	int estimate;
+
+	hid_find_max_report(hdev, HID_INPUT_REPORT, &max_report_size);
+	hid_find_max_report_count(hdev, HID_INPUT_REPORT, &max_report_count);
+
+	/*
+	 * We need enough space to:
+	 * - dump the report (max_report_size * 3)
+	 * - dump each usage in a human reading style. 25 columns seem enough.
+	 */
+	estimate = max_report_size * 3 + max_report_count * 25;
+
+	return max(estimate, HID_DEBUG_BUFSIZE);
+}
+
 static int hid_debug_events_open(struct inode *inode, struct file *file)
 {
 	int err = 0;
@@ -981,12 +1000,17 @@ static int hid_debug_events_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 
-	if (!(list->hid_debug_buf = kzalloc(sizeof(char) * HID_DEBUG_BUFSIZE, GFP_KERNEL))) {
+	list->hdev = (struct hid_device *) inode->i_private;
+	list->size = hid_debug_estimate_buffer_size(list->hdev);
+
+	list->hid_debug_buf = kzalloc(sizeof(char) * list->size, GFP_KERNEL);
+
+	if (!list->hid_debug_buf) {
 		err = -ENOMEM;
 		kfree(list);
 		goto out;
 	}
-	list->hdev = (struct hid_device *) inode->i_private;
+
 	file->private_data = list;
 	mutex_init(&list->read_mutex);
 
@@ -1046,7 +1070,7 @@ static ssize_t hid_debug_events_read(struct file *file, char __user *buffer,
 			if (list->tail > list->head)
 				len = list->tail - list->head;
 			else
-				len = HID_DEBUG_BUFSIZE - list->head;
+				len = list->size - list->head;
 
 			len = min(count - ret, len);
 
@@ -1055,7 +1079,7 @@ static ssize_t hid_debug_events_read(struct file *file, char __user *buffer,
 				goto out;
 			}
 			ret += len;
-			list->head = (list->head + len) % HID_DEBUG_BUFSIZE;
+			list->head = (list->head + len) % list->size;
 		}
 
 	}
diff --git a/include/linux/hid-debug.h b/include/linux/hid-debug.h
index 8663f21..404d5e1 100644
--- a/include/linux/hid-debug.h
+++ b/include/linux/hid-debug.h
@@ -42,6 +42,7 @@ struct hid_debug_list {
 	char *hid_debug_buf;
 	int head;
 	int tail;
+	int size;
 	struct fasync_struct *fasync;
 	struct hid_device *hdev;
 	struct list_head node;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 9b6c71c..cd75732 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -738,6 +738,9 @@ extern void hidinput_disconnect(struct hid_device *);
 
 int hid_get_report_length(struct hid_report *);
 void hid_find_max_report(struct hid_device *, unsigned int, unsigned int *);
+int hid_get_report_count(struct hid_report *);
+void hid_find_max_report_count(struct hid_device *, unsigned int,
+	unsigned int *);
 int hid_set_field(struct hid_field *, unsigned, __s32);
 int hid_input_report(struct hid_device *, int type, u8 *, int, int);
 int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int code, struct hid_field **field);
-- 
1.8.1.4

