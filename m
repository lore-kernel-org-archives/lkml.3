Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab3EJPSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:18:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:13258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab3EJPSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:18:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,648,1363158000"; 
   d="scan'208";a="334911242"
From: Alex Shi <alex.shi@intel.com>
To: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com
Cc: vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        alex.shi@intel.com, mgorman@suse.de, riel@redhat.com,
        wangyun@linux.vnet.ibm.com
Subject: [patch v6 7/8] sched: consider runnable load average in move_tasks
Date: Fri, 10 May 2013 23:17:28 +0800
Message-Id: <1368199049-2798-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
References: <1368199049-2798-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Except using runnable load average in background, move_tasks is also
the key functions in load balance. We need consider the runnable load
average in it in order to the apple to apple load comparison.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0159c85..91e60ac 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4138,11 +4138,11 @@ static int tg_load_down(struct task_group *tg, void *data)
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
@@ -4170,8 +4170,8 @@ static unsigned long task_h_load(struct task_struct *p)
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
 	unsigned long load;
 
-	load = p->se.load.weight;
-	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
+	load = p->se.avg.load_avg_contrib;
+	load = div_u64(load * cfs_rq->h_load, cfs_rq->runnable_load_avg + 1);
 
 	return load;
 }
-- 
1.7.5.4

