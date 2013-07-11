Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab3GKOZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:25:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42891 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab3GKOZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 17/98] ext3,ext4: don't mess with dir_file->f_pos in htree_dirblock_to_tree()
Date: Thu, 11 Jul 2013 15:23:47 +0100
Message-Id: <1373552708-15235-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 64cb927371cd2ec43758d8a094a003d27bc3d0dc upstream.

Both ext3 and ext4 htree_dirblock_to_tree() is just filling the
in-core rbtree for use by call_filldir().  All updates of ->f_pos are
done by the latter; bumping it here (on error) is obviously wrong - we
might very well have it nowhere near the block we'd found an error in.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext3/namei.c | 7 ++-----
 fs/ext4/namei.c | 7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index eeb63df..336256a 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -573,11 +573,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
index 20c13eb..43a35db 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -859,11 +859,8 @@ static int htree_dirblock_to_tree(struct file *dir_file,
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
-- 
1.8.1.2

