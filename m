Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab3CRFpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:45:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43953 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3CRFpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:45:38 -0400
X-AuditID: cbfee68d-b7f786d000005188-c7-5146aa00866a
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix to unlock node page when it was truncated
Date: Mon, 18 Mar 2013 14:44:42 +0900
Message-id: <1363585482-7630-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zI12GVW6BBjsfGVhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXHu1gz2gr/sFV/X
	LmBqYNzP1sXIySEhYCJxpuUxC4QtJnHh3nqgOBeHkMAyRonlty8zwRQd/bKSFSIxnVHi1Km5
	rCAJIYE2JokN58W6GDk42AS0JTbvNwAJiwgwSyyYep4RpJ5ZYAKjxP9F78E2CAu4SOx6uB5s
	KIuAqsTE9b/ZQWxeATeJnjkrWCGW6Uqs/v+cHaRZQuA+m8S2439YIRoEJL5NPsQCskxCQFZi
	0wFmiHpJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMkBHt3MN4+YH2I
	MRlo3ERmKdHkfGAI55XEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqT
	WnyIkYmDU6qBkdPH+45gmayN0aLKmLJuk1WHLxpEZPx/Lv96cZuR3eP8S5ENG46bCQj9OPl5
	VnO89D1rqQ/zUu+sOXtr/cKAymiuUPXTJT8vNkpuaJ01rfykwgOJN9Gz518rObpoD5v6ueqj
	RuXiU0xqj0una6yZFH399nTm/2WL1VV5npnsmrKIfXulFduxWUosxRmJhlrMRcWJAF+adqpX	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jQV2GVW6BBodX6lhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hx7tYM9oK/7BVf1y5gamDcz9bFyMkhIWAicfTLSlYIW0ziwr31QHEuDiGB
	6YwSp07NBUsICbQxSWw4L9bFyMHBJqAtsXm/AUhYRIBZYsHU84wg9cwCExgl/i96zwKSEBZw
	kdj1cD0TiM0ioCoxcf1vdhCbV8BNomfOCqhluhKr/z9nn8DIvYCRYRWjaGpBckFxUnquoV5x
	Ym5xaV66XnJ+7iZGcIA/k9rBuLLB4hCjAAejEg+vAY9roBBrYllxZe4hRgkOZiUR3oYQt0Ah
	3pTEyqrUovz4otKc1OJDjMlA2ycyS4km5wOjL68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGLtrpZbW+b/kym/cJ89vm/EzdOvSer+VfSZVATJ1zrGdrMoq
	5/cs/7DR85L6u3lrigTKWkMrpdhvcBz33VhUunxXy5Qji2UW58bP+/Hp/d+j+m2/vXRm71SU
	qYopSZEy5r5cnrp/ruaJE9P2+J8VkLD5MbFl1ZbWubqrDZl/M3EZlIZ+7pteqMRSnJFoqMVc
	VJwIAKl0zoe0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the node page was truncated, its block address became zero.
This means that we don't need to write the node page, but have to unlock
NODE_WRITE, decrease the number of dirty node pages, and then unlock_page
before returning the f2fs_write_node_page with zero.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e275218..3dc63f4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1106,15 +1106,15 @@ static int f2fs_write_node_page(struct page *page,
 
 	/* This page is already truncated */
 	if (ni.blk_addr == NULL_ADDR)
-		return 0;
+		goto out;
 
 	set_page_writeback(page);
 
 	/* insert node offset */
 	write_node_page(sbi, page, nid, ni.blk_addr, &new_addr);
 	set_node_addr(sbi, &ni, new_addr);
+out:
 	dec_page_count(sbi, F2FS_DIRTY_NODES);
-
 	mutex_unlock_op(sbi, NODE_WRITE);
 	unlock_page(page);
 	return 0;
-- 
1.8.1.3.566.gaa39828

