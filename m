Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759360AbaGCQ0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:26:22 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45618 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759297AbaGCQ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:26:19 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        peterz@infradead.org, mingo@kernel.org
Cc: rjw@rjwysocki.net, vincent.guittot@linaro.org, daniel.lezcano@linaro.org,
        preeti@linux.vnet.ibm.com, Dietmar.Eggemann@arm.com, pjt@google.com
Subject: [RFCv2 PATCH 10/23] sched: Account for blocked unweighted load waking back up
Date: Thu,  3 Jul 2014 17:25:57 +0100
Message-Id: <1404404770-323-11-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 03 Jul 2014 16:26:14.0162 (UTC) FILETIME=[82178F20:01CF96DB]
X-MC-Unique: 114070317261708801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s63GQR7Q010621

From: Dietmar Eggemann <dietmar.eggemann@arm.com>

Migrate unweighted blocked load of an entity away from the run queue
in case it is migrated to another cpu during wake-up.

This patch is the unweighted counterpart of "sched: Account for blocked
load waking back up" (commit id aff3e4988444).

Note: The unweighted blocked load is not used for energy aware
scheduling yet.

Signed-off-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
---
 kernel/sched/fair.c  |    9 +++++++--
 kernel/sched/sched.h |    2 +-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c6207f7..93c8dbe 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2545,9 +2545,11 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
 		return;
 
 	if (atomic_long_read(&cfs_rq->removed_load)) {
-		unsigned long removed_load;
+		unsigned long removed_load, uw_removed_load;
 		removed_load = atomic_long_xchg(&cfs_rq->removed_load, 0);
-		subtract_blocked_load_contrib(cfs_rq, removed_load, 0);
+		uw_removed_load = atomic_long_xchg(&cfs_rq->uw_removed_load, 0);
+		subtract_blocked_load_contrib(cfs_rq, removed_load,
+					      uw_removed_load);
 	}
 
 	if (decays) {
@@ -4606,6 +4608,8 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 		se->avg.decay_count = -__synchronize_entity_decay(se);
 		atomic_long_add(se->avg.load_avg_contrib,
 						&cfs_rq->removed_load);
+		atomic_long_add(se->avg.uw_load_avg_contrib,
+						&cfs_rq->uw_removed_load);
 	}
 
 	/* We have migrated, no longer consider this task hot */
@@ -7553,6 +7557,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
 #ifdef CONFIG_SMP
 	atomic64_set(&cfs_rq->decay_counter, 1);
 	atomic_long_set(&cfs_rq->removed_load, 0);
+	atomic_long_set(&cfs_rq->uw_removed_load, 0);
 #endif
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 3f1eeb3..d7d2ee2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -340,7 +340,7 @@ struct cfs_rq {
 	unsigned long uw_runnable_load_avg, uw_blocked_load_avg;
 	atomic64_t decay_counter;
 	u64 last_decay;
-	atomic_long_t removed_load;
+	atomic_long_t removed_load, uw_removed_load;
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* Required to track per-cpu representation of a task_group */
-- 
1.7.9.5


