Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbaD2PNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:13:24 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:54915 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757679AbaD2PNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:13:23 -0400
Date: Tue, 29 Apr 2014 17:13:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Denys Vlasenko <dvlasenk@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/2] nohz: move NOHZ code bits out of
 io_schedule{,_timeout} into a helper
Message-ID: <20140429151317.GC6129@localhost.localdomain>
References: <1398452250-6047-1-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398452250-6047-1-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 08:57:29PM +0200, Denys Vlasenko wrote:
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> Cc: Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/sched/core.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ffea757..3137980 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4208,6 +4208,21 @@ EXPORT_SYMBOL_GPL(yield_to);
>   * This task is about to go to sleep on IO. Increment rq->nr_iowait so
>   * that process accounting knows that this is a task in IO wait state.
>   */
> +#ifdef CONFIG_NO_HZ_COMMON
> +static __sched void io_wait_end(struct rq *rq)
> +{
> +	if (atomic_dec_and_test(&rq->nr_iowait)) {
> +		if (raw_smp_processor_id() != cpu_of(rq))
> +			tick_nohz_iowait_to_idle(cpu_of(rq));
> +	}
> +}
> +#else
> +static inline void io_wait_end(struct rq *rq)
> +{
> +	atomic_dec(&rq->nr_iowait);
> +}
> +#endif
> +
>  void __sched io_schedule(void)
>  {
>  	struct rq *rq = raw_rq();
> @@ -4218,14 +4233,7 @@ void __sched io_schedule(void)
>  	current->in_iowait = 1;
>  	schedule();
>  	current->in_iowait = 0;
> -#ifdef CONFIG_NO_HZ_COMMON
> -	if (atomic_dec_and_test(&rq->nr_iowait)) {
> -		if (raw_smp_processor_id() != cpu_of(rq))
> -			tick_nohz_iowait_to_idle(cpu_of(rq));
> -	}
> -#else
> -	atomic_dec(&rq->nr_iowait);
> -#endif
> +	io_wait_end(rq);
>  	delayacct_blkio_end();

There is much more to unify that the iowait accounting between all
the io_schedule() declensions.

Peterz I think you had a patch to unify that a few month ago?
