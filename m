Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab3AMRxt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:53:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34979 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755344Ab3AMRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:27 -0500
Message-Id: <20130113174255.968441684@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:42:56 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Forrest Liu <forrestl@synology.com>, "Theodore Tso" <tytso@mit.edu>,
        Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [ 01/49] ext4: fix extent tree corruption caused by hole punch
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forrest Liu <forrestl@synology.com>

commit c36575e663e302dbaa4d16b9c72d2c9a913a9aef upstream.

When depth of extent tree is greater than 1, logical start value of
interior node is not correctly updated in ext4_ext_rm_idx.

Signed-off-by: Forrest Liu <forrestl@synology.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Ashish Sangwan <ashishsangwan2@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/extents.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 26af228..5ae1674 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2226,13 +2226,14 @@ errout:
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
@@ -2257,6 +2258,19 @@ static int ext4_ext_rm_idx(handle_t *handle, struct inode *inode,
 
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
 
@@ -2599,7 +2613,7 @@ ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 	/* if this leaf is free, then we should
 	 * remove it from index block above */
 	if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
-		err = ext4_ext_rm_idx(handle, inode, path + depth);
+		err = ext4_ext_rm_idx(handle, inode, path, depth);
 
 out:
 	return err;
@@ -2802,7 +2816,7 @@ again:
 				/* index is empty, remove it;
 				 * handle must be already prepared by the
 				 * truncatei_leaf() */
-				err = ext4_ext_rm_idx(handle, inode, path + i);
+				err = ext4_ext_rm_idx(handle, inode, path, i);
 			}
 			/* root level has p_bh == NULL, brelse() eats this */
 			brelse(path[i].p_bh);


