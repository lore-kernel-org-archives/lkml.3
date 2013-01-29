Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3A2QZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 11:25:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19993 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3A2QZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 11:25:08 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Jan Kara <jack@suse.cz>
Subject: [PATCH V6 27/30] udf: convert file ops from aio_read/write to read/write_iter
Date: Tue, 29 Jan 2013 10:23:40 -0600
Message-Id: <1359476623-10544-28-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
References: <1359476623-10544-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/udf/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index c4164dc..a5d69c0 100644
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
1.8.1.1

