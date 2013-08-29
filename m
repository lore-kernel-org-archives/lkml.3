Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3H2Asw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:48:52 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42317 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3H2Asu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:48:50 -0400
From: Jin Xu <jinuxstyle@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jinuxstyle@gmail.com
Subject: [PATCH] f2fs: optimize gc for better performance
Date: Thu, 29 Aug 2013 08:48:43 +0800
Message-Id: <1377737323-11803-1-git-send-email-jinuxstyle@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jin Xu <jinuxstyle@gmail.com>

This patch improves the foreground gc efficiency by optimizing the
victim selection policy. With this optimization, the random re-write
performance could increase up to 20%.

For f2fs, foreground gc happens when disk is lack of free spaces,
it selects dirty segments and moves valid blocks around for making
more space available. The gc cost of a segment is determined by the
valid blocks in the segment. The less the valid blocks, the higher
the efficiency. The ideal victim segment is the one that has the
most garbage blocks.

Currently, it searches up to 20 dirty segments for a victim segment.
The selected victim is not likely the best victim for gc when there
are much more dirty segments. Why not searching more dirty segments
for a better victim? The cost of searching dirty segments is
negligible in comparison to moving blocks.

In this patch, it does not search a constant number of dirty segments
anymore, instead it calculates the number based on the total segments,
dirty segments and a threshold. Following is the pseudo formula.
		,-- nr_dirty_segments, if total_segments < threshold
(# of search) = |
		`-- (nr_dirty_segments * threshold) / total_segments,
                        Otherwise

The test case is simple. It creates as many files until the disk full.
The size for each file is 32KB. Then it writes as many as 100000
records of 4KB size to random offsets of random files in sync mode.
The testing was done on a 2GB partition of a SDHC card. Let's see the
test result of f2fs without and with the patch.

----without the patch----
created 52023 files of size 32768 bytes in 341 seconds
finished 100000 loops in 4204 seconds
(internally, 722 gc were done, 115939 garbage blocks were reclaimed)

----with the patch----
created 52023 files of size 32768 bytes in 326 seconds
finished 100000 loops in 3067 seconds
(internally, 1255 gc were done, 181101 garbage blocks were reclaimed)

It's obvious that, with the patch, f2fs finishes the test in 20+% less
time than without the patch.

Since the performance improvement is related to gc, it might not be so
obvious for other tests that do not trigger gc as often as this one (
This is because f2fs selects dirty segments for SSR use most of the
time when free space is in shortage). The well-known iozone test tool
was not used for benchmarking the patch becuase it seems do not have
a test case that performs random re-write on a full disk.

Signed-off-by: Jin Xu <jinuxstyle@gmail.com>
---
 fs/f2fs/gc.c      |   27 ++++++++++++++++++++++++++-
 fs/f2fs/gc.h      |    4 +++-
 fs/f2fs/segment.h |    1 +
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 35f9b1a..4e045e6 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -138,10 +138,12 @@ static void select_policy(struct f2fs_sb_info *sbi, int gc_type,
 	if (p->alloc_mode == SSR) {
 		p->gc_mode = GC_GREEDY;
 		p->dirty_segmap = dirty_i->dirty_segmap[type];
+		p->dirty_type = type;
 		p->ofs_unit = 1;
 	} else {
 		p->gc_mode = select_gc_type(gc_type);
 		p->dirty_segmap = dirty_i->dirty_segmap[DIRTY];
+		p->dirty_type = DIRTY;
 		p->ofs_unit = sbi->segs_per_sec;
 	}
 	p->offset = sbi->last_victim[p->gc_mode];
@@ -243,6 +245,8 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 	struct victim_sel_policy p;
 	unsigned int secno, max_cost;
 	int nsearched = 0;
+	unsigned int max_search = MAX_VICTIM_SEARCH;
+	unsigned int nr_dirty;
 
 	p.alloc_mode = alloc_mode;
 	select_policy(sbi, gc_type, type, &p);
@@ -258,6 +262,27 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 			goto got_it;
 	}
 
+	nr_dirty = dirty_i->nr_dirty[p.dirty_type];
+	if (p.gc_mode == GC_GREEDY && p.alloc_mode != SSR) {
+		if (TOTAL_SEGS(sbi) <= FULL_VICTIM_SEARCH_THRESH)
+			max_search = nr_dirty; /* search all the dirty segs */
+		else {
+			/*
+			 * With more dirty segments, garbage blocks are likely
+			 * more scattered, thus search harder for better
+			 * victim.
+			 */
+			max_search = div_u64 ((nr_dirty *
+				FULL_VICTIM_SEARCH_THRESH), TOTAL_SEGS(sbi));
+			if (max_search < MIN_VICTIM_SEARCH_GREEDY)
+				max_search = MIN_VICTIM_SEARCH_GREEDY;
+		}
+	}
+
+	/* no more than the total dirty segments */
+	if (max_search > nr_dirty)
+		max_search = nr_dirty;
+
 	while (1) {
 		unsigned long cost;
 		unsigned int segno;
@@ -290,7 +315,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 		if (cost == max_cost)
 			continue;
 
-		if (nsearched++ >= MAX_VICTIM_SEARCH) {
+		if (nsearched++ >= max_search) {
 			sbi->last_victim[p.gc_mode] = segno;
 			break;
 		}
diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
index 2c6a6bd..2f525aa 100644
--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -20,7 +20,9 @@
 #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
 
 /* Search max. number of dirty segments to select a victim segment */
-#define MAX_VICTIM_SEARCH	20
+#define MAX_VICTIM_SEARCH		20
+#define MIN_VICTIM_SEARCH_GREEDY	20
+#define FULL_VICTIM_SEARCH_THRESH	4096
 
 struct f2fs_gc_kthread {
 	struct task_struct *f2fs_gc_task;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 062424a..cd33f96 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -142,6 +142,7 @@ struct victim_sel_policy {
 	int alloc_mode;			/* LFS or SSR */
 	int gc_mode;			/* GC_CB or GC_GREEDY */
 	unsigned long *dirty_segmap;	/* dirty segment bitmap */
+	int dirty_type;
 	unsigned int offset;		/* last scanned bitmap offset */
 	unsigned int ofs_unit;		/* bitmap search unit */
 	unsigned int min_cost;		/* minimum cost */
-- 
1.7.9.5

