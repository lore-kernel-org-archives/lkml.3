Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab3IZRcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:32:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:59167 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3IZRcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:32:14 -0400
Subject: [PATCH] ext4: avoid exposure of stale data in ext4_punch_hole()
To: tytso@mit.edu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Sep 2013 21:32:07 +0400
Message-ID: <20130926173113.23276.77451.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While handling punch-hole fallocate, it's useless to truncate page cache
before removing the range from extent tree (or block map in indirect case)
because page cache can be re-populated (by read-ahead or read(2) or mmap-ed
read) immediately after truncating page cache, but before updating extent
tree (or block map). In that case the user will see stale data even after
fallocate is completed.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/ext4/inode.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0d424d7..6b71116 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3564,14 +3564,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 
 	}
 
-	first_block_offset = round_up(offset, sb->s_blocksize);
-	last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
-
-	/* Now release the pages and zero block aligned part of pages*/
-	if (last_block_offset > first_block_offset)
-		truncate_pagecache_range(inode, first_block_offset,
-					 last_block_offset);
-
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	ext4_inode_block_unlocked_dio(inode);
 	inode_dio_wait(inode);
@@ -3621,6 +3613,15 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 	up_write(&EXT4_I(inode)->i_data_sem);
 	if (IS_SYNC(inode))
 		ext4_handle_sync(handle);
+
+	first_block_offset = round_up(offset, sb->s_blocksize);
+	last_block_offset = round_down((offset + length), sb->s_blocksize) - 1;
+
+	/* Now release the pages and zero block aligned part of pages */
+	if (last_block_offset > first_block_offset)
+		truncate_pagecache_range(inode, first_block_offset,
+					 last_block_offset);
+
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 out_stop:

