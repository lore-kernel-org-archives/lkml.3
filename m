Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030888Ab3DSPPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 11:15:32 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:55985 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030529Ab3DSPP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 11:15:28 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jonathan Cameron <jic23@cam.ac.uk>, Jiri Kosina <jkosina@suse.cz>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 2/3] rtc: rtc-hid-sensor-time: allow 16 and 32 bit values for all attributes.
Date: Fri, 19 Apr 2013 17:14:11 +0200
Message-Id: <1366384452-14367-3-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1366384452-14367-1-git-send-email-holler@ahsoftware.de>
References: <1366384452-14367-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no real reason to not support 16 or 32 bit values too.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/rtc/rtc-hid-sensor-time.c | 59 +++++++++++++++++++++------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index f3ef38a..10fc0f0 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -76,6 +76,20 @@ static int hid_time_proc_event(struct hid_sensor_hub_device *hsdev,
 	return 0;
 }
 
+static u32 hid_time_value(size_t raw_len, char *raw_data)
+{
+	switch (raw_len) {
+	case 1:
+		return *(u8 *)raw_data;
+	case 2:
+		return *(u16 *)raw_data;
+	case 4:
+		return *(u32 *)raw_data;
+	default:
+		return (u32)(~0U); /* 0xff... or -1 to denote an error */
+	}
+}
+
 static int hid_time_capture_sample(struct hid_sensor_hub_device *hsdev,
 				unsigned usage_id, size_t raw_len,
 				char *raw_data, void *priv)
@@ -85,29 +99,35 @@ static int hid_time_capture_sample(struct hid_sensor_hub_device *hsdev,
 
 	switch (usage_id) {
 	case HID_USAGE_SENSOR_TIME_YEAR:
+		/*
+		 * The draft for HID-sensors (HUTRR39) currently doesn't define
+		 * the range for the year attribute. Therefor we support
+		 * 8 bit (0-99) and 16 or 32 bits (full) as size for the year.
+		 */
 		if (raw_len == 1) {
 			time_buf->tm_year = *(u8 *)raw_data;
 			if (time_buf->tm_year < 70)
 				/* assume we are in 1970...2069 */
 				time_buf->tm_year += 100;
 		} else
-			time_buf->tm_year = *(u16 *)raw_data-1900;
+			time_buf->tm_year =
+				(int)hid_time_value(raw_len, raw_data)-1900;
 		break;
 	case HID_USAGE_SENSOR_TIME_MONTH:
-		/* sensor sending the month as 1-12, we need 0-11 */
-		time_buf->tm_mon = *(u8 *)raw_data-1;
+		/* sensors are sending the month as 1-12, we need 0-11 */
+		time_buf->tm_mon = (int)hid_time_value(raw_len, raw_data)-1;
 		break;
 	case HID_USAGE_SENSOR_TIME_DAY:
-		time_buf->tm_mday = *(u8 *)raw_data;
+		time_buf->tm_mday = (int)hid_time_value(raw_len, raw_data);
 		break;
 	case HID_USAGE_SENSOR_TIME_HOUR:
-		time_buf->tm_hour = *(u8 *)raw_data;
+		time_buf->tm_hour = (int)hid_time_value(raw_len, raw_data);
 		break;
 	case HID_USAGE_SENSOR_TIME_MINUTE:
-		time_buf->tm_min = *(u8 *)raw_data;
+		time_buf->tm_min = (int)hid_time_value(raw_len, raw_data);
 		break;
 	case HID_USAGE_SENSOR_TIME_SECOND:
-		time_buf->tm_sec = *(u8 *)raw_data;
+		time_buf->tm_sec = (int)hid_time_value(raw_len, raw_data);
 		break;
 	default:
 		return -EINVAL;
@@ -153,28 +173,13 @@ static int hid_time_parse_report(struct platform_device *pdev,
 				"not all needed attributes inside the same report!\n");
 			return -EINVAL;
 		}
-		if (time_state->info[i].size != 1) {
-			/*
-			 * The draft for HID-sensors (HUTRR39) currently
-			 * doesn't define the range for the year attribute.
-			 * Therefor we support both 8 bit (0-99) and 16 bit
-			 * (full) as size for the year.
-			 */
-			if (time_state->info[i].attrib_id !=
-				HID_USAGE_SENSOR_TIME_YEAR) {
-				dev_err(&pdev->dev,
-					"attribute '%s' not 8 bits wide!\n",
-				hid_time_attrib_name(
-					time_state->info[i].attrib_id));
-				return -EINVAL;
-			}
-			if (time_state->info[i].size != 2) {
-				dev_err(&pdev->dev,
-					"attribute '%s' not 8 or 16 bits wide!\n",
+		if (time_state->info[i].size == 3 ||
+				time_state->info[i].size > 4) {
+			dev_err(&pdev->dev,
+				"attribute '%s' not 8, 16 or 32 bits wide!\n",
 				hid_time_attrib_name(
 					time_state->info[i].attrib_id));
-				return -EINVAL;
-			}
+			return -EINVAL;
 		}
 		if (time_state->info[i].units !=
 				HID_USAGE_SENSOR_UNITS_NOT_SPECIFIED &&
-- 
1.8.1.4

