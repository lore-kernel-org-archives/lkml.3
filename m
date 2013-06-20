Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935673Ab3FTCVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:21:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:6154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935648Ab3FTCVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:21:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,901,1363158000"; 
   d="scan'208";a="319759507"
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
Subject: [Resend patch v8 07/13] sched: consider runnable load average in move_tasks
Date: Thu, 20 Jun 2013 10:18:51 +0800
Message-Id: <1371694737-29336-8-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Except using runnable load average in background, move_tasks is also
the key functions in load balance. We need consider the runnable load
average in it in order to the apple to apple load comparison.

Morten had caught a div u64 bug on ARM, thanks!

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7d5c477..ddbc19f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4184,11 +4184,14 @@ static int tg_load_down(struct task_group *tg, void *data)
 	long cpu = (long)data;
 
 	if (!tg->parent) {
-		load = cpu_rq(cpu)->load.weight;
+		load = cpu_rq(cpu)->avg.load_avg_contrib;
 	} else {
+		unsigned long tmp_rla;
+		tmp_rla = tg->parent->cfs_rq[cpu]->runnable_load_avg + 1;
+
 		load = tg->parent->cfs_rq[cpu]->h_load;
-		load *= tg->se[cpu]->load.weight;
-		load /= tg->parent->cfs_rq[cpu]->load.weight + 1;
+		load *= tg->se[cpu]->avg.load_avg_contrib;
+		load /= tmp_rla;
 	}
 
 	tg->cfs_rq[cpu]->h_load = load;
@@ -4214,12 +4217,9 @@ static void update_h_load(long cpu)
 static unsigned long task_h_load(struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
-	unsigned long load;
-
-	load = p->se.load.weight;
-	load = div_u64(load * cfs_rq->h_load, cfs_rq->load.weight + 1);
 
-	return load;
+	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
+			cfs_rq->runnable_load_avg + 1);
 }
 #else
 static inline void update_blocked_averages(int cpu)
@@ -4232,7 +4232,7 @@ static inline void update_h_load(long cpu)
 
 static unsigned long task_h_load(struct task_struct *p)
 {
-	return p->se.load.weight;
+	return p->se.avg.load_avg_contrib;
 }
 #endif
 
-- 
1.7.12

