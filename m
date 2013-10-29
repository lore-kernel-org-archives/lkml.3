Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab3J2OIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:08:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45895 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3J2OIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:08:19 -0400
Date: Tue, 29 Oct 2013 07:07:49 -0700
From: tip-bot for Ben Segall <tipbot@zytor.com>
Message-ID: <tip-f9f9ffc237dd924f048204e8799da74f9ecf40cf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20131016181632.22647.84174.stgit@sword-of-the-dawn.mtv.corp.google.com>
References: <20131016181632.22647.84174.stgit@sword-of-the-dawn.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Avoid throttle_cfs_rq()
  racing with period_timer stopping
Git-Commit-ID: f9f9ffc237dd924f048204e8799da74f9ecf40cf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 29 Oct 2013 07:07:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9f9ffc237dd924f048204e8799da74f9ecf40cf
Gitweb:     http://git.kernel.org/tip/f9f9ffc237dd924f048204e8799da74f9ecf40cf
Author:     Ben Segall <bsegall@google.com>
AuthorDate: Wed, 16 Oct 2013 11:16:32 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Oct 2013 12:02:32 +0100

sched: Avoid throttle_cfs_rq() racing with period_timer stopping

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
---
 kernel/sched/debug.c | 8 ++++++++
 kernel/sched/fair.c  | 2 ++
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
index 0923ab2..41c02b6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3112,6 +3112,8 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->throttled_clock = rq_clock(rq);
 	raw_spin_lock(&cfs_b->lock);
 	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	if (!cfs_b->timer_active)
+		__start_cfs_bandwidth(cfs_b);
 	raw_spin_unlock(&cfs_b->lock);
 }
 
