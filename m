Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaLPAuf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:50:35 -0500
Received: from lekensteyn.nl ([178.21.112.251]:59213 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbaLPAud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:50:33 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] HID: logitech-{dj,hidpp}: check report length
Date: Tue, 16 Dec 2014 01:50:15 +0100
Message-Id: <1418691016-30681-3-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418691016-30681-1-git-send-email-peter@lekensteyn.nl>
References: <1418691016-30681-1-git-send-email-peter@lekensteyn.nl>
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Malicious USB devices can send bogus reports smaller than the expected
buffer size. Ensure that the length is valid to avoid reading out of
bounds.

For the old WTP, I do not have a HID descriptor so just check for the
minimum length in hidpp_raw_event (this can be changed to an inequality
later).

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
Hi,

If you know that the WTP report (ID 2) has a length of 2, then you can change
"<" to "!=" and remove the paragraph from the commit message.

Kind regards,
Peter
---
 drivers/hid/hid-logitech-dj.c    | 16 +++++++++++++++-
 drivers/hid/hid-logitech-hidpp.c | 12 +++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index c917ab6..5bc6d80 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -962,10 +962,24 @@ static int logi_dj_raw_event(struct hid_device *hdev,
 
 	switch (data[0]) {
 	case REPORT_ID_DJ_SHORT:
+		if (size != DJREPORT_SHORT_LENGTH) {
+			dev_err(&hdev->dev, "DJ report of bad size (%d)", size);
+			return false;
+		}
 		return logi_dj_dj_event(hdev, report, data, size);
 	case REPORT_ID_HIDPP_SHORT:
-		/* intentional fallthrough */
+		if (size != HIDPP_REPORT_SHORT_LENGTH) {
+			dev_err(&hdev->dev,
+				"Short HID++ report of bad size (%d)", size);
+			return false;
+		}
+		return logi_dj_hidpp_event(hdev, report, data, size);
 	case REPORT_ID_HIDPP_LONG:
+		if (size != HIDPP_REPORT_LONG_LENGTH) {
+			dev_err(&hdev->dev,
+				"Long HID++ report of bad size (%d)", size);
+			return false;
+		}
 		return logi_dj_hidpp_event(hdev, report, data, size);
 	}
 
diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index ae23dec..2315358 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -992,11 +992,17 @@ static int hidpp_raw_event(struct hid_device *hdev, struct hid_report *report,
 			return 1;
 		}
 		return hidpp_raw_hidpp_event(hidpp, data, size);
+	case 0x02:
+		if (size < 2) {
+			hid_err(hdev, "Received HID report of bad size (%d)",
+				size);
+			return 1;
+		}
+		if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
+			return wtp_raw_event(hdev, data, size);
+		return 1;
 	}
 
-	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
-		return wtp_raw_event(hdev, data, size);
-
 	return 0;
 }
 
-- 
2.1.3

