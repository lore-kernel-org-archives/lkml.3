Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3DVJzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:55:53 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:36551 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab3DVJzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:55:52 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrey Vagin <avagin@openvz.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] ptrace: add ability to get/set signal-blocked mask
Date: Mon, 22 Apr 2013 13:53:20 +0400
Message-Id: <1366624400-9773-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crtools uses a parasite code for dumping processes. The parasite code is
injected into a process with help PTRACE_SEIZE.

Currently crtools blocks signals from a parasite code. If a process has
pending signals, crtools wait while a process handles these signals.

This method is not suitable for stopped tasks. A stopped task can have a
few pending signals, when we will try to execute a parasite code, we
will need to drop SIGSTOP, but all other signals must remain pending,
because a state of processes must not be changed during checkpointing.

This patch adds two ptrace commands to set/get signal-blocked mask.

I think gdb can use this commands too.

Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/linux/signal.h      |  1 +
 include/uapi/linux/ptrace.h |  2 ++
 kernel/ptrace.c             | 36 ++++++++++++++++++++++++++++++++++++
 kernel/signal.c             |  2 +-
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index a2dcb94..706b88d 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -246,6 +246,7 @@ extern int do_sigtimedwait(const sigset_t *, siginfo_t *,
 extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
+extern void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset);
 extern int show_unhandled_signals;
 extern int sigsuspend(sigset_t *);
 
diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index 52ebcc8..1527684 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -54,6 +54,8 @@
 #define PTRACE_LISTEN		0x4208
 
 #define PTRACE_PEEKSIGINFO	0x4209
+#define PTRACE_GETSIGMASK	0x420a
+#define PTRACE_SETSIGMASK	0x420b
 
 struct ptrace_peeksiginfo_args {
 	__u64 off;	/* from which siginfo to start */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 17ae54d..317a737 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -841,6 +841,42 @@ int ptrace_request(struct task_struct *child, long request,
 			ret = ptrace_setsiginfo(child, &siginfo);
 		break;
 
+	case PTRACE_GETSIGMASK:
+		if (addr != sizeof(sigset_t)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (copy_to_user(datavp, &child->blocked, sizeof(sigset_t)))
+			ret = -EFAULT;
+		else
+			ret = 0;
+
+		break;
+
+	case PTRACE_SETSIGMASK:
+	{
+		sigset_t new_set;
+
+		if (addr != sizeof(sigset_t)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (copy_from_user(&new_set, datavp, sizeof(sigset_t))) {
+			ret = -EFAULT;
+			break;
+		}
+
+		sigdelsetmask(&new_set, sigmask(SIGKILL)|sigmask(SIGSTOP));
+
+		spin_lock_irq(&child->sighand->siglock);
+		__set_task_blocked(child, &new_set);
+		spin_unlock_irq(&child->sighand->siglock);
+
+		ret = 0;
+		break;
+	}
 	case PTRACE_INTERRUPT:
 		/*
 		 * Stop tracee without any side-effect on signal or job
diff --git a/kernel/signal.c b/kernel/signal.c
index dd72567..d757e5b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2522,7 +2522,7 @@ long do_no_restart_syscall(struct restart_block *param)
 	return -EINTR;
 }
 
-static void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset)
+void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset)
 {
 	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
 		sigset_t newblocked;
-- 
1.8.1.4

