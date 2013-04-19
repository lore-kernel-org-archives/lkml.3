Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030701Ab3DSPQA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:16:00 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:56015 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030512Ab3DSPP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:15:57 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 3/3] rtc: rtc-hid-sensor-time; add option hctosys to set time at boot
Date: Fri, 19 Apr 2013 17:14:12 +0200
Message-Id: <1366384452-14367-4-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1366384452-14367-1-git-send-email-holler@ahsoftware.de>
References: <1366384452-14367-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/rtc/hctosys (CONFIG_RTC_HCTOSYS) doesn't work for
rtc-hid-sensor-time because it will be called in late_init, and thus before
rtc-hid-sensor-time gets loaded. To set the time through rtc-hid-sensor-time
at startup, the module now checks by default if the system time is before
1970-01-02 and sets the system time (once) if this is the case.

To disable this behaviour, set the module option hctosys to zero, e.g. by
using rtc-hid-sensor-time.hctosys=0 at the kernel command line if the
driver is statically linked into the kernel.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/rtc/rtc-hid-sensor-time.c | 72 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 10fc0f0..3184729 100644
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
@@ -62,6 +68,38 @@ static const char * const hid_time_channel_names[TIME_RTC_CHANNEL_MAX] = {
 	"year", "month", "day", "hour", "minute", "second",
 };
 
+static void hid_time_hctosys(struct hid_time_state *time_state)
+{
+	struct timeval tv;
+	struct timespec ts;
+	int rc = rtc_valid_tm(&time_state->last_time);
+	if (rc) {
+		dev_err(time_state->rtc->dev.parent,
+			"hctosys: invalid date/time\n");
+		return;
+	}
+	do_gettimeofday(&tv);
+	if (tv.tv_sec >= 86400) /* 1970-01-02 00:00:00 UTC */
+		/*
+		 * Security: don't let a hot-pluggable device change
+		 * a valid system time.
+		 */
+		return;
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
@@ -73,6 +111,10 @@ static int hid_time_proc_event(struct hid_sensor_hub_device *hsdev,
 	time_state->last_time = time_state->time_buf;
 	spin_unlock_irqrestore(&time_state->lock_last_time, flags);
 	complete(&time_state->comp_last_time);
+	if (unlikely(!hid_time_time_set_once && hid_time_hctosys_enabled)) {
+		hid_time_time_set_once = 1;
+		hid_time_hctosys(time_state);
+	}
 	return 0;
 }
 
@@ -237,6 +279,22 @@ static const struct rtc_class_ops hid_time_rtc_ops = {
 	.read_time = hid_rtc_read_time,
 };
 
+struct hid_time_work_time_state {
+	struct work_struct work;
+	struct hid_time_state *time_state;
+};
+
+static void hid_time_request_report_work(struct work_struct *work)
+{
+	struct hid_time_state *time_state =
+		((struct hid_time_work_time_state *)work)->time_state;
+	/* get a report with all values through requesting one value */
+	sensor_hub_input_attr_get_raw_value(
+		time_state->common_attributes.hsdev, HID_USAGE_SENSOR_TIME,
+		hid_time_addresses[0], time_state->info[0].report_id);
+	kfree(work);
+}
+
 static int hid_time_probe(struct platform_device *pdev)
 {
 	int ret = 0;
@@ -287,6 +345,20 @@ static int hid_time_probe(struct platform_device *pdev)
 		return PTR_ERR(time_state->rtc);
 	}
 
+	if (!hid_time_time_set_once && hid_time_hctosys_enabled) {
+		/*
+		 * Request a HID report to set the time.
+		 * Calling sensor_hub_..._get_raw_value() here directly
+		 * doesn't work, therefor we have to use a work.
+		 */
+		struct hid_time_work_time_state *hdwork =
+			kmalloc(sizeof(struct hid_time_work_time_state),
+				GFP_KERNEL);
+		hdwork->time_state = time_state;
+		INIT_WORK(&hdwork->work, hid_time_request_report_work);
+		schedule_work(&hdwork->work);
+	}
+
 	return ret;
 }
 
-- 
1.8.1.4

