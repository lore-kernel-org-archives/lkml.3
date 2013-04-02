Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760226Ab3DBDYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:24:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:45959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab3DBDYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:24:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,391,1363158000"; 
   d="scan'208";a="310928621"
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
Subject: [patch v3 8/8] sched: use instant load for burst wake up
Date: Tue,  2 Apr 2013 11:23:28 +0800
Message-Id: <1364873008-3169-9-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If many tasks sleep long time, their runnable load are zero. And if they
are waked up bursty, too light runnable load causes big imbalance among
CPU. So such benchmark, like aim9 drop 5~7%.

With this patch the losing is covered, and even is slight better.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fdb88de..c2f6e4e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3103,12 +3103,26 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 	unsigned long weight;
 	int balanced;
 	int runnable_avg;
+	int burst_prev = 0, burst_this = 0;
 
 	idx	  = sd->wake_idx;
 	this_cpu  = smp_processor_id();
 	prev_cpu  = task_cpu(p);
-	load	  = source_load(prev_cpu, idx);
-	this_load = target_load(this_cpu, idx);
+
+	if (cpu_rq(this_cpu)->avg_idle < sysctl_sched_migration_cost)
+		burst_this = 1;
+	if (cpu_rq(prev_cpu)->avg_idle < sysctl_sched_migration_cost)
+		burst_prev = 1;
+
+	/* use instant load on bursty waking up cpu */
+	if (!burst_prev)
+		load = source_load(prev_cpu, idx);
+	else
+		load = cpu_rq(prev_cpu)->load.weight;
+	if (!burst_this)
+		this_load = target_load(this_cpu, idx);
+	else
+		this_load = cpu_rq(this_cpu)->load.weight;
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
-- 
1.7.12

