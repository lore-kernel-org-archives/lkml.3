Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab3BUWxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 17:53:41 -0500
Received: from www.linutronix.de ([62.245.132.108]:53417 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3BUWvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 17:51:39 -0500
Message-Id: <20130221224230.895278757@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Feb 2013 22:51:37 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [RFC patch 3/8] timekeeping: Move lock out of timekeeper struct
References: <20130221220147.719832397@linutronix.de>
Content-Disposition: inline;
 filename=timekeeping-move-lock-out-of-timekeeper.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the lock a separate entity. Preparatory patch for shadow
timekeeper structure.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeper_internal.h |    2 
 kernel/time/timekeeping.c           |   96 +++++++++++++++++-------------------
 2 files changed, 47 insertions(+), 51 deletions(-)

Index: linux-2.6/include/linux/timekeeper_internal.h
===================================================================
--- linux-2.6.orig/include/linux/timekeeper_internal.h
+++ linux-2.6/include/linux/timekeeper_internal.h
@@ -62,8 +62,6 @@ struct timekeeper {
 	ktime_t			offs_boot;
 	/* The raw monotonic time for the CLOCK_MONOTONIC_RAW posix clock. */
 	struct timespec		raw_time;
-	/* Seqlock for all timekeeper values */
-	seqlock_t		lock;
 };
 
 static inline struct timespec tk_xtime(struct timekeeper *tk)
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -26,6 +26,7 @@
 #include "tick-internal.h"
 
 static struct timekeeper timekeeper;
+static DEFINE_SEQLOCK(timekeeper_lock);
 
 /* flag for if timekeeping is suspended */
 int __read_mostly timekeeping_suspended;
@@ -197,11 +198,11 @@ int pvclock_gtod_register_notifier(struc
 	unsigned long flags;
 	int ret;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	write_seqlock_irqsave(&timekeeper_lock, flags);
 	ret = raw_notifier_chain_register(&pvclock_gtod_chain, nb);
 	/* update timekeeping data */
 	update_pvclock_gtod(tk);
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_sequnlock_irqrestore(&timekeeper_lock, flags);
 
 	return ret;
 }
@@ -215,13 +216,12 @@ EXPORT_SYMBOL_GPL(pvclock_gtod_register_
  */
 int pvclock_gtod_unregister_notifier(struct notifier_block *nb)
 {
-	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
 	int ret;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	write_seqlock_irqsave(&timekeeper_lock, flags);
 	ret = raw_notifier_chain_unregister(&pvclock_gtod_chain, nb);
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_sequnlock_irqrestore(&timekeeper_lock, flags);
 
 	return ret;
 }
@@ -281,12 +281,12 @@ int __getnstimeofday(struct timespec *ts
 	s64 nsecs = 0;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 
 		ts->tv_sec = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsecs);
@@ -322,11 +322,11 @@ ktime_t ktime_get(void)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 		secs = tk->xtime_sec + tk->wall_to_monotonic.tv_sec;
 		nsecs = timekeeping_get_ns(tk) + tk->wall_to_monotonic.tv_nsec;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.
@@ -353,12 +353,12 @@ void ktime_get_ts(struct timespec *ts)
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	ts->tv_sec += tomono.tv_sec;
 	ts->tv_nsec = 0;
@@ -386,7 +386,7 @@ void getnstime_raw_and_real(struct times
 	WARN_ON_ONCE(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 
 		*ts_raw = tk->raw_time;
 		ts_real->tv_sec = tk->xtime_sec;
@@ -395,7 +395,7 @@ void getnstime_raw_and_real(struct times
 		nsecs_raw = timekeeping_get_ns_raw(tk);
 		nsecs_real = timekeeping_get_ns(tk);
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
 	timespec_add_ns(ts_real, nsecs_real);
@@ -435,7 +435,7 @@ int do_settimeofday(const struct timespe
 	if (!timespec_valid_strict(tv))
 		return -EINVAL;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	write_seqlock_irqsave(&timekeeper_lock, flags);
 
 	timekeeping_forward_now(tk);
 
@@ -449,7 +449,7 @@ int do_settimeofday(const struct timespe
 
 	timekeeping_update(tk, true);
 
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_sequnlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -474,7 +474,7 @@ int timekeeping_inject_offset(struct tim
 	if ((unsigned long)ts->tv_nsec >= NSEC_PER_SEC)
 		return -EINVAL;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	write_seqlock_irqsave(&timekeeper_lock, flags);
 
 	timekeeping_forward_now(tk);
 
@@ -491,7 +491,7 @@ int timekeeping_inject_offset(struct tim
 error: /* even if we error out, we forwarded the time, so call update */
 	timekeeping_update(tk, true);
 
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_sequnlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -513,7 +513,7 @@ static int change_clocksource(void *data
 
 	new = (struct clocksource *) data;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	write_seqlock_irqsave(&timekeeper_lock, flags);
 
 	timekeeping_forward_now(tk);
 	if (!new->enable || new->enable(new) == 0) {
@@ -524,7 +524,7 @@ static int change_clocksource(void *data
 	}
 	timekeeping_update(tk, true);
 
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_sequnlock_irqrestore(&timekeeper_lock, flags);
 
 	return 0;
 }
@@ -574,11 +574,11 @@ void getrawmonotonic(struct timespec *ts
 	s64 nsecs;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 		nsecs = timekeeping_get_ns_raw(tk);
 		*ts = tk->raw_time;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	timespec_add_ns(ts, nsecs);
 }
@@ -594,11 +594,11 @@ int timekeeping_valid_for_hres(void)
 	int ret;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 
 		ret = tk->clock->flags & CLOCK_SOURCE_VALID_FOR_HRES;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	return ret;
 }
@@ -613,11 +613,11 @@ u64 timekeeping_max_deferment(void)
 	u64 ret;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 
 		ret = tk->clock->max_idle_ns;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	return ret;
 }
@@ -680,11 +680,9 @@ void __init timekeeping_init(void)
 		boot.tv_nsec = 0;
 	}
 
-	seqlock_init(&tk->lock);
-
 	ntp_init();
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	write_seqlock_irqsave(&timekeeper_lock, flags);
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
@@ -703,7 +701,7 @@ void __init timekeeping_init(void)
 	tmp.tv_nsec = 0;
 	tk_set_sleep_time(tk, tmp);
 
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_sequnlock_irqrestore(&timekeeper_lock, flags);
 }
 
 /* time in seconds when suspend began */
@@ -751,7 +749,7 @@ void timekeeping_inject_sleeptime(struct
 	if (has_persistent_clock())
 		return;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	write_seqlock_irqsave(&timekeeper_lock, flags);
 
 	timekeeping_forward_now(tk);
 
@@ -759,7 +757,7 @@ void timekeeping_inject_sleeptime(struct
 
 	timekeeping_update(tk, true);
 
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_sequnlock_irqrestore(&timekeeper_lock, flags);
 
 	/* signal hrtimers about time change */
 	clock_was_set();
@@ -783,7 +781,7 @@ static void timekeeping_resume(void)
 	clockevents_resume();
 	clocksource_resume();
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	write_seqlock_irqsave(&timekeeper_lock, flags);
 
 	if (timespec_compare(&ts, &timekeeping_suspend_time) > 0) {
 		ts = timespec_sub(ts, timekeeping_suspend_time);
@@ -794,7 +792,7 @@ static void timekeeping_resume(void)
 	tk->ntp_error = 0;
 	timekeeping_suspended = 0;
 	timekeeping_update(tk, false);
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_sequnlock_irqrestore(&timekeeper_lock, flags);
 
 	touch_softlockup_watchdog();
 
@@ -813,7 +811,7 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	write_seqlock_irqsave(&timekeeper_lock, flags);
 	timekeeping_forward_now(tk);
 	timekeeping_suspended = 1;
 
@@ -836,7 +834,7 @@ static int timekeeping_suspend(void)
 		timekeeping_suspend_time =
 			timespec_add(timekeeping_suspend_time, delta_delta);
 	}
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_sequnlock_irqrestore(&timekeeper_lock, flags);
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 	clocksource_suspend();
@@ -1174,7 +1172,7 @@ static void update_wall_time(void)
 	int shift = 0, maxshift;
 	unsigned long flags;
 
-	write_seqlock_irqsave(&tk->lock, flags);
+	write_seqlock_irqsave(&timekeeper_lock, flags);
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -1229,7 +1227,7 @@ static void update_wall_time(void)
 	timekeeping_update(tk, false);
 
 out:
-	write_sequnlock_irqrestore(&tk->lock, flags);
+	write_sequnlock_irqrestore(&timekeeper_lock, flags);
 
 }
 
@@ -1277,13 +1275,13 @@ void get_monotonic_boottime(struct times
 	WARN_ON(timekeeping_suspended);
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 		ts->tv_sec = tk->xtime_sec;
 		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 		sleep = tk->total_sleep_time;
 
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	ts->tv_sec += tomono.tv_sec + sleep.tv_sec;
 	ts->tv_nsec = 0;
@@ -1342,10 +1340,10 @@ struct timespec current_kernel_time(void
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 
 		now = tk_xtime(tk);
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	return now;
 }
@@ -1358,11 +1356,11 @@ struct timespec get_monotonic_coarse(voi
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 
 		now = tk_xtime(tk);
 		mono = tk->wall_to_monotonic;
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	set_normalized_timespec(&now, now.tv_sec + mono.tv_sec,
 				now.tv_nsec + mono.tv_nsec);
@@ -1393,11 +1391,11 @@ void get_xtime_and_monotonic_and_sleep_o
 	unsigned long seq;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 		*xtim = tk_xtime(tk);
 		*wtom = tk->wall_to_monotonic;
 		*sleep = tk->total_sleep_time;
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 }
 
 #ifdef CONFIG_HIGH_RES_TIMERS
@@ -1417,14 +1415,14 @@ ktime_t ktime_get_update_offsets(ktime_t
 	u64 secs, nsecs;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 
 		secs = tk->xtime_sec;
 		nsecs = timekeeping_get_ns(tk);
 
 		*offs_real = tk->offs_real;
 		*offs_boot = tk->offs_boot;
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	now = ktime_add_ns(ktime_set(secs, 0), nsecs);
 	now = ktime_sub(now, *offs_real);
@@ -1442,9 +1440,9 @@ ktime_t ktime_get_monotonic_offset(void)
 	struct timespec wtom;
 
 	do {
-		seq = read_seqbegin(&tk->lock);
+		seq = read_seqbegin(&timekeeper_lock);
 		wtom = tk->wall_to_monotonic;
-	} while (read_seqretry(&tk->lock, seq));
+	} while (read_seqretry(&timekeeper_lock, seq));
 
 	return timespec_to_ktime(wtom);
 }


