Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3JYQH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:07:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:16585 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab3JYQH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:07:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,571,1378882800"; 
   d="scan'208";a="417211518"
From: Huajun Li <huajun.li.lee@gmail.com>
To: jaegeuk.kim@samsung.com, linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Subject: [f2fs-dev 1/5] f2fs: Add flags and helpers to support inline data
Date: Sat, 26 Oct 2013 00:01:55 +0800
Message-Id: <1382716919-23345-2-git-send-email-huajun.li.lee@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
References: <1382716919-23345-1-git-send-email-huajun.li.lee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huajun Li <huajun.li@intel.com>

Add new inode flags F2FS_INLINE_DATA and FI_INLINE_DATA to indicate
whether the inode has inline data.

Inline data makes use of inode block's data indices region to save small
file. Currently there are 923 data indices in an inode block. Since
inline xattr has made use of the last 50 indices to save its data, there
are 873 indices left which can be used for inline data. When
FI_INLINE_DATA is set, the layout of inode block's indices region is
like below:
+-----------------+
|                 | Reserved. reserve_new_block() will make use of
| i_addr[0]       | i_addr[0] when we need to reserve a new data block
|                 | to convert inline data into regular one's.
|-----------------|
|                 | Used by inline data. A file whose size is less than
| i_addr[1..872]  | 3488 bytes(~3.4k) and doesn't reserve extra
|                 | blocks by fallocate() can be saved here.
|-----------------|
| i_addr[873-922] | Reserved for inline xattr
+-----------------+

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Huajun Li <huajun.li@intel.com>
Signed-off-by: Weihong Xu <weihong.xu@intel.com>
---
 fs/f2fs/f2fs.h          |   14 ++++++++++++++
 include/linux/f2fs_fs.h |    8 ++++++++
 2 files changed, 22 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a61cc5f..e50a8b0 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -31,6 +31,7 @@
 #define F2FS_MOUNT_POSIX_ACL		0x00000020
 #define F2FS_MOUNT_DISABLE_EXT_IDENTIFY	0x00000040
 #define F2FS_MOUNT_INLINE_XATTR		0x00000080
+#define F2FS_MOUNT_INLINE_DATA		0x00000100
 
 #define clear_opt(sbi, option)	(sbi->mount_opt.opt &= ~F2FS_MOUNT_##option)
 #define set_opt(sbi, option)	(sbi->mount_opt.opt |= F2FS_MOUNT_##option)
@@ -871,6 +872,7 @@ enum {
 	FI_UPDATE_DIR,		/* should update inode block for consistency */
 	FI_DELAY_IPUT,		/* used for the recovery */
 	FI_INLINE_XATTR,	/* used for inline xattr */
+	FI_INLINE_DATA,		/* used for inline data*/
 };
 
 static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
@@ -908,6 +910,8 @@ static inline void get_inline_info(struct f2fs_inode_info *fi,
 {
 	if (ri->i_inline & F2FS_INLINE_XATTR)
 		set_inode_flag(fi, FI_INLINE_XATTR);
+	if (ri->i_inline & F2FS_INLINE_DATA)
+		set_inode_flag(fi, FI_INLINE_DATA);
 }
 
 static inline void set_raw_inline(struct f2fs_inode_info *fi,
@@ -917,6 +921,8 @@ static inline void set_raw_inline(struct f2fs_inode_info *fi,
 
 	if (is_inode_flag_set(fi, FI_INLINE_XATTR))
 		ri->i_inline |= F2FS_INLINE_XATTR;
+	if (is_inode_flag_set(fi, FI_INLINE_DATA))
+		ri->i_inline |= F2FS_INLINE_DATA;
 }
 
 static inline unsigned int addrs_per_inode(struct f2fs_inode_info *fi)
@@ -942,6 +948,13 @@ static inline int inline_xattr_size(struct inode *inode)
 		return 0;
 }
 
+static inline void *inline_data_addr(struct page *page)
+{
+	struct f2fs_inode *ri;
+	ri = (struct f2fs_inode *)page_address(page);
+	return (void *)&(ri->i_addr[1]);
+}
+
 static inline int f2fs_readonly(struct super_block *sb)
 {
 	return sb->s_flags & MS_RDONLY;
@@ -1231,4 +1244,5 @@ extern const struct address_space_operations f2fs_meta_aops;
 extern const struct inode_operations f2fs_dir_inode_operations;
 extern const struct inode_operations f2fs_symlink_inode_operations;
 extern const struct inode_operations f2fs_special_inode_operations;
+
 #endif
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index bb942f6..aea5eed 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -153,6 +153,14 @@ struct f2fs_extent {
 #define	NODE_DIND_BLOCK		(DEF_ADDRS_PER_INODE + 5)
 
 #define F2FS_INLINE_XATTR	0x01	/* file inline xattr flag */
+#define F2FS_INLINE_DATA	0x02	/* file inline data flag */
+
+
+#define MAX_INLINE_DATA		(sizeof(__le32) * (DEF_ADDRS_PER_INODE - \
+						F2FS_INLINE_XATTR_ADDRS - 1))
+
+#define INLINE_DATA_OFFSET	(PAGE_CACHE_SIZE - sizeof(struct node_footer) \
+				- sizeof(__le32)*(DEF_ADDRS_PER_INODE + 5 - 1))
 
 struct f2fs_inode {
 	__le16 i_mode;			/* file mode */
-- 
1.7.9.5

