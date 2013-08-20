Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab3HTQjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 12:39:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab3HTQjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 12:39:36 -0400
Date: Tue, 20 Aug 2013 18:33:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
Message-ID: <20130820163312.GA17957@redhat.com>
References: <1376667753-29014-3-git-send-email-fweisbec@gmail.com> <20130816160201.GA31682@redhat.com> <20130816162056.GE24210@somewhere> <20130816162654.GA453@redhat.com> <20130816164626.GH24210@somewhere> <20130819111026.GE24092@twins.programming.kicks-ass.net> <521313D8.9080500@lab.ntt.co.jp> <20130820084405.GC3258@twins.programming.kicks-ass.net> <52138BE9.5090005@linux.intel.com> <20130820160146.GG3258@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820160146.GG3258@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Peter Zijlstra wrote:
>
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -453,7 +453,8 @@ struct rq {
>  	u64 clock;
>  	u64 clock_task;
>  
> -	atomic_t nr_iowait;
> +	int nr_iowait_local;
> +	atomic_t nr_iowait_remote;

I am wondering how the extra lock(rq)/unlock(rq) in schedule() is bad
compared to atomic_dec.

IOW, what if we simply make rq->nr_iowait "int" and change schedule()
to update it? Something like below. Just curious.

As for nr_iowait_local + nr_iowait_remote, this doesn't look safe...
in theory nr_iowait_cpu() or even nr_iowait() can return a negative
number.

Oleg.


--- x/kernel/sched/core.c
+++ x/kernel/sched/core.c
@@ -2435,6 +2435,9 @@ need_resched:
 		rq->curr = next;
 		++*switch_count;
 
+		if (unlikely(prev->in_iowait))
+			rq->nr_iowait++;
+
 		context_switch(rq, prev, next); /* unlocks the rq */
 		/*
 		 * The context switch have flipped the stack from under us
@@ -2442,6 +2445,12 @@ need_resched:
 		 * this task called schedule() in the past. prev == current
 		 * is still correct, but it can be moved to another cpu/rq.
 		 */
+		if (unlikely(prev->in_iowait)) {
+			raw_spin_lock_irq(&rq->lock);
+			rq->nr_iowait--;
+			raw_spin_unlock_irq(&rq->lock);
+		}
+
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
 	} else
@@ -3939,31 +3948,24 @@ EXPORT_SYMBOL_GPL(yield_to);
  */
 void __sched io_schedule(void)
 {
-	struct rq *rq = raw_rq();
-
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
 	blk_flush_plug(current);
 	current->in_iowait = 1;
 	schedule();
 	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 }
 EXPORT_SYMBOL(io_schedule);
 
 long __sched io_schedule_timeout(long timeout)
 {
-	struct rq *rq = raw_rq();
 	long ret;
 
 	delayacct_blkio_start();
-	atomic_inc(&rq->nr_iowait);
 	blk_flush_plug(current);
 	current->in_iowait = 1;
 	ret = schedule_timeout(timeout);
 	current->in_iowait = 0;
-	atomic_dec(&rq->nr_iowait);
 	delayacct_blkio_end();
 	return ret;
 }

