Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab3IYB0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:26:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab3IYAMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:12:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 24/40] HID: validate HID report id size
Date: Tue, 24 Sep 2013 17:11:56 -0700
Message-Id: <20130925001044.576740150@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001041.939335518@linuxfoundation.org>
References: <20130925001041.939335518@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |   10 +++++++---
 include/linux/hid.h    |    4 +++-
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -63,6 +63,8 @@ struct hid_report *hid_register_report(s
 	struct hid_report_enum *report_enum = device->report_enum + type;
 	struct hid_report *report;
 
+	if (id >= HID_MAX_IDS)
+		return NULL;
 	if (report_enum->report_id_hash[id])
 		return report_enum->report_id_hash[id];
 
@@ -385,8 +387,10 @@ static int hid_parser_global(struct hid_
 
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
@@ -557,7 +561,7 @@ static void hid_device_release(struct de
 	for (i = 0; i < HID_REPORT_TYPES; i++) {
 		struct hid_report_enum *report_enum = device->report_enum + i;
 
-		for (j = 0; j < 256; j++) {
+		for (j = 0; j < HID_MAX_IDS; j++) {
 			struct hid_report *report = report_enum->report_id_hash[j];
 			if (report)
 				hid_free_report(report);
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -420,10 +420,12 @@ struct hid_report {
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


