Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbaLEAuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 19:50:05 -0500
Received: from mail.kernel.org ([198.145.19.201]:44904 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933358AbaLEAuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 19:50:01 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 2/3] f2fs: use rw_semaphore for nat entry lock
Date: Thu,  4 Dec 2014 16:49:42 -0800
Message-Id: <1417740583-1681-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1417740583-1681-1-git-send-email-jaegeuk@kernel.org>
References: <1417740583-1681-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previoulsy, we used rwlock for nat_entry lock.
But, now we have a lot of complex operations in set_node_addr.
(e.g., allocating kernel memories, handling radix_trees, and so on)

So, this patches tries to change spinlock to rw_semaphore to give CPUs to other
threads.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h |  2 +-
 fs/f2fs/node.c | 52 ++++++++++++++++++++++++++--------------------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index d042813..c873140 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -332,7 +332,7 @@ struct f2fs_nm_info {
 	/* NAT cache management */
 	struct radix_tree_root nat_root;/* root of the nat entry cache */
 	struct radix_tree_root nat_set_root;/* root of the nat set cache */
-	rwlock_t nat_tree_lock;		/* protect nat_tree_lock */
+	struct rw_semaphore nat_tree_lock;	/* protect nat_tree_lock */
 	struct list_head nat_entries;	/* cached nat entry list (clean) */
 	unsigned int nat_cnt;		/* the # of cached nat entries */
 	unsigned int dirty_nat_cnt;	/* total num of nat entries in set */
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c59341d..b47555f 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -196,11 +196,11 @@ bool is_checkpointed_node(struct f2fs_sb_info *sbi, nid_t nid)
 	struct nat_entry *e;
 	bool is_cp = true;
 
-	read_lock(&nm_i->nat_tree_lock);
+	down_read(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, nid);
 	if (e && !get_nat_flag(e, IS_CHECKPOINTED))
 		is_cp = false;
-	read_unlock(&nm_i->nat_tree_lock);
+	up_read(&nm_i->nat_tree_lock);
 	return is_cp;
 }
 
@@ -210,11 +210,11 @@ bool has_fsynced_inode(struct f2fs_sb_info *sbi, nid_t ino)
 	struct nat_entry *e;
 	bool fsynced = false;
 
-	read_lock(&nm_i->nat_tree_lock);
+	down_read(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, ino);
 	if (e && get_nat_flag(e, HAS_FSYNCED_INODE))
 		fsynced = true;
-	read_unlock(&nm_i->nat_tree_lock);
+	up_read(&nm_i->nat_tree_lock);
 	return fsynced;
 }
 
@@ -224,13 +224,13 @@ bool need_inode_block_update(struct f2fs_sb_info *sbi, nid_t ino)
 	struct nat_entry *e;
 	bool need_update = true;
 
-	read_lock(&nm_i->nat_tree_lock);
+	down_read(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, ino);
 	if (e && get_nat_flag(e, HAS_LAST_FSYNC) &&
 			(get_nat_flag(e, IS_CHECKPOINTED) ||
 			 get_nat_flag(e, HAS_FSYNCED_INODE)))
 		need_update = false;
-	read_unlock(&nm_i->nat_tree_lock);
+	up_read(&nm_i->nat_tree_lock);
 	return need_update;
 }
 
@@ -258,17 +258,17 @@ static void cache_nat_entry(struct f2fs_nm_info *nm_i, nid_t nid,
 {
 	struct nat_entry *e;
 retry:
-	write_lock(&nm_i->nat_tree_lock);
+	down_write(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, nid);
 	if (!e) {
 		e = grab_nat_entry(nm_i, nid);
 		if (!e) {
-			write_unlock(&nm_i->nat_tree_lock);
+			up_write(&nm_i->nat_tree_lock);
 			goto retry;
 		}
 		node_info_from_raw_nat(&e->ni, ne);
 	}
-	write_unlock(&nm_i->nat_tree_lock);
+	up_write(&nm_i->nat_tree_lock);
 }
 
 static void set_node_addr(struct f2fs_sb_info *sbi, struct node_info *ni,
@@ -277,12 +277,12 @@ static void set_node_addr(struct f2fs_sb_info *sbi, struct node_info *ni,
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct nat_entry *e;
 retry:
-	write_lock(&nm_i->nat_tree_lock);
+	down_write(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, ni->nid);
 	if (!e) {
 		e = grab_nat_entry(nm_i, ni->nid);
 		if (!e) {
-			write_unlock(&nm_i->nat_tree_lock);
+			up_write(&nm_i->nat_tree_lock);
 			goto retry;
 		}
 		e->ni = *ni;
@@ -326,7 +326,7 @@ retry:
 			set_nat_flag(e, HAS_FSYNCED_INODE, true);
 		set_nat_flag(e, HAS_LAST_FSYNC, fsync_done);
 	}
-	write_unlock(&nm_i->nat_tree_lock);
+	up_write(&nm_i->nat_tree_lock);
 }
 
 int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
@@ -336,7 +336,7 @@ int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 	if (available_free_memory(sbi, NAT_ENTRIES))
 		return 0;
 
-	write_lock(&nm_i->nat_tree_lock);
+	down_write(&nm_i->nat_tree_lock);
 	while (nr_shrink && !list_empty(&nm_i->nat_entries)) {
 		struct nat_entry *ne;
 		ne = list_first_entry(&nm_i->nat_entries,
@@ -344,7 +344,7 @@ int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 		__del_from_nat_cache(nm_i, ne);
 		nr_shrink--;
 	}
-	write_unlock(&nm_i->nat_tree_lock);
+	up_write(&nm_i->nat_tree_lock);
 	return nr_shrink;
 }
 
@@ -367,14 +367,14 @@ void get_node_info(struct f2fs_sb_info *sbi, nid_t nid, struct node_info *ni)
 	ni->nid = nid;
 
 	/* Check nat cache */
-	read_lock(&nm_i->nat_tree_lock);
+	down_read(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, nid);
 	if (e) {
 		ni->ino = nat_get_ino(e);
 		ni->blk_addr = nat_get_blkaddr(e);
 		ni->version = nat_get_version(e);
 	}
-	read_unlock(&nm_i->nat_tree_lock);
+	up_read(&nm_i->nat_tree_lock);
 	if (e)
 		return;
 
@@ -1432,13 +1432,13 @@ static int add_free_nid(struct f2fs_sb_info *sbi, nid_t nid, bool build)
 
 	if (build) {
 		/* do not add allocated nids */
-		read_lock(&nm_i->nat_tree_lock);
+		down_read(&nm_i->nat_tree_lock);
 		ne = __lookup_nat_cache(nm_i, nid);
 		if (ne &&
 			(!get_nat_flag(ne, IS_CHECKPOINTED) ||
 				nat_get_blkaddr(ne) != NULL_ADDR))
 			allocated = true;
-		read_unlock(&nm_i->nat_tree_lock);
+		up_read(&nm_i->nat_tree_lock);
 		if (allocated)
 			return 0;
 	}
@@ -1827,20 +1827,20 @@ static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
 
 		raw_ne = nat_in_journal(sum, i);
 retry:
-		write_lock(&nm_i->nat_tree_lock);
+		down_write(&nm_i->nat_tree_lock);
 		ne = __lookup_nat_cache(nm_i, nid);
 		if (ne)
 			goto found;
 
 		ne = grab_nat_entry(nm_i, nid);
 		if (!ne) {
-			write_unlock(&nm_i->nat_tree_lock);
+			up_write(&nm_i->nat_tree_lock);
 			goto retry;
 		}
 		node_info_from_raw_nat(&ne->ni, &raw_ne);
 found:
 		__set_nat_cache_dirty(nm_i, ne);
-		write_unlock(&nm_i->nat_tree_lock);
+		up_write(&nm_i->nat_tree_lock);
 	}
 	update_nats_in_cursum(sum, -i);
 	mutex_unlock(&curseg->curseg_mutex);
@@ -1911,10 +1911,10 @@ static void __flush_nat_entry_set(struct f2fs_sb_info *sbi,
 		}
 		raw_nat_from_node_info(raw_ne, &ne->ni);
 
-		write_lock(&NM_I(sbi)->nat_tree_lock);
+		down_write(&NM_I(sbi)->nat_tree_lock);
 		nat_reset_flag(ne);
 		__clear_nat_cache_dirty(NM_I(sbi), ne);
-		write_unlock(&NM_I(sbi)->nat_tree_lock);
+		up_write(&NM_I(sbi)->nat_tree_lock);
 
 		if (nat_get_blkaddr(ne) == NULL_ADDR)
 			add_free_nid(sbi, nid, false);
@@ -2000,7 +2000,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 
 	mutex_init(&nm_i->build_lock);
 	spin_lock_init(&nm_i->free_nid_list_lock);
-	rwlock_init(&nm_i->nat_tree_lock);
+	init_rwsem(&nm_i->nat_tree_lock);
 
 	nm_i->next_scan_nid = le32_to_cpu(sbi->ckpt->next_free_nid);
 	nm_i->bitmap_size = __bitmap_size(sbi, NAT_BITMAP);
@@ -2056,7 +2056,7 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 	spin_unlock(&nm_i->free_nid_list_lock);
 
 	/* destroy nat cache */
-	write_lock(&nm_i->nat_tree_lock);
+	down_write(&nm_i->nat_tree_lock);
 	while ((found = __gang_lookup_nat_cache(nm_i,
 					nid, NATVEC_SIZE, natvec))) {
 		unsigned idx;
@@ -2065,7 +2065,7 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
 			__del_from_nat_cache(nm_i, natvec[idx]);
 	}
 	f2fs_bug_on(sbi, nm_i->nat_cnt);
-	write_unlock(&nm_i->nat_tree_lock);
+	up_write(&nm_i->nat_tree_lock);
 
 	kfree(nm_i->nat_bitmap);
 	sbi->nm_info = NULL;
-- 
2.1.1

