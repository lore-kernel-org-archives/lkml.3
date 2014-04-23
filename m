Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbaDWGLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 02:11:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14636 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaDWGLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 02:11:10 -0400
X-AuditID: cbfee61b-b7f766d00000646c-be-5357597c4f7a
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [f2fs-dev][PATCH 2/2 v2] f2fs: introduce f2fs_seek_block to support
 SEEK_{DATA, HOLE} in llseek
Date: Wed, 23 Apr 2014 14:10:24 +0800
Message-id: <000001cf5eba$d120a7e0$7361f7a0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9eupMcZV4j+GN/TpC+J6Qx0py/Fg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAd2ayPBggw1tyhbXd/1lsri0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZTT9WsBS8Fqu4u2P
	92wNjOcluhg5OSQETCTuH9jPDmGLSVy4t56ti5GLQ0hgEaPEnrbXzBDOD0aJtt4nLCBVbAIq
	Ess7/jOB2CICihIb3m8A62YWyJSY83oyK4gtLJAl8efyJzCbRUBV4nr/e7BeXgFLiZ3X+9gg
	bEGJH5PvsUD0akms33mcCcKWl9i85i0zxEUKEjvOvmaE2KUnse/LZkaIGnGJjUdusUxgFJiF
	ZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBofxMegfjqgaLQ4wC
	HIxKPLwSy8OChVgTy4orcw8xSnAwK4nwzvwIFOJNSaysSi3Kjy8qzUktPsQozcGiJM57sNU6
	UEggPbEkNTs1tSC1CCbLxMEp1cBY3+ulsfk6Z1gdg8GO+0nM5y2eyl9l+3bIX0+j+lV28dcX
	oY0sVvpJLSkumreflTg5qPSuuLc+28fhUduvG6UXHq3ZmlrxVn/lbZaF+fILMl9K3Q+dJhP0
	MuhnZ6DG/E2dKpy/bzEJ1/znD1f03XQp+kG33AvFntSKWd7eK1/zfPvuVqC6dZoSS3FGoqEW
	c1FxIgBL5ikxYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In This patch we introduce f2fs_seek_block to support SEEK_{DATA,HOLE} of
lseek(2).

change log from v1:
 o fix bug when lseek from middle of page and fix wrong calculation of
PGOFS_OF_NEXT_DNODE macro.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h |    6 ++++
 fs/f2fs/file.c |   92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 97da71d..2397301 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1074,6 +1074,12 @@ static inline void f2fs_stop_checkpoint(struct f2fs_sb_info *sbi)
 	((is_inode_flag_set(F2FS_I(i), FI_ACL_MODE)) ? \
 	 (F2FS_I(i)->i_acl_mode) : ((i)->i_mode))
 
+/* get offset of first page in next direct node */
+#define PGOFS_OF_NEXT_DNODE(pgofs, fi)				\
+	((pgofs < ADDRS_PER_INODE(fi)) ? ADDRS_PER_INODE(fi) :	\
+	(pgofs - ADDRS_PER_INODE(fi) + ADDRS_PER_BLOCK) /	\
+	ADDRS_PER_BLOCK * ADDRS_PER_BLOCK + ADDRS_PER_INODE(fi))
+
 /*
  * file.c
  */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 60e7d54..655d7a8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -194,6 +194,96 @@ out:
 	return ret;
 }
 
+static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+	loff_t maxbytes = inode->i_sb->s_maxbytes;
+	struct dnode_of_data dn;
+	pgoff_t pgofs, end_offset;
+	loff_t data_ofs = offset, isize;
+	int err = 0;
+
+	mutex_lock(&inode->i_mutex);
+
+	isize = i_size_read(inode);
+	if (offset >= isize)
+		goto fail;
+
+	/* handle inline data case */
+	if (f2fs_has_inline_data(inode)) {
+		if (whence == SEEK_HOLE)
+			data_ofs = isize;
+		goto found;
+	}
+
+	pgofs = (pgoff_t)(offset >> PAGE_CACHE_SHIFT);
+
+	for (; data_ofs < isize; data_ofs = pgofs << PAGE_CACHE_SHIFT) {
+		set_new_dnode(&dn, inode, NULL, NULL, 0);
+		err = get_dnode_of_data(&dn, pgofs, LOOKUP_NODE_RA);
+		if (err && err != -ENOENT) {
+			goto fail;
+		} else if (err == -ENOENT) {
+			/* direct node is not exist */
+			if (whence == SEEK_DATA) {
+				pgofs = PGOFS_OF_NEXT_DNODE(pgofs,
+							F2FS_I(inode));
+				continue;
+			} else {
+				goto found;
+			}
+		}
+
+		end_offset = IS_INODE(dn.node_page) ?
+			ADDRS_PER_INODE(F2FS_I(inode)) : ADDRS_PER_BLOCK;
+
+		/* find data/hole in dnode block */
+		for (; dn.ofs_in_node < end_offset;
+				dn.ofs_in_node++, pgofs++,
+				data_ofs = pgofs << PAGE_CACHE_SHIFT) {
+			block_t blkaddr;
+			blkaddr = datablock_addr(dn.node_page, dn.ofs_in_node);
+
+			if ((whence == SEEK_DATA && blkaddr != NULL_ADDR) ||
+				(whence == SEEK_HOLE && blkaddr == NULL_ADDR)) {
+				f2fs_put_dnode(&dn);
+				goto found;
+			}
+		}
+		f2fs_put_dnode(&dn);
+	}
+
+	if (whence == SEEK_DATA)
+		goto fail;
+	else
+		data_ofs = isize;
+found:
+	mutex_unlock(&inode->i_mutex);
+	return vfs_setpos(file, data_ofs, maxbytes);
+fail:
+	mutex_unlock(&inode->i_mutex);
+	return -ENXIO;
+}
+
+static loff_t f2fs_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+	loff_t maxbytes = inode->i_sb->s_maxbytes;
+
+	switch (whence) {
+	case SEEK_SET:
+	case SEEK_CUR:
+	case SEEK_END:
+		return generic_file_llseek_size(file, offset, whence,
+						maxbytes, i_size_read(inode));
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		return f2fs_seek_block(file, offset, whence);
+	}
+
+	return -EINVAL;
+}
+
 static int f2fs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	file_accessed(file);
@@ -678,7 +768,7 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 #endif
 
 const struct file_operations f2fs_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= f2fs_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
-- 
1.7.9.5


