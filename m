Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbaHNPvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 11:51:23 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:38561 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbaHNPvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 11:51:19 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>, Benjamin LaHaise <bcrl@kvack.org>,
        Christoph Hellwig <hch@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v1 1/9] aio: add aio_kernel_() interface
Date: Thu, 14 Aug 2014 23:50:32 +0800
Message-Id: <1408031441-31156-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
References: <1408031441-31156-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Kleikamp <dave.kleikamp@oracle.com>

This adds an interface that lets kernel callers submit aio iocbs without
going through the user space syscalls.  This lets kernel callers avoid
the management limits and overhead of the context.  It will also let us
integrate aio operations with other kernel apis that the user space
interface doesn't have access to.

This patch is based on Dave's posts in below links:

	https://lkml.org/lkml/2013/10/16/365
	https://groups.google.com/forum/#!topic/linux.kernel/l7mogGJZoKQ

And most of the patch is from Dave's directly, and follows potential
users of this APIs:
	- Loop block driver for avoiding double cache, and improving
	  throughput
	- all kinds of kernel target(SCSI, USB, ...) which need to access
	file efficiently
	- all kinds of socket users if socket aio is mature

Cc: Zach Brown <zab@zabbo.net>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-aio@kvack.org (open list:AIO)
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/aio.c            |  121 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/aio.h |   15 ++++++-
 2 files changed, 135 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index ae63587..6437cb8 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -941,6 +941,9 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 		iocb->ki_ctx = ERR_PTR(-EXDEV);
 		wake_up_process(iocb->ki_obj.tsk);
 		return;
+	} else if (is_kernel_kiocb(iocb)) {
+		iocb->ki_obj.complete(iocb->ki_user_data, res);
+		return;
 	}
 
 	if (iocb->ki_list.next) {
@@ -1387,6 +1390,124 @@ rw_common:
 	return 0;
 }
 
+/*
+ * This allocates an iocb that will be used to submit and track completion of
+ * an IO that is issued from kernel space.
+ *
+ * The caller is expected to call the appropriate aio_kernel_init_() functions
+ * and then call aio_kernel_submit().  From that point forward progress is
+ * guaranteed by the file system aio method.  Eventually the caller's
+ * completion callback will be called.
+ *
+ * These iocbs are special.  They don't have a context, we don't limit the
+ * number pending, and they can't be canceled.
+ */
+struct kiocb *aio_kernel_alloc(gfp_t gfp, unsigned extra)
+{
+	return kzalloc(sizeof(struct kiocb) + extra, gfp);
+}
+EXPORT_SYMBOL_GPL(aio_kernel_alloc);
+
+void aio_kernel_free(struct kiocb *iocb)
+{
+	kfree(iocb);
+}
+EXPORT_SYMBOL_GPL(aio_kernel_free);
+
+/*
+ * ptr and count can be a buff and bytes or an iov and segs.
+ */
+void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp,
+			size_t nr, loff_t off,
+			void (*complete)(u64 user_data, long res),
+			u64 user_data)
+{
+	iocb->ki_filp = filp;
+	iocb->ki_nbytes = nr;
+	iocb->ki_pos = off;
+	iocb->ki_ctx = (void *)-1;
+
+	iocb->ki_obj.complete = complete;
+	iocb->ki_user_data = user_data;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_init_rw);
+
+static ssize_t aio_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t ret;
+
+	if (unlikely(!(file->f_mode & FMODE_READ)))
+		return -EBADF;
+
+	ret = security_file_permission(file, MAY_READ);
+	if (unlikely(ret))
+		return ret;
+
+	if (!file->f_op->read_iter)
+		return -EINVAL;
+
+	return file->f_op->read_iter(iocb, iter);
+}
+
+static ssize_t aio_write_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t ret;
+
+	if (unlikely(!(file->f_mode & FMODE_WRITE)))
+		return -EBADF;
+
+	ret = security_file_permission(file, MAY_WRITE);
+	if (unlikely(ret))
+		return ret;
+
+	if (!file->f_op->write_iter)
+		return -EINVAL;
+
+	file_start_write(file);
+	ret = file->f_op->write_iter(iocb, iter);
+	file_end_write(file);
+
+	return ret;
+}
+
+/*
+ * The iocb is our responsibility once this is called.  The caller must not
+ * reference it.
+ *
+ * Callers must be prepared for their iocb completion callback to be called the
+ * moment they enter this function.  The completion callback may be called from
+ * any context.
+ *
+ * Returns: 0: the iocb completion callback will be called with the op result
+ * negative errno: the operation was not submitted and the iocb was freed
+ */
+int aio_kernel_submit(struct kiocb *iocb, bool is_write,
+		      struct iov_iter *iter)
+{
+	int ret = -EINVAL;
+
+	if (WARN_ON(!is_kernel_kiocb(iocb) || !iocb->ki_obj.complete
+			|| !iocb->ki_filp || !(iter->type & ITER_BVEC)))
+		return ret;
+
+	if (is_write)
+		ret = aio_write_iter(iocb, iter);
+	else
+		ret = aio_read_iter(iocb, iter);
+
+	/*
+	 * use same policy with userspace aio, req may have been
+	 * completed already, so release it by aio completion.
+	 */
+	if (ret != -EIOCBQUEUED)
+		iocb->ki_obj.complete(iocb->ki_user_data, ret);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_submit);
+
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, bool compat)
 {
diff --git a/include/linux/aio.h b/include/linux/aio.h
index d9c92da..4c27d42 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -31,13 +31,15 @@ typedef int (kiocb_cancel_fn)(struct kiocb *);
 
 struct kiocb {
 	struct file		*ki_filp;
-	struct kioctx		*ki_ctx;	/* NULL for sync ops */
+	struct kioctx		*ki_ctx;	/* NULL for sync ops,
+						 * -1 for kernel caller */
 	kiocb_cancel_fn		*ki_cancel;
 	void			*private;
 
 	union {
 		void __user		*user;
 		struct task_struct	*tsk;
+		void			(*complete)(u64 user_data, long res);
 	} ki_obj;
 
 	__u64			ki_user_data;	/* user's data for completion */
@@ -59,6 +61,11 @@ static inline bool is_sync_kiocb(struct kiocb *kiocb)
 	return kiocb->ki_ctx == NULL;
 }
 
+static inline bool is_kernel_kiocb(struct kiocb *kiocb)
+{
+	return kiocb->ki_ctx == (void *)-1;
+}
+
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 {
 	*kiocb = (struct kiocb) {
@@ -77,6 +84,12 @@ extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
 void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel);
+struct kiocb *aio_kernel_alloc(gfp_t gfp, unsigned extra);
+void aio_kernel_free(struct kiocb *iocb);
+void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp, size_t nr,
+			loff_t off, void (*complete)(u64 user_data, long res),
+			u64 user_data);
+int aio_kernel_submit(struct kiocb *iocb, bool is_write, struct iov_iter *iter);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline void aio_complete(struct kiocb *iocb, long res, long res2) { }
-- 
1.7.9.5

