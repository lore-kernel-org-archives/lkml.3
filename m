Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaDUQXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 12:23:16 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33432 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaDUQXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 12:23:03 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        David Herrmann <dh.herrmann@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 1/2] fs,proc: Pass nameidata to proc_get_link implementations
Date: Mon, 21 Apr 2014 09:22:47 -0700
Message-Id: <79198263e1989bf0916e3aa51a253d8b4c08a396.1398097304.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1398097304.git.luto@amacapital.net>
References: <cover.1398097304.git.luto@amacapital.net>
In-Reply-To: <cover.1398097304.git.luto@amacapital.net>
References: <cover.1398097304.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_fd_link should respect fs modes, and it needs to know the open
mode to do so.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/proc/base.c     | 13 ++++++++-----
 fs/proc/fd.c       |  3 ++-
 fs/proc/internal.h |  3 ++-
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2d696b0..b8eca09 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -171,7 +171,8 @@ static int get_task_root(struct task_struct *task, struct path *root)
 	return result;
 }
 
-static int proc_cwd_link(struct dentry *dentry, struct path *path)
+static int proc_cwd_link(struct nameidata *nd,
+			 struct dentry *dentry, struct path *path)
 {
 	struct task_struct *task = get_proc_task(dentry->d_inode);
 	int result = -ENOENT;
@@ -188,7 +189,8 @@ static int proc_cwd_link(struct dentry *dentry, struct path *path)
 	return result;
 }
 
-static int proc_root_link(struct dentry *dentry, struct path *path)
+static int proc_root_link(struct nameidata *nd,
+			  struct dentry *dentry, struct path *path)
 {
 	struct task_struct *task = get_proc_task(dentry->d_inode);
 	int result = -ENOENT;
@@ -1407,7 +1409,8 @@ static const struct file_operations proc_pid_set_comm_operations = {
 	.release	= single_release,
 };
 
-static int proc_exe_link(struct dentry *dentry, struct path *exe_path)
+static int proc_exe_link(struct nameidata *nd,
+			 struct dentry *dentry, struct path *exe_path)
 {
 	struct task_struct *task;
 	struct mm_struct *mm;
@@ -1441,7 +1444,7 @@ static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(dentry, &path);
+	error = PROC_I(inode)->op.proc_get_link(nd, dentry, &path);
 	if (error)
 		goto out;
 
@@ -1485,7 +1488,7 @@ static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int b
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(dentry, &path);
+	error = PROC_I(inode)->op.proc_get_link(NULL, dentry, &path);
 	if (error)
 		goto out;
 
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 0788d09..deca407 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -139,7 +139,8 @@ static const struct dentry_operations tid_fd_dentry_operations = {
 	.d_delete	= pid_delete_dentry,
 };
 
-static int proc_fd_link(struct dentry *dentry, struct path *path)
+static int proc_fd_link(struct nameidata *nd,
+			struct dentry *dentry, struct path *path)
 {
 	struct files_struct *files = NULL;
 	struct task_struct *task;
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 3ab6d14..ae7ff1d 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -51,7 +51,8 @@ struct proc_dir_entry {
 };
 
 union proc_op {
-	int (*proc_get_link)(struct dentry *, struct path *);
+	int (*proc_get_link)(struct nameidata *,
+			     struct dentry *, struct path *);
 	int (*proc_read)(struct task_struct *task, char *page);
 	int (*proc_show)(struct seq_file *m,
 		struct pid_namespace *ns, struct pid *pid,
-- 
1.9.0

