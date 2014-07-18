Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761606AbaGRKkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:40:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761365AbaGRKiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:38:03 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/8] GFS2: Only wait for demote when last holder is dequeued
Date: Fri, 18 Jul 2014 11:37:38 +0100
Message-Id: <1405679865-15728-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
References: <1405679865-15728-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Function gfs2_glock_dq_wait is supposed to dequeue a glock and then
wait for the lock to be demoted. The problem is, if this is a shared
lock, its demote will depend on the other holders, which means you
might end up waiting forever because the other process is blocked.
This problem is especially apparent when dealing with nested flocks.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c355f73..278fae5 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1128,7 +1128,9 @@ void gfs2_glock_dq_wait(struct gfs2_holder *gh)
 	struct gfs2_glock *gl = gh->gh_gl;
 	gfs2_glock_dq(gh);
 	might_sleep();
-	wait_on_bit(&gl->gl_flags, GLF_DEMOTE, gfs2_glock_demote_wait, TASK_UNINTERRUPTIBLE);
+	if (!find_first_holder(gl))
+		wait_on_bit(&gl->gl_flags, GLF_DEMOTE, gfs2_glock_demote_wait,
+			    TASK_UNINTERRUPTIBLE);
 }
 
 /**
-- 
1.8.3.1

