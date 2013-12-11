Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab3LKLAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:00:32 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:43643 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3LKLAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:00:31 -0500
Message-ID: <52A845BD.5020801@linaro.org>
Date: Wed, 11 Dec 2013 19:00:13 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: nohz_full left a periodic tick cpu issue
References: <52A80627.9020109@linaro.org>
In-Reply-To: <52A80627.9020109@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 02:28 PM, Alex Shi wrote:
> Hi Frederic,
> 
> Sorry for idiot of nohz_full. When we using this feature on my mobile
> devices, we found this feature keep cpu0 in periodic tick mode. then the
> timer interrupt on cpu0 is very higher than normal nohz mode.
> that cause high power consuming cost.
> 
> I found you have mention this on commit: a382bf934449
> nohz: Assign timekeeping duty to a CPU outside the full dynticks range
> 
> In fact, if all full dynticks cpu are in idle, cpu0 should be safe to
> get into idle too. Do you have some plan or idea to implement this?
> otherwise, power cost is too high to enable nohz_full in mobile platform.

CC to more experts: Paul and zhong.

In fact, I try to figure out a simple solution for this:
We can use a global variable to store full dyntick cpus number, when the number goes to 0, the cpu0 can be get into nohz mode as normal nohz.
Then before any cpu get into full dyntick, it can send out a need resched to wake up the cpu0.

but I am stalled for a week in making the nr_nohz_busy_cpu balance on a 2 cpus system - pandaboard es. the variable may increases 2 or 3 times continuously without a decrease. so nr_nohz_busy_cpus increased to 28 in 7200 seconds.

Anyone like point out what I missed in this simple patch?

For more cpus system you can just assign one cpu as full dyntick cpu to debug this patch.


>From 14afeca87d8d74cb65c1d0f2bdd270466d4c7083 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linaro.org>
Date: Wed, 11 Dec 2013 18:32:52 +0800
Subject: [PATCH 4/5] nohz_full: tracking the full dynticks cpu number

This patch try to track the full dynticks cpu number with a global
varible nr_nohz_busy_cpus.

When ts->tick_stopped and !ts->inidle, it is time for full dyntick.
To achieve this, the ts->inidle = 0 was delayed in tick_nohz_idle_exit
safely.

But the patch failed, it may increases 2 or 3 times continuously without
 a decrease. so nr_nohz_busy_cpus increased to 28 in 7200 seconds. :(

---
 include/linux/tick.h     |  3 +++
 kernel/time/tick-sched.c | 19 +++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 5128d33..3784f9f 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -161,6 +161,7 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 
 #ifdef CONFIG_NO_HZ_FULL
 extern bool tick_nohz_full_running;
+extern atomic_t nr_nohz_busy_cpus;
 extern cpumask_var_t tick_nohz_full_mask;
 
 static inline bool tick_nohz_full_enabled(void)
@@ -184,6 +185,7 @@ extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
+extern bool has_nohz_busy_cpus(void);
 #else
 static inline void tick_nohz_init(void) { }
 static inline bool tick_nohz_full_enabled(void) { return false; }
@@ -192,6 +194,7 @@ static inline void __tick_nohz_full_check(void) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
+static inline bool has_nohz_busy_cpus(void) { return true; }
 #endif
 
 static inline void tick_nohz_full_check(void)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b55d1c0..37f2784 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -148,9 +148,13 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 	profile_tick(CPU_PROFILING);
 }
 
+atomic_t nr_nohz_busy_cpus = ATOMIC_INIT(0);
 #ifdef CONFIG_NO_HZ_FULL
 cpumask_var_t tick_nohz_full_mask;
 bool tick_nohz_full_running;
+inline bool has_nohz_busy_cpus(void) {
+	return !!atomic_read(&nr_nohz_busy_cpus);
+}
 
 static bool can_stop_full_tick(void)
 {
@@ -642,6 +646,11 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
 			ts->last_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
 			trace_tick_stop(1, " ");
+			if (!ts->inidle) {
+				if (atomic_inc_return(&nr_nohz_busy_cpus) != 1) {
+					printk(KERN_ERR "inc cpu %d as %d\n", cpu, test);
+				}
+			}
 		}
 
 		/*
@@ -881,6 +890,12 @@ static void tick_nohz_restart_sched_tick(struct tick_sched *ts, ktime_t now)
 	ts->tick_stopped  = 0;
 	ts->idle_exittime = now;
 
+	if (!ts->inidle) {
+		if (atomic_dec_return(&nr_nohz_busy_cpus)) {
+			printk(KERN_ERR "dec cpu %d to %d\n",
+				smp_processor_id(), atomic_read(&nr_nohz_busy_cpus));
+		}
+	}
 	tick_nohz_restart(ts, now);
 }
 
@@ -922,8 +937,6 @@ void tick_nohz_idle_exit(void)
 
 	WARN_ON_ONCE(!ts->inidle);
 
-	ts->inidle = 0;
-
 	if (ts->idle_active || ts->tick_stopped)
 		now = ktime_get();
 
@@ -935,6 +948,8 @@ void tick_nohz_idle_exit(void)
 		tick_nohz_account_idle_ticks(ts);
 	}
 
+	ts->inidle = 0;
+
 	local_irq_enable();
 }
 EXPORT_SYMBOL_GPL(tick_nohz_idle_exit);
-- 
1.8.1.2

-- 
Thanks
    Alex
