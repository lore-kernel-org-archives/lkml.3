Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaIZEz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:55:56 -0400
Received: from mail.kernel.org ([198.145.19.201]:57057 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357AbaIZEyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:54:55 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/4] f2fs: support atomic_write feature for database
Date: Thu, 25 Sep 2014 21:54:45 -0700
Message-Id: <1411707287-21760-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.9.3 (Apple Git-50)
In-Reply-To: <1411707287-21760-1-git-send-email-jaegeuk@kernel.org>
References: <1411707287-21760-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a very limited functionality for atomic write support.
In order to support atomic write, this patch adds two ioctls:
 o F2FS_IOC_ATOMIC_WRITE
 o F2FS_IOC_ATOMIC_COMMIT

For F2FS_IOC_ATOMIC_WRITE, this patch introduces a data structure to communicate
with applications.

struct atmoic_w {
	u64 aid;		/* atomic write id */
	const char __user *buf;	/* user data */
	u64 count;		/* size to update */
	u64 pos;		/* file offset */
};

This is almost same as write() system call, and application can easily submit
any atomic data by calling
  f2fs_ioctl(fd, F2FS_IOC_ATOMIC_WRITE, struct atomic_w *);

Then, data's page indices are recorded in the linked list, atomic_range list.
Later, f2fs_ioctl(fd, F2FS_IOC_ATOMIC_COMMIT, aid) trigger will flush all the
previous atomic data to the storage, which will be shown all or nothing by
f2fs recovery procedure.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c    |  7 ++++--
 fs/f2fs/f2fs.h    | 23 +++++++++++++++---
 fs/f2fs/file.c    | 55 ++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/gc.c      |  2 +-
 fs/f2fs/inode.c   |  4 ++++
 fs/f2fs/segment.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/segment.h | 12 ++++++++--
 fs/f2fs/super.c   |  1 +
 8 files changed, 167 insertions(+), 8 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 13ab7208..369f887 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -14,6 +14,7 @@
 #include <linux/mpage.h>
 #include <linux/aio.h>
 #include <linux/writeback.h>
+#include <linux/mount.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
 #include <linux/bio.h>
@@ -934,7 +935,6 @@ skip_write:
 	wbc->pages_skipped += get_dirty_pages(inode);
 	return 0;
 }
-
 static void f2fs_write_failed(struct address_space *mapping, loff_t to)
 {
 	struct inode *inode = mapping->host;
@@ -1052,7 +1052,10 @@ static int f2fs_write_end(struct file *file,
 
 	trace_f2fs_write_end(inode, pos, len, copied);
 
-	set_page_dirty(page);
+	if (is_inode_flag_set(F2FS_I(inode), FI_ATOMIC_FILE))
+		get_page(page);
+	else
+		set_page_dirty(page);
 
 	if (pos + copied > i_size_read(inode)) {
 		i_size_write(inode, pos + copied);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 94cfdc4..802ebf3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -192,8 +192,19 @@ static inline bool __has_cursum_space(struct f2fs_summary_block *sum, int size,
 /*
  * ioctl commands
  */
-#define F2FS_IOC_GETFLAGS               FS_IOC_GETFLAGS
-#define F2FS_IOC_SETFLAGS               FS_IOC_SETFLAGS
+#define F2FS_IOC_GETFLAGS		FS_IOC_GETFLAGS
+#define F2FS_IOC_SETFLAGS		FS_IOC_SETFLAGS
+
+#define F2FS_IOCTL_MAGIC		0xf5
+#define F2FS_IOC_ATOMIC_WRITE	_IOW(F2FS_IOCTL_MAGIC, 1, struct atomic_w)
+#define F2FS_IOC_ATOMIC_COMMIT	_IOW(F2FS_IOCTL_MAGIC, 2, u64)
+
+struct atomic_w {
+	u64 aid;		/* atomic write id */
+	const char __user *buf;	/* user data */
+	u64 count;		/* size to update */
+	u64 pos;		/* file offset */
+};
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
@@ -263,6 +274,8 @@ struct f2fs_inode_info {
 	unsigned long long xattr_ver;	/* cp version of xattr modification */
 	struct extent_info ext;		/* in-memory extent cache entry */
 	struct dir_inode_entry *dirty_dir;	/* the pointer of dirty dir */
+
+	struct list_head atomic_pages;	/* atomic page indexes */
 };
 
 static inline void get_extent_info(struct extent_info *ext,
@@ -1051,7 +1064,8 @@ enum {
 	FI_INLINE_DATA,		/* used for inline data*/
 	FI_APPEND_WRITE,	/* inode has appended data */
 	FI_UPDATE_WRITE,	/* inode has in-place-update data */
-	FI_NEED_IPU,		/* used fo ipu for fdatasync */
+	FI_NEED_IPU,		/* used for ipu for fdatasync */
+	FI_ATOMIC_FILE,		/* used for atomic writes support */
 };
 
 static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
@@ -1274,6 +1288,8 @@ void destroy_node_manager_caches(void);
 /*
  * segment.c
  */
+void prepare_atomic_pages(struct inode *, struct atomic_w *);
+void commit_atomic_pages(struct inode *, u64, bool);
 void f2fs_balance_fs(struct f2fs_sb_info *);
 void f2fs_balance_fs_bg(struct f2fs_sb_info *);
 int f2fs_issue_flush(struct f2fs_sb_info *);
@@ -1355,6 +1371,7 @@ int f2fs_fiemap(struct inode *inode, struct fiemap_extent_info *, u64, u64);
 /*
  * gc.c
  */
+void move_data_page(struct inode *, struct page *, int);
 int start_gc_thread(struct f2fs_sb_info *);
 void stop_gc_thread(struct f2fs_sb_info *);
 block_t start_bidx_of_node(unsigned int, struct f2fs_inode_info *);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 1184207..d7528c4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -805,6 +805,57 @@ static inline __u32 f2fs_mask_flags(umode_t mode, __u32 flags)
 		return flags & F2FS_OTHER_FLMASK;
 }
 
+static int f2fs_ioc_atomic_write(struct file *filp, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	struct atomic_w aw;
+	loff_t pos;
+	int ret;
+
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
+	if (copy_from_user(&aw, (struct atomic_w __user *)arg, sizeof(aw)))
+		return -EFAULT;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	pos = aw.pos;
+	set_inode_flag(F2FS_I(inode), FI_ATOMIC_FILE);
+	ret = vfs_write(filp, aw.buf, aw.count, &pos);
+	if (ret >= 0)
+		prepare_atomic_pages(inode, &aw);
+	else
+		clear_inode_flag(F2FS_I(inode), FI_ATOMIC_FILE);
+
+	mnt_drop_write_file(filp);
+	return ret;
+}
+
+static int f2fs_ioc_atomic_commit(struct file *filp, unsigned long arg)
+{
+	struct inode *inode = file_inode(filp);
+	int ret;
+	u64 aid;
+
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
+	if (copy_from_user(&aid, (u64 __user *)arg, sizeof(u64)))
+		return -EFAULT;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	commit_atomic_pages(inode, aid, false);
+	ret = f2fs_sync_file(filp, 0, LONG_MAX, 0);
+	mnt_drop_write_file(filp);
+	return ret;
+}
+
 long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -860,6 +911,10 @@ out:
 		mnt_drop_write_file(filp);
 		return ret;
 	}
+	case F2FS_IOC_ATOMIC_WRITE:
+		return f2fs_ioc_atomic_write(filp, arg);
+	case F2FS_IOC_ATOMIC_COMMIT:
+		return f2fs_ioc_atomic_commit(filp, arg);
 	case FITRIM:
 	{
 		struct super_block *sb = inode->i_sb;
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 2a8f4ac..1ce6e6c 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -520,7 +520,7 @@ static int check_dnode(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	return 1;
 }
 
-static void move_data_page(struct inode *inode, struct page *page, int gc_type)
+void move_data_page(struct inode *inode, struct page *page, int gc_type)
 {
 	struct f2fs_io_info fio = {
 		.type = DATA,
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index ff95547..62c5284 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -269,6 +269,10 @@ void f2fs_evict_inode(struct inode *inode)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 
+	/* some remained atomic pages should discarded */
+	if (is_inode_flag_set(F2FS_I(inode), FI_ATOMIC_FILE))
+		commit_atomic_pages(inode, 0, true);
+
 	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages_final(&inode->i_data);
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index d30cd16..6e3a405 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -26,6 +26,7 @@
 
 static struct kmem_cache *discard_entry_slab;
 static struct kmem_cache *sit_entry_set_slab;
+static struct kmem_cache *aw_entry_slab;
 
 /*
  * __reverse_ffs is copied from include/asm-generic/bitops/__ffs.h since
@@ -173,6 +174,70 @@ found_middle:
 	return result + __reverse_ffz(tmp);
 }
 
+/* For atomic write support */
+void prepare_atomic_pages(struct inode *inode, struct atomic_w *aw)
+{
+	pgoff_t start = aw->pos >> PAGE_CACHE_SHIFT;
+	pgoff_t end = (aw->pos + aw->count + PAGE_CACHE_SIZE - 1) >>
+						PAGE_CACHE_SHIFT;
+	struct atomic_range *new;
+
+	new = f2fs_kmem_cache_alloc(aw_entry_slab, GFP_NOFS);
+
+	/* add atomic page indices to the list */
+	new->aid = aw->aid;
+	new->start = start;
+	new->end = end;
+	INIT_LIST_HEAD(&new->list);
+	list_add_tail(&new->list, &F2FS_I(inode)->atomic_pages);
+}
+
+void commit_atomic_pages(struct inode *inode, u64 aid, bool abort)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	struct atomic_range *cur, *tmp;
+	u64 start;
+	struct page *page;
+
+	if (abort)
+		goto release;
+
+	f2fs_balance_fs(sbi);
+	mutex_lock(&sbi->cp_mutex);
+
+	/* Step #1: write all the pages */
+	list_for_each_entry(cur, &F2FS_I(inode)->atomic_pages, list) {
+		if (cur->aid != aid)
+			continue;
+
+		for (start = cur->start; start < cur->end; start++) {
+			page = grab_cache_page(inode->i_mapping, start);
+			WARN_ON(!page);
+			move_data_page(inode, page, FG_GC);
+		}
+	}
+	f2fs_submit_merged_bio(sbi, DATA, WRITE);
+	mutex_unlock(&sbi->cp_mutex);
+release:
+	/* Step #2: wait for writeback */
+	list_for_each_entry_safe(cur, tmp, &F2FS_I(inode)->atomic_pages, list) {
+		if (cur->aid != aid && !abort)
+			continue;
+
+		for (start = cur->start; start < cur->end; start++) {
+			page = find_get_page(inode->i_mapping, start);
+			WARN_ON(!page);
+			wait_on_page_writeback(page);
+			f2fs_put_page(page, 0);
+
+			/* release reference got by atomic_write operation */
+			f2fs_put_page(page, 0);
+		}
+		list_del(&cur->list);
+		kmem_cache_free(aw_entry_slab, cur);
+	}
+}
+
 /*
  * This function balances dirty node and dentry pages.
  * In addition, it controls garbage collection.
@@ -2153,8 +2218,14 @@ int __init create_segment_manager_caches(void)
 			sizeof(struct nat_entry_set));
 	if (!sit_entry_set_slab)
 		goto destory_discard_entry;
+	aw_entry_slab = f2fs_kmem_cache_create("atomic_entry",
+			sizeof(struct atomic_range));
+	if (!aw_entry_slab)
+		goto destroy_sit_entry_set;
 	return 0;
 
+destroy_sit_entry_set:
+	kmem_cache_destroy(sit_entry_set_slab);
 destory_discard_entry:
 	kmem_cache_destroy(discard_entry_slab);
 fail:
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index d080f55..393af7b 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -175,6 +175,13 @@ struct segment_allocation {
 	void (*allocate_segment)(struct f2fs_sb_info *, int, bool);
 };
 
+struct atomic_range {
+	struct list_head list;
+	u64 aid;
+	pgoff_t start;
+	pgoff_t end;
+};
+
 struct sit_info {
 	const struct segment_allocation *s_ops;
 
@@ -502,9 +509,10 @@ static inline bool need_inplace_update(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	unsigned int policy = SM_I(sbi)->ipu_policy;
+	struct f2fs_inode_info *fi = F2FS_I(inode);
 
 	/* IPU can be done only for the user data */
-	if (S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode) || is_inode_flag_set(fi, FI_ATOMIC_FILE))
 		return false;
 
 	if (policy & (0x1 << F2FS_IPU_FORCE))
@@ -520,7 +528,7 @@ static inline bool need_inplace_update(struct inode *inode)
 
 	/* this is only set during fdatasync */
 	if (policy & (0x1 << F2FS_IPU_FSYNC) &&
-			is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
+			is_inode_flag_set(fi, FI_NEED_IPU))
 		return true;
 
 	return false;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index bb6b568..8915c77 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -373,6 +373,7 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 	fi->i_advise = 0;
 	rwlock_init(&fi->ext.ext_lock);
 	init_rwsem(&fi->i_sem);
+	INIT_LIST_HEAD(&fi->atomic_pages);
 
 	set_inode_flag(fi, FI_NEW_INODE);
 
-- 
1.9.3 (Apple Git-50)

