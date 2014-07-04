Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030846AbaGDWSN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:18:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030800AbaGDWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:18:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.4 19/19] tracing: Fix syscall_*regfunc() vs copy_process() race
Date: Fri,  4 Jul 2014 15:15:29 -0700
Message-Id: <20140704221437.311827316@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221436.423715636@linuxfoundation.org>
References: <20140704221436.423715636@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/trace/syscall.h |   15 +++++++++++++++
 kernel/fork.c           |    2 ++
 2 files changed, 17 insertions(+)

--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -4,6 +4,7 @@
 #include <linux/tracepoint.h>
 #include <linux/unistd.h>
 #include <linux/ftrace_event.h>
+#include <linux/thread_info.h>
 
 #include <asm/ptrace.h>
 
@@ -54,4 +55,18 @@ int perf_sysexit_enable(struct ftrace_ev
 void perf_sysexit_disable(struct ftrace_event_call *call);
 #endif
 
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
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1441,7 +1441,9 @@ static struct task_struct *copy_process(
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
+	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
+
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)


