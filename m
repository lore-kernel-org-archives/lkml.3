Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab3GYSBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:01:16 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48502 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638Ab3GYSBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:01:07 -0400
From: Dave Kleikamp <dave.kleikamp@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Dave Kleikamp <dave.kleikamp@oracle.com>,
        David Howells <dhowells@redhat.com>, linux-afs@lists.infradead.org
Subject: [PATCH V8 30/33] afs: add support for read_iter and write_iter
Date: Thu, 25 Jul 2013 12:50:56 -0500
Message-Id: <1374774659-13121-31-git-send-email-dave.kleikamp@oracle.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-afs@lists.infradead.org
---
 fs/afs/file.c     | 4 ++--
 fs/afs/internal.h | 3 +--
 fs/afs/write.c    | 9 ++++-----
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 66d50fe..3b71622 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -33,8 +33,8 @@ const struct file_operations afs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-	.aio_read	= generic_file_aio_read,
-	.aio_write	= afs_file_write,
+	.read_iter	= generic_file_read_iter,
+	.write_iter	= afs_file_write,
 	.mmap		= generic_file_readonly_mmap,
 	.splice_read	= generic_file_splice_read,
 	.fsync		= afs_fsync,
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index a306bb6..9c048ff 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -747,8 +747,7 @@ extern int afs_write_end(struct file *file, struct address_space *mapping,
 extern int afs_writepage(struct page *, struct writeback_control *);
 extern int afs_writepages(struct address_space *, struct writeback_control *);
 extern void afs_pages_written_back(struct afs_vnode *, struct afs_call *);
-extern ssize_t afs_file_write(struct kiocb *, const struct iovec *,
-			      unsigned long, loff_t);
+extern ssize_t afs_file_write(struct kiocb *, struct iov_iter *, loff_t);
 extern int afs_writeback_all(struct afs_vnode *);
 extern int afs_fsync(struct file *, loff_t, loff_t, int);
 
diff --git a/fs/afs/write.c b/fs/afs/write.c
index a890db4..9fa2f59 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -625,15 +625,14 @@ void afs_pages_written_back(struct afs_vnode *vnode, struct afs_call *call)
 /*
  * write to an AFS file
  */
-ssize_t afs_file_write(struct kiocb *iocb, const struct iovec *iov,
-		       unsigned long nr_segs, loff_t pos)
+ssize_t afs_file_write(struct kiocb *iocb, struct iov_iter *iter, loff_t pos)
 {
 	struct afs_vnode *vnode = AFS_FS_I(file_inode(iocb->ki_filp));
 	ssize_t result;
-	size_t count = iov_length(iov, nr_segs);
+	size_t count = iov_iter_count(iter);
 
 	_enter("{%x.%u},{%zu},%lu,",
-	       vnode->fid.vid, vnode->fid.vnode, count, nr_segs);
+	       vnode->fid.vid, vnode->fid.vnode, count, iter->nr_segs);
 
 	if (IS_SWAPFILE(&vnode->vfs_inode)) {
 		printk(KERN_INFO
@@ -644,7 +643,7 @@ ssize_t afs_file_write(struct kiocb *iocb, const struct iovec *iov,
 	if (!count)
 		return 0;
 
-	result = generic_file_aio_write(iocb, iov, nr_segs, pos);
+	result = generic_file_write_iter(iocb, iter, pos);
 	if (IS_ERR_VALUE(result)) {
 		_leave(" = %zd", result);
 		return result;
-- 
1.8.3.4

