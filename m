Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaDRAZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:25:44 -0400
Received: from smtp.outflux.net ([198.145.64.163]:41184 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaDRAYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:24:35 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>,
        John Johansen <john.johansen@canonical.com>,
        Will Drewry <wad@chromium.org>, Julien Tinnes <jln@chromium.org>,
        linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [PATCH v3 5/5] seccomp: add SECCOMP_EXT_ACT_TSYNC and SECCOMP_FILTER_TSYNC
Date: Thu, 17 Apr 2014 17:24:20 -0700
Message-Id: <1397780660-24750-6-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397780660-24750-1-git-send-email-keescook@chromium.org>
References: <1397780660-24750-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applying restrictive seccomp filter programs to large or diverse
codebases often requires handling threads which may be started early in
the process lifetime (e.g., by code that is linked in). While it is
possible to apply permissive programs prior to process start up, it is
difficult to further restrict the kernel ABI to those threads after that
point.

This change adds a new seccomp extension action for synchronizing thread
group seccomp filters and a prctl() for accessing that functionality,
as well as a flag for SECCOMP_EXT_ACT_FILTER to perform sync at filter
installation time.

When calling prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT_FILTER, flags, filter)
with flags containing SECCOMP_FILTER_TSYNC, or when calling
prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT_TSYNC, 0, 0), it will attempt to
synchronize all threads in current's threadgroup to its seccomp
filter program. This is possible iff all threads are using a filter that
is an ancestor to the filter current is attempting to synchronize to. NULL
filters (where the task is running as SECCOMP_MODE_NONE) are also treated
as ancestors allowing threads to be transitioned into SECCOMP_MODE_FILTER.
On success, 0 is returned. On failure, the pid of one of the failing
threads will be returned, with as many filters installed as possible.

The race conditions are against another thread calling TSYNC, another
thread performing a clone, and another thread changing its filter. The
seccomp write lock is sufficient for these cases, though the clone
case is assisted by the tasklist_lock so that new threads must have a
duplicate of its parent seccomp state when it appears on the tasklist.

Based on patches by Will Drewry.

Suggested-by: Julien Tinnes <jln@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/prctl/seccomp_filter.txt |   20 +++++-
 include/uapi/linux/seccomp.h           |    4 ++
 kernel/seccomp.c                       |  104 ++++++++++++++++++++++++++++++--
 3 files changed, 122 insertions(+), 6 deletions(-)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index ea6bb5576fdc..7bae09f20338 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -235,5 +235,21 @@ prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT_FILTER, flags, prog):
 	Attach filter, with flags.
 
 	This is the same as prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, prog)
-	except with the addition of optional "flags" argument. No flags
-	are currently recognized.
+	except with the addition of optional "flags" argument:
+
+	SECCOMP_FILTER_TSYNC:
+		After installing filter, perform threadgroup sync, as
+		described below for SECCOMP_EXT_ACT_TSYNC.
+
+prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT_TSYNC, 0, 0):
+	Thread synchronization.
+
+	The current thread requests to synchronize all threads in current's
+	threadgroup to its seccomp filter program. This is possible iff all
+	threads are using a filter that is an ancestor to the filter current
+	is attempting to synchronize to, or the thread has not yet entered
+	seccomp.
+
+	On success, 0 is returned. On failure, all synchronizable threads
+	will have been synchronized, and the pid of any of the failing
+	threads will be returned.
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index d7ad626c684d..7f4431b90fd4 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -15,6 +15,10 @@
 
 /* Valid extension actions as arg3 to prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT) */
 #define SECCOMP_EXT_ACT_FILTER	1 /* apply seccomp-bpf filter with flags */
+#define SECCOMP_EXT_ACT_TSYNC	2 /* synchronize threadgroup filters */
+
+/* Flags for prctl arg4 when calling SECCOMP_EXT_ACT_FILTER */
+#define SECCOMP_FILTER_TSYNC	1 /* synchronize threadgroup to filter */
 
 /*
  * All BPF programs must return a 32-bit value.
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 6b582f73c5de..8b12ae826122 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -24,6 +24,7 @@
 #ifdef CONFIG_SECCOMP_FILTER
 #include <asm/syscall.h>
 #include <linux/filter.h>
+#include <linux/pid.h>
 #include <linux/ptrace.h>
 #include <linux/security.h>
 #include <linux/slab.h>
@@ -198,6 +199,91 @@ static u32 seccomp_run_filters(int syscall)
 	return ret;
 }
 
+/* Returns 1 if the candidate is an ancestor. */
+static int is_ancestor(struct seccomp_filter *candidate,
+		       struct seccomp_filter *child)
+{
+	/* NULL is the root ancestor. */
+	if (candidate == NULL)
+		return 1;
+	for (; child; child = child->prev)
+		if (child == candidate)
+			return 1;
+	return 0;
+}
+
+/* Expects locking and sync suitability to have been done already. */
+static void seccomp_sync_thread(struct task_struct *caller,
+				struct task_struct *thread)
+{
+	/* Get a task reference for the new leaf node. */
+	get_seccomp_filter(caller);
+	/*
+	 * Drop the task reference to the shared ancestor since
+	 * current's path will hold a reference.  (This also
+	 * allows a put before the assignment.)
+	 */
+	put_seccomp_filter(thread);
+	thread->seccomp.filter = caller->seccomp.filter;
+	/* Opt the other thread into seccomp if needed.
+	 * As threads are considered to be trust-realm
+	 * equivalent (see ptrace_may_access), it is safe to
+	 * allow one thread to transition the other.
+	 */
+	if (thread->seccomp.mode == SECCOMP_MODE_DISABLED) {
+		thread->seccomp.mode = SECCOMP_MODE_FILTER;
+		/*
+		 * Don't let an unprivileged task work around
+		 * the no_new_privs restriction by creating
+		 * a thread that sets it up, enters seccomp,
+		 * then dies.
+		 */
+		if (task_no_new_privs(caller))
+			task_set_no_new_privs(thread);
+		set_tsk_thread_flag(thread, TIF_SECCOMP);
+	}
+}
+
+/**
+ * seccomp_act_sync_threads: sets all threads to use current's filter
+ *
+ * Returns 0 on success, -ve on error, or the pid of a thread which was
+ * either not in the correct seccomp mode or it did not have an ancestral
+ * seccomp filter.
+ */
+static pid_t seccomp_act_sync_threads(void)
+{
+	struct task_struct *thread, *caller;
+	pid_t failed = 0;
+
+	if (current->seccomp.mode != SECCOMP_MODE_FILTER)
+		return -EACCES;
+
+	write_lock(&tasklist_lock);
+	thread = caller = current;
+	while_each_thread(caller, thread) {
+		seccomp_lock(thread);
+		/*
+		 * Validate thread being eligible for synchronization.
+		 */
+		if (thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
+		    (thread->seccomp.mode == SECCOMP_MODE_FILTER &&
+		     is_ancestor(thread->seccomp.filter,
+				 caller->seccomp.filter))) {
+			seccomp_sync_thread(caller, thread);
+		} else {
+			/* Keep the last sibling that failed to return. */
+			failed = task_pid_vnr(thread);
+			/* If the pid cannot be resolved, then return -ESRCH */
+			if (failed == 0)
+				failed = -ESRCH;
+		}
+		seccomp_unlock(thread);
+	}
+	write_unlock(&tasklist_lock);
+	return failed;
+}
+
 /**
  * seccomp_attach_filter: Attaches a seccomp filter to current.
  * @fprog: BPF program to install
@@ -317,21 +403,26 @@ out:
  * @flags:  flags from SECCOMP_FILTER_* to change behavior
  * @filter: struct sock_fprog for use with SECCOMP_MODE_FILTER
  *
- * Return 0 on success, -ve on error.
+ * Return 0 on success, -ve on error, or thread pid that caused failures.
  */
 static long seccomp_act_filter(unsigned long flags, char * __user filter)
 {
 	long ret;
 
-	/* No flags currently recognized. */
-	if (flags != 0)
+	/* Only SECCOMP_FILTER_TSYNC is recognized. */
+	if ((flags & ~(SECCOMP_FILTER_TSYNC)) != 0)
 		return -EINVAL;
 
 	seccomp_lock(current);
 	ret = _seccomp_set_mode(SECCOMP_MODE_FILTER, filter);
 	seccomp_unlock(current);
+	if (ret)
+		return ret;
 
-	return ret;
+	if (flags & SECCOMP_FILTER_TSYNC)
+		return seccomp_act_sync_threads();
+
+	return 0;
 }
 
 /**
@@ -347,6 +438,11 @@ static long seccomp_extended_action(int action, unsigned long arg1,
 	switch (action) {
 	case SECCOMP_EXT_ACT_FILTER:
 		return seccomp_act_filter(arg1, (char * __user)arg2);
+	case SECCOMP_EXT_ACT_TSYNC:
+		/* arg1 and arg2 are currently unused. */
+		if (arg1 || arg2)
+			return -EINVAL;
+		return seccomp_act_sync_threads();
 	default:
 		break;
 	}
-- 
1.7.9.5

