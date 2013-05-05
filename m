Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3EELX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 07:23:28 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:48015 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106Ab3EELX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 07:23:27 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 3/4] rtc: rtc-hid-sensor-time: add option hctosys to set time at boot
Date: Sun,  5 May 2013 13:21:26 +0200
Message-Id: <1367752887-2927-4-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1367752887-2927-1-git-send-email-holler@ahsoftware.de>
References: <51765FB9.2050009@ahsoftware.de>
 <1367752887-2927-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/rtc/hctosys (CONFIG_RTC_HCTOSYS) doesn't work for
rtc-hid-sensor-time because it will be called in late_init, and thus before
rtc-hid-sensor-time gets loaded. To set the time through
rtc-hid-sensor-time at startup, the module now checks by default if the
system time is before 1970-01-02 and sets the system time (once) if this is
the case.

To disable this behaviour, set the module option hctosys to zero, e.g. by
using rtc-hid-sensor-time.hctosys=0 at the kernel command line if the
driver is statically linked into the kernel.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/rtc/rtc-hid-sensor-time.c | 94 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 94 insertions(+)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 7273b01..db8503a 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -27,6 +27,12 @@
 /* Usage ID from spec for Time: 0x2000A0 */
 #define DRIVER_NAME "HID-SENSOR-2000a0" /* must be lowercase */
 
+static bool hid_time_hctosys_enabled = 1;
+module_param_named(hctosys, hid_time_hctosys_enabled, bool, 0644);
+MODULE_PARM_DESC(hctosys,
+	"set the system time (once) if it is before 1970-01-02");
+static bool hid_time_time_set_once;
+
 enum hid_time_channel {
 	CHANNEL_SCAN_INDEX_YEAR,
 	CHANNEL_SCAN_INDEX_MONTH,
@@ -37,6 +43,11 @@ enum hid_time_channel {
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
@@ -46,6 +57,7 @@ struct hid_time_state {
 	struct completion comp_last_time;
 	struct rtc_time time_buf;
 	struct rtc_device *rtc;
+	struct hid_time_workts *workts;
 };
 
 static const u32 hid_time_addresses[TIME_RTC_CHANNEL_MAX] = {
@@ -62,6 +74,49 @@ static const char * const hid_time_channel_names[TIME_RTC_CHANNEL_MAX] = {
 	"year", "month", "day", "hour", "minute", "second",
 };
 
+static void hid_time_hctosys(struct hid_time_state *time_state)
+{
+	struct timespec ts;
+	int rc = rtc_valid_tm(&time_state->last_time);
+
+	if (rc) {
+		dev_err(time_state->rtc->dev.parent,
+			"hctosys: invalid date/time\n");
+		return;
+	}
+
+	getnstimeofday(&ts);
+	if (ts.tv_sec >= 86400) /* 1970-01-02 00:00:00 UTC */
+		/*
+		 * Security: don't let a hot-pluggable device change
+		 * a valid system time.
+		 * In absence of a kernel-wide flag like 'systime_was_set',
+		 * we check if the system time is earlier than 1970-01-02.
+		 * Just using a flag inside the RTC subsystem (e.g. from
+		 * hctosys) doesn't work, because the time could be set
+		 * by userspace (NTP, date, user, ...) or something else
+		 * in the kernel too.
+		 * Using a whole day to decide if something else has set the
+		 * time should be enough for even the longest boot to complete
+		 * (including possible forced fscks) and load this module.
+		 */
+		return;
+
+	ts.tv_nsec = NSEC_PER_SEC >> 1;
+	rtc_tm_to_time(&time_state->last_time, &ts.tv_sec);
+	rc = do_settimeofday(&ts);
+	dev_info(time_state->rtc->dev.parent,
+		"hctosys: setting system clock to "
+		"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+		time_state->last_time.tm_year + 1900,
+		time_state->last_time.tm_mon + 1,
+		time_state->last_time.tm_mday,
+		time_state->last_time.tm_hour,
+		time_state->last_time.tm_min,
+		time_state->last_time.tm_sec,
+		(unsigned int) ts.tv_sec);
+}
+
 /* Callback handler to send event after all samples are received and captured */
 static int hid_time_proc_event(struct hid_sensor_hub_device *hsdev,
 				unsigned usage_id, void *priv)
@@ -73,6 +128,10 @@ static int hid_time_proc_event(struct hid_sensor_hub_device *hsdev,
 	time_state->last_time = time_state->time_buf;
 	spin_unlock_irqrestore(&time_state->lock_last_time, flags);
 	complete(&time_state->comp_last_time);
+	if (unlikely(!hid_time_time_set_once && hid_time_hctosys_enabled)) {
+		hid_time_time_set_once = 1;
+		hid_time_hctosys(time_state);
+	}
 	return 0;
 }
 
@@ -237,6 +296,19 @@ static const struct rtc_class_ops hid_time_rtc_ops = {
 	.read_time = hid_rtc_read_time,
 };
 
+static void hid_time_request_report_work(struct work_struct *work)
+{
+	struct hid_time_state *time_state =
+		container_of(work, struct hid_time_workts, work)
+			->time_state;
+	/* get a report with all values through requesting one value */
+	sensor_hub_input_attr_get_raw_value(
+		time_state->common_attributes.hsdev, HID_USAGE_SENSOR_TIME,
+		hid_time_addresses[0], time_state->info[0].report_id);
+	time_state->workts = NULL;
+	kfree(work);
+}
+
 static int hid_time_probe(struct platform_device *pdev)
 {
 	int ret = 0;
@@ -288,13 +360,35 @@ static int hid_time_probe(struct platform_device *pdev)
 		return PTR_ERR(time_state->rtc);
 	}
 
+	if (!hid_time_time_set_once && hid_time_hctosys_enabled) {
+		/*
+		 * Request a HID report to set the time.
+		 * Calling sensor_hub_..._get_raw_value() here directly
+		 * doesn't work, therefor we have to use a work.
+		 */
+		time_state->workts = kmalloc(sizeof(struct hid_time_workts),
+			GFP_KERNEL);
+		if (time_state->workts == NULL)
+			return -ENOMEM;
+		time_state->workts->time_state = time_state;
+		INIT_WORK(&time_state->workts->work,
+			hid_time_request_report_work);
+		schedule_work(&time_state->workts->work);
+	}
+
 	return ret;
 }
 
 static int hid_time_remove(struct platform_device *pdev)
 {
 	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
+	struct hid_time_state *time_state = platform_get_drvdata(pdev);
 
+	if (time_state->workts) {
+		cancel_work_sync(&time_state->workts->work);
+		kfree(time_state->workts);
+		time_state->workts = NULL;
+	}
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 
 	return 0;
-- 
1.8.1.5

