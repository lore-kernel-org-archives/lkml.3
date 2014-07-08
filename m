Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbaGHTW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:22:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54245 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755736AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jan Kratochvil" <jan.kratochvil@redhat.com>,
        "Matthew Dempsky" <mdempsky@chromium.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Roland McGrath" <mcgrathr@chromium.org>,
        "Kees Cook" <keescook@chromium.org>,
        "Julien Tinnes" <jln@chromium.org>, "Oleg Nesterov" <oleg@redhat.com>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.888246203@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 065/125] ptrace: fix fork event messages across pid
 namespaces
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Dempsky <mdempsky@chromium.org>

commit 4e52365f279564cef0ddd41db5237f0471381093 upstream.

When tracing a process in another pid namespace, it's important for fork
event messages to contain the child's pid as seen from the tracer's pid
namespace, not the parent's.  Otherwise, the tracer won't be able to
correlate the fork event with later SIGTRAP signals it receives from the
child.

We still risk a race condition if a ptracer from a different pid
namespace attaches after we compute the pid_t value.  However, sending a
bogus fork event message in this unlikely scenario is still a vast
improvement over the status quo where we always send bogus fork event
messages to debuggers in a different pid namespace than the forking
process.

Signed-off-by: Matthew Dempsky <mdempsky@chromium.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Julien Tinnes <jln@chromium.org>
Cc: Roland McGrath <mcgrathr@chromium.org>
Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/ptrace.h | 32 ++++++++++++++++++++++++++++++++
 kernel/fork.c          | 10 +++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -112,6 +112,7 @@
 
 #include <linux/compiler.h>		/* For unlikely.  */
 #include <linux/sched.h>		/* For struct task_struct.  */
+#include <linux/pid_namespace.h>	/* For task_active_pid_ns.  */
 
 
 extern long arch_ptrace(struct task_struct *child, long request,
@@ -204,6 +205,37 @@ static inline void ptrace_event(int even
 }
 
 /**
+ * ptrace_event_pid - possibly stop for a ptrace event notification
+ * @event:	%PTRACE_EVENT_* value to report
+ * @pid:	process identifier for %PTRACE_GETEVENTMSG to return
+ *
+ * Check whether @event is enabled and, if so, report @event and @pid
+ * to the ptrace parent.  @pid is reported as the pid_t seen from the
+ * the ptrace parent's pid namespace.
+ *
+ * Called without locks.
+ */
+static inline void ptrace_event_pid(int event, struct pid *pid)
+{
+	/*
+	 * FIXME: There's a potential race if a ptracer in a different pid
+	 * namespace than parent attaches between computing message below and
+	 * when we acquire tasklist_lock in ptrace_stop().  If this happens,
+	 * the ptracer will get a bogus pid from PTRACE_GETEVENTMSG.
+	 */
+	unsigned long message = 0;
+	struct pid_namespace *ns;
+
+	rcu_read_lock();
+	ns = task_active_pid_ns(rcu_dereference(current->parent));
+	if (ns)
+		message = pid_nr_ns(pid, ns);
+	rcu_read_unlock();
+
+	ptrace_event(event, message);
+}
+
+/**
  * ptrace_init_task - initialize ptrace state for a new child
  * @child:		new child task
  * @ptrace:		true if child should be ptrace'd by parent's tracer
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1513,10 +1513,12 @@ long do_fork(unsigned long clone_flags,
 	 */
 	if (!IS_ERR(p)) {
 		struct completion vfork;
+		struct pid *pid;
 
 		trace_sched_process_fork(current, p);
 
-		nr = task_pid_vnr(p);
+		pid = get_task_pid(p, PIDTYPE_PID);
+		nr = pid_vnr(pid);
 
 		if (clone_flags & CLONE_PARENT_SETTID)
 			put_user(nr, parent_tidptr);
@@ -1540,14 +1542,16 @@ long do_fork(unsigned long clone_flags,
 
 		/* forking complete and child started to run, tell ptracer */
 		if (unlikely(trace))
-			ptrace_event(trace, nr);
+			ptrace_event_pid(trace, pid);
 
 		if (clone_flags & CLONE_VFORK) {
 			freezer_do_not_count();
 			wait_for_completion(&vfork);
 			freezer_count();
-			ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
+			ptrace_event_pid(PTRACE_EVENT_VFORK_DONE, pid);
 		}
+
+		put_pid(pid);
 	} else {
 		nr = PTR_ERR(p);
 	}

