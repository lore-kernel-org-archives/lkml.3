Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab3AOXsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:48:00 -0500
Received: from mail.kernel.org ([198.145.19.201]:45902 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933130Ab3AOWuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Forrest Liu <forrestl@synology.com>, "Theodore Tso" <tytso@mit.edu>,
        Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [ 057/171] ext4: fix extent tree corruption caused by hole punch
Date: Tue, 15 Jan 2013 14:43:42 -0800
Message-Id: <20130115224317.535739341@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Forrest Liu <forrestl@synology.com>

commit c36575e663e302dbaa4d16b9c72d2c9a913a9aef upstream.

When depth of extent tree is greater than 1, logical start value of
interior node is not correctly updated in ext4_ext_rm_idx.

Signed-off-by: Forrest Liu <forrestl@synology.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Ashish Sangwan <ashishsangwan2@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2110,13 +2110,14 @@ ext4_ext_in_cache(struct inode *inode, e
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
@@ -2141,6 +2142,19 @@ static int ext4_ext_rm_idx(handle_t *han
 
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
 
@@ -2474,7 +2488,7 @@ ext4_ext_rm_leaf(handle_t *handle, struc
 	/* if this leaf is free, then we should
 	 * remove it from index block above */
 	if (err == 0 && eh->eh_entries == 0 && path[depth].p_bh != NULL)
-		err = ext4_ext_rm_idx(handle, inode, path + depth);
+		err = ext4_ext_rm_idx(handle, inode, path, depth);
 
 out:
 	return err;
@@ -2675,7 +2689,7 @@ cont:
 				/* index is empty, remove it;
 				 * handle must be already prepared by the
 				 * truncatei_leaf() */
-				err = ext4_ext_rm_idx(handle, inode, path + i);
+				err = ext4_ext_rm_idx(handle, inode, path, i);
 			}
 			/* root level has p_bh == NULL, brelse() eats this */
 			brelse(path[i].p_bh);


