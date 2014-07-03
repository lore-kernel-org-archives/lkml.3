Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbaGCJVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaGCJVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kees Cook <keescook@chromium.org>, Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 030/198] HID: core: fix validation of report id 0
Date: Thu,  3 Jul 2014 10:17:53 +0100
Message-Id: <1404379241-8590-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 016aab4b4d32..5fa380f86154 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -796,7 +796,17 @@ struct hid_report *hid_validate_values(struct hid_device *hid,
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
1.9.1

