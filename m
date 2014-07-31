Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaGaNOE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:14:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13473 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaGaNOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:14:02 -0400
X-AuditID: cbfee61a-f79e46d00000134f-32-53da41173d65
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/2] f2fs: invalidate xattr node page when evict inode
Date: Thu, 31 Jul 2014 21:13:11 +0800
Message-id: <017301cfacc1$4b476730$e1d63590$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: zh-cn
Thread-index: Ac+swS2+xqKXLmheR4O/Yr1hC0BQYA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jAV0Jx1vBBvMrLK7ta2SyeLJ+FrPF
	pUXuFnv2nmSxuLxrDpsDq8emVZ1sHrsXfGby6NuyitHj8ya5AJYoLpuU1JzMstQifbsErozj
	y6YxF3xkr5jZ8oepgfEwWxcjJ4eEgInEzeY9rBC2mMSFe+uB4lwcQgKLGCVef90J5fxglNj2
	bTozSBWbgIrE8o7/TCC2iICXxKT9J1hAbGaBTIl7TTPAaoQFAiT+zv0JZHNwsAioSqw4nAAS
	5hWwlHhz7iw7hC0o8WPyPahWLYn1O48zQdjyEpvXvGWGOEhBYsfZ14wQcXGJjUdusUCs1ZPY
	feAD8wRGgVlIRs1CMmoWklGzkLQvYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc2s+k
	djCubLA4xCjAwajEw/vD5GawEGtiWXFl7iFGCQ5mJRHeKMtbwUK8KYmVValF+fFFpTmpxYcY
	pTlYlMR5D7RaBwoJpCeWpGanphakFsFkmTg4pRoYnX8+uLWd55vq/Hlz477tUilqWOzg4L6Z
	i6t2vsKB3XKT/S7NuNi1sP/O5MRZa5OeSPEbW2SVz3xe0TDhbexOuZk37Q3qvvlej98jsOPw
	Z7cXU09X63Fusjuew+lkt8BbJ7x0WdfFSoVLdXxZy+5fbWi1XM7wWML+fobiu0KTT/c+9Iam
	WcuaKrEUZyQaajEXFScCAMkYxrtpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When inode is evicted, all the page cache belong to this inode should be
released including the xattr node page. But previously we didn't do this, this
patch fixed this issue.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/inode.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 0e69aa9..8a5403b 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -267,10 +267,16 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 void f2fs_evict_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	struct f2fs_inode_info *fi = F2FS_I(inode);
 
 	trace_f2fs_evict_inode(inode);
+
 	truncate_inode_pages_final(&inode->i_data);
 
+	if (fi->i_xattr_nid)
+		invalidate_mapping_pages(NODE_MAPPING(sbi),
+					fi->i_xattr_nid, fi->i_xattr_nid);
+
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
 			inode->i_ino == F2FS_META_INO(sbi))
 		goto out_clear;
-- 
2.0.1.474.g72c7794


