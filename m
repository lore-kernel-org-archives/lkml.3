Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaATM3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:29:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbaATMYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:39 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/24] GFS2: Consolidate transaction blocks calculation for dir add
Date: Mon, 20 Jan 2014 12:23:33 +0000
Message-Id: <1390220627-1571-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three cases where we need to calculate the number of
blocks to reserve in a transaction involving linking an inode
into a directory. The one in rename is a bit more complicated,
but the basis of it is the same as for link and create. So it
makes sense to move this calculation into a single function
rather than repeating it three times.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9ac8f13..fa4624f 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -469,6 +469,28 @@ static void init_dinode(struct gfs2_inode *dip, struct gfs2_inode *ip,
 	brelse(dibh);
 }
 
+/**
+ * gfs2_trans_da_blocks - Calculate number of blocks to link inode
+ * @dip: The directory we are linking into
+ * @da: The dir add information
+ * @nr_inodes: The number of inodes involved
+ *
+ * This calculate the number of blocks we need to reserve in a
+ * transaction to link @nr_inodes into a directory. In most cases
+ * @nr_inodes will be 2 (the directory plus the inode being linked in)
+ * but in case of rename, 4 may be required.
+ *
+ * Returns: Number of blocks
+ */
+
+static unsigned gfs2_trans_da_blks(const struct gfs2_inode *dip,
+				   const struct gfs2_diradd *da,
+				   unsigned nr_inodes)
+{
+	return da->nr_blocks + gfs2_rg_blocks(dip, da->nr_blocks) +
+	       (nr_inodes * RES_DINODE) + RES_QUOTA + RES_STATFS;
+}
+
 static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 		       struct gfs2_inode *ip, struct gfs2_diradd *da)
 {
@@ -485,10 +507,7 @@ static int link_dinode(struct gfs2_inode *dip, const struct qstr *name,
 		if (error)
 			goto fail_quota_locks;
 
-		error = gfs2_trans_begin(sdp, da->nr_blocks +
-					 gfs2_rg_blocks(dip, da->nr_blocks) +
-					 2 * RES_DINODE +
-					 RES_STATFS + RES_QUOTA, 0);
+		error = gfs2_trans_begin(sdp, gfs2_trans_da_blks(dip, da, 2), 0);
 		if (error)
 			goto fail_ipreserv;
 	} else {
@@ -886,10 +905,7 @@ static int gfs2_link(struct dentry *old_dentry, struct inode *dir,
 		if (error)
 			goto out_gunlock_q;
 
-		error = gfs2_trans_begin(sdp, da.nr_blocks +
-					 gfs2_rg_blocks(dip, da.nr_blocks) +
-					 2 * RES_DINODE + RES_STATFS +
-					 RES_QUOTA, 0);
+		error = gfs2_trans_begin(sdp, gfs2_trans_da_blks(dip, &da, 2), 0);
 		if (error)
 			goto out_ipres;
 	} else {
@@ -1403,10 +1419,8 @@ static int gfs2_rename(struct inode *odir, struct dentry *odentry,
 		if (error)
 			goto out_gunlock_q;
 
-		error = gfs2_trans_begin(sdp, da.nr_blocks +
-					 gfs2_rg_blocks(ndip, da.nr_blocks) +
-					 4 * RES_DINODE + 4 * RES_LEAF +
-					 RES_STATFS + RES_QUOTA + 4, 0);
+		error = gfs2_trans_begin(sdp, gfs2_trans_da_blks(ndip, &da, 4) +
+					 4 * RES_LEAF + 4, 0);
 		if (error)
 			goto out_ipreserv;
 	} else {
-- 
1.8.3.1

