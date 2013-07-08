Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3GHJNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 05:13:24 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:41716 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649Ab3GHJNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 05:13:21 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>, Jiri Kosina <jkosina@suse.cz>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/2] rtc: rtc-hid-sensor-time: improve error handling when rtc register fails
Date: Mon,  8 Jul 2013 11:12:46 +0200
Message-Id: <1373274767-24724-2-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373274767-24724-1-git-send-email-holler@ahsoftware.de>
References: <51D91A5D.3050908@ahsoftware.de>
 <1373274767-24724-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop processing hid input when registering the RTC fails and handle
a NULL returned from devm_rtc_device_register() as a failure too.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/rtc/rtc-hid-sensor-time.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 7273b01..1ab3d13 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -283,9 +283,11 @@ static int hid_time_probe(struct platform_device *pdev)
 					"hid-sensor-time", &hid_time_rtc_ops,
 					THIS_MODULE);
 
-	if (IS_ERR(time_state->rtc)) {
+	if (IS_ERR_OR_NULL(time_state->rtc)) {
+		ret = time_state->rtc ? PTR_ERR(time_state->rtc) : -ENODEV;
+		time_state->rtc = NULL;
+		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 		dev_err(&pdev->dev, "rtc device register failed!\n");
-		return PTR_ERR(time_state->rtc);
 	}
 
 	return ret;
-- 
1.8.1.4

