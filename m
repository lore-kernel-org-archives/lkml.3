Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934172AbaJ3ORv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:17:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:53723 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaJ3ORu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:17:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,286,1413270000"; 
   d="scan'208";a="628327921"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        juri.lelli@gmail.com, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v2 3/6] sched/dl: add deadline rq status print
Date: Thu, 30 Oct 2014 22:17:00 +0800
Message-Id: <1414678623-13576-3-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1414678623-13576-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1414678623-13576-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add deadline rq status print.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 kernel/sched/deadline.c | 9 +++++++++
 kernel/sched/debug.c    | 7 +++++++
 kernel/sched/sched.h    | 1 +
 3 files changed, 17 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index db6ad38..4c5fdf5 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1727,3 +1727,12 @@ const struct sched_class dl_sched_class = {
 	.switched_from		= switched_from_dl,
 	.switched_to		= switched_to_dl,
 };
+
+#ifdef CONFIG_SCHED_DEBUG
+extern void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq);
+
+void print_dl_stats(struct seq_file *m, int cpu)
+{
+	print_dl_rq(m, cpu, &cpu_rq(cpu)->dl);
+}
+#endif /* CONFIG_SCHED_DEBUG */
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index ce33780..eeb6046 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -261,6 +261,12 @@ void print_rt_rq(struct seq_file *m, int cpu, struct rt_rq *rt_rq)
 #undef P
 }
 
+void print_dl_rq(struct seq_file *m, int cpu, struct dl_rq *dl_rq)
+{
+	SEQ_printf(m, "\ndl_rq[%d]:\n", cpu);
+	SEQ_printf(m, "  .%-30s: %ld\n", "dl_nr_running", dl_rq->dl_nr_running);
+}
+
 extern __read_mostly int sched_clock_running;
 
 static void print_cpu(struct seq_file *m, int cpu)
@@ -329,6 +335,7 @@ do {									\
 	spin_lock_irqsave(&sched_debug_lock, flags);
 	print_cfs_stats(m, cpu);
 	print_rt_stats(m, cpu);
+	print_dl_stats(m, cpu);
 
 	print_rq(m, rq, cpu);
 	spin_unlock_irqrestore(&sched_debug_lock, flags);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ec3917c..3c6cac6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1532,6 +1532,7 @@ extern struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq);
 extern struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq);
 extern void print_cfs_stats(struct seq_file *m, int cpu);
 extern void print_rt_stats(struct seq_file *m, int cpu);
+extern void print_dl_stats(struct seq_file *m, int cpu);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
-- 
1.9.1

