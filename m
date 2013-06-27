Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751068Ab3F0ERc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:17:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10837 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3F0ERa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:17:30 -0400
X-AuditID: cbfee68f-b7f436d000000f81-dd-51cbbcd80f78
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: remove reusing any prefree segments
Date: Thu, 27 Jun 2013 13:17:27 +0900
Message-id: <1372306648-26438-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t8zfd2be04HGmwptbi+6y+TxaVF7hZ7
	9p5ksbi8aw6bA4vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr4/i+kywF12Qrtn99
	y9rA+Fy8i5GTQ0LARGJuWwsThC0mceHeejYQW0hgGaPE+escMDUPT/8BquECii9ilLh49Ao7
	hNPGJDHrZydQhoODTUBbYvN+A5AGEQFmiQVTzzOC1DALTGCU+L/oPQtIQljATuLeyU3MIDaL
	gKpE79UWRhCbV8BdovfbamaIbboSi04cZAVplhB4zCZx/XcbO0SDgMS3yYdYQJZJCMhKbDoA
	VS8pcXDFDZYJjIILGBlWMYqmFiQXFCelFxnrFSfmFpfmpesl5+duYoQEYP8OxrsHrA8xJgON
	m8gsJZqcDwzgvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8x
	MnFwSjUw5ry/UrW8ofOh5LuO32+6H821ElMpDVki83Gv9rqeAzWH/t7P2LbEMPfwEzm5O2LF
	b4TyZG4H/vV/frv0/aFzx/6Hvjt8qOrnMf9zVxX1Jgib83zfem4Kz5nH3qePCZ6XuCl2qz5d
	qcqL//Y/b7Gn2/fLiNu1fRS8Obtq85bbsbFPFn8pV7EI/afEUpyRaKjFXFScCACuSD17VgIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAd0be04HGpw8aGlxfddfJotLi9wt
	9uw9yWJxedccNgcWj90LPjN59G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPG8X0nWQquyVZs//qWtYHxuXgXIyeHhICJxMPTf5ggbDGJC/fWs3UxcnEI
	CSxilLh49Ao7hNPGJDHrZydQFQcHm4C2xOb9BiANIgLMEgumnmcEqWEWmMAo8X/RexaQhLCA
	ncS9k5uYQWwWAVWJ3qstjCA2r4C7RO+31cwQ23QlFp04yDqBkXsBI8MqRtHUguSC4qT0XEO9
	4sTc4tK8dL3k/NxNjOAQfya1g3Flg8UhRgEORiUeXg+W04FCrIllxZW5hxglOJiVRHhDc4BC
	vCmJlVWpRfnxRaU5qcWHGJOBtk9klhJNzgfGX15JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOF
	BNITS1KzU1MLUotgtjBxcEo1MGbHVhTtK7zxP9xs7jHtmkMvBHSvHfieskhrYq8yf/2tWQ/v
	bvp7YhuHRn2j0o3lT7yXsdbv2fLylecN976GPSt8z4hEr+KdwRNj+6ry3jK2f+vPe5ie3+mj
	0aK8e8b+Z94Tlm7gWxgbFspe4s2yk+/3p+oLuTzeMTwnmyXPGsd3WOvMlluw/4ISS3FGoqEW
	c1FxIgAdkRgUtQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes check_prefree_segments initially designed to enhance the
performance by narrowing the range of LBA usage across the whole block device.

When allocating a new segment, previous f2fs tries to find proper prefree
segments, and then, if finds a segment, it reuses the segment for further
data or node block allocation.

However, I found that this was totally wrong approach since the prefree segments
have several data or node blocks that will be used by the roll-forward mechanism
operated after sudden-power-off.

Let's assume the following scenario.

/* write 8MB with fsync */
for (i = 0; i < 2048; i++) {
	offset = i * 4096;
	write(fd, offset, 4KB);
	fsync(fd);
}

In this case, naive segment allocation sequence will be like:
 data segment: x, x+1, x+2, x+3
 node segment: y, y+1, y+2, y+3.

But, if we can reuse prefree segments, the sequence can be like:
 data segment: x, x+1, y, y+1
 node segment: y, y+1, y+2, y+3.
Because, y, y+1, and y+2 became prefree segments one by one, and those are
reused by data allocation.

After conducting this workload, we should consider how to recover the latest
inode with its data.
If we reuse the prefree segments such as y or y+1, we lost the old node blocks
so that f2fs even cannot start roll-forward recovery.

Therefore, I suggest that we should remove reusing prefree segments.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/segment.c | 56 +------------------------------------------------------
 1 file changed, 1 insertion(+), 55 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 3ac4d29..a86d125 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -309,56 +309,6 @@ static void write_sum_page(struct f2fs_sb_info *sbi,
 	f2fs_put_page(page, 1);
 }
 
-static unsigned int check_prefree_segments(struct f2fs_sb_info *sbi, int type)
-{
-	struct dirty_seglist_info *dirty_i = DIRTY_I(sbi);
-	unsigned long *prefree_segmap = dirty_i->dirty_segmap[PRE];
-	unsigned int segno;
-	unsigned int ofs = 0;
-
-	/*
-	 * If there is not enough reserved sections,
-	 * we should not reuse prefree segments.
-	 */
-	if (has_not_enough_free_secs(sbi, 0))
-		return NULL_SEGNO;
-
-	/*
-	 * NODE page should not reuse prefree segment,
-	 * since those information is used for SPOR.
-	 */
-	if (IS_NODESEG(type))
-		return NULL_SEGNO;
-next:
-	segno = find_next_bit(prefree_segmap, TOTAL_SEGS(sbi), ofs);
-	ofs += sbi->segs_per_sec;
-
-	if (segno < TOTAL_SEGS(sbi)) {
-		int i;
-
-		/* skip intermediate segments in a section */
-		if (segno % sbi->segs_per_sec)
-			goto next;
-
-		/* skip if the section is currently used */
-		if (sec_usage_check(sbi, GET_SECNO(sbi, segno)))
-			goto next;
-
-		/* skip if whole section is not prefree */
-		for (i = 1; i < sbi->segs_per_sec; i++)
-			if (!test_bit(segno + i, prefree_segmap))
-				goto next;
-
-		/* skip if whole section was not free at the last checkpoint */
-		for (i = 0; i < sbi->segs_per_sec; i++)
-			if (get_seg_entry(sbi, segno + i)->ckpt_valid_blocks)
-				goto next;
-
-		return segno;
-	}
-	return NULL_SEGNO;
-}
-
 static int is_next_segment_free(struct f2fs_sb_info *sbi, int type)
 {
 	struct curseg_info *curseg = CURSEG_I(sbi, type);
@@ -597,11 +547,7 @@ static void allocate_segment_by_default(struct f2fs_sb_info *sbi,
 		goto out;
 	}
 
-	curseg->next_segno = check_prefree_segments(sbi, type);
-
-	if (curseg->next_segno != NULL_SEGNO)
-		change_curseg(sbi, type, false);
-	else if (type == CURSEG_WARM_NODE)
+	if (type == CURSEG_WARM_NODE)
 		new_curseg(sbi, type, false);
 	else if (curseg->alloc_type == LFS && is_next_segment_free(sbi, type))
 		new_curseg(sbi, type, false);
-- 
1.8.3.1.437.g0dbd812

