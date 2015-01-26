Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbbAZFo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 00:44:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55502 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbbAZFo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 00:44:56 -0500
X-AuditID: cbfee61a-f79c06d000004e71-55-54c5d4561718
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2 01/10] f2fs: move ext_lock out of struct
 extent_info
Date: Mon, 26 Jan 2015 13:44:08 +0800
Message-id: <005d01d0392b$35b8e0f0$a12aa2d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA23VXAS00uz+A+Q3K9FfQOVXCUZA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd2wK0dDDK7tU7a4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxpc9L5gL
	1qhUbL91i7mBsU2ui5GTQ0LAROLz7y4WCFtM4sK99WwgtpDAdEaJ/1eEuxi5gOwfjBJb395i
	AkmwCahILO/4D2aLCHhJTNp/AqyZWcBDorHjOyuILSwQLLG27wGYzSKgKnHx731GEJtXwFLi
	556FULagxI/J96B6tSTW7zzOBGHLS2xe85YZ4iAFiR1nXwPVcwDt0pP4MVUfokRcYuORWywT
	GAVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcEA/k9rBuLLB
	4hCjAAejEg9vQ/PRECHWxLLiytxDjBIczEoivOVTgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5
	lezbQoQE0hNLUrNTUwtSi2CyTBycUg2MLFPF7D/piU96pjnN8fcm78AbuopH3cI787p+Pj/r
	t/dUvIhEJdukqnTJOu5Vv35xHTQ8dHpznPmmTdu3Fp1hE0n9viHgw1YRc8N1sZek3A9u65/n
	3j+zy/dWQXV2ZGTsy8mLuV2sPE1rZssdZwhmeWDynWdC4IEJit+m8Fy8PEnhU/kB1VuHlFiK
	MxINtZiLihMBLz6bkWQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move ext_lock out of struct extent_info, then in the following patches we can
use variables with struct extent_info type as a parameter to pass pure data.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/data.c  | 12 ++++++------
 fs/f2fs/f2fs.h  |  6 +-----
 fs/f2fs/inode.c |  7 +++++++
 fs/f2fs/super.c |  2 +-
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a7b905c..fece5cc 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -258,9 +258,9 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 	if (is_inode_flag_set(fi, FI_NO_EXTENT))
 		return 0;
 
-	read_lock(&fi->ext.ext_lock);
+	read_lock(&fi->ext_lock);
 	if (fi->ext.len == 0) {
-		read_unlock(&fi->ext.ext_lock);
+		read_unlock(&fi->ext_lock);
 		return 0;
 	}
 
@@ -284,10 +284,10 @@ static int check_extent_cache(struct inode *inode, pgoff_t pgofs,
 			bh_result->b_size = UINT_MAX;
 
 		stat_inc_read_hit(inode->i_sb);
-		read_unlock(&fi->ext.ext_lock);
+		read_unlock(&fi->ext_lock);
 		return 1;
 	}
-	read_unlock(&fi->ext.ext_lock);
+	read_unlock(&fi->ext_lock);
 	return 0;
 }
 
@@ -309,7 +309,7 @@ void update_extent_cache(struct dnode_of_data *dn)
 	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
 							dn->ofs_in_node;
 
-	write_lock(&fi->ext.ext_lock);
+	write_lock(&fi->ext_lock);
 
 	start_fofs = fi->ext.fofs;
 	end_fofs = fi->ext.fofs + fi->ext.len - 1;
@@ -366,7 +366,7 @@ void update_extent_cache(struct dnode_of_data *dn)
 		need_update = true;
 	}
 end_update:
-	write_unlock(&fi->ext.ext_lock);
+	write_unlock(&fi->ext_lock);
 	if (need_update)
 		sync_inode_page(dn);
 	return;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 1795ce2..f1452a3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -271,7 +271,6 @@ enum {
 #define F2FS_MIN_EXTENT_LEN	16	/* minimum extent length */
 
 struct extent_info {
-	rwlock_t ext_lock;	/* rwlock for consistency */
 	unsigned int fofs;	/* start offset in a file */
 	u32 blk_addr;		/* start block address of the extent */
 	unsigned int len;	/* length of the extent */
@@ -303,6 +302,7 @@ struct f2fs_inode_info {
 	nid_t i_xattr_nid;		/* node id that contains xattrs */
 	unsigned long long xattr_ver;	/* cp version of xattr modification */
 	struct extent_info ext;		/* in-memory extent cache entry */
+	rwlock_t ext_lock;		/* rwlock for single extent cache */
 	struct inode_entry *dirty_dir;	/* the pointer of dirty dir */
 
 	struct radix_tree_root inmem_root;	/* radix tree for inmem pages */
@@ -313,21 +313,17 @@ struct f2fs_inode_info {
 static inline void get_extent_info(struct extent_info *ext,
 					struct f2fs_extent i_ext)
 {
-	write_lock(&ext->ext_lock);
 	ext->fofs = le32_to_cpu(i_ext.fofs);
 	ext->blk_addr = le32_to_cpu(i_ext.blk_addr);
 	ext->len = le32_to_cpu(i_ext.len);
-	write_unlock(&ext->ext_lock);
 }
 
 static inline void set_raw_extent(struct extent_info *ext,
 					struct f2fs_extent *i_ext)
 {
-	read_lock(&ext->ext_lock);
 	i_ext->fofs = cpu_to_le32(ext->fofs);
 	i_ext->blk_addr = cpu_to_le32(ext->blk_addr);
 	i_ext->len = cpu_to_le32(ext->len);
-	read_unlock(&ext->ext_lock);
 }
 
 struct f2fs_nm_info {
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 2d002e3..28dd26a 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -130,7 +130,10 @@ static int do_read_inode(struct inode *inode)
 	fi->i_pino = le32_to_cpu(ri->i_pino);
 	fi->i_dir_level = ri->i_dir_level;
 
+	write_lock(&fi->ext_lock);
 	get_extent_info(&fi->ext, ri->i_ext);
+	write_unlock(&fi->ext_lock);
+
 	get_inline_info(fi, ri);
 
 	/* check data exist */
@@ -220,7 +223,11 @@ void update_inode(struct inode *inode, struct page *node_page)
 	ri->i_links = cpu_to_le32(inode->i_nlink);
 	ri->i_size = cpu_to_le64(i_size_read(inode));
 	ri->i_blocks = cpu_to_le64(inode->i_blocks);
+
+	read_lock(&F2FS_I(inode)->ext_lock);
 	set_raw_extent(&F2FS_I(inode)->ext, &ri->i_ext);
+	read_unlock(&F2FS_I(inode)->ext_lock);
+
 	set_raw_inline(F2FS_I(inode), ri);
 
 	ri->i_atime = cpu_to_le64(inode->i_atime.tv_sec);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 0d627f2..5706c17 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -382,7 +382,7 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 	atomic_set(&fi->dirty_pages, 0);
 	fi->i_current_depth = 1;
 	fi->i_advise = 0;
-	rwlock_init(&fi->ext.ext_lock);
+	rwlock_init(&fi->ext_lock);
 	init_rwsem(&fi->i_sem);
 	INIT_RADIX_TREE(&fi->inmem_root, GFP_NOFS);
 	INIT_LIST_HEAD(&fi->inmem_pages);
-- 
2.2.1


