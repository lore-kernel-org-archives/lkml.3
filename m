Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbaEIPOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:14:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbaEIPOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:14:01 -0400
Message-ID: <536CF004.7090102@redhat.com>
Date: Fri, 09 May 2014 11:11:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de,
        chegu_vinod@hp.com
Subject: Re: [PATCH 2/4] sched,numa: weigh nearby nodes for task placement
 on complex NUMA topologies
References: <1399569811-14362-1-git-send-email-riel@redhat.com> <1399569811-14362-3-git-send-email-riel@redhat.com> <20140509101152.GT30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140509101152.GT30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 06:11 AM, Peter Zijlstra wrote:
> On Thu, May 08, 2014 at 01:23:29PM -0400, riel@redhat.com wrote:
>> @@ -930,7 +987,7 @@ static inline unsigned long group_faults_cpu(struct numa_group *group, int nid)
>>    */
>>   static inline unsigned long task_weight(struct task_struct *p, int nid)
>>   {
>> -	unsigned long total_faults;
>> +	unsigned long total_faults, score;
>>
>>   	if (!p->numa_faults_memory)
>>   		return 0;
>> @@ -940,15 +997,32 @@ static inline unsigned long task_weight(struct task_struct *p, int nid)
>>   	if (!total_faults)
>>   		return 0;
>>
>> -	return 1000 * task_faults(p, nid) / total_faults;
>> +	score = 1000 * task_faults(p, nid);
>> +	score += nearby_nodes_score(p, nid, true);
>> +
>> +	score /= total_faults;
>> +
>> +	return score;
>>   }
>>
>>   static inline unsigned long group_weight(struct task_struct *p, int nid)
>>   {
>> -	if (!p->numa_group || !p->numa_group->total_faults)
>> +	unsigned long total_faults, score;
>> +
>> +	if (!p->numa_group)
>> +		return 0;
>> +
>> +	total_faults = p->numa_group->total_faults;
>> +
>> +	if (!total_faults)
>>   		return 0;
>>
>> -	return 1000 * group_faults(p, nid) / p->numa_group->total_faults;
>> +	score = 1000 * group_faults(p, nid);
>> +	score += nearby_nodes_score(p, nid, false);
>> +
>> +	score /= total_faults;
>> +
>> +	return score;
>>   }
>
> OK, and that's just sad..
>
> See task_numa_placement(), which does:
>
> 	for_each_online_node(nid) {
> 		weight = task_weight(p, nid) + group_weight(p, nid);
> 		if (weight > max_weight) {
> 			max_weight = weight;
> 			max_nid = nid;
> 		}
> 	}
>
> So not only is that loop now O(nr_nodes^2), the inner loops doubly
> iterates all nodes.

I am not too worried about task_numa_placement, but you are
right that this may well be much too expensive for more
frequently called code like migrate_improves_locality.

Having said that, grouping related tasks together on nearby
nodes does seem to bring significant performance gains.

Do you have any ideas on other ways we can achieve that
grouping?

> Also, {task,group}_weight() functions were like cheap-ish (/me mumbles
> something about people using !2^n scaling factors for no sane reason).
> And they're used all over with that in mind.
>
> But look what you did to migrate_improves_locality(), that will now
> iterate all nodes _4_ times, and its called for every single task we try
> and migrate during load balance, while holding rq->lock.
>
>

