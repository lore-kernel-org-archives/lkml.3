Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaFCLDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:03:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbaFCLCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:02:55 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/6] GFS2: remove transaction glock
Date: Tue,  3 Jun 2014 12:02:30 +0100
Message-Id: <1401793353-1469-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
References: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

GFS2 has a transaction glock, which must be grabbed for every
transaction, whose purpose is to deal with freezing the filesystem.
Aside from this involving a large amount of locking, it is very easy to
make the current fsfreeze code hang on unfreezing.

This patch rewrites how gfs2 handles freezing the filesystem. The
transaction glock is removed. In it's place is a freeze glock, which is
cached (but not held) in a shared state by every node in the cluster
when the filesystem is mounted. This lock only needs to be grabbed on
freezing, and actions which need to be safe from freezing, like
recovery.

When a node wants to freeze the filesystem, it grabs this glock
exclusively.  When the freeze glock state changes on the nodes (either
from shared to unlocked, or shared to exclusive), the filesystem does a
special log flush.  gfs2_log_flush() does all the work for flushing out
the and shutting down the incore log, and then it tries to grab the
freeze glock in a shared state again.  Since the filesystem is stuck in
gfs2_log_flush, no new transaction can start, and nothing can be written
to disk. Unfreezing the filesytem simply involes dropping the freeze
glock, allowing gfs2_log_flush() to grab and then release the shared
lock, so it is cached for next time.

However, in order for the unfreezing ioctl to occur, gfs2 needs to get a
shared lock on the filesystem root directory inode to check permissions.
If that glock has already been grabbed exclusively, fsfreeze will be
unable to get the shared lock and unfreeze the filesystem.

In order to allow the unfreeze, this patch makes gfs2 grab a shared lock
on the filesystem root directory during the freeze, and hold it until it
unfreezes the filesystem.  The functions which need to grab a shared
lock in order to allow the unfreeze ioctl to be issued now use the lock
grabbed by the freeze code instead.

The freeze and unfreeze code take care to make sure that this shared
lock will not be dropped while another process is using it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index ce62dca..5a49b03 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -431,7 +431,7 @@ static int gfs2_jdata_writepages(struct address_space *mapping,
 
 	ret = gfs2_write_cache_jdata(mapping, wbc);
 	if (ret == 0 && wbc->sync_mode == WB_SYNC_ALL) {
-		gfs2_log_flush(sdp, ip->i_gl);
+		gfs2_log_flush(sdp, ip->i_gl, NORMAL_FLUSH);
 		ret = gfs2_write_cache_jdata(mapping, wbc);
 	}
 	return ret;
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 80d6725..6065252 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -256,7 +256,7 @@ static int do_gfs2_set_flags(struct file *filp, u32 reqflags, u32 mask)
 	}
 	if ((flags ^ new_flags) & GFS2_DIF_JDATA) {
 		if (flags & GFS2_DIF_JDATA)
-			gfs2_log_flush(sdp, ip->i_gl);
+			gfs2_log_flush(sdp, ip->i_gl, NORMAL_FLUSH);
 		error = filemap_fdatawrite(inode->i_mapping);
 		if (error)
 			goto out;
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 54b66809..0b52793 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -89,18 +89,23 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	if (!tr.tr_revokes)
 		return;
 
-	/* A shortened, inline version of gfs2_trans_begin() */
+	/* A shortened, inline version of gfs2_trans_begin()
+         * tr->alloced is not set since the transaction structure is
+         * on the stack */
 	tr.tr_reserved = 1 + gfs2_struct2blk(sdp, tr.tr_revokes, sizeof(u64));
 	tr.tr_ip = (unsigned long)__builtin_return_address(0);
 	sb_start_intwrite(sdp->sd_vfs);
-	gfs2_log_reserve(sdp, tr.tr_reserved);
+	if (gfs2_log_reserve(sdp, tr.tr_reserved) < 0) {
+		sb_end_intwrite(sdp->sd_vfs);
+		return;
+	}
 	WARN_ON_ONCE(current->journal_info);
 	current->journal_info = &tr;
 
 	__gfs2_ail_flush(gl, 0, tr.tr_revokes);
 
 	gfs2_trans_end(sdp);
-	gfs2_log_flush(sdp, NULL);
+	gfs2_log_flush(sdp, NULL, NORMAL_FLUSH);
 }
 
 void gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
@@ -121,7 +126,7 @@ void gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
 		return;
 	__gfs2_ail_flush(gl, fsync, max_revokes);
 	gfs2_trans_end(sdp);
-	gfs2_log_flush(sdp, NULL);
+	gfs2_log_flush(sdp, NULL, NORMAL_FLUSH);
 }
 
 /**
@@ -144,7 +149,7 @@ static void rgrp_go_sync(struct gfs2_glock *gl)
 		return;
 	GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_EXCLUSIVE);
 
-	gfs2_log_flush(sdp, gl);
+	gfs2_log_flush(sdp, gl, NORMAL_FLUSH);
 	filemap_fdatawrite_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
 	error = filemap_fdatawait_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
 	mapping_set_error(mapping, error);
@@ -206,7 +211,7 @@ static void inode_go_sync(struct gfs2_glock *gl)
 
 	GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_EXCLUSIVE);
 
-	gfs2_log_flush(gl->gl_sbd, gl);
+	gfs2_log_flush(gl->gl_sbd, gl, NORMAL_FLUSH);
 	filemap_fdatawrite(metamapping);
 	if (ip) {
 		struct address_space *mapping = ip->i_inode.i_mapping;
@@ -253,7 +258,7 @@ static void inode_go_inval(struct gfs2_glock *gl, int flags)
 	}
 
 	if (ip == GFS2_I(gl->gl_sbd->sd_rindex)) {
-		gfs2_log_flush(gl->gl_sbd, NULL);
+		gfs2_log_flush(gl->gl_sbd, NULL, NORMAL_FLUSH);
 		gl->gl_sbd->sd_rindex_uptodate = 0;
 	}
 	if (ip && S_ISREG(ip->i_inode.i_mode))
@@ -455,31 +460,39 @@ static void inode_go_dump(struct seq_file *seq, const struct gfs2_glock *gl)
 }
 
 /**
- * trans_go_sync - promote/demote the transaction glock
+ * freeze_go_sync - promote/demote the freeze glock
  * @gl: the glock
  * @state: the requested state
  * @flags:
  *
  */
 
-static void trans_go_sync(struct gfs2_glock *gl)
+static void freeze_go_sync(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
+	DEFINE_WAIT(wait);
 
-	if (gl->gl_state != LM_ST_UNLOCKED &&
+	if (gl->gl_state == LM_ST_SHARED &&
 	    test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags)) {
-		gfs2_meta_syncfs(sdp);
-		gfs2_log_shutdown(sdp);
+		atomic_set(&sdp->sd_log_freeze, 1);
+		wake_up(&sdp->sd_logd_waitq);
+		do {
+			prepare_to_wait(&sdp->sd_log_frozen_wait, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (atomic_read(&sdp->sd_log_freeze))
+				io_schedule();
+		} while(atomic_read(&sdp->sd_log_freeze));
+		finish_wait(&sdp->sd_log_frozen_wait, &wait);
 	}
 }
 
 /**
- * trans_go_xmote_bh - After promoting/demoting the transaction glock
+ * freeze_go_xmote_bh - After promoting/demoting the freeze glock
  * @gl: the glock
  *
  */
 
-static int trans_go_xmote_bh(struct gfs2_glock *gl, struct gfs2_holder *gh)
+static int freeze_go_xmote_bh(struct gfs2_glock *gl, struct gfs2_holder *gh)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_jdesc->jd_inode);
@@ -512,7 +525,7 @@ static int trans_go_xmote_bh(struct gfs2_glock *gl, struct gfs2_holder *gh)
  * Always returns 0
  */
 
-static int trans_go_demote_ok(const struct gfs2_glock *gl)
+static int freeze_go_demote_ok(const struct gfs2_glock *gl)
 {
 	return 0;
 }
@@ -563,10 +576,10 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_flags = GLOF_LVB,
 };
 
-const struct gfs2_glock_operations gfs2_trans_glops = {
-	.go_sync = trans_go_sync,
-	.go_xmote_bh = trans_go_xmote_bh,
-	.go_demote_ok = trans_go_demote_ok,
+const struct gfs2_glock_operations gfs2_freeze_glops = {
+	.go_sync = freeze_go_sync,
+	.go_xmote_bh = freeze_go_xmote_bh,
+	.go_demote_ok = freeze_go_demote_ok,
 	.go_type = LM_TYPE_NONDISK,
 };
 
diff --git a/fs/gfs2/glops.h b/fs/gfs2/glops.h
index bf95a2d..7455d26 100644
--- a/fs/gfs2/glops.h
+++ b/fs/gfs2/glops.h
@@ -15,7 +15,7 @@
 extern const struct gfs2_glock_operations gfs2_meta_glops;
 extern const struct gfs2_glock_operations gfs2_inode_glops;
 extern const struct gfs2_glock_operations gfs2_rgrp_glops;
-extern const struct gfs2_glock_operations gfs2_trans_glops;
+extern const struct gfs2_glock_operations gfs2_freeze_glops;
 extern const struct gfs2_glock_operations gfs2_iopen_glops;
 extern const struct gfs2_glock_operations gfs2_flock_glops;
 extern const struct gfs2_glock_operations gfs2_nondisk_glops;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index bdf70c1..2434a96 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -465,9 +465,7 @@ struct gfs2_trans {
 	unsigned int tr_reserved;
 	unsigned int tr_touched:1;
 	unsigned int tr_attached:1;
-
-	struct gfs2_holder tr_t_gh;
-
+	unsigned int tr_alloced:1;
 
 	unsigned int tr_num_buf_new;
 	unsigned int tr_num_databuf_new;
@@ -682,7 +680,7 @@ struct gfs2_sbd {
 	struct lm_lockstruct sd_lockstruct;
 	struct gfs2_holder sd_live_gh;
 	struct gfs2_glock *sd_rename_gl;
-	struct gfs2_glock *sd_trans_gl;
+	struct gfs2_glock *sd_freeze_gl;
 	wait_queue_head_t sd_glock_wait;
 	atomic_t sd_glock_disposal;
 	struct completion sd_locking_init;
@@ -794,6 +792,12 @@ struct gfs2_sbd {
 
 	/* For quiescing the filesystem */
 	struct gfs2_holder sd_freeze_gh;
+	struct gfs2_holder sd_freeze_root_gh;
+	struct gfs2_holder sd_thaw_gh;
+	atomic_t sd_log_freeze;
+	atomic_t sd_frozen_root;
+	wait_queue_head_t sd_frozen_root_wait;
+	wait_queue_head_t sd_log_frozen_wait;
 
 	char sd_fsname[GFS2_FSNAME_LEN];
 	char sd_table_name[GFS2_FSNAME_LEN];
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 28cc7bf..e62e594 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1613,18 +1613,26 @@ int gfs2_permission(struct inode *inode, int mask)
 {
 	struct gfs2_inode *ip;
 	struct gfs2_holder i_gh;
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	int error;
 	int unlock = 0;
+	int frozen_root = 0;
 
 
 	ip = GFS2_I(inode);
 	if (gfs2_glock_is_locked_by_me(ip->i_gl) == NULL) {
-		if (mask & MAY_NOT_BLOCK)
-			return -ECHILD;
-		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
-		if (error)
-			return error;
-		unlock = 1;
+		if (unlikely(gfs2_glock_is_held_excl(sdp->sd_freeze_gl) &&
+			     inode == sdp->sd_root_dir->d_inode &&
+			     atomic_inc_not_zero(&sdp->sd_frozen_root)))
+			frozen_root = 1;
+		else {
+			if (mask & MAY_NOT_BLOCK)
+				return -ECHILD;
+			error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &i_gh);
+			if (error)
+				return error;
+			unlock = 1;
+		}
 	}
 
 	if ((mask & MAY_WRITE) && IS_IMMUTABLE(inode))
@@ -1633,6 +1641,8 @@ int gfs2_permission(struct inode *inode, int mask)
 		error = generic_permission(inode, mask);
 	if (unlock)
 		gfs2_glock_dq_uninit(&i_gh);
+	else if (frozen_root && atomic_dec_and_test(&sdp->sd_frozen_root))
+		wake_up(&sdp->sd_frozen_root_wait);
 
 	return error;
 }
@@ -1805,19 +1815,29 @@ static int gfs2_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	struct inode *inode = dentry->d_inode;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_holder gh;
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	int error;
 	int unlock = 0;
+	int frozen_root = 0;
 
 	if (gfs2_glock_is_locked_by_me(ip->i_gl) == NULL) {
-		error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
-		if (error)
-			return error;
-		unlock = 1;
+		if (unlikely(gfs2_glock_is_held_excl(sdp->sd_freeze_gl) &&
+			     inode == sdp->sd_root_dir->d_inode &&
+			     atomic_inc_not_zero(&sdp->sd_frozen_root)))
+			frozen_root = 1;
+		else {
+			error = gfs2_glock_nq_init(ip->i_gl, LM_ST_SHARED, LM_FLAG_ANY, &gh);
+			if (error)
+				return error;
+			unlock = 1;
+		}
 	}
 
 	generic_fillattr(inode, stat);
 	if (unlock)
 		gfs2_glock_dq_uninit(&gh);
+	else if (frozen_root && atomic_dec_and_test(&sdp->sd_frozen_root))
+		wake_up(&sdp->sd_frozen_root_wait);
 
 	return 0;
 }
diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
index 4a14d50..3966fad 100644
--- a/fs/gfs2/log.c
+++ b/fs/gfs2/log.c
@@ -301,6 +301,23 @@ static void ail2_empty(struct gfs2_sbd *sdp, unsigned int new_tail)
 }
 
 /**
+ * gfs2_log_release - Release a given number of log blocks
+ * @sdp: The GFS2 superblock
+ * @blks: The number of blocks
+ *
+ */
+
+void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
+{
+
+	atomic_add(blks, &sdp->sd_log_blks_free);
+	trace_gfs2_log_blocks(sdp, blks);
+	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
+				  sdp->sd_jdesc->jd_blocks);
+	up_read(&sdp->sd_log_flush_lock);
+}
+
+/**
  * gfs2_log_reserve - Make a log reservation
  * @sdp: The GFS2 superblock
  * @blks: The number of blocks to reserve
@@ -358,7 +375,10 @@ retry:
 		wake_up(&sdp->sd_log_waitq);
 
 	down_read(&sdp->sd_log_flush_lock);
-
+	if (unlikely(!test_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags))) {
+		gfs2_log_release(sdp, blks);
+		return -EROFS;
+	}
 	return 0;
 }
 
@@ -671,7 +691,8 @@ static void log_write_header(struct gfs2_sbd *sdp, u32 flags)
  *
  */
 
-void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
+void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl,
+		    enum gfs2_flush_type type)
 {
 	struct gfs2_trans *tr;
 
@@ -723,6 +744,42 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
 	}
 	spin_unlock(&sdp->sd_ail_lock);
 	gfs2_log_unlock(sdp);
+
+	if (atomic_read(&sdp->sd_log_freeze))
+		type = FREEZE_FLUSH;
+	if (type != NORMAL_FLUSH) {
+		if (!sdp->sd_log_idle) {
+			for (;;) {
+				gfs2_ail1_start(sdp);
+				gfs2_ail1_wait(sdp);
+				if (gfs2_ail1_empty(sdp))
+					break;
+			}
+			atomic_dec(&sdp->sd_log_blks_free); /* Adjust for unreserved buffer */
+			trace_gfs2_log_blocks(sdp, -1);
+			sdp->sd_log_flush_wrapped = 0;
+			log_write_header(sdp, 0);
+			sdp->sd_log_head = sdp->sd_log_flush_head;
+		}
+		if (type == SHUTDOWN_FLUSH || type == FREEZE_FLUSH)
+			gfs2_log_shutdown(sdp);
+		if (type == FREEZE_FLUSH) {
+			int error;
+
+			atomic_set(&sdp->sd_log_freeze, 0);
+			wake_up(&sdp->sd_log_frozen_wait);
+			error = gfs2_glock_nq_init(sdp->sd_freeze_gl,
+						   LM_ST_SHARED, 0,
+						   &sdp->sd_thaw_gh);
+			if (error) {
+				printk(KERN_INFO "GFS2: couln't get freeze lock : %d\n", error);
+				gfs2_assert_withdraw(sdp, 0);
+			}
+			else
+				gfs2_glock_dq_uninit(&sdp->sd_thaw_gh);
+		}
+	}
+
 	trace_gfs2_log_flush(sdp, 0);
 	up_write(&sdp->sd_log_flush_lock);
 
@@ -761,7 +818,7 @@ static void log_refund(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 	if (sdp->sd_log_tr) {
 		gfs2_merge_trans(sdp->sd_log_tr, tr);
 	} else if (tr->tr_num_buf_new || tr->tr_num_databuf_new) {
-		gfs2_assert_withdraw(sdp, tr->tr_t_gh.gh_gl);
+		gfs2_assert_withdraw(sdp, tr->tr_alloced);
 		sdp->sd_log_tr = tr;
 		tr->tr_attached = 1;
 	}
@@ -813,8 +870,6 @@ void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *tr)
 
 void gfs2_log_shutdown(struct gfs2_sbd *sdp)
 {
-	down_write(&sdp->sd_log_flush_lock);
-
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_blks_reserved);
 	gfs2_assert_withdraw(sdp, !sdp->sd_log_num_revoke);
 	gfs2_assert_withdraw(sdp, list_empty(&sdp->sd_ail1_list));
@@ -824,38 +879,16 @@ void gfs2_log_shutdown(struct gfs2_sbd *sdp)
 
 	log_write_header(sdp, GFS2_LOG_HEAD_UNMOUNT);
 
-	gfs2_assert_warn(sdp, atomic_read(&sdp->sd_log_blks_free) == sdp->sd_jdesc->jd_blocks);
 	gfs2_assert_warn(sdp, sdp->sd_log_head == sdp->sd_log_tail);
 	gfs2_assert_warn(sdp, list_empty(&sdp->sd_ail2_list));
 
 	sdp->sd_log_head = sdp->sd_log_flush_head;
 	sdp->sd_log_tail = sdp->sd_log_head;
-
-	up_write(&sdp->sd_log_flush_lock);
-}
-
-
-/**
- * gfs2_meta_syncfs - sync all the buffers in a filesystem
- * @sdp: the filesystem
- *
- */
-
-void gfs2_meta_syncfs(struct gfs2_sbd *sdp)
-{
-	gfs2_log_flush(sdp, NULL);
-	for (;;) {
-		gfs2_ail1_start(sdp);
-		gfs2_ail1_wait(sdp);
-		if (gfs2_ail1_empty(sdp))
-			break;
-	}
-	gfs2_log_flush(sdp, NULL);
 }
 
 static inline int gfs2_jrnl_flush_reqd(struct gfs2_sbd *sdp)
 {
-	return (atomic_read(&sdp->sd_log_pinned) >= atomic_read(&sdp->sd_log_thresh1));
+	return (atomic_read(&sdp->sd_log_pinned) >= atomic_read(&sdp->sd_log_thresh1) || atomic_read(&sdp->sd_log_freeze));
 }
 
 static inline int gfs2_ail_flush_reqd(struct gfs2_sbd *sdp)
@@ -882,14 +915,14 @@ int gfs2_logd(void *data)
 
 		if (gfs2_jrnl_flush_reqd(sdp) || t == 0) {
 			gfs2_ail1_empty(sdp);
-			gfs2_log_flush(sdp, NULL);
+			gfs2_log_flush(sdp, NULL, NORMAL_FLUSH);
 		}
 
 		if (gfs2_ail_flush_reqd(sdp)) {
 			gfs2_ail1_start(sdp);
 			gfs2_ail1_wait(sdp);
 			gfs2_ail1_empty(sdp);
-			gfs2_log_flush(sdp, NULL);
+			gfs2_log_flush(sdp, NULL, NORMAL_FLUSH);
 		}
 
 		if (!gfs2_ail_flush_reqd(sdp))
diff --git a/fs/gfs2/log.h b/fs/gfs2/log.h
index 3721663..9499a60 100644
--- a/fs/gfs2/log.h
+++ b/fs/gfs2/log.h
@@ -63,14 +63,21 @@ extern void gfs2_ordered_del_inode(struct gfs2_inode *ip);
 extern unsigned int gfs2_struct2blk(struct gfs2_sbd *sdp, unsigned int nstruct,
 			    unsigned int ssize);
 
+extern void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks);
 extern int gfs2_log_reserve(struct gfs2_sbd *sdp, unsigned int blks);
-extern void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl);
+enum gfs2_flush_type {
+	NORMAL_FLUSH = 0,
+	SYNC_FLUSH,
+	SHUTDOWN_FLUSH,
+	FREEZE_FLUSH
+};
+extern void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl,
+			   enum gfs2_flush_type type);
 extern void gfs2_log_commit(struct gfs2_sbd *sdp, struct gfs2_trans *trans);
 extern void gfs2_remove_from_ail(struct gfs2_bufdata *bd);
 extern void gfs2_ail1_flush(struct gfs2_sbd *sdp, struct writeback_control *wbc);
 
 extern void gfs2_log_shutdown(struct gfs2_sbd *sdp);
-extern void gfs2_meta_syncfs(struct gfs2_sbd *sdp);
 extern int gfs2_logd(void *data);
 extern void gfs2_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd);
 extern void gfs2_write_revokes(struct gfs2_sbd *sdp);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 22f9540..be45c79 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -129,6 +129,10 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	init_rwsem(&sdp->sd_log_flush_lock);
 	atomic_set(&sdp->sd_log_in_flight, 0);
 	init_waitqueue_head(&sdp->sd_log_flush_wait);
+	init_waitqueue_head(&sdp->sd_log_frozen_wait);
+	atomic_set(&sdp->sd_log_freeze, 0);
+	atomic_set(&sdp->sd_frozen_root, 0);
+	init_waitqueue_head(&sdp->sd_frozen_root_wait);
 
 	return sdp;
 }
@@ -419,8 +423,8 @@ static int init_locking(struct gfs2_sbd *sdp, struct gfs2_holder *mount_gh,
 		goto fail_live;
 	}
 
-	error = gfs2_glock_get(sdp, GFS2_TRANS_LOCK, &gfs2_trans_glops,
-			       CREATE, &sdp->sd_trans_gl);
+	error = gfs2_glock_get(sdp, GFS2_FREEZE_LOCK, &gfs2_freeze_glops,
+			       CREATE, &sdp->sd_freeze_gl);
 	if (error) {
 		fs_err(sdp, "can't create transaction glock: %d\n", error);
 		goto fail_rename;
@@ -429,7 +433,7 @@ static int init_locking(struct gfs2_sbd *sdp, struct gfs2_holder *mount_gh,
 	return 0;
 
 fail_trans:
-	gfs2_glock_put(sdp->sd_trans_gl);
+	gfs2_glock_put(sdp->sd_freeze_gl);
 fail_rename:
 	gfs2_glock_put(sdp->sd_rename_gl);
 fail_live:
@@ -755,7 +759,15 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 	set_bit(SDF_JOURNAL_CHECKED, &sdp->sd_flags);
 	gfs2_glock_dq_uninit(&ji_gh);
 	jindex = 0;
-
+	if (!sdp->sd_args.ar_spectator) {
+		error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, 0,
+					   &sdp->sd_thaw_gh);
+		if (error) {
+			fs_err(sdp, "can't acquire freeze glock: %d\n", error);
+			goto fail_jinode_gh;
+		}
+	}
+	gfs2_glock_dq_uninit(&sdp->sd_thaw_gh);
 	return 0;
 
 fail_jinode_gh:
@@ -1380,7 +1392,7 @@ static void gfs2_kill_sb(struct super_block *sb)
 		return;
 	}
 
-	gfs2_meta_syncfs(sdp);
+	gfs2_log_flush(sdp, NULL, SYNC_FLUSH);
 	dput(sdp->sd_root_dir);
 	dput(sdp->sd_master_dir);
 	sdp->sd_root_dir = NULL;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 6193896..64b29f7 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -880,7 +880,7 @@ out:
 		gfs2_glock_dq_uninit(&ghs[qx]);
 	mutex_unlock(&ip->i_inode.i_mutex);
 	kfree(ghs);
-	gfs2_log_flush(ip->i_gl->gl_sbd, ip->i_gl);
+	gfs2_log_flush(ip->i_gl->gl_sbd, ip->i_gl, NORMAL_FLUSH);
 	return error;
 }
 
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 7ad4094..a4ed78b 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -454,7 +454,7 @@ void gfs2_recover_func(struct work_struct *work)
 	struct gfs2_inode *ip = GFS2_I(jd->jd_inode);
 	struct gfs2_sbd *sdp = GFS2_SB(jd->jd_inode);
 	struct gfs2_log_header_host head;
-	struct gfs2_holder j_gh, ji_gh, t_gh;
+	struct gfs2_holder j_gh, ji_gh, thaw_gh;
 	unsigned long t;
 	int ro = 0;
 	unsigned int pass;
@@ -508,11 +508,11 @@ void gfs2_recover_func(struct work_struct *work)
 
 		t = jiffies;
 
-		/* Acquire a shared hold on the transaction lock */
+		/* Acquire a shared hold on the freeze lock */
 
-		error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED,
-					   LM_FLAG_NOEXP | LM_FLAG_PRIORITY |
-					   GL_NOCACHE, &t_gh);
+		error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED,
+					   LM_FLAG_NOEXP | LM_FLAG_PRIORITY,
+					   &thaw_gh);
 		if (error)
 			goto fail_gunlock_ji;
 
@@ -538,7 +538,7 @@ void gfs2_recover_func(struct work_struct *work)
 			fs_warn(sdp, "jid=%u: Can't replay: read-only block "
 				"device\n", jd->jd_jid);
 			error = -EROFS;
-			goto fail_gunlock_tr;
+			goto fail_gunlock_thaw;
 		}
 
 		fs_info(sdp, "jid=%u: Replaying journal...\n", jd->jd_jid);
@@ -549,14 +549,14 @@ void gfs2_recover_func(struct work_struct *work)
 						   head.lh_blkno, pass);
 			lops_after_scan(jd, error, pass);
 			if (error)
-				goto fail_gunlock_tr;
+				goto fail_gunlock_thaw;
 		}
 
 		error = clean_journal(jd, &head);
 		if (error)
-			goto fail_gunlock_tr;
+			goto fail_gunlock_thaw;
 
-		gfs2_glock_dq_uninit(&t_gh);
+		gfs2_glock_dq_uninit(&thaw_gh);
 		t = DIV_ROUND_UP(jiffies - t, HZ);
 		fs_info(sdp, "jid=%u: Journal replayed in %lus\n",
 			jd->jd_jid, t);
@@ -572,8 +572,8 @@ void gfs2_recover_func(struct work_struct *work)
 	fs_info(sdp, "jid=%u: Done\n", jd->jd_jid);
 	goto done;
 
-fail_gunlock_tr:
-	gfs2_glock_dq_uninit(&t_gh);
+fail_gunlock_thaw:
+	gfs2_glock_dq_uninit(&thaw_gh);
 fail_gunlock_ji:
 	if (jlocked) {
 		gfs2_glock_dq_uninit(&ji_gh);
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 281a771..db629d1 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -2001,7 +2001,7 @@ next_rgrp:
 		}
 		/* Flushing the log may release space */
 		if (loops == 2)
-			gfs2_log_flush(sdp, NULL);
+			gfs2_log_flush(sdp, NULL, NORMAL_FLUSH);
 	}
 
 	return -ENOSPC;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index de8afad..1319b5c 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -399,7 +399,7 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 {
 	struct gfs2_inode *ip = GFS2_I(sdp->sd_jdesc->jd_inode);
 	struct gfs2_glock *j_gl = ip->i_gl;
-	struct gfs2_holder t_gh;
+	struct gfs2_holder thaw_gh;
 	struct gfs2_log_header_host head;
 	int error;
 
@@ -407,7 +407,8 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	if (error)
 		return error;
 
-	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED, 0, &t_gh);
+	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, 0,
+				   &thaw_gh);
 	if (error)
 		goto fail_threads;
 
@@ -433,13 +434,13 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 
 	set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 
-	gfs2_glock_dq_uninit(&t_gh);
+	gfs2_glock_dq_uninit(&thaw_gh);
 
 	return 0;
 
 fail:
-	t_gh.gh_flags |= GL_NOCACHE;
-	gfs2_glock_dq_uninit(&t_gh);
+	thaw_gh.gh_flags |= GL_NOCACHE;
+	gfs2_glock_dq_uninit(&thaw_gh);
 fail_threads:
 	kthread_stop(sdp->sd_quotad_process);
 	kthread_stop(sdp->sd_logd_process);
@@ -635,15 +636,21 @@ struct lfcc {
  */
 
 static int gfs2_lock_fs_check_clean(struct gfs2_sbd *sdp,
-				    struct gfs2_holder *t_gh)
+				    struct gfs2_holder *freeze_gh)
 {
 	struct gfs2_inode *ip;
 	struct gfs2_jdesc *jd;
 	struct lfcc *lfcc;
 	LIST_HEAD(list);
 	struct gfs2_log_header_host lh;
+	struct gfs2_inode *dip = GFS2_I(sdp->sd_root_dir->d_inode);
 	int error;
 
+	error = gfs2_glock_nq_init(dip->i_gl, LM_ST_SHARED, 0,
+				   &sdp->sd_freeze_root_gh);
+	if (error)
+		return error;
+	atomic_set(&sdp->sd_frozen_root, 1);
 	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
 		lfcc = kmalloc(sizeof(struct lfcc), GFP_KERNEL);
 		if (!lfcc) {
@@ -659,8 +666,8 @@ static int gfs2_lock_fs_check_clean(struct gfs2_sbd *sdp,
 		list_add(&lfcc->list, &list);
 	}
 
-	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_DEFERRED,
-				   GL_NOCACHE, t_gh);
+	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_EXCLUSIVE,
+				   GL_NOCACHE, freeze_gh);
 
 	list_for_each_entry(jd, &sdp->sd_jindex_list, jd_list) {
 		error = gfs2_jdesc_check(jd);
@@ -676,7 +683,7 @@ static int gfs2_lock_fs_check_clean(struct gfs2_sbd *sdp,
 	}
 
 	if (error)
-		gfs2_glock_dq_uninit(t_gh);
+		gfs2_glock_dq_uninit(freeze_gh);
 
 out:
 	while (!list_empty(&list)) {
@@ -685,6 +692,11 @@ out:
 		gfs2_glock_dq_uninit(&lfcc->gh);
 		kfree(lfcc);
 	}
+	if (error) {
+		atomic_dec(&sdp->sd_frozen_root);
+		wait_event(sdp->sd_frozen_root_wait, atomic_read(&sdp->sd_frozen_root) == 0);
+		gfs2_glock_dq_uninit(&sdp->sd_freeze_root_gh);
+	}
 	return error;
 }
 
@@ -742,7 +754,7 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 	int ret = 0;
 
 	if (wbc->sync_mode == WB_SYNC_ALL)
-		gfs2_log_flush(GFS2_SB(inode), ip->i_gl);
+		gfs2_log_flush(GFS2_SB(inode), ip->i_gl, NORMAL_FLUSH);
 	if (bdi->dirty_exceeded)
 		gfs2_ail1_flush(sdp, wbc);
 	else
@@ -822,9 +834,18 @@ out:
 
 static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 {
-	struct gfs2_holder t_gh;
+	struct gfs2_holder thaw_gh;
 	int error;
 
+	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, GL_NOCACHE,
+				   &thaw_gh);
+	if (error && !test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
+		return error;
+
+	down_write(&sdp->sd_log_flush_lock);
+	clear_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
+	up_write(&sdp->sd_log_flush_lock);
+
 	kthread_stop(sdp->sd_quotad_process);
 	kthread_stop(sdp->sd_logd_process);
 
@@ -832,18 +853,11 @@ static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	gfs2_quota_sync(sdp->sd_vfs, 0);
 	gfs2_statfs_sync(sdp->sd_vfs, 0);
 
-	error = gfs2_glock_nq_init(sdp->sd_trans_gl, LM_ST_SHARED, GL_NOCACHE,
-				   &t_gh);
-	if (error && !test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
-		return error;
-
-	gfs2_meta_syncfs(sdp);
-	gfs2_log_shutdown(sdp);
-
-	clear_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
+	gfs2_log_flush(sdp, NULL, SHUTDOWN_FLUSH);
+	gfs2_assert_warn(sdp, atomic_read(&sdp->sd_log_blks_free) == sdp->sd_jdesc->jd_blocks);
 
-	if (t_gh.gh_gl)
-		gfs2_glock_dq_uninit(&t_gh);
+	if (thaw_gh.gh_gl)
+		gfs2_glock_dq_uninit(&thaw_gh);
 
 	gfs2_quota_cleanup(sdp);
 
@@ -900,7 +914,7 @@ restart:
 	iput(sdp->sd_quota_inode);
 
 	gfs2_glock_put(sdp->sd_rename_gl);
-	gfs2_glock_put(sdp->sd_trans_gl);
+	gfs2_glock_put(sdp->sd_freeze_gl);
 
 	if (!sdp->sd_args.ar_spectator) {
 		gfs2_glock_dq_uninit(&sdp->sd_journal_gh);
@@ -935,8 +949,8 @@ static int gfs2_sync_fs(struct super_block *sb, int wait)
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 
 	gfs2_quota_sync(sb, -1);
-	if (wait && sdp)
-		gfs2_log_flush(sdp, NULL);
+	if (wait && sdp && !atomic_read(&sdp->sd_log_freeze))
+		gfs2_log_flush(sdp, NULL, NORMAL_FLUSH);
 	return 0;
 }
 
@@ -986,6 +1000,9 @@ static int gfs2_unfreeze(struct super_block *sb)
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 
 	gfs2_glock_dq_uninit(&sdp->sd_freeze_gh);
+	atomic_dec(&sdp->sd_frozen_root);
+	wait_event(sdp->sd_frozen_root_wait, atomic_read(&sdp->sd_frozen_root) == 0);
+	gfs2_glock_dq_uninit(&sdp->sd_freeze_root_gh);
 	return 0;
 }
 
@@ -1525,7 +1542,7 @@ static void gfs2_evict_inode(struct inode *inode)
 	goto out_unlock;
 
 out_truncate:
-	gfs2_log_flush(sdp, ip->i_gl);
+	gfs2_log_flush(sdp, ip->i_gl, NORMAL_FLUSH);
 	if (test_bit(GLF_DIRTY, &ip->i_gl->gl_flags)) {
 		struct address_space *metamapping = gfs2_glock2aspace(ip->i_gl);
 		filemap_fdatawrite(metamapping);
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index de25d55..7bc17ed 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -240,8 +240,8 @@ static ssize_t demote_rq_store(struct gfs2_sbd *sdp, const char *buf, size_t len
 
 	if (gltype > LM_TYPE_JOURNAL)
 		return -EINVAL;
-	if (gltype == LM_TYPE_NONDISK && glnum == GFS2_TRANS_LOCK)
-		glops = &gfs2_trans_glops;
+	if (gltype == LM_TYPE_NONDISK && glnum == GFS2_FREEZE_LOCK)
+		glops = &gfs2_freeze_glops;
 	else
 		glops = gfs2_glops_list[gltype];
 	if (glops == NULL)
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index bead90d..0546ab4 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -48,6 +48,7 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 	tr->tr_blocks = blocks;
 	tr->tr_revokes = revokes;
 	tr->tr_reserved = 1;
+	tr->tr_alloced = 1;
 	if (blocks)
 		tr->tr_reserved += 6 + blocks;
 	if (revokes)
@@ -57,48 +58,22 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
 	INIT_LIST_HEAD(&tr->tr_buf);
 
 	sb_start_intwrite(sdp->sd_vfs);
-	gfs2_holder_init(sdp->sd_trans_gl, LM_ST_SHARED, 0, &tr->tr_t_gh);
-
-	error = gfs2_glock_nq(&tr->tr_t_gh);
-	if (error)
-		goto fail_holder_uninit;
 
 	error = gfs2_log_reserve(sdp, tr->tr_reserved);
 	if (error)
-		goto fail_gunlock;
+		goto fail;
 
 	current->journal_info = tr;
 
 	return 0;
 
-fail_gunlock:
-	gfs2_glock_dq(&tr->tr_t_gh);
-
-fail_holder_uninit:
+fail:
 	sb_end_intwrite(sdp->sd_vfs);
-	gfs2_holder_uninit(&tr->tr_t_gh);
 	kfree(tr);
 
 	return error;
 }
 
-/**
- * gfs2_log_release - Release a given number of log blocks
- * @sdp: The GFS2 superblock
- * @blks: The number of blocks
- *
- */
-
-static void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
-{
-
-	atomic_add(blks, &sdp->sd_log_blks_free);
-	trace_gfs2_log_blocks(sdp, blks);
-	gfs2_assert_withdraw(sdp, atomic_read(&sdp->sd_log_blks_free) <=
-				  sdp->sd_jdesc->jd_blocks);
-	up_read(&sdp->sd_log_flush_lock);
-}
-
 static void gfs2_print_trans(const struct gfs2_trans *tr)
 {
 	pr_warn("Transaction created at: %pSR\n", (void *)tr->tr_ip);
@@ -119,11 +94,8 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 
 	if (!tr->tr_touched) {
 		gfs2_log_release(sdp, tr->tr_reserved);
-		if (tr->tr_t_gh.gh_gl) {
-			gfs2_glock_dq(&tr->tr_t_gh);
-			gfs2_holder_uninit(&tr->tr_t_gh);
+		if (tr->tr_alloced)
 			kfree(tr);
-		}
 		sb_end_intwrite(sdp->sd_vfs);
 		return;
 	}
@@ -137,16 +109,12 @@ void gfs2_trans_end(struct gfs2_sbd *sdp)
 		gfs2_print_trans(tr);
 
 	gfs2_log_commit(sdp, tr);
-	if (tr->tr_t_gh.gh_gl) {
-		gfs2_glock_dq(&tr->tr_t_gh);
-		gfs2_holder_uninit(&tr->tr_t_gh);
-		if (!tr->tr_attached)
+	if (tr->tr_alloced && !tr->tr_attached)
 			kfree(tr);
-	}
 	up_read(&sdp->sd_log_flush_lock);
 
 	if (sdp->sd_vfs->s_flags & MS_SYNCHRONOUS)
-		gfs2_log_flush(sdp, NULL);
+		gfs2_log_flush(sdp, NULL, NORMAL_FLUSH);
 	sb_end_intwrite(sdp->sd_vfs);
 }
 
diff --git a/include/uapi/linux/gfs2_ondisk.h b/include/uapi/linux/gfs2_ondisk.h
index db3fdd0..1a763ea 100644
--- a/include/uapi/linux/gfs2_ondisk.h
+++ b/include/uapi/linux/gfs2_ondisk.h
@@ -20,7 +20,7 @@
 
 #define GFS2_MOUNT_LOCK		0
 #define GFS2_LIVE_LOCK		1
-#define GFS2_TRANS_LOCK		2
+#define GFS2_FREEZE_LOCK	2
 #define GFS2_RENAME_LOCK	3
 #define GFS2_CONTROL_LOCK	4
 #define GFS2_MOUNTED_LOCK	5
-- 
1.8.3.1

