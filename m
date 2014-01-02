Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaABM3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:29:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbaABM2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:28:45 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/6] GFS2: Wait for async DIO in glock state changes
Date: Thu,  2 Jan 2014 12:28:13 +0000
Message-Id: <1388665694-1639-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
References: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to wait for any outstanding DIO to complete in a couple
of situations. Firstly, in case we are changing out of deferred
mode (in inode_go_sync) where GLF_DIRTY will not be set. That
call could be prefixed with a test for gl_state == LM_ST_DEFERRED
but it doesn't seem worth it bearing in mind that the test for
outstanding DIO is very quick anyway, in the usual case that there
is none.

The second case is in inode_go_lock which will catch the cases
where we have a cached EX lock, but where we grant deferred locks
against it so that there is no glock state transistion. We only
need to wait if the state is not deferred, since DIO is valid
anyway in that state.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index db908f6..f88dcd9 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -192,8 +192,11 @@ static void inode_go_sync(struct gfs2_glock *gl)
 
 	if (ip && !S_ISREG(ip->i_inode.i_mode))
 		ip = NULL;
-	if (ip && test_and_clear_bit(GIF_SW_PAGED, &ip->i_flags))
-		unmap_shared_mapping_range(ip->i_inode.i_mapping, 0, 0);
+	if (ip) {
+		if (test_and_clear_bit(GIF_SW_PAGED, &ip->i_flags))
+			unmap_shared_mapping_range(ip->i_inode.i_mapping, 0, 0);
+		inode_dio_wait(&ip->i_inode);
+	}
 	if (!test_and_clear_bit(GLF_DIRTY, &gl->gl_flags))
 		return;
 
@@ -410,6 +413,9 @@ static int inode_go_lock(struct gfs2_holder *gh)
 			return error;
 	}
 
+	if (gh->gh_state != LM_ST_DEFERRED)
+		inode_dio_wait(&ip->i_inode);
+
 	if ((ip->i_diskflags & GFS2_DIF_TRUNC_IN_PROG) &&
 	    (gl->gl_state == LM_ST_EXCLUSIVE) &&
 	    (gh->gh_state == LM_ST_EXCLUSIVE)) {
-- 
1.8.3.1

