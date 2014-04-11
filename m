Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759693AbaDKQik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:38:40 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:65419 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422913AbaDKQib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:38:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140411151825.GX11096@twins.programming.kicks-ass.net>
References: <CAKohpo=uT0oC+bZVJQPsoGLb-a4y4huYKtd1ayb4_+iH4906nw@mail.gmail.com>
	<CAKohpom5Ft_XrNTExE9Ukyv1e4car+wicDiPp_Bdhy=PW9Sq8g@mail.gmail.com>
	<20140410143857.GA27654@localhost.localdomain>
	<CAKohpomMhpGsYGafr5uZ0QgO0MEndqDA4G=4syhus4sZW3d8cg@mail.gmail.com>
	<20140411145333.GC3438@localhost.localdomain>
	<20140411151825.GX11096@twins.programming.kicks-ass.net>
Date: Fri, 11 Apr 2014 22:08:30 +0530
Message-ID: <CAKohpomgv-LbUcPxazfJkf0Jq0sSULxT0WjrbFovn0k0O-ORwg@mail.gmail.com>
Subject: Re: [Query]: tick-sched: why don't we stop tick when we are running
 idle task?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 April 2014 20:48, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Apr 11, 2014 at 04:53:35PM +0200, Frederic Weisbecker wrote:

> I think there's assumptions that tick runs on the local cpu;

Yes, many function behave that way, i.e. with smp_processor_id() as
CPU.

> also what
> are you going to do when running it on all remote cpus takes longer than
> the tick?
>
>> Otherwise (and ideally) we need to make the scheduler code able to handle long periods without
>> calling scheduler_tick(). But this is a lot more plumbing. And the scheduler has gazillions
>> accounting stuffs to handle. Sounds like a big nightmare to take that direction.
>
> So i'm not at all sure what you guys are talking about, but it seems to
> me you should all put down the bong and have a detox round instead.
>
> This all sounds like a cure worse than the problem.

So, what I was working on isn't ready yet but I would like to show what lines
I have been trying on. In case that is completely incorrect and I should stop
making that work :)

Please share your feedback about this (Yes there are several parts broken
currently, specially the assumption that tick runs on local CPU):

NOTE: Its rebased over some cleanups I did which aren't sent to LKML yet.

---------x-------------------------x---------------
    tick-sched: offload NO_HZ_FULL computation to timekeeping CPUs

    Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 include/linux/tick.h     |  2 ++
 kernel/time/tick-sched.c | 90
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 82 insertions(+), 10 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 97bbb64..f8efa9f 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -62,6 +62,7 @@ enum tick_nohz_mode {
  */
 struct tick_sched {
        struct hrtimer                  sched_timer;
+       struct cpumask                  timekeeping_pending;
        enum tick_nohz_mode             nohz_mode;
        unsigned long                   check_clocks;
        unsigned long                   idle_jiffies;
@@ -77,6 +78,7 @@ struct tick_sched {
        ktime_t                         iowait_sleeptime;
        ktime_t                         sleep_length;
        ktime_t                         idle_expires;
+       unsigned int                    cpu;
        int                             inidle;
        int                             idle_active;
        int                             tick_stopped;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2d0b154..7560bd0 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -532,13 +532,56 @@ u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time)
 }
 EXPORT_SYMBOL_GPL(get_cpu_iowait_time_us);

+static int tick_nohz_full_get_offload_cpu(unsigned int cpu)
+{
+       const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+       unsigned int offload_cpu;
+       cpumask_t cpumask;
+
+       /* Don't pick any NO_HZ_FULL cpu */
+       cpumask_andnot(&cpumask, cpu_online_mask, tick_nohz_full_mask);
+       cpumask_clear_cpu(cpu, &cpumask);
+
+       /* Try for same node. */
+       offload_cpu = cpumask_first_and(nodemask, &cpumask);
+       if (offload_cpu < nr_cpu_ids)
+               return offload_cpu;
+
+       /* Any online will do */
+       return cpumask_any(&cpumask);
+}
+
+static void tick_nohz_full_offload_timer(void *info)
+{
+       struct tick_sched *ts = info;
+       hrtimer_start_expires(&ts->sched_timer, HRTIMER_MODE_ABS_PINNED);
+}
+
+static void tick_nohz_full_offload_tick(struct tick_sched *ts, ktime_t expires,
+                                       unsigned int cpu)
+{
+       unsigned int offload_cpu = tick_nohz_full_get_offload_cpu(cpu);
+
+       /* Offload accounting to timekeeper */
+       hrtimer_cancel(&ts->sched_timer);
+       hrtimer_set_expires(&ts->sched_timer, expires);
+
+       /*
+        * This is triggering a WARN_ON() as below routine doesn't support calls
+        * while interrupts are disabled. Need to think of some other way to get
+        * this fixed.
+        */
+       smp_call_function_single(offload_cpu, tick_nohz_full_offload_timer, ts,
+                                true);
+}
+
 static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
                                         ktime_t now, int cpu)
 {
        unsigned long seq, last_jiffies, next_jiffies, delta_jiffies;
        ktime_t last_update, expires, ret = { .tv64 = 0 };
        unsigned long rcu_delta_jiffies;
-       struct clock_event_device *dev = tick_get_cpu_device()->evtdev;
+       struct clock_event_device *dev = tick_get_device(cpu)->evtdev;
        u64 time_delta;

        time_delta = timekeeping_max_deferment();
@@ -661,8 +704,12 @@ static ktime_t tick_nohz_stop_sched_tick(struct
tick_sched *ts,
                }

                if (ts->nohz_mode == NOHZ_MODE_HIGHRES) {
-                       hrtimer_start(&ts->sched_timer, expires,
-                                     HRTIMER_MODE_ABS_PINNED);
+                       if (ts->inidle)
+                               hrtimer_start(&ts->sched_timer, expires,
+                                             HRTIMER_MODE_ABS_PINNED);
+                       else
+                               tick_nohz_full_offload_tick(ts, expires, cpu);
+
                        /* Check, if the timer was already in the past */
                        if (hrtimer_active(&ts->sched_timer))
                                goto out;
@@ -687,9 +734,7 @@ out:
 static void tick_nohz_full_stop_tick(struct tick_sched *ts)
 {
 #ifdef CONFIG_NO_HZ_FULL
-       int cpu = smp_processor_id();
-
-       if (!tick_nohz_full_cpu(cpu) || is_idle_task(current))
+       if (!tick_nohz_full_cpu(ts->cpu) || is_idle_task(current))
                return;

        if (!ts->tick_stopped && ts->nohz_mode == NOHZ_MODE_INACTIVE)
@@ -698,7 +743,7 @@ static void tick_nohz_full_stop_tick(struct tick_sched *ts)
        if (!can_stop_full_tick())
                return;

-       tick_nohz_stop_sched_tick(ts, ktime_get(), cpu);
+       tick_nohz_stop_sched_tick(ts, ktime_get(), ts->cpu);
 #endif
 }

@@ -824,11 +869,21 @@ EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
 void tick_nohz_irq_exit(void)
 {
        struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+       unsigned int cpu;

-       if (ts->inidle)
+       if (ts->inidle) {
                __tick_nohz_idle_enter(ts);
-       else
+       } else {
                tick_nohz_full_stop_tick(ts);
+
+               while (!cpumask_empty(&ts->timekeeping_pending)) {
+                       cpu = cpumask_first(&ts->timekeeping_pending);
+                       cpumask_clear_cpu(cpu, &ts->timekeeping_pending);
+
+                       /* Try to stop tick of NO_HZ_FULL cpu */
+                       tick_nohz_full_stop_tick(tick_get_tick_sched(cpu));
+               }
+       }
 }

 /**
@@ -1090,13 +1145,23 @@ static enum hrtimer_restart
tick_sched_timer(struct hrtimer *timer)
 {
        struct tick_sched *ts =
                container_of(timer, struct tick_sched, sched_timer);
+       struct tick_sched *this_ts = &__get_cpu_var(tick_cpu_sched);
        ktime_t now = ktime_get();

-       tick_sched_do_timer(now);
+       /* Running as timekeeper ? */
+       if (likely(ts == this_ts))
+               tick_sched_do_timer(now);
+       else
+               cpumask_set_cpu(ts->cpu, &this_ts->timekeeping_pending);
+
        tick_sched_handle(ts);

        hrtimer_forward(timer, now, tick_period);

+       /*
+        * Yes, we are scheduling next tick also while timekeeping on this_cpu.
+        * We will handle that from irq_exit().
+        */
        return HRTIMER_RESTART;
 }

@@ -1149,6 +1214,11 @@ void tick_setup_sched_timer(void)
                tick_nohz_active = 1;
        }
 #endif
+
+#ifdef CONFIG_NO_HZ_FULL
+       ts->cpu = smp_processor_id();
+       cpumask_clear(&ts->timekeeping_pending);
+#endif
 }
 #endif /* HIGH_RES_TIMERS */
