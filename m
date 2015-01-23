Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbbAWQ01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:26:27 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:37966 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755658AbbAWQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:24:16 -0500
Message-Id: <20150123162414.897590925@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 23 Jan 2015 10:55:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 5/5 v2] tracing: Have mkdir and rmdir be part of tracefs
References: <20150123155525.795129339@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0005-tracing-Have-mkdir-and-rmdir-be-part-of-tracefs.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The tracing "instances" directory can create sub tracing buffers
with mkdir, and remove them with rmdir. As a mkdir will also create
all the files and directories that control the sub buffer the inode
mutexes need to be released before this is done, to avoid deadlocks.
It is better to let the tracing system unlock the inode mutexes before
calling the functions that create the files within the new directory
(or deletes the files from the one being destroyed).

Now that tracing has been converted over to tracefs, the tracefs file
system can be modified to accommodate this feature. It still releases
the locks, but the filesystem itself can take care of the ugly
business and let the user just do what it needs.

The tracing system now attaches a descriptor to the directory dentry
that can have userspace create or remove sub directories. If this
descriptor does not exist for a dentry, then that dentry can not be
used to create other directories. This descriptor holds a mkdir and
rmdir method that only takes a character string as an argument.

The tracefs file system will first make a copy of the dentry name
before releasing the locks. Then it will pass the copied name to the
methods. It is up to the tracing system that supplied the methods to
handle races with duplicate names and such as all the inode mutexes
would be released when the functions are called.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/tracefs/inode.c      | 93 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/tracefs.h |  7 ++++
 kernel/trace/trace.c    | 68 +++---------------------------------
 3 files changed, 103 insertions(+), 65 deletions(-)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index cdbaa42b44a1..a005b951fd85 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -50,6 +50,87 @@ static const struct file_operations tracefs_file_operations = {
 	.llseek =	noop_llseek,
 };
 
+static char *get_dname(struct dentry *dentry)
+{
+	const char *dname;
+	char *name;
+	int len = dentry->d_name.len;
+
+	dname = dentry->d_name.name;
+	name = kmalloc(len + 1, GFP_KERNEL);
+	if (!name)
+		return NULL;
+	memcpy(name, dname, len);
+	name[len] = 0;
+	return name;
+}
+
+static int tracefs_syscall_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode)
+{
+	const struct tracefs_dir_ops *ops = inode ? inode->i_private : NULL;
+	char *name;
+	int ret;
+
+	if (!ops)
+		return -EPERM;
+
+	name = get_dname(dentry);
+	if (!name)
+		return -ENOMEM;
+
+	/*
+	 * The mkdir call can call the generic functions that create
+	 * the files within the tracefs system. It is up to the individual
+	 * mkdir routine to handle races.
+	 */
+	mutex_unlock(&inode->i_mutex);
+	ret = ops->mkdir(name);
+	mutex_lock(&inode->i_mutex);
+
+	kfree(name);
+
+	return ret;
+}
+
+static int tracefs_syscall_rmdir(struct inode *inode, struct dentry *dentry)
+{
+	const struct tracefs_dir_ops *ops = inode->i_private;
+	char *name;
+	int ret;
+
+	if (!ops)
+		return -EPERM;
+
+	name = get_dname(dentry);
+	if (!name)
+		return -ENOMEM;
+
+	/*
+	 * The rmdir call can call the generic functions that create
+	 * the files within the tracefs system. It is up to the individual
+	 * rmdir routine to handle races.
+	 * This time we need to unlock not only the parent (inode) but
+	 * also the directory that is being deleted.
+	 */
+	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&dentry->d_inode->i_mutex);
+
+	ret = ops->rmdir(name);
+
+	mutex_lock_nested(&inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock(&dentry->d_inode->i_mutex);
+
+	kfree(name);
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
 
@@ -69,7 +150,7 @@ static struct inode *tracefs_get_inode(struct super_block *sb, umode_t mode, dev
 			inode->i_private = data;
 			break;
 		case S_IFDIR:
-			inode->i_op = &simple_dir_inode_operations;
+			inode->i_op = &tracefs_dir_inode_operations;
 			inode->i_fop = &simple_dir_operations;
 
 			/* directory inodes start off with i_nlink == 2
@@ -125,6 +206,16 @@ static int tracefs_create(struct inode *dir, struct dentry *dentry, umode_t mode
 	return res;
 }
 
+void tracefs_add_dir_ops(struct dentry *dentry, const struct tracefs_dir_ops *ops)
+{
+	struct inode *inode = dentry->d_inode;
+
+	if (!inode)
+		return;
+
+	inode->i_private = (void *)ops;
+}
+
 struct tracefs_mount_opts {
 	kuid_t uid;
 	kgid_t gid;
diff --git a/include/linux/tracefs.h b/include/linux/tracefs.h
index 23e04ce21749..d142b1f9d453 100644
--- a/include/linux/tracefs.h
+++ b/include/linux/tracefs.h
@@ -34,6 +34,13 @@ struct dentry *tracefs_create_dir(const char *name, struct dentry *parent);
 void tracefs_remove(struct dentry *dentry);
 void tracefs_remove_recursive(struct dentry *dentry);
 
+struct tracefs_dir_ops {
+	int (*mkdir)(const char *name);
+	int (*rmdir)(const char *name);
+};
+
+void tracefs_add_dir_ops(struct dentry *dentry, const struct tracefs_dir_ops *ops);
+
 bool tracefs_initialized(void);
 
 #endif /* CONFIG_TRACING */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4fb557917d39..ce9a331ebc9c 100644
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
+static const struct tracefs_dir_ops instance_dir_ops = {
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


