Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282Ab3DCE2q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 00:28:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:26276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760139Ab3DCE2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 00:28:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,397,1363158000"; 
   d="scan'208";a="288568909"
Message-ID: <515BAFE6.1020804@intel.com>
Date: Wed, 03 Apr 2013 12:28:22 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515A9859.6000606@intel.com> <515B97FF.2040409@linux.vnet.ibm.com> <515B9A7A.6030807@intel.com> <515BA0B7.2090906@linux.vnet.ibm.com>
In-Reply-To: <515BA0B7.2090906@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 11:23 AM, Michael Wang wrote:
> On 04/03/2013 10:56 AM, Alex Shi wrote:
>> On 04/03/2013 10:46 AM, Michael Wang wrote:
>>> | 15 GB   |      16 | 45110 |   | 48091 |
>>> | 15 GB   |      24 | 41415 |   | 47415 |
>>> | 15 GB   |      32 | 35988 |   | 45749 |	+27.12%
>>>
>>> Very nice improvement, I'd like to test it with the wake-affine throttle
>>> patch later, let's see what will happen ;-)
>>>
>>> Any idea on why the last one caused the regression?
>>
>> you can change the burst threshold: sysctl_sched_migration_cost, to see
>> what's happen with different value. create a similar knob and tune it.
>> +
>> +	if (cpu_rq(this_cpu)->avg_idle < sysctl_sched_migration_cost)
>> +		burst_this = 1;
>> +	if (cpu_rq(prev_cpu)->avg_idle < sysctl_sched_migration_cost)
>> +		burst_prev = 1;
>> +
>>
>>
> 
> This changing the rate of adopt cpu_rq(cpu)->load.weight, correct?
> 
> So if rq is busy, cpu_rq(cpu)->load.weight is capable enough to stand
> for the load status of rq? what's the really idea here?

This patch try to resolved the aim7 liked benchmark regression.
If many tasks sleep long time, their runnable load are zero. And then if 
they are waked up bursty, too light runnable load causes big imbalance in
 select_task_rq. So such benchmark, like aim9 drop 5~7%.

this patch try to detect the burst, if so, it use load weight directly not
 zero runnable load avg to avoid the imbalance.

but the patch may cause some unfairness if this/prev cpu are not burst at 
same time. So could like try the following patch?


>From 4722a7567dccfb19aa5afbb49982ffb6d65e6ae5 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Tue, 2 Apr 2013 10:27:45 +0800
Subject: [PATCH] sched: use instant load for burst wake up

If many tasks sleep long time, their runnable load are zero. And if they
are waked up bursty, too light runnable load causes big imbalance among
CPU. So such benchmark, like aim9 drop 5~7%.

With this patch the losing is covered, and even is slight better.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dbaa8ca..25ac437 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3103,12 +3103,24 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	unsigned long weight;
 	int balanced;
 	int runnable_avg;
+	int burst = 0;
 
 	idx	  = sd->wake_idx;
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
-	load	  = source_load(prev_cpu, idx);
-	this_load = target_load(this_cpu, idx);
+
+	if (cpu_rq(this_cpu)->avg_idle < sysctl_sched_migration_cost ||
+		cpu_rq(prev_cpu)->avg_idle < sysctl_sched_migration_cost)
+		burst= 1;
+
+	/* use instant load for bursty waking up */
+	if (!burst) {
+		load = source_load(prev_cpu, idx);
+		this_load = target_load(this_cpu, idx);
+	} else {
+		load = cpu_rq(prev_cpu)->load.weight;
+		this_load = cpu_rq(this_cpu)->load.weight;
+	}
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
-- 
1.7.12

