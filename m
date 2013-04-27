Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab3D0F13 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 01:27:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:2129 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755880Ab3D0F1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 01:27:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,562,1363158000"; 
   d="scan'208";a="328478897"
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
Subject: [PATCH v4 5/6] sched: consider runnable load average in move_tasks
Date: Sat, 27 Apr 2013 13:25:43 +0800
Message-Id: <1367040344-14485-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1367040344-14485-1-git-send-email-alex.shi@intel.com>
References: <1367040344-14485-1-git-send-email-alex.shi@intel.com>
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
index ca63c9f..995dfc7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3989,6 +3989,15 @@ static unsigned long task_h_load(struct task_struct *p);
 
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
@@ -4024,7 +4033,7 @@ static int move_tasks(struct lb_env *env)
 		if (!can_migrate_task(p, env))
 			goto next;
 
-		load = task_h_load(p);
+		load = task_h_load_avg(p);
 
 		if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
 			goto next;
-- 
1.7.12

