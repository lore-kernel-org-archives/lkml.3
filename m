Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3BULDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 06:03:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56359 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3BULDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 06:03:13 -0500
Message-ID: <1361444576.26780.4.camel@laptop>
Subject: Re: [PATCH v2 -tip] sched/rt: Fix locality of threaded interrupt
 handlers
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 21 Feb 2013 12:02:56 +0100
In-Reply-To: <0d651595a85f2393ae5363f155e5b77ebdb6a5e2.1361349058.git.agordeev@redhat.com>
References: <0d651595a85f2393ae5363f155e5b77ebdb6a5e2.1361349058.git.agordeev@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 10:19 +0100, Alexander Gordeev wrote:
> When a interrupt affinity mask targets multiple CPUs, the
> RT scheduler selects a runqueue for RT task corresponding
> to a threaded interrupt handler without consideration of
> where the interrupt is actually gets delivered. It leads
> to a suboptimal condition when a hardware interrupt handler
> executes on one CPU while the threaded interrupt handler
> executes on another CPU.
> 
> This fix alters the behaviour of threaded handler wake-ups
> by getting priority to a CPU where the hardware interrupt
> handler is executing. As result, most of the time both
> halves of interrupt handling are kept local.

This fails to explain the ramifications for the 'global' FIFO push-pull
stuff.

Left patch in-place for Steven.

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  include/linux/sched.h |    2 ++
>  kernel/irq/handle.c   |    2 +-
>  kernel/sched/core.c   |    5 +++++
>  kernel/sched/rt.c     |   27 +++++++++++++++++++--------
>  4 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 206bb08..1d59efa 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1061,6 +1061,7 @@ struct sched_domain;
>  #define WF_SYNC		0x01		/* waker goes to sleep after wakup */
>  #define WF_FORK		0x02		/* child wakeup after fork */
>  #define WF_MIGRATED	0x04		/* internal use, task got migrated */
> +#define WF_LOCAL	0x08		/* try to wake up locally */
>  
>  #define ENQUEUE_WAKEUP		1
>  #define ENQUEUE_HEAD		2
> @@ -2207,6 +2208,7 @@ extern void xtime_update(unsigned long ticks);
>  
>  extern int wake_up_state(struct task_struct *tsk, unsigned int state);
>  extern int wake_up_process(struct task_struct *tsk);
> +extern int wake_up_local(struct task_struct *tsk);
>  extern void wake_up_new_task(struct task_struct *tsk);
>  #ifdef CONFIG_SMP
>   extern void kick_process(struct task_struct *tsk);
> diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
> index 131ca17..fe97d0c 100644
> --- a/kernel/irq/handle.c
> +++ b/kernel/irq/handle.c
> @@ -126,7 +126,7 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
>  	 */
>  	atomic_inc(&desc->threads_active);
>  
> -	wake_up_process(action->thread);
> +	wake_up_local(action->thread);
>  }
>  
>  irqreturn_t
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 257002c..38413f6 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1527,6 +1527,11 @@ int wake_up_process(struct task_struct *p)
>  }
>  EXPORT_SYMBOL(wake_up_process);
>  
> +int wake_up_local(struct task_struct *p)
> +{
> +	return try_to_wake_up(p, TASK_ALL, WF_LOCAL);
> +}
> +
>  int wake_up_state(struct task_struct *p, unsigned int state)
>  {
>  	return try_to_wake_up(p, state, 0);
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 418feb0..de16e16 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1234,7 +1234,7 @@ static void yield_task_rt(struct rq *rq)
>  }
>  
>  #ifdef CONFIG_SMP
> -static int find_lowest_rq(struct task_struct *task);
> +static int find_lowest_rq(struct task_struct *task, bool prefer_this_cpu);
>  
>  static int
>  select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
> @@ -1242,6 +1242,7 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
>  	struct task_struct *curr;
>  	struct rq *rq;
>  	int cpu;
> +	bool prefer_this_cpu = flags & WF_LOCAL;
>  
>  	cpu = task_cpu(p);
>  
> @@ -1258,6 +1259,11 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
>  	curr = ACCESS_ONCE(rq->curr); /* unlocked access */
>  
>  	/*
> +	 * If this RT task is a threaded interrupt handler, then
> +	 * it is being awaken from the hardware interrupt handler.
> +	 * In this case try to keep hardware and threaded interrupt
> +	 * handlers as close as possible and wake it up on this CPU.
> +	 *
>  	 * If the current task on @p's runqueue is an RT task, then
>  	 * try to see if we can wake this RT task up on another
>  	 * runqueue. Otherwise simply start this RT task
> @@ -1279,11 +1285,12 @@ select_task_rq_rt(struct task_struct *p, int sd_flag, int flags)
>  	 * This test is optimistic, if we get it wrong the load-balancer
>  	 * will have to sort it out.
>  	 */
> -	if (curr && unlikely(rt_task(curr)) &&
> -	    (curr->nr_cpus_allowed < 2 ||
> -	     curr->prio <= p->prio) &&
> -	    (p->nr_cpus_allowed > 1)) {
> -		int target = find_lowest_rq(p);
> +	if (prefer_this_cpu ||
> +	    (curr && unlikely(rt_task(curr)) &&
> +	     (curr->nr_cpus_allowed < 2 ||
> +	      curr->prio <= p->prio) &&
> +	     (p->nr_cpus_allowed > 1))) {
> +		int target = find_lowest_rq(p, prefer_this_cpu);
>  
>  		if (target != -1)
>  			cpu = target;
> @@ -1473,7 +1480,7 @@ next_idx:
>  
>  static DEFINE_PER_CPU(cpumask_var_t, local_cpu_mask);
>  
> -static int find_lowest_rq(struct task_struct *task)
> +static int find_lowest_rq(struct task_struct *task, bool prefer_this_cpu)
>  {
>  	struct sched_domain *sd;
>  	struct cpumask *lowest_mask = __get_cpu_var(local_cpu_mask);
> @@ -1495,9 +1502,13 @@ static int find_lowest_rq(struct task_struct *task)
>  	 * lowest priority tasks in the system.  Now we want to elect
>  	 * the best one based on our affinity and topology.
>  	 *
> +	 * If asked explicitly, try to pick up this cpu.
> +	 *
>  	 * We prioritize the last cpu that the task executed on since
>  	 * it is most likely cache-hot in that location.
>  	 */
> +	if (prefer_this_cpu && cpumask_test_cpu(this_cpu, lowest_mask))
> +		return this_cpu;
>  	if (cpumask_test_cpu(cpu, lowest_mask))
>  		return cpu;
>  
> @@ -1555,7 +1566,7 @@ static struct rq *find_lock_lowest_rq(struct task_struct *task, struct rq *rq)
>  	int cpu;
>  
>  	for (tries = 0; tries < RT_MAX_TRIES; tries++) {
> -		cpu = find_lowest_rq(task);
> +		cpu = find_lowest_rq(task, false);
>  
>  		if ((cpu == -1) || (cpu == rq->cpu))
>  			break;
> -- 
> 1.7.7.6
> 
> 


