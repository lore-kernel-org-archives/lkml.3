Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716AbaF1TK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:10:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125AbaF1RsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Dempsky <mdempsky@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 20/77] ptrace: fix fork event messages across pid namespaces
Date: Sat, 28 Jun 2014 10:46:13 -0700
Message-Id: <20140628174522.622058440@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ptrace.h |   32 ++++++++++++++++++++++++++++++++
 kernel/fork.c          |   10 +++++++---
 2 files changed, 39 insertions(+), 3 deletions(-)

--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -5,6 +5,7 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 #include <linux/err.h>			/* for IS_ERR_VALUE */
 #include <linux/bug.h>			/* For BUG_ON.  */
+#include <linux/pid_namespace.h>	/* For task_active_pid_ns.  */
 #include <uapi/linux/ptrace.h>
 
 /*
@@ -129,6 +130,37 @@ static inline void ptrace_event(int even
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
@@ -1607,10 +1607,12 @@ long do_fork(unsigned long clone_flags,
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
@@ -1625,12 +1627,14 @@ long do_fork(unsigned long clone_flags,
 
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


