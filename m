Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756416AbaD2BDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 21:03:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31948 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaD2BDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 21:03:47 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-a3-535efa71d6a3
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 3/3 v2] f2fs: fix to truncate inline data in inode
 page when setattr
Date: Tue, 29 Apr 2014 09:03:03 +0800
Message-id: <000001cf6346$dfbc8bd0$9f35a370$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9jQ+lnpMm7XBeMRA+6TC0l9vTNiQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd3CX3HBBpdv81lc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldHW+oetoF2oYtP5
	JsYGxhd8XYycHBICJhL7l01jgbDFJC7cW8/WxcjFISSwiFGi+doVsISQwA9GidV3S0FsNgEV
	ieUd/5lAbBEBRYkN7zewg9jMApkS95pmMIPYwgIJEl8OnGfsYuTgYBFQlZj0SQDE5BWwlJj4
	NhKkgldAUOLH5HssEJ1aEut3HmeCsOUlNq95ywxxjoLEjrOvGSE26Uns3jwDapO4xMYjt1gm
	MArMQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4CB+JrWDcWWD
	xSFGAQ5GJR5eg6i4YCHWxLLiytxDjBIczEoivLatQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8
	B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2MQQtDsyrn5guWmUvv33o2Y8L/rQn5zXx5pm8YN2RU
	6RYYTxRb9uPiK//HBu38pgYbrse71nWFh9/Qm5gos/tUQev8F6waZSf/JAgnNS21OP6ph+v+
	wxkLH55c3l/G+WlKzPli2U/nf90MC9n9IVr2f+TGRJN77hfT9zkFcMwpUGW+1fjcdH+lEktx
	RqKhFnNRcSIAmpPKQl4CAAA=
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

change log from v1:
 o fix a bug and do not truncate first page data after truncate inline data.

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
index d99d173..1b27bd6 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -332,6 +332,9 @@ static void truncate_partial_data_page(struct inode *inode, u64 from)
 	unsigned offset = from & (PAGE_CACHE_SIZE - 1);
 	struct page *page;
 
+	if (f2fs_has_inline_data(inode))
+		return truncate_inline_data(inode, from);
+
 	if (!offset)
 		return;
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 3258c7c..d215dbb 100644
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
+	set_page_dirty(ipage);
+	f2fs_put_page(ipage, 1);
+}
+
 int recover_inline_data(struct inode *inode, struct page *npage)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
-- 
1.7.9.5


