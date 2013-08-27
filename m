Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3H0TQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 15:16:59 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33122 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3H0TQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 15:16:57 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        "security@kernel.org" <security@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Brad Spengler <spender@grsecurity.net>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH] fs: Add user_file_or_path_at and use it for truncate
Date: Tue, 27 Aug 2013 12:16:34 -0700
Message-Id: <7d1419dda1da70a8ad915f85b093a58b86bcaf3b.1377630856.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
References: <CA+55aFw20W9L8HV+VbTRNeQQM-_+aeUhvT9AAod5LGfb-7hE9g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an experiment to see if we can get nice semantics for all syscalls
that either follow symlinks or allow AT_EMPTY_PATH without jumping through
enormous hoops.  This converts truncate (although you can't tell using
truncate from coreutils, because it actually uses open + ftruncate).

The basic idea is that there's a new helper function
user_file_or_path_at.  It takes an fd and a path and, depending on
flags, the emptiness of the path, and whether path is a magic /proc
symlink (or a symlink to a magic /proc/symlink), it returns either a
struct path or a struct file *.

To make this genuinely useful, something similar will need to happen for
open/openat.

The lifetime rules for the contents of struct nameidata seem weird.
If all users first memset the thing to zero and called nd_put or
something when they were done, this would be cleaner.  But they don't.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 fs/namei.c            | 73 ++++++++++++++++++++++++++++++++++++++++
 fs/open.c             | 93 +++++++++++++++++++++++++++++----------------------
 fs/proc/base.c        | 44 +++++++++++++-----------
 fs/proc/fd.c          | 10 +++---
 fs/proc/internal.h    |  3 +-
 include/linux/namei.h | 14 ++++++++
 6 files changed, 171 insertions(+), 66 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 89a612e..0d905ac 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -691,6 +691,28 @@ void nd_jump_link(struct nameidata *nd, struct path *path)
 	nd->flags |= LOOKUP_JUMPED;
 }
 
+/*
+ * Helper for /proc/pid/fd/N-style magic links.  This is like nd_jump_link
+ * except that it will apply additional security checks.  Caller must have
+ * taken a reference to file beforehand.
+ */
+void nd_jump_link_file(struct nameidata *nd, struct file *file)
+{
+	path_put(&nd->path);
+
+	nd->path = file->f_path;
+	path_get(&nd->path);
+	if (nd->flags & LOOKUP_FILE) {
+		if (nd->last_symlink_file)
+			fput(nd->last_symlink_file);
+		nd->last_symlink_file = file;
+	} else {
+		fput(file);
+	}
+	nd->inode = nd->path.dentry->d_inode;
+	nd->flags |= LOOKUP_JUMPED;
+}
+
 static inline void put_link(struct nameidata *nd, struct path *link, void *cookie)
 {
 	struct inode *inode = link->dentry->d_inode;
@@ -842,6 +864,10 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
 		goto out_put_nd_path;
 
 	nd->last_type = LAST_BIND;
+	if (unlikely((nd->flags & LOOKUP_FILE) && nd->last_symlink_file)) {
+		fput(nd->last_symlink_file);
+		nd->last_symlink_file = NULL;
+	}
 	*p = dentry->d_inode->i_op->follow_link(dentry, nd);
 	error = PTR_ERR(*p);
 	if (IS_ERR(*p))
@@ -2156,6 +2182,53 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
 	return user_path_at_empty(dfd, name, flags, path, NULL);
 }
 
+int user_file_or_path_at(int dfd, const char __user *filename,
+			 int lookup_flags, bool null_filename_okay,
+			 struct file_or_path *out)
+{
+	struct nameidata nd;
+	struct filename *tmp;
+	int err;
+	int empty = 0;
+
+	if (!filename && null_filename_okay) {
+		out->file = fget(dfd);
+		return out->file ? 0 : -EBADF;
+	}
+
+	tmp = getname_flags(filename, lookup_flags, &empty);
+	if (IS_ERR(tmp))
+		return PTR_ERR(tmp);
+
+	if (empty) {
+		out->file = fget(dfd);
+		return out->file ? 0 : -EBADF;
+	}
+
+	nd.last_symlink_file = NULL;
+	BUG_ON(lookup_flags & LOOKUP_PARENT);
+
+	err = filename_lookup(dfd, tmp, lookup_flags | LOOKUP_FILE, &nd);
+	putname(tmp);
+	if (!err) {
+		if (nd.last_symlink_file && nd.last_type == LAST_BIND) {
+			out->file = nd.last_symlink_file;
+			memset(&out->path, 0, sizeof(out->path));
+			path_put(&nd.path);
+		} else {
+			out->path = nd.path;
+			out->file = NULL;
+			if (nd.last_symlink_file)
+				fput(nd.last_symlink_file);
+		}
+	} else {
+		if (nd.last_symlink_file)
+			fput(nd.last_symlink_file);
+	}
+
+	return err;
+}
+
 /*
  * NB: most callers don't do anything directly with the reference to the
  *     to struct filename, but the nd->last pointer points into the name string
diff --git a/fs/open.c b/fs/open.c
index 7931f76..1349b43 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -114,20 +114,66 @@ out:
 }
 EXPORT_SYMBOL_GPL(vfs_truncate);
 
+static long do_truncate_file(struct file *file, loff_t length, int small)
+{
+	struct inode *inode;
+	struct dentry *dentry;
+	int error;
+
+	error = -EINVAL;
+	if (length < 0)
+		goto out;
+
+	/* explicitly opened as large or we are on 64-bit box */
+	if (file->f_flags & O_LARGEFILE)
+		small = 0;
+
+	dentry = file->f_path.dentry;
+	inode = dentry->d_inode;
+	error = -EINVAL;
+	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
+		goto out;
+
+	error = -EINVAL;
+	/* Cannot ftruncate over 2^31 bytes without large file support */
+	if (small && length > MAX_NON_LFS)
+		goto out;
+
+	error = -EPERM;
+	if (IS_APPEND(inode))
+		goto out;
+
+	sb_start_write(inode->i_sb);
+	error = locks_verify_truncate(inode, file, length);
+	if (!error)
+		error = security_path_truncate(&file->f_path);
+	if (!error)
+		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+	sb_end_write(inode->i_sb);
+out:
+	return error;
+}
+
 static long do_sys_truncate(const char __user *pathname, loff_t length)
 {
-	unsigned int lookup_flags = LOOKUP_FOLLOW;
-	struct path path;
+	struct file_or_path obj;
+	int lookup_flags = LOOKUP_FOLLOW;
 	int error;
 
 	if (length < 0)	/* sorry, but loff_t says... */
 		return -EINVAL;
 
 retry:
-	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
+	error = user_file_or_path_at(AT_FDCWD, pathname,
+				     LOOKUP_FOLLOW, false, &obj);
 	if (!error) {
-		error = vfs_truncate(&path, length);
-		path_put(&path);
+		if (obj.file) {
+			error = do_truncate_file(obj.file, length, 0);
+			fput(obj.file);
+		} else {
+			error = vfs_truncate(&obj.path, length);
+			path_put(&obj.path);
+		}
 	}
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
@@ -150,48 +196,15 @@ COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length
 
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 {
-	struct inode *inode;
-	struct dentry *dentry;
 	struct fd f;
 	int error;
 
-	error = -EINVAL;
-	if (length < 0)
-		goto out;
 	error = -EBADF;
 	f = fdget(fd);
 	if (!f.file)
-		goto out;
-
-	/* explicitly opened as large or we are on 64-bit box */
-	if (f.file->f_flags & O_LARGEFILE)
-		small = 0;
-
-	dentry = f.file->f_path.dentry;
-	inode = dentry->d_inode;
-	error = -EINVAL;
-	if (!S_ISREG(inode->i_mode) || !(f.file->f_mode & FMODE_WRITE))
-		goto out_putf;
-
-	error = -EINVAL;
-	/* Cannot ftruncate over 2^31 bytes without large file support */
-	if (small && length > MAX_NON_LFS)
-		goto out_putf;
-
-	error = -EPERM;
-	if (IS_APPEND(inode))
-		goto out_putf;
-
-	sb_start_write(inode->i_sb);
-	error = locks_verify_truncate(inode, f.file, length);
-	if (!error)
-		error = security_path_truncate(&f.file->f_path);
-	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, f.file);
-	sb_end_write(inode->i_sb);
-out_putf:
+		return error;
+	error = do_truncate_file(f.file, length, small);
 	fdput(f);
-out:
 	return error;
 }
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1485e38..ac28ff3 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -171,7 +171,7 @@ static int get_task_root(struct task_struct *task, struct path *root)
 	return result;
 }
 
-static int proc_cwd_link(struct dentry *dentry, struct path *path)
+static int proc_cwd_link(struct dentry *dentry, struct file_or_path *link)
 {
 	struct task_struct *task = get_proc_task(dentry->d_inode);
 	int result = -ENOENT;
@@ -179,7 +179,8 @@ static int proc_cwd_link(struct dentry *dentry, struct path *path)
 	if (task) {
 		task_lock(task);
 		if (task->fs) {
-			get_fs_pwd(task->fs, path);
+			link->file = NULL;
+			get_fs_pwd(task->fs, &link->path);
 			result = 0;
 		}
 		task_unlock(task);
@@ -188,13 +189,14 @@ static int proc_cwd_link(struct dentry *dentry, struct path *path)
 	return result;
 }
 
-static int proc_root_link(struct dentry *dentry, struct path *path)
+static int proc_root_link(struct dentry *dentry, struct file_or_path *link)
 {
 	struct task_struct *task = get_proc_task(dentry->d_inode);
 	int result = -ENOENT;
 
 	if (task) {
-		result = get_task_root(task, path);
+		link->file = NULL;
+		result = get_task_root(task, &link->path);
 		put_task_struct(task);
 	}
 	return result;
@@ -1430,11 +1432,10 @@ static const struct file_operations proc_pid_set_comm_operations = {
 	.release	= single_release,
 };
 
-static int proc_exe_link(struct dentry *dentry, struct path *exe_path)
+static int proc_exe_link(struct dentry *dentry, struct file_or_path *link)
 {
 	struct task_struct *task;
 	struct mm_struct *mm;
-	struct file *exe_file;
 
 	task = get_proc_task(dentry->d_inode);
 	if (!task)
@@ -1443,32 +1444,32 @@ static int proc_exe_link(struct dentry *dentry, struct path *exe_path)
 	put_task_struct(task);
 	if (!mm)
 		return -ENOENT;
-	exe_file = get_mm_exe_file(mm);
+	link->file = get_mm_exe_file(mm);
 	mmput(mm);
-	if (exe_file) {
-		*exe_path = exe_file->f_path;
-		path_get(&exe_file->f_path);
-		fput(exe_file);
+	if (link->file)
 		return 0;
-	} else
+	else
 		return -ENOENT;
 }
 
 static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct inode *inode = dentry->d_inode;
-	struct path path;
+	struct file_or_path link;
 	int error = -EACCES;
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(dentry, &path);
+	error = PROC_I(inode)->op.proc_get_link(dentry, &link);
 	if (error)
 		goto out;
 
-	nd_jump_link(nd, &path);
+	if (link.file)
+		nd_jump_link_file(nd, link.file);
+	else
+		nd_jump_link(nd, &link.path);
 	return NULL;
 out:
 	return ERR_PTR(error);
@@ -1502,18 +1503,23 @@ static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int b
 {
 	int error = -EACCES;
 	struct inode *inode = dentry->d_inode;
-	struct path path;
+	struct file_or_path link;
 
 	/* Are we allowed to snoop on the tasks file descriptors? */
 	if (!proc_fd_access_allowed(inode))
 		goto out;
 
-	error = PROC_I(inode)->op.proc_get_link(dentry, &path);
+	error = PROC_I(inode)->op.proc_get_link(dentry, &link);
 	if (error)
 		goto out;
 
-	error = do_proc_readlink(&path, buffer, buflen);
-	path_put(&path);
+	if (link.file) {
+		error = do_proc_readlink(&link.file->f_path, buffer, buflen);
+		fput(link.file);
+	} else {
+		error = do_proc_readlink(&link.path, buffer, buflen);
+		path_put(&link.path);
+	}
 out:
 	return error;
 }
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 0ff80f9..4c88fc2 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -137,7 +137,7 @@ static const struct dentry_operations tid_fd_dentry_operations = {
 	.d_delete	= pid_delete_dentry,
 };
 
-static int proc_fd_link(struct dentry *dentry, struct path *path)
+static int proc_fd_link(struct dentry *dentry, struct file_or_path *link)
 {
 	struct files_struct *files = NULL;
 	struct task_struct *task;
@@ -151,13 +151,11 @@ static int proc_fd_link(struct dentry *dentry, struct path *path)
 
 	if (files) {
 		int fd = proc_fd(dentry->d_inode);
-		struct file *fd_file;
 
 		spin_lock(&files->file_lock);
-		fd_file = fcheck_files(files, fd);
-		if (fd_file) {
-			*path = fd_file->f_path;
-			path_get(&fd_file->f_path);
+		link->file = fcheck_files(files, fd);
+		if (link->file) {
+			get_file(link->file);
 			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 651d09a..fc936d5 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
 #include <linux/binfmts.h>
+#include <linux/namei.h>
 
 struct ctl_table_header;
 struct mempolicy;
@@ -51,7 +52,7 @@ struct proc_dir_entry {
 };
 
 union proc_op {
-	int (*proc_get_link)(struct dentry *, struct path *);
+	int (*proc_get_link)(struct dentry *, struct file_or_path *link);
 	int (*proc_read)(struct task_struct *task, char *page);
 	int (*proc_show)(struct seq_file *m,
 		struct pid_namespace *ns, struct pid *pid,
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 5a5ff57..77f585e 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -15,6 +15,7 @@ struct nameidata {
 	struct qstr	last;
 	struct path	root;
 	struct inode	*inode; /* path.dentry.d_inode */
+	struct file	*last_symlink_file;
 	unsigned int	flags;
 	unsigned	seq;
 	int		last_type;
@@ -56,9 +57,21 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_ROOT		0x2000
 #define LOOKUP_EMPTY		0x4000
 
+#define LOOKUP_FILE		0x8000
+
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
 extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
 
+struct file_or_path
+{
+	struct file *file;
+	struct path path;
+};
+
+extern int user_file_or_path_at(int dfd, const char __user *filename,
+				int lookup_flags, bool null_filename_okay,
+				struct file_or_path *out);
+
 #define user_path(name, path) user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW, path)
 #define user_lpath(name, path) user_path_at(AT_FDCWD, name, 0, path)
 #define user_path_dir(name, path) \
@@ -83,6 +96,7 @@ extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);
 
 extern void nd_jump_link(struct nameidata *nd, struct path *path);
+extern void nd_jump_link_file(struct nameidata *nd, struct file *file);
 
 static inline void nd_set_link(struct nameidata *nd, char *path)
 {
-- 
1.8.3.1

