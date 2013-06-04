Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3FDOHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:07:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab3FDOHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:20 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/4] GFS2: Don't cache iopen glocks
Date: Tue,  4 Jun 2013 14:40:40 +0100
Message-Id: <1370353240-5962-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1370353240-5962-1-git-send-email-swhiteho@redhat.com>
References: <1370353240-5962-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch makes GFS2 immediately reclaim/delete all iopen glocks
as soon as they're dequeued. This allows deleters to get an
EXclusive lock on iopen so files are deleted properly instead of
being set as unlinked.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 8833a4f..62b484e 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -189,6 +189,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
 	return inode;
 
 fail_refresh:
+	ip->i_iopen_gh.gh_flags |= GL_NOCACHE;
 	ip->i_iopen_gh.gh_gl->gl_object = NULL;
 	gfs2_glock_dq_uninit(&ip->i_iopen_gh);
 fail_iopen:
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 917c8e1..e5639de 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1444,6 +1444,7 @@ static void gfs2_evict_inode(struct inode *inode)
 	/* Must not read inode block until block type has been verified */
 	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, GL_SKIP, &gh);
 	if (unlikely(error)) {
+		ip->i_iopen_gh.gh_flags |= GL_NOCACHE;
 		gfs2_glock_dq_uninit(&ip->i_iopen_gh);
 		goto out;
 	}
@@ -1514,8 +1515,10 @@ out_unlock:
 	if (gfs2_rs_active(ip->i_res))
 		gfs2_rs_deltree(ip->i_res);
 
-	if (test_bit(HIF_HOLDER, &ip->i_iopen_gh.gh_iflags))
+	if (test_bit(HIF_HOLDER, &ip->i_iopen_gh.gh_iflags)) {
+		ip->i_iopen_gh.gh_flags |= GL_NOCACHE;
 		gfs2_glock_dq(&ip->i_iopen_gh);
+	}
 	gfs2_holder_uninit(&ip->i_iopen_gh);
 	gfs2_glock_dq_uninit(&gh);
 	if (error && error != GLR_TRYFAILED && error != -EROFS)
@@ -1534,6 +1537,7 @@ out:
 	ip->i_gl = NULL;
 	if (ip->i_iopen_gh.gh_gl) {
 		ip->i_iopen_gh.gh_gl->gl_object = NULL;
+		ip->i_iopen_gh.gh_flags |= GL_NOCACHE;
 		gfs2_glock_dq_uninit(&ip->i_iopen_gh);
 	}
 }
-- 
1.7.4

