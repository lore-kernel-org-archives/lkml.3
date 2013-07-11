Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab3GKNmM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:42:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab3GKNln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:41:43 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        David Herrmann <dh.herrmann@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-bluetooth@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Bluetooth: hidp: remove wrong send_report at init
Date: Thu, 11 Jul 2013 15:41:30 +0200
Message-Id: <1373550090-30379-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1373550090-30379-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The USB hid implementation does retrieve the reports during the start.
However, this implementation does not call the HID command GET_REPORT
(which would fetch the current status of each report), but use the
DATA command, which is an Output Report (so transmitting data from the
host to the device).
The Wiimote controller is already guarded against this problem in the
protocol, but it is not conformant to the specification to set all the
reports to 0 on start.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 net/bluetooth/hidp/core.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 9c8b50d..59d132a 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -703,20 +703,6 @@ static int hidp_parse(struct hid_device *hid)
 
 static int hidp_start(struct hid_device *hid)
 {
-	struct hidp_session *session = hid->driver_data;
-	struct hid_report *report;
-
-	if (hid->quirks & HID_QUIRK_NO_INIT_REPORTS)
-		return 0;
-
-	list_for_each_entry(report, &hid->report_enum[HID_INPUT_REPORT].
-			report_list, list)
-		hidp_send_report(session, report);
-
-	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].
-			report_list, list)
-		hidp_send_report(session, report);
-
 	return 0;
 }
 
-- 
1.8.3.1

