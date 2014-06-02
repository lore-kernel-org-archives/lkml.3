Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaFBOPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:15:43 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:48185 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932173AbaFBOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:15:42 -0400
Date: Mon, 2 Jun 2014 15:15:36 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140602141536.GL19967@e103034-lin>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
 <20140530120424.GD30445@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530120424.GD30445@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 01:04:24PM +0100, Peter Zijlstra wrote:
> On Fri, May 23, 2014 at 07:16:33PM +0100, Morten Rasmussen wrote:
> > +static struct capacity_state cap_states_cluster_a7[] = {
> > +	/* Cluster only power */
> > +	 { .cap =  358, .power = 2967, }, /*  350 MHz */
> > +	 { .cap =  410, .power = 2792, }, /*  400 MHz */
> > +	 { .cap =  512, .power = 2810, }, /*  500 MHz */
> > +	 { .cap =  614, .power = 2815, }, /*  600 MHz */
> > +	 { .cap =  717, .power = 2919, }, /*  700 MHz */
> > +	 { .cap =  819, .power = 2847, }, /*  800 MHz */
> > +	 { .cap =  922, .power = 3917, }, /*  900 MHz */
> > +	 { .cap = 1024, .power = 4905, }, /* 1000 MHz */
> > +	};
> 
> > +static struct capacity_state cap_states_core_a7[] = {
> > +	/* Power per cpu */
> > +	 { .cap =  358, .power =  187, }, /*  350 MHz */
> > +	 { .cap =  410, .power =  275, }, /*  400 MHz */
> > +	 { .cap =  512, .power =  334, }, /*  500 MHz */
> > +	 { .cap =  614, .power =  407, }, /*  600 MHz */
> > +	 { .cap =  717, .power =  447, }, /*  700 MHz */
> > +	 { .cap =  819, .power =  549, }, /*  800 MHz */
> > +	 { .cap =  922, .power =  761, }, /*  900 MHz */
> > +	 { .cap = 1024, .power = 1024, }, /* 1000 MHz */
> > +	};
> 
> Talk to me about this core vs cluster thing.
> 
> Why would an architecture have multiple energy domains like this?
> 
> That is, if a cpu can set P states per core, why does it need a cluster
> wide thing.

The reason is that power domains are often organized in a hierarchy
where you may be able to power down just a cpu or the entire cluster
along with cluster wide shared resources. This is quite typical for ARM
systems. Frequency domains (P-states) typically cover the same hardware
as one of the power domain levels. That is, there might be several
smaller power domains sharing the same frequency (P-state) or there
might be a power domain spanning multiple frequency domains.

The main reason why we need to worry about all this is that it typically
cost a lot more energy to use the first cpu in a cluster since you
also need to power up all the shared hardware resources than the energy
cost of waking and using additional cpus in the same cluster.

IMHO, the most natural way to model the energy is therefore something
like:

    energy = energy_cluster + n * energy_cpu

Where 'n' is the number of cpus powered up and energy_cluster is the
cost paid as soon as any cpu in the cluster is powered up.

If we take TC2 as an example, we have per-cluster frequency domains
(P-states) and idle-states for both the individual cpus and the
clusters. WFI for individual cpus and cluster power down for the
cluster, which takes down the per-cluster L2 cache and other cluster
resources. When we wake the first cpu in a cluster, the cluster will
exit cluster power down and put all other into WFI. Powering on the
first cpu (A7) and fully utilizing it at 1000 MHz will cost:

    power_one = 4905 + 1024

Waking up an additional cpu and fully utilizing it we get:

    power_two = 4905 + 2*1024

So if we need two cpu's worth of compute capacity (at max capacity) we
can save quite a lot of energy by picking two in the same cluster rather
than paying the cluster power twice.

Now if one of the cpus is only 50% utilized, it will be in WFI half the
time:

    power = power_cluster + \sum{n}^{cpus} util(n) * power_cpu +
					(1-util(n)) * idle_power_cpu

    power_100_50 = 4905 + (1.0*1024 + 0.0*0) + (0.5*1024 + 0.5*0)

I have normalized the utilization factor to 1.0 for simplicity. We also
need to factor in the cost of the wakeups on the 50% loaded cpu, but I
will leave that out here to keep it simpler.

If we now consider a slightly different scenario where one cpu is 50%
utilized and the other is 25% utilized. We assume that the busy period
starts at the same time on both cpus (overlapped). In this case, we can
power down the whole cluster 50% of the time (assuming that the idle
period is long enough to allow it). We can expand power_cluster to
factor that in:

    power_cluster' = util(cluster) * power_cluster + 
				(1-util(cluster)) * idle_power_cluster

    power_50_25 = 0.5*4905 + 0.5*10 + (0.5*1024 + 0.0*0) +
    						(0.25*1024 + 0.75*0)

> Also, in general, why would we need to walk the domain tree all the way
> up, typically I would expect to stop walking once we've covered the two
> cpu's we're interested in, because above that nothing changes.

True. In some cases we don't have to go all the way up. There is a
condition in energy_diff_load() that bails out if the energy doesn't
change further up the hierarchy. There might be scope for improving that
condition though.

We can basically stop going up if the utilization of the domain is
unchanged by the change we want to do. For example, we can ignore the
next level above if a third cpu is keeping the domain up all the time
anyway. In the 100% + 50% case above, putting another 50% task on the
50% cpu wouldn't affect the cluster according the proposed model, so it
can be ignored. However, if we did the same on any of the two cpus in
the 50% + 25% example we affect the cluster utilization and have to do
the cluster level maths.

So we do sometimes have to go all the way up even if we are balancing
two sibling cpus to determine the energy implications. At least if we
want an energy score like energy_diff_load() produces. However, we might
be able to take some other shortcuts if we are balancing load between
two specific cpus (not wakeup/fork/exec balancing) as you point out. But
there are cases where we need to continue up until the domain
utilization is unchanged.
