Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3KDLgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752141Ab3KDLga (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:30 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/19] GFS2: Clean up reservation removal
Date: Mon,  4 Nov 2013 11:09:31 +0000
Message-Id: <1383563382-8535-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reservation for an inode should be cleared when it is truncated so
that we can start again at a different offset for future allocations.
We could try and do better than that, by resetting the search based on
where the truncation started from, but this is only a first step.

In addition, there are three callers of gfs2_rs_delete() but only one
of those should really be testing the value of i_writecount. While
we get away with that in the other cases currently, I think it would
be better if we made that test specific to the one case which
requires it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 62a65fc..21ad0f1 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1279,6 +1279,7 @@ do_grow_qunlock:
 
 int gfs2_setattr_size(struct inode *inode, u64 newsize)
 {
+	struct gfs2_inode *ip = GFS2_I(inode);
 	int ret;
 	u64 oldsize;
 
@@ -1294,7 +1295,7 @@ int gfs2_setattr_size(struct inode *inode, u64 newsize)
 
 	inode_dio_wait(inode);
 
-	ret = gfs2_rs_alloc(GFS2_I(inode));
+	ret = gfs2_rs_alloc(ip);
 	if (ret)
 		goto out;
 
@@ -1304,6 +1305,7 @@ int gfs2_setattr_size(struct inode *inode, u64 newsize)
 		goto out;
 	}
 
+	gfs2_rs_deltree(ip->i_res);
 	ret = do_shrink(inode, oldsize, newsize);
 out:
 	put_write_access(inode);
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 0621b46..9ad20ed 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -620,7 +620,7 @@ static int gfs2_release(struct inode *inode, struct file *file)
 	if (!(file->f_mode & FMODE_WRITE))
 		return 0;
 
-	gfs2_rs_delete(ip);
+	gfs2_rs_delete(ip, &inode->i_writecount);
 	return 0;
 }
 
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index cd58611..4b79c19 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -711,7 +711,7 @@ fail_gunlock2:
 fail_free_inode:
 	if (ip->i_gl)
 		gfs2_glock_put(ip->i_gl);
-	gfs2_rs_delete(ip);
+	gfs2_rs_delete(ip, NULL);
 	free_inode_nonrcu(inode);
 	inode = NULL;
 fail_gunlock:
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 285dd36..d4d10fa 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -661,14 +661,13 @@ void gfs2_rs_deltree(struct gfs2_blkreserv *rs)
 /**
  * gfs2_rs_delete - delete a multi-block reservation
  * @ip: The inode for this reservation
+ * @wcount: The inode's write count, or NULL
  *
  */
-void gfs2_rs_delete(struct gfs2_inode *ip)
+void gfs2_rs_delete(struct gfs2_inode *ip, atomic_t *wcount)
 {
-	struct inode *inode = &ip->i_inode;
-
 	down_write(&ip->i_rw_mutex);
-	if (ip->i_res && atomic_read(&inode->i_writecount) <= 1) {
+	if (ip->i_res && ((wcount == NULL) || (atomic_read(wcount) <= 1))) {
 		gfs2_rs_deltree(ip->i_res);
 		BUG_ON(ip->i_res->rs_free);
 		kmem_cache_free(gfs2_rsrv_cachep, ip->i_res);
diff --git a/fs/gfs2/rgrp.h b/fs/gfs2/rgrp.h
index 5b3f4a8..57ea16b 100644
--- a/fs/gfs2/rgrp.h
+++ b/fs/gfs2/rgrp.h
@@ -48,7 +48,7 @@ extern int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *n,
 
 extern int gfs2_rs_alloc(struct gfs2_inode *ip);
 extern void gfs2_rs_deltree(struct gfs2_blkreserv *rs);
-extern void gfs2_rs_delete(struct gfs2_inode *ip);
+extern void gfs2_rs_delete(struct gfs2_inode *ip, atomic_t *wcount);
 extern void __gfs2_free_blocks(struct gfs2_inode *ip, u64 bstart, u32 blen, int meta);
 extern void gfs2_free_meta(struct gfs2_inode *ip, u64 bstart, u32 blen);
 extern void gfs2_free_di(struct gfs2_rgrpd *rgd, struct gfs2_inode *ip);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index e5639de..35da5b1 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1526,7 +1526,7 @@ out_unlock:
 out:
 	/* Case 3 starts here */
 	truncate_inode_pages(&inode->i_data, 0);
-	gfs2_rs_delete(ip);
+	gfs2_rs_delete(ip, NULL);
 	gfs2_ordered_del_inode(ip);
 	clear_inode(inode);
 	gfs2_dir_hash_inval(ip);
-- 
1.7.4.4

