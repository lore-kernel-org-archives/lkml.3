Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab3LLQzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:55:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45723 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3LLQyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:54:52 -0500
From: vegard.nossum@oracle.com
To: linux-kernel@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@oracle.com>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: [PATCH 1/9] Known exploit detection
Date: Thu, 12 Dec 2013 17:52:24 +0100
Message-Id: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

The idea is simple -- since different kernel versions are vulnerable to
different root exploits, hackers most likely try multiple exploits before
they actually succeed.

Fixing an exploitable kernel bug usually means adding a check to see if
what a userspace program tried to do is allowed and makes sense (for
example, writing beyond the end of an array is a bug and can be fixed by
checking that the index provided by userspace is indeed within the array
bounds).

Instead of just returning an error when these extra checks fail, we can
also give the system administrator a heads up that somebody supplied this
invalid input that would have lead to elevated privileges on earlier
versions of the kernel.

This serves as a practical, low-overhead early-detection of malicious users
(and/or buggy userspace programs) to system administrators.

I propose limiting the annotation of known exploits to the most serious
type of exploit, namely where the attacker otherwise silently gains
root/elevated capabilities. For sure, there is little point in calling
exploit() where an older kernel would just panic or OOM.

I also propose to keep each exploit() annotation around for only ~5 years
after the bug was discovered/fixed. This will allow us to catch most of the
intrusion attempts while still not littering the kernel code forever.

Cc: Tommi Rantala <tt.rantala@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Morris <james.l.morris@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 include/linux/exploit.h |   23 +++++++++++++++++++++++
 security/Kconfig        |   14 +++++++++++++-
 security/Makefile       |    2 ++
 security/exploit.c      |   28 ++++++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/exploit.h
 create mode 100644 security/exploit.c

diff --git a/include/linux/exploit.h b/include/linux/exploit.h
new file mode 100644
index 0000000..a8df72a
--- /dev/null
+++ b/include/linux/exploit.h
@@ -0,0 +1,23 @@
+#ifndef _LINUX_EXPLOIT_H
+#define _LINUX_EXPLOIT_H
+
+#ifdef CONFIG_EXPLOIT_DETECTION
+extern void _exploit(const char *id);
+
+#define exploit_on(cond, id) \
+	do { \
+		if (unlikely(cond)) \
+			_exploit(id); \
+	} while (0)
+
+#else
+
+#define exploit_on(cond, id) \
+	do { \
+	} while (0)
+
+#endif
+
+#define exploit(id) exploit_on(true, id)
+
+#endif
diff --git a/security/Kconfig b/security/Kconfig
index e9c6ac7..a828dfb 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -167,5 +167,17 @@ config DEFAULT_SECURITY
 	default "yama" if DEFAULT_SECURITY_YAMA
 	default "" if DEFAULT_SECURITY_DAC
 
-endmenu
+config EXPLOIT_DETECTION
+	bool "Known exploit detection"
+	depends on PRINTK
+	default y
+	help
+	  This option enables the detection of users/programs who attempt to
+	  break into the kernel using publicly known (past) exploits.
+
+	  Upon detection, a message will be printed in the kernel log.
 
+	  The runtime overhead of enabling this option is extremely small, so
+	  you are recommended to say Y.
+
+endmenu
diff --git a/security/Makefile b/security/Makefile
index c26c81e..d152a1d 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -28,3 +28,5 @@ obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 # Object integrity file lists
 subdir-$(CONFIG_INTEGRITY)		+= integrity
 obj-$(CONFIG_INTEGRITY)			+= integrity/built-in.o
+
+obj-$(CONFIG_EXPLOIT_DETECTION)		+= exploit.o
diff --git a/security/exploit.c b/security/exploit.c
new file mode 100644
index 0000000..a732613
--- /dev/null
+++ b/security/exploit.c
@@ -0,0 +1,28 @@
+#include <linux/cred.h>
+#include <linux/exploit.h>
+#include <linux/printk.h>
+#include <linux/ratelimit.h>
+#include <linux/sched.h>
+
+void _exploit(const char *id)
+{
+	/*
+	 * This function needs to be super defensive/conservative, since
+	 * userspace can easily get to it from several different contexts.
+	 * We don't want it to become an attack vector in itself!
+	 *
+	 * We can assume that we're in process context, but spinlocks may
+	 * be held, etc.
+	 */
+
+	struct task_struct *task = current;
+	pid_t pid = task_pid_nr(task);
+	uid_t uid = from_kuid(&init_user_ns, current_uid());
+	char comm[sizeof(task->comm)];
+
+	get_task_comm(comm, task);
+
+	pr_warn_ratelimited("warning: possible %s exploit attempt by pid=%u uid=%u comm=%s\n",
+		id, pid, uid, comm);
+}
+EXPORT_SYMBOL(_exploit);
-- 
1.7.10.4

