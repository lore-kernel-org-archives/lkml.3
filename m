Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041Ab3C3OkJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:40:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:36513 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab3C3OgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:36:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,378,1363158000"; 
   d="scan'208";a="220568258"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v6 10/21] sched: get rq potential maximum utilization
Date: Sat, 30 Mar 2013 22:34:57 +0800
Message-Id: <1364654108-16307-11-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the rt task priority is higher than fair tasks, cfs_rq utilization
is just the left of rt utilization.

When there are some cfs tasks in queue, the potential utilization may
be yielded, so mulitiplying cfs task number to get max potential
utilization of cfs. Then the rq utilization is sum of rt util and cfs
util.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ae87dab..0feeaee 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3350,6 +3350,22 @@ struct sg_lb_stats {
 	unsigned int group_util;	/* sum utilization of group */
 };
 
+static unsigned long scale_rt_util(int cpu);
+
+static unsigned int max_rq_util(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned int rt_util = scale_rt_util(cpu);
+	unsigned int cfs_util;
+	unsigned int nr_running;
+
+	cfs_util = (FULL_UTIL - rt_util) > rq->util ? rq->util
+			: (FULL_UTIL - rt_util);
+	nr_running = rq->nr_running ? rq->nr_running : 1;
+
+	return rt_util + cfs_util * nr_running;
+}
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
-- 
1.7.12

