Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbbATMpv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:45:51 -0500
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:42423 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752848AbbATMpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:45:50 -0500
Authentication-Results: smtpcorp1m.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: tglx@linutronix.de, linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, viresh.kumar@linaro.org, fweisbec@gmail.com,
        mingo@kernel.org, cl@linux.com, stuart.w.hayes@gmail.com
Subject: [PATCH v3] hrtimers: calculate expires_next after all timers are executed
Date: Tue, 20 Jan 2015 15:45:25 +0300
Message-Id: <1421757925-3533-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

There was a problem awhile ago regarding hrtimer interrupt missing tick
reprogramming: https://lkml.org/lkml/2014/3/17/323

This is the last version of the patch rebased on top of 3.19-rc5 and
lightly tested. Could you please apply it?

---

I think I'm hitting particularly subtle issue with NOHZ_IDLE kernel.

The sequence is as follows:
- CPU enters idle, we disable tick
- hrtimer interrupt fires (for hrtimer_wakeup)
- for clock base #1 (REALTIME) we wake up SCHED_RT thread and
  start RT period timer (from start_rt_bandwidth) for clock base #0
(MONOTONIC)
- because we already checked expiry time for clock base #0
  we end up programming wrong wake up time (minutes, from
tick_sched_timer)
- then, we exit idle loop and restart tick;
  but because tick_sched_timer is not leftmost (the leftmost one
  is RT period timer) we don't program it

So in the end, there is working CPU without tick interrupt enabled.
This eventually leads to RCU stall on that CPU: rcu_gp_kthread
is not woken up because there is no tick.

This fix runs expired timers first and only then tries to find
next expiry time for all clocks.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 include/linux/hrtimer.h |   2 +
 kernel/time/hrtimer.c   | 162 ++++++++++++++++++++++++++----------------------
 2 files changed, 90 insertions(+), 74 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index a036d058a249..f23ee6edd2e7 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -141,6 +141,7 @@ struct hrtimer_sleeper {
  * @get_time:		function to retrieve the current time of the clock
  * @softirq_time:	the time when running the hrtimer queue in the softirq
  * @offset:		offset of this clock to the monotonic base
+ * @expires_next:	absolute time of the next event on this clock base
  */
 struct hrtimer_clock_base {
 	struct hrtimer_cpu_base	*cpu_base;
@@ -151,6 +152,7 @@ struct hrtimer_clock_base {
 	ktime_t			(*get_time)(void);
 	ktime_t			softirq_time;
 	ktime_t			offset;
+	ktime_t			expires_next;
 };
 
 enum  hrtimer_base_type {
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 37e50aadd471..63247b2ac72b 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -440,6 +440,36 @@ static inline void debug_deactivate(struct hrtimer *timer)
 	trace_hrtimer_cancel(timer);
 }
 
+/*
+ * Find the next expiring timer and return the expiry in absolute
+ * CLOCK_MONOTONIC time.
+ */
+static ktime_t hrtimer_get_expires_next(struct hrtimer_cpu_base *cpu_base)
+{
+	int i;
+	ktime_t expires, expires_next = { .tv64 = KTIME_MAX };
+	struct hrtimer_clock_base *base;
+
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+		if (!(cpu_base->active_bases & (1 << i)))
+			continue;
+
+		base = cpu_base->clock_base + i;
+		/* Adjust to CLOCK_MONOTONIC */
+		expires = ktime_sub(base->expires_next, base->offset);
+
+		if (expires.tv64 < expires_next.tv64)
+			expires_next = expires;
+	}
+	/*
+	 * If clock_was_set() has changed base->offset the result
+	 * might be negative. Fix it up to prevent a false positive in
+	 * clockevents_program_event()
+	 */
+	expires.tv64 = 0;
+	return expires_next.tv64 < 0 ? expires : expires_next;
+}
+
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
@@ -488,32 +518,7 @@ static inline int hrtimer_hres_active(void)
 static void
 hrtimer_force_reprogram(struct hrtimer_cpu_base *cpu_base, int skip_equal)
 {
-	int i;
-	struct hrtimer_clock_base *base = cpu_base->clock_base;
-	ktime_t expires, expires_next;
-
-	expires_next.tv64 = KTIME_MAX;
-
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
-		struct hrtimer *timer;
-		struct timerqueue_node *next;
-
-		next = timerqueue_getnext(&base->active);
-		if (!next)
-			continue;
-		timer = container_of(next, struct hrtimer, node);
-
-		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
-		/*
-		 * clock_was_set() has changed base->offset so the
-		 * result might be negative. Fix it up to prevent a
-		 * false positive in clockevents_program_event()
-		 */
-		if (expires.tv64 < 0)
-			expires.tv64 = 0;
-		if (expires.tv64 < expires_next.tv64)
-			expires_next = expires;
-	}
+	ktime_t expires_next = hrtimer_get_expires_next(cpu_base);
 
 	if (skip_equal && expires_next.tv64 == cpu_base->expires_next.tv64)
 		return;
@@ -830,6 +835,8 @@ EXPORT_SYMBOL_GPL(hrtimer_forward);
 static int enqueue_hrtimer(struct hrtimer *timer,
 			   struct hrtimer_clock_base *base)
 {
+	int leftmost;
+
 	debug_activate(timer);
 
 	timerqueue_add(&base->active, &timer->node);
@@ -841,7 +848,13 @@ static int enqueue_hrtimer(struct hrtimer *timer,
 	 */
 	timer->state |= HRTIMER_STATE_ENQUEUED;
 
-	return (&timer->node == base->active.next);
+	leftmost = &timer->node == base->active.next;
+	/*
+	 * If the new timer is the leftmost, update clock_base->expires_next.
+	 */
+	if (leftmost)
+		base->expires_next = hrtimer_get_expires(timer);
+	return leftmost;
 }
 
 /*
@@ -858,27 +871,45 @@ static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
 			     unsigned long newstate, int reprogram)
 {
-	struct timerqueue_node *next_timer;
+	struct timerqueue_node *next;
+	struct hrtimer *next_timer;
+	bool first;
+
 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
 		goto out;
 
-	next_timer = timerqueue_getnext(&base->active);
+	/*
+	 * If this is not the first timer of the clock base, we just
+	 * remove it. No updates, no reprogramming.
+	 */
+	first = timerqueue_getnext(&base->active) == &timer->node;
 	timerqueue_del(&base->active, &timer->node);
-	if (&timer->node == next_timer) {
+	if (!first)
+		goto out;
+
+	/*
+	 * Update cpu base and clock base. This needs to be done
+	 * before calling into hrtimer_force_reprogram() as that
+	 * relies on active_bases and expires_next.
+	 */
+	next = timerqueue_getnext(&base->active);
+	if (!next) {
+		base->cpu_base->active_bases &= ~(1 << base->index);
+		base->expires_next.tv64 = KTIME_MAX;
+	} else {
+		next_timer = container_of(next, struct hrtimer, node);
+		base->expires_next = hrtimer_get_expires(next_timer);
+	}
+
 #ifdef CONFIG_HIGH_RES_TIMERS
-		/* Reprogram the clock event device. if enabled */
-		if (reprogram && hrtimer_hres_active()) {
-			ktime_t expires;
-
-			expires = ktime_sub(hrtimer_get_expires(timer),
-					    base->offset);
-			if (base->cpu_base->expires_next.tv64 == expires.tv64)
-				hrtimer_force_reprogram(base->cpu_base, 1);
-		}
-#endif
+	if (reprogram && hrtimer_hres_active()) {
+		ktime_t expires;
+
+		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+		if (base->cpu_base->expires_next.tv64 == expires.tv64)
+			hrtimer_force_reprogram(base->cpu_base, 1);
 	}
-	if (!timerqueue_getnext(&base->active))
-		base->cpu_base->active_bases &= ~(1 << base->index);
+#endif
 out:
 	timer->state = newstate;
 }
@@ -1104,35 +1135,21 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining);
 ktime_t hrtimer_get_next_event(void)
 {
 	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
-	struct hrtimer_clock_base *base = cpu_base->clock_base;
-	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
+	ktime_t next, delta = { .tv64 = KTIME_MAX };
 	unsigned long flags;
-	int i;
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
 	if (!hrtimer_hres_active()) {
-		for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
-			struct hrtimer *timer;
-			struct timerqueue_node *next;
-
-			next = timerqueue_getnext(&base->active);
-			if (!next)
-				continue;
-
-			timer = container_of(next, struct hrtimer, node);
-			delta.tv64 = hrtimer_get_expires_tv64(timer);
-			delta = ktime_sub(delta, base->get_time());
-			if (delta.tv64 < mindelta.tv64)
-				mindelta.tv64 = delta.tv64;
-		}
+		next = hrtimer_get_expires_next(cpu_base);
+		delta = ktime_sub(next, ktime_get());
+		if (delta.tv64 < 0)
+			delta.tv64 = 0;
 	}
 
 	raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
 
-	if (mindelta.tv64 < 0)
-		mindelta.tv64 = 0;
-	return mindelta;
+	return delta;
 }
 #endif
 
@@ -1242,6 +1259,7 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
  */
 void hrtimer_interrupt(struct clock_event_device *dev)
 {
+	struct hrtimer_clock_base *base;
 	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
 	ktime_t expires_next, now, entry_time, delta;
 	int i, retries = 0;
@@ -1253,7 +1271,6 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	raw_spin_lock(&cpu_base->lock);
 	entry_time = now = hrtimer_update_base(cpu_base);
 retry:
-	expires_next.tv64 = KTIME_MAX;
 	/*
 	 * We set expires_next to KTIME_MAX here with cpu_base->lock
 	 * held to prevent that a timer is enqueued in our queue via
@@ -1264,7 +1281,6 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	cpu_base->expires_next.tv64 = KTIME_MAX;
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
-		struct hrtimer_clock_base *base;
 		struct timerqueue_node *node;
 		ktime_t basenow;
 
@@ -1292,23 +1308,20 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 			 * timer will have to trigger a wakeup anyway.
 			 */
 
-			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer)) {
-				ktime_t expires;
-
-				expires = ktime_sub(hrtimer_get_expires(timer),
-						    base->offset);
-				if (expires.tv64 < 0)
-					expires.tv64 = KTIME_MAX;
-				if (expires.tv64 < expires_next.tv64)
-					expires_next = expires;
+			if (basenow.tv64 < hrtimer_get_softexpires_tv64(timer))
 				break;
-			}
 
 			__run_hrtimer(timer, &basenow);
 		}
 	}
 
 	/*
+	 * We might have dropped cpu_base->lock and the callbacks
+	 * might have added timers. Find the timer which expires first.
+	 */
+	expires_next = hrtimer_get_expires_next(cpu_base);
+
+	/*
 	 * Store the new expiry value so the migration code can verify
 	 * against it.
 	 */
@@ -1628,6 +1641,7 @@ static void init_hrtimers_cpu(int cpu)
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		cpu_base->clock_base[i].cpu_base = cpu_base;
 		timerqueue_init_head(&cpu_base->clock_base[i].active);
+		cpu_base->clock_base[i].expires_next.tv64 = KTIME_MAX;
 	}
 
 	cpu_base->cpu = cpu;
-- 
2.1.0

