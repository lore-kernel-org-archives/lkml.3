Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaJHJxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:53:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaJHJxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:53:45 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] GFS2: fix bad inode i_goal values during block allocation
Date: Wed,  8 Oct 2014 10:53:10 +0100
Message-Id: <1412761993-5982-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1412761993-5982-1-git-send-email-swhiteho@redhat.com>
References: <1412761993-5982-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhi Das <adas@redhat.com>

This patch checks if i_goal is either zero or if doesn't exist
within any rgrp (i.e gfs2_blk2rgrpd() returns NULL). If so, it
assigns the ip->i_no_addr block as the i_goal.

There are two scenarios where a bad i_goal can result in a
-EBADSLT error.

1. Attempting to allocate to an existing inode:
Control reaches gfs2_inplace_reserve() and ip->i_goal is bad.
We need to fix i_goal here.

2. A new inode is created in a directory whose i_goal is hosed:
In this case, the parent dir's i_goal is copied onto the new
inode. Since the new inode is not yet created, the ip->i_no_addr
field is invalid and so, the fix in gfs2_inplace_reserve() as per
1) won't work in this scenario. We need to catch and fix it sooner
in the parent dir itself (gfs2_create_inode()), before it is
copied to the new inode.

Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index fc8ac2e..9516f5c 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -672,6 +672,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	gfs2_set_inode_blocks(inode, 1);
 	munge_mode_uid_gid(dip, inode);
+	check_and_update_goal(dip);
 	ip->i_goal = dip->i_goal;
 	ip->i_diskflags = 0;
 	ip->i_eattr = 0;
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index f4cb9c0..55ef72d 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -577,6 +577,13 @@ struct gfs2_rgrpd *gfs2_rgrpd_get_next(struct gfs2_rgrpd *rgd)
 	return rgd;
 }
 
+void check_and_update_goal(struct gfs2_inode *ip)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	if (!ip->i_goal || gfs2_blk2rgrpd(sdp, ip->i_goal, 1) == NULL)
+		ip->i_goal = ip->i_no_addr;
+}
+
 void gfs2_free_clones(struct gfs2_rgrpd *rgd)
 {
 	int x;
@@ -1910,6 +1917,7 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, const struct gfs2_alloc_parms *a
 	} else if (ip->i_rgd && rgrp_contains_block(ip->i_rgd, ip->i_goal)) {
 		rs->rs_rbm.rgd = begin = ip->i_rgd;
 	} else {
+		check_and_update_goal(ip);
 		rs->rs_rbm.rgd = begin = gfs2_blk2rgrpd(sdp, ip->i_goal, 1);
 	}
 	if (S_ISDIR(ip->i_inode.i_mode) && (ap->aflags & GFS2_AF_ORLOV))
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 463ab2e..5d8f085 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -80,4 +80,5 @@ static inline bool gfs2_rs_active(struct gfs2_blkreserv *rs)
 	return rs && !RB_EMPTY_NODE(&rs->rs_node);
 }
 
+extern void check_and_update_goal(struct gfs2_inode *ip);
 #endif /* __RGRP_DOT_H__ */
-- 
1.8.3.1

