Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaHTLsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:48:30 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59051 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ales Novak <alnovak@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 104/104] drivers/rtc/interface.c: fix infinite loop in initializing the alarm
Date: Wed, 20 Aug 2014 13:44:07 +0200
Message-Id: <c07d9e5da83f1470ccc58d37fe222dab36dbca67.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ales Novak <alnovak@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ee1d90146815fdc8d653c558b327fff2acba041d upstream.

In __rtc_read_alarm(), if the alarm time retrieved by
rtc_read_alarm_internal() from the device contains invalid values (e.g.
month=2,mday=31) and the year not set (=-1), the initialization will
loop infinitely because the year-fixing loop expects the time being
invalid due to leap year.

Fix reduces the loop to the leap years and adds final validity check.

Signed-off-by: Ales Novak <alnovak@suse.cz>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Reported-by: Jiri Bohac <jbohac@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/rtc/interface.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 72c5cdbe0791..ff20d90ea8e7 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -290,7 +290,8 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "year");
 		do {
 			alarm->time.tm_year++;
-		} while (rtc_valid_tm(&alarm->time) != 0);
+		} while (!is_leap_year(alarm->time.tm_year + 1900)
+			&& rtc_valid_tm(&alarm->time) != 0);
 		break;
 
 	default:
@@ -298,7 +299,16 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
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
2.0.4

