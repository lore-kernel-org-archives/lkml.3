Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab3GYSKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:10:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43367 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879Ab3GYRv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:51:56 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>
Subject: [PATCH V8 15/33] aio: add aio support for iov_iter arguments
Date: Thu, 25 Jul 2013 12:50:41 -0500
Message-Id: <1374774659-13121-16-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds iocb cmds which specify that memory is held in iov_iter
structures.  This lets kernel callers specify memory that can be
expressed in an iov_iter, which includes pages in bio_vec arrays.

Only kernel callers can provide an iov_iter so it doesn't make a lot of
sense to expose the IOCB_CMD values for this as part of the user space
ABI.

But kernel callers should also be able to perform the usual aio
operations which suggests using the the existing operation namespace and
support code.

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Zach Brown <zab@zabbo.net>
---
 fs/aio.c                     | 67 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/aio.h          |  3 ++
 include/uapi/linux/aio_abi.h |  2 ++
 3 files changed, 72 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index c65ba13..0da82c0 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -991,6 +991,48 @@ static ssize_t aio_setup_single_vector(int rw, struct kiocb *kiocb)
 	return 0;
 }
 
+static ssize_t aio_read_iter(struct kiocb *iocb)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t ret;
+
+	if (unlikely(!is_kernel_kiocb(iocb)))
+		return -EINVAL;
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
+	return file->f_op->read_iter(iocb, iocb->ki_iter, iocb->ki_pos);
+}
+
+static ssize_t aio_write_iter(struct kiocb *iocb)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t ret;
+
+	if (unlikely(!is_kernel_kiocb(iocb)))
+		return -EINVAL;
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
+	return file->f_op->write_iter(iocb, iocb->ki_iter, iocb->ki_pos);
+}
+
 /*
  * aio_setup_iocb:
  *	Performs the initial checks and aio retry method
@@ -1042,6 +1084,14 @@ rw_common:
 		ret = aio_rw_vect_retry(req, rw, rw_op);
 		break;
 
+	case IOCB_CMD_READ_ITER:
+		ret = aio_read_iter(req);
+		break;
+
+	case IOCB_CMD_WRITE_ITER:
+		ret = aio_write_iter(req);
+		break;
+
 	case IOCB_CMD_FDSYNC:
 		if (!file->f_op->aio_fsync)
 			return -EINVAL;
@@ -1116,6 +1166,23 @@ void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp,
 }
 EXPORT_SYMBOL_GPL(aio_kernel_init_rw);
 
+/*
+ * The iter count must be set before calling here.  Some filesystems uses
+ * iocb->ki_left as an indicator of the size of an IO.
+ */
+void aio_kernel_init_iter(struct kiocb *iocb, struct file *filp,
+			  unsigned short op, struct iov_iter *iter, loff_t off)
+{
+	iocb->ki_filp = filp;
+	iocb->ki_iter = iter;
+	iocb->ki_opcode = op;
+	iocb->ki_pos = off;
+	iocb->ki_nbytes = iov_iter_count(iter);
+	iocb->ki_left = iocb->ki_nbytes;
+	iocb->ki_ctx = (void *)-1;
+}
+EXPORT_SYMBOL_GPL(aio_kernel_init_iter);
+
 void aio_kernel_init_callback(struct kiocb *iocb,
 			      void (*complete)(u64 user_data, long res),
 			      u64 user_data)
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 014a75d..64d059d 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -66,6 +66,7 @@ struct kiocb {
 	 * this is the underlying eventfd context to deliver events to.
 	 */
 	struct eventfd_ctx	*ki_eventfd;
+	struct iov_iter		*ki_iter;
 };
 
 static inline bool is_sync_kiocb(struct kiocb *kiocb)
@@ -102,6 +103,8 @@ struct kiocb *aio_kernel_alloc(gfp_t gfp);
 void aio_kernel_free(struct kiocb *iocb);
 void aio_kernel_init_rw(struct kiocb *iocb, struct file *filp,
 			unsigned short op, void *ptr, size_t nr, loff_t off);
+void aio_kernel_init_iter(struct kiocb *iocb, struct file *filp,
+			  unsigned short op, struct iov_iter *iter, loff_t off);
 void aio_kernel_init_callback(struct kiocb *iocb,
 			      void (*complete)(u64 user_data, long res),
 			      u64 user_data);
diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
index bb2554f..22ce4bd 100644
--- a/include/uapi/linux/aio_abi.h
+++ b/include/uapi/linux/aio_abi.h
@@ -44,6 +44,8 @@ enum {
 	IOCB_CMD_NOOP = 6,
 	IOCB_CMD_PREADV = 7,
 	IOCB_CMD_PWRITEV = 8,
+	IOCB_CMD_READ_ITER = 9,
+	IOCB_CMD_WRITE_ITER = 10,
 };
 
 /*
-- 
1.8.3.4

