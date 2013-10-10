Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab3JJPu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:50:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53041 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab3JJPuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 043/104] HID: multitouch: validate indexes details
Date: Thu, 10 Oct 2013 08:41:31 -0700
Message-Id: <1381419752-29733-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 8821f5dc187bdf16cfb32ef5aa8c3035273fa79a upstream.

When working on report indexes, always validate that they are in bounds.
Without this, a HID device could report a malicious feature report that
could trick the driver into a heap overflow:

[  634.885003] usb 1-1: New USB device found, idVendor=0596, idProduct=0500
...
[  676.469629] BUG kmalloc-192 (Tainted: G        W   ): Redzone overwritten

Note that we need to change the indexes from s8 to s16 as they can
be between -1 and 255.

CVE-2013-2897

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hid/hid-multitouch.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 61543c0..071c288 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -85,9 +85,9 @@ struct mt_device {
 					   multitouch fields */
 	unsigned last_field_index;	/* last field index of the report */
 	unsigned last_slot_field;	/* the last field of a slot */
-	__s8 inputmode;		/* InputMode HID feature, -1 if non-existent */
-	__s8 inputmode_index;	/* InputMode HID feature index in the report */
-	__s8 maxcontact_report_id;	/* Maximum Contact Number HID feature,
+	__s16 inputmode;	/* InputMode HID feature, -1 if non-existent */
+	__s16 inputmode_index;	/* InputMode HID feature index in the report */
+	__s16 maxcontact_report_id;	/* Maximum Contact Number HID feature,
 				   -1 if non-existent */
 	__u8 num_received;	/* how many contacts we received */
 	__u8 num_expected;	/* expected last contact index */
@@ -268,20 +268,18 @@ static void mt_feature_mapping(struct hid_device *hdev,
 		struct hid_field *field, struct hid_usage *usage)
 {
 	struct mt_device *td = hid_get_drvdata(hdev);
-	int i;
 
 	switch (usage->hid) {
 	case HID_DG_INPUTMODE:
-		td->inputmode = field->report->id;
-		td->inputmode_index = 0; /* has to be updated below */
-
-		for (i=0; i < field->maxusage; i++) {
-			if (field->usage[i].hid == usage->hid) {
-				td->inputmode_index = i;
-				break;
-			}
+		/* Ignore if value index is out of bounds. */
+		if (usage->usage_index >= field->report_count) {
+			dev_err(&hdev->dev, "HID_DG_INPUTMODE out of range\n");
+			break;
 		}
 
+		td->inputmode = field->report->id;
+		td->inputmode_index = usage->usage_index;
+
 		break;
 	case HID_DG_CONTACTMAX:
 		td->maxcontact_report_id = field->report->id;
@@ -459,6 +457,10 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTCOUNT:
+			/* Ignore if indexes are out of bounds. */
+			if (field->index >= field->report->maxfield ||
+			    usage->usage_index >= field->report_count)
+				return 1;
 			td->last_field_index = field->index;
 			return 1;
 		case HID_DG_CONTACTMAX:
-- 
1.8.1.2

