Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbaD2UVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 16:21:16 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36363 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaD2UVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 16:21:15 -0400
From: Matthew Dempsky <mdempsky@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Dempsky <mdempsky@chromium.org>, Kees Cook <keescook@chromium.org>,
        Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v4] ptrace: Fix fork event messages across pid namespaces
Date: Tue, 29 Apr 2014 13:20:58 -0700
Message-Id: <1398802858-13624-1-git-send-email-mdempsky@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1396492005-23811-1-git-send-email-mdempsky@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4 resend:
	- Ran "git pull --rebase"; no code changes needed.

v4:
	- Refactor out ptrace_event_pid() to dedup FIXME code
	- Handle task_active_pid_ns() returning NULL
	- Use rcu_dereference() for accessing current->parent

v3:
        - Respond to Oleg feedback about p possibly already exiting
          and adding proper locking
        - Add comment warning that race condition still exists
        - Removed selftest to instead be included with other ptrace tests
        - Removed ptrace_message zero'ing; to be handled in followup patch

v2:
        - Moved selftests/ptrace-pidns into selftests/ptrace as pidns-events
          per feedback from Kees.

8>--------------------------------------------------------------------<8

When tracing a process in another pid namespace, it's important for
fork event messages to contain the child's pid as seen from the
tracer's pid namespace, not the parent's.  Otherwise, the tracer won't
be able to correlate the fork event with later SIGTRAP signals it
receives from the child.

We still risk a race condition if a ptracer from a different pid
namespace attaches after we compute the pid_t value.  However, sending
a bogus fork event message in this unlikely scenario is still a vast
improvement over the status quo where we always send bogus fork event
messages to debuggers in a different pid namespace than the forking
process.

Signed-off-by: Matthew Dempsky <mdempsky@chromium.org>
---
 include/linux/ptrace.h | 31 +++++++++++++++++++++++++++++++
 kernel/fork.c          | 10 +++++++---
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 07d0df6..219c52c 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 #include <linux/err.h>			/* for IS_ERR_VALUE */
 #include <linux/bug.h>			/* For BUG_ON.  */
+#include <linux/pid_namespace.h>	/* For task_active_pid_ns.  */
 #include <uapi/linux/ptrace.h>
 
 /*
@@ -129,6 +130,36 @@ static inline void ptrace_event(int event, unsigned long message)
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
+	 * and when we acquire tasklist_lock in ptrace_stop().
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
diff --git a/kernel/fork.c b/kernel/fork.c
index 54a8d26..1429043 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1606,10 +1606,12 @@ long do_fork(unsigned long clone_flags,
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
@@ -1624,12 +1626,14 @@ long do_fork(unsigned long clone_flags,
 
 		/* forking complete and child started to run, tell ptracer */
 		if (unlikely(trace))
-			ptrace_event(trace, nr);
+			ptrace_event_pid(trace, pid);
 
 		if (clone_flags & CLONE_VFORK) {
 			if (!wait_for_vfork_done(p, &vfork))
-				ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
+				ptrace_event_pid(PTRACE_EVENT_VFORK_DONE, pid);
 		}
+
+		put_pid(pid);
 	} else {
 		nr = PTR_ERR(p);
 	}
-- 
1.9.1.423.g4596e3a
