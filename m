Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3EIW1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:27:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617Ab3EIW06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: [ 68/73] Btrfs: fix extent logging with O_DIRECT into prealloc
Date: Thu,  9 May 2013 15:25:58 -0700
Message-Id: <20130509222533.317951825@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fusionio.com>

commit eb384b55ae9c2055ea00c5cc87971e182d47aefa upstream.

This is the same as the fix from commit

Btrfs: fix bad extent logging

but for O_DIRECT.  I missed this when I fixed the problem originally, we were
still using the em for the orig_start and orig_block_len, which would be the
merged extent.  We need to use the actual extent from the on disk file extent
item, which we have to lookup to make sure it's ok to nocow anyway so just pass
in some pointers to hold this info.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/inode.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6502,7 +6502,9 @@ out:
  * block must be cow'd
  */
 static noinline int can_nocow_odirect(struct btrfs_trans_handle *trans,
-				      struct inode *inode, u64 offset, u64 len)
+				      struct inode *inode, u64 offset, u64 *len,
+				      u64 *orig_start, u64 *orig_block_len,
+				      u64 *ram_bytes)
 {
 	struct btrfs_path *path;
 	int ret;
@@ -6559,8 +6561,12 @@ static noinline int can_nocow_odirect(st
 	disk_bytenr = btrfs_file_extent_disk_bytenr(leaf, fi);
 	backref_offset = btrfs_file_extent_offset(leaf, fi);
 
+	*orig_start = key.offset - backref_offset;
+	*orig_block_len = btrfs_file_extent_disk_num_bytes(leaf, fi);
+	*ram_bytes = btrfs_file_extent_ram_bytes(leaf, fi);
+
 	extent_end = key.offset + btrfs_file_extent_num_bytes(leaf, fi);
-	if (extent_end < offset + len) {
+	if (extent_end < offset + *len) {
 		/* extent doesn't include our full range, must cow */
 		goto out;
 	}
@@ -6584,13 +6590,14 @@ static noinline int can_nocow_odirect(st
 	 */
 	disk_bytenr += backref_offset;
 	disk_bytenr += offset - key.offset;
-	num_bytes = min(offset + len, extent_end) - offset;
+	num_bytes = min(offset + *len, extent_end) - offset;
 	if (csum_exist_in_range(root, disk_bytenr, num_bytes))
 				goto out;
 	/*
 	 * all of the above have passed, it is safe to overwrite this extent
 	 * without cow
 	 */
+	*len = num_bytes;
 	ret = 1;
 out:
 	btrfs_free_path(path);
@@ -6789,7 +6796,7 @@ static int btrfs_get_blocks_direct(struc
 	     em->block_start != EXTENT_MAP_HOLE)) {
 		int type;
 		int ret;
-		u64 block_start;
+		u64 block_start, orig_start, orig_block_len, ram_bytes;
 
 		if (test_bit(EXTENT_FLAG_PREALLOC, &em->flags))
 			type = BTRFS_ORDERED_PREALLOC;
@@ -6807,10 +6814,8 @@ static int btrfs_get_blocks_direct(struc
 		if (IS_ERR(trans))
 			goto must_cow;
 
-		if (can_nocow_odirect(trans, inode, start, len) == 1) {
-			u64 orig_start = em->orig_start;
-			u64 orig_block_len = em->orig_block_len;
-
+		if (can_nocow_odirect(trans, inode, start, &len, &orig_start,
+				      &orig_block_len, &ram_bytes) == 1) {
 			if (type == BTRFS_ORDERED_PREALLOC) {
 				free_extent_map(em);
 				em = create_pinned_em(inode, start, len,


