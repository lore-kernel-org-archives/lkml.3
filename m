Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469Ab3FDO3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:29:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62384 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab3FDOHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:18 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/4] GFS2: Fall back to vmalloc if kmalloc fails for dir hash tables
Date: Tue,  4 Jun 2013 14:40:39 +0100
Message-Id: <1370353240-5962-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1370353240-5962-1-git-send-email-swhiteho@redhat.com>
References: <1370353240-5962-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This version has one more correction: the vmalloc calls are replaced
by __vmalloc calls to preserve the GFP_NOFS flag.

When GFS2's directory management code allocates buffers for a
directory hash table, if it can't get the memory it needs, it
currently gives a bad return code. Rather than giving an error,
this patch allows it to use virtual memory rather than kernel
memory for the hash table. This should make it possible for
directories to function properly, even when kernel memory becomes
very fragmented.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index c3e82bd..b631c90 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -354,22 +354,31 @@ static __be64 *gfs2_dir_get_hash_table(struct gfs2_inode *ip)
 		return ERR_PTR(-EIO);
 	}
 
-	hc = kmalloc(hsize, GFP_NOFS);
-	ret = -ENOMEM;
+	hc = kmalloc(hsize, GFP_NOFS | __GFP_NOWARN);
+	if (hc == NULL)
+		hc = __vmalloc(hsize, GFP_NOFS, PAGE_KERNEL);
+
 	if (hc == NULL)
 		return ERR_PTR(-ENOMEM);
 
 	ret = gfs2_dir_read_data(ip, hc, hsize);
 	if (ret < 0) {
-		kfree(hc);
+		if (is_vmalloc_addr(hc))
+			vfree(hc);
+		else
+			kfree(hc);
 		return ERR_PTR(ret);
 	}
 
 	spin_lock(&inode->i_lock);
-	if (ip->i_hash_cache)
-		kfree(hc);
-	else
+	if (ip->i_hash_cache) {
+		if (is_vmalloc_addr(hc))
+			vfree(hc);
+		else
+			kfree(hc);
+	} else {
 		ip->i_hash_cache = hc;
+	}
 	spin_unlock(&inode->i_lock);
 
 	return ip->i_hash_cache;
@@ -385,7 +394,10 @@ void gfs2_dir_hash_inval(struct gfs2_inode *ip)
 {
 	__be64 *hc = ip->i_hash_cache;
 	ip->i_hash_cache = NULL;
-	kfree(hc);
+	if (is_vmalloc_addr(hc))
+		vfree(hc);
+	else
+		kfree(hc);
 }
 
 static inline int gfs2_dirent_sentinel(const struct gfs2_dirent *dent)
@@ -1113,7 +1125,10 @@ static int dir_double_exhash(struct gfs2_inode *dip)
 	if (IS_ERR(hc))
 		return PTR_ERR(hc);
 
-	h = hc2 = kmalloc(hsize_bytes * 2, GFP_NOFS);
+	h = hc2 = kmalloc(hsize_bytes * 2, GFP_NOFS | __GFP_NOWARN);
+	if (hc2 == NULL)
+		hc2 = __vmalloc(hsize_bytes * 2, GFP_NOFS, PAGE_KERNEL);
+
 	if (!hc2)
 		return -ENOMEM;
 
@@ -1145,7 +1160,10 @@ fail:
 	gfs2_dinode_out(dip, dibh->b_data);
 	brelse(dibh);
 out_kfree:
-	kfree(hc2);
+	if (is_vmalloc_addr(hc2))
+		vfree(hc2);
+	else
+		kfree(hc2);
 	return error;
 }
 
@@ -1846,6 +1864,8 @@ static int leaf_dealloc(struct gfs2_inode *dip, u32 index, u32 len,
 	memset(&rlist, 0, sizeof(struct gfs2_rgrp_list));
 
 	ht = kzalloc(size, GFP_NOFS);
+	if (ht == NULL)
+		ht = vzalloc(size);
 	if (!ht)
 		return -ENOMEM;
 
@@ -1933,7 +1953,10 @@ out_rlist:
 	gfs2_rlist_free(&rlist);
 	gfs2_quota_unhold(dip);
 out:
-	kfree(ht);
+	if (is_vmalloc_addr(ht))
+		vfree(ht);
+	else
+		kfree(ht);
 	return error;
 }
 
-- 
1.7.4

