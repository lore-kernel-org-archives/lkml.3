Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947384Ab3BHXl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 18:41:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947302Ab3BHXl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 18:41:26 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time, Fix setting of hardware clock in NTP code
Date: Fri,  8 Feb 2013 17:59:53 -0500
Message-Id: <1360364393-17595-1-git-send-email-prarit@redhat.com>
In-Reply-To: <CANcMJZAzT-fCXY2P0ZRjdMoXq+dNd3rrq3eNY18pgob-hS6L9g@mail.gmail.com>
References: <CANcMJZAzT-fCXY2P0ZRjdMoXq+dNd3rrq3eNY18pgob-hS6L9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At init time, if the system time is "warped" forward in warp_clock()
it will differ from the hardware clock by sys_tz.tz_minuteswest.  This time
difference is not taken into account when ntp updates the hardware clock,
and this causes the system time to jump forward by this offset every reboot.

The kernel must take this offset into account when writing the system time
to the hardware clock in the ntp code.  This patch adds
persistent_clock_is_local which indicates that an offset has been applied
in warp_clock() and accounts for the "warp" before writing the hardware
clock.

x86 does not have this problem as rtc writes are software limited to a
+/-15 minute window relative to the current rtc time.  Other arches, such
as powerpc, however do a full synchronization of the system time to the
rtc and will see this problem.

[v2]: generated against tip/timers/core

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/time.h | 1 +
 kernel/time.c        | 8 ++++++++
 kernel/time/ntp.c    | 8 ++++++--
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 476e1d7..a3ab6a8 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -128,6 +128,7 @@ static inline bool has_persistent_clock(void)
 
 extern void read_persistent_clock(struct timespec *ts);
 extern void read_boot_clock(struct timespec *ts);
+extern int persistent_clock_is_local;
 extern int update_persistent_clock(struct timespec now);
 void timekeeping_init(void);
 extern int timekeeping_suspended;
diff --git a/kernel/time.c b/kernel/time.c
index d226c6a..c2a27dd 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -115,6 +115,12 @@ SYSCALL_DEFINE2(gettimeofday, struct timeval __user *, tv,
 }
 
 /*
+ * Indicates if there is an offset between the system clock and the hardware
+ * clock/persistent clock/rtc.
+ */
+int persistent_clock_is_local;
+
+/*
  * Adjust the time obtained from the CMOS to be UTC time instead of
  * local time.
  *
@@ -135,6 +141,8 @@ static inline void warp_clock(void)
 	struct timespec adjust;
 
 	adjust = current_kernel_time();
+	if (sys_tz.tz_minuteswest != 0)
+		persistent_clock_is_local = 1;
 	adjust.tv_sec += sys_tz.tz_minuteswest * 60;
 	do_settimeofday(&adjust);
 }
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 313b161..b10a42b 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -511,13 +511,17 @@ static void sync_cmos_clock(struct work_struct *work)
 
 	getnstimeofday(&now);
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2) {
+		struct timespec adjust = now;
+
 		fail = -ENODEV;
+		if (persistent_clock_is_local)
+			adjust.tv_sec -= (sys_tz.tz_minuteswest * 60);
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
-		fail = update_persistent_clock(now);
+		fail = update_persistent_clock(adjust);
 #endif
 #ifdef CONFIG_RTC_SYSTOHC
 		if (fail == -ENODEV)
-			fail = rtc_set_ntp_time(now);
+			fail = rtc_set_ntp_time(adjust);
 #endif
 	}
 
-- 
1.8.1.2

