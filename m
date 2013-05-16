Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3EPHp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:45:56 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:57486 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab3EPHpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:45:55 -0400
Message-ID: <51948EA4.7090700@linux.vnet.ibm.com>
Date: Thu, 16 May 2013 15:45:40 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: wake-affine throttle
References: <5164DCE7.8080906@linux.vnet.ibm.com>
In-Reply-To: <5164DCE7.8080906@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051607-8878-0000-0000-0000072131A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 11:30 AM, Michael Wang wrote:
> Log since RFC:
> 	1. Throttle only when wake-affine failed. (thanks to PeterZ)
> 	2. Do throttle inside wake_affine(). (thanks to PeterZ)
> 	3. Other small fix.
> 
> Recently testing show that wake-affine stuff cause regression on pgbench, the
> hiding rat was finally catched out.
> 
> wake-affine stuff is always trying to pull wakee close to waker, by theory,
> this will benefit us if waker's cpu cached hot data for wakee, or the extreme
> ping-pong case.
> 
> However, the whole stuff is somewhat blindly, load balance is the only factor
> to be guaranteed, and since the stuff itself is time-consuming, some workload
> suffered, pgbench is just the one who has been found.
> 
> Thus, throttle the wake-affine stuff for such workload is necessary.
> 
> This patch introduced a new knob 'sysctl_sched_wake_affine_interval' with the
> default value 1ms (default minimum balance interval), which means wake-affine
> will keep silent for 1ms after it returned false.
> 
> By turning the new knob, those workload who suffered will have the chance to
> stop the regression.
> 
> Test:
> 	Test with 12 cpu X86 server and tip 3.9.0-rc2.
> 
> 				default
> 		    base	1ms interval	 10ms interval	 100ms interval
> | db_size | clients |  tps  |	|  tps  | 	 |  tps  |	   |  tps  |
> +---------+---------+-------+-  +-------+        +-------+         +-------+
> | 21 MB   |       1 | 10572 |   | 10804 |        | 10802 |         | 10801 |
> | 21 MB   |       2 | 21275 |   | 21533 |        | 21400 |         | 21498 |
> | 21 MB   |       4 | 41866 |   | 42158 |        | 42410 |         | 42306 |
> | 21 MB   |       8 | 53931 |   | 55796 |        | 58608 | +8.67%  | 59916 | +11.10%
> | 21 MB   |      12 | 50956 |   | 52266 |        | 54586 | +7.12%  | 55982 | +9.86%
> | 21 MB   |      16 | 49911 |   | 52862 | +5.91% | 55668 | +11.53% | 57255 | +14.71%
> | 21 MB   |      24 | 46046 |   | 48820 | +6.02% | 54269 | +17.86% | 58113 | +26.21%
> | 21 MB   |      32 | 43405 |   | 46635 | +7.44% | 53690 | +23.70% | 57729 | +33.00%
> | 7483 MB |       1 |  7734 |   |  8013 |        |  8046 |         |  7879 |
> | 7483 MB |       2 | 19375 |   | 19459 |        | 19448 |         | 19421 |
> | 7483 MB |       4 | 37408 |   | 37780 |        | 37937 |         | 37819 |
> | 7483 MB |       8 | 49033 |   | 50389 |        | 51636 | +5.31%  | 52294 | +6.65%
> | 7483 MB |      12 | 45525 |   | 47794 | +4.98% | 49828 | +9.45%  | 50571 | +11.08%
> | 7483 MB |      16 | 45731 |   | 47921 | +4.79% | 50203 | +9.78%  | 52033 | +13.78%
> | 7483 MB |      24 | 41533 |   | 44301 | +6.67% | 49697 | +19.66% | 53833 | +29.62%
> | 7483 MB |      32 | 36370 |   | 38301 | +5.31% | 48146 | +32.38% | 52795 | +45.16%
> | 15 GB   |       1 |  7576 |   |  7926 |        |  7722 |         |  7969 |
> | 15 GB   |       2 | 19157 |   | 19284 |        | 19294 |         | 19304 |
> | 15 GB   |       4 | 37285 |   | 37539 |        | 37281 |         | 37508 |
> | 15 GB   |       8 | 48718 |   | 49176 |        | 50836 | +4.35%  | 51239 | +5.17%
> | 15 GB   |      12 | 45167 |   | 47180 | +4.45% | 49206 | +8.94%  | 50126 | +10.98%
> | 15 GB   |      16 | 45270 |   | 47293 | +4.47% | 49638 | +9.65%  | 51748 | +14.31%
> | 15 GB   |      24 | 40984 |   | 43366 | +5.81% | 49356 | +20.43% | 53157 | +29.70%
> | 15 GB   |      32 | 35918 |   | 37632 | +4.77% | 47923 | +33.42% | 52241 | +45.45%
> 

Add cc list :)

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>
CC: Alex Shi <alex.shi@intel.com>

> Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  include/linux/sched.h |    5 +++++
>  kernel/sched/fair.c   |   31 +++++++++++++++++++++++++++++++
>  kernel/sysctl.c       |   10 ++++++++++
>  3 files changed, 46 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d35d2b6..e9efd3a 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1197,6 +1197,10 @@ enum perf_event_task_context {
>  	perf_nr_task_contexts,
>  };
>  
> +#ifdef CONFIG_SMP
> +extern unsigned int sysctl_sched_wake_affine_interval;
> +#endif
> +
>  struct task_struct {
>  	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
>  	void *stack;
> @@ -1207,6 +1211,7 @@ struct task_struct {
>  #ifdef CONFIG_SMP
>  	struct llist_node wake_entry;
>  	int on_cpu;
> +	unsigned long next_wake_affine;
>  #endif
>  	int on_rq;
>  
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 7a33e59..68eedd7 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3087,6 +3087,22 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
>  
>  #endif
>  
> +/*
> + * Default is 1ms, to prevent the wake_affine() stuff working too frequently.
> + */
> +unsigned int sysctl_sched_wake_affine_interval = 1U;
> +
> +static inline int wake_affine_throttled(struct task_struct *p)
> +{
> +	return time_before(jiffies, p->next_wake_affine);
> +}
> +
> +static inline void wake_affine_throttle(struct task_struct *p)
> +{
> +	p->next_wake_affine = jiffies +
> +			msecs_to_jiffies(sysctl_sched_wake_affine_interval);
> +}
> +
>  static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  {
>  	s64 this_load, load;
> @@ -3096,6 +3112,9 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	unsigned long weight;
>  	int balanced;
>  
> +	if (wake_affine_throttled(p))
> +		return 0;
> +
>  	idx	  = sd->wake_idx;
>  	this_cpu  = smp_processor_id();
>  	prev_cpu  = task_cpu(p);
> @@ -3167,6 +3186,18 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  
>  		return 1;
>  	}
> +
> +	/*
> +	 * wake_affine() stuff try to pull wakee to the cpu
> +	 * around waker, this will benefit us if the data
> +	 * cached on waker cpu is hot for wakee, or the extreme
> +	 * ping-pong case.
> +	 *
> +	 * However, do such blindly work too frequently will
> +	 * cause regression to some workload, thus, each time
> +	 * when wake_affine() failed, throttle it for a while.
> +	 */
> +	wake_affine_throttle(p);
>  	return 0;
>  }
>  
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index afc1dc6..6ebfc18 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -437,6 +437,16 @@ static struct ctl_table kern_table[] = {
>  		.extra1		= &one,
>  	},
>  #endif
> +#ifdef CONFIG_SMP
> +	{
> +		.procname	= "sched_wake_affine_interval",
> +		.data		= &sysctl_sched_wake_affine_interval,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &zero,
> +	},
> +#endif
>  #ifdef CONFIG_PROVE_LOCKING
>  	{
>  		.procname	= "prove_locking",
> 

