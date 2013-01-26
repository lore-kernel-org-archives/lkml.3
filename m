Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3AZBte (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:49:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:39598 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab3AZBtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:49:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,542,1355126400"; 
   d="scan'208";a="276820883"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [RFC patch v2 6/7] sched: consider runnable load average in move_tasks
Date: Sat, 26 Jan 2013 09:49:23 +0800
Message-Id: <1359164964-29052-7-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
References: <1359164964-29052-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Except using runnable load average in background, move_tasks is also
the key functions in load balance. We need consider the runnable load
average in it in order to the apple to apple load comparison.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 729221b..84bb3f7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3978,6 +3978,15 @@ static unsigned long task_h_load(struct task_struct *p);
 
 static const unsigned int sched_nr_migrate_break = 32;
 
+static unsigned long task_h_load_avg(struct task_struct *p)
+{
+	u32 period = p->se.avg.runnable_avg_period;
+	if (!period)
+		return 0;
+
+	return task_h_load(p) * p->se.avg.runnable_avg_sum / period;
+}
+
 /*
  * move_tasks tries to move up to imbalance weighted load from busiest to
  * this_rq, as part of a balancing operation within domain "sd".
@@ -4013,7 +4022,7 @@ static int move_tasks(struct lb_env *env)
 		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
 			goto next;
 
-		load = task_h_load(p);
+		load = task_h_load_avg(p);
 
 		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
-- 
1.7.12

