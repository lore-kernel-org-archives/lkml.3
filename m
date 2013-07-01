Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3GAKBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab3GAJ76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:59:58 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 07/12] GFS2: Add atomic_open support
Date: Mon,  1 Jul 2013 10:33:10 +0100
Message-Id: <1372671195-3472-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've restricted atomic_open to only operate on regular files, although
I still don't understand why atomic_open should not be possible also for
directories on GFS2. That can always be added in later though, if it
makes sense.

The ->atomic_open function can be passed negative dentries, which
in most cases means either ENOENT (->lookup) or a call to d_instantiate
(->create). In the GFS2 case though, we need to actually perform the
look up, since we do not know whether there has been a new inode created
on another node. The look up calls d_splice_alias which then tries to
rehash the dentry - so the solution here is to simply check for that
in d_splice_alias. The same issue is likely to affect any other cluster
filesystem implementing ->atomic_open

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields fieldses org>
Cc: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/dcache.c b/fs/dcache.c
index f09b908..5a23073 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1612,6 +1612,10 @@ EXPORT_SYMBOL(d_obtain_alias);
  * If a dentry was found and moved, then it is returned.  Otherwise NULL
  * is returned.  This matches the expected return value of ->lookup.
  *
+ * Cluster filesystems may call this function with a negative, hashed dentry.
+ * In that case, we know that the inode will be a regular file, and also this
+ * will only occur during atomic_open. So we need to check for the dentry
+ * being already hashed only in the final case.
  */
 struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
 {
@@ -1636,8 +1640,11 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
 			security_d_instantiate(dentry, inode);
 			d_rehash(dentry);
 		}
-	} else
-		d_add(dentry, inode);
+	} else {
+		d_instantiate(dentry, inode);
+		if (d_unhashed(dentry))
+			d_rehash(dentry);
+	}
 	return new;
 }
 EXPORT_SYMBOL(d_splice_alias);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index ad0dc38..4ed6a03 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -538,21 +538,30 @@ static int gfs2_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 /**
- * gfs2_open - open a file
- * @inode: the inode to open
- * @file: the struct file for this opening
+ * gfs2_open_common - This is common to open and atomic_open
+ * @inode: The inode being opened
+ * @file: The file being opened
  *
- * Returns: errno
+ * This maybe called under a glock or not depending upon how it has
+ * been called. We must always be called under a glock for regular
+ * files, however. For other file types, it does not matter whether
+ * we hold the glock or not.
+ *
+ * Returns: Error code or 0 for success
  */
 
-static int gfs2_open(struct inode *inode, struct file *file)
+int gfs2_open_common(struct inode *inode, struct file *file)
 {
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_holder i_gh;
 	struct gfs2_file *fp;
-	int error;
+	int ret;
 
-	fp = kzalloc(sizeof(struct gfs2_file), GFP_KERNEL);
+	if (S_ISREG(inode->i_mode)) {
+		ret = generic_file_open(inode, file);
+		if (ret)
+			return ret;
+	}
+
+	fp = kzalloc(sizeof(struct gfs2_file), GFP_NOFS);
 	if (!fp)
 		return -ENOMEM;
 
@@ -560,29 +569,43 @@ static int gfs2_open(struct inode *inode, struct file *file)
 
 	gfs2_assert_warn(GFS2_SB(inode), !file->private_data);
 	file->private_data = fp;
+	return 0;
+}
+
+/**
+ * gfs2_open - open a file
+ * @inode: the inode to open
+ * @file: the struct file for this opening
+ *
+ * After atomic_open, this function is only used for opening files
+ * which are already cached. We must still get the glock for regular
+ * files to ensure that we have the file size uptodate for the large
+ * file check which is in the common code. That is only an issue for
+ * regular files though.
+ *
+ * Returns: errno
+ */
+
+static int gfs2_open(struct inode *inode, struct file *file)
+{
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_holder i_gh;
+	int error;
+	bool need_unlock = false;
 
 	if (S_ISREG(ip->i_inode.i_mode)) {
 		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY,
 					   &i_gh);
 		if (error)
-			goto fail;
+			return error;
+		need_unlock = true;
+	}
 
-		if (!(file->f_flags & O_LARGEFILE) &&
-		    i_size_read(inode) > MAX_NON_LFS) {
-			error = -EOVERFLOW;
-			goto fail_gunlock;
-		}
+	error = gfs2_open_common(inode, file);
 
+	if (need_unlock)
 		gfs2_glock_dq_uninit(&i_gh);
-	}
-
-	return 0;
 
-fail_gunlock:
-	gfs2_glock_dq_uninit(&i_gh);
-fail:
-	file->private_data = NULL;
-	kfree(fp);
 	return error;
 }
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index ede16ae..bbb2715 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -535,6 +535,7 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
  * gfs2_create_inode - Create a new inode
  * @dir: The parent directory
  * @dentry: The new dentry
+ * @file: If non-NULL, the file which is being opened
  * @mode: The permissions on the new inode
  * @dev: For device nodes, this is the device number
  * @symname: For symlinks, this is the link destination
@@ -544,8 +545,9 @@ static int gfs2_security_init(struct gfs2_inode *dip, struct gfs2_inode *ip,
  */
 
 static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
+			     struct file *file,
 			     umode_t mode, dev_t dev, const char *symname,
-			     unsigned int size, int excl)
+			     unsigned int size, int excl, int *opened)
 {
 	const struct qstr *name = &dentry->d_name;
 	struct gfs2_holder ghs[2];
@@ -553,6 +555,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	struct gfs2_inode *dip = GFS2_I(dir), *ip;
 	struct gfs2_sbd *sdp = GFS2_SB(&dip->i_inode);
 	struct gfs2_glock *io_gl;
+	struct dentry *d;
 	int error;
 	u32 aflags = 0;
 	int arq;
@@ -579,9 +582,20 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	inode = gfs2_dir_search(dir, &dentry->d_name, !S_ISREG(mode) || excl);
 	error = PTR_ERR(inode);
 	if (!IS_ERR(inode)) {
+		d = d_splice_alias(inode, dentry);
+		error = 0;
+		if (file && !IS_ERR(d)) {
+			if (d == NULL)
+				d = dentry;
+			if (S_ISREG(inode->i_mode))
+				error = finish_open(file, d, gfs2_open_common, opened);
+			else
+				error = finish_no_open(file, d);
+		}
 		gfs2_glock_dq_uninit(ghs);
-		d_instantiate(dentry, inode);
-		return 0;
+		if (IS_ERR(d))
+			return PTR_RET(d);
+		return error;
 	} else if (error != -ENOENT) {
 		goto fail_gunlock;
 	}
@@ -679,10 +693,12 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 		goto fail_gunlock3;
 
 	mark_inode_dirty(inode);
+	d_instantiate(dentry, inode);
+	if (file)
+		error = finish_open(file, dentry, gfs2_open_common, opened);
 	gfs2_glock_dq_uninit(ghs);
 	gfs2_glock_dq_uninit(ghs + 1);
-	d_instantiate(dentry, inode);
-	return 0;
+	return error;
 
 fail_gunlock3:
 	gfs2_glock_dq_uninit(ghs + 1);
@@ -722,36 +738,56 @@ fail:
 static int gfs2_create(struct inode *dir, struct dentry *dentry,
 		       umode_t mode, bool excl)
 {
-	return gfs2_create_inode(dir, dentry, S_IFREG | mode, 0, NULL, 0, excl);
+	return gfs2_create_inode(dir, dentry, NULL, S_IFREG | mode, 0, NULL, 0, excl, NULL);
 }
 
 /**
- * gfs2_lookup - Look up a filename in a directory and return its inode
+ * __gfs2_lookup - Look up a filename in a directory and return its inode
  * @dir: The directory inode
  * @dentry: The dentry of the new inode
- * @nd: passed from Linux VFS, ignored by us
+ * @file: File to be opened
+ * @opened: atomic_open flags
  *
- * Called by the VFS layer. Lock dir and call gfs2_lookupi()
  *
  * Returns: errno
  */
 
-static struct dentry *gfs2_lookup(struct inode *dir, struct dentry *dentry,
-				  unsigned int flags)
+static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
+				    struct file *file, int *opened)
 {
-	struct inode *inode = gfs2_lookupi(dir, &dentry->d_name, 0);
-	if (inode && !IS_ERR(inode)) {
-		struct gfs2_glock *gl = GFS2_I(inode)->i_gl;
-		struct gfs2_holder gh;
-		int error;
-		error = gfs2_glock_nq_init(gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
-		if (error) {
-			iput(inode);
-			return ERR_PTR(error);
-		}
-		gfs2_glock_dq_uninit(&gh);
+	struct inode *inode;
+	struct dentry *d;
+	struct gfs2_holder gh;
+	struct gfs2_glock *gl;
+	int error;
+
+	inode = gfs2_lookupi(dir, &dentry->d_name, 0);
+	if (!inode)
+		return NULL;
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	gl = GFS2_I(inode)->i_gl;
+	error = gfs2_glock_nq_init(gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
+	if (error) {
+		iput(inode);
+		return ERR_PTR(error);
 	}
-	return d_splice_alias(inode, dentry);
+
+	d = d_splice_alias(inode, dentry);
+	if (file && S_ISREG(inode->i_mode))
+		error = finish_open(file, dentry, gfs2_open_common, opened);
+
+	gfs2_glock_dq_uninit(&gh);
+	if (error)
+		return ERR_PTR(error);
+	return d;
+}
+
+static struct dentry *gfs2_lookup(struct inode *dir, struct dentry *dentry,
+				  unsigned flags)
+{
+	return __gfs2_lookup(dir, dentry, NULL, NULL);
 }
 
 /**
@@ -1069,7 +1105,7 @@ static int gfs2_symlink(struct inode *dir, struct dentry *dentry,
 	if (size > sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode) - 1)
 		return -ENAMETOOLONG;
 
-	return gfs2_create_inode(dir, dentry, S_IFLNK | S_IRWXUGO, 0, symname, size, 0);
+	return gfs2_create_inode(dir, dentry, NULL, S_IFLNK | S_IRWXUGO, 0, symname, size, 0, NULL);
 }
 
 /**
@@ -1085,7 +1121,7 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(dir);
 	unsigned dsize = sdp->sd_sb.sb_bsize - sizeof(struct gfs2_dinode);
-	return gfs2_create_inode(dir, dentry, S_IFDIR | mode, 0, NULL, dsize, 0);
+	return gfs2_create_inode(dir, dentry, NULL, S_IFDIR | mode, 0, NULL, dsize, 0, NULL);
 }
 
 /**
@@ -1100,7 +1136,43 @@ static int gfs2_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 static int gfs2_mknod(struct inode *dir, struct dentry *dentry, umode_t mode,
 		      dev_t dev)
 {
-	return gfs2_create_inode(dir, dentry, mode, dev, NULL, 0, 0);
+	return gfs2_create_inode(dir, dentry, NULL, mode, dev, NULL, 0, 0, NULL);
+}
+
+/**
+ * gfs2_atomic_open - Atomically open a file
+ * @dir: The directory
+ * @dentry: The proposed new entry
+ * @file: The proposed new struct file
+ * @flags: open flags
+ * @mode: File mode
+ * @opened: Flag to say whether the file has been opened or not
+ *
+ * Returns: error code or 0 for success
+ */
+
+static int gfs2_atomic_open(struct inode *dir, struct dentry *dentry,
+                            struct file *file, unsigned flags,
+                            umode_t mode, int *opened)
+{
+	struct dentry *d;
+	bool excl = !!(flags & O_EXCL);
+
+	d = __gfs2_lookup(dir, dentry, file, opened);
+	if (IS_ERR(d))
+		return PTR_ERR(d);
+	if (d == NULL)
+		d = dentry;
+	if (d->d_inode) {
+		if (!(*opened & FILE_OPENED))
+			return finish_no_open(file, d);
+		return 0;
+	}
+
+	if (!(flags & O_CREAT))
+		return -ENOENT;
+
+	return gfs2_create_inode(dir, dentry, file, S_IFREG | mode, 0, NULL, 0, excl, opened);
 }
 
 /*
@@ -1780,6 +1852,7 @@ const struct inode_operations gfs2_dir_iops = {
 	.removexattr = gfs2_removexattr,
 	.fiemap = gfs2_fiemap,
 	.get_acl = gfs2_get_acl,
+	.atomic_open = gfs2_atomic_open,
 };
 
 const struct inode_operations gfs2_symlink_iops = {
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index c53c747..ba4d949 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -109,6 +109,7 @@ extern int gfs2_permission(struct inode *inode, int mask);
 extern int gfs2_setattr_simple(struct inode *inode, struct iattr *attr);
 extern struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
 extern void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
+extern int gfs2_open_common(struct inode *inode, struct file *file);
 
 extern const struct inode_operations gfs2_file_iops;
 extern const struct inode_operations gfs2_dir_iops;
-- 
1.7.4

