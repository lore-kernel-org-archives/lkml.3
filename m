Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbaCHBWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:22:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaCHBHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 66/99] ext4: return ENOMEM if sb_getblk() fails
Date: Fri,  7 Mar 2014 17:08:02 -0800
Message-Id: <20140308010613.714110268@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 860d21e2c585f7ee8a4ecc06f474fdc33c9474f4 upstream.

The only reason for sb_getblk() failing is if it can't allocate the
buffer_head.  So ENOMEM is more appropriate than EIO.  In addition,
make sure that the file system is marked as being inconsistent if
sb_getblk() fails.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
[xr: Backported to 3.4:
 - Drop change to inline.c
 - Call to ext4_ext_check() from ext4_ext_find_extent() is conditional]
Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/extents.c  |   25 ++++++++++++++-----------
 fs/ext4/indirect.c |    9 ++++++---
 fs/ext4/inode.c    |    9 +++------
 fs/ext4/mmp.c      |    2 ++
 fs/ext4/resize.c   |    8 ++++----
 fs/ext4/xattr.c    |    3 ++-
 6 files changed, 31 insertions(+), 25 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -670,6 +670,7 @@ ext4_ext_find_extent(struct inode *inode
 	struct ext4_extent_header *eh;
 	struct buffer_head *bh;
 	short int depth, i, ppos = 0, alloc = 0;
+	int ret;
 
 	eh = ext_inode_hdr(inode);
 	depth = ext_depth(inode);
@@ -699,12 +700,15 @@ ext4_ext_find_extent(struct inode *inode
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
@@ -717,13 +721,15 @@ ext4_ext_find_extent(struct inode *inode
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
 
@@ -745,7 +751,7 @@ err:
 	ext4_ext_drop_refs(path);
 	if (alloc)
 		kfree(path);
-	return ERR_PTR(-EIO);
+	return ERR_PTR(ret);
 }
 
 /*
@@ -900,7 +906,7 @@ static int ext4_ext_split(handle_t *hand
 	}
 	bh = sb_getblk(inode->i_sb, newblock);
 	if (!bh) {
-		err = -EIO;
+		err = -ENOMEM;
 		goto cleanup;
 	}
 	lock_buffer(bh);
@@ -972,7 +978,7 @@ static int ext4_ext_split(handle_t *hand
 		newblock = ablocks[--a];
 		bh = sb_getblk(inode->i_sb, newblock);
 		if (!bh) {
-			err = -EIO;
+			err = -ENOMEM;
 			goto cleanup;
 		}
 		lock_buffer(bh);
@@ -1083,11 +1089,8 @@ static int ext4_ext_grow_indepth(handle_
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
@@ -145,6 +145,7 @@ static Indirect *ext4_get_branch(struct
 	struct super_block *sb = inode->i_sb;
 	Indirect *p = chain;
 	struct buffer_head *bh;
+	int ret = -EIO;
 
 	*err = 0;
 	/* i_data is not going away, no lock needed */
@@ -153,8 +154,10 @@ static Indirect *ext4_get_branch(struct
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
@@ -176,7 +179,7 @@ static Indirect *ext4_get_branch(struct
 	return NULL;
 
 failure:
-	*err = -EIO;
+	*err = ret;
 no_block:
 	return p;
 }
@@ -470,7 +473,7 @@ static int ext4_alloc_branch(handle_t *h
 		 */
 		bh = sb_getblk(inode->i_sb, new_blocks[n-1]);
 		if (unlikely(!bh)) {
-			err = -EIO;
+			err = -ENOMEM;
 			goto failed;
 		}
 
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -663,7 +663,7 @@ struct buffer_head *ext4_getblk(handle_t
 
 	bh = sb_getblk(inode->i_sb, map.m_pblk);
 	if (!bh) {
-		*errp = -EIO;
+		*errp = -ENOMEM;
 		return NULL;
 	}
 	if (map.m_flags & EXT4_MAP_NEW) {
@@ -3461,11 +3461,8 @@ static int __ext4_get_inode_loc(struct i
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
@@ -315,7 +315,7 @@ static struct buffer_head *bclean(handle
 
 	bh = sb_getblk(sb, blk);
 	if (!bh)
-		return ERR_PTR(-EIO);
+		return ERR_PTR(-ENOMEM);
 	if ((err = ext4_journal_get_write_access(handle, bh))) {
 		brelse(bh);
 		bh = ERR_PTR(err);
@@ -392,7 +392,7 @@ static int set_flexbg_block_bitmap(struc
 
 		bh = sb_getblk(sb, flex_gd->groups[group].block_bitmap);
 		if (!bh)
-			return -EIO;
+			return -ENOMEM;
 
 		err = ext4_journal_get_write_access(handle, bh);
 		if (err)
@@ -470,7 +470,7 @@ static int setup_new_flex_group_blocks(s
 
 			gdb = sb_getblk(sb, block);
 			if (!gdb) {
-				err = -EIO;
+				err = -ENOMEM;
 				goto out;
 			}
 
@@ -991,7 +991,7 @@ static void update_backups(struct super_
 
 		bh = sb_getblk(sb, group * bpg + blk_off);
 		if (!bh) {
-			err = -EIO;
+			err = -ENOMEM;
 			break;
 		}
 		ext4_debug("update metadata backup %#04lx\n",
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -840,16 +840,17 @@ inserted:
 
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


