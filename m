Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab3FHMZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 08:25:51 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:55667 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212Ab3FHMZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 08:25:48 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 4/4] f2fs: optimise the truncate_data_blocks_range() range.
Date: Sat,  8 Jun 2013 21:25:40 +0900
Message-Id: <1370694340-2842-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

The function truncate_data_blocks_range() decrements the valid
block count of inode via dec_valid_block_count(). Since this
function updates the i_blocks field of inode, we can update this
field once we have calculated total the number of blocks
to be freed.

Therefore we can decrement valid blocks outside of the for loop.

if (nr_free) {
+dec_valid_block_count(sbi, dn->inode, nf_free)
                set_page_dirty(dn->node_page);
                sync_inode_page(dn);
        }
'nr_free' tells the total number of blocks freed.So, we can
just directly pass this value to dec_valid_block_count() and update
the i_blocks.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 6071ff5..1c5362b 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -185,10 +185,10 @@ int truncate_data_blocks_range(struct dnode_of_data *dn, int count)
 
 		update_extent_cache(NULL_ADDR, dn);
 		invalidate_blocks(sbi, blkaddr);
-		dec_valid_block_count(sbi, dn->inode, 1);
 		nr_free++;
 	}
 	if (nr_free) {
+		dec_valid_block_count(sbi, dn->inode, nr_free);
 		set_page_dirty(dn->node_page);
 		sync_inode_page(dn);
 	}
-- 
1.7.9.5

