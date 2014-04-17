Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaDQSH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 14:07:27 -0400
Received: from smtp.outflux.net ([198.145.64.163]:55131 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbaDQSFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 14:05:31 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: John Johansen <john.johansen@canonical.com>,
        Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v2 3/3] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
Date: Thu, 17 Apr 2014 11:05:04 -0700
Message-Id: <1397757904-30665-4-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397757904-30665-1-git-send-email-keescook@chromium.org>
References: <1397757904-30665-1-git-send-email-keescook@chromium.org>
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

This change adds a new seccomp "extension" for synchronizing thread
group seccomp filters and a prctl() for accessing that functionality.
The need for the added prctl() is due to the lack of reserved arguments
in PR_SET_SECCOMP (much existing code already calls prctl without
initializing trailing arguments).

When prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT_TSYNC, 0, 0) is called, it will
attempt to synchronize all threads in current's threadgroup to its seccomp
filter program. This is possible iff all threads are using a filter that
is an ancestor to the filter current is attempting to synchronize to. NULL
filters (where the task is running as SECCOMP_MODE_NONE) are also treated
as ancestors allowing threads to be transitioned into SECCOMP_MODE_FILTER.
On success, 0 is returned. On failure, the pid of one of the failing
threads will be returned.

The possible race conditions are against another thread calling TSYNC,
another thread performing a clone, and another thread changing its
filter. The seccomp write lock is sufficient for these cases, though the
clone case is assisted by the tasklist_lock so that new threads must have
a duplicate of its parent seccomp state when it appears on the tasklist.

Based on patches by Will Drewry.

Suggested-by: Julien Tinnes <jln@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/prctl/seccomp_filter.txt |   20 +++++
 include/linux/seccomp.h                |    7 ++
 include/uapi/linux/prctl.h             |    6 ++
 include/uapi/linux/seccomp.h           |    6 ++
 kernel/seccomp.c                       |  128 ++++++++++++++++++++++++++++++++
 kernel/sys.c                           |    3 +
 6 files changed, 170 insertions(+)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index 1e469ef75778..632f7d9fcfb2 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -223,3 +223,23 @@ Note that modern systems are unlikely to use vsyscalls at all -- they
 are a legacy feature and they are considerably slower than standard
 syscalls.  New code will use the vDSO, and vDSO-issued system calls
 are indistinguishable from normal system calls.
+
+
+
+Extensions
+----------
+Additional seccomp extensions are available through prctl using
+PR_SECCOMP_EXT, with the extension as the following argument.
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
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index d05f1f1b8b10..a34a6bc76d3d 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -82,6 +82,8 @@ static inline int seccomp_mode(struct seccomp *s)
 #ifdef CONFIG_SECCOMP_FILTER
 extern void put_seccomp_filter(struct task_struct *tsk);
 extern void get_seccomp_filter(struct task_struct *tsk);
+extern long prctl_seccomp_ext(unsigned long, unsigned long,
+			      unsigned long, unsigned long);
 #else  /* CONFIG_SECCOMP_FILTER */
 static inline void put_seccomp_filter(struct task_struct *tsk)
 {
@@ -91,5 +93,10 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
 {
 	return;
 }
+static inline long prctl_seccomp_ext(unsigned long arg2, unsigned long arg3,
+				     unsigned long arg4, unsigned long arg5)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_SECCOMP_FILTER */
 #endif /* _LINUX_SECCOMP_H */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 58afc04c107e..ac758ed72495 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -152,4 +152,10 @@
 #define PR_SET_THP_DISABLE	41
 #define PR_GET_THP_DISABLE	42
 
+/*
+ * Access seccomp extensions
+ * See Documentation/prctl/seccomp_filter.txt for more details.
+ */
+#define PR_SECCOMP_EXT		43
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index ac2dc9f72973..49b527935957 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -10,6 +10,12 @@
 #define SECCOMP_MODE_STRICT	1 /* uses hard-coded filter. */
 #define SECCOMP_MODE_FILTER	2 /* uses user-supplied filter. */
 
+/* Valid extension types as arg2 for prctl(PR_SECCOMP_EXT) */
+#define SECCOMP_EXT_ACT		1
+
+/* Valid extension actions as arg3 to prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT) */
+#define SECCOMP_EXT_ACT_TSYNC	1 /* attempt to synchronize thread filters */
+
 /*
  * All BPF programs must return a 32-bit value.
  * The bottom 16-bits are for optional return data.
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 8761ce47a8bd..3f32904533fa 100644
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
@@ -196,6 +197,108 @@ static u32 seccomp_run_filters(int syscall)
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
+ * seccomp_sync_threads: sets all threads to use current's filter
+ *
+ * Returns 0 on success or the pid of a thread which was either not
+ * in the correct seccomp mode or it did not have an ancestral
+ * seccomp filter.
+ */
+static pid_t seccomp_sync_threads(void)
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
+/**
+ * seccomp_extended_action: performs the specific action
+ * @action: the enum of the action to perform.
+ *
+ * Returns 0 on success. On failure, it returns -ve, or EINVAL on an
+ * invalid action.
+ */
+static long seccomp_extended_action(int action)
+{
+	switch (action) {
+	case SECCOMP_EXT_ACT_TSYNC:
+		return seccomp_sync_threads();
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
 /**
  * seccomp_attach_filter: Attaches a seccomp filter to current.
  * @fprog: BPF program to install
@@ -351,6 +454,31 @@ static void seccomp_send_sigsys(int syscall, int reason)
 	info.si_syscall = syscall;
 	force_sig_info(SIGSYS, &info, current);
 }
+
+/**
+ * prctl_seccomp_ext: exposed extension behaviors for seccomp
+ * @cmd: the type of extension being called
+ * @arg[123]: the arguments for the extension
+ *            (at present, arg2 and arg3 must be 0)
+ *
+ * Returns >= 0 on success and < 0 on failure.
+ * Invalid arguments return -EINVAL.
+ * Improper seccomp mode will result in -EACCES.
+ *
+ * SECCOMP_EXT_TYPE_ACT, SECCOMP_EXT_ACT_TSYNC will return 0 on success
+ * or the last thread pid that it cannot synchronize.
+ */
+long prctl_seccomp_ext(unsigned long type, unsigned long arg1,
+		       unsigned long arg2, unsigned long arg3)
+{
+	if (type != SECCOMP_EXT_ACT)
+		return -EINVAL;
+	/* arg2 and arg3 are currently unused. */
+	if (arg2 || arg3)
+		return -EINVAL;
+	/* For action extensions, arg1 is the identifier. */
+	return seccomp_extended_action(arg1);
+}
 #endif	/* CONFIG_SECCOMP_FILTER */
 
 /*
diff --git a/kernel/sys.c b/kernel/sys.c
index 262919a8a7ac..cb73d82e1dd5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1917,6 +1917,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_SET_SECCOMP:
 		error = prctl_set_seccomp(arg2, (char __user *)arg3);
 		break;
+	case PR_SECCOMP_EXT:
+		error = prctl_seccomp_ext(arg2, arg3, arg4, arg5);
+		break;
 	case PR_GET_TSC:
 		error = GET_TSC_CTL(arg2);
 		break;
-- 
1.7.9.5

