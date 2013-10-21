Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab3JUJRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:17:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39549 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779Ab3JUIvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>,
        "Benjamin Tissoires" <benjamin.tissoires@redhat.com>,
        "Kees Cook" <keescook@chromium.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.749859191@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 068/149] HID: provide a helper for validating hid reports
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 331415ff16a12147d57d5c953f3a961b7ede348b upstream.

Many drivers need to validate the characteristics of their HID report
during initialization to avoid misusing the reports. This adds a common
helper to perform validation of the report exisitng, the field existing,
and the expected number of values within the field.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-core.c | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hid.h    |  4 ++++
 2 files changed, 62 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -714,6 +714,64 @@ err:
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
 /*
  * Convert a signed n-bit integer to signed 32-bit integer. Common
  * cases are done through the compiler, the screwed things has to be
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -718,6 +718,10 @@ void hid_output_report(struct hid_report
 struct hid_device *hid_allocate_device(void);
 struct hid_report *hid_register_report(struct hid_device *device, unsigned type, unsigned id);
 int hid_parse_report(struct hid_device *hid, __u8 *start, unsigned size);
+struct hid_report *hid_validate_values(struct hid_device *hid,
+				       unsigned int type, unsigned int id,
+				       unsigned int field_index,
+				       unsigned int report_counts);
 int hid_check_keys_pressed(struct hid_device *hid);
 int hid_connect(struct hid_device *hid, unsigned int connect_mask);
 void hid_disconnect(struct hid_device *hid);

