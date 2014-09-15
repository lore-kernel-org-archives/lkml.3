Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbaIOUU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:20:28 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:63789 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070AbaIOUUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:20:23 -0400
Date: Mon, 15 Sep 2014 16:20:17 -0400
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/7] Prepare for adding a new readv/writev with user flags.
Message-ID: <e434e839351324641e10cc0a309a5c5f86e196c5.1410810247.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1410810247.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Plumbing the flags argument through the vfs code so they can be passed down to
__generic_file_(read/write)_iter function that do the acctual work.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 drivers/target/target_core_file.c |    6 +++---
 fs/afs/internal.h                 |    2 +-
 fs/afs/write.c                    |    4 ++--
 fs/aio.c                          |    4 ++--
 fs/block_dev.c                    |    9 +++++----
 fs/btrfs/file.c                   |    2 +-
 fs/ceph/file.c                    |    8 +++++---
 fs/cifs/cifsfs.c                  |    9 +++++----
 fs/cifs/cifsfs.h                  |   12 ++++++++----
 fs/cifs/file.c                    |   24 ++++++++++++------------
 fs/ecryptfs/file.c                |    4 ++--
 fs/ext4/file.c                    |    4 ++--
 fs/fuse/file.c                    |   10 ++++++----
 fs/gfs2/file.c                    |    5 +++--
 fs/nfs/file.c                     |    8 ++++----
 fs/nfs/internal.h                 |    4 ++--
 fs/nfsd/vfs.c                     |    4 ++--
 fs/ocfs2/file.c                   |    7 ++++---
 fs/pipe.c                         |    4 ++--
 fs/read_write.c                   |   35 +++++++++++++++++++----------------
 fs/splice.c                       |    4 ++--
 fs/ubifs/file.c                   |    5 +++--
 fs/udf/file.c                     |    5 +++--
 fs/xfs/xfs_file.c                 |    8 +++++---
 include/linux/fs.h                |   16 ++++++++--------
 mm/filemap.c                      |   13 +++++++------
 mm/shmem.c                        |    2 +-
 27 files changed, 119 insertions(+), 99 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 7d6cdda..58d9a6d 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -350,9 +350,9 @@ static int fd_do_rw(struct se_cmd *cmd, struct scatterlist *sgl,
 	set_fs(get_ds());
 
 	if (is_write)
-		ret = vfs_writev(fd, &iov[0], sgl_nents, &pos);
+		ret = vfs_writev(fd, &iov[0], sgl_nents, &pos, 0);
 	else
-		ret = vfs_readv(fd, &iov[0], sgl_nents, &pos);
+		ret = vfs_readv(fd, &iov[0], sgl_nents, &pos, 0);
 
 	set_fs(old_fs);
 
@@ -528,7 +528,7 @@ fd_execute_write_same(struct se_cmd *cmd)
 
 	old_fs = get_fs();
 	set_fs(get_ds());
-	rc = vfs_writev(f, &iov[0], iov_num, &pos);
+	rc = vfs_writev(f, &iov[0], iov_num, &pos, 0);
 	set_fs(old_fs);
 
 	vfree(iov);
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 71d5982..50bf5cd 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -747,7 +747,7 @@ extern int afs_write_end(struct file *file, struct address_space *mapping,
 extern int afs_writepage(struct page *, struct writeback_control *);
 extern int afs_writepages(struct address_space *, struct writeback_control *);
 extern void afs_pages_written_back(struct afs_vnode *, struct afs_call *);
-extern ssize_t afs_file_write(struct kiocb *, struct iov_iter *);
+extern ssize_t afs_file_write(struct kiocb *, struct iov_iter *, int flags);
 extern int afs_writeback_all(struct afs_vnode *);
 extern int afs_fsync(struct file *, loff_t, loff_t, int);
 
diff --git a/fs/afs/write.c b/fs/afs/write.c
index ab6adfd..7330860 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -625,7 +625,7 @@ void afs_pages_written_back(struct afs_vnode *vnode, struct afs_call *call)
 /*
  * write to an AFS file
  */
-ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *from)
+ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *from, int flags)
 {
 	struct afs_vnode *vnode = AFS_FS_I(file_inode(iocb->ki_filp));
 	ssize_t result;
@@ -643,7 +643,7 @@ ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	if (!count)
 		return 0;
 
-	result = generic_file_write_iter(iocb, from);
+	result = generic_file_write_iter(iocb, from, flags);
 	if (IS_ERR_VALUE(result)) {
 		_leave(" = %zd", result);
 		return result;
diff --git a/fs/aio.c b/fs/aio.c
index 7337500..c17227f 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1309,7 +1309,7 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 
 typedef ssize_t (aio_rw_op)(struct kiocb *, const struct iovec *,
 			    unsigned long, loff_t);
-typedef ssize_t (rw_iter_op)(struct kiocb *, struct iov_iter *);
+typedef ssize_t (rw_iter_op)(struct kiocb *, struct iov_iter *, int flags);
 
 static ssize_t aio_setup_vectored_rw(struct kiocb *kiocb,
 				     int rw, char __user *buf,
@@ -1421,7 +1421,7 @@ rw_common:
 
 		if (iter_op) {
 			iov_iter_init(&iter, rw, iovec, nr_segs, req->ki_nbytes);
-			ret = iter_op(req, &iter);
+			ret = iter_op(req, &iter, 0);
 		} else {
 			ret = rw_op(req, iovec, nr_segs, req->ki_pos);
 		}
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6d72746..04b203b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1572,14 +1572,14 @@ static long block_ioctl(struct file *file, unsigned cmd, unsigned long arg)
  * Does not take i_mutex for the write and thus is not for general purpose
  * use.
  */
-ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
+ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from, int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct blk_plug plug;
 	ssize_t ret;
 
 	blk_start_plug(&plug);
-	ret = __generic_file_write_iter(iocb, from);
+	ret = __generic_file_write_iter(iocb, from, flags);
 	if (ret > 0) {
 		ssize_t err;
 		err = generic_write_sync(file, iocb->ki_pos - ret, ret);
@@ -1591,7 +1591,8 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 }
 EXPORT_SYMBOL_GPL(blkdev_write_iter);
 
-static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
+static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to,
+			        int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *bd_inode = file->f_mapping->host;
@@ -1603,7 +1604,7 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 	size -= pos;
 	iov_iter_truncate(to, size);
-	return generic_file_read_iter(iocb, to);
+	return generic_file_read_iter(iocb, to, flags);
 }
 
 /*
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index ff1cc03..ad72a21 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1726,7 +1726,7 @@ static void update_time_for_write(struct inode *inode)
 }
 
 static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
-				    struct iov_iter *from)
+				    struct iov_iter *from, int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 2eb02f8..4776257 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -781,7 +781,8 @@ out:
  *
  * Hmm, the sync read case isn't actually async... should it be?
  */
-static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to)
+static ssize_t ceph_read_iter(struct kiocb *iocb, struct iov_iter *to,
+			      int flags)
 {
 	struct file *filp = iocb->ki_filp;
 	struct ceph_file_info *fi = filp->private_data;
@@ -819,7 +820,7 @@ again:
 		     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len,
 		     ceph_cap_string(got));
 
-		ret = generic_file_read_iter(iocb, to);
+		ret = generic_file_read_iter(iocb, to, flags);
 	}
 	dout("aio_read %p %llx.%llx dropping cap refs on %s = %d\n",
 	     inode, ceph_vinop(inode), ceph_cap_string(got), (int)ret);
@@ -860,7 +861,8 @@ again:
  *
  * If we are near ENOSPC, write synchronously.
  */
-static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from,
+			       int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct ceph_file_info *fi = file->private_data;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 889b984..079ad6c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -739,7 +739,7 @@ out_nls:
 }
 
 static ssize_t
-cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter, int flags)
 {
 	ssize_t rc;
 	struct inode *inode = file_inode(iocb->ki_filp);
@@ -748,10 +748,11 @@ cifs_loose_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (rc)
 		return rc;
 
-	return generic_file_read_iter(iocb, iter);
+	return generic_file_read_iter(iocb, iter, flags);
 }
 
-static ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from,
+		int flags)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
@@ -762,7 +763,7 @@ static ssize_t cifs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (written)
 		return written;
 
-	written = generic_file_write_iter(iocb, from);
+	written = generic_file_write_iter(iocb, from, flags);
 
 	if (CIFS_CACHE_WRITE(CIFS_I(inode)))
 		goto out;
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index b0fafa4..6c44582 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -95,10 +95,14 @@ extern const struct file_operations cifs_file_strict_nobrl_ops;
 extern int cifs_open(struct inode *inode, struct file *file);
 extern int cifs_close(struct inode *inode, struct file *file);
 extern int cifs_closedir(struct inode *inode, struct file *file);
-extern ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to);
-extern ssize_t cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to);
-extern ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from);
-extern ssize_t cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from);
+extern ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to,
+		int flags);
+extern ssize_t cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to,
+		int flags);
+extern ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from,
+		int flags);
+extern ssize_t cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from,
+		int flags);
 extern int cifs_lock(struct file *, int, struct file_lock *);
 extern int cifs_fsync(struct file *, loff_t, loff_t, int);
 extern int cifs_strict_fsync(struct file *, loff_t, loff_t, int);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7c018a1..58aecd7 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2658,7 +2658,7 @@ restart_loop:
 	return total_written ? total_written : (ssize_t)rc;
 }
 
-ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
+ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from, int flags)
 {
 	ssize_t written;
 	struct inode *inode;
@@ -2682,7 +2682,7 @@ ssize_t cifs_user_writev(struct kiocb *iocb, struct iov_iter *from)
 }
 
 static ssize_t
-cifs_writev(struct kiocb *iocb, struct iov_iter *from)
+cifs_writev(struct kiocb *iocb, struct iov_iter *from, int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
@@ -2703,7 +2703,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 	if (!cifs_find_lock_conflict(cfile, lock_pos, iov_iter_count(from),
 				     server->vals->exclusive_lock_type, NULL,
 				     CIFS_WRITE_OP)) {
-		rc = __generic_file_write_iter(iocb, from);
+		rc = __generic_file_write_iter(iocb, from, flags);
 		mutex_unlock(&inode->i_mutex);
 
 		if (rc > 0) {
@@ -2721,7 +2721,7 @@ cifs_writev(struct kiocb *iocb, struct iov_iter *from)
 }
 
 ssize_t
-cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
+cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from, int flags)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
@@ -2739,10 +2739,10 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 		if (cap_unix(tcon->ses) &&
 		(CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability))
 		  && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
-			written = generic_file_write_iter(iocb, from);
+			written = generic_file_write_iter(iocb, from, flags);
 			goto out;
 		}
-		written = cifs_writev(iocb, from);
+		written = cifs_writev(iocb, from, flags);
 		goto out;
 	}
 	/*
@@ -2751,7 +2751,7 @@ cifs_strict_writev(struct kiocb *iocb, struct iov_iter *from)
 	 * affected pages because it may cause a error with mandatory locks on
 	 * these pages but not on the region from pos to ppos+len-1.
 	 */
-	written = cifs_user_writev(iocb, from);
+	written = cifs_user_writev(iocb, from, flags);
 	if (written > 0 && CIFS_CACHE_READ(cinode)) {
 		/*
 		 * Windows 7 server can delay breaking level2 oplock if a write
@@ -2992,7 +2992,7 @@ error:
 	return rc;
 }
 
-ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
+ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to, int flags)
 {
 	struct file *file = iocb->ki_filp;
 	ssize_t rc;
@@ -3097,7 +3097,7 @@ again:
 }
 
 ssize_t
-cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
+cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to, int flags)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
@@ -3116,12 +3116,12 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 	 * pos+len-1.
 	 */
 	if (!CIFS_CACHE_READ(cinode))
-		return cifs_user_readv(iocb, to);
+		return cifs_user_readv(iocb, to, flags);
 
 	if (cap_unix(tcon->ses) &&
 	    (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
 	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
-		return generic_file_read_iter(iocb, to);
+		return generic_file_read_iter(iocb, to, flags);
 
 	/*
 	 * We need to hold the sem to be sure nobody modifies lock list
@@ -3131,7 +3131,7 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 	if (!cifs_find_lock_conflict(cfile, iocb->ki_pos, iov_iter_count(to),
 				     tcon->ses->server->vals->shared_lock_type,
 				     NULL, CIFS_READ_OP))
-		rc = generic_file_read_iter(iocb, to);
+		rc = generic_file_read_iter(iocb, to, flags);
 	up_read(&cinode->lock_sem);
 	return rc;
 }
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index db0fad3..bec0a0e 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -45,13 +45,13 @@
  * The function to be used for directory reads is ecryptfs_read.
  */
 static ssize_t ecryptfs_read_update_atime(struct kiocb *iocb,
-				struct iov_iter *to)
+				struct iov_iter *to, int flags)
 {
 	ssize_t rc;
 	struct path *path;
 	struct file *file = iocb->ki_filp;
 
-	rc = generic_file_read_iter(iocb, to);
+	rc = generic_file_read_iter(iocb, to, flags);
 	/*
 	 * Even though this is a async interface, we need to wait
 	 * for IO to finish to update atime
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index aca7b24..565de78 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -89,7 +89,7 @@ ext4_unaligned_aio(struct inode *inode, struct iov_iter *from, loff_t pos)
 }
 
 static ssize_t
-ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from, int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(iocb->ki_filp);
@@ -172,7 +172,7 @@ ext4_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		}
 	}
 
-	ret = __generic_file_write_iter(iocb, from);
+	ret = __generic_file_write_iter(iocb, from, flags);
 	mutex_unlock(&inode->i_mutex);
 
 	if (ret > 0) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 912061a..fdf1711 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -933,7 +933,8 @@ out:
 	return err;
 }
 
-static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
+static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to,
+				   int flags)
 {
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
 	struct fuse_conn *fc = get_fuse_conn(inode);
@@ -951,7 +952,7 @@ static ssize_t fuse_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 			return err;
 	}
 
-	return generic_file_read_iter(iocb, to);
+	return generic_file_read_iter(iocb, to, flags);
 }
 
 static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
@@ -1180,7 +1181,8 @@ static ssize_t fuse_perform_write(struct file *file,
 	return res > 0 ? res : err;
 }
 
-static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from,
+				    int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -1198,7 +1200,7 @@ static ssize_t fuse_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (err)
 			return err;
 
-		return generic_file_write_iter(iocb, from);
+		return generic_file_write_iter(iocb, from, flags);
 	}
 
 	mutex_lock(&inode->i_mutex);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 26b3f95..6146ffe 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -697,7 +697,8 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
  *
  */
 
-static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from,
+		int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct gfs2_inode *ip = GFS2_I(file_inode(file));
@@ -718,7 +719,7 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		gfs2_glock_dq_uninit(&gh);
 	}
 
-	return generic_file_write_iter(iocb, from);
+	return generic_file_write_iter(iocb, from, flags);
 }
 
 static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 524dd80..4072f3a 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -165,7 +165,7 @@ nfs_file_flush(struct file *file, fl_owner_t id)
 EXPORT_SYMBOL_GPL(nfs_file_flush);
 
 ssize_t
-nfs_file_read(struct kiocb *iocb, struct iov_iter *to)
+nfs_file_read(struct kiocb *iocb, struct iov_iter *to, int flags)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t result;
@@ -179,7 +179,7 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to)
 
 	result = nfs_revalidate_mapping(inode, iocb->ki_filp->f_mapping);
 	if (!result) {
-		result = generic_file_read_iter(iocb, to);
+		result = generic_file_read_iter(iocb, to, flags);
 		if (result > 0)
 			nfs_add_stats(inode, NFSIOS_NORMALREADBYTES, result);
 	}
@@ -634,7 +634,7 @@ static int nfs_need_sync_write(struct file *filp, struct inode *inode)
 	return 0;
 }
 
-ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
+ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from, int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
@@ -669,7 +669,7 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 	if (!count)
 		goto out;
 
-	result = generic_file_write_iter(iocb, from);
+	result = generic_file_write_iter(iocb, from, flags);
 	if (result > 0)
 		written = result;
 
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 9056622..646ad13c 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -337,11 +337,11 @@ int nfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *)
 int nfs_file_fsync_commit(struct file *, loff_t, loff_t, int);
 loff_t nfs_file_llseek(struct file *, loff_t, int);
 int nfs_file_flush(struct file *, fl_owner_t);
-ssize_t nfs_file_read(struct kiocb *, struct iov_iter *);
+ssize_t nfs_file_read(struct kiocb *, struct iov_iter *, int);
 ssize_t nfs_file_splice_read(struct file *, loff_t *, struct pipe_inode_info *,
 			     size_t, unsigned int);
 int nfs_file_mmap(struct file *, struct vm_area_struct *);
-ssize_t nfs_file_write(struct kiocb *, struct iov_iter *);
+ssize_t nfs_file_write(struct kiocb *, struct iov_iter *, int);
 int nfs_file_release(struct inode *, struct file *);
 int nfs_lock(struct file *, int, struct file_lock *);
 int nfs_flock(struct file *, int, struct file_lock *);
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index f501a9b..db7a31d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -855,7 +855,7 @@ __be32 nfsd_readv(struct file *file, loff_t offset, struct kvec *vec, int vlen,
 
 	oldfs = get_fs();
 	set_fs(KERNEL_DS);
-	host_err = vfs_readv(file, (struct iovec __user *)vec, vlen, &offset);
+	host_err = vfs_readv(file, (struct iovec __user *)vec, vlen, &offset, 0);
 	set_fs(oldfs);
 	return nfsd_finish_read(file, count, host_err);
 }
@@ -943,7 +943,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct file *file,
 
 	/* Write the data. */
 	oldfs = get_fs(); set_fs(KERNEL_DS);
-	host_err = vfs_writev(file, (struct iovec __user *)vec, vlen, &pos);
+	host_err = vfs_writev(file, (struct iovec __user *)vec, vlen, &pos, 0);
 	set_fs(oldfs);
 	if (host_err < 0)
 		goto out_nfserr;
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2930e23..418c8a3 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2234,7 +2234,7 @@ out:
 }
 
 static ssize_t ocfs2_file_write_iter(struct kiocb *iocb,
-				    struct iov_iter *from)
+				    struct iov_iter *from, int flags)
 {
 	int ret, direct_io, appending, rw_level, have_alloc_sem  = 0;
 	int can_do_direct, has_refcount = 0;
@@ -2461,7 +2461,8 @@ bail:
 }
 
 static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
-				   struct iov_iter *to)
+				   struct iov_iter *to,
+				   int flags)
 {
 	int ret = 0, rw_level = -1, have_alloc_sem = 0, lock_level = 0;
 	struct file *filp = iocb->ki_filp;
@@ -2516,7 +2517,7 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 	}
 	ocfs2_inode_unlock(inode, lock_level);
 
-	ret = generic_file_read_iter(iocb, to);
+	ret = generic_file_read_iter(iocb, to, flags);
 	trace_generic_file_aio_read_ret(ret);
 
 	/* buffered aio wouldn't have proper lock coverage today */
diff --git a/fs/pipe.c b/fs/pipe.c
index 21981e5..d2510ab 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -227,7 +227,7 @@ static const struct pipe_buf_operations packet_pipe_buf_ops = {
 };
 
 static ssize_t
-pipe_read(struct kiocb *iocb, struct iov_iter *to)
+pipe_read(struct kiocb *iocb, struct iov_iter *to, int flags)
 {
 	size_t total_len = iov_iter_count(to);
 	struct file *filp = iocb->ki_filp;
@@ -336,7 +336,7 @@ static inline int is_packetized(struct file *file)
 }
 
 static ssize_t
-pipe_write(struct kiocb *iocb, struct iov_iter *from)
+pipe_write(struct kiocb *iocb, struct iov_iter *from, int flags)
 {
 	struct file *filp = iocb->ki_filp;
 	struct pipe_inode_info *pipe = filp->private_data;
diff --git a/fs/read_write.c b/fs/read_write.c
index 009d854..4747247 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -25,7 +25,7 @@
 typedef ssize_t (*io_fn_t)(struct file *, char __user *, size_t, loff_t *);
 typedef ssize_t (*iov_fn_t)(struct kiocb *, const struct iovec *,
 		unsigned long, loff_t);
-typedef ssize_t (*iter_fn_t)(struct kiocb *, struct iov_iter *);
+typedef ssize_t (*iter_fn_t)(struct kiocb *, struct iov_iter *, int);
 
 const struct file_operations generic_ro_fops = {
 	.llseek		= generic_file_llseek,
@@ -403,7 +403,7 @@ ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *p
 	kiocb.ki_nbytes = len;
 	iov_iter_init(&iter, READ, &iov, 1, len);
 
-	ret = filp->f_op->read_iter(&kiocb, &iter);
+	ret = filp->f_op->read_iter(&kiocb, &iter, 0);
 	if (-EIOCBQUEUED == ret)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
@@ -475,7 +475,7 @@ ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t len, lo
 	kiocb.ki_nbytes = len;
 	iov_iter_init(&iter, WRITE, &iov, 1, len);
 
-	ret = filp->f_op->write_iter(&kiocb, &iter);
+	ret = filp->f_op->write_iter(&kiocb, &iter, 0);
 	if (-EIOCBQUEUED == ret)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
@@ -651,7 +651,8 @@ unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to)
 EXPORT_SYMBOL(iov_shorten);
 
 static ssize_t do_iter_readv_writev(struct file *filp, int rw, const struct iovec *iov,
-		unsigned long nr_segs, size_t len, loff_t *ppos, iter_fn_t fn)
+		unsigned long nr_segs, size_t len, loff_t *ppos, iter_fn_t fn,
+		int flags)
 {
 	struct kiocb kiocb;
 	struct iov_iter iter;
@@ -662,7 +663,7 @@ static ssize_t do_iter_readv_writev(struct file *filp, int rw, const struct iove
 	kiocb.ki_nbytes = len;
 
 	iov_iter_init(&iter, rw, iov, nr_segs, len);
-	ret = fn(&kiocb, &iter);
+	ret = fn(&kiocb, &iter, flags);
 	if (ret == -EIOCBQUEUED)
 		ret = wait_on_sync_kiocb(&kiocb);
 	*ppos = kiocb.ki_pos;
@@ -798,7 +799,8 @@ out:
 
 static ssize_t do_readv_writev(int type, struct file *file,
 			       const struct iovec __user * uvector,
-			       unsigned long nr_segs, loff_t *pos)
+			       unsigned long nr_segs, loff_t *pos,
+			       int flags)
 {
 	size_t tot_len;
 	struct iovec iovstack[UIO_FASTIOV];
@@ -832,7 +834,7 @@ static ssize_t do_readv_writev(int type, struct file *file,
 
 	if (iter_fn)
 		ret = do_iter_readv_writev(file, type, iov, nr_segs, tot_len,
-						pos, iter_fn);
+						pos, iter_fn, flags);
 	else if (fnv)
 		ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
 						pos, fnv);
@@ -855,27 +857,27 @@ out:
 }
 
 ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
-		  unsigned long vlen, loff_t *pos)
+		  unsigned long vlen, loff_t *pos, int flags)
 {
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_READ))
 		return -EINVAL;
 
-	return do_readv_writev(READ, file, vec, vlen, pos);
+	return do_readv_writev(READ, file, vec, vlen, pos, flags);
 }
 
 EXPORT_SYMBOL(vfs_readv);
 
 ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
-		   unsigned long vlen, loff_t *pos)
+		   unsigned long vlen, loff_t *pos, int flags)
 {
 	if (!(file->f_mode & FMODE_WRITE))
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_WRITE))
 		return -EINVAL;
 
-	return do_readv_writev(WRITE, file, vec, vlen, pos);
+	return do_readv_writev(WRITE, file, vec, vlen, pos, flags);
 }
 
 EXPORT_SYMBOL(vfs_writev);
@@ -888,7 +890,7 @@ SYSCALL_DEFINE3(readv, unsigned long, fd, const struct iovec __user *, vec,
 
 	if (f.file) {
 		loff_t pos = file_pos_read(f.file);
-		ret = vfs_readv(f.file, vec, vlen, &pos);
+		ret = vfs_readv(f.file, vec, vlen, &pos, 0);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
 		fdput_pos(f);
@@ -908,7 +910,7 @@ SYSCALL_DEFINE3(writev, unsigned long, fd, const struct iovec __user *, vec,
 
 	if (f.file) {
 		loff_t pos = file_pos_read(f.file);
-		ret = vfs_writev(f.file, vec, vlen, &pos);
+		ret = vfs_writev(f.file, vec, vlen, &pos, 0);
 		if (ret >= 0)
 			file_pos_write(f.file, pos);
 		fdput_pos(f);
@@ -940,7 +942,7 @@ SYSCALL_DEFINE5(preadv, unsigned long, fd, const struct iovec __user *, vec,
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PREAD)
-			ret = vfs_readv(f.file, vec, vlen, &pos);
+			ret = vfs_readv(f.file, vec, vlen, &pos, 0);
 		fdput(f);
 	}
 
@@ -964,7 +966,7 @@ SYSCALL_DEFINE5(pwritev, unsigned long, fd, const struct iovec __user *, vec,
 	if (f.file) {
 		ret = -ESPIPE;
 		if (f.file->f_mode & FMODE_PWRITE)
-			ret = vfs_writev(f.file, vec, vlen, &pos);
+			ret = vfs_writev(f.file, vec, vlen, &pos, 0);
 		fdput(f);
 	}
 
@@ -1012,7 +1014,7 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 
 	if (iter_fn)
 		ret = do_iter_readv_writev(file, type, iov, nr_segs, tot_len,
-						pos, iter_fn);
+						pos, iter_fn, 0);
 	else if (fnv)
 		ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
 						pos, fnv);
@@ -1111,6 +1113,7 @@ COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
 	return __compat_sys_preadv64(fd, vec, vlen, pos);
 }
 
+
 static size_t compat_writev(struct file *file,
 			    const struct compat_iovec __user *vec,
 			    unsigned long vlen, loff_t *pos)
diff --git a/fs/splice.c b/fs/splice.c
index f5cb9ba..a466a86 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -576,7 +576,7 @@ static ssize_t kernel_readv(struct file *file, const struct iovec *vec,
 	old_fs = get_fs();
 	set_fs(get_ds());
 	/* The cast to a user pointer is valid due to the set_fs() */
-	res = vfs_readv(file, (const struct iovec __user *)vec, vlen, &pos);
+	res = vfs_readv(file, (const struct iovec __user *)vec, vlen, &pos, 0);
 	set_fs(old_fs);
 
 	return res;
@@ -1018,7 +1018,7 @@ iter_file_splice_write(struct pipe_inode_info *pipe, struct file *out,
 		kiocb.ki_nbytes = sd.total_len - left;
 
 		/* now, send it */
-		ret = out->f_op->write_iter(&kiocb, &from);
+		ret = out->f_op->write_iter(&kiocb, &from, 0);
 		if (-EIOCBQUEUED == ret)
 			ret = wait_on_sync_kiocb(&kiocb);
 
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index b5b593c..51100c4 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1397,13 +1397,14 @@ static int update_mctime(struct inode *inode)
 	return 0;
 }
 
-static ssize_t ubifs_write_iter(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t ubifs_write_iter(struct kiocb *iocb, struct iov_iter *from,
+		int flags)
 {
 	int err = update_mctime(file_inode(iocb->ki_filp));
 	if (err)
 		return err;
 
-	return generic_file_write_iter(iocb, from);
+	return generic_file_write_iter(iocb, from, flags);
 }
 
 static int ubifs_set_page_dirty(struct page *page)
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 86c6743..e903b96 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -116,7 +116,8 @@ const struct address_space_operations udf_adinicb_aops = {
 	.direct_IO	= udf_adinicb_direct_IO,
 };
 
-static ssize_t udf_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t udf_file_write_iter(struct kiocb *iocb, struct iov_iter *from,
+		int flags)
 {
 	ssize_t retval;
 	struct file *file = iocb->ki_filp;
@@ -152,7 +153,7 @@ static ssize_t udf_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	} else
 		up_write(&iinfo->i_data_sem);
 
-	retval = __generic_file_write_iter(iocb, from);
+	retval = __generic_file_write_iter(iocb, from, flags);
 	mutex_unlock(&inode->i_mutex);
 
 	if (retval > 0) {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index de5368c..68847008 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -232,7 +232,8 @@ xfs_file_fsync(
 STATIC ssize_t
 xfs_file_read_iter(
 	struct kiocb		*iocb,
-	struct iov_iter		*to)
+	struct iov_iter		*to,
+	int			flags)
 {
 	struct file		*file = iocb->ki_filp;
 	struct inode		*inode = file->f_mapping->host;
@@ -313,7 +314,7 @@ xfs_file_read_iter(
 
 	trace_xfs_file_read(ip, size, pos, ioflags);
 
-	ret = generic_file_read_iter(iocb, to);
+	ret = generic_file_read_iter(iocb, to, flags);
 	if (ret > 0)
 		XFS_STATS_ADD(xs_read_bytes, ret);
 
@@ -743,7 +744,8 @@ out:
 STATIC ssize_t
 xfs_file_write_iter(
 	struct kiocb		*iocb,
-	struct iov_iter		*from)
+	struct iov_iter		*from,
+	int			flags)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9418772..62ea9f5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1486,8 +1486,8 @@ struct file_operations {
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
 	ssize_t (*aio_read) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
 	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long, loff_t);
-	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
-	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
+	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *, int);
+	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *, int);
 	int (*iterate) (struct file *, struct dir_context *);
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
@@ -1556,9 +1556,9 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
-		unsigned long, loff_t *);
+		unsigned long, loff_t *, int);
 extern ssize_t vfs_writev(struct file *, const struct iovec __user *,
-		unsigned long, loff_t *);
+		unsigned long, loff_t *, int);
 
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
@@ -2444,9 +2444,9 @@ extern int generic_file_readonly_mmap(struct file *, struct vm_area_struct *);
 extern int generic_file_remap_pages(struct vm_area_struct *, unsigned long addr,
 		unsigned long size, pgoff_t pgoff);
 int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk);
-extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
-extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *);
-extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *);
+extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *, int flags);
+extern ssize_t __generic_file_write_iter(struct kiocb *, struct iov_iter *, int flags);
+extern ssize_t generic_file_write_iter(struct kiocb *, struct iov_iter *, int flags);
 extern ssize_t generic_file_direct_write(struct kiocb *, struct iov_iter *, loff_t);
 extern ssize_t generic_perform_write(struct file *, struct iov_iter *, loff_t);
 extern ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos);
@@ -2455,7 +2455,7 @@ extern ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, lo
 extern ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
 
 /* fs/block_dev.c */
-extern ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from);
+extern ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from, int flags);
 extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
 			int datasync);
 extern void block_sync_page(struct page *page);
diff --git a/mm/filemap.c b/mm/filemap.c
index 90effcd..c95edbf 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1456,7 +1456,7 @@ static void shrink_readahead_size_eio(struct file *filp,
  * of the logic when it comes to error handling etc.
  */
 static ssize_t do_generic_file_read(struct file *filp, loff_t *ppos,
-		struct iov_iter *iter, ssize_t written)
+		struct iov_iter *iter, ssize_t written, int flags)
 {
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
@@ -1683,7 +1683,7 @@ out:
  * that can use the page cache directly.
  */
 ssize_t
-generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter, int flags)
 {
 	struct file *file = iocb->ki_filp;
 	ssize_t retval = 0;
@@ -1726,7 +1726,7 @@ generic_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		}
 	}
 
-	retval = do_generic_file_read(file, ppos, iter, retval);
+	retval = do_generic_file_read(file, ppos, iter, retval, flags);
 out:
 	return retval;
 }
@@ -2549,7 +2549,8 @@ EXPORT_SYMBOL(generic_perform_write);
  * A caller has to handle it. This is mainly due to the fact that we want to
  * avoid syncing under i_mutex.
  */
-ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from,
+				  int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space * mapping = file->f_mapping;
@@ -2645,14 +2646,14 @@ EXPORT_SYMBOL(__generic_file_write_iter);
  * filesystems. It takes care of syncing the file in case of O_SYNC file
  * and acquires i_mutex as needed.
  */
-ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+ssize_t generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from, int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
 	mutex_lock(&inode->i_mutex);
-	ret = __generic_file_write_iter(iocb, from);
+	ret = __generic_file_write_iter(iocb, from, flags);
 	mutex_unlock(&inode->i_mutex);
 
 	if (ret > 0) {
diff --git a/mm/shmem.c b/mm/shmem.c
index 0e5fb22..24c73bce 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1519,7 +1519,7 @@ shmem_write_end(struct file *file, struct address_space *mapping,
 	return copied;
 }
 
-static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
+static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to, int flags)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
-- 
1.7.9.5

