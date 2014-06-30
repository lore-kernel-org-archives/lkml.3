Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaF3McA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:32:00 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964906AbaF3Mb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 117/181] HID: core: fix validation of report id 0
Date: Mon, 30 Jun 2014 13:52:18 +0200
Message-Id: <772b0286464c4dc5e361067e5b1103290b6119ed.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1b15d2e5b8077670b1e6a33250a0d9577efff4a5 upstream.

Some drivers use the first HID report in the list instead of using an
index. In these cases, validation uses ID 0, which was supposed to mean
"first known report". This fixes the problem, which was causing at least
the lgff family of devices to stop working since hid_validate_values
was being called with ID 0, but the devices used single numbered IDs
for their reports:

0x05, 0x01,         /*  Usage Page (Desktop),                   */
0x09, 0x05,         /*  Usage (Gamepad),                        */
0xA1, 0x01,         /*  Collection (Application),               */
0xA1, 0x02,         /*      Collection (Logical),               */
0x85, 0x01,         /*          Report ID (1),                  */
...

Reported-by: Simon Wood <simon@mungewell.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hid/hid-core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 0335f86502c2..245f8922f813 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -842,7 +842,17 @@ struct hid_report *hid_validate_values(struct hid_device *hid,
 	 * ->numbered being checked, which may not always be the case when
 	 * drivers go to access report values.
 	 */
-	report = hid->report_enum[type].report_id_hash[id];
+	if (id == 0) {
+		/*
+		 * Validating on id 0 means we should examine the first
+		 * report in the list.
+		 */
+		report = list_entry(
+				hid->report_enum[type].report_list.next,
+				struct hid_report, list);
+	} else {
+		report = hid->report_enum[type].report_id_hash[id];
+	}
 	if (!report) {
 		hid_err(hid, "missing %s %u\n", hid_report_names[type], id);
 		return NULL;
-- 
2.0.0

