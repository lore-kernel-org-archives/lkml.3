Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab3DZJp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:45:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932875Ab3DZJp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:45:56 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 8/8] GFS2: Flush work queue before clearing glock hash tables
Date: Fri, 26 Apr 2013 10:19:01 +0100
Message-Id: <1366967941-7184-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
References: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

There was a timing window when a GFS2 file system was unmounted
that caused GFS2 to call BUG() and panic the kernel. The call
to BUG() is meant to ensure that the glock reference count,
gl_ref, never gets down to zero and bounce back up again. What was
happening during umount is that function gfs2_put_super was dequeing
its glocks for well-known files. In particular, we saw it on the
journal glock, sd_jinode_gh. The dequeue caused delayed work to be
queued for the glock state machine, to transition the lock to an
"unlocked" state. While the work was still queued, gfs2_put_super
called gfs2_gl_hash_clear to clear out the glock hash tables.
If the timing was just so, the glock work function would drop the
reference count at the time when it was being checked for zero,
and that caused BUG() to be called. This patch calls
flush_workqueue before clearing the glock hash tables, thereby
ensuring that the delayed work is executed before the hash tables
are cleared, and therefore the reference count never goes to zero
until the glock is cleared.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 3b9e178..b777691 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1577,6 +1577,7 @@ static void dump_glock_func(struct gfs2_glock *gl)
 void gfs2_gl_hash_clear(struct gfs2_sbd *sdp)
 {
 	set_bit(SDF_SKIP_DLM_UNLOCK, &sdp->sd_flags);
+	flush_workqueue(glock_workqueue);
 	glock_hash_walk(clear_glock, sdp);
 	flush_workqueue(glock_workqueue);
 	wait_event(sdp->sd_glock_wait, atomic_read(&sdp->sd_glock_disposal) == 0);
-- 
1.7.4

