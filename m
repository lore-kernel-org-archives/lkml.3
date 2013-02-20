Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935663Ab3BTDex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 22:34:53 -0500
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:34066 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933844Ab3BTDev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 22:34:51 -0500
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Feb 2013 22:34:51 EST
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=YO+FcVZrxpdWV6Mo6AkY2Rtp7tuV51ZJEd1ZQZEmJbs= c=1 sm=1
 a=D7il1KcXhDIA:10 a=3762yOXauukA:10 a=BLceEmwcHowA:10
 a=oaxjXb+On79cRBAvziGSJw==:17 a=47LbCVvxAAAA:8 a=h-rVzXr4HokMWlinBgYA:9
 a=QhNQsjeWOoAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Simon Wood <simon@mungewell.org>
To: linux-input@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        simon@mungewell.org
Subject: [PATCH 3/5] HID: LG: Prevent the Logitech Gaming Wheels deadzone
Date: Tue, 19 Feb 2013 20:25:12 -0700
Message-Id: <1361330714-5217-3-git-send-email-simon@mungewell.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1361330714-5217-1-git-send-email-simon@mungewell.org>
References: <1361330714-5217-1-git-send-email-simon@mungewell.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures that the Logitech wheels are not initialised with
default fuzz/flat values, by marking them as multiaxis devices (rather
than joysticks).

Signed-off-by: Simon Wood <simon@mungewell.org>
---
 drivers/hid/hid-lg.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/hid/hid-lg.c b/drivers/hid/hid-lg.c
index c065598..5d3c861 100644
--- a/drivers/hid/hid-lg.c
+++ b/drivers/hid/hid-lg.c
@@ -479,6 +479,26 @@ static int lg_input_mapped(struct hid_device *hdev, struct hid_input *hi,
 			 usage->type == EV_REL || usage->type == EV_ABS))
 		clear_bit(usage->code, *bit);
 
+	/* Ensure that Logitech wheels are not given a default fuzz/flat value */
+	if (usage->type == EV_ABS && (usage->code == ABS_X ||
+			usage->code == ABS_Y || usage->code == ABS_Z ||
+			usage->code == ABS_RZ)) {
+		switch (hdev->product) {
+		case USB_DEVICE_ID_LOGITECH_WHEEL:
+		case USB_DEVICE_ID_LOGITECH_MOMO_WHEEL:
+		case USB_DEVICE_ID_LOGITECH_DFP_WHEEL:
+		case USB_DEVICE_ID_LOGITECH_G25_WHEEL:
+		case USB_DEVICE_ID_LOGITECH_DFGT_WHEEL:
+		case USB_DEVICE_ID_LOGITECH_G27_WHEEL:
+		case USB_DEVICE_ID_LOGITECH_WII_WHEEL:
+		case USB_DEVICE_ID_LOGITECH_MOMO_WHEEL2:
+			field->application = HID_GD_MULTIAXIS;
+			break;
+		default:
+			break;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.7.10.4

