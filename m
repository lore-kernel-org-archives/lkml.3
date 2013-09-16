Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3IPIGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 04:06:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:37206 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab3IPIGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 04:06:15 -0400
Message-ID: <5236BBF0.8030505@parallels.com>
Date: Mon, 16 Sep 2013 12:06:08 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [PATCH 1/2] sched: calculate_imbalance: Fix local->avg_load >
 sds->avg_load case
References: <8f596cc6bc0e5e655119dc892c9bfcad26e971f4.1379252740.git.vdavydov@parallels.com> <20130916055202.GL21832@twins.programming.kicks-ass.net>
In-Reply-To: <20130916055202.GL21832@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.22.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2013 09:52 AM, Peter Zijlstra wrote:
> On Sun, Sep 15, 2013 at 05:49:13PM +0400, Vladimir Davydov wrote:
>> In busiest->group_imb case we can come to calculate_imbalance() with
>> local->avg_load >= busiest->avg_load >= sds->avg_load. This can result
>> in imbalance overflow, because it is calculated as follows
>>
>> env->imbalance = min(
>> 	max_pull * busiest->group_power,
>> 	(sds->avg_load - local->avg_load) * local->group_power
>> ) / SCHED_POWER_SCALE;
>>
>> As a result we can end up constantly bouncing tasks from one cpu to
>> another if there are pinned tasks.
>>
>> Fix this by skipping the assignment and assuming imbalance=0 in case
>> local->avg_load > sds->avg_load.
>> --
>> The bug can be caught by running 2*N cpuhogs pinned to two logical cpus
>> belonging to different cores on an HT-enabled machine with N logical
>> cpus: just look at se.nr_migrations growth.
>>
>> Signed-off-by: Vladimir Davydov<vdavydov@parallels.com>
>> ---
>>   kernel/sched/fair.c |    3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 9b3fe1c..507a8a9 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -4896,7 +4896,8 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>>   	 * max load less than avg load(as we skip the groups at or below
>>   	 * its cpu_power, while calculating max_load..)
>>   	 */
>> -	if (busiest->avg_load < sds->avg_load) {
>> +	if (busiest->avg_load <= sds->avg_load ||
>> +	    local->avg_load >= sds->avg_load) {
>>   		env->imbalance = 0;
>>   		return fix_small_imbalance(env, sds);
>>   	}
> Why the = part? Surely 'busiest->avg_load < sds->avg_load ||
> local->avg_load > sds->avg_load' avoids both underflows?

Of course it does, but env->imbalance will be assigned to 0 anyway in = 
case, so why not go shortcut?
