Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3DWPNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:13:23 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32520 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620Ab3DWPNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:13:22 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrey Vagin <avagin@openvz.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] ptrace: add ability to get/set signal-blocked mask (v2)
Date: Tue, 23 Apr 2013 19:10:43 +0400
Message-Id: <1366729843-24148-1-git-send-email-avagin@openvz.org>
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

v2: Don't use __set_task_blocked with tsk != current.
recalc_sigpending() is not called here, because it will be called after
resume. retarget_shared_pending() are not called, because we suppose,
that other threads are stopped too.

Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/uapi/linux/ptrace.h |  3 +++
 kernel/ptrace.c             | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index 52ebcc8..cf1019e 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -61,6 +61,9 @@ struct ptrace_peeksiginfo_args {
 	__s32 nr;	/* how may siginfos to take */
 };
 
+#define PTRACE_GETSIGMASK	0x420a
+#define PTRACE_SETSIGMASK	0x420b
+
 /* Read signals from a shared (process wide) queue */
 #define PTRACE_PEEKSIGINFO_SHARED	(1 << 0)
 
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 17ae54d..bebe67e 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -841,6 +841,48 @@ int ptrace_request(struct task_struct *child, long request,
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
+		/*
+		 * Every thread does recalc_sigpending() after resume, so
+		 * retarget_shared_pending() and recalc_sigpending() are not
+		 * called here.
+		 */
+		spin_lock_irq(&child->sighand->siglock);
+		child->blocked = new_set;
+		spin_unlock_irq(&child->sighand->siglock);
+
+		ret = 0;
+		break;
+	}
+
 	case PTRACE_INTERRUPT:
 		/*
 		 * Stop tracee without any side-effect on signal or job
-- 
1.8.1.4

