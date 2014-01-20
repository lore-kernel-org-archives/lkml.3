Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaATTDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:03:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaATTDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:03:07 -0500
Message-ID: <52DD72C8.2050602@redhat.com>
Date: Mon, 20 Jan 2014 14:02:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, chegu_vinod@hp.com,
        mgorman@suse.de, mingo@redhat.com
Subject: Re: [PATCH 6/7] numa,sched: normalize faults_from stats and weigh
 by CPU use
References: <1389993129-28180-1-git-send-email-riel@redhat.com> <1389993129-28180-7-git-send-email-riel@redhat.com> <20140120165747.GL31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140120165747.GL31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 11:57 AM, Peter Zijlstra wrote:
> On Fri, Jan 17, 2014 at 04:12:08PM -0500, riel@redhat.com wrote:
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 0af6c1a..52de567 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1471,6 +1471,8 @@ struct task_struct {
>>  	int numa_preferred_nid;
>>  	unsigned long numa_migrate_retry;
>>  	u64 node_stamp;			/* migration stamp  */
>> +	u64 last_task_numa_placement;
>> +	u64 last_sum_exec_runtime;
>>  	struct callback_head numa_work;
>>  
>>  	struct list_head numa_entry;
> 
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 8e0a53a..0d395a0 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1422,11 +1422,41 @@ static void update_task_scan_period(struct task_struct *p,
>>  	memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
>>  }
>>  
>> +/*
>> + * Get the fraction of time the task has been running since the last
>> + * NUMA placement cycle. The scheduler keeps similar statistics, but
>> + * decays those on a 32ms period, which is orders of magnitude off
>> + * from the dozens-of-seconds NUMA balancing period. Use the scheduler
>> + * stats only if the task is so new there are no NUMA statistics yet.
>> + */
>> +static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
>> +{
>> +	u64 runtime, delta, now;
>> +	/* Use the start of this time slice to avoid calculations. */
>> +	now = p->se.exec_start;
>> +	runtime = p->se.sum_exec_runtime;
>> +
>> +	if (p->last_task_numa_placement) {
>> +		delta = runtime - p->last_sum_exec_runtime;
>> +		*period = now - p->last_task_numa_placement;
>> +	} else {
>> +		delta = p->se.avg.runnable_avg_sum;
>> +		*period = p->se.avg.runnable_avg_period;
>> +	}
>> +
>> +	p->last_sum_exec_runtime = runtime;
>> +	p->last_task_numa_placement = now;
>> +
>> +	return delta;
>> +}
> 
> Have you tried what happens if you use p->se.avg.runnable_avg_sum /
> p->se.avg.runnable_avg_period instead? If that also works it avoids
> growing the datastructures and keeping of yet another set of runtime
> stats.

That is what I started out with, and the results were not
as stable as with this calculation.

Having said that, I did that before I came up with patch 7/7,
so maybe the effect would no longer be as pronounced any more
as it was before...

I can send in a simplified version, if you prefer.

-- 
All rights reversed
