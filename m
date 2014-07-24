Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727AbaGXJsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:48:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54917 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934561AbaGXJsC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 068/128] ext4: Fix hole punching for files with indirect blocks
Date: Thu, 24 Jul 2014 10:45:17 +0100
Message-Id: <1406195177-8656-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/indirect.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index c40587735e58..0ade936f2b83 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -1319,16 +1319,24 @@ static int free_hole_blocks(handle_t *handle, struct inode *inode,
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
1.9.1

