Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbbAXRt2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 12:49:28 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:43160 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbbAXRtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 12:49:22 -0500
From: Daniel Church <dchurch@andplus.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org,
        Daniel Church <dchurch@andplus.com>
Subject: [PATCH v2 1/2] posix-timers: Prevents overrun counter overflow
Date: Sat, 24 Jan 2015 12:48:56 -0500
Message-Id: <1422121737-3686-2-git-send-email-dchurch@andplus.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422121737-3686-1-git-send-email-dchurch@andplus.com>
References: <[PATCH 0/2] posix-timers: Prevents overrun counter overflow, adds DELAYTIMER_MAX>
 <1422121737-3686-1-git-send-email-dchurch@andplus.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a timer overruns too many times before a call to timer_getoverrun the
overrun count can overflow and go negative.  Adds delaytimer_max value
to cap overrun count and prevent overflow.

Signed-off-by: Daniel Church <dchurch@andplus.com>
---
 include/linux/posix-timers.h |  3 +++
 kernel/time/posix-timers.c   | 45 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 40 insertions(+), 8 deletions(-)

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
index 31ea01f..010344e 100644
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
@@ -202,6 +204,24 @@ static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
 	spin_unlock_irqrestore(&timr->it_lock, flags);
 }
 
+/*
+ * Updates a timer's overrun count while capping it to delaytimer_max
+ */
+static void posix_timer_update_overrun_count(struct k_itimer *timer,
+					     unsigned int overruns)
+{
+	const bool newOverrunsAboveMax = overruns >= delaytimer_max;
+	const bool totalOverrunsAboveMax =
+		timer->it_overrun >= 0 &&
+		timer->it_overrun >= delaytimer_max - overruns;
+
+	if (newOverrunsAboveMax || totalOverrunsAboveMax) {
+		timer->it_overrun = delaytimer_max;
+	} else {
+		timer->it_overrun += overruns;
+	}
+}
+
 /* Get clock_realtime */
 static int posix_clock_realtime_get(clockid_t which_clock, struct timespec *tp)
 {
@@ -350,14 +370,17 @@ __initcall(init_posix_timers);
 
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
+
+	posix_timer_update_overrun_count(timr, overruns);
 
 	timr->it_overrun_last = timr->it_overrun;
 	timr->it_overrun = -1;
@@ -436,6 +459,7 @@ static enum hrtimer_restart posix_timer_fn(struct hrtimer *timer)
 {
 	struct k_itimer *timr;
 	unsigned long flags;
+	unsigned int overruns;
 	int si_private = 0;
 	enum hrtimer_restart ret = HRTIMER_NORESTART;
 
@@ -484,9 +508,10 @@ static enum hrtimer_restart posix_timer_fn(struct hrtimer *timer)
 					now = ktime_add(now, kj);
 			}
 #endif
-			timr->it_overrun += (unsigned int)
-				hrtimer_forward(timer, now,
-						timr->it.real.interval);
+			overruns = (unsigned int) hrtimer_forward(timer, now,
+								 timr->it.real.interval);
+			posix_timer_update_overrun_count(timr, overruns);
+
 			ret = HRTIMER_RESTART;
 			++timr->it_requeue_pending;
 		}
@@ -729,6 +754,7 @@ static void
 common_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
 {
 	ktime_t now, remaining, iv;
+	unsigned int overruns;
 	struct hrtimer *timer = &timr->it.real.timer;
 
 	memset(cur_setting, 0, sizeof(struct itimerspec));
@@ -750,8 +776,10 @@ common_timer_get(struct k_itimer *timr, struct itimerspec *cur_setting)
 	 * expiry is > now.
 	 */
 	if (iv.tv64 && (timr->it_requeue_pending & REQUEUE_PENDING ||
-	    (timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE))
-		timr->it_overrun += (unsigned int) hrtimer_forward(timer, now, iv);
+	    (timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE)) {
+		overruns = (unsigned int) hrtimer_forward(timer, now, iv);
+		posix_timer_update_overrun_count(timr, overruns);
+	}
 
 	remaining = ktime_sub(hrtimer_get_expires(timer), now);
 	/* Return 0 only, when the timer is expired and not pending */
@@ -1122,3 +1150,4 @@ long clock_nanosleep_restart(struct restart_block *restart_block)
 
 	return kc->nsleep_restart(restart_block);
 }
+
-- 
1.9.1

