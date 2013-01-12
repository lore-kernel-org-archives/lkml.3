Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3ALFmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 00:42:00 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:39325 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3ALFl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 00:41:58 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 3/4] f2fs: introduce trace points in f2fs filesystem
Date: Sat, 12 Jan 2013 14:41:48 +0900
Message-Id: <1357969308-9361-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

#> cat /sys/kernel/debug/tracing/events/f2fs/enable
0
#> echo 1 > /sys/kernel/debug/tracing/events/f2fs/enable
#> cat /sys/kernel/debug/tracing/events/f2fs/enable
1

#> mount -t f2fs /dev/sdb3  /mnt/
#>
#> cat /sys/kernel/debug/tracing/trace
# tracer: nop
#
#TASK-PID    CPU#    TIMESTAMP  FUNCTION
#   | |       |          |         |
 mount-423   [001]    49.879188: f2fs_iget: dev 8,19 ino 2
 mount-423   [001]    49.879215: f2fs_get_page: dev 8,19  page_index 81, type 2
 mount-423   [001]    49.879224: f2fs_readpage: dev 8,19 ino 2 page_index 81
 mount-423   [001]    49.879819: f2fs_get_page: dev 8,19  page_index 83, type 2
 mount-423   [001]    49.879830: f2fs_readpage: dev 8,19 ino 2 page_index 83
 mount-423   [001]    49.880434: f2fs_get_page: dev 8,19  page_index 593, type 2
 mount-423   [001]    49.880442: f2fs_readpage: dev 8,19 ino 2 page_index 593
 mount-423   [001]    49.889931: f2fs_get_page: dev 8,19  page_index 595, type 2
 mount-423   [001]    49.889939: f2fs_readpage: dev 8,19 ino 2 page_index 595
 mount-423   [001]    49.892169: f2fs_get_page: dev 8,19  page_index 594, type 2
 mount-423   [001]    49.892186: f2fs_readpage: dev 8,19 ino 2 page_index 594
 ...
 ..

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/checkpoint.c        |   17 +
 fs/f2fs/data.c              |   17 +
 fs/f2fs/file.c              |   14 +
 fs/f2fs/inode.c             |   10 +
 fs/f2fs/namei.c             |    7 +-
 fs/f2fs/node.c              |   23 +-
 fs/f2fs/segment.c           |    5 +
 fs/f2fs/super.c             |    4 +
 include/trace/events/f2fs.h | 1220 +++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 1315 insertions(+), 2 deletions(-)
 create mode 100644 include/trace/events/f2fs.h

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index d75c86a..448f728 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -17,6 +17,8 @@
 #include <linux/pagevec.h>
 #include <linux/swap.h>
 
+#include <trace/events/f2fs.h>
+
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
@@ -31,6 +33,8 @@ struct page *grab_meta_page(struct f2fs_sb_info *sbi, pgoff_t index)
 {
 	struct address_space *mapping = sbi->meta_inode->i_mapping;
 	struct page *page = NULL;
+
+	trace_f2fs_grab_page(sbi->sb, index, META);
 repeat:
 	page = grab_cache_page(mapping, index);
 	if (!page) {
@@ -51,6 +55,8 @@ struct page *get_meta_page(struct f2fs_sb_info *sbi, pgoff_t index)
 {
 	struct address_space *mapping = sbi->meta_inode->i_mapping;
 	struct page *page;
+
+	trace_f2fs_get_page(sbi->sb, index, META);
 repeat:
 	page = grab_cache_page(mapping, index);
 	if (!page) {
@@ -74,6 +80,8 @@ static int f2fs_write_meta_page(struct page *page,
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	int err;
 
+	trace_f2fs_write_page(page, META);
+
 	wait_on_page_writeback(page);
 
 	err = write_meta_page(sbi, page, wbc);
@@ -122,6 +130,7 @@ long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
 		.for_reclaim = 0,
 	};
 
+	trace_f2fs_sync_pages(sbi->sb, type, nr_to_write);
 	pagevec_init(&pvec, 0);
 
 	while (index <= end) {
@@ -157,6 +166,7 @@ static int f2fs_set_meta_page_dirty(struct page *page)
 	struct address_space *mapping = page->mapping;
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
 
+	trace_f2fs_set_page_dirty(page, META);
 	SetPageUptodate(page);
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
@@ -197,6 +207,7 @@ void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 	struct list_head *head, *this;
 	struct orphan_inode_entry *new = NULL, *orphan = NULL;
 
+	trace_f2fs_orphan_inode(sbi->sb, ino);
 	mutex_lock(&sbi->orphan_inode_mutex);
 	head = &sbi->orphan_inode_list;
 	list_for_each(this, head) {
@@ -239,6 +250,7 @@ void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 	struct list_head *this, *next, *head;
 	struct orphan_inode_entry *orphan;
 
+	trace_f2fs_remove_orphan_inode(sbi->sb, ino);
 	mutex_lock(&sbi->orphan_inode_mutex);
 	head = &sbi->orphan_inode_list;
 	list_for_each_safe(this, next, head) {
@@ -458,6 +470,8 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
 
 	if (!S_ISDIR(inode->i_mode))
 		return;
+
+	trace_f2fs_set_dirty_dir_page(inode, page);
 retry:
 	new = kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
 	if (!new) {
@@ -554,6 +568,7 @@ void block_operations(struct f2fs_sb_info *sbi)
 		.for_reclaim = 0,
 	};
 
+	trace_f2fs_operations(sbi->sb, 1);
 	/* Stop renaming operation */
 	mutex_lock_op(sbi, RENAME);
 	mutex_lock_op(sbi, DENTRY_OPS);
@@ -593,6 +608,7 @@ retry:
 static void unblock_operations(struct f2fs_sb_info *sbi)
 {
 	int t;
+	trace_f2fs_operations(sbi->sb, 0);
 	for (t = NODE_WRITE; t >= RENAME; t--)
 		mutex_unlock_op(sbi, t);
 }
@@ -734,6 +750,7 @@ void write_checkpoint(struct f2fs_sb_info *sbi, bool blocked, bool is_umount)
 	struct f2fs_checkpoint *ckpt = F2FS_CKPT(sbi);
 	unsigned long long ckpt_ver;
 
+	trace_f2fs_writecheckpoint(sbi->sb, blocked);
 	if (!blocked) {
 		mutex_lock(&sbi->cp_mutex);
 		block_operations(sbi);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 3aa5ce7..1d7dbb4 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -18,6 +18,8 @@
 #include <linux/bio.h>
 #include <linux/prefetch.h>
 
+#include <trace/events/f2fs.h>
+
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
@@ -49,6 +51,7 @@ int reserve_new_block(struct dnode_of_data *dn)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
 
+	trace_f2fs_reserve_new_block(dn->inode, dn->nid);
 	if (is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC))
 		return -EPERM;
 	if (!inc_valid_block_count(sbi, dn->inode, 1))
@@ -107,6 +110,8 @@ void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
 	block_t start_blkaddr, end_blkaddr;
 
 	BUG_ON(blk_addr == NEW_ADDR);
+
+	trace_f2fs_update_extent_cache(blk_addr);
 	fofs = start_bidx_of_node(ofs_of_node(dn->node_page)) + dn->ofs_in_node;
 
 	/* Update the page address in the parent node */
@@ -221,6 +226,7 @@ struct page *get_lock_data_page(struct inode *inode, pgoff_t index)
 	struct page *page;
 	int err;
 
+	trace_f2fs_get_page(inode->i_sb, index, DATA);
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, index, RDONLY_NODE);
 	if (err)
@@ -261,6 +267,7 @@ struct page *get_new_data_page(struct inode *inode, pgoff_t index,
 	struct dnode_of_data dn;
 	int err;
 
+	trace_f2fs_new_data_page(inode, index);
 	set_new_dnode(&dn, inode, NULL, NULL, 0);
 	err = get_dnode_of_data(&dn, index, 0);
 	if (err)
@@ -334,6 +341,8 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
 	bool sync = (type == READ_SYNC);
 	struct bio *bio;
 
+	if (page->mapping)
+		trace_f2fs_readpage(page);
 	/* This page can be already read by other threads */
 	if (PageUptodate(page)) {
 		if (!sync)
@@ -424,6 +433,7 @@ static int get_data_block_ro(struct inode *inode, sector_t iblock,
 
 static int f2fs_read_data_page(struct file *file, struct page *page)
 {
+	trace_f2fs_read_page(page, DATA);
 	return mpage_readpage(page, get_data_block_ro);
 }
 
@@ -489,6 +499,7 @@ static int f2fs_write_data_page(struct page *page,
 	if (page->index < end_index)
 		goto out;
 
+	trace_f2fs_write_page(page, DATA);
 	/*
 	 * If the offset is out-of-range of file size,
 	 * this page does not have to be written to disk.
@@ -588,6 +599,8 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	/* for nobh_write_end */
 	*fsdata = NULL;
 
+	trace_f2fs_write_begin(inode, pos, len, flags);
+
 	f2fs_balance_fs(sbi);
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
@@ -650,6 +663,7 @@ static ssize_t f2fs_direct_IO(int rw, struct kiocb *iocb,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 
+	trace_f2fs_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
 	if (rw == WRITE)
 		return 0;
 
@@ -662,6 +676,7 @@ static void f2fs_invalidate_data_page(struct page *page, unsigned long offset)
 {
 	struct inode *inode = page->mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+	trace_f2fs_invalidate_page(page, offset, DATA);
 	if (S_ISDIR(inode->i_mode) && PageDirty(page)) {
 		dec_page_count(sbi, F2FS_DIRTY_DENTS);
 		inode_dec_dirty_dents(inode);
@@ -671,6 +686,7 @@ static void f2fs_invalidate_data_page(struct page *page, unsigned long offset)
 
 static int f2fs_release_data_page(struct page *page, gfp_t wait)
 {
+	trace_f2fs_release_page(page, DATA);
 	ClearPagePrivate(page);
 	return 0;
 }
@@ -680,6 +696,7 @@ static int f2fs_set_data_page_dirty(struct page *page)
 	struct address_space *mapping = page->mapping;
 	struct inode *inode = mapping->host;
 
+	trace_f2fs_set_page_dirty(page, DATA);
 	SetPageUptodate(page);
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 819de7f..d93093d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -18,6 +18,8 @@
 #include <linux/uaccess.h>
 #include <linux/mount.h>
 
+#include <trace/events/f2fs.h>
+
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
@@ -34,6 +36,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 	struct dnode_of_data dn;
 	int err;
 
+	trace_f2fs_vm_page_mkwrite(vma);
 	f2fs_balance_fs(sbi);
 
 	sb_start_pagefault(inode->i_sb);
@@ -133,6 +136,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		return 0;
 
+	trace_f2fs_sync_file_enter(file, datasync);
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
 	if (ret)
 		return ret;
@@ -179,6 +183,7 @@ int f2fs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 out:
 	mutex_unlock(&inode->i_mutex);
+	trace_f2fs_sync_file_exit(inode, ret);
 	return ret;
 }
 
@@ -219,7 +224,9 @@ static int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 
 void truncate_data_blocks(struct dnode_of_data *dn)
 {
+	trace_f2fs_truncate_data_blocks_enter(dn->inode);
 	truncate_data_blocks_range(dn, ADDRS_PER_BLOCK);
+	trace_f2fs_truncate_data_blocks_exit(dn->inode);
 }
 
 static void truncate_partial_data_page(struct inode *inode, u64 from)
@@ -293,12 +300,14 @@ void f2fs_truncate(struct inode *inode)
 				S_ISLNK(inode->i_mode)))
 		return;
 
+	trace_f2fs_truncate_enter(inode);
 	if (!truncate_blocks(inode, i_size_read(inode))) {
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		mark_inode_dirty(inode);
 	}
 
 	f2fs_balance_fs(F2FS_SB(inode->i_sb));
+	trace_f2fs_truncate_exit(inode);
 }
 
 static int f2fs_getattr(struct vfsmount *mnt,
@@ -406,6 +415,7 @@ int truncate_hole(struct inode *inode, pgoff_t pg_start, pgoff_t pg_end)
 	pgoff_t index;
 	int err;
 
+	trace_f2fs_truncate_hole(inode, pg_start, pg_end);
 	for (index = pg_start; index < pg_end; index++) {
 		struct dnode_of_data dn;
 		struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
@@ -436,6 +446,7 @@ static int punch_hole(struct inode *inode, loff_t offset, loff_t len, int mode)
 	loff_t off_start, off_end;
 	int ret = 0;
 
+	trace_f2fs_punch_hole(inode, offset, len);
 	pg_start = ((unsigned long long) offset) >> PAGE_CACHE_SHIFT;
 	pg_end = ((unsigned long long) offset + len) >> PAGE_CACHE_SHIFT;
 
@@ -544,6 +555,7 @@ static long f2fs_fallocate(struct file *file, int mode,
 	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
+	trace_f2fs_fallocate_enter(inode, offset, len, mode);
 	if (mode & FALLOC_FL_PUNCH_HOLE)
 		ret = punch_hole(inode, offset, len, mode);
 	else
@@ -553,6 +565,8 @@ static long f2fs_fallocate(struct file *file, int mode,
 		inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		mark_inode_dirty(inode);
 	}
+
+	trace_f2fs_fallocate_exit(inode, offset, len, ret);
 	return ret;
 }
 
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 7942417..2a0bd38 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -13,6 +13,8 @@
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 
+#include <trace/events/f2fs.h>
+
 #include "f2fs.h"
 #include "node.h"
 
@@ -55,12 +57,16 @@ static int f2fs_iget_test(struct inode *inode, void *data)
 
 struct inode *f2fs_iget_nowait(struct super_block *sb, unsigned long ino)
 {
+
 	struct f2fs_iget_args args = {
 		.ino = ino,
 		.on_free = 0
 	};
+
 	struct inode *inode = ilookup5(sb, ino, f2fs_iget_test, &args);
 
+	trace_f2fs_iget_nowait(sb, ino);
+
 	if (inode)
 		return inode;
 	if (!args.on_free)
@@ -119,6 +125,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
 	struct inode *inode;
 	int ret;
 
+	trace_f2fs_iget(sb, ino);
 	inode = iget_locked(sb, ino);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -178,6 +185,7 @@ void update_inode(struct inode *inode, struct page *node_page)
 	struct f2fs_node *rn;
 	struct f2fs_inode *ri;
 
+	trace_f2fs_update_inode(inode, node_page);
 	wait_on_page_writeback(node_page);
 
 	rn = page_address(node_page);
@@ -217,6 +225,7 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 			inode->i_ino == F2FS_META_INO(sbi))
 		return 0;
 
+	trace_f2fs_write_inode(inode);
 	if (wbc)
 		f2fs_balance_fs(sbi);
 
@@ -248,6 +257,7 @@ void f2fs_evict_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
+	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages(&inode->i_data, 0);
 
 	if (inode->i_ino == F2FS_NODE_INO(sbi) ||
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 1a49b88..ecc8353 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -14,6 +14,8 @@
 #include <linux/sched.h>
 #include <linux/ctype.h>
 
+#include <trace/events/f2fs.h>
+
 #include "f2fs.h"
 #include "xattr.h"
 #include "acl.h"
@@ -26,7 +28,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	struct inode *inode;
 	bool nid_free = false;
 	int err;
-
+	trace_f2fs_new_inode(dir, mode);
 	inode = new_inode(sb);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -63,6 +65,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
 	}
 
 	mark_inode_dirty(inode);
+	trace_f2fs_allocate_inode(inode, dir, mode);
 	return inode;
 
 out:
@@ -223,6 +226,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	struct page *page;
 	int err = -ENOENT;
 
+	trace_f2fs_unlink_enter(dir, dentry);
 	f2fs_balance_fs(sbi);
 
 	de = f2fs_find_entry(dir, &dentry->d_name, &page);
@@ -241,6 +245,7 @@ static int f2fs_unlink(struct inode *dir, struct dentry *dentry)
 	/* In order to evict this inode,  we set it dirty */
 	mark_inode_dirty(inode);
 fail:
+	trace_f2fs_unlink_exit(dentry, err);
 	return err;
 }
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 5066bfd..40ceda2 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -16,10 +16,12 @@
 #include <linux/pagevec.h>
 #include <linux/swap.h>
 
+
 #include "f2fs.h"
 #include "node.h"
 #include "segment.h"
 
+#include <trace/events/f2fs.h>
 static struct kmem_cache *nat_entry_slab;
 static struct kmem_cache *free_nid_slab;
 
@@ -29,6 +31,7 @@ static void clear_node_page_dirty(struct page *page)
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
 	unsigned int long flags;
 
+	trace_f2fs_clear_page_dirty(page, NODE);
 	if (PageDirty(page)) {
 		spin_lock_irqsave(&mapping->tree_lock, flags);
 		radix_tree_tag_clear(&mapping->page_tree,
@@ -92,6 +95,7 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
 	pgoff_t index;
 	int i;
 
+	trace_f2fs_ra_nat_pages(sbi->sb, nid);
 	for (i = 0; i < FREE_NID_PAGES; i++, nid += NAT_ENTRY_PER_BLOCK) {
 		if (nid >= nm_i->max_nid)
 			nid = 0;
@@ -236,6 +240,7 @@ static int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 
+	trace_f2fs_try_to_free_nats(sbi->sb, nm_i->nat_blkaddr, nr_shrink);
 	if (nm_i->nat_cnt < 2 * NM_WOUT_THRESHOLD)
 		return 0;
 
@@ -301,6 +306,7 @@ void get_node_info(struct f2fs_sb_info *sbi, nid_t nid, struct node_info *ni)
 cache:
 	/* cache nat entry */
 	cache_nat_entry(NM_I(sbi), nid, &ne);
+	trace_f2fs_get_node_info(sbi->sb, ni->nid, ni->ino);
 }
 
 /*
@@ -395,6 +401,7 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int ro)
 	int level, i;
 	int err = 0;
 
+	trace_f2fs_get_dnode_of_data(dn->inode->i_sb, dn->nid, index);
 	level = get_node_path(index, offset, noffset);
 
 	nids[0] = dn->inode->i_ino;
@@ -483,6 +490,7 @@ static void truncate_node(struct dnode_of_data *dn)
 	struct f2fs_sb_info *sbi = F2FS_SB(dn->inode->i_sb);
 	struct node_info ni;
 
+	trace_f2fs_truncate_node(dn->inode, dn->nid); /*Nid and Inode */
 	get_node_info(sbi, dn->nid, &ni);
 	if (dn->inode->i_blocks == 0) {
 		BUG_ON(ni.blk_addr != NULL_ADDR);
@@ -667,6 +675,7 @@ int truncate_inode_blocks(struct inode *inode, pgoff_t from)
 
 	level = get_node_path(from, offset, noffset);
 
+	trace_f2fs_truncate_inode_blocks(inode, from);
 	page = get_node_page(sbi, inode->i_ino);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
@@ -755,7 +764,7 @@ int remove_inode_page(struct inode *inode)
 		mutex_unlock_op(sbi, NODE_TRUNC);
 		return PTR_ERR(page);
 	}
-
+	trace_f2fs_remove_inode_page(inode, page);
 	if (F2FS_I(inode)->i_xattr_nid) {
 		nid_t nid = F2FS_I(inode)->i_xattr_nid;
 		struct page *npage = get_node_page(sbi, nid);
@@ -806,6 +815,7 @@ struct page *new_node_page(struct dnode_of_data *dn, unsigned int ofs)
 	struct page *page;
 	int err;
 
+	trace_f2fs_new_node_page(dn->inode, dn->nid, ofs);
 	if (is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC))
 		return ERR_PTR(-EPERM);
 
@@ -967,6 +977,7 @@ page_hit:
 
 void sync_inode_page(struct dnode_of_data *dn)
 {
+	trace_f2fs_sync_inode_page(dn->inode, dn->nid);
 	if (IS_INODE(dn->node_page) || dn->inode_page == dn->node_page) {
 		update_inode(dn->inode, dn->node_page);
 	} else if (dn->inode_page) {
@@ -1091,6 +1102,8 @@ static int f2fs_write_node_page(struct page *page,
 	block_t new_addr;
 	struct node_info ni;
 
+	trace_f2fs_write_page(page, NODE);
+
 	if (wbc->for_reclaim) {
 		dec_page_count(sbi, F2FS_DIRTY_NODES);
 		wbc->pages_skipped++;
@@ -1155,6 +1168,7 @@ static int f2fs_set_node_page_dirty(struct page *page)
 	struct address_space *mapping = page->mapping;
 	struct f2fs_sb_info *sbi = F2FS_SB(mapping->host->i_sb);
 
+	trace_f2fs_set_page_dirty(page, NODE);
 	SetPageUptodate(page);
 	if (!PageDirty(page)) {
 		__set_page_dirty_nobuffers(page);
@@ -1169,6 +1183,8 @@ static void f2fs_invalidate_node_page(struct page *page, unsigned long offset)
 {
 	struct inode *inode = page->mapping->host;
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
+
+	trace_f2fs_invalidate_page(page, offset, NODE);
 	if (PageDirty(page))
 		dec_page_count(sbi, F2FS_DIRTY_NODES);
 	ClearPagePrivate(page);
@@ -1176,6 +1192,7 @@ static void f2fs_invalidate_node_page(struct page *page, unsigned long offset)
 
 static int f2fs_release_node_page(struct page *page, gfp_t wait)
 {
+	trace_f2fs_release_page(page, NODE);
 	ClearPagePrivate(page);
 	return 0;
 }
@@ -1342,6 +1359,8 @@ bool alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid)
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *i = NULL;
 	struct list_head *this;
+
+	trace_f2fs_alloc_nid(sbi->sb);
 retry:
 	mutex_lock(&nm_i->build_lock);
 	if (!nm_i->fcnt) {
@@ -1377,6 +1396,7 @@ retry:
 	i->state = NID_ALLOC;
 	nm_i->fcnt--;
 	spin_unlock(&nm_i->free_nid_list_lock);
+	trace_f2fs_allocated_nid(sbi->sb, *nid);
 	return true;
 }
 
@@ -1553,6 +1573,7 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
 	nid_t start_nid = 0, end_nid = 0;
 	bool flushed;
 
+	trace_f2fs_flush_nat_entries(sbi->sb);
 	flushed = flush_nats_in_journal(sbi);
 
 	if (!flushed)
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 4b00990..0db91bf 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -14,6 +14,7 @@
 #include <linux/blkdev.h>
 #include <linux/prefetch.h>
 #include <linux/vmalloc.h>
+#include <trace/events/f2fs.h>
 
 #include "f2fs.h"
 #include "segment.h"
@@ -87,6 +88,7 @@ void locate_dirty_segment(struct f2fs_sb_info *sbi, unsigned int segno)
 	if (segno == NULL_SEGNO || IS_CURSEG(sbi, segno))
 		return;
 
+	trace_f2fs_locate_dirty_segment(sbi->sb, segno);
 	mutex_lock(&dirty_i->seglist_lock);
 
 	valid_blocks = get_valid_blocks(sbi, segno, 0);
@@ -177,6 +179,7 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 	unsigned int segno, offset;
 	long int new_vblocks;
 
+	trace_f2fs_update_sit_entry(sbi->sb, blkaddr);
 	segno = GET_SEGNO(sbi, blkaddr);
 
 	se = get_seg_entry(sbi, segno);
@@ -226,6 +229,7 @@ void invalidate_blocks(struct f2fs_sb_info *sbi, block_t addr)
 	BUG_ON(addr == NULL_ADDR);
 	if (addr == NEW_ADDR)
 		return;
+	trace_f2fs_invalidate_blocks(sbi->sb, addr);
 
 	/* add it into sit main buffer */
 	mutex_lock(&sit_i->sentry_lock);
@@ -546,6 +550,7 @@ static void allocate_segment_by_default(struct f2fs_sb_info *sbi,
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
 	unsigned int ofs_unit;
 
+	trace_f2fs_allocate_segment(sbi->sb, type);
 	if (force) {
 		new_curseg(sbi, type, true);
 		goto out;
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index ac127fd..e8d0783 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -23,6 +23,9 @@
 #include <linux/exportfs.h>
 #include <linux/f2fs_fs.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/f2fs.h>
+
 #include "f2fs.h"
 #include "node.h"
 #include "xattr.h"
@@ -132,6 +135,7 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
 
+	trace_f2fs_sync_fs(sb, sync);
 	if (!sbi->s_dirty && !get_pages(sbi, F2FS_DIRTY_NODES))
 		return 0;
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
new file mode 100644
index 0000000..b7e57c9
--- /dev/null
+++ b/include/trace/events/f2fs.h
@@ -0,0 +1,1220 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM f2fs
+
+#if !defined(_TRACE_F2FS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_F2FS_H
+
+#include <linux/tracepoint.h>
+
+struct node_info;
+
+DECLARE_EVENT_CLASS(f2fs__iget_ops,
+	TP_PROTO(struct super_block *sb, unsigned long ino),
+
+	TP_ARGS(sb, ino),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(unsigned long,	ino)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->ino	= ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino)
+);
+
+DEFINE_EVENT(f2fs__iget_ops, f2fs_iget,
+
+	TP_PROTO(struct super_block *sb, unsigned long ino),
+
+	TP_ARGS(sb, ino)
+);
+
+DEFINE_EVENT(f2fs__iget_ops, f2fs_iget_nowait,
+
+	TP_PROTO(struct super_block *sb, unsigned long ino),
+
+	TP_ARGS(sb, ino)
+);
+
+TRACE_EVENT(f2fs_new_inode,
+	TP_PROTO(struct inode *dir, int mode),
+
+	TP_ARGS(dir, mode),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	dir)
+		__field(umode_t, mode)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= dir->i_sb->s_dev;
+		__entry->dir	= dir->i_ino;
+		__entry->mode	= mode;
+	),
+
+	TP_printk("dev %d,%d dir %lu mode 0%o",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->dir, __entry->mode)
+);
+
+TRACE_EVENT(f2fs_allocate_inode,
+	TP_PROTO(struct inode *inode, struct inode *dir, int mode),
+
+	TP_ARGS(inode, dir, mode),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(ino_t,	dir)
+		__field(umode_t, mode)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->dir	= dir->i_ino;
+		__entry->mode	= mode;
+	),
+
+	TP_printk("dev %d,%d ino %lu dir %lu mode 0%o",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->dir, __entry->mode)
+);
+
+TRACE_EVENT(f2fs_write_inode,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino)
+);
+
+TRACE_EVENT(f2fs_update_inode,
+	TP_PROTO(struct inode *inode, struct page *page),
+
+	TP_ARGS(inode, page),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t, index)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->index	= page->index;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->index)
+);
+
+TRACE_EVENT(f2fs_remove_inode_page,
+	TP_PROTO(struct inode *inode, struct page *page),
+
+	TP_ARGS(inode, page),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t, index)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->index	= page->index;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->index)
+);
+
+TRACE_EVENT(f2fs_sync_inode_page,
+	TP_PROTO(struct inode *inode, u32 nid),
+
+	TP_ARGS(inode, nid),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(u32, nid)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->nid	= nid;
+	),
+
+	TP_printk("dev %d,%d ino %lu nid %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->nid)
+);
+
+TRACE_EVENT(f2fs_evict_inode,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(int,	nlink)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->nlink	= inode->i_nlink;
+	),
+
+	TP_printk("dev %d,%d ino %lu nlink %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->nlink)
+);
+
+TRACE_EVENT(f2fs_orphan_inode,
+	TP_PROTO(struct super_block *sb, unsigned int ino),
+
+	TP_ARGS(sb, ino),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->ino	= ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino)
+);
+
+TRACE_EVENT(f2fs_remove_orphan_inode,
+	TP_PROTO(struct super_block *sb, unsigned int ino),
+
+	TP_ARGS(sb, ino),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->ino	= ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino)
+);
+
+TRACE_EVENT(f2fs_update_extent_cache,
+	TP_PROTO(u64 blk_addr),
+
+	TP_ARGS(blk_addr),
+
+	TP_STRUCT__entry(
+		__field(u64, blk_addr)
+	),
+
+	TP_fast_assign(
+		__entry->blk_addr = blk_addr;
+	),
+
+	TP_printk("Cache extent block address %llu ",
+		   __entry->blk_addr)
+);
+
+DECLARE_EVENT_CLASS(f2fs__truncate_op,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_data_blocks_enter,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_data_blocks_exit,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_enter,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(f2fs__truncate_op, f2fs_truncate_exit,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+TRACE_EVENT(f2fs_truncate_hole,
+
+	TP_PROTO(struct inode *inode, pgoff_t pg_start, pgoff_t pg_end),
+
+	TP_ARGS(inode, pg_start, pg_end),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t, pg_start)
+		__field(pgoff_t, pg_end)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pg_start = pg_start;
+		__entry->pg_end	= pg_end;
+	),
+
+	TP_printk("dev %d,%d ino %lu Start offset %lu End Offset %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->pg_start,
+				  __entry->pg_end)
+);
+
+TRACE_EVENT(f2fs_punch_hole,
+
+	TP_PROTO(struct inode *inode, loff_t offset, loff_t len),
+
+	TP_ARGS(inode, offset, len),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t, offset)
+		__field(loff_t, len)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->offset = offset;
+		__entry->len	= len;
+	),
+
+	TP_printk("dev %d,%d ino %lu offset %llu length %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->offset,
+				  __entry->len)
+);
+
+TRACE_EVENT(f2fs_truncate_node,
+
+	TP_PROTO(struct inode *inode, unsigned int nid),
+
+	TP_ARGS(inode, nid),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(unsigned int, nid)
+		__field(ino_t,	ino)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->nid	= nid;
+		__entry->ino	= inode->i_ino;
+	),
+
+	TP_printk("dev %d,%d: with Nid %u  Inode Number %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->nid, (unsigned long)__entry->ino)
+);
+
+TRACE_EVENT(f2fs_fallocate_enter,
+	TP_PROTO(struct inode *inode, loff_t offset, loff_t len, int mode),
+
+	TP_ARGS(inode, offset, len, mode),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	pos)
+		__field(loff_t,	len)
+		__field(int,	mode)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= offset;
+		__entry->len	= len;
+		__entry->mode	= mode;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %lld len %lld mode %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->pos,
+		  __entry->len, __entry->mode)
+);
+
+TRACE_EVENT(f2fs_fallocate_exit,
+	TP_PROTO(struct inode *inode, loff_t offset,
+		 unsigned int max_blocks, int ret),
+
+	TP_ARGS(inode, offset, max_blocks, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	pos)
+		__field(unsigned int,	blocks)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= offset;
+		__entry->blocks	= max_blocks;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %lld blocks %u ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->pos, __entry->blocks,
+		  __entry->ret)
+);
+
+TRACE_EVENT(f2fs_truncate_inode_blocks,
+	TP_PROTO(struct inode *inode, pgoff_t from),
+
+	TP_ARGS(inode, from),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t, pos)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= from;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->pos)
+);
+
+TRACE_EVENT(f2fs_locate_dirty_segment,
+	TP_PROTO(struct super_block *sb, unsigned int segno),
+
+	TP_ARGS(sb, segno),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(unsigned int,	segno)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->segno	= segno;
+	),
+
+	TP_printk("dev %d,%d  segno %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->segno)
+);
+
+TRACE_EVENT(f2fs_allocate_segment,
+	TP_PROTO(struct super_block *sb, int type),
+
+	TP_ARGS(sb, type),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int, type)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->type	= type;
+	),
+
+	TP_printk("dev %d,%d  type %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->type)
+);
+
+TRACE_EVENT(f2fs_update_sit_entry,
+	TP_PROTO(struct super_block *sb, u64 addr),
+
+	TP_ARGS(sb, addr),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(u64, addr)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->addr	= addr;
+	),
+
+	TP_printk("dev %d,%d  adress block %llu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->addr)
+);
+
+TRACE_EVENT(f2fs_invalidate_blocks,
+	TP_PROTO(struct super_block *sb, u64 addr),
+
+	TP_ARGS(sb, addr),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(u64, addr)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->addr	= addr;
+	),
+
+	TP_printk("dev %d,%d  adress block %llu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->addr)
+);
+
+TRACE_EVENT(f2fs_get_page,
+	TP_PROTO(struct super_block *sb, pgoff_t index, int type),
+
+	TP_ARGS(sb, index, type),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(pgoff_t, index)
+		__field(int, type)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->index	= index;
+		__entry->type	= type;
+	),
+
+	TP_printk("dev %d,%d  page_index %lu, type %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->index, __entry->type)
+);
+
+TRACE_EVENT(f2fs_grab_page,
+	TP_PROTO(struct super_block *sb, pgoff_t index, int type),
+
+	TP_ARGS(sb, index, type),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(pgoff_t, index)
+		__field(int, type)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->index	= index;
+		__entry->type	= type;
+	),
+
+	TP_printk("dev %d,%d  page_index %lu, type %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->index, __entry->type)
+);
+
+DECLARE_EVENT_CLASS(f2fs__page_op,
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page),
+
+	TP_STRUCT__entry(
+		__field(pgoff_t, index)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->index)
+);
+
+DEFINE_EVENT(f2fs__page_op, f2fs_writepage,
+
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page)
+);
+
+DEFINE_EVENT(f2fs__page_op, f2fs_readpage,
+
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page)
+);
+
+TRACE_EVENT(f2fs_vm_page_mkwrite,
+	TP_PROTO(struct vm_area_struct *vma),
+
+	TP_ARGS(vma),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, start)
+		__field(unsigned long, end)
+
+	),
+
+	TP_fast_assign(
+		__entry->start	= vma->vm_start;
+		__entry->end	= vma->vm_end;
+	),
+
+	TP_printk("VMA Start %lu VMA End %lu",
+		   __entry->start, __entry->end)
+);
+
+DECLARE_EVENT_CLASS(f2fs_type_page_op,
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type),
+
+	TP_STRUCT__entry(
+		__field(pgoff_t, index)
+		__field(int, type)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->type	= type;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu type %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->index, __entry->type)
+);
+
+DEFINE_EVENT(f2fs_type_page_op, f2fs_write_page,
+
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type)
+);
+
+DEFINE_EVENT(f2fs_type_page_op, f2fs_read_page,
+
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type)
+);
+
+DEFINE_EVENT(f2fs_type_page_op, f2fs_release_page,
+
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type)
+);
+
+DEFINE_EVENT(f2fs_type_page_op, f2fs_set_page_dirty,
+
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type)
+);
+
+TRACE_EVENT(f2fs_ra_nat_pages,
+	TP_PROTO(struct super_block *sb, int nid),
+
+	TP_ARGS(sb, nid),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int, nid)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->nid	= nid;
+	),
+
+	TP_printk("dev %d,%d  nid %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->nid)
+);
+
+TRACE_EVENT(f2fs_clear_page_dirty,
+	TP_PROTO(struct page *page, int type),
+
+	TP_ARGS(page, type),
+
+	TP_STRUCT__entry(
+		__field(pgoff_t, index)
+		__field(int, type)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->type	= type;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu type %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->index, __entry->type)
+);
+
+TRACE_EVENT(f2fs_set_dirty_dir_page,
+	TP_PROTO(struct inode *inode, struct page *page),
+
+	TP_ARGS(inode, page),
+
+	TP_STRUCT__entry(
+		__field(pgoff_t, index)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->ino	= inode->i_ino;
+		__entry->dev	= inode->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->index)
+);
+
+TRACE_EVENT(f2fs_sync_pages,
+	TP_PROTO(struct super_block *sb, int type, int nr_to_write),
+
+	TP_ARGS(sb, type, nr_to_write),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int, type)
+		__field(int, nr_to_write)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->type	= type;
+		__entry->nr_to_write = nr_to_write;
+	),
+
+	TP_printk("dev %d,%d  type %d to write %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->type, __entry->nr_to_write)
+);
+
+TRACE_EVENT(f2fs_operations,
+	TP_PROTO(struct super_block *sb, int type),
+
+	TP_ARGS(sb, type),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int, type)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->type	= type;
+	),
+
+	TP_printk("dev %d,%d  operation %s ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   (__entry->type ? "blocking" : "unblocking"))
+);
+
+TRACE_EVENT(f2fs_writecheckpoint,
+
+	TP_PROTO(struct super_block *sb, bool type),
+
+	TP_ARGS(sb, type),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(bool, type)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->type	= type;
+	),
+
+	TP_printk("dev %d,%d: %s ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   (__entry->type ? "Blocking" : "Unblocking"))
+);
+
+TRACE_EVENT(f2fs_reserve_new_block,
+	TP_PROTO(struct inode *inode, unsigned int nid),
+
+	TP_ARGS(inode, nid),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(unsigned int, nid)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->nid	= nid;
+	),
+
+	TP_printk("dev %d,%d: with Nid %u ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->nid)
+);
+
+TRACE_EVENT(f2fs_new_node_page,
+
+	TP_PROTO(struct inode *inode, unsigned int nid, unsigned int offset),
+
+	TP_ARGS(inode, nid, offset),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(unsigned int, nid)
+		__field(unsigned int, offset)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->nid	= nid;
+		__entry->offset	= offset;
+	),
+
+	TP_printk("dev %d,%d: with Nid %u offset %u ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->nid, __entry->offset)
+);
+
+TRACE_EVENT(f2fs_new_data_page,
+	TP_PROTO(struct inode *inode, pgoff_t index),
+
+	TP_ARGS(inode, index),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(pgoff_t, index)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->index	= index;
+	),
+
+	TP_printk("dev %d,%d: data page with index %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->index)
+);
+
+TRACE_EVENT(f2fs_write_begin,
+
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+		 unsigned int flags),
+
+	TP_ARGS(inode, pos, len, flags),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(loff_t,	pos)
+		__field(unsigned int, len)
+		__field(unsigned int, flags)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= pos;
+		__entry->len	= len;
+		__entry->flags	= flags;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %lld len %u flags %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->pos, __entry->len, __entry->flags)
+);
+
+TRACE_EVENT(f2fs_invalidate_page,
+	TP_PROTO(struct page *page, unsigned long offset, int type),
+
+	TP_ARGS(page, offset, type),
+
+	TP_STRUCT__entry(
+		__field(pgoff_t, index)
+		__field(unsigned long, offset)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+		__field(int,	type)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->offset	= offset;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+		__entry->type	= type;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu offset %lu type %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->index, __entry->offset,
+				  __entry->type)
+);
+
+TRACE_EVENT(f2fs_try_to_free_nats,
+	TP_PROTO(struct super_block *sb, u64 blkaddr, int nr_to_shrink) ,
+
+	TP_ARGS(sb, blkaddr, nr_to_shrink),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(u64,	blkaddr)
+		__field(int,	nr_to_shrink)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->blkaddr = blkaddr;
+		__entry->nr_to_shrink = nr_to_shrink;
+	),
+
+	TP_printk("dev %d,%d Nat Base address %llu number to shrink %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+			__entry->blkaddr, __entry->nr_to_shrink)
+);
+
+TRACE_EVENT(f2fs_alloc_nid,
+	TP_PROTO(struct super_block *sb),
+
+	TP_ARGS(sb),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d allocating nid ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev))
+);
+
+TRACE_EVENT(f2fs_allocated_nid,
+	TP_PROTO(struct super_block *sb, u32 nid),
+
+	TP_ARGS(sb, nid),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(u32,	nid)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->nid = nid
+	),
+
+	TP_printk("dev %d,%d allocated nid %u ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+			__entry->nid)
+);
+
+TRACE_EVENT(f2fs_flush_nat_entries,
+	TP_PROTO(struct super_block *sb),
+
+	TP_ARGS(sb),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev))
+);
+
+TRACE_EVENT(f2fs_get_node_info,
+	TP_PROTO(struct super_block *sb, u32 nid, u32 ino),
+
+	TP_ARGS(sb, nid, ino),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(u32,	nid)
+		__field(u32,	ino)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->nid = nid;
+		__entry->ino = ino;
+	),
+
+	TP_printk("dev %d,%d Node Nid %u Node Inode No %u ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+			__entry->nid, __entry->ino)
+);
+
+TRACE_EVENT(f2fs_get_dnode_of_data,
+	TP_PROTO(struct super_block *sb, u32 nid, pgoff_t index),
+
+	TP_ARGS(sb, nid, index),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(u32,	nid)
+		__field(pgoff_t, index)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->nid = nid;
+		__entry->index = index;
+	),
+
+	TP_printk("dev %d,%d Node Nid %u page_index %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+			__entry->nid, __entry->index)
+);
+
+TRACE_EVENT(f2fs_sync_file_enter,
+	TP_PROTO(struct file *file, int datasync),
+
+	TP_ARGS(file, datasync),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(ino_t,	parent)
+		__field(int,	datasync)
+	),
+
+	TP_fast_assign(
+		struct dentry *dentry = file->f_path.dentry;
+
+		__entry->dev		= dentry->d_inode->i_sb->s_dev;
+		__entry->ino		= dentry->d_inode->i_ino;
+		__entry->datasync	= datasync;
+		__entry->parent		= dentry->d_parent->d_inode->i_ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu parent %lu datasync %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->parent, __entry->datasync)
+);
+
+TRACE_EVENT(f2fs_sync_file_exit,
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret),
+
+	TP_STRUCT__entry(
+		__field(int,	ret)
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+	),
+
+	TP_fast_assign(
+		__entry->ret		= ret;
+		__entry->ino		= inode->i_ino;
+		__entry->dev		= inode->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->ret)
+);
+
+TRACE_EVENT(f2fs_sync_fs,
+	TP_PROTO(struct super_block *sb, int wait),
+
+	TP_ARGS(sb, wait),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(int,	wait)
+
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->wait	= wait;
+	),
+
+	TP_printk("dev %d,%d wait %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->wait)
+);
+
+TRACE_EVENT(f2fs_direct_IO_enter,
+	TP_PROTO(struct inode *inode, loff_t offset, unsigned long len, int rw),
+
+	TP_ARGS(inode, offset, len, rw),
+
+	TP_STRUCT__entry(
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+		__field(loff_t,	pos)
+		__field(unsigned long,	len)
+		__field(int,	rw)
+	),
+
+	TP_fast_assign(
+		__entry->ino	= inode->i_ino;
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->pos	= offset;
+		__entry->len	= len;
+		__entry->rw	= rw;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %lld len %lu rw %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->pos, __entry->len, __entry->rw)
+);
+
+TRACE_EVENT(f2fs_unlink_enter,
+	TP_PROTO(struct inode *parent, struct dentry *dentry),
+
+	TP_ARGS(parent, dentry),
+
+	TP_STRUCT__entry(
+		__field(ino_t,	parent)
+		__field(ino_t,	ino)
+		__field(loff_t,	size)
+		__field(dev_t,	dev)
+	),
+
+	TP_fast_assign(
+		__entry->parent		= parent->i_ino;
+		__entry->ino		= dentry->d_inode->i_ino;
+		__entry->size		= dentry->d_inode->i_size;
+		__entry->dev		= dentry->d_inode->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu size %lld parent %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->size,
+		  (unsigned long) __entry->parent)
+);
+
+TRACE_EVENT(f2fs_unlink_exit,
+	TP_PROTO(struct dentry *dentry, int ret),
+
+	TP_ARGS(dentry, ret),
+
+	TP_STRUCT__entry(
+		__field(ino_t,	ino)
+		__field(dev_t,	dev)
+		__field(int,	ret)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= dentry->d_inode->i_ino;
+		__entry->dev		= dentry->d_inode->i_sb->s_dev;
+		__entry->ret		= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->ret)
+);
+
+#endif /* _TRACE_F2FS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.9.5

