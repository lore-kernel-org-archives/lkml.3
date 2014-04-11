Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbaDKSEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:04:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbaDKSEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:04:13 -0400
Message-ID: <53482E77.7030802@redhat.com>
Date: Fri, 11 Apr 2014 14:03:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        chegu_vinod@hp.com, mgorman@suse.de
Subject: Re: [PATCH 2/3] sched,numa: retry placement more frequently when
 misplaced
References: <1397235629-16328-1-git-send-email-riel@redhat.com>	 <1397235629-16328-3-git-send-email-riel@redhat.com> <1397238417.7113.29.camel@joe-AO722>
In-Reply-To: <1397238417.7113.29.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 01:46 PM, Joe Perches wrote:
> On Fri, 2014-04-11 at 13:00 -0400, riel@redhat.com wrote:
>> This patch reduces the interval at which migration is retried,
>> when the task's numa_scan_period is small.
> 
> More style trivia and a question.
> 
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> []
>> @@ -1326,12 +1326,15 @@ static int task_numa_migrate(struct task_struct *p)
>>  /* Attempt to migrate a task to a CPU on the preferred node. */
>>  static void numa_migrate_preferred(struct task_struct *p)
>>  {
>> +	unsigned long interval = HZ;
> 
> Perhaps it'd be better without the unnecessary initialization.
> 
>>  	/* This task has no NUMA fault statistics yet */
>>  	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults_memory))
>>  		return;
>>  
>>  	/* Periodically retry migrating the task to the preferred node */
>> -	p->numa_migrate_retry = jiffies + HZ;
>> +	interval = min(interval, msecs_to_jiffies(p->numa_scan_period) / 16);
> 
> and use
> 
> 	interval = min_t(unsigned long, HZ,
> 			 msecs_to_jiffies(p->numa_scan_period) / 16);

That's what I had before, but spilling things over across
multiple lines like that didn't exactly help readability.

> btw; why 16?
> 
> Can msecs_to_jiffies(p->numa_scan_period) ever be < 16?

I picked 16 because there is a cost tradeoff between unmapping
and faulting (and potentially migrating) a task's memory, which
is very expensive, and searching for a better NUMA node to run
on, which is potentially slightly expensive.

This way we may run on the wrong NUMA node for around 6% of the
time between unmapping all of the task's memory (and faulting
it back in with NUMA hinting faults), before retrying migration
of the task to a better node.

I suppose it is possible for a sysadmin to set the minimum
numa scan period to under 16 milliseconds, but if your system
is trying to unmap all of a task's memory every 16 milliseconds,
and fault it back in, task placement is likely to be the least
of your problems :)

-- 
All rights reversed
