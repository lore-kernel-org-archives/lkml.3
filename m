Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935703Ab3FTCVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:21:23 -0400
Received: from mga03.intel.com ([143.182.124.21]:16182 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935671Ab3FTCVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:21:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,901,1363158000"; 
   d="scan'208";a="319759558"
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
Subject: [Resend patch v8 11/13] sched/cfs_rq: change atomic64_t removed_load to atomic_long_t
Date: Thu, 20 Jun 2013 10:18:55 +0800
Message-Id: <1371694737-29336-12-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like as runnable_load_avg, blocked_load_avg variable, long type is
enough for removed_load in 64 bit or 32 bit machine.

Then we avoid the expensive atomic64 operations on 32 bit machine.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Paul Turner <pjt@google.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/fair.c  | 10 ++++++----
 kernel/sched/sched.h |  3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c2a2a36..8889fbf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1517,8 +1517,9 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 	if (!decays && !force_update)
 		return;
 
-	if (atomic64_read(&cfs_rq->removed_load)) {
-		u64 removed_load = atomic64_xchg(&cfs_rq->removed_load, 0);
+	if (atomic_long_read(&cfs_rq->removed_load)) {
+		unsigned long removed_load;
+		removed_load = atomic_long_xchg(&cfs_rq->removed_load, 0);
 		subtract_blocked_load_contrib(cfs_rq, removed_load);
 	}
 
@@ -3485,7 +3486,8 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 	 */
 	if (se->avg.decay_count) {
 		se->avg.decay_count = -__synchronize_entity_decay(se);
-		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
+		atomic_long_add(se->avg.load_avg_contrib,
+						&cfs_rq->removed_load);
 	}
 }
 #endif /* CONFIG_SMP */
@@ -5947,7 +5949,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #endif
 #if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
 	atomic64_set(&cfs_rq->decay_counter, 1);
-	atomic64_set(&cfs_rq->removed_load, 0);
+	atomic_long_set(&cfs_rq->removed_load, 0);
 #endif
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 78bb990..755d930 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -278,8 +278,9 @@ struct cfs_rq {
 	 * the FAIR_GROUP_SCHED case).
 	 */
 	unsigned long runnable_load_avg, blocked_load_avg;
-	atomic64_t decay_counter, removed_load;
+	atomic64_t decay_counter;
 	u64 last_decay;
+	atomic_long_t removed_load;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* Required to track per-cpu representation of a task_group */
-- 
1.7.12

