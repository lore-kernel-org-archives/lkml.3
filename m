Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288AbaDVFfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:35:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31509 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058AbaDVFfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:35:05 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-d9-5355ff8714a3
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/2] f2fs: introduce f2fs_seek_block to support
 SEEK_{DATA,HOLE} in llseek
Date: Tue, 22 Apr 2014 13:34:53 +0800
Message-id: <001a01cf5dec$9a398680$ceac9380$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9d6tmf5C03VAPpQfenufMQPoBBng==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQd32/6HBBrv/Klhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfFyxmPGgi9yFasW
	HGRuYDwv0cXIySEhYCKx7cFuFghbTOLCvfVsXYxcHEIC0xkllr9tYYdwfjBKfD62kBGkik1A
	RWJ5x38mEFtEQFFiw/sN7CA2s0CmxL2mGcwgtrBAmkT7x11g9SwCqhI7p94Gs3kFLCV2NC9i
	hbAFJX5MvscC0aslsX7ncSYIW15i85q3zBAXKUjsOPuaEWKXnkTr3clsEDXiEhuP3GKZwCgw
	C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgkP5mdQOxpUNFocY
	BTgYlXh4JQxCg4VYE8uKK3MPMUpwMCuJ8Kb/AQrxpiRWVqUW5ccXleakFh9ilOZgURLnPdBq
	HSgkkJ5YkpqdmlqQWgSTZeLglGpgNNf6s/ftmy7Lv4Kxdz8seHTDcmrXhivd2f+WX5LJ9yv6
	Wf+96+bSv9+sJpzwW210Qm6tXbfP/2Wf77G/fqz+m/Xe7M7Vf+Jf7ZRrj/K7Zf+58Jf5EctV
	W0vmbrm+253d8FJNxN3CqQJvZbXi/kw92rv8+8mNRyqOiaR1f5g6x2Zdw4FTPF/WbrmvxFKc
	kWioxVxUnAgAHfq2zmECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In This patch we introduce f2fs_seek_block to support SEEK_{DATA,HOLE} of
lseek(2).

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h |    6 ++++
 fs/f2fs/file.c |   96 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 97da71d..b1d6699 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1074,6 +1074,12 @@ static inline void f2fs_stop_checkpoint(struct f2fs_sb_info *sbi)
 	((is_inode_flag_set(F2FS_I(i), FI_ACL_MODE)) ? \
 	 (F2FS_I(i)->i_acl_mode) : ((i)->i_mode))
 
+/* get offset of first page in next direct node */
+#define PGOFS_OF_NEXT_DNODE(pgofs, fi)					\
+	((pgofs < ADDRS_PER_INODE(fi)) ? ADDRS_PER_INODE(fi) :		\
+	(pgofs - ADDRS_PER_INODE(fi) + 2 * ADDRS_PER_BLOCK - 1) /	\
+	ADDRS_PER_BLOCK * ADDRS_PER_BLOCK + ADDRS_PER_INODE(fi))
+
 /*
  * file.c
  */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 60e7d54..da1c3b7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -194,6 +194,100 @@ out:
 	return ret;
 }
 
+static loff_t f2fs_seek_block(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+	loff_t maxbytes = inode->i_sb->s_maxbytes;
+	struct dnode_of_data dn;
+	pgoff_t pgofs, end_offset, end;
+	loff_t data_ofs = 0, isize;
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
+	pgofs =	(pgoff_t)(offset >> PAGE_CACHE_SHIFT);
+	end = (pgoff_t)(isize >> PAGE_CACHE_SHIFT);
+
+	while (pgofs < end) {
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
+				data_ofs = pgofs << PAGE_CACHE_SHIFT;
+				goto found;
+			}
+		}
+
+		end_offset = IS_INODE(dn.node_page) ?
+			ADDRS_PER_INODE(F2FS_I(inode)) : ADDRS_PER_BLOCK;
+
+		/* find data/hole in dnode block */
+		for (; dn.ofs_in_node < end_offset; dn.ofs_in_node++, pgofs++) {
+			block_t blkaddr;
+			blkaddr = datablock_addr(dn.node_page, dn.ofs_in_node);
+
+			if ((whence == SEEK_DATA && blkaddr != NULL_ADDR) ||
+				(whence == SEEK_HOLE && blkaddr == NULL_ADDR)) {
+				f2fs_put_dnode(&dn);
+				data_ofs = pgofs << PAGE_CACHE_SHIFT;
+				goto found;
+			}
+		}
+		f2fs_put_dnode(&dn);
+	}
+
+	data_ofs = pgofs << PAGE_CACHE_SHIFT;
+	if (data_ofs > isize) {
+		if (whence == SEEK_DATA)
+			goto fail;
+		else
+			data_ofs =  isize;
+	}
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
@@ -678,7 +772,7 @@ long f2fs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 #endif
 
 const struct file_operations f2fs_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= f2fs_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
-- 
1.7.9.5


