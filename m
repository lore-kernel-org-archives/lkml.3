Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab3DCIqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:46:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:58528 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932216Ab3DCIqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:46:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,399,1363158000"; 
   d="scan'208";a="288656088"
Message-ID: <515BEC5F.60001@intel.com>
Date: Wed, 03 Apr 2013 16:46:23 +0800
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
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com>
In-Reply-To: <515A877B.3020908@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 03:23 PM, Michael Wang wrote:
> | 15 GB   |      12 | 45393 |   | 43986 |
> | 15 GB   |      16 | 45110 |   | 45719 |
> | 15 GB   |      24 | 41415 |   | 36813 |	-11.11%
> | 15 GB   |      32 | 35988 |   | 34025 |
> 
> The reason may caused by wake_affine()'s higher overhead, and pgbench is
> really sensitive to this stuff...

Michael:
I changed the threshold to 0.1ms it has same effect on aim7.
So could you try the following on pgbench?


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
index dbaa8ca..dd5a324 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -91,6 +91,7 @@ unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
 unsigned int normalized_sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
+const_debug unsigned int sysctl_sched_burst_threshold = 100000UL;
 
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
+	if (cpu_rq(this_cpu)->avg_idle < sysctl_sched_burst_threshold ||
+		cpu_rq(prev_cpu)->avg_idle < sysctl_sched_burst_threshold)
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
Thanks Alex
