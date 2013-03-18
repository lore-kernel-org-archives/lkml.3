Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab3CRFyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:54:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34800 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3CRFym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:54:42 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-2d-5146ac1877f0
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix not to allocate max_nid
Date: Mon, 18 Mar 2013 14:53:48 +0900
Message-id: <1363586028-8617-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t8zI12JNW6BBmtOmlrs2XuSxeLyrjls
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXsnjOBsWAbR8XZN1ENjI/Zuhg5OSQETCRWtVxkhLDF
	JC7cWw8U5+IQEljGKPGw5yo7TNGhLZOYIRKLGCU+dr1hBUkICbQxSRxbF97FyMHBJqAtsXm/
	AUhYRIBZYsHU84wg9cwCExgl/i96zwKSEBYwkjjydTs7SD2LgKrE9IvVIGFeATeJU2cOQh2h
	K7H6/3N2kF4JgSNsEqua7jOBJFgEBCS+TT7EAtIrISArsekAM0S9pMTBFTdYJjAKLmBkWMUo
	mlqQXFCclF5kqlecmFtcmpeul5yfu4kRElgTdzDeP2B9iDEZaNxEZinR5HxgYOaVxBsamxlZ
	mJqYGhuZW5qRJqwkzqveYh0oJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXFd3BWjb6eC/Z52
	b30w05JroY294h+faxdCvjcf2JQoFF1nu46f82CazPfKj6/vS2tf5HfKX/tmor6YvUWH6rHe
	c8skD8wIMkt7uGJXn8PapVNeT7puX8Fcl8Uj1l33be2DjZE2Mmum1+3Nrnp+7PuDHjaxmzys
	3w+o7DkkX81km8Z7zan3lKUSS3FGoqEWc1FxIgCIdnMwQgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphkeLIzCtJLcpLzFFi42I5/e+xgK7EGrdAg9P7DCz27D3JYnF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzds+ZwFiwjaPi
	7Buggx6zdTFyckgImEgc2jKJGcIWk7hwbz1QnItDSGARo8THrjesIAkhgTYmiWPrwrsYOTjY
	BLQlNu83AAmLCDBLLJh6nhGknllgAqPE/0XvWUASwgJGEke+bmcHqWcRUJWYfrEaJMwr4CZx
	6sxBRohduhKr/z9nn8DIvYCRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcNg+k9rBuLLB
	4hCjAAejEg+vAY9roBBrYllxZe4hRgkOZiUR3oYQt0Ah3pTEyqrUovz4otKc1OJDjMlAyycy
	S4km5wNjKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGCfN
	8cjdeeHoSQNBH0meJ7K1IbGp145Oqjzso5Hs/+utnSbHhEVdC7NsNnC//chUse6q58JDqfL7
	i0/tvB5/dU3w1r+lf68pMRarXV8X/drk0y6eKQri71dw34z/lLGi/ay7vOmk5wvncx+X8T/g
	e2jGpKyQOXLJywMifu4Pbd2m+o5vl8k/JyMlluKMREMt5qLiRAAQJ+ginwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The build_free_nid should not add free nids over nm_i->max_nid.
But, there was a hole that invalid free nid was added by the following scenario.

Let's suppose nm_i->max_nid = 150 and the last NAT page has 100 ~ 200 nids.

build_free_nids
  - get_current_nat_page loads the last NAT page
  - scan_nat_page can add 100 ~ 200 nids
    -> Bug here!
So, when scanning an NAT page, we should check each candidate whether it is
over max_nid or not.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index c60919f..3fb6dfe 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1270,6 +1270,8 @@ static int scan_nat_page(struct f2fs_nm_info *nm_i,
 	i = start_nid % NAT_ENTRY_PER_BLOCK;
 
 	for (; i < NAT_ENTRY_PER_BLOCK; i++, start_nid++) {
+		if (start_nid >= nm_i->max_nid)
+			return fcnt;
 		blk_addr  = le32_to_cpu(nat_blk->entries[i].block_addr);
 		BUG_ON(blk_addr == NEW_ADDR);
 		if (blk_addr == NULL_ADDR)
-- 
1.8.1.3.566.gaa39828

