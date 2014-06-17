Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbaFQDYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 23:24:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10346 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbaFQDY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 23:24:29 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-3e-539fb4eaf252
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH v2] f2fs: refactor flush_nat_entries codes for
 reducing NAT writes
Date: Tue, 17 Jun 2014 11:23:22 +0800
Message-id: <002401cf89db$a25c8810$e7159830$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+J2u+T6Rt9sdWbRpK0nccUAcDpVw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jAd1XW+YHGyycoWfxZP0sZotLi9wt
	9uw9yWJxedccNgcWj02rOtk8di/4zOTxeZNcAHMUl01Kak5mWWqRvl0CV0bP9OWMBYtzK25t
	28rewHgioouRk0NCwERi8oLtzBC2mMSFe+vZuhi5OIQEFjFK/O1pZYRwfjBKbNjRxgJSxSag
	IrG84z8TiC0CZB9adJkdxGYWyJS41zQDbJKwQJzEl7NvwWwWAVWJGWumM4LYvAKWEi3/rrBB
	2IISPybfY4Ho1ZJYv/M4E4QtL7F5zVuoixQkdpx9zQixS0+i5edqZogacYmNR26xTGAUmIVk
	1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGh/Ex6B+OqBotDjAIc
	jEo8vA9k5wcLsSaWFVfmHmKU4GBWEuHlMgcK8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0o
	JJCeWJKanZpakFoEk2Xi4JRqYAziPyAbZjQ/2zbdssVkqmeHzz1901vX9Q6FZ65e2z5nTtRZ
	3lu/Dsi2JE/49L1ikoLGpkmK6vYXPT/0H7y+rbyRXd645W1bvqy1/RKj79utTK/d67e8/Opb
	fdjuk8J7Dm2+1KEb1BUo7ffq8L6tjHNYzv7kl/7Xl/JznxrzS1WehFtmy43VzyuxFGckGmox
	FxUnAgB5IaFPYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although building NAT journal in cursum reduce the read/write work for NAT
block, but previous design leave us lower performance when write checkpoint
frequently for these cases:
1. if journal in cursum has already full, it's a bit of waste that we flush all
   nat entries to page for persistence, but not to cache any entries.
2. if journal in cursum is not full, we fill nat entries to journal util
   journal is full, then flush the left dirty entries to disk without merge
   journaled entries, so these journaled entries may be flushed to disk at next
   checkpoint but lost chance to flushed last time.

In this patch we merge dirty entries located in same NAT block to nat entry set,
and linked all set to list, sorted ascending order by entries' count of set.
Later we flush entries in sparse set into journal as many as we can, and then
flush merged entries to disk.

In my testing environment, it shows this patch can help to reduce NAT block
writes.

1. virtual machine + hard disk:
fsstress -p 20 -n 200 -l 5
		node num	cp count	nodes/cp
based		4599.6		1803.0		2.551
patched		2714.6		1829.6		1.483

2. virtual machine + 32g micro SD card:
fsstress -p 20 -n 200 -l 1 -w -f chown=0 -f creat=4 -f dwrite=0
-f fdatasync=4 -f fsync=4 -f link=0 -f mkdir=4 -f mknod=4 -f rename=5
-f rmdir=5 -f symlink=0 -f truncate=4 -f unlink=5 -f write=0 -S

		node num	cp count	nodes/cp
based		84.5		43.7		1.933
patched		49.2		40.0		1.23

change log from v1:
 o use list_for_each_entry_safe in add_nat_entry() to avoid potential deadloop.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h  |    4 +
 fs/f2fs/node.c  |  254 +++++++++++++++++++++++++++++++++++++------------------
 fs/f2fs/node.h  |    7 ++
 fs/f2fs/super.c |    8 +-
 4 files changed, 192 insertions(+), 81 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 58df97e..4d717dc 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -256,6 +256,8 @@ struct f2fs_nm_info {
 	unsigned int nat_cnt;		/* the # of cached nat entries */
 	struct list_head nat_entries;	/* cached nat entry list (clean) */
 	struct list_head dirty_nat_entries; /* cached nat entry list (dirty) */
+	struct list_head nat_entry_set;	/* nat entry set list */
+	unsigned int dirty_nat_cnt;	/* total num of nat entries in set */
 
 	/* free node ids management */
 	struct radix_tree_root free_nid_root;/* root of the free_nid cache */
@@ -1194,6 +1196,8 @@ int build_node_manager(struct f2fs_sb_info *);
 void destroy_node_manager(struct f2fs_sb_info *);
 int __init create_node_manager_caches(void);
 void destroy_node_manager_caches(void);
+int __init create_nat_set_caches(void);
+void destroy_nat_set_caches(void);
 
 /*
  * segment.c
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 9dfb9a0..347c0c1 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -25,6 +25,7 @@
 
 static struct kmem_cache *nat_entry_slab;
 static struct kmem_cache *free_nid_slab;
+static struct kmem_cache *nat_entry_set_slab;
 
 bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 {
@@ -88,12 +89,8 @@ static struct page *get_next_nat_page(struct f2fs_sb_info *sbi, nid_t nid)
 
 	/* get current nat block page with lock */
 	src_page = get_meta_page(sbi, src_off);
-
-	/* Dirty src_page means that it is already the new target NAT page. */
-	if (PageDirty(src_page))
-		return src_page;
-
 	dst_page = grab_meta_page(sbi, dst_off);
+	f2fs_bug_on(PageDirty(src_page));
 
 	src_addr = page_address(src_page);
 	dst_addr = page_address(dst_page);
@@ -1742,7 +1739,90 @@ skip:
 	return err;
 }
 
-static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)
+static struct nat_entry_set *grab_nat_entry_set(void)
+{
+	struct nat_entry_set *nes =
+			f2fs_kmem_cache_alloc(nat_entry_set_slab, GFP_NOFS);
+
+	nes->entry_cnt = 0;
+	INIT_LIST_HEAD(&nes->set_list);
+	INIT_LIST_HEAD(&nes->entry_list);
+	return nes;
+}
+
+static void release_nat_entry_set(struct nat_entry_set *nes,
+						struct f2fs_nm_info *nm_i)
+{
+	f2fs_bug_on(!list_empty(nes->entry_list));
+
+	nm_i->dirty_nat_cnt -= nes->entry_cnt;
+	list_del(&nes->set_list);
+	kmem_cache_free(nat_entry_set_slab, nes);
+}
+
+static void adjust_nat_entry_set(struct nat_entry_set *nes,
+						struct list_head *head)
+{
+	struct nat_entry_set *next = nes;
+
+	if (list_is_last(&nes->set_list, head))
+		return;
+
+	list_for_each_entry_continue(next, head, set_list)
+		if (nes->entry_cnt <= next->entry_cnt)
+			break;
+
+	list_move_tail(&nes->set_list, &next->set_list);
+}
+
+static void add_nat_entry(struct nat_entry *ne, struct list_head *head)
+{
+	struct nat_entry_set *nes, *tmp;
+	nid_t start_nid = START_NID(ne->ni.nid);
+
+	list_for_each_entry_safe(nes, tmp, head, set_list) {
+		if (nes->start_nid == start_nid) {
+			list_move_tail(&ne->list, &nes->entry_list);
+			nes->entry_cnt++;
+			adjust_nat_entry_set(nes, head);
+			return;
+		}
+	}
+
+	nes = grab_nat_entry_set();
+
+	nes->start_nid = START_NID(ne->ni.nid);
+	list_move_tail(&ne->list, &nes->entry_list);
+	nes->entry_cnt++;
+	list_add_tail(&nes->set_list, head);
+}
+
+static void merge_nats_in_set(struct f2fs_sb_info *sbi)
+{
+	struct f2fs_nm_info *nm_i = NM_I(sbi);
+	struct list_head *dirty_list = &nm_i->dirty_nat_entries;
+	struct list_head *set_list = &nm_i->nat_entry_set;
+	struct nat_entry *ne, *tmp;
+
+	write_lock(&nm_i->nat_tree_lock);
+	list_for_each_entry_safe(ne, tmp, dirty_list, list) {
+		if (nat_get_blkaddr(ne) == NEW_ADDR)
+			continue;
+		add_nat_entry(ne, set_list);
+		nm_i->dirty_nat_cnt++;
+	}
+	write_unlock(&nm_i->nat_tree_lock);
+}
+
+static bool __has_cursum_space(struct f2fs_summary_block *sum, int size)
+{
+	if (nats_in_cursum(sum) + size <= NAT_JOURNAL_ENTRIES)
+		return true;
+	else
+		return false;
+}
+
+static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
@@ -1750,12 +1830,6 @@ static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)
 	int i;
 
 	mutex_lock(&curseg->curseg_mutex);
-
-	if (nats_in_cursum(sum) < NAT_JOURNAL_ENTRIES) {
-		mutex_unlock(&curseg->curseg_mutex);
-		return false;
-	}
-
 	for (i = 0; i < nats_in_cursum(sum); i++) {
 		struct nat_entry *ne;
 		struct f2fs_nat_entry raw_ne;
@@ -1765,23 +1839,21 @@ static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)
 retry:
 		write_lock(&nm_i->nat_tree_lock);
 		ne = __lookup_nat_cache(nm_i, nid);
-		if (ne) {
-			__set_nat_cache_dirty(nm_i, ne);
-			write_unlock(&nm_i->nat_tree_lock);
-			continue;
-		}
+		if (ne)
+			goto found;
+
 		ne = grab_nat_entry(nm_i, nid);
 		if (!ne) {
 			write_unlock(&nm_i->nat_tree_lock);
 			goto retry;
 		}
 		node_info_from_raw_nat(&ne->ni, &raw_ne);
+found:
 		__set_nat_cache_dirty(nm_i, ne);
 		write_unlock(&nm_i->nat_tree_lock);
 	}
 	update_nats_in_cursum(sum, -i);
 	mutex_unlock(&curseg->curseg_mutex);
-	return true;
 }
 
 /*
@@ -1792,80 +1864,87 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_HOT_DATA);
 	struct f2fs_summary_block *sum = curseg->sum_blk;
-	struct nat_entry *ne, *cur;
-	struct page *page = NULL;
-	struct f2fs_nat_block *nat_blk = NULL;
-	nid_t start_nid = 0, end_nid = 0;
-	bool flushed;
-
-	flushed = flush_nats_in_journal(sbi);
-
-	if (!flushed)
-		mutex_lock(&curseg->curseg_mutex);
-
-	/* 1) flush dirty nat caches */
-	list_for_each_entry_safe(ne, cur, &nm_i->dirty_nat_entries, list) {
-		nid_t nid;
-		struct f2fs_nat_entry raw_ne;
-		int offset = -1;
-
-		if (nat_get_blkaddr(ne) == NEW_ADDR)
-			continue;
+	struct nat_entry_set *nes, *tmp;
+	struct list_head *head = &nm_i->nat_entry_set;
+	bool to_journal = true;
 
-		nid = nat_get_nid(ne);
+	/* merge nat entries of dirty list to nat entry set temporarily */
+	merge_nats_in_set(sbi);
 
-		if (flushed)
-			goto to_nat_page;
+	if (!__has_cursum_space(sum, nm_i->dirty_nat_cnt)) {
+		/*
+		 * if there are no enough space in journal to store dirty nat
+		 * entries, remove all entries from journal and merge them
+		 * into nat entry set.
+		 */
+		remove_nats_in_journal(sbi);
+		merge_nats_in_set(sbi);
+	}
 
-		/* if there is room for nat enries in curseg->sumpage */
-		offset = lookup_journal_in_cursum(sum, NAT_JOURNAL, nid, 1);
-		if (offset >= 0) {
-			raw_ne = nat_in_journal(sum, offset);
-			goto flush_now;
-		}
-to_nat_page:
-		if (!page || (start_nid > nid || nid > end_nid)) {
-			if (page) {
-				f2fs_put_page(page, 1);
-				page = NULL;
-			}
-			start_nid = START_NID(nid);
-			end_nid = start_nid + NAT_ENTRY_PER_BLOCK - 1;
+	if (!nm_i->dirty_nat_cnt)
+		return;
 
-			/*
-			 * get nat block with dirty flag, increased reference
-			 * count, mapped and lock
-			 */
+	/*
+	 * there are two steps to flush nat entries:
+	 * #1, flush nat entries to journal in current hot data summary block.
+	 * #2, flush nat entries to nat page.
+	 */
+	list_for_each_entry_safe(nes, tmp, head, set_list) {
+		struct f2fs_nat_block *nat_blk;
+		struct nat_entry *ne, *cur;
+		struct page *page;
+		nid_t start_nid = nes->start_nid;
+
+		if (to_journal && !__has_cursum_space(sum, nes->entry_cnt))
+			to_journal = false;
+
+		if (to_journal) {
+			mutex_lock(&curseg->curseg_mutex);
+		} else {
 			page = get_next_nat_page(sbi, start_nid);
 			nat_blk = page_address(page);
+			f2fs_bug_on(!nat_blk);
 		}
 
-		f2fs_bug_on(!nat_blk);
-		raw_ne = nat_blk->entries[nid - start_nid];
-flush_now:
-		raw_nat_from_node_info(&raw_ne, &ne->ni);
-
-		if (offset < 0) {
-			nat_blk->entries[nid - start_nid] = raw_ne;
-		} else {
-			nat_in_journal(sum, offset) = raw_ne;
-			nid_in_journal(sum, offset) = cpu_to_le32(nid);
-		}
+		/* flush dirty nats in nat entry set */
+		list_for_each_entry_safe(ne, cur, &nes->entry_list, list) {
+			struct f2fs_nat_entry *raw_ne;
+			nid_t nid = nat_get_nid(ne);
+			int offset;
+
+			if (to_journal) {
+				offset = lookup_journal_in_cursum(sum,
+							NAT_JOURNAL, nid, 1);
+				f2fs_bug_on(offset < 0);
+				raw_ne = &nat_in_journal(sum, offset);
+				nid_in_journal(sum, offset) = cpu_to_le32(nid);
+			} else {
+				raw_ne = &nat_blk->entries[nid - start_nid];
+			}
+			raw_nat_from_node_info(raw_ne, &ne->ni);
 
-		if (nat_get_blkaddr(ne) == NULL_ADDR &&
+			if (nat_get_blkaddr(ne) == NULL_ADDR &&
 				add_free_nid(sbi, nid, false) <= 0) {
-			write_lock(&nm_i->nat_tree_lock);
-			__del_from_nat_cache(nm_i, ne);
-			write_unlock(&nm_i->nat_tree_lock);
-		} else {
-			write_lock(&nm_i->nat_tree_lock);
-			__clear_nat_cache_dirty(nm_i, ne);
-			write_unlock(&nm_i->nat_tree_lock);
+				write_lock(&nm_i->nat_tree_lock);
+				__del_from_nat_cache(nm_i, ne);
+				write_unlock(&nm_i->nat_tree_lock);
+			} else {
+				write_lock(&nm_i->nat_tree_lock);
+				__clear_nat_cache_dirty(nm_i, ne);
+				write_unlock(&nm_i->nat_tree_lock);
+			}
 		}
+
+		if (to_journal)
+			mutex_unlock(&curseg->curseg_mutex);
+		else
+			f2fs_put_page(page, 1);
+
+		release_nat_entry_set(nes, nm_i);
 	}
-	if (!flushed)
-		mutex_unlock(&curseg->curseg_mutex);
-	f2fs_put_page(page, 1);
+
+	f2fs_bug_on(!list_empty(head));
+	f2fs_bug_on(nm_i->dirty_nat_cnt);
 }
 
 static int init_node_manager(struct f2fs_sb_info *sbi)
@@ -1894,6 +1973,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	INIT_RADIX_TREE(&nm_i->nat_root, GFP_ATOMIC);
 	INIT_LIST_HEAD(&nm_i->nat_entries);
 	INIT_LIST_HEAD(&nm_i->dirty_nat_entries);
+	INIT_LIST_HEAD(&nm_i->nat_entry_set);
 
 	mutex_init(&nm_i->build_lock);
 	spin_lock_init(&nm_i->free_nid_list_lock);
@@ -1990,3 +2070,17 @@ void destroy_node_manager_caches(void)
 	kmem_cache_destroy(free_nid_slab);
 	kmem_cache_destroy(nat_entry_slab);
 }
+
+int __init create_nat_set_caches(void)
+{
+	nat_entry_set_slab = f2fs_kmem_cache_create("f2fs_nat_entry_set",
+					sizeof(struct nat_entry_set));
+	if (!nat_entry_set_slab)
+		return -ENOMEM;
+	return 0;
+}
+
+void destroy_nat_set_caches(void)
+{
+	kmem_cache_destroy(nat_entry_set_slab);
+}
diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index 7281112..8a116a4 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -89,6 +89,13 @@ enum mem_type {
 	DIRTY_DENTS	/* indicates dirty dentry pages */
 };
 
+struct nat_entry_set {
+	struct list_head set_list;	/* link with all nat sets */
+	struct list_head entry_list;	/* link with dirty nat entries */
+	nid_t start_nid;		/* start nid of nats in set */
+	unsigned int entry_cnt;		/* the # of nat entries in set */
+};
+
 /*
  * For free nid mangement
  */
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 8f96d93..c2ab776 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1172,10 +1172,13 @@ static int __init init_f2fs_fs(void)
 	err = create_checkpoint_caches();
 	if (err)
 		goto free_gc_caches;
+	err = create_nat_set_caches();
+	if (err)
+		goto free_checkpoint_caches;
 	f2fs_kset = kset_create_and_add("f2fs", NULL, fs_kobj);
 	if (!f2fs_kset) {
 		err = -ENOMEM;
-		goto free_checkpoint_caches;
+		goto free_nat_set_caches;
 	}
 	err = register_filesystem(&f2fs_fs_type);
 	if (err)
@@ -1186,6 +1189,8 @@ static int __init init_f2fs_fs(void)
 
 free_kset:
 	kset_unregister(f2fs_kset);
+free_nat_set_caches:
+	destroy_nat_set_caches();
 free_checkpoint_caches:
 	destroy_checkpoint_caches();
 free_gc_caches:
@@ -1205,6 +1210,7 @@ static void __exit exit_f2fs_fs(void)
 	remove_proc_entry("fs/f2fs", NULL);
 	f2fs_destroy_root_stats();
 	unregister_filesystem(&f2fs_fs_type);
+	destroy_nat_set_caches();
 	destroy_checkpoint_caches();
 	destroy_gc_caches();
 	destroy_segment_manager_caches();
-- 
1.7.9.5


