Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934987Ab3JPOMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:12:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26638 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934614Ab3JPOFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:05:54 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V9 11/33] dio: Convert direct_IO to use iov_iter
Date: Wed, 16 Oct 2013 09:04:24 -0500
Message-Id: <1381932286-14978-12-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the direct_IO aop to take an iov_iter argument rather than an iovec.
This will get passed down through most filesystems so that only the
__blockdev_direct_IO helper need be aware of whether user or kernel memory
is being passed to the function.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 Documentation/filesystems/Locking |  4 +--
 Documentation/filesystems/vfs.txt |  4 +--
 fs/9p/vfs_addr.c                  |  8 ++---
 fs/block_dev.c                    |  8 ++---
 fs/btrfs/inode.c                  | 63 +++++++++++++++++++++++----------------
 fs/ceph/addr.c                    |  3 +-
 fs/direct-io.c                    | 19 ++++++------
 fs/ext2/inode.c                   |  8 ++---
 fs/ext3/inode.c                   | 15 ++++------
 fs/ext4/ext4.h                    |  3 +-
 fs/ext4/indirect.c                | 16 +++++-----
 fs/ext4/inode.c                   | 23 +++++++-------
 fs/f2fs/data.c                    |  4 +--
 fs/fat/inode.c                    | 10 +++----
 fs/fuse/cuse.c                    | 10 +++++--
 fs/fuse/file.c                    | 56 +++++++++++++++++-----------------
 fs/fuse/fuse_i.h                  |  5 ++--
 fs/gfs2/aops.c                    |  7 ++---
 fs/hfs/inode.c                    |  7 ++---
 fs/hfsplus/inode.c                |  6 ++--
 fs/jfs/inode.c                    |  7 ++---
 fs/nfs/direct.c                   | 13 ++++----
 fs/nilfs2/inode.c                 |  8 ++---
 fs/ocfs2/aops.c                   |  8 ++---
 fs/reiserfs/inode.c               |  7 ++---
 fs/udf/file.c                     |  3 +-
 fs/udf/inode.c                    | 10 +++----
 fs/xfs/xfs_aops.c                 | 13 ++++----
 include/linux/fs.h                | 18 +++++------
 include/linux/nfs_fs.h            |  3 +-
 mm/filemap.c                      | 13 ++++++--
 mm/page_io.c                      |  8 +++--
 32 files changed, 196 insertions(+), 194 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index fe7afe2..ff1e311 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -192,8 +192,8 @@ prototypes:
 	void (*invalidatepage) (struct page *, unsigned int, unsigned int);
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
-	int (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs);
+	int (*direct_IO)(int, struct kiocb *, struct iov_iter *iter,
+			loff_t offset);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int, void **,
 				unsigned long *);
 	int (*migratepage)(struct address_space *, struct page *, struct page *);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index deb48b5..234da0a 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -573,8 +573,8 @@ struct address_space_operations {
 	void (*invalidatepage) (struct page *, unsigned int, unsigned int);
 	int (*releasepage) (struct page *, int);
 	void (*freepage)(struct page *);
-	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs);
+	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter,
+			loff_t offset);
 	struct page* (*get_xip_page)(struct address_space *, sector_t,
 			int);
 	/* migrate the contents of a page to the specified target */
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index 9ff073f..5581415 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -241,9 +241,8 @@ static int v9fs_launder_page(struct page *page)
  * v9fs_direct_IO - 9P address space operation for direct I/O
  * @rw: direction (read or write)
  * @iocb: target I/O control block
- * @iov: array of vectors that define I/O buffer
+ * @iter: array of vectors that define I/O buffer
  * @pos: offset in file to begin the operation
- * @nr_segs: size of iovec array
  *
  * The presence of v9fs_direct_IO() in the address space ops vector
  * allowes open() O_DIRECT flags which would have failed otherwise.
@@ -257,8 +256,7 @@ static int v9fs_launder_page(struct page *page)
  *
  */
 static ssize_t
-v9fs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-	       loff_t pos, unsigned long nr_segs)
+v9fs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	/*
 	 * FIXME
@@ -267,7 +265,7 @@ v9fs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	 */
 	p9_debug(P9_DEBUG_VFS, "v9fs_direct_IO: v9fs_direct_IO (%s) off/no(%lld/%lu) EINVAL\n",
 		 iocb->ki_filp->f_path.dentry->d_name.name,
-		 (long long)pos, nr_segs);
+		 (long long)pos, iter->nr_segs);
 
 	return -EINVAL;
 }
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1e86823..af016f4 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -165,14 +165,14 @@ blkdev_get_block(struct inode *inode, sector_t iblock,
 }
 
 static ssize_t
-blkdev_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+blkdev_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+			loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
-	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iov, offset,
-				    nr_segs, blkdev_get_block, NULL, NULL, 0);
+	return __blockdev_direct_IO(rw, iocb, inode, I_BDEV(inode), iter,
+				    offset, blkdev_get_block, NULL, NULL, 0);
 }
 
 int __sync_blockdev(struct block_device *bdev, int wait)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b0ef7b0..6feae86 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7154,8 +7154,7 @@ free_ordered:
 }
 
 static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+			struct iov_iter *iter, loff_t offset)
 {
 	int seg;
 	int i;
@@ -7169,35 +7168,50 @@ static ssize_t check_direct_IO(struct btrfs_root *root, int rw, struct kiocb *io
 		goto out;
 
 	/* Check the memory alignment.  Blocks cannot straddle pages */
-	for (seg = 0; seg < nr_segs; seg++) {
-		addr = (unsigned long)iov[seg].iov_base;
-		size = iov[seg].iov_len;
-		end += size;
-		if ((addr & blocksize_mask) || (size & blocksize_mask))
-			goto out;
+	if (iov_iter_has_iovec(iter)) {
+		const struct iovec *iov = iov_iter_iovec(iter);
+
+		for (seg = 0; seg < iter->nr_segs; seg++) {
+			addr = (unsigned long)iov[seg].iov_base;
+			size = iov[seg].iov_len;
+			end += size;
+			if ((addr & blocksize_mask) || (size & blocksize_mask))
+				goto out;
 
-		/* If this is a write we don't need to check anymore */
-		if (rw & WRITE)
-			continue;
+			/* If this is a write we don't need to check anymore */
+			if (rw & WRITE)
+				continue;
 
-		/*
-		 * Check to make sure we don't have duplicate iov_base's in this
-		 * iovec, if so return EINVAL, otherwise we'll get csum errors
-		 * when reading back.
-		 */
-		for (i = seg + 1; i < nr_segs; i++) {
-			if (iov[seg].iov_base == iov[i].iov_base)
+			/*
+			* Check to make sure we don't have duplicate iov_base's
+			* in this iovec, if so return EINVAL, otherwise we'll
+			* get csum errors when reading back.
+			*/
+			for (i = seg + 1; i < iter->nr_segs; i++) {
+				if (iov[seg].iov_base == iov[i].iov_base)
+					goto out;
+			}
+		}
+	} else if (iov_iter_has_bvec(iter)) {
+		struct bio_vec *bvec = iov_iter_bvec(iter);
+
+		for (seg = 0; seg < iter->nr_segs; seg++) {
+			addr = (unsigned long)bvec[seg].bv_offset;
+			size = bvec[seg].bv_len;
+			end += size;
+			if ((addr & blocksize_mask) || (size & blocksize_mask))
 				goto out;
 		}
-	}
+	} else
+		BUG();
+
 	retval = 0;
 out:
 	return retval;
 }
 
 static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+			struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -7207,8 +7221,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	bool relock = false;
 	ssize_t ret;
 
-	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iov,
-			    offset, nr_segs))
+	if (check_direct_IO(BTRFS_I(inode)->root, rw, iocb, iter, offset))
 		return 0;
 
 	atomic_inc(&inode->i_dio_count);
@@ -7220,7 +7233,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 	 * call btrfs_wait_ordered_range to make absolutely sure that any
 	 * outstanding dirty pages are on disk.
 	 */
-	count = iov_length(iov, nr_segs);
+	count = iov_iter_count(iter);
 	btrfs_wait_ordered_range(inode, offset, count);
 
 	if (rw & WRITE) {
@@ -7245,7 +7258,7 @@ static ssize_t btrfs_direct_IO(int rw, struct kiocb *iocb,
 
 	ret = __blockdev_direct_IO(rw, iocb, inode,
 			BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
-			iov, offset, nr_segs, btrfs_get_blocks_direct, NULL,
+			iter, offset, btrfs_get_blocks_direct, NULL,
 			btrfs_submit_direct, flags);
 	if (rw & WRITE) {
 		if (ret < 0 && ret != -EIOCBQUEUED)
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 6df8bd4..1cb39e6 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1179,8 +1179,7 @@ static int ceph_write_end(struct file *file, struct address_space *mapping,
  * never get called.
  */
 static ssize_t ceph_direct_io(int rw, struct kiocb *iocb,
-			      const struct iovec *iov,
-			      loff_t pos, unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t pos)
 {
 	WARN_ON(1);
 	return -EINVAL;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 0e04142..1cf8f17 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1108,9 +1108,9 @@ static inline int drop_refcount(struct dio *dio)
  */
 static inline ssize_t
 do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags)
+	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
+	get_block_t get_block, dio_iodone_t end_io, dio_submit_t submit_io,
+	int flags)
 {
 	int seg;
 	size_t size;
@@ -1126,6 +1126,8 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	size_t bytes;
 	struct buffer_head map_bh = { 0, };
 	struct blk_plug plug;
+	const struct iovec *iov = iov_iter_iovec(iter);
+	unsigned long nr_segs = iter->nr_segs;
 
 	if (rw & WRITE)
 		rw = WRITE_ODIRECT;
@@ -1360,9 +1362,9 @@ out:
 
 ssize_t
 __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset,
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags)
+	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
+	get_block_t get_block, dio_iodone_t end_io, dio_submit_t submit_io,
+	int flags)
 {
 	/*
 	 * The block device state is needed in the end to finally
@@ -1376,9 +1378,8 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	prefetch(bdev->bd_queue);
 	prefetch((char *)bdev->bd_queue + SMP_CACHE_BYTES);
 
-	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iov, offset,
-				     nr_segs, get_block, end_io,
-				     submit_io, flags);
+	return do_blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
+				     get_block, end_io, submit_io, flags);
 }
 
 EXPORT_SYMBOL(__blockdev_direct_IO);
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index c260de6..cf91b33 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -848,18 +848,16 @@ static sector_t ext2_bmap(struct address_space *mapping, sector_t block)
 }
 
 static ssize_t
-ext2_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+ext2_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 ext2_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, ext2_get_block);
 	if (ret < 0 && (rw & WRITE))
-		ext2_write_failed(mapping, offset + iov_length(iov, nr_segs));
+		ext2_write_failed(mapping, offset + iov_iter_count(iter));
 	return ret;
 }
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2bd8548..85bd13b 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1862,8 +1862,7 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
  * VFS code falls back into buffered path in that case so we are safe.
  */
 static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
-			const struct iovec *iov, loff_t offset,
-			unsigned long nr_segs)
+			struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -1871,10 +1870,10 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 	int retries = 0;
 
-	trace_ext3_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
+	trace_ext3_direct_IO_enter(inode, offset, count, rw);
 
 	if (rw == WRITE) {
 		loff_t final_size = offset + count;
@@ -1898,15 +1897,14 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	}
 
 retry:
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 ext3_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, ext3_get_block);
 	/*
 	 * In case of error extending write may have instantiated a few
 	 * blocks outside i_size. Trim these off again.
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + count;
 
 		if (end > isize)
 			ext3_truncate_failed_direct_write(inode);
@@ -1949,8 +1947,7 @@ retry:
 			ret = err;
 	}
 out:
-	trace_ext3_direct_IO_exit(inode, offset,
-				iov_length(iov, nr_segs), rw, ret);
+	trace_ext3_direct_IO_exit(inode, offset, count, rw, ret);
 	return ret;
 }
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index af815ea..75af764 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2117,8 +2117,7 @@ extern void ext4_da_update_reserve_space(struct inode *inode,
 extern int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 				struct ext4_map_blocks *map, int flags);
 extern ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
-				const struct iovec *iov, loff_t offset,
-				unsigned long nr_segs);
+				struct iov_iter *iter, loff_t offset);
 extern int ext4_ind_calc_metadata_amount(struct inode *inode, sector_t lblock);
 extern int ext4_ind_trans_blocks(struct inode *inode, int nrblocks);
 extern void ext4_ind_truncate(handle_t *, struct inode *inode);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 594009f..8026469 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -639,8 +639,7 @@ out:
  * VFS code falls back into buffered path in that case so we are safe.
  */
 ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
-			   const struct iovec *iov, loff_t offset,
-			   unsigned long nr_segs)
+			   struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -648,7 +647,7 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 	handle_t *handle;
 	ssize_t ret;
 	int orphan = 0;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 	int retries = 0;
 
 	if (rw == WRITE) {
@@ -687,18 +686,17 @@ retry:
 			goto locked;
 		}
 		ret = __blockdev_direct_IO(rw, iocb, inode,
-				 inode->i_sb->s_bdev, iov,
-				 offset, nr_segs,
-				 ext4_get_block, NULL, NULL, 0);
+				 inode->i_sb->s_bdev, iter,
+				 offset, ext4_get_block, NULL, NULL, 0);
 		inode_dio_done(inode);
 	} else {
 locked:
-		ret = blockdev_direct_IO(rw, iocb, inode, iov,
-				 offset, nr_segs, ext4_get_block);
+		ret = blockdev_direct_IO(rw, iocb, inode, iter,
+				 offset, ext4_get_block);
 
 		if (unlikely((rw & WRITE) && ret < 0)) {
 			loff_t isize = i_size_read(inode);
-			loff_t end = offset + iov_length(iov, nr_segs);
+			loff_t end = offset + iov_iter_count(iter);
 
 			if (end > isize)
 				ext4_truncate_failed_write(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e274e9c..32c04ab 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3067,13 +3067,12 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
  *
  */
 static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 	int overwrite = 0;
 	get_block_t *get_block_func = NULL;
 	int dio_flags = 0;
@@ -3082,7 +3081,7 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 
 	/* Use the old path for reads and writes beyond i_size. */
 	if (rw != WRITE || final_size > inode->i_size)
-		return ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
+		return ext4_ind_direct_IO(rw, iocb, iter, offset);
 
 	BUG_ON(iocb->private == NULL);
 
@@ -3149,8 +3148,8 @@ static ssize_t ext4_ext_direct_IO(int rw, struct kiocb *iocb,
 		dio_flags = DIO_LOCKING;
 	}
 	ret = __blockdev_direct_IO(rw, iocb, inode,
-				   inode->i_sb->s_bdev, iov,
-				   offset, nr_segs,
+				   inode->i_sb->s_bdev, iter,
+				   offset,
 				   get_block_func,
 				   ext4_end_io_dio,
 				   NULL,
@@ -3204,8 +3203,7 @@ retake_lock:
 }
 
 static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -3221,13 +3219,12 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 	if (ext4_has_inline_data(inode))
 		return 0;
 
-	trace_ext4_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
+	trace_ext4_direct_IO_enter(inode, offset, iov_iter_count(iter), rw);
 	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		ret = ext4_ext_direct_IO(rw, iocb, iov, offset, nr_segs);
+		ret = ext4_ext_direct_IO(rw, iocb, iter, offset);
 	else
-		ret = ext4_ind_direct_IO(rw, iocb, iov, offset, nr_segs);
-	trace_ext4_direct_IO_exit(inode, offset,
-				iov_length(iov, nr_segs), rw, ret);
+		ret = ext4_ind_direct_IO(rw, iocb, iter, offset);
+	trace_ext4_direct_IO_exit(inode, offset, iov_iter_count(iter), rw, ret);
 	return ret;
 }
 
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 941f9b9..2c02ec8 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -727,7 +727,7 @@ static int f2fs_write_end(struct file *file,
 }
 
 static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+		struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -736,7 +736,7 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 		return 0;
 
 	/* Needs synchronization with the cleaner */
-	return blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+	return blockdev_direct_IO(rw, iocb, inode, iter, offset,
 						  get_data_block_ro);
 }
 
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 0062da2..3134d1e 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -185,8 +185,7 @@ static int fat_write_end(struct file *file, struct address_space *mapping,
 }
 
 static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
-			     const struct iovec *iov,
-			     loff_t offset, unsigned long nr_segs)
+			     struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -203,7 +202,7 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 		 *
 		 * Return 0, and fallback to normal buffered write.
 		 */
-		loff_t size = offset + iov_length(iov, nr_segs);
+		loff_t size = offset + iov_iter_count(iter);
 		if (MSDOS_I(inode)->mmu_private < size)
 			return 0;
 	}
@@ -212,10 +211,9 @@ static ssize_t fat_direct_IO(int rw, struct kiocb *iocb,
 	 * FAT need to use the DIO_LOCKING for avoiding the race
 	 * condition of fat_get_block() and ->truncate().
 	 */
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 fat_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, fat_get_block);
 	if (ret < 0 && (rw & WRITE))
-		fat_write_failed(mapping, offset + iov_length(iov, nr_segs));
+		fat_write_failed(mapping, offset + iov_iter_count(iter));
 
 	return ret;
 }
diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index adbfd66..7e5950f 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -94,8 +94,11 @@ static ssize_t cuse_read(struct file *file, char __user *buf, size_t count,
 	loff_t pos = 0;
 	struct iovec iov = { .iov_base = buf, .iov_len = count };
 	struct fuse_io_priv io = { .async = 0, .file = file };
+	struct iov_iter ii;
 
-	return fuse_direct_io(&io, &iov, 1, count, &pos, 0);
+	iov_iter_init(&ii, &iov, 1, count, 0);
+
+	return fuse_direct_io(&io, &ii, count, &pos, 0);
 }
 
 static ssize_t cuse_write(struct file *file, const char __user *buf,
@@ -104,12 +107,15 @@ static ssize_t cuse_write(struct file *file, const char __user *buf,
 	loff_t pos = 0;
 	struct iovec iov = { .iov_base = (void __user *)buf, .iov_len = count };
 	struct fuse_io_priv io = { .async = 0, .file = file };
+	struct iov_iter ii;
+
+	iov_iter_init(&ii, &iov, 1, count, 0);
 
 	/*
 	 * No locking or generic_write_checks(), the server is
 	 * responsible for locking and sanity checks.
 	 */
-	return fuse_direct_io(&io, &iov, 1, count, &pos, 1);
+	return fuse_direct_io(&io, &ii, count, &pos, 1);
 }
 
 static int cuse_open(struct inode *inode, struct file *file)
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index b04c8c6..05d025a 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1270,9 +1270,8 @@ static inline int fuse_iter_npages(const struct iov_iter *ii_p)
 	return min(npages, FUSE_MAX_PAGES_PER_REQ);
 }
 
-ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
-		       unsigned long nr_segs, size_t count, loff_t *ppos,
-		       int write)
+ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *ii,
+		       size_t count, loff_t *ppos, int write)
 {
 	struct file *file = io->file;
 	struct fuse_file *ff = file->private_data;
@@ -1281,14 +1280,11 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
 	loff_t pos = *ppos;
 	ssize_t res = 0;
 	struct fuse_req *req;
-	struct iov_iter ii;
-
-	iov_iter_init(&ii, iov, nr_segs, count, 0);
 
 	if (io->async)
-		req = fuse_get_req_for_background(fc, fuse_iter_npages(&ii));
+		req = fuse_get_req_for_background(fc, fuse_iter_npages(ii));
 	else
-		req = fuse_get_req(fc, fuse_iter_npages(&ii));
+		req = fuse_get_req(fc, fuse_iter_npages(ii));
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
@@ -1296,7 +1292,7 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
 		size_t nres;
 		fl_owner_t owner = current->files;
 		size_t nbytes = min(count, nmax);
-		int err = fuse_get_user_pages(req, &ii, &nbytes, write);
+		int err = fuse_get_user_pages(req, ii, &nbytes, write);
 		if (err) {
 			res = err;
 			break;
@@ -1326,9 +1322,9 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
 			fuse_put_request(fc, req);
 			if (io->async)
 				req = fuse_get_req_for_background(fc,
-					fuse_iter_npages(&ii));
+					fuse_iter_npages(ii));
 			else
-				req = fuse_get_req(fc, fuse_iter_npages(&ii));
+				req = fuse_get_req(fc, fuse_iter_npages(ii));
 			if (IS_ERR(req))
 				break;
 		}
@@ -1342,10 +1338,8 @@ ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
 }
 EXPORT_SYMBOL_GPL(fuse_direct_io);
 
-static ssize_t __fuse_direct_read(struct fuse_io_priv *io,
-				  const struct iovec *iov,
-				  unsigned long nr_segs, loff_t *ppos,
-				  size_t count)
+static ssize_t __fuse_direct_read(struct fuse_io_priv *io, struct iov_iter *ii,
+				  loff_t *ppos, size_t count)
 {
 	ssize_t res;
 	struct file *file = io->file;
@@ -1354,7 +1348,7 @@ static ssize_t __fuse_direct_read(struct fuse_io_priv *io,
 	if (is_bad_inode(inode))
 		return -EIO;
 
-	res = fuse_direct_io(io, iov, nr_segs, count, ppos, 0);
+	res = fuse_direct_io(io, ii, count, ppos, 0);
 
 	fuse_invalidate_attr(inode);
 
@@ -1366,21 +1360,24 @@ static ssize_t fuse_direct_read(struct file *file, char __user *buf,
 {
 	struct fuse_io_priv io = { .async = 0, .file = file };
 	struct iovec iov = { .iov_base = buf, .iov_len = count };
-	return __fuse_direct_read(&io, &iov, 1, ppos, count);
+	struct iov_iter ii;
+
+	iov_iter_init(&ii, &iov, 1, count, 0);
+
+	return __fuse_direct_read(&io, &ii, ppos, count);
 }
 
-static ssize_t __fuse_direct_write(struct fuse_io_priv *io,
-				   const struct iovec *iov,
-				   unsigned long nr_segs, loff_t *ppos)
+static ssize_t __fuse_direct_write(struct fuse_io_priv *io, struct iov_iter *ii,
+				   loff_t *ppos)
 {
 	struct file *file = io->file;
 	struct inode *inode = file_inode(file);
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(ii);
 	ssize_t res;
 
 	res = generic_write_checks(file, ppos, &count, 0);
 	if (!res)
-		res = fuse_direct_io(io, iov, nr_segs, count, ppos, 1);
+		res = fuse_direct_io(io, ii, count, ppos, 1);
 
 	fuse_invalidate_attr(inode);
 
@@ -1391,6 +1388,7 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
 	struct iovec iov = { .iov_base = (void __user *)buf, .iov_len = count };
+	struct iov_iter ii;
 	struct inode *inode = file_inode(file);
 	ssize_t res;
 	struct fuse_io_priv io = { .async = 0, .file = file };
@@ -1398,9 +1396,11 @@ static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 	if (is_bad_inode(inode))
 		return -EIO;
 
+	iov_iter_init(&ii, &iov, 1, count, 0);
+
 	/* Don't allow parallel writes to the same file */
 	mutex_lock(&inode->i_mutex);
-	res = __fuse_direct_write(&io, &iov, 1, ppos);
+	res = __fuse_direct_write(&io, &ii, ppos);
 	if (res > 0)
 		fuse_write_update_size(inode, *ppos);
 	mutex_unlock(&inode->i_mutex);
@@ -2373,8 +2373,8 @@ static inline loff_t fuse_round_up(loff_t off)
 }
 
 static ssize_t
-fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs)
+fuse_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *ii,
+			loff_t offset)
 {
 	ssize_t ret = 0;
 	struct file *file = iocb->ki_filp;
@@ -2383,7 +2383,7 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	loff_t pos = 0;
 	struct inode *inode;
 	loff_t i_size;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(ii);
 	struct fuse_io_priv *io;
 
 	pos = offset;
@@ -2424,9 +2424,9 @@ fuse_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		io->async = false;
 
 	if (rw == WRITE)
-		ret = __fuse_direct_write(io, iov, nr_segs, &pos);
+		ret = __fuse_direct_write(io, ii, &pos);
 	else
-		ret = __fuse_direct_read(io, iov, nr_segs, &pos, count);
+		ret = __fuse_direct_read(io, ii, &pos, count);
 
 	if (io->async) {
 		fuse_aio_complete(io, ret < 0 ? ret : 0, -1);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 5b9e6f3..67f06d5 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -858,9 +858,8 @@ int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
 
 int fuse_do_open(struct fuse_conn *fc, u64 nodeid, struct file *file,
 		 bool isdir);
-ssize_t fuse_direct_io(struct fuse_io_priv *io, const struct iovec *iov,
-		       unsigned long nr_segs, size_t count, loff_t *ppos,
-		       int write);
+ssize_t fuse_direct_io(struct fuse_io_priv *io, struct iov_iter *ii,
+		       size_t count, loff_t *ppos, int write);
 long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 		   unsigned int flags);
 long fuse_ioctl_common(struct file *file, unsigned int cmd,
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 1f7d805..43e8eaa 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -979,8 +979,7 @@ static int gfs2_ok_for_dio(struct gfs2_inode *ip, int rw, loff_t offset)
 
 
 static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
-			      const struct iovec *iov, loff_t offset,
-			      unsigned long nr_segs)
+			      struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
@@ -1004,8 +1003,8 @@ static ssize_t gfs2_direct_IO(int rw, struct kiocb *iocb,
 	if (rv != 1)
 		goto out; /* dio not valid, fall back to buffered i/o */
 
-	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				  offset, nr_segs, gfs2_get_block_direct,
+	rv = __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iter,
+				  offset, gfs2_get_block_direct,
 				  NULL, NULL, 0);
 out:
 	gfs2_glock_dq(&gh);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index 380ab31..9c10f7c 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -125,15 +125,14 @@ static int hfs_releasepage(struct page *page, gfp_t mask)
 }
 
 static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+		struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = file_inode(file)->i_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 hfs_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, hfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -141,7 +140,7 @@ static ssize_t hfs_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			hfs_write_failed(mapping, end);
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 37213d0..1516656 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -123,14 +123,14 @@ static int hfsplus_releasepage(struct page *page, gfp_t mask)
 }
 
 static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
-		const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+		struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = file_inode(file)->i_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				 hfsplus_get_block);
 
 	/*
@@ -139,7 +139,7 @@ static ssize_t hfsplus_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			hfsplus_write_failed(mapping, end);
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index f4aab71..51652aa 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -331,15 +331,14 @@ static sector_t jfs_bmap(struct address_space *mapping, sector_t block)
 }
 
 static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
-	const struct iovec *iov, loff_t offset, unsigned long nr_segs)
+			     struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				 jfs_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, jfs_get_block);
 
 	/*
 	 * In case of error extending write may have instantiated a few
@@ -347,7 +346,7 @@ static ssize_t jfs_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			jfs_write_failed(mapping, end);
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 91ff089..b70fa71 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -112,7 +112,7 @@ static inline int put_dreq(struct nfs_direct_req *dreq)
  * nfs_direct_IO - NFS address space operation for direct I/O
  * @rw: direction (read or write)
  * @iocb: target I/O control block
- * @iov: array of vectors that define I/O buffer
+ * @iter: array of vectors that define I/O buffer
  * @pos: offset in file to begin the operation
  * @nr_segs: size of iovec array
  *
@@ -121,21 +121,24 @@ static inline int put_dreq(struct nfs_direct_req *dreq)
  * shunt off direct read and write requests before the VFS gets them,
  * so this method is only ever called for swap.
  */
-ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_t pos, unsigned long nr_segs)
+ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+		      loff_t pos)
 {
 #ifndef CONFIG_NFS_SWAP
 	dprintk("NFS: nfs_direct_IO (%s) off/no(%Ld/%lu) EINVAL\n",
 			iocb->ki_filp->f_path.dentry->d_name.name,
-			(long long) pos, nr_segs);
+			(long long) pos, iter->nr_segs);
 
 	return -EINVAL;
 #else
+	const struct iovec *iov = iov_iter_iovec(iter);
+
 	VM_BUG_ON(iocb->ki_nbytes != PAGE_SIZE);
 
 	if (rw == READ || rw == KERNEL_READ)
-		return nfs_file_direct_read(iocb, iov, nr_segs, pos,
+		return nfs_file_direct_read(iocb, iov, iter->nr_segs, pos,
 				rw == READ ? true : false);
-	return nfs_file_direct_write(iocb, iov, nr_segs, pos,
+	return nfs_file_direct_write(iocb, iov, iter->nr_segs, pos,
 				rw == WRITE ? true : false);
 #endif /* CONFIG_NFS_SWAP */
 }
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 7e350c5..4a99a24 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -298,8 +298,8 @@ static int nilfs_write_end(struct file *file, struct address_space *mapping,
 }
 
 static ssize_t
-nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
-		loff_t offset, unsigned long nr_segs)
+nilfs_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+		loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -310,7 +310,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 		return 0;
 
 	/* Needs synchronization with the cleaner */
-	size = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+	size = blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				  nilfs_get_block);
 
 	/*
@@ -319,7 +319,7 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	 */
 	if (unlikely((rw & WRITE) && size < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if (end > isize)
 			nilfs_write_failed(mapping, end);
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index f37d3c0..2921dcf 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -616,9 +616,8 @@ static int ocfs2_releasepage(struct page *page, gfp_t wait)
 
 static ssize_t ocfs2_direct_IO(int rw,
 			       struct kiocb *iocb,
-			       const struct iovec *iov,
-			       loff_t offset,
-			       unsigned long nr_segs)
+			       struct iov_iter *iter,
+			       loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file)->i_mapping->host;
@@ -635,8 +634,7 @@ static ssize_t ocfs2_direct_IO(int rw,
 		return 0;
 
 	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
-				    iov, offset, nr_segs,
-				    ocfs2_direct_IO_get_blocks,
+				    iter, offset, ocfs2_direct_IO_get_blocks,
 				    ocfs2_dio_end_io, NULL, 0);
 }
 
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index ad62bdb..6d652af 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -3083,14 +3083,13 @@ static int reiserfs_releasepage(struct page *page, gfp_t unused_gfp_flags)
 /* We thank Mingming Cao for helping us understand in great detail what
    to do in this section of the code. */
 static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
-				  const struct iovec *iov, loff_t offset,
-				  unsigned long nr_segs)
+				  struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset,
 				  reiserfs_get_blocks_direct_io);
 
 	/*
@@ -3099,7 +3098,7 @@ static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
 	 */
 	if (unlikely((rw & WRITE) && ret < 0)) {
 		loff_t isize = i_size_read(inode);
-		loff_t end = offset + iov_length(iov, nr_segs);
+		loff_t end = offset + iov_iter_count(iter);
 
 		if ((end > isize) && inode_newsize_ok(inode, isize) == 0) {
 			truncate_setsize(inode, isize);
diff --git a/fs/udf/file.c b/fs/udf/file.c
index c02a27a..523ed30 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -119,8 +119,7 @@ static int udf_adinicb_write_end(struct file *file,
 }
 
 static ssize_t udf_adinicb_direct_IO(int rw, struct kiocb *iocb,
-				     const struct iovec *iov,
-				     loff_t offset, unsigned long nr_segs)
+				     struct iov_iter *iter, loff_t offset)
 {
 	/* Fallback to buffered I/O. */
 	return 0;
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 062b792..986e11a 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -216,19 +216,17 @@ static int udf_write_begin(struct file *file, struct address_space *mapping,
 	return ret;
 }
 
-static ssize_t udf_direct_IO(int rw, struct kiocb *iocb,
-			     const struct iovec *iov,
-			     loff_t offset, unsigned long nr_segs)
+static ssize_t udf_direct_IO(int rw, struct kiocb *iocb, struct iov_iter *iter,
+			     loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	ssize_t ret;
 
-	ret = blockdev_direct_IO(rw, iocb, inode, iov, offset, nr_segs,
-				  udf_get_block);
+	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, udf_get_block);
 	if (unlikely(ret < 0 && (rw & WRITE)))
-		udf_write_failed(mapping, offset + iov_length(iov, nr_segs));
+		udf_write_failed(mapping, offset + iov_iter_count(iter));
 	return ret;
 }
 
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e51e581..6fad7b5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1413,9 +1413,8 @@ STATIC ssize_t
 xfs_vm_direct_IO(
 	int			rw,
 	struct kiocb		*iocb,
-	const struct iovec	*iov,
-	loff_t			offset,
-	unsigned long		nr_segs)
+	struct iov_iter		*iter,
+	loff_t			offset)
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
@@ -1423,7 +1422,7 @@ xfs_vm_direct_IO(
 	ssize_t			ret;
 
 	if (rw & WRITE) {
-		size_t size = iov_length(iov, nr_segs);
+		size_t size = iov_iter_count(iter);
 
 		/*
 		 * We cannot preallocate a size update transaction here as we
@@ -1435,15 +1434,13 @@ xfs_vm_direct_IO(
 		if (offset + size > XFS_I(inode)->i_d.di_size)
 			ioend->io_isdirect = 1;
 
-		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
-					    offset, nr_segs,
+		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
 					    xfs_get_blocks_direct,
 					    xfs_end_io_direct_write, NULL, 0);
 		if (ret != -EIOCBQUEUED && iocb->private)
 			goto out_destroy_ioend;
 	} else {
-		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
-					    offset, nr_segs,
+		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iter, offset,
 					    xfs_get_blocks_direct,
 					    NULL, NULL, 0);
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e717b47..0753aeb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -463,8 +463,8 @@ struct address_space_operations {
 	void (*invalidatepage) (struct page *, unsigned int, unsigned int);
 	int (*releasepage) (struct page *, gfp_t);
 	void (*freepage)(struct page *);
-	ssize_t (*direct_IO)(int, struct kiocb *, const struct iovec *iov,
-			loff_t offset, unsigned long nr_segs);
+	ssize_t (*direct_IO)(int, struct kiocb *, struct iov_iter *iter,
+			loff_t offset);
 	int (*get_xip_mem)(struct address_space *, pgoff_t, int,
 						void **, unsigned long *);
 	/*
@@ -2567,16 +2567,16 @@ enum {
 void dio_end_io(struct bio *bio, int error);
 
 ssize_t __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset,
-	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
-	dio_submit_t submit_io,	int flags);
+	struct block_device *bdev, struct iov_iter *iter, loff_t offset,
+	get_block_t get_block, dio_iodone_t end_io, dio_submit_t submit_io,
+	int flags);
 
 static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
-		struct inode *inode, const struct iovec *iov, loff_t offset,
-		unsigned long nr_segs, get_block_t get_block)
+		struct inode *inode, struct iov_iter *iter, loff_t offset,
+		get_block_t get_block)
 {
-	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iov,
-				    offset, nr_segs, get_block, NULL, NULL,
+	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev, iter,
+				    offset, get_block, NULL, NULL,
 				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
 #endif
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 3ea4cde..7fb0e41 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -457,8 +457,7 @@ extern int nfs3_removexattr (struct dentry *, const char *name);
 /*
  * linux/fs/nfs/direct.c
  */
-extern ssize_t nfs_direct_IO(int, struct kiocb *, const struct iovec *, loff_t,
-			unsigned long);
+extern ssize_t nfs_direct_IO(int, struct kiocb *, struct iov_iter *, loff_t);
 extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
 			const struct iovec *iov, unsigned long nr_segs,
 			loff_t pos, bool uio);
diff --git a/mm/filemap.c b/mm/filemap.c
index e652863..17ac229 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1429,11 +1429,15 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			goto out; /* skip atime */
 		size = i_size_read(inode);
 		if (pos < size) {
+			size_t bytes = iov_length(iov, nr_segs);
 			retval = filemap_write_and_wait_range(mapping, pos,
-					pos + iov_length(iov, nr_segs) - 1);
+					pos + bytes - 1);
 			if (!retval) {
+				struct iov_iter iter;
+
+				iov_iter_init(&iter, iov, nr_segs, bytes, 0);
 				retval = mapping->a_ops->direct_IO(READ, iocb,
-							iov, pos, nr_segs);
+							&iter, pos);
 			}
 			if (retval > 0) {
 				*ppos = pos + retval;
@@ -2067,6 +2071,7 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 	ssize_t		written;
 	size_t		write_len;
 	pgoff_t		end;
+	struct iov_iter iter;
 
 	if (count != ocount)
 		*nr_segs = iov_shorten((struct iovec *)iov, *nr_segs, count);
@@ -2098,7 +2103,9 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
-	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
+	iov_iter_init(&iter, iov, *nr_segs, write_len, 0);
+
+	written = mapping->a_ops->direct_IO(WRITE, iocb, &iter, pos);
 
 	/*
 	 * Finally, try again to invalidate clean pages which might have been
diff --git a/mm/page_io.c b/mm/page_io.c
index 8c79a47..4f7e599 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -263,6 +263,9 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 			.iov_base = kmap(page),
 			.iov_len  = PAGE_SIZE,
 		};
+		struct iov_iter iter;
+
+		iov_iter_init(&iter, &iov, 1, PAGE_SIZE, 0);
 
 		init_sync_kiocb(&kiocb, swap_file);
 		kiocb.ki_pos = page_file_offset(page);
@@ -270,9 +273,8 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 
 		set_page_writeback(page);
 		unlock_page(page);
-		ret = mapping->a_ops->direct_IO(KERNEL_WRITE,
-						&kiocb, &iov,
-						kiocb.ki_pos, 1);
+		ret = mapping->a_ops->direct_IO(KERNEL_WRITE, &kiocb, &iter,
+						kiocb.ki_pos);
 		kunmap(page);
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
-- 
1.8.4

