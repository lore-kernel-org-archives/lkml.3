Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbaCRNHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:07:06 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35764 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaCRNHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:07:02 -0400
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 2/5] staging/lustre/libcfs: remove waitq_wait
Date: Tue, 18 Mar 2014 21:05:53 +0800
Message-Id: <1395147956-2056-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1395147956-2056-2-git-send-email-bergwolf@gmail.com>
References: <1395147956-2056-1-git-send-email-bergwolf@gmail.com>
 <1395147956-2056-2-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_prim.h      |    1 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    2 +-
 drivers/staging/lustre/lnet/lnet/lib-eq.c          |    2 +-
 drivers/staging/lustre/lustre/fid/fid_request.c    |    4 ++--
 drivers/staging/lustre/lustre/include/lustre_lib.h |    2 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    2 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |    2 +-
 .../lustre/lustre/libcfs/linux/linux-prim.c        |    7 -------
 drivers/staging/lustre/lustre/lov/lov_object.c     |    2 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    2 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    2 +-
 12 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
index b174567..b9251a5 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
@@ -52,7 +52,6 @@ typedef  void (cfs_timer_func_t)(ulong_ptr_t);
 void schedule_timeout_and_set_state(long, int64_t);
 
 int64_t waitq_timedwait(wait_queue_t *, long, int64_t);
-void waitq_wait(wait_queue_t *, long);
 void add_wait_queue_exclusive_head(wait_queue_head_t *, wait_queue_t *);
 
 void cfs_init_timer(struct timer_list *t);
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 9ae5745..07b1da2 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -3423,7 +3423,7 @@ kiblnd_scheduler(void *arg)
 		add_wait_queue_exclusive(&sched->ibs_waitq, &wait);
 		spin_unlock_irqrestore(&sched->ibs_lock, flags);
 
-		waitq_wait(&wait, TASK_INTERRUPTIBLE);
+		schedule();
 		busy_loops = 0;
 
 		remove_wait_queue(&sched->ibs_waitq, &wait);
diff --git a/drivers/staging/lustre/lnet/lnet/lib-eq.c b/drivers/staging/lustre/lnet/lnet/lib-eq.c
index 6209728..65af201 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-eq.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-eq.c
@@ -341,7 +341,7 @@ lnet_eq_wait_locked(int *timeout_ms)
 	lnet_eq_wait_unlock();
 
 	if (tms < 0) {
-		waitq_wait(&wl, TASK_INTERRUPTIBLE);
+		schedule();
 
 	} else {
 		struct timeval tv;
diff --git a/drivers/staging/lustre/lustre/fid/fid_request.c b/drivers/staging/lustre/lustre/fid/fid_request.c
index 0521a06..3401c9a 100644
--- a/drivers/staging/lustre/lustre/fid/fid_request.c
+++ b/drivers/staging/lustre/lustre/fid/fid_request.c
@@ -225,7 +225,7 @@ static int seq_fid_alloc_prep(struct lu_client_seq *seq,
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&seq->lcs_mutex);
 
-		waitq_wait(link, TASK_UNINTERRUPTIBLE);
+		schedule();
 
 		mutex_lock(&seq->lcs_mutex);
 		remove_wait_queue(&seq->lcs_waitq, link);
@@ -378,7 +378,7 @@ void seq_client_flush(struct lu_client_seq *seq)
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		mutex_unlock(&seq->lcs_mutex);
 
-		waitq_wait(&link, TASK_UNINTERRUPTIBLE);
+		schedule();
 
 		mutex_lock(&seq->lcs_mutex);
 		remove_wait_queue(&seq->lcs_waitq, &link);
diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index 6211185..0695436 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -558,7 +558,7 @@ do {									   \
 			break;						 \
 									       \
 		if (__timeout == 0) {					  \
-			waitq_wait(&__wait, __wstate);		     \
+			schedule();						\
 		} else {						       \
 			cfs_duration_t interval = info->lwi_interval?	  \
 					     min_t(cfs_duration_t,	     \
diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index a1902f1..6907a16 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -1203,7 +1203,7 @@ static void cl_object_put_last(struct lu_env *env, struct cl_object *obj)
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			if (atomic_read(&header->loh_ref) == 1)
 				break;
-			waitq_wait(&waiter, TASK_UNINTERRUPTIBLE);
+			schedule();
 		}
 
 		set_current_state(TASK_RUNNING);
diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index b65e12a..1e4c5ad 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -379,7 +379,7 @@ void libcfs_debug_dumplog(void)
 		printk(KERN_ERR "LustreError: cannot start log dump thread:"
 		       " %ld\n", PTR_ERR(dumper));
 	else
-		waitq_wait(&wait, TASK_INTERRUPTIBLE);
+		schedule();
 
 	/* be sure to teardown if cfs_create_thread() failed */
 	remove_wait_queue(&debug_ctlwq, &wait);
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
index 548cb1b..86475c2 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
@@ -70,13 +70,6 @@ add_wait_queue_exclusive_head(wait_queue_head_t *waitq, wait_queue_t *link)
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive_head);
 
-void
-waitq_wait(wait_queue_t *link, long state)
-{
-	schedule();
-}
-EXPORT_SYMBOL(waitq_wait);
-
 int64_t
 waitq_timedwait(wait_queue_t *link, long state, int64_t timeout)
 {
diff --git a/drivers/staging/lustre/lustre/lov/lov_object.c b/drivers/staging/lustre/lustre/lov/lov_object.c
index 8a7a55e..d6b2cb4 100644
--- a/drivers/staging/lustre/lustre/lov/lov_object.c
+++ b/drivers/staging/lustre/lustre/lov/lov_object.c
@@ -320,7 +320,7 @@ static void lov_subobject_kill(const struct lu_env *env, struct lov_object *lov,
 			spin_lock(&r0->lo_sub_lock);
 			if (r0->lo_sub[idx] == los) {
 				spin_unlock(&r0->lo_sub_lock);
-				waitq_wait(waiter, TASK_UNINTERRUPTIBLE);
+				schedule();
 			} else {
 				spin_unlock(&r0->lo_sub_lock);
 				set_current_state(TASK_RUNNING);
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index c6e1df3..d795cef 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -943,7 +943,7 @@ int cl_lock_state_wait(const struct lu_env *env, struct cl_lock *lock)
 		 * can be restarted if signals are pending here */
 		result = -ERESTARTSYS;
 		if (likely(!OBD_FAIL_CHECK(OBD_FAIL_LOCK_STATE_WAIT_INTR))) {
-			waitq_wait(&waiter, TASK_INTERRUPTIBLE);
+			schedule();
 			if (!cfs_signal_pending())
 				result = 0;
 		}
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index 55bd47f..92e8a15 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -712,7 +712,7 @@ struct lu_object *lu_object_find_at(const struct lu_env *env,
 		 * lu_object_find_try() already added waiter into the
 		 * wait queue.
 		 */
-		waitq_wait(&wait, TASK_UNINTERRUPTIBLE);
+		schedule();
 		bkt = lu_site_bkt_from_fid(dev->ld_site, (void *)f);
 		remove_wait_queue(&bkt->lsb_marche_funebre, &wait);
 	}
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index 5e747e3..9656681 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -549,7 +549,7 @@ again:
 			add_wait_queue(&page_pools.epp_waitq, &waitlink);
 
 			spin_unlock(&page_pools.epp_lock);
-			waitq_wait(&waitlink, TASK_UNINTERRUPTIBLE);
+			schedule();
 			remove_wait_queue(&page_pools.epp_waitq, &waitlink);
 			LASSERT(page_pools.epp_waitqlen > 0);
 			spin_lock(&page_pools.epp_lock);
-- 
1.7.7.6

