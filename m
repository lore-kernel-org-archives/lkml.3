Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbaGHTdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:33:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54158 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755694AbaGHTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steven Rostedt" <rostedt@goodmis.org>,
        "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Oleg Nesterov" <oleg@redhat.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.637630262@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 092/125] tracing: Fix syscall_*regfunc() vs
 copy_process() race
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/trace/syscall.h | 15 +++++++++++++++
 kernel/fork.c           |  2 ++
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
@@ -1370,7 +1370,9 @@ static struct task_struct *copy_process(
 
 	total_forks++;
 	spin_unlock(&current->sighand->siglock);
+	syscall_tracepoint_update(p);
 	write_unlock_irq(&tasklist_lock);
+
 	proc_fork_connector(p);
 	cgroup_post_fork(p);
 	if (clone_flags & CLONE_THREAD)

