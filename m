Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3C1Qwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:52:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab3C1Qwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:52:54 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        hpa@zytor.com, rostedt@goodmis.org, akpm@linux-foundation.org,
        tglx@linutronix.de, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 2/4] procfs: add sum_exec_runtime to /proc/PID/stat
Date: Thu, 28 Mar 2013 17:53:23 +0100
Message-Id: <1364489605-5443-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1364489605-5443-1-git-send-email-sgruszka@redhat.com>
References: <1364489605-5443-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow procps programs (i.e. top) to read precise CPU time usage of
processes.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 fs/proc/array.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

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

