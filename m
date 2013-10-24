Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3JXH60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 03:58:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57007 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3JXH6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 03:58:22 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-89-5268d31c6de8
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Changman Lee <cm224.lee@samsung.com>
Subject: [PATCH 1/3] f2fs: reclaim prefree segments periodically
Date: Thu, 24 Oct 2013 16:57:40 +0900
Message-id: <1382601462-7989-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsVy+t8zY12ZyxlBBsuP6Fpc29fIZHF9118m
	i0uL3C327D3JYnF51xw2B1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXRv/BBywF
	XbIV2yauYWxgnCLRxcjJISFgIvHs2T0WCFtM4sK99WxdjFwcQgLLGCVWnJ7MBlM0/e4TZojE
	dEaJ240/GEESQgLNTBInLyV1MXJwsAloS2zebwASFhFgllgw9TwjSD2zwA5GiVMT9zCC1AgL
	OEh8WiwDUsMioCpx7eZ0sPm8Am4SV/asYoXYpS2x7flEsF4JgddsEsvvnWWBaBCQ+Db5EAvI
	HAkBWYlNB5gh6iUlDq64wTKBUXABI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJBQ7NvB
	ePOA9SHGZKBxE5mlRJPzgaGcVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6YklqdmpqQWp
	RfFFpTmpxYcYmTg4pRoYnQ7c3JD57+vlwONVR+ZEnL1+ct1P/veGvJfO5TAuOi1Vpp1TlJyf
	YfxSf2n7viTG0nkqPKuPbznp4XP5htayL6t/ZN4seMkefvT3zMJnVSZJizvyX8g5VVpnvH24
	uEyV6dzbUuM8BeYV9Q+OTX/j86hyZ/a8sM3S/VXLNn5fLufWdej+sZZ6aSWW4oxEQy3mouJE
	AI7u0nRbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t9jQV2ZyxlBBg2n1C2u7Wtksri+6y+T
	xaVF7hZ79p5ksbi8aw6bA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMaP/4AOWgi7Zim0T1zA2ME6R6GLk5JAQMJGYfvcJM4QtJnHh3nq2
	LkYuDiGB6YwStxt/MIIkhASamSROXkrqYuTgYBPQlti83wAkLCLALLFg6nlGkHpmgR2MEqcm
	7mEEqREWcJD4tFgGpIZFQFXi2s3pbCA2r4CbxJU9q1ghdmlLbHs+kXECI/cCRoZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMGB/kx6B+OqBotDjAIcjEo8vBof0oOEWBPLiitzDzFKcDAr
	ifB6VmQECfGmJFZWpRblxxeV5qQWH2JMBto+kVlKNDkfGIV5JfGGxiZmRpZGZhZGJubmpAkr
	ifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cDYrLJHcFG3qUdT6Om6lv28KU3uuzdtmJ74MHKV
	mg1vpv/nGr9/V8/tkFi09Or2txtn+lpGLmKPcGtYeVF785mKPbcZ2v52ZYtarQiUOGoptcgw
	/pEOZ9JGc8MCJznJyhyH11u4NYVdG/0WrS90vWLScr3t02f330czWO6IiLWu7+Y8o/9uiqQS
	S3FGoqEWc1FxIgD3HbCSuAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, f2fs postpones reclaiming prefree segments into free segments
as much as possible.
However, if user writes and deletes a bunch of data without any sync or fsync
calls, some flash storages can suffer from garbage collections.

So, this patch adds the reclaiming codes to f2fs_write_node_pages and background
GC thread.

If there are a lot of prefree segments, let's do checkpoint so that f2fs
submits discard commands for the prefree regions to the flash storage.

Signed-off-by: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/f2fs.h    | 3 +++
 fs/f2fs/gc.c      | 5 +++++
 fs/f2fs/node.c    | 3 ++-
 fs/f2fs/segment.c | 1 +
 fs/f2fs/segment.h | 7 +++++++
 5 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 590a09e..3c95d35 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -299,6 +299,9 @@ struct f2fs_sm_info {
 	unsigned int main_segments;	/* # of segments in main area */
 	unsigned int reserved_segments;	/* # of reserved segments */
 	unsigned int ovp_segments;	/* # of overprovision segments */
+
+	/* a threshold to reclaim prefree segments */
+	unsigned int rec_prefree_segments;
 };
 
 /*
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index cb286d7..783c6cc 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -82,6 +82,11 @@ static int gc_thread_func(void *data)
 		/* if return value is not zero, no victim was selected */
 		if (f2fs_gc(sbi))
 			wait_ms = gc_th->no_gc_sleep_time;
+
+		/* balancing prefree segments */
+		if (excess_prefree_segs(sbi))
+			f2fs_sync_fs(sbi->sb, true);
+
 	} while (!kthread_should_stop());
 	return 0;
 }
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index cc119b6..89dd8a5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1206,7 +1206,8 @@ static int f2fs_write_node_pages(struct address_space *mapping,
 	long nr_to_write = wbc->nr_to_write;
 
 	/* First check balancing cached NAT entries */
-	if (try_to_free_nats(sbi, NAT_ENTRY_PER_BLOCK)) {
+	if (try_to_free_nats(sbi, NAT_ENTRY_PER_BLOCK) ||
+				excess_prefree_segs(sbi)) {
 		f2fs_sync_fs(sbi->sb, true);
 		return 0;
 	}
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c9c276e..43ee91e 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1645,6 +1645,7 @@ int build_segment_manager(struct f2fs_sb_info *sbi)
 	sm_info->ovp_segments = le32_to_cpu(ckpt->overprov_segment_count);
 	sm_info->main_segments = le32_to_cpu(raw_super->segment_count_main);
 	sm_info->ssa_blkaddr = le32_to_cpu(raw_super->ssa_blkaddr);
+	sm_info->rec_prefree_segments = DEF_RECLAIM_PREFREE_SEGMENTS;
 
 	err = build_sit_info(sbi);
 	if (err)
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 7f94d78..abe7094 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -14,6 +14,8 @@
 #define NULL_SEGNO			((unsigned int)(~0))
 #define NULL_SECNO			((unsigned int)(~0))
 
+#define DEF_RECLAIM_PREFREE_SEGMENTS	100	/* 200MB of prefree segments */
+
 /* L: Logical segment # in volume, R: Relative segment # in main area */
 #define GET_L2R_SEGNO(free_i, segno)	(segno - free_i->start_segno)
 #define GET_R2L_SEGNO(free_i, segno)	(segno + free_i->start_segno)
@@ -472,6 +474,11 @@ static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi, int freed)
 						reserved_sections(sbi)));
 }
 
+static inline bool excess_prefree_segs(struct f2fs_sb_info *sbi)
+{
+	return (prefree_segments(sbi) > SM_I(sbi)->rec_prefree_segments);
+}
+
 static inline int utilization(struct f2fs_sb_info *sbi)
 {
 	return div_u64((u64)valid_user_blocks(sbi) * 100, sbi->user_block_count);
-- 
1.8.4.474.g128a96c

