Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161866Ab3DEKYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:24:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161175Ab3DEKYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:24:53 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 6/6] GFS2: Issue discards in 512b sectors
Date: Fri,  5 Apr 2013 10:57:16 +0100
Message-Id: <1365155836-3069-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
References: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes GFS2's discard issuing code so that it calls
function sb_issue_discard rather than blkdev_issue_discard. The
code was calling blkdev_issue_discard and specifying the correct
sector offset and sector size, but blkdev_issue_discard expects
these values to be in terms of 512 byte sectors, even if the native
sector size for the device is different. Calling sb_issue_discard
with the BLOCK size instead ensures the correct block-to-512b-sector
translation. I verified that "minlen" is specified in blocks, so
comparing it to a number of blocks is correct.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 70d1cd0..5a51265 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1181,12 +1181,9 @@ int gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 			     const struct gfs2_bitmap *bi, unsigned minlen, u64 *ptrimmed)
 {
 	struct super_block *sb = sdp->sd_vfs;
-	struct block_device *bdev = sb->s_bdev;
-	const unsigned int sects_per_blk = sdp->sd_sb.sb_bsize /
-					   bdev_logical_block_size(sb->s_bdev);
 	u64 blk;
 	sector_t start = 0;
-	sector_t nr_sects = 0;
+	sector_t nr_blks = 0;
 	int rv;
 	unsigned int x;
 	u32 trimmed = 0;
@@ -1206,35 +1203,34 @@ int gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 		if (diff == 0)
 			continue;
 		blk = offset + ((bi->bi_start + x) * GFS2_NBBY);
-		blk *= sects_per_blk; /* convert to sectors */
 		while(diff) {
 			if (diff & 1) {
-				if (nr_sects == 0)
+				if (nr_blks == 0)
 					goto start_new_extent;
-				if ((start + nr_sects) != blk) {
-					if (nr_sects >= minlen) {
-						rv = blkdev_issue_discard(bdev,
-							start, nr_sects,
+				if ((start + nr_blks) != blk) {
+					if (nr_blks >= minlen) {
+						rv = sb_issue_discard(sb,
+							start, nr_blks,
 							GFP_NOFS, 0);
 						if (rv)
 							goto fail;
-						trimmed += nr_sects;
+						trimmed += nr_blks;
 					}
-					nr_sects = 0;
+					nr_blks = 0;
 start_new_extent:
 					start = blk;
 				}
-				nr_sects += sects_per_blk;
+				nr_blks++;
 			}
 			diff >>= 2;
-			blk += sects_per_blk;
+			blk++;
 		}
 	}
-	if (nr_sects >= minlen) {
-		rv = blkdev_issue_discard(bdev, start, nr_sects, GFP_NOFS, 0);
+	if (nr_blks >= minlen) {
+		rv = sb_issue_discard(sb, start, nr_blks, GFP_NOFS, 0);
 		if (rv)
 			goto fail;
-		trimmed += nr_sects;
+		trimmed += nr_blks;
 	}
 	if (ptrimmed)
 		*ptrimmed = trimmed;
-- 
1.7.4

