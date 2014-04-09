Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934032AbaDIRFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:05:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353AbaDIRFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:05:39 -0400
Date: Wed, 9 Apr 2014 19:05:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH RESEND 1/2] tracing: syscall_*regfunc() can race with
	copy_process()
Message-ID: <20140409170542.GB27638@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com> <1397059882-23063-3-git-send-email-fweisbec@gmail.com> <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com> <20140409124249.4081e665@gandalf.local.home> <20140409170505.GA27638@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409170505.GA27638@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syscall_regfunc() and syscall_unregfunc() should set/clear
TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
with copy_process() and miss the new child which was not added to
init_task.tasks list yet.

Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
under tasklist.

While at it,

	- remove _irqsafe from syscall_regfunc/syscall_unregfunc,
	  read_lock(tasklist) doesn't need to disable irqs.

	- change syscall_unregfunc() to check PF_KTHREAD to skip
	  the kernel threads, ->mm != NULL is the common mistake.

	  Note: probably this check should be simply removed, needs
	  another patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/syscall.h |   15 +++++++++++++++
 kernel/fork.c           |    2 ++
 kernel/tracepoint.c     |   12 +++++-------
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 84bc419..15a954b 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -4,6 +4,7 @@
 #include <linux/tracepoint.h>
 #include <linux/unistd.h>
 #include <linux/ftrace_event.h>
+#include <linux/thread_info.h>
 
 #include <asm/ptrace.h>
 
@@ -31,4 +32,18 @@ struct syscall_metadata {
 	struct ftrace_event_call *exit_event;
 };
 
+#ifdef CONFIG_TRACEPOINTS
+static inline void syscall_tracepoint_update(struct task_struct *p)
+{
+	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
+		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
+	else
+		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
+}
+#else
+static inline void syscall_tracepoint_update(struct task_struct *p)
+{
+}
+#endif
+
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 1766d32..e463f99 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1472,7 +1472,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
+	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
+
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 0c05a45..a16754b 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -732,33 +732,31 @@ static int sys_tracepoint_refcount;
 
 void syscall_regfunc(void)
 {
-	unsigned long flags;
 	struct task_struct *g, *t;
 
 	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
+		read_lock(&tasklist_lock);
 		do_each_thread(g, t) {
 			/* Skip kernel threads. */
-			if (t->mm)
+			if (!(t->flags & PF_KTHREAD))
 				set_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
+		read_unlock(&tasklist_lock);
 	}
 	sys_tracepoint_refcount++;
 }
 
 void syscall_unregfunc(void)
 {
-	unsigned long flags;
 	struct task_struct *g, *t;
 
 	sys_tracepoint_refcount--;
 	if (!sys_tracepoint_refcount) {
-		read_lock_irqsave(&tasklist_lock, flags);
+		read_lock(&tasklist_lock);
 		do_each_thread(g, t) {
 			clear_tsk_thread_flag(t, TIF_SYSCALL_TRACEPOINT);
 		} while_each_thread(g, t);
-		read_unlock_irqrestore(&tasklist_lock, flags);
+		read_unlock(&tasklist_lock);
 	}
 }
 #endif
-- 
1.5.5.1


