Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaKTFSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:18:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57804 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbaKTFSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:18:40 -0500
Date: Thu, 20 Nov 2014 05:18:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com
Subject: gfs2: use kvfree() instead of open-coding it
Message-ID: <20141120051838.GF7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/gfs2/dir.c   |   40 ++++++++--------------------------------
 fs/gfs2/quota.c |    9 ++-------
 2 files changed, 10 insertions(+), 39 deletions(-)

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index 5d4261f..c247fed 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -365,22 +365,15 @@ static __be64 *gfs2_dir_get_hash_table(struct gfs2_inode *ip)
 
 	ret = gfs2_dir_read_data(ip, hc, hsize);
 	if (ret < 0) {
-		if (is_vmalloc_addr(hc))
-			vfree(hc);
-		else
-			kfree(hc);
+		kvfree(hc);
 		return ERR_PTR(ret);
 	}
 
 	spin_lock(&inode->i_lock);
-	if (ip->i_hash_cache) {
-		if (is_vmalloc_addr(hc))
-			vfree(hc);
-		else
-			kfree(hc);
-	} else {
+	if (ip->i_hash_cache)
+		kvfree(hc);
+	else
 		ip->i_hash_cache = hc;
-	}
 	spin_unlock(&inode->i_lock);
 
 	return ip->i_hash_cache;
@@ -396,10 +389,7 @@ void gfs2_dir_hash_inval(struct gfs2_inode *ip)
 {
 	__be64 *hc = ip->i_hash_cache;
 	ip->i_hash_cache = NULL;
-	if (is_vmalloc_addr(hc))
-		vfree(hc);
-	else
-		kfree(hc);
+	kvfree(hc);
 }
 
 static inline int gfs2_dirent_sentinel(const struct gfs2_dirent *dent)
@@ -1168,10 +1158,7 @@ fail:
 	gfs2_dinode_out(dip, dibh->b_data);
 	brelse(dibh);
 out_kfree:
-	if (is_vmalloc_addr(hc2))
-		vfree(hc2);
-	else
-		kfree(hc2);
+	kvfree(hc2);
 	return error;
 }
 
@@ -1302,14 +1289,6 @@ static void *gfs2_alloc_sort_buffer(unsigned size)
 	return ptr;
 }
 
-static void gfs2_free_sort_buffer(void *ptr)
-{
-	if (is_vmalloc_addr(ptr))
-		vfree(ptr);
-	else
-		kfree(ptr);
-}
-
 static int gfs2_dir_read_leaf(struct inode *inode, struct dir_context *ctx,
 			      int *copied, unsigned *depth,
 			      u64 leaf_no)
@@ -1393,7 +1372,7 @@ static int gfs2_dir_read_leaf(struct inode *inode, struct dir_context *ctx,
 out_free:
 	for(i = 0; i < leaf; i++)
 		brelse(larr[i]);
-	gfs2_free_sort_buffer(larr);
+	kvfree(larr);
 out:
 	return error;
 }
@@ -2004,10 +1983,7 @@ out_rlist:
 	gfs2_rlist_free(&rlist);
 	gfs2_quota_unhold(dip);
 out:
-	if (is_vmalloc_addr(ht))
-		vfree(ht);
-	else
-		kfree(ht);
+	kvfree(ht);
 	return error;
 }
 
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 64b29f7..c8b148b 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1360,13 +1360,8 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 
 	gfs2_assert_warn(sdp, !atomic_read(&sdp->sd_quota_count));
 
-	if (sdp->sd_quota_bitmap) {
-		if (is_vmalloc_addr(sdp->sd_quota_bitmap))
-			vfree(sdp->sd_quota_bitmap);
-		else
-			kfree(sdp->sd_quota_bitmap);
-		sdp->sd_quota_bitmap = NULL;
-	}
+	kvfree(sdp->sd_quota_bitmap);
+	sdp->sd_quota_bitmap = NULL;
 }
 
 static void quotad_error(struct gfs2_sbd *sdp, const char *msg, int error)
-- 
1.7.10.4

