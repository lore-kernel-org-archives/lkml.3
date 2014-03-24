Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbaCXUVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:21:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754294AbaCXUVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:21:04 -0400
Date: Mon, 24 Mar 2014 21:20:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] exec: kill bprm->tcomm[], simplify the "basename" logic
Message-ID: <20140324202025.GA985@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting from c4ad8f98bef7 "execve: use 'struct filename *' for
executable name passing" bprm->filename can not go away after
flush_old_exec(), so we do not need to save the binary name in
bprm->tcomm[] added by 96e02d158678 "exec: fix use-after-free
bug in setup_new_exec()".

And there was never need for filename_to_taskname-like code, we
can simply do set_task_comm(kbasename(filename).

This patch has to change set_task_comm() and trace_task_rename()
to accept "const char *", but I think this change is also good.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c                   |   21 ++-------------------
 include/linux/binfmts.h     |    1 -
 include/linux/sched.h       |    2 +-
 include/trace/events/task.h |    2 +-
 4 files changed, 4 insertions(+), 22 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 3d78fcc..de5faec 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1041,7 +1041,7 @@ EXPORT_SYMBOL_GPL(get_task_comm);
  * so that a new one can be started
  */
 
-void set_task_comm(struct task_struct *tsk, char *buf)
+void set_task_comm(struct task_struct *tsk, const char *buf)
 {
 	task_lock(tsk);
 	trace_task_rename(tsk, buf);
@@ -1050,21 +1050,6 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	perf_event_comm(tsk);
 }
 
-static void filename_to_taskname(char *tcomm, const char *fn, unsigned int len)
-{
-	int i, ch;
-
-	/* Copies the binary name from after last slash */
-	for (i = 0; (ch = *(fn++)) != '\0';) {
-		if (ch == '/')
-			i = 0; /* overwrite what we wrote */
-		else
-			if (i < len - 1)
-				tcomm[i++] = ch;
-	}
-	tcomm[i] = '\0';
-}
-
 int flush_old_exec(struct linux_binprm * bprm)
 {
 	int retval;
@@ -1078,8 +1063,6 @@ int flush_old_exec(struct linux_binprm * bprm)
 		goto out;
 
 	set_mm_exe_file(bprm->mm, bprm->file);
-
-	filename_to_taskname(bprm->tcomm, bprm->filename, sizeof(bprm->tcomm));
 	/*
 	 * Release all of the old mmap stuff
 	 */
@@ -1122,7 +1105,7 @@ void setup_new_exec(struct linux_binprm * bprm)
 	else
 		set_dumpable(current->mm, suid_dumpable);
 
-	set_task_comm(current, bprm->tcomm);
+	set_task_comm(current, kbasename(bprm->filename));
 
 	/* Set the new mm task size. We have to do that late because it may
 	 * depend on TIF_32BIT which is only updated in flush_thread() on
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index b4a745d..61f29e5 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -44,7 +44,6 @@ struct linux_binprm {
 	unsigned interp_flags;
 	unsigned interp_data;
 	unsigned long loader, exec;
-	char tcomm[TASK_COMM_LEN];
 };
 
 #define BINPRM_FLAGS_ENFORCE_NONDUMP_BIT 0
diff --git a/include/linux/sched.h b/include/linux/sched.h
index af42ee2..7653285 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2317,7 +2317,7 @@ extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, i
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 
-extern void set_task_comm(struct task_struct *tsk, char *from);
+extern void set_task_comm(struct task_struct *tsk, const char *from);
 extern char *get_task_comm(char *to, struct task_struct *tsk);
 
 #ifdef CONFIG_SMP
diff --git a/include/trace/events/task.h b/include/trace/events/task.h
index 102a646..dee3bb1 100644
--- a/include/trace/events/task.h
+++ b/include/trace/events/task.h
@@ -32,7 +32,7 @@ TRACE_EVENT(task_newtask,
 
 TRACE_EVENT(task_rename,
 
-	TP_PROTO(struct task_struct *task, char *comm),
+	TP_PROTO(struct task_struct *task, const char *comm),
 
 	TP_ARGS(task, comm),
 
-- 
1.5.5.1


