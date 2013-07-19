Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935074Ab3GSCXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 22:23:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934875Ab3GSCXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 22:23:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 02/18] ext3,ext4: dont mess with dir_file->f_pos in htree_dirblock_to_tree()
Date: Thu, 18 Jul 2013 19:23:17 -0700
Message-Id: <20130719021049.132514575@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719021048.965829361@linuxfoundation.org>
References: <20130719021048.965829361@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 64cb927371cd2ec43758d8a094a003d27bc3d0dc upstream.

Both ext3 and ext4 htree_dirblock_to_tree() is just filling the
in-core rbtree for use by call_filldir().  All updates of ->f_pos are
done by the latter; bumping it here (on error) is obviously wrong - we
might very well have it nowhere near the block we'd found an error in.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext3/namei.c |    7 ++-----
 fs/ext4/namei.c |    7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -584,11 +584,8 @@ static int htree_dirblock_to_tree(struct
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
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -585,11 +585,8 @@ static int htree_dirblock_to_tree(struct
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
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


