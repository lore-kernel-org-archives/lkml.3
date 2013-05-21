Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab3EUWZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:25:35 -0400
Received: from relay3.sgi.com ([192.48.152.1]:37102 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752049Ab3EUWZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:25:34 -0400
Date: Tue, 21 May 2013 17:25:29 -0500
From: Russ Anderson <rja@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Robin Holt <holt@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpu: Speedup disable_nonboot_cpus()
Message-ID: <20130521222529.GA17762@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130503223543.GB25937@sgi.com>
 <20130521141717.a5eec1db994e193f0479b296@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130521141717.a5eec1db994e193f0479b296@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 02:17:17PM -0700, Andrew Morton wrote:
> On Fri, 3 May 2013 17:35:44 -0500 Russ Anderson <rja@sgi.com> wrote:
> 
> > The routine disable_nonboot_cpus() shuts down cpus sequentially
> > using for_each_online_cpu(cpu) to call cpu_down() one cpu at
> > a time.  cpu_down() calls __stop_machine() which stops all
> > the cpus while it disables one.  Then it re-enables the remaining
> > cpus, only to do it all over again for the next cpu.  The 
> > result is that it takes 16 minutes on a 1024 cpu system to 
> > disable 1023 cpus.
> > 
> > This patch changes disable_nonboot_cpus() to pass a bitmask
> > of cpus to cpu_down() and modifies cpu_down() to only call
> > __stop_machine() once.
> > 
> > On a 1024 cpu system this reduces the time it takes to disable
> > all but one cpu from 16 minutes down to 4 minutes.
> 
> That's still a helluva long time.  What's the kernel *doing* for
> all that time?

Since __raw_notifier_call_chain() isn't thread safe, it is still
called one cpu at a time.  See "__cpu_notify(CPU_DOWN_PREPARE" below.
So we still go sequentially for each cpu through the call chain.

These are the two heaviest hitters on the call chain.

    sched_init_smp ->
        cpuset_cpu_inactive ->
            cpuset_update_active_cpus ->
                    partition_sched_domains(1, NULL, NULL)
                    schedule_work(&cpuset_hotplug_work);
                        cpuset_hotplug_workfn
                            mutex_lock(&cpuset_mutex);
                            partition_sched_domains()

                    partition_sched_domains ->
                            unregister_sched_domain_sysctl() ->
                                    unregister_sysctl_table
                            register_sched_domain_sysctl
                                    for_each_possible_cpu()
                                    register_sysctl_table


    uncore_cpu_nb -> uncore_cpu_notifier
           uncore_event_exit_cpu
                   for_each_online_cpu()

The partition_sched_domains() code gets called for each cpu,
each time destroying and building new domains.
register_sched_domain_sysctl() calls for_each_possible_cpu()
each time.

Likewise uncore_event_exit_cpu() calls for_each_online_cpu()
for each cpu.

Neither of those scale well.


> > --- linux.orig/kernel/cpu.c	2013-05-03 09:56:31.145508321 -0500
> > +++ linux/kernel/cpu.c	2013-05-03 17:01:20.652959400 -0500
> >
> > ...
> >
> > @@ -255,21 +255,21 @@ static int __ref take_cpu_down(void *_pa
> >  	if (err < 0)
> >  		return err;
> >  
> > -	cpu_notify(CPU_DYING | param->mod, param->hcpu);
> > +	cpu_notify(CPU_DYING | param->mod, hcpu);
> >  	/* Park the stopper thread */
> >  	kthread_park(current);
> >  	return 0;
> >  }
> >  
> >  /* Requires cpu_add_remove_lock to be held */
> > -static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
> > +static int __ref _cpu_down(const cpumask_t *cpus_to_offline, int tasks_frozen)
> 
> _cpu_down() is now misnamed - it downs multiple CPUs.

OK, I'll change it.

> >  {
> > -	int err, nr_calls = 0;
> > +	int err = 0, cpu = 0, nr_calls = 0;
> >  	void *hcpu = (void *)(long)cpu;
> > +	cpumask_var_t cpus_offlined;
> >  	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
> >  	struct take_cpu_down_param tcd_param = {
> >  		.mod = mod,
> > -		.hcpu = hcpu,
> >  	};
> >  
> >  	if (num_online_cpus() == 1)
> > @@ -278,46 +278,67 @@ static int __ref _cpu_down(unsigned int
> >  	if (!cpu_online(cpu))
> >  		return -EINVAL;
> >  
> > +	if (!alloc_cpumask_var(&cpus_offlined, GFP_KERNEL))
> > +		return -ENOMEM;
> > +
> >  	cpu_hotplug_begin();
> > +	cpumask_copy(cpus_offlined, cpus_to_offline);
> >  
> > -	err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
> > -	if (err) {
> > -		nr_calls--;
> > -		__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
> > -		printk("%s: attempt to take down CPU %u failed\n",
> > +	for_each_cpu_mask(cpu, *cpus_to_offline) {
> > +		if (!cpu_online(cpu))
> > +			continue;
> > +		hcpu = (void *)(long)cpu;
> > +		err = __cpu_notify(CPU_DOWN_PREPARE | mod, hcpu, -1, &nr_calls);
> > +		if (err) {
> > +			nr_calls--;
> > +			__cpu_notify(CPU_DOWN_FAILED | mod, hcpu, nr_calls, NULL);
> > +			pr_err("%s: attempt to take down CPU %u failed\n",
> >  				__func__, cpu);
> > -		goto out_release;
> > +			goto out_release;
> > +		}
> > +		smpboot_park_threads(cpu);
> >  	}
> > -	smpboot_park_threads(cpu);
> >  
> > -	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
> > +	err = __stop_machine(take_cpu_down, &tcd_param, cpus_to_offline);
> >  	if (err) {
> >  		/* CPU didn't die: tell everyone.  Can't complain. */
> 
> This comment is now inaccurate.  "One or more of the CPUs didn't die"?.
> 
> I'm not sure what "Can't complain" means.  Perhaps expand on this while
> you're there?

OK.

> > -		smpboot_unpark_threads(cpu);
> > -		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
> > +		for_each_cpu_mask(cpu, *cpus_to_offline) {
> > +			hcpu = (void *)(long)cpu;
> > +			smpboot_unpark_threads(cpu);
> > +			cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
> 
> Is this accurate?  What happens if we asked stop_machine() to down 100
> CPUs but it failed at CPU #50?  We now tell listeners that we failed to
> down all 100 CPUs?  That's not true.

I'll look closer at that.

> > +		}
> >  		goto out_release;
> >  	}
> > -	BUG_ON(cpu_online(cpu));
> >  
> >  	/*
> >  	 * The migration_call() CPU_DYING callback will have removed all
> >  	 * runnable tasks from the cpu, there's only the idle task left now
> >  	 * that the migration thread is done doing the stop_machine thing.
> > -	 *
> > -	 * Wait for the stop thread to go away.
> >  	 */
> > -	while (!idle_cpu(cpu))
> > -		cpu_relax();
> > -
> > -	/* This actually kills the CPU. */
> > -	__cpu_die(cpu);
> > +	for_each_cpu_mask(cpu, *cpus_offlined) {
> > +		BUG_ON(cpu_online(cpu));
> >  
> > -	/* CPU is completely dead: tell everyone.  Too late to complain. */
> > -	cpu_notify_nofail(CPU_DEAD | mod, hcpu);
> > -
> > -	check_for_tasks(cpu);
> > +		/*
> > +		 * Wait for the stop thread to go away.
> > +		 */
> > +		while (!idle_cpu(cpu))
> > +			cpu_relax();
> > +
> > +		/*
> > +		 * This actually kills the CPU.
> > +		 */
> > +		__cpu_die(cpu);
> > +
> > +		/*
> > +		 * CPU is completely dead: tell everyone.  Too late to complain.
> > +		 */
> > +		hcpu = (void *)(long)cpu;
> > +		cpu_notify_nofail(CPU_DEAD | mod, hcpu);
> > +		check_for_tasks(cpu);
> > +	}
> >  
> >  out_release:
> > +	free_cpumask_var(cpus_offlined);
> >  	cpu_hotplug_done();
> 
> Swap the above two lines and we reduced the locked region by an
> unmeasurable amount!
> 
> >  	if (!err)
> >  		cpu_notify_nofail(CPU_POST_DEAD | mod, hcpu);
> >
> > ...
> >

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
