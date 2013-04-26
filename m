Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab3DZJq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759628Ab3DZJpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:45:52 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 6/8] GFS2: Add origin indicator to glock callbacks
Date: Fri, 26 Apr 2013 10:18:59 +0100
Message-Id: <1366967941-7184-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
References: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a bool indicating whether the demote
request was originated locally or remotely. This is then
used by the iopen ->go_callback() to make 100% sure that
it will only respond to remote callbacks.

Since ->evict_inode() uses GL_NOCACHE when it attempts to
get an exclusive lock on the iopen lock, this may result
in extra scheduling of the workqueue in case that the
exclusive promotion request failed. This patch prevents
that from happening.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 6e30fd1..77d7927 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -912,7 +912,7 @@ int gfs2_glock_wait(struct gfs2_holder *gh)
  */
 
 static void handle_callback(struct gfs2_glock *gl, unsigned int state,
-			    unsigned long delay)
+			    unsigned long delay, bool remote)
 {
 	int bit = delay ? GLF_PENDING_DEMOTE : GLF_DEMOTE;
 
@@ -925,7 +925,7 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 		gl->gl_demote_state = LM_ST_UNLOCKED;
 	}
 	if (gl->gl_ops->go_callback)
-		gl->gl_ops->go_callback(gl);
+		gl->gl_ops->go_callback(gl, remote);
 	trace_gfs2_demote_rq(gl);
 }
 
@@ -1091,7 +1091,7 @@ void gfs2_glock_dq(struct gfs2_holder *gh)
 
 	spin_lock(&gl->gl_spin);
 	if (gh->gh_flags & GL_NOCACHE)
-		handle_callback(gl, LM_ST_UNLOCKED, 0);
+		handle_callback(gl, LM_ST_UNLOCKED, 0, false);
 
 	list_del_init(&gh->gh_list);
 	if (find_first_holder(gl) == NULL) {
@@ -1296,7 +1296,7 @@ void gfs2_glock_cb(struct gfs2_glock *gl, unsigned int state)
 	}
 
 	spin_lock(&gl->gl_spin);
-	handle_callback(gl, state, delay);
+	handle_callback(gl, state, delay, true);
 	spin_unlock(&gl->gl_spin);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, delay) == 0)
 		gfs2_glock_put(gl);
@@ -1409,7 +1409,7 @@ __acquires(&lru_lock)
 		spin_unlock(&lru_lock);
 		spin_lock(&gl->gl_spin);
 		if (demote_ok(gl))
-			handle_callback(gl, LM_ST_UNLOCKED, 0);
+			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
 		WARN_ON(!test_and_clear_bit(GLF_LOCK, &gl->gl_flags));
 		smp_mb__after_clear_bit();
 		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
@@ -1534,7 +1534,7 @@ static void clear_glock(struct gfs2_glock *gl)
 
 	spin_lock(&gl->gl_spin);
 	if (gl->gl_state != LM_ST_UNLOCKED)
-		handle_callback(gl, LM_ST_UNLOCKED, 0);
+		handle_callback(gl, LM_ST_UNLOCKED, 0, false);
 	spin_unlock(&gl->gl_spin);
 	gfs2_glock_hold(gl);
 	if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 444b650..c66e99c 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -515,12 +515,12 @@ static int trans_go_demote_ok(const struct gfs2_glock *gl)
  *
  * gl_spin lock is held while calling this
  */
-static void iopen_go_callback(struct gfs2_glock *gl)
+static void iopen_go_callback(struct gfs2_glock *gl, bool remote)
 {
 	struct gfs2_inode *ip = (struct gfs2_inode *)gl->gl_object;
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 
-	if (sdp->sd_vfs->s_flags & MS_RDONLY)
+	if (!remote || (sdp->sd_vfs->s_flags & MS_RDONLY))
 		return;
 
 	if (gl->gl_demote_state == LM_ST_UNLOCKED &&
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 2532f7e..26aabd7 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -210,7 +210,7 @@ struct gfs2_glock_operations {
 	int (*go_lock) (struct gfs2_holder *gh);
 	void (*go_unlock) (struct gfs2_holder *gh);
 	int (*go_dump)(struct seq_file *seq, const struct gfs2_glock *gl);
-	void (*go_callback) (struct gfs2_glock *gl);
+	void (*go_callback)(struct gfs2_glock *gl, bool remote);
 	const int go_type;
 	const unsigned long go_flags;
 #define GLOF_ASPACE 1
-- 
1.7.4

