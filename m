Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaHDBzw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 21:55:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41751 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaHDBzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 21:55:51 -0400
X-AuditID: cbfee61a-f79e46d00000134f-6d-53dee824f4c9
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/2 v2] f2fs: invalidate xattr node page when evict
 inode
Date: Mon, 04 Aug 2014 09:54:58 +0800
Message-id: <001d01cfaf87$3664dfa0$a32e9ee0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+vhoCTf7BxmAJNSdK5OEYKcF7+bA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jAV2VF/eCDRbPN7e4tq+RyeLJ+lnM
	FpcWuVvs2XuSxeLyrjlsDqwem1Z1snnsXvCZyaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	JryfylzQz1Wx+HFlA+Mpji5GTg4JAROJDVN/skLYYhIX7q1nA7GFBBYxSmzt0uli5AKyfzBK
	rD30igkkwSagIrG84z+YLSLgJTFp/wkWEJtZIFPiXtMMZhBbWCBUoqf/MSOIzSKgKvG67xJY
	Da+ApcSKhlY2CFtQ4sfke1C9WhLrdx5ngrDlJTavecsMcZCCxI6zrxkhdulJnGncwwhRIy6x
	8cgtlgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4tJ9J
	7WBc2WBxiFGAg1GJh1dh791gIdbEsuLK3EOMEhzMSiK81tfuBQvxpiRWVqUW5ccXleakFh9i
	lOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgXOYqanjvk0nW97kBZ4+L7RKVL7n26vnd
	3qO8Dfs3Tzx/+U7WOTup3Q8WeAv/FJaeniryKUVfrPXz/ccyoifaov8LTf0eP0+kYsak1o0i
	en//ZpdrpyX29BfHV8S11nN8fx19xKVqxdqovFKfI9lFcfc8nPadzrnTGfEvsiCqoa/52Lun
	AafqlFiKMxINtZiLihMBUZPb7WkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When inode is evicted, all the page cache belong to this inode should be
released including the xattr node page. But previously we didn't do this, this
patch fixed this issue.

v2:
 o reposition invalidate_mapping_pages() to the right place suggested by
Jaegeuk Kim.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 0e69aa9..2c39999 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -267,6 +267,7 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 void f2fs_evict_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 
 	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages_final(&inode->i_data);
@@ -296,6 +297,8 @@ void f2fs_evict_inode(struct inode *inode)
 	sb_end_intwrite(inode->i_sb);
 no_delete:
 	invalidate_mapping_pages(NODE_MAPPING(sbi), inode->i_ino, inode->i_ino);
+	if (xnid)
+		invalidate_mapping_pages(NODE_MAPPING(sbi), xnid, xnid);
 	if (is_inode_flag_set(F2FS_I(inode), FI_APPEND_WRITE))
 		add_dirty_inode(sbi, inode->i_ino, APPEND_INO);
 	if (is_inode_flag_set(F2FS_I(inode), FI_UPDATE_WRITE))
-- 
2.0.1.474.g72c7794


