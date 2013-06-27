Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3F0JDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:03:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46083 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab3F0JDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:03:25 -0400
Date: Thu, 27 Jun 2013 02:02:50 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-2509940fd71c2e2915a05052bbdbf2d478364184@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, alex.shi@intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, alex.shi@intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1371694737-29336-12-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-12-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cfs_rq:
  Change atomic64_t removed_load to atomic_long_t
Git-Commit-ID: 2509940fd71c2e2915a05052bbdbf2d478364184
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:02:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2509940fd71c2e2915a05052bbdbf2d478364184
Gitweb:     http://git.kernel.org/tip/2509940fd71c2e2915a05052bbdbf2d478364184
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:55 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:41 +0200

sched/cfs_rq: Change atomic64_t removed_load to atomic_long_t

Similar to runnable_load_avg, blocked_load_avg variable, long type is
enough for removed_load in 64 bit or 32 bit machine.

Then we avoid the expensive atomic64 operations on 32 bit machine.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Paul Turner <pjt@google.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-12-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c  | 10 ++++++----
 kernel/sched/sched.h |  3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 30ccc37..b43474a 100644
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
 
@@ -3480,7 +3481,8 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 	 */
 	if (se->avg.decay_count) {
 		se->avg.decay_count = -__synchronize_entity_decay(se);
-		atomic64_add(se->avg.load_avg_contrib, &cfs_rq->removed_load);
+		atomic_long_add(se->avg.load_avg_contrib,
+						&cfs_rq->removed_load);
 	}
 }
 #endif /* CONFIG_SMP */
@@ -5942,7 +5944,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #endif
 #ifdef CONFIG_SMP
 	atomic64_set(&cfs_rq->decay_counter, 1);
-	atomic64_set(&cfs_rq->removed_load, 0);
+	atomic_long_set(&cfs_rq->removed_load, 0);
 #endif
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 5585eb2..7059919 100644
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
