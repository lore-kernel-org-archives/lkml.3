Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaICFCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:02:45 -0400
Received: from mail.kernel.org ([198.145.19.201]:37804 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbaICFCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:02:42 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/6] f2fs: need fsck.f2fs when f2fs_bug_on is triggered
Date: Tue,  2 Sep 2014 22:02:31 -0700
Message-Id: <1409720554-72925-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1409720554-72925-1-git-send-email-jaegeuk@kernel.org>
References: <1409720554-72925-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If any f2fs_bug_on is triggered, fsck.f2fs is needed.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c |  6 +++---
 fs/f2fs/data.c       |  4 ++--
 fs/f2fs/dir.c        |  4 ++--
 fs/f2fs/f2fs.h       | 26 ++++++++++++++---------
 fs/f2fs/file.c       |  2 +-
 fs/f2fs/inline.c     |  4 ++--
 fs/f2fs/inode.c      |  2 +-
 fs/f2fs/node.c       | 58 ++++++++++++++++++++++++++--------------------------
 fs/f2fs/recovery.c   |  8 ++++----
 fs/f2fs/segment.c    | 17 +++++++--------
 fs/f2fs/xattr.c      |  2 +-
 11 files changed, 70 insertions(+), 63 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 5af97d9..935a56e 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -374,7 +374,7 @@ int acquire_orphan_inode(struct f2fs_sb_info *sbi)
 void release_orphan_inode(struct f2fs_sb_info *sbi)
 {
 	spin_lock(&sbi->ino_lock[ORPHAN_INO]);
-	f2fs_bug_on(sbi->n_orphans == 0);
+	f2fs_bug_on(sbi, sbi->n_orphans == 0);
 	sbi->n_orphans--;
 	spin_unlock(&sbi->ino_lock[ORPHAN_INO]);
 }
@@ -394,7 +394,7 @@ void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 static void recover_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
 {
 	struct inode *inode = f2fs_iget(sbi->sb, ino);
-	f2fs_bug_on(IS_ERR(inode));
+	f2fs_bug_on(sbi, IS_ERR(inode));
 	clear_nlink(inode);
 
 	/* truncate all the data during iput */
@@ -455,7 +455,7 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	list_for_each_entry(orphan, head, list) {
 		if (!page) {
 			page = find_get_page(META_MAPPING(sbi), start_blk++);
-			f2fs_bug_on(!page);
+			f2fs_bug_on(sbi, !page);
 			orphan_blk =
 				(struct f2fs_orphan_block *)page_address(page);
 			memset(orphan_blk, 0, sizeof(*orphan_blk));
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 8eb6fca..64d8550 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -258,7 +258,7 @@ int f2fs_reserve_block(struct dnode_of_data *dn, pgoff_t index)
 	int err;
 
 	/* if inode_page exists, index should be zero */
-	f2fs_bug_on(!need_put && index);
+	f2fs_bug_on(F2FS_I_SB(dn->inode), !need_put && index);
 
 	err = get_dnode_of_data(dn, index, ALLOC_NODE);
 	if (err)
@@ -321,7 +321,7 @@ void update_extent_cache(block_t blk_addr, struct dnode_of_data *dn)
 	block_t start_blkaddr, end_blkaddr;
 	int need_update = true;
 
-	f2fs_bug_on(blk_addr == NEW_ADDR);
+	f2fs_bug_on(F2FS_I_SB(dn->inode), blk_addr == NEW_ADDR);
 	fofs = start_bidx_of_node(ofs_of_node(dn->node_page), fi) +
 							dn->ofs_in_node;
 
diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index c242904..f1ceeb2 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -126,7 +126,7 @@ static struct f2fs_dir_entry *find_in_block(struct page *dentry_page,
 		 * For the most part, it should be a bug when name_len is zero.
 		 * We stop here for figuring out where the bugs has occurred.
 		 */
-		f2fs_bug_on(!de->name_len);
+		f2fs_bug_on(F2FS_P_SB(dentry_page), !de->name_len);
 
 		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
 	}
@@ -151,7 +151,7 @@ static struct f2fs_dir_entry *find_in_level(struct inode *dir,
 	bool room = false;
 	int max_slots = 0;
 
-	f2fs_bug_on(level > MAX_DIR_HASH_DEPTH);
+	f2fs_bug_on(F2FS_I_SB(dir), level > MAX_DIR_HASH_DEPTH);
 
 	nbucket = dir_buckets(level, F2FS_I(dir)->i_dir_level);
 	nblock = bucket_blocks(level);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 210c62d..b389ced 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -21,10 +21,16 @@
 #include <linux/sched.h>
 
 #ifdef CONFIG_F2FS_CHECK_FS
-#define f2fs_bug_on(condition)	BUG_ON(condition)
+#define f2fs_bug_on(sbi, condition)	BUG_ON(condition)
 #define f2fs_down_write(x, y)	down_write_nest_lock(x, y)
 #else
-#define f2fs_bug_on(condition)	WARN_ON(condition)
+#define f2fs_bug_on(sbi, condition)					\
+	do {								\
+		if (unlikely(condition)) {				\
+			WARN_ON(1);					\
+			sbi->need_fsck = true;				\
+		}							\
+	} while (0)
 #define f2fs_down_write(x, y)	down_write(x)
 #endif
 
@@ -719,8 +725,8 @@ static inline void dec_valid_block_count(struct f2fs_sb_info *sbi,
 						blkcnt_t count)
 {
 	spin_lock(&sbi->stat_lock);
-	f2fs_bug_on(sbi->total_valid_block_count < (block_t) count);
-	f2fs_bug_on(inode->i_blocks < count);
+	f2fs_bug_on(sbi, sbi->total_valid_block_count < (block_t) count);
+	f2fs_bug_on(sbi, inode->i_blocks < count);
 	inode->i_blocks -= count;
 	sbi->total_valid_block_count -= (block_t)count;
 	spin_unlock(&sbi->stat_lock);
@@ -864,9 +870,9 @@ static inline void dec_valid_node_count(struct f2fs_sb_info *sbi,
 {
 	spin_lock(&sbi->stat_lock);
 
-	f2fs_bug_on(!sbi->total_valid_block_count);
-	f2fs_bug_on(!sbi->total_valid_node_count);
-	f2fs_bug_on(!inode->i_blocks);
+	f2fs_bug_on(sbi, !sbi->total_valid_block_count);
+	f2fs_bug_on(sbi, !sbi->total_valid_node_count);
+	f2fs_bug_on(sbi, !inode->i_blocks);
 
 	inode->i_blocks--;
 	sbi->total_valid_node_count--;
@@ -883,7 +889,7 @@ static inline unsigned int valid_node_count(struct f2fs_sb_info *sbi)
 static inline void inc_valid_inode_count(struct f2fs_sb_info *sbi)
 {
 	spin_lock(&sbi->stat_lock);
-	f2fs_bug_on(sbi->total_valid_inode_count == sbi->total_node_count);
+	f2fs_bug_on(sbi, sbi->total_valid_inode_count == sbi->total_node_count);
 	sbi->total_valid_inode_count++;
 	spin_unlock(&sbi->stat_lock);
 }
@@ -891,7 +897,7 @@ static inline void inc_valid_inode_count(struct f2fs_sb_info *sbi)
 static inline void dec_valid_inode_count(struct f2fs_sb_info *sbi)
 {
 	spin_lock(&sbi->stat_lock);
-	f2fs_bug_on(!sbi->total_valid_inode_count);
+	f2fs_bug_on(sbi, !sbi->total_valid_inode_count);
 	sbi->total_valid_inode_count--;
 	spin_unlock(&sbi->stat_lock);
 }
@@ -907,7 +913,7 @@ static inline void f2fs_put_page(struct page *page, int unlock)
 		return;
 
 	if (unlock) {
-		f2fs_bug_on(!PageLocked(page));
+		f2fs_bug_on(F2FS_P_SB(page), !PageLocked(page));
 		unlock_page(page);
 	}
 	page_cache_release(page);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 411f053..9f0ea3d 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -463,7 +463,7 @@ int truncate_blocks(struct inode *inode, u64 from, bool lock)
 	count = ADDRS_PER_PAGE(dn.node_page, F2FS_I(inode));
 
 	count -= dn.ofs_in_node;
-	f2fs_bug_on(count < 0);
+	f2fs_bug_on(sbi, count < 0);
 
 	if (dn.ofs_in_node || IS_INODE(dn.node_page)) {
 		truncate_data_blocks_range(&dn, count);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 289f99e..6aef11d 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -226,7 +226,7 @@ bool recover_inline_data(struct inode *inode, struct page *npage)
 			ri && (ri->i_inline & F2FS_INLINE_DATA)) {
 process_inline:
 		ipage = get_node_page(sbi, inode->i_ino);
-		f2fs_bug_on(IS_ERR(ipage));
+		f2fs_bug_on(sbi, IS_ERR(ipage));
 
 		f2fs_wait_on_page_writeback(ipage, NODE);
 
@@ -240,7 +240,7 @@ process_inline:
 
 	if (f2fs_has_inline_data(inode)) {
 		ipage = get_node_page(sbi, inode->i_ino);
-		f2fs_bug_on(IS_ERR(ipage));
+		f2fs_bug_on(sbi, IS_ERR(ipage));
 		f2fs_wait_on_page_writeback(ipage, NODE);
 		zero_user_segment(ipage, INLINE_DATA_OFFSET,
 				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index bf99e1f..95c0bc2 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -276,7 +276,7 @@ void f2fs_evict_inode(struct inode *inode)
 			inode->i_ino == F2FS_META_INO(sbi))
 		goto out_clear;
 
-	f2fs_bug_on(get_dirty_dents(inode));
+	f2fs_bug_on(sbi, get_dirty_dents(inode));
 	remove_dirty_dir_inode(inode);
 
 	if (inode->i_nlink || is_bad_inode(inode))
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 725a471..1af7879 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -91,7 +91,7 @@ static struct page *get_next_nat_page(struct f2fs_sb_info *sbi, nid_t nid)
 	/* get current nat block page with lock */
 	src_page = get_meta_page(sbi, src_off);
 	dst_page = grab_meta_page(sbi, dst_off);
-	f2fs_bug_on(PageDirty(src_page));
+	f2fs_bug_on(sbi, PageDirty(src_page));
 
 	src_addr = page_address(src_page);
 	dst_addr = page_address(dst_page);
@@ -215,7 +215,7 @@ retry:
 			goto retry;
 		}
 		e->ni = *ni;
-		f2fs_bug_on(ni->blk_addr == NEW_ADDR);
+		f2fs_bug_on(sbi, ni->blk_addr == NEW_ADDR);
 	} else if (new_blkaddr == NEW_ADDR) {
 		/*
 		 * when nid is reallocated,
@@ -223,16 +223,16 @@ retry:
 		 * So, reinitialize it with new information.
 		 */
 		e->ni = *ni;
-		f2fs_bug_on(ni->blk_addr != NULL_ADDR);
+		f2fs_bug_on(sbi, ni->blk_addr != NULL_ADDR);
 	}
 
 	/* sanity check */
-	f2fs_bug_on(nat_get_blkaddr(e) != ni->blk_addr);
-	f2fs_bug_on(nat_get_blkaddr(e) == NULL_ADDR &&
+	f2fs_bug_on(sbi, nat_get_blkaddr(e) != ni->blk_addr);
+	f2fs_bug_on(sbi, nat_get_blkaddr(e) == NULL_ADDR &&
 			new_blkaddr == NULL_ADDR);
-	f2fs_bug_on(nat_get_blkaddr(e) == NEW_ADDR &&
+	f2fs_bug_on(sbi, nat_get_blkaddr(e) == NEW_ADDR &&
 			new_blkaddr == NEW_ADDR);
-	f2fs_bug_on(nat_get_blkaddr(e) != NEW_ADDR &&
+	f2fs_bug_on(sbi, nat_get_blkaddr(e) != NEW_ADDR &&
 			nat_get_blkaddr(e) != NULL_ADDR &&
 			new_blkaddr == NEW_ADDR);
 
@@ -508,10 +508,10 @@ static void truncate_node(struct dnode_of_data *dn)
 
 	get_node_info(sbi, dn->nid, &ni);
 	if (dn->inode->i_blocks == 0) {
-		f2fs_bug_on(ni.blk_addr != NULL_ADDR);
+		f2fs_bug_on(sbi, ni.blk_addr != NULL_ADDR);
 		goto invalidate;
 	}
-	f2fs_bug_on(ni.blk_addr == NULL_ADDR);
+	f2fs_bug_on(sbi, ni.blk_addr == NULL_ADDR);
 
 	/* Deallocate node address */
 	invalidate_blocks(sbi, ni.blk_addr);
@@ -836,7 +836,8 @@ void remove_inode_page(struct inode *inode)
 		truncate_data_blocks_range(&dn, 1);
 
 	/* 0 is possible, after f2fs_new_inode() has failed */
-	f2fs_bug_on(inode->i_blocks != 0 && inode->i_blocks != 1);
+	f2fs_bug_on(F2FS_I_SB(inode),
+			inode->i_blocks != 0 && inode->i_blocks != 1);
 
 	/* will put inode & node pages */
 	truncate_node(&dn);
@@ -876,7 +877,7 @@ struct page *new_node_page(struct dnode_of_data *dn,
 	get_node_info(sbi, dn->nid, &old_ni);
 
 	/* Reinitialize old_ni with new node page */
-	f2fs_bug_on(old_ni.blk_addr != NULL_ADDR);
+	f2fs_bug_on(sbi, old_ni.blk_addr != NULL_ADDR);
 	new_ni = old_ni;
 	new_ni.ino = dn->inode->i_ino;
 	set_node_addr(sbi, &new_ni, NEW_ADDR, false);
@@ -1222,7 +1223,7 @@ static int f2fs_write_node_page(struct page *page,
 
 	/* get old block addr of this node page */
 	nid = nid_of_node(page);
-	f2fs_bug_on(page->index != nid);
+	f2fs_bug_on(sbi, page->index != nid);
 
 	get_node_info(sbi, nid, &ni);
 
@@ -1405,7 +1406,7 @@ static void scan_nat_page(struct f2fs_sb_info *sbi,
 			break;
 
 		blk_addr = le32_to_cpu(nat_blk->entries[i].block_addr);
-		f2fs_bug_on(blk_addr == NEW_ADDR);
+		f2fs_bug_on(sbi, blk_addr == NEW_ADDR);
 		if (blk_addr == NULL_ADDR) {
 			if (add_free_nid(sbi, start_nid, true) < 0)
 				break;
@@ -1475,12 +1476,12 @@ retry:
 
 	/* We should not use stale free nids created by build_free_nids */
 	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
-		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
+		f2fs_bug_on(sbi, list_empty(&nm_i->free_nid_list));
 		list_for_each_entry(i, &nm_i->free_nid_list, list)
 			if (i->state == NID_NEW)
 				break;
 
-		f2fs_bug_on(i->state != NID_NEW);
+		f2fs_bug_on(sbi, i->state != NID_NEW);
 		*nid = i->nid;
 		i->state = NID_ALLOC;
 		nm_i->fcnt--;
@@ -1506,7 +1507,7 @@ void alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid)
 
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nm_i, nid);
-	f2fs_bug_on(!i || i->state != NID_ALLOC);
+	f2fs_bug_on(sbi, !i || i->state != NID_ALLOC);
 	__del_from_free_nid_list(nm_i, i);
 	spin_unlock(&nm_i->free_nid_list_lock);
 
@@ -1527,7 +1528,7 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nm_i, nid);
-	f2fs_bug_on(!i || i->state != NID_ALLOC);
+	f2fs_bug_on(sbi, !i || i->state != NID_ALLOC);
 	if (!available_free_memory(sbi, FREE_NIDS)) {
 		__del_from_free_nid_list(nm_i, i);
 		need_free = true;
@@ -1549,7 +1550,7 @@ void recover_inline_xattr(struct inode *inode, struct page *page)
 	struct f2fs_inode *ri;
 
 	ipage = get_node_page(F2FS_I_SB(inode), inode->i_ino);
-	f2fs_bug_on(IS_ERR(ipage));
+	f2fs_bug_on(F2FS_I_SB(inode), IS_ERR(ipage));
 
 	ri = F2FS_INODE(page);
 	if (!(ri->i_inline & F2FS_INLINE_XATTR)) {
@@ -1581,7 +1582,7 @@ void recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
 
 	/* Deallocate node address */
 	get_node_info(sbi, prev_xnid, &ni);
-	f2fs_bug_on(ni.blk_addr == NULL_ADDR);
+	f2fs_bug_on(sbi, ni.blk_addr == NULL_ADDR);
 	invalidate_blocks(sbi, ni.blk_addr);
 	dec_valid_node_count(sbi, inode);
 	set_node_addr(sbi, &ni, NULL_ADDR, false);
@@ -1589,7 +1590,7 @@ void recover_xattr_data(struct inode *inode, struct page *page, block_t blkaddr)
 recover_xnid:
 	/* 2: allocate new xattr nid */
 	if (unlikely(!inc_valid_node_count(sbi, inode)))
-		f2fs_bug_on(1);
+		f2fs_bug_on(sbi, 1);
 
 	remove_free_nid(NM_I(sbi), new_xnid);
 	get_node_info(sbi, new_xnid, &ni);
@@ -1738,8 +1739,6 @@ static struct nat_entry_set *grab_nat_entry_set(void)
 static void release_nat_entry_set(struct nat_entry_set *nes,
 						struct f2fs_nm_info *nm_i)
 {
-	f2fs_bug_on(!list_empty(&nes->entry_list));
-
 	nm_i->dirty_nat_cnt -= nes->entry_cnt;
 	list_del(&nes->set_list);
 	kmem_cache_free(nat_entry_set_slab, nes);
@@ -1892,7 +1891,7 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
 		} else {
 			page = get_next_nat_page(sbi, start_nid);
 			nat_blk = page_address(page);
-			f2fs_bug_on(!nat_blk);
+			f2fs_bug_on(sbi, !nat_blk);
 		}
 
 		/* flush dirty nats in nat entry set */
@@ -1904,7 +1903,7 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
 			if (to_journal) {
 				offset = lookup_journal_in_cursum(sum,
 							NAT_JOURNAL, nid, 1);
-				f2fs_bug_on(offset < 0);
+				f2fs_bug_on(sbi, offset < 0);
 				raw_ne = &nat_in_journal(sum, offset);
 				nid_in_journal(sum, offset) = cpu_to_le32(nid);
 			} else {
@@ -1929,11 +1928,12 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
 		else
 			f2fs_put_page(page, 1);
 
+		f2fs_bug_on(sbi, !list_empty(&nes->entry_list));
 		release_nat_entry_set(nes, nm_i);
 	}
 
-	f2fs_bug_on(!list_empty(head));
-	f2fs_bug_on(nm_i->dirty_nat_cnt);
+	f2fs_bug_on(sbi, !list_empty(head));
+	f2fs_bug_on(sbi, nm_i->dirty_nat_cnt);
 }
 
 static int init_node_manager(struct f2fs_sb_info *sbi)
@@ -2011,14 +2011,14 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 	/* destroy free nid list */
 	spin_lock(&nm_i->free_nid_list_lock);
 	list_for_each_entry_safe(i, next_i, &nm_i->free_nid_list, list) {
-		f2fs_bug_on(i->state == NID_ALLOC);
+		f2fs_bug_on(sbi, i->state == NID_ALLOC);
 		__del_from_free_nid_list(nm_i, i);
 		nm_i->fcnt--;
 		spin_unlock(&nm_i->free_nid_list_lock);
 		kmem_cache_free(free_nid_slab, i);
 		spin_lock(&nm_i->free_nid_list_lock);
 	}
-	f2fs_bug_on(nm_i->fcnt);
+	f2fs_bug_on(sbi, nm_i->fcnt);
 	spin_unlock(&nm_i->free_nid_list_lock);
 
 	/* destroy nat cache */
@@ -2030,7 +2030,7 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 		for (idx = 0; idx < found; idx++)
 			__del_from_nat_cache(nm_i, natvec[idx]);
 	}
-	f2fs_bug_on(nm_i->nat_cnt);
+	f2fs_bug_on(sbi, nm_i->nat_cnt);
 	write_unlock(&nm_i->nat_tree_lock);
 
 	kfree(nm_i->nat_bitmap);
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 5c095f7..6c5a74a 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -331,8 +331,8 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 	f2fs_wait_on_page_writeback(dn.node_page, NODE);
 
 	get_node_info(sbi, dn.nid, &ni);
-	f2fs_bug_on(ni.ino != ino_of_node(page));
-	f2fs_bug_on(ofs_of_node(dn.node_page) != ofs_of_node(page));
+	f2fs_bug_on(sbi, ni.ino != ino_of_node(page));
+	f2fs_bug_on(sbi, ofs_of_node(dn.node_page) != ofs_of_node(page));
 
 	for (; start < end; start++) {
 		block_t src, dest;
@@ -344,7 +344,7 @@ static int do_recover_data(struct f2fs_sb_info *sbi, struct inode *inode,
 			if (src == NULL_ADDR) {
 				err = reserve_new_block(&dn);
 				/* We should not get -ENOSPC */
-				f2fs_bug_on(err);
+				f2fs_bug_on(sbi, err);
 			}
 
 			/* Check the previous node page having this index */
@@ -474,7 +474,7 @@ int recover_fsync_data(struct f2fs_sb_info *sbi)
 	/* step #2: recover data */
 	err = recover_data(sbi, &inode_list, CURSEG_WARM_NODE);
 	if (!err)
-		f2fs_bug_on(!list_empty(&inode_list));
+		f2fs_bug_on(sbi, !list_empty(&inode_list));
 out:
 	destroy_fsync_dnodes(&inode_list);
 	kmem_cache_destroy(fsync_entry_slab);
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a270726..abfbbca 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -516,7 +516,7 @@ static void update_sit_entry(struct f2fs_sb_info *sbi, block_t blkaddr, int del)
 	new_vblocks = se->valid_blocks + del;
 	offset = GET_BLKOFF_FROM_SEG0(sbi, blkaddr);
 
-	f2fs_bug_on((new_vblocks >> (sizeof(unsigned short) << 3) ||
+	f2fs_bug_on(sbi, (new_vblocks >> (sizeof(unsigned short) << 3) ||
 				(new_vblocks > sbi->blocks_per_seg)));
 
 	se->valid_blocks = new_vblocks;
@@ -558,7 +558,7 @@ void invalidate_blocks(struct f2fs_sb_info *sbi, block_t addr)
 	unsigned int segno = GET_SEGNO(sbi, addr);
 	struct sit_info *sit_i = SIT_I(sbi);
 
-	f2fs_bug_on(addr == NULL_ADDR);
+	f2fs_bug_on(sbi, addr == NULL_ADDR);
 	if (addr == NEW_ADDR)
 		return;
 
@@ -671,7 +671,7 @@ find_other_zone:
 		if (dir == ALLOC_RIGHT) {
 			secno = find_next_zero_bit(free_i->free_secmap,
 							TOTAL_SECS(sbi), 0);
-			f2fs_bug_on(secno >= TOTAL_SECS(sbi));
+			f2fs_bug_on(sbi, secno >= TOTAL_SECS(sbi));
 		} else {
 			go_left = 1;
 			left_start = hint - 1;
@@ -687,7 +687,7 @@ find_other_zone:
 		}
 		left_start = find_next_zero_bit(free_i->free_secmap,
 							TOTAL_SECS(sbi), 0);
-		f2fs_bug_on(left_start >= TOTAL_SECS(sbi));
+		f2fs_bug_on(sbi, left_start >= TOTAL_SECS(sbi));
 		break;
 	}
 	secno = left_start;
@@ -726,7 +726,7 @@ skip_left:
 	}
 got_it:
 	/* set it as dirty segment in free segmap */
-	f2fs_bug_on(test_bit(segno, free_i->free_segmap));
+	f2fs_bug_on(sbi, test_bit(segno, free_i->free_segmap));
 	__set_inuse(sbi, segno);
 	*newseg = segno;
 	write_unlock(&free_i->segmap_lock);
@@ -960,7 +960,8 @@ static int __get_segment_type(struct page *page, enum page_type p_type)
 		return __get_segment_type_4(page, p_type);
 	}
 	/* NR_CURSEG_TYPE(6) logs by default */
-	f2fs_bug_on(F2FS_P_SB(page)->active_logs != NR_CURSEG_TYPE);
+	f2fs_bug_on(F2FS_P_SB(page),
+		F2FS_P_SB(page)->active_logs != NR_CURSEG_TYPE);
 	return __get_segment_type_6(page, p_type);
 }
 
@@ -1044,7 +1045,7 @@ void write_data_page(struct page *page, struct dnode_of_data *dn,
 	struct f2fs_summary sum;
 	struct node_info ni;
 
-	f2fs_bug_on(dn->data_blkaddr == NULL_ADDR);
+	f2fs_bug_on(sbi, dn->data_blkaddr == NULL_ADDR);
 	get_node_info(sbi, dn->nid, &ni);
 	set_summary(&sum, dn->nid, dn->ofs_in_node, ni.version);
 
@@ -1424,7 +1425,7 @@ static struct page *get_next_sit_page(struct f2fs_sb_info *sbi,
 	/* get current sit block page without lock */
 	src_page = get_meta_page(sbi, src_off);
 	dst_page = grab_meta_page(sbi, dst_off);
-	f2fs_bug_on(PageDirty(src_page));
+	f2fs_bug_on(sbi, PageDirty(src_page));
 
 	src_addr = page_address(src_page);
 	dst_addr = page_address(dst_page);
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index d92a47d..deca872 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -373,7 +373,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
 			alloc_nid_failed(sbi, new_nid);
 			return PTR_ERR(xpage);
 		}
-		f2fs_bug_on(new_nid);
+		f2fs_bug_on(sbi, new_nid);
 		f2fs_wait_on_page_writeback(xpage, NODE);
 	} else {
 		struct dnode_of_data dn;
-- 
1.8.5.2 (Apple Git-48)

