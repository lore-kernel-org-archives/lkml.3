Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3IPIJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:09:03 -0400
Received: from relay.parallels.com ([195.214.232.42]:37781 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab3IPIJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:09:00 -0400
Message-ID: <5236BC9B.8040006@parallels.com>
Date: Mon, 16 Sep 2013 12:08:59 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH 2/2] sched: load_balance: Reset env when going to redo
 due to all pinned
References: <281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com> <c34e2ebbe55403d5db111fa3ecdf6ca52b73a337.1379265590.git.vdavydov@parallels.com> <20130916054301.GK21832@twins.programming.kicks-ass.net>
In-Reply-To: <20130916054301.GK21832@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 09:43 AM, Peter Zijlstra wrote:
> On Sun, Sep 15, 2013 at 09:30:14PM +0400, Vladimir Davydov wrote:
>> Firstly, reset env.dst_cpu/dst_rq to this_cpu/this_rq, because it could
>> have changed in 'some pinned' case. Otherwise, should_we_balance() can
>> stop balancing beforehand.
>>
>> Secondly, reset env.flags, because it can have LBF_SOME_PINNED set.
>>
>> Thirdly, reset env.dst_grpmask cpus in env.cpus to allow handling 'some
>> pinned' case when pulling tasks from a new busiest cpu.
> Did you actually run into any problems because of this?

IRL no, and now I see that catching 'all pinned' after 'some pinned' 
case can only happen if a task changes its affinity mask or gets 
throttled during load balance run, which is very unlikely. So this patch 
is rather for sanity and can be safely dropped.

>> Signed-off-by: Vladimir Davydov<vdavydov@parallels.com>
>> ---
>>   kernel/sched/fair.c |   12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index cd59640..d840e51 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5289,8 +5289,16 @@ more_balance:
>>   		if (unlikely(env.flags & LBF_ALL_PINNED)) {
>>   			cpumask_clear_cpu(cpu_of(busiest), cpus);
>>   			if (!cpumask_empty(cpus)) {
>> -				env.loop = 0;
>> -				env.loop_break = sched_nr_migrate_break;
>> +				env.dst_cpu	= this_cpu;
>> +				env.dst_rq	= this_rq;
>> +				env.flags	= 0;
>> +				env.loop	= 0;
>> +				env.loop_break	= sched_nr_migrate_break;
>> +
>> +				/* Reset cpus cleared in LBF_SOME_PINNED case */
>> +				if (env.dst_grpmask)
>> +					cpumask_or(cpus, cpus, env.dst_grpmask);
>> +
>>   				goto redo;
>>   			}
>>   			goto out_balanced;
> So the problem I have with this is that it removes the bound on the
> number of iterations we do. Currently we're limited by the bits in cpus,
> but by resetting those we can do on and on and on...

find_busiest_group() never selects the local group, doesn't it? So none 
of env.dst_grpmask, which is initialized to 
sched_group_cpus(this_rq->sd), can be selected for the source cpu. That 
said, resetting env.dst_grpmask bits in the cpus bitmask actually 
doesn't affect the number of balance iterations.
