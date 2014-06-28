Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbaF1SxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:53:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaF1RtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Simon Wood <simon@mungewell.org>, Kees Cook <keescook@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.14 029/110] HID: core: fix validation of report id 0
Date: Sat, 28 Jun 2014 10:46:26 -0700
Message-Id: <20140628174546.923110637@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-core.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -842,7 +842,17 @@ struct hid_report *hid_validate_values(s
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


