Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaDAJQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaDAJQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:12 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/29] GFS2: Lock i_mutex and use a local gfs2_holder for fallocate
Date: Tue,  1 Apr 2014 10:15:16 +0100
Message-Id: <1396343741-1524-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch causes GFS2 to lock the i_mutex during fallocate. It
also switches from using a dinode's inode glock to using a local
holder like the other GFS2 i_operations.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index efc078f..6c79408 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -811,6 +811,8 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	loff_t bsize_mask = ~((loff_t)sdp->sd_sb.sb_bsize - 1);
 	loff_t next = (offset + len - 1) >> sdp->sd_sb.sb_bsize_shift;
 	loff_t max_chunk_size = UINT_MAX & bsize_mask;
+	struct gfs2_holder gh;
+
 	next = (next + 1) << sdp->sd_sb.sb_bsize_shift;
 
 	/* We only support the FALLOC_FL_KEEP_SIZE mode */
@@ -831,8 +833,10 @@ static long gfs2_fallocate(struct file *file, int mode, loff_t offset,
 	if (error)
 		return error;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
-	error = gfs2_glock_nq(&ip->i_gh);
+	mutex_lock(&inode->i_mutex);
+
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
+	error = gfs2_glock_nq(&gh);
 	if (unlikely(error))
 		goto out_uninit;
 
@@ -900,9 +904,10 @@ out_trans_fail:
 out_qunlock:
 	gfs2_quota_unlock(ip);
 out_unlock:
-	gfs2_glock_dq(&ip->i_gh);
+	gfs2_glock_dq(&gh);
 out_uninit:
-	gfs2_holder_uninit(&ip->i_gh);
+	gfs2_holder_uninit(&gh);
+	mutex_unlock(&inode->i_mutex);
 	return error;
 }
 
-- 
1.8.3.1

