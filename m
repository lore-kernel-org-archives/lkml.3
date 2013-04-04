Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab3DDJKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:10:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab3DDJKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:10:11 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 3/4] sched,proc: add csum_sched_runtime to /proc/PID/stat
Date: Thu,  4 Apr 2013 11:10:34 +0200
Message-Id: <1365066635-2959-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
References: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Account precise CPU time used by finished children and export that value
via procfs.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 Documentation/filesystems/proc.txt |    1 +
 fs/proc/array.c                    |    3 +++
 include/linux/sched.h              |   11 +++++++----
 kernel/exit.c                      |    2 ++
 4 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index ffd012b..a0e9162 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -320,6 +320,7 @@ Table 1-4: Contents of the stat files (as of 2.6.30-rc7)
   env_end       address below which program environment is placed
   exit_code     the thread's exit_code in the form reported by the waitpid system call
   exec_time     total process time spent on the CPU, in nanoseconds
+  cexec_time    total finished children time spent on the CPU, in nanoseconds
 ..............................................................................
 
 The /proc/PID/maps file containing the currently mapped memory regions and
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
index 01fc6d4..c25772d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -568,14 +568,17 @@ struct signal_struct {
 	struct task_io_accounting ioac;
 
 	/*
-	 * Cumulative ns of schedule CPU time fo dead threads in the
-	 * group, not including a zombie group leader, (This only differs
-	 * from jiffies_to_ns(utime + stime) if sched_clock uses something
-	 * other than jiffies.)
+	 * Cumulative ns of schedule CPU time of dead threads in the
+	 * group, not including a zombie group leader.
 	 */
 	unsigned long long sum_sched_runtime;
 
 	/*
+	 * Cumulative ns of schedule CPU time of all finished child processes.
+	 */
+	unsigned long long csum_sched_runtime;
+
+	/*
 	 * We don't bother to synchronize most readers of this at all,
 	 * because there is no reader checking a limit that actually needs
 	 * to get both rlim_cur and rlim_max atomically, and either one
diff --git a/kernel/exit.c b/kernel/exit.c
index 27f0907..fb158f1 100644
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

