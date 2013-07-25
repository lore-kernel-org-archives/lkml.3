Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932194Ab3GYR7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:59:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19907 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757002Ab3GYRwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:52:04 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: [PATCH V8 31/33] ecrpytfs: Convert aio_read/write ops to read/write_iter
Date: Thu, 25 Jul 2013 12:50:57 -0500
Message-Id: <1374774659-13121-32-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Tyler Hicks <tyhicks@canonical.com>
Cc: Dustin Kirkland <dustin.kirkland@gazzang.com>
Cc: ecryptfs@vger.kernel.org
---
 fs/ecryptfs/file.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 992cf95..3ed6e5f 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -37,22 +37,21 @@
 /**
  * ecryptfs_read_update_atime
  *
- * generic_file_read updates the atime of upper layer inode.  But, it
+ * generic_file_read_iter updates the atime of upper layer inode.  But, it
  * doesn't give us a chance to update the atime of the lower layer
- * inode.  This function is a wrapper to generic_file_read.  It
- * updates the atime of the lower level inode if generic_file_read
+ * inode.  This function is a wrapper to generic_file_read_iter.  It
+ * updates the atime of the lower level inode if generic_file_read_iter
  * returns without any errors. This is to be used only for file reads.
  * The function to be used for directory reads is ecryptfs_read.
  */
 static ssize_t ecryptfs_read_update_atime(struct kiocb *iocb,
-				const struct iovec *iov,
-				unsigned long nr_segs, loff_t pos)
+				struct iov_iter *iter, loff_t pos)
 {
 	ssize_t rc;
 	struct path *path;
 	struct file *file = iocb->ki_filp;
 
-	rc = generic_file_aio_read(iocb, iov, nr_segs, pos);
+	rc = generic_file_read_iter(iocb, iter, pos);
 	/*
 	 * Even though this is a async interface, we need to wait
 	 * for IO to finish to update atime
@@ -357,9 +356,9 @@ const struct file_operations ecryptfs_dir_fops = {
 const struct file_operations ecryptfs_main_fops = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
-	.aio_read = ecryptfs_read_update_atime,
+	.read_iter = ecryptfs_read_update_atime,
 	.write = do_sync_write,
-	.aio_write = generic_file_aio_write,
+	.write_iter = generic_file_write_iter,
 	.iterate = ecryptfs_readdir,
 	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
-- 
1.8.3.4

