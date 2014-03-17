Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbaCQIgK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 04:36:10 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48973 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbaCQIgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 04:36:08 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-39-5326b3f686b3
From: Chao Yu <chao2.yu@samsung.com>
To: ??? <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev] [PATCH 1/2] f2fs: introduce f2fs_has_xattr_block for better
 readability
Date: Mon, 17 Mar 2014 16:35:06 +0800
Message-id: <000001cf41bb$f0754220$d15fc660$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9BuWeJ7+oGJppASuqTQ/wbn0QYwg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jAd1vm9WCDbrnGVpc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfHmZlXBWb6Km28P
	MzUw/uTuYuTkkBAwkbizfgIrhC0mceHeerYuRi4OIYFFjBJH309jgXB+MEpM/3icHaSKTUBF
	YnnHfyYQW0RAUWLD+w1gcWaBTIl7TTOYQWxhgViJY+2fweIsAqoSHxb/ZwGxeQUsJV58/8cE
	YQtK/Jh8jwWiV0ti/c7jTBC2vMTmNW+ZIS5SkNhx9jUjxC49ifsXX0PViEtsPHKLZQKjwCwk
	o2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAgO5GfSOxhXNVgcYhTg
	YFTi4Z2grBYsxJpYVlyZe4hRgoNZSYSXdy1QiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutA
	IYH0xJLU7NTUgtQimCwTB6dUA+PGZ6e8tgu6R+l95lioXsj/5Pf7F+tab/Ewq9dPOxRQ94WP
	8d/+U+4cLD3x+77/8WSxuaS07+6St8rdE3d3fF1zo1JZKP/xrv9fNhgtsrUWO/M6UVTWmfvI
	20dT7blvKq6Lf3Ts/tHsTHZm61UJufXyUhxSfkmfNrlJqAqHBfzJnyBu0PHs1UQlluKMREMt
	5qLiRAB/8AxFYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a help function f2fs_has_xattr_block for better
readability.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h |    5 +++++
 fs/f2fs/node.c |    4 ++--
 fs/f2fs/node.h |    2 +-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1f87a04..292cc3c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -637,6 +637,11 @@ static inline int F2FS_HAS_BLOCKS(struct inode *inode)
 		return inode->i_blocks > F2FS_DEFAULT_ALLOCATED_BLOCKS;
 }
 
+static inline bool f2fs_has_xattr_block(unsigned int ofs)
+{
+	return ofs == XATTR_NODE_OFFSET;
+}
+
 static inline bool inc_valid_block_count(struct f2fs_sb_info *sbi,
 				 struct inode *inode, blkcnt_t count)
 {
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c618fad..3e36240 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -836,7 +836,7 @@ struct page *new_node_page(struct dnode_of_data *dn,
 	SetPageUptodate(page);
 	set_page_dirty(page);
 
-	if (ofs == XATTR_NODE_OFFSET)
+	if (f2fs_has_xattr_block(ofs))
 		F2FS_I(dn->inode)->i_xattr_nid = dn->nid;
 
 	dn->node_page = page;
@@ -1533,7 +1533,7 @@ bool recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
 
 	recover_inline_xattr(inode, page);
 
-	if (ofs_of_node(page) != XATTR_NODE_OFFSET)
+	if (!f2fs_has_xattr_block(ofs_of_node(page)))
 		return false;
 
 	/* 1: invalidate the previous xattr nid */
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 4dea719..ee6d286 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -242,7 +242,7 @@ static inline bool IS_DNODE(struct page *node_page)
 {
 	unsigned int ofs = ofs_of_node(node_page);
 
-	if (ofs == XATTR_NODE_OFFSET)
+	if (f2fs_has_xattr_block(ofs))
 		return false;
 
 	if (ofs == 3 || ofs == 4 + NIDS_PER_BLOCK ||
-- 
1.7.9.5


