Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaD1KCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:02:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27740 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaD1KCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:02:06 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-31-535e271cdbef
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/3] f2fs: fix to truncate inline data in inode page
 when setattr
Date: Mon, 28 Apr 2014 18:01:21 +0800
Message-id: <000701cf62c8$e8e7cb80$bab76280$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9ivs7iUjbPzWRqScOBaRx1ReQ0uQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jAV0Z9bhgg5MrbCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgynjacp+toEWwYmlj
	M1sD43/eLkZODgkBE4kzi+6yQthiEhfurWcDsYUEFjFKLPzt1MXIBWT/YJR42fODCSTBJqAi
	sbzjP5gtIqAoseH9BnYQm1kgU+Je0wzmLkYODmGBWImfzUYgYRYBVYnpXyeBlfMKWEp8XPeF
	DcIWlPgx+R4LRKuWxPqdx5kgbHmJzWveMkPcoyCx4+xrRohVehLndi+AqhGX2HjkFssERoFZ
	SEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHMbPpHYwrmywOMQo
	wMGoxMMbMSc2WIg1say4MvcQowQHs5II736JuGAh3pTEyqrUovz4otKc1OJDjNIcLErivAda
	rQOFBNITS1KzU1MLUotgskwcnFINjDVeLXZ5/YH3RY3NXA9olErLZXKmLNzX6bJL3q1px7/S
	Xu7O7aULprD+TTihdGX/dA71rX5K1edZ2Y0ZP15SKRBVe9emK1l74sZj40PmHnnCX/oVmQ5t
	PPswRlxXg80x1isn7a7SiinCov/U+NQ0dJt12Krk2ctymBwbHuse5gpa8Yl3S5ASS3FGoqEW
	c1FxIgBQyOYWXwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous we do not truncate inline data in inode page when setattr, so following
case could still read the inline data which has already truncated:

1.write inline data
2.ftruncate size to 0
3.ftruncate size to max inline data size
4.read from offset 0

This patch introduces truncate_inline_data() to fix this problem.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h   |    1 +
 fs/f2fs/file.c   |    3 +++
 fs/f2fs/inline.c |   18 ++++++++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 2b67679..676a2c6 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1410,5 +1410,6 @@ bool f2fs_may_inline(struct inode *);
 int f2fs_read_inline_data(struct inode *, struct page *);
 int f2fs_convert_inline_data(struct inode *, pgoff_t);
 int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
+void truncate_inline_data(struct inode *, u64);
 int recover_inline_data(struct inode *, struct page *);
 #endif
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index d99d173..a8329de 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -332,6 +332,9 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
 	unsigned offset = from & (PAGE_CACHE_SIZE - 1);
 	struct page *page;
 
+	if (f2fs_has_inline_data(inode))
+		truncate_inline_data(inode, from);
+
 	if (!offset)
 		return;
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 3258c7c..84cd893 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -176,6 +176,24 @@ int f2fs_write_inline_data(struct inode *inode,
 	return 0;
 }
 
+void truncate_inline_data(struct inode *inode, u64 from)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct page *ipage;
+
+	if (from >= MAX_INLINE_DATA)
+		return;
+
+	ipage = get_node_page(sbi, inode->i_ino);
+	if (IS_ERR(ipage))
+		return;
+
+	zero_user_segment(ipage, INLINE_DATA_OFFSET + from,
+				INLINE_DATA_OFFSET + MAX_INLINE_DATA);
+
+	f2fs_put_page(ipage, 1);
+}
+
 int recover_inline_data(struct inode *inode, struct page *npage)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-- 
1.7.9.5


