Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3FDJo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:44:58 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:53802 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3FDJo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:44:56 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] rtc: rtc-hid-sensor-time: fix possible bug on driver_remove
Date: Tue,  4 Jun 2013 11:38:42 +0200
Message-Id: <1370338722-3646-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1367752887-2927-4-git-send-email-holler@ahsoftware.de>
References: <1367752887-2927-4-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The work we schedule on register deletes himself. Therefor we cannot
use cancel_work_sync() because that calls flush_work() but still uses
the pointer to the (now deleted) work afterwards (for clear_work_data)
which ends up in a bug.
Replacing cancel_work_sync() with flush_work() fixes that.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---

 This patch applies on top of PATCH 3/4 or 4/4 of the small series of 4 patches
 for rtc-hid-sensor-time, which was already merged into the -mm tree.

 drivers/rtc/rtc-hid-sensor-time.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 4aca12d..acb2bc2 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -414,9 +414,8 @@ static int hid_time_remove(struct platform_device *pdev)
 	struct hid_time_state *time_state = platform_get_drvdata(pdev);
 
 	if (time_state->workts) {
-		cancel_work_sync(&time_state->workts->work);
-		kfree(time_state->workts);
-		time_state->workts = NULL;
+		flush_work(&time_state->workts->work);
+		BUG_ON(time_state->workts != NULL);
 	}
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 
-- 
1.8.1.5

