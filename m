Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3FDOHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab3FDOHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:17 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] GFS2: Increase i_writecount during gfs2_setattr_size
Date: Tue,  4 Jun 2013 14:40:38 +0100
Message-Id: <1370353240-5962-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1370353240-5962-1-git-send-email-swhiteho@redhat.com>
References: <1370353240-5962-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch calls get_write_access in a few functions. This
merely increases inode->i_writecount for the duration of the function.
That will ensure that any file closes won't delete the inode's
multi-block reservation while the function is running.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 1dc9a13..93b5809 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1286,17 +1286,26 @@ int gfs2_setattr_size(struct inode *inode, u64 newsize)
 	if (ret)
 		return ret;
 
+	ret = get_write_access(inode);
+	if (ret)
+		return ret;
+
 	inode_dio_wait(inode);
 
 	ret = gfs2_rs_alloc(GFS2_I(inode));
 	if (ret)
-		return ret;
+		goto out;
 
 	oldsize = inode->i_size;
-	if (newsize >= oldsize)
-		return do_grow(inode, newsize);
+	if (newsize >= oldsize) {
+		ret = do_grow(inode, newsize);
+		goto out;
+	}
 
-	return do_shrink(inode, oldsize, newsize);
+	ret = do_shrink(inode, oldsize, newsize);
+out:
+	put_write_access(inode);
+	return ret;
 }
 
 int gfs2_truncatei_resume(struct gfs2_inode *ip)
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index acd1676..ad0dc38 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -402,16 +402,20 @@ static int gfs2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	/* Update file times before taking page lock */
 	file_update_time(vma->vm_file);
 
+	ret = get_write_access(inode);
+	if (ret)
+		goto out;
+
 	ret = gfs2_rs_alloc(ip);
 	if (ret)
-		return ret;
+		goto out_write_access;
 
 	gfs2_size_hint(vma->vm_file, pos, PAGE_CACHE_SIZE);
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
 	ret = gfs2_glock_nq(&gh);
 	if (ret)
-		goto out;
+		goto out_uninit;
 
 	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
 	set_bit(GIF_SW_PAGED, &ip->i_flags);
@@ -480,12 +484,15 @@ out_quota_unlock:
 	gfs2_quota_unlock(ip);
 out_unlock:
 	gfs2_glock_dq(&gh);
-out:
+out_uninit:
 	gfs2_holder_uninit(&gh);
 	if (ret == 0) {
 		set_page_dirty(page);
 		wait_for_stable_page(page);
 	}
+out_write_access:
+	put_write_access(inode);
+out:
 	sb_end_pagefault(inode->i_sb);
 	return block_page_mkwrite_return(ret);
 }
@@ -594,10 +601,10 @@ static int gfs2_release(struct inode *inode, struct file *file)
 	kfree(file->private_data);
 	file->private_data = NULL;
 
-	if ((file->f_mode & FMODE_WRITE) &&
-	    (atomic_read(&inode->i_writecount) == 1))
-		gfs2_rs_delete(ip);
+	if (!(file->f_mode & FMODE_WRITE))
+		return 0;
 
+	gfs2_rs_delete(ip);
 	return 0;
 }
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 5232525..9809156 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -638,8 +638,10 @@ void gfs2_rs_deltree(struct gfs2_blkreserv *rs)
  */
 void gfs2_rs_delete(struct gfs2_inode *ip)
 {
+	struct inode *inode = &ip->i_inode;
+
 	down_write(&ip->i_rw_mutex);
-	if (ip->i_res) {
+	if (ip->i_res && atomic_read(&inode->i_writecount) <= 1) {
 		gfs2_rs_deltree(ip->i_res);
 		BUG_ON(ip->i_res->rs_free);
 		kmem_cache_free(gfs2_rsrv_cachep, ip->i_res);
-- 
1.7.4

