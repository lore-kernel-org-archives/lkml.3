Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3LSQXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:23:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206Ab3LSQXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:23:21 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Edel Maks <edelmaks@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] HID: multitouch: introduce mt_protocol_generic
Date: Thu, 19 Dec 2013 11:23:10 -0500
Message-Id: <1387470191-9725-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1387470191-9725-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1387470191-9725-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

most of the protocol callbacks used by the pen protocol are generic,
they just ask hid-input to treat the incoming data.
Introduce a generic protocol to avoid having to copy/paste the pens
callbacks for other kinds of input reports.

Tested-by: Edel Maks <edelmaks@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 42 ++++++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 1cdc21a..4dd6c6c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -156,26 +156,36 @@ static struct mt_protocol mt_protocol_touch = {
 	.input_configured = mt_touch_input_configured,
 };
 
-static int mt_pen_input_mapping(struct hid_device *hdev,
+static int mt_generic_input_mapping(struct hid_device *hdev,
 		struct hid_input *hi, struct hid_field *field,
 		struct hid_usage *usage, unsigned long **bit, int *max);
-static int mt_pen_input_mapped(struct hid_device *hdev,
+static int mt_generic_input_mapped(struct hid_device *hdev,
 		struct hid_input *hi, struct hid_field *field,
 		struct hid_usage *usage, unsigned long **bit, int *max);
-static int mt_pen_event(struct hid_device *hid,
+static int mt_generic_event(struct hid_device *hid,
 		struct hid_field *field, struct hid_usage *usage,
 		__s32 value);
-static void mt_pen_report(struct hid_device *hid,
+static void mt_generic_report(struct hid_device *hid,
 		struct hid_report *report);
+
+static struct mt_protocol mt_protocol_generic = {
+	.suffix = NULL,
+	.event = mt_generic_event,
+	.report = mt_generic_report,
+	.input_mapping = mt_generic_input_mapping,
+	.input_mapped = mt_generic_input_mapped,
+	.input_configured = NULL,
+};
+
 static void mt_pen_input_configured(struct hid_device *hdev,
 		struct hid_input *hi);
 
 static struct mt_protocol mt_protocol_pen = {
 	.suffix = "Pen",
-	.event = mt_pen_event,
-	.report = mt_pen_report,
-	.input_mapping = mt_pen_input_mapping,
-	.input_mapped = mt_pen_input_mapped,
+	.event = mt_generic_event,
+	.report = mt_generic_report,
+	.input_mapping = mt_generic_input_mapping,
+	.input_mapped = mt_generic_input_mapped,
 	.input_configured = mt_pen_input_configured,
 };
 
@@ -422,28 +432,28 @@ static void mt_store_field(struct hid_usage *usage, struct mt_device *td,
 	f->usages[f->length++] = usage->hid;
 }
 
-static int mt_pen_input_mapping(struct hid_device *hdev, struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+static int mt_generic_input_mapping(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max)
 {
 	return 0;
 }
 
-static int mt_pen_input_mapped(struct hid_device *hdev, struct hid_input *hi,
-		struct hid_field *field, struct hid_usage *usage,
-		unsigned long **bit, int *max)
+static int mt_generic_input_mapped(struct hid_device *hdev,
+		struct hid_input *hi, struct hid_field *field,
+		struct hid_usage *usage, unsigned long **bit, int *max)
 {
 	return 0;
 }
 
-static int mt_pen_event(struct hid_device *hid, struct hid_field *field,
+static int mt_generic_event(struct hid_device *hid, struct hid_field *field,
 				struct hid_usage *usage, __s32 value)
 {
 	/* let hid-input handle it */
 	return 0;
 }
 
-static void mt_pen_report(struct hid_device *hid, struct hid_report *report)
+static void mt_generic_report(struct hid_device *hid, struct hid_report *report)
 {
 	struct hid_field *field = report->field[0];
 
-- 
1.8.3.1

