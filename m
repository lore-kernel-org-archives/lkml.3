Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380AbaLHHAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:00:40 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:9124 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbaLHHAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:00:39 -0500
X-AuditID: cbfee61a-f79c06d000004e71-95-54854c959a57
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH 2/4] f2fs: introduce is_valid_blkaddr to cleanup
 codes in ra_meta_pages
Date: Mon, 08 Dec 2014 14:59:17 +0800
Message-id: <001901d012b4$ab211670$01634350$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdASn2D+cCgOQKSHTLOnZiF6+kboVQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd2pPq0hBo2/hC2u7Wtksniyfhaz
	xaVF7hZ79p5ksbi8aw6bA6vHplWdbB67F3xm8ujbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
	3qb3rAU7pSq6muezNzAeFeli5OSQEDCRuLhsAhuELSZx4d56IJuLQ0hgEaNEy+ZTTBDOD0aJ
	RTdWg1WxCahILO/4zwRiiwh4SUzaf4IFxGYWyJS41zSDGcQWFkiWWL1hPlg9i4CqxKbts8Hq
	eQUsJd6938cOYQtK/Jh8D6pXS2LztiZWCFteYvOat8wQFylI7Dj7mhFil57Euo5WJogacYmN
	R26xTGAUmIVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHh/Uxq
	B+PKBotDjAIcjEo8vAsetIQIsSaWFVfmHmKU4GBWEuH1tG8NEeJNSaysSi3Kjy8qzUktPsQo
	zcGiJM5742ZuiJBAemJJanZqakFqEUyWiYNTqoHxmMNC796vT3pafU/5ljEeFk5x2r65r2at
	c8cmo5KV6UYzcwscjOQv5HWfOahQlMR5a/dk6TeMMfqLlk7/PIHnyNSSK1+tFy34ar5uvv9t
	TrfzEVqXc78e4NEpZT5rO/tM8q73037dz9i6YVdn+8v3LLsi+dv+vp+8qOyuvjXHNKOrLw/O
	nn5ntRJLcUaioRZzUXEiAP9onBBrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch does cleanup work, it introduces is_valid_blkaddr() to include
verification code for blkaddr with upper and down boundary value which were in
ra_meta_pages previous.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/checkpoint.c | 53 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index c32ed7c..e0ff75e 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -87,22 +87,36 @@ struct page *get_meta_page_ra(struct f2fs_sb_info *sbi, pgoff_t index)
 	return get_meta_page(sbi, index);
 }
 
-static inline block_t get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
+static inline bool is_valid_blkaddr(struct f2fs_sb_info *sbi,
+						block_t blkaddr, int type)
 {
 	switch (type) {
 	case META_NAT:
-		return NM_I(sbi)->max_nid / NAT_ENTRY_PER_BLOCK;
+		break;
 	case META_SIT:
-		return SIT_BLK_CNT(sbi);
+		if (unlikely(blkaddr >= SIT_BLK_CNT(sbi)))
+			return false;
+		break;
 	case META_SSA:
-		return MAIN_BLKADDR(sbi);
+		if (unlikely(blkaddr >= MAIN_BLKADDR(sbi) ||
+			blkaddr < SM_I(sbi)->ssa_blkaddr))
+			return false;
+		break;
 	case META_CP:
-		return SM_I(sbi)->sit_info->sit_base_addr;
+		if (unlikely(blkaddr >= SIT_I(sbi)->sit_base_addr ||
+			blkaddr < __start_cp_addr(sbi)))
+			return false;
+		break;
 	case META_POR:
-		return MAX_BLKADDR(sbi);
+		if (unlikely(blkaddr >= MAX_BLKADDR(sbi) ||
+			blkaddr < MAIN_BLKADDR(sbi)))
+			return false;
+		break;
 	default:
 		BUG();
 	}
+
+	return true;
 }
 
 /*
@@ -113,7 +127,6 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type
 	block_t prev_blk_addr = 0;
 	struct page *page;
 	block_t blkno = start;
-	block_t max_blks = get_max_meta_blks(sbi, type);
 
 	struct f2fs_io_info fio = {
 		.type = META,
@@ -123,18 +136,20 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type
 	for (; nrpages-- > 0; blkno++) {
 		block_t blk_addr;
 
+		if (!is_valid_blkaddr(sbi, blkno, type))
+			goto out;
+
 		switch (type) {
 		case META_NAT:
-			/* get nat block addr */
-			if (unlikely(blkno >= max_blks))
+			if (unlikely(blkno >=
+					NAT_BLOCK_OFFSET(NM_I(sbi)->max_nid)))
 				blkno = 0;
+			/* get nat block addr */
 			blk_addr = current_nat_addr(sbi,
 					blkno * NAT_ENTRY_PER_BLOCK);
 			break;
 		case META_SIT:
 			/* get sit block addr */
-			if (unlikely(blkno >= max_blks))
-				goto out;
 			blk_addr = current_sit_addr(sbi,
 					blkno * SIT_ENTRY_PER_BLOCK);
 			if (blkno != start && prev_blk_addr + 1 != blk_addr)
@@ -142,24 +157,8 @@ int ra_meta_pages(struct f2fs_sb_info *sbi, block_t start, int nrpages, int type
 			prev_blk_addr = blk_addr;
 			break;
 		case META_SSA:
-			if (unlikely(blkno >= max_blks))
-				goto out;
-			if (unlikely(blkno < SM_I(sbi)->ssa_blkaddr))
-				goto out;
-			blk_addr = blkno;
-			break;
 		case META_CP:
-			if (unlikely(blkno >= max_blks))
-				goto out;
-			if (unlikely(blkno < __start_cp_addr(sbi)))
-				goto out;
-			blk_addr = blkno;
-			break;
 		case META_POR:
-			if (unlikely(blkno >= max_blks))
-				goto out;
-			if (unlikely(blkno < MAIN_BLKADDR(sbi)))
-				goto out;
 			blk_addr = blkno;
 			break;
 		default:
-- 
2.1.2


