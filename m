Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaDDLmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:42:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53593 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752760AbaDDLmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:42:00 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, linux-pm@vger.kernel.org,
        alex.shi@linaro.org, vincent.guittot@linaro.org,
        morten.rasmussen@arm.com
Subject: Re: [RFC PATCHC 3/3] sched/fair: use the idle state info to choose the idlest cpu
Date: Fri, 04 Apr 2014 13:57:52 +0200
Message-ID: <1967882.uTPDmTW56C@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1404012208110.1571@knanqh.ubzr>
References: <1396009796-31598-1-git-send-email-daniel.lezcano@linaro.org> <1396009796-31598-4-git-send-email-daniel.lezcano@linaro.org> <alpine.LFD.2.11.1404012208110.1571@knanqh.ubzr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 01, 2014 11:05:49 PM Nicolas Pitre wrote:
> On Fri, 28 Mar 2014, Daniel Lezcano wrote:
> 
> > As we know in which idle state the cpu is, we can investigate the following:
> > 
> > 1. when did the cpu entered the idle state ? the longer the cpu is idle, the
> > deeper it is idle
> > 2. what exit latency is ? the greater the exit latency is, the deeper it is
> > 
> > With both information, when all cpus are idle, we can choose the idlest cpu.
> > 
> > When one cpu is not idle, the old check against weighted load applies.
> > 
> > Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> 
> There seems to be some problems with the implementation.
> 
> > @@ -4336,20 +4337,53 @@ static int
> >  find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
> >  {
> >  	unsigned long load, min_load = ULONG_MAX;
> > -	int idlest = -1;
> > +	unsigned int min_exit_latency = UINT_MAX;
> > +	u64 idle_stamp, min_idle_stamp = ULONG_MAX;
> 
> I don't think you really meant to assign an u64 variable with ULONG_MAX.
> You probably want ULLONG_MAX here.  And probably not in fact (more 
> later).
> 
> > +
> > +	struct rq *rq;
> > +	struct cpuidle_power *power;
> > +
> > +	int cpu_idle = -1;
> > +	int cpu_busy = -1;
> >  	int i;
> >  
> >  	/* Traverse only the allowed CPUs */
> >  	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
> > -		load = weighted_cpuload(i);
> >  
> > -		if (load < min_load || (load == min_load && i == this_cpu)) {
> > -			min_load = load;
> > -			idlest = i;
> > +		if (idle_cpu(i)) {
> > +
> > +			rq = cpu_rq(i);
> > +			power = rq->power;
> > +			idle_stamp = rq->idle_stamp;
> > +
> > +			/* The cpu is idle since a shorter time */
> > +			if (idle_stamp < min_idle_stamp) {
> > +				min_idle_stamp = idle_stamp;
> > +				cpu_idle = i;
> > +				continue;
> 
> Don't you want the highest time stamp in order to select the most 
> recently idled CPU?  Favoring the CPU which has been idle the longest 
> makes little sense.

It may make sense if the hardware can auto-promote CPUs to deeper C-states.

Something like that happens with package C-states that are only entered when
all cores have entered a particular core C-state already.  In that case the
probability of the core being in a deeper state grows with time.

That said I would just drop this heuristics for the time being.  If auto-promotion
is disregarded, it doesn't really matter how much time the given CPU has been idle
except for one case: When the target residency of its idle state hasn't been
reached yet, waking up the CPU may be a mistake (depending on how deep the state
actually is, but for the majority of drivers in the tree we don't have any measure
of that).

> > +			}
> > +
> > +			/* The cpu is idle but the exit_latency is shorter */
> > +			if (power && power->exit_latency < min_exit_latency) {
> > +				min_exit_latency = power->exit_latency;
> > +				cpu_idle = i;
> > +				continue;
> > +			}
> 
> I think this is wrong.  This gives priority to CPUs which have been idle 
> for a (longer... although this should have been) shorter period of time 
> over those with a shallower idle state.  I think this should rather be:
> 
> 	if (power && power->exit_latency < min_exit_latency) {
> 		min_exit_latency = power->exit_latency;
> 		latest_idle_stamp = idle_stamp;
> 	       	cpu_idle = i;
> 	} else if ((!power || power->exit_latency == min_exit_latency) &&
> 		   idle_stamp > latest_idle_stamp) {
> 		latest_idle_stamp = idle_stamp;
> 		cpu_idle = i;
> 	}
> 
> So the CPU with the shallowest idle state is selected in priority, and 
> if many CPUs are in the same state then the time stamp is used to 
> select the most recent one.

Again, if auto-promotion is disregarded, it doesn't really matter which of them
is woken up.

> Whenever a shallower idle state is found then the latest_idle_stamp is reset for 
> that state even if it is further in the past.
> 
> > +		} else {
> > +
> > +			load = weighted_cpuload(i);
> > +
> > +			if (load < min_load ||
> > +			    (load == min_load && i == this_cpu)) {
> > +				min_load = load;
> > +				cpu_busy = i;
> > +				continue;
> > +			}
> >  		}
> 
> I think this is wrong to do an if-else based on idle_cpu() here.  What 
> if a CPU is heavily loaded, but for some reason it happens to be idle at 
> this very moment?  With your patch it could be selected as an idle CPU 
> while it would be discarded as being too busy otherwise.

But see below ->

> It is important to determine both cpu_busy and cpu_idle for all CPUs.
> 
> And cpu_busy is a bad name for this.  Something like least_loaded would 
> be more self explanatory.  Same thing for cpu_idle which could be 
> clearer if named shalloest_idle.

shallowest_idle?

> > -	return idlest;
> > +	/* Busy cpus are considered less idle than idle cpus ;) */
> > +	return cpu_busy != -1 ? cpu_busy : cpu_idle;
> 
> And finally it is a policy decision whether or not we want to return 
> least_loaded over shallowest_idle e.g do we pack tasks on non idle CPUs 
> first or not.  That in itself needs more investigation.  To keep the 
> existing policy unchanged for now the above condition should have its 
> variables swapped.

Which means that once we've find the first idle CPU, it is not useful to
continue computing least_loaded, because we will return the idle one anyway,
right?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
