Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613Ab3GQW4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:56:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56854 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943Ab3GQW4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 055/145] ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()
Date: Wed, 17 Jul 2013 15:46:27 -0700
Message-Id: <1374101277-7915-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 64cb927371cd2ec43758d8a094a003d27bc3d0dc upstream.

Both ext3 and ext4 htree_dirblock_to_tree() is just filling the
in-core rbtree for use by call_filldir().  All updates of ->f_pos are
done by the latter; bumping it here (on error) is obviously wrong - we
might very well have it nowhere near the block we'd found an error in.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext3/namei.c | 7 ++-----
 fs/ext4/namei.c | 7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 890b894..3c7b413 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -577,11 +577,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
index f9ed946..6cda31e 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -890,11 +890,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
-- 
1.8.1.2

