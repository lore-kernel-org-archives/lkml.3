Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaFMP6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:58:20 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44854 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaFMP6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:58:17 -0400
Date: Fri, 13 Jun 2014 08:58:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu: Only pin GP kthread when full dynticks is actually
 used
Message-ID: <20140613155812.GO4581@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1402618619-32630-1-git-send-email-fweisbec@gmail.com>
 <20140613012432.GH4581@linux.vnet.ibm.com>
 <20140613124207.GB6635@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613124207.GB6635@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061315-1542-0000-0000-0000028D0757
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 02:42:09PM +0200, Frederic Weisbecker wrote:
> On Thu, Jun 12, 2014 at 06:24:32PM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 13, 2014 at 02:16:59AM +0200, Frederic Weisbecker wrote:
> > > CONFIG_NO_HZ_FULL may be enabled widely on distros nowadays but actual
> > > users should be a tiny minority, if actually any.
> > > 
> > > Also there is a risk that affining the GP kthread to a single CPU could
> > > end up noticeably reducing RCU performances and increasing energy
> > > consumption.
> > > 
> > > So lets affine the GP kthread only when nohz full is actually used
> > > (ie: when the nohz_full= parameter is filled or CONFIG_NO_HZ_FULL_ALL=y)
> > > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > Cc: Steven Rostedt <rostedt@goodmis.org>
> > > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > ---
> > >  kernel/rcu/tree_plugin.h | 10 +++++++---
> > >  1 file changed, 7 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > > index cbc2c45..726f52c 100644
> > > --- a/kernel/rcu/tree_plugin.h
> > > +++ b/kernel/rcu/tree_plugin.h
> > > @@ -2843,12 +2843,16 @@ static bool rcu_nohz_full_cpu(struct rcu_state *rsp)
> > >   */
> > >  static void rcu_bind_gp_kthread(void)
> > >  {
> > > -#ifdef CONFIG_NO_HZ_FULL
> > > -	int cpu = ACCESS_ONCE(tick_do_timer_cpu);
> > > +	int cpu;
> > > +
> > > +	if (!tick_nohz_full_enabled())
> > > +		return;
> > > +
> > > +	cpu = ACCESS_ONCE(tick_do_timer_cpu);
> > > 
> > >  	if (cpu < 0 || cpu >= nr_cpu_ids)
> > >  		return;
> > > +
> > >  	if (raw_smp_processor_id() != cpu)
> > >  		set_cpus_allowed_ptr(current, cpumask_of(cpu));
> > > -#endif /* #ifdef CONFIG_NO_HZ_FULL */
> > >  }
> > 
> > Hello, Frederic,
> > 
> > I have the following queued.  Shall I port yours on top of mine, or is
> > there an issue with mine?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > rcu: Bind grace-period kthreads to non-NO_HZ_FULL CPUs
> > 
> > Binding the grace-period kthreads to the timekeeping CPU resulted in
> > significant performance decreases for some workloads.  For more detail,
> > see:
> > 
> > https://lkml.org/lkml/2014/6/3/395 for benchmark numbers
> > 
> > https://lkml.org/lkml/2014/6/4/218 for CPU statistics
> > 
> > It turns out that it is necessary to bind the grace-period kthreads
> > to the timekeeping CPU only when all but CPU 0 is a nohz_full CPU
> > on the one hand or if CONFIG_NO_HZ_FULL_SYSIDLE=y on the other.
> > In other cases, it suffices to bind the grace-period kthreads to the
> > set of non-nohz_full CPUs.
> > 
> > This commit therefore creates a tick_nohz_not_full_mask that is the
> > complement of tick_nohz_full_mask, and then binds the grace-period
> > kthread to the set of CPUs indicated by this new mask, which covers
> > the CONFIG_NO_HZ_FULL_SYSIDLE=n case.  The CONFIG_NO_HZ_FULL_SYSIDLE=y
> > case still binds the grace-period kthreads to the timekeeping CPU.
> > 
> > Reported-by: Jet Chen <jet.chen@intel.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/include/linux/tick.h b/include/linux/tick.h
> > index b84773cb9f4c..1fe0c05eee39 100644
> > --- a/include/linux/tick.h
> > +++ b/include/linux/tick.h
> > @@ -162,6 +162,7 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
> >  #ifdef CONFIG_NO_HZ_FULL
> >  extern bool tick_nohz_full_running;
> >  extern cpumask_var_t tick_nohz_full_mask;
> > +extern cpumask_var_t tick_nohz_not_full_mask;
> >  
> >  static inline bool tick_nohz_full_enabled(void)
> >  {
> > diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> > index 7ce734040a5e..ec7627becaf0 100644
> > --- a/kernel/rcu/tree_plugin.h
> > +++ b/kernel/rcu/tree_plugin.h
> > @@ -2863,7 +2863,12 @@ static void rcu_bind_gp_kthread(void)
> >  
> >  	if (cpu < 0 || cpu >= nr_cpu_ids)
> >  		return;
> > +#ifdef CONFIG_NO_HZ_FULL_SYSIDLE
> >  	if (raw_smp_processor_id() != cpu)
> >  		set_cpus_allowed_ptr(current, cpumask_of(cpu));
> > +#else /* #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
> > +	if (!cpumask_test_cpu(raw_smp_processor_id(), tick_nohz_not_full_mask))
> > +		set_cpus_allowed_ptr(current, tick_nohz_not_full_mask);
> > +#endif /* #else #ifdef CONFIG_NO_HZ_FULL_SYSIDLE */
> >  #endif /* #ifdef CONFIG_NO_HZ_FULL */
> >  }
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index 9f8af69c67ec..02209e957e76 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -151,6 +151,7 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
> >  
> >  #ifdef CONFIG_NO_HZ_FULL
> >  cpumask_var_t tick_nohz_full_mask;
> > +cpumask_var_t tick_nohz_not_full_mask;
> >  bool tick_nohz_full_running;
> >  
> >  static bool can_stop_full_tick(void)
> > @@ -278,6 +279,7 @@ static int __init tick_nohz_full_setup(char *str)
> >  	int cpu;
> >  
> >  	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
> > +	alloc_bootmem_cpumask_var(&tick_nohz_not_full_mask);
> >  	if (cpulist_parse(str, tick_nohz_full_mask) < 0) {
> >  		pr_warning("NOHZ: Incorrect nohz_full cpumask\n");
> >  		return 1;
> > @@ -288,6 +290,8 @@ static int __init tick_nohz_full_setup(char *str)
> >  		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
> >  		cpumask_clear_cpu(cpu, tick_nohz_full_mask);
> >  	}
> > +	cpumask_andnot(tick_nohz_not_full_mask,
> > +		       cpu_possible_mask, tick_nohz_full_mask);
> >  	tick_nohz_full_running = true;
> >  
> >  	return 1;
> > @@ -332,6 +336,8 @@ static int tick_nohz_init_all(void)
> >  	err = 0;
> >  	cpumask_setall(tick_nohz_full_mask);
> >  	cpumask_clear_cpu(smp_processor_id(), tick_nohz_full_mask);
> > +	cpumask_clear(tick_nohz_not_full_mask);
> > +	cpumask_set_cpu(smp_processor_id(), tick_nohz_not_full_mask);
> >  	tick_nohz_full_running = true;
> >  #endif
> >  	return err;
> > 
> 
> Ah I missed that one. Ok it should fix the issue then, no need for mine.
> 
> Ok I must confess that I don't have a comfortable feeling with having two opposed masks
> like this: tick_nohz_full_mask and tick_nohz_not_full_mask.
> 
> Maybe what we should do instead is to have something like this on RCU kthread init:
> 
>           cpumask_var_t gp_kthread_mask;
> 
>           if (alloc_cpumask_var(gp_kthread_mask, GFP_KERNEL))
>               return -EFAULT;
> 
>           cpumask_andnot(gp_kthread_mask, cpu_possible_mask, tick_nohz_full_mask);
> 
> 	  set_cpus_allowed_ptr(current, gp_kthread_mask);
> 
> 	  free_cpumask_var(gp_kthread_mask);

I was guessing that RCU's kthreads would not be the only ones that wanted
similar binding.  But if you feel strongly about this, we could at least
start by placing it local to RCU as above.

							Thanx, Paul

