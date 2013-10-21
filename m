Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3JUNkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 09:40:49 -0400
Received: from www84.your-server.de ([213.133.104.84]:47275 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab3JUNks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 09:40:48 -0400
X-Greylist: delayed 1293 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Oct 2013 09:40:48 EDT
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org, mingo@redhat.com,
        peterz@infradead.org
Cc: stefani@seibold.net
Subject: [PATCH] [PATCH] add new prctl for a per process wide close on exec
Date: Mon, 21 Oct 2013 15:18:29 +0200
Message-Id: <1382361509-28543-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.8.4
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

This small patch adds a runtime prctl config option for a per process wide
"close on exec" without breaking existing code.

With this feature a developer can decide if the application will pass all non
"close on exec" file descriptors to a new process or not.

The mode of the process wide "close on exec" can be set with PR_SET_CLOEXEC and
PR_GET_CLOEXEC returns the current mode. Mode is one of the following:

- PR_CLOEXEC_DEFAULT closes only the fd's marked as "close on exec" in
   the child process, this is the linux default behaviour.

- PR_CLOEXEC_ONCE closes all fd's expect 0, 1 and 2 which are regular
   handled as in PR_CLOEXEC_DEFAULT and reset the mode of the child to
   PR_CLOEXEC_DEFAULT.

- PR_CLOEXEC_INHERIT is like PR_CLOEXEC_ONCE, but the mode will stay in the
   child

STDIO file descriptors will be passed to the child process depending on the
..._CLOEXEC flag. So the new modes should be compatible to regular code.

This patch will increase security since no developers can review all libraries
which there are using. Also in a team of developers it is not always possible
to have a full survey over the code which is produced. Or the output of a code
generators and so one. This patch allows a kind of preventive measures.

It can also prevent resource occupation. Imagine a long running process (a
daemon) is execute from the application after open some file desciptors. For
example libpcsclite.so will not open the socket with SOCK_CLOEXEC. Or a device
driver which alows only a single open. In both cases the resource cannot
reopened after a close. Sigh!

What do you think?

ChangeLog:

2013-10-21	First release to the mailing list

The patch is against 3.12.0-rc6

Greetings,
Stefani

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 fs/exec.c                  |  2 ++
 fs/file.c                  | 12 +++++++++++-
 include/linux/sched.h      |  6 ++++++
 include/uapi/linux/prctl.h | 18 ++++++++++++++++++
 kernel/sys.c               | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 8875dd1..c8af524 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1546,6 +1546,8 @@ static int do_execve_common(const char *filename,
 	/* execve succeeded */
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
+	if (!current->cloexec_inherit)
+		current->cloexec = 0;
 	acct_update_integrals(current);
 	free_bprm(bprm);
 	if (displaced)
diff --git a/fs/file.c b/fs/file.c
index 4a78f98..7372252 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -622,7 +622,17 @@ void do_close_on_exec(struct files_struct *files)
 		fdt = files_fdtable(files);
 		if (fd >= fdt->max_fds)
 			break;
-		set = fdt->close_on_exec[i];
+		if (!current->cloexec)
+			set = fdt->close_on_exec[i];
+		else {
+			set = fdt->open_fds[i];
+
+			/* special handling for stdio */
+			if (!i) {
+				set &= ~7;
+				set |= fdt->close_on_exec[i] & 7;
+			}
+		}
 		if (!set)
 			continue;
 		fdt->close_on_exec[i] = 0;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e27baee..469e6f8 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1112,6 +1112,12 @@ struct task_struct {
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
 
+	/* close non stdio on exec */
+	unsigned cloexec:1;
+
+	/* inherit cloexec flag on exec */
+	unsigned cloexec_inherit:1;
+
 	pid_t pid;
 	pid_t tgid;
 
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 289760f..e1c2d66 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -149,4 +149,22 @@
 
 #define PR_GET_TID_ADDRESS	40
 
+/*
+ * PR_CLOEXEC allows to configure the inheritance of the non stdio file
+ * handles to a child process:
+ *
+ * - PR_CLOEXEC_DEFAULT: close only the fd's marked with as close on exec
+ *    in the child process
+ * - PR_CLOEXEC_ONCE: close all fd's expect 0, 1 and 2 which are regular
+ *    handled as in PR_CLOEXEC_DEFAULT and reset the mode of the child to
+ *    PR_CLOEXEC_DEFAULT
+ * - PR_CLOEXEC_INHERIT: like PR_CLOEXEC_ONCE, but the mode will stay in the
+ *    child process
+ */
+#define PR_SET_CLOEXEC		41
+#define PR_GET_CLOEXEC		42
+# define PR_CLOEXEC_DEFAULT		1
+# define PR_CLOEXEC_ONCE		2
+# define PR_CLOEXEC_INHERIT		3
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index c18ecca..7e53e14 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1999,6 +1999,38 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		if (arg2 || arg3 || arg4 || arg5)
 			return -EINVAL;
 		return current->no_new_privs ? 1 : 0;
+	case PR_SET_CLOEXEC:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		switch(arg2) {
+		case PR_CLOEXEC_DEFAULT:
+			current->group_leader->cloexec = 0;
+			current->group_leader->cloexec_inherit = 0;
+			break;
+		case PR_CLOEXEC_ONCE:
+			current->group_leader->cloexec = 1;
+			current->group_leader->cloexec_inherit = 0;
+			break;
+		case PR_CLOEXEC_INHERIT:
+			current->group_leader->cloexec = 1;
+			current->group_leader->cloexec_inherit = 1;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case PR_GET_CLOEXEC:
+		if (arg2 || arg3 || arg4 || arg5)
+			return -EINVAL;
+		if (!current->group_leader->cloexec)
+			error = PR_CLOEXEC_DEFAULT;
+		else {
+			if (!current->group_leader->cloexec_inherit)
+				error = PR_CLOEXEC_ONCE;
+			else
+				error = PR_CLOEXEC_INHERIT;
+		}
+		break;
 	default:
 		error = -EINVAL;
 		break;
-- 
1.8.4

