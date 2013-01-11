Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3AKDp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 22:45:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:49158 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab3AKDp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 22:45:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,449,1355126400"; 
   d="scan'208";a="272523770"
Message-ID: <50EF8B37.7050404@intel.com>
Date: Fri, 11 Jan 2013 11:47:03 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 17/22] sched: packing small tasks in wake/exec balancing
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-18-git-send-email-alex.shi@intel.com> <20130110171728.GG2046@e103034-lin>
In-Reply-To: <20130110171728.GG2046@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2013 01:17 AM, Morten Rasmussen wrote:
> On Sat, Jan 05, 2013 at 08:37:46AM +0000, Alex Shi wrote:
>> If the wake/exec task is small enough, utils < 12.5%, it will
>> has the chance to be packed into a cpu which is busy but still has space to
>> handle it.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  kernel/sched/fair.c | 51 +++++++++++++++++++++++++++++++++++++++++++++------
>>  1 file changed, 45 insertions(+), 6 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 8d0d3af..0596e81 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3471,19 +3471,57 @@ static inline int get_sd_sched_policy(struct sched_domain *sd,
>>  }
>>  
>>  /*
>> + * find_leader_cpu - find the busiest but still has enough leisure time cpu
>> + * among the cpus in group.
>> + */
>> +static int
>> +find_leader_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>> +{
>> +	unsigned vacancy, min_vacancy = UINT_MAX;
> 
> unsigned int?

yes
> 
>> +	int idlest = -1;
>> +	int i;
>> +	/* percentage the task's util */
>> +	unsigned putil = p->se.avg.runnable_avg_sum * 100
>> +				/ (p->se.avg.runnable_avg_period + 1);
> 
> Alternatively you could use se.avg.load_avg_contrib which is the same
> ratio scaled by the task priority (se->load.weight). In the above
> expression you don't take priority into account.

sure. but this seems more directly of meaningful.
> 
>> +
>> +	/* Traverse only the allowed CPUs */
>> +	for_each_cpu_and(i, sched_group_cpus(group), tsk_cpus_allowed(p)) {
>> +		struct rq *rq = cpu_rq(i);
>> +		int nr_running = rq->nr_running > 0 ? rq->nr_running : 1;
>> +
>> +		/* only pack task which putil < 12.5% */
>> +		vacancy = FULL_UTIL - (rq->util * nr_running + putil * 8);
> 
> I can't follow this expression.
> 
> The variables can have the following values:
> FULL_UTIL  = 99
> rq->util   = [0..99]
> nr_running = [1..inf]
> putil      = [0..99]
> 
> Why multiply rq->util by nr_running?
> 
> Let's take an example where rq->util = 50, nr_running = 2, and putil =
> 10. In this case the value of putil doesn't really matter as vacancy
> would be negative anyway since FULL_UTIL - rq->util * nr_running is -1.
> However, with rq->util = 50 there should be plenty of spare cpu time to
> take another task.

for this example, the util is not full maybe due to it was just wake up,
it still is possible like to run full time. So, I try to give it the
large guess load.
> 
> Also, why multiply putil by 8? rq->util must be very close to 0 for
> vacancy to be positive if putil is close to 12 (12.5%).

just want to pack small util tasks, since packing is possible to hurt
performance.
> 
> The vacancy variable is declared unsigned, so it will underflow instead
> of becoming negative. Is this intentional?

ops, my mistake.
> 
> I may be missing something, but could the expression be something like
> the below instead?
> 
> Create a putil < 12.5% check before the loop. There is no reason to
> recheck it every iteration. Then:
> 
> vacancy = FULL_UTIL - (rq->util + putil)
> 
> should be enough?
> 
>> +
>> +		/* bias toward local cpu */
>> +		if (vacancy > 0 && (i == this_cpu))
>> +			return i;
>> +
>> +		if (vacancy > 0 && vacancy < min_vacancy) {
>> +			min_vacancy = vacancy;
>> +			idlest = i;
> 
> "idlest" may be a bit misleading here as you actually select busiest cpu
> that have enough spare capacity to take the task.

Um, change to leader_cpu?
> 
> Morten
> 
