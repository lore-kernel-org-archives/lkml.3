Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab3DDCFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:05:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:29708 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932558Ab3DDCCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534441"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, jkosina@suse.cz, clark.williams@gmail.com,
        tony.luck@intel.com, keescook@chromium.org, mgorman@suse.de,
        riel@redhat.com
Subject: [patch v7 11/21] sched: add sched_burst_threshold_ns as wakeup burst indicator
Date: Thu,  4 Apr 2013 10:00:52 +0800
Message-Id: <1365040862-8390-12-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

