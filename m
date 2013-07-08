Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3GHJNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:13:30 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:41731 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3GHJN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:13:28 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, Jiri Kosina <jkosina@suse.cz>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/2] rtc: rtc-hid-sensor-time: enable HID input processing early
Date: Mon,  8 Jul 2013 11:12:47 +0200
Message-Id: <1373274767-24724-3-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373274767-24724-1-git-send-email-holler@ahsoftware.de>
References: <51D91A5D.3050908@ahsoftware.de>
 <1373274767-24724-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the processing of HID input records before the RTC will be registered,
in order to allow the RTC register function to read clock. Without doing
that the clock can only be read after the probe function has finished.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/rtc/rtc-hid-sensor-time.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 1ab3d13..1006a62 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -279,11 +279,18 @@ static int hid_time_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/*
+	 * Enable HID input processing early in order to be able to read the
+	 * clock already in devm_rtc_device_register().
+	 */
+	hid_device_io_start(hsdev->hdev);
+
 	time_state->rtc = devm_rtc_device_register(&pdev->dev,
 					"hid-sensor-time", &hid_time_rtc_ops,
 					THIS_MODULE);
 
 	if (IS_ERR_OR_NULL(time_state->rtc)) {
+		hid_device_io_stop(hsdev->hdev);
 		ret = time_state->rtc ? PTR_ERR(time_state->rtc) : -ENODEV;
 		time_state->rtc = NULL;
 		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
-- 
1.8.1.4

