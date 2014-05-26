Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaEZNei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:34:38 -0400
Received: from numidia.opendz.org ([98.142.220.152]:37420 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaEZNeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:34:36 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH 5/9] procfs: improve /proc/<pid>/syscall protection
Date: Mon, 26 May 2014 14:27:26 +0100
Message-Id: <1401110850-3552-6-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert syscall from an INF entry to a REG one. This way we can perform
and cache the permission checks during ->open().

The ptrace capability is only cached, it will be re-checked during
->read(). If the opener did not have enough privileges then fail.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index ef35544..f0ce94a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -183,6 +183,18 @@ out_no_task:
 	return length;
 }
 
+static int pid_entry_attach(struct file *filp)
+{
+	int ret = pid_entry_access(filp, PTRACE_MODE_ATTACH);
+
+	if (ret)
+		filp->private_data = (void *)(unsigned long)PID_ENTRY_DENY;
+	else
+		filp->private_data = (void *)(unsigned long)PID_ENTRY_ALLOW;
+
+	return ret;
+}
+
 /*
  * Count the number of hardlinks for the pid_entry table, excluding the .
  * and .. links.
@@ -574,11 +586,25 @@ static int proc_pid_limits(struct task_struct *task, char *buffer)
 }
 
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-static int proc_pid_syscall(struct task_struct *task, char *buffer)
+static int syscall_open(struct inode *inode, struct file *filp)
+{
+	/* we only cache the result */
+	pid_entry_attach(filp);
+
+	return 0;
+}
+
+static int proc_pid_syscall(char *buffer,
+			    struct task_struct *task, int permitted)
 {
 	long nr;
+	int res = -EPERM;
 	unsigned long args[6], sp, pc;
-	int res = lock_trace(task);
+
+	if (!permitted)
+		return res;
+
+	res = lock_trace(task);
 	if (res)
 		return res;
 
@@ -595,6 +621,28 @@ static int proc_pid_syscall(struct task_struct *task, char *buffer)
 	unlock_trace(task);
 	return res;
 }
+
+static ssize_t syscall_read(struct file *file, char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	ssize_t length;
+	unsigned long page = 0UL;
+
+	length = pid_entry_read(file, &page, proc_pid_syscall);
+	if (length >= 0) {
+		length = proc_read_from_buffer(buf, count, ppos,
+					       (char *)page, length);
+		free_page(page);
+	}
+
+	return length;
+}
+
+static const struct file_operations proc_pid_syscall_operations = {
+	.open	= syscall_open,
+	.read	= syscall_read,
+	.llseek	= generic_file_llseek,
+};
 #endif /* CONFIG_HAVE_ARCH_TRACEHOOK */
 
 /************************************************************************/
@@ -2649,7 +2697,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",    S_IRUSR, proc_pid_syscall),
+	REG("syscall",    S_IRUSR, proc_pid_syscall_operations),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
 	ONE("stat",       S_IRUGO, proc_tgid_stat),
@@ -2983,7 +3031,7 @@ static const struct pid_entry tid_base_stuff[] = {
 #endif
 	REG("comm",      S_IRUGO|S_IWUSR, proc_pid_set_comm_operations),
 #ifdef CONFIG_HAVE_ARCH_TRACEHOOK
-	INF("syscall",   S_IRUSR, proc_pid_syscall),
+	REG("syscall",   S_IRUSR, proc_pid_syscall_operations),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
 	ONE("stat",      S_IRUGO, proc_tid_stat),
-- 
1.7.11.7

