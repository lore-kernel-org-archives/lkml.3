Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab3ENBYH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:24:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61110 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab3ENBTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:16 -0400
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
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 09/21] aio: Kill unneeded kiocb members
Date: Mon, 13 May 2013 18:18:46 -0700
Message-Id: <1368494338-7069-10-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old aio retry infrastucture needed to save the various arguments to
to aio operations. But with the retry infrastructure gone, we can trim
struct kiocb quite a bit.

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
Cc: Theodore Ts'o <tytso@mit.edu>
---
 fs/aio.c            | 69 +++++++++++++++++++++++++++++++----------------------
 include/linux/aio.h | 11 ++-------
 2 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 73ec062..280b014 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -637,8 +637,6 @@ static void kiocb_free(struct kiocb *req)
 		eventfd_ctx_put(req->ki_eventfd);
 	if (req->ki_dtor)
 		req->ki_dtor(req);
-	if (req->ki_iovec != &req->ki_inline_vec)
-		kfree(req->ki_iovec);
 	kmem_cache_free(kiocb_cachep, req);
 }
 
@@ -968,24 +966,26 @@ SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 typedef ssize_t (aio_rw_op)(struct kiocb *, const struct iovec *,
 			    unsigned long, loff_t);
 
-static ssize_t aio_setup_vectored_rw(int rw, struct kiocb *kiocb, bool compat)
+static ssize_t aio_setup_vectored_rw(struct kiocb *kiocb,
+				     int rw, char __user *buf,
+				     unsigned long *nr_segs,
+				     struct iovec **iovec,
+				     bool compat)
 {
 	ssize_t ret;
 
-	kiocb->ki_nr_segs = kiocb->ki_nbytes;
+	*nr_segs = kiocb->ki_nbytes;
 
 #ifdef CONFIG_COMPAT
 	if (compat)
 		ret = compat_rw_copy_check_uvector(rw,
-				(struct compat_iovec __user *)kiocb->ki_buf,
-				kiocb->ki_nr_segs, 1, &kiocb->ki_inline_vec,
-				&kiocb->ki_iovec);
+				(struct compat_iovec __user *)buf,
+				*nr_segs, 1, *iovec, iovec);
 	else
 #endif
 		ret = rw_copy_check_uvector(rw,
-				(struct iovec __user *)kiocb->ki_buf,
-				kiocb->ki_nr_segs, 1, &kiocb->ki_inline_vec,
-				&kiocb->ki_iovec);
+				(struct iovec __user *)buf,
+				*nr_segs, 1, *iovec, iovec);
 	if (ret < 0)
 		return ret;
 
@@ -994,15 +994,17 @@ static ssize_t aio_setup_vectored_rw(int rw, struct kiocb *kiocb, bool compat)
 	return 0;
 }
 
-static ssize_t aio_setup_single_vector(int rw, struct kiocb *kiocb)
+static ssize_t aio_setup_single_vector(struct kiocb *kiocb,
+				       int rw, char __user *buf,
+				       unsigned long *nr_segs,
+				       struct iovec *iovec)
 {
-	if (unlikely(!access_ok(!rw, kiocb->ki_buf, kiocb->ki_nbytes)))
+	if (unlikely(!access_ok(!rw, buf, kiocb->ki_nbytes)))
 		return -EFAULT;
 
-	kiocb->ki_iovec = &kiocb->ki_inline_vec;
-	kiocb->ki_iovec->iov_base = kiocb->ki_buf;
-	kiocb->ki_iovec->iov_len = kiocb->ki_nbytes;
-	kiocb->ki_nr_segs = 1;
+	iovec->iov_base = buf;
+	iovec->iov_len = kiocb->ki_nbytes;
+	*nr_segs = 1;
 	return 0;
 }
 
@@ -1011,15 +1013,18 @@ static ssize_t aio_setup_single_vector(int rw, struct kiocb *kiocb)
  *	Performs the initial checks and aio retry method
  *	setup for the kiocb at the time of io submission.
  */
-static ssize_t aio_run_iocb(struct kiocb *req, bool compat)
+static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
+			    char __user *buf, bool compat)
 {
 	struct file *file = req->ki_filp;
 	ssize_t ret;
+	unsigned long nr_segs;
 	int rw;
 	fmode_t mode;
 	aio_rw_op *rw_op;
+	struct iovec inline_vec, *iovec = &inline_vec;
 
-	switch (req->ki_opcode) {
+	switch (opcode) {
 	case IOCB_CMD_PREAD:
 	case IOCB_CMD_PREADV:
 		mode	= FMODE_READ;
@@ -1040,16 +1045,21 @@ rw_common:
 		if (!rw_op)
 			return -EINVAL;
 
-		ret = (req->ki_opcode == IOCB_CMD_PREADV ||
-		       req->ki_opcode == IOCB_CMD_PWRITEV)
-			? aio_setup_vectored_rw(rw, req, compat)
-			: aio_setup_single_vector(rw, req);
+		ret = (opcode == IOCB_CMD_PREADV ||
+		       opcode == IOCB_CMD_PWRITEV)
+			? aio_setup_vectored_rw(req, rw, buf, &nr_segs,
+						&iovec, compat)
+			: aio_setup_single_vector(req, rw, buf, &nr_segs,
+						  iovec);
 		if (ret)
 			return ret;
 
 		ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
-		if (ret < 0)
+		if (ret < 0) {
+			if (iovec != &inline_vec)
+				kfree(iovec);
 			return ret;
+		}
 
 		req->ki_nbytes = ret;
 
@@ -1063,8 +1073,7 @@ rw_common:
 		if (rw == WRITE)
 			file_start_write(file);
 
-		ret = rw_op(req, req->ki_iovec,
-			    req->ki_nr_segs, req->ki_pos);
+		ret = rw_op(req, iovec, nr_segs, req->ki_pos);
 
 		if (rw == WRITE)
 			file_end_write(file);
@@ -1089,6 +1098,9 @@ rw_common:
 		return -EINVAL;
 	}
 
+	if (iovec != &inline_vec)
+		kfree(iovec);
+
 	if (ret != -EIOCBQUEUED) {
 		/*
 		 * There's no easy way to restart the syscall since other AIO's
@@ -1160,12 +1172,11 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_obj.user = user_iocb;
 	req->ki_user_data = iocb->aio_data;
 	req->ki_pos = iocb->aio_offset;
-
-	req->ki_buf = (char __user *)(unsigned long)iocb->aio_buf;
 	req->ki_nbytes = iocb->aio_nbytes;
-	req->ki_opcode = iocb->aio_lio_opcode;
 
-	ret = aio_run_iocb(req, compat);
+	ret = aio_run_iocb(req, iocb->aio_lio_opcode,
+			   (char __user *)(unsigned long)iocb->aio_buf,
+			   compat);
 	if (ret)
 		goto out_put_req;
 
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 7bb766e..b570472 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -36,6 +36,7 @@ struct kiocb {
 	struct kioctx		*ki_ctx;	/* NULL for sync ops */
 	kiocb_cancel_fn		*ki_cancel;
 	void			(*ki_dtor)(struct kiocb *);
+	void			*private;
 
 	union {
 		void __user		*user;
@@ -44,15 +45,7 @@ struct kiocb {
 
 	__u64			ki_user_data;	/* user's data for completion */
 	loff_t			ki_pos;
-
-	void			*private;
-	/* State that we remember to be able to restart/retry  */
-	unsigned short		ki_opcode;
-	size_t			ki_nbytes; 	/* copy of iocb->aio_nbytes */
-	char 			__user *ki_buf;	/* remaining iocb->aio_buf */
-	struct iovec		ki_inline_vec;	/* inline vector */
- 	struct iovec		*ki_iovec;
- 	unsigned long		ki_nr_segs;
+	size_t			ki_nbytes;	/* copy of iocb->aio_nbytes */
 
 	struct list_head	ki_list;	/* the aio core uses this
 						 * for cancellation */
-- 
1.8.2.1

