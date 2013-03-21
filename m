Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3CURWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:22:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:50566 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab3CURW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:22:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,887,1355126400"; 
   d="scan'208";a="305711201"
From: daniel.leung@linux.intel.com
To: jkosina@suse.cz, srinivas.pandruvada@intel.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Leung <daniel.leung@linux.intel.com>
Subject: [PATCH] HID: hid-sensor-hub: do not process feature reports in raw_event
Date: Thu, 21 Mar 2013 10:22:26 -0700
Message-Id: <1363886546-6517-1-git-send-email-daniel.leung@linux.intel.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Leung <daniel.leung@linux.intel.com>

In sensor_hub_raw_event(), HID feature reports are ignored but are
still marked as processed. This causes the in-kernel struct not to be
updated. Any non-updated fields in the feature reports are zero, and
they are being sent to the device. This causes confusion in the
sensor hub firmware, and some sensors are not powered up as a result.

This changes the raw_event rountine to only process input reports,
and let the hid core handle the incoming feature reports.

The issue has been observed on Acer Iconia W700.

Signed-off-by: Daniel Leung <daniel.leung@linux.intel.com>
---
 drivers/hid/hid-sensor-hub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index ca749810..3f7df68 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -413,7 +413,7 @@ static int sensor_hub_raw_event(struct hid_device *hdev,
 			 report->id, size, report->type);
 	hid_dbg(hdev, "maxfield:%d\n", report->maxfield);
 	if (report->type != HID_INPUT_REPORT)
-		return 1;
+		return 0;
 
 	ptr = raw_data;
 	ptr++; /*Skip report id*/
-- 
1.8.1.5

