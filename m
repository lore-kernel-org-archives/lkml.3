Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab3BYKIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 05:08:30 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:39812 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab3BYKI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 05:08:29 -0500
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
Subject: [PATCH] ptrace: add ability to retrieve signals without removing from a queue (v2)
Date: Mon, 25 Feb 2013 14:06:53 +0400
Message-Id: <1361786813-14652-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new ptrace request PTRACE_PEEKSIGINFO.

This request is used to retrieve information about signals starting with
the specified sequence number. Siginfo_t structures are copied from the
child into the buffer starting at "data".

The argument "addr" is a pointer to struct ptrace_peeksiginfo_args.
struct ptrace_peeksiginfo_args {
	u64 off;	/* from which siginfo to start */
	u32 nr;		/* how may siginfos to take */
	u32 flags;
};

Currently here is only one flag PTRACE_PEEKSIGINFO_SHARED for dumping
signals from process-wide shared queue. If this flag is not set, a
signal is read from a per-thread queue.  A result siginfo contains a
kernel part of si_code which usually striped, but it's required for
queuing the same siginfo back during restore of pending signals.

The request PTRACE_PEEKSIGINFO returns a number of dumped signals.
If a signal with the specified sequence number doesn't exist, ptrace
returns 0.

This functionality is required for checkpointing pending signals.

The prototype of this code was developed by Oleg Nesterov.

v2: * don't wrapped on CONFIG_CHECKPOINT_RESTORE. This functionality is
      going to be used in gdb.
    * use ptrace_peeksiginfo_args, because addr is too small for
      encoding a signal number and flags.

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
---
 include/uapi/linux/ptrace.h | 12 +++++++
 kernel/ptrace.c             | 76 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index 022ab18..01b4bd8 100644
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
+	__u32 nr;	/* how may siginfos to take */
+	__u32 flags;
+};
+
+/* Read signals from a shared (process wide) queue */
+#define PTRACE_PEEKSIGINFO_SHARED	(1 << 0)
+
 /* Wait extended result codes for the above trace options.  */
 #define PTRACE_EVENT_FORK	1
 #define PTRACE_EVENT_VFORK	2
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 6cbeaae..ceecdcd 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -24,6 +24,7 @@
 #include <linux/regset.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/cn_proc.h>
+#include <linux/compat.h>
 
 
 static int ptrace_trapping_sleep_fn(void *flags)
@@ -618,6 +619,77 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 	return error;
 }
 
+static int ptrace_peek_siginfo(struct task_struct *child,
+				unsigned long addr,
+				unsigned long data)
+{
+	struct ptrace_peeksiginfo_args arg;
+	struct sigpending *pending;
+	struct sigqueue *q;
+	siginfo_t info;
+	long long off;
+	int ret, i;
+
+	ret = copy_from_user(&arg, (void __user *) addr,
+				sizeof(struct ptrace_peeksiginfo_args));
+	if (ret)
+		return ret;
+
+	if (arg.flags & PTRACE_PEEKSIGINFO_SHARED)
+		pending = &child->signal->shared_pending;
+	else
+		pending = &child->pending;
+
+	if (arg.flags & ~PTRACE_PEEKSIGINFO_SHARED)
+		return -EINVAL; /* unknown flags */
+
+	for (i = 0; i < arg.nr; i++) {
+		off = arg.off + i;
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
+		if (off >= 0)
+			break;
+
+#ifdef CONFIG_COMPAT
+		if (unlikely(is_compat_task())) {
+			compat_siginfo_t __user *uinfo = compat_ptr(data);
+
+			ret = copy_siginfo_to_user32(uinfo, &info);
+			if (!ret)
+				ret = __put_user(info.si_code, &uinfo->si_code);
+		} else
+#endif
+		{
+			siginfo_t __user *uinfo = (siginfo_t __user *) data;
+
+			ret = copy_siginfo_to_user(uinfo, &info);
+			if (!ret)
+				ret = __put_user(info.si_code, &uinfo->si_code);
+		}
+
+		if (ret)
+			break;
+
+		data += sizeof(siginfo_t);
+
+		if (signal_pending(current)) {
+			i++;
+			break;
+		}
+
+		cond_resched();
+	}
+
+	return i ? : ret;
+}
 
 #ifdef PTRACE_SINGLESTEP
 #define is_singlestep(request)		((request) == PTRACE_SINGLESTEP)
@@ -742,6 +814,10 @@ int ptrace_request(struct task_struct *child, long request,
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

