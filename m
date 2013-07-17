Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694Ab3GQW5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:57:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56914 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934668Ab3GQW5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:57:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maarten ter Huurne <maarten@treewalker.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 053/145] ext4: fix corruption when online resizing a fs with 1K block size
Date: Wed, 17 Jul 2013 15:46:25 -0700
Message-Id: <1374101277-7915-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maarten ter Huurne <maarten@treewalker.org>

commit 6ca792edc13c409e8d4eb9001e048264c6a2eb64 upstream.

Subtracting the number of the first data block places the superblock
backups one block too early, corrupting the file system. When the block
size is larger than 1K, the first data block is 0, so the subtraction
has no effect and no corruption occurs.

Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/resize.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 0cfa2f4..28d5f2c 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1654,12 +1654,10 @@ errout:
 		err = err2;
 
 	if (!err) {
-		ext4_fsblk_t first_block;
-		first_block = ext4_group_first_block_no(sb, 0);
 		if (test_opt(sb, DEBUG))
 			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
 			       "blocks\n", ext4_blocks_count(es));
-		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr - first_block,
+		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr,
 			       (char *)es, sizeof(struct ext4_super_block), 0);
 	}
 	return err;
-- 
1.8.1.2

