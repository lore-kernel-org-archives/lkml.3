Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaABM3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:29:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265AbaABM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:28:40 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/6] GFS2: Fix use-after-free race when calling gfs2_remove_from_ail
Date: Thu,  2 Jan 2014 12:28:10 +0000
Message-Id: <1388665694-1639-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
References: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Function gfs2_remove_from_ail drops the reference on the bh via
brelse. This patch fixes a race condition whereby bh is deferenced
after the brelse when setting bd->bd_blkno = bh->b_blocknr;
Under certain rare circumstances, bh might be gone or reused,
and bd->bd_blkno is set to whatever that memory happens to be,
which is often 0. Later, in gfs2_trans_add_unrevoke, that bd fails
the test "bd->bd_blkno >= blkno" which causes it to never be freed.
The end result is that the bd is never freed from the bufdata cache,
which results in this error:
slab error in kmem_cache_destroy(): cache `gfs2_bufdata': Can't free all objects

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 610613f..9dcb977 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -551,10 +551,10 @@ void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	struct buffer_head *bh = bd->bd_bh;
 	struct gfs2_glock *gl = bd->bd_gl;
 
-	gfs2_remove_from_ail(bd);
-	bd->bd_bh = NULL;
 	bh->b_private = NULL;
 	bd->bd_blkno = bh->b_blocknr;
+	gfs2_remove_from_ail(bd); /* drops ref on bh */
+	bd->bd_bh = NULL;
 	bd->bd_ops = &gfs2_revoke_lops;
 	sdp->sd_log_num_revoke++;
 	atomic_inc(&gl->gl_revokes);
-- 
1.8.3.1

