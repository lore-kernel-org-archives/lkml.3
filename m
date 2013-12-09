Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645Ab3LIM7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:59:34 -0500
Received: from service87.mimecast.com ([91.220.42.44]:48498 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933272Ab3LIM7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:59:30 -0500
From: Chris Redpath <chris.redpath@arm.com>
To: pjt@google.com, mingo@redhat.com, peterz@infradead.org,
        alex.shi@linaro.org, morten.rasmussen@arm.com,
        dietmar.eggemann@arm.com
Cc: linux-kernel@vger.kernel.org, Chris Redpath <chris.redpath@arm.com>
Subject: [PATCH 2/2] sched: update runqueue clock before migrations away
Date: Mon,  9 Dec 2013 12:59:10 +0000
Message-Id: <1386593950-26475-3-git-send-email-chris.redpath@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>
X-OriginalArrivalTime: 09 Dec 2013 12:59:27.0678 (UTC) FILETIME=[7E27D5E0:01CEF4DE]
X-MC-Unique: 113120912592900501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id rB9CxgcC005433

If we migrate a sleeping task away from a CPU which has the
tick stopped, then both the clock_task and decay_counter will
be out of date for that CPU and we will not decay load correctly
regardless of how often we update the blocked load.

This is only an issue for tasks which are not on a runqueue
(because otherwise that CPU would be awake) and simultaneously
the CPU the task previously ran on has had the tick stopped.

Signed-off-by: Chris Redpath <chris.redpath@arm.com>
---
 kernel/sched/fair.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b7e5945..0af1dc2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4324,6 +4324,7 @@ unlock:
 	return new_cpu;
 }
 
+static int nohz_test_cpu(int cpu);
 /*
  * Called immediately before a task is migrated to a new cpu; task_cpu(p) and
  * cfs_rq_of(p) references at time of call are still valid and identify the
@@ -4343,6 +4344,25 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
 	 * be negative here since on-rq tasks have decay-count == 0.
 	 */
 	if (se->avg.decay_count) {
+		/*
+		 * If we migrate a sleeping task away from a CPU
+		 * which has the tick stopped, then both the clock_task
+		 * and decay_counter will be out of date for that CPU
+		 * and we will not decay load correctly.
+		 */
+		if (!se->on_rq && nohz_test_cpu(task_cpu(p))) {
+			struct rq *rq = cpu_rq(task_cpu(p));
+			unsigned long flags;
+			/*
+			 * Current CPU cannot be holding rq->lock in this
+			 * circumstance, but another might be. We must hold
+			 * rq->lock before we go poking around in its clocks
+			 */
+			raw_spin_lock_irqsave(&rq->lock, flags);
+			update_rq_clock(rq);
+			update_cfs_rq_blocked_load(cfs_rq, 0);
+			raw_spin_unlock_irqrestore(&rq->lock, flags);
+		}
 		se->avg.decay_count = -__synchronize_entity_decay(se);
 		atomic_long_add(se->avg.load_avg_contrib,
 						&cfs_rq->removed_load);
@@ -6507,6 +6527,11 @@ static struct {
 	unsigned long next_balance;     /* in jiffy units */
 } nohz ____cacheline_aligned;
 
+static int nohz_test_cpu(int cpu)
+{
+	return cpumask_test_cpu(cpu, nohz.idle_cpus_mask);
+}
+
 static inline int find_new_ilb(int call_cpu)
 {
 	int ilb = cpumask_first(nohz.idle_cpus_mask);
@@ -6619,6 +6644,11 @@ static int sched_ilb_notifier(struct notifier_block *nfb,
 		return NOTIFY_DONE;
 	}
 }
+#else
+static int nohz_test_cpu(int cpu)
+{
+	return 0;
+}
 #endif
 
 static DEFINE_SPINLOCK(balancing);
-- 
1.7.9.5


