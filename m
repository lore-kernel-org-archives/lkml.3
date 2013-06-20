Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3FTKkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:40:52 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45689 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3FTKku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:40:50 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 3/9 v2] rtc: rtc-hid-sensor-time: delay registering as rtc into a work
Date: Thu, 20 Jun 2013 12:39:36 +0200
Message-Id: <1371724776-5572-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371228732-5749-4-git-send-email-holler@ahsoftware.de>
References: <1371228732-5749-4-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc_device_register() might want to read the clock which doesn't work
before the hid device is registered. Therefor we delay the registration of
the rtc driver by moving it to a work.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 Changes to v1:

  I've fixed a bug calling rtc_device_unregister() in remove() which was
  necessary in 3.9 but leads to a crash in 3.10 (through the use of devm_*).
  Sorry for that, I assume I've resolved a conflict wrong while moving this
  patch from 3.9.x to 3.10.

 This patch can already be added to -mm. It is only necessary if
 rtc_device_register() reads the time (which would fail without this patch).
 I've left the "3/9" in the subject only there, because the patch was named
 as such before. But the patch is independ if hctosys will be changed or not.
 1/9 and 2/9 are already in -mm, 4-9 are in discussion which will need some
 time.

 Thanks,

 Alexander Holler

 drivers/rtc/rtc-hid-sensor-time.c | 64 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 7273b01..0767395 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -37,6 +37,11 @@ enum hid_time_channel {
 	TIME_RTC_CHANNEL_MAX,
 };
 
+struct hid_time_workts {
+	struct work_struct work;
+	struct hid_time_state *time_state;
+};
+
 struct hid_time_state {
 	struct hid_sensor_hub_callbacks callbacks;
 	struct hid_sensor_common common_attributes;
@@ -46,6 +51,7 @@ struct hid_time_state {
 	struct completion comp_last_time;
 	struct rtc_time time_buf;
 	struct rtc_device *rtc;
+	struct hid_time_workts *workts;
 };
 
 static const u32 hid_time_addresses[TIME_RTC_CHANNEL_MAX] = {
@@ -237,6 +243,36 @@ static const struct rtc_class_ops hid_time_rtc_ops = {
 	.read_time = hid_rtc_read_time,
 };
 
+static void hid_time_register_rtc_work(struct work_struct *work)
+{
+	struct hid_time_state *time_state =
+		container_of(work, struct hid_time_workts, work)
+			->time_state;
+	struct platform_device *pdev = time_state->callbacks.pdev;
+
+	time_state->rtc = devm_rtc_device_register(&pdev->dev,
+					"hid-sensor-time", &hid_time_rtc_ops,
+					THIS_MODULE);
+	if (IS_ERR_OR_NULL(time_state->rtc)) {
+		struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
+		time_state->rtc = NULL;
+		dev_err(&pdev->dev, "rtc device register failed!\n");
+		/*
+		 *  I haven't a found a way to remove only this device from
+		 *  hid-sensor-hub. Removing the device a level above (the
+		 *  complete HID device) doesn't work, because a sensor-hub
+		 *  might provide more than just a time-sensor and thus we
+		 *  would remove all sensors not just this one.
+		 *  So we just leave this driver idling around until I or
+		 *  someone else has figured out how to remove this device
+		 *  from hid-sensor-hub.
+		 */
+	}
+	time_state->workts = NULL;
+	kfree(work);
+}
+
 static int hid_time_probe(struct platform_device *pdev)
 {
 	int ret = 0;
@@ -279,22 +315,34 @@ static int hid_time_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	time_state->rtc = devm_rtc_device_register(&pdev->dev,
-					"hid-sensor-time", &hid_time_rtc_ops,
-					THIS_MODULE);
-
-	if (IS_ERR(time_state->rtc)) {
-		dev_err(&pdev->dev, "rtc device register failed!\n");
-		return PTR_ERR(time_state->rtc);
+	/*
+	 * The HID device has to be registered to read the clock.
+	 * Because rtc_device_register() might read the time, we have to delay
+	 * rtc_device_register() to a work in order to finish the probe before.
+	 */
+	time_state->workts = kmalloc(sizeof(struct hid_time_workts),
+		GFP_KERNEL);
+	if (time_state->workts == NULL) {
+		sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
+		return -ENOMEM;
 	}
+	time_state->workts->time_state = time_state;
+	INIT_WORK(&time_state->workts->work,
+			hid_time_register_rtc_work);
+	schedule_work(&time_state->workts->work);
 
-	return ret;
+	return 0;
 }
 
 static int hid_time_remove(struct platform_device *pdev)
 {
 	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_time_state *time_state = platform_get_drvdata(pdev);
 
+	if (time_state->workts) {
+		flush_work(&time_state->workts->work);
+		WARN_ON(time_state->workts != NULL);
+	}
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 
 	return 0;
-- 
1.8.1.4

