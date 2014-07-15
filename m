Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbaGOBjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 21:39:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:53456 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaGOBje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 21:39:34 -0400
X-AuditID: cbfee61b-f79f86d00000144c-40-53c48654ba0c
From: Chao Yu <chao2.yu@samsung.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2] udf: avoid redundant memcpy when writing data in
 ICB
Date: Tue, 15 Jul 2014 09:38:51 +0800
Message-id: <000d01cf9fcd$9e226500$da672f00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+fzHbZzBiFTUWrT1Wtf92e5zDx1A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jAd2QtiPBBhN/6FnMnt7MZHF51xw2
	ByaPMwuOsHt83iQXwBTFZZOSmpNZllqkb5fAlfH56D22gk18FQenSDUwPuHuYuTkkBAwkdi+
	4hMThC0mceHeerYuRi4OIYFFjBKP+h6wgiSEBH4wShw4bw9iswmoSCzv+A/WICIgIPH22E82
	EJtZQEHi171NYPXCAiESN9d+ZQexWQRUJb7cnwhWzytgKdGybzWULSjxY/I9FoheLYn1O48z
	QdjyEpvXvGWGOEhBYsfZ14wQu/Qkpuy9BVUvLrHxyC2WCYwCs5CMmoVk1Cwko2YhaVnAyLKK
	UTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhUn0nvYFzVYHGIUYCDUYmHV+Ld4WAh1sSy4src
	Q4wSHMxKIrxNFUeChXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgsky
	cXACg9zm5IYzXk9k1dU/feWUqPm+et3hJ1EnpMIsE+d8LZBWC7x1RaugYNmdj5UP2E+9Der4
	n6BYbP1055y0noXMD683RygwSn52nj3545IFfBeuKuvEfpDi8AwQ6yzW2FPJlpg4zz2D5y+z
	df36e6cYXz41uBOdyml2uYspielRoIyEsVRM2bsHvUosxRmJhlrMRcWJAJ0zHs1RAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valid data within i_size in page cache will be copied to ICB cache when we
writeback the page by invoking udf_adinicb_writepage, so the copy in
udf_adinicb_write_end is redundant.
After we remove the copy, it's better to use simple_write_end directly in
udf_adinicb_aops instead of udf_adinicb_write_end.

v2:
 o fix to remove redundant code correctly and use simple_write_end directly in
udf_adinicb_aops pointed out by Jan Kara.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/udf/file.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index d80738f..3d06489 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -100,24 +100,6 @@ static int udf_adinicb_write_begin(struct file *file,
 	return 0;
 }
 
-static int udf_adinicb_write_end(struct file *file,
-			struct address_space *mapping,
-			loff_t pos, unsigned len, unsigned copied,
-			struct page *page, void *fsdata)
-{
-	struct inode *inode = mapping->host;
-	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
-	char *kaddr;
-	struct udf_inode_info *iinfo = UDF_I(inode);
-
-	kaddr = kmap_atomic(page);
-	memcpy(iinfo->i_ext.i_data + iinfo->i_lenEAttr + offset,
-		kaddr + offset, copied);
-	kunmap_atomic(kaddr);
-
-	return simple_write_end(file, mapping, pos, len, copied, page, fsdata);
-}
-
 static ssize_t udf_adinicb_direct_IO(int rw, struct kiocb *iocb,
 				     struct iov_iter *iter,
 				     loff_t offset)
@@ -130,7 +112,7 @@ const struct address_space_operations udf_adinicb_aops = {
 	.readpage	= udf_adinicb_readpage,
 	.writepage	= udf_adinicb_writepage,
 	.write_begin	= udf_adinicb_write_begin,
-	.write_end	= udf_adinicb_write_end,
+	.write_end	= simple_write_end,
 	.direct_IO	= udf_adinicb_direct_IO,
 };
 
-- 
2.0.1.474.g72c7794


