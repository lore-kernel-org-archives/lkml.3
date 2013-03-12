Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019Ab3CLXUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:20:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab3CLWcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 020/100] Btrfs: delete inline extents when we find them during logging
Date: Tue, 12 Mar 2013 15:31:05 -0700
Message-Id: <20130312223125.197472423@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit 124fe663f93162d17b7e391705cac122101e93d8 upstream.

Apparently when we do inline extents we allow the data to overlap the last chunk
of the btrfs_file_extent_item, which means that we can possibly have a
btrfs_file_extent_item that isn't actually as large as a btrfs_file_extent_item.
This messes with us when we try to overwrite the extent when logging new extents
since we expect for it to be the right size.  To fix this just delete the item
and try to do the insert again which will give us the proper sized
btrfs_file_extent_item.  This fixes a panic where map_private_extent_buffer
would blow up because we're trying to write past the end of the leaf.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/tree-log.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3281,6 +3281,7 @@ static int log_one_extent(struct btrfs_t
 	int ret;
 	bool skip_csum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
 
+insert:
 	INIT_LIST_HEAD(&ordered_sums);
 	btrfs_init_map_token(&token);
 	key.objectid = btrfs_ino(inode);
@@ -3296,6 +3297,23 @@ static int log_one_extent(struct btrfs_t
 	leaf = path->nodes[0];
 	fi = btrfs_item_ptr(leaf, path->slots[0],
 			    struct btrfs_file_extent_item);
+
+	/*
+	 * If we are overwriting an inline extent with a real one then we need
+	 * to just delete the inline extent as it may not be large enough to
+	 * have the entire file_extent_item.
+	 */
+	if (ret && btrfs_token_file_extent_type(leaf, fi, &token) ==
+	    BTRFS_FILE_EXTENT_INLINE) {
+		ret = btrfs_del_item(trans, log, path);
+		btrfs_release_path(path);
+		if (ret) {
+			path->really_keep_locks = 0;
+			return ret;
+		}
+		goto insert;
+	}
+
 	btrfs_set_token_file_extent_generation(leaf, fi, em->generation,
 					       &token);
 	if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags)) {


