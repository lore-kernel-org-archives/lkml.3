Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3FCKE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 06:04:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:37171 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab3FCKEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 06:04:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,791,1363158000"; 
   d="scan'208";a="249941753"
From: Huajun Li <huajun.li@intel.com>
To: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        huajun.li.lee@gmail.com
Cc: namjae.jeon@samsung.com, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Huajun Li <huajun.li@intel.com>
Subject: [RFC 1/5] f2fs: Add helper functions and flag to support inline data
Date: Mon,  3 Jun 2013 18:04:10 +0800
Message-Id: <1370253854-15084-2-git-send-email-huajun.li@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
References: <1370253854-15084-1-git-send-email-huajun.li@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haicheng Li <haicheng.li@linux.intel.com>

Add a new flag i_dyn_flags to struct f2fs_inode_info to indicate whether
the inode has inline data, and sync the flag with raw inode while update
file.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Huajun Li <huajun.li@intel.com>
---
 fs/f2fs/f2fs.h          |   70 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/inode.c         |    8 ++++++
 include/linux/f2fs_fs.h |    5 ++++
 3 files changed, 83 insertions(+)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 40b137a..9382f76 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -162,6 +162,7 @@ struct f2fs_inode_info {
 	umode_t i_acl_mode;		/* keep file acl mode temporarily */
 
 	/* Use below internally in f2fs*/
+	unsigned long i_dyn_flags;	/* use to mark dynamic features */
 	unsigned long flags;		/* use to pass per-file flags */
 	atomic_t dirty_dents;		/* # of dirty dentry pages */
 	f2fs_hash_t chash;		/* hash value of given file name */
@@ -170,6 +171,14 @@ struct f2fs_inode_info {
 	struct extent_info ext;		/* in-memory extent cache entry */
 };
 
+/*
+ * Flags on f2fs_inode_info.i_dyn_flags
+ *
+ * These can change much more often than i_flags.
+ */
+#define F2FS_INLINE_DATA_FL       (0x00000001)	/* Data stored in inode block */
+#define F2FS_INLINE_DATA_ATTEMPT  (0x00000002)	/* Data stored in inode block */
+
 static inline void get_extent_info(struct extent_info *ext,
 					struct f2fs_extent i_ext)
 {
@@ -877,6 +886,21 @@ static inline void clear_inode_flag(struct f2fs_inode_info *fi, int flag)
 	clear_bit(flag, &fi->flags);
 }
 
+static inline void set_inode_dyn_flag(struct f2fs_inode_info *fi, int flag)
+{
+	set_bit(flag, &fi->i_dyn_flags);
+}
+
+static inline int is_inode_dyn_flag_set(struct f2fs_inode_info *fi, int flag)
+{
+	return test_bit(flag, &fi->i_dyn_flags);
+}
+
+static inline void clear_inode_dyn_flag(struct f2fs_inode_info *fi, int flag)
+{
+	clear_bit(flag, &fi->i_dyn_flags);
+}
+
 static inline void set_acl_inode(struct f2fs_inode_info *fi, umode_t mode)
 {
 	fi->i_acl_mode = mode;
@@ -1042,6 +1066,7 @@ void destroy_checkpoint_caches(void);
  * data.c
  */
 int reserve_new_block(struct dnode_of_data *);
+int f2fs_reserve_block(struct inode *, pgoff_t);
 void update_extent_cache(block_t, struct dnode_of_data *);
 struct page *find_data_page(struct inode *, pgoff_t, bool);
 struct page *get_lock_data_page(struct inode *, pgoff_t);
@@ -1144,6 +1169,51 @@ static inline void __init f2fs_create_root_stats(void) { }
 static inline void f2fs_destroy_root_stats(void) { }
 #endif
 
+/*
+ * inline.c
+ */
+#ifdef CONFIG_F2FS_INLINE_DATA
+#define MAX_INLINE_DATA		(sizeof(__le32) * (ADDRS_PER_INODE + 5))
+#define INLINE_DATA_OFFSET	(PAGE_CACHE_SIZE - sizeof(struct node_footer)\
+					- MAX_INLINE_DATA)
+
+void f2fs_clear_inode_inline_flag(struct f2fs_inode *);
+void f2fs_set_inode_inline_flag(struct f2fs_inode *);
+int f2fs_inline_data_attempt(struct inode *);
+int f2fs_has_inline_data(struct inode *);
+int f2fs_read_inline_data_page(struct inode *, struct page *);
+int f2fs_convert_inline_data(struct page *, struct inode *, unsigned);
+int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
+#else
+static inline void
+f2fs_clear_inode_inline_flag(struct f2fs_inode *raw_inode) { }
+static inline void
+f2fs_set_inode_inline_flag(struct f2fs_inode *raw_inode) { }
+int f2fs_inline_data_attempt(struct inode *inode)
+{
+	return 0;
+}
+static inline int f2fs_has_inline_data(struct inode *inode)
+{
+	return 0;
+}
+static inline int f2fs_read_inline_data_page(struct inode *inode,
+						struct page *page)
+{
+	return 0;
+}
+static inline int f2fs_convert_inline_data(struct page *page,
+					   struct inode *inode, unsigned flags)
+{
+	return 0;
+}
+static inline int f2fs_write_inline_data(struct inode *inode,
+					 struct page *page, unsigned size)
+{
+	return 0;
+}
+#endif
+
 extern const struct file_operations f2fs_dir_operations;
 extern const struct file_operations f2fs_file_operations;
 extern const struct inode_operations f2fs_file_inode_operations;
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index b44a4c1..1d7b0b5 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -84,6 +84,9 @@ static int do_read_inode(struct inode *inode)
 	fi->flags = 0;
 	fi->i_advise = ri->i_advise;
 	fi->i_pino = le32_to_cpu(ri->i_pino);
+	if (ri->i_reserved & F2FS_INODE_INLINE_DATA)
+		set_inode_dyn_flag(fi, F2FS_INLINE_DATA_FL);
+
 	get_extent_info(&fi->ext, ri->i_ext);
 	f2fs_put_page(node_page, 1);
 	return 0;
@@ -177,6 +180,11 @@ void update_inode(struct inode *inode, struct page *node_page)
 	ri->i_pino = cpu_to_le32(F2FS_I(inode)->i_pino);
 	ri->i_generation = cpu_to_le32(inode->i_generation);
 
+	if (f2fs_has_inline_data(inode))
+		f2fs_set_inode_inline_flag(ri);
+	else
+		f2fs_clear_inode_inline_flag(ri);
+
 	if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) {
 		if (old_valid_dev(inode->i_rdev)) {
 			ri->i_addr[0] =
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 383d5e3..505808c 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -176,6 +176,11 @@ struct f2fs_inode {
 						double_indirect(1) node id */
 } __packed;
 
+/*
+ * Flags on f2fs_inode.i_reserved
+ */
+#define F2FS_INODE_INLINE_DATA	0x01    /* Inode has inline data */
+
 struct direct_node {
 	__le32 addr[ADDRS_PER_BLOCK];	/* array of data block address */
 } __packed;
-- 
1.7.9.5

