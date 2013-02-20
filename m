Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807Ab3BTDft (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 22:35:49 -0500
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:34069 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935646Ab3BTDew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 22:34:52 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=YO+FcVZrxpdWV6Mo6AkY2Rtp7tuV51ZJEd1ZQZEmJbs= c=1 sm=1
 a=7rbM7X0_CQwA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=47LbCVvxAAAA:8 a=VQujHiI9EXa9UuH7ttIA:9
 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org
Subject: [PATCH 2/5] HID: LG: Fix detection of Logitech Speed Force Wireless (WiiWheel)
Date: Tue, 19 Feb 2013 20:25:11 -0700
Message-Id: <1361330714-5217-2-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361330714-5217-1-git-send-email-simon@mungewell.org>
References: <1361330714-5217-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously 'LG4FF' was only used for the WiiWheel, however it is now used
for all the Logitech Wheels. This patch corrects the detection mechanism
for the patching the report descriptor to ensure only the WiiWheel will
be patched.

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index 160c489..c065598 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -242,15 +242,6 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 			 "fixing up rel/abs in Logitech report descriptor\n");
 		rdesc[33] = rdesc[50] = 0x02;
 	}
-	if ((drv_data->quirks & LG_FF4) && *rsize >= 101 &&
-			rdesc[41] == 0x95 && rdesc[42] == 0x0B &&
-			rdesc[47] == 0x05 && rdesc[48] == 0x09) {
-		hid_info(hdev, "fixing up Logitech Speed Force Wireless button descriptor\n");
-		rdesc[41] = 0x05;
-		rdesc[42] = 0x09;
-		rdesc[47] = 0x95;
-		rdesc[48] = 0x0B;
-	}
 
 	switch (hdev->product) {
 
@@ -292,6 +283,17 @@ static __u8 *lg_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 			*rsize = sizeof(dfp_rdesc_fixed);
 		}
 		break;
+
+	case USB_DEVICE_ID_LOGITECH_WII_WHEEL:
+		if (*rsize >= 101 && rdesc[41] == 0x95 && rdesc[42] == 0x0B &&
+				rdesc[47] == 0x05 && rdesc[48] == 0x09) {
+			hid_info(hdev, "fixing up Logitech Speed Force Wireless report descriptor\n");
+			rdesc[41] = 0x05;
+			rdesc[42] = 0x09;
+			rdesc[47] = 0x95;
+			rdesc[48] = 0x0B;
+		}
+		break;
 	}
 
 	return rdesc;
-- 
1.7.10.4

