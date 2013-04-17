Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936388Ab3DQRjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 13:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36900 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936238Ab3DQRjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 13:39:16 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 1/4] HID: debug: break out hid_dump_report() into hid-debug
Date: Wed, 17 Apr 2013 19:38:13 +0200
Message-Id: <1366220296-14346-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1366220296-14346-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No semantic changes, but hid_dump_report should be in hid-debug.c, not
in hid-core.c

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c    | 25 ++-----------------------
 drivers/hid/hid-debug.c   | 30 ++++++++++++++++++++++++++++++
 include/linux/hid-debug.h |  6 ++++--
 3 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 1129f49..34c53fc 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1259,8 +1259,6 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 	struct hid_report_enum *report_enum;
 	struct hid_driver *hdrv;
 	struct hid_report *report;
-	char *buf;
-	unsigned int i;
 	int ret = 0;
 
 	if (!hid)
@@ -1283,28 +1281,9 @@ int hid_input_report(struct hid_device *hid, int type, u8 *data, int size, int i
 	}
 
 	/* Avoid unnecessary overhead if debugfs is disabled */
-	if (list_empty(&hid->debug_list))
-		goto nomem;
-
-	buf = kmalloc(sizeof(char) * HID_DEBUG_BUFSIZE, GFP_ATOMIC);
-
-	if (!buf)
-		goto nomem;
-
-	/* dump the report */
-	snprintf(buf, HID_DEBUG_BUFSIZE - 1,
-			"\nreport (size %u) (%snumbered) = ", size, report_enum->numbered ? "" : "un");
-	hid_debug_event(hid, buf);
-
-	for (i = 0; i < size; i++) {
-		snprintf(buf, HID_DEBUG_BUFSIZE - 1,
-				" %02x", data[i]);
-		hid_debug_event(hid, buf);
-	}
-	hid_debug_event(hid, "\n");
-	kfree(buf);
+	if (!list_empty(&hid->debug_list))
+		hid_dump_report(hid, type, data, size);
 
-nomem:
 	report = hid_get_report(report_enum, data);
 
 	if (!report) {
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 933fff0..094cbcf 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -591,6 +591,36 @@ void hid_debug_event(struct hid_device *hdev, char *buf)
 }
 EXPORT_SYMBOL_GPL(hid_debug_event);
 
+void hid_dump_report(struct hid_device *hid, int type, u8 *data,
+		int size)
+{
+	struct hid_report_enum *report_enum;
+	char *buf;
+	unsigned int i;
+
+	buf = kmalloc(sizeof(char) * HID_DEBUG_BUFSIZE, GFP_ATOMIC);
+
+	if (!buf)
+		return;
+
+	report_enum = hid->report_enum + type;
+
+	/* dump the report */
+	snprintf(buf, HID_DEBUG_BUFSIZE - 1,
+			"\nreport (size %u) (%snumbered) = ", size,
+			report_enum->numbered ? "" : "un");
+	hid_debug_event(hid, buf);
+
+	for (i = 0; i < size; i++) {
+		snprintf(buf, HID_DEBUG_BUFSIZE - 1,
+				" %02x", data[i]);
+		hid_debug_event(hid, buf);
+	}
+	hid_debug_event(hid, "\n");
+	kfree(buf);
+}
+EXPORT_SYMBOL_GPL(hid_dump_report);
+
 void hid_dump_input(struct hid_device *hdev, struct hid_usage *usage, __s32 value)
 {
 	char *buf;
diff --git a/include/linux/hid-debug.h b/include/linux/hid-debug.h
index 53744fa..8663f21 100644
--- a/include/linux/hid-debug.h
+++ b/include/linux/hid-debug.h
@@ -22,11 +22,12 @@
  *
  */
 
-#define HID_DEBUG_BUFSIZE 512
-
 #ifdef CONFIG_DEBUG_FS
 
+#define HID_DEBUG_BUFSIZE 512
+
 void hid_dump_input(struct hid_device *, struct hid_usage *, __s32);
+void hid_dump_report(struct hid_device *, int , u8 *, int);
 void hid_dump_device(struct hid_device *, struct seq_file *);
 void hid_dump_field(struct hid_field *, int, struct seq_file *);
 char *hid_resolv_usage(unsigned, struct seq_file *);
@@ -50,6 +51,7 @@ struct hid_debug_list {
 #else
 
 #define hid_dump_input(a,b,c)		do { } while (0)
+#define hid_dump_report(a,b,c,d)	do { } while (0)
 #define hid_dump_device(a,b)		do { } while (0)
 #define hid_dump_field(a,b,c)		do { } while (0)
 #define hid_resolv_usage(a,b)		do { } while (0)
-- 
1.8.1.4

