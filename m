Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965052AbaDJDXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:23:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934661AbaDJDVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:21:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>, Jiri Kosina <jkosina@suse.cz>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 019/134] HID: hidraw: add proper error handling to raw event reporting
Date: Wed,  9 Apr 2014 20:22:15 -0700
Message-Id: <20140410032302.324568081@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit b6787242f32700377d3da3b8d788ab3928bab849 upstream.

If kmemdup() in hidraw_report_event() fails, we are not propagating
this fact properly.

Let hidraw_report_event() and hid_report_raw_event() return an error
value to the caller.

Reported-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |   16 +++++++++++-----
 drivers/hid/hidraw.c   |   19 +++++++++++++------
 include/linux/hid.h    |    2 +-
 include/linux/hidraw.h |    4 ++--
 4 files changed, 27 insertions(+), 14 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1100,7 +1100,7 @@ static struct hid_report *hid_get_report
 	return report;
 }
 
-void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
+int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		int interrupt)
 {
 	struct hid_report_enum *report_enum = hid->report_enum + type;
@@ -1108,10 +1108,11 @@ void hid_report_raw_event(struct hid_dev
 	unsigned int a;
 	int rsize, csize = size;
 	u8 *cdata = data;
+	int ret = 0;
 
 	report = hid_get_report(report_enum, data);
 	if (!report)
-		return;
+		goto out;
 
 	if (report_enum->numbered) {
 		cdata++;
@@ -1131,14 +1132,19 @@ void hid_report_raw_event(struct hid_dev
 
 	if ((hid->claimed & HID_CLAIMED_HIDDEV) && hid->hiddev_report_event)
 		hid->hiddev_report_event(hid, report);
-	if (hid->claimed & HID_CLAIMED_HIDRAW)
-		hidraw_report_event(hid, data, size);
+	if (hid->claimed & HID_CLAIMED_HIDRAW) {
+		ret = hidraw_report_event(hid, data, size);
+		if (ret)
+			goto out;
+	}
 
 	for (a = 0; a < report->maxfield; a++)
 		hid_input_field(hid, report->field[a], cdata, interrupt);
 
 	if (hid->claimed & HID_CLAIMED_INPUT)
 		hidinput_report_event(hid, report);
+out:
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hid_report_raw_event);
 
@@ -1215,7 +1221,7 @@ nomem:
 		}
 	}
 
-	hid_report_raw_event(hid, type, data, size, interrupt);
+	ret = hid_report_raw_event(hid, type, data, size, interrupt);
 
 unlock:
 	up(&hid->driver_lock);
--- a/drivers/hid/hidraw.c
+++ b/drivers/hid/hidraw.c
@@ -87,11 +87,13 @@ static ssize_t hidraw_read(struct file *
 		len = list->buffer[list->tail].len > count ?
 			count : list->buffer[list->tail].len;
 
-		if (copy_to_user(buffer, list->buffer[list->tail].value, len)) {
-			ret = -EFAULT;
-			goto out;
+		if (list->buffer[list->tail].value) {
+			if (copy_to_user(buffer, list->buffer[list->tail].value, len)) {
+				ret = -EFAULT;
+				goto out;
+			}
+			ret = len;
 		}
-		ret = len;
 
 		kfree(list->buffer[list->tail].value);
 		list->tail = (list->tail + 1) & (HIDRAW_BUFFER_SIZE - 1);
@@ -437,19 +439,24 @@ static const struct file_operations hidr
 	.llseek =	noop_llseek,
 };
 
-void hidraw_report_event(struct hid_device *hid, u8 *data, int len)
+int hidraw_report_event(struct hid_device *hid, u8 *data, int len)
 {
 	struct hidraw *dev = hid->hidraw;
 	struct hidraw_list *list;
+	int ret = 0;
 
 	list_for_each_entry(list, &dev->list, node) {
-		list->buffer[list->head].value = kmemdup(data, len, GFP_ATOMIC);
+		if (!(list->buffer[list->head].value = kmemdup(data, len, GFP_ATOMIC))) {
+			ret = -ENOMEM;
+			break;
+		}
 		list->buffer[list->head].len = len;
 		list->head = (list->head + 1) & (HIDRAW_BUFFER_SIZE - 1);
 		kill_fasync(&list->fasync, SIGIO, POLL_IN);
 	}
 
 	wake_up_interruptible(&dev->wait);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hidraw_report_event);
 
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -902,7 +902,7 @@ static inline int hid_hw_power(struct hi
 	return hdev->ll_driver->power ? hdev->ll_driver->power(hdev, level) : 0;
 }
 
-void hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
+int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		int interrupt);
 
 extern int hid_generic_init(void);
--- a/include/linux/hidraw.h
+++ b/include/linux/hidraw.h
@@ -76,13 +76,13 @@ struct hidraw_list {
 #ifdef CONFIG_HIDRAW
 int hidraw_init(void);
 void hidraw_exit(void);
-void hidraw_report_event(struct hid_device *, u8 *, int);
+int hidraw_report_event(struct hid_device *, u8 *, int);
 int hidraw_connect(struct hid_device *);
 void hidraw_disconnect(struct hid_device *);
 #else
 static inline int hidraw_init(void) { return 0; }
 static inline void hidraw_exit(void) { }
-static inline void hidraw_report_event(struct hid_device *hid, u8 *data, int len) { }
+static inline int hidraw_report_event(struct hid_device *hid, u8 *data, int len) { }
 static inline int hidraw_connect(struct hid_device *hid) { return -1; }
 static inline void hidraw_disconnect(struct hid_device *hid) { }
 #endif


