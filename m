Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaDXTTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:19:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35779 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaDXTTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:19:14 -0400
Date: Thu, 24 Apr 2014 21:18:56 +0200
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
Subject: Re: [PATCH 4/4] nohz: Fix iowait overcounting if iowait task migrates
Message-ID: <20140424191856.GD26782@laptop.programming.kicks-ass.net>
References: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com>
 <1398365158-12568-4-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398365158-12568-4-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 08:45:58PM +0200, Denys Vlasenko wrote:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 268a45e..ffea757 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4218,7 +4218,14 @@ void __sched io_schedule(void)
>  	current->in_iowait = 1;
>  	schedule();
>  	current->in_iowait = 0;
> +#ifdef CONFIG_NO_HZ_COMMON
> +	if (atomic_dec_and_test(&rq->nr_iowait)) {
> +		if (raw_smp_processor_id() != cpu_of(rq))
> +			tick_nohz_iowait_to_idle(cpu_of(rq));
> +	}
> +#else
>  	atomic_dec(&rq->nr_iowait);
> +#endif
>  	delayacct_blkio_end();
>  }

You're really refusing to collapse that stuff eh? Maybe I should just
redirect this entire iowait fest to /dev/null :/

> +void tick_nohz_iowait_to_idle(int cpu)
> +{
> +	struct tick_sched *ts = tick_get_tick_sched(cpu);
> +	ktime_t now = ktime_get();
> +
> +	write_seqcount_begin(&ts->idle_sleeptime_seq);
> +	ts->iowait_exittime = now;
> +	write_seqcount_end(&ts->idle_sleeptime_seq);
> +}


So what again was wrong with this one?

  http://marc.info/?l=linux-kernel&m=139772917211023

