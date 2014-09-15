Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbaIOUWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:22:20 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:60884 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbaIOUWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:22:17 -0400
From: Christoph Hellwig <milosz@adfin.com>
X-Google-Original-From: Christoph Hellwig <hch@lst.de>
Date: Mon, 15 Sep 2014 16:22:12 -0400
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 7/7] check for O_NONBLOCK in all read_iter instances
Message-ID: <c31364dee619b2c813c84437561569441fd5fd61.1410810247.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1410810247.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Milosz Tanski <milosz@adfin.com>
---
 fs/ceph/file.c    |    2 ++
 fs/cifs/file.c    |    6 ++++++
 fs/nfs/file.c     |    5 ++++-
 fs/ocfs2/file.c   |    6 ++++++
 fs/pipe.c         |    3 ++-
 fs/read_write.c   |   17 +++++++++++------
 fs/xfs/xfs_file.c |    4 ++++
 mm/shmem.c        |    4 ++++
 8 files changed, 39 insertions(+), 8 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4776257..b62e3a5 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -808,6 +808,8 @@ again:
 	if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
 	    (iocb->ki_filp->f_flags & O_DIRECT) ||
 	    (fi->flags & CEPH_F_SYNC)) {
+		if (flags & O_NONBLOCK)
+			return -EAGAIN;
 
 		dout("aio_sync_read %p %llx.%llx %llu~%u got cap refs on %s\n",
 		     inode, ceph_vinop(inode), iocb->ki_pos, (unsigned)len,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 58aecd7..cda6b9e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3005,6 +3005,9 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to, int flags)
 	struct cifs_readdata *rdata, *tmp;
 	struct list_head rdata_list;
 
+	if (flags & O_NONBLOCK)
+		return -EAGAIN;
+
 	len = iov_iter_count(to);
 	if (!len)
 		return 0;
@@ -3123,6 +3126,9 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to, int flags)
 	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		return generic_file_read_iter(iocb, to, flags);
 
+	if (flags & O_NONBLOCK)
+		return -EAGAIN;
+
 	/*
 	 * We need to hold the sem to be sure nobody modifies lock list
 	 * with a brlock that prevents reading.
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 4072f3a..116bed2 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -170,8 +170,11 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to, int flags)
 	struct inode *inode = file_inode(iocb->ki_filp);
 	ssize_t result;
 
-	if (iocb->ki_filp->f_flags & O_DIRECT)
+	if (iocb->ki_filp->f_flags & O_DIRECT) {
+		if (flags & O_NONBLOCK)
+			return -EAGAIN;
 		return nfs_file_direct_read(iocb, to, iocb->ki_pos, true);
+	}
 
 	dprintk("NFS: read(%pD2, %zu@%lu)\n",
 		iocb->ki_filp,
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 418c8a3..a8f7def 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2474,6 +2474,12 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 			filp->f_path.dentry->d_name.name,
 			to->nr_segs);	/* GRRRRR */
 
+	/*
+	 * No non-blocking reads for ocfs2 for now.  Might be doable with
+	 * non-blocking cluster lock helpers.
+	 */
+	if (flags & O_NONBLOCK)
+		return -EAGAIN;
 
 	if (!inode) {
 		ret = -EINVAL;
diff --git a/fs/pipe.c b/fs/pipe.c
index d2510ab..74d6749 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -302,7 +302,8 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to, int flags)
 			 */
 			if (ret)
 				break;
-			if (filp->f_flags & O_NONBLOCK) {
+			if ((filp->f_flags & O_NONBLOCK) ||
+			    (flags & O_NONBLOCK)) {
 				ret = -EAGAIN;
 				break;
 			}
diff --git a/fs/read_write.c b/fs/read_write.c
index 233ea98..4a5f82c 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -832,14 +832,19 @@ static ssize_t do_readv_writev(int type, struct file *file,
 		file_start_write(file);
 	}
 
-	if (iter_fn)
+	if (iter_fn) {
 		ret = do_iter_readv_writev(file, type, iov, nr_segs, tot_len,
 						pos, iter_fn, flags);
-	else if (fnv)
-		ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
-						pos, fnv);
-	else
-		ret = do_loop_readv_writev(file, iov, nr_segs, pos, fn);
+	} else {
+		if (type == READ && (flags & O_NONBLOCK))
+			return -EAGAIN;
+
+		if (fnv)
+			ret = do_sync_readv_writev(file, iov, nr_segs, tot_len,
+							pos, fnv);
+		else
+			ret = do_loop_readv_writev(file, iov, nr_segs, pos, fn);
+	}
 
 	if (type != READ)
 		file_end_write(file);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 68847008..0252a31 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -247,6 +247,10 @@ xfs_file_read_iter(
 
 	XFS_STATS_INC(xs_read_calls);
 
+	/* XXX: need a non-blocking iolock helper, shouldn't be too hard */
+	if (flags & O_NONBLOCK)
+		return -EAGAIN;
+
 	if (unlikely(file->f_flags & O_DIRECT))
 		ioflags |= XFS_IO_ISDIRECT;
 	if (file->f_mode & FMODE_NOCMTIME)
diff --git a/mm/shmem.c b/mm/shmem.c
index 24c73bce..f5ad85f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1531,6 +1531,10 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to, int
 	ssize_t retval = 0;
 	loff_t *ppos = &iocb->ki_pos;
 
+	/* XXX: should be easily supportable */
+	if (flags & O_NONBLOCK)
+		return -EAGAIN;
+
 	/*
 	 * Might this read be for a stacking filesystem?  Then when reading
 	 * holes of a sparse file, we actually need to allocate those pages,
-- 
1.7.9.5

