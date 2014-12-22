Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160AbaLVTT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:19:56 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:34045 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111AbaLVTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:19:54 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>
Date: Mon, 22 Dec 2014 19:19:39 +0000
Message-Id: <1419275979-24307-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 2.1.0
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 109.170.219.216
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-Spam-ASN: 
Subject: [PATCH] RTC: Restore alarm after resume
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:54:46 +0000)
X-SA-Exim-Scanned: Yes (on cavan.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platform firmware may interfere with the RTC alarm over suspend,
resulting in the kernel and hardware having different ideas about system state
but also potentially causing problems with firmware that assumes the OS will
clean this case up. This patch saves the RTC alarm state on suspend and will
restore it on resume if the alarm has not yet fired - if it has, it will clear
the RTC alarm.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
Tested-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/rtc/class.c | 24 ++++++++++++++++++++++++
 include/linux/rtc.h |  4 ++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 472a5ad..c7e09e2 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -55,6 +55,8 @@ static int rtc_suspend(struct device *dev)
 	struct timespec64	delta, delta_delta;
 	int err;
 
+	rtc->valid_alarm = !rtc_read_alarm(rtc, &rtc->alarm);
+
 	if (has_persistent_clock())
 		return 0;
 
@@ -102,6 +104,27 @@ static int rtc_resume(struct device *dev)
 	struct timespec64	sleep_time;
 	int err;
 
+	/*
+	 * Ensure that the platform hasn't overwritten a pending alarm while
+	 * suspended
+	 */
+	if (rtc->valid_alarm) {
+		long now, scheduled;
+
+		rtc_read_time(rtc, &tm);
+		rtc_tm_to_time(&rtc->alarm.time, &scheduled);
+		rtc_tm_to_time(&tm, &now);
+
+		/* Clear the alarm registers if it went off during suspend */
+		if (scheduled <= now) {
+			rtc_time_to_tm(0, &rtc->alarm.time);
+			rtc->alarm.enabled = 0;
+		}
+
+		if (rtc->ops && rtc->ops->set_alarm)
+			rtc->ops->set_alarm(rtc->dev.parent, &rtc->alarm);
+	}
+
 	if (has_persistent_clock())
 		return 0;
 
@@ -145,6 +168,7 @@ static int rtc_resume(struct device *dev)
 	if (sleep_time.tv_sec >= 0)
 		timekeeping_inject_sleeptime64(&sleep_time);
 	rtc_hctosys_ret = 0;
+
 	return 0;
 }
 
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 6d6be09..bc805ff 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -133,6 +133,10 @@ struct rtc_device
 	/* Some hardware can't support UIE mode */
 	int uie_unsupported;
 
+#ifdef CONFIG_PM_SLEEP
+	struct rtc_wkalrm alarm;
+	bool valid_alarm;
+#endif
 #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
 	struct work_struct uie_task;
 	struct timer_list uie_timer;
-- 
2.1.0

