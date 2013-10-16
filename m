Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677Ab3JPOGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:06:08 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26721 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934657Ab3JPOGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:06:02 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org
Subject: [PATCH V9 15/33] aio: add aio support for iov_iter arguments
Date: Wed, 16 Oct 2013 09:04:28 -0500
Message-Id: <1381932286-14978-16-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Zach Brown <zab@zabbo.net>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-aio@kvack.org
---
 fs/aio.c            | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/aio.h |  8 ++++++++
 2 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index ae40141..b1d257a 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1199,13 +1199,55 @@ static ssize_t aio_setup_single_vector(struct kiocb *kiocb,
 	return 0;
 }
 
+static ssize_t aio_read_iter(struct kiocb *iocb, struct iov_iter *iter)
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
+	return file->f_op->read_iter(iocb, iter, iocb->ki_pos);
+}
+
+static ssize_t aio_write_iter(struct kiocb *iocb, struct iov_iter *iter)
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
+	return file->f_op->write_iter(iocb, iter, iocb->ki_pos);
+}
+
 /*
  * aio_setup_iocb:
  *	Performs the initial checks and aio retry method
  *	setup for the kiocb at the time of io submission.
  */
 static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
-			    char __user *buf, bool compat)
+			    void *buf, bool compat)
 {
 	struct file *file = req->ki_filp;
 	ssize_t ret;
@@ -1270,6 +1312,14 @@ rw_common:
 			file_end_write(file);
 		break;
 
+	case IOCB_CMD_READ_ITER:
+		ret = aio_read_iter(req, buf);
+		break;
+
+	case IOCB_CMD_WRITE_ITER:
+		ret = aio_write_iter(req, buf);
+		break;
+
 	case IOCB_CMD_FDSYNC:
 		if (!file->f_op->aio_fsync)
 			return -EINVAL;
@@ -1440,7 +1490,7 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
 	req->ki_nbytes = iocb->aio_nbytes;
 
 	ret = aio_run_iocb(req, iocb->aio_lio_opcode,
-			   (char __user *)(unsigned long)iocb->aio_buf,
+			   (void *)(unsigned long)iocb->aio_buf,
 			   compat);
 	if (ret)
 		goto out_put_req;
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 734d9e6..f01e7e3 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -15,6 +15,14 @@ struct kiocb;
 #define KIOCB_KEY		0
 
 /*
+ * opcode values not exposed to user space
+ */
+enum {
+	IOCB_CMD_READ_ITER = 0x10000,
+	IOCB_CMD_WRITE_ITER = 0x10001,
+};
+
+/*
  * We use ki_cancel == KIOCB_CANCELLED to indicate that a kiocb has been either
  * cancelled or completed (this makes a certain amount of sense because
  * successful cancellation - io_cancel() - does deliver the completion to
-- 
1.8.4

