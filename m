Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaATM13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:27:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbaATMYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:53 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 18/24] GFS2: Only run logd and quota when mounted read/write
Date: Mon, 20 Jan 2014 12:23:41 +0000
Message-Id: <1390220627-1571-19-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While investigating a rather strange bit of code in the quota
clean up function, I spotted that the reason for its existence
was that when remounting read only, we were not stopping the
quotad thread, and thus it was possible for it to still have
a reference to some of the quotas in that case.

This patch moves the logd and quota thread start and stop into
the make_fs_rw/ro functions, so that we now stop those threads
when mounted read only.

This means that quotad will always be stopped before we call
the quota clean up function, and we can thus dispose of the
(rather hackish) code that waits for it to give up its
reference on the quotas.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 3b820b6..27648e8 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -969,40 +969,6 @@ fail:
 	return error;
 }
 
-static int init_threads(struct gfs2_sbd *sdp, int undo)
-{
-	struct task_struct *p;
-	int error = 0;
-
-	if (undo)
-		goto fail_quotad;
-
-	p = kthread_run(gfs2_logd, sdp, "gfs2_logd");
-	if (IS_ERR(p)) {
-		error = PTR_ERR(p);
-		fs_err(sdp, "can't start logd thread: %d\n", error);
-		return error;
-	}
-	sdp->sd_logd_process = p;
-
-	p = kthread_run(gfs2_quotad, sdp, "gfs2_quotad");
-	if (IS_ERR(p)) {
-		error = PTR_ERR(p);
-		fs_err(sdp, "can't start quotad thread: %d\n", error);
-		goto fail;
-	}
-	sdp->sd_quotad_process = p;
-
-	return 0;
-
-
-fail_quotad:
-	kthread_stop(sdp->sd_quotad_process);
-fail:
-	kthread_stop(sdp->sd_logd_process);
-	return error;
-}
-
 static const match_table_t nolock_tokens = {
 	{ Opt_jid, "jid=%d\n", },
 	{ Opt_err, NULL },
@@ -1267,15 +1233,11 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 		goto fail_per_node;
 	}
 
-	error = init_threads(sdp, DO);
-	if (error)
-		goto fail_per_node;
-
 	if (!(sb->s_flags & MS_RDONLY)) {
 		error = gfs2_make_fs_rw(sdp);
 		if (error) {
 			fs_err(sdp, "can't make FS RW: %d\n", error);
-			goto fail_threads;
+			goto fail_per_node;
 		}
 	}
 
@@ -1283,8 +1245,6 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 	gfs2_online_uevent(sdp);
 	return 0;
 
-fail_threads:
-	init_threads(sdp, UNDO);
 fail_per_node:
 	init_per_node(sdp, UNDO);
 fail_inodes:
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index a1df01d..3287d98 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1376,23 +1376,6 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 	while (!list_empty(head)) {
 		qd = list_entry(head->prev, struct gfs2_quota_data, qd_list);
 
-		/*
-		 * To be removed in due course... we should be able to
-		 * ensure that all refs to the qd have done by this point
-		 * so that this rather odd test is not required
-		 */
-		spin_lock(&qd->qd_lockref.lock);
-		if (qd->qd_lockref.count > 1 ||
-		    (qd->qd_lockref.count && !test_bit(QDF_CHANGE, &qd->qd_flags))) {
-			spin_unlock(&qd->qd_lockref.lock);
-			list_move(&qd->qd_list, head);
-			spin_unlock(&qd_lock);
-			schedule();
-			spin_lock(&qd_lock);
-			continue;
-		}
-		spin_unlock(&qd->qd_lockref.lock);
-
 		list_del(&qd->qd_list);
 
 		/* Also remove if this qd exists in the reclaim list */
@@ -1404,11 +1387,8 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 		hlist_bl_del_rcu(&qd->qd_hlist);
 		spin_unlock_bucket(qd->qd_hash);
 
-		if (!qd->qd_lockref.count) {
-			gfs2_assert_warn(sdp, !qd->qd_change);
-			gfs2_assert_warn(sdp, !qd->qd_slot_count);
-		} else
-			gfs2_assert_warn(sdp, qd->qd_slot_count == 1);
+		gfs2_assert_warn(sdp, !qd->qd_change);
+		gfs2_assert_warn(sdp, !qd->qd_slot_count);
 		gfs2_assert_warn(sdp, !qd->qd_bh_count);
 
 		gfs2_glock_put(qd->qd_gl);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 35da5b1..60f60f6 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -369,6 +369,33 @@ int gfs2_jdesc_check(struct gfs2_jdesc *jd)
 	return 0;
 }
 
+static int init_threads(struct gfs2_sbd *sdp)
+{
+	struct task_struct *p;
+	int error = 0;
+
+	p = kthread_run(gfs2_logd, sdp, "gfs2_logd");
+	if (IS_ERR(p)) {
+		error = PTR_ERR(p);
+		fs_err(sdp, "can't start logd thread: %d\n", error);
+		return error;
+	}
+	sdp->sd_logd_process = p;
+
+	p = kthread_run(gfs2_quotad, sdp, "gfs2_quotad");
+	if (IS_ERR(p)) {
+		error = PTR_ERR(p);
+		fs_err(sdp, "can't start quotad thread: %d\n", error);
+		goto fail;
+	}
+	sdp->sd_quotad_process = p;
+	return 0;
+
+fail:
+	kthread_stop(sdp->sd_logd_process);
+	return error;
+}
+
 /**
  * gfs2_make_fs_rw - Turn a Read-Only FS into a Read-Write one
  * @sdp: the filesystem
@@ -384,10 +411,14 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	struct gfs2_log_header_host head;
 	int error;
 
-	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED, 0, &t_gh);
+	error = init_threads(sdp);
 	if (error)
 		return error;
 
+	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED, 0, &t_gh);
+	if (error)
+		goto fail_threads;
+
 	j_gl->gl_ops->go_inval(j_gl, DIO_METADATA);
 
 	error = gfs2_find_jhead(sdp->sd_jdesc, &head);
@@ -417,7 +448,9 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 fail:
 	t_gh.gh_flags |= GL_NOCACHE;
 	gfs2_glock_dq_uninit(&t_gh);
-
+fail_threads:
+	kthread_stop(sdp->sd_quotad_process);
+	kthread_stop(sdp->sd_logd_process);
 	return error;
 }
 
@@ -800,6 +833,9 @@ static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	struct gfs2_holder t_gh;
 	int error;
 
+	kthread_stop(sdp->sd_quotad_process);
+	kthread_stop(sdp->sd_logd_process);
+
 	flush_workqueue(gfs2_delete_workqueue);
 	gfs2_quota_sync(sdp->sd_vfs, 0);
 	gfs2_statfs_sync(sdp->sd_vfs, 0);
@@ -857,9 +893,6 @@ restart:
 	}
 	spin_unlock(&sdp->sd_jindex_spin);
 
-	kthread_stop(sdp->sd_quotad_process);
-	kthread_stop(sdp->sd_logd_process);
-
 	if (!(sb->s_flags & MS_RDONLY)) {
 		error = gfs2_make_fs_ro(sdp);
 		if (error)
-- 
1.8.3.1

