Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbaIRRjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:39:36 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52524 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaIRRjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:39:35 -0400
Date: Thu, 18 Sep 2014 10:39:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v2 1/2] sched: let the scheduler see CPU idle states
Message-ID: <20140918173925.GA7337@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1409844730-12273-1-git-send-email-nicolas.pitre@linaro.org>
 <1409844730-12273-2-git-send-email-nicolas.pitre@linaro.org>
 <20140918173733.GQ4723@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140918173733.GQ4723@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091817-6688-0000-0000-000004EADBF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 10:37:33AM -0700, Paul E. McKenney wrote:
> On Thu, Sep 04, 2014 at 11:32:09AM -0400, Nicolas Pitre wrote:
> > From: Daniel Lezcano <daniel.lezcano@linaro.org>
> > 
> > When the cpu enters idle, it stores the cpuidle state pointer in its
> > struct rq instance which in turn could be used to make a better decision
> > when balancing tasks.
> > 
> > As soon as the cpu exits its idle state, the struct rq reference is
> > cleared.
> > 
> > There are a couple of situations where the idle state pointer could be changed
> > while it is being consulted:
> > 
> > 1. For x86/acpi with dynamic c-states, when a laptop switches from battery
> >    to AC that could result on removing the deeper idle state. The acpi driver
> >    triggers:
> > 	'acpi_processor_cst_has_changed'
> > 		'cpuidle_pause_and_lock'
> > 			'cpuidle_uninstall_idle_handler'
> > 				'kick_all_cpus_sync'.
> > 
> > All cpus will exit their idle state and the pointed object will be set to
> > NULL.
> > 
> > 2. The cpuidle driver is unloaded. Logically that could happen but not
> > in practice because the drivers are always compiled in and 95% of them are
> > not coded to unregister themselves.  In any case, the unloading code must
> > call 'cpuidle_unregister_device', that calls 'cpuidle_pause_and_lock'
> > leading to 'kick_all_cpus_sync' as mentioned above.
> > 
> > A race can happen if we use the pointer and then one of these two scenarios
> > occurs at the same moment.
> > 
> > In order to be safe, the idle state pointer stored in the rq must be
> > used inside a rcu_read_lock section where we are protected with the
> > 'rcu_barrier' in the 'cpuidle_uninstall_idle_handler' function. The
> > idle_get_state() and idle_put_state() accessors should be used to that
> > effect.
> > 
> > Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Signed-off-by: Nicolas Pitre <nico@linaro.org>
> > ---
> >  drivers/cpuidle/cpuidle.c |  6 ++++++
> >  kernel/sched/idle.c       |  6 ++++++
> >  kernel/sched/sched.h      | 39 +++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 51 insertions(+)
> > 
> > diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> > index ee9df5e3f5..530e3055a2 100644
> > --- a/drivers/cpuidle/cpuidle.c
> > +++ b/drivers/cpuidle/cpuidle.c
> > @@ -225,6 +225,12 @@ void cpuidle_uninstall_idle_handler(void)
> >  		initialized = 0;
> >  		kick_all_cpus_sync();
> >  	}
> > +
> > +	/*
> > +	 * Make sure external observers (such as the scheduler)
> > +	 * are done looking at pointed idle states.
> > +	 */
> > +	rcu_barrier();
> 
> Actually, all rcu_barrier() does is to make sure that all previously
> queued RCU callbacks have been invoked.  And given the current
> implementation, if there are no callbacks queued anywhere in the system,
> rcu_barrier() is an extended no-op.  "Has CPU 0 any callbacks?" "Nope!"
> "Has CPU 1 any callbacks?"  "Nope!" ... "Has CPU nr_cpu_ids-1 any
> callbacks?"  "Nope!"  "OK, done!"
> 
> This is all done with the current task looking at per-CPU data structures,
> with no interaction with the scheduler and with no need to actually make
> those other CPUs do anything.
> 
> So what is it that you really need to do here?
> 
> A synchronize_sched() will wait for all non-idle online CPUs to pass
> through the scheduler, where "idle" includes usermode execution in
> CONFIG_NO_HZ_FULL=y kernels.  But it won't wait for CPUs executing
> in the idle loop.
> 
> A synchronize_rcu_tasks() will wait for all non-idle tasks that are
> currently on a runqueue to do a voluntary context switch.  There has
> been some discussion about extending this to idle tasks, but the current
> prospective users can live without this.  But if you need it, I can push
> on getting it set up.  (Current plans are that synchronize_rcu_tasks()
> goes into the v3.18 merge window.)  And one caveat: There is long
> latency associated with synchronize_rcu_tasks() by design.  Grace
> periods are measured in seconds.
> 
> A stop_cpus() will force a context switch on all CPUs, though it is
> a rather big hammer.

And I was reminded by the very next email that kick_all_cpus_sync() is
another possibility -- it forces an interrupt on all online CPUs, idle
or not.

							Thanx, Paul

> So again, what do you really need?
> 
> 							Thanx, Paul
> 
> >  }
> > 
> >  /**
> > diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> > index 11e7bc434f..c47fce75e6 100644
> > --- a/kernel/sched/idle.c
> > +++ b/kernel/sched/idle.c
> > @@ -147,6 +147,9 @@ use_default:
> >  	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
> >  		goto use_default;
> > 
> > +	/* Take note of the planned idle state. */
> > +	idle_set_state(this_rq(), &drv->states[next_state]);
> > +
> >  	/*
> >  	 * Enter the idle state previously returned by the governor decision.
> >  	 * This function will block until an interrupt occurs and will take
> > @@ -154,6 +157,9 @@ use_default:
> >  	 */
> >  	entered_state = cpuidle_enter(drv, dev, next_state);
> > 
> > +	/* The cpu is no longer idle or about to enter idle. */
> > +	idle_set_state(this_rq(), NULL);
> > +
> >  	if (broadcast)
> >  		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
> > 
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index 579712f4e9..aea8baa7a5 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -14,6 +14,7 @@
> >  #include "cpuacct.h"
> > 
> >  struct rq;
> > +struct cpuidle_state;
> > 
> >  extern __read_mostly int scheduler_running;
> > 
> > @@ -636,6 +637,11 @@ struct rq {
> >  #ifdef CONFIG_SMP
> >  	struct llist_head wake_list;
> >  #endif
> > +
> > +#ifdef CONFIG_CPU_IDLE
> > +	/* Must be inspected within a rcu lock section */
> > +	struct cpuidle_state *idle_state;
> > +#endif
> >  };
> > 
> >  static inline int cpu_of(struct rq *rq)
> > @@ -1180,6 +1186,39 @@ static inline void idle_exit_fair(struct rq *rq) { }
> > 
> >  #endif
> > 
> > +#ifdef CONFIG_CPU_IDLE
> > +static inline void idle_set_state(struct rq *rq,
> > +				  struct cpuidle_state *idle_state)
> > +{
> > +	rq->idle_state = idle_state;
> > +}
> > +
> > +static inline struct cpuidle_state *idle_get_state(struct rq *rq)
> > +{
> > +	rcu_read_lock();
> > +	return rq->idle_state;
> > +}
> > +
> > +static inline void cpuidle_put_state(struct rq *rq)
> > +{
> > +	rcu_read_unlock();
> > +}
> > +#else
> > +static inline void idle_set_state(struct rq *rq,
> > +				  struct cpuidle_state *idle_state)
> > +{
> > +}
> > +
> > +static inline struct cpuidle_state *idle_get_state(struct rq *rq)
> > +{
> > +	return NULL;
> > +}
> > +
> > +static inline void cpuidle_put_state(struct rq *rq)
> > +{
> > +}
> > +#endif
> > +
> >  extern void sysrq_sched_debug_show(void);
> >  extern void sched_init_granularity(void);
> >  extern void update_max_interval(void);
> > -- 
> > 1.8.4.108.g55ea5f6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 

