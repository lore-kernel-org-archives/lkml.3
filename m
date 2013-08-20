Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab3HTKqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:46:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62814 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3HTKqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:46:11 -0400
X-AuditID: cbfee68e-b7f276d000002279-de-521348f045f6
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] f2fs: fix wrong BUG_ON condition
Date: Tue, 20 Aug 2013 19:46:04 +0900
Message-id: <1376995564-8691-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.3.1.437.g0dbd812
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zI90PHsJBBs/e6Flc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAldE97QZrwWKeiu67
	9xgbGP9ydjFyckgImEg8XrGCDcIWk7hwbz2QzcUhJLCMUWLBp/UsMEUfG/ayg9hCAosYJS4e
	5oIoamOS6P06i7GLkYODTUBbYvN+A5AaEQFmiQVTzzOC1DALTGCU+L/oPdggYQFDibnftoMN
	YhFQlTj6YSdYnFfATeJh5zx2iGW6EotOHGQFaZYQuM8mMe1GCxNEg4DEt8mHWECWSQjISmw6
	wAxRLylxcMUNlgmMggsYGVYxiqYWJBcUJ6UXGekVJ+YWl+al6yXn525ihIRg3w7GmwesDzEm
	A42byCwlmpwPDOG8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTBGtnqyLI2sfRD1QmzqAhkPA4PvK3lFJc1OrtW/VDs5co8xr5R2fiPLrgl7Fxpf
	Ztv0Wy/2z+lJ1XmXfh+wi/rlc8yIZa9qjakmd7j1hNn62x7qSb+XYzrM8DpRO0rj5pZZr2dc
	2KHq5RrB3MqgKTv7m6yerLwkv0zC2eDXPvV7paOzzRt3NyuxFGckGmoxFxUnAgAUkL/wVwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAd0PHsJBBrPPaFlc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jRPe0Ga8Finoruu/cYGxj/cnYxcnJICJhIfGzYyw5hi0lcuLeeDcQWEljE
	KHHxMFcXIxeQ3cYk0ft1FmMXIwcHm4C2xOb9BiA1IgLMEgumnmcEqWEWmMAo8X/RexaQhLCA
	ocTcb9vBhrIIqEoc/bATLM4r4CbxsHMe1DJdiUUnDrJOYORewMiwilE0tSC5oDgpPddIrzgx
	t7g0L10vOT93EyM4wJ9J72Bc1WBxiFGAg1GJh7dDSShIiDWxrLgy9xCjBAezkgjva0fhICHe
	lMTKqtSi/Pii0pzU4kOMyUDbJzJLiSbnA6MvryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC
	6YklqdmpqQWpRTBbmDg4pRoYqzwLEmRvXahPPDTlZeei7v+TFHljtzydva72yB/ObFMDodX+
	KUn6C4zFrF/w8nztKVzkFlvetFtIvL+j+X3DH0HzFaU7FxXd29+0do/WltnyCzecrYrd8OOB
	dKnY4f65t7f5f5t7YZduEFP3+3LmTzdbGJh3iWcWW+r0HWHof36snfH0ql99SizFGYmGWsxF
	xYkA4cFMIrQCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a false-alaramed BUG_ON.
The previous BUG_ON condition didn't cover the following true scenario.

In f2fs_add_link, 1) get_new_data_page gives an uptodate page successfully,
and then, 2) init_inode_metadata returns -ENOSPC.
At this moment, a new clean data page is remained in the page cache, but its
block address still indicates NEW_ADDR.
After then, even if sync is called, this clean data page cannot be written to
the disk due to the clean state.

So this means that get_lock_data_page should make a new empty page when its
block address is NEW_ADDR and its page is not uptodated.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/data.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ea3cb29..6b328de 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -259,8 +259,17 @@ repeat:
 	if (PageUptodate(page))
 		return page;
 
-	BUG_ON(dn.data_blkaddr == NEW_ADDR);
-	BUG_ON(dn.data_blkaddr == NULL_ADDR);
+	/*
+	 * A new dentry page is allocated but not able to be written, since its
+	 * new inode page couldn't be allocated due to -ENOSPC.
+	 * In such the case, its blkaddr can be remained as NEW_ADDR.
+	 * see, f2fs_add_link -> get_new_data_page -> init_inode_metadata.
+	 */
+	if (dn.data_blkaddr == NEW_ADDR) {
+		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+		SetPageUptodate(page);
+		return page;
+	}
 
 	err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
 	if (err)
-- 
1.8.3.1.437.g0dbd812

