Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaEZNhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:37:40 -0400
Received: from numidia.opendz.org ([98.142.220.152]:46159 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbaEZNhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:37:38 -0400
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
Subject: [PATCH 8/9] procfs: improve /proc/<pid>/stat protection
Date: Mon, 26 May 2014 14:27:29 +0100
Message-Id: <1401110850-3552-9-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert wchan from an INF entry to a REG one. This way we can perform
and cache the permission checks during ->open(). We make sure that the
/proc/<pid>/stat will continue to use sequence iterators, in fact this
patch do not affect the logic of /proc/<pid>/stat, it only makes the
cached permission checks available to that handler.

The checks are only cached, since /proc/<pid>/stat is world readable,
and only a small subset of its fields need protections, all the other
fields are world readable. So in order to not break userspace, we cache
the permission checks during ->open() and we re-check during ->read()
and pad sensitive fields with zeros if the reader did not have enough
privileges.

With this logic userspace should continue to work without any problem,
only cases where users are trying to play tricks or something
sophisticated is trying to use privileged programs to disclose sensitive
data will notice that fields are zeroed.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/array.c    | 90 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 fs/proc/base.c     |  4 +--
 fs/proc/internal.h |  6 ++--
 3 files changed, 88 insertions(+), 12 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 64db2bc..84f588f 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -387,7 +387,6 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	char state;
 	pid_t ppid = 0, pgid = -1, sid = -1;
 	int num_threads = 0;
-	int permitted;
 	struct mm_struct *mm;
 	unsigned long long start_time;
 	unsigned long cmin_flt = 0, cmaj_flt = 0;
@@ -397,10 +396,22 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	unsigned long rsslim = 0;
 	char tcomm[sizeof(task->comm)];
 	unsigned long flags;
+	struct pid_seq_private *priv = m->private;
+	int permitted = priv->permitted;
 
 	state = *get_task_state(task);
 	vsize = eip = esp = 0;
-	permitted = ptrace_may_access(task, PTRACE_MODE_READ | PTRACE_MODE_NOAUDIT);
+
+	if (permitted) {
+		/* Update only if access was granted during ->open */
+		unsigned int mode = PTRACE_MODE_READ | PTRACE_MODE_NOAUDIT;
+
+		if (!mutex_lock_killable(&task->signal->cred_guard_mutex)) {
+			permitted = ptrace_may_access(task, mode);
+			mutex_unlock(&task->signal->cred_guard_mutex);
+		}
+	}
+
 	mm = get_task_mm(task);
 	if (mm) {
 		vsize = task_vsize(mm);
@@ -550,18 +561,85 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 	return 0;
 }
 
-int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
-			struct pid *pid, struct task_struct *task)
+static int proc_show_tid_stat(struct seq_file *m, struct pid_namespace *ns,
+			      struct pid *pid, struct task_struct *task)
 {
 	return do_task_stat(m, ns, pid, task, 0);
 }
 
-int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
-			struct pid *pid, struct task_struct *task)
+static int proc_tid_stat(struct seq_file *m, void *v)
+{
+	return pid_entry_show(m, proc_show_tid_stat);
+}
+
+static int do_proc_stat_open(struct inode *inode, struct file *filp,
+			     int (*proc_stat)(struct seq_file *, void *))
+{
+	int ret = -ENOMEM;
+	struct pid_seq_private *priv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ret;
+
+	priv->inode = inode;
+	if (pid_entry_access(filp, PTRACE_MODE_READ | PTRACE_MODE_NOAUDIT))
+		priv->permitted = PID_ENTRY_DENY;
+	else
+		priv->permitted = PID_ENTRY_ALLOW;
+
+	ret = single_open(filp, proc_stat, priv);
+	if (ret)
+		kfree(priv);
+
+	return ret;
+}
+
+static int proc_tid_stat_open(struct inode *inode, struct file *filp)
+{
+	return do_proc_stat_open(inode, filp, proc_tid_stat);
+}
+
+static int proc_stat_release(struct inode *inode, struct file *filp)
+{
+	struct seq_file *seq = filp->private_data;
+
+	kfree(seq->private);
+	seq->private = NULL;
+
+	return single_release(inode, filp);
+}
+
+const struct file_operations proc_tid_stat_operations = {
+	.open		= proc_tid_stat_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = proc_stat_release,
+};
+
+static int proc_show_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
+			       struct pid *pid, struct task_struct *task)
 {
 	return do_task_stat(m, ns, pid, task, 1);
 }
 
+static int proc_tgid_stat(struct seq_file *m, void *v)
+{
+	return pid_entry_show(m, proc_show_tgid_stat);
+}
+
+static int proc_tgid_stat_open(struct inode *inode, struct file *filp)
+{
+	return do_proc_stat_open(inode, filp, proc_tgid_stat);
+}
+
+const struct file_operations proc_tgid_stat_operations = {
+	.open		= proc_tgid_stat_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = proc_stat_release,
+};
+
 int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
 			struct pid *pid, struct task_struct *task)
 {
diff --git a/fs/proc/base.c b/fs/proc/base.c
index b40345b..d98ce15 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2721,7 +2721,7 @@ static const struct pid_entry tgid_base_stuff[] = {
 	REG("syscall",    S_IRUSR, proc_pid_syscall_operations),
 #endif
 	INF("cmdline",    S_IRUGO, proc_pid_cmdline),
-	ONE("stat",       S_IRUGO, proc_tgid_stat),
+	REG("stat",       S_IRUGO, proc_tgid_stat_operations),
 	ONE("statm",      S_IRUGO, proc_pid_statm),
 	REG("maps",       S_IRUGO, proc_pid_maps_operations),
 #ifdef CONFIG_NUMA
@@ -3055,7 +3055,7 @@ static const struct pid_entry tid_base_stuff[] = {
 	REG("syscall",   S_IRUSR, proc_pid_syscall_operations),
 #endif
 	INF("cmdline",   S_IRUGO, proc_pid_cmdline),
-	ONE("stat",      S_IRUGO, proc_tid_stat),
+	REG("stat",      S_IRUGO, proc_tid_stat_operations),
 	ONE("statm",     S_IRUGO, proc_pid_statm),
 	REG("maps",      S_IRUGO, proc_tid_maps_operations),
 #ifdef CONFIG_CHECKPOINT_RESTORE
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 3c4bd73..fc2f59d 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -171,11 +171,9 @@ out:
  * array.c
  */
 extern const struct file_operations proc_tid_children_operations;
+extern const struct file_operations proc_tid_stat_operations;
+extern const struct file_operations proc_tgid_stat_operations;
 
-extern int proc_tid_stat(struct seq_file *, struct pid_namespace *,
-			 struct pid *, struct task_struct *);
-extern int proc_tgid_stat(struct seq_file *, struct pid_namespace *,
-			  struct pid *, struct task_struct *);
 extern int proc_pid_status(struct seq_file *, struct pid_namespace *,
 			   struct pid *, struct task_struct *);
 extern int proc_pid_statm(struct seq_file *, struct pid_namespace *,
-- 
1.7.11.7

