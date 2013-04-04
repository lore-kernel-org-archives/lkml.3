Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623Ab3DDJK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:10:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab3DDJKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:10:15 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 2/4] procfs: add sum_exec_runtime to /proc/PID/stat
Date: Thu,  4 Apr 2013 11:10:33 +0200
Message-Id: <1365066635-2959-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
References: <1365066635-2959-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow user-space (i.e. top) to read precise CPU time usage of
the process.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 Documentation/filesystems/proc.txt |    1 +
 fs/proc/array.c                    |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index fd8d0d5..ffd012b 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -319,6 +319,7 @@ Table 1-4: Contents of the stat files (as of 2.6.30-rc7)
   env_start     address above which program environment is placed
   env_end       address below which program environment is placed
   exit_code     the thread's exit_code in the form reported by the waitpid system call
+  exec_time     total process time spent on the CPU, in nanoseconds
 ..............................................................................
 
 The /proc/PID/maps file containing the currently mapped memory regions and
diff --git a/fs/proc/array.c b/fs/proc/array.c
index fef7850..ee47b29 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -403,6 +403,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
+	u64 sum_exec_runtime = 0;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
@@ -459,6 +460,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 			thread_group_cputime_adjusted(task, &cputime);
 			utime = cputime.utime;
 			stime = cputime.stime;
+			sum_exec_runtime = cputime.sum_exec_runtime;
 			gtime += sig->gtime;
 		}
 
@@ -475,6 +477,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
 		task_cputime_adjusted(task, &utime, &stime);
+		sum_exec_runtime = task->se.sum_exec_runtime;
 		gtime = task_gtime(task);
 	}
 
@@ -554,6 +557,8 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	else
 		seq_put_decimal_ll(m, ' ', 0);
 
+	seq_put_decimal_ull(m, ' ', sum_exec_runtime);
+
 	seq_putc(m, '\n');
 	if (mm)
 		mmput(mm);
-- 
1.7.1

