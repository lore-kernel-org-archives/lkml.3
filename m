Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbaAWKtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:49:43 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41116 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaAWKtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:49:41 -0500
Message-ID: <52E0F3BF.5020904@linaro.org>
Date: Thu, 23 Jan 2014 18:49:35 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@redhat.com>,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, Mike Galbraith <efault@gmx.de>,
        wangyun@linux.vnet.ibm.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched: add statistic for rq->max_idle_balance_cost
References: <1390282399-17091-1-git-send-email-alex.shi@linaro.org> <1390282399-17091-2-git-send-email-alex.shi@linaro.org> <CAGQ1y=4rgj8qPeKQhNTA5__VzrOQ1uCqFZrVLO3MO9MfL+6UEg@mail.gmail.com> <52DF802D.4030608@linaro.org> <20140122160901.GW13532@twins.programming.kicks-ass.net> <1390414208.2866.11.camel@j-VirtualBox> <52E0BB75.2080102@linaro.org> <20140123095443.GQ30183@twins.programming.kicks-ass.net>
In-Reply-To: <20140123095443.GQ30183@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 05:54 PM, Peter Zijlstra wrote:
> On Thu, Jan 23, 2014 at 02:49:25PM +0800, Alex Shi wrote:
>> On 01/23/2014 02:10 AM, Jason Low wrote:
>>>>>>>  	P64(avg_idle);
>>>>>>> +	P64(max_idle_balance_cost);
>>>>>>>  #endif
>>>>>>>   	P(ttwu_count);
>>>>>
>>>>> Not also the per-sd value in sd_alloc_ctl_domain_table() ?
>>> Yeah, tracking the sd->max_newidle_lb_cost can also be useful.
>>>
>>>
>>
>> Thanks for suggestion!
>>
>> I thought the sd->max_newidle_lb_cost keep changing. But yes, it's
>> still meaningful. 
>> BTW, in the pandaboard ES, sd balance cost is about 1~2ms.
> 
> That's an insane amount of time for only 2 cpus.

maybe, :(

but it is the data.
$ cat /proc/sys/kernel/sched_domain/cpu0/domain0/max_newidle_lb_cost
1873393

> 
>> ---
>>

[...]
>>  sd_alloc_ctl_domain_table(struct sched_domain *sd)
>>  {
>> -	struct ctl_table *table = sd_alloc_ctl_entry(8);
>> +	struct ctl_table *table = sd_alloc_ctl_entry(9);
> 
> tip/master has 13 there, not 8.
> 

Sorry about this. updated on tip/master.

-----

>From c49ae4749ffa2d1f95bd0d8b3c8e6fbce8864f04 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@linaro.org>
Date: Thu, 23 Jan 2014 18:39:54 +0800
Subject: [PATCH] sched: add statistic for newidle load balance cost

Tracking rq->max_idle_balance_cost and sd->max_newidle_lb_cost.
It's useful to know these values in debug mode.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 kernel/sched/core.c  | 9 ++++++---
 kernel/sched/debug.c | 1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 36c951b..4740456 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4815,7 +4815,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(13);
+	struct ctl_table *table = sd_alloc_ctl_entry(14);
 
 	if (table == NULL)
 		return NULL;
@@ -4843,9 +4843,12 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(int), 0644, proc_dointvec_minmax, false);
 	set_table_entry(&table[10], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax, false);
-	set_table_entry(&table[11], "name", sd->name,
+	set_table_entry(&table[11], "max_newidle_lb_cost",
+		&sd->max_newidle_lb_cost,
+		sizeof(long), 0644, proc_doulongvec_minmax, false);
+	set_table_entry(&table[12], "name", sd->name,
 		CORENAME_MAX_SIZE, 0444, proc_dostring, false);
-	/* &table[12] is terminator */
+	/* &table[13] is terminator */
 
 	return table;
 }
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index dd52e7f..7f17a38 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -321,6 +321,7 @@ do {									\
 	P(sched_goidle);
 #ifdef CONFIG_SMP
 	P64(avg_idle);
+	P64(max_idle_balance_cost);
 #endif
 
 	P(ttwu_count);
-- 
1.8.1.2


-- 
Thanks
    Alex
