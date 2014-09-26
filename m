Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaIZEy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:54:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:57045 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbaIZEyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:54:54 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/4] f2fs: check the use of macros on block counts and addresses
Date: Thu, 25 Sep 2014 21:54:44 -0700
Message-Id: <1411707287-21760-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.9.3 (Apple Git-50)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the existing and new macros for readability.

Rule is like this.

         ,-----------------------------------------> MAX_BLKADDR -,
         |  ,------------- TOTAL_BLKS ----------------------------,
         |  |                                                     |
         |  ,- seg0_blkaddr   ,----- sit/nat/ssa/main blkaddress  |
block    |  | (SEG0_BLKADDR)  | | | |   (e.g., MAIN_BLKADDR)      |
address  0..x................ a b c d .............................
            |                                                     |
global seg# 0...................... m .............................
            |                       |                             |
            |                       `------- MAIN_SEGS -----------'
            `-------------- TOTAL_SEGS ---------------------------'
                                    |                             |
 seg#                               0..........xx..................

= Note =
 o GET_SEGNO_FROM_SEG0 : blk address -> global segno
 o GET_SEGNO           : blk address -> segno
 o START_BLOCK         : segno -> starting block address

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c |  5 ++--
 fs/f2fs/debug.c      | 20 ++++++-------
 fs/f2fs/gc.c         |  7 ++---
 fs/f2fs/recovery.c   |  8 ++---
 fs/f2fs/segment.c    | 85 +++++++++++++++++++++++-----------------------------
 fs/f2fs/segment.h    | 44 +++++++++++++--------------
 6 files changed, 77 insertions(+), 92 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 4abf0ba..dd10a03 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -98,7 +98,7 @@ static inline block_t get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 	case META_CP:
 		return 0;
 	case META_POR:
-		return SM_I(sbi)->seg0_blkaddr + TOTAL_BLKS(sbi);
+		return MAX_BLKADDR(sbi);
 	default:
 		BUG();
 	}
@@ -113,7 +113,6 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type
 	struct page *page;
 	block_t blkno = start;
 	block_t max_blks = get_max_meta_blks(sbi, type);
-	block_t min_blks = SM_I(sbi)->seg0_blkaddr;
 
 	struct f2fs_io_info fio = {
 		.type = META,
@@ -146,7 +145,7 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type
 		case META_POR:
 			if (unlikely(blkno >= max_blks))
 				goto out;
-			if (unlikely(blkno < min_blks))
+			if (unlikely(blkno < SEG0_BLKADDR(sbi)))
 				goto out;
 			blk_addr = blkno;
 			break;
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index fecebdb..0a91ab8 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -93,7 +93,7 @@ static void update_sit_info(struct f2fs_sb_info *sbi)
 	total_vblocks = 0;
 	blks_per_sec = sbi->segs_per_sec * (1 << sbi->log_blocks_per_seg);
 	hblks_per_sec = blks_per_sec / 2;
-	for (segno = 0; segno < TOTAL_SEGS(sbi); segno += sbi->segs_per_sec) {
+	for (segno = 0; segno < MAIN_SEGS(sbi); segno += sbi->segs_per_sec) {
 		vblocks = get_valid_blocks(sbi, segno, sbi->segs_per_sec);
 		dist = abs(vblocks - hblks_per_sec);
 		bimodal += dist * dist;
@@ -103,7 +103,7 @@ static void update_sit_info(struct f2fs_sb_info *sbi)
 			ndirty++;
 		}
 	}
-	dist = TOTAL_SECS(sbi) * hblks_per_sec * hblks_per_sec / 100;
+	dist = MAIN_SECS(sbi) * hblks_per_sec * hblks_per_sec / 100;
 	si->bimodal = bimodal / dist;
 	if (si->dirty_count)
 		si->avg_vblocks = total_vblocks / ndirty;
@@ -131,17 +131,17 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 
 	/* build sit */
 	si->base_mem += sizeof(struct sit_info);
-	si->base_mem += TOTAL_SEGS(sbi) * sizeof(struct seg_entry);
-	si->base_mem += f2fs_bitmap_size(TOTAL_SEGS(sbi));
-	si->base_mem += 2 * SIT_VBLOCK_MAP_SIZE * TOTAL_SEGS(sbi);
+	si->base_mem += MAIN_SEGS(sbi) * sizeof(struct seg_entry);
+	si->base_mem += f2fs_bitmap_size(MAIN_SEGS(sbi));
+	si->base_mem += 2 * SIT_VBLOCK_MAP_SIZE * MAIN_SEGS(sbi);
 	if (sbi->segs_per_sec > 1)
-		si->base_mem += TOTAL_SECS(sbi) * sizeof(struct sec_entry);
+		si->base_mem += MAIN_SECS(sbi) * sizeof(struct sec_entry);
 	si->base_mem += __bitmap_size(sbi, SIT_BITMAP);
 
 	/* build free segmap */
 	si->base_mem += sizeof(struct free_segmap_info);
-	si->base_mem += f2fs_bitmap_size(TOTAL_SEGS(sbi));
-	si->base_mem += f2fs_bitmap_size(TOTAL_SECS(sbi));
+	si->base_mem += f2fs_bitmap_size(MAIN_SEGS(sbi));
+	si->base_mem += f2fs_bitmap_size(MAIN_SECS(sbi));
 
 	/* build curseg */
 	si->base_mem += sizeof(struct curseg_info) * NR_CURSEG_TYPE;
@@ -149,8 +149,8 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 
 	/* build dirty segmap */
 	si->base_mem += sizeof(struct dirty_seglist_info);
-	si->base_mem += NR_DIRTY_TYPE * f2fs_bitmap_size(TOTAL_SEGS(sbi));
-	si->base_mem += f2fs_bitmap_size(TOTAL_SECS(sbi));
+	si->base_mem += NR_DIRTY_TYPE * f2fs_bitmap_size(MAIN_SEGS(sbi));
+	si->base_mem += f2fs_bitmap_size(MAIN_SECS(sbi));
 
 	/* build nm */
 	si->base_mem += sizeof(struct f2fs_nm_info);
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index e88fcf6..2a8f4ac 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -193,7 +193,7 @@ static unsigned int check_bg_victims(struct f2fs_sb_info *sbi)
 	 * selected by background GC before.
 	 * Those segments guarantee they have small valid blocks.
 	 */
-	for_each_set_bit(secno, dirty_i->victim_secmap, TOTAL_SECS(sbi)) {
+	for_each_set_bit(secno, dirty_i->victim_secmap, MAIN_SECS(sbi)) {
 		if (sec_usage_check(sbi, secno))
 			continue;
 		clear_bit(secno, dirty_i->victim_secmap);
@@ -281,9 +281,8 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 		unsigned long cost;
 		unsigned int segno;
 
-		segno = find_next_bit(p.dirty_segmap,
-						TOTAL_SEGS(sbi), p.offset);
-		if (segno >= TOTAL_SEGS(sbi)) {
+		segno = find_next_bit(p.dirty_segmap, MAIN_SEGS(sbi), p.offset);
+		if (segno >= MAIN_SEGS(sbi)) {
 			if (sbi->last_victim[p.gc_mode]) {
 				sbi->last_victim[p.gc_mode] = 0;
 				p.offset = 0;
diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
index 947b922..ebd0132 100644
--- a/fs/f2fs/recovery.c
+++ b/fs/f2fs/recovery.c
@@ -173,8 +173,7 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
 	while (1) {
 		struct fsync_inode_entry *entry;
 
-		if (blkaddr < SM_I(sbi)->main_blkaddr ||
-			blkaddr >= (SM_I(sbi)->seg0_blkaddr + TOTAL_BLKS(sbi)))
+		if (blkaddr < MAIN_BLKADDR(sbi) || blkaddr >= MAX_BLKADDR(sbi))
 			return 0;
 
 		page = get_meta_page_ra(sbi, blkaddr);
@@ -434,8 +433,7 @@ static int recover_data(struct f2fs_sb_info *sbi,
 	while (1) {
 		struct fsync_inode_entry *entry;
 
-		if (blkaddr < SM_I(sbi)->main_blkaddr ||
-			blkaddr >= (SM_I(sbi)->seg0_blkaddr + TOTAL_BLKS(sbi)))
+		if (blkaddr < MAIN_BLKADDR(sbi) || blkaddr >= MAX_BLKADDR(sbi))
 			break;
 
 		page = get_meta_page_ra(sbi, blkaddr);
@@ -525,7 +523,7 @@ out:
 
 	/* truncate meta pages to be used by the recovery */
 	truncate_inode_pages_range(META_MAPPING(sbi),
-		SM_I(sbi)->main_blkaddr << PAGE_CACHE_SHIFT, -1);
+			MAIN_BLKADDR(sbi) << PAGE_CACHE_SHIFT, -1);
 
 	if (err) {
 		truncate_inode_pages_final(NODE_MAPPING(sbi));
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index f602fa9..d30cd16 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -481,10 +481,9 @@ static void set_prefree_as_free_segments(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	unsigned int segno;
-	unsigned int total_segs = TOTAL_SEGS(sbi);
 
 	mutex_lock(&dirty_i->seglist_lock);
-	for_each_set_bit(segno, dirty_i->dirty_segmap[PRE], total_segs)
+	for_each_set_bit(segno, dirty_i->dirty_segmap[PRE], MAIN_SEGS(sbi))
 		__set_test_and_free(sbi, segno);
 	mutex_unlock(&dirty_i->seglist_lock);
 }
@@ -495,17 +494,17 @@ void clear_prefree_segments(struct f2fs_sb_info *sbi)
 	struct discard_entry *entry, *this;
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	unsigned long *prefree_map = dirty_i->dirty_segmap[PRE];
-	unsigned int total_segs = TOTAL_SEGS(sbi);
 	unsigned int start = 0, end = -1;
 
 	mutex_lock(&dirty_i->seglist_lock);
 
 	while (1) {
 		int i;
-		start = find_next_bit(prefree_map, total_segs, end + 1);
-		if (start >= total_segs)
+		start = find_next_bit(prefree_map, MAIN_SEGS(sbi), end + 1);
+		if (start >= MAIN_SEGS(sbi))
 			break;
-		end = find_next_zero_bit(prefree_map, total_segs, start + 1);
+		end = find_next_zero_bit(prefree_map, MAIN_SEGS(sbi),
+								start + 1);
 
 		for (i = start; i < end; i++)
 			clear_bit(i, prefree_map);
@@ -680,7 +679,7 @@ static int is_next_segment_free(struct f2fs_sb_info *sbi, int type)
 	unsigned int segno = curseg->segno + 1;
 	struct free_segmap_info *free_i = FREE_I(sbi);
 
-	if (segno < TOTAL_SEGS(sbi) && segno % sbi->segs_per_sec)
+	if (segno < MAIN_SEGS(sbi) && segno % sbi->segs_per_sec)
 		return !test_bit(segno, free_i->free_segmap);
 	return 0;
 }
@@ -694,7 +693,7 @@ static void get_new_segment(struct f2fs_sb_info *sbi,
 {
 	struct free_segmap_info *free_i = FREE_I(sbi);
 	unsigned int segno, secno, zoneno;
-	unsigned int total_zones = TOTAL_SECS(sbi) / sbi->secs_per_zone;
+	unsigned int total_zones = MAIN_SECS(sbi) / sbi->secs_per_zone;
 	unsigned int hint = *newseg / sbi->segs_per_sec;
 	unsigned int old_zoneno = GET_ZONENO_FROM_SEGNO(sbi, *newseg);
 	unsigned int left_start = hint;
@@ -706,18 +705,18 @@ static void get_new_segment(struct f2fs_sb_info *sbi,
 
 	if (!new_sec && ((*newseg + 1) % sbi->segs_per_sec)) {
 		segno = find_next_zero_bit(free_i->free_segmap,
-					TOTAL_SEGS(sbi), *newseg + 1);
+					MAIN_SEGS(sbi), *newseg + 1);
 		if (segno - *newseg < sbi->segs_per_sec -
 					(*newseg % sbi->segs_per_sec))
 			goto got_it;
 	}
 find_other_zone:
-	secno = find_next_zero_bit(free_i->free_secmap, TOTAL_SECS(sbi), hint);
-	if (secno >= TOTAL_SECS(sbi)) {
+	secno = find_next_zero_bit(free_i->free_secmap, MAIN_SECS(sbi), hint);
+	if (secno >= MAIN_SECS(sbi)) {
 		if (dir == ALLOC_RIGHT) {
 			secno = find_next_zero_bit(free_i->free_secmap,
-							TOTAL_SECS(sbi), 0);
-			f2fs_bug_on(sbi, secno >= TOTAL_SECS(sbi));
+							MAIN_SECS(sbi), 0);
+			f2fs_bug_on(sbi, secno >= MAIN_SECS(sbi));
 		} else {
 			go_left = 1;
 			left_start = hint - 1;
@@ -732,8 +731,8 @@ find_other_zone:
 			continue;
 		}
 		left_start = find_next_zero_bit(free_i->free_secmap,
-							TOTAL_SECS(sbi), 0);
-		f2fs_bug_on(sbi, left_start >= TOTAL_SECS(sbi));
+							MAIN_SECS(sbi), 0);
+		f2fs_bug_on(sbi, left_start >= MAIN_SECS(sbi));
 		break;
 	}
 	secno = left_start;
@@ -946,26 +945,22 @@ static const struct segment_allocation default_salloc_ops = {
 
 int f2fs_trim_fs(struct f2fs_sb_info *sbi, struct fstrim_range *range)
 {
-	block_t start_addr = SM_I(sbi)->main_blkaddr;
 	__u64 start = range->start >> sbi->log_blocksize;
 	__u64 end = start + (range->len >> sbi->log_blocksize) - 1;
-	__u64 segment = 1 << (sbi->log_blocksize + sbi->log_blocks_per_seg);
 	unsigned int start_segno, end_segno;
 	struct cp_control cpc;
 
-	if (range->minlen > segment ||
-			start >= SM_I(sbi)->seg0_blkaddr + TOTAL_BLKS(sbi) ||
-			range->len < sbi->blocksize)
+	if (range->minlen > SEGMENT_SIZE(sbi) || start >= MAX_BLKADDR(sbi) ||
+						range->len < sbi->blocksize)
 		return -EINVAL;
 
-	if (end <= start_addr)
+	if (end <= MAIN_BLKADDR(sbi))
 		goto out;
 
 	/* start/end segment number in main_area */
-	start_segno = (start <= start_addr) ? 0 : GET_SEGNO(sbi, start);
-	end_segno = (end >= SM_I(sbi)->seg0_blkaddr + TOTAL_BLKS(sbi)) ?
-				TOTAL_SEGS(sbi) - 1 : GET_SEGNO(sbi, end);
-
+	start_segno = (start <= MAIN_BLKADDR(sbi)) ? 0 : GET_SEGNO(sbi, start);
+	end_segno = (end >= MAX_BLKADDR(sbi)) ? MAIN_SEGS(sbi) - 1 :
+						GET_SEGNO(sbi, end);
 	cpc.reason = CP_DISCARD;
 	cpc.trim_start = start_segno;
 	cpc.trim_end = end_segno;
@@ -1576,10 +1571,9 @@ static void add_sits_in_set(struct f2fs_sb_info *sbi)
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
 	struct list_head *set_list = &sm_info->sit_entry_set;
 	unsigned long *bitmap = SIT_I(sbi)->dirty_sentries_bitmap;
-	unsigned long nsegs = TOTAL_SEGS(sbi);
 	unsigned int segno;
 
-	for_each_set_bit(segno, bitmap, nsegs)
+	for_each_set_bit(segno, bitmap, MAIN_SEGS(sbi))
 		add_sit_entry(segno, set_list);
 }
 
@@ -1614,7 +1608,6 @@ void flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	struct f2fs_summary_block *sum = curseg->sum_blk;
 	struct sit_entry_set *ses, *tmp;
 	struct list_head *head = &SM_I(sbi)->sit_entry_set;
-	unsigned long nsegs = TOTAL_SEGS(sbi);
 	bool to_journal = true;
 	struct seg_entry *se;
 
@@ -1648,7 +1641,7 @@ void flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 		struct f2fs_sit_block *raw_sit = NULL;
 		unsigned int start_segno = ses->start_segno;
 		unsigned int end = min(start_segno + SIT_ENTRY_PER_BLOCK,
-								nsegs);
+						(unsigned long)MAIN_SEGS(sbi));
 		unsigned int segno = start_segno;
 
 		if (to_journal &&
@@ -1727,16 +1720,16 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 
 	SM_I(sbi)->sit_info = sit_i;
 
-	sit_i->sentries = vzalloc(TOTAL_SEGS(sbi) * sizeof(struct seg_entry));
+	sit_i->sentries = vzalloc(MAIN_SEGS(sbi) * sizeof(struct seg_entry));
 	if (!sit_i->sentries)
 		return -ENOMEM;
 
-	bitmap_size = f2fs_bitmap_size(TOTAL_SEGS(sbi));
+	bitmap_size = f2fs_bitmap_size(MAIN_SEGS(sbi));
 	sit_i->dirty_sentries_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
 	if (!sit_i->dirty_sentries_bitmap)
 		return -ENOMEM;
 
-	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
+	for (start = 0; start < MAIN_SEGS(sbi); start++) {
 		sit_i->sentries[start].cur_valid_map
 			= kzalloc(SIT_VBLOCK_MAP_SIZE, GFP_KERNEL);
 		sit_i->sentries[start].ckpt_valid_map
@@ -1747,7 +1740,7 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 	}
 
 	if (sbi->segs_per_sec > 1) {
-		sit_i->sec_entries = vzalloc(TOTAL_SECS(sbi) *
+		sit_i->sec_entries = vzalloc(MAIN_SECS(sbi) *
 					sizeof(struct sec_entry));
 		if (!sit_i->sec_entries)
 			return -ENOMEM;
@@ -1782,7 +1775,6 @@ static int build_sit_info(struct f2fs_sb_info *sbi)
 
 static int build_free_segmap(struct f2fs_sb_info *sbi)
 {
-	struct f2fs_sm_info *sm_info = SM_I(sbi);
 	struct free_segmap_info *free_i;
 	unsigned int bitmap_size, sec_bitmap_size;
 
@@ -1793,12 +1785,12 @@ static int build_free_segmap(struct f2fs_sb_info *sbi)
 
 	SM_I(sbi)->free_info = free_i;
 
-	bitmap_size = f2fs_bitmap_size(TOTAL_SEGS(sbi));
+	bitmap_size = f2fs_bitmap_size(MAIN_SEGS(sbi));
 	free_i->free_segmap = kmalloc(bitmap_size, GFP_KERNEL);
 	if (!free_i->free_segmap)
 		return -ENOMEM;
 
-	sec_bitmap_size = f2fs_bitmap_size(TOTAL_SECS(sbi));
+	sec_bitmap_size = f2fs_bitmap_size(MAIN_SECS(sbi));
 	free_i->free_secmap = kmalloc(sec_bitmap_size, GFP_KERNEL);
 	if (!free_i->free_secmap)
 		return -ENOMEM;
@@ -1808,8 +1800,7 @@ static int build_free_segmap(struct f2fs_sb_info *sbi)
 	memset(free_i->free_secmap, 0xff, sec_bitmap_size);
 
 	/* init free segmap information */
-	free_i->start_segno =
-		(unsigned int) GET_SEGNO_FROM_SEG0(sbi, sm_info->main_blkaddr);
+	free_i->start_segno = GET_SEGNO_FROM_SEG0(sbi, MAIN_BLKADDR(sbi));
 	free_i->free_segments = 0;
 	free_i->free_sections = 0;
 	rwlock_init(&free_i->segmap_lock);
@@ -1854,7 +1845,7 @@ static void build_sit_entries(struct f2fs_sb_info *sbi)
 		start = start_blk * sit_i->sents_per_block;
 		end = (start_blk + readed) * sit_i->sents_per_block;
 
-		for (; start < end && start < TOTAL_SEGS(sbi); start++) {
+		for (; start < end && start < MAIN_SEGS(sbi); start++) {
 			struct seg_entry *se = &sit_i->sentries[start];
 			struct f2fs_sit_block *sit_blk;
 			struct f2fs_sit_entry sit;
@@ -1892,7 +1883,7 @@ static void init_free_segmap(struct f2fs_sb_info *sbi)
 	unsigned int start;
 	int type;
 
-	for (start = 0; start < TOTAL_SEGS(sbi); start++) {
+	for (start = 0; start < MAIN_SEGS(sbi); start++) {
 		struct seg_entry *sentry = get_seg_entry(sbi, start);
 		if (!sentry->valid_blocks)
 			__set_free(sbi, start);
@@ -1909,13 +1900,13 @@ static void init_dirty_segmap(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
 	struct free_segmap_info *free_i = FREE_I(sbi);
-	unsigned int segno = 0, offset = 0, total_segs = TOTAL_SEGS(sbi);
+	unsigned int segno = 0, offset = 0;
 	unsigned short valid_blocks;
 
 	while (1) {
 		/* find dirty segment based on free segmap */
-		segno = find_next_inuse(free_i, total_segs, offset);
-		if (segno >= total_segs)
+		segno = find_next_inuse(free_i, MAIN_SEGS(sbi), offset);
+		if (segno >= MAIN_SEGS(sbi))
 			break;
 		offset = segno + 1;
 		valid_blocks = get_valid_blocks(sbi, segno, 0);
@@ -1934,7 +1925,7 @@ static void init_dirty_segmap(struct f2fs_sb_info *sbi)
 static int init_victim_secmap(struct f2fs_sb_info *sbi)
 {
 	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
-	unsigned int bitmap_size = f2fs_bitmap_size(TOTAL_SECS(sbi));
+	unsigned int bitmap_size = f2fs_bitmap_size(MAIN_SECS(sbi));
 
 	dirty_i->victim_secmap = kzalloc(bitmap_size, GFP_KERNEL);
 	if (!dirty_i->victim_secmap)
@@ -1955,7 +1946,7 @@ static int build_dirty_segmap(struct f2fs_sb_info *sbi)
 	SM_I(sbi)->dirty_info = dirty_i;
 	mutex_init(&dirty_i->seglist_lock);
 
-	bitmap_size = f2fs_bitmap_size(TOTAL_SEGS(sbi));
+	bitmap_size = f2fs_bitmap_size(MAIN_SEGS(sbi));
 
 	for (i = 0; i < NR_DIRTY_TYPE; i++) {
 		dirty_i->dirty_segmap[i] = kzalloc(bitmap_size, GFP_KERNEL);
@@ -1979,7 +1970,7 @@ static void init_min_max_mtime(struct f2fs_sb_info *sbi)
 
 	sit_i->min_mtime = LLONG_MAX;
 
-	for (segno = 0; segno < TOTAL_SEGS(sbi); segno += sbi->segs_per_sec) {
+	for (segno = 0; segno < MAIN_SEGS(sbi); segno += sbi->segs_per_sec) {
 		unsigned int i;
 		unsigned long long mtime = 0;
 
@@ -2122,7 +2113,7 @@ static void destroy_sit_info(struct f2fs_sb_info *sbi)
 		return;
 
 	if (sit_i->sentries) {
-		for (start = 0; start < TOTAL_SEGS(sbi); start++) {
+		for (start = 0; start < MAIN_SEGS(sbi); start++) {
 			kfree(sit_i->sentries[start].cur_valid_map);
 			kfree(sit_i->sentries[start].ckpt_valid_map);
 		}
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 4588545..d080f55 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -45,16 +45,26 @@
 	 (secno == CURSEG_I(sbi, CURSEG_COLD_NODE)->segno /		\
 	  sbi->segs_per_sec))	\
 
-#define START_BLOCK(sbi, segno)						\
-	(SM_I(sbi)->seg0_blkaddr +					\
+#define MAIN_BLKADDR(sbi)	(SM_I(sbi)->main_blkaddr)
+#define SEG0_BLKADDR(sbi)	(SM_I(sbi)->seg0_blkaddr)
+
+#define MAIN_SEGS(sbi)	(SM_I(sbi)->main_segments)
+#define MAIN_SECS(sbi)	(sbi->total_sections)
+
+#define TOTAL_SEGS(sbi)	(SM_I(sbi)->segment_count)
+#define TOTAL_BLKS(sbi)	(TOTAL_SEGS(sbi) << sbi->log_blocks_per_seg)
+
+#define MAX_BLKADDR(sbi)	(SEG0_BLKADDR(sbi) + TOTAL_BLKS(sbi))
+#define SEGMENT_SIZE(sbi)	(1 << (sbi->log_blocksize +		\
+					sbi->log_blocks_per_seg))
+
+#define START_BLOCK(sbi, segno)	(SEG0_BLKADDR(sbi) +			\
 	 (GET_R2L_SEGNO(FREE_I(sbi), segno) << sbi->log_blocks_per_seg))
+
 #define NEXT_FREE_BLKADDR(sbi, curseg)					\
 	(START_BLOCK(sbi, curseg->segno) + curseg->next_blkoff)
 
-#define MAIN_BASE_BLOCK(sbi)	(SM_I(sbi)->main_blkaddr)
-
-#define GET_SEGOFF_FROM_SEG0(sbi, blk_addr)				\
-	((blk_addr) - SM_I(sbi)->seg0_blkaddr)
+#define GET_SEGOFF_FROM_SEG0(sbi, blk_addr)	((blk_addr) - SEG0_BLKADDR(sbi))
 #define GET_SEGNO_FROM_SEG0(sbi, blk_addr)				\
 	(GET_SEGOFF_FROM_SEG0(sbi, blk_addr) >> sbi->log_blocks_per_seg)
 #define GET_BLKOFF_FROM_SEG0(sbi, blk_addr)				\
@@ -82,12 +92,9 @@
 #define	START_SEGNO(segno)		\
 	(SIT_BLOCK_OFFSET(segno) * SIT_ENTRY_PER_BLOCK)
 #define SIT_BLK_CNT(sbi)			\
-	((TOTAL_SEGS(sbi) + SIT_ENTRY_PER_BLOCK - 1) / SIT_ENTRY_PER_BLOCK)
+	((MAIN_SEGS(sbi) + SIT_ENTRY_PER_BLOCK - 1) / SIT_ENTRY_PER_BLOCK)
 #define f2fs_bitmap_size(nr)			\
 	(BITS_TO_LONGS(nr) * sizeof(unsigned long))
-#define TOTAL_SEGS(sbi)	(SM_I(sbi)->main_segments)
-#define TOTAL_SECS(sbi)	(sbi->total_sections)
-#define TOTAL_BLKS(sbi)	(SM_I(sbi)->segment_count << sbi->log_blocks_per_seg)
 
 #define SECTOR_FROM_BLOCK(blk_addr)					\
 	(((sector_t)blk_addr) << F2FS_LOG_SECTORS_PER_BLOCK)
@@ -323,7 +330,7 @@ static inline void __set_free(struct f2fs_sb_info *sbi, unsigned int segno)
 	clear_bit(segno, free_i->free_segmap);
 	free_i->free_segments++;
 
-	next = find_next_bit(free_i->free_segmap, TOTAL_SEGS(sbi), start_segno);
+	next = find_next_bit(free_i->free_segmap, MAIN_SEGS(sbi), start_segno);
 	if (next >= start_segno + sbi->segs_per_sec) {
 		clear_bit(secno, free_i->free_secmap);
 		free_i->free_sections++;
@@ -548,12 +555,8 @@ static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned int segno)
 
 static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t blk_addr)
 {
-	struct f2fs_sm_info *sm_info = SM_I(sbi);
-	block_t total_blks = TOTAL_BLKS(sbi);
-	block_t start_addr = sm_info->seg0_blkaddr;
-	block_t end_addr = start_addr + total_blks - 1;
-	BUG_ON(blk_addr < start_addr);
-	BUG_ON(blk_addr > end_addr);
+	BUG_ON(blk_addr < SEG0_BLKADDR(sbi));
+	BUG_ON(blk_addr >= MAX_BLKADDR(sbi));
 }
 
 /*
@@ -601,12 +604,7 @@ static inline void check_seg_range(struct f2fs_sb_info *sbi, unsigned int segno)
 
 static inline void verify_block_addr(struct f2fs_sb_info *sbi, block_t blk_addr)
 {
-	struct f2fs_sm_info *sm_info = SM_I(sbi);
-	block_t total_blks = TOTAL_BLKS(sbi);
-	block_t start_addr = sm_info->seg0_blkaddr;
-	block_t end_addr = start_addr + total_blks - 1;
-
-	if (blk_addr < start_addr || blk_addr > end_addr)
+	if (blk_addr < SEG0_BLKADDR(sbi) || blk_addr >= MAX_BLKADDR(sbi))
 		sbi->need_fsck = true;
 }
 
-- 
1.9.3 (Apple Git-50)

