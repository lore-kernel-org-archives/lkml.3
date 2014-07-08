Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974AbaGHTm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:42:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54073 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755675AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Simon Wood" <simon@mungewell.org>,
        "Benjamin Tissoires" <benjamin.tissoires@redhat.com>,
        "Kees Cook" <keescook@chromium.org>, "Jiri Kosina" <jkosina@suse.cz>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.454359113@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 007/125] HID: core: fix validation of report id 0
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -754,7 +754,17 @@ struct hid_report *hid_validate_values(s
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

