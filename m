Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab3IXOmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 10:42:47 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52219 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860Ab3IXOmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 10:42:45 -0400
Date: Tue, 24 Sep 2013 07:42:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130924144236.GB9093@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
 <1378805550-29949-38-git-send-email-mgorman@suse.de>
 <20130917143003.GA29354@twins.programming.kicks-ass.net>
 <20130917162050.GK22421@suse.de>
 <20130917164505.GG12926@twins.programming.kicks-ass.net>
 <20130918154939.GZ26785@twins.programming.kicks-ass.net>
 <20130919143241.GB26785@twins.programming.kicks-ass.net>
 <20130923175052.GA20991@redhat.com>
 <20130924123821.GT12926@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924123821.GT12926@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092414-5806-0000-0000-000022D54028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 02:38:21PM +0200, Peter Zijlstra wrote:
> 
> OK, so another attempt.
> 
> This one is actually fair in that it immediately forces a reader
> quiescent state by explicitly implementing reader-reader recursion.
> 
> This does away with the potentially long pending writer case and can
> thus use the simpler global state.
> 
> I don't really like this lock being fair, but alas.
> 
> Also, please have a look at the atomic_dec_and_test(cpuhp_waitcount) and
> cpu_hotplug_done(). I think its ok, but I keep confusing myself.

Cute!

Some commentary below.  Also one question about how a race leading to
a NULL-pointer dereference is avoided.

							Thanx, Paul

> ---
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -16,6 +16,7 @@
>  #include <linux/node.h>
>  #include <linux/compiler.h>
>  #include <linux/cpumask.h>
> +#include <linux/percpu.h>
> 
>  struct device;
> 
> @@ -173,10 +174,49 @@ extern struct bus_type cpu_subsys;
>  #ifdef CONFIG_HOTPLUG_CPU
>  /* Stop CPUs going up and down. */
> 
> +extern void cpu_hotplug_init_task(struct task_struct *p);
> +
>  extern void cpu_hotplug_begin(void);
>  extern void cpu_hotplug_done(void);
> -extern void get_online_cpus(void);
> -extern void put_online_cpus(void);
> +
> +extern int __cpuhp_writer;
> +DECLARE_PER_CPU(unsigned int, __cpuhp_refcount);
> +
> +extern void __get_online_cpus(void);
> +
> +static inline void get_online_cpus(void)
> +{
> +	might_sleep();
> +
> +	if (current->cpuhp_ref++) {
> +		barrier();
> +		return;
> +	}
> +
> +	preempt_disable();
> +	if (likely(!__cpuhp_writer))
> +		__this_cpu_inc(__cpuhp_refcount);
> +	else
> +		__get_online_cpus();
> +	preempt_enable();
> +}
> +
> +extern void __put_online_cpus(void);
> +
> +static inline void put_online_cpus(void)
> +{
> +	barrier();
> +	if (--current->cpuhp_ref)
> +		return;
> +
> +	preempt_disable();
> +	if (likely(!__cpuhp_writer))
> +		__this_cpu_dec(__cpuhp_refcount);
> +	else
> +		__put_online_cpus();
> +	preempt_enable();
> +}
> +
>  extern void cpu_hotplug_disable(void);
>  extern void cpu_hotplug_enable(void);
>  #define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
> @@ -200,6 +240,8 @@ static inline void cpu_hotplug_driver_un
> 
>  #else		/* CONFIG_HOTPLUG_CPU */
> 
> +static inline void cpu_hotplug_init_task(struct task_struct *p) {}
> +
>  static inline void cpu_hotplug_begin(void) {}
>  static inline void cpu_hotplug_done(void) {}
>  #define get_online_cpus()	do { } while (0)
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1454,6 +1454,9 @@ struct task_struct {
>  	unsigned int	sequential_io;
>  	unsigned int	sequential_io_avg;
>  #endif
> +#ifdef CONFIG_HOTPLUG_CPU
> +	int		cpuhp_ref;
> +#endif
>  };
> 
>  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -49,88 +49,115 @@ static int cpu_hotplug_disabled;
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> 
> -static struct {
> -	struct task_struct *active_writer;
> -	struct mutex lock; /* Synchronizes accesses to refcount, */
> -	/*
> -	 * Also blocks the new readers during
> -	 * an ongoing cpu hotplug operation.
> -	 */
> -	int refcount;
> -} cpu_hotplug = {
> -	.active_writer = NULL,
> -	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
> -	.refcount = 0,
> -};
> +static struct task_struct *cpuhp_writer_task = NULL;
> 
> -void get_online_cpus(void)
> -{
> -	might_sleep();
> -	if (cpu_hotplug.active_writer == current)
> -		return;
> -	mutex_lock(&cpu_hotplug.lock);
> -	cpu_hotplug.refcount++;
> -	mutex_unlock(&cpu_hotplug.lock);
> +int __cpuhp_writer;
> +EXPORT_SYMBOL_GPL(__cpuhp_writer);
> 
> +DEFINE_PER_CPU(unsigned int, __cpuhp_refcount);
> +EXPORT_PER_CPU_SYMBOL_GPL(__cpuhp_refcount);
> +
> +static atomic_t cpuhp_waitcount;
> +static atomic_t cpuhp_slowcount;
> +static DECLARE_WAIT_QUEUE_HEAD(cpuhp_wq);
> +
> +void cpu_hotplug_init_task(struct task_struct *p)
> +{
> +	p->cpuhp_ref = 0;
>  }
> -EXPORT_SYMBOL_GPL(get_online_cpus);
> 
> -void put_online_cpus(void)
> +#define cpuhp_writer_wake()						\
> +	wake_up_process(cpuhp_writer_task)
> +
> +#define cpuhp_writer_wait(cond)						\
> +do {									\
> +	for (;;) {							\
> +		set_current_state(TASK_UNINTERRUPTIBLE);		\
> +		if (cond)						\
> +			break;						\
> +		schedule();						\
> +	}								\
> +	__set_current_state(TASK_RUNNING);				\
> +} while (0)

Why not wait_event()?  Presumably the above is a bit lighter weight,
but is that even something that can be measured?

> +void __get_online_cpus(void)
>  {
> -	if (cpu_hotplug.active_writer == current)
> +	if (cpuhp_writer_task == current)
>  		return;
> -	mutex_lock(&cpu_hotplug.lock);
> 
> -	if (WARN_ON(!cpu_hotplug.refcount))
> -		cpu_hotplug.refcount++; /* try to fix things up */
> +	atomic_inc(&cpuhp_waitcount);
> +
> +	/*
> +	 * We either call schedule() in the wait, or we'll fall through
> +	 * and reschedule on the preempt_enable() in get_online_cpus().
> +	 */
> +	preempt_enable_no_resched();
> +	wait_event(cpuhp_wq, !__cpuhp_writer);

Finally!  A good use for preempt_enable_no_resched().  ;-)

> +	preempt_disable();
> +
> +	/*
> +	 * It would be possible for cpu_hotplug_done() to complete before
> +	 * the atomic_inc() above; in which case there is no writer waiting
> +	 * and doing a wakeup would be BAD (tm).
> +	 *
> +	 * If however we still observe cpuhp_writer_task here we know
> +	 * cpu_hotplug_done() is currently stuck waiting for cpuhp_waitcount.
> +	 */
> +	if (atomic_dec_and_test(&cpuhp_waitcount) && cpuhp_writer_task)

OK, I'll bite...  What sequence of events results in the
atomic_dec_and_test() returning true but there being no
cpuhp_writer_task?

Ah, I see it...

o	Task A becomes the writer.

o	Task B tries to read, but stalls for whatever reason before
	the atomic_inc().

o	Task A completes its write-side operation.  It sees no readers
	blocked, so goes on its merry way.

o	Task B does its atomic_inc(), does its read, then sees
	atomic_dec_and_test() return zero, but cpuhp_writer_task
	is NULL, so it doesn't do the wakeup.

But what prevents the following sequence of events?

o	Task A becomes the writer.

o	Task B tries to read, but stalls for whatever reason before
	the atomic_inc().

o	Task A completes its write-side operation.  It sees no readers
	blocked, so goes on its merry way, but is delayed before it
	NULLs cpuhp_writer_task.

o	Task B does its atomic_inc(), does its read, then sees
	atomic_dec_and_test() return zero.  However, it sees
	cpuhp_writer_task as non-NULL.

o	Then Task A NULLs cpuhp_writer_task.

o	Task B's call to cpuhp_writer_wake() sees a NULL pointer.

> +		cpuhp_writer_wake();
> +}
> +EXPORT_SYMBOL_GPL(__get_online_cpus);
> 
> -	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
> -		wake_up_process(cpu_hotplug.active_writer);
> -	mutex_unlock(&cpu_hotplug.lock);
> +void __put_online_cpus(void)
> +{
> +	if (cpuhp_writer_task == current)
> +		return;
> 
> +	if (atomic_dec_and_test(&cpuhp_slowcount))
> +		cpuhp_writer_wake();
>  }
> -EXPORT_SYMBOL_GPL(put_online_cpus);
> +EXPORT_SYMBOL_GPL(__put_online_cpus);
> 
>  /*
>   * This ensures that the hotplug operation can begin only when the
>   * refcount goes to zero.
>   *
> - * Note that during a cpu-hotplug operation, the new readers, if any,
> - * will be blocked by the cpu_hotplug.lock
> - *
>   * Since cpu_hotplug_begin() is always called after invoking
>   * cpu_maps_update_begin(), we can be sure that only one writer is active.
> - *
> - * Note that theoretically, there is a possibility of a livelock:
> - * - Refcount goes to zero, last reader wakes up the sleeping
> - *   writer.
> - * - Last reader unlocks the cpu_hotplug.lock.
> - * - A new reader arrives at this moment, bumps up the refcount.
> - * - The writer acquires the cpu_hotplug.lock finds the refcount
> - *   non zero and goes to sleep again.
> - *
> - * However, this is very difficult to achieve in practice since
> - * get_online_cpus() not an api which is called all that often.
> - *
>   */
>  void cpu_hotplug_begin(void)
>  {
> -	cpu_hotplug.active_writer = current;
> +	unsigned int count = 0;
> +	int cpu;
> +
> +	lockdep_assert_held(&cpu_add_remove_lock);
> 
> -	for (;;) {
> -		mutex_lock(&cpu_hotplug.lock);
> -		if (likely(!cpu_hotplug.refcount))
> -			break;
> -		__set_current_state(TASK_UNINTERRUPTIBLE);
> -		mutex_unlock(&cpu_hotplug.lock);
> -		schedule();
> +	__cpuhp_writer = 1;
> +	cpuhp_writer_task = current;

At this point, the value of cpuhp_slowcount can go negative.  Can't see
that this causes a problem, given the atomic_add() below.

> +
> +	/* After this everybody will observe writer and take the slow path. */
> +	synchronize_sched();
> +
> +	/* Collapse the per-cpu refcount into slowcount */
> +	for_each_possible_cpu(cpu) {
> +		count += per_cpu(__cpuhp_refcount, cpu);
> +		per_cpu(__cpuhp_refcount, cpu) = 0;
>  	}

The above is safe because the readers are no longer changing their
__cpuhp_refcount values.

> +	atomic_add(count, &cpuhp_slowcount);
> +
> +	/* Wait for all readers to go away */
> +	cpuhp_writer_wait(!atomic_read(&cpuhp_slowcount));
>  }
> 
>  void cpu_hotplug_done(void)
>  {
> -	cpu_hotplug.active_writer = NULL;
> -	mutex_unlock(&cpu_hotplug.lock);
> +	/* Signal the writer is done */
> +	cpuhp_writer = 0;
> +	wake_up_all(&cpuhp_wq);
> +
> +	/* Wait for any pending readers to be running */
> +	cpuhp_writer_wait(!atomic_read(&cpuhp_waitcount));
> +	cpuhp_writer_task = NULL;
>  }
> 
>  /*
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1736,6 +1736,8 @@ static void __sched_fork(unsigned long c
>  	INIT_LIST_HEAD(&p->numa_entry);
>  	p->numa_group = NULL;
>  #endif /* CONFIG_NUMA_BALANCING */
> +
> +	cpu_hotplug_init_task(p);
>  }
> 
>  #ifdef CONFIG_NUMA_BALANCING
> 

