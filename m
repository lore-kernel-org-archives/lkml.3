Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614Ab3CQSaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 14:30:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429Ab3CQSag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 14:30:36 -0400
Date: Sun, 17 Mar 2013 19:28:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] tracing: syscall_*regfunc() can race with
	copy_process()
Message-ID: <20130317182831.GA22986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130317182814.GA22968@redhat.com>
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
 kernel/fork.c       |    7 +++++++
 kernel/tracepoint.c |   12 +++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1766d32..8184a53 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1472,7 +1472,14 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
+#ifdef CONFIG_TRACEPOINTS
+	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
+		set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
+	else
+		clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
+#endif
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

