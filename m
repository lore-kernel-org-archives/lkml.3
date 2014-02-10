Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaBJSC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:02:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180AbaBJR7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:59:07 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 03/14] HID: core: implement generic .request()
Date: Mon, 10 Feb 2014 12:58:48 -0500
Message-Id: <1392055139-19631-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.request() can be emulated through .raw_request()
we can implement this emulation in hid-core, and make .request
not mandatory for transport layer drivers.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/hid.h    |  5 ++++-
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 18fe49b..f36778a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1248,6 +1248,11 @@ void hid_output_report(struct hid_report *report, __u8 *data)
 }
 EXPORT_SYMBOL_GPL(hid_output_report);
 
+static int hid_report_len(struct hid_report *report)
+{
+	return ((report->size - 1) >> 3) + 1 + (report->id > 0) + 7;
+}
+
 /*
  * Allocator for buffer that is going to be passed to hid_output_report()
  */
@@ -1258,7 +1263,7 @@ u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags)
 	 * of implement() working on 8 byte chunks
 	 */
 
-	int len = ((report->size - 1) >> 3) + 1 + (report->id > 0) + 7;
+	int len = hid_report_len(report);
 
 	return kmalloc(len, flags);
 }
@@ -1314,6 +1319,44 @@ static struct hid_report *hid_get_report(struct hid_report_enum *report_enum,
 	return report;
 }
 
+/*
+ * Implement a generic .request() callback, using .raw_request()
+ * DO NOT USE in hid drivers directly, but through hid_hw_request instead.
+ */
+void __hid_request(struct hid_device *hid, struct hid_report *report,
+		int reqtype)
+{
+	char *buf;
+	int ret;
+	int len;
+
+	if (!hid->ll_driver->raw_request)
+		return;
+
+	buf = hid_alloc_report_buf(report, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	len = hid_report_len(report);
+
+	if (reqtype == HID_REQ_SET_REPORT)
+		hid_output_report(report, buf);
+
+	ret = hid->ll_driver->raw_request(hid, report->id, buf, len,
+					  report->type, reqtype);
+	if (ret < 0) {
+		dbg_hid("unable to complete request: %d\n", ret);
+		goto out;
+	}
+
+	if (reqtype == HID_REQ_GET_REPORT)
+		hid_input_report(hid, report->type, buf, ret, 0);
+
+out:
+	kfree(buf);
+}
+EXPORT_SYMBOL_GPL(__hid_request);
+
 int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
 		int interrupt)
 {
diff --git a/include/linux/hid.h b/include/linux/hid.h
index a837ede..09fbbd7 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -753,6 +753,7 @@ struct hid_field *hidinput_get_led_field(struct hid_device *hid);
 unsigned int hidinput_count_leds(struct hid_device *hid);
 __s32 hidinput_calc_abs_res(const struct hid_field *field, __u16 code);
 void hid_output_report(struct hid_report *report, __u8 *data);
+void __hid_request(struct hid_device *hid, struct hid_report *rep, int reqtype);
 u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags);
 struct hid_device *hid_allocate_device(void);
 struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id);
@@ -965,7 +966,9 @@ static inline void hid_hw_request(struct hid_device *hdev,
 				  struct hid_report *report, int reqtype)
 {
 	if (hdev->ll_driver->request)
-		hdev->ll_driver->request(hdev, report, reqtype);
+		return hdev->ll_driver->request(hdev, report, reqtype);
+
+	__hid_request(hdev, report, reqtype);
 }
 
 /**
-- 
1.8.3.1

