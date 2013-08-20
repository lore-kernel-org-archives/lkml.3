Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab3HTQCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:02:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33905 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3HTQCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:02:06 -0400
Date: Tue, 20 Aug 2013 18:01:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130820160146.GG3258@twins.programming.kicks-ass.net>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-3-git-send-email-fweisbec@gmail.com>
 <20130816160201.GA31682@redhat.com>
 <20130816162056.GE24210@somewhere>
 <20130816162654.GA453@redhat.com>
 <20130816164626.GH24210@somewhere>
 <20130819111026.GE24092@twins.programming.kicks-ass.net>
 <521313D8.9080500@lab.ntt.co.jp>
 <20130820084405.GC3258@twins.programming.kicks-ass.net>
 <52138BE9.5090005@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52138BE9.5090005@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:31:53AM -0700, Arjan van de Ven wrote:
> On 8/20/2013 1:44 AM, Peter Zijlstra wrote:

> >Of course, if we can get away with completely removing all of that
> >(which I think Arjan suggested was a real possibility) then that would
> >be ever so much better still :-)
> 
> I'm quite ok with removing that.
> 
> however note that "top" also reports per cpu iowait...
> and that's a userspace expectation

Right, broken as that maybe :/ OK that looks like CPUTIME_IOWAIT which
is tick based and not the ns based accounting.

Still it needs the per-cpu nr_iowait accounting which pretty much
requires the atomics so no big gains there.

Which means that if Frederic can make the ns thing as expensive as the
existing atomics we might as well keep the ns thing too.


Hmm, would something like the below make sense? I suppose this can be
done even for the ns case, you'd have to duplicate all stats though.

At the very least the below reduces the number of atomics, not entirely
sure it all matters much though, some benchmarking would be in order I
suppose.

---
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2167,8 +2167,12 @@ unsigned long nr_iowait(void)
 {
 	unsigned long i, sum = 0;
 
-	for_each_possible_cpu(i)
-		sum += atomic_read(&cpu_rq(i)->nr_iowait);
+	for_each_possible_cpu(i) {
+		struct rq *rq = cpu_rq(i);
+
+		sum += rq->nr_iowait_local;
+		sum += atomic_read(&rq->nr_iowait_remote);
+	}
 
 	return sum;
 }
@@ -2176,7 +2180,7 @@ unsigned long nr_iowait(void)
 unsigned long nr_iowait_cpu(int cpu)
 {
 	struct rq *this = cpu_rq(cpu);
-	return atomic_read(&this->nr_iowait);
+	return atomic_read(&this->nr_iowait_remote) + this->nr_iowait_local;
 }
 
 #ifdef CONFIG_SMP
@@ -4086,31 +4090,49 @@ EXPORT_SYMBOL_GPL(yield_to);
  */
 void __sched io_schedule(void)
 {
-	struct rq *rq = raw_rq();
+	struct rq *rq;
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
 	blk_flush_plug(current);
+
+	preempt_disable();
+	rq = this_rq();
+	rq->nr_iowait_local++;
 	current->in_iowait = 1;
-	schedule();
+	schedule_preempt_disabled();
 	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	if (likely(task_cpu(current) == cpu_of(rq)))
+		rq->nr_iowait_local--;
+	else
+		atomic_dec(&rq->nr_iowait_remote);
+	preempt_enable();
+
 	delayacct_blkio_end();
 }
 EXPORT_SYMBOL(io_schedule);
 
 long __sched io_schedule_timeout(long timeout)
 {
-	struct rq *rq = raw_rq();
+	struct rq *rq;
 	long ret;
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
 	blk_flush_plug(current);
+
+	preempt_disable();
+	rq = this_rq();
+	rq->nr_iowait_local++;
 	current->in_iowait = 1;
+	preempt_enable_no_resched();
 	ret = schedule_timeout(timeout);
+	preempt_disable();
 	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
+	if (likely(task_cpu(current) == cpu_of(rq)))
+		rq->nr_iowait_local--;
+	else
+		atomic_dec(&rq->nr_iowait_remote);
+	preempt_enable();
+
 	delayacct_blkio_end();
 	return ret;
 }
@@ -6650,7 +6672,8 @@ void __init sched_init(void)
 #endif
 #endif
 		init_rq_hrtick(rq);
-		atomic_set(&rq->nr_iowait, 0);
+		rq->nr_iowait_local = 0;
+		atomic_set(&rq->nr_iowait_remote, 0);
 	}
 
 	set_load_weight(&init_task);
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -453,7 +453,8 @@ struct rq {
 	u64 clock;
 	u64 clock_task;
 
-	atomic_t nr_iowait;
+	int nr_iowait_local;
+	atomic_t nr_iowait_remote;
 
 #ifdef CONFIG_SMP
 	struct root_domain *rd;

