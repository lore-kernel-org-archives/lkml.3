Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab3BSKgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:36:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932568Ab3BSKeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:05 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/10] GFS2: Split gfs2_trans_add_bh() into two
Date: Tue, 19 Feb 2013 10:07:33 +0000
Message-Id: <1361268460-3092-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
References: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is little common content in gfs2_trans_add_bh() between the data
and meta classes by the time that the functions which it calls are
taken into account. The intent here is to split this into two
separate functions. Stage one is to introduce gfs2_trans_add_data()
and gfs2_trans_add_meta() and update the callers accordingly.

Later patches will then pull in the content of gfs2_trans_add_bh()
and its dependent functions in order to clean up the code in this
area.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 30de4f2..92340dd 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -51,7 +51,7 @@ static void gfs2_page_add_databufs(struct gfs2_inode *ip, struct page *page,
 			continue;
 		if (gfs2_is_jdata(ip))
 			set_buffer_uptodate(bh);
-		gfs2_trans_add_bh(ip->i_gl, bh, 0);
+		gfs2_trans_add_data(ip->i_gl, bh);
 	}
 }
 
@@ -852,7 +852,7 @@ static int gfs2_write_end(struct file *file, struct address_space *mapping,
 		goto failed;
 	}
 
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 
 	if (gfs2_is_stuffed(ip))
 		return gfs2_stuffed_write_end(inode, dibh, pos, len, copied, page);
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index a68e91b..7a86275 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -93,7 +93,7 @@ static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
 	if (!gfs2_is_jdata(ip))
 		mark_buffer_dirty(bh);
 	if (!gfs2_is_writeback(ip))
-		gfs2_trans_add_bh(ip->i_gl, bh, 0);
+		gfs2_trans_add_data(ip->i_gl, bh);
 
 	if (release) {
 		unlock_page(page);
@@ -153,7 +153,7 @@ int gfs2_unstuff_dinode(struct gfs2_inode *ip, struct page *page)
 
 	/*  Set up the pointer to the new block  */
 
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 	di = (struct gfs2_dinode *)dibh->b_data;
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 
@@ -405,7 +405,7 @@ static inline __be64 *gfs2_indirect_init(struct metapath *mp,
 	BUG_ON(i < 1);
 	BUG_ON(mp->mp_bh[i] != NULL);
 	mp->mp_bh[i] = gfs2_meta_new(gl, bn);
-	gfs2_trans_add_bh(gl, mp->mp_bh[i], 1);
+	gfs2_trans_add_meta(gl, mp->mp_bh[i]);
 	gfs2_metatype_set(mp->mp_bh[i], GFS2_METATYPE_IN, GFS2_FORMAT_IN);
 	gfs2_buffer_clear_tail(mp->mp_bh[i], sizeof(struct gfs2_meta_header));
 	ptr += offset;
@@ -468,7 +468,7 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 	BUG_ON(sheight < 1);
 	BUG_ON(dibh == NULL);
 
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 
 	if (height == sheight) {
 		struct buffer_head *bh;
@@ -544,7 +544,7 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 		/* Branching from existing tree */
 		case ALLOC_GROW_DEPTH:
 			if (i > 1 && i < height)
-				gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[i-1], 1);
+				gfs2_trans_add_meta(ip->i_gl, mp->mp_bh[i-1]);
 			for (; i < height && n > 0; i++, n--)
 				gfs2_indirect_init(mp, ip->i_gl, i,
 						   mp->mp_list[i-1], bn++);
@@ -556,7 +556,7 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 		case ALLOC_DATA:
 			BUG_ON(n > dblks);
 			BUG_ON(mp->mp_bh[end_of_metadata] == NULL);
-			gfs2_trans_add_bh(ip->i_gl, mp->mp_bh[end_of_metadata], 1);
+			gfs2_trans_add_meta(ip->i_gl, mp->mp_bh[end_of_metadata]);
 			dblks = n;
 			ptr = metapointer(end_of_metadata, mp);
 			dblock = bn;
@@ -796,8 +796,8 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 
 	down_write(&ip->i_rw_mutex);
 
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
+	gfs2_trans_add_meta(ip->i_gl, bh);
 
 	bstart = 0;
 	blen = 0;
@@ -981,7 +981,7 @@ static int gfs2_block_truncate_page(struct address_space *mapping, loff_t from)
 	}
 
 	if (!gfs2_is_writeback(ip))
-		gfs2_trans_add_bh(ip->i_gl, bh, 0);
+		gfs2_trans_add_data(ip->i_gl, bh);
 
 	zero_user(page, offset, length);
 	mark_buffer_dirty(bh);
@@ -1046,7 +1046,7 @@ static int trunc_start(struct inode *inode, u64 oldsize, u64 newsize)
 	if (error)
 		goto out;
 
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 
 	if (gfs2_is_stuffed(ip)) {
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode) + newsize);
@@ -1141,7 +1141,7 @@ static int trunc_end(struct gfs2_inode *ip)
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 	ip->i_diskflags &= ~GFS2_DIF_TRUNC_IN_PROG;
 
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
 
@@ -1246,7 +1246,7 @@ static int do_grow(struct inode *inode, u64 size)
 
 	i_size_write(inode, size);
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
 
diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 9a35670..7179478 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -93,7 +93,7 @@ int gfs2_dir_get_new_buffer(struct gfs2_inode *ip, u64 block,
 	struct buffer_head *bh;
 
 	bh = gfs2_meta_new(ip->i_gl, block);
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, bh);
 	gfs2_metatype_set(bh, GFS2_METATYPE_JD, GFS2_FORMAT_JD);
 	gfs2_buffer_clear_tail(bh, sizeof(struct gfs2_meta_header));
 	*bhp = bh;
@@ -127,7 +127,7 @@ static int gfs2_dir_write_stuffed(struct gfs2_inode *ip, const char *buf,
 	if (error)
 		return error;
 
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 	memcpy(dibh->b_data + offset + sizeof(struct gfs2_dinode), buf, size);
 	if (ip->i_inode.i_size < offset + size)
 		i_size_write(&ip->i_inode, offset + size);
@@ -209,7 +209,7 @@ static int gfs2_dir_write_data(struct gfs2_inode *ip, const char *buf,
 		if (error)
 			goto fail;
 
-		gfs2_trans_add_bh(ip->i_gl, bh, 1);
+		gfs2_trans_add_meta(ip->i_gl, bh);
 		memcpy(bh->b_data + o, buf, amount);
 		brelse(bh);
 
@@ -231,7 +231,7 @@ out:
 		i_size_write(&ip->i_inode, offset + copied);
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = CURRENT_TIME;
 
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
 
@@ -647,7 +647,7 @@ static void dirent_del(struct gfs2_inode *dip, struct buffer_head *bh,
 		return;
 	}
 
-	gfs2_trans_add_bh(dip->i_gl, bh, 1);
+	gfs2_trans_add_meta(dip->i_gl, bh);
 
 	/* If there is no prev entry, this is the first entry in the block.
 	   The de_rec_len is already as big as it needs to be.  Just zero
@@ -690,7 +690,7 @@ static struct gfs2_dirent *gfs2_init_dirent(struct inode *inode,
 		offset = GFS2_DIRENT_SIZE(be16_to_cpu(dent->de_name_len));
 	totlen = be16_to_cpu(dent->de_rec_len);
 	BUG_ON(offset + name->len > totlen);
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, bh);
 	ndent = (struct gfs2_dirent *)((char *)dent + offset);
 	dent->de_rec_len = cpu_to_be16(offset);
 	gfs2_qstr2dirent(name, totlen - offset, ndent);
@@ -831,7 +831,7 @@ static struct gfs2_leaf *new_leaf(struct inode *inode, struct buffer_head **pbh,
 		return NULL;
 
 	gfs2_trans_add_unrevoke(GFS2_SB(inode), bn, 1);
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, bh);
 	gfs2_metatype_set(bh, GFS2_METATYPE_LF, GFS2_FORMAT_LF);
 	leaf = (struct gfs2_leaf *)bh->b_data;
 	leaf->lf_depth = cpu_to_be16(depth);
@@ -916,7 +916,7 @@ static int dir_make_exhash(struct inode *inode)
 	/*  We're done with the new leaf block, now setup the new
 	    hash table.  */
 
-	gfs2_trans_add_bh(dip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(dip->i_gl, dibh);
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 
 	lp = (__be64 *)(dibh->b_data + sizeof(struct gfs2_dinode));
@@ -976,7 +976,7 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 		return 1; /* can't split */
 	}
 
-	gfs2_trans_add_bh(dip->i_gl, obh, 1);
+	gfs2_trans_add_meta(dip->i_gl, obh);
 
 	nleaf = new_leaf(inode, &nbh, be16_to_cpu(oleaf->lf_depth) + 1);
 	if (!nleaf) {
@@ -1069,7 +1069,7 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 
 	error = gfs2_meta_inode_buffer(dip, &dibh);
 	if (!gfs2_assert_withdraw(GFS2_SB(&dip->i_inode), !error)) {
-		gfs2_trans_add_bh(dip->i_gl, dibh, 1);
+		gfs2_trans_add_meta(dip->i_gl, dibh);
 		gfs2_add_inode_blocks(&dip->i_inode, 1);
 		gfs2_dinode_out(dip, dibh->b_data);
 		brelse(dibh);
@@ -1622,7 +1622,7 @@ static int dir_new_leaf(struct inode *inode, const struct qstr *name)
 			return error;
 	} while(1);
 
-	gfs2_trans_add_bh(ip->i_gl, obh, 1);
+	gfs2_trans_add_meta(ip->i_gl, obh);
 
 	leaf = new_leaf(inode, &bh, be16_to_cpu(oleaf->lf_depth));
 	if (!leaf) {
@@ -1636,7 +1636,7 @@ static int dir_new_leaf(struct inode *inode, const struct qstr *name)
 	error = gfs2_meta_inode_buffer(ip, &bh);
 	if (error)
 		return error;
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, bh);
 	gfs2_add_inode_blocks(&ip->i_inode, 1);
 	gfs2_dinode_out(ip, bh->b_data);
 	brelse(bh);
@@ -1795,7 +1795,7 @@ int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 	if (IS_ERR(dent))
 		return PTR_ERR(dent);
 
-	gfs2_trans_add_bh(dip->i_gl, bh, 1);
+	gfs2_trans_add_meta(dip->i_gl, bh);
 	gfs2_inum_out(nip, dent);
 	dent->de_type = cpu_to_be16(new_type);
 
@@ -1804,7 +1804,7 @@ int gfs2_dir_mvino(struct gfs2_inode *dip, const struct qstr *filename,
 		error = gfs2_meta_inode_buffer(dip, &bh);
 		if (error)
 			return error;
-		gfs2_trans_add_bh(dip->i_gl, bh, 1);
+		gfs2_trans_add_meta(dip->i_gl, bh);
 	}
 
 	dip->i_inode.i_mtime = dip->i_inode.i_ctime = CURRENT_TIME;
@@ -1917,7 +1917,7 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 	if (error)
 		goto out_end_trans;
 
-	gfs2_trans_add_bh(dip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(dip->i_gl, dibh);
 	/* On the last dealloc, make this a regular file in case we crash.
 	   (We don't want to free these blocks a second time.)  */
 	if (last_dealloc)
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 991ab2d..06b7092 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -276,7 +276,7 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	error = gfs2_meta_inode_buffer(ip, &bh);
 	if (error)
 		goto out_trans_end;
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, bh);
 	ip->i_diskflags = new_flags;
 	gfs2_dinode_out(ip, bh->b_data);
 	brelse(bh);
@@ -709,7 +709,7 @@ static int fallocate_chunk(struct inode *inode, loff_t offset, loff_t len,
 	if (unlikely(error))
 		return error;
 
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 
 	if (gfs2_is_stuffed(ip)) {
 		error = gfs2_unstuff_dinode(ip, NULL);
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 2b6f569..db048a8 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -447,7 +447,7 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 	struct timespec tv = CURRENT_TIME;
 
 	dibh = gfs2_meta_new(ip->i_gl, ip->i_no_addr);
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 	gfs2_metatype_set(dibh, GFS2_METATYPE_DI, GFS2_FORMAT_DI);
 	gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode));
 	di = (struct gfs2_dinode *)dibh->b_data;
@@ -584,7 +584,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 	if (error)
 		goto fail_end_trans;
 	set_nlink(&ip->i_inode, S_ISDIR(ip->i_inode.i_mode) ? 2 : 1);
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
 	return 0;
@@ -931,7 +931,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 	if (error)
 		goto out_brelse;
 
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 	inc_nlink(&ip->i_inode);
 	ip->i_inode.i_ctime = CURRENT_TIME;
 	ihold(inode);
@@ -1412,7 +1412,7 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		if (error)
 			goto out_end_trans;
 		ip->i_inode.i_ctime = CURRENT_TIME;
-		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+		gfs2_trans_add_meta(ip->i_gl, dibh);
 		gfs2_dinode_out(ip, dibh->b_data);
 		brelse(dibh);
 	}
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index ae55e24..06122d0 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -590,7 +590,7 @@ static void do_qc(struct gfs2_quota_data *qd, s64 change)
 	s64 x;
 
 	mutex_lock(&sdp->sd_quota_mutex);
-	gfs2_trans_add_bh(ip->i_gl, qd->qd_bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, qd->qd_bh);
 
 	if (!test_bit(QDF_CHANGE, &qd->qd_flags)) {
 		qc->qc_change = 0;
@@ -726,7 +726,7 @@ get_a_page:
 			goto unlock_out;
 	}
 
-	gfs2_trans_add_bh(ip->i_gl, bh, 0);
+	gfs2_trans_add_meta(ip->i_gl, bh);
 
 	kaddr = kmap_atomic(page);
 	if (offset + sizeof(struct gfs2_quota) > PAGE_CACHE_SIZE)
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index b7eff07..52c2aea 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1323,7 +1323,7 @@ int gfs2_fitrim(struct file *filp, void __user *argp)
 			if (ret == 0) {
 				bh = rgd->rd_bits[0].bi_bh;
 				rgd->rd_flags |= GFS2_RGF_TRIMMED;
-				gfs2_trans_add_bh(rgd->rd_gl, bh, 1);
+				gfs2_trans_add_meta(rgd->rd_gl, bh);
 				gfs2_rgrp_out(rgd, bh->b_data);
 				gfs2_rgrp_ondisk2lvb(rgd->rd_rgl, bh->b_data);
 				gfs2_trans_end(sdp);
@@ -1968,14 +1968,14 @@ static void gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
 
 	*n = 1;
 	block = gfs2_rbm_to_block(rbm);
-	gfs2_trans_add_bh(rbm->rgd->rd_gl, rbm->bi->bi_bh, 1);
+	gfs2_trans_add_meta(rbm->rgd->rd_gl, rbm->bi->bi_bh);
 	gfs2_setbit(rbm, true, dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
 	block++;
 	while (*n < elen) {
 		ret = gfs2_rbm_from_block(&pos, block);
 		if (ret || gfs2_testbit(&pos) != GFS2_BLKST_FREE)
 			break;
-		gfs2_trans_add_bh(pos.rgd->rd_gl, pos.bi->bi_bh, 1);
+		gfs2_trans_add_meta(pos.rgd->rd_gl, pos.bi->bi_bh);
 		gfs2_setbit(&pos, true, GFS2_BLKST_USED);
 		(*n)++;
 		block++;
@@ -2014,7 +2014,7 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 			       rbm.bi->bi_bh->b_data + rbm.bi->bi_offset,
 			       rbm.bi->bi_len);
 		}
-		gfs2_trans_add_bh(rbm.rgd->rd_gl, rbm.bi->bi_bh, 1);
+		gfs2_trans_add_meta(rbm.rgd->rd_gl, rbm.bi->bi_bh);
 		gfs2_setbit(&rbm, false, new_state);
 	}
 
@@ -2157,7 +2157,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 		if (error == 0) {
 			struct gfs2_dinode *di =
 				(struct gfs2_dinode *)dibh->b_data;
-			gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+			gfs2_trans_add_meta(ip->i_gl, dibh);
 			di->di_goal_meta = di->di_goal_data =
 				cpu_to_be64(ip->i_goal);
 			brelse(dibh);
@@ -2176,7 +2176,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 			*generation = rbm.rgd->rd_igeneration++;
 	}
 
-	gfs2_trans_add_bh(rbm.rgd->rd_gl, rbm.rgd->rd_bits[0].bi_bh, 1);
+	gfs2_trans_add_meta(rbm.rgd->rd_gl, rbm.rgd->rd_bits[0].bi_bh);
 	gfs2_rgrp_out(rbm.rgd, rbm.rgd->rd_bits[0].bi_bh->b_data);
 	gfs2_rgrp_ondisk2lvb(rbm.rgd->rd_rgl, rbm.rgd->rd_bits[0].bi_bh->b_data);
 
@@ -2223,7 +2223,7 @@ void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta)
 	trace_gfs2_block_alloc(ip, rgd, bstart, blen, GFS2_BLKST_FREE);
 	rgd->rd_free += blen;
 	rgd->rd_flags &= ~GFS2_RGF_TRIMMED;
-	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
+	gfs2_trans_add_meta(rgd->rd_gl, rgd->rd_bits[0].bi_bh);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 	gfs2_rgrp_ondisk2lvb(rgd->rd_rgl, rgd->rd_bits[0].bi_bh->b_data);
 
@@ -2260,7 +2260,7 @@ void gfs2_unlink_di(struct inode *inode)
 	if (!rgd)
 		return;
 	trace_gfs2_block_alloc(ip, rgd, blkno, 1, GFS2_BLKST_UNLINKED);
-	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
+	gfs2_trans_add_meta(rgd->rd_gl, rgd->rd_bits[0].bi_bh);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 	gfs2_rgrp_ondisk2lvb(rgd->rd_rgl, rgd->rd_bits[0].bi_bh->b_data);
 	update_rgrp_lvb_unlinked(rgd, 1);
@@ -2281,7 +2281,7 @@ static void gfs2_free_uninit_di(struct gfs2_rgrpd *rgd, u64 blkno)
 	rgd->rd_dinodes--;
 	rgd->rd_free++;
 
-	gfs2_trans_add_bh(rgd->rd_gl, rgd->rd_bits[0].bi_bh, 1);
+	gfs2_trans_add_meta(rgd->rd_gl, rgd->rd_bits[0].bi_bh);
 	gfs2_rgrp_out(rgd, rgd->rd_bits[0].bi_bh->b_data);
 	gfs2_rgrp_ondisk2lvb(rgd->rd_rgl, rgd->rd_bits[0].bi_bh->b_data);
 	update_rgrp_lvb_unlinked(rgd, -1);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index d648867..4dfda4c 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -500,7 +500,7 @@ void gfs2_statfs_change(struct gfs2_sbd *sdp, s64 total, s64 free,
 	if (error)
 		return;
 
-	gfs2_trans_add_bh(l_ip->i_gl, l_bh, 1);
+	gfs2_trans_add_meta(l_ip->i_gl, l_bh);
 
 	spin_lock(&sdp->sd_statfs_spin);
 	l_sc->sc_total += total;
@@ -528,7 +528,7 @@ void update_statfs(struct gfs2_sbd *sdp, struct buffer_head *m_bh,
 	struct gfs2_statfs_change_host *m_sc = &sdp->sd_statfs_master;
 	struct gfs2_statfs_change_host *l_sc = &sdp->sd_statfs_local;
 
-	gfs2_trans_add_bh(l_ip->i_gl, l_bh, 1);
+	gfs2_trans_add_meta(l_ip->i_gl, l_bh);
 
 	spin_lock(&sdp->sd_statfs_spin);
 	m_sc->sc_total += l_sc->sc_total;
@@ -539,7 +539,7 @@ void update_statfs(struct gfs2_sbd *sdp, struct buffer_head *m_bh,
 	       0, sizeof(struct gfs2_statfs_change));
 	spin_unlock(&sdp->sd_statfs_spin);
 
-	gfs2_trans_add_bh(m_ip->i_gl, m_bh, 1);
+	gfs2_trans_add_meta(m_ip->i_gl, m_bh);
 	gfs2_statfs_change_out(m_sc, m_bh->b_data + sizeof(struct gfs2_dinode));
 }
 
@@ -824,7 +824,7 @@ static void gfs2_dirty_inode(struct inode *inode, int flags)
 
 	ret = gfs2_meta_inode_buffer(ip, &bh);
 	if (ret == 0) {
-		gfs2_trans_add_bh(ip->i_gl, bh, 1);
+		gfs2_trans_add_meta(ip->i_gl, bh);
 		gfs2_dinode_out(ip, bh->b_data);
 		brelse(bh);
 	}
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 6f3ddbc..cb795ac 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -150,7 +150,7 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
  *
  */
 
-void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
+static void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct gfs2_bufdata *bd;
@@ -173,6 +173,16 @@ void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta)
 	unlock_buffer(bh);
 }
 
+void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh)
+{
+	return gfs2_trans_add_bh(gl, bh, 0);
+}
+
+void gfs2_trans_add_meta(struct gfs2_glock *gl, struct buffer_head *bh)
+{
+	return gfs2_trans_add_bh(gl, bh, 1);
+}
+
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 {
 	struct gfs2_glock *gl = bd->bd_gl;
diff --git a/fs/gfs2/trans.h b/fs/gfs2/trans.h
index bf2ae9a..1e6e7da 100644
--- a/fs/gfs2/trans.h
+++ b/fs/gfs2/trans.h
@@ -39,7 +39,8 @@ extern int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 			    unsigned int revokes);
 
 extern void gfs2_trans_end(struct gfs2_sbd *sdp);
-extern void gfs2_trans_add_bh(struct gfs2_glock *gl, struct buffer_head *bh, int meta);
+extern void gfs2_trans_add_data(struct gfs2_glock *gl, struct buffer_head *bh);
+extern void gfs2_trans_add_meta(struct gfs2_glock *gl, struct buffer_head *bh);
 extern void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
 extern void gfs2_trans_add_unrevoke(struct gfs2_sbd *sdp, u64 blkno, unsigned int len);
 
diff --git a/fs/gfs2/xattr.c b/fs/gfs2/xattr.c
index 76c144b..cbb46c2 100644
--- a/fs/gfs2/xattr.c
+++ b/fs/gfs2/xattr.c
@@ -270,7 +270,7 @@ static int ea_dealloc_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 	if (error)
 		goto out_gunlock;
 
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, bh);
 
 	dataptrs = GFS2_EA2DATAPTRS(ea);
 	for (x = 0; x < ea->ea_num_ptrs; x++, dataptrs++) {
@@ -309,7 +309,7 @@ static int ea_dealloc_unstuffed(struct gfs2_inode *ip, struct buffer_head *bh,
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
 		ip->i_inode.i_ctime = CURRENT_TIME;
-		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+		gfs2_trans_add_meta(ip->i_gl, dibh);
 		gfs2_dinode_out(ip, dibh->b_data);
 		brelse(dibh);
 	}
@@ -509,7 +509,7 @@ static int gfs2_iter_unstuffed(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 		}
 
 		if (din) {
-			gfs2_trans_add_bh(ip->i_gl, bh[x], 1);
+			gfs2_trans_add_meta(ip->i_gl, bh[x]);
 			memcpy(pos, din, cp_size);
 			din += sdp->sd_jbsize;
 		}
@@ -629,7 +629,7 @@ static int ea_alloc_blk(struct gfs2_inode *ip, struct buffer_head **bhp)
 		return error;
 	gfs2_trans_add_unrevoke(sdp, block, 1);
 	*bhp = gfs2_meta_new(ip->i_gl, block);
-	gfs2_trans_add_bh(ip->i_gl, *bhp, 1);
+	gfs2_trans_add_meta(ip->i_gl, *bhp);
 	gfs2_metatype_set(*bhp, GFS2_METATYPE_EA, GFS2_FORMAT_EA);
 	gfs2_buffer_clear_tail(*bhp, sizeof(struct gfs2_meta_header));
 
@@ -691,7 +691,7 @@ static int ea_write(struct gfs2_inode *ip, struct gfs2_ea_header *ea,
 				return error;
 			gfs2_trans_add_unrevoke(sdp, block, 1);
 			bh = gfs2_meta_new(ip->i_gl, block);
-			gfs2_trans_add_bh(ip->i_gl, bh, 1);
+			gfs2_trans_add_meta(ip->i_gl, bh);
 			gfs2_metatype_set(bh, GFS2_METATYPE_ED, GFS2_FORMAT_ED);
 
 			gfs2_add_inode_blocks(&ip->i_inode, 1);
@@ -751,7 +751,7 @@ static int ea_alloc_skeleton(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
 		ip->i_inode.i_ctime = CURRENT_TIME;
-		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+		gfs2_trans_add_meta(ip->i_gl, dibh);
 		gfs2_dinode_out(ip, dibh->b_data);
 		brelse(dibh);
 	}
@@ -834,7 +834,7 @@ static void ea_set_remove_stuffed(struct gfs2_inode *ip,
 	struct gfs2_ea_header *prev = el->el_prev;
 	u32 len;
 
-	gfs2_trans_add_bh(ip->i_gl, el->el_bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, el->el_bh);
 
 	if (!prev || !GFS2_EA_IS_STUFFED(ea)) {
 		ea->ea_type = GFS2_EATYPE_UNUSED;
@@ -872,7 +872,7 @@ static int ea_set_simple_noalloc(struct gfs2_inode *ip, struct buffer_head *bh,
 	if (error)
 		return error;
 
-	gfs2_trans_add_bh(ip->i_gl, bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, bh);
 
 	if (es->ea_split)
 		ea = ea_split_ea(ea);
@@ -886,7 +886,7 @@ static int ea_set_simple_noalloc(struct gfs2_inode *ip, struct buffer_head *bh,
 	if (error)
 		goto out;
 	ip->i_inode.i_ctime = CURRENT_TIME;
-	gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+	gfs2_trans_add_meta(ip->i_gl, dibh);
 	gfs2_dinode_out(ip, dibh->b_data);
 	brelse(dibh);
 out:
@@ -901,7 +901,7 @@ static int ea_set_simple_alloc(struct gfs2_inode *ip,
 	struct gfs2_ea_header *ea = es->es_ea;
 	int error;
 
-	gfs2_trans_add_bh(ip->i_gl, es->es_bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, es->es_bh);
 
 	if (es->ea_split)
 		ea = ea_split_ea(ea);
@@ -997,7 +997,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 			goto out;
 		}
 
-		gfs2_trans_add_bh(ip->i_gl, indbh, 1);
+		gfs2_trans_add_meta(ip->i_gl, indbh);
 	} else {
 		u64 blk;
 		unsigned int n = 1;
@@ -1006,7 +1006,7 @@ static int ea_set_block(struct gfs2_inode *ip, struct gfs2_ea_request *er,
 			return error;
 		gfs2_trans_add_unrevoke(sdp, blk, 1);
 		indbh = gfs2_meta_new(ip->i_gl, blk);
-		gfs2_trans_add_bh(ip->i_gl, indbh, 1);
+		gfs2_trans_add_meta(ip->i_gl, indbh);
 		gfs2_metatype_set(indbh, GFS2_METATYPE_IN, GFS2_FORMAT_IN);
 		gfs2_buffer_clear_tail(indbh, mh_size);
 
@@ -1092,7 +1092,7 @@ static int ea_remove_stuffed(struct gfs2_inode *ip, struct gfs2_ea_location *el)
 	if (error)
 		return error;
 
-	gfs2_trans_add_bh(ip->i_gl, el->el_bh, 1);
+	gfs2_trans_add_meta(ip->i_gl, el->el_bh);
 
 	if (prev) {
 		u32 len;
@@ -1109,7 +1109,7 @@ static int ea_remove_stuffed(struct gfs2_inode *ip, struct gfs2_ea_location *el)
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
 		ip->i_inode.i_ctime = CURRENT_TIME;
-		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+		gfs2_trans_add_meta(ip->i_gl, dibh);
 		gfs2_dinode_out(ip, dibh->b_data);
 		brelse(dibh);
 	}
@@ -1265,7 +1265,7 @@ int gfs2_xattr_acl_chmod(struct gfs2_inode *ip, struct iattr *attr, char *data)
 	if (GFS2_EA_IS_STUFFED(el.el_ea)) {
 		error = gfs2_trans_begin(sdp, RES_DINODE + RES_EATTR, 0);
 		if (error == 0) {
-			gfs2_trans_add_bh(ip->i_gl, el.el_bh, 1);
+			gfs2_trans_add_meta(ip->i_gl, el.el_bh);
 			memcpy(GFS2_EA2DATA(el.el_ea), data,
 			       GFS2_EA_DATA_LEN(el.el_ea));
 		}
@@ -1352,7 +1352,7 @@ static int ea_dealloc_indirect(struct gfs2_inode *ip)
 	if (error)
 		goto out_gunlock;
 
-	gfs2_trans_add_bh(ip->i_gl, indbh, 1);
+	gfs2_trans_add_meta(ip->i_gl, indbh);
 
 	eablk = (__be64 *)(indbh->b_data + sizeof(struct gfs2_meta_header));
 	bstart = 0;
@@ -1384,7 +1384,7 @@ static int ea_dealloc_indirect(struct gfs2_inode *ip)
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
-		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+		gfs2_trans_add_meta(ip->i_gl, dibh);
 		gfs2_dinode_out(ip, dibh->b_data);
 		brelse(dibh);
 	}
@@ -1434,7 +1434,7 @@ static int ea_dealloc_block(struct gfs2_inode *ip)
 
 	error = gfs2_meta_inode_buffer(ip, &dibh);
 	if (!error) {
-		gfs2_trans_add_bh(ip->i_gl, dibh, 1);
+		gfs2_trans_add_meta(ip->i_gl, dibh);
 		gfs2_dinode_out(ip, dibh->b_data);
 		brelse(dibh);
 	}
-- 
1.7.4

