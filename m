Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab3FCC3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:29:18 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43048 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab3FCC3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:29:11 -0400
Message-ID: <51ABFF6A.60206@linux.vnet.ibm.com>
Date: Mon, 03 Jun 2013 10:28:58 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [RFC PATCH] sched: smart wake-affine
References: <51A43B16.9080801@linux.vnet.ibm.com>
In-Reply-To: <51A43B16.9080801@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060302-6102-0000-0000-000003A0A5D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 01:05 PM, Michael Wang wrote:
> wake-affine stuff is always trying to pull wakee close to waker, by theory,
> this will bring benefit if waker's cpu cached hot data for wakee, or the
> extreme ping-pong case.
> 
> And testing show it could benefit hackbench 15% at most.
> 
> However, the whole stuff is somewhat blindly and time-consuming, some
> workload therefore suffer.
> 
> And testing show it could damage pgbench 50% at most.
> 
> Thus, wake-affine stuff should be smarter, and realise when to stop
> it's thankless effort.

Is there any comments?

Peter, do you have any comments on this idea? Is this the kind of fix we
are looking for? I think you mentioned we want some kind of filter
rather than the knob, correct?

Folks, please let me know your concerns so I could help on the research
work :)

Regards,
Michael Wang


> 
> This patch introduced per task 'nr_wakee_switch', which will be increased
> each time the task switch it's wakee.
> 
> So a high 'nr_wakee_switch' means the task has more than one wakee, and
> less the wakee number, higher the wakeup frequency.
> 
> Now when making the decision on whether to pull or not, pay attention on
> the wakee with a high 'nr_wakee_switch', pull such task may benefit wakee,
> but that imply waker will face cruel competition later, it could be very
> crule or very fast depends on the story behind 'nr_wakee_switch', whatever,
> waker therefore suffer.
> 
> Furthermore, if waker also has a high 'nr_wakee_switch', that imply multiple
> tasks rely on it, waker's higher latency will damage all those tasks, pull
> wakee in such cases seems to be a bad deal.
> 
> Thus, when 'waker->nr_wakee_switch / wakee->nr_wakee_switch' become higher
> and higher, the deal seems to be worse and worse.
> 
> This patch therefore help wake-affine stuff to stop it's work when:
> 
> 	wakee->nr_wakee_switch > factor &&
> 	waker->nr_wakee_switch > (factor * wakee->nr_wakee_switch)
> 
> The factor here is the online cpu number, so more cpu will lead to more pull
> since the trial become more severe.
> 
> After applied the patch, pgbench show 42% improvement at most.
> 
> Test:
> 	Test with 12 cpu X86 server and tip 3.10.0-rc1.
> 
> 				base	smart
> 
> 	| db_size | clients |  tps  | |  tps  |
> 	+---------+---------+-------+ +-------+
> 	| 21 MB   |       1 | 10749 | | 10337 |
> 	| 21 MB   |       2 | 21382 | | 21391 |
> 	| 21 MB   |       4 | 41570 | | 41808 |
> 	| 21 MB   |       8 | 52828 | | 58792 |
> 	| 21 MB   |      12 | 48447 | | 54553 |
> 	| 21 MB   |      16 | 46246 | | 56726 |	+22.66%
> 	| 21 MB   |      24 | 43850 | | 56853 |	+29.65%
> 	| 21 MB   |      32 | 43455 | | 55846 |	+28.51%
> 	| 7483 MB |       1 |  9290 | |  8848 |
> 	| 7483 MB |       2 | 19347 | | 19351 |
> 	| 7483 MB |       4 | 37135 | | 37511 |
> 	| 7483 MB |       8 | 47310 | | 50210 |
> 	| 7483 MB |      12 | 42721 | | 49396 |
> 	| 7483 MB |      16 | 41016 | | 51826 |	+26.36%
> 	| 7483 MB |      24 | 37540 | | 52579 |	+40.06%
> 	| 7483 MB |      32 | 36756 | | 51332 |	+39.66%
> 	| 15 GB   |       1 |  8758 | |  8670 |
> 	| 15 GB   |       2 | 19204 | | 19249 |
> 	| 15 GB   |       4 | 36997 | | 37199 |
> 	| 15 GB   |       8 | 46578 | | 50681 |
> 	| 15 GB   |      12 | 42141 | | 48671 |
> 	| 15 GB   |      16 | 40518 | | 51280 |	+26.56%
> 	| 15 GB   |      24 | 36788 | | 52329 |	+42.24%
> 	| 15 GB   |      32 | 36056 | | 50350 | +39.64%
> 
> 
> 
> CC: Ingo Molnar <mingo@kernel.org>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  include/linux/sched.h |    3 +++
>  kernel/sched/fair.c   |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 178a8d9..1c996c7 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1041,6 +1041,9 @@ struct task_struct {
>  #ifdef CONFIG_SMP
>  	struct llist_node wake_entry;
>  	int on_cpu;
> +	struct task_struct *last_wakee;
> +	unsigned long nr_wakee_switch;
> +	unsigned long last_switch_decay;
>  #endif
>  	int on_rq;
>  
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index f62b16d..eaaceb7 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3127,6 +3127,45 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
>  
>  #endif
>  
> +static void record_wakee(struct task_struct *p)
> +{
> +	/*
> +	 * Rough decay, don't worry about the boundary, really active
> +	 * task won't care the loose.
> +	 */
> +	if (jiffies > current->last_switch_decay + HZ) {
> +		current->nr_wakee_switch = 0;
> +		current->last_switch_decay = jiffies;
> +	}
> +
> +	if (current->last_wakee != p) {
> +		current->last_wakee = p;
> +		current->nr_wakee_switch++;
> +	}
> +}
> +
> +static int nasty_pull(struct task_struct *p)
> +{
> +	int factor = cpumask_weight(cpu_online_mask);
> +
> +	/*
> +	 * Yeah, it's the switching-frequency, could means many wakee or
> +	 * rapidly switch, use factor here will just help to automatically
> +	 * adjust the loose-degree, so more cpu will lead to more pull.
> +	 */
> +	if (p->nr_wakee_switch > factor) {
> +		/*
> +		 * wakee is somewhat hot, it needs certain amount of cpu
> +		 * resource, so if waker is far more hot, prefer to leave
> +		 * it alone.
> +		 */
> +		if (current->nr_wakee_switch > (factor * p->nr_wakee_switch))
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  {
>  	s64 this_load, load;
> @@ -3136,6 +3175,9 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	unsigned long weight;
>  	int balanced;
>  
> +	if (nasty_pull(p))
> +		return 0;
> +
>  	idx	  = sd->wake_idx;
>  	this_cpu  = smp_processor_id();
>  	prev_cpu  = task_cpu(p);
> @@ -3428,6 +3470,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  		/* while loop will break here if sd == NULL */
>  	}
>  unlock:
> +	if (sd_flag & SD_BALANCE_WAKE)
> +		record_wakee(p);
> +
>  	rcu_read_unlock();
>  
>  	return new_cpu;
> 

