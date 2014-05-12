Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbaELCQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 22:16:41 -0400
Received: from 1wt.eu ([62.212.114.60]:34427 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbaELBlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:55 -0400
Message-Id: <20140512003201.426762644@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:19 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, stable@kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Willy Tarreau <w@1wt.eu>
Subject: [ 019/143] HID: validate HID report id size
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 43622021d2e2b82ea03d883926605bdd0525e1d1 upstream

The "Report ID" field of a HID report is used to build indexes of
reports. The kernel's index of these is limited to 256 entries, so any
malicious device that sets a Report ID greater than 255 will trigger
memory corruption on the host:

[ 1347.156239] BUG: unable to handle kernel paging request at ffff88094958a878
[ 1347.156261] IP: [<ffffffff813e4da0>] hid_register_report+0x2a/0x8b

CVE-2013-2888

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[jmm: backport to 2.6.32]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/hid/hid-core.c | 10 +++++++---
 include/linux/hid.h    |  4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 11f8069..e40e3c4 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -58,6 +58,8 @@ static struct hid_report *hid_register_report(struct hid_device *device, unsigne
 	struct hid_report_enum *report_enum = device->report_enum + type;
 	struct hid_report *report;
 
+	if (id >= HID_MAX_IDS)
+		return NULL;
 	if (report_enum->report_id_hash[id])
 		return report_enum->report_id_hash[id];
 
@@ -368,8 +370,10 @@ static int hid_parser_global(struct hid_parser *parser, struct hid_item *item)
 
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
index 8709365..481080d 100644
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
1.7.12.2.21.g234cd45.dirty



