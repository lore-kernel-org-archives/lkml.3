Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaD1KAa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:00:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27301 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbaD1KA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:00:28 -0400
X-AuditID: cbfee61b-b7f766d00000646c-b0-535e26bb7e79
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/2] f2fs: readahead multi pages of directory for
 performance
Date: Mon, 28 Apr 2014 17:59:43 +0800
Message-id: <000601cf62c8$ae9a4200$0bcec600$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9iqy63cqWB+OF3REqqwXmd8CW2/Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQd3danHBBu8villc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHn82Xmgms8FdO7
	F7E3MM7m6mLk4JAQMJG4My+6i5ETyBSTuHBvPVsXIxeHkMB0RoktZ/6yQjg/gJybXcwgVWwC
	KhLLO/4zgdgiAooSG95vYAexmQUyJe41zQCrERaIlDjScB/MZhFQlXg3bRo7yDJeAUuJG0u8
	QcK8AoISPybfY4Fo1ZJYv/M4E4QtL7F5zVtmiIMUJHacfc0IsUpP4uyW5VD14hIbj9ximcAo
	MAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLD+Jn0DsZVDRaH
	GAU4GJV4eCPmxAYLsSaWFVfmHmKU4GBWEuHdLxEXLMSbklhZlVqUH19UmpNafIhRmoNFSZz3
	YKt1oJBAemJJanZqakFqEUyWiYNTqoFRruKt/KVTxy4u4z+7edHTQ/GqB2919LI5nv4XVc5v
	0aK836TGfulfXtGIoNCnalOShfZNELrwf3nTAnEjvlu73H/z8TV22L5d+lHv1YwdbxVtkkN8
	rAUbPaJn1gjvNvB+WmPNcIIx17ci8am8k/H/Dexs7BPKbxwrtKw06lC61SO83m1j3mIlluKM
	REMt5qLiRADD+EVqXwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have no so such readahead mechanism in ->iterate() path as the one in
->read() path, it cause low performance when we read large directory.
This patch add readahead in f2fs_readdir() for better performance.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c  |    6 ++++++
 fs/f2fs/f2fs.h |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 972fd0e..3581c2b 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -637,11 +637,17 @@ static int f2fs_readdir(struct file *file, struct dir_context *ctx)
 	struct f2fs_dentry_block *dentry_blk = NULL;
 	struct f2fs_dir_entry *de = NULL;
 	struct page *dentry_page = NULL;
+	struct file_ra_state *ra = &file->f_ra;
 	unsigned int n = ((unsigned long)ctx->pos / NR_DENTRY_IN_BLOCK);
 	unsigned char d_type = DT_UNKNOWN;
 
 	bit_pos = ((unsigned long)ctx->pos % NR_DENTRY_IN_BLOCK);
 
+	/* readahead for multi pages of dir */
+	if (npages - n > 1 && !ra_has_index(ra, n))
+		page_cache_sync_readahead(inode->i_mapping, ra, file, n,
+				min(npages - n, (pgoff_t)MAX_DIR_RA_PAGES));
+
 	for (; n < npages; n++) {
 		dentry_page = get_lock_data_page(inode, n);
 		if (IS_ERR(dentry_page))
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index e77be7c..2b67679 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -182,6 +182,8 @@ enum {
 
 #define F2FS_LINK_MAX		32000	/* maximum link count per file */
 
+#define MAX_DIR_RA_PAGES	4	/* maximum ra pages of dir */
+
 /* for in-memory extent cache entry */
 #define F2FS_MIN_EXTENT_LEN	16	/* minimum extent length */
 
-- 
1.7.9.5


