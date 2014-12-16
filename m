Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaLPXYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:24:05 -0500
Received: from lekensteyn.nl ([178.21.112.251]:51819 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaLPXYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:24:03 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] HID: logitech-hidpp: separate HID++ from WTP processing
Date: Wed, 17 Dec 2014 00:23:51 +0100
Message-Id: <1418772231-31330-1-git-send-email-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <CAN+gG=GhJx38LDwAGoPA1BpYOmjS8r_xnYPXWOgB66VLwmv5kg@mail.gmail.com>
References: <CAN+gG=GhJx38LDwAGoPA1BpYOmjS8r_xnYPXWOgB66VLwmv5kg@mail.gmail.com>
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously wtp_raw_event would be called through
hidpp_raw_hidpp_event (for the touchpad report) and hidpp_raw_event
(for the mouse report).

This patch removes one calling surface, making a clearer distinction
between "generic HID++ processing" (matching internal reports) and
device-specific event processing.

Suggested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Peter Wu <peter@lekensteyn.nl>
Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 v1: patch 2/3 HID: logitech-{dj,hidpp}: check report length
 v2: splitted original report length check patch. Restructured code.
 v3: renamed var r to ret for consistency, added R-b of Benjamin

Hi Benjamin,

I am in a good mood now, so here is v3!

IMO 'r' as 'ret' is common just like 'i' is short for 'index', but for
consistency sake I'll use ret here ;)

Kind regards,
Peter
---
 drivers/hid/hid-logitech-hidpp.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 2f1b0ac..18af2de 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -942,7 +942,7 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 
 	/*
 	 * If the mutex is locked then we have a pending answer from a
-	 * previoulsly sent command
+	 * previously sent command.
 	 */
 	if (unlikely(mutex_is_locked(&hidpp->send_mutex))) {
 		/*
@@ -973,9 +973,6 @@ static int hidpp_raw_hidpp_event(struct hidpp_device *hidpp, u8 *data,
 		return 1;
 	}
 
-	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
-		return wtp_raw_event(hidpp->hid_dev, data, size);
-
 	return 0;
 }
 
@@ -983,7 +980,9 @@ static int hidpp_raw_event(struct hid_device *hdev, struct hid_report *report,
 		u8 *data, int size)
 {
 	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
+	int ret = 0;
 
+	/* Generic HID++ processing. */
 	switch (data[0]) {
 	case REPORT_ID_HIDPP_LONG:
 		if (size != HIDPP_REPORT_LONG_LENGTH) {
@@ -991,16 +990,23 @@ static int hidpp_raw_event(struct hid_device *hdev, struct hid_report *report,
 				size);
 			return 1;
 		}
-		return hidpp_raw_hidpp_event(hidpp, data, size);
+		ret = hidpp_raw_hidpp_event(hidpp, data, size);
+		break;
 	case REPORT_ID_HIDPP_SHORT:
 		if (size != HIDPP_REPORT_SHORT_LENGTH) {
 			hid_err(hdev, "received hid++ report of bad size (%d)",
 				size);
 			return 1;
 		}
-		return hidpp_raw_hidpp_event(hidpp, data, size);
+		ret = hidpp_raw_hidpp_event(hidpp, data, size);
+		break;
 	}
 
+	/* If no report is available for further processing, skip calling
+	 * raw_event of subclasses. */
+	if (ret != 0)
+		return ret;
+
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
 		return wtp_raw_event(hdev, data, size);
 
-- 
2.1.3

