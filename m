Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3C1Qw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:52:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926Ab3C1Qwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:52:54 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        hpa@zytor.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 3/4] sched,proc: add csum_sched_runtime
Date: Thu, 28 Mar 2013 17:53:24 +0100
Message-Id: <1364489605-5443-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1364489605-5443-1-git-send-email-sgruszka@redhat.com>
References: <1364489605-5443-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account and export via proc scheduler calculated time of children
execution.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 fs/proc/array.c       |    3 +++
 include/linux/sched.h |    1 +
 kernel/exit.c         |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index ee47b29..1444dc5 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -404,6 +404,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
 	u64 sum_exec_runtime = 0;
+	u64 csum_exec_runtime = 0;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -442,6 +443,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		cutime = sig->cutime;
 		cstime = sig->cstime;
 		cgtime = sig->cgtime;
+		csum_exec_runtime = sig->csum_sched_runtime;
 		rsslim = ACCESS_ONCE(sig->rlim[RLIMIT_RSS].rlim_cur);
 
 		/* add up live thread stats at the group level */
@@ -558,6 +560,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		seq_put_decimal_ll(m, ' ', 0);
 
 	seq_put_decimal_ull(m, ' ', sum_exec_runtime);
+	seq_put_decimal_ull(m, ' ', csum_exec_runtime);
 
 	seq_putc(m, '\n');
 	if (mm)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index eb6005c..6673a59 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -574,6 +574,7 @@ struct signal_struct {
 	 * other than jiffies.)
 	 */
 	unsigned long long sum_sched_runtime;
+	unsigned long long csum_sched_runtime;
 
 	/*
 	 * We don't bother to synchronize most readers of this at all,
diff --git a/kernel/exit.c b/kernel/exit.c
index 5a7023f..eda4fa7 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1094,6 +1094,8 @@ static int wait_task_zombie(struct wait_opts *wo, struct task_struct *p)
 		sig = p->signal;
 		psig->cutime += tg_cputime.utime + sig->cutime;
 		psig->cstime += tg_cputime.stime + sig->cstime;
+		psig->csum_sched_runtime +=
+			tg_cputime.sum_exec_runtime + sig->csum_sched_runtime;
 		psig->cgtime += task_gtime(p) + sig->gtime + sig->cgtime;
 		psig->cmin_flt +=
 			p->min_flt + sig->min_flt + sig->cmin_flt;
-- 
1.7.1

