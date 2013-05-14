Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab3ENBTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:19:21 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52888 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab3ENBTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:15 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>
Subject: [PATCH 08/21] aio: Kill aio_rw_vect_retry()
Date: Mon, 13 May 2013 18:18:45 -0700
Message-Id: <1368494338-7069-9-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code doesn't serve any purpose anymore, since the aio retry
infrastructure has been removed.

This change should be safe because aio_read/write are also used for
synchronous IO, and called from do_sync_read()/do_sync_write() - and
there's no looping done in the sync case (the read and write syscalls).

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
---
 drivers/staging/android/logger.c |  2 +-
 drivers/usb/gadget/inode.c       |  6 +--
 fs/aio.c                         | 91 ++++++++--------------------------------
 fs/block_dev.c                   |  2 +-
 fs/nfs/direct.c                  |  1 -
 fs/ocfs2/file.c                  |  6 +--
 fs/read_write.c                  |  3 --
 fs/udf/file.c                    |  2 +-
 include/linux/aio.h              |  2 -
 mm/page_io.c                     |  1 -
 net/socket.c                     |  2 +-
 11 files changed, 28 insertions(+), 90 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index b040200..f9dbebe 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -481,7 +481,7 @@ static ssize_t logger_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	header.sec = now.tv_sec;
 	header.nsec = now.tv_nsec;
 	header.euid = current_euid();
-	header.len = min_t(size_t, iocb->ki_left, LOGGER_ENTRY_MAX_PAYLOAD);
+	header.len = min_t(size_t, iocb->ki_nbytes, LOGGER_ENTRY_MAX_PAYLOAD);
 	header.hdr_size = sizeof(struct logger_entry);
 
 	/* null writes succeed, return zero */
diff --git a/drivers/usb/gadget/inode.c b/drivers/usb/gadget/inode.c
index e02c1e0..f255ad7 100644
--- a/drivers/usb/gadget/inode.c
+++ b/drivers/usb/gadget/inode.c
@@ -708,11 +708,11 @@ ep_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	if (unlikely(usb_endpoint_dir_in(&epdata->desc)))
 		return -EINVAL;
 
-	buf = kmalloc(iocb->ki_left, GFP_KERNEL);
+	buf = kmalloc(iocb->ki_nbytes, GFP_KERNEL);
 	if (unlikely(!buf))
 		return -ENOMEM;
 
-	return ep_aio_rwtail(iocb, buf, iocb->ki_left, epdata, iov, nr_segs);
+	return ep_aio_rwtail(iocb, buf, iocb->ki_nbytes, epdata, iov, nr_segs);
 }
 
 static ssize_t
@@ -727,7 +727,7 @@ ep_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (unlikely(!usb_endpoint_dir_in(&epdata->desc)))
 		return -EINVAL;
 
-	buf = kmalloc(iocb->ki_left, GFP_KERNEL);
+	buf = kmalloc(iocb->ki_nbytes, GFP_KERNEL);
 	if (unlikely(!buf))
 		return -ENOMEM;
 
diff --git a/fs/aio.c b/fs/aio.c
index 2c9a5ac..73ec062 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -621,7 +621,7 @@ static inline struct kiocb *aio_get_req(struct kioctx *ctx)
 	if (unlikely(!req))
 		goto out_put;
 
-	atomic_set(&req->ki_users, 2);
+	atomic_set(&req->ki_users, 1);
 	req->ki_ctx = ctx;
 	return req;
 out_put:
@@ -965,75 +965,9 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 	return -EINVAL;
 }
 
-static void aio_advance_iovec(struct kiocb *iocb, ssize_t ret)
-{
-	struct iovec *iov = &iocb->ki_iovec[iocb->ki_cur_seg];
-
-	BUG_ON(ret <= 0);
-
-	while (iocb->ki_cur_seg < iocb->ki_nr_segs && ret > 0) {
-		ssize_t this = min((ssize_t)iov->iov_len, ret);
-		iov->iov_base += this;
-		iov->iov_len -= this;
-		iocb->ki_left -= this;
-		ret -= this;
-		if (iov->iov_len == 0) {
-			iocb->ki_cur_seg++;
-			iov++;
-		}
-	}
-
-	/* the caller should not have done more io than what fit in
-	 * the remaining iovecs */
-	BUG_ON(ret > 0 && iocb->ki_left == 0);
-}
-
 typedef ssize_t (aio_rw_op)(struct kiocb *, const struct iovec *,
 			    unsigned long, loff_t);
 
-static ssize_t aio_rw_vect_retry(struct kiocb *iocb, int rw, aio_rw_op *rw_op)
-{
-	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	ssize_t ret = 0;
-
-	/* This matches the pread()/pwrite() logic */
-	if (iocb->ki_pos < 0)
-		return -EINVAL;
-
-	if (rw == WRITE)
-		file_start_write(file);
-	do {
-		ret = rw_op(iocb, &iocb->ki_iovec[iocb->ki_cur_seg],
-			    iocb->ki_nr_segs - iocb->ki_cur_seg,
-			    iocb->ki_pos);
-		if (ret > 0)
-			aio_advance_iovec(iocb, ret);
-
-	/* retry all partial writes.  retry partial reads as long as its a
-	 * regular file. */
-	} while (ret > 0 && iocb->ki_left > 0 &&
-		 (rw == WRITE ||
-		  (!S_ISFIFO(inode->i_mode) && !S_ISSOCK(inode->i_mode))));
-	if (rw == WRITE)
-		file_end_write(file);
-
-	/* This means we must have transferred all that we could */
-	/* No need to retry anymore */
-	if ((ret == 0) || (iocb->ki_left == 0))
-		ret = iocb->ki_nbytes - iocb->ki_left;
-
-	/* If we managed to write some out we return that, rather than
-	 * the eventual error. */
-	if (rw == WRITE
-	    && ret < 0 && ret != -EIOCBQUEUED
-	    && iocb->ki_nbytes - iocb->ki_left)
-		ret = iocb->ki_nbytes - iocb->ki_left;
-
-	return ret;
-}
-
 static ssize_t aio_setup_vectored_rw(int rw, struct kiocb *kiocb, bool compat)
 {
 	ssize_t ret;
@@ -1118,9 +1052,22 @@ rw_common:
 			return ret;
 
 		req->ki_nbytes = ret;
-		req->ki_left = ret;
 
-		ret = aio_rw_vect_retry(req, rw, rw_op);
+		/* XXX: move/kill - rw_verify_area()? */
+		/* This matches the pread()/pwrite() logic */
+		if (req->ki_pos < 0) {
+			ret = -EINVAL;
+			break;
+		}
+
+		if (rw == WRITE)
+			file_start_write(file);
+
+		ret = rw_op(req, req->ki_iovec,
+			    req->ki_nr_segs, req->ki_pos);
+
+		if (rw == WRITE)
+			file_end_write(file);
 		break;
 
 	case IOCB_CMD_FDSYNC:
@@ -1215,19 +1162,17 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_pos = iocb->aio_offset;
 
 	req->ki_buf = (char __user *)(unsigned long)iocb->aio_buf;
-	req->ki_left = req->ki_nbytes = iocb->aio_nbytes;
+	req->ki_nbytes = iocb->aio_nbytes;
 	req->ki_opcode = iocb->aio_lio_opcode;
 
 	ret = aio_run_iocb(req, compat);
 	if (ret)
 		goto out_put_req;
 
-	aio_put_req(req);	/* drop extra ref to req */
 	return 0;
 out_put_req:
 	put_reqs_available(ctx, 1);
-	aio_put_req(req);	/* drop extra ref to req */
-	aio_put_req(req);	/* drop i/o ref to req */
+	aio_put_req(req);
 	return ret;
 }
 
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2091db8..2964b15 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1556,7 +1556,7 @@ static ssize_t blkdev_aio_read(struct kiocb *iocb, const struct iovec *iov,
 		return 0;
 
 	size -= pos;
-	if (size < iocb->ki_left)
+	if (size < iocb->ki_nbytes)
 		nr_segs = iov_shorten((struct iovec *)iov, nr_segs, size);
 	return generic_file_aio_read(iocb, iov, nr_segs, pos);
 }
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 0bd7a55..91ff089 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -130,7 +130,6 @@ ssize_t nfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov, loff_
 
 	return -EINVAL;
 #else
-	VM_BUG_ON(iocb->ki_left != PAGE_SIZE);
 	VM_BUG_ON(iocb->ki_nbytes != PAGE_SIZE);
 
 	if (rw == READ || rw == KERNEL_READ)
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 8a7509f..c85ad15 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2245,7 +2245,7 @@ static ssize_t ocfs2_file_aio_write(struct kiocb *iocb,
 		file->f_path.dentry->d_name.name,
 		(unsigned int)nr_segs);
 
-	if (iocb->ki_left == 0)
+	if (iocb->ki_nbytes == 0)
 		return 0;
 
 	appending = file->f_flags & O_APPEND ? 1 : 0;
@@ -2296,7 +2296,7 @@ relock:
 
 	can_do_direct = direct_io;
 	ret = ocfs2_prepare_inode_for_write(file, ppos,
-					    iocb->ki_left, appending,
+					    iocb->ki_nbytes, appending,
 					    &can_do_direct, &has_refcount);
 	if (ret < 0) {
 		mlog_errno(ret);
@@ -2304,7 +2304,7 @@ relock:
 	}
 
 	if (direct_io && !is_sync_kiocb(iocb))
-		unaligned_dio = ocfs2_is_io_unaligned(inode, iocb->ki_left,
+		unaligned_dio = ocfs2_is_io_unaligned(inode, iocb->ki_nbytes,
 						      *ppos);
 
 	/*
diff --git a/fs/read_write.c b/fs/read_write.c
index 0343000..421cee4 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -338,7 +338,6 @@ ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *pp
 
 	init_sync_kiocb(&kiocb, filp);
 	kiocb.ki_pos = *ppos;
-	kiocb.ki_left = len;
 	kiocb.ki_nbytes = len;
 
 	ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
@@ -388,7 +387,6 @@ ssize_t do_sync_write(struct file *filp, const char __user *buf, size_t len, lof
 
 	init_sync_kiocb(&kiocb, filp);
 	kiocb.ki_pos = *ppos;
-	kiocb.ki_left = len;
 	kiocb.ki_nbytes = len;
 
 	ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
@@ -568,7 +566,6 @@ static ssize_t do_sync_readv_writev(struct file *filp, const struct iovec *iov,
 
 	init_sync_kiocb(&kiocb, filp);
 	kiocb.ki_pos = *ppos;
-	kiocb.ki_left = len;
 	kiocb.ki_nbytes = len;
 
 	ret = fn(&kiocb, iov, nr_segs, kiocb.ki_pos);
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 29569dd..c02a27a 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -141,7 +141,7 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	int err, pos;
-	size_t count = iocb->ki_left;
+	size_t count = iocb->ki_nbytes;
 	struct udf_inode_info *iinfo = UDF_I(inode);
 
 	down_write(&iinfo->i_data_sem);
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 8c8dd1d..7bb766e 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -50,11 +50,9 @@ struct kiocb {
 	unsigned short		ki_opcode;
 	size_t			ki_nbytes; 	/* copy of iocb->aio_nbytes */
 	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
-	size_t			ki_left; 	/* remaining bytes */
 	struct iovec		ki_inline_vec;	/* inline vector */
  	struct iovec		*ki_iovec;
  	unsigned long		ki_nr_segs;
- 	unsigned long		ki_cur_seg;
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
diff --git a/mm/page_io.c b/mm/page_io.c
index a8a3ef4..3db0f5f 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -220,7 +220,6 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 
 		init_sync_kiocb(&kiocb, swap_file);
 		kiocb.ki_pos = page_file_offset(page);
-		kiocb.ki_left = PAGE_SIZE;
 		kiocb.ki_nbytes = PAGE_SIZE;
 
 		set_page_writeback(page);
diff --git a/net/socket.c b/net/socket.c
index 6b94633..bfe9fab 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -925,7 +925,7 @@ static ssize_t sock_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	if (pos != 0)
 		return -ESPIPE;
 
-	if (iocb->ki_left == 0)	/* Match SYS5 behaviour */
+	if (iocb->ki_nbytes == 0)	/* Match SYS5 behaviour */
 		return 0;
 
 
-- 
1.8.2.1

