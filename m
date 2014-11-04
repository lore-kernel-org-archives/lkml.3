Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbaKDQMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:12:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59533 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbaKDQMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:12:17 -0500
Date: Tue, 4 Nov 2014 08:11:24 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-acb32132ec0433c03bed750f3e9508dc29db0328@git.kernel.org>
Cc: juri.lelli@arm.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@kernel.org, tglx@linutronix.de,
        ktkhai@parallels.com, peterz@infradead.org, wanpeng.li@linux.intel.com
Reply-To: linux-kernel@vger.kernel.org, juri.lelli@arm.com, hpa@zytor.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@kernel.org,
        wanpeng.li@linux.intel.com, peterz@infradead.org, ktkhai@parallels.com
In-Reply-To: <1414708776-124078-3-git-send-email-wanpeng.li@linux.intel.com>
References: <1414708776-124078-3-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Add deadline rq status print
Git-Commit-ID: acb32132ec0433c03bed750f3e9508dc29db0328
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acb32132ec0433c03bed750f3e9508dc29db0328
Gitweb:     http://git.kernel.org/tip/acb32132ec0433c03bed750f3e9508dc29db0328
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Fri, 31 Oct 2014 06:39:33 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:54 +0100

sched/deadline: Add deadline rq status print

This patch add deadline rq status print.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414708776-124078-3-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 9 +++++++++
 kernel/sched/debug.c    | 7 +++++++
 kernel/sched/sched.h    | 1 +
 3 files changed, 17 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index c047a94..8867a67 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1747,3 +1747,12 @@ const struct sched_class dl_sched_class = {
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
index 49b941f..7e5c1ee 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1537,6 +1537,7 @@ extern struct sched_entity *__pick_first_entity(struct cfs_rq *cfs_rq);
 extern struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq);
 extern void print_cfs_stats(struct seq_file *m, int cpu);
 extern void print_rt_stats(struct seq_file *m, int cpu);
+extern void print_dl_stats(struct seq_file *m, int cpu);
 
 extern void init_cfs_rq(struct cfs_rq *cfs_rq);
 extern void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq);
