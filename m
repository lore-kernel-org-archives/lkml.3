Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161343Ab3DEK60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:58:26 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:40221 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765997Ab3DEK6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:58:25 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] rtc: rtc-hid-sensor-time: allow full years (16bit) in HID reports
Date: Fri,  5 Apr 2013 12:58:10 +0200
Message-Id: <1365159490-9327-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The draft for HID-sensors (HUTRR39) currently doesn't define the range
for the attribute year. Asking one of the authors revealed that full years
(e.g. 2013 instead of just 13) were meant.

So we now allow both, 8 bit and 16 bit values for the attribute year and
assuming full years when the value is 16 bits wide.

We will still support 8 bit values until the specification gets final
(and maybe defines a way to set the time too).

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/rtc/rtc-hid-sensor-time.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 31c5728..f3ef38a 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -85,10 +85,13 @@ static int hid_time_capture_sample(struct hid_sensor_hub_device *hsdev,
 
 	switch (usage_id) {
 	case HID_USAGE_SENSOR_TIME_YEAR:
-		time_buf->tm_year = *(u8 *)raw_data;
-		if (time_buf->tm_year < 70)
-			/* assume we are in 1970...2069 */
-			time_buf->tm_year += 100;
+		if (raw_len == 1) {
+			time_buf->tm_year = *(u8 *)raw_data;
+			if (time_buf->tm_year < 70)
+				/* assume we are in 1970...2069 */
+				time_buf->tm_year += 100;
+		} else
+			time_buf->tm_year = *(u16 *)raw_data-1900;
 		break;
 	case HID_USAGE_SENSOR_TIME_MONTH:
 		/* sensor sending the month as 1-12, we need 0-11 */
@@ -151,11 +154,27 @@ static int hid_time_parse_report(struct platform_device *pdev,
 			return -EINVAL;
 		}
 		if (time_state->info[i].size != 1) {
-			dev_err(&pdev->dev,
-				"attribute '%s' not 8 bits wide!\n",
+			/*
+			 * The draft for HID-sensors (HUTRR39) currently
+			 * doesn't define the range for the year attribute.
+			 * Therefor we support both 8 bit (0-99) and 16 bit
+			 * (full) as size for the year.
+			 */
+			if (time_state->info[i].attrib_id !=
+				HID_USAGE_SENSOR_TIME_YEAR) {
+				dev_err(&pdev->dev,
+					"attribute '%s' not 8 bits wide!\n",
 				hid_time_attrib_name(
 					time_state->info[i].attrib_id));
-			return -EINVAL;
+				return -EINVAL;
+			}
+			if (time_state->info[i].size != 2) {
+				dev_err(&pdev->dev,
+					"attribute '%s' not 8 or 16 bits wide!\n",
+				hid_time_attrib_name(
+					time_state->info[i].attrib_id));
+				return -EINVAL;
+			}
 		}
 		if (time_state->info[i].units !=
 				HID_USAGE_SENSOR_UNITS_NOT_SPECIFIED &&
-- 
1.8.1.4

