Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967700Ab3E3HEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:04:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:55254 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967724Ab3E3HDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:03:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,769,1363158000"; 
   d="scan'208";a="345550511"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com, Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>
Subject: [patch v7 7/8] sched: consider runnable load average in move_tasks
Date: Thu, 30 May 2013 15:02:03 +0800
Message-Id: <1369897324-16646-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
References: <1369897324-16646-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Except using runnable load average in background, move_tasks is also
the key functions in load balance. We need consider the runnable load
average in it in order to the apple to apple load comparison.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index eadd2e7..bb2470a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4178,11 +4178,11 @@ static int tg_load_down(struct task_group *tg, void *data)
 	long cpu = (long)data;
 
 	if (!tg->parent) {
-		load = cpu_rq(cpu)->load.weight;
+		load = cpu_rq(cpu)->avg.load_avg_contrib;
 	} else {
 		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->se[cpu]->load.weight;
-		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+		load *= tg->se[cpu]->avg.load_avg_contrib;
+		load /= tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;
 	}
 
 	tg->cfs_rq[cpu]->h_load = load;
@@ -4210,8 +4210,8 @@ static unsigned long task_h_load(struct task_struct *p)
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 	unsigned long load;
 
-	load = p->se.load.weight;
-	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
+	load = p->se.avg.load_avg_contrib;
+	load = div_u64(load * cfs_rq->h_load, cfs_rq->runnable_load_avg + 1);
 
 	return load;
 }
-- 
1.7.12

