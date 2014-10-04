Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaJDHEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 03:04:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:60814 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaJDHEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 03:04:24 -0400
Date: Sat, 4 Oct 2014 00:04:26 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 2/4 v2] f2fs: support atomic_write feature for
 database
Message-ID: <20141004070109.GA48021@jaegeuk-mac02.mot-mobility.com>
References: <1411707287-21760-1-git-send-email-jaegeuk@kernel.org>
 <1411707287-21760-2-git-send-email-jaegeuk@kernel.org>
 <20140930061909.GA12164@jaegeuk-mac02.mot-mobility.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930061909.GA12164@jaegeuk-mac02.mot-mobility.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change log from v2:
 o change naming and add one more api

>From 148ec45e541b2d2b37b90f27286a3ee484866679 Mon Sep 17 00:00:00 2001
From: Jaegeuk Kim <jaegeuk@kernel.org>
Date: Thu, 25 Sep 2014 21:54:45 -0700
Subject: [PATCH] f2fs: support atomic operations for database

This patch introduces a very limited functionality for atomic write support.
In order to support atomic write, this patch adds two ioctls:
 o F2FS_IOC_DB_OPEN
 o F2FS_IOC_COMMIT

The database engine should be aware of the following sequence.
1. open
 -> ioctl(F2FS_IOC_DB_OPEN);
2. writes
  : all the written data will be treated as atomic pages.
3. commit
 -> ioctl(F2FS_IOC_COMMIT);
  : this flushes all the data blocks to the disk, which will be shown all or
  nothing by f2fs recovery procedure.

The IO pattens should be:

 CP | D D D D D D | FSYNC | D D D D | FSYNC ...

While supporting atomic writes for main database file, we can keep its journal
data temporarily in the page cache by the following sequence.

1. open
 -> ioctl(F2FS_IOC_JOURNAL_OPEN);
2. writes
 : keep all the data in the page cache.
3. flush to the database file with atomic writes
  a. ioctl(F2FS_IOC_DB_OPEN);
  b. writes
  c. ioctl(F2FS_IOC_COMMIT);
4. close
 -> drop the cached data

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c    |  9 ++++++-
 fs/f2fs/f2fs.h    | 27 ++++++++++++++++---
 fs/f2fs/file.c    | 55 ++++++++++++++++++++++++++++++++++++++
 fs/f2fs/inline.c  |  3 +++
 fs/f2fs/inode.c   |  4 +++
 fs/f2fs/segment.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/f2fs/segment.h | 10 +++++--
 fs/f2fs/super.c   |  2 ++
 8 files changed, 183 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 13ab7208..5869cfc 100644
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
@@ -1052,7 +1053,10 @@ static int f2fs_write_end(struct file *file,
 
 	trace_f2fs_write_end(inode, pos, len, copied);
 
-	set_page_dirty(page);
+	if (f2fs_is_db_file(inode))
+		register_db_page(inode, page);
+	else
+		set_page_dirty(page);
 
 	if (pos + copied > i_size_read(inode)) {
 		i_size_write(inode, pos + copied);
@@ -1116,6 +1120,9 @@ static void f2fs_invalidate_data_page(struct page *page, unsigned int offset,
 	if (offset % PAGE_CACHE_SIZE || length != PAGE_CACHE_SIZE)
 		return;
 
+	if (f2fs_is_db_file(inode))
+		invalidate_db_page(inode, page);
+
 	if (PageDirty(page))
 		inode_dec_dirty_pages(inode);
 	ClearPagePrivate(page);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a397f7a..f424ae7 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -192,8 +192,13 @@ static inline bool __has_cursum_space(struct f2fs_summary_block *sum, int size,
 /*
  * ioctl commands
  */
-#define F2FS_IOC_GETFLAGS               FS_IOC_GETFLAGS
-#define F2FS_IOC_SETFLAGS               FS_IOC_SETFLAGS
+#define F2FS_IOC_GETFLAGS		FS_IOC_GETFLAGS
+#define F2FS_IOC_SETFLAGS		FS_IOC_SETFLAGS
+
+#define F2FS_IOCTL_MAGIC		0xf5
+#define F2FS_IOC_DB_OPEN	_IO(F2FS_IOCTL_MAGIC, 1)
+#define F2FS_IOC_JOURNAL_OPEN	_IO(F2FS_IOCTL_MAGIC, 2)
+#define F2FS_IOC_COMMIT		_IO(F2FS_IOCTL_MAGIC, 3)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
@@ -263,6 +268,9 @@ struct f2fs_inode_info {
 	unsigned long long xattr_ver;	/* cp version of xattr modification */
 	struct extent_info ext;		/* in-memory extent cache entry */
 	struct dir_inode_entry *dirty_dir;	/* the pointer of dirty dir */
+
+	struct list_head db_pages;		/* atomic page indexes */
+	struct mutex db_lock;		/* lock for atomic pages */
 };
 
 static inline void get_extent_info(struct extent_info *ext,
@@ -1051,7 +1059,9 @@ enum {
 	FI_INLINE_DATA,		/* used for inline data*/
 	FI_APPEND_WRITE,	/* inode has appended data */
 	FI_UPDATE_WRITE,	/* inode has in-place-update data */
-	FI_NEED_IPU,		/* used fo ipu for fdatasync */
+	FI_NEED_IPU,		/* used for ipu for fdatasync */
+	FI_DB_FILE,		/* indicate database file */
+	FI_JOURNAL_FILE,	/* indicate journal file */
 };
 
 static inline void set_inode_flag(struct f2fs_inode_info *fi, int flag)
@@ -1111,6 +1121,14 @@ static inline int f2fs_has_inline_xattr(struct inode *inode)
 	return is_inode_flag_set(F2FS_I(inode), FI_INLINE_XATTR);
 }
 
+static inline bool f2fs_is_db_file(struct inode *inode)
+{
+	if (is_inode_flag_set(F2FS_I(inode), FI_DB_FILE) ||
+			is_inode_flag_set(F2FS_I(inode), FI_JOURNAL_FILE))
+		return true;
+	return false;
+}
+
 static inline unsigned int addrs_per_inode(struct f2fs_inode_info *fi)
 {
 	if (f2fs_has_inline_xattr(&fi->vfs_inode))
@@ -1275,6 +1293,9 @@ void destroy_node_manager_caches(void);
 /*
  * segment.c
  */
+void register_db_page(struct inode *, struct page *);
+void invalidate_db_page(struct inode *, struct page *);
+void commit_db_pages(struct inode *, bool);
 void f2fs_balance_fs(struct f2fs_sb_info *);
 void f2fs_balance_fs_bg(struct f2fs_sb_info *);
 int f2fs_issue_flush(struct f2fs_sb_info *);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 735e9a2..de486ad 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -862,6 +862,55 @@ out:
 	return ret;
 }
 
+static int f2fs_ioc_open_db_file(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
+	f2fs_balance_fs(sbi);
+
+	set_inode_flag(F2FS_I(inode), FI_DB_FILE);
+
+	return f2fs_convert_inline_data(inode, MAX_INLINE_DATA + 1, NULL);
+}
+
+static int f2fs_ioc_open_journal_file(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
+
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
+	set_inode_flag(F2FS_I(inode), FI_JOURNAL_FILE);
+	return 0;
+}
+
+static int f2fs_ioc_commit(struct file *filp)
+{
+	struct inode *inode = file_inode(filp);
+	int ret;
+
+	if (!inode_owner_or_capable(inode))
+		return -EACCES;
+
+	if (is_inode_flag_set(F2FS_I(inode), FI_JOURNAL_FILE))
+		return 0;
+
+	ret = mnt_want_write_file(filp);
+	if (ret)
+		return ret;
+
+	if (is_inode_flag_set(F2FS_I(inode), FI_DB_FILE))
+		commit_db_pages(inode, false);
+
+	ret = f2fs_sync_file(filp, 0, LONG_MAX, 0);
+	mnt_drop_write_file(filp);
+	return ret;
+}
+
 static int f2fs_ioc_fitrim(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
@@ -899,6 +948,12 @@ long f2fs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return f2fs_ioc_getflags(filp, arg);
 	case F2FS_IOC_SETFLAGS:
 		return f2fs_ioc_setflags(filp, arg);
+	case F2FS_IOC_DB_OPEN:
+		return f2fs_ioc_open_db_file(filp);
+	case F2FS_IOC_JOURNAL_OPEN:
+		return f2fs_ioc_open_journal_file(filp);
+	case F2FS_IOC_COMMIT:
+		return f2fs_ioc_commit(filp);
 	case FITRIM:
 		return f2fs_ioc_fitrim(filp, arg);
 	default:
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 6aef11d..b47377b 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -21,6 +21,9 @@ bool f2fs_may_inline(struct inode *inode)
 	if (!test_opt(F2FS_I_SB(inode), INLINE_DATA))
 		return false;
 
+	if (is_inode_flag_set(F2FS_I(inode), FI_DB_FILE))
+		return false;
+
 	nr_blocks = F2FS_I(inode)->i_xattr_nid ? 3 : 2;
 	if (inode->i_blocks > nr_blocks)
 		return false;
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 63923ee..23f718e 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -269,6 +269,10 @@ void f2fs_evict_inode(struct inode *inode)
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
 
+	/* some remained atomic pages should discarded */
+	if (f2fs_is_db_file(inode))
+		commit_db_pages(inode, true);
+
 	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages_final(&inode->i_data);
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 4d1c49a..b70e2ac 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -26,6 +26,7 @@
 
 static struct kmem_cache *discard_entry_slab;
 static struct kmem_cache *sit_entry_set_slab;
+static struct kmem_cache *aw_entry_slab;
 
 /*
  * __reverse_ffs is copied from include/asm-generic/bitops/__ffs.h since
@@ -173,6 +174,77 @@ found_middle:
 	return result + __reverse_ffz(tmp);
 }
 
+/* For atomic write support */
+void register_db_page(struct inode *inode, struct page *page)
+{
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	struct db_pages *new;
+
+	new = f2fs_kmem_cache_alloc(aw_entry_slab, GFP_NOFS);
+
+	/* add atomic page indices to the list */
+	new->page = page;
+	INIT_LIST_HEAD(&new->list);
+
+	/* increase reference count with clean state */
+	mutex_lock(&fi->db_lock);
+	get_page(page);
+	list_add_tail(&new->list, &fi->db_pages);
+	mutex_unlock(&fi->db_lock);
+}
+
+void invalidate_db_page(struct inode *inode, struct page *page)
+{
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	struct db_pages *cur, *tmp;
+
+	mutex_lock(&fi->db_lock);
+	list_for_each_entry_safe(cur, tmp, &fi->db_pages, list) {
+		if (cur->page == page) {
+			put_page(page);
+			list_del(&cur->list);
+			kmem_cache_free(aw_entry_slab, cur);
+		}
+	}
+	mutex_unlock(&fi->db_lock);
+}
+
+void commit_db_pages(struct inode *inode, bool abort)
+{
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	struct db_pages *cur, *tmp;
+	bool submit_bio = false;
+	struct f2fs_io_info fio = {
+		.type = DATA,
+		.rw = WRITE_SYNC,
+	};
+
+	f2fs_balance_fs(sbi);
+	f2fs_lock_op(sbi);
+
+	mutex_lock(&fi->db_lock);
+	list_for_each_entry_safe(cur, tmp, &fi->db_pages, list) {
+		lock_page(cur->page);
+		if (!abort && cur->page->mapping == inode->i_mapping) {
+			f2fs_wait_on_page_writeback(cur->page, DATA);
+			if (clear_page_dirty_for_io(cur->page))
+				inode_dec_dirty_pages(inode);
+			do_write_data_page(cur->page, &fio);
+			submit_bio = true;
+		}
+		f2fs_put_page(cur->page, 1);
+		list_del(&cur->list);
+		kmem_cache_free(aw_entry_slab, cur);
+	}
+	if (submit_bio)
+		f2fs_submit_merged_bio(sbi, DATA, WRITE);
+	mutex_unlock(&fi->db_lock);
+
+	filemap_fdatawait_range(inode->i_mapping, 0, LLONG_MAX);
+	f2fs_unlock_op(sbi);
+}
+
 /*
  * This function balances dirty node and dentry pages.
  * In addition, it controls garbage collection.
@@ -2148,8 +2220,14 @@ int __init create_segment_manager_caches(void)
 			sizeof(struct nat_entry_set));
 	if (!sit_entry_set_slab)
 		goto destory_discard_entry;
+	aw_entry_slab = f2fs_kmem_cache_create("db_page_entry",
+			sizeof(struct db_pages));
+	if (!aw_entry_slab)
+		goto destroy_sit_entry_set;
 	return 0;
 
+destroy_sit_entry_set:
+	kmem_cache_destroy(sit_entry_set_slab);
 destory_discard_entry:
 	kmem_cache_destroy(discard_entry_slab);
 fail:
@@ -2160,4 +2238,5 @@ void destroy_segment_manager_caches(void)
 {
 	kmem_cache_destroy(sit_entry_set_slab);
 	kmem_cache_destroy(discard_entry_slab);
+	kmem_cache_destroy(aw_entry_slab);
 }
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index afb7362..45583a9 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -175,6 +175,11 @@ struct segment_allocation {
 	void (*allocate_segment)(struct f2fs_sb_info *, int, bool);
 };
 
+struct db_pages {
+	struct list_head list;
+	struct page *page;
+};
+
 struct sit_info {
 	const struct segment_allocation *s_ops;
 
@@ -502,9 +507,10 @@ static inline bool need_inplace_update(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	unsigned int policy = SM_I(sbi)->ipu_policy;
+	struct f2fs_inode_info *fi = F2FS_I(inode);
 
 	/* IPU can be done only for the user data */
-	if (S_ISDIR(inode->i_mode))
+	if (S_ISDIR(inode->i_mode) || is_inode_flag_set(fi, FI_DB_FILE))
 		return false;
 
 	if (policy & (0x1 << F2FS_IPU_FORCE))
@@ -520,7 +526,7 @@ static inline bool need_inplace_update(struct inode *inode)
 
 	/* this is only set during fdatasync */
 	if (policy & (0x1 << F2FS_IPU_FSYNC) &&
-			is_inode_flag_set(F2FS_I(inode), FI_NEED_IPU))
+			is_inode_flag_set(fi, FI_NEED_IPU))
 		return true;
 
 	return false;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index bb6b568..68a5047 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -373,6 +373,8 @@ static struct inode *f2fs_alloc_inode(struct super_block *sb)
 	fi->i_advise = 0;
 	rwlock_init(&fi->ext.ext_lock);
 	init_rwsem(&fi->i_sem);
+	INIT_LIST_HEAD(&fi->db_pages);
+	mutex_init(&fi->db_lock);
 
 	set_inode_flag(fi, FI_NEW_INODE);
 
-- 
2.1.1

