Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbaCTMlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:41:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55553 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbaCTMls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:41:48 -0400
Message-ID: <532AE216.3080106@arm.com>
Date: Thu, 20 Mar 2014 12:41:58 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v3 1/6] sched: rework of sched_domain topology definition
References: <1395246165-31150-1-git-send-email-vincent.guittot@linaro.org> <1395246165-31150-2-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1395246165-31150-2-git-send-email-vincent.guittot@linaro.org>
X-OriginalArrivalTime: 20 Mar 2014 12:41:57.0663 (UTC) FILETIME=[C80502F0:01CF4439]
X-MC-Unique: 114032012414504901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/03/14 16:22, Vincent Guittot wrote:
> We replace the old way to configure the scheduler topology with a new method
> which enables a platform to declare additionnal level (if needed).
> 
> We still have a default topology table definition that can be used by platform
> that don't want more level than the SMT, MC, CPU and NUMA ones. This table can
> be overwritten by an arch which either wants to add new level where a load balance
> make sense like BOOK or powergating level or wants to change the flags
> configuration of some levels.
> 
> For each level, we need a function pointer that returns cpumask for each cpu,
> a function pointer that returns the flags for the level and a name. Only flags
> that describe topology, can be set by an architecture. The current topology
> flags are:
>  SD_SHARE_CPUPOWER
>  SD_SHARE_PKG_RESOURCES
>  SD_NUMA
>  SD_ASYM_PACKING
> 
> Then, each level must be a subset on the next one. The build sequence of the
> sched_domain will take care of removing useless levels like those with 1 CPU
> and those with the same CPU span and relevant information for load balancing
> than its child.

The paragraph above contains important information to set this up
correctly, that's why it might be worth clarifying:

- "next one" of sd means "child of sd" ?
- "subset" means really "subset" and not "proper subset" ?

On TC2 w/ the following change in cpu_corepower_mask()

 const struct cpumask *cpu_corepower_mask(int cpu)
 {
-       return &cpu_topology[cpu].thread_sibling;
+       return cpu_topology[cpu].socket_id ?
&cpu_topology[cpu].thread_sibling :
+                       &cpu_topology[cpu].core_sibling;
 }

I get this e.g. for CPU0,2:

CPU0: cpu_corepower_mask=0-1  -> GMC is subset of MC
CPU0: cpu_coregroup_mask=0-1
CPU0: cpu_cpu_mask=0-4

CPU2: cpu_corepower_mask=2    -> GMC is proper sunset of MC
CPU2: cpu_coregroup_mask=2-4
CPU2: cpu_cpu_mask=0-4

I assume here that this is a correct set-up.

The domain degenerate part:

"useless levels like those with 1 CPU" ... that's the case for GMC level
for CPU2,3,4

The GMC level is destroyed because of the following code snippet in
sd_degenerate(): if (cpumask_weight(sched_domain_span(sd)) == 1)

so that's fine.

In case of CPU0,1 since GMC and MC have the same span, the code in
build_sched_groups() creates only one group for MC  and that's why
pflags is altered in sd_parent_degenerate() to SD_WAKE_AFFINE (0x20) and
the if condition 'if (~cflags & pflags)' is not hit and
sd_parent_degenerate() finally returns 1 for MC.

So the "those with the same CPU span and relevant information for load
balancing than its child." is not so easy to understand for me. Because
both levels have the same span we actually don't take the flags of the
parent into consideration which require at least 2 groups.

So the TC2 example covers for me two corner cases: (1) The level I want
to get rid of only contains 1 CPU (GMC for CPU2,3,4) and (2) The span of
the parent level I want to get rid of (MC for CPU0,1) of is the same as
the span of the level which should stay.

Are these two corner cases the only one supported here? If yes this has
to be stated somewhere, otherwise if somebody will try this approach on
a different topology, (s)he might be surprised.

If we only consider SD_SHARE_POWERDOMAIN for the socket related level,
this works fine.

I would like to test this on more platforms but I only have my TC2
available :-)

-- Dietmar

[...]

