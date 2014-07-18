Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbaGRKiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:38:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761443AbaGRKiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:38:06 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/8] GFS2: Use GFP_NOFS when allocating glocks
Date: Fri, 18 Jul 2014 11:37:40 +0100
Message-Id: <1405679865-15728-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
References: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally GFP_KERNEL is ok here, but there is now a rarely used code path
relating to deallocation of unlinked inodes (in certain corner cases)
which if hit at times of memory shortage can cause recursion while
trying to free memory.

One solution would be to try and move the gfs2_glock_get() call so
that it is no longer called while another glock is held, but that
doesn't look at all easy, so GFP_NOFS is the best solution for the
time being.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c1e5b12..b703dcc 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -731,14 +731,14 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 		cachep = gfs2_glock_aspace_cachep;
 	else
 		cachep = gfs2_glock_cachep;
-	gl = kmem_cache_alloc(cachep, GFP_KERNEL);
+	gl = kmem_cache_alloc(cachep, GFP_NOFS);
 	if (!gl)
 		return -ENOMEM;
 
 	memset(&gl->gl_lksb, 0, sizeof(struct dlm_lksb));
 
 	if (glops->go_flags & GLOF_LVB) {
-		gl->gl_lksb.sb_lvbptr = kzalloc(GFS2_MIN_LVB_SIZE, GFP_KERNEL);
+		gl->gl_lksb.sb_lvbptr = kzalloc(GFS2_MIN_LVB_SIZE, GFP_NOFS);
 		if (!gl->gl_lksb.sb_lvbptr) {
 			kmem_cache_free(cachep, gl);
 			return -ENOMEM;
-- 
1.8.3.1

