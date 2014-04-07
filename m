Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbaDGWyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 18:54:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbaDGWyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 18:54:49 -0400
From: Ales Novak <alnovak@suse.cz>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, John Stultz <john.stultz@linaro.org>,
        Ales Novak <alnovak@suse.cz>
Subject: [PATCH] RTC: Fix infinite loop in initializing the alarm.
Date: Tue,  8 Apr 2014 00:54:42 +0200
Message-Id: <1396911282-4410-1-git-send-email-alnovak@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __rtc_read_alarm(), if the alarm time retrieved by
rtc_read_alarm_internal() from the device contains invalid values
(e.g. month=2,mday=31) and the year not set (=-1), the initialization
will loop infinitely because the year-fixing loop expects the
time being invalid due to leap year.

Fix reduces the loop to the leap years and adds final validity check.

Signed-off-by: Ales Novak <alnovak@suse.cz>
---
 drivers/rtc/interface.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 544be72..a2df283 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -292,7 +292,9 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
 		do {
 			alarm->time.tm_year++;
-		} while (rtc_valid_tm(&alarm->time) != 0);
+		} while (alarm->time.tm_mon == 1
+			&& is_leap_year(alarm->time.tm_year + 1900)
+			&& rtc_valid_tm(&alarm->time) != 0);
 		break;
 
 	default:
@@ -300,7 +302,16 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	}
 
 done:
-	return 0;
+	err = rtc_valid_tm(&alarm->time);
+
+	if (err) {
+		dev_warn(&rtc->dev, "invalid alarm value: %d-%d-%d %d:%d:%d\n",
+			alarm->time.tm_year + 1900, alarm->time.tm_mon + 1,
+			alarm->time.tm_mday, alarm->time.tm_hour, alarm->time.tm_min,
+			alarm->time.tm_sec);
+	}
+
+	return err;
 }
 
 int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
-- 
1.8.1.4

