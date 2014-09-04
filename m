Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbaIDKNs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:13:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63769 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbaIDKNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:13:46 -0400
X-AuditID: cbfee61b-f79f86d00000144c-70-54083b581566
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/2] f2fs: refactor flush_sit_entries codes for
 reducing SIT writes
Date: Thu, 04 Sep 2014 18:13:01 +0800
Message-id: <006a01cfc828$e736f7a0$b5a4e6e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac/IFa06Vxsy4XqITKyHpU8+SX/ibQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQd0Ia44Qg2sblCyerJ/FbHFpkbvF
	5V1z2ByYPTat6mTz2L3gM5PH501yAcxRXDYpqTmZZalF+nYJXBlnFs1nKniTU7GjrY29gbEp
	oouRk0NCwERi7eRV7BC2mMSFe+vZuhi5OIQEpjNK9Cy+CuX8YJSYsKEBrIpNQEViecd/JhBb
	BMg+tOgyWJxZwEOiseM7K4gtLBAvceLiLTCbRUBV4vm+Z2D1vAKWEnN7PrNA2IISPybfY4Ho
	1ZJYv/M4E4QtL7F5zVtmiIsUJHacfc0IsUtPYvG2u1C7xCU2HrnFMoFRYBaSUbOQjJqFZNQs
	JC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQH8DPpHYyrGiwOMQpwMCrx8Ba8YA8R
	Yk0sK67MPcQowcGsJMK70JIjRIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbrQCGB9MSS1OzU
	1ILUIpgsEwenVAOjlMBUk3m2ClKBH4+65axetNbi1407a/6arBQqLOeXX9bOtGpvvdiW1Lva
	l+P4Y2+KBd/OfGYYzs91IHfqhmijW8fZeiYcWuf29njAq2+HbK/Okr6/52xW7wpmn1vfdj8R
	rzAXCP2/9WQ4p0Xw1fJZ0scY3v9/cnzuJAmPrpSNuxe8eWQZEC6WocRSnJFoqMVcVJwIAD0n
	5eRcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit aec71382c681 ("f2fs: refactor flush_nat_entries codes for reducing NAT
writes"), we descripte the issue as below:

"Although building NAT journal in cursum reduce the read/write work for NAT
block, but previous design leave us lower performance when write checkpoint
frequently for these cases:
1. if journal in cursum has already full, it's a bit of waste that we flush all
   nat entries to page for persistence, but not to cache any entries.
2. if journal in cursum is not full, we fill nat entries to journal util
   journal is full, then flush the left dirty entries to disk without merge
   journaled entries, so these journaled entries may be flushed to disk at next
   checkpoint but lost chance to flushed last time."

Actually, we have the same problem in using SIT journal area.

In this patch, firstly we will update sit journal with dirty entries as many as
possible. Secondly if there is no space in sit journal, we will remove all
entries in journal and walk through the whole dirty entry bitmap of sit,
accounting dirty sit entries located in same SIT block to sit entry set. All
entry sets are linked to list sit_entry_set in sm_info, sorted ascending order
by count of entries in set. Later we flush entries in set which have fewest
entries into journal as many as we can, and then flush dense set with merged
entries to disk.

In this way we can use sit journal area more effectively, also we will reduce
SIT update, result in gaining in performance and saving lifetime of flash
device.

In my testing environment, it shows this patch can help to reduce SIT block
update obviously.

virtual machine + hard disk:
fsstress -p 20 -n 400 -l 5
		sit page num	cp count	sit pages/cp
based		2006.50		1349.75		1.486
patched		1566.25		1463.25		1.070

Our latency of merging op is small when handling a great number of dirty SIT
entries in flush_sit_entries:
latency(ns)	dirty sit count
36038		2151
49168		2123
37174		2232

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/f2fs.h    |  11 +++
 fs/f2fs/node.c    |  13 +---
 fs/f2fs/segment.c | 227 +++++++++++++++++++++++++++++++++++++++---------------
 fs/f2fs/segment.h |   6 ++
 4 files changed, 186 insertions(+), 71 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b389ced..dd7b171 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -161,6 +161,15 @@ static inline int update_sits_in_cursum(struct f2fs_summary_block *rs, int i)
 	return before;
 }
 
+static inline bool __has_cursum_space(struct f2fs_summary_block *sum, int size,
+								int type)
+{
+	if (type == NAT_JOURNAL)
+		return nats_in_cursum(sum) + size <= NAT_JOURNAL_ENTRIES;
+
+	return sits_in_cursum(sum) + size <= SIT_JOURNAL_ENTRIES;
+}
+
 /*
  * ioctl commands
  */
@@ -375,6 +384,8 @@ struct f2fs_sm_info {
 	int nr_discards;			/* # of discards in the list */
 	int max_discards;			/* max. discards to be issued */
 
+	struct list_head sit_entry_set;	/* sit entry set list */
+
 	unsigned int ipu_policy;	/* in-place-update policy */
 	unsigned int min_ipu_util;	/* in-place-update threshold */
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 1af7879..b32eb56 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1798,14 +1798,6 @@ static void merge_nats_in_set(struct f2fs_sb_info *sbi)
 	write_unlock(&nm_i->nat_tree_lock);
 }
 
-static bool __has_cursum_space(struct f2fs_summary_block *sum, int size)
-{
-	if (nats_in_cursum(sum) + size <= NAT_JOURNAL_ENTRIES)
-		return true;
-	else
-		return false;
-}
-
 static void remove_nats_in_journal(struct f2fs_sb_info *sbi)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
@@ -1860,7 +1852,7 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
 	 * entries, remove all entries from journal and merge them
 	 * into nat entry set.
 	 */
-	if (!__has_cursum_space(sum, nm_i->dirty_nat_cnt)) {
+	if (!__has_cursum_space(sum, nm_i->dirty_nat_cnt, NAT_JOURNAL)) {
 		remove_nats_in_journal(sbi);
 
 		/*
@@ -1883,7 +1875,8 @@ void flush_nat_entries(struct f2fs_sb_info *sbi)
 		struct page *page;
 		nid_t start_nid = nes->start_nid;
 
-		if (to_journal && !__has_cursum_space(sum, nes->entry_cnt))
+		if (to_journal &&
+			!__has_cursum_space(sum, nes->entry_cnt, NAT_JOURNAL))
 			to_journal = false;
 
 		if (to_journal) {
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index a6b90a5..d1ff225 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -25,6 +25,7 @@
 #define __reverse_ffz(x) __reverse_ffs(~(x))
 
 static struct kmem_cache *discard_entry_slab;
+static struct kmem_cache *sit_entry_set_slab;
 
 /*
  * __reverse_ffs is copied from include/asm-generic/bitops/__ffs.h since
@@ -492,11 +493,16 @@ void clear_prefree_segments(struct f2fs_sb_info *sbi)
 	}
 }
 
-static void __mark_sit_entry_dirty(struct f2fs_sb_info *sbi, unsigned int segno)
+static bool __mark_sit_entry_dirty(struct f2fs_sb_info *sbi, unsigned int segno)
 {
 	struct sit_info *sit_i = SIT_I(sbi);
-	if (!__test_and_set_bit(segno, sit_i->dirty_sentries_bitmap))
+
+	if (!__test_and_set_bit(segno, sit_i->dirty_sentries_bitmap)) {
 		sit_i->dirty_sentries++;
+		return false;
+	}
+
+	return true;
 }
 
 static void __set_sit_entry_type(struct f2fs_sb_info *sbi, int type,
@@ -1443,27 +1449,86 @@ static struct page *get_next_sit_page(struct f2fs_sb_info *sbi,
 	return dst_page;
 }
 
-static bool flush_sits_in_journal(struct f2fs_sb_info *sbi)
+static struct sit_entry_set *grab_sit_entry_set(void)
+{
+	struct sit_entry_set *ses =
+			f2fs_kmem_cache_alloc(sit_entry_set_slab, GFP_ATOMIC);
+
+	ses->entry_cnt = 0;
+	INIT_LIST_HEAD(&ses->set_list);
+	return ses;
+}
+
+static void release_sit_entry_set(struct sit_entry_set *ses)
+{
+	list_del(&ses->set_list);
+	kmem_cache_free(sit_entry_set_slab, ses);
+}
+
+static void adjust_sit_entry_set(struct sit_entry_set *ses,
+						struct list_head *head)
+{
+	struct sit_entry_set *next = ses;
+
+	if (list_is_last(&ses->set_list, head))
+		return;
+
+	list_for_each_entry_continue(next, head, set_list)
+		if (ses->entry_cnt <= next->entry_cnt)
+			break;
+
+	list_move_tail(&ses->set_list, &next->set_list);
+}
+
+static void add_sit_entry(unsigned int segno, struct list_head *head)
+{
+	struct sit_entry_set *ses;
+	unsigned int start_segno = START_SEGNO(segno);
+
+	list_for_each_entry(ses, head, set_list) {
+		if (ses->start_segno == start_segno) {
+			ses->entry_cnt++;
+			adjust_sit_entry_set(ses, head);
+			return;
+		}
+	}
+
+	ses = grab_sit_entry_set();
+
+	ses->start_segno = start_segno;
+	ses->entry_cnt++;
+	list_add(&ses->set_list, head);
+}
+
+static void add_sits_in_set(struct f2fs_sb_info *sbi)
+{
+	struct f2fs_sm_info *sm_info = SM_I(sbi);
+	struct list_head *set_list = &sm_info->sit_entry_set;
+	unsigned long *bitmap = SIT_I(sbi)->dirty_sentries_bitmap;
+	unsigned long nsegs = TOTAL_SEGS(sbi);
+	unsigned int segno;
+
+	for_each_set_bit(segno, bitmap, nsegs)
+		add_sit_entry(segno, set_list);
+}
+
+static void remove_sits_in_journal(struct f2fs_sb_info *sbi)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_COLD_DATA);
 	struct f2fs_summary_block *sum = curseg->sum_blk;
 	int i;
 
-	/*
-	 * If the journal area in the current summary is full of sit entries,
-	 * all the sit entries will be flushed. Otherwise the sit entries
-	 * are not able to replace with newly hot sit entries.
-	 */
-	if (sits_in_cursum(sum) >= SIT_JOURNAL_ENTRIES) {
-		for (i = sits_in_cursum(sum) - 1; i >= 0; i--) {
-			unsigned int segno;
-			segno = le32_to_cpu(segno_in_journal(sum, i));
-			__mark_sit_entry_dirty(sbi, segno);
-		}
-		update_sits_in_cursum(sum, -sits_in_cursum(sum));
-		return true;
+	for (i = sits_in_cursum(sum) - 1; i >= 0; i--) {
+		unsigned int segno;
+		bool dirtied;
+
+		segno = le32_to_cpu(segno_in_journal(sum, i));
+		dirtied = __mark_sit_entry_dirty(sbi, segno);
+
+		if (!dirtied)
+			add_sit_entry(segno, &SM_I(sbi)->sit_entry_set);
 	}
-	return false;
+	update_sits_in_cursum(sum, -sits_in_cursum(sum));
 }
 
 /*
@@ -1476,68 +1541,95 @@ void flush_sit_entries(struct f2fs_sb_info *sbi)
 	unsigned long *bitmap = sit_i->dirty_sentries_bitmap;
 	struct curseg_info *curseg = CURSEG_I(sbi, CURSEG_COLD_DATA);
 	struct f2fs_summary_block *sum = curseg->sum_blk;
+	struct sit_entry_set *ses, *tmp;
+	struct list_head *head = &SM_I(sbi)->sit_entry_set;
 	unsigned long nsegs = TOTAL_SEGS(sbi);
-	struct page *page = NULL;
-	struct f2fs_sit_block *raw_sit = NULL;
-	unsigned int start = 0, end = 0;
-	unsigned int segno;
-	bool flushed;
+	bool to_journal = true;
 
 	mutex_lock(&curseg->curseg_mutex);
 	mutex_lock(&sit_i->sentry_lock);
 
 	/*
-	 * "flushed" indicates whether sit entries in journal are flushed
-	 * to the SIT area or not.
+	 * add and account sit entries of dirty bitmap in sit entry
+	 * set temporarily
 	 */
-	flushed = flush_sits_in_journal(sbi);
-
-	for_each_set_bit(segno, bitmap, nsegs) {
-		struct seg_entry *se = get_seg_entry(sbi, segno);
-		int sit_offset, offset;
+	add_sits_in_set(sbi);
 
-		sit_offset = SIT_ENTRY_OFFSET(sit_i, segno);
-
-		/* add discard candidates */
-		if (SM_I(sbi)->nr_discards < SM_I(sbi)->max_discards)
-			add_discard_addrs(sbi, segno, se);
+	/*
+	 * if there are no enough space in journal to store dirty sit
+	 * entries, remove all entries from journal and add and account
+	 * them in sit entry set.
+	 */
+	if (!__has_cursum_space(sum, sit_i->dirty_sentries, SIT_JOURNAL))
+		remove_sits_in_journal(sbi);
 
-		if (flushed)
-			goto to_sit_page;
+	if (!sit_i->dirty_sentries)
+		goto out;
 
-		offset = lookup_journal_in_cursum(sum, SIT_JOURNAL, segno, 1);
-		if (offset >= 0) {
-			segno_in_journal(sum, offset) = cpu_to_le32(segno);
-			seg_info_to_raw_sit(se, &sit_in_journal(sum, offset));
-			goto flush_done;
+	/*
+	 * there are two steps to flush sit entries:
+	 * #1, flush sit entries to journal in current cold data summary block.
+	 * #2, flush sit entries to sit page.
+	 */
+	list_for_each_entry_safe(ses, tmp, head, set_list) {
+		struct page *page;
+		struct f2fs_sit_block *raw_sit = NULL;
+		unsigned int start_segno = ses->start_segno;
+		unsigned int end = min(start_segno + SIT_ENTRY_PER_BLOCK,
+								nsegs);
+		unsigned int segno = start_segno;
+
+		if (to_journal &&
+			!__has_cursum_space(sum, ses->entry_cnt, SIT_JOURNAL))
+			to_journal = false;
+
+		if (!to_journal) {
+			page = get_next_sit_page(sbi, start_segno);
+			raw_sit = page_address(page);
 		}
-to_sit_page:
-		if (!page || (start > segno) || (segno > end)) {
-			if (page) {
-				f2fs_put_page(page, 1);
-				page = NULL;
-			}
 
-			start = START_SEGNO(segno);
-			end = start + SIT_ENTRY_PER_BLOCK - 1;
+		/* flush dirty sit entries in region of current sit set */
+		for_each_set_bit_from(segno, bitmap, end) {
+			int offset, sit_offset;
+			struct seg_entry *se = get_seg_entry(sbi, segno);
+
+			/* add discard candidates */
+			if (SM_I(sbi)->nr_discards < SM_I(sbi)->max_discards)
+				add_discard_addrs(sbi, segno, se);
+
+			if (to_journal) {
+				offset = lookup_journal_in_cursum(sum,
+							SIT_JOURNAL, segno, 1);
+				f2fs_bug_on(sbi, offset < 0);
+				segno_in_journal(sum, offset) =
+							cpu_to_le32(segno);
+				seg_info_to_raw_sit(se,
+						&sit_in_journal(sum, offset));
+			} else {
+				sit_offset = SIT_ENTRY_OFFSET(sit_i, segno);
+				seg_info_to_raw_sit(se,
+						&raw_sit->entries[sit_offset]);
+			}
 
-			/* read sit block that will be updated */
-			page = get_next_sit_page(sbi, start);
-			raw_sit = page_address(page);
+			__clear_bit(segno, bitmap);
+			sit_i->dirty_sentries--;
+			ses->entry_cnt--;
 		}
 
-		/* udpate entry in SIT block */
-		seg_info_to_raw_sit(se, &raw_sit->entries[sit_offset]);
-flush_done:
-		__clear_bit(segno, bitmap);
-		sit_i->dirty_sentries--;
+		if (!to_journal)
+			f2fs_put_page(page, 1);
+
+		f2fs_bug_on(sbi, ses->entry_cnt);
+		release_sit_entry_set(ses);
 	}
+
+	f2fs_bug_on(sbi, !list_empty(head));
+	f2fs_bug_on(sbi, sit_i->dirty_sentries);
+
+out:
 	mutex_unlock(&sit_i->sentry_lock);
 	mutex_unlock(&curseg->curseg_mutex);
 
-	/* writeout last modified SIT block */
-	f2fs_put_page(page, 1);
-
 	set_prefree_as_free_segments(sbi);
 }
 
@@ -1854,6 +1946,8 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->nr_discards = 0;
 	sm_info->max_discards = 0;
 
+	INIT_LIST_HEAD(&sm_info->sit_entry_set);
+
 	if (test_opt(sbi, FLUSH_MERGE) && !f2fs_readonly(sbi->sb)) {
 		err = create_flush_cmd_control(sbi);
 		if (err)
@@ -1983,11 +2077,22 @@ int __init create_segment_manager_caches(void)
 	discard_entry_slab = f2fs_kmem_cache_create("discard_entry",
 			sizeof(struct discard_entry));
 	if (!discard_entry_slab)
-		return -ENOMEM;
+		goto fail;
+
+	sit_entry_set_slab = f2fs_kmem_cache_create("sit_entry_set",
+			sizeof(struct nat_entry_set));
+	if (!sit_entry_set_slab)
+		goto destory_discard_entry;
 	return 0;
+
+destory_discard_entry:
+	kmem_cache_destroy(discard_entry_slab);
+fail:
+	return -ENOMEM;
 }
 
 void destroy_segment_manager_caches(void)
 {
+	kmem_cache_destroy(sit_entry_set_slab);
 	kmem_cache_destroy(discard_entry_slab);
 }
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 2548bfd..bed0dc9 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -237,6 +237,12 @@ struct curseg_info {
 	unsigned int next_segno;		/* preallocated segment */
 };
 
+struct sit_entry_set {
+	struct list_head set_list;	/* link with all sit sets */
+	unsigned int start_segno;	/* start segno of sits in set */
+	unsigned int entry_cnt;		/* the # of sit entries in set */
+};
+
 /*
  * inline functions
  */
-- 
2.0.1.474.g72c7794


