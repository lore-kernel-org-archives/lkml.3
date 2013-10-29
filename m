Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3J2Gvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 02:51:37 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33247 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab3J2Gve convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 02:51:34 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-02-526f5af51d8f
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?utf-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
Subject: [f2fs-dev] [PATCH V2 RESEND] f2fs: check all ones or zeros bitmap with
 bitops for better mount performance
Date: Tue, 29 Oct 2013 14:50:40 +0800
Message-id: <001f01ced473$4c5cc9c0$e5165d40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac7UcSgd2JyePsh+Q3mS8r2J+QYRfw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd2vUflBBjM38Fhc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxvM9a5kL
	+gUqNt7dztrAOIG3i5GTQ0LAROLutv+MELaYxIV769lAbCGB6YwSrZ1GXYxcQPYPRom3/bvB
	EmwCKhLLO/4zgdgiAtISsz7NYwEpYhaYzSjR8+UZ2CRhgVKJV+vmgzWwCKhKLLrRBmbzClhK
	TPnQyA5hC0r8mHwPqJkDqFldYsqUXJAws4C2xJN3F1ghDlKQ2HH2NSPELj2J28vaWCFqxCU2
	HrnFMoFRYBaSSbMQJs1CMmkWko4FjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYID+pn0
	DsZVDRaHGAU4GJV4eC3Y8oOEWBPLiitzDzFKcDArifDuCAYK8aYkVlalFuXHF5XmpBYfYpTm
	YFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYOzsuHC2/wSjd1BYuuXFqec0ezlqkt3Ot/E3
	/8oxLX58yep0aum27VxrLj6tfral5LXVS0H9g6mvNC/uz7uutsiWxW3/o4Xnfr18vTtCtKr2
	6/bO6KXhavIBe7tvBz+3VjV5HvROcNqHBP66EwHrF2aFnmc3MLxepbP15MrFG249PC0Ru+Ds
	JTUlluKMREMt5qLiRAA7kMslZAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, check_block_count check valid_map with bit data type in common scenario that sit has all ones or zeros bitmap, it makes low mount performance.
So let's check the special bitmap with integer data type instead of the bit one.

v1-->v2:
    use find_next_{zero_}bit_le for better performance and readable as Jaegeuk suggested.
	use neat logogram in comment as Gu Zheng suggested.
	search continuous ones or zeros for better performance when checking mixed bitmap.

Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Signed-off-by: Shu Tan <shu.tan@samsung.com>
Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/segment.h |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index abe7094..a7abfa8 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -550,8 +550,9 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
 {
 	struct f2fs_sm_info *sm_info = SM_I(sbi);
 	unsigned int end_segno = sm_info->segment_count - 1;
+	bool is_valid  = test_bit_le(0, raw_sit->valid_map) ? true : false;
 	int valid_blocks = 0;
-	int i;
+	int cur_pos = 0, next_pos;
 
 	/* check segment usage */
 	BUG_ON(GET_SIT_VBLOCKS(raw_sit) > sbi->blocks_per_seg);
@@ -560,9 +561,19 @@ static inline void check_block_count(struct f2fs_sb_info *sbi,
 	BUG_ON(segno > end_segno);
 
 	/* check bitmap with valid block count */
-	for (i = 0; i < sbi->blocks_per_seg; i++)
-		if (f2fs_test_bit(i, raw_sit->valid_map))
-			valid_blocks++;
+	do {
+		if (is_valid) {
+			next_pos = find_next_zero_bit_le(&raw_sit->valid_map,
+					sbi->blocks_per_seg,
+					cur_pos);
+			valid_blocks += next_pos - cur_pos;
+		} else
+			next_pos = find_next_bit_le(&raw_sit->valid_map,
+					sbi->blocks_per_seg,
+					cur_pos);
+		cur_pos = next_pos;
+		is_valid = !is_valid;
+	} while (cur_pos < sbi->blocks_per_seg);
 	BUG_ON(GET_SIT_VBLOCKS(raw_sit) != valid_blocks);
 }
 
-- 
1.7.9.5

