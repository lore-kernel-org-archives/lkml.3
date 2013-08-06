Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3HFJYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 05:24:52 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:58390 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab3HFJYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 05:24:51 -0400
Message-ID: <5200C04B.8030507@linux.vnet.ibm.com>
Date: Tue, 06 Aug 2013 14:52:19 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH v2 3/3] sched: clean-up struct sd_lb_stat
References: <1375408223-10934-1-git-send-email-iamjoonsoo.kim@lge.com> <1375408223-10934-4-git-send-email-iamjoonsoo.kim@lge.com> <51FB382B.80209@linux.vnet.ibm.com> <20130805073248.GC27240@lge.com>
In-Reply-To: <20130805073248.GC27240@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080609-7014-0000-0000-0000036DC87A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On 08/05/2013 01:02 PM, Joonsoo Kim wrote:
>>> +	if (busiest->group_imb) {
>>> +		busiest->sum_weighted_load =
>>> +			min(busiest->sum_weighted_load, sds->sd_avg_load);
>>
>> Right here we get confused as to why the total load is being compared
>> against load per task (although you are changing it to load per task above).
> 
> Yes, you are right. I will add load_per_task to struct sg_lb_stats.
> 
> 
>>> @@ -4771,12 +4763,13 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>>>  	 * Be careful of negative numbers as they'll appear as very large values
>>>  	 * with unsigned longs.
>>>  	 */
>>> -	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
>>> +	max_pull = min(busiest->avg_load - sds->sd_avg_load,
>>> +						load_above_capacity);
>>
>> This is ok, but readability wise max_load is much better. max_load
>> signifies the maximum load per task on a group in this sd, and avg_load
>> signifies the total load per task across the sd. You are checking if
>> there is imbalance in the total load in the sd and try to even it out
>> across the sd.  Here "busiest" does not convey this immediately.
> 
> You may be confused. max_load doesn't means the maximum load per task.
> It means that the busiest group's load per cpu power. And here max doesn't
> mean maximum load in this sd, instead, load of busiest sg. IMO,
> busiest->avg_load convey proper meaning.

Yes sorry about that. It is load per cpu power. My point was that 
max_load helped in readability. Look at the these two lines in your patch.

-	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
+	max_pull = min(busiest->avg_load - sds->sd_avg_load,
>>> +						load_above_capacity);

The deleted line says that there is an imbalance in the load/cpu in some 
part of the sd(max_load), which is above the average load of the sd, which
we are trying to even out. Something like the below diagram for the sd load.

  max_load
_/\________ avg_load.

I believe the line you have added makes it hard to understand this.

Anyway this is a minor issue, you can ignore it.

Regards
Preeti U Murthy

