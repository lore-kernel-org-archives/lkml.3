Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaAMUlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:41:51 -0500
Received: from mail-gg0-f178.google.com ([209.85.161.178]:57230 "EHLO
	mail-gg0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaAMUls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:41:48 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2014 15:41:47 EST
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>, nschichan@freebox.fr,
        keescook@chromium.org, james.l.morris@oracle.com,
        akpm@linux-foundation.org, oleg@redhat.com, holt@sgi.com,
        viro@zeniv.linux.org.uk
Subject: [PATCH 2/2] sys, seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
Date: Mon, 13 Jan 2014 14:30:21 -0600
Message-Id: <1389645028-17157-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389645028-17157-1-git-send-email-wad@chromium.org>
References: <1389645028-17157-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applying restrictive seccomp filter programs to large or diverse
codebases often requires handling threads which may be started early in
the process lifetime (e.g., by code that is linked in).  While it is
possible to apply permissive programs prior to process start up, it is
difficult to further restrict the kernel ABI to those threads after that
point.

This change adds a new seccomp "extension" for synchronizing thread
group seccomp filters and a prctl() for accessing that functionality.
The need for the added prctl() is due to the lack of reserved arguments
in PR_SET_SECCOMP.

When prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT_TSYNC, 0, 0) is called, it
will attempt to synchronize all threads in current's threadgroup to its
seccomp filter program.  This is possible iff all threads are using a
filter that is an ancestor to the filter current is attempting to
synchronize to. NULL filters (where the task is running as
SECCOMP_MODE_NONE) are also treated as ancestors allowing threads to be
transitioned into SECCOMP_MODE_FILTER.  On success, 0 is returned.  On
failure, the pid of one of the failing threads will be returned.

Suggested-by: Julien Tinnes <jln@chromium.org>
Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/linux/seccomp.h      |    7 +++
 include/uapi/linux/prctl.h   |    6 ++
 include/uapi/linux/seccomp.h |    6 ++
 kernel/seccomp.c             |  128 ++++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c                 |    3 +
 5 files changed, 150 insertions(+)

diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index 85c0895..3163db6 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -77,6 +77,8 @@ static inline int seccomp_mode(struct seccomp *s)
 extern void put_seccomp_filter(struct task_struct *tsk);
 extern void get_seccomp_filter(struct task_struct *tsk);
 extern u32 seccomp_bpf_load(int off);
+extern long prctl_seccomp_ext(unsigned long, unsigned long,
+			      unsigned long, unsigned long);
 #else  /* CONFIG_SECCOMP_FILTER */
 static inline void put_seccomp_filter(struct task_struct *tsk)
 {
@@ -86,5 +88,10 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
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
index 289760f..5dcd5d3 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -149,4 +149,10 @@
 
 #define PR_GET_TID_ADDRESS	40
 
+/*
+ * Access seccomp extensions
+ * See Documentation/prctl/seccomp_filter.txt for more details.
+ */
+#define PR_SECCOMP_EXT	41
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index ac2dc9f..49b5279 100644
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
index 71512e4..8a0de7b 100644
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
@@ -220,6 +221,108 @@ static u32 seccomp_run_filters(int syscall)
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
+/**
+ * seccomp_sync_threads: sets all threads to use current's filter
+ *
+ * Returns 0 on success or the pid of a thread which was either not
+ * in the correct seccomp mode or it did not have an ancestral
+ * seccomp filter. current must be in seccomp.mode=2 already.
+ */
+static pid_t seccomp_sync_threads(void)
+{
+	struct task_struct *thread, *caller;
+	pid_t failed = 0;
+	thread = caller = current;
+
+	read_lock(&tasklist_lock);
+	if (thread_group_empty(caller))
+		goto done;
+	while_each_thread(caller, thread) {
+		task_lock(thread);
+		/*
+		 * All threads must not be in SECCOMP_MODE_STRICT to
+		 * be eligible for synchronization.
+		 */
+		if ((thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
+		     thread->seccomp.mode == SECCOMP_MODE_FILTER) &&
+		    is_ancestor(thread->seccomp.filter,
+				caller->seccomp.filter)) {
+			/* Get a task reference for the new leaf node. */
+			get_seccomp_filter(caller);
+			/*
+			 * Drop the task reference to the shared ancestor since
+			 * current's path will hold a reference.  (This also
+			 * allows a put before the assignment.)
+			 */
+			put_seccomp_filter(thread);
+			thread->seccomp.filter = caller->seccomp.filter;
+			/* Opt the other thread into seccomp if needed.
+			 * As threads are considered to be trust-realm
+			 * equivalent (see ptrace_may_access), it is safe to
+			 * allow one thread to transition the other.
+			 */
+			if (thread->seccomp.mode == SECCOMP_MODE_DISABLED) {
+				thread->seccomp.mode = SECCOMP_MODE_FILTER;
+				/*
+				 * Don't let an unprivileged task work around
+				 * the no_new_privs restriction by creating
+				 * a thread that sets it up, enters seccomp,
+				 * then dies.
+				 */
+				if (caller->no_new_privs)
+					thread->no_new_privs = 1;
+				set_tsk_thread_flag(thread, TIF_SECCOMP);
+			}
+		} else {
+			/* Keep the last sibling that failed to return. */
+			struct pid *pid = get_task_pid(thread, PIDTYPE_PID);
+			failed = pid_vnr(pid);
+			put_pid(pid);
+			/* If the pid cannot be resolved, then return -ESRCH */
+			if (failed == 0)
+				failed = -ESRCH;
+		}
+		task_unlock(thread);
+	}
+done:
+	read_unlock(&tasklist_lock);
+	return failed;
+}
+
+/**
+ * seccomp_extended_action: performs the specific action
+ * @action: the enum of the action to perform.
+ *
+ * Returns 0 on success. On failure, it returns -EINVAL
+ * on a invalid action or -EACCES if the seccomp mode is
+ * invalid.
+ */
+static long seccomp_extended_action(int action)
+{
+	switch (action) {
+	case SECCOMP_EXT_ACT_TSYNC:
+		if (current->seccomp.mode != SECCOMP_MODE_FILTER)
+			return -EACCES;
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
@@ -471,6 +574,31 @@ long prctl_get_seccomp(void)
 }
 
 /**
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
+
+/**
  * prctl_set_seccomp: configures current->seccomp.mode
  * @seccomp_mode: requested mode to use
  * @filter: optional struct sock_fprog for use with SECCOMP_MODE_FILTER
diff --git a/kernel/sys.c b/kernel/sys.c
index c723113..73d599a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1919,6 +1919,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
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

