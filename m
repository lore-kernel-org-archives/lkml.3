Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161374AbaGRN1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:27:17 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17908 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935179AbaGRNRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:17:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 110/170] ext4: Fix hole punching for files with indirect blocks
Date: Fri, 18 Jul 2014 14:11:55 +0200
Message-Id: <da4b5edf217160f07f288b484185d83cbfb8852a.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a93cd4cf86466caa49cfe64607bea7f0bde3f916 upstream.

Hole punching code for files with indirect blocks wrongly computed
number of blocks which need to be cleared when traversing the indirect
block tree. That could result in punching more blocks than actually
requested and thus effectively cause a data loss. For example:

fallocate -n -p 10240000 4096

will punch the range 10240000 - 12632064 instead of the range 1024000 -
10244096. Fix the calculation.

Fixes: 8bad6fc813a3a5300f51369c39d315679fd88c72
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/indirect.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 3b91d240da4d..e6574d7b6642 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1318,16 +1318,24 @@ static int free_hole_blocks(handle_t *handle, struct inode *inode,
 		blk = *i_data;
 		if (level > 0) {
 			ext4_lblk_t first2;
+			ext4_lblk_t count2;
+
 			bh = sb_bread(inode->i_sb, le32_to_cpu(blk));
 			if (!bh) {
 				EXT4_ERROR_INODE_BLOCK(inode, le32_to_cpu(blk),
 						       "Read failure");
 				return -EIO;
 			}
-			first2 = (first > offset) ? first - offset : 0;
+			if (first > offset) {
+				first2 = first - offset;
+				count2 = count;
+			} else {
+				first2 = 0;
+				count2 = count - (offset - first);
+			}
 			ret = free_hole_blocks(handle, inode, bh,
 					       (__le32 *)bh->b_data, level - 1,
-					       first2, count - offset,
+					       first2, count2,
 					       inode->i_sb->s_blocksize >> 2);
 			if (ret) {
 				brelse(bh);
-- 
2.0.0

