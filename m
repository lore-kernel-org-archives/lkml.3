Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491AbaGRKiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:38:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761467AbaGRKiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:38:10 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/8] GFS2: Allow flocks to use normal glock dq rather than dq_wait
Date: Fri, 18 Jul 2014 11:37:42 +0100
Message-Id: <1405679865-15728-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
References: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch allows flock glocks to use a non-blocking dequeue rather
than dq_wait. It also reverts the previous patch I had posted regarding
dq_wait. The reverted patch isn't necessarily a bad idea, but I decided
this might avoid unforeseen side effects, and was therefore safer.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 4fc3a30..491e8e0 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -991,7 +991,7 @@ static int do_flock(struct file *file, int cmd, struct file_lock *fl)
 			goto out;
 		flock_lock_file_wait(file,
 				     &(struct file_lock){.fl_type = F_UNLCK});
-		gfs2_glock_dq_wait(fl_gh);
+		gfs2_glock_dq(fl_gh);
 		gfs2_holder_reinit(state, flags, fl_gh);
 	} else {
 		error = gfs2_glock_get(GFS2_SB(&ip->i_inode), ip->i_no_addr,
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index b703dcc..ee4e04f 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1128,9 +1128,7 @@ void gfs2_glock_dq_wait(struct gfs2_holder *gh)
 	struct gfs2_glock *gl = gh->gh_gl;
 	gfs2_glock_dq(gh);
 	might_sleep();
-	if (!find_first_holder(gl))
-		wait_on_bit(&gl->gl_flags, GLF_DEMOTE, gfs2_glock_demote_wait,
-			    TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&gl->gl_flags, GLF_DEMOTE, gfs2_glock_demote_wait, TASK_UNINTERRUPTIBLE);
 }
 
 /**
-- 
1.8.3.1

