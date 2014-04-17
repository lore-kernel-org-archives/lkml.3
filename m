Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbaDQKGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:06:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57814 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbaDQKFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:05:53 -0400
Date: Thu, 17 Apr 2014 12:05:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] nohz: use delayed iowait accounting to avoid race on
 idle time stats
Message-ID: <20140417100519.GF11096@twins.programming.kicks-ass.net>
References: <53465F54.708@jp.fujitsu.com>
 <534660D2.1080505@jp.fujitsu.com>
 <20140415101910.GN11096@twins.programming.kicks-ass.net>
 <534E2422.1040706@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534E2422.1040706@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 03:33:06PM +0900, Hidetoshi Seto wrote:
> [3] : new tricks
> 
> To use seqcount, observers must be readers and never be writers.
> It means that:
> 
>   - Observed cpu's time stats are fixed at idle entry, and
>     unchanged while sleeping (otherwise results of readers will
>     not be coherent).
> 
>   - Readers must not refer nr_iowait of sleeping cpu because
>     it can be changed by task woken up on other cpu.
> 
> At this point:
> 
>   - As already pointed out, stating "I'll sleep as iowait"
>     at idle entry will result in infinite iowait.
>       => Then how about stating:
>           "I'll sleep for <e.g. few nsec> as iowait
>            and rest as idle"?
>       => how to determine reasonable <few nsecs>?

Well, we actually _know_ when that counter drops to 0. We've got the
actual event there, we don't need to guess about any of this.

>   - Original code accounts iowait only when nr_iowait is >0
>     at idle exit. It means we can not determine whether the
>     sleep time will be idle or iowait on the fly.
>       => we cannot determine <few nsecs> at idle entry

Intel really should give us this crystal ball instruction already ;-)


Anyway, if you want to preserve the same broken ass crap we had pre
NOHZ, something like the below should do that.

I'm not really thrilled with iowait_{start,stop}() but I think they
should have the same general cost as the atomic ops we already had. In
particular on x86 an uncontended lock+unlock is a single atomic.

This is on top the first patch from Frederic that both you and Denys
carried.

That said; I really hate duckt taping this together, for the generated
numbers are still useless.

--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -58,6 +58,8 @@ union ktime {
 
 typedef union ktime ktime_t;		/* Kill this */
 
+#define ktime_zero ((ktime_t){ .tv64 = 0 })
+
 /*
  * ktime_t definitions when using the 64-bit scalar representation:
  */
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2297,15 +2297,29 @@ unsigned long nr_iowait(void)
 	unsigned long i, sum = 0;
 
 	for_each_possible_cpu(i)
-		sum += atomic_read(&cpu_rq(i)->nr_iowait);
+		sum += cpu_rq(i)->nr_iowait;
 
 	return sum;
 }
 
 unsigned long nr_iowait_cpu(int cpu)
 {
-	struct rq *this = cpu_rq(cpu);
-	return atomic_read(&this->nr_iowait);
+	return cpu_rq(cpu)->nr_iowait;
+}
+
+void nr_iowait_deltas(ktime_t start, ktime_t now,
+		      ktime_t *iowait_delta, ktime_t *idle_delta)
+{
+	struct rq *rq = this_rq();
+
+	raw_spin_lock(&rq->iowait_lock);
+	if (rq->nr_iowait) {
+		*iowait_delta = ktime_sub(now, start);
+	} else {
+		*iowait_delta = ktime_sub(rq->last_iowait, start);
+		*idle_delta = ktime_sub(now, rq->last_iowait);
+	}
+	raw_spin_unlock(&rq->iowait_lock);
 }
 
 #ifdef CONFIG_SMP
@@ -4201,6 +4215,24 @@ bool __sched yield_to(struct task_struct
 }
 EXPORT_SYMBOL_GPL(yield_to);
 
+static inline void iowait_start(struct rq *rq)
+{
+	raw_spin_lock(&rq->iowait_lock);
+	rq->nr_iowait++;
+	raw_spin_unlock(&rq->iowait_lock);
+	current->in_iowait = 1;
+}
+
+static inline void iowait_stop(struct rq *rq)
+{
+	current->in_iowait = 0;
+	raw_spin_lock(&rq->iowait_lock);
+	rq->nr_iowait--;
+	if (!rq->nr_iowait && rq != this_rq())
+		rq->last_iowait = ktime_get();
+	raw_spin_unlock(&rq->iowait_lock);
+}
+
 /*
  * This task is about to go to sleep on IO. Increment rq->nr_iowait so
  * that process accounting knows that this is a task in IO wait state.
@@ -4210,12 +4242,10 @@ void __sched io_schedule(void)
 	struct rq *rq = raw_rq();
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
+	iowait_start();
 	blk_flush_plug(current);
-	current->in_iowait = 1;
 	schedule();
-	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	iowait_stop();
 	delayacct_blkio_end();
 }
 EXPORT_SYMBOL(io_schedule);
@@ -4226,12 +4256,10 @@ long __sched io_schedule_timeout(long ti
 	long ret;
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
+	iowait_start();
 	blk_flush_plug(current);
-	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
-	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	iowait_stop();
 	delayacct_blkio_end();
 	return ret;
 }
@@ -6880,7 +6908,10 @@ void __init sched_init(void)
 #endif
 #endif
 		init_rq_hrtick(rq);
-		atomic_set(&rq->nr_iowait, 0);
+
+		raw_spinlock_init(&rq->iowait_lock);
+		rq->nr_iowait = 0;
+		rq->last_iowait = ktime_get();
 	}
 
 	set_load_weight(&init_task);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -571,7 +571,9 @@ struct rq {
 	u64 clock;
 	u64 clock_task;
 
-	atomic_t nr_iowait;
+	raw_spinlock_t	iowait_lock ____cacheline_aligned;
+	unsigned int	nr_iowait;
+	ktime_t		last_iowait
 
 #ifdef CONFIG_SMP
 	struct root_domain *rd;
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -429,14 +429,16 @@ static void tick_nohz_update_jiffies(kti
 
 static void tick_nohz_stop_idle(struct tick_sched *ts, ktime_t now)
 {
-	ktime_t delta;
+	ktime_t iowait_delta = ktime_zero, idle_delta = ktime_zero;
+
+	if (ts->idle_active == 2) {
+		nr_iowait_deltas(ts->idle_entrytime, now, &iowait_delta, &idle_delta);
+		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, iowait_delta);
+	} else {
+		idle_delta = ktime_sub(now, ts->idle_entrytime);
+	}
+	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, idle_delta);
 
-	/* Updates the per cpu time idle statistics counters */
-	delta = ktime_sub(now, ts->idle_entrytime);
-	if (nr_iowait_cpu(smp_processor_id()) > 0)
-		ts->iowait_sleeptime = ktime_add(ts->iowait_sleeptime, delta);
-	else
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
@@ -447,7 +449,7 @@ static ktime_t tick_nohz_start_idle(stru
 	ktime_t now = ktime_get();
 
 	ts->idle_entrytime = now;
-	ts->idle_active = 1;
+	ts->idle_active = 1 + !!nr_iowait_cpu(smp_processor_id());
 	sched_clock_idle_sleep_event();
 	return now;
 }
