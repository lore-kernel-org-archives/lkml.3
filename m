Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaF0R11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 13:27:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44123 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbaF0R1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 13:27:23 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, John Whitmore <arigead@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH 1/2][RFC] time: Introduce do_first_settimeofday()
Date: Fri, 27 Jun 2014 10:27:10 -0700
Message-Id: <1403890031-26419-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>
References: <1403890031-26419-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's some cases in the kernel, particuarly with RTC drivers,
where we want to set the time, but only if no one else has
already set it.

This is useful for systems where the RTC driver is a module, and
is loaded late in initialization. However, we want to be sure we
don't override the time that may have been set by userspace.

Cc: John Whitmore <arigead@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/time.h      |  2 ++
 kernel/time/timekeeping.c | 54 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index d5d229b..7379291 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -157,6 +157,8 @@ extern void do_gettimeofday(struct timeval *tv);
 extern int do_settimeofday(const struct timespec *tv);
 extern int do_sys_settimeofday(const struct timespec *tv,
 			       const struct timezone *tz);
+extern int do_first_settimeofday(const struct timespec *ts);
+
 #define do_posix_clock_monotonic_gettime(ts) ktime_get_ts(ts)
 extern long do_utimes(int dfd, const char __user *filename, struct timespec *times, int flags);
 struct itimerval;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 32d8d6a..45c2642 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -487,6 +487,25 @@ void do_gettimeofday(struct timeval *tv)
 }
 EXPORT_SYMBOL(do_gettimeofday);
 
+
+static void __do_settimeofday(struct timekeeper *tk, const struct timespec *tv)
+{
+	struct timespec ts_delta, xt;
+
+	timekeeping_forward_now(tk);
+
+	xt = tk_xtime(tk);
+	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
+	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
+
+	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, ts_delta));
+
+	tk_set_xtime(tk, tv);
+
+	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
+}
+
+
 /**
  * do_settimeofday - Sets the time of day
  * @tv:		pointer to the timespec variable containing the new time
@@ -496,7 +515,6 @@ EXPORT_SYMBOL(do_gettimeofday);
 int do_settimeofday(const struct timespec *tv)
 {
 	struct timekeeper *tk = &timekeeper;
-	struct timespec ts_delta, xt;
 	unsigned long flags;
 
 	if (!timespec_valid_strict(tv))
@@ -505,27 +523,43 @@ int do_settimeofday(const struct timespec *tv)
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 
-	timekeeping_forward_now(tk);
+	__do_settimeofday(tk, tv);
 
-	xt = tk_xtime(tk);
-	ts_delta.tv_sec = tv->tv_sec - xt.tv_sec;
-	ts_delta.tv_nsec = tv->tv_nsec - xt.tv_nsec;
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
-	tk_set_wall_to_mono(tk, timespec_sub(tk->wall_to_monotonic, ts_delta));
+	/* signal hrtimers about time change */
+	clock_was_set();
 
-	tk_set_xtime(tk, tv);
+	return 0;
+}
+EXPORT_SYMBOL(do_settimeofday);
 
-	timekeeping_update(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);
 
+int do_first_settimeofday(const struct timespec *tv)
+{
+	struct timekeeper *tk = &timekeeper;
+	unsigned long flags;
+	int ret = 0;
+
+	if (!timespec_valid_strict(tv))
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
+
+	if (!tk->wall_to_monotonic.tv_sec && !tk->wall_to_monotonic.tv_nsec)
+		__do_settimeofday(tk, tv);
+	else
+		ret = -EACCES;
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
 
-	return 0;
+	return ret;
 }
-EXPORT_SYMBOL(do_settimeofday);
 
 /**
  * timekeeping_inject_offset - Adds or subtracts from the current time.
-- 
1.9.1

