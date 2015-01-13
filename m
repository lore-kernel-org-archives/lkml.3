Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbbAMPpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:45:43 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59726 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbbAMPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:45:40 -0500
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Zach Brown <zab@zabbo.net>,
        Christoph Hellwig <hch@infradead.org>,
        Maxim Patlasov <mpatlasov@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org (open list:AIO), Ming Lei <ming.lei@canonical.com>
Subject: [PATCH v2 1/4] aio: add aio_kernel_() interface
Date: Tue, 13 Jan 2015 23:44:45 +0800
Message-Id: <1421163888-21452-2-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
References: <1421163888-21452-1-git-send-email-ming.lei@canonical.com>
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

Most of the patch is from Dave's directly, this version tries to
not couple kernel aio with linux-aio implementation.

Follows potential users of these APIs:

	- Loop block driver for avoiding double cache, and improving throughput
	- All kinds of kernel target(SCSI, USB, ...) which need to access
	file efficiently, and has the double cache problem too
	- socket users may benifit from the APIs too

Cc: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-aio@kvack.org (open list:AIO)
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 fs/aio.c            |  121 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/aio.h |   17 +++++++-
 2 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 1b7893e..d044387 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1044,6 +1044,9 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 		iocb->ki_ctx = ERR_PTR(-EXDEV);
 		wake_up_process(iocb->ki_obj.tsk);
 		return;
+	} else if (is_kernel_kiocb(iocb)) {
+		iocb->ki_obj.complete(iocb->ki_user_data, res);
+		return;
 	}
 
 	if (iocb->ki_list.next) {
@@ -1503,6 +1506,124 @@ rw_common:
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
+struct kiocb *aio_kernel_alloc(gfp_t gfp)
+{
+	return kzalloc(sizeof(struct kiocb), gfp);
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
+	iocb->ki_ctx = KERNEL_AIO_CTX;
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
index d9c92da..7b4764a 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -27,17 +27,21 @@ struct kiocb;
  */
 #define KIOCB_CANCELLED		((void *) (~0ULL))
 
+#define KERNEL_AIO_CTX		((void *) -1)
+
 typedef int (kiocb_cancel_fn)(struct kiocb *);
 
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
@@ -59,6 +63,11 @@ static inline bool is_sync_kiocb(struct kiocb *kiocb)
 	return kiocb->ki_ctx == NULL;
 }
 
+static inline bool is_kernel_kiocb(struct kiocb *kiocb)
+{
+	return kiocb->ki_ctx == KERNEL_AIO_CTX;
+}
+
 static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 {
 	*kiocb = (struct kiocb) {
@@ -77,6 +86,12 @@ extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
 void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel);
+struct kiocb *aio_kernel_alloc(gfp_t gfp);
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

