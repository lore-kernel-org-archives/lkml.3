Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3HGIZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 04:25:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab3HGIZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 04:25:47 -0400
Message-ID: <1375863939.12157.27.camel@marge.simpson.net>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ethan Zhao <ethan.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        johlstei@codeaurora.org, Yinghai Lu <yinghai@kernel.org>,
        Jin Feng <joe.jin@oracle.com>, Youquan Song <youquan.song@intel.com>,
        LenBrown <len.brown@intel.com>
Date: Wed, 07 Aug 2013 10:25:39 +0200
In-Reply-To: <1375774140.5412.9.camel@marge.simpson.net>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
	 <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
	 <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
	 <20130730093519.GP3008@twins.programming.kicks-ass.net>
	 <1375774140.5412.9.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:wPa9zhS3yojizzczFpnTs2X6i2GAm4RMiufTFG0jRB8
 iY1gQUt0KleSGcRI93xrrsZEtR+DETgllsKFsAauWTmLF50gXY
 UyK3pJaYoNiZ30AQvePWGsRsW9RxlPQXln3qiiJdAbSXILgwUA
 k6lHz5/5mwhY2oESv1fptGkKffajtAqcU+BwcEBKLr7h9prbcU
 gMzfOz5jdj9Kzo4G8TakYhVd5vjw63F+uJWpsJvneWLJ6xJuEi
 xGcGV9MgweUK92pvdYMXEnyrVhZHgV6FFfprGjdazohRbkq9qn
 7xMRy0NiOTLNbCy4gq7s9uMXFSWdBC3UmpogeF+CkhmBhVsEb3
 bxaZO4QpSzCXHhI4b9vAqYVuzobS5dB65QEiTzXwX37zvEuP1/
 3S6r3OLI1oFAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 09:29 +0200, Mike Galbraith wrote:

...

> E5620                                            +write 0 -> /dev/cpu_dma_latency, hold open
> v3.7.10                  578.5 KHz     1.000     675.4 KHz     1.000
> v3.7.10-nothrottle       366.7 KHz      .633     395.0 KHz      .584
> v3.8.13                  468.3 KHz      .809     690.0 KHz     1.021
> v3.8.13 idle=mwait       595.1 KHz     1.028     NA
> v3.9.11                  462.0 KHz      .798     691.1 KHz     1.023
> v3.10.4                  419.4 KHz      .724     570.8 KHz      .845
> v3.11-rc3-4-g36f571e     400.1 KHz      .691     538.5 KHz      .797

Adds Peter's patch, re-tests master/E5620, nohz throttled/unthrottled..

v3.11-rc4-27-ge4ef108    481.9 KHz      .833     1.000     throttle (400->481 36f571e..e4ef108? spinlock overhead gone)
v3.11-rc4-27-ge4ef108    496.7 KHz      .858     1.030     throttle+peterz   (spinlock overhead gone)

v3.11-rc4-27-ge4ef108    340.0 KHz      .587     1.000     nothrottle        (spinlock overhead present)
v3.11-rc4-27-ge4ef108    440.7 KHz      .761     1.296     nothrottle+peterz (spinlock overhead gone)

E5620 (2.4 GHz Westmere) nothrottle

    v3.11-rc4-27-ge4ef108                       v3.11-rc4-27-ge4ef108+peterz
    17.48%  [k] _raw_spin_unlock_irqrestore     5.37%  [k] __schedule
    11.36%  [k] __hrtimer_start_range_ns        4.96%  [k] reschedule_interrupt
     3.78%  [k] __schedule                      3.82%  [k] _raw_spin_lock_irqsave
     3.54%  [k] reschedule_interrupt            3.62%  [k] __switch_to
     2.81%  [k] __switch_to                     3.05%  [k] cpuidle_enter_state
     2.64%  [k] _raw_spin_lock_irqsave          2.99%  [k] resched_task
     2.14%  [k] cpuidle_enter_state             2.39%  [k] mutex_lock
     1.97%  [k] resched_task                    2.31%  [k] copy_user_generic_string
     1.68%  [k] copy_user_generic_string        2.23%  [k] cpu_idle_loop
     1.68%  [k] cpu_idle_loop                   2.20%  [k] task_waking_fair

E5620 (2.4 GHz Westmere) throttle

    v3.11-rc4-27-ge4ef108                       v3.11-rc4-27-ge4ef108+peterz
    6.76%  [k] __schedule                       7.68%  [k] reschedule_interrupt  (find this little bastard)
    5.90%  [k] reschedule_interrupt             7.18%  [k] __schedule
    4.12%  [k] __switch_to                      4.52%  [k] __switch_to
    3.58%  [k] resched_tas                      4.24%  [k] cpuidle_enter_state
    3.24%  [k] cpuidle_enter_state              2.96%  [k] cpu_idle_loop
    3.01%  [k] _raw_spin_lock_irqsave           2.96%  [k] resched_task
    2.67%  [k] cpu_idle_loop                    2.79%  [k] _raw_spin_lock_irqsave
    2.49%  [k] task_waking_fair                 2.45%  [k] ktime_get
    2.38%  [k] copy_user_generic_string         2.34%  [k] copy_user_generic_string
    2.27%  [k] mutex_lock                       2.32%  [k] get_typical_interval

And below is peterz..

On Mon, Jul 29, 2013 at 12:18:11PM +0200, Thomas Gleixner wrote:

> The reason why we want to do that is: 
> 
>     timer      expiry time
>     A	        100us -> programmed hardware event
>     B	       2000us
> 
> Restart timer A with an expiry time of 3000us without reprogramming:
> 
>     timer      expiry time
>     NONE       100us -> programmed hardware event
>     B	       2000us
>     A	       3000us
> 
> We take an extra wakeup for reprogramming the hardware, which is
> counterproductive for power saving. So disabling it blindly will cause
> a regresssion for other people. We need to be smarter than that.

So aside from the complete mess posted; how about something like this?

*completely untested etc..*

mike: Builds(now)/boots/makes E5620 happier.

---
 include/linux/hrtimer.h |    5 ++++
 kernel/hrtimer.c        |   60 ++++++++++++++++++++++--------------------------
 2 files changed, 33 insertions(+), 32 deletions(-)

--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -185,6 +185,7 @@ struct hrtimer_cpu_base {
 	ktime_t				expires_next;
 	int				hres_active;
 	int				hang_detected;
+	int				timers_removed;
 	unsigned long			nr_events;
 	unsigned long			nr_retries;
 	unsigned long			nr_hangs;
@@ -261,6 +262,8 @@ static inline ktime_t hrtimer_expires_re
 #ifdef CONFIG_HIGH_RES_TIMERS
 struct clock_event_device;
 
+extern void hrtimer_enter_idle(void);
+
 extern void hrtimer_interrupt(struct clock_event_device *dev);
 
 /*
@@ -296,6 +299,8 @@ extern void clock_was_set_delayed(void);
 # define MONOTONIC_RES_NSEC	LOW_RES_NSEC
 # define KTIME_MONOTONIC_RES	KTIME_LOW_RES
 
+static inline void hrtimer_enter_idle(void) { }
+
 static inline void hrtimer_peek_ahead_timers(void) { }
 
 /*
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -673,6 +673,27 @@ static inline ktime_t hrtimer_update_bas
 	return ktime_get_update_offsets(offs_real, offs_boot, offs_tai);
 }
 
+static void __hrtimer_reprogram_all(struct hrtimer_cpu_base *base)
+{
+	if (!hrtimer_hres_active())
+		return;
+
+	raw_spin_lock(&base->lock);
+	hrtimer_update_base(base);
+	hrtimer_force_reprogram(base, 0);
+	raw_spin_unlock(&base->lock);
+}
+
+void hrtimer_enter_idle(void)
+{
+	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
+
+	if (base->timers_removed) {
+		base->timers_removed = 0;
+		__hrtimer_reprogram_all(base);
+	}
+}
+
 /*
  * Retrigger next event is called after clock was set
  *
@@ -682,13 +703,7 @@ static void retrigger_next_event(void *a
 {
 	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
 
-	if (!hrtimer_hres_active())
-		return;
-
-	raw_spin_lock(&base->lock);
-	hrtimer_update_base(base);
-	hrtimer_force_reprogram(base, 0);
-	raw_spin_unlock(&base->lock);
+	__hrtimer_reprogram_all(base);
 }
 
 /*
@@ -907,7 +922,7 @@ static int enqueue_hrtimer(struct hrtime
  */
 static void __remove_hrtimer(struct hrtimer *timer,
 			     struct hrtimer_clock_base *base,
-			     unsigned long newstate, int reprogram)
+			     unsigned long newstate)
 {
 	struct timerqueue_node *next_timer;
 	if (!(timer->state & HRTIMER_STATE_ENQUEUED))
@@ -915,19 +930,10 @@ static void __remove_hrtimer(struct hrti
 
 	next_timer = timerqueue_getnext(&base->active);
 	timerqueue_del(&base->active, &timer->node);
-	if (&timer->node == next_timer) {
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
+	if (hrtimer_hres_active() && &timer->node == next_timer)
+		base->cpu_base->timers_removed++;
 #endif
-	}
 	if (!timerqueue_getnext(&base->active))
 		base->cpu_base->active_bases &= ~(1 << base->index);
 out:
@@ -942,26 +948,16 @@ remove_hrtimer(struct hrtimer *timer, st
 {
 	if (hrtimer_is_queued(timer)) {
 		unsigned long state;
-		int reprogram;
 
-		/*
-		 * Remove the timer and force reprogramming when high
-		 * resolution mode is active and the timer is on the current
-		 * CPU. If we remove a timer on another CPU, reprogramming is
-		 * skipped. The interrupt event on this CPU is fired and
-		 * reprogramming happens in the interrupt handler. This is a
-		 * rare case and less expensive than a smp call.
-		 */
 		debug_deactivate(timer);
 		timer_stats_hrtimer_clear_start_info(timer);
-		reprogram = base->cpu_base == &__get_cpu_var(hrtimer_bases);
 		/*
 		 * We must preserve the CALLBACK state flag here,
 		 * otherwise we could move the timer base in
 		 * switch_hrtimer_base.
 		 */
 		state = timer->state & HRTIMER_STATE_CALLBACK;
-		__remove_hrtimer(timer, base, state, reprogram);
+		__remove_hrtimer(timer, base, state);
 		return 1;
 	}
 	return 0;
@@ -1243,7 +1239,7 @@ static void __run_hrtimer(struct hrtimer
 	WARN_ON(!irqs_disabled());
 
 	debug_deactivate(timer);
-	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK, 0);
+	__remove_hrtimer(timer, base, HRTIMER_STATE_CALLBACK);
 	timer_stats_account_hrtimer(timer);
 	fn = timer->function;
 
@@ -1690,7 +1686,7 @@ static void migrate_hrtimer_list(struct
 		 * timer could be seen as !active and just vanish away
 		 * under us on another CPU
 		 */
-		__remove_hrtimer(timer, old_base, HRTIMER_STATE_MIGRATE, 0);
+		__remove_hrtimer(timer, old_base, HRTIMER_STATE_MIGRATE);
 		timer->base = new_base;
 		/*
 		 * Enqueue the timers on the new cpu. This does not


