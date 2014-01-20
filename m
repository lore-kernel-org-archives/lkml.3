Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaATMYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:24:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016AbaATMYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:30 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/24] GFS2: Implement a "rgrp has no extents longer than X" scheme
Date: Mon, 20 Jan 2014 12:23:26 +0000
Message-Id: <1390220627-1571-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

With the preceding patch, we started accepting block reservations
smaller than the ideal size, which requires a lot more parsing of the
bitmaps. To reduce the amount of bitmap searching, this patch
implements a scheme whereby each rgrp keeps track of the point
at this multi-block reservations will fail.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index ba1ea67..0132816 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -93,6 +93,7 @@ struct gfs2_rgrpd {
 	struct gfs2_rgrp_lvb *rd_rgl;
 	u32 rd_last_alloc;
 	u32 rd_flags;
+	u32 rd_extfail_pt;		/* extent failure point */
 #define GFS2_RDF_CHECK		0x10000000 /* check for unlinked inodes */
 #define GFS2_RDF_UPTODATE	0x20000000 /* rg is up to date */
 #define GFS2_RDF_ERROR		0x40000000 /* error in rg */
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 010b9fb..cdadb92 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -83,6 +83,7 @@ static void maybe_release_space(struct gfs2_bufdata *bd)
 	       bd->bd_bh->b_data + bi->bi_offset, bi->bi_len);
 	clear_bit(GBF_FULL, &bi->bi_flags);
 	rgd->rd_free_clone = rgd->rd_free;
+	rgd->rd_extfail_pt = rgd->rd_free;
 }
 
 /**
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 1ccf89a..797f1d3 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -641,9 +641,13 @@ static void __rs_deltree(struct gfs2_blkreserv *rs)
 		/* return reserved blocks to the rgrp */
 		BUG_ON(rs->rs_rbm.rgd->rd_reserved < rs->rs_free);
 		rs->rs_rbm.rgd->rd_reserved -= rs->rs_free;
+		/* The rgrp extent failure point is likely not to increase;
+		   it will only do so if the freed blocks are somehow
+		   contiguous with a span of free blocks that follows. Still,
+		   it will force the number to be recalculated later. */
+		rgd->rd_extfail_pt += rs->rs_free;
 		rs->rs_free = 0;
 		clear_bit(GBF_FULL, &bi->bi_flags);
-		smp_mb__after_clear_bit();
 	}
 }
 
@@ -1132,6 +1136,8 @@ int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
 		gfs2_rgrp_in(rgd, (rgd->rd_bits[0].bi_bh)->b_data);
 		rgd->rd_flags |= (GFS2_RDF_UPTODATE | GFS2_RDF_CHECK);
 		rgd->rd_free_clone = rgd->rd_free;
+		/* max out the rgrp allocation failure point */
+		rgd->rd_extfail_pt = rgd->rd_free;
 	}
 	if (cpu_to_be32(GFS2_MAGIC) != rgd->rd_rgl->rl_magic) {
 		rgd->rd_rgl->rl_unlinked = cpu_to_be32(count_unlinked(rgd));
@@ -1593,6 +1599,8 @@ fail:
  * Side effects:
  * - If looking for free blocks, we set GBF_FULL on each bitmap which
  *   has no free blocks in it.
+ * - If looking for free blocks, we set rd_extfail_pt on each rgrp which
+ *   has come up short on a free block search.
  *
  * Returns: 0 on success, -ENOSPC if there is no block of the requested state
  */
@@ -1604,6 +1612,8 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 *minext,
 	struct buffer_head *bh;
 	int initial_bii;
 	u32 initial_offset;
+	int first_bii = rbm->bii;
+	u32 first_offset = rbm->offset;
 	u32 offset;
 	u8 *buffer;
 	int n = 0;
@@ -1679,6 +1689,13 @@ next_iter:
 	if (minext == NULL || state != GFS2_BLKST_FREE)
 		return -ENOSPC;
 
+	/* If the extent was too small, and it's smaller than the smallest
+	   to have failed before, remember for future reference that it's
+	   useless to search this rgrp again for this amount or more. */
+	if ((first_offset == 0) && (first_bii == 0) &&
+	    (*minext < rbm->rgd->rd_extfail_pt))
+		rbm->rgd->rd_extfail_pt = *minext;
+
 	/* If the maximum extent we found is big enough to fulfill the
 	   minimum requirements, use it anyway. */
 	if (maxext.len) {
@@ -1924,7 +1941,9 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, const struct gfs2_alloc_parms *a
 		}
 
 		/* Skip unuseable resource groups */
-		if (rs->rs_rbm.rgd->rd_flags & (GFS2_RGF_NOALLOC | GFS2_RDF_ERROR))
+		if ((rs->rs_rbm.rgd->rd_flags & (GFS2_RGF_NOALLOC |
+						 GFS2_RDF_ERROR)) ||
+		    (ap && (ap->target > rs->rs_rbm.rgd->rd_extfail_pt)))
 			goto skip_rgrp;
 
 		if (sdp->sd_args.ar_rgrplvb)
@@ -2106,10 +2125,10 @@ int gfs2_rgrp_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 
 	if (rgd == NULL)
 		return 0;
-	gfs2_print_dbg(seq, " R: n:%llu f:%02x b:%u/%u i:%u r:%u\n",
+	gfs2_print_dbg(seq, " R: n:%llu f:%02x b:%u/%u i:%u r:%u e:%u\n",
 		       (unsigned long long)rgd->rd_addr, rgd->rd_flags,
 		       rgd->rd_free, rgd->rd_free_clone, rgd->rd_dinodes,
-		       rgd->rd_reserved);
+		       rgd->rd_reserved, rgd->rd_extfail_pt);
 	spin_lock(&rgd->rd_rsspin);
 	for (n = rb_first(&rgd->rd_rstree); n; n = rb_next(&trs->rs_node)) {
 		trs = rb_entry(n, struct gfs2_blkreserv, rs_node);
@@ -2228,9 +2247,10 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 
 	/* Since all blocks are reserved in advance, this shouldn't happen */
 	if (error) {
-		fs_warn(sdp, "inum=%llu error=%d, nblocks=%u, full=%d\n",
+		fs_warn(sdp, "inum=%llu error=%d, nblocks=%u, full=%d fail_pt=%d\n",
 			(unsigned long long)ip->i_no_addr, error, *nblocks,
-			test_bit(GBF_FULL, &rbm.rgd->rd_bits->bi_flags));
+			test_bit(GBF_FULL, &rbm.rgd->rd_bits->bi_flags),
+			rbm.rgd->rd_extfail_pt);
 		goto rgrp_error;
 	}
 
-- 
1.8.3.1

