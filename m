Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762906Ab3DCGyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 02:54:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:61215 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762628Ab3DCGyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 02:54:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,399,1363158000"; 
   d="scan'208";a="222214633"
Message-ID: <515BD1FE.7030901@intel.com>
Date: Wed, 03 Apr 2013 14:53:50 +0800
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
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515A9859.6000606@intel.com> <515B97FF.2040409@linux.vnet.ibm.com> <515B9A7A.6030807@intel.com> <515BA0B7.2090906@linux.vnet.ibm.com> <515BAFE6.1020804@intel.com> <515BCA94.6050703@linux.vnet.ibm.com>
In-Reply-To: <515BCA94.6050703@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 02:22 PM, Michael Wang wrote:
>> > 
>> > If many tasks sleep long time, their runnable load are zero. And if they
>> > are waked up bursty, too light runnable load causes big imbalance among
>> > CPU. So such benchmark, like aim9 drop 5~7%.
>> > 
>> > With this patch the losing is covered, and even is slight better.
> A fast test show the improvement disappear and the regression back
> again...after applied this one as the 8th patch, it doesn't works.

It always is good for on benchmark and bad for another. :)

the following patch include the renamed knob, and you can tune it under 
/proc/sys/kernel/... to see detailed impact degree.

>From e540b31b99c887d5a0c5338f7b1f224972b98932 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Tue, 2 Apr 2013 10:27:45 +0800
Subject: [PATCH] sched: use instant load for burst wake up

If many tasks sleep long time, their runnable load are zero. And if they
are waked up bursty, too light runnable load causes big imbalance among
CPU. So such benchmark, like aim9 drop 5~7%.

rq->avg_idle is 'to used to accommodate bursty loads in a dirt simple
dirt cheap manner' -- Mike Galbraith.

With this cheap and smart bursty indicator, we can find the wake up
burst, and just use nr_running as instant utilization only.

The 'sysctl_sched_burst_threshold' used for wakeup burst.

With this patch the losing is covered, and even is slight better.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched/sysctl.h |  1 +
 kernel/sched/fair.c          | 17 +++++++++++++++--
 kernel/sysctl.c              |  7 +++++++
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/sysctl.h b/include/linux/sched/sysctl.h
index bf8086b..a3c3d43 100644
--- a/include/linux/sched/sysctl.h
+++ b/include/linux/sched/sysctl.h
@@ -53,6 +53,7 @@ extern unsigned int sysctl_numa_balancing_settle_count;
 
 #ifdef CONFIG_SCHED_DEBUG
 extern unsigned int sysctl_sched_migration_cost;
+extern unsigned int sysctl_sched_burst_threshold;
 extern unsigned int sysctl_sched_nr_migrate;
 extern unsigned int sysctl_sched_time_avg;
 extern unsigned int sysctl_timer_migration;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index dbaa8ca..f41ca67 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -91,6 +91,7 @@ unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
 unsigned int normalized_sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
+const_debug unsigned int sysctl_sched_burst_threshold = 1000000UL;
 
 /*
  * The exponential sliding  window over which load is averaged for shares
@@ -3103,12 +3104,24 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
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
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index afc1dc6..1f23457 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -327,6 +327,13 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
+		.procname	= "sched_burst_threshold_ns",
+		.data		= &sysctl_sched_burst_threshold,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
 		.procname	= "sched_nr_migrate",
 		.data		= &sysctl_sched_nr_migrate,
 		.maxlen		= sizeof(unsigned int),
-- 
1.7.12


-- 
Thanks Alex
