Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab3JUIvO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39396 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477Ab3JUIvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jiri Kosina" <jkosina@suse.cz>,
        "Kees Cook" <keescook@chromium.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.966669635@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 039/149] HID: validate HID report id size
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
[bwh: Backported to 3.2: use dbg_hid() not hid_err()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-core.c | 10 +++++++---
 include/linux/hid.h    |  4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -59,6 +59,8 @@ struct hid_report *hid_register_report(s
 	struct hid_report_enum *report_enum = device->report_enum + type;
 	struct hid_report *report;
 
+	if (id >= HID_MAX_IDS)
+		return NULL;
 	if (report_enum->report_id_hash[id])
 		return report_enum->report_id_hash[id];
 
@@ -380,8 +382,10 @@ static int hid_parser_global(struct hid_
 
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
@@ -552,7 +556,7 @@ static void hid_device_release(struct de
 	for (i = 0; i < HID_REPORT_TYPES; i++) {
 		struct hid_report_enum *report_enum = device->report_enum + i;
 
-		for (j = 0; j < 256; j++) {
+		for (j = 0; j < HID_MAX_IDS; j++) {
 			struct hid_report *report = report_enum->report_id_hash[j];
 			if (report)
 				hid_free_report(report);
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -416,10 +416,12 @@ struct hid_report {
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

