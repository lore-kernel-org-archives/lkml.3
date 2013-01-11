Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3AKO4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 09:56:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:26067 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932Ab3AKO4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 09:56:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,452,1355126400"; 
   d="scan'208";a="242773619"
Message-ID: <50F02823.1070909@intel.com>
Date: Fri, 11 Jan 2013 22:56:35 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: li guang <lig.fnst@cn.fujitsu.com>
CC: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 05/22] sched: remove domain iterations in fork/exec/wake
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com>  <1357375071-11793-6-git-send-email-alex.shi@intel.com>  <20130109182102.GC2046@e103034-lin>  <50EF9B69.3000201@linux.vnet.ibm.com> <1357891316.2860.6.camel@liguang.fnst.cn.fujitsu.com>
In-Reply-To: <1357891316.2860.6.camel@liguang.fnst.cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 04:01 PM, li guang wrote:
> 在 2013-01-11五的 10:26 +0530，Preeti U Murthy写道：
>> Hi Morten,Alex
>>
>> On 01/09/2013 11:51 PM, Morten Rasmussen wrote:
>>> On Sat, Jan 05, 2013 at 08:37:34AM +0000, Alex Shi wrote:
>>>> Guess the search cpu from bottom to up in domain tree come from
>>>> commit 3dbd5342074a1e sched: multilevel sbe sbf, the purpose is
>>>> balancing over tasks on all level domains.
>>>>
>>>> This balancing cost much if there has many domain/groups in a large
>>>> system. And force spreading task among different domains may cause
>>>> performance issue due to bad locality.
>>>>
>>>> If we remove this code, we will get quick fork/exec/wake, plus better
>>>> balancing among whole system, that also reduce migrations in future
>>>> load balancing.
>>>>
>>>> This patch increases 10+% performance of hackbench on my 4 sockets
>>>> NHM and SNB machines.
>>>>
>>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>>> ---
>>>>  kernel/sched/fair.c | 20 +-------------------
>>>>  1 file changed, 1 insertion(+), 19 deletions(-)
>>>>
>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index ecfbf8e..895a3f4 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -3364,15 +3364,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>>>>  		goto unlock;
>>>>  	}
>>>>  
>>>> -	while (sd) {
>>>> +	if (sd) {
>>>>  		int load_idx = sd->forkexec_idx;
>>>>  		struct sched_group *group;
>>>> -		int weight;
>>>> -
>>>> -		if (!(sd->flags & sd_flag)) {
>>>> -			sd = sd->child;
>>>> -			continue;
>>>> -		}
>>>>  
>>>>  		if (sd_flag & SD_BALANCE_WAKE)
>>>>  			load_idx = sd->wake_idx;
>>>> @@ -3382,18 +3376,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>>>>  			goto unlock;
>>>>  
>>>>  		new_cpu = find_idlest_cpu(group, p, cpu);
>>>> -
>>>> -		/* Now try balancing at a lower domain level of new_cpu */
>>>> -		cpu = new_cpu;
>>>> -		weight = sd->span_weight;
>>>> -		sd = NULL;
>>>> -		for_each_domain(cpu, tmp) {
>>>> -			if (weight <= tmp->span_weight)
>>>> -				break;
>>>> -			if (tmp->flags & sd_flag)
>>>> -				sd = tmp;
>>>> -		}
>>>> -		/* while loop will break here if sd == NULL */
>>>
>>> I agree that this should be a major optimization. I just can't figure
>>> out why the existing recursive search for an idle cpu switches to the
>>> new cpu near the end and then starts a search for an idle cpu in the new
>>> cpu's domain. Is this to handle some exotic sched domain configurations?
>>> If so, they probably wouldn't work with your optimizations.
>>
>> Let me explain my understanding of why the recursive search is the way
>> it is.
>>
>>  _________________________  sd0
>> |                         |
>> |  ___sd1__   ___sd2__    |
>> | |        | |        |   |
>> | | sgx    | |  sga   |   |
>> | | sgy    | |  sgb   |   |
>> | |________| |________|   |
>> |_________________________|
>>
>> What the current recursive search is doing is (assuming we start with
>> sd0-the top level sched domain whose flags are rightly set). we find
>> that sd1 is the idlest group,and a cpux1 in sgx is the idlest cpu.
>>
>> We could have ideally stopped the search here.But the problem with this
>> is that there is a possibility that sgx is more loaded than sgy; meaning
>> the cpus in sgx are heavily imbalanced;say there are two cpus cpux1 and
>> cpux2 in sgx,where cpux2 is heavily loaded and cpux1 has recently gotten
>> idle and load balancing has not come to its rescue yet.According to the
>> search above, cpux1 is idle,but is *not the right candidate for
>> scheduling forked task,it is the right candidate for relieving the load
>> from cpux2* due to cache locality etc.
> 
> This corner case may occur after "[PATCH v3 03/22] sched: fix
> find_idlest_group mess logical" brought in the local sched_group bias,
> and assume balancing runs on cpux2.
> ideally,  find_idlest_group should find the real idlest(this case: sgy),
> then, this patch is reasonable.
> 

Sure. but seems it is a bit hard to go down the idlest group.

and the old logical is real cost too much, on my 2 socket NHM/SNB
server, hackbench can increase 2~5% performance. and no clean
performance on kbuild/aim7 etc.

-- 
Thanks
    Alex
