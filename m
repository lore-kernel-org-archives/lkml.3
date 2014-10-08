Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaJHJxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:53:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755034AbaJHJxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:53:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/4] GFS2: Use gfs2_rbm_incr in rgblk_free
Date: Wed,  8 Oct 2014 10:53:12 +0100
Message-Id: <1412761993-5982-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1412761993-5982-1-git-send-email-swhiteho@redhat.com>
References: <1412761993-5982-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch speeds up GFS2 unlink operations by using function
gfs2_rbm_incr rather than continuously calculating the rbm.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 55ef72d..7474c41 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2097,7 +2097,7 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 				     u32 blen, unsigned char new_state)
 {
 	struct gfs2_rbm rbm;
-	struct gfs2_bitmap *bi;
+	struct gfs2_bitmap *bi, *bi_prev = NULL;
 
 	rbm.rgd = gfs2_blk2rgrpd(sdp, bstart, 1);
 	if (!rbm.rgd) {
@@ -2106,18 +2106,22 @@ static struct gfs2_rgrpd *rgblk_free(struct gfs2_sbd *sdp, u64 bstart,
 		return NULL;
 	}
 
+	gfs2_rbm_from_block(&rbm, bstart);
 	while (blen--) {
-		gfs2_rbm_from_block(&rbm, bstart);
 		bi = rbm_bi(&rbm);
-		bstart++;
-		if (!bi->bi_clone) {
-			bi->bi_clone = kmalloc(bi->bi_bh->b_size,
-					       GFP_NOFS | __GFP_NOFAIL);
-			memcpy(bi->bi_clone + bi->bi_offset,
-			       bi->bi_bh->b_data + bi->bi_offset, bi->bi_len);
+		if (bi != bi_prev) {
+			if (!bi->bi_clone) {
+				bi->bi_clone = kmalloc(bi->bi_bh->b_size,
+						      GFP_NOFS | __GFP_NOFAIL);
+				memcpy(bi->bi_clone + bi->bi_offset,
+				       bi->bi_bh->b_data + bi->bi_offset,
+				       bi->bi_len);
+			}
+			gfs2_trans_add_meta(rbm.rgd->rd_gl, bi->bi_bh);
+			bi_prev = bi;
 		}
-		gfs2_trans_add_meta(rbm.rgd->rd_gl, bi->bi_bh);
 		gfs2_setbit(&rbm, false, new_state);
+		gfs2_rbm_incr(&rbm);
 	}
 
 	return rbm.rgd;
-- 
1.8.3.1

