Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbbAURVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:21:44 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:51265 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753065AbbAURVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:21:04 -0500
Message-Id: <20150121172101.953700301@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 21 Jan 2015 12:19:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [RFC][PATCH 4/5] tracing: Have mkdir and rmdir be part of tracefs
References: <20150121171953.823177070@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-tracing-Have-mkdir-and-rmdir-be-part-of-tracefs.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The tracing "instances" directory can create sub tracing buffers
with mkdir, and remove them with rmdir. As a mkdir will also create
all the files and directories that control the sub buffer the locks
needed to be released before doing so to avoid deadlock. This method
was not very robust, and could potentially have a race somewhere due
to the lock releasing within the removing of the directory. But this
was needed because debugfs did not provide a mkdir or rmdir method
from syscalls.

Now that tracing has been converted over to tracefs, the tracefs file
system can be modified to accommodate this feature. Instead of needing
to release the locks, keep them locked but add a way to flag that they
are locked and do not need to be locked again.

A struct trace_dir_ops is created that holds the methods to be called
for both mkdir and rmdir, as well as a pointer to let the tracefs subsystem
know that the current inode's lock is already held by the calling process.

The pointer holds the current owner of the lock, and this is checked when
creating new files or removing old ones, and if the pointer matches current,
then the lock is not taken to avoid the deadlock.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/tracefs/inode.c   | 103 +++++++++++++++++++++++++++++++++++++++++++++------
 kernel/trace/trace.c |  68 ++--------------------------------
 2 files changed, 96 insertions(+), 75 deletions(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index d243f670d461..29632ce2c456 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -42,13 +42,62 @@ static ssize_t default_write_file(struct file *file, const char __user *buf,
 	return count;
 }
 
-const struct file_operations tracefs_file_operations = {
+static const struct file_operations tracefs_file_operations = {
 	.read =		default_read_file,
 	.write =	default_write_file,
 	.open =		simple_open,
 	.llseek =	noop_llseek,
 };
 
+static int tracefs_syscall_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode)
+{
+	struct tracefs_dir_ops *ops = inode ? inode->i_private : NULL;
+	int ret;
+
+	if (!ops)
+		return -EPERM;
+
+	/*
+	 * The mkdir call can call the generic functions that create
+	 * the files within the tracefs system. Do not relock the parent,
+	 * it was locked by the caller of this function.
+	 */
+	ops->lock_owner = current;
+	ret = ops->mkdir(dentry->d_iname);
+	ops->lock_owner = NULL;
+
+	return ret;
+}
+
+static int tracefs_syscall_rmdir(struct inode *inode, struct dentry *dentry)
+{
+	struct tracefs_dir_ops *ops = inode->i_private;
+	int ret;
+
+	if (!ops)
+		return -EPERM;
+
+	/*
+	 * The rmdir call can call the generic functions that remove
+	 * the files within the tracefs system. Do not relock the parent,
+	 * it was locked by the caller of this function.
+	 */
+	ops->lock_owner = current;
+	/* The caller also locked the dentry, do not lock that again either */
+	dentry->d_inode->i_private = ops;
+	ret = ops->rmdir(dentry->d_iname);
+	dentry->d_inode->i_private = NULL;
+	ops->lock_owner = NULL;
+
+	return ret;
+}
+
+const struct inode_operations tracefs_dir_inode_operations = {
+	.lookup		= simple_lookup,
+	.mkdir		= tracefs_syscall_mkdir,
+	.rmdir		= tracefs_syscall_rmdir,
+};
+
 static struct inode *tracefs_get_inode(struct super_block *sb, umode_t mode, dev_t dev,
 				      void *data, const struct file_operations *fops)
 
@@ -68,7 +117,7 @@ static struct inode *tracefs_get_inode(struct super_block *sb, umode_t mode, dev
 			inode->i_private = data;
 			break;
 		case S_IFDIR:
-			inode->i_op = &simple_dir_inode_operations;
+			inode->i_op = &tracefs_dir_inode_operations;
 			inode->i_fop = &simple_dir_operations;
 
 			/* directory inodes start off with i_nlink == 2
@@ -125,6 +174,16 @@ static int tracefs_create(struct inode *dir, struct dentry *dentry, umode_t mode
 	return res;
 }
 
+void tracefs_add_dir_ops(struct dentry *dentry, struct tracefs_dir_ops *ops)
+{
+	struct inode *inode = dentry->d_inode;
+
+	if (!inode)
+		return;
+
+	inode->i_private = ops;
+}
+
 struct tracefs_mount_opts {
 	kuid_t uid;
 	kgid_t gid;
@@ -305,7 +364,9 @@ static struct dentry *__create_file(const char *name, umode_t mode,
 				    struct dentry *parent, void *data,
 				    const struct file_operations *fops)
 {
+	struct tracefs_dir_ops *ops;
 	struct dentry *dentry = NULL;
+	struct inode *parent_inode;
 	int error;
 
 	pr_debug("tracefs: creating file '%s'\n",name);
@@ -323,7 +384,12 @@ static struct dentry *__create_file(const char *name, umode_t mode,
 	if (!parent)
 		parent = tracefs_mount->mnt_root;
 
-	mutex_lock(&parent->d_inode->i_mutex);
+	parent_inode = parent->d_inode;
+	ops = parent_inode->i_private;
+
+	if (!ops || ops->lock_owner != current)
+		mutex_lock(&parent->d_inode->i_mutex);
+
 	dentry = lookup_one_len(name, parent, strlen(name));
 	if (!IS_ERR(dentry)) {
 		switch (mode & S_IFMT) {
@@ -339,7 +405,8 @@ static struct dentry *__create_file(const char *name, umode_t mode,
 		dput(dentry);
 	} else
 		error = PTR_ERR(dentry);
-	mutex_unlock(&parent->d_inode->i_mutex);
+	if (!ops || ops->lock_owner != current)
+		mutex_unlock(&parent->d_inode->i_mutex);
 
 	if (error) {
 		dentry = NULL;
@@ -452,7 +519,9 @@ static int __tracefs_remove(struct dentry *dentry, struct dentry *parent)
  */
 void tracefs_remove(struct dentry *dentry)
 {
+	struct tracefs_dir_ops *ops;
 	struct dentry *parent;
+	struct inode *inode;
 	int ret;
 
 	if (IS_ERR_OR_NULL(dentry))
@@ -462,9 +531,13 @@ void tracefs_remove(struct dentry *dentry)
 	if (!parent || !parent->d_inode)
 		return;
 
-	mutex_lock(&parent->d_inode->i_mutex);
+	inode = parent->d_inode;
+	ops = inode->i_private;
+	if (!ops || ops->lock_owner != current)
+		mutex_lock(&parent->d_inode->i_mutex);
 	ret = __tracefs_remove(dentry, parent);
-	mutex_unlock(&parent->d_inode->i_mutex);
+	if (!ops || ops->lock_owner != current)
+		mutex_unlock(&parent->d_inode->i_mutex);
 	if (!ret)
 		simple_release_fs(&tracefs_mount, &tracefs_mount_count);
 }
@@ -479,6 +552,7 @@ void tracefs_remove(struct dentry *dentry)
  */
 void tracefs_remove_recursive(struct dentry *dentry)
 {
+	struct tracefs_dir_ops *ops;
 	struct dentry *child, *parent;
 
 	if (IS_ERR_OR_NULL(dentry))
@@ -490,7 +564,9 @@ void tracefs_remove_recursive(struct dentry *dentry)
 
 	parent = dentry;
  down:
-	mutex_lock(&parent->d_inode->i_mutex);
+	ops = parent->d_inode->i_private;
+	if (!ops || ops->lock_owner != current)
+		mutex_lock(&parent->d_inode->i_mutex);
  loop:
 	/*
 	 * The parent->d_subdirs is protected by the d_lock. Outside that
@@ -505,7 +581,8 @@ void tracefs_remove_recursive(struct dentry *dentry)
 		/* perhaps simple_empty(child) makes more sense */
 		if (!list_empty(&child->d_subdirs)) {
 			spin_unlock(&parent->d_lock);
-			mutex_unlock(&parent->d_inode->i_mutex);
+			if (!ops || ops->lock_owner != current)
+				mutex_unlock(&parent->d_inode->i_mutex);
 			parent = child;
 			goto down;
 		}
@@ -526,10 +603,13 @@ void tracefs_remove_recursive(struct dentry *dentry)
 	}
 	spin_unlock(&parent->d_lock);
 
-	mutex_unlock(&parent->d_inode->i_mutex);
+	if (!ops || ops->lock_owner != current)
+		mutex_unlock(&parent->d_inode->i_mutex);
 	child = parent;
 	parent = parent->d_parent;
-	mutex_lock(&parent->d_inode->i_mutex);
+	ops = parent->d_inode->i_private;
+	if (!ops || ops->lock_owner != current)
+		mutex_lock(&parent->d_inode->i_mutex);
 
 	if (child != dentry)
 		/* go up */
@@ -537,7 +617,8 @@ void tracefs_remove_recursive(struct dentry *dentry)
 
 	if (!__tracefs_remove(child, parent))
 		simple_release_fs(&tracefs_mount, &tracefs_mount_count);
-	mutex_unlock(&parent->d_inode->i_mutex);
+	if (!ops || ops->lock_owner != current)
+		mutex_unlock(&parent->d_inode->i_mutex);
 }
 
 /**
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e025e6f04bfa..78bf3007cfc2 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -6349,7 +6349,7 @@ static void free_trace_buffers(struct trace_array *tr)
 #endif
 }
 
-static int new_instance_create(const char *name)
+static int instance_mkdir(const char *name)
 {
 	struct trace_array *tr;
 	int ret;
@@ -6419,7 +6419,7 @@ static int new_instance_create(const char *name)
 
 }
 
-static int instance_delete(const char *name)
+static int instance_rmdir(const char *name)
 {
 	struct trace_array *tr;
 	int found = 0;
@@ -6460,66 +6460,7 @@ static int instance_delete(const char *name)
 	return ret;
 }
 
-static int instance_mkdir (struct inode *inode, struct dentry *dentry, umode_t mode)
-{
-	struct dentry *parent;
-	int ret;
-
-	/* Paranoid: Make sure the parent is the "instances" directory */
-	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_u.d_alias);
-	if (WARN_ON_ONCE(parent != trace_instance_dir))
-		return -ENOENT;
-
-	/*
-	 * The inode mutex is locked, but tracefs_create_dir() will also
-	 * take the mutex. As the instances directory can not be destroyed
-	 * or changed in any other way, it is safe to unlock it, and
-	 * let the dentry try. If two users try to make the same dir at
-	 * the same time, then the new_instance_create() will determine the
-	 * winner.
-	 */
-	mutex_unlock(&inode->i_mutex);
-
-	ret = new_instance_create(dentry->d_iname);
-
-	mutex_lock(&inode->i_mutex);
-
-	return ret;
-}
-
-static int instance_rmdir(struct inode *inode, struct dentry *dentry)
-{
-	struct dentry *parent;
-	int ret;
-
-	/* Paranoid: Make sure the parent is the "instances" directory */
-	parent = hlist_entry(inode->i_dentry.first, struct dentry, d_u.d_alias);
-	if (WARN_ON_ONCE(parent != trace_instance_dir))
-		return -ENOENT;
-
-	/* The caller did a dget() on dentry */
-	mutex_unlock(&dentry->d_inode->i_mutex);
-
-	/*
-	 * The inode mutex is locked, but tracefs_create_dir() will also
-	 * take the mutex. As the instances directory can not be destroyed
-	 * or changed in any other way, it is safe to unlock it, and
-	 * let the dentry try. If two users try to make the same dir at
-	 * the same time, then the instance_delete() will determine the
-	 * winner.
-	 */
-	mutex_unlock(&inode->i_mutex);
-
-	ret = instance_delete(dentry->d_iname);
-
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
-	mutex_lock(&dentry->d_inode->i_mutex);
-
-	return ret;
-}
-
-static const struct inode_operations instance_dir_inode_operations = {
-	.lookup		= simple_lookup,
+static struct tracefs_dir_ops instance_dir_ops = {
 	.mkdir		= instance_mkdir,
 	.rmdir		= instance_rmdir,
 };
@@ -6530,8 +6471,7 @@ static __init void create_trace_instances(struct dentry *d_tracer)
 	if (WARN_ON(!trace_instance_dir))
 		return;
 
-	/* Hijack the dir inode operations, to allow mkdir */
-	trace_instance_dir->d_inode->i_op = &instance_dir_inode_operations;
+	tracefs_add_dir_ops(trace_instance_dir, &instance_dir_ops);
 }
 
 static void
-- 
2.1.4


