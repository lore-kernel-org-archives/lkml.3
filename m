Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3EFBqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 21:46:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:64038 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab3EFBqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 21:46:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,618,1363158000"; 
   d="scan'208";a="308658667"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [PATCH v5 6/7] sched: consider runnable load average in move_tasks
Date: Mon,  6 May 2013 09:45:10 +0800
Message-Id: <1367804711-30308-7-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Except using runnable load average in background, move_tasks is also
the key functions in load balance. We need consider the runnable load
average in it in order to the apple to apple load comparison.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0bf88e8..790e23d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3966,6 +3966,12 @@ static unsigned long task_h_load(struct task_struct *p);
 
 static const unsigned int sched_nr_migrate_break = 32;
 
+static unsigned long task_h_load_avg(struct task_struct *p)
+{
+	return div_u64(task_h_load(p) * (u64)p->se.avg.runnable_avg_sum,
+			p->se.avg.runnable_avg_period + 1);
+}
+
 /*
  * move_tasks tries to move up to imbalance weighted load from busiest to
  * this_rq, as part of a balancing operation within domain "sd".
@@ -4001,7 +4007,7 @@ static int move_tasks(struct lb_env *env)
 		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
 			goto next;
 
-		load = task_h_load(p);
+		load = task_h_load_avg(p);
 
 		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
-- 
1.7.12

