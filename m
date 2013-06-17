Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab3FQPXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:23:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44698 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3FQPXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:23:40 -0400
Date: Mon, 17 Jun 2013 16:23:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [ext3,ext4] old bug in htree_dirblock_to_tree()
Message-ID: <20130617152338.GS4165@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Both ext3 and ext4 htree_dirblock_to_tree() is just filling
the in-core rbtree for use by call_filldir().  All updates of
->f_pos are done by the latter; bumping it here (on error) is obviously
wrong - we might very well have it nowhere near the block we'd found
an error in.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 7523c61f..998ea11 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -576,11 +576,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 		if (!ext3_check_dir_entry("htree_dirblock_to_tree", dir, de, bh,
 					(block<<EXT3_BLOCK_SIZE_BITS(dir->i_sb))
 						+((char *)de - bh->b_data))) {
-			/* On error, skip the f_pos to the next block. */
-			dir_file->f_pos = (dir_file->f_pos |
-					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse (bh);
-			return count;
+			/* silently ignore the rest of the block */
+			break;
 		}
 		ext3fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6653fc3..ab2f6dc 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -918,11 +918,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
 				bh->b_data, bh->b_size,
 				(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
 					 + ((char *)de - bh->b_data))) {
-			/* On error, skip the f_pos to the next block. */
-			dir_file->f_pos = (dir_file->f_pos |
-					(dir->i_sb->s_blocksize - 1)) + 1;
-			brelse(bh);
-			return count;
+			/* silently ignore the rest of the block */
+			break;
 		}
 		ext4fs_dirhash(de->name, de->name_len, hinfo);
 		if ((hinfo->hash < start_hash) ||
