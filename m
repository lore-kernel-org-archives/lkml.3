Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994Ab3CHWzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:55:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30454 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759818Ab3CHWww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:52:52 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Zach Brown <zab@zabbo.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <dustin.kirkland@gazzang.com>,
        ecryptfs@vger.kernel.org
Subject: [PATCH V7 -next 31/33] ecrpytfs: Convert aio_read/write ops to read/write_iter
Date: Fri,  8 Mar 2013 16:52:26 -0600
Message-Id: <1362783148-22736-32-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
References: <1362783148-22736-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
index 201f0a0..3392544 100644
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
 	struct path lower;
 	struct file *file = iocb->ki_filp;
 
-	rc = generic_file_aio_read(iocb, iov, nr_segs, pos);
+	rc = generic_file_read_iter(iocb, iter, pos);
 	/*
 	 * Even though this is a async interface, we need to wait
 	 * for IO to finish to update atime
@@ -356,9 +355,9 @@ const struct file_operations ecryptfs_dir_fops = {
 const struct file_operations ecryptfs_main_fops = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
-	.aio_read = ecryptfs_read_update_atime,
+	.read_iter = ecryptfs_read_update_atime,
 	.write = do_sync_write,
-	.aio_write = generic_file_aio_write,
+	.write_iter = generic_file_write_iter,
 	.readdir = ecryptfs_readdir,
 	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
-- 
1.8.1.5

