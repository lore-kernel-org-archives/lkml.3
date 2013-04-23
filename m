Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab3DWV6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:58:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581Ab3DWV4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:56:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Lingzhu Xiang <lxiang@redhat.com>, CAI Qian <caiqian@redhat.com>
Subject: [ 23/23] Btrfs: make sure nbytes are right after log replay
Date: Tue, 23 Apr 2013 14:56:30 -0700
Message-Id: <20130423215458.671054628@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215456.307216898@linuxfoundation.org>
References: <20130423215456.307216898@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Reviewed-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |   48 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 42 insertions(+), 6 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -315,6 +315,7 @@ static noinline int overwrite_item(struc
 	unsigned long src_ptr;
 	unsigned long dst_ptr;
 	int overwrite_root = 0;
+	bool inode_item = key->type == BTRFS_INODE_ITEM_KEY;
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
 		overwrite_root = 1;
@@ -324,6 +325,9 @@ static noinline int overwrite_item(struc
 
 	/* look for the key in the destination tree */
 	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	if (ret < 0)
+		return ret;
+
 	if (ret == 0) {
 		char *src_copy;
 		char *dst_copy;
@@ -365,6 +369,30 @@ static noinline int overwrite_item(struc
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
@@ -487,7 +515,7 @@ static noinline int replay_one_extent(st
 	u64 extent_end;
 	u64 alloc_hint;
 	u64 start = key->offset;
-	u64 saved_nbytes;
+	u64 nbytes = 0;
 	struct btrfs_file_extent_item *item;
 	struct inode *inode = NULL;
 	unsigned long size;
@@ -497,10 +525,19 @@ static noinline int replay_one_extent(st
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
@@ -549,7 +586,6 @@ static noinline int replay_one_extent(st
 	}
 	btrfs_release_path(path);
 
-	saved_nbytes = inode_get_bytes(inode);
 	/* drop any overlapping extents */
 	ret = btrfs_drop_extents(trans, inode, start, extent_end,
 				 &alloc_hint, 1);
@@ -637,7 +673,7 @@ static noinline int replay_one_extent(st
 		BUG_ON(ret);
 	}
 
-	inode_set_bytes(inode, saved_nbytes);
+	inode_add_bytes(inode, nbytes);
 	btrfs_update_inode(trans, root, inode);
 out:
 	if (inode)


