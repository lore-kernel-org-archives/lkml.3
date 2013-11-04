Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab3KDLgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012Ab3KDLgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:20 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 03/19] GFS2: introduce bi_blocks for optimization
Date: Mon,  4 Nov 2013 11:09:26 +0000
Message-Id: <1383563382-8535-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch introduces a new field in the bitmap structure called
bi_blocks. Its purpose is to save us from constantly multiplying
bi_len by the constant GFS2_NBBY. It also paves the way for more
optimization in a future patch.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 26aabd7..f1a3243 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -71,6 +71,7 @@ struct gfs2_bitmap {
 	u32 bi_offset;
 	u32 bi_start;
 	u32 bi_len;
+	u32 bi_blocks;
 };
 
 struct gfs2_rgrpd {
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 7a6fa03..7d64a27 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -262,7 +262,7 @@ static int gfs2_rbm_from_block(struct gfs2_rbm *rbm, u64 block)
 	rbm->bi = rbm->rgd->rd_bits;
 	rbm->offset = (u32)(rblock);
 	/* Check if the block is within the first block */
-	if (rbm->offset < rbm->bi->bi_len * GFS2_NBBY)
+	if (rbm->offset < rbm->bi->bi_blocks)
 		return 0;
 
 	/* Adjust for the size diff between gfs2_meta_header and gfs2_rgrp */
@@ -743,18 +743,21 @@ static int compute_bitstructs(struct gfs2_rgrpd *rgd)
 			bi->bi_offset = sizeof(struct gfs2_rgrp);
 			bi->bi_start = 0;
 			bi->bi_len = bytes;
+			bi->bi_blocks = bytes * GFS2_NBBY;
 		/* header block */
 		} else if (x == 0) {
 			bytes = sdp->sd_sb.sb_bsize - sizeof(struct gfs2_rgrp);
 			bi->bi_offset = sizeof(struct gfs2_rgrp);
 			bi->bi_start = 0;
 			bi->bi_len = bytes;
+			bi->bi_blocks = bytes * GFS2_NBBY;
 		/* last block */
 		} else if (x + 1 == length) {
 			bytes = bytes_left;
 			bi->bi_offset = sizeof(struct gfs2_meta_header);
 			bi->bi_start = rgd->rd_bitbytes - bytes_left;
 			bi->bi_len = bytes;
+			bi->bi_blocks = bytes * GFS2_NBBY;
 		/* other blocks */
 		} else {
 			bytes = sdp->sd_sb.sb_bsize -
@@ -762,6 +765,7 @@ static int compute_bitstructs(struct gfs2_rgrpd *rgd)
 			bi->bi_offset = sizeof(struct gfs2_meta_header);
 			bi->bi_start = rgd->rd_bitbytes - bytes_left;
 			bi->bi_len = bytes;
+			bi->bi_blocks = bytes * GFS2_NBBY;
 		}
 
 		bytes_left -= bytes;
-- 
1.7.4.4

