Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584Ab3DCIM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 04:12:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:14842 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759242Ab3DCIMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 04:12:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,399,1363158000"; 
   d="scan'208";a="312864344"
Message-ID: <515BE452.4030002@intel.com>
Date: Wed, 03 Apr 2013 16:12:02 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v6 11/21] sched: detect wakeup burst with rq->avg_idle
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com> <1364654108-16307-12-git-send-email-alex.shi@intel.com>
In-Reply-To: <1364654108-16307-12-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2013 10:34 PM, Alex Shi wrote:

The 'sysctl_sched_burst_threshold' used for wakeup burst, since we will
check every cpu's avg_idle, the value get be more precise, set 0.1ms.

patch updated.
========

>From 67192d87f9656c3e72bc108ef4648de55d470f4a Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 21 Mar 2013 14:23:00 +0800
Subject: [PATCH 11/21] sched: add sched_burst_threshold_ns as wakeup burst
 indicator

rq->avg_idle is 'to used to accommodate bursty loads in a dirt simple
dirt cheap manner' -- Mike Galbraith.

With this cheap and smart bursty indicator, we can find the wake up
burst, and just use nr_running as instant utilization only.

The 'sysctl_sched_burst_threshold' used for wakeup burst, since we will
check every cpu's avg_idle, the value get be more precise, set 0.1ms.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched/sysctl.h | 1 +
 kernel/sched/fair.c          | 1 +
 kernel/sysctl.c              | 7 +++++++
 3 files changed, 9 insertions(+)

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
index 0c08773..f610313 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -91,6 +91,7 @@ unsigned int sysctl_sched_wakeup_granularity = 1000000UL;
 unsigned int normalized_sysctl_sched_wakeup_granularity = 1000000UL;
 
 const_debug unsigned int sysctl_sched_migration_cost = 500000UL;
+const_debug unsigned int sysctl_sched_burst_threshold = 100000UL;
 
 /*
  * The exponential sliding  window over which load is averaged for shares
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
