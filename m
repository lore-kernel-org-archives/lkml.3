Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab3CDKub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:50:31 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:20694 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab3CDKua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:50:30 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-api@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pedro Alves <palves@redhat.com>
Subject: [PATCH 1/2] ptrace: add ability to retrieve signals without removing from a queue (v4)
Date: Mon,  4 Mar 2013 14:46:34 +0400
Message-Id: <1362393995-22190-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new ptrace request PTRACE_PEEKSIGINFO.

This request is used to retrieve information about pending signals
starting with the specified sequence number. Siginfo_t structures are
copied from the child into the buffer starting at "data".

The argument "addr" is a pointer to struct ptrace_peeksiginfo_args.
struct ptrace_peeksiginfo_args {
	u64 off;	/* from which siginfo to start */
	u32 flags;
	s32 nr;		/* how may siginfos to take */
};

"nr" has type "s32", because ptrace() returns "long", which has 32 bits
on i386 and a negative values is used for errors.

Currently here is only one flag PTRACE_PEEKSIGINFO_SHARED for dumping
signals from process-wide queue. If this flag is not set, signals are
read from a per-thread queue.

The request PTRACE_PEEKSIGINFO returns a number of dumped signals.  If a
signal with the specified sequence number doesn't exist, ptrace returns
zero.  The request returns an error, if no signal has been dumped.

Errors:
EINVAL - one or more specified flags are not supported or nr is negative
EFAULT - buf or addr is outside your accessible address space.

A result siginfo contains a kernel part of si_code which usually
striped, but it's required for queuing the same siginfo back during
restore of pending signals.

This functionality is required for checkpointing pending signals.
Pedro Alves suggested using it in "gdb" to peek at pending signals.
gdb already uses PTRACE_GETSIGINFO to get the siginfo for the signal
which was already dequeued. This functionality allows gdb to look at
the pending signals which were not reported yet.

The prototype of this code was developed by Oleg Nesterov.

v2: * don't wrapped on CONFIG_CHECKPOINT_RESTORE. This functionality is
      going to be used in gdb.
    * use ptrace_peeksiginfo_args, because addr is too small for
      encoding a signal number and flags.
v3: incorporate comments received from Andrew Morton
v4: make code a bit more obvious

Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pedro Alves <palves@redhat.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Andrew Vagin <avagin@openvz.org>
---
 include/uapi/linux/ptrace.h | 12 +++++++
 kernel/ptrace.c             | 80 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index 022ab18..52ebcc8 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -5,6 +5,7 @@
 
 /* has the defines to get at the registers. */
 
+#include <linux/types.h>
 
 #define PTRACE_TRACEME		   0
 #define PTRACE_PEEKTEXT		   1
@@ -52,6 +53,17 @@
 #define PTRACE_INTERRUPT	0x4207
 #define PTRACE_LISTEN		0x4208
 
+#define PTRACE_PEEKSIGINFO	0x4209
+
+struct ptrace_peeksiginfo_args {
+	__u64 off;	/* from which siginfo to start */
+	__u32 flags;
+	__s32 nr;	/* how may siginfos to take */
+};
+
+/* Read signals from a shared (process wide) queue */
+#define PTRACE_PEEKSIGINFO_SHARED	(1 << 0)
+
 /* Wait extended result codes for the above trace options.  */
 #define PTRACE_EVENT_FORK	1
 #define PTRACE_EVENT_VFORK	2
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index acbd284..17ae54d 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -24,6 +24,7 @@
 #include <linux/regset.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/cn_proc.h>
+#include <linux/compat.h>
 
 
 static int ptrace_trapping_sleep_fn(void *flags)
@@ -618,6 +619,81 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 	return error;
 }
 
+static int ptrace_peek_siginfo(struct task_struct *child,
+				unsigned long addr,
+				unsigned long data)
+{
+	struct ptrace_peeksiginfo_args arg;
+	struct sigpending *pending;
+	struct sigqueue *q;
+	int ret, i;
+
+	ret = copy_from_user(&arg, (void __user *) addr,
+				sizeof(struct ptrace_peeksiginfo_args));
+	if (ret)
+		return -EFAULT;
+
+	if (arg.flags & ~PTRACE_PEEKSIGINFO_SHARED)
+		return -EINVAL; /* unknown flags */
+
+	if (arg.nr < 0)
+		return -EINVAL;
+
+	if (arg.flags & PTRACE_PEEKSIGINFO_SHARED)
+		pending = &child->signal->shared_pending;
+	else
+		pending = &child->pending;
+
+	for (i = 0; i < arg.nr; ) {
+		siginfo_t info;
+		s32 off = arg.off + i;
+
+		spin_lock_irq(&child->sighand->siglock);
+		list_for_each_entry(q, &pending->list, list) {
+			if (!off--) {
+				copy_siginfo(&info, &q->info);
+				break;
+			}
+		}
+		spin_unlock_irq(&child->sighand->siglock);
+
+		if (off >= 0) /* beyond the end of the list */
+			break;
+
+#ifdef CONFIG_COMPAT
+		if (unlikely(is_compat_task())) {
+			compat_siginfo_t __user *uinfo = compat_ptr(data);
+
+			ret = copy_siginfo_to_user32(uinfo, &info);
+			ret |= __put_user(info.si_code, &uinfo->si_code);
+		} else
+#endif
+		{
+			siginfo_t __user *uinfo = (siginfo_t __user *) data;
+
+			ret = copy_siginfo_to_user(uinfo, &info);
+			ret |= __put_user(info.si_code, &uinfo->si_code);
+		}
+
+		if (ret) {
+			ret = -EFAULT;
+			break;
+		}
+
+		data += sizeof(siginfo_t);
+		i++;
+
+		if (signal_pending(current))
+			break;
+
+		cond_resched();
+	}
+
+	if (i > 0)
+		return i;
+
+	return ret;
+}
 
 #ifdef PTRACE_SINGLESTEP
 #define is_singlestep(request)		((request) == PTRACE_SINGLESTEP)
@@ -748,6 +824,10 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = put_user(child->ptrace_message, datalp);
 		break;
 
+	case PTRACE_PEEKSIGINFO:
+		ret = ptrace_peek_siginfo(child, addr, data);
+		break;
+
 	case PTRACE_GETSIGINFO:
 		ret = ptrace_getsiginfo(child, &siginfo);
 		if (!ret)
-- 
1.7.11.7

