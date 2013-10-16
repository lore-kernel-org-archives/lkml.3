Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895Ab3JPORN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:17:13 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26553 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934545Ab3JPOFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:05:47 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org
Subject: [PATCH V9 14/33] aio: add aio_kernel_() interface
Date: Wed, 16 Oct 2013 09:04:27 -0500
Message-Id: <1381932286-14978-15-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds an interface that lets kernel callers submit aio iocbs without
going through the user space syscalls.  This lets kernel callers avoid
the management limits and overhead of the context.  It will also let us
integrate aio operations with other kernel apis that the user space
interface doesn't have access to.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-aio@kvack.org
---
 fs/aio.c            | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/aio.h | 17 +++++++++++-
 2 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/fs/aio.c b/fs/aio.c
index 067e3d3..ae40141 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -877,6 +877,10 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 		iocb->ki_ctx = ERR_PTR(-EXDEV);
 		wake_up_process(iocb->ki_obj.tsk);
 		return;
+	} else if (is_kernel_kiocb(iocb)) {
+		iocb->ki_obj.complete(iocb->ki_user_data, res);
+		aio_kernel_free(iocb);
+		return;
 	}
 
 	/*
@@ -1303,6 +1307,80 @@ rw_common:
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
+			size_t nr, loff_t off)
+{
+	iocb->ki_filp = filp;
+	iocb->ki_nbytes = nr;
+	iocb->ki_pos = off;
+	iocb->ki_ctx = (void *)-1;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_init_rw);
+
+void aio_kernel_init_callback(struct kiocb *iocb,
+			      void (*complete)(u64 user_data, long res),
+			      u64 user_data)
+{
+	iocb->ki_obj.complete = complete;
+	iocb->ki_user_data = user_data;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_init_callback);
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
+int aio_kernel_submit(struct kiocb *iocb, unsigned op, void *ptr)
+{
+	int ret;
+
+	BUG_ON(!is_kernel_kiocb(iocb));
+	BUG_ON(!iocb->ki_obj.complete);
+	BUG_ON(!iocb->ki_filp);
+
+	ret = aio_run_iocb(iocb, op, ptr, 0);
+
+	if (ret)
+		aio_kernel_free(iocb);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_submit);
+
 static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 			 struct iocb *iocb, bool compat)
 {
diff --git a/include/linux/aio.h b/include/linux/aio.h
index d9c92da..734d9e6 100644
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
@@ -77,6 +84,14 @@ extern void exit_aio(struct mm_struct *mm);
 extern long do_io_submit(aio_context_t ctx_id, long nr,
 			 struct iocb __user *__user *iocbpp, bool compat);
 void kiocb_set_cancel_fn(struct kiocb *req, kiocb_cancel_fn *cancel);
+struct kiocb *aio_kernel_alloc(gfp_t gfp);
+void aio_kernel_free(struct kiocb *iocb);
+void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp, size_t nr,
+			loff_t off);
+void aio_kernel_init_callback(struct kiocb *iocb,
+			      void (*complete)(u64 user_data, long res),
+			      u64 user_data);
+int aio_kernel_submit(struct kiocb *iocb, unsigned op, void *ptr);
 #else
 static inline ssize_t wait_on_sync_kiocb(struct kiocb *iocb) { return 0; }
 static inline void aio_complete(struct kiocb *iocb, long res, long res2) { }
-- 
1.8.4

