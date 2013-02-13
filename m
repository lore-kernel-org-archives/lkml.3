Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751Ab3BMPTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:19:38 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:11531 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759544Ab3BMPTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:19:38 -0500
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
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ptrace: add ability to retrieve signals without removing them from a queue
Date: Wed, 13 Feb 2013 19:16:35 +0400
Message-Id: <1360768595-31943-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new ptrace request PTRACE_PEEKSIGINFO.

This request is used to retrieve information about a signal with the
specified sequence number. A siginfo_t structure is copied from the child
to location data in the parent.

The low 16 bits of addr contains a sequence number of signal in a queue.
All other bits of addr is used for flags. Currently here is only one
flag PTRACE_PEEK_SHARED for dumping signals from process-wide shared
queue. If this flag is not set, a signal is read from a per-thread
queue.  A result siginfo contains a kernel part of si_code which usually
striped, but it's required for queuing the same siginfo back during
restore of pending signals.

If a signal with the specified sequence number doesn't exist, ptrace
returns ENOENT.

This functionality is required for checkpointing pending signals.

The prototype of this code was developed by Oleg Nesterov.

Cc: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/uapi/linux/ptrace.h |  9 +++++++
 kernel/ptrace.c             | 64 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+)

diff --git a/include/uapi/linux/ptrace.h b/include/uapi/linux/ptrace.h
index 022ab18..5d851d5 100644
--- a/include/uapi/linux/ptrace.h
+++ b/include/uapi/linux/ptrace.h
@@ -52,6 +52,15 @@
 #define PTRACE_INTERRUPT	0x4207
 #define PTRACE_LISTEN		0x4208
 
+#define PTRACE_PEEKSIGINFO	0x4209
+
+/*
+ * The lower 16 bits of addr is a sequence number of a signal.
+ * All other bits can be used for flags.
+ */
+#define PTRACE_PEEKSIGINFO_FLAGS_MASK	(~0UL << 16)
+#define PTRACE_PEEK_SHARED		(1UL << 31)
+
 /* Wait extended result codes for the above trace options.  */
 #define PTRACE_EVENT_FORK	1
 #define PTRACE_EVENT_VFORK	2
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 1599157..27fd31a 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -579,6 +579,40 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 	return error;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static int ptrace_peek_siginfo(struct task_struct *child,
+				unsigned long addr, siginfo_t *siginfo)
+{
+	struct sigpending *pending;
+	struct sigqueue *q;
+	unsigned long flags;
+	unsigned int nr;
+	int ret = -ENOENT;
+
+	nr = addr & ~PTRACE_PEEKSIGINFO_FLAGS_MASK;
+	flags = addr & PTRACE_PEEKSIGINFO_FLAGS_MASK;
+
+	if (flags & PTRACE_PEEK_SHARED)
+		pending = &child->signal->shared_pending;
+	else
+		pending = &child->pending;
+
+	if (flags & ~PTRACE_PEEK_SHARED)
+		return -EINVAL; /* unknown flags */
+
+	spin_lock_irq(&child->sighand->siglock);
+	list_for_each_entry(q, &pending->list, list) {
+		if (!nr--) {
+			copy_siginfo(siginfo, &q->info);
+			ret = 0;
+			break;
+		}
+	}
+	spin_unlock_irq(&child->sighand->siglock);
+
+	return ret;
+}
+#endif
 
 #ifdef PTRACE_SINGLESTEP
 #define is_singlestep(request)		((request) == PTRACE_SINGLESTEP)
@@ -703,6 +737,21 @@ int ptrace_request(struct task_struct *child, long request,
 		ret = put_user(child->ptrace_message, datalp);
 		break;
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	case PTRACE_PEEKSIGINFO:
+	{
+		siginfo_t __user *uinfo = (siginfo_t __user *) data;
+
+		ret = ptrace_peek_siginfo(child, addr, &siginfo);
+
+		if (!ret)
+			ret = copy_siginfo_to_user(uinfo, &siginfo);
+		if (!ret)
+			ret = __put_user(siginfo.si_code, &uinfo->si_code);
+		break;
+	}
+#endif
+
 	case PTRACE_GETSIGINFO:
 		ret = ptrace_getsiginfo(child, &siginfo);
 		if (!ret)
@@ -959,6 +1008,21 @@ int compat_ptrace_request(struct task_struct *child, compat_long_t request,
 		ret = put_user((compat_ulong_t) child->ptrace_message, datap);
 		break;
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+	case PTRACE_PEEKSIGINFO:
+	{
+		compat_siginfo_t __user *uinfo = compat_ptr(data);
+
+		ret = ptrace_peek_siginfo(child, addr, &siginfo);
+
+		if (!ret)
+			ret = copy_siginfo_to_user32(uinfo, &siginfo);
+		if (!ret)
+			ret = __put_user(siginfo.si_code, &uinfo->si_code);
+		break;
+	}
+#endif
+
 	case PTRACE_GETSIGINFO:
 		ret = ptrace_getsiginfo(child, &siginfo);
 		if (!ret)
-- 
1.7.11.7

