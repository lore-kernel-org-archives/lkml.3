Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbaABRIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:08:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40350 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaABRIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:08:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Segall <bsegall@google.com>, Peter Zijlstra <peterz@infradead.org>,
        pjt@google.com, Ingo Molnar <mingo@kernel.org>,
        Chris J Arges <chris.j.arges@ubuntu.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 51/91] sched: Avoid throttle_cfs_rq() racing with period_timer stopping
Date: Thu,  2 Jan 2014 09:04:26 -0800
Message-Id: <1388682306-30859-52-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Segall <bsegall@google.com>

commit f9f9ffc237dd924f048204e8799da74f9ecf40cf upstream.

throttle_cfs_rq() doesn't check to make sure that period_timer is running,
and while update_curr/assign_cfs_runtime does, a concurrently running
period_timer on another cpu could cancel itself between this cpu's
update_curr and throttle_cfs_rq(). If there are no other cfs_rqs running
in the tg to restart the timer, this causes the cfs_rq to be stranded
forever.

Fix this by calling __start_cfs_bandwidth() in throttle if the timer is
inactive.

(Also add some sched_debug lines for cfs_bandwidth.)

Tested: make a run/sleep task in a cgroup, loop switching the cgroup
between 1ms/100ms quota and unlimited, checking for timer_active=0 and
throttled=1 as a failure. With the throttle_cfs_rq() change commented out
this fails, with the full patch it passes.

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: pjt@google.com
Link: http://lkml.kernel.org/r/20131016181632.22647.84174.stgit@sword-of-the-dawn.mtv.corp.google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Chris J Arges <chris.j.arges@ubuntu.com>
[ Chris J Arges: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/sched/debug.c | 10 ++++++++++
 kernel/sched/fair.c  |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 7ae4c4c..3539029 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -231,7 +231,17 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 	SEQ_printf(m, "  .%-30s: %d\n", "tg->runnable_avg",
 			atomic_read(&cfs_rq->tg->runnable_avg));
 #endif
+#endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	SEQ_printf(m, "  .%-30s: %d\n", "tg->cfs_bandwidth.timer_active",
+			cfs_rq->tg->cfs_bandwidth.timer_active);
+	SEQ_printf(m, "  .%-30s: %d\n", "throttled",
+			cfs_rq->throttled);
+	SEQ_printf(m, "  .%-30s: %d\n", "throttle_count",
+			cfs_rq->throttle_count);
+#endif
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
 #endif
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e9ab160..6c8930e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2268,6 +2268,8 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->throttled_clock = rq->clock;
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	if (!cfs_b->timer_active)
+		__start_cfs_bandwidth(cfs_b);
 	raw_spin_unlock(&cfs_b->lock);
 }
 
-- 
1.8.3.2

