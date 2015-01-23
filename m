Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbbAWSDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:03:55 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:46276 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbbAWSDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:03:47 -0500
From: Daniel Church <dchurch@andplus.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Daniel Church <dchurch@andplus.com>
Subject: [PATCH 1/2] posix-timers: Prevents overrun counter overflow
Date: Fri, 23 Jan 2015 13:03:30 -0500
Message-Id: <1422036211-10934-2-git-send-email-dchurch@andplus.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422036211-10934-1-git-send-email-dchurch@andplus.com>
References: <1422036211-10934-1-git-send-email-dchurch@andplus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a timer overruns too many times before a call to timer_getoverrun the
overrun count can overflow and go negative.  Adds delaytimer_max value
to cap overrun count and prevent overflow.

Signed-off-by: Daniel Church <dchurch@andplus.com>
---
 include/linux/posix-timers.h |  3 +++
 kernel/time/posix-timers.c   | 42 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 37 insertions(+), 8 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 907f3fd..dc8a1e7 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -138,4 +138,7 @@ long clock_nanosleep_restart(struct restart_block *restart_block);
 
 void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new);
 
+#define DELAYTIMER_MAX_DEFAULT 1000000
+extern int delaytimer_max;
+
 #endif
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 31ea01f..bdf0c0f 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -68,6 +68,8 @@ static struct kmem_cache *posix_timers_cache;
 static DEFINE_HASHTABLE(posix_timers_hashtable, 9);
 static DEFINE_SPINLOCK(hash_lock);
 
+int delaytimer_max = DELAYTIMER_MAX_DEFAULT;
+
 /*
  * we assume that the new SIGEV_THREAD_ID shares no bits with the other
  * SIGEV values.  Here we put out an error if this assumption fails.
@@ -350,14 +352,22 @@ __initcall(init_posix_timers);
 
 static void schedule_next_timer(struct k_itimer *timr)
 {
+	unsigned int overruns;
 	struct hrtimer *timer = &timr->it.real.timer;
 
 	if (timr->it.real.interval.tv64 == 0)
 		return;
 
-	timr->it_overrun += (unsigned int) hrtimer_forward(timer,
-						timer->base->get_time(),
-						timr->it.real.interval);
+	overruns = (unsigned int) hrtimer_forward(timer,
+					timer->base->get_time(),
+					timr->it.real.interval);
+	if (overruns >= delaytimer_max ||
+		(timr->it_overrun >= 0 &&
+		 timr->it_overrun >= delaytimer_max - overruns)) {
+		timr->it_overrun = delaytimer_max;
+	} else {
+		timr->it_overrun += overruns;
+	}
 
 	timr->it_overrun_last = timr->it_overrun;
 	timr->it_overrun = -1;
@@ -436,6 +446,7 @@ static enum hrtimer_restart posix_timer_fn(struct hrtimer *timer)
 {
 	struct k_itimer *timr;
 	unsigned long flags;
+	unsigned int overruns;
 	int si_private = 0;
 	enum hrtimer_restart ret = HRTIMER_NORESTART;
 
@@ -484,9 +495,15 @@ static enum hrtimer_restart posix_timer_fn(struct hrtimer *timer)
 					now = ktime_add(now, kj);
 			}
 #endif
-			timr->it_overrun += (unsigned int)
-				hrtimer_forward(timer, now,
-						timr->it.real.interval);
+			overruns = (unsigned int) hrtimer_forward(timer, now,
+								 timr->it.real.interval);
+			if (overruns >= delaytimer_max ||
+				(timr->it_overrun >= 0 &&
+				 timr->it_overrun >= delaytimer_max - overruns)) {
+				timr->it_overrun = delaytimer_max;
+			} else {
+				timr->it_overrun += overruns;
+			}
 			ret = HRTIMER_RESTART;
 			++timr->it_requeue_pending;
 		}
@@ -729,6 +746,7 @@ static void
 common_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
 {
 	ktime_t now, remaining, iv;
+	unsigned int overruns;
 	struct hrtimer *timer = &timr->it.real.timer;
 
 	memset(cur_setting, 0, sizeof(struct itimerspec));
@@ -750,8 +768,16 @@ common_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
 	 * expiry is > now.
 	 */
 	if (iv.tv64 && (timr->it_requeue_pending & REQUEUE_PENDING ||
-	    (timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE))
-		timr->it_overrun += (unsigned int) hrtimer_forward(timer, now, iv);
+	    (timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE)) {
+		overruns = (unsigned int) hrtimer_forward(timer, now, iv);
+		if (overruns >= delaytimer_max ||
+			(timr->it_overrun >= 0 &&
+			 timr->it_overrun >= delaytimer_max - overruns)) {
+			timr->it_overrun = delaytimer_max;
+		} else {
+			timr->it_overrun += overruns;
+		}
+	}
 
 	remaining = ktime_sub(hrtimer_get_expires(timer), now);
 	/* Return 0 only, when the timer is expired and not pending */
-- 
1.9.1

