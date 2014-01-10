Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbaAJMpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 07:45:19 -0500
Received: from nautica.notk.org ([91.121.71.147]:54954 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbaAJMoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 07:44:46 -0500
From: Dominique Martinet <dominique.martinet@cea.fr>
To: Eric Van Hensbergen <ericvh@gmail.com>,
        v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dominique Martinet <dominique.martinet@cea.fr>
Subject: [PATCH RESEND] 9P: introduction of a new cache=mmap model.
Date: Fri, 10 Jan 2014 13:44:09 +0100
Message-Id: <1389357849-20367-1-git-send-email-dominique.martinet@cea.fr>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - Add cache=mmap option
 - Make mmap read-write while keeping it as synchronous as possible
 - Build writeback fid on mmap creation if it is writable

Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
---

The patch has been taken into next-20131105 (commit 94876b5) but has
apparently been dropped because of a conflict?
Anyway, this is the very same patch as last time with the conflict solved
(conflicting patch was ceaec15d4
"9p: make v9fs_cache_inode_{get,put,set}_cookie empty inlines for !9P_CACHEFS")

The patch applies on linus' master, next's master, and has been retested
on top of 3.13.0-rc7.

Sorry if I was supposed to drop Eric's sign-off due to the minor edit!


 fs/9p/v9fs.c           |   9 +++-
 fs/9p/v9fs.h           |   1 +
 fs/9p/v9fs_vfs.h       |   2 +
 fs/9p/vfs_addr.c       |   7 +++
 fs/9p/vfs_file.c       | 140 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/9p/vfs_inode.c      |  22 +++++---
 fs/9p/vfs_inode_dotl.c |   9 ++--
 fs/9p/vfs_super.c      |   8 +--
 8 files changed, 179 insertions(+), 19 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 08f2e1e..14da825 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -56,7 +56,7 @@ enum {
 	/* Options that take no arguments */
 	Opt_nodevmap,
 	/* Cache options */
-	Opt_cache_loose, Opt_fscache,
+	Opt_cache_loose, Opt_fscache, Opt_mmap,
 	/* Access options */
 	Opt_access, Opt_posixacl,
 	/* Error token */
@@ -74,6 +74,7 @@ static const match_table_t tokens = {
 	{Opt_cache, "cache=%s"},
 	{Opt_cache_loose, "loose"},
 	{Opt_fscache, "fscache"},
+	{Opt_mmap, "mmap"},
 	{Opt_cachetag, "cachetag=%s"},
 	{Opt_access, "access=%s"},
 	{Opt_posixacl, "posixacl"},
@@ -91,6 +92,9 @@ static int get_cache_mode(char *s)
 	} else if (!strcmp(s, "fscache")) {
 		version = CACHE_FSCACHE;
 		p9_debug(P9_DEBUG_9P, "Cache mode: fscache\n");
+	} else if (!strcmp(s, "mmap")) {
+		version = CACHE_MMAP;
+		p9_debug(P9_DEBUG_9P, "Cache mode: mmap\n");
 	} else if (!strcmp(s, "none")) {
 		version = CACHE_NONE;
 		p9_debug(P9_DEBUG_9P, "Cache mode: none\n");
@@ -220,6 +224,9 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 		case Opt_fscache:
 			v9ses->cache = CACHE_FSCACHE;
 			break;
+		case Opt_mmap:
+			v9ses->cache = CACHE_MMAP;
+			break;
 		case Opt_cachetag:
 #ifdef CONFIG_9P_FSCACHE
 			v9ses->cachetag = match_strdup(&args[0]);
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index a8e127c..099c771 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -64,6 +64,7 @@ enum p9_session_flags {
 
 enum p9_cache_modes {
 	CACHE_NONE,
+	CACHE_MMAP,
 	CACHE_LOOSE,
 	CACHE_FSCACHE,
 };
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index dc95a25..b83ebfb 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -50,6 +50,8 @@ extern const struct dentry_operations v9fs_dentry_operations;
 extern const struct dentry_operations v9fs_cached_dentry_operations;
 extern const struct file_operations v9fs_cached_file_operations;
 extern const struct file_operations v9fs_cached_file_operations_dotl;
+extern const struct file_operations v9fs_mmap_file_operations;
+extern const struct file_operations v9fs_mmap_file_operations_dotl;
 extern struct kmem_cache *v9fs_inode_cache;
 
 struct inode *v9fs_alloc_inode(struct super_block *sb);
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 9ff073f..c71e886 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -202,6 +202,8 @@ static int v9fs_vfs_writepage(struct page *page, struct writeback_control *wbc)
 {
 	int retval;
 
+	p9_debug(P9_DEBUG_VFS, "page %p\n", page);
+
 	retval = v9fs_vfs_writepage_locked(page);
 	if (retval < 0) {
 		if (retval == -EAGAIN) {
@@ -282,6 +284,9 @@ static int v9fs_write_begin(struct file *filp, struct address_space *mapping,
 	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
 	struct inode *inode = mapping->host;
 
+
+	p9_debug(P9_DEBUG_VFS, "filp %p, mapping %p\n", filp, mapping);
+
 	v9inode = V9FS_I(inode);
 start:
 	page = grab_cache_page_write_begin(mapping, index, flags);
@@ -312,6 +317,8 @@ static int v9fs_write_end(struct file *filp, struct address_space *mapping,
 	loff_t last_pos = pos + copied;
 	struct inode *inode = page->mapping->host;
 
+	p9_debug(P9_DEBUG_VFS, "filp %p, mapping %p\n", filp, mapping);
+
 	if (unlikely(copied < len)) {
 		/*
 		 * zero out the rest of the area
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 27782bb..9bc7ad9 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -45,6 +45,7 @@
 #include "cache.h"
 
 static const struct vm_operations_struct v9fs_file_vm_ops;
+static const struct vm_operations_struct v9fs_mmap_file_vm_ops;
 
 /**
  * v9fs_file_open - open a file (or directory)
@@ -87,7 +88,8 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 
 	file->private_data = fid;
 	mutex_lock(&v9inode->v_mutex);
-	if (v9ses->cache && !v9inode->writeback_fid &&
+	if ((v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) &&
+	    !v9inode->writeback_fid &&
 	    ((file->f_flags & O_ACCMODE) != O_RDONLY)) {
 		/*
 		 * clone a fid and add it to writeback_fid
@@ -105,7 +107,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 		v9inode->writeback_fid = (void *) fid;
 	}
 	mutex_unlock(&v9inode->v_mutex);
-	if (v9ses->cache)
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
 		v9fs_cache_inode_set_cookie(inode, file);
 	return 0;
 out_error:
@@ -579,11 +581,12 @@ int v9fs_file_fsync_dotl(struct file *filp, loff_t start, loff_t end,
 }
 
 static int
-v9fs_file_mmap(struct file *file, struct vm_area_struct *vma)
+v9fs_file_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	int retval;
 
-	retval = generic_file_mmap(file, vma);
+
+	retval = generic_file_mmap(filp, vma);
 	if (!retval)
 		vma->vm_ops = &v9fs_file_vm_ops;
 
@@ -591,6 +594,43 @@ v9fs_file_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 static int
+v9fs_mmap_file_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	int retval;
+	struct inode *inode;
+	struct v9fs_inode *v9inode;
+	struct p9_fid *fid;
+
+	inode = file_inode(filp);
+	v9inode = V9FS_I(inode);
+	mutex_lock(&v9inode->v_mutex);
+	if (!v9inode->writeback_fid &&
+	    (vma->vm_flags & VM_WRITE)) {
+		/*
+		 * clone a fid and add it to writeback_fid
+		 * we do it during mmap instead of
+		 * page dirty time via write_begin/page_mkwrite
+		 * because we want write after unlink usecase
+		 * to work.
+		 */
+		fid = v9fs_writeback_fid(filp->f_path.dentry);
+		if (IS_ERR(fid)) {
+			retval = PTR_ERR(fid);
+			mutex_unlock(&v9inode->v_mutex);
+			return retval;
+		}
+		v9inode->writeback_fid = (void *) fid;
+	}
+	mutex_unlock(&v9inode->v_mutex);
+
+	retval = generic_file_mmap(filp, vma);
+	if (!retval)
+		vma->vm_ops = &v9fs_mmap_file_vm_ops;
+
+	return retval;
+}
+
+static int
 v9fs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct v9fs_inode *v9inode;
@@ -658,6 +698,22 @@ v9fs_cached_file_read(struct file *filp, char __user *data, size_t count,
 	return do_sync_read(filp, data, count, offset);
 }
 
+/**
+ * v9fs_mmap_file_read - read from a file
+ * @filp: file pointer to read
+ * @udata: user data buffer to read data into
+ * @count: size of buffer
+ * @offset: offset at which to read data
+ *
+ */
+static ssize_t
+v9fs_mmap_file_read(struct file *filp, char __user *data, size_t count,
+		      loff_t *offset)
+{
+	/* TODO: Check if there are dirty pages */
+	return v9fs_file_read(filp, data, count, offset);
+}
+
 static ssize_t
 v9fs_direct_write(struct file *filp, const char __user * data,
 		  size_t count, loff_t *offsetp)
@@ -728,12 +784,65 @@ v9fs_cached_file_write(struct file *filp, const char __user * data,
 	return do_sync_write(filp, data, count, offset);
 }
 
+
+/**
+ * v9fs_mmap_file_write - write to a file
+ * @filp: file pointer to write
+ * @data: data buffer to write data from
+ * @count: size of buffer
+ * @offset: offset at which to write data
+ *
+ */
+static ssize_t
+v9fs_mmap_file_write(struct file *filp, const char __user *data,
+		       size_t count, loff_t *offset)
+{
+	/*
+	 * TODO: invalidate mmaps on filp's inode between
+	 * offset and offset+count
+	 */
+	return v9fs_file_write(filp, data, count, offset);
+}
+
+static void v9fs_mmap_vm_close(struct vm_area_struct *vma)
+{
+	struct inode *inode;
+
+	struct writeback_control wbc = {
+		.nr_to_write = LONG_MAX,
+		.sync_mode = WB_SYNC_ALL,
+		.range_start = vma->vm_pgoff * PAGE_SIZE,
+		 /* absolute end, byte at end included */
+		.range_end = vma->vm_pgoff * PAGE_SIZE +
+			(vma->vm_end - vma->vm_start - 1),
+	};
+
+
+	p9_debug(P9_DEBUG_VFS, "9p VMA close, %p, flushing", vma);
+
+	inode = file_inode(vma->vm_file);
+
+	if (!mapping_cap_writeback_dirty(inode->i_mapping))
+		wbc.nr_to_write = 0;
+
+	might_sleep();
+	sync_inode(inode, &wbc);
+}
+
+
 static const struct vm_operations_struct v9fs_file_vm_ops = {
 	.fault = filemap_fault,
 	.page_mkwrite = v9fs_vm_page_mkwrite,
 	.remap_pages = generic_file_remap_pages,
 };
 
+static const struct vm_operations_struct v9fs_mmap_file_vm_ops = {
+	.close = v9fs_mmap_vm_close,
+	.fault = filemap_fault,
+	.page_mkwrite = v9fs_vm_page_mkwrite,
+	.remap_pages = generic_file_remap_pages,
+};
+
 
 const struct file_operations v9fs_cached_file_operations = {
 	.llseek = generic_file_llseek,
@@ -784,3 +893,26 @@ const struct file_operations v9fs_file_operations_dotl = {
 	.mmap = generic_file_readonly_mmap,
 	.fsync = v9fs_file_fsync_dotl,
 };
+
+const struct file_operations v9fs_mmap_file_operations = {
+	.llseek = generic_file_llseek,
+	.read = v9fs_mmap_file_read,
+	.write = v9fs_mmap_file_write,
+	.open = v9fs_file_open,
+	.release = v9fs_dir_release,
+	.lock = v9fs_file_lock,
+	.mmap = v9fs_mmap_file_mmap,
+	.fsync = v9fs_file_fsync,
+};
+
+const struct file_operations v9fs_mmap_file_operations_dotl = {
+	.llseek = generic_file_llseek,
+	.read = v9fs_mmap_file_read,
+	.write = v9fs_mmap_file_write,
+	.open = v9fs_file_open,
+	.release = v9fs_dir_release,
+	.lock = v9fs_file_lock_dotl,
+	.flock = v9fs_file_flock_dotl,
+	.mmap = v9fs_mmap_file_mmap,
+	.fsync = v9fs_file_fsync_dotl,
+};
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index af7d531..bb7991c 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -299,15 +299,22 @@ int v9fs_init_inode(struct v9fs_session_info *v9ses,
 	case S_IFREG:
 		if (v9fs_proto_dotl(v9ses)) {
 			inode->i_op = &v9fs_file_inode_operations_dotl;
-			if (v9ses->cache)
+			if (v9ses->cache == CACHE_LOOSE ||
+			    v9ses->cache == CACHE_FSCACHE)
 				inode->i_fop =
 					&v9fs_cached_file_operations_dotl;
+			else if (v9ses->cache == CACHE_MMAP)
+				inode->i_fop = &v9fs_mmap_file_operations_dotl;
 			else
 				inode->i_fop = &v9fs_file_operations_dotl;
 		} else {
 			inode->i_op = &v9fs_file_inode_operations;
-			if (v9ses->cache)
-				inode->i_fop = &v9fs_cached_file_operations;
+			if (v9ses->cache == CACHE_LOOSE ||
+			    v9ses->cache == CACHE_FSCACHE)
+				inode->i_fop =
+					&v9fs_cached_file_operations;
+			else if (v9ses->cache == CACHE_MMAP)
+				inode->i_fop = &v9fs_mmap_file_operations;
 			else
 				inode->i_fop = &v9fs_file_operations;
 		}
@@ -810,7 +817,7 @@ struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 	 * unlink. For cached mode create calls request for new
 	 * inode. But with cache disabled, lookup should do this.
 	 */
-	if (v9ses->cache)
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
 		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
 	else
 		inode = v9fs_get_new_inode_from_fid(v9ses, fid, dir->i_sb);
@@ -876,7 +883,8 @@ v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
 	v9fs_invalidate_inode_attr(dir);
 	v9inode = V9FS_I(dentry->d_inode);
 	mutex_lock(&v9inode->v_mutex);
-	if (v9ses->cache && !v9inode->writeback_fid &&
+	if ((v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) &&
+	    !v9inode->writeback_fid &&
 	    ((flags & O_ACCMODE) != O_RDONLY)) {
 		/*
 		 * clone a fid and add it to writeback_fid
@@ -899,7 +907,7 @@ v9fs_vfs_atomic_open(struct inode *dir, struct dentry *dentry,
 		goto error;
 
 	file->private_data = fid;
-	if (v9ses->cache)
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
 		v9fs_cache_inode_set_cookie(dentry->d_inode, file);
 
 	*opened |= FILE_CREATED;
@@ -1477,7 +1485,7 @@ int v9fs_refresh_inode(struct p9_fid *fid, struct inode *inode)
 	 */
 	i_size = inode->i_size;
 	v9fs_stat2inode(st, inode, inode->i_sb);
-	if (v9ses->cache)
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
 		inode->i_size = i_size;
 	spin_unlock(&inode->i_lock);
 out:
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 9801306..59dc8e8 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -330,7 +330,8 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 
 	v9inode = V9FS_I(inode);
 	mutex_lock(&v9inode->v_mutex);
-	if (v9ses->cache && !v9inode->writeback_fid &&
+	if ((v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) &&
+	    !v9inode->writeback_fid &&
 	    ((flags & O_ACCMODE) != O_RDONLY)) {
 		/*
 		 * clone a fid and add it to writeback_fid
@@ -353,7 +354,7 @@ v9fs_vfs_atomic_open_dotl(struct inode *dir, struct dentry *dentry,
 	if (err)
 		goto err_clunk_old_fid;
 	file->private_data = ofid;
-	if (v9ses->cache)
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
 		v9fs_cache_inode_set_cookie(inode, file);
 	*opened |= FILE_CREATED;
 out:
@@ -710,7 +711,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 	}
 
 	v9fs_invalidate_inode_attr(dir);
-	if (v9ses->cache) {
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE) {
 		/* Now walk from the parent so we can get an unopened fid. */
 		fid = p9_client_walk(dfid, 1, &name, 1);
 		if (IS_ERR(fid)) {
@@ -965,7 +966,7 @@ int v9fs_refresh_inode_dotl(struct p9_fid *fid, struct inode *inode)
 	 */
 	i_size = inode->i_size;
 	v9fs_stat2inode_dotl(st, inode);
-	if (v9ses->cache)
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
 		inode->i_size = i_size;
 	spin_unlock(&inode->i_lock);
 out:
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 2756dcd..0afd038 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -144,7 +144,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 	}
 	v9fs_fill_super(sb, v9ses, flags, data);
 
-	if (v9ses->cache)
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
 		sb->s_d_op = &v9fs_cached_dentry_operations;
 	else
 		sb->s_d_op = &v9fs_dentry_operations;
@@ -282,7 +282,7 @@ static int v9fs_drop_inode(struct inode *inode)
 {
 	struct v9fs_session_info *v9ses;
 	v9ses = v9fs_inode2v9ses(inode);
-	if (v9ses->cache)
+	if (v9ses->cache == CACHE_LOOSE || v9ses->cache == CACHE_FSCACHE)
 		return generic_drop_inode(inode);
 	/*
 	 * in case of non cached mode always drop the
@@ -325,10 +325,12 @@ static int v9fs_write_inode_dotl(struct inode *inode,
 	 * send an fsync request to server irrespective of
 	 * wbc->sync_mode.
 	 */
-	p9_debug(P9_DEBUG_VFS, "%s: inode %p\n", __func__, inode);
 	v9inode = V9FS_I(inode);
+	p9_debug(P9_DEBUG_VFS, "%s: inode %p, writeback_fid %p\n",
+		 __func__, inode, v9inode->writeback_fid);
 	if (!v9inode->writeback_fid)
 		return 0;
+
 	ret = p9_client_fsync(v9inode->writeback_fid, 0);
 	if (ret < 0) {
 		__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
-- 
1.8.1.4

