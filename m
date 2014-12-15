Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaLOH3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:29:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:34440 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbaLOH1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:27:44 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 4/7] f2fs: change atomic and volatile write policies
Date: Sun, 14 Dec 2014 23:27:35 -0800
Message-Id: <1418628458-82740-4-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
References: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds two new ioctls to release inmemory pages grabbed by atomic
writes.
 o f2fs_ioc_abort_volatile_write
  - If transaction was failed, all the grabbed pages and data should be written.
 o f2fs_ioc_release_volatile_write
  - This is to enhance the performance of PERSIST mode in sqlite.

In order to avoid huge memory consumption which causes OOM, this patch changes
volatile writes to use normal dirty pages, instead blocked flushing to the disk
as long as system does not suffer from memory pressure.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c    |  9 +++++--
 fs/f2fs/f2fs.h    |  8 ++++++
 fs/f2fs/file.c    | 77 +++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/f2fs/inode.c   |  2 +-
 fs/f2fs/node.c    |  3 +++
 fs/f2fs/node.h    |  1 +
 fs/f2fs/segment.c |  2 +-
 7 files changed, 88 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7ec697b..32264e3 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -814,6 +814,11 @@ static int f2fs_write_data_page(struct page *page,
 write:
 	if (unlikely(sbi->por_doing))
 		goto redirty_out;
+	if (f2fs_is_drop_cache(inode))
+		goto out;
+	if (f2fs_is_volatile_file(inode) && !wbc->for_reclaim &&
+			available_free_memory(sbi, BASE_CHECK))
+		goto redirty_out;
 
 	/* Dentry blocks are controlled by checkpoint */
 	if (S_ISDIR(inode->i_mode)) {
@@ -1109,7 +1114,7 @@ static void f2fs_invalidate_data_page(struct page *page, unsigned int offset,
 	if (offset % PAGE_CACHE_SIZE || length != PAGE_CACHE_SIZE)
 		return;
 
-	if (f2fs_is_atomic_file(inode) || f2fs_is_volatile_file(inode))
+	if (f2fs_is_atomic_file(inode))
 		invalidate_inmem_page(inode, page);
 
 	if (PageDirty(page))
@@ -1132,7 +1137,7 @@ static int f2fs_set_data_page_dirty(struct page *page)
 
 	SetPageUptodate(page);
 
-	if (f2fs_is_atomic_file(inode) || f2fs_is_volatile_file(inode)) {
+	if (f2fs_is_atomic_file(inode)) {
 		register_inmem_page(inode, page);
 		return 1;
 	}
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index ec58bb2..8c9bf3d 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -201,6 +201,8 @@ static inline bool __has_cursum_space(struct f2fs_summary_block *sum, int size,
 #define F2FS_IOC_START_ATOMIC_WRITE	_IO(F2FS_IOCTL_MAGIC, 1)
 #define F2FS_IOC_COMMIT_ATOMIC_WRITE	_IO(F2FS_IOCTL_MAGIC, 2)
 #define F2FS_IOC_START_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 3)
+#define F2FS_IOC_RELEASE_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 4)
+#define F2FS_IOC_ABORT_VOLATILE_WRITE	_IO(F2FS_IOCTL_MAGIC, 5)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
@@ -1113,6 +1115,7 @@ enum {
 	FI_NEED_IPU,		/* used for ipu per file */
 	FI_ATOMIC_FILE,		/* indicate atomic file */
 	FI_VOLATILE_FILE,	/* indicate volatile file */
+	FI_DROP_CACHE,		/* drop dirty page cache */
 	FI_DATA_EXIST,		/* indicate data exists */
 };
 
@@ -1220,6 +1223,11 @@ static inline bool f2fs_is_volatile_file(struct inode *inode)
 	return is_inode_flag_set(F2FS_I(inode), FI_VOLATILE_FILE);
 }
 
+static inline bool f2fs_is_drop_cache(struct inode *inode)
+{
+	return is_inode_flag_set(F2FS_I(inode), FI_DROP_CACHE);
+}
+
 static inline void *inline_data_addr(struct page *page)
 {
 	struct f2fs_inode *ri = F2FS_INODE(page);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 3c27e0e..5139f90 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -836,6 +836,19 @@ static long f2fs_fallocate(struct file *file, int mode,
 	return ret;
 }
 
+static int f2fs_release_file(struct inode *inode, struct file *filp)
+{
+	/* some remained atomic pages should discarded */
+	if (f2fs_is_atomic_file(inode))
+		commit_inmem_pages(inode, true);
+	if (f2fs_is_volatile_file(inode)) {
+		set_inode_flag(F2FS_I(inode), FI_DROP_CACHE);
+		filemap_fdatawrite(inode->i_mapping);
+		clear_inode_flag(F2FS_I(inode), FI_DROP_CACHE);
+	}
+	return 0;
+}
+
 #define F2FS_REG_FLMASK		(~(FS_DIRSYNC_FL | FS_TOPDIR_FL))
 #define F2FS_OTHER_FLMASK	(FS_NODUMP_FL | FS_NOATIME_FL)
 
@@ -909,26 +922,20 @@ out:
 static int f2fs_ioc_start_atomic_write(struct file *filp)
 {
 	struct inode *inode = file_inode(filp);
-	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
-	f2fs_balance_fs(sbi);
+	f2fs_balance_fs(F2FS_I_SB(inode));
+
+	if (f2fs_is_atomic_file(inode))
+		return 0;
 
 	set_inode_flag(F2FS_I(inode), FI_ATOMIC_FILE);
 
 	return f2fs_convert_inline_inode(inode);
 }
 
-static int f2fs_release_file(struct inode *inode, struct file *filp)
-{
-	/* some remained atomic pages should discarded */
-	if (f2fs_is_atomic_file(inode) || f2fs_is_volatile_file(inode))
-		commit_inmem_pages(inode, true);
-	return 0;
-}
-
 static int f2fs_ioc_commit_atomic_write(struct file *filp)
 {
 	struct inode *inode = file_inode(filp);
@@ -949,6 +956,7 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
 
 	ret = f2fs_sync_file(filp, 0, LONG_MAX, 0);
 	mnt_drop_write_file(filp);
+	clear_inode_flag(F2FS_I(inode), FI_ATOMIC_FILE);
 	return ret;
 }
 
@@ -959,11 +967,56 @@ static int f2fs_ioc_start_volatile_write(struct file *filp)
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
 
+	if (f2fs_is_volatile_file(inode))
+		return 0;
+
 	set_inode_flag(F2FS_I(inode), FI_VOLATILE_FILE);
 
 	return f2fs_convert_inline_inode(inode);
 }
 
+static int f2fs_ioc_release_volatile_write(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
+
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
+	if (!f2fs_is_volatile_file(inode))
+		return 0;
+
+	punch_hole(inode, 0, F2FS_BLKSIZE);
+	return 0;
+}
+
+static int f2fs_ioc_abort_volatile_write(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
+	int ret;
+
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	f2fs_balance_fs(F2FS_I_SB(inode));
+
+	if (f2fs_is_atomic_file(inode)) {
+		commit_inmem_pages(inode, false);
+		clear_inode_flag(F2FS_I(inode), FI_ATOMIC_FILE);
+	}
+
+	if (f2fs_is_volatile_file(inode)) {
+		clear_inode_flag(F2FS_I(inode), FI_VOLATILE_FILE);
+		filemap_fdatawrite(inode->i_mapping);
+		set_inode_flag(F2FS_I(inode), FI_VOLATILE_FILE);
+	}
+	mnt_drop_write_file(filp);
+	return ret;
+}
+
 static int f2fs_ioc_fitrim(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -1007,6 +1060,10 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_commit_atomic_write(filp);
 	case F2FS_IOC_START_VOLATILE_WRITE:
 		return f2fs_ioc_start_volatile_write(filp);
+	case F2FS_IOC_RELEASE_VOLATILE_WRITE:
+		return f2fs_ioc_release_volatile_write(filp);
+	case F2FS_IOC_ABORT_VOLATILE_WRITE:
+		return f2fs_ioc_abort_volatile_write(filp);
 	case FITRIM:
 		return f2fs_ioc_fitrim(filp, arg);
 	default:
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 196cc78..3a8958d 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -304,7 +304,7 @@ void f2fs_evict_inode(struct inode *inode)
 	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 
 	/* some remained atomic pages should discarded */
-	if (f2fs_is_atomic_file(inode) || f2fs_is_volatile_file(inode))
+	if (f2fs_is_atomic_file(inode))
 		commit_inmem_pages(inode, true);
 
 	trace_f2fs_evict_inode(inode);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index d6f073e..cabecee 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -61,6 +61,9 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 			mem_size += (sbi->im[i].ino_num *
 				sizeof(struct ino_entry)) >> PAGE_CACHE_SHIFT;
 		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
+	} else {
+		if (sbi->sb->s_bdi->dirty_exceeded)
+			return false;
 	}
 	return res;
 }
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index d10b644..036b887 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -108,6 +108,7 @@ enum mem_type {
 	NAT_ENTRIES,	/* indicates the cached nat entry */
 	DIRTY_DENTS,	/* indicates dirty dentry pages */
 	INO_ENTRIES,	/* indicates inode entries */
+	BASE_CHECK,	/* check kernel status */
 };
 
 struct nat_entry_set {
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3ce86c5..de9c070 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -230,7 +230,7 @@ void commit_inmem_pages(struct inode *inode, bool abort)
 	bool submit_bio = false;
 	struct f2fs_io_info fio = {
 		.type = DATA,
-		.rw = WRITE_SYNC,
+		.rw = WRITE_SYNC | REQ_PRIO,
 	};
 
 	/*
-- 
2.1.1

