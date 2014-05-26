Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaEZNil (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:38:41 -0400
Received: from numidia.opendz.org ([98.142.220.152]:57873 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaEZNik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:38:40 -0400
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
Subject: [PATCH 9/9] procfs: improve /proc/<pid>/stack protection
Date: Mon, 26 May 2014 14:27:30 +0100
Message-Id: <1401110850-3552-10-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert stack from an INF entry to a REG one. This way we can perform
and cache the permission checks during ->open(). We make sure that
/proc/<pid>/stack will continue to use sequence iterators.

The ptrace capability is only cached, it will be re-checked during
->read(). If the opener did not have enough privileges then fail.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 54 insertions(+), 5 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index d98ce15..6786878 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -387,14 +387,19 @@ static void unlock_trace(struct task_struct *task)
 
 #define MAX_STACK_TRACE_DEPTH	64
 
-static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
-			  struct pid *pid, struct task_struct *task)
+static int proc_show_pid_stack(struct seq_file *m, struct pid_namespace *ns,
+			       struct pid *pid, struct task_struct *task)
 {
 	struct stack_trace trace;
 	unsigned long *entries;
-	int err;
+	struct pid_seq_private *priv = m->private;
+	int permitted = priv->permitted;
+	int err = -EPERM;
 	int i;
 
+	if (!permitted)
+		return err;
+
 	entries = kmalloc(MAX_STACK_TRACE_DEPTH * sizeof(*entries), GFP_KERNEL);
 	if (!entries)
 		return -ENOMEM;
@@ -418,6 +423,50 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 
 	return err;
 }
+
+static int proc_pid_stack(struct seq_file *m, void *v)
+{
+	return pid_entry_show(m, proc_show_pid_stack);
+}
+
+static int stack_open(struct inode *inode, struct file *filp)
+{
+	int ret = -ENOMEM;
+	struct pid_seq_private *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ret;
+
+	priv->inode = inode;
+	if (pid_entry_access(filp, PTRACE_MODE_ATTACH))
+		priv->permitted = PID_ENTRY_DENY;
+	else
+		priv->permitted = PID_ENTRY_ALLOW;
+
+	ret = single_open(filp, proc_pid_stack, priv);
+	if (ret)
+		kfree(priv);
+
+	return ret;
+}
+
+static int stack_release(struct inode *inode, struct file *filp)
+{
+	struct seq_file *seq = filp->private_data;
+
+	kfree(seq->private);
+	seq->private = NULL;
+
+	return single_release(inode, filp);
+}
+
+static const struct file_operations proc_pid_stack_operations = {
+	.open		= stack_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = stack_release,
+};
 #endif
 
 #ifdef CONFIG_SCHEDSTATS
@@ -2746,7 +2795,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("wchan",      S_IRUGO, proc_pid_wchan_operations),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUSR, proc_pid_stack),
+	REG("stack",      S_IRUSR, proc_pid_stack_operations),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat",  S_IRUGO, proc_pid_schedstat),
@@ -3082,7 +3131,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("wchan",     S_IRUGO, proc_pid_wchan_operations),
 #endif
 #ifdef CONFIG_STACKTRACE
-	ONE("stack",      S_IRUSR, proc_pid_stack),
+	REG("stack",      S_IRUSR, proc_pid_stack_operations),
 #endif
 #ifdef CONFIG_SCHEDSTATS
 	INF("schedstat", S_IRUGO, proc_pid_schedstat),
-- 
1.7.11.7

