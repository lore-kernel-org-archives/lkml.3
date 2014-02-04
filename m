Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaBDEtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 23:49:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58609 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaBDEsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 23:48:16 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-2a-52f0710ee46f
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 1/2] f2fs: fix the potential mismatch between dir's i_size and
 i_blocks
Date: Tue, 04 Feb 2014 13:46:43 +0900
Message-id: <1391489204-19695-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t8zA12+wg9BBjNWSlhc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXF98QqmgvV8Fa8X
	32JtYDzB1cXIySEhYCIx6c4UNghbTOLCvfVANheHkMAyRolDi2cywhQd3XyZBSKxiFFix98W
	ZpCEkEATk8TH3oouRg4ONgFtic37DUDCIgLMEgumnmcEqWcWmMAo8X/RexaQhLBApMSvK1OZ
	QGwWAVWJAwvngs3hFXCX2D67gRVimbbEtucTwZolBB6zSWz7+AKqQUDi2+RDLCDLJARkJTYd
	YIaol5Q4uOIGywRGwQWMDKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQkKwdwfj7QPWhxiT
	gcZNZJYSTc4HhnBeSbyhsZmRhamJqbGRuaUZacJK4rxJD5OChATSE0tSs1NTC1KL4otKc1KL
	DzEycXBKNTDqeG6yVWl+LJdpm60vtOJ4WKoah2T81lRLPtGz9QaX1WPfe/Af2iYu0MbX/Uty
	4aEOL77XLJdaVpbMT12l5MqjM113DuMBm1XuO8pLEsVqo664xRZ87JwlqMb5rvQuG7P+mdju
	x35hUw1qtsQt1dpjqtqwLeL/ednFx34fSGJYryKz7NPGt0osxRmJhlrMRcWJALc8zJtXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIIsWRmVeSWpSXmKPExsVy+t9jAV2+wg9BBlvWi1hc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5hxffEKpoL1fBWvF99ibWA8wdXFyMkhIWAicXTzZRYIW0ziwr31bF2MXBxC
	AosYJXb8bWEGSQgJNDFJfOyt6GLk4GAT0JbYvN8AJCwiwCyxYOp5RpB6ZoEJjBL/F70HGyQs
	ECnx68pUJhCbRUBV4sDCuWBzeAXcJbbPbmCFWKYtse35RMYJjNwLGBlWMYqmFiQXFCel5xrq
	FSfmFpfmpesl5+duYgQH+DOpHYwrGywOMQpwMCrx8CqofAgSYk0sK67MPcQowcGsJMJ70AIo
	xJuSWFmVWpQfX1Sak1p8iDEZaPtEZinR5Hxg9OWVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQ
	SCA9sSQ1OzW1ILUIZgsTB6dUA2Nd9vHuqHmhEw580ly9tXTNE7Wbd0V+tNtF3jG/YSd9lP/1
	pbXrnykXsjTJcDXc11ZcYp63dsHuZ0c0/jEXPe2cscapra64d95m/S3brI+s3dnQv2XS8QVv
	o6oyz3xvi4+K7KnfoBX7vljBpEPtBsf15/uM4q7W71O+Vp4dk2xSMFMkYh7Hsv1KLMUZiYZa
	zEXFiQA2DvXYtAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the erroneous scenario.

                             i_size    on-disk i_size    i_blocks
__f2fs_add_link()             4096           4096           2
 get_new_data_page            8192           4096           3
 -ENOSPC = init_inode_metadata
 checkpoint                     -            4096           3
 POR and reboot

__f2fs_add_link()             4096           4096           3
 page = get_new_data_page (page->index = 1 by NEW_ADDR)
 add a dentry to the page successfully

f2fs_rmdir()
 f2fs_empty_dir()             4096           4096           3
 f2fs_unlink() goes, since there is no valid dentry due to i_size = 4096.
 But, still there is one dentry in page->index = 1.

So this patch moves the code to write dir->i_size into on-disk i_size in order
to sync dir's i_size, on-disk i_size, and its i_blocks.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/dir.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 2b7c255..bfcb4ae 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -395,9 +395,6 @@ static void update_parent_metadata(struct inode *dir, struct inode *inode,
 		set_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
 	}
 
-	if (is_inode_flag_set(F2FS_I(dir), FI_UPDATE_DIR))
-		update_inode_page(dir);
-
 	if (is_inode_flag_set(F2FS_I(inode), FI_INC_LINK))
 		clear_inode_flag(F2FS_I(inode), FI_INC_LINK);
 }
@@ -511,7 +508,10 @@ add_dentry:
 
 	update_parent_metadata(dir, inode, current_depth);
 fail:
-	clear_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
+	if (is_inode_flag_set(F2FS_I(dir), FI_UPDATE_DIR)) {
+		update_inode_page(dir);
+		clear_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
+	}
 	kunmap(dentry_page);
 	f2fs_put_page(dentry_page, 1);
 	return err;
-- 
1.8.4.474.g128a96c

