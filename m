Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab3KDLkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:40:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab3KDLgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:33 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/19] GFS2: Speed up starting point selection for block allocation
Date: Mon,  4 Nov 2013 11:09:33 +0000
Message-Id: <1383563382-8535-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When setting the starting point for block allocation, there were calls
to both gfs2_rbm_to_block() and gfs2_rbm_from_block() in the common case
of there being an active reservation. The gfs2_rbm_from_block() function
can be quite slow, and since the two conversions were effectively a
no-op, it makes sense to avoid them entirely in this case.

There is no functional change here, but the code should be a bit more
efficient after this patch.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 4f0984a..4d83abd 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2134,6 +2134,35 @@ out:
 }
 
 /**
+ * gfs2_set_alloc_start - Set starting point for block allocation
+ * @rbm: The rbm which will be set to the required location
+ * @ip: The gfs2 inode
+ * @dinode: Flag to say if allocation includes a new inode
+ *
+ * This sets the starting point from the reservation if one is active
+ * otherwise it falls back to guessing a start point based on the
+ * inode's goal block or the last allocation point in the rgrp.
+ */
+
+static void gfs2_set_alloc_start(struct gfs2_rbm *rbm,
+				 const struct gfs2_inode *ip, bool dinode)
+{
+	u64 goal;
+
+	if (gfs2_rs_active(ip->i_res)) {
+		*rbm = ip->i_res->rs_rbm;
+		return;
+	}
+
+	if (!dinode && rgrp_contains_block(rbm->rgd, ip->i_goal))
+		goal = ip->i_goal;
+	else
+		goal = rbm->rgd->rd_last_alloc + rbm->rgd->rd_data0;
+
+	gfs2_rbm_from_block(rbm, goal);
+}
+
+/**
  * gfs2_alloc_blocks - Allocate one or more blocks of data and/or a dinode
  * @ip: the inode to allocate the block for
  * @bn: Used to return the starting block number
@@ -2151,22 +2180,14 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 	struct buffer_head *dibh;
 	struct gfs2_rbm rbm = { .rgd = ip->i_rgd, };
 	unsigned int ndata;
-	u64 goal;
 	u64 block; /* block, within the file system scope */
 	int error;
 
-	if (gfs2_rs_active(ip->i_res))
-		goal = gfs2_rbm_to_block(&ip->i_res->rs_rbm);
-	else if (!dinode && rgrp_contains_block(rbm.rgd, ip->i_goal))
-		goal = ip->i_goal;
-	else
-		goal = rbm.rgd->rd_last_alloc + rbm.rgd->rd_data0;
-
-	gfs2_rbm_from_block(&rbm, goal);
+	gfs2_set_alloc_start(&rbm, ip, dinode);
 	error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, 0, ip, false);
 
 	if (error == -ENOSPC) {
-		gfs2_rbm_from_block(&rbm, goal);
+		gfs2_set_alloc_start(&rbm, ip, dinode);
 		error = gfs2_rbm_find(&rbm, GFS2_BLKST_FREE, 0, NULL, false);
 	}
 
-- 
1.7.4.4

