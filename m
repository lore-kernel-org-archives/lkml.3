Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbbAFG3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 01:29:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55388 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbAFG3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 01:29:31 -0500
X-AuditID: cbfee61a-f79c06d000004e71-11-54ab80c8a7f5
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/2] f2fs: get rid of kzalloc in
 __recover_inline_status
Date: Tue, 06 Jan 2015 14:28:43 +0800
Message-id: <009301d0297a$1fc55780$5f500680$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdApd8pnKTFd1q9SQcOcO0p26hj14Q==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAd0TDatDDK5+l7O4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxuK1E5gL
	DglV7J4+gaWBsZ2/i5GTQ0LARGJ721VWCFtM4sK99WxdjFwcQgKLGCVeH7/FDuH8YJR48u0O
	I0gVm4CKxPKO/0wgtoiAl8Sk/SdYQGxmAQ+Jxo7vYJOEBUIkXv18xwZiswioSqx90QBm8wpY
	SkyacIQZwhaU+DH5HlSvlsT6nceZIGx5ic1r3jJDXKQgsePsa0aIXXoS/55OZIWoEZfYeOQW
	ywRGgVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc1M+kdjCu
	bLA4xCjAwajEw+txYmWIEGtiWXFl7iFGCQ5mJRHec7WrQ4R4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzKtm3hQgJpCeWpGanphakFsFkmTg4pYBh7h0o8vGUg9u3/+YT44ovNCdNtyws++oZIang
	avOp/+W6wLcbG1nW7c6btp9n9rPba17Mkul/5+nSqh96u9X0FM+ukCVzpnzpZJo7M2hXuxrP
	njK1+RkfLY/EPw2bsVBlr6e/9J8Nnrtm14u5n7m8WWSrHUflrDjFjRaCtyYc/dEcuFVmqpCH
	EktxRqKhFnNRcSIAzjzjP2YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use kzalloc to allocate memory in __recover_inline_status, and use this
all-zero memory to check the inline date content of inode page by comparing
them. This is low effective and not needed, let's check inline date content
directly.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/inode.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 3a8958d..8be0fd5 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -67,29 +67,25 @@ static void __set_inode_rdev(struct inode *inode, struct f2fs_inode *ri)
 	}
 }
 
-static int __recover_inline_status(struct inode *inode, struct page *ipage)
+static void __recover_inline_status(struct inode *inode, struct page *ipage)
 {
 	void *inline_data = inline_data_addr(ipage);
+	__le32 *start = inline_data;
+	__le32 *end = start + MAX_INLINE_DATA / sizeof(__le32);
 	struct f2fs_inode *ri;
-	void *zbuf;
-
-	zbuf = kzalloc(MAX_INLINE_DATA, GFP_NOFS);
-	if (!zbuf)
-		return -ENOMEM;
-
-	if (!memcmp(zbuf, inline_data, MAX_INLINE_DATA)) {
-		kfree(zbuf);
-		return 0;
-	}
-	kfree(zbuf);
 
+	while (start < end)
+		if (*start++)
+			goto recover;
+	return;
+recover:
 	f2fs_wait_on_page_writeback(ipage, NODE);
 	set_inode_flag(F2FS_I(inode), FI_DATA_EXIST);
 
 	ri = F2FS_INODE(ipage);
 	set_raw_inline(F2FS_I(inode), ri);
 	set_page_dirty(ipage);
-	return 0;
+	return;
 }
 
 static int do_read_inode(struct inode *inode)
@@ -98,7 +94,6 @@ static int do_read_inode(struct inode *inode)
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct page *node_page;
 	struct f2fs_inode *ri;
-	int err = 0;
 
 	/* Check if ino is within scope */
 	if (check_nid_range(sbi, inode->i_ino)) {
@@ -142,7 +137,7 @@ static int do_read_inode(struct inode *inode)
 
 	/* check data exist */
 	if (f2fs_has_inline_data(inode) && !f2fs_exist_data(inode))
-		err = __recover_inline_status(inode, node_page);
+		__recover_inline_status(inode, node_page);
 
 	/* get rdev by using inline_info */
 	__get_inode_rdev(inode, ri);
@@ -152,7 +147,7 @@ static int do_read_inode(struct inode *inode)
 	stat_inc_inline_inode(inode);
 	stat_inc_inline_dir(inode);
 
-	return err;
+	return 0;
 }
 
 struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
-- 
2.2.1


