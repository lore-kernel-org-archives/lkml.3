Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbaIQWVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 18:21:38 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:48252 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757067AbaIQWVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 18:21:05 -0400
From: Milosz Tanski <milosz@adfin.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [RFC v2 5/5] Check for O_NONBLOCK in all read_iter instances
Date: Wed, 17 Sep 2014 22:20:50 +0000
Message-Id: <5d2507ee57b30987a1bbd495dce565f4ef86fdef.1410983999.git.milosz@adfin.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1410983998.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
 <cover.1410983998.git.milosz@adfin.com>
In-Reply-To: <cover.1410983998.git.milosz@adfin.com>
References: <cover.1410983998.git.milosz@adfin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

Go through filesystem paths and return EAGAIN if there's an operation (like
metadata) that would cause blocking.

Signed-off-by: Milosz Tanski <milosz@adfin.com>
---
 fs/cifs/file.c    |  6 ++++++
 fs/ocfs2/file.c   |  6 ++++++
 fs/pipe.c         |  3 ++-
 fs/read_write.c   | 17 +++++++++++------
 fs/xfs/xfs_file.c |  4 ++++
 mm/shmem.c        |  4 ++++
 6 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 7c018a1..e7169ba 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3005,6 +3005,9 @@ ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
 	struct cifs_readdata *rdata, *tmp;
 	struct list_head rdata_list;
 
+	if (iocb->ki_rwflags & RWF_NONBLOCK)
+		return -EAGAIN;
+
 	len = iov_iter_count(to);
 	if (!len)
 		return 0;
@@ -3123,6 +3126,9 @@ cifs_strict_readv(struct kiocb *iocb, struct iov_iter *to)
 	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
 		return generic_file_read_iter(iocb, to);
 
+	if (iocb->ki_rwflags & RWF_NONBLOCK)
+		return -EAGAIN;
+
 	/*
 	 * We need to hold the sem to be sure nobody modifies lock list
 	 * with a brlock that prevents reading.
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 2930e23..d96f60d 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2473,6 +2473,12 @@ static ssize_t ocfs2_file_read_iter(struct kiocb *iocb,
 			filp->f_path.dentry->d_name.name,
 			to->nr_segs);	/* GRRRRR */
 
+	/*
+	 * No non-blocking reads for ocfs2 for now.  Might be doable with
+	 * non-blocking cluster lock helpers.
+	 */
+	if (iocb->ki_rwflags & RWF_NONBLOCK)
+		return -EAGAIN;
 
 	if (!inode) {
 		ret = -EINVAL;
diff --git a/fs/pipe.c b/fs/pipe.c
index 21981e5..212bf68 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -302,7 +302,8 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 			 */
 			if (ret)
 				break;
-			if (filp->f_flags & O_NONBLOCK) {
+			if ((filp->f_flags & O_NONBLOCK) ||
+			    (iocb->ki_rwflags & RWF_NONBLOCK)) {
 				ret = -EAGAIN;
 				break;
 			}
diff --git a/fs/read_write.c b/fs/read_write.c
index 29b5823..a3efa95 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -833,14 +833,19 @@ static ssize_t do_readv_writev(int type, struct file *file,
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
+		if (type == READ && (flags & RWF_NONBLOCK))
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
index de5368c..cf61271 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -246,6 +246,10 @@ xfs_file_read_iter(
 
 	XFS_STATS_INC(xs_read_calls);
 
+	/* XXX: need a non-blocking iolock helper, shouldn't be too hard */
+	if (iocb->ki_rwflags & RWF_NONBLOCK)
+		return -EAGAIN;
+
 	if (unlikely(file->f_flags & O_DIRECT))
 		ioflags |= XFS_IO_ISDIRECT;
 	if (file->f_mode & FMODE_NOCMTIME)
diff --git a/mm/shmem.c b/mm/shmem.c
index 0e5fb22..ca2cae2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1531,6 +1531,10 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t retval = 0;
 	loff_t *ppos = &iocb->ki_pos;
 
+	/* XXX: should be easily supportable */
+	if (iocb->ki_rwflags & RWF_NONBLOCK)
+		return -EAGAIN;
+
 	/*
 	 * Might this read be for a stacking filesystem?  Then when reading
 	 * holes of a sparse file, we actually need to allocate those pages,
-- 
2.1.0

