Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbbATXGs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:06:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:51320 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbbATXGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:06:47 -0500
Date: Wed, 21 Jan 2015 00:06:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislav Fomichev <stfomichev@yandex-team.ru>
cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        viresh.kumar@linaro.org, fweisbec@gmail.com, mingo@kernel.org,
        cl@linux.com, stuart.w.hayes@gmail.com
Subject: Re: [PATCH v3] hrtimers: calculate expires_next after all timers
 are executed
In-Reply-To: <1421757925-3533-1-git-send-email-stfomichev@yandex-team.ru>
Message-ID: <alpine.DEB.2.11.1501202049190.5526@nanos>
References: <1421757925-3533-1-git-send-email-stfomichev@yandex-team.ru>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Stanislav Fomichev wrote:
> I think I'm hitting particularly subtle issue with NOHZ_IDLE kernel.
> 
> The sequence is as follows:
> - CPU enters idle, we disable tick
> - hrtimer interrupt fires (for hrtimer_wakeup)
> - for clock base #1 (REALTIME) we wake up SCHED_RT thread and
>   start RT period timer (from start_rt_bandwidth) for clock base #0
> (MONOTONIC)
> - because we already checked expiry time for clock base #0
>   we end up programming wrong wake up time (minutes, from
> tick_sched_timer)
> - then, we exit idle loop and restart tick;
>   but because tick_sched_timer is not leftmost (the leftmost one
>   is RT period timer) we don't program it
> 
> So in the end, there is working CPU without tick interrupt enabled.
> This eventually leads to RCU stall on that CPU: rcu_gp_kthread
> is not woken up because there is no tick.
> 
> This fix runs expired timers first and only then tries to find
> next expiry time for all clocks.

I have a few issues with that patch:

1) The extra storage and conditionals in enqueue()

   Why do we need the extra clock base storage for the expiry per
   clock base if we evaluate all clockbases anyway?

   Getting it from the timerqueue is not that much slower than reading
   it from clock_base especially as we have to take the offset into
   account in any case.

2) We have another problem in that code:
 
   We hold off timer migration by setting cpu_base->expires_next to
   KTIME_MAX while we are in hrtimer_interrupt(). Aside of that we
   really want to avoid touching the hardware while we are running
   hrtimer_interrupt() simply becasue hrtimer_interrupt() is going to
   repogramm the hardware anyway.

   Now if a timer gets armed from a callback, like in the case you
   describe above we end up changing cpu_base->expires_next and
   programming the hardware, which of course gets overwritten at the
   end of hrtimer_interrupt().

   So that's inconsistent behaviour and just works by chance. With
   your patch applied we paper over this issue, but we really want to
   solve it proper.

   We could allow that behaviour with the explicit reevaluation of the
   next expiry time, but if we decide to do so then this wants to be
   documented and a seperate patch.

Does the patch below fix your problem as well?

Thanks,

	tglx

----------------->

Subject: hrtimer: Prevent stale expiry time in hrtimer_interrupt()
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 20 Jan 2015 21:24:10 +0100

hrtimer_interrupt() has the following subtle issue:

hrtimer_interrupt()
  lock(cpu_base);
  expires_next = KTIME_MAX;

  expire_timers(CLOCK_MONOTONIC);
  expires = get_next_timer(CLOCK_MONOTONIC);
  if (expires < expires_next)
    expires_next = expires;

  expire_timers(CLOCK_REALTIME);
    unlock(cpu_base);
    wakeup()
    hrtimer_start(CLOCK_MONOTONIC, newtimer);
    lock(cpu_base();  
  expires = get_next_timer(CLOCK_REALTIME);
  if (expires < expires_next)
    expires_next = expires;

So because we already evaluated the next expiring timer of
CLOCK_MONOTONIC we ignore that the expiry time of newtimer might be
earlier than the overall next expiry time in hrtimer_interrupt().

To solve this, remove the caching of the next expiry value from
hrtimer_interrupt() and reevaluate all active clock bases for the next
expiry value. To avoid another code duplication, create a shared
evaluation function and use it for hrtimer_get_next_event(),
hrtimer_force_reprogram() and hrtimer_interrupt().

There is another subtlety in this mechanism:

While hrtimer_interrupt() is running, we want to avoid to touch the
hardware device because we will reprogram it anyway at the end of
hrtimer_interrupt(). This works nicely for hrtimers which get rearmed
via the HRTIMER_RESTART mechanism, because we drop out when the
callback on that CPU is running. But that fails, if a new timer gets
enqueued like in the example above.

This has another implication: While hrtimer_interrupt() is running we
refuse remote enqueueing of timers - see hrtimer_interrupt() and
hrtimer_check_target().

hrtimer_interrupt() tries to prevent this by setting cpu_base->expires
to KTIME_MAX, but that fails if a new timer gets queued.

Prevent both the hardware access and the remote enqueue
explicitely. We can loosen the restriction on the remote enqueue now
due to reevaluation of the next expiry value, but that needs a
seperate patch.

Reported-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Based-on-patch-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h |    2 
 kernel/time/hrtimer.c   |  107 +++++++++++++++++++++---------------------------
 2 files changed, 51 insertions(+), 58 deletions(-)

Index: tip/include/linux/hrtimer.h
===================================================================
--- tip.orig/include/linux/hrtimer.h
+++ tip/include/linux/hrtimer.h
@@ -170,6 +170,7 @@ enum  hrtimer_base_type {
  * @clock_was_set:	Indicates that clock was set from irq context.
  * @expires_next:	absolute time of the next event which was scheduled
  *			via clock_set_next_event()
+ * @in_hrtirq:		hrtimer_interrupt() is currently executing
  * @hres_active:	State of high resolution mode
  * @hang_detected:	The last hrtimer interrupt detected a hang
  * @nr_events:		Total number of hrtimer interrupt events
@@ -185,6 +186,7 @@ struct hrtimer_cpu_base {
 	unsigned int			clock_was_set;
 #ifdef CONFIG_HIGH_RES_TIMERS
 	ktime_t				expires_next;
+	int				in_hrtirq;
 	int				hres_active;
 	int				hang_detected;
 	unsigned long			nr_events;
Index: tip/kernel/time/hrtimer.c
===================================================================
--- tip.orig/kernel/time/hrtimer.c
+++ tip/kernel/time/hrtimer.c
@@ -440,6 +440,37 @@ static inline void debug_deactivate(stru
 	trace_hrtimer_cancel(timer);
 }
 
+#if defined(CONFIG_NO_HZ_COMMON) || defined(CONFIG_HIGH_RES_TIMERS)
+ktime_t __hrtimer_get_next_event(struct hrtimer_cpu_base *cpu_base)
+{
+	struct hrtimer_clock_base *base = cpu_base->clock_base;
+	ktime_t expires, expires_next = { .tv64 = KTIME_MAX };
+	int i;
+
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++, base++) {
+		struct timerqueue_node *next;
+		struct hrtimer *timer;
+
+		next = timerqueue_getnext(&base->active);
+		if (!next)
+			continue;
+
+		timer = container_of(next, struct hrtimer, node);
+		expires = ktime_sub(hrtimer_get_expires(timer), base->offset);
+		if (expires.tv64 < expires_next.tv64)
+			expires_next = expires;
+	}
+	/*
+	 * clock_was_set() might have changed base->offset of any of
+	 * the clock bases so the result might be negative. Fix it up
+	 * to prevent a false positive in clockevents_program_event().
+	 */
+	if (expires_next.tv64 < 0)
+		expires_next.tv64 = 0;
+	return expires_next;
+}
+#endif
+
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
 
@@ -488,32 +519,7 @@ static inline int hrtimer_hres_active(vo
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
+	ktime_t expires_next = __hrtimer_get_next_event(cpu_base);
 
 	if (skip_equal && expires_next.tv64 == cpu_base->expires_next.tv64)
 		return;
@@ -587,6 +593,15 @@ static int hrtimer_reprogram(struct hrti
 		return 0;
 
 	/*
+	 * When the target cpu of the timer is currently executing
+	 * hrtimer_interrupt(), then we do not touch the clock event
+	 * device. hrtimer_interrupt() will reevaluate all clock bases
+	 * before reprogramming the device.
+	 */
+	if (cpu_base->in_hrtirq)
+		return 0;
+
+	/*
 	 * If a hang was detected in the last timer interrupt then we
 	 * do not schedule a timer which is earlier than the expiry
 	 * which we enforced in the hang detection. We want the system
@@ -1104,29 +1119,14 @@ EXPORT_SYMBOL_GPL(hrtimer_get_remaining)
 ktime_t hrtimer_get_next_event(void)
 {
 	struct hrtimer_cpu_base *cpu_base = this_cpu_ptr(&hrtimer_bases);
-	struct hrtimer_clock_base *base = cpu_base->clock_base;
-	ktime_t delta, mindelta = { .tv64 = KTIME_MAX };
+	ktime_t mindelta = { .tv64 = KTIME_MAX };
 	unsigned long flags;
-	int i;
 
 	raw_spin_lock_irqsave(&cpu_base->lock, flags);
 
-	if (!hrtimer_hres_active()) {
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
-	}
+	if (!hrtimer_hres_active())
+		mindelta = ktime_sub(__hrtimer_get_next_event(cpu_base),
+				     ktime_get());
 
 	raw_spin_unlock_irqrestore(&cpu_base->lock, flags);
 
@@ -1251,9 +1251,9 @@ void hrtimer_interrupt(struct clock_even
 	dev->next_event.tv64 = KTIME_MAX;
 
 	raw_spin_lock(&cpu_base->lock);
+	cpu_base->in_hrtirq = 1;
 	entry_time = now = hrtimer_update_base(cpu_base);
 retry:
-	expires_next.tv64 = KTIME_MAX;
 	/*
 	 * We set expires_next to KTIME_MAX here with cpu_base->lock
 	 * held to prevent that a timer is enqueued in our queue via
@@ -1291,23 +1291,14 @@ retry:
 			 * are right-of a not yet expired timer, because that
 			 * timer will have to trigger a wakeup anyway.
 			 */
-
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
-
+	/* Reevaluate the clock bases for the next expiry */
+	expires_next = __hrtimer_get_next_event(cpu_base);
 	/*
 	 * Store the new expiry value so the migration code can verify
 	 * against it.
