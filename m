Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947577Ab3BIAdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:33:16 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35076 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947344Ab3BIAdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:33:11 -0500
Date: Fri, 8 Feb 2013 16:33:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 02/40] stop_machine: Store task reference in a separate
 per cpu variable
Message-ID: <20130209003302.GW2666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130131120348.372374706@linutronix.de>
 <20130131120741.626690384@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131120741.626690384@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020900-7182-0000-0000-00000515B21E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:11:13PM -0000, Thomas Gleixner wrote:
> To allow the stopper thread being managed by the smpboot thread
> infrastructure separate out the task storage from the stopper data
> structure.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  kernel/stop_machine.c |   32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> Index: linux-2.6/kernel/stop_machine.c
> ===================================================================
> --- linux-2.6.orig/kernel/stop_machine.c
> +++ linux-2.6/kernel/stop_machine.c
> @@ -37,10 +37,10 @@ struct cpu_stopper {
>  	spinlock_t		lock;
>  	bool			enabled;	/* is this stopper enabled? */
>  	struct list_head	works;		/* list of pending works */
> -	struct task_struct	*thread;	/* stopper thread */
>  };
> 
>  static DEFINE_PER_CPU(struct cpu_stopper, cpu_stopper);
> +static DEFINE_PER_CPU(struct task_struct *, cpu_stopper_task);
>  static bool stop_machine_initialized = false;
> 
>  static void cpu_stop_init_done(struct cpu_stop_done *done, unsigned int nr_todo)
> @@ -62,16 +62,18 @@ static void cpu_stop_signal_done(struct 
>  }
> 
>  /* queue @work to @stopper.  if offline, @work is completed immediately */
> -static void cpu_stop_queue_work(struct cpu_stopper *stopper,
> -				struct cpu_stop_work *work)
> +static void cpu_stop_queue_work(unsigned int cpu, struct cpu_stop_work *work)
>  {
> +	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
> +	struct task_struct *p = per_cpu(cpu_stopper_task, cpu);
> +
>  	unsigned long flags;
> 
>  	spin_lock_irqsave(&stopper->lock, flags);
> 
>  	if (stopper->enabled) {
>  		list_add_tail(&work->list, &stopper->works);
> -		wake_up_process(stopper->thread);
> +		wake_up_process(p);
>  	} else
>  		cpu_stop_signal_done(work->done, false);
> 
> @@ -108,7 +110,7 @@ int stop_one_cpu(unsigned int cpu, cpu_s
>  	struct cpu_stop_work work = { .fn = fn, .arg = arg, .done = &done };
> 
>  	cpu_stop_init_done(&done, 1);
> -	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), &work);
> +	cpu_stop_queue_work(cpu, &work);
>  	wait_for_completion(&done.completion);
>  	return done.executed ? done.ret : -ENOENT;
>  }
> @@ -130,7 +132,7 @@ void stop_one_cpu_nowait(unsigned int cp
>  			struct cpu_stop_work *work_buf)
>  {
>  	*work_buf = (struct cpu_stop_work){ .fn = fn, .arg = arg, };
> -	cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu), work_buf);
> +	cpu_stop_queue_work(cpu, work_buf);
>  }
> 
>  /* static data for stop_cpus */
> @@ -159,8 +161,7 @@ static void queue_stop_cpus_work(const s
>  	 */
>  	preempt_disable();
>  	for_each_cpu(cpu, cpumask)
> -		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
> -				    &per_cpu(stop_cpus_work, cpu));
> +		cpu_stop_queue_work(cpu, &per_cpu(stop_cpus_work, cpu));
>  	preempt_enable();
>  }
> 
> @@ -304,12 +305,11 @@ static int __cpuinit cpu_stop_cpu_callba
>  {
>  	unsigned int cpu = (unsigned long)hcpu;
>  	struct cpu_stopper *stopper = &per_cpu(cpu_stopper, cpu);
> -	struct task_struct *p;
> +	struct task_struct *p = per_cpu(cpu_stopper_task, cpu);
> 
>  	switch (action & ~CPU_TASKS_FROZEN) {
>  	case CPU_UP_PREPARE:
> -		BUG_ON(stopper->thread || stopper->enabled ||
> -		       !list_empty(&stopper->works));
> +		BUG_ON(p || stopper->enabled || !list_empty(&stopper->works));
>  		p = kthread_create_on_node(cpu_stopper_thread,
>  					   stopper,
>  					   cpu_to_node(cpu),
> @@ -319,12 +319,12 @@ static int __cpuinit cpu_stop_cpu_callba
>  		get_task_struct(p);
>  		kthread_bind(p, cpu);
>  		sched_set_stop_task(cpu, p);
> -		stopper->thread = p;
> +		per_cpu(cpu_stopper_task, cpu) = p;
>  		break;
> 
>  	case CPU_ONLINE:
>  		/* strictly unnecessary, as first user will wake it */
> -		wake_up_process(stopper->thread);
> +		wake_up_process(p);
>  		/* mark enabled */
>  		spin_lock_irq(&stopper->lock);
>  		stopper->enabled = true;
> @@ -339,7 +339,7 @@ static int __cpuinit cpu_stop_cpu_callba
> 
>  		sched_set_stop_task(cpu, NULL);
>  		/* kill the stopper */
> -		kthread_stop(stopper->thread);
> +		kthread_stop(p);
>  		/* drain remaining works */
>  		spin_lock_irq(&stopper->lock);
>  		list_for_each_entry(work, &stopper->works, list)
> @@ -347,8 +347,8 @@ static int __cpuinit cpu_stop_cpu_callba
>  		stopper->enabled = false;
>  		spin_unlock_irq(&stopper->lock);
>  		/* release the stopper */
> -		put_task_struct(stopper->thread);
> -		stopper->thread = NULL;
> +		put_task_struct(p);
> +		per_cpu(cpu_stopper_task, cpu) = NULL;
>  		break;
>  	}
>  #endif
> 
> 

