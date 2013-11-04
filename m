Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3KDLgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab3KDLgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:23 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 05/19] GFS2: Introduce rbm field bii
Date: Mon,  4 Nov 2013 11:09:28 +0000
Message-Id: <1383563382-8535-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is a respin of the original patch. As Steve pointed out, the
introduction of field bii makes it easy to eliminate bi itself.
This revised patch does just that, replacing bi with bii.

This patch adds a new field to the rbm structure, called bii,
which is an index into the array of bitmaps for an rgrp.
This replaces *bi which was a pointer to the bitmap.
This is being done for further optimizations.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index f1a3243..8c8f110 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -102,19 +102,25 @@ struct gfs2_rgrpd {
 
 struct gfs2_rbm {
 	struct gfs2_rgrpd *rgd;
-	struct gfs2_bitmap *bi;	/* Bitmap must belong to the rgd */
 	u32 offset;		/* The offset is bitmap relative */
+	int bii;		/* Bitmap index */
 };
 
+static inline struct gfs2_bitmap *rbm_bi(const struct gfs2_rbm *rbm)
+{
+	return rbm->rgd->rd_bits + rbm->bii;
+}
+
 static inline u64 gfs2_rbm_to_block(const struct gfs2_rbm *rbm)
 {
-	return rbm->rgd->rd_data0 + (rbm->bi->bi_start * GFS2_NBBY) + rbm->offset;
+	return rbm->rgd->rd_data0 + (rbm_bi(rbm)->bi_start * GFS2_NBBY) +
+		rbm->offset;
 }
 
 static inline bool gfs2_rbm_eq(const struct gfs2_rbm *rbm1,
 			       const struct gfs2_rbm *rbm2)
 {
-	return (rbm1->rgd == rbm2->rgd) && (rbm1->bi == rbm2->bi) && 
+	return (rbm1->rgd == rbm2->rgd) && (rbm1->bii == rbm2->bii) &&
 	       (rbm1->offset == rbm2->offset);
 }
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 8e50038..dd3c4d3 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -81,11 +81,12 @@ static inline void gfs2_setbit(const struct gfs2_rbm *rbm, bool do_clone,
 			       unsigned char new_state)
 {
 	unsigned char *byte1, *byte2, *end, cur_state;
-	unsigned int buflen = rbm->bi->bi_len;
+	struct gfs2_bitmap *bi = rbm_bi(rbm);
+	unsigned int buflen = bi->bi_len;
 	const unsigned int bit = (rbm->offset % GFS2_NBBY) * GFS2_BIT_SIZE;
 
-	byte1 = rbm->bi->bi_bh->b_data + rbm->bi->bi_offset + (rbm->offset / GFS2_NBBY);
-	end = rbm->bi->bi_bh->b_data + rbm->bi->bi_offset + buflen;
+	byte1 = bi->bi_bh->b_data + bi->bi_offset + (rbm->offset / GFS2_NBBY);
+	end = bi->bi_bh->b_data + bi->bi_offset + buflen;
 
 	BUG_ON(byte1 >= end);
 
@@ -95,18 +96,17 @@ static inline void gfs2_setbit(const struct gfs2_rbm *rbm, bool do_clone,
 		printk(KERN_WARNING "GFS2: buf_blk = 0x%x old_state=%d, "
 		       "new_state=%d\n", rbm->offset, cur_state, new_state);
 		printk(KERN_WARNING "GFS2: rgrp=0x%llx bi_start=0x%x\n",
-		       (unsigned long long)rbm->rgd->rd_addr,
-		       rbm->bi->bi_start);
+		       (unsigned long long)rbm->rgd->rd_addr, bi->bi_start);
 		printk(KERN_WARNING "GFS2: bi_offset=0x%x bi_len=0x%x\n",
-		       rbm->bi->bi_offset, rbm->bi->bi_len);
+		       bi->bi_offset, bi->bi_len);
 		dump_stack();
 		gfs2_consist_rgrpd(rbm->rgd);
 		return;
 	}
 	*byte1 ^= (cur_state ^ new_state) << bit;
 
-	if (do_clone && rbm->bi->bi_clone) {
-		byte2 = rbm->bi->bi_clone + rbm->bi->bi_offset + (rbm->offset / GFS2_NBBY);
+	if (do_clone && bi->bi_clone) {
+		byte2 = bi->bi_clone + bi->bi_offset + (rbm->offset / GFS2_NBBY);
 		cur_state = (*byte2 >> bit) & GFS2_BIT_MASK;
 		*byte2 ^= (cur_state ^ new_state) << bit;
 	}
@@ -121,7 +121,8 @@ static inline void gfs2_setbit(const struct gfs2_rbm *rbm, bool do_clone,
 
 static inline u8 gfs2_testbit(const struct gfs2_rbm *rbm)
 {
-	const u8 *buffer = rbm->bi->bi_bh->b_data + rbm->bi->bi_offset;
+	struct gfs2_bitmap *bi = rbm_bi(rbm);
+	const u8 *buffer = bi->bi_bh->b_data + bi->bi_offset;
 	const u8 *byte;
 	unsigned int bit;
 
@@ -252,25 +253,23 @@ static u32 gfs2_bitfit(const u8 *buf, const unsigned int len,
 static int gfs2_rbm_from_block(struct gfs2_rbm *rbm, u64 block)
 {
 	u64 rblock = block - rbm->rgd->rd_data0;
-	u32 x;
 
 	if (WARN_ON_ONCE(rblock > UINT_MAX))
 		return -EINVAL;
 	if (block >= rbm->rgd->rd_data0 + rbm->rgd->rd_data)
 		return -E2BIG;
 
-	rbm->bi = rbm->rgd->rd_bits;
+	rbm->bii = 0;
 	rbm->offset = (u32)(rblock);
 	/* Check if the block is within the first block */
-	if (rbm->offset < rbm->bi->bi_blocks)
+	if (rbm->offset < rbm_bi(rbm)->bi_blocks)
 		return 0;
 
 	/* Adjust for the size diff between gfs2_meta_header and gfs2_rgrp */
 	rbm->offset += (sizeof(struct gfs2_rgrp) -
 			sizeof(struct gfs2_meta_header)) * GFS2_NBBY;
-	x = rbm->offset / rbm->rgd->rd_sbd->sd_blocks_per_bitmap;
-	rbm->offset -= x * rbm->rgd->rd_sbd->sd_blocks_per_bitmap;
-	rbm->bi += x;
+	rbm->bii = rbm->offset / rbm->rgd->rd_sbd->sd_blocks_per_bitmap;
+	rbm->offset -= rbm->bii * rbm->rgd->rd_sbd->sd_blocks_per_bitmap;
 	return 0;
 }
 
@@ -328,6 +327,7 @@ static u32 gfs2_free_extlen(const struct gfs2_rbm *rrbm, u32 len)
 	u32 chunk_size;
 	u8 *ptr, *start, *end;
 	u64 block;
+	struct gfs2_bitmap *bi;
 
 	if (n_unaligned &&
 	    gfs2_unaligned_extlen(&rbm, 4 - n_unaligned, &len))
@@ -336,11 +336,12 @@ static u32 gfs2_free_extlen(const struct gfs2_rbm *rrbm, u32 len)
 	n_unaligned = len & 3;
 	/* Start is now byte aligned */
 	while (len > 3) {
-		start = rbm.bi->bi_bh->b_data;
-		if (rbm.bi->bi_clone)
-			start = rbm.bi->bi_clone;
-		end = start + rbm.bi->bi_bh->b_size;
-		start += rbm.bi->bi_offset;
+		bi = rbm_bi(&rbm);
+		start = bi->bi_bh->b_data;
+		if (bi->bi_clone)
+			start = bi->bi_clone;
+		end = start + bi->bi_bh->b_size;
+		start += bi->bi_offset;
 		BUG_ON(rbm.offset & 3);
 		start += (rbm.offset / GFS2_NBBY);
 		bytes = min_t(u32, len / GFS2_NBBY, (end - start));
@@ -605,11 +606,13 @@ static void __rs_deltree(struct gfs2_blkreserv *rs)
 	RB_CLEAR_NODE(&rs->rs_node);
 
 	if (rs->rs_free) {
+		struct gfs2_bitmap *bi = rbm_bi(&rs->rs_rbm);
+
 		/* return reserved blocks to the rgrp */
 		BUG_ON(rs->rs_rbm.rgd->rd_reserved < rs->rs_free);
 		rs->rs_rbm.rgd->rd_reserved -= rs->rs_free;
 		rs->rs_free = 0;
-		clear_bit(GBF_FULL, &rs->rs_rbm.bi->bi_flags);
+		clear_bit(GBF_FULL, &bi->bi_flags);
 		smp_mb__after_clear_bit();
 	}
 }
@@ -1558,14 +1561,14 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 minext,
 			 const struct gfs2_inode *ip, bool nowrap)
 {
 	struct buffer_head *bh;
-	struct gfs2_bitmap *initial_bi;
+	int initial_bii;
 	u32 initial_offset;
 	u32 offset;
 	u8 *buffer;
-	int index;
 	int n = 0;
 	int iters = rbm->rgd->rd_length;
 	int ret;
+	struct gfs2_bitmap *bi;
 
 	/* If we are not starting at the beginning of a bitmap, then we
 	 * need to add one to the bitmap count to ensure that we search
@@ -1575,52 +1578,53 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 minext,
 		iters++;
 
 	while(1) {
-		if (test_bit(GBF_FULL, &rbm->bi->bi_flags) &&
+		bi = rbm_bi(rbm);
+		if (test_bit(GBF_FULL, &bi->bi_flags) &&
 		    (state == GFS2_BLKST_FREE))
 			goto next_bitmap;
 
-		bh = rbm->bi->bi_bh;
-		buffer = bh->b_data + rbm->bi->bi_offset;
+		bh = bi->bi_bh;
+		buffer = bh->b_data + bi->bi_offset;
 		WARN_ON(!buffer_uptodate(bh));
-		if (state != GFS2_BLKST_UNLINKED && rbm->bi->bi_clone)
-			buffer = rbm->bi->bi_clone + rbm->bi->bi_offset;
+		if (state != GFS2_BLKST_UNLINKED && bi->bi_clone)
+			buffer = bi->bi_clone + bi->bi_offset;
 		initial_offset = rbm->offset;
-		offset = gfs2_bitfit(buffer, rbm->bi->bi_len, rbm->offset, state);
+		offset = gfs2_bitfit(buffer, bi->bi_len, rbm->offset, state);
 		if (offset == BFITNOENT)
 			goto bitmap_full;
 		rbm->offset = offset;
 		if (ip == NULL)
 			return 0;
 
-		initial_bi = rbm->bi;
+		initial_bii = rbm->bii;
 		ret = gfs2_reservation_check_and_update(rbm, ip, minext);
 		if (ret == 0)
 			return 0;
 		if (ret > 0) {
-			n += (rbm->bi - initial_bi);
+			n += (rbm->bii - initial_bii);
 			goto next_iter;
 		}
 		if (ret == -E2BIG) {
-			index = 0;
+			rbm->bii = 0;
 			rbm->offset = 0;
-			n += (rbm->bi - initial_bi);
+			n += (rbm->bii - initial_bii);
 			goto res_covered_end_of_rgrp;
 		}
 		return ret;
 
 bitmap_full:	/* Mark bitmap as full and fall through */
-		if ((state == GFS2_BLKST_FREE) && initial_offset == 0)
-			set_bit(GBF_FULL, &rbm->bi->bi_flags);
+		if ((state == GFS2_BLKST_FREE) && initial_offset == 0) {
+			struct gfs2_bitmap *bi = rbm_bi(rbm);
+			set_bit(GBF_FULL, &bi->bi_flags);
+		}
 
 next_bitmap:	/* Find next bitmap in the rgrp */
 		rbm->offset = 0;
-		index = rbm->bi - rbm->rgd->rd_bits;
-		index++;
-		if (index == rbm->rgd->rd_length)
-			index = 0;
+		rbm->bii++;
+		if (rbm->bii == rbm->rgd->rd_length)
+			rbm->bii = 0;
 res_covered_end_of_rgrp:
-		rbm->bi = &rbm->rgd->rd_bits[index];
-		if ((index == 0) && nowrap)
+		if ((rbm->bii == 0) && nowrap)
 			break;
 		n++;
 next_iter:
@@ -1649,7 +1653,7 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 	struct gfs2_inode *ip;
 	int error;
 	int found = 0;
-	struct gfs2_rbm rbm = { .rgd = rgd, .bi = rgd->rd_bits, .offset = 0 };
+	struct gfs2_rbm rbm = { .rgd = rgd, .bii = 0, .offset = 0 };
 
 	while (1) {
 		down_write(&sdp->sd_log_flush_lock);
@@ -1976,14 +1980,14 @@ static void gfs2_alloc_extent(const struct gfs2_rbm *rbm, bool dinode,
 
 	*n = 1;
 	block = gfs2_rbm_to_block(rbm);
-	gfs2_trans_add_meta(rbm->rgd->rd_gl, rbm->bi->bi_bh);
+	gfs2_trans_add_meta(rbm->rgd->rd_gl, rbm_bi(rbm)->bi_bh);
 	gfs2_setbit(rbm, true, dinode ? GFS2_BLKST_DINODE : GFS2_BLKST_USED);
 	block++;
 	while (*n < elen) {
 		ret = gfs2_rbm_from_block(&pos, block);
 		if (ret || gfs2_testbit(&pos) != GFS2_BLKST_FREE)
 			break;
-		gfs2_trans_add_meta(pos.rgd->rd_gl, pos.bi->bi_bh);
+		gfs2_trans_add_meta(pos.rgd->rd_gl, rbm_bi(&pos)->bi_bh);
 		gfs2_setbit(&pos, true, GFS2_BLKST_USED);
 		(*n)++;
 		block++;
@@ -2004,6 +2008,7 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 				     u32 blen, unsigned char new_state)
 {
 	struct gfs2_rbm rbm;
+	struct gfs2_bitmap *bi;
 
 	rbm.rgd = gfs2_blk2rgrpd(sdp, bstart, 1);
 	if (!rbm.rgd) {
@@ -2014,15 +2019,15 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 
 	while (blen--) {
 		gfs2_rbm_from_block(&rbm, bstart);
+		bi = rbm_bi(&rbm);
 		bstart++;
-		if (!rbm.bi->bi_clone) {
-			rbm.bi->bi_clone = kmalloc(rbm.bi->bi_bh->b_size,
-						   GFP_NOFS | __GFP_NOFAIL);
-			memcpy(rbm.bi->bi_clone + rbm.bi->bi_offset,
-			       rbm.bi->bi_bh->b_data + rbm.bi->bi_offset,
-			       rbm.bi->bi_len);
+		if (!bi->bi_clone) {
+			bi->bi_clone = kmalloc(bi->bi_bh->b_size,
+					       GFP_NOFS | __GFP_NOFAIL);
+			memcpy(bi->bi_clone + bi->bi_offset,
+			       bi->bi_bh->b_data + bi->bi_offset, bi->bi_len);
 		}
-		gfs2_trans_add_meta(rbm.rgd->rd_gl, rbm.bi->bi_bh);
+		gfs2_trans_add_meta(rbm.rgd->rd_gl, bi->bi_bh);
 		gfs2_setbit(&rbm, false, new_state);
 	}
 
-- 
1.7.4.4

