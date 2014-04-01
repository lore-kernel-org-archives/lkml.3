Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaDAW3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:29:52 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62090 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaDAW3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:29:51 -0400
From: Matthew Dempsky <mdempsky@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matthew Dempsky <mdempsky@chromium.org>, Kees Cook <keescook@chromium.org>,
        Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] ptrace: Fix fork event messages across pid namespaces
Date: Tue,  1 Apr 2014 15:29:18 -0700
Message-Id: <1396391358-22367-1-git-send-email-mdempsky@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com>
References: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revised patch below.  Unfortunately, I just realized I don't have my
test machine handy, so I won't be able to test it until tomorrow.

v3:
        - Respond to Oleg feedback about p possibly already exiting
          and adding proper locking
        - Add comment warning that race condition still exists
        - Removed selftest to instead be included with other ptrace tests
        - Removed ptrace_message zero'ing; to be handled in followup patch

8>--------------------------------------------------------------------<8

When tracing a thread in another pid namespace, it's important for
fork event messages to contain the child's pid as seen from the
tracer's pid namespace, not the parent's.  Otherwise, the tracer won't
be able to correlate the fork event with later SIGTRAP signals it
receives from the child.

We still (at least theoretically) risk sending a bogus fork event
message if a debugger from pid namespace A detaches and then another
debugger from pid namespace B attaches right away.  But this is still
an improvement from the status quo where we always send bogus fork
event messages when the debugger is in a different pid namespace than
the parent.

Signed-off-by: Matthew Dempsky <mdempsky@chromium.org>
---
 kernel/fork.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 332688e..d928761 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1605,10 +1605,12 @@ long do_fork(unsigned long clone_flags,
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
@@ -1622,13 +1624,35 @@ long do_fork(unsigned long clone_flags,
 		wake_up_new_task(p);
 
 		/* forking complete and child started to run, tell ptracer */
-		if (unlikely(trace))
-			ptrace_event(trace, nr);
+		if (unlikely(trace)) {
+			/*
+			 * We want to report the child's pid as seen from the
+			 * tracer's pid namespace.
+			 * FIXME: We still risk sending a bogus event message if
+			 * debuggers from different pid namespaces detach and
+			 * reattach between rcu_read_unlock() and ptrace_stop().
+			 */
+			unsigned long message;
+			rcu_read_lock();
+			message = pid_nr_ns(pid,
+				task_active_pid_ns(current->parent));
+			rcu_read_unlock();
+			ptrace_event(trace, message);
+		}
 
 		if (clone_flags & CLONE_VFORK) {
-			if (!wait_for_vfork_done(p, &vfork))
-				ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
+			if (!wait_for_vfork_done(p, &vfork)) {
+				/* See comment above about pid namespaces. */
+				unsigned long message;
+				rcu_read_lock();
+				message = pid_nr_ns(pid,
+					task_active_pid_ns(current->parent));
+				rcu_read_unlock();
+				ptrace_event(PTRACE_EVENT_VFORK_DONE, message);
+			}
 		}
+
+		put_pid(pid);
 	} else {
 		nr = PTR_ERR(p);
 	}
-- 
1.9.1.423.g4596e3a
