Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3FNQzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:55:47 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50273 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163Ab3FNQzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:55:46 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 8/9] RFC: rtc: hctosys: support rtc_read_timeval() for high precision clocks
Date: Fri, 14 Jun 2013 18:52:11 +0200
Message-Id: <1371228732-5749-9-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
References: <51BA1FF7.4000206@ahsoftware.de>
 <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some RTCs do provide a higher precision than seconds. Add support for them
by trying rtc_read_timeval() before using rtc_read_time() to get the time
in the hctosys mechanism.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 drivers/rtc/class.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 625076b..1cdd506 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -150,16 +150,25 @@ static int rtc_resume(struct device *dev)
 static void hctosys(struct rtc_device *rtc)
 {
 	struct rtc_time now;
-	struct timespec ts = {
-		.tv_nsec = NSEC_PER_SEC >> 1,
-	};
+	struct timespec ts;
+	struct timeval tv = { 0, 0 };
 	int rc;
 
-	rc = rtc_read_time(rtc, &now);
-	if (unlikely(rc)) {
-		dev_err(rtc->dev.parent,
-			"rtc core: error reading time from RTC: %d\n", rc);
-		return;
+	rc = rtc_read_timeval(rtc, &tv);
+	if (rc || (!tv.tv_sec && !tv.tv_usec)) {
+		rc = rtc_read_time(rtc, &now);
+		if (unlikely(rc)) {
+			dev_err(rtc->dev.parent,
+				"rtc core: error reading time from RTC: %d\n",
+				rc);
+			return;
+		}
+		rtc_tm_to_time(&now, &ts.tv_sec);
+		ts.tv_nsec = NSEC_PER_SEC >> 1;
+	} else {
+		rtc_time_to_tm(tv.tv_sec, &now);
+		ts.tv_sec = tv.tv_sec;
+		ts.tv_nsec = tv.tv_usec*NSEC_PER_USEC;
 	}
 	rc = rtc_valid_tm(&now);
 	if (unlikely(rc)) {
@@ -167,7 +176,6 @@ static void hctosys(struct rtc_device *rtc)
 			"rtc core: timestamp from RTC is invalid\n");
 		return;
 	}
-	rtc_tm_to_time(&now, &ts.tv_sec);
 	if (systime_was_set)
 		return;
 	rc = do_settimeofday(&ts);
@@ -176,12 +184,17 @@ static void hctosys(struct rtc_device *rtc)
 			"rtc core: error setting system clock: %d\n", rc);
 		return;
 	} else if (systime_was_set) {
+		char usbuf[8];
 		rtc_hctosys_dev_id = rtc->id;
+		if (tv.tv_sec)
+			snprintf(usbuf, sizeof(usbuf), ":%06ld", tv.tv_usec);
+		else
+			*usbuf = 0;
 		dev_info(rtc->dev.parent,
 			"rtc core: setting system clock to "
-			"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+			"%d-%02d-%02d %02d:%02d:%02d%s UTC (%u)\n",
 			now.tm_year + 1900, now.tm_mon + 1, now.tm_mday,
-			now.tm_hour, now.tm_min, now.tm_sec,
+			now.tm_hour, now.tm_min, now.tm_sec, usbuf,
 			(unsigned int) ts.tv_sec);
 	}
 }
-- 
1.8.1.4

