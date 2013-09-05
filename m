Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935580Ab3IEJ2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:28:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763514Ab3IEJ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:28:43 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/6] GFS2: Take glock reference in examine_bucket()
Date: Thu,  5 Sep 2013 10:02:08 +0100
Message-Id: <1378371732-3947-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
References: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to check the glock ref counter in a race free way
in order to ensure that the gfs2_glock_hold() call will
succeed. The easiest way to do that is to simply take the
reference count early in the common code of examine_bucket,
skipping any glocks with zero ref count.

That means that the examiner functions all need to put their
reference on the glock once they've performed their function.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-by: David Teigland <teigland@redhat.com>
Tested-by: David Teigland <teigland@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 544a809..ce7078d 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1488,7 +1488,7 @@ static void examine_bucket(glock_examiner examiner, const struct gfs2_sbd *sdp,
 
 	rcu_read_lock();
 	hlist_bl_for_each_entry_rcu(gl, pos, head, gl_list) {
-		if ((gl->gl_sbd == sdp) && atomic_read(&gl->gl_ref))
+		if ((gl->gl_sbd == sdp) && atomic_inc_not_zero(&gl->gl_ref))
 			examiner(gl);
 	}
 	rcu_read_unlock();
@@ -1508,18 +1508,17 @@ static void glock_hash_walk(glock_examiner examiner, const struct gfs2_sbd *sdp)
  * thaw_glock - thaw out a glock which has an unprocessed reply waiting
  * @gl: The glock to thaw
  *
- * N.B. When we freeze a glock, we leave a ref to the glock outstanding,
- * so this has to result in the ref count being dropped by one.
  */
 
 static void thaw_glock(struct gfs2_glock *gl)
 {
 	if (!test_and_clear_bit(GLF_FROZEN, &gl->gl_flags))
-		return;
+		goto out;
 	set_bit(GLF_REPLY_PENDING, &gl->gl_flags);
-	gfs2_glock_hold(gl);
-	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
+	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0) {
+out:
 		gfs2_glock_put(gl);
+	}
 }
 
 /**
@@ -1536,7 +1535,6 @@ static void clear_glock(struct gfs2_glock *gl)
 	if (gl->gl_state != LM_ST_UNLOCKED)
 		handle_callback(gl, LM_ST_UNLOCKED, 0, false);
 	spin_unlock(&gl->gl_spin);
-	gfs2_glock_hold(gl);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 		gfs2_glock_put(gl);
 }
-- 
1.7.4

