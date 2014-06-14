Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaFNLsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 07:48:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27667 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbaFNLsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 07:48:41 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-f6-539c36964bfb
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: refactor flush_nat_entries codes for reducing
 NAT writes
Date: Sat, 14 Jun 2014 19:47:48 +0800
Message-id: <001201cf87c6$92b9fad0$b82df070$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+HxaJHz6D4ZeTdRpuTPk+SxpP0vw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQd1pZnOCDRasNLV4sn4Ws8WlRe4W
	e/aeZLG4vGsOmwOLx6ZVnWweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK2PKux2sBRMSK2Zv
	ecncwLjar4uRk0NCwERi6/F3bBC2mMSFe+uBbC4OIYHpjBI7z11nBkkICfxglJi9lh/EZhNQ
	kVje8Z8JxBYBsg8tuswOYjMLZErca5oBVi8sEC2x78U+MJtFQFXiZu8ZsAW8ApYSb66uYYew
	BSV+TL7HAtGrJbF+53EmCFteYvOat8wQBylI7Dj7mhFil57E5ytvGCFqxCU2HrnFMoFRYBaS
	UbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgQH8jOpHYwrGywOMQpw
	MCrx8K6QnR0sxJpYVlyZe4hRgoNZSYT3jMGcYCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qt
	A4UE0hNLUrNTUwtSi2CyTBycUg2MGYwM4gpf10uuitNed3Bazym+jUHmqvb5227MLrjR/uHG
	8ss77W/qvFpQfXTfSxYJ3rqDspEJZiyreXk/pL47uzG1TPL/x9k/738r0fz22X0nw1SbQk6J
	kHniPonmzyZN5bVaKdXBsN/g94yTYT2JGic2GgcwLizZef/UZFuLm+Lz9wrcWtnBqsRSnJFo
	qMVcVJwIAEXHhZZgAgAA
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

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h |    2 +
 fs/f2fs/node.c |  254 ++++++++++++++++++++++++++++++++++++++------------------
 fs/f2fs/node.h |    7 ++
 3 files changed, 183 insertions(+), 80 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 58df97e..a55f67d 100644
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
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a0a1f25..a4d1d56 100644
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
@@ -1744,7 +1741,90 @@ skip:
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
+	struct nat_entry_set *nes;
+	nid_t start_nid = START_NID(ne->ni.nid);
+
+	list_for_each_entry(nes, head, set_list) {
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
@@ -1752,12 +1832,6 @@ static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)
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
@@ -1767,23 +1841,21 @@ static bool flush_nats_in_journal(struct f2fs_sb_info *sbi)
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
@@ -1794,80 +1866,87 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
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
@@ -1896,6 +1975,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
 	INIT_RADIX_TREE(&nm_i->nat_root, GFP_ATOMIC);
 	INIT_LIST_HEAD(&nm_i->nat_entries);
 	INIT_LIST_HEAD(&nm_i->dirty_nat_entries);
+	INIT_LIST_HEAD(&nm_i->nat_entry_set);
 
 	mutex_init(&nm_i->build_lock);
 	spin_lock_init(&nm_i->free_nid_list_lock);
@@ -1992,3 +2072,17 @@ void destroy_node_manager_caches(void)
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
-- 
1.7.9.5


