Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab3B1PGO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:06:14 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42302 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab3B1OtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 082/139] ext4: return ENOMEM if sb_getblk() fails
Date: Thu, 28 Feb 2013 14:43:52 +0000
Message-Id: <1362062689-2567-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 860d21e2c585f7ee8a4ecc06f474fdc33c9474f4 upstream.

The only reason for sb_getblk() failing is if it can't allocate the
buffer_head.  So ENOMEM is more appropriate than EIO.  In addition,
make sure that the file system is marked as being inconsistent if
sb_getblk() fails.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[ luis: removed fs/ext4/inline.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/extents.c  | 25 ++++++++++++++-----------
 fs/ext4/indirect.c |  9 ++++++---
 fs/ext4/inode.c    |  9 +++------
 fs/ext4/mmp.c      |  2 ++
 fs/ext4/resize.c   |  8 ++++----
 fs/ext4/xattr.c    |  3 ++-
 6 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8e5dd3b..d14487e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -720,6 +720,7 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 	struct ext4_extent_header *eh;
 	struct buffer_head *bh;
 	short int depth, i, ppos = 0, alloc = 0;
+	int ret;
 
 	eh = ext_inode_hdr(inode);
 	depth = ext_depth(inode);
@@ -747,12 +748,15 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
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
@@ -763,13 +767,15 @@ ext4_ext_find_extent(struct inode *inode, ext4_lblk_t block,
 			put_bh(bh);
 			EXT4_ERROR_INODE(inode,
 					 "ppos %d > depth %d", ppos, depth);
+			ret = -EIO;
 			goto err;
 		}
 		path[ppos].p_bh = bh;
 		path[ppos].p_hdr = eh;
 		i--;
 
-		if (ext4_ext_check_block(inode, eh, i, bh))
+		ret = ext4_ext_check_block(inode, eh, i, bh);
+		if (ret < 0)
 			goto err;
 	}
 
@@ -791,7 +797,7 @@ err:
 	ext4_ext_drop_refs(path);
 	if (alloc)
 		kfree(path);
-	return ERR_PTR(-EIO);
+	return ERR_PTR(ret);
 }
 
 /*
@@ -946,7 +952,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	}
 	bh = sb_getblk(inode->i_sb, newblock);
 	if (!bh) {
-		err = -EIO;
+		err = -ENOMEM;
 		goto cleanup;
 	}
 	lock_buffer(bh);
@@ -1019,7 +1025,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 		newblock = ablocks[--a];
 		bh = sb_getblk(inode->i_sb, newblock);
 		if (!bh) {
-			err = -EIO;
+			err = -ENOMEM;
 			goto cleanup;
 		}
 		lock_buffer(bh);
@@ -1131,11 +1137,8 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
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
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 830e1b2..6dc6153 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -145,6 +145,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	struct super_block *sb = inode->i_sb;
 	Indirect *p = chain;
 	struct buffer_head *bh;
+	int ret = -EIO;
 
 	*err = 0;
 	/* i_data is not going away, no lock needed */
@@ -153,8 +154,10 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
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
@@ -176,7 +179,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	return NULL;
 
 failure:
-	*err = -EIO;
+	*err = ret;
 no_block:
 	return p;
 }
@@ -470,7 +473,7 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 		 */
 		bh = sb_getblk(inode->i_sb, new_blocks[n-1]);
 		if (unlikely(!bh)) {
-			err = -EIO;
+			err = -ENOMEM;
 			goto failed;
 		}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 75f537f..20b2687 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -730,7 +730,7 @@ struct buffer_head *ext4_getblk(handle_t *handle, struct inode *inode,
 
 	bh = sb_getblk(inode->i_sb, map.m_pblk);
 	if (!bh) {
-		*errp = -EIO;
+		*errp = -ENOMEM;
 		return NULL;
 	}
 	if (map.m_flags & EXT4_MAP_NEW) {
@@ -3528,11 +3528,8 @@ static int __ext4_get_inode_loc(struct inode *inode,
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
 
diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index f99a131..b4d5088 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -74,6 +74,8 @@ static int read_mmp_block(struct super_block *sb, struct buffer_head **bh,
 	 * is not blocked in the elevator. */
 	if (!*bh)
 		*bh = sb_getblk(sb, mmp_block);
+	if (!*bh)
+		return -ENOMEM;
 	if (*bh) {
 		get_bh(*bh);
 		lock_buffer(*bh);
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 367510e..4c31b71 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -315,7 +315,7 @@ static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
 
 	bh = sb_getblk(sb, blk);
 	if (!bh)
-		return ERR_PTR(-EIO);
+		return ERR_PTR(-ENOMEM);
 	if ((err = ext4_journal_get_write_access(handle, bh))) {
 		brelse(bh);
 		bh = ERR_PTR(err);
@@ -392,7 +392,7 @@ static int set_flexbg_block_bitmap(struct super_block *sb, handle_t *handle,
 
 		bh = sb_getblk(sb, flex_gd->groups[group].block_bitmap);
 		if (!bh)
-			return -EIO;
+			return -ENOMEM;
 
 		err = ext4_journal_get_write_access(handle, bh);
 		if (err)
@@ -470,7 +470,7 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 
 			gdb = sb_getblk(sb, block);
 			if (!gdb) {
-				err = -EIO;
+				err = -ENOMEM;
 				goto out;
 			}
 
@@ -991,7 +991,7 @@ static void update_backups(struct super_block *sb,
 
 		bh = sb_getblk(sb, group * bpg + blk_off);
 		if (!bh) {
-			err = -EIO;
+			err = -ENOMEM;
 			break;
 		}
 		ext4_debug("update metadata backup %#04lx\n",
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 2cdb98d..3390680 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -898,16 +898,17 @@ inserted:
 
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
-- 
1.8.1.2

