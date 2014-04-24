Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbaDXHHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:07:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:35396 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaDXHHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:07:36 -0400
Date: Thu, 24 Apr 2014 09:07:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 3/3] nohz: Fix iowait overcounting if iowait task migrates
Message-ID: <20140424070726.GY26782@laptop.programming.kicks-ass.net>
References: <1398279636-21503-1-git-send-email-dvlasenk@redhat.com>
 <1398279636-21503-3-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398279636-21503-3-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 09:00:36PM +0200, Denys Vlasenko wrote:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9cae286..08dd220 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4255,6 +4255,9 @@ EXPORT_SYMBOL_GPL(yield_to);
>   */
>  void __sched io_schedule(void)
>  {
> +#ifdef CONFIG_NO_HZ_COMMON
> +	int cpu_on_entry = smp_processor_id();
> +#endif
>  	struct rq *rq = raw_rq();
>  
>  	delayacct_blkio_start();
> @@ -4263,13 +4266,23 @@ void __sched io_schedule(void)
>  	current->in_iowait = 1;
>  	schedule();
>  	current->in_iowait = 0;
> +#ifdef CONFIG_NO_HZ_COMMON
> +	if (atomic_dec_and_test(&rq->nr_iowait)) {
> +		if (smp_processor_id() != cpu_on_entry)
> +			tick_nohz_iowait_to_idle(cpu_on_entry);
> +	}
> +#else
>  	atomic_dec(&rq->nr_iowait);
> +#endif
>  	delayacct_blkio_end();
>  }
>  EXPORT_SYMBOL(io_schedule);
>  
>  long __sched io_schedule_timeout(long timeout)
>  {
> +#ifdef CONFIG_NO_HZ_COMMON
> +	int cpu_on_entry = smp_processor_id();
> +#endif
>  	struct rq *rq = raw_rq();
>  	long ret;
>  
> @@ -4279,7 +4292,14 @@ long __sched io_schedule_timeout(long timeout)
>  	current->in_iowait = 1;
>  	ret = schedule_timeout(timeout);
>  	current->in_iowait = 0;
> +#ifdef CONFIG_NO_HZ_COMMON
> +	if (atomic_dec_and_test(&rq->nr_iowait)) {
> +		if (smp_processor_id() != cpu_on_entry)
> +			tick_nohz_iowait_to_idle(cpu_on_entry);
> +	}
> +#else
>  	atomic_dec(&rq->nr_iowait);
> +#endif
>  	delayacct_blkio_end();
>  	return ret;
>  }

Why do you insist on writing the same (buggy, see later) code twice?
Really, get lazy already and write it once but use it twice!

Its buggy because the smp_processor_id() is used in preemptible context,
its further buggy because the raw_rq() does it again and could get a rq
on a different cpu.

What you want is something like:

static inline void io_wait_start(struct rq *rq)
{
	atomic_inc(&rq->nr_iowait);
	current->in_iowait = 1;
}

static inline void io_wait_end(struct rq *rq)
{
	current->in_iowait = 0;
#ifdef CONFIG_NO_HZ_COMMON
	if (atomic_dec_and_test(&rq->nr_iowait) && 
		cpu_of(rq) != raw_smp_processor_id()) {
		tick_nohz_iowait_end(cpu_of(rq));
	}
#else
	atomic_dec(&rq->nr_iowait);
#endif
}

Anyway, I suspect that's still broken and you really need that lock
around the state like I did earlier, because the above isn't serialized
between remote wakeup and the cpu waking from nohz.
