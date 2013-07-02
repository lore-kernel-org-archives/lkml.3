Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab3GBIwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:52:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40673 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab3GBIwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:52:13 -0400
Date: Tue, 2 Jul 2013 10:52:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH] sched: smart wake-affine
Message-ID: <20130702085202.GA23916@twins.programming.kicks-ass.net>
References: <51A43B16.9080801@linux.vnet.ibm.com>
 <51D25A80.8090406@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51D25A80.8090406@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 12:43:44PM +0800, Michael Wang wrote:

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
> index c61a614..591c113 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3109,6 +3109,45 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
>  
>  #endif
>  
> +static void record_wakee(struct task_struct *p)
> +{
> +	/*
> +	 * Rough decay, don't worry about the boundary, really active
> +	 * task won't care the loose.
> +	 */

OK so we 'decay' once a second.

> +	if (jiffies > current->last_switch_decay + HZ) {
> +		current->nr_wakee_switch = 0;
> +		current->last_switch_decay = jiffies;
> +	}

This isn't so much a decay as it is wiping state. Did you try an actual
decay -- something like: current->nr_wakee_switch >>= 1; ?

I suppose you wanted to avoid something like:

  now = jiffies;
  while (now > current->last_switch_decay + HZ) {
  	current->nr_wakee_switch >>= 1;
	current->last_switch_decay += HZ;
  }

?

And we increment every time we wake someone else. Gaining a measure of
how often we wake someone else.

> +	if (current->last_wakee != p) {
> +		current->last_wakee = p;
> +		current->nr_wakee_switch++;
> +	}
> +}
> +
> +static int nasty_pull(struct task_struct *p)

I've seen there's some discussion as to this function name.. good :-) It
really wants to change. How about something like:

int wake_affine()
{
  ...

  /*
   * If we wake multiple tasks be careful to not bounce
   * ourselves around too much.
   */
  if (wake_wide(p))
  	return 0;


> +{
> +	int factor = cpumask_weight(cpu_online_mask);

We have num_cpus_online() for this.. however both are rather expensive.
Having to walk and count a 4096 bitmap for every wakeup if going to get
tiresome real quick.

I suppose the question is; to what level do we really want to scale?

One fair answer would be node size I suppose; do you really want to go
bigger than that?

Also; you compare a size against a switching frequency, that's not
really and apples to apples comparison.

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

Ah ok, this makes more sense; the first is simply a filter to avoid
doing the second dereference I suppose.

> +	}
> +
> +	return 0;
> +}
> +
>  static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  {
>  	s64 this_load, load;
> @@ -3118,6 +3157,9 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	unsigned long weight;
>  	int balanced;
>  
> +	if (nasty_pull(p))
> +		return 0;
> +
>  	idx	  = sd->wake_idx;
>  	this_cpu  = smp_processor_id();
>  	prev_cpu  = task_cpu(p);
> @@ -3410,6 +3452,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>  		/* while loop will break here if sd == NULL */
>  	}
>  unlock:
> +	if (sd_flag & SD_BALANCE_WAKE)
> +		record_wakee(p);

if we put this in task_waking_fair() we can avoid an entire conditional!

