Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3EXOEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:04:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab3EXOEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:04:11 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] GFS2: Use single-block reservations for directories
Date: Fri, 24 May 2013 14:37:33 +0100
Message-Id: <1369402655-26600-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1369402655-26600-1-git-send-email-swhiteho@redhat.com>
References: <1369402655-26600-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch changes the multi-block allocation code, such that
directory inodes only get a single block reserved in the bitmap.
That way, the bitmaps are more tightly packed together, and there
are fewer spans of free blocks for in-use block reservations.
This means it takes less time to find a free span of blocks in the
bitmap, which speeds things up. This increases the performance of
some workloads by almost 2X. In Nate's mockup.py script (which does
(1) create dir, (2) create dir in dir, (3) create file in that dir)
the test executes in 23 steps rather than 43 steps, a 47%
performance improvement.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 0c5a575..5232525 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1401,9 +1401,14 @@ static void rg_mblk_search(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip,
 	u32 extlen;
 	u32 free_blocks = rgd->rd_free_clone - rgd->rd_reserved;
 	int ret;
+	struct inode *inode = &ip->i_inode;
 
-	extlen = max_t(u32, atomic_read(&rs->rs_sizehint), requested);
-	extlen = clamp(extlen, RGRP_RSRV_MINBLKS, free_blocks);
+	if (S_ISDIR(inode->i_mode))
+		extlen = 1;
+	else {
+		extlen = max_t(u32, atomic_read(&rs->rs_sizehint), requested);
+		extlen = clamp(extlen, RGRP_RSRV_MINBLKS, free_blocks);
+	}
 	if ((rgd->rd_free_clone < rgd->rd_reserved) || (free_blocks < extlen))
 		return;
 
-- 
1.7.4

