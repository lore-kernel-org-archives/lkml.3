Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab3JKLMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:12:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58351 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757262Ab3JKKmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:42:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 007/100] HID: add usage_index in struct hid_usage.
Date: Fri, 11 Oct 2013 11:40:37 +0100
Message-Id: <1381488130-30235-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@gmail.com>

commit f262d1fa2c651a5e2f92b6aee8779597631cd5d4 upstream.

Currently, there is no way to know the index of the current field
in the .input_mapping and .event callbacks  when this field is inside
an array of HID fields.
This patch adds this index to the struct hid_usage so that this
information is available to input_mapping and event callbacks.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[ luis: 3.5.y prereq for:
  cc6b54a HID: validate feature and input report details ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-core.c | 4 ++++
 include/linux/hid.h    | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index d4111de..4043d73 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -94,6 +94,7 @@ EXPORT_SYMBOL_GPL(hid_register_report);
 static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages, unsigned values)
 {
 	struct hid_field *field;
+	int i;
 
 	if (report->maxfield == HID_MAX_FIELDS) {
 		hid_err(report->device, "too many fields in report\n");
@@ -112,6 +113,9 @@ static struct hid_field *hid_register_field(struct hid_report *report, unsigned
 	field->value = (s32 *)(field->usage + usages);
 	field->report = report;
 
+	for (i = 0; i < usages; i++)
+		field->usage[i].usage_index = i;
+
 	return field;
 }
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index cdf6171..be1afbc 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -378,6 +378,7 @@ struct hid_collection {
 struct hid_usage {
 	unsigned  hid;			/* hid usage code */
 	unsigned  collection_index;	/* index into collection array */
+	unsigned  usage_index;		/* index into usage array */
 	/* hidinput data */
 	__u16     code;			/* input driver code */
 	__u8      type;			/* input driver type */
-- 
1.8.3.2

