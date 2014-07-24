Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbaGXKYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:24:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54679 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbaGXJrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 023/128] tracing: Fix syscall_*regfunc() vs copy_process() race
Date: Thu, 24 Jul 2014 10:44:32 +0100
Message-Id: <1406195177-8656-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 4af4206be2bd1933cae20c2b6fb2058dbc887f7c upstream.

syscall_regfunc() and syscall_unregfunc() should set/clear
TIF_SYSCALL_TRACEPOINT system-wide, but do_each_thread() can race
with copy_process() and miss the new child which was not added to
the process/thread lists yet.

Change copy_process() to update the child's TIF_SYSCALL_TRACEPOINT
under tasklist.

Link: http://lkml.kernel.org/p/20140413185854.GB20668@redhat.com

Fixes: a871bd33a6c0 "tracing: Add syscall tracepoints"
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/trace/syscall.h | 15 +++++++++++++++
 kernel/fork.c           |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index fed853f3d7aa..9674145e2f6a 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -4,6 +4,7 @@
 #include <linux/tracepoint.h>
 #include <linux/unistd.h>
 #include <linux/ftrace_event.h>
+#include <linux/thread_info.h>
 
 #include <asm/ptrace.h>
 
@@ -32,4 +33,18 @@ struct syscall_metadata {
 	struct ftrace_event_call *exit_event;
 };
 
+#if defined(CONFIG_TRACEPOINTS) && defined(CONFIG_HAVE_SYSCALL_TRACEPOINTS)
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
index 2782836d8adc..8c8cb29ebc95 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1491,7 +1491,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
+	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
+
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)
-- 
1.9.1

