Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaLFTzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 14:55:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:37293 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbaLFTzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 14:55:44 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/5] f2fs: do retry operations with cond_resched
Date: Sat,  6 Dec 2014 11:55:35 -0800
Message-Id: <1417895739-15251-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch revists retrial paths in f2fs.
The basic idea is to use cond_resched instead of retrying from the very early
stage.

Suggested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h    |  7 +++++++
 fs/f2fs/gc.c      |  5 ++---
 fs/f2fs/node.c    | 41 +++++++++--------------------------------
 fs/f2fs/segment.c |  5 ++---
 4 files changed, 20 insertions(+), 38 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index c873140..c787fe3 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1021,6 +1021,13 @@ retry:
 	return entry;
 }
 
+static inline void f2fs_radix_tree_insert(struct radix_tree_root *root,
+				unsigned long index, void *item)
+{
+	while (radix_tree_insert(root, index, item))
+		cond_resched();
+}
+
 #define RAW_IS_INODE(p)	((p)->footer.nid == (p)->footer.ino)
 
 static inline bool IS_INODE(struct page *page)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 2c58c58..eec0933 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -356,12 +356,11 @@ static void add_gc_inode(struct gc_inode_list *gc_list, struct inode *inode)
 		iput(inode);
 		return;
 	}
-retry:
 	new_ie = f2fs_kmem_cache_alloc(winode_slab, GFP_NOFS);
 	new_ie->inode = inode;
-
+retry:
 	if (radix_tree_insert(&gc_list->iroot, inode->i_ino, new_ie)) {
-		kmem_cache_free(winode_slab, new_ie);
+		cond_resched();
 		goto retry;
 	}
 	list_add_tail(&new_ie->list, &gc_list->ilist);
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 8de4f55..f83326c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -147,7 +147,7 @@ static void __set_nat_cache_dirty(struct f2fs_nm_info *nm_i,
 
 	if (get_nat_flag(ne, IS_DIRTY))
 		return;
-retry:
+
 	head = radix_tree_lookup(&nm_i->nat_set_root, set);
 	if (!head) {
 		head = f2fs_kmem_cache_alloc(nat_entry_set_slab, GFP_ATOMIC);
@@ -156,11 +156,7 @@ retry:
 		INIT_LIST_HEAD(&head->set_list);
 		head->set = set;
 		head->entry_cnt = 0;
-
-		if (radix_tree_insert(&nm_i->nat_set_root, set, head)) {
-			kmem_cache_free(nat_entry_set_slab, head);
-			goto retry;
-		}
+		f2fs_radix_tree_insert(&nm_i->nat_set_root, set, head);
 	}
 	list_move_tail(&ne->list, &head->entry_list);
 	nm_i->dirty_nat_cnt++;
@@ -238,13 +234,8 @@ static struct nat_entry *grab_nat_entry(struct f2fs_nm_info *nm_i, nid_t nid)
 {
 	struct nat_entry *new;
 
-	new = kmem_cache_alloc(nat_entry_slab, GFP_ATOMIC);
-	if (!new)
-		return NULL;
-	if (radix_tree_insert(&nm_i->nat_root, nid, new)) {
-		kmem_cache_free(nat_entry_slab, new);
-		return NULL;
-	}
+	new = f2fs_kmem_cache_alloc(nat_entry_slab, GFP_ATOMIC);
+	f2fs_radix_tree_insert(&nm_i->nat_root, nid, new);
 	memset(new, 0, sizeof(struct nat_entry));
 	nat_set_nid(new, nid);
 	nat_reset_flag(new);
@@ -257,15 +248,11 @@ static void cache_nat_entry(struct f2fs_nm_info *nm_i, nid_t nid,
 						struct f2fs_nat_entry *ne)
 {
 	struct nat_entry *e;
-retry:
+
 	down_write(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, nid);
 	if (!e) {
 		e = grab_nat_entry(nm_i, nid);
-		if (!e) {
-			up_write(&nm_i->nat_tree_lock);
-			goto retry;
-		}
 		node_info_from_raw_nat(&e->ni, ne);
 	}
 	up_write(&nm_i->nat_tree_lock);
@@ -276,15 +263,11 @@ static void set_node_addr(struct f2fs_sb_info *sbi, struct node_info *ni,
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct nat_entry *e;
-retry:
+
 	down_write(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, ni->nid);
 	if (!e) {
 		e = grab_nat_entry(nm_i, ni->nid);
-		if (!e) {
-			up_write(&nm_i->nat_tree_lock);
-			goto retry;
-		}
 		e->ni = *ni;
 		f2fs_bug_on(sbi, ni->blk_addr == NEW_ADDR);
 	} else if (new_blkaddr == NEW_ADDR) {
@@ -1833,19 +1816,13 @@ static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
 		nid_t nid = le32_to_cpu(nid_in_journal(sum, i));
 
 		raw_ne = nat_in_journal(sum, i);
-retry:
+
 		down_write(&nm_i->nat_tree_lock);
 		ne = __lookup_nat_cache(nm_i, nid);
-		if (ne)
-			goto found;
-
-		ne = grab_nat_entry(nm_i, nid);
 		if (!ne) {
-			up_write(&nm_i->nat_tree_lock);
-			goto retry;
+			ne = grab_nat_entry(nm_i, nid);
+			node_info_from_raw_nat(&ne->ni, &raw_ne);
 		}
-		node_info_from_raw_nat(&ne->ni, &raw_ne);
-found:
 		__set_nat_cache_dirty(nm_i, ne);
 		up_write(&nm_i->nat_tree_lock);
 	}
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 9a33e34..c79d67e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -179,13 +179,13 @@ void register_inmem_page(struct inode *inode, struct page *page)
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct inmem_pages *new;
 	int err;
-retry:
+
 	new = f2fs_kmem_cache_alloc(inmem_entry_slab, GFP_NOFS);
 
 	/* add atomic page indices to the list */
 	new->page = page;
 	INIT_LIST_HEAD(&new->list);
-
+retry:
 	/* increase reference count with clean state */
 	mutex_lock(&fi->inmem_lock);
 	err = radix_tree_insert(&fi->inmem_root, page->index, new);
@@ -195,7 +195,6 @@ retry:
 		return;
 	} else if (err) {
 		mutex_unlock(&fi->inmem_lock);
-		kmem_cache_free(inmem_entry_slab, new);
 		goto retry;
 	}
 	get_page(page);
-- 
2.1.1

