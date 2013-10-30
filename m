Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3J3KGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:06:41 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:53604 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3J3KGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:06:40 -0400
Message-ID: <5270D974.3090003@linux.vnet.ibm.com>
Date: Wed, 30 Oct 2013 15:33:32 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: peterz@infradead.org, mikey@neuling.org, svaidy@linux.vnet.ibm.com,
        mingo@kernel.org, vincent.guittot@linaro.org, bitbucket@online.de,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        anton@samba.org, linuxppc-dev@lists.ozlabs.org,
        Morten.Rasmussen@arm.com, pjt@google.com
Subject: Re: [PATCH V2 2/2] sched: Remove un-necessary iteration over sched
 domains to update nr_busy_cpus
References: <20131030031145.23426.22930.stgit@preeti.in.ibm.com> <20131030031252.23426.4417.stgit@preeti.in.ibm.com> <52707B02.7030100@linux.vnet.ibm.com> <20131030092313.GA4196@linux.vnet.ibm.com>
In-Reply-To: <20131030092313.GA4196@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103010-2674-0000-0000-00000B48AFEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

On 10/30/2013 02:53 PM, Kamalesh Babulal wrote:
> Hi Preeti,
> 
>> nr_busy_cpus parameter is used by nohz_kick_needed() to find out the number
>> of busy cpus in a sched domain which has SD_SHARE_PKG_RESOURCES flag set.
>> Therefore instead of updating nr_busy_cpus at every level of sched domain,
>> since it is irrelevant, we can update this parameter only at the parent
>> domain of the sd which has this flag set. Introduce a per-cpu parameter
>> sd_busy which represents this parent domain.
>>
>> In nohz_kick_needed() we directly query the nr_busy_cpus parameter
>> associated with the groups of sd_busy.
>>
>> By associating sd_busy with the highest domain which has
>> SD_SHARE_PKG_RESOURCES flag set, we cover all lower level domains which could
>> have this flag set and trigger nohz_idle_balancing if any of the levels have
>> more than one busy cpu.
>>
>> sd_busy is irrelevant for asymmetric load balancing. However sd_asym has been
>> introduced to represent the highest sched domain which has SD_ASYM_PACKING flag set
>> so that it can be queried directly when required.
>>
>> While we are at it, we might as well change the nohz_idle parameter to be
>> updated at the sd_busy domain level alone and not the base domain level of a CPU.
>> This will unify the concept of busy cpus at just one level of sched domain
>> where it is currently used.
>>
>> Signed-off-by: Preeti U Murthy<preeti@linux.vnet.ibm.com>
>> ---
>>  kernel/sched/core.c  |    6 ++++++
>>  kernel/sched/fair.c  |   38 ++++++++++++++++++++------------------
>>  kernel/sched/sched.h |    2 ++
>>  3 files changed, 28 insertions(+), 18 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index c06b8d3..e6a6244 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -5271,6 +5271,8 @@ DEFINE_PER_CPU(struct sched_domain *, sd_llc);
>>  DEFINE_PER_CPU(int, sd_llc_size);
>>  DEFINE_PER_CPU(int, sd_llc_id);
>>  DEFINE_PER_CPU(struct sched_domain *, sd_numa);
>> +DEFINE_PER_CPU(struct sched_domain *, sd_busy);
>> +DEFINE_PER_CPU(struct sched_domain *, sd_asym);
>>
>>  static void update_top_cache_domain(int cpu)
>>  {
>> @@ -5282,6 +5284,7 @@ static void update_top_cache_domain(int cpu)
>>  	if (sd) {
>>  		id = cpumask_first(sched_domain_span(sd));
>>  		size = cpumask_weight(sched_domain_span(sd));
>> +		rcu_assign_pointer(per_cpu(sd_busy, cpu), sd->parent);
>>  	}
> 
> 
> consider a machine with single socket, dual core with HT enabled. The top most
> domain is also the highest domain with SD_SHARE_PKG_RESOURCES flag set,
> i.e MC domain (the machine toplogy consist of SIBLING and MC domain).
> 
> # lstopo-no-graphics --no-bridges --no-io
> Machine (7869MB) + Socket L#0 + L3 L#0 (3072KB)
>   L2 L#0 (256KB) + L1d L#0 (32KB) + L1i L#0 (32KB) + Core L#0
>     PU L#0 (P#0)
>     PU L#1 (P#1)
>   L2 L#1 (256KB) + L1d L#1 (32KB) + L1i L#1 (32KB) + Core L#1
>     PU L#2 (P#2)
>     PU L#3 (P#3)
> 
> With this approach parent of MC domain is NULL and given that sd_busy is NULL,
> nr_busy_cpus of sched domain sd_busy will never be incremented/decremented.
> Resulting is nohz_kick_needed returning 0.

Right and it *should* return 0. There is no sibling domain that can
offload tasks from it. Therefore there is no point kicking nohz idle
balance.

Regards
Preeti U Murthy
> 
> Thanks,
> Kamalesh.
> 

