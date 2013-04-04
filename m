Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab3DDCFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:05:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:29688 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab3DDCC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:02:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,404,1363158000"; 
   d="scan'208";a="280534395"
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
Subject: [patch v7 09/21] sched: get rq potential maximum utilization
Date: Thu,  4 Apr 2013 10:00:50 +0800
Message-Id: <1365040862-8390-10-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
References: <1365040862-8390-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the rt task priority is higher than fair tasks, cfs_rq utilization
is just the left of rt utilization.

When there are some cfs tasks in queue, the potential utilization may
be yielded, so mulitiplying cfs task number to get max potential
utilization of cfs. Then the rq utilization is sum of rt util and cfs
util.

Thanks for Paul Turner and Namhyung's reminder!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c47933f..70a99c9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3350,6 +3350,27 @@ struct sg_lb_stats {
 	unsigned int group_util;	/* sum utilization of group */
 };
 
+static unsigned long scale_rt_util(int cpu);
+
+/*
+ * max_rq_util - get the possible maximum cpu utilization
+ */
+static unsigned int max_rq_util(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned int rt_util = scale_rt_util(cpu);
+	unsigned int cfs_util;
+	unsigned int nr_running;
+
+	/* yield cfs utilization to rt's, if total utilization > 100% */
+	cfs_util = min(rq->util, (unsigned int)(FULL_UTIL - rt_util));
+
+	/* count transitory task utilization */
+	nr_running = max(rq->cfs.h_nr_running, (unsigned int)1);
+
+	return rt_util + cfs_util * nr_running;
+}
+
 /*
  * sched_balance_self: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
-- 
1.7.12

