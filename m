Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab3IKT5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 15:57:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755250Ab3IKT5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 15:57:12 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/10] HID: provide a helper for validating hid reports
Date: Wed, 11 Sep 2013 21:56:50 +0200
Message-Id: <1378929419-6269-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1378929419-6269-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

Many drivers need to validate the characteristics of their HID report
during initialization to avoid misusing the reports. This adds a common
helper to perform validation of the report exisitng, the field existing,
and the expected number of values within the field.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
v3:
 - no changes

v2:
 - suggestions from Benjamin Tissoires:
  - check id too, just to be double-safe.
  - updated to check a specific field, moving the for loop to callers.

 drivers/hid/hid-core.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hid.h    |  4 ++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2c77854..44b6c68 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -801,6 +801,64 @@ int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size)
 }
 EXPORT_SYMBOL_GPL(hid_parse_report);
 
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
+		hid_err(hid, "invalid HID report type %u\n", type);
+		return NULL;
+	}
+
+	if (id >= HID_MAX_IDS) {
+		hid_err(hid, "invalid HID report id %u\n", id);
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
+		hid_err(hid, "missing %s %u\n", hid_report_names[type], id);
+		return NULL;
+	}
+	if (report->maxfield <= field_index) {
+		hid_err(hid, "not enough fields in %s %u\n",
+			hid_report_names[type], id);
+		return NULL;
+	}
+	if (report->field[field_index]->report_count < report_counts) {
+		hid_err(hid, "not enough values in %s %u field %u\n",
+			hid_report_names[type], id, field_index);
+		return NULL;
+	}
+	return report;
+}
+EXPORT_SYMBOL_GPL(hid_validate_values);
+
 /**
  * hid_open_report - open a driver-specific device report
  *
diff --git a/include/linux/hid.h b/include/linux/hid.h
index ee1ffc5..31b9d29 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -756,6 +756,10 @@ u8 *hid_alloc_report_buf(struct hid_report *report, gfp_t flags);
 struct hid_device *hid_allocate_device(void);
 struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
+struct hid_report *hid_validate_values(struct hid_device *hid,
+				       unsigned int type, unsigned int id,
+				       unsigned int field_index,
+				       unsigned int report_counts);
 int hid_open_report(struct hid_device *device);
 int hid_check_keys_pressed(struct hid_device *hid);
 int hid_connect(struct hid_device *hid, unsigned int connect_mask);
-- 
1.8.3.1

