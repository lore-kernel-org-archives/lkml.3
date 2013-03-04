Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab3CDDm3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60720 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754960Ab3CDDm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:26 -0500
Message-Id: <20130304033708.557694317@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:16 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Theodore Tso <tytso@mit.edu>
Subject: [ 009/153] ext4: return ENOMEM if sb_getblk() fails
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 860d21e2c585f7ee8a4ecc06f474fdc33c9474f4 upstream.

The only reason for sb_getblk() failing is if it can't allocate the
buffer_head.  So ENOMEM is more appropriate than EIO.  In addition,
make sure that the file system is marked as being inconsistent if
sb_getblk() fails.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[bwh: Backported to 3.2:
 - Adjust context
 - Drop change to inline.c
 - Call to ext4_ext_check() from ext4_ext_find_extent() is conditional]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/extents.c  |   25 ++++++++++++++-----------
 fs/ext4/indirect.c |    9 ++++++---
 fs/ext4/inline.c   |    2 +-
 fs/ext4/inode.c    |    9 +++------
 fs/ext4/mmp.c      |    2 ++
 fs/ext4/resize.c   |    8 ++++----
 fs/ext4/xattr.c    |    3 ++-
 7 files changed, 32 insertions(+), 26 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -636,6 +636,7 @@ ext4_ext_find_extent(struct inode *inode
 	struct ext4_extent_header *eh;
 	struct buffer_head *bh;
 	short int depth, i, ppos = 0, alloc = 0;
+	int ret;
 
 	eh = ext_inode_hdr(inode);
 	depth = ext_depth(inode);
@@ -665,12 +666,15 @@ ext4_ext_find_extent(struct inode *inode
 		path[ppos].p_ext = NULL;
 
 		bh = sb_getblk(inode->i_sb, path[ppos].p_block);
-		if (unlikely(!bh))
+		if (unlikely(!bh)) {
+			ret = -ENOMEM;
 			goto err;
+		}
 		if (!bh_uptodate_or_lock(bh)) {
 			trace_ext4_ext_load_extent(inode, block,
 						path[ppos].p_block);
-			if (bh_submit_read(bh) < 0) {
+			ret = bh_submit_read(bh);
+			if (ret < 0) {
 				put_bh(bh);
 				goto err;
 			}
@@ -683,13 +687,15 @@ ext4_ext_find_extent(struct inode *inode
 			put_bh(bh);
 			EXT4_ERROR_INODE(inode,
 					 "ppos %d > depth %d", ppos, depth);
+			ret = -EIO;
 			goto err;
 		}
 		path[ppos].p_bh = bh;
 		path[ppos].p_hdr = eh;
 		i--;
 
-		if (need_to_validate && ext4_ext_check(inode, eh, i))
+		ret = need_to_validate ? ext4_ext_check(inode, eh, i) : 0;
+		if (ret < 0)
 			goto err;
 	}
 
@@ -711,7 +717,7 @@ err:
 	ext4_ext_drop_refs(path);
 	if (alloc)
 		kfree(path);
-	return ERR_PTR(-EIO);
+	return ERR_PTR(ret);
 }
 
 /*
@@ -866,7 +872,7 @@ static int ext4_ext_split(handle_t *hand
 	}
 	bh = sb_getblk(inode->i_sb, newblock);
 	if (!bh) {
-		err = -EIO;
+		err = -ENOMEM;
 		goto cleanup;
 	}
 	lock_buffer(bh);
@@ -938,7 +944,7 @@ static int ext4_ext_split(handle_t *hand
 		newblock = ablocks[--a];
 		bh = sb_getblk(inode->i_sb, newblock);
 		if (!bh) {
-			err = -EIO;
+			err = -ENOMEM;
 			goto cleanup;
 		}
 		lock_buffer(bh);
@@ -1049,11 +1055,8 @@ static int ext4_ext_grow_indepth(handle_
 		return err;
 
 	bh = sb_getblk(inode->i_sb, newblock);
-	if (!bh) {
-		err = -EIO;
-		ext4_std_error(inode->i_sb, err);
-		return err;
-	}
+	if (!bh)
+		return -ENOMEM;
 	lock_buffer(bh);
 
 	err = ext4_journal_get_create_access(handle, bh);
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -146,6 +146,7 @@ static Indirect *ext4_get_branch(struct
 	struct super_block *sb = inode->i_sb;
 	Indirect *p = chain;
 	struct buffer_head *bh;
+	int ret = -EIO;
 
 	*err = 0;
 	/* i_data is not going away, no lock needed */
@@ -154,8 +155,10 @@ static Indirect *ext4_get_branch(struct
 		goto no_block;
 	while (--depth) {
 		bh = sb_getblk(sb, le32_to_cpu(p->key));
-		if (unlikely(!bh))
+		if (unlikely(!bh)) {
+			ret = -ENOMEM;
 			goto failure;
+		}
 
 		if (!bh_uptodate_or_lock(bh)) {
 			if (bh_submit_read(bh) < 0) {
@@ -177,7 +180,7 @@ static Indirect *ext4_get_branch(struct
 	return NULL;
 
 failure:
-	*err = -EIO;
+	*err = ret;
 no_block:
 	return p;
 }
@@ -471,7 +474,7 @@ static int ext4_alloc_branch(handle_t *h
 		 */
 		bh = sb_getblk(inode->i_sb, new_blocks[n-1]);
 		if (unlikely(!bh)) {
-			err = -EIO;
+			err = -ENOMEM;
 			goto failed;
 		}
 
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -661,7 +661,7 @@ struct buffer_head *ext4_getblk(handle_t
 
 	bh = sb_getblk(inode->i_sb, map.m_pblk);
 	if (!bh) {
-		*errp = -EIO;
+		*errp = -ENOMEM;
 		return NULL;
 	}
 	if (map.m_flags & EXT4_MAP_NEW) {
@@ -3575,11 +3575,8 @@ static int __ext4_get_inode_loc(struct i
 	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
 
 	bh = sb_getblk(sb, block);
-	if (!bh) {
-		EXT4_ERROR_INODE_BLOCK(inode, block,
-				       "unable to read itable block");
-		return -EIO;
-	}
+	if (!bh)
+		return -ENOMEM;
 	if (!buffer_uptodate(bh)) {
 		lock_buffer(bh);
 
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -41,6 +41,8 @@ static int read_mmp_block(struct super_b
 	 * is not blocked in the elevator. */
 	if (!*bh)
 		*bh = sb_getblk(sb, mmp_block);
+	if (!*bh)
+		return -ENOMEM;
 	if (*bh) {
 		get_bh(*bh);
 		lock_buffer(*bh);
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -142,7 +142,7 @@ static struct buffer_head *bclean(handle
 
 	bh = sb_getblk(sb, blk);
 	if (!bh)
-		return ERR_PTR(-EIO);
+		return ERR_PTR(-ENOMEM);
 	if ((err = ext4_journal_get_write_access(handle, bh))) {
 		brelse(bh);
 		bh = ERR_PTR(err);
@@ -220,7 +220,7 @@ static int setup_new_group_blocks(struct
 
 		gdb = sb_getblk(sb, block);
 		if (!gdb) {
-			err = -EIO;
+			err = -ENOMEM;
 			goto exit_journal;
 		}
 		if ((err = ext4_journal_get_write_access(handle, gdb))) {
@@ -694,7 +694,7 @@ static void update_backups(struct super_
 
 		bh = sb_getblk(sb, group * bpg + blk_off);
 		if (!bh) {
-			err = -EIO;
+			err = -ENOMEM;
 			break;
 		}
 		ext4_debug("update metadata backup %#04lx\n",
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -839,16 +839,17 @@ inserted:
 
 			new_bh = sb_getblk(sb, block);
 			if (!new_bh) {
+				error = -ENOMEM;
 getblk_failed:
 				ext4_free_blocks(handle, inode, NULL, block, 1,
 						 EXT4_FREE_BLOCKS_METADATA);
-				error = -EIO;
 				goto cleanup;
 			}
 			lock_buffer(new_bh);
 			error = ext4_journal_get_create_access(handle, new_bh);
 			if (error) {
 				unlock_buffer(new_bh);
+				error = -EIO;
 				goto getblk_failed;
 			}
 			memcpy(new_bh->b_data, s->base, new_bh->b_size);


