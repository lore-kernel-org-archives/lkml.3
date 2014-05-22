Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaEVXQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:16:21 -0400
Received: from smtp.outflux.net ([198.145.64.163]:49023 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbaEVXGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:06:35 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Dario Faggioli <raistlin@linux.it>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        liguang <lig.fnst@cn.fujitsu.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-doc@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v5 5/6] seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_FILTER
Date: Thu, 22 May 2014 16:05:35 -0700
Message-Id: <1400799936-26499-6-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400799936-26499-1-git-send-email-keescook@chromium.org>
References: <1400799936-26499-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a new seccomp "extension" framework for more complex filter
actions and option setting. The need for the added prctl() is due to
the lack of reserved arguments in PR_SET_SECCOMP (much existing code
already calls prctl without initializing trailing arguments).

When prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT, SECCOMP_EXT_ACT_FILTER, flags,
filter) is called, it will be the same as prctl(PR_SET_SECCOMP,
SECCOMP_MODE_FILTER, filter), when flags is 0. This will allow for
additional flags being set on the filter in the future.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 Documentation/prctl/seccomp_filter.txt |   14 ++++++++
 include/linux/seccomp.h                |   10 ++++--
 include/uapi/linux/prctl.h             |    6 ++++
 include/uapi/linux/seccomp.h           |    6 ++++
 kernel/seccomp.c                       |   58 ++++++++++++++++++++++++++++++++
 kernel/sys.c                           |    3 ++
 6 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index 1e469ef75778..a5e47753b32d 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -223,3 +223,17 @@ Note that modern systems are unlikely to use vsyscalls at all -- they
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
+prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT, SECCOMP_EXT_ACT_FILTER, flags, prog):
+	Attach filter, with flags.
+
+	This is the same as prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, prog)
+	except with the addition of optional "flags" argument. No flags
+	are currently recognized.
diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
index ed86b298f3b2..e315fea562e1 100644
--- a/include/linux/seccomp.h
+++ b/include/linux/seccomp.h
@@ -7,6 +7,7 @@
 
 #ifdef CONFIG_SECCOMP
 
+#include <linux/errno.h>
 #include <linux/thread_info.h>
 #include <asm/seccomp.h>
 
@@ -55,8 +56,6 @@ static inline int seccomp_mode(struct seccomp *s)
 
 #else /* CONFIG_SECCOMP */
 
-#include <linux/errno.h>
-
 struct seccomp {
 	unsigned long flags;
 };
@@ -84,6 +83,8 @@ static inline int seccomp_mode(struct seccomp *s)
 #ifdef CONFIG_SECCOMP_FILTER
 extern void put_seccomp_filter(struct task_struct *tsk);
 extern void get_seccomp_filter(struct task_struct *tsk);
+extern long prctl_seccomp_ext(unsigned long, unsigned long,
+			      unsigned long, unsigned long);
 #else  /* CONFIG_SECCOMP_FILTER */
 static inline void put_seccomp_filter(struct task_struct *tsk)
 {
@@ -93,5 +94,10 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
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
index ac2dc9f72973..d7ad626c684d 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -10,6 +10,12 @@
 #define SECCOMP_MODE_STRICT	1 /* uses hard-coded filter. */
 #define SECCOMP_MODE_FILTER	2 /* uses user-supplied filter. */
 
+/* Valid extension types as arg2 for prctl(PR_SECCOMP_EXT) */
+#define SECCOMP_EXT_ACT		1
+
+/* Valid extension actions as arg3 to prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT) */
+#define SECCOMP_EXT_ACT_FILTER	1 /* apply seccomp-bpf filter with flags */
+
 /*
  * All BPF programs must return a 32-bit value.
  * The bottom 16-bits are for optional return data.
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index e7238f5708d4..088244b2c765 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -30,6 +30,8 @@
 #include <linux/tracehook.h>
 #include <linux/uaccess.h>
 
+static long seccomp_set_mode(unsigned long mode, char * __user filter);
+
 /**
  * struct seccomp_filter - container for seccomp BPF programs
  *
@@ -333,6 +335,45 @@ static long _seccomp_attach_filter(struct seccomp_filter *filter)
 	return 0;
 }
 
+/**
+ * seccomp_act_filter: attach filter with additional flags
+ * @flags:  flags from SECCOMP_FILTER_* to change behavior
+ * @filter: struct sock_fprog for use with SECCOMP_MODE_FILTER
+ *
+ * Return 0 on success, -ve on error.
+ */
+static long seccomp_act_filter(unsigned long flags, char * __user filter)
+{
+	long ret;
+
+	/* No flags currently recognized. */
+	if (flags != 0)
+		return -EINVAL;
+
+	ret = seccomp_set_mode(SECCOMP_MODE_FILTER, filter);
+
+	return ret;
+}
+
+/**
+ * seccomp_extended_action: performs the specific action
+ * @action: the enum of the action to perform.
+ *
+ * Returns 0 on success. On failure, it returns != 0, or EINVAL on an
+ * invalid action.
+ */
+static long seccomp_extended_action(int action, unsigned long arg1,
+				    unsigned long arg2)
+{
+	switch (action) {
+	case SECCOMP_EXT_ACT_FILTER:
+		return seccomp_act_filter(arg1, (char * __user)arg2);
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
 /* get_seccomp_filter - increments the reference count of the filter on @tsk */
 void get_seccomp_filter(struct task_struct *tsk)
 {
@@ -374,6 +415,23 @@ static void seccomp_send_sigsys(int syscall, int reason)
 	info.si_syscall = syscall;
 	force_sig_info(SIGSYS, &info, current);
 }
+
+/**
+ * prctl_seccomp_ext: exposed extension behaviors for seccomp
+ * @cmd: the type of extension being called
+ * @arg[123]: the arguments for the extension
+ *
+ * Returns == 0 on success and != 0 on failure.
+ * Invalid arguments return -EINVAL.
+ */
+long prctl_seccomp_ext(unsigned long type, unsigned long arg1,
+		       unsigned long arg2, unsigned long arg3)
+{
+	if (type != SECCOMP_EXT_ACT)
+		return -EINVAL;
+	/* For action extensions, arg1 is the identifier. */
+	return seccomp_extended_action(arg1, arg2, arg3);
+}
 #endif	/* CONFIG_SECCOMP_FILTER */
 
 /*
diff --git a/kernel/sys.c b/kernel/sys.c
index d3b4af60a411..ce00ad88e48f 100644
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

