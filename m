Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934770Ab3JPOGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:06:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39898 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934654Ab3JPOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:06:17 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Christoph Hellwig <hch@infradead.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org
Subject: [PATCH V9 32/33] ubifs: convert file ops from aio_read/write to read/write_iter
Date: Wed, 16 Oct 2013 09:04:45 -0500
Message-Id: <1381932286-14978-33-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
References: <1381932286-14978-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-mtd@lists.infradead.org
---
 fs/ubifs/file.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 123c79b..22924e0 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -44,7 +44,7 @@
  * 'ubifs_writepage()' we are only guaranteed that the page is locked.
  *
  * Similarly, @i_mutex is not always locked in 'ubifs_readpage()', e.g., the
- * read-ahead path does not lock it ("sys_read -> generic_file_aio_read ->
+ * read-ahead path does not lock it ("sys_read -> generic_file_read_iter ->
  * ondemand_readahead -> readpage"). In case of readahead, @I_SYNC flag is not
  * set as well. However, UBIFS disables readahead.
  */
@@ -1396,8 +1396,8 @@ static int update_mctime(struct ubifs_info *c, struct inode *inode)
 	return 0;
 }
 
-static ssize_t ubifs_aio_write(struct kiocb *iocb, const struct iovec *iov,
-			       unsigned long nr_segs, loff_t pos)
+static ssize_t ubifs_write_iter(struct kiocb *iocb, struct iov_iter *iter,
+				loff_t pos)
 {
 	int err;
 	struct inode *inode = iocb->ki_filp->f_mapping->host;
@@ -1407,7 +1407,7 @@ static ssize_t ubifs_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (err)
 		return err;
 
-	return generic_file_aio_write(iocb, iov, nr_segs, pos);
+	return generic_file_write_iter(iocb, iter, pos);
 }
 
 static int ubifs_set_page_dirty(struct page *page)
@@ -1583,8 +1583,8 @@ const struct file_operations ubifs_file_operations = {
 	.llseek         = generic_file_llseek,
 	.read           = do_sync_read,
 	.write          = do_sync_write,
-	.aio_read       = generic_file_aio_read,
-	.aio_write      = ubifs_aio_write,
+	.read_iter       = generic_file_read_iter,
+	.write_iter      = ubifs_write_iter,
 	.mmap           = ubifs_file_mmap,
 	.fsync          = ubifs_fsync,
 	.unlocked_ioctl = ubifs_ioctl,
-- 
1.8.4

