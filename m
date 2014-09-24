Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaIXKQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:16:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14055 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaIXKQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:16:05 -0400
X-AuditID: cbfee61a-f79c06d000004e71-8c-542299e21f98
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 1/6 v2] f2fs: add infra struct and helper for inline
 dir
Date: Wed, 24 Sep 2014 18:15:19 +0800
Message-id: <003c01cfd7e0$8b671af0$a23550d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/X34hkNTGWQTwoQUOMVBiwPD6HoA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd1HM5VCDP5+4bO4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxt4jy1gK
	NshXNE45wdzAuFyqi5GdQ0LAROKScxcjJ5AlJnHh3no2EFtIYBGjxPb5kl2MXED2D0aJLzu2
	giXYBFQklnf8ZwKxRQS8JCbtP8ECYjMLeEg0dnxnBbGFBUIk7r++C1bPIqAqcevSLjCbV8BS
	YvHknywQtqDEj8n3oHq1JNbvPM4EYctLbF7zlhniIAWJHWdfM3YxcgDt0pNoXW4OUSIusfHI
	LZYJjAKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOJifSe1g
	XNlgcYhRgINRiYd3grhSiBBrYllxZe4hRgkOZiUR3lc9QCHelMTKqtSi/Pii0pzU4kOM0hws
	SuK8B1qtA4UE0hNLUrNTUwtSi2CyTBycUg2M/A15FV97fh05074h87hhRfzPS16pJkGTTgpc
	U2OPDr8U5RPw6p+qU5ZghKfQIutG3WXvypwXaB5zqz15+azXqkUztnbtfdy4eVGQVudqu81s
	thJ3OL4wsrXycqwXkiyx8nrHL/bGvq/hxhLDmV99DD72r572XnnXLcbZkqevMVwVUU17M+OQ
	EktxRqKhFnNRcSIAEt78M2ICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines macro/inline dentry structure, and adds some helpers for
inline dir infrastructure.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h          | 21 +++++++++++++++++++--
 include/linux/f2fs_fs.h | 19 +++++++++++++++++++
 2 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 94cfdc4..b94721c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -46,8 +46,9 @@
 #define F2FS_MOUNT_DISABLE_EXT_IDENTIFY	0x00000040
 #define F2FS_MOUNT_INLINE_XATTR		0x00000080
 #define F2FS_MOUNT_INLINE_DATA		0x00000100
-#define F2FS_MOUNT_FLUSH_MERGE		0x00000200
-#define F2FS_MOUNT_NOBARRIER		0x00000400
+#define F2FS_MOUNT_INLINE_DENTRY	0x00000200
+#define F2FS_MOUNT_FLUSH_MERGE		0x00000400
+#define F2FS_MOUNT_NOBARRIER		0x00000800
 
 #define clear_opt(sbi, option)	(sbi->mount_opt.opt &= ~F2FS_MOUNT_##option)
 #define set_opt(sbi, option)	(sbi->mount_opt.opt |= F2FS_MOUNT_##option)
@@ -1049,6 +1050,7 @@ enum {
 	FI_NO_EXTENT,		/* not to use the extent cache */
 	FI_INLINE_XATTR,	/* used for inline xattr */
 	FI_INLINE_DATA,		/* used for inline data*/
+	FI_INLINE_DENTRY,	/* used for inline dentry */
 	FI_APPEND_WRITE,	/* inode has appended data */
 	FI_UPDATE_WRITE,	/* inode has in-place-update data */
 	FI_NEED_IPU,		/* used fo ipu for fdatasync */
@@ -1093,6 +1095,8 @@ static inline void get_inline_info(struct f2fs_inode_info *fi,
 		set_inode_flag(fi, FI_INLINE_XATTR);
 	if (ri->i_inline & F2FS_INLINE_DATA)
 		set_inode_flag(fi, FI_INLINE_DATA);
+	if (ri->i_inline & F2FS_INLINE_DENTRY)
+		set_inode_flag(fi, FI_INLINE_DENTRY);
 }
 
 static inline void set_raw_inline(struct f2fs_inode_info *fi,
@@ -1104,6 +1108,8 @@ static inline void set_raw_inline(struct f2fs_inode_info *fi,
 		ri->i_inline |= F2FS_INLINE_XATTR;
 	if (is_inode_flag_set(fi, FI_INLINE_DATA))
 		ri->i_inline |= F2FS_INLINE_DATA;
+	if (is_inode_flag_set(fi, FI_INLINE_DENTRY))
+		ri->i_inline |= F2FS_INLINE_DENTRY;
 }
 
 static inline int f2fs_has_inline_xattr(struct inode *inode)
@@ -1144,6 +1150,17 @@ static inline void *inline_data_addr(struct page *page)
 	return (void *)&(ri->i_addr[1]);
 }
 
+static inline int f2fs_has_inline_dentry(struct inode *inode)
+{
+	return is_inode_flag_set(F2FS_I(inode), FI_INLINE_DENTRY);
+}
+
+static inline void *inline_dentry_addr(struct page *page)
+{
+	struct f2fs_inode *ri = F2FS_INODE(page);
+	return (void *)&(ri->i_addr[1]);
+}
+
 static inline int f2fs_readonly(struct super_block *sb)
 {
 	return sb->s_flags & MS_RDONLY;
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 860313a..29b3cf3 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -170,6 +170,7 @@ struct f2fs_extent {
 
 #define F2FS_INLINE_XATTR	0x01	/* file inline xattr flag */
 #define F2FS_INLINE_DATA	0x02	/* file inline data flag */
+#define F2FS_INLINE_DENTRY	0x04	/* file inline dentry flag */
 
 #define MAX_INLINE_DATA		(sizeof(__le32) * (DEF_ADDRS_PER_INODE - \
 						F2FS_INLINE_XATTR_ADDRS - 1))
@@ -435,6 +436,24 @@ struct f2fs_dentry_block {
 	__u8 filename[NR_DENTRY_IN_BLOCK][F2FS_SLOT_LEN];
 } __packed;
 
+/* for inline dir */
+#define NR_INLINE_DENTRY	(MAX_INLINE_DATA * BITS_PER_BYTE / \
+				((SIZE_OF_DIR_ENTRY + F2FS_SLOT_LEN) * \
+				BITS_PER_BYTE + 1))
+#define INLINE_DENTRY_BITMAP_SIZE	((NR_INLINE_DENTRY + \
+					BITS_PER_BYTE - 1) / BITS_PER_BYTE)
+#define INLINE_RESERVED_SIZE	(MAX_INLINE_DATA - \
+				((SIZE_OF_DIR_ENTRY + F2FS_SLOT_LEN) * \
+				NR_INLINE_DENTRY + INLINE_DENTRY_BITMAP_SIZE))
+
+/* inline directory entry structure */
+struct f2fs_inline_dentry {
+	__u8 dentry_bitmap[INLINE_DENTRY_BITMAP_SIZE];
+	__u8 reserved[INLINE_RESERVED_SIZE];
+	struct f2fs_dir_entry dentry[NR_INLINE_DENTRY];
+	__u8 filename[NR_INLINE_DENTRY][F2FS_SLOT_LEN];
+} __packed;
+
 /* file types used in inode_info->flags */
 enum {
 	F2FS_FT_UNKNOWN,
-- 
2.0.1.474.g72c7794


