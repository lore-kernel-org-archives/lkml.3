Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaGBFZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:25:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27568 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaGBFZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:25:54 -0400
X-AuditID: cbfee61b-f79f86d00000144c-31-53b397e01c19
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/2] f2fs: introduce f2fs_write_failed to handle
 error case when write
Date: Wed, 02 Jul 2014 13:25:04 +0800
Message-id: <000101cf95b6$18137ab0$483a7010$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+Vs18plsUVZDBOSruO3nLWn03Ikg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd0H0zcHG1xcI2VxbV8jk8WT9bOY
	LS4tcrfYs/cki8XlXXPYHFg9Nq3qZPPYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	/Np/nL3ginTFjwUrGRsY34p2MXJySAiYSDw8cZcdwhaTuHBvPVsXIxeHkMAiRonZM7ezQDg/
	GCXurfnGBFLFJqAisbzjP5gtIuAlMWn/CRYQm1kgU+Je0wxmEFtYIEli4YZFrCA2i4CqxIsZ
	X9hAbF4BS4k7XVeYIGxBiR+T70H1akms33mcCcKWl9i85i0zxEUKEjvOvmaE2KUn8b7vPDtE
	jbjExiO3WCYwCsxCMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzg
	8H4mvYNxVYPFIUYBDkYlHt6Iu5uChVgTy4orcw8xSnAwK4nwxvNsDhbiTUmsrEotyo8vKs1J
	LT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAKP+7zKXNI0lA/ulPl6h85lKuqZcS
	ngneXzpTrqy38/7lSTVuDFEu1mXRJxP5OYTunOZd0buH5WkS3/qHIZPYDh2eb2J/cJ12Dvtc
	9saP02+4v+pWPKgZXFppfrVqwb+uF66ppX2fpnleiHVLLn8RW8JkVjv12PIf/WLPGlmcddbc
	l087LHJIiaU4I9FQi7moOBEAL/QdIGsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we fail in ->write_begin()/->direct_IO(), our allocated node block in disk
and page cache are still kept, despite these may not be used again.

This patch introduce f2fs_write_failed() to handle the error case of these two
interfaces, it will truncate page cache and blocks of this file according to
i_size.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 2eb2764..05154d6 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -914,6 +914,16 @@ skip_write:
 	return 0;
 }
 
+static void f2fs_write_failed(struct address_space *mapping, loff_t to)
+{
+	struct inode *inode = mapping->host;
+
+	if (to > inode->i_size) {
+		truncate_pagecache(inode, inode->i_size);
+		truncate_blocks(inode, inode->i_size);
+	}
+}
+
 static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 		loff_t pos, unsigned len, unsigned flags,
 		struct page **pagep, void **fsdata)
@@ -931,11 +941,13 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 repeat:
 	err = f2fs_convert_inline_data(inode, pos + len);
 	if (err)
-		return err;
+		goto fail;
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
-	if (!page)
-		return -ENOMEM;
+	if (!page) {
+		err = -ENOMEM;
+		goto fail;
+	}
 
 	/* to avoid latency during memory pressure */
 	unlock_page(page);
@@ -949,10 +961,9 @@ repeat:
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = f2fs_reserve_block(&dn, index);
 	f2fs_unlock_op(sbi);
-
 	if (err) {
 		f2fs_put_page(page, 0);
-		return err;
+		goto fail;
 	}
 inline_data:
 	lock_page(page);
@@ -982,19 +993,20 @@ inline_data:
 			err = f2fs_read_inline_data(inode, page);
 			if (err) {
 				page_cache_release(page);
-				return err;
+				goto fail;
 			}
 		} else {
 			err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
 							READ_SYNC);
 			if (err)
-				return err;
+				goto fail;
 		}
 
 		lock_page(page);
 		if (unlikely(!PageUptodate(page))) {
 			f2fs_put_page(page, 1);
-			return -EIO;
+			err = -EIO;
+			goto fail;
 		}
 		if (unlikely(page->mapping != mapping)) {
 			f2fs_put_page(page, 1);
@@ -1005,6 +1017,9 @@ out:
 	SetPageUptodate(page);
 	clear_cold_data(page);
 	return 0;
+fail:
+	f2fs_write_failed(mapping, pos + len);
+	return err;
 }
 
 static int f2fs_write_end(struct file *file,
@@ -1049,7 +1064,10 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 		struct iov_iter *iter, loff_t offset)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_mapping->host;
+	struct address_space *mapping = file->f_mapping;
+	struct inode *inode = mapping->host;
+	size_t count = iov_iter_count(iter);
+	int err;
 
 	/* Let buffer I/O handle the inline data case. */
 	if (f2fs_has_inline_data(inode))
@@ -1061,8 +1079,10 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 	/* clear fsync mark to recover these blocks */
 	fsync_mark_clear(F2FS_SB(inode->i_sb), inode->i_ino);
 
-	return blockdev_direct_IO(rw, iocb, inode, iter, offset,
-				  get_data_block);
+	err = blockdev_direct_IO(rw, iocb, inode, iter, offset, get_data_block);
+	if (err < 0 && (rw & WRITE))
+		f2fs_write_failed(mapping, offset + count);
+	return err;
 }
 
 static void f2fs_invalidate_data_page(struct page *page, unsigned int offset,
-- 
1.7.9.5


