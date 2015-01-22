Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbbAVFAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:00:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbbAVFAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:00:09 -0500
Subject: [PATCH v2 2/5] fs: create proper filename objects using
 getname_kernel()
From: Paul Moore <pmoore@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com
Cc: rgb@redhat.com, sd@queasysnail.net, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, viro@zeniv.linux.org.uk
Date: Thu, 22 Jan 2015 00:00:03 -0500
Message-ID: <20150122050003.1347.4833.stgit@localhost>
In-Reply-To: <20150122045303.1347.98054.stgit@localhost>
References: <20150122045303.1347.98054.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several areas in the kernel that create temporary filename
objects using the following pattern:

	int func(const char *name)
	{
		struct filename *file = { .name = name };
		...
		return 0;
	}

... which for the most part works okay, but it causes havoc within the
audit subsystem as the filename object does not persist beyond the
lifetime of the function.  This patch converts all of these temporary
filename objects into proper filename objects using getname_kernel()
and putname() which ensure that the filename object persists until the
audit subsystem is finished with it.

Also, a special thanks to Al Viro, Guenter Roeck, and Sabrina Dubroca
for helping resolve a difficult kernel panic on boot related to a
use-after-free problem in kern_path_create(); the thread can be seen
at the link below:

 * https://lkml.org/lkml/2015/1/20/710

This patch includes code that was either based on, or directly written
by Al in the above thread.

CC: viro@zeniv.linux.org.uk
CC: linux@roeck-us.net
CC: sd@queasysnail.net
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Paul Moore <pmoore@redhat.com>
---
 fs/exec.c  |   11 +++++++-
 fs/namei.c |   80 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 fs/open.c  |   11 +++++++-
 3 files changed, 81 insertions(+), 21 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index a3d33fe..d067771 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -789,8 +789,15 @@ exit:
 
 struct file *open_exec(const char *name)
 {
-	struct filename tmp = { .name = name };
-	return do_open_exec(&tmp);
+	struct file *file;
+	struct filename *tmp;
+
+	tmp = getname_kernel(name);
+	if (unlikely(IS_ERR(tmp)))
+		return (void *)tmp;
+	file = do_open_exec(tmp);
+	putname(tmp);
+	return file;
 }
 EXPORT_SYMBOL(open_exec);
 
diff --git a/fs/namei.c b/fs/namei.c
index 63eaaf6..f793fe4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2001,31 +2001,50 @@ static int filename_lookup(int dfd, struct filename *name,
 static int do_path_lookup(int dfd, const char *name,
 				unsigned int flags, struct nameidata *nd)
 {
-	struct filename filename = { .name = name };
+	int retval;
+	struct filename *filename;
 
-	return filename_lookup(dfd, &filename, flags, nd);
+	filename = getname_kernel(name);
+	if (unlikely(IS_ERR(filename)))
+		return PTR_ERR(filename);
+	retval = filename_lookup(dfd, filename, flags, nd);
+	putname(filename);
+	return retval;
 }
 
 /* does lookup, returns the object with parent locked */
 struct dentry *kern_path_locked(const char *name, struct path *path)
 {
+	struct filename *filename;
 	struct nameidata nd;
 	struct dentry *d;
-	int err = do_path_lookup(AT_FDCWD, name, LOOKUP_PARENT, &nd);
-	if (err)
-		return ERR_PTR(err);
+	int err;
+
+	filename = getname_kernel(name);
+	if (IS_ERR(filename))
+		return ERR_CAST(filename);
+
+	err = filename_lookup(AT_FDCWD, filename, LOOKUP_PARENT, &nd);
+	if (err) {
+		d = ERR_PTR(err);
+		goto out;
+	}
 	if (nd.last_type != LAST_NORM) {
 		path_put(&nd.path);
-		return ERR_PTR(-EINVAL);
+		d = ERR_PTR(-EINVAL);
+		goto out;
 	}
 	mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
 	d = __lookup_hash(&nd.last, nd.path.dentry, 0);
 	if (IS_ERR(d)) {
 		mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
 		path_put(&nd.path);
-		return d;
+		goto out;
 	}
 	*path = nd.path;
+
+out:
+	putname(filename);
 	return d;
 }
 
@@ -2368,8 +2387,15 @@ int
 kern_path_mountpoint(int dfd, const char *name, struct path *path,
 			unsigned int flags)
 {
-	struct filename s = {.name = name};
-	return filename_mountpoint(dfd, &s, path, flags);
+	int retval;
+	struct filename *s;
+
+	s = getname_kernel(name);
+	if (unlikely(IS_ERR(s)))
+		return PTR_ERR(s);
+	retval = filename_mountpoint(dfd, s, path, flags);
+	putname(s);
+	return retval;
 }
 EXPORT_SYMBOL(kern_path_mountpoint);
 
@@ -3259,7 +3285,7 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 {
 	struct nameidata nd;
 	struct file *file;
-	struct filename filename = { .name = name };
+	struct filename *filename;
 	int flags = op->lookup_flags | LOOKUP_ROOT;
 
 	nd.root.mnt = mnt;
@@ -3268,16 +3294,22 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	if (d_is_symlink(dentry) && op->intent & LOOKUP_OPEN)
 		return ERR_PTR(-ELOOP);
 
-	file = path_openat(-1, &filename, &nd, op, flags | LOOKUP_RCU);
+	filename = getname_kernel(name);
+	if (unlikely(IS_ERR(filename)))
+		return ERR_CAST(filename);
+
+	file = path_openat(-1, filename, &nd, op, flags | LOOKUP_RCU);
 	if (unlikely(file == ERR_PTR(-ECHILD)))
-		file = path_openat(-1, &filename, &nd, op, flags);
+		file = path_openat(-1, filename, &nd, op, flags);
 	if (unlikely(file == ERR_PTR(-ESTALE)))
-		file = path_openat(-1, &filename, &nd, op, flags | LOOKUP_REVAL);
+		file = path_openat(-1, filename, &nd, op, flags | LOOKUP_REVAL);
+	putname(filename);
 	return file;
 }
 
-struct dentry *kern_path_create(int dfd, const char *pathname,
-				struct path *path, unsigned int lookup_flags)
+static struct dentry *filename_create(int dfd, struct filename *name,
+				      struct path *path,
+				      unsigned int lookup_flags)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
 	struct nameidata nd;
@@ -3291,7 +3323,7 @@ struct dentry *kern_path_create(int dfd, const char *pathname,
 	 */
 	lookup_flags &= LOOKUP_REVAL;
 
-	error = do_path_lookup(dfd, pathname, LOOKUP_PARENT|lookup_flags, &nd);
+	error = filename_lookup(dfd, name, LOOKUP_PARENT|lookup_flags, &nd);
 	if (error)
 		return ERR_PTR(error);
 
@@ -3345,6 +3377,20 @@ out:
 	path_put(&nd.path);
 	return dentry;
 }
+
+struct dentry *kern_path_create(int dfd, const char *pathname,
+				struct path *path, unsigned int lookup_flags)
+{
+	struct filename *filename;
+	struct dentry *res;
+
+	filename = getname_kernel(pathname);
+	if (IS_ERR(filename))
+		return ERR_CAST(filename);
+	res = filename_create(dfd, filename, path, lookup_flags);
+	putname(filename);
+	return res;
+}
 EXPORT_SYMBOL(kern_path_create);
 
 void done_path_create(struct path *path, struct dentry *dentry)
@@ -3363,7 +3409,7 @@ struct dentry *user_path_create(int dfd, const char __user *pathname,
 	struct dentry *res;
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
-	res = kern_path_create(dfd, tmp->name, path, lookup_flags);
+	res = filename_create(dfd, tmp, path, lookup_flags);
 	putname(tmp);
 	return res;
 }
diff --git a/fs/open.c b/fs/open.c
index d6fd3ac..33839e1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -940,8 +940,15 @@ struct file *file_open_name(struct filename *name, int flags, umode_t mode)
  */
 struct file *filp_open(const char *filename, int flags, umode_t mode)
 {
-	struct filename name = {.name = filename};
-	return file_open_name(&name, flags, mode);
+	struct file *file;
+	struct filename *name;
+
+	name = getname_kernel(filename);
+	if (unlikely(IS_ERR(name)))
+		return ERR_CAST(name);
+	file = file_open_name(name, flags, mode);
+	putname(name);
+	return file;
 }
 EXPORT_SYMBOL(filp_open);
 

