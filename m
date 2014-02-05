Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaBEUDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:03:48 -0500
Received: from mail.windriver.com ([147.11.1.11]:54203 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaBEUDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 017/213] HID: validate HID report id size
Date: Wed, 5 Feb 2014 14:59:32 -0500
Message-ID: <1391630568-49251-18-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
[PG: hid_err() --> dbg_hid() in 2.6.34 baseline]

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hid/hid-core.c | 10 +++++++---
 include/linux/hid.h    |  4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 07ddda553a95..195e366ea18d 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -56,6 +56,8 @@ struct hid_report *hid_register_report(struct hid_device *device, unsigned type,
 	struct hid_report_enum *report_enum = device->report_enum + type;
 	struct hid_report *report;
 
+	if (id >= HID_MAX_IDS)
+		return NULL;
 	if (report_enum->report_id_hash[id])
 		return report_enum->report_id_hash[id];
 
@@ -367,8 +369,10 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
 
 	case HID_GLOBAL_ITEM_TAG_REPORT_ID:
 		parser->global.report_id = item_udata(item);
-		if (parser->global.report_id == 0) {
-			dbg_hid("report_id 0 is invalid\n");
+		if (parser->global.report_id == 0 ||
+		    parser->global.report_id >= HID_MAX_IDS) {
+			dbg_hid("report_id %u is invalid\n",
+				parser->global.report_id);
 			return -1;
 		}
 		return 0;
@@ -545,7 +549,7 @@ static void hid_device_release(struct device *dev)
 	for (i = 0; i < HID_REPORT_TYPES; i++) {
 		struct hid_report_enum *report_enum = device->report_enum + i;
 
-		for (j = 0; j < 256; j++) {
+		for (j = 0; j < HID_MAX_IDS; j++) {
 			struct hid_report *report = report_enum->report_id_hash[j];
 			if (report)
 				hid_free_report(report);
diff --git a/include/linux/hid.h b/include/linux/hid.h
index b1344ec4b7fc..85e0942cfd76 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -410,10 +410,12 @@ struct hid_report {
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
1.8.5.2

