Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063AbaGXAe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 20:34:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63547 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933818AbaGXAe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 20:34:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, preeti@linux.vnet.ibm.com,
        Dietmar.Eggemann@arm.com, pjt@google.com
Subject: Re: [RFCv2 PATCH 01/23] sched: Documentation for scheduler energy cost model
Date: Thu, 24 Jul 2014 02:53:20 +0200
Message-ID: <3288345.jvzVvqTJvD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1404404770-323-2-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com> <1404404770-323-2-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,

Sorry for the late response, I've been swamped with other stuff lately.

I have a couple of remarks regarding the terminology and one general concern
(please see below).

On Thursday, July 03, 2014 05:25:48 PM Morten Rasmussen wrote:
> This documentation patch provides an overview of the experimental
> scheduler energy costing model, associated data structures, and a
> reference recipe on how platforms can be characterized to derive energy
> models.
> 
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---

[cut]

> +
> +Platform topology
> +------------------
> +
> +The system topology (cpus, caches, and NUMA information, not peripherals) is
> +represented in the scheduler by the sched_domain hierarchy which has
> +sched_groups attached at each level that covers one or more cpus (see
> +sched-domains.txt for more details). To add energy awareness to the scheduler
> +we need to consider power and frequency domains.
> +
> +Power domain:
> +
> +A power domain is a part of the system that can be powered on/off
> +independently. Power domains are typically organized in a hierarchy where you
> +may be able to power down just a cpu or a group of cpus along with any
> +associated resources (e.g.  shared caches). Powering up a cpu means that all
> +power domains it is a part of in the hierarchy must be powered up. Hence, it is
> +more expensive to power up the first cpu that belongs to a higher level power
> +domain than powering up additional cpus in the same high level domain. Two
> +level power domain hierarchy example:
> +
> +		Power source
> +		         +-------------------------------+----...
> +per group PD		 G                               G
> +		         |           +----------+        |
> +		    +--------+-------| Shared   |  (other groups)
> +per-cpu PD	    G        G       | resource |
> +		    |        |       +----------+
> +		+-------+ +-------+
> +		| CPU 0 | | CPU 1 |
> +		+-------+ +-------+
> +
> +Frequency domain:
> +
> +Frequency domains (P-states) typically cover the same group of cpus as one of
> +the power domain levels. That is, there might be several smaller power domains
> +sharing the same frequency (P-state) or there might be a power domain spanning
> +multiple frequency domains.
> +
> +From a scheduling point of view there is no need to know the actual frequencies
> +[Hz]. All the scheduler cares about is the compute capacity available at the
> +current state (P-state) the cpu is in and any other available states. For that
> +reason, and to also factor in any cpu micro-architecture differences, compute
> +capacity scaling states are called 'capacity states' in this document. For SMP
> +systems this is equivalent to P-states. For mixed micro-architecture systems
> +(like ARM big.LITTLE) it is P-states scaled according to the micro-architecture
> +performance relative to the other cpus in the system.
> +

I am used to slightly different terminology here.  Namely, there are voltage
domains (parts sharing a voltage rail or a voltage regulator, such that you
can only apply/remove/change voltage to all of them at the same time) and clock
domains (analogously, but for clocks).  A power domain (which in your description
above seems to correspond to a voltage domain) may be a voltage domain, a clock
domain or a combination thereof.

In addition to that, in a voltage domain it may be possible to apply many
different levels of voltage, which case doesn't seem to be covered at all by
the above (or I'm missing something).

Also a P-state is not just a frequency level, but a combination of frequency
and voltage that has to be applied for that frequency to be stable.  You may
regard them as Operation Performance Points of the CPU, but that very well may
go beyond frequencies and voltages.  Thus it actually is better not to talk
about P-states as "frequencies".

Now, P-states may or may not have to be coordinated between all CPUs in a
package (cluster), by hardware or software, such that all CPUs in a cluster
need to be kept in the same P-state.  That you can regard as a "P-state
domain", but it usually means a specific combination of voltage and frequency.

C-states in turn are states in which CPUs don't execute instructions.
That need not mean the removal of voltage or even frequency from them.
Of course, they do mean some sort of power draw reduction, but that may
be achieved in many different ways.  Some C-states require coordination
too (for example, a single C-state may apply to a whole package or cluster
at the same time) and you can think about "domains" here too, but there
need not be a direct mapping to physical parameters such as the frequency
or the voltage.

Moreover, P-states and C-states may overlap.  That is, a CPU may be in Px
and Cy at the same time, which means that after leaving Cy it will execute
instructions in Px.  Things like leakage may depend on x in that case and
the total power draw may depend on the combination of x and y.


> +Energy modelling:
> +------------------
> +
> +Due to the hierarchical nature of the power domains, the most obvious way to
> +model energy costs is therefore to associate power and energy costs with
> +domains (groups of cpus). Energy costs of shared resources are associated with
> +the group of cpus that share the resources, only the cost of powering the
> +cpu itself and any private resources (e.g. private L1 caches) is associated
> +with the per-cpu groups (lowest level).
> +
> +For example, for an SMP system with per-cpu power domains and a cluster level
> +(group of cpus) power domain we get the overall energy costs to be:
> +
> +	energy = energy_cluster + n * energy_cpu
> +
> +where 'n' is the number of cpus powered up and energy_cluster is the cost paid
> +as soon as any cpu in the cluster is powered up.
> +
> +The power and frequency domains can naturally be mapped onto the existing
> +sched_domain hierarchy and sched_groups by adding the necessary data to the
> +existing data structures.
> +
> +The energy model considers energy consumption from three contributors (shown in
> +the illustration below):
> +
> +1. Busy energy: Energy consumed while a cpu and the higher level groups that it
> +belongs to are busy running tasks. Busy energy is associated with the state of
> +the cpu, not an event. The time the cpu spends in this state varies. Thus, the
> +most obvious platform parameter for this contribution is busy power
> +(energy/time).
> +
> +2. Idle energy: Energy consumed while a cpu and higher level groups that it
> +belongs to are idle (in a C-state). Like busy energy, idle energy is associated
> +with the state of the cpu. Thus, the platform parameter for this contribution
> +is idle power (energy/time).
> +
> +3. Wakeup energy: Energy consumed for a transition from an idle-state (C-state)
> +to a busy state (P-state) and back again, that is, a full run->sleep->run cycle
> +(they always come in pairs, transitions between idle-states are not modelled).
> +This energy is associated with an event with a fixed duration (at least
> +roughly). The most obvious platform parameter for this contribution is
> +therefore wakeup energy. Wakeup energy is depicted by the areas under the power
> +graph for the transition phases in the illustration.
> +
> +
> +	Power
> +	^
> +	|            busy->idle             idle->busy
> +	|            transition             transition
> +	|
> +	|                _                      __
> +	|               / \                    /  \__________________
> +	|______________/   \                  /
> +	|                   \                /
> +	|  Busy              \    Idle      /        Busy
> +	|  low P-state        \____________/         high P-state
> +	|
> +	+------------------------------------------------------------> time
> +
> +Busy    |--------------|                          |-----------------|
> +
> +Wakeup                 |------|            |------|
> +
> +Idle                          |------------|
> +
> +
> +The basic algorithm
> +====================
> +
> +The basic idea is to determine the total energy impact when utilization is
> +added or removed by estimating the impact at each level in the sched_domain
> +hierarchy starting from the bottom (sched_group contains just a single cpu).
> +The energy cost comes from three sources: busy time (sched_group is awake
> +because one or more cpus are busy), idle time (in an idle-state), and wakeups
> +(idle state exits). Power and energy numbers account for energy costs
> +associated with all cpus in the sched_group as a group. In some cases it is
> +possible to bail out early without having go to the top of the hierarchy if the
> +additional/removed utilization doesn't affect the busy time of higher levels.
> +
> +	for_each_domain(cpu, sd) {
> +		sg = sched_group_of(cpu)
> +		energy_before = curr_util(sg) * busy_power(sg)
> +				+ (1-curr_util(sg)) * idle_power(sg)
> +		energy_after = new_util(sg) * busy_power(sg)
> +				+ (1-new_util(sg)) * idle_power(sg)
> +				+ (1-new_util(sg)) * wakeups * wakeup_energy(sg)
> +		energy_diff += energy_before - energy_after
> +
> +		if (energy_before == energy_after)
> +			break;
> +	}
> +
> +	return energy_diff
> +
> +{curr, new}_util: The cpu utilization at the lowest level and the overall
> +non-idle time for the entire group for higher levels. Utilization is in the
> +range 0.0 to 1.0 in the pseudo-code.
> +
> +busy_power: The power consumption of the sched_group.
> +
> +idle_power: The power consumption of the sched_group when idle.
> +
> +wakeups: Average wakeup rate of the task(s) being added/removed. To predict how
> +many of the wakeups are wakeups that causes idle exits we scale the number by
> +the unused utilization (assuming that wakeups are uniformly distributed).
> +
> +wakeup_energy: The energy consumed for a run->sleep->run cycle for the
> +sched_group.

The concern is that if a scaling governor is running in parallel with the above
algorithm and it has its own utilization goal (it usually does), it may change
the P-state under you to match that utilization goal and you'll end up with
something different from what you expected.

That may be addressed either by trying to predict what the scaling governor will
do (and good luck with that) or by taking care of P-states by yourself.  The
latter would require changes to the algorithm I think, though.

Kind regards,
Rafael

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
