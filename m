Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3I3KZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:25:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43655 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3I3KMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:12:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 062/104] HID: validate HID report id size
Date: Mon, 30 Sep 2013 11:10:39 +0100
Message-Id: <1380535881-9239-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 43622021d2e2b82ea03d883926605bdd0525e1d1 upstream.

The "Report ID" field of a HID report is used to build indexes of
reports. The kernel's index of these is limited to 256 entries, so any
malicious device that sets a Report ID greater than 255 will trigger
memory corruption on the host:

[ 1347.156239] BUG: unable to handle kernel paging request at ffff88094958a878
[ 1347.156261] IP: [<ffffffff813e4da0>] hid_register_report+0x2a/0x8b

CVE-2013-2888

Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-core.c | 10 +++++++---
 include/linux/hid.h    |  4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2f85e59..104792d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -63,6 +63,8 @@ struct hid_report *hid_register_report(struct hid_device *device, unsigned type,
 	struct hid_report_enum *report_enum = device->report_enum + type;
 	struct hid_report *report;
 
+	if (id >= HID_MAX_IDS)
+		return NULL;
 	if (report_enum->report_id_hash[id])
 		return report_enum->report_id_hash[id];
 
@@ -392,8 +394,10 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
 
 	case HID_GLOBAL_ITEM_TAG_REPORT_ID:
 		parser->global.report_id = item_udata(item);
-		if (parser->global.report_id == 0) {
-			hid_err(parser->device, "report_id 0 is invalid\n");
+		if (parser->global.report_id == 0 ||
+		    parser->global.report_id >= HID_MAX_IDS) {
+			hid_err(parser->device, "report_id %u is invalid\n",
+				parser->global.report_id);
 			return -1;
 		}
 		return 0;
@@ -563,7 +567,7 @@ static void hid_close_report(struct hid_device *device)
 	for (i = 0; i < HID_REPORT_TYPES; i++) {
 		struct hid_report_enum *report_enum = device->report_enum + i;
 
-		for (j = 0; j < 256; j++) {
+		for (j = 0; j < HID_MAX_IDS; j++) {
 			struct hid_report *report = report_enum->report_id_hash[j];
 			if (report)
 				hid_free_report(report);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 449fa38..69b6e30 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -425,10 +425,12 @@ struct hid_report {
 	struct hid_device *device;			/* associated device */
 };
 
+#define HID_MAX_IDS 256
+
 struct hid_report_enum {
 	unsigned numbered;
 	struct list_head report_list;
-	struct hid_report *report_id_hash[256];
+	struct hid_report *report_id_hash[HID_MAX_IDS];
 };
 
 #define HID_REPORT_TYPES 3
-- 
1.8.3.2

