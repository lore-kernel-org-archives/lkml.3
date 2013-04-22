Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab3DVOkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:40:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51590 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754910Ab3DVOaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:30:13 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Mason" <chris.mason@fusionio.com>,
        "Josef Bacik" <jbacik@fusionio.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.30729068@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [39/75] Btrfs: make sure nbytes are right after log replay
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 4bc4bee4595662d8bff92180d5c32e3313a704b0 upstream.

While trying to track down a tree log replay bug I noticed that fsck was always
complaining about nbytes not being right for our fsynced file.  That is because
the new fsync stuff doesn't wait for ordered extents to complete, so the inodes
nbytes are not necessarily updated properly when we log it.  So to fix this we
need to set nbytes to whatever it is on the inode that is on disk, so when we
replay the extents we can just add the bytes that are being added as we replay
the extent.  This makes it work for the case that we have the wrong nbytes or
the case that we logged everything and nbytes is actually correct.  With this
I'm no longer getting nbytes errors out of btrfsck.

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Chris Mason <chris.mason@fusionio.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/btrfs/tree-log.c |   48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -316,6 +316,7 @@ static noinline int overwrite_item(struc
 	unsigned long src_ptr;
 	unsigned long dst_ptr;
 	int overwrite_root = 0;
+	bool inode_item = key->type == BTRFS_INODE_ITEM_KEY;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
 		overwrite_root = 1;
@@ -325,6 +326,9 @@ static noinline int overwrite_item(struc
 
 	/* look for the key in the destination tree */
 	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	if (ret < 0)
+		return ret;
+
 	if (ret == 0) {
 		char *src_copy;
 		char *dst_copy;
@@ -366,6 +370,30 @@ static noinline int overwrite_item(struc
 			return 0;
 		}
 
+		/*
+		 * We need to load the old nbytes into the inode so when we
+		 * replay the extents we've logged we get the right nbytes.
+		 */
+		if (inode_item) {
+			struct btrfs_inode_item *item;
+			u64 nbytes;
+
+			item = btrfs_item_ptr(path->nodes[0], path->slots[0],
+					      struct btrfs_inode_item);
+			nbytes = btrfs_inode_nbytes(path->nodes[0], item);
+			item = btrfs_item_ptr(eb, slot,
+					      struct btrfs_inode_item);
+			btrfs_set_inode_nbytes(eb, item, nbytes);
+		}
+	} else if (inode_item) {
+		struct btrfs_inode_item *item;
+
+		/*
+		 * New inode, set nbytes to 0 so that the nbytes comes out
+		 * properly when we replay the extents.
+		 */
+		item = btrfs_item_ptr(eb, slot, struct btrfs_inode_item);
+		btrfs_set_inode_nbytes(eb, item, 0);
 	}
 insert:
 	btrfs_release_path(path);
@@ -488,7 +516,7 @@ static noinline int replay_one_extent(st
 	u64 extent_end;
 	u64 alloc_hint;
 	u64 start = key->offset;
-	u64 saved_nbytes;
+	u64 nbytes = 0;
 	struct btrfs_file_extent_item *item;
 	struct inode *inode = NULL;
 	unsigned long size;
@@ -498,10 +526,19 @@ static noinline int replay_one_extent(st
 	found_type = btrfs_file_extent_type(eb, item);
 
 	if (found_type == BTRFS_FILE_EXTENT_REG ||
-	    found_type == BTRFS_FILE_EXTENT_PREALLOC)
-		extent_end = start + btrfs_file_extent_num_bytes(eb, item);
-	else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
+	    found_type == BTRFS_FILE_EXTENT_PREALLOC) {
+		nbytes = btrfs_file_extent_num_bytes(eb, item);
+		extent_end = start + nbytes;
+
+		/*
+		 * We don't add to the inodes nbytes if we are prealloc or a
+		 * hole.
+		 */
+		if (btrfs_file_extent_disk_bytenr(eb, item) == 0)
+			nbytes = 0;
+	} else if (found_type == BTRFS_FILE_EXTENT_INLINE) {
 		size = btrfs_file_extent_inline_len(eb, item);
+		nbytes = btrfs_file_extent_ram_bytes(eb, item);
 		extent_end = (start + size + mask) & ~mask;
 	} else {
 		ret = 0;
@@ -550,7 +587,6 @@ static noinline int replay_one_extent(st
 	}
 	btrfs_release_path(path);
 
-	saved_nbytes = inode_get_bytes(inode);
 	/* drop any overlapping extents */
 	ret = btrfs_drop_extents(trans, inode, start, extent_end,
 				 &alloc_hint, 1);
@@ -638,7 +674,7 @@ static noinline int replay_one_extent(st
 		BUG_ON(ret);
 	}
 
-	inode_set_bytes(inode, saved_nbytes);
+	inode_add_bytes(inode, nbytes);
 	btrfs_update_inode(trans, root, inode);
 out:
 	if (inode)

