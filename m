Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaELBla (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:30 -0400
Received: from 1wt.eu ([62.212.114.60]:34304 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaELBlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:23 -0400
Message-Id: <20140512003201.632216643@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:24 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 024/143] HID: provide a helper for validating hid reports
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 331415ff16a12147d57d5c953f3a961b7ede348b upstream

Many drivers need to validate the characteristics of their HID report
during initialization to avoid misusing the reports. This adds a common
helper to perform validation of the report exisitng, the field existing,
and the expected number of values within the field.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

[jmm: backported to 2.6.32]
[wt: dev_err() in 2.6.32 instead of hid_err()]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/hid/hid-core.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hid.h    |  4 ++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a222cbb..e7e28b5 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -808,6 +808,64 @@ static __inline__ int search(__s32 *array, __s32 value, unsigned n)
 	return -1;
 }
 
+static const char * const hid_report_names[] = {
+	"HID_INPUT_REPORT",
+	"HID_OUTPUT_REPORT",
+	"HID_FEATURE_REPORT",
+};
+/**
+ * hid_validate_values - validate existing device report's value indexes
+ *
+ * @device: hid device
+ * @type: which report type to examine
+ * @id: which report ID to examine (0 for first)
+ * @field_index: which report field to examine
+ * @report_counts: expected number of values
+ *
+ * Validate the number of values in a given field of a given report, after
+ * parsing.
+ */
+struct hid_report *hid_validate_values(struct hid_device *hid,
+				       unsigned int type, unsigned int id,
+				       unsigned int field_index,
+				       unsigned int report_counts)
+{
+	struct hid_report *report;
+
+	if (type > HID_FEATURE_REPORT) {
+		dev_err(&hid->dev, "invalid HID report type %u\n", type);
+		return NULL;
+	}
+
+	if (id >= HID_MAX_IDS) {
+		dev_err(&hid->dev, "invalid HID report id %u\n", id);
+		return NULL;
+	}
+
+	/*
+	 * Explicitly not using hid_get_report() here since it depends on
+	 * ->numbered being checked, which may not always be the case when
+	 * drivers go to access report values.
+	 */
+	report = hid->report_enum[type].report_id_hash[id];
+	if (!report) {
+		dev_err(&hid->dev, "missing %s %u\n", hid_report_names[type], id);
+		return NULL;
+	}
+	if (report->maxfield <= field_index) {
+		dev_err(&hid->dev, "not enough fields in %s %u\n",
+			hid_report_names[type], id);
+		return NULL;
+	}
+	if (report->field[field_index]->report_count < report_counts) {
+		dev_err(&hid->dev, "not enough values in %s %u field %u\n",
+			hid_report_names[type], id, field_index);
+		return NULL;
+	}
+	return report;
+}
+EXPORT_SYMBOL_GPL(hid_validate_values);
+
 /**
  * hid_match_report - check if driver's raw_event should be called
  *
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 481080d..e5db8e5 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -693,6 +693,10 @@ int hidinput_find_field(struct hid_device *hid, unsigned int type, unsigned int
 void hid_output_report(struct hid_report *report, __u8 *data);
 struct hid_device *hid_allocate_device(void);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
+struct hid_report *hid_validate_values(struct hid_device *hid,
+				       unsigned int type, unsigned int id,
+				       unsigned int field_index,
+				       unsigned int report_counts);
 int hid_check_keys_pressed(struct hid_device *hid);
 int hid_connect(struct hid_device *hid, unsigned int connect_mask);
 void hid_disconnect(struct hid_device *hid);
-- 
1.7.12.2.21.g234cd45.dirty



