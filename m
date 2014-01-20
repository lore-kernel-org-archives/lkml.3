Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaATMc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:32:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaATMYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:05 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 01/24] GFS2: If requested is too large, use the largest extent in the rgrp
Date: Mon, 20 Jan 2014 12:23:24 +0000
Message-Id: <1390220627-1571-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Here is a second try at a patch I posted earlier, which also implements
suggestions Steve made:

Before this patch, GFS2 would keep searching through all the rgrps
until it found one that had a chunk of free blocks big enough to
satisfy the size hint, which is based on the file write size,
regardless of whether the chunk was big enough to perform the write.
However, when doing big writes there may not be a large enough
chunk of free blocks in any rgrp, due to file system fragmentation.
The largest chunk may be big enough to satisfy the write request,
but it may not meet the ideal reservation size from the "size hint".
The writes would slow to a crawl because every write would search
every rgrp, then finally give up and default to a single-block write.
In my case, performance would drop from 425MB/s to 18KB/s, or 24000
times slower.

This patch basically makes it so that if we can't find a contiguous
chunk of blocks big enough to satisfy the sizehint, we'll use the
largest chunk of blocks we found that will still contain the write.
It does so by keeping track of the largest run of blocks within the
rgrp.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index c8d6161..809fecd 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -57,6 +57,11 @@
  * 3 = Used (metadata)
  */
 
+struct gfs2_extent {
+	struct gfs2_rbm rbm;
+	u32 len;
+};
+
 static const char valid_change[16] = {
 	        /* current */
 	/* n */ 0, 1, 1, 1,
@@ -65,8 +70,9 @@ static const char valid_change[16] = {
 	        1, 0, 0, 0
 };
 
-static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 minext,
-                         const struct gfs2_inode *ip, bool nowrap);
+static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 *minext,
+			 const struct gfs2_inode *ip, bool nowrap,
+			 const struct gfs2_alloc_parms *ap);
 
 
 /**
@@ -1455,7 +1461,7 @@ static void rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip,
 	if (WARN_ON(gfs2_rbm_from_block(&rbm, goal)))
 		return;
 
-	ret = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, extlen, ip, true);
+	ret = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, &extlen, ip, true, ap);
 	if (ret == 0) {
 		rs->rs_rbm = rbm;
 		rs->rs_free = extlen;
@@ -1520,6 +1526,7 @@ static u64 gfs2_next_unreserved_block(struct gfs2_rgrpd *rgd, u64 block,
  * @rbm: The current position in the resource group
  * @ip: The inode for which we are searching for blocks
  * @minext: The minimum extent length
+ * @maxext: A pointer to the maximum extent structure
  *
  * This checks the current position in the rgrp to see whether there is
  * a reservation covering this block. If not then this function is a
@@ -1532,7 +1539,8 @@ static u64 gfs2_next_unreserved_block(struct gfs2_rgrpd *rgd, u64 block,
 
 static int gfs2_reservation_check_and_update(struct gfs2_rbm *rbm,
 					     const struct gfs2_inode *ip,
-					     u32 minext)
+					     u32 minext,
+					     struct gfs2_extent *maxext)
 {
 	u64 block = gfs2_rbm_to_block(rbm);
 	u32 extlen = 1;
@@ -1545,8 +1553,7 @@ static int gfs2_reservation_check_and_update(struct gfs2_rbm *rbm,
 	 */
 	if (minext) {
 		extlen = gfs2_free_extlen(rbm, minext);
-		nblock = block + extlen;
-		if (extlen < minext)
+		if (extlen <= maxext->len)
 			goto fail;
 	}
 
@@ -1555,9 +1562,17 @@ static int gfs2_reservation_check_and_update(struct gfs2_rbm *rbm,
 	 * and skip if parts of it are already reserved
 	 */
 	nblock = gfs2_next_unreserved_block(rbm->rgd, block, extlen, ip);
-	if (nblock == block)
-		return 0;
+	if (nblock == block) {
+		if (!minext || extlen >= minext)
+			return 0;
+
+		if (extlen > maxext->len) {
+			maxext->len = extlen;
+			maxext->rbm = *rbm;
+		}
 fail:
+		nblock = block + extlen;
+	}
 	ret = gfs2_rbm_from_block(rbm, nblock);
 	if (ret < 0)
 		return ret;
@@ -1568,10 +1583,12 @@ fail:
  * gfs2_rbm_find - Look for blocks of a particular state
  * @rbm: Value/result starting position and final position
  * @state: The state which we want to find
- * @minext: The requested extent length (0 for a single block)
+ * @minext: Pointer to the requested extent length (NULL for a single block)
+ *          This is updated to be the actual reservation size.
  * @ip: If set, check for reservations
  * @nowrap: Stop looking at the end of the rgrp, rather than wrapping
  *          around until we've reached the starting point.
+ * @ap: the allocation parameters
  *
  * Side effects:
  * - If looking for free blocks, we set GBF_FULL on each bitmap which
@@ -1580,8 +1597,9 @@ fail:
  * Returns: 0 on success, -ENOSPC if there is no block of the requested state
  */
 
-static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 minext,
-			 const struct gfs2_inode *ip, bool nowrap)
+static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 *minext,
+			 const struct gfs2_inode *ip, bool nowrap,
+			 const struct gfs2_alloc_parms *ap)
 {
 	struct buffer_head *bh;
 	int initial_bii;
@@ -1592,6 +1610,7 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 minext,
 	int iters = rbm->rgd->rd_length;
 	int ret;
 	struct gfs2_bitmap *bi;
+	struct gfs2_extent maxext = { .rbm.rgd = rbm->rgd, };
 
 	/* If we are not starting at the beginning of a bitmap, then we
 	 * need to add one to the bitmap count to ensure that we search
@@ -1620,7 +1639,9 @@ static int gfs2_rbm_find(struct gfs2_rbm *rbm, u8 state, u32 minext,
 			return 0;
 
 		initial_bii = rbm->bii;
-		ret = gfs2_reservation_check_and_update(rbm, ip, minext);
+		ret = gfs2_reservation_check_and_update(rbm, ip,
+							minext ? *minext : 0,
+							&maxext);
 		if (ret == 0)
 			return 0;
 		if (ret > 0) {
@@ -1655,6 +1676,17 @@ next_iter:
 			break;
 	}
 
+	if (minext == NULL || state != GFS2_BLKST_FREE)
+		return -ENOSPC;
+
+	/* If the maximum extent we found is big enough to fulfill the
+	   minimum requirements, use it anyway. */
+	if (maxext.len) {
+		*rbm = maxext.rbm;
+		*minext = maxext.len;
+		return 0;
+	}
+
 	return -ENOSPC;
 }
 
@@ -1680,7 +1712,8 @@ static void try_rgrp_unlink(struct gfs2_rgrpd *rgd, u64 *last_unlinked, u64 skip
 
 	while (1) {
 		down_write(&sdp->sd_log_flush_lock);
-		error = gfs2_rbm_find(&rbm, GFS2_BLKST_UNLINKED, 0, NULL, true);
+		error = gfs2_rbm_find(&rbm, GFS2_BLKST_UNLINKED, NULL, NULL,
+				      true, NULL);
 		up_write(&sdp->sd_log_flush_lock);
 		if (error == -ENOSPC)
 			break;
@@ -2184,11 +2217,12 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	int error;
 
 	gfs2_set_alloc_start(&rbm, ip, dinode);
-	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, 0, ip, false);
+	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, NULL, ip, false, NULL);
 
 	if (error == -ENOSPC) {
 		gfs2_set_alloc_start(&rbm, ip, dinode);
-		error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, 0, NULL, false);
+		error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, NULL, NULL, false,
+				      NULL);
 	}
 
 	/* Since all blocks are reserved in advance, this shouldn't happen */
-- 
1.8.3.1

