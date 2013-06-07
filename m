Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab3FGIIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:08:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54597 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab3FGIIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:08:43 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-b2-51b195099281
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix i_blocks translation on various types of files
Date: Fri, 07 Jun 2013 17:07:23 +0900
Message-id: <1370592443-30457-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t8zA13OqRsDDf5v17a4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK2Nl63WWgpUiFZf+
	f2NvYHwo0MXIwSEhYCKxexVXFyMnkCkmceHeerYuRi4OIYFljBKT9/9gg0iYSLze84sVpF5I
	YDqjxCVfiJo2JoltF2+DxdkEtCU27zcAKRcRYJZYMPU8I0gNs8AERon/i96zgCSEBTwlDqz+
	wgRiswioSpxp6GEGsXkF3CXO/rrPCrFLV2L1/+fsEPZjNollh60g6gUkvk0+xAJxs6zEpgPM
	ECWSEgdX3GCZwCi4gJFhFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZI8E3YwXjvgPUhxmSg
	cROZpUST84HBm1cSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGxn7DpYu81Lif7W/hkpyw+ntGx9Ht7cHNbuESJcHJWnUT/5mf9T25a2ZUzKWYF6va
	2Ks8ebbprXhfd2ktl6cAm82qG0aFaxbPXzz7qVLlkRsb9nVvy9rBIFwdeemgSulOxrITKdnV
	CfJaE449e6gREb35CverOWxm/hum3fto8vlFtv0zxu/PBJRYijMSDbWYi4oTAVHGvShUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAIsWRmVeSWpSXmKPExsVy+t9jQV3OqRsDDc52qFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ixsvU6S8FKkYpL/7+xNzA+FOhi5OSQEDCReL3nFyuELSZx4d56ti5GDg4h
	gemMEpd8uxi5gMw2JoltF2+zgsTZBLQlNu83ACkXEWCWWDD1PCNIDbPABEaJ/4ves4AkhAU8
	JQ6s/sIEYrMIqEqcaehhBrF5Bdwlzv66D7VLV2L1/+fsExi5FzAyrGIUTS1ILihOSs810itO
	zC0uzUvXS87P3cQIDu9n0jsYVzVYHGIU4GBU4uH9sWpDoBBrYllxZe4hRgkOZiUR3vVpGwOF
	eFMSK6tSi/Lji0pzUosPMSYDbZ/ILCWanA+MvbySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcK
	CaQnlqRmp6YWpBbBbGHi4JRqYFy+5caUSiHF7/xTwzrUl7/onb9QXewcc/D5g65r9lXLiX98
	m9431zhKf/qeqTdM7k/o4N8Ud+qXYdOpT83udevj/eQdCjQ7oyVSd++ZmHrzlvlOKzF56S72
	nuXfF+28kV9h3belpMh9/wLGinVL62Z+X+7yODmknr/kyJQZO15znjUV7j3AlaLEUpyRaKjF
	XFScCACXs5skswIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically an inode manages the number of allocated blocks with inode->i_blocks
which is represented in a unit of sectors, not file system blocks.
But, f2fs has used i_blocks in a unit of file system blocks, and f2fs_getattr
translates it to the number of sectors when fstat is called.

However, previously f2fs_file_inode_operations only has this, so this patch adds
it to all the types of inode_operations.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h  | 1 +
 fs/f2fs/file.c  | 2 +-
 fs/f2fs/namei.c | 3 +++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d6e63da..bfb97c9 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -903,6 +903,7 @@ static inline int f2fs_readonly(struct super_block *sb)
 int f2fs_sync_file(struct file *, loff_t, loff_t, int);
 void truncate_data_blocks(struct dnode_of_data *);
 void f2fs_truncate(struct inode *);
+int f2fs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 int f2fs_setattr(struct dentry *, struct iattr *);
 int truncate_hole(struct inode *, pgoff_t, pgoff_t);
 int truncate_data_blocks_range(struct dnode_of_data *, int);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index deefd25..8d2fce9 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -291,7 +291,7 @@ void f2fs_truncate(struct inode *inode)
 	}
 }
 
-static int f2fs_getattr(struct vfsmount *mnt,
+int f2fs_getattr(struct vfsmount *mnt,
 			 struct dentry *dentry, struct kstat *stat)
 {
 	struct inode *inode = dentry->d_inode;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 1fe1502..810444e 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -490,6 +490,7 @@ const struct inode_operations f2fs_dir_inode_operations = {
 	.rmdir		= f2fs_rmdir,
 	.mknod		= f2fs_mknod,
 	.rename		= f2fs_rename,
+	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
 	.get_acl	= f2fs_get_acl,
 #ifdef CONFIG_F2FS_FS_XATTR
@@ -504,6 +505,7 @@ const struct inode_operations f2fs_symlink_inode_operations = {
 	.readlink       = generic_readlink,
 	.follow_link    = page_follow_link_light,
 	.put_link       = page_put_link,
+	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
 #ifdef CONFIG_F2FS_FS_XATTR
 	.setxattr	= generic_setxattr,
@@ -514,6 +516,7 @@ const struct inode_operations f2fs_symlink_inode_operations = {
 };
 
 const struct inode_operations f2fs_special_inode_operations = {
+	.getattr	= f2fs_getattr,
 	.setattr        = f2fs_setattr,
 	.get_acl	= f2fs_get_acl,
 #ifdef CONFIG_F2FS_FS_XATTR
-- 
1.8.1.3.566.gaa39828

