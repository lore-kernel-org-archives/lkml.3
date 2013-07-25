Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab3GYSA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:00:59 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24547 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab3GYSAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:00:52 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH V8 29/33] udf: convert file ops from aio_read/write to read/write_iter
Date: Thu, 25 Jul 2013 12:50:55 -0500
Message-Id: <1374774659-13121-30-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 339df8b..e392d60 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -133,8 +133,8 @@ const struct address_space_operations udf_adinicb_aops = {
 	.direct_IO	= udf_adinicb_direct_IO,
 };
 
-static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-				  unsigned long nr_segs, loff_t ppos)
+static ssize_t udf_file_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+				   loff_t ppos)
 {
 	ssize_t retval;
 	struct file *file = iocb->ki_filp;
@@ -168,7 +168,7 @@ static ssize_t udf_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	} else
 		up_write(&iinfo->i_data_sem);
 
-	retval = generic_file_aio_write(iocb, iov, nr_segs, ppos);
+	retval = generic_file_write_iter(iocb, iter, ppos);
 	if (retval > 0)
 		mark_inode_dirty(inode);
 
@@ -242,12 +242,12 @@ static int udf_release_file(struct inode *inode, struct file *filp)
 
 const struct file_operations udf_file_operations = {
 	.read			= do_sync_read,
-	.aio_read		= generic_file_aio_read,
+	.read_iter		= generic_file_read_iter,
 	.unlocked_ioctl		= udf_ioctl,
 	.open			= generic_file_open,
 	.mmap			= generic_file_mmap,
 	.write			= do_sync_write,
-	.aio_write		= udf_file_aio_write,
+	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
 	.fsync			= generic_file_fsync,
 	.splice_read		= generic_file_splice_read,
-- 
1.8.3.4

