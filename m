Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbbAVCdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:33:20 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:55866 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbbAVCcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:32:09 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH 5/5] rtc: Convert rtc_set_ntp_time() to use timespec64
Date: Thu, 22 Jan 2015 02:31:55 +0000
Message-Id: <1421893915-19309-5-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
References: <1421893915-19309-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc_set_ntp_time() uses timespec which is y2038-unsafe,
so modify to use timespec64 which is y2038-safe, then
replace rtc_time_to_tm() with rtc_time64_to_tm().

Also adjust all its call sites(only NTP uses it) accordingly.

Reviewed-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Arnd Bergmann <arnd.bergmann@linaro.org>
Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 drivers/rtc/systohc.c | 6 +++---
 include/linux/rtc.h   | 2 +-
 kernel/time/ntp.c     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/systohc.c b/drivers/rtc/systohc.c
index e34a07b..22bbe2e 100644
--- a/drivers/rtc/systohc.c
+++ b/drivers/rtc/systohc.c
@@ -20,16 +20,16 @@
  *
  * If temporary failure is indicated the caller should try again 'soon'
  */
-int rtc_set_ntp_time(struct timespec now)
+int rtc_set_ntp_time(struct timespec64 now)
 {
 	struct rtc_device *rtc;
 	struct rtc_time tm;
 	int err = -ENODEV;
 
 	if (now.tv_nsec < (NSEC_PER_SEC >> 1))
-		rtc_time_to_tm(now.tv_sec, &tm);
+		rtc_time64_to_tm(now.tv_sec, &tm);
 	else
-		rtc_time_to_tm(now.tv_sec + 1, &tm);
+		rtc_time64_to_tm(now.tv_sec + 1, &tm);
 
 	rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
 	if (rtc) {
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 29093da..8dcf682 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -162,7 +162,7 @@ extern void devm_rtc_device_unregister(struct device *dev,
 extern int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_time(struct rtc_device *rtc, struct rtc_time *tm);
 extern int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs);
-extern int rtc_set_ntp_time(struct timespec now);
+extern int rtc_set_ntp_time(struct timespec64 now);
 int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm);
 extern int rtc_read_alarm(struct rtc_device *rtc,
 			struct rtc_wkalrm *alrm);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 87a346f..183dfe2 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -488,13 +488,13 @@ static void sync_cmos_clock(struct work_struct *work)
 
 	getnstimeofday64(&now);
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec * 5) {
-		struct timespec adjust = timespec64_to_timespec(now);
+		struct timespec64 adjust = now;
 
 		fail = -ENODEV;
 		if (persistent_clock_is_local)
 			adjust.tv_sec -= (sys_tz.tz_minuteswest * 60);
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
-		fail = update_persistent_clock(adjust);
+		fail = update_persistent_clock(timespec64_to_timespec(adjust));
 #endif
 #ifdef CONFIG_RTC_SYSTOHC
 		if (fail == -ENODEV)
-- 
1.9.1

