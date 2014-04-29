Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbaD2QUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:20:10 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39158 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbaD2QUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:20:05 -0400
Date: Tue, 29 Apr 2014 18:20:01 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 4/4] nohz: Fix iowait overcounting if iowait task migrates
Message-ID: <20140429161959.GD6129@localhost.localdomain>
References: <1398365158-12568-1-git-send-email-dvlasenk@redhat.com>
 <1398365158-12568-4-git-send-email-dvlasenk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398365158-12568-4-git-send-email-dvlasenk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 08:45:58PM +0200, Denys Vlasenko wrote:
> Before this change, if last IO-blocked task wakes up
> on a different CPU, the original CPU may stay idle for much longer,
> and the entire time it stays idle is accounted as iowait time.
> 
> This change adds struct tick_sched::iowait_exittime member.
> On entry to idle, it is set to KTIME_MAX.
> Last IO-blocked task, if migrated, sets it to current time.
> Note that this can happen only once per each idle period:
> new iowaiting tasks can't magically appear on idle CPU's rq.
> 
> If iowait_exittime is set, then (iowait_exittime - idle_entrytime)
> gets accounted as iowait, and the remaining (now - iowait_exittime)
> as "true" idle.
> 
> Run-tested: /proc/stat counters no longer go backwards.
> 
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
>  include/linux/tick.h     |  2 ++
>  kernel/sched/core.c      | 14 +++++++++++
>  kernel/time/tick-sched.c | 64 ++++++++++++++++++++++++++++++++++++++++--------
>  3 files changed, 70 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/tick.h b/include/linux/tick.h
> index 4de1f9e..1bf653e 100644
> --- a/include/linux/tick.h
> +++ b/include/linux/tick.h
> @@ -67,6 +67,7 @@ struct tick_sched {
>  	ktime_t				idle_exittime;
>  	ktime_t				idle_sleeptime;
>  	ktime_t				iowait_sleeptime;
> +	ktime_t				iowait_exittime;
>  	seqcount_t			idle_sleeptime_seq;
>  	ktime_t				sleep_length;
>  	unsigned long			last_jiffies;
> @@ -140,6 +141,7 @@ extern void tick_nohz_irq_exit(void);
>  extern ktime_t tick_nohz_get_sleep_length(void);
>  extern u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time);
>  extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
> +extern void tick_nohz_iowait_to_idle(int cpu);
>  
>  # else /* !CONFIG_NO_HZ_COMMON */
>  static inline int tick_nohz_tick_stopped(void)
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

Note that even using seqlock doesn't alone help to fix the preemption issue
when the above may overwrite the exittime of the next last iowait task from
the old rq.
