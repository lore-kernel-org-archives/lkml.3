Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaIOJdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:33:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbaIOJdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:33:08 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/6] GFS2: Change maxlen variables to size_t
Date: Mon, 15 Sep 2014 10:32:44 +0100
Message-Id: <1410773568-1573-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
References: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes some variables (especially maxlen in function
gfs2_block_map) from unsigned int to size_t. We need 64-bit arithmetic
for very large files (e.g. 1PB) where the variables otherwise get
shifted to all 0's.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index e6ee5b6..f0b945a 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -359,7 +359,7 @@ static inline void release_metapath(struct metapath *mp)
  * Returns: The length of the extent (minimum of one block)
  */
 
-static inline unsigned int gfs2_extent_length(void *start, unsigned int len, __be64 *ptr, unsigned limit, int *eob)
+static inline unsigned int gfs2_extent_length(void *start, unsigned int len, __be64 *ptr, size_t limit, int *eob)
 {
 	const __be64 *end = (start + len);
 	const __be64 *first = ptr;
@@ -449,7 +449,7 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 			   struct buffer_head *bh_map, struct metapath *mp,
 			   const unsigned int sheight,
 			   const unsigned int height,
-			   const unsigned int maxlen)
+			   const size_t maxlen)
 {
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -483,7 +483,8 @@ static int gfs2_bmap_alloc(struct inode *inode, const sector_t lblock,
 	} else {
 		/* Need to allocate indirect blocks */
 		ptrs_per_blk = height > 1 ? sdp->sd_inptrs : sdp->sd_diptrs;
-		dblks = min(maxlen, ptrs_per_blk - mp->mp_list[end_of_metadata]);
+		dblks = min(maxlen, (size_t)(ptrs_per_blk -
+					     mp->mp_list[end_of_metadata]));
 		if (height == ip->i_height) {
 			/* Writing into existing tree, extend tree down */
 			iblks = height - sheight;
@@ -605,7 +606,7 @@ int gfs2_block_map(struct inode *inode, sector_t lblock,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	unsigned int bsize = sdp->sd_sb.sb_bsize;
-	const unsigned int maxlen = bh_map->b_size >> inode->i_blkbits;
+	const size_t maxlen = bh_map->b_size >> inode->i_blkbits;
 	const u64 *arr = sdp->sd_heightsize;
 	__be64 *ptr;
 	u64 size;
-- 
1.8.3.1

