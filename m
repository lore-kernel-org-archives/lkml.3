Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3GXOXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:23:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45794 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752350Ab3GXOGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Al Viro" <viro@zeniv.linux.org.uk>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.704800998@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [57/85] ext3,ext4: don't mess with dir_file->f_pos in
 htree_dirblock_to_tree()
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 64cb927371cd2ec43758d8a094a003d27bc3d0dc upstream.

Both ext3 and ext4 htree_dirblock_to_tree() is just filling the
in-core rbtree for use by call_filldir().  All updates of ->f_pos are
done by the latter; bumping it here (on error) is obviously wrong - we
might very well have it nowhere near the block we'd found an error in.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext3/namei.c | 7 ++-----
 fs/ext4/namei.c | 7 ++-----
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -585,11 +585,8 @@ static int htree_dirblock_to_tree(struct
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

