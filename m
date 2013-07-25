Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab3GYR7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:59:43 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43468 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab3GYRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:52:04 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH V8 28/33] gfs2: Convert aio_read/write ops to read/write_iter
Date: Thu, 25 Jul 2013 12:50:54 -0500
Message-Id: <1374774659-13121-29-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
---
 fs/gfs2/file.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 72c3866..23cbdd4 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -679,10 +679,9 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 }
 
 /**
- * gfs2_file_aio_write - Perform a write to a file
+ * gfs2_file_write_iter - Perform a write to a file
  * @iocb: The io context
- * @iov: The data to write
- * @nr_segs: Number of @iov segments
+ * @iter: The data to write
  * @pos: The file position
  *
  * We have to do a lock/unlock here to refresh the inode size for
@@ -692,11 +691,11 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
  *
  */
 
-static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-				   unsigned long nr_segs, loff_t pos)
+static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+				    loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
-	size_t writesize = iov_length(iov, nr_segs);
+	size_t writesize = iov_iter_count(iter);
 	struct gfs2_inode *ip = GFS2_I(file_inode(file));
 	int ret;
 
@@ -715,7 +714,7 @@ static ssize_t gfs2_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 		gfs2_glock_dq_uninit(&gh);
 	}
 
-	return generic_file_aio_write(iocb, iov, nr_segs, pos);
+	return generic_file_write_iter(iocb, iter, pos);
 }
 
 static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,
@@ -1047,9 +1046,9 @@ static int gfs2_flock(struct file *file, int cmd, struct file_lock *fl)
 const struct file_operations gfs2_file_fops = {
 	.llseek		= gfs2_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= gfs2_file_aio_write,
+	.write_iter	= gfs2_file_write_iter,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
@@ -1079,9 +1078,9 @@ const struct file_operations gfs2_dir_fops = {
 const struct file_operations gfs2_file_fops_nolock = {
 	.llseek		= gfs2_llseek,
 	.read		= do_sync_read,
-	.aio_read	= generic_file_aio_read,
+	.read_iter	= generic_file_read_iter,
 	.write		= do_sync_write,
-	.aio_write	= gfs2_file_aio_write,
+	.write_iter	= gfs2_file_write_iter,
 	.unlocked_ioctl	= gfs2_ioctl,
 	.mmap		= gfs2_mmap,
 	.open		= gfs2_open,
-- 
1.8.3.4

