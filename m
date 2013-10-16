Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103Ab3JPSqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:46:47 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:43090 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584Ab3JPSqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:46:45 -0400
Subject: [PATCH 5/5] sched: Avoid throttle_cfs_rq racing with period_timer
 stopping
To: peterz@infradead.org, mingo@redhat.com
From: Ben Segall <bsegall@google.com>
Cc: pjt@google.com, linux-kernel@vger.kernel.org
Date: Wed, 16 Oct 2013 11:16:32 -0700
Message-ID: <20131016181632.22647.84174.stgit@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20131016181548.22647.17161.stgit@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

throttle_cfs_rq doesn't check to make sure that period_timer is running,
and while update_curr/assign_cfs_runtime does, a concurrently running
period_timer on another cpu could cancel itself between this cpu's
update_curr and throttle_cfs_rq. If there are no other cfs_rqs running
in the tg to restart the timer, this causes the cfs_rq to be stranded
forever.

Fix this by calling __start_cfs_bandwidth in throttle if the timer is
inactive.

Also add some sched_debug lines for cfs_bandwidth.

Tested: make a run/sleep task in a cgroup, loop switching the cgroup
between 1ms/100ms quota and unlimited, checking for timer_active=0 and
throttled=1 as a failure. With the throttle_cfs_rq change commented out
this fails, with the full patch it passes.

Signed-off-by: Ben Segall <bsegall@google.com>
---
 kernel/sched/debug.c |    8 ++++++++
 kernel/sched/fair.c  |    2 ++
 2 files changed, 10 insertions(+)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index e6ba5e3..5c34d18 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -229,6 +229,14 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			atomic_read(&cfs_rq->tg->runnable_avg));
 #endif
 #endif
+#ifdef CONFIG_CFS_BANDWIDTH
+	SEQ_printf(m, "  .%-30s: %d\n", "tg->cfs_bandwidth.timer_active",
+			cfs_rq->tg->cfs_bandwidth.timer_active);
+	SEQ_printf(m, "  .%-30s: %d\n", "throttled",
+			cfs_rq->throttled);
+	SEQ_printf(m, "  .%-30s: %d\n", "throttle_count",
+			cfs_rq->throttle_count);
+#endif
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	print_cfs_group_stats(m, cpu, cfs_rq->tg);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 424c294..2dc6fbe 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3121,6 +3121,8 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->throttled_clock = rq_clock(rq);
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	if (!cfs_b->timer_active)
+		__start_cfs_bandwidth(cfs_b);
 	raw_spin_unlock(&cfs_b->lock);
 }
 

