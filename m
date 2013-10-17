Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab3JQIbv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 04:31:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39996 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3JQIbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 04:31:48 -0400
X-AuditID: cbfee68e-b7f486d0000040b6-c4-525fa071cefe
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: avoid to write during the recovery
Date: Thu, 17 Oct 2013 17:31:12 +0900
Message-id: <1381998672-19014-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zQ93CBfFBBo2HZSyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgymhacIKt4BF/xebd
	09kaGP/wdDFyckgImEhcvjKFGcIWk7hwbz1bFyMXh5DAMkaJ1fsfsMIULe3uZIZILGKUePy8
	kxXCaWaSWN/0D6iFg4NNQFti834DkAYRAWaJBVPPM4LUMAtMYJT4v+g9C0iNsIClRMeJLJAa
	FgFViUeX+xlBbF4Bd4mml8dZIJZpS2x7PhGsV0LgPpvEjK8L2CAaBCS+TT4ENkdCQFZi0wGo
	qyUlDq64wTKBUXABI8MqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJAQ7NvBePOA9SHGZKBx
	E5mlRJPzgSGcVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFG
	Jg5OqQbG2oIOWZm6BVkXz066ZuH+O8fu2DlPW5WaYzq/Z+V0Xreaz7/ism3RzfkyAZY2Hrvv
	nglfbcB6XCz6pMTTePWVhp1O9sKrJ9X5nVFzYzotpZngk86j9702/WpNcs1c9sVFeyZ/kHog
	dz5y82rn6284w0SChV5PnL7kpcpctZkc6flnl8177rlMiaU4I9FQi7moOBEAFeJu4VcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd3CBfFBBr+XSlhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jRtOAEW8Ej/orNu6ezNTD+4eli5OSQEDCRWNrdyQxhi0lcuLeerYuRi0NI
	YBGjxOPnnawQTjOTxPqmf0AZDg42AW2JzfsNQBpEBJglFkw9zwhSwywwgVHi/6L3LCA1wgKW
	Eh0nskBqWARUJR5d7mcEsXkF3CWaXh5ngVimLbHt+UTGCYzcCxgZVjGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEB/gz6R2MqxosDjEKcDAq8fDOWB4XJMSaWFZcmXuIUYKDWUmE98S0+CAh
	3pTEyqrUovz4otKc1OJDjMlA2ycyS4km5wOjL68k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGI02S9b2u7gUcvPOfxChJtWwaNfLBVIbZcULShO0zhyW2im6
	WP6yUdTpD80K16euq85xcTU4Z3Iva/E8bTutPzpsXw9YB/3+2ve1s2Sq8+VXK0yyFN/r7Jbq
	qBBQ1mR/Gdoiu/vePsNGm6U8P5MmTqru7lLeUjd102H5PcrCzT7iu2cJPkl+r8RSnJFoqMVc
	VJwIAPp0ejK0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enhances the recovery routine not to write any data/node/meta until
its completion.
If any writes are sent to the disk, it could contaminate the written history
that will be used for further recovery.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/checkpoint.c |  2 +-
 fs/f2fs/node.c       | 17 +++++++++++------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 2a5999d..8d16071 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -81,7 +81,7 @@ static int f2fs_write_meta_page(struct page *page,
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 
 	/* Should not write any meta pages, if any IO error was occurred */
-	if (wbc->for_reclaim ||
+	if (wbc->for_reclaim || sbi->por_doing ||
 			is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ERROR_FLAG)) {
 		dec_page_count(sbi, F2FS_DIRTY_META);
 		wbc->pages_skipped++;
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 51ef278..ef80f79 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1156,6 +1156,9 @@ static int f2fs_write_node_page(struct page *page,
 	block_t new_addr;
 	struct node_info ni;
 
+	if (sbi->por_doing)
+		goto redirty_out;
+
 	wait_on_page_writeback(page);
 
 	/* get old block addr of this node page */
@@ -1171,12 +1174,8 @@ static int f2fs_write_node_page(struct page *page,
 		return 0;
 	}
 
-	if (wbc->for_reclaim) {
-		dec_page_count(sbi, F2FS_DIRTY_NODES);
-		wbc->pages_skipped++;
-		set_page_dirty(page);
-		return AOP_WRITEPAGE_ACTIVATE;
-	}
+	if (wbc->for_reclaim)
+		goto redirty_out;
 
 	mutex_lock(&sbi->node_write);
 	set_page_writeback(page);
@@ -1186,6 +1185,12 @@ static int f2fs_write_node_page(struct page *page,
 	mutex_unlock(&sbi->node_write);
 	unlock_page(page);
 	return 0;
+
+redirty_out:
+	dec_page_count(sbi, F2FS_DIRTY_NODES);
+	wbc->pages_skipped++;
+	set_page_dirty(page);
+	return AOP_WRITEPAGE_ACTIVATE;
 }
 
 /*
-- 
1.8.4.474.g128a96c

