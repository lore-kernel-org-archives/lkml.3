Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab3DZJpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:45:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759433Ab3DZJpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:45:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/8] GFS2: Remove vestigial parameter ip from function rs_deltree
Date: Fri, 26 Apr 2013 10:18:57 +0100
Message-Id: <1366967941-7184-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
References: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

The functions that delete block reservations from the rgrp block
reservations rbtree no longer use the ip parameter. This patch
eliminates the parameter.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 5e83657..1dc9a13 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -787,7 +787,7 @@ static int do_strip(struct gfs2_inode *ip, struct buffer_head *dibh,
 		goto out_rlist;
 
 	if (gfs2_rs_active(ip->i_res)) /* needs to be done with the rgrp glock held */
-		gfs2_rs_deltree(ip, ip->i_res);
+		gfs2_rs_deltree(ip->i_res);
 
 	error = gfs2_trans_begin(sdp, rg_blocks + RES_DINODE +
 				 RES_INDIRECT + RES_STATFS + RES_QUOTA,
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 71c7fc5..0c5a575 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -592,7 +592,7 @@ static void dump_rs(struct seq_file *seq, const struct gfs2_blkreserv *rs)
  * @rs: The reservation to remove
  *
  */
-static void __rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs)
+static void __rs_deltree(struct gfs2_blkreserv *rs)
 {
 	struct gfs2_rgrpd *rgd;
 
@@ -605,7 +605,7 @@ static void __rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs)
 	RB_CLEAR_NODE(&rs->rs_node);
 
 	if (rs->rs_free) {
-		/* return reserved blocks to the rgrp and the ip */
+		/* return reserved blocks to the rgrp */
 		BUG_ON(rs->rs_rbm.rgd->rd_reserved < rs->rs_free);
 		rs->rs_rbm.rgd->rd_reserved -= rs->rs_free;
 		rs->rs_free = 0;
@@ -619,14 +619,14 @@ static void __rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs)
  * @rs: The reservation to remove
  *
  */
-void gfs2_rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs)
+void gfs2_rs_deltree(struct gfs2_blkreserv *rs)
 {
 	struct gfs2_rgrpd *rgd;
 
 	rgd = rs->rs_rbm.rgd;
 	if (rgd) {
 		spin_lock(&rgd->rd_rsspin);
-		__rs_deltree(ip, rs);
+		__rs_deltree(rs);
 		spin_unlock(&rgd->rd_rsspin);
 	}
 }
@@ -640,7 +640,7 @@ void gfs2_rs_delete(struct gfs2_inode *ip)
 {
 	down_write(&ip->i_rw_mutex);
 	if (ip->i_res) {
-		gfs2_rs_deltree(ip, ip->i_res);
+		gfs2_rs_deltree(ip->i_res);
 		BUG_ON(ip->i_res->rs_free);
 		kmem_cache_free(gfs2_rsrv_cachep, ip->i_res);
 		ip->i_res = NULL;
@@ -664,7 +664,7 @@ static void return_all_reservations(struct gfs2_rgrpd *rgd)
 	spin_lock(&rgd->rd_rsspin);
 	while ((n = rb_first(&rgd->rd_rstree))) {
 		rs = rb_entry(n, struct gfs2_blkreserv, rs_node);
-		__rs_deltree(NULL, rs);
+		__rs_deltree(rs);
 	}
 	spin_unlock(&rgd->rd_rsspin);
 }
@@ -1874,7 +1874,7 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, u32 requested, u32 aflags)
 
 		/* Drop reservation, if we couldn't use reserved rgrp */
 		if (gfs2_rs_active(rs))
-			gfs2_rs_deltree(ip, rs);
+			gfs2_rs_deltree(rs);
 check_rgrp:
 		/* Check for unlinked inodes which can be reclaimed */
 		if (rs->rs_rbm.rgd->rd_flags & GFS2_RDF_CHECK)
@@ -2087,7 +2087,7 @@ static void gfs2_adjust_reservation(struct gfs2_inode *ip,
 			if (rs->rs_free && !ret)
 				goto out;
 		}
-		__rs_deltree(ip, rs);
+		__rs_deltree(rs);
 	}
 out:
 	spin_unlock(&rgd->rd_rsspin);
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 8421858..5b3f4a8 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -47,7 +47,7 @@ extern int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
 			     bool dinode, u64 *generation);
 
 extern int gfs2_rs_alloc(struct gfs2_inode *ip);
-extern void gfs2_rs_deltree(struct gfs2_inode *ip, struct gfs2_blkreserv *rs);
+extern void gfs2_rs_deltree(struct gfs2_blkreserv *rs);
 extern void gfs2_rs_delete(struct gfs2_inode *ip);
 extern void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta);
 extern void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index cab77b8..917c8e1 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1512,7 +1512,7 @@ out_truncate:
 out_unlock:
 	/* Error path for case 1 */
 	if (gfs2_rs_active(ip->i_res))
-		gfs2_rs_deltree(ip, ip->i_res);
+		gfs2_rs_deltree(ip->i_res);
 
 	if (test_bit(HIF_HOLDER, &ip->i_iopen_gh.gh_iflags))
 		gfs2_glock_dq(&ip->i_iopen_gh);
-- 
1.7.4

