Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772Ab3APQIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:08:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36662 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab3APQIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:08:10 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Forrest Liu <forrestl@synology.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 165/222] ext4: fix extent tree corruption caused by hole punch
Date: Wed, 16 Jan 2013 13:56:05 -0200
Message-Id: <1358351822-7675-166-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forrest Liu <forrestl@synology.com>

commit c36575e663e302dbaa4d16b9c72d2c9a913a9aef upstream.

When depth of extent tree is greater than 1, logical start value of
interior node is not correctly updated in ext4_ext_rm_idx.

Signed-off-by: Forrest Liu <forrestl@synology.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Ashish Sangwan <ashishsangwan2@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/ext4/extents.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 844e11e..8e5dd3b 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2177,13 +2177,14 @@ ext4_ext_in_cache(struct inode *inode, ext4_lblk_t block,
  * removes index from the index block.
  */
 static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
-			struct ext4_ext_path *path)
+			struct ext4_ext_path *path, int depth)
 {
 	int err;
 	ext4_fsblk_t leaf;
 
 	/* free index block */
-	path--;
+	depth--;
+	path = path + depth;
 	leaf = ext4_idx_pblock(path->p_idx);
 	if (unlikely(path->p_hdr->eh_entries == 0)) {
 		EXT4_ERROR_INODE(inode, "path->p_hdr->eh_entries == 0");
@@ -2208,6 +2209,19 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
 
 	ext4_free_blocks(handle, inode, NULL, leaf, 1,
 			 EXT4_FREE_BLOCKS_METADATA | EXT4_FREE_BLOCKS_FORGET);
+
+	while (--depth >= 0) {
+		if (path->p_idx != EXT_FIRST_INDEX(path->p_hdr))
+			break;
+		path--;
+		err = ext4_ext_get_access(handle, inode, path);
+		if (err)
+			break;
+		path->p_idx->ei_block = (path+1)->p_idx->ei_block;
+		err = ext4_ext_dirty(handle, inode, path);
+		if (err)
+			break;
+	}
 	return err;
 }
 
@@ -2541,7 +2555,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	/* if this leaf is free, then we should
 	 * remove it from index block above */
 	if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
-		err = ext4_ext_rm_idx(handle, inode, path + depth);
+		err = ext4_ext_rm_idx(handle, inode, path, depth);
 
 out:
 	return err;
@@ -2742,7 +2756,7 @@ cont:
 				/* index is empty, remove it;
 				 * handle must be already prepared by the
 				 * truncatei_leaf() */
-				err = ext4_ext_rm_idx(handle, inode, path + i);
+				err = ext4_ext_rm_idx(handle, inode, path, i);
 			}
 			/* root level has p_bh == NULL, brelse() eats this */
 			brelse(path[i].p_bh);
-- 
1.7.9.5

