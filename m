Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3KZCGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:06:33 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57364 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab3KZCG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:06:29 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Eremin <dmitry.eremin@intel.com>,
        Ned Bass <bass6@llnl.gov>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 12/16] staging/lustre/build: clean up unused variables and dead code
Date: Tue, 26 Nov 2013 10:05:06 +0800
Message-Id: <1385431510-18988-13-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
References: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

Clean up the code from really unused variables and rearrange other
to remove SET_BUT_UNUSED and UNUSED macro usage if possible.

Clean up or comment on some dead code.

Removed never implemented suspend timeouts functionality from pinger.c
which was commented out since 2007 and going to be replaced by adaptive
timeouts. Also removed all references to this functionality from
ldlm_lockd.c, ldlm_request.c and import.c which actually nevers executes
or do nothing.

 pinger.c commit d2d56f38da01001c92a09afc6b52b5acbd9bc13c
 Author: tappro <tappro>
 Date:   Mon Jul 30 21:08:59 2007 +0000
    - make HEAD from b_post_cmd3

Lustre-change: http://review.whamcloud.com/6139
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3204
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Signed-off-by: Ned Bass <bass6@llnl.gov>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/include/linux/libcfs/libcfs.h   |    2 -
 drivers/staging/lustre/lnet/selftest/rpc.c         |    2 -
 drivers/staging/lustre/lnet/selftest/selftest.h    |    3 -
 drivers/staging/lustre/lnet/selftest/timer.c       |    6 +-
 .../lustre/lustre/include/linux/lustre_compat25.h  |    4 +-
 drivers/staging/lustre/lustre/include/lustre_ha.h  |    3 -
 drivers/staging/lustre/lustre/include/lustre_net.h |    2 -
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    3 -
 drivers/staging/lustre/lustre/libcfs/workitem.c    |   56 ++++++++---------
 drivers/staging/lustre/lustre/llite/dcache.c       |   36 ++++-------
 drivers/staging/lustre/lustre/llite/namei.c        |    6 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |    4 --
 drivers/staging/lustre/lustre/ptlrpc/client.c      |   10 ++-
 drivers/staging/lustre/lustre/ptlrpc/import.c      |    2 -
 drivers/staging/lustre/lustre/ptlrpc/niobuf.c      |   10 ++-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c      |   65 --------------------
 drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c     |   44 ++++++-------
 17 files changed, 76 insertions(+), 182 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs.h b/drivers/staging/lustre/include/linux/libcfs/libcfs.h
index 687dbab..4a6c7da 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs.h
@@ -181,8 +181,6 @@ static inline void *__container_of(void *ptr, unsigned long shift)
 #define container_of0(ptr, type, member) \
 	((type *)__container_of((void *)(ptr), offsetof(type, member)))
 
-#define SET_BUT_UNUSED(a) do { } while(sizeof(a) - sizeof(a))
-
 #define _LIBCFS_H
 
 #endif /* _LIBCFS_H */
diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index 7659a26..5ae59d2 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -124,7 +124,6 @@ srpc_bulk_t *
 srpc_alloc_bulk(int cpt, unsigned bulk_npg, unsigned bulk_len, int sink)
 {
 	srpc_bulk_t  *bk;
-	struct page  **pages;
 	int	      i;
 
 	LASSERT(bulk_npg > 0 && bulk_npg <= LNET_MAX_IOV);
@@ -140,7 +139,6 @@ srpc_alloc_bulk(int cpt, unsigned bulk_npg, unsigned bulk_len, int sink)
 	bk->bk_sink   = sink;
 	bk->bk_len    = bulk_len;
 	bk->bk_niov   = bulk_npg;
-	UNUSED(pages);
 
 	for (i = 0; i < bulk_npg; i++) {
 		struct page *pg;
diff --git a/drivers/staging/lustre/lnet/selftest/selftest.h b/drivers/staging/lustre/lnet/selftest/selftest.h
index 8053b05..cd53926 100644
--- a/drivers/staging/lustre/lnet/selftest/selftest.h
+++ b/drivers/staging/lustre/lnet/selftest/selftest.h
@@ -572,9 +572,6 @@ swi_state2str (int state)
 #undef STATE2STR
 }
 
-#define UNUSED(x)       ( (void)(x) )
-
-
 #define selftest_wait_events()	cfs_pause(cfs_time_seconds(1) / 10)
 
 
diff --git a/drivers/staging/lustre/lnet/selftest/timer.c b/drivers/staging/lustre/lnet/selftest/timer.c
index 82fd363..5dc8e3d 100644
--- a/drivers/staging/lustre/lnet/selftest/timer.c
+++ b/drivers/staging/lustre/lnet/selftest/timer.c
@@ -172,9 +172,6 @@ int
 stt_timer_main(void *arg)
 {
 	int rc = 0;
-	UNUSED(arg);
-
-	SET_BUT_UNUSED(rc);
 
 	cfs_block_allsigs();
 
@@ -184,12 +181,13 @@ stt_timer_main(void *arg)
 		rc = wait_event_timeout(stt_data.stt_waitq,
 					stt_data.stt_shuttingdown,
 					cfs_time_seconds(STTIMER_SLOTTIME));
+		rc = 0; /* Discard jiffies remaining before timeout. */
 	}
 
 	spin_lock(&stt_data.stt_lock);
 	stt_data.stt_nthreads--;
 	spin_unlock(&stt_data.stt_lock);
-	return 0;
+	return rc;
 }
 
 int
diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
index 359c6c1..2e1b7f1 100644
--- a/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
+++ b/drivers/staging/lustre/lustre/include/linux/lustre_compat25.h
@@ -171,8 +171,8 @@ static inline int ll_quota_off(struct super_block *sb, int off, int remount)
 #define ll_d_hlist_empty(list) hlist_empty(list)
 #define ll_d_hlist_entry(ptr, type, name) hlist_entry(ptr.first, type, name)
 #define ll_d_hlist_for_each(tmp, i_dentry) hlist_for_each(tmp, i_dentry)
-#define ll_d_hlist_for_each_entry(dentry, p, i_dentry, alias) \
-	p = NULL; hlist_for_each_entry(dentry, i_dentry, alias)
+#define ll_d_hlist_for_each_entry(dentry, i_dentry, alias) \
+	hlist_for_each_entry(dentry, i_dentry, alias)
 
 
 #define bio_hw_segments(q, bio) 0
diff --git a/drivers/staging/lustre/lustre/include/lustre_ha.h b/drivers/staging/lustre/lustre/include/lustre_ha.h
index 105f6d6..f3ae02b 100644
--- a/drivers/staging/lustre/lustre/include/lustre_ha.h
+++ b/drivers/staging/lustre/lustre/include/lustre_ha.h
@@ -58,9 +58,6 @@ void ptlrpc_activate_import(struct obd_import *imp);
 void ptlrpc_deactivate_import(struct obd_import *imp);
 void ptlrpc_invalidate_import(struct obd_import *imp);
 void ptlrpc_fail_import(struct obd_import *imp, __u32 conn_cnt);
-int ptlrpc_check_suspend(void);
-void ptlrpc_activate_timeouts(struct obd_import *imp);
-void ptlrpc_deactivate_timeouts(struct obd_import *imp);
 
 /** @} ha */
 
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 91f28e3..6c5479b 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -3403,10 +3403,8 @@ int ptlrpc_del_timeout_client(struct list_head *obd_list,
 			      enum timeout_event event);
 struct ptlrpc_request * ptlrpc_prep_ping(struct obd_import *imp);
 int ptlrpc_obd_ping(struct obd_device *obd);
-cfs_time_t ptlrpc_suspend_wakeup_time(void);
 void ping_evictor_start(void);
 void ping_evictor_stop(void);
-int ptlrpc_check_and_wait_suspend(struct ptlrpc_request *req);
 void ptlrpc_pinger_ir_up(void);
 void ptlrpc_pinger_ir_down(void);
 /** @} */
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index 4974bec..a8f8c1c 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -97,9 +97,6 @@ int ldlm_expired_completion_wait(void *data)
 	if (lock->l_conn_export == NULL) {
 		static cfs_time_t next_dump = 0, last_dump = 0;
 
-		if (ptlrpc_check_suspend())
-			return 0;
-
 		LCONSOLE_WARN("lock timed out (enqueued at "CFS_TIME_T", "
 			      CFS_DURATION_T"s ago)\n",
 			      lock->l_last_activity,
diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
index 1a55c81..f216deb 100644
--- a/drivers/staging/lustre/lustre/libcfs/workitem.c
+++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
@@ -306,8 +306,6 @@ cfs_wi_scheduler (void *arg)
 void
 cfs_wi_sched_destroy(struct cfs_wi_sched *sched)
 {
-	int	i;
-
 	LASSERT(cfs_wi_data.wi_init);
 	LASSERT(!cfs_wi_data.wi_stopping);
 
@@ -324,18 +322,22 @@ cfs_wi_sched_destroy(struct cfs_wi_sched *sched)
 
 	spin_unlock(&cfs_wi_data.wi_glock);
 
-	i = 2;
 	wake_up_all(&sched->ws_waitq);
 
 	spin_lock(&cfs_wi_data.wi_glock);
-	while (sched->ws_nthreads > 0) {
-		CDEBUG(IS_PO2(++i) ? D_WARNING : D_NET,
-		       "waiting for %d threads of WI sched[%s] to terminate\n",
-		       sched->ws_nthreads, sched->ws_name);
+	{
+		int i = 2;
 
-		spin_unlock(&cfs_wi_data.wi_glock);
-		cfs_pause(cfs_time_seconds(1) / 20);
-		spin_lock(&cfs_wi_data.wi_glock);
+		while (sched->ws_nthreads > 0) {
+			CDEBUG(IS_PO2(++i) ? D_WARNING : D_NET,
+			       "waiting for %d threads of WI sched[%s] to "
+			       "terminate\n", sched->ws_nthreads,
+			       sched->ws_name);
+
+			spin_unlock(&cfs_wi_data.wi_glock);
+			cfs_pause(cfs_time_seconds(1) / 20);
+			spin_lock(&cfs_wi_data.wi_glock);
+		}
 	}
 
 	list_del(&sched->ws_list);
@@ -352,7 +354,6 @@ cfs_wi_sched_create(char *name, struct cfs_cpt_table *cptab,
 		    int cpt, int nthrs, struct cfs_wi_sched **sched_pp)
 {
 	struct cfs_wi_sched	*sched;
-	int			rc;
 
 	LASSERT(cfs_wi_data.wi_init);
 	LASSERT(!cfs_wi_data.wi_stopping);
@@ -373,9 +374,8 @@ cfs_wi_sched_create(char *name, struct cfs_cpt_table *cptab,
 	INIT_LIST_HEAD(&sched->ws_rerunq);
 	INIT_LIST_HEAD(&sched->ws_list);
 
-	rc = 0;
-	while (nthrs > 0)  {
-		char	name[16];
+	for (; nthrs > 0; nthrs--)  {
+		char		name[16];
 		struct task_struct *task;
 
 		spin_lock(&cfs_wi_data.wi_glock);
@@ -402,21 +402,19 @@ cfs_wi_sched_create(char *name, struct cfs_cpt_table *cptab,
 			nthrs--;
 			continue;
 		}
-		rc = PTR_ERR(task);
-
-		CERROR("Failed to create thread for WI scheduler %s: %d\n",
-		       name, rc);
-
-		spin_lock(&cfs_wi_data.wi_glock);
-
-		/* make up for cfs_wi_sched_destroy */
-		list_add(&sched->ws_list, &cfs_wi_data.wi_scheds);
-		sched->ws_starting--;
-
-		spin_unlock(&cfs_wi_data.wi_glock);
-
-		cfs_wi_sched_destroy(sched);
-		return rc;
+		if (IS_ERR(task)) {
+			int rc = PTR_ERR(task);
+			CERROR(
+			       "Failed to create thread for WI scheduler %s: %d\n",
+			       name, rc);
+			spin_lock(&cfs_wi_data.wi_glock);
+			/* make up for cfs_wi_sched_destroy */
+			list_add(&sched->ws_list, &cfs_wi_data.wi_scheds);
+			sched->ws_starting--;
+			spin_unlock(&cfs_wi_data.wi_glock);
+			cfs_wi_sched_destroy(sched);
+			return rc;
+		}
 	}
 	spin_lock(&cfs_wi_data.wi_glock);
 	list_add(&sched->ws_list, &cfs_wi_data.wi_scheds);
diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
index e7629be..cc7befe 100644
--- a/drivers/staging/lustre/lustre/llite/dcache.c
+++ b/drivers/staging/lustre/lustre/llite/dcache.c
@@ -270,7 +270,6 @@ void ll_intent_release(struct lookup_intent *it)
 void ll_invalidate_aliases(struct inode *inode)
 {
 	struct dentry *dentry;
-	struct ll_d_hlist_node *p;
 
 	LASSERT(inode != NULL);
 
@@ -278,7 +277,7 @@ void ll_invalidate_aliases(struct inode *inode)
 	       inode->i_ino, inode->i_generation, inode);
 
 	ll_lock_dcache(inode);
-	ll_d_hlist_for_each_entry(dentry, p, &inode->i_dentry, d_alias) {
+	ll_d_hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
 		CDEBUG(D_DENTRY, "dentry in drop %.*s (%p) parent %p "
 		       "inode %p flags %d\n", dentry->d_name.len,
 		       dentry->d_name.name, dentry, dentry->d_parent,
@@ -404,7 +403,6 @@ int ll_revalidate_it(struct dentry *de, int lookup_flags,
 		struct inode *inode = de->d_inode;
 		struct ll_inode_info *lli = ll_i2info(inode);
 		struct obd_client_handle **och_p;
-		__u64 *och_usecount;
 		__u64 ibits;
 
 		/*
@@ -417,38 +415,30 @@ int ll_revalidate_it(struct dentry *de, int lookup_flags,
 		 * change, LOOKUP lock is revoked.
 		 */
 
-
-		if (it->it_flags & FMODE_WRITE) {
+		if (it->it_flags & FMODE_WRITE)
 			och_p = &lli->lli_mds_write_och;
-			och_usecount = &lli->lli_open_fd_write_count;
-		} else if (it->it_flags & FMODE_EXEC) {
+		else if (it->it_flags & FMODE_EXEC)
 			och_p = &lli->lli_mds_exec_och;
-			och_usecount = &lli->lli_open_fd_exec_count;
-		} else {
+		else
 			och_p = &lli->lli_mds_read_och;
-			och_usecount = &lli->lli_open_fd_read_count;
-		}
 		/* Check for the proper lock. */
 		ibits = MDS_INODELOCK_LOOKUP;
 		if (!ll_have_md_lock(inode, &ibits, LCK_MINMODE))
 			goto do_lock;
 		mutex_lock(&lli->lli_och_mutex);
 		if (*och_p) { /* Everything is open already, do nothing */
-			/*(*och_usecount)++;  Do not let them steal our open
-			  handle from under us */
-			SET_BUT_UNUSED(och_usecount);
-			/* XXX The code above was my original idea, but in case
-			   we have the handle, but we cannot use it due to later
-			   checks (e.g. O_CREAT|O_EXCL flags set), nobody
-			   would decrement counter increased here. So we just
-			   hope the lock won't be invalidated in between. But
-			   if it would be, we'll reopen the open request to
-			   MDS later during file open path */
+			/* Originally it was idea to do not let them steal our
+			 * open handle from under us by (*och_usecount)++ here.
+			 * But in case we have the handle, but we cannot use it
+			 * due to later checks (e.g. O_CREAT|O_EXCL flags set),
+			 * nobody would decrement counter increased here. So we
+			 * just hope the lock won't be invalidated in between.
+			 * But if it would be, we'll reopen the open request to
+			 * MDS later during file open path. */
 			mutex_unlock(&lli->lli_och_mutex);
 			return 1;
-		} else {
-			mutex_unlock(&lli->lli_och_mutex);
 		}
+		mutex_unlock(&lli->lli_och_mutex);
 	}
 
 	if (it->it_op == IT_GETATTR) {
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index e47e2b1..0000530 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -172,10 +172,9 @@ struct inode *ll_iget(struct super_block *sb, ino_t hash,
 static void ll_invalidate_negative_children(struct inode *dir)
 {
 	struct dentry *dentry, *tmp_subdir;
-	struct ll_d_hlist_node *p;
 
 	ll_lock_dcache(dir);
-	ll_d_hlist_for_each_entry(dentry, p, &dir->i_dentry, d_alias) {
+	ll_d_hlist_for_each_entry(dentry, &dir->i_dentry, d_alias) {
 		spin_lock(&dentry->d_lock);
 		if (!list_empty(&dentry->d_subdirs)) {
 			struct dentry *child;
@@ -352,7 +351,6 @@ void ll_i2gids(__u32 *suppgids, struct inode *i1, struct inode *i2)
 static struct dentry *ll_find_alias(struct inode *inode, struct dentry *dentry)
 {
 	struct dentry *alias, *discon_alias, *invalid_alias;
-	struct ll_d_hlist_node *p;
 
 	if (ll_d_hlist_empty(&inode->i_dentry))
 		return NULL;
@@ -360,7 +358,7 @@ static struct dentry *ll_find_alias(struct inode *inode, struct dentry *dentry)
 	discon_alias = invalid_alias = NULL;
 
 	ll_lock_dcache(inode);
-	ll_d_hlist_for_each_entry(alias, p, &inode->i_dentry, d_alias) {
+	ll_d_hlist_for_each_entry(alias, &inode->i_dentry, d_alias) {
 		LASSERT(alias != dentry);
 
 		spin_lock(&alias->d_lock);
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 0f0750b..8828419 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -420,7 +420,6 @@ void lprocfs_stats_collect(struct lprocfs_stats *stats, int idx,
 {
 	unsigned int			num_entry;
 	struct lprocfs_counter		*percpu_cntr;
-	struct lprocfs_counter_header	*cntr_header;
 	int				i;
 	unsigned long			flags = 0;
 
@@ -439,7 +438,6 @@ void lprocfs_stats_collect(struct lprocfs_stats *stats, int idx,
 	for (i = 0; i < num_entry; i++) {
 		if (stats->ls_percpu[i] == NULL)
 			continue;
-		cntr_header = &stats->ls_cnt_header[idx];
 		percpu_cntr = lprocfs_stats_counter_get(stats, i, idx);
 
 		cnt->lc_count += percpu_cntr->lc_count;
@@ -999,7 +997,6 @@ EXPORT_SYMBOL(lprocfs_free_stats);
 void lprocfs_clear_stats(struct lprocfs_stats *stats)
 {
 	struct lprocfs_counter		*percpu_cntr;
-	struct lprocfs_counter_header	*header;
 	int				i;
 	int				j;
 	unsigned int			num_entry;
@@ -1011,7 +1008,6 @@ void lprocfs_clear_stats(struct lprocfs_stats *stats)
 		if (stats->ls_percpu[i] == NULL)
 			continue;
 		for (j = 0; j < stats->ls_num; j++) {
-			header = &stats->ls_cnt_header[j];
 			percpu_cntr = lprocfs_stats_counter_get(stats, i, j);
 			percpu_cntr->lc_count		= 0;
 			percpu_cntr->lc_min		= LC_MIN_INIT;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index d90efe4..684000e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -2289,7 +2289,6 @@ EXPORT_SYMBOL(ptlrpc_req_xid);
 int ptlrpc_unregister_reply(struct ptlrpc_request *request, int async)
 {
 	int		rc;
-	wait_queue_head_t       *wq;
 	struct l_wait_info lwi;
 
 	/*
@@ -2334,12 +2333,11 @@ int ptlrpc_unregister_reply(struct ptlrpc_request *request, int async)
 	 * a chance to run reply_in_callback(), and to make sure we've
 	 * unlinked before returning a req to the pool.
 	 */
-	if (request->rq_set != NULL)
-		wq = &request->rq_set->set_waitq;
-	else
-		wq = &request->rq_reply_waitq;
-
 	for (;;) {
+		/* The wq argument is ignored by user-space wait_event macros */
+		wait_queue_head_t *wq = (request->rq_set != NULL) ?
+				  &request->rq_set->set_waitq :
+				  &request->rq_reply_waitq;
 		/* Network access will complete in finite time but the HUGE
 		 * timeout lets us CWARN for visibility of sluggish NALs */
 		lwi = LWI_TIMEOUT_INTERVAL(cfs_time_seconds(LONG_UNLINK),
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index 283173a..f465547 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -170,7 +170,6 @@ int ptlrpc_set_import_discon(struct obd_import *imp, __u32 conn_cnt)
 			       target_len, target_start,
 			       libcfs_nid2str(imp->imp_connection->c_peer.nid));
 		}
-		ptlrpc_deactivate_timeouts(imp);
 		IMPORT_SET_STATE_NOLOCK(imp, LUSTRE_IMP_DISCON);
 		spin_unlock(&imp->imp_lock);
 
@@ -383,7 +382,6 @@ void ptlrpc_activate_import(struct obd_import *imp)
 
 	spin_lock(&imp->imp_lock);
 	imp->imp_invalid = 0;
-	ptlrpc_activate_timeouts(imp);
 	spin_unlock(&imp->imp_lock);
 	obd_import_event(obd, imp, IMP_EVENT_ACTIVE);
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
index 5f2aa7a..499e4be 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/niobuf.c
@@ -243,7 +243,6 @@ EXPORT_SYMBOL(ptlrpc_register_bulk);
 int ptlrpc_unregister_bulk(struct ptlrpc_request *req, int async)
 {
 	struct ptlrpc_bulk_desc *desc = req->rq_bulk;
-	wait_queue_head_t	     *wq;
 	struct l_wait_info       lwi;
 	int		      rc;
 
@@ -275,12 +274,11 @@ int ptlrpc_unregister_bulk(struct ptlrpc_request *req, int async)
 	if (async)
 		return 0;
 
-	if (req->rq_set != NULL)
-		wq = &req->rq_set->set_waitq;
-	else
-		wq = &req->rq_reply_waitq;
-
 	for (;;) {
+		/* The wq argument is ignored by user-space wait_event macros */
+		wait_queue_head_t *wq = (req->rq_set != NULL) ?
+				  &req->rq_set->set_waitq :
+				  &req->rq_reply_waitq;
 		/* Network access will complete in finite time but the HUGE
 		 * timeout lets us CWARN for visibility of sluggish NALs */
 		lwi = LWI_TIMEOUT_INTERVAL(cfs_time_seconds(LONG_UNLINK),
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 7c05e82..aaceafa 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -141,9 +141,6 @@ static inline int ptlrpc_next_reconnect(struct obd_import *imp)
 		return cfs_time_shift(obd_timeout);
 }
 
-static atomic_t suspend_timeouts = ATOMIC_INIT(0);
-static cfs_time_t suspend_wakeup_time = 0;
-
 cfs_duration_t pinger_check_timeout(cfs_time_t time)
 {
 	struct timeout_item *item;
@@ -163,67 +160,6 @@ cfs_duration_t pinger_check_timeout(cfs_time_t time)
 					 cfs_time_current());
 }
 
-static wait_queue_head_t suspend_timeouts_waitq;
-
-cfs_time_t ptlrpc_suspend_wakeup_time(void)
-{
-	return suspend_wakeup_time;
-}
-
-void ptlrpc_deactivate_timeouts(struct obd_import *imp)
-{
-	/*XXX: disabled for now, will be replaced by adaptive timeouts */
-#if 0
-	if (imp->imp_no_timeout)
-		return;
-	imp->imp_no_timeout = 1;
-	atomic_inc(&suspend_timeouts);
-	CDEBUG(D_HA|D_WARNING, "deactivate timeouts %u\n",
-	       atomic_read(&suspend_timeouts));
-#endif
-}
-
-void ptlrpc_activate_timeouts(struct obd_import *imp)
-{
-	/*XXX: disabled for now, will be replaced by adaptive timeouts */
-#if 0
-	if (!imp->imp_no_timeout)
-		return;
-	imp->imp_no_timeout = 0;
-	LASSERT(atomic_read(&suspend_timeouts) > 0);
-	if (atomic_dec_and_test(&suspend_timeouts)) {
-		suspend_wakeup_time = cfs_time_current();
-		wake_up(&suspend_timeouts_waitq);
-	}
-	CDEBUG(D_HA|D_WARNING, "activate timeouts %u\n",
-	       atomic_read(&suspend_timeouts));
-#endif
-}
-
-int ptlrpc_check_suspend(void)
-{
-	if (atomic_read(&suspend_timeouts))
-		return 1;
-	return 0;
-}
-
-int ptlrpc_check_and_wait_suspend(struct ptlrpc_request *req)
-{
-	struct l_wait_info lwi;
-
-	if (atomic_read(&suspend_timeouts)) {
-		DEBUG_REQ(D_NET, req, "-- suspend %d regular timeout",
-			  atomic_read(&suspend_timeouts));
-		lwi = LWI_INTR(NULL, NULL);
-		l_wait_event(suspend_timeouts_waitq,
-			     atomic_read(&suspend_timeouts) == 0, &lwi);
-		DEBUG_REQ(D_NET, req, "-- recharge regular timeout");
-		return 1;
-	}
-	return 0;
-}
-
-
 static bool ir_up;
 
 void ptlrpc_pinger_ir_up(void)
@@ -378,7 +314,6 @@ int ptlrpc_start_pinger(void)
 		return -EALREADY;
 
 	init_waitqueue_head(&pinger_thread.t_ctl_waitq);
-	init_waitqueue_head(&suspend_timeouts_waitq);
 
 	strcpy(pinger_thread.t_name, "ll_ping");
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
index 2ebdb1b..8a95fa5 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/ptlrpcd.c
@@ -600,7 +600,6 @@ static int ptlrpcd_bind(int index, int max)
 int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc)
 {
 	int rc;
-	int env = 0;
 
 	/*
 	 * Do not allow start second thread for one pc.
@@ -619,6 +618,7 @@ int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc)
 	pc->pc_set = ptlrpc_prep_set();
 	if (pc->pc_set == NULL)
 		GOTO(out, rc = -ENOMEM);
+
 	/*
 	 * So far only "client" ptlrpcd uses an environment. In the future,
 	 * ptlrpcd thread (or a thread-set) has to be given an argument,
@@ -626,40 +626,40 @@ int ptlrpcd_start(int index, int max, const char *name, struct ptlrpcd_ctl *pc)
 	 */
 	rc = lu_context_init(&pc->pc_env.le_ctx, LCT_CL_THREAD|LCT_REMEMBER);
 	if (rc != 0)
-		GOTO(out, rc);
+		GOTO(out_set, rc);
 
-	env = 1;
 	{
 		struct task_struct *task;
-
 		if (index >= 0) {
 			rc = ptlrpcd_bind(index, max);
 			if (rc < 0)
-				GOTO(out, rc);
+				GOTO(out_env, rc);
 		}
 
-		task = kthread_run(ptlrpcd, pc, "%s", pc->pc_name);
+		task = kthread_run(ptlrpcd, pc, pc->pc_name);
 		if (IS_ERR(task))
-			GOTO(out, rc = PTR_ERR(task));
+			GOTO(out_env, rc = PTR_ERR(task));
 
-		rc = 0;
 		wait_for_completion(&pc->pc_starting);
 	}
-out:
-	if (rc) {
-		if (pc->pc_set != NULL) {
-			struct ptlrpc_request_set *set = pc->pc_set;
-
-			spin_lock(&pc->pc_lock);
-			pc->pc_set = NULL;
-			spin_unlock(&pc->pc_lock);
-			ptlrpc_set_destroy(set);
-		}
-		if (env != 0)
-			lu_context_fini(&pc->pc_env.le_ctx);
-		clear_bit(LIOD_BIND, &pc->pc_flags);
-		clear_bit(LIOD_START, &pc->pc_flags);
+	return 0;
+
+out_env:
+	lu_context_fini(&pc->pc_env.le_ctx);
+
+out_set:
+	if (pc->pc_set != NULL) {
+		struct ptlrpc_request_set *set = pc->pc_set;
+
+		spin_lock(&pc->pc_lock);
+		pc->pc_set = NULL;
+		spin_unlock(&pc->pc_lock);
+		ptlrpc_set_destroy(set);
 	}
+	clear_bit(LIOD_BIND, &pc->pc_flags);
+
+out:
+	clear_bit(LIOD_START, &pc->pc_flags);
 	return rc;
 }
 
-- 
1.7.9.5

