Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580Ab3FNQ4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:56:30 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50305 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab3FNQ43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:56:29 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 9/9] RFC: rtc: rtc-hid-sensor-time: add support for rtc_read_timeval()
Date: Fri, 14 Jun 2013 18:52:12 +0200
Message-Id: <1371228732-5749-10-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
References: <51BA1FF7.4000206@ahsoftware.de>
 <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some HID clocks do provide milliseconds. Make it possible to read a high
precision timestamp by supporting rtc_read_timeval().

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/rtc/rtc-hid-sensor-time.c | 74 +++++++++++++++++++++++++++++++--------
 include/linux/hid-sensor-ids.h    |  1 +
 2 files changed, 61 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index b842730..3e6d874 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -34,6 +34,7 @@ enum hid_time_channel {
 	CHANNEL_SCAN_INDEX_HOUR,
 	CHANNEL_SCAN_INDEX_MINUTE,
 	CHANNEL_SCAN_INDEX_SECOND,
+	CHANNEL_SCAN_INDEX_MILLISECOND, /* optional */
 	TIME_RTC_CHANNEL_MAX,
 };
 
@@ -47,11 +48,14 @@ struct hid_time_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info info[TIME_RTC_CHANNEL_MAX];
 	struct rtc_time last_time;
+	unsigned last_ms; /* == UINT_MAX to indicate ms aren't supported */
 	spinlock_t lock_last_time;
 	struct completion comp_last_time;
 	struct rtc_time time_buf;
+	unsigned ms_buf;
 	struct rtc_device *rtc;
 	struct hid_time_workts *workts;
+	struct rtc_class_ops rtc_ops;
 };
 
 static const u32 hid_time_addresses[TIME_RTC_CHANNEL_MAX] = {
@@ -61,11 +65,12 @@ static const u32 hid_time_addresses[TIME_RTC_CHANNEL_MAX] = {
 	HID_USAGE_SENSOR_TIME_HOUR,
 	HID_USAGE_SENSOR_TIME_MINUTE,
 	HID_USAGE_SENSOR_TIME_SECOND,
+	HID_USAGE_SENSOR_TIME_MILLISECOND, /* optional */
 };
 
 /* Channel names for verbose error messages */
 static const char * const hid_time_channel_names[TIME_RTC_CHANNEL_MAX] = {
-	"year", "month", "day", "hour", "minute", "second",
+	"year", "month", "day", "hour", "minute", "second", "millisecond",
 };
 
 /* Callback handler to send event after all samples are received and captured */
@@ -77,6 +82,8 @@ static int hid_time_proc_event(struct hid_sensor_hub_device *hsdev,
 
 	spin_lock_irqsave(&time_state->lock_last_time, flags);
 	time_state->last_time = time_state->time_buf;
+	if (time_state->last_ms != UINT_MAX)
+		time_state->last_ms = time_state->ms_buf;
 	spin_unlock_irqrestore(&time_state->lock_last_time, flags);
 	complete(&time_state->comp_last_time);
 	return 0;
@@ -135,6 +142,9 @@ static int hid_time_capture_sample(struct hid_sensor_hub_device *hsdev,
 	case HID_USAGE_SENSOR_TIME_SECOND:
 		time_buf->tm_sec = (int)hid_time_value(raw_len, raw_data);
 		break;
+	case HID_USAGE_SENSOR_TIME_MILLISECOND:
+		time_state->ms_buf = hid_time_value(raw_len, raw_data);
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -161,12 +171,18 @@ static int hid_time_parse_report(struct platform_device *pdev,
 {
 	int report_id, i;
 
-	for (i = 0; i < TIME_RTC_CHANNEL_MAX; ++i)
+	/* Check if all required attributes are available */
+	for (i = 0; i < CHANNEL_SCAN_INDEX_MILLISECOND; ++i)
 		if (sensor_hub_input_get_attribute_info(hsdev,
 				HID_INPUT_REPORT, usage_id,
 				hid_time_addresses[i],
 				&time_state->info[i]) < 0)
 			return -EINVAL;
+	if (!sensor_hub_input_get_attribute_info(hsdev, HID_INPUT_REPORT,
+		usage_id, hid_time_addresses[i], &time_state->info[i])) {
+		dev_info(&pdev->dev, "milliseconds supported\n");
+		time_state->last_ms = 0;
+	}
 	/* Check the (needed) attributes for sanity */
 	report_id = time_state->info[0].report_id;
 	if (report_id < 0) {
@@ -174,6 +190,10 @@ static int hid_time_parse_report(struct platform_device *pdev,
 		return -EINVAL;
 	}
 	for (i = 0; i < TIME_RTC_CHANNEL_MAX; ++i) {
+		if (time_state->info[i].attrib_id ==
+				HID_USAGE_SENSOR_TIME_MILLISECOND &&
+				time_state->last_ms == UINT_MAX)
+			continue;
 		if (time_state->info[i].report_id != report_id) {
 			dev_err(&pdev->dev,
 				"not all needed attributes inside the same report!\n");
@@ -212,21 +232,25 @@ static int hid_time_parse_report(struct platform_device *pdev,
 	return 0;
 }
 
-static int hid_rtc_read_time(struct device *dev, struct rtc_time *tm)
+static int hid_time_get_report(struct hid_time_state *time_state)
 {
-	unsigned long flags;
-	struct hid_time_state *time_state =
-		platform_get_drvdata(to_platform_device(dev));
-	int ret;
-
 	INIT_COMPLETION(time_state->comp_last_time);
 	/* get a report with all values through requesting one value */
 	sensor_hub_input_attr_get_raw_value(time_state->common_attributes.hsdev,
 			HID_USAGE_SENSOR_TIME, hid_time_addresses[0],
 			time_state->info[0].report_id);
 	/* wait for all values (event) */
-	ret = wait_for_completion_killable_timeout(
-			&time_state->comp_last_time, HZ*6);
+	return wait_for_completion_killable_timeout(&time_state->comp_last_time,
+							HZ*6);
+}
+
+static int hid_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	unsigned long flags;
+	struct hid_time_state *time_state =
+		platform_get_drvdata(to_platform_device(dev));
+	int ret = hid_time_get_report(time_state);
+
 	if (ret > 0) {
 		/* no error */
 		spin_lock_irqsave(&time_state->lock_last_time, flags);
@@ -239,9 +263,25 @@ static int hid_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	return ret; /* killed (-ERESTARTSYS) */
 }
 
-static const struct rtc_class_ops hid_time_rtc_ops = {
-	.read_time = hid_rtc_read_time,
-};
+static int hid_rtc_read_timeval(struct device *dev, struct timeval *tv)
+{
+	unsigned long flags;
+	struct hid_time_state *time_state =
+		platform_get_drvdata(to_platform_device(dev));
+	int ret = hid_time_get_report(time_state);
+
+	if (ret > 0) {
+		/* no error */
+		spin_lock_irqsave(&time_state->lock_last_time, flags);
+		rtc_tm_to_time(&time_state->last_time, &tv->tv_sec);
+		tv->tv_usec = time_state->last_ms * USEC_PER_MSEC;
+		spin_unlock_irqrestore(&time_state->lock_last_time, flags);
+		return 0;
+	}
+	if (!ret)
+		return -EIO; /* timeouted */
+	return ret; /* killed (-ERESTARTSYS) */
+}
 
 static void hid_time_register_rtc_work(struct work_struct *work)
 {
@@ -251,7 +291,7 @@ static void hid_time_register_rtc_work(struct work_struct *work)
 	struct platform_device *pdev = time_state->callbacks.pdev;
 
 	time_state->rtc = devm_rtc_device_register(&pdev->dev,
-					"hid-sensor-time", &hid_time_rtc_ops,
+					"hid-sensor-time", &time_state->rtc_ops,
 					THIS_MODULE);
 	if (IS_ERR_OR_NULL(time_state->rtc)) {
 		struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
@@ -283,6 +323,8 @@ static int hid_time_probe(struct platform_device *pdev)
 	if (time_state == NULL)
 		return -ENOMEM;
 
+	time_state->last_ms = UINT_MAX;
+
 	platform_set_drvdata(pdev, time_state);
 
 	spin_lock_init(&time_state->lock_last_time);
@@ -315,6 +357,10 @@ static int hid_time_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	time_state->rtc_ops.read_time = hid_rtc_read_time;
+	if (time_state->last_ms != UINT_MAX)
+		time_state->rtc_ops.read_timeval = hid_rtc_read_timeval;
+
 	/*
 	 * The HID device has to be registered to read the clock.
 	 * Because rtc_device_register() might read the time, we have to delay
diff --git a/include/linux/hid-sensor-ids.h b/include/linux/hid-sensor-ids.h
index 6f24446..b519c47 100644
--- a/include/linux/hid-sensor-ids.h
+++ b/include/linux/hid-sensor-ids.h
@@ -74,6 +74,7 @@
 #define HID_USAGE_SENSOR_TIME_HOUR				0x200525
 #define HID_USAGE_SENSOR_TIME_MINUTE				0x200526
 #define HID_USAGE_SENSOR_TIME_SECOND				0x200527
+#define HID_USAGE_SENSOR_TIME_MILLISECOND			0x200528
 
 /* Units */
 #define HID_USAGE_SENSOR_UNITS_NOT_SPECIFIED			0x00
-- 
1.8.1.4

