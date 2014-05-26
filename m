Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaEZNgj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:36:39 -0400
Received: from numidia.opendz.org ([98.142.220.152]:45402 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaEZNgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:36:37 -0400
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
Subject: [PATCH 7/9] procfs: add pid_entry_show() helper to handle /proc/<pid>/{stat|stack}
Date: Mon, 26 May 2014 14:27:28 +0100
Message-Id: <1401110850-3552-8-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparation, it adds the pid_entry_show() helper function
which will be used to handle /proc/<pid>/{stat|stack} and to call their
internal handlers. This logic allows these files to continue to use
sequence iterators.

Currently ONE entries share the same code, and they do not perform
permission checks during ->open(). So adding these checks during open
will only disturb the ONE entries that do not need permission checks.

The ONE entries that need checks are:
/proc/<pid>/stat
/proc/<pid>/stack

So to have proper permission checks convert this ONE entries to REG
entries and use their open() and read() handlers to implement these
checks. To achieve this we add the following helper:

* pid_entry_show(): which will get the necessary info and passe it to the
appropriate handlers. The handlers are of the same type of the previous
ONE entries, so nothing changes for /proc/<pid>/{stat|stack} handlers.

The handler type is:
typedef int (*proc_show_fn_t)(struct seq_file *seq, struct pid_namespace *ns,
			      struct pid *pid, struct task_struct *task);

Which is the same type of:

/proc/<pid>/stat:
int proc_tid_stat(struct seq_file *m, struct pid_namespace *ns,
		  struct pid *pid, struct task_struct *task)

/proc/<pid>/stack:
static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
			  struct pid *pid, struct task_struct *task)

The 'seq_file->private' will contain the struct 'pid_seq_private' which
contains the inode and the cached permission checks.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/base.c     | 21 +++++++++++++++++++++
 fs/proc/internal.h |  3 +++
 2 files changed, 24 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index f0ce94a..b40345b 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -183,6 +183,27 @@ out_no_task:
 	return length;
 }
 
+int pid_entry_show(struct seq_file *seq, proc_show_fn_t proc_show)
+{
+	int ret = -ESRCH;
+	struct pid *pid;
+	struct task_struct *task;
+	struct pid_namespace *ns;
+	struct pid_seq_private *priv = seq->private;
+	struct inode *inode = priv->inode;
+
+	ns = inode->i_sb->s_fs_info;
+	pid = proc_pid(inode);
+	task = get_pid_task(pid, PIDTYPE_PID);
+	if (!task)
+		return ret;
+
+	ret = proc_show(seq, ns, pid, task);
+
+	put_task_struct(task);
+	return ret;
+}
+
 static int pid_entry_attach(struct file *filp)
 {
 	int ret = pid_entry_access(filp, PTRACE_MODE_ATTACH);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index f28e4f01..3c4bd73 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -91,6 +91,8 @@ struct pid_seq_private {
 
 typedef int (*proc_read_fn_t)(char *page,
 			      struct task_struct *task, int permitted);
+typedef int (*proc_show_fn_t)(struct seq_file *seq, struct pid_namespace *ns,
+			      struct pid *pid, struct task_struct *task);
 
 /*
  * General functions
@@ -191,6 +193,7 @@ extern int pid_delete_dentry(const struct dentry *);
 extern int proc_pid_readdir(struct file *, struct dir_context *);
 extern struct dentry *proc_pid_lookup(struct inode *, struct dentry *, unsigned int);
 extern loff_t mem_lseek(struct file *, loff_t, int);
+extern int pid_entry_show(struct seq_file *seq, proc_show_fn_t proc_show);
 
 /* Lookups */
 typedef int instantiate_t(struct inode *, struct dentry *,
-- 
1.7.11.7

