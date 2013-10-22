Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3JVQnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:43:40 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:36305 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3JVQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:43:38 -0400
Message-ID: <5266AA78.4060607@linux.vnet.ibm.com>
Date: Tue, 22 Oct 2013 22:10:24 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        linuxppc-dev@lists.ozlabs.org, vincent.guittot@linaro.org,
        suresh.b.siddha@intel.com
Subject: Re: [PATCH 1/3] sched: Fix nohz_kick_needed to consider the nr_busy
 of the parent domain's group
References: <20131021114002.13291.31478.stgit@drishya> <20131021114442.13291.99344.stgit@drishya> <20131022143559.GA3197@linux.vnet.ibm.com>
In-Reply-To: <20131022143559.GA3197@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102216-0260-0000-0000-000003D63221
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

On 10/22/2013 08:05 PM, Kamalesh Babulal wrote:
> * Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> [2013-10-21 17:14:42]:
> 
>>  	for_each_domain(cpu, sd) {
>> -		struct sched_group *sg = sd->groups;
>> -		struct sched_group_power *sgp = sg->sgp;
>> -		int nr_busy = atomic_read(&sgp->nr_busy_cpus);
>> -
>> -		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
>> -			goto need_kick_unlock;
>> +		struct sched_domain *sd_parent = sd->parent;
>> +		struct sched_group *sg;
>> +		struct sched_group_power *sgp;
>> +		int nr_busy;
>> +
>> +		if (sd_parent) {
>> +			sg = sd_parent->groups;
>> +			sgp = sg->sgp;
>> +			nr_busy = atomic_read(&sgp->nr_busy_cpus);
>> +
>> +			if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
>> +				goto need_kick_unlock;
>> +		}
>>
>>  		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
>>  		    && (cpumask_first_and(nohz.idle_cpus_mask,
> 
> CC'ing Suresh Siddha and Vincent Guittot
> 
> Please correct me, If my understanding of idle balancing is wrong.
> With proposed approach will not idle load balancer kick in, even if
> there are busy cpus across groups or if there are 2 busy cpus which
> are spread across sockets.

Yes load balancing will happen on busy cpus periodically.

Wrt idle balancing there are two points here. One, when a CPU is just
about to go idle, it will enter idle_balance(), and trigger load
balancing with itself being the destination CPU to begin with. It will
load balance at every level of the sched domain that it belongs to. If
it manages to pull tasks, good, else it will enter an idle state.

nohz_idle_balancing is triggered by a busy cpu at every tick if it has
more than one task in its runqueue or if it belongs to a group that
shares the package resources and has more than one cpu busy. By
"nohz_idle_balance triggered", it means the busy cpu will send an ipi to
the ilb_cpu to do load balancing on the behalf of the idle cpus in the
nohz mask.

So to answer your question wrt this patch, if there is one busy cpu with
say 2 tasks in one socket and another busy cpu with 1 task on another
socket, the former busy cpu can kick nohz_idle_balance since it has more
than one task in its runqueue. An idle cpu in either socket could be
woken up to balance tasks with it.

The usual idle load balancer that runs on a CPU about to become idle
could pull from either cpu depending on who is more busy as it begins to
load balance across all levels of sched domain that it belongs to.
> 
> Consider 2 socket machine with 4 processors each (MC and NUMA domains).
> If the machine is partial loaded such that cpus 0,4,5,6,7 are busy, then too
> nohz balancing is triggered because with this approach
> (NUMA)->groups->sgp->nr_busy_cpus is taken in account for nohz kick, while
> iterating over MC domain.

For the example that you mention, you will have a CPU domain and a NUMA
domain. When the sockets are NUMA nodes, each socket will belong to a
CPU domain. If the sockets are non-numa nodes, then the domain
encompassing both the nodes will be a CPU domain, possibly with each
socket being an MC domain.
> 
> Isn't idle load balancer not suppose kick in, even in the case of two busy
> cpu's in a dual-core single socket system

nohz_idle_balancing is a special case. It is triggered when the
conditions mentioned in nohz_kick_needed() are true. A CPU just about to
go idle will trigger load balancing without any pre-conditions.

In a single socket machine, there will be a CPU domain encompassing the
socket and the MC domain will encompass a core. nohz_idle load balancer
will kick in if both the threads in the core have tasks running on them.
This is fair enough because the threads share the resources of the core.

Regards
Preeti U Murthy
> 
> Thanks,
> Kamalesh.
> 

