Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaCRNG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 09:06:59 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:38072 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbaCRNGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 09:06:55 -0400
From: Peng Tao <bergwolf@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 1/5] staging/lustre/libcfs: remove init_waitqueue_entry_current
Date: Tue, 18 Mar 2014 21:05:52 +0800
Message-Id: <1395147956-2056-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1395147956-2056-1-git-send-email-bergwolf@gmail.com>
References: <1395147956-2056-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/libcfs_prim.h      |    1 -
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c |    6 +++---
 .../staging/lustre/lnet/klnds/socklnd/socklnd_cb.c |    4 ++--
 drivers/staging/lustre/lnet/lnet/lib-eq.c          |    2 +-
 drivers/staging/lustre/lustre/fid/fid_request.c    |    6 +++---
 drivers/staging/lustre/lustre/include/lustre_lib.h |    2 +-
 drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    2 +-
 drivers/staging/lustre/lustre/libcfs/debug.c       |    2 +-
 .../lustre/lustre/libcfs/linux/linux-prim.c        |    7 -------
 drivers/staging/lustre/lustre/libcfs/tracefile.c   |    2 +-
 .../staging/lustre/lustre/libcfs/upcall_cache.c    |    2 +-
 drivers/staging/lustre/lustre/lov/lov_object.c     |    2 +-
 drivers/staging/lustre/lustre/obdclass/cl_lock.c   |    2 +-
 drivers/staging/lustre/lustre/obdclass/lu_object.c |    2 +-
 .../lustre/lustre/ptlrpc/gss/gss_svc_upcall.c      |    2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |    2 +-
 16 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
index e6e417a..b174567 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_prim.h
@@ -51,7 +51,6 @@ void cfs_pause(cfs_duration_t ticks);
 typedef  void (cfs_timer_func_t)(ulong_ptr_t);
 void schedule_timeout_and_set_state(long, int64_t);
 
-void init_waitqueue_entry_current(wait_queue_t *link);
 int64_t waitq_timedwait(wait_queue_t *, long, int64_t);
 void waitq_wait(wait_queue_t *, long);
 void add_wait_queue_exclusive_head(wait_queue_head_t *, wait_queue_t *);
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
index 6f58ead..9ae5745 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd_cb.c
@@ -3127,7 +3127,7 @@ kiblnd_connd (void *arg)
 
 	cfs_block_allsigs ();
 
-	init_waitqueue_entry_current (&wait);
+	init_waitqueue_entry(&wait, current);
 	kiblnd_data.kib_connd = current;
 
 	spin_lock_irqsave(&kiblnd_data.kib_connd_lock, flags);
@@ -3324,7 +3324,7 @@ kiblnd_scheduler(void *arg)
 
 	cfs_block_allsigs();
 
-	init_waitqueue_entry_current(&wait);
+	init_waitqueue_entry(&wait, current);
 
 	sched = kiblnd_data.kib_scheds[KIB_THREAD_CPT(id)];
 
@@ -3450,7 +3450,7 @@ kiblnd_failover_thread(void *arg)
 
 	cfs_block_allsigs ();
 
-	init_waitqueue_entry_current(&wait);
+	init_waitqueue_entry(&wait, current);
 	write_lock_irqsave(glock, flags);
 
 	while (!kiblnd_data.kib_shutdown) {
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index b7b53b5..fdf9101 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -2140,7 +2140,7 @@ ksocknal_connd (void *arg)
 
 	cfs_block_allsigs ();
 
-	init_waitqueue_entry_current (&wait);
+	init_waitqueue_entry(&wait, current);
 
 	spin_lock_bh(connd_lock);
 
@@ -2532,7 +2532,7 @@ ksocknal_reaper (void *arg)
 	cfs_block_allsigs ();
 
 	INIT_LIST_HEAD(&enomem_conns);
-	init_waitqueue_entry_current (&wait);
+	init_waitqueue_entry(&wait, current);
 
 	spin_lock_bh(&ksocknal_data.ksnd_reaper_lock);
 
diff --git a/drivers/staging/lustre/lnet/lnet/lib-eq.c b/drivers/staging/lustre/lnet/lnet/lib-eq.c
index 4ce68d3..6209728 100644
--- a/drivers/staging/lustre/lnet/lnet/lib-eq.c
+++ b/drivers/staging/lustre/lnet/lnet/lib-eq.c
@@ -334,7 +334,7 @@ lnet_eq_wait_locked(int *timeout_ms)
 	if (tms == 0)
 		return -1; /* don't want to wait and no new event */
 
-	init_waitqueue_entry_current(&wl);
+	init_waitqueue_entry(&wl, current);
 	set_current_state(TASK_INTERRUPTIBLE);
 	add_wait_queue(&the_lnet.ln_eq_waitq, &wl);
 
diff --git a/drivers/staging/lustre/lustre/fid/fid_request.c b/drivers/staging/lustre/lustre/fid/fid_request.c
index 69e6a32..0521a06 100644
--- a/drivers/staging/lustre/lustre/fid/fid_request.c
+++ b/drivers/staging/lustre/lustre/fid/fid_request.c
@@ -256,7 +256,7 @@ int seq_client_get_seq(const struct lu_env *env,
 
 	LASSERT(seqnr != NULL);
 	mutex_lock(&seq->lcs_mutex);
-	init_waitqueue_entry_current(&link);
+	init_waitqueue_entry(&link, current);
 
 	while (1) {
 		rc = seq_fid_alloc_prep(seq, &link);
@@ -306,7 +306,7 @@ int seq_client_alloc_fid(const struct lu_env *env,
 	LASSERT(seq != NULL);
 	LASSERT(fid != NULL);
 
-	init_waitqueue_entry_current(&link);
+	init_waitqueue_entry(&link, current);
 	mutex_lock(&seq->lcs_mutex);
 
 	if (OBD_FAIL_CHECK(OBD_FAIL_SEQ_EXHAUST))
@@ -370,7 +370,7 @@ void seq_client_flush(struct lu_client_seq *seq)
 	wait_queue_t link;
 
 	LASSERT(seq != NULL);
-	init_waitqueue_entry_current(&link);
+	init_waitqueue_entry(&link, current);
 	mutex_lock(&seq->lcs_mutex);
 
 	while (seq->lcs_update) {
diff --git a/drivers/staging/lustre/lustre/include/lustre_lib.h b/drivers/staging/lustre/lustre/include/lustre_lib.h
index 609a090..6211185 100644
--- a/drivers/staging/lustre/lustre/include/lustre_lib.h
+++ b/drivers/staging/lustre/lustre/include/lustre_lib.h
@@ -536,7 +536,7 @@ do {									   \
 	if (condition)							 \
 		break;							 \
 									       \
-	init_waitqueue_entry_current(&__wait);					    \
+	init_waitqueue_entry(&__wait, current);					    \
 	l_add_wait(&wq, &__wait);					      \
 									       \
 	/* Block all signals (just the non-fatal ones if no timeout). */       \
diff --git a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
index 94b1641..a1902f1 100644
--- a/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
+++ b/drivers/staging/lustre/lustre/lclient/lcommon_cl.c
@@ -1196,7 +1196,7 @@ static void cl_object_put_last(struct lu_env *env, struct cl_object *obj)
 
 		bkt = lu_site_bkt_from_fid(site, &header->loh_fid);
 
-		init_waitqueue_entry_current(&waiter);
+		init_waitqueue_entry(&waiter, current);
 		add_wait_queue(&bkt->lsb_marche_funebre, &waiter);
 
 		while (1) {
diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index f30c84f..b65e12a 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -368,7 +368,7 @@ void libcfs_debug_dumplog(void)
 	/* we're being careful to ensure that the kernel thread is
 	 * able to set our state to running as it exits before we
 	 * get to schedule() */
-	init_waitqueue_entry_current(&wait);
+	init_waitqueue_entry(&wait, current);
 	set_current_state(TASK_INTERRUPTIBLE);
 	add_wait_queue(&debug_ctlwq, &wait);
 
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
index c7bc7fc..548cb1b 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
@@ -46,13 +46,6 @@
 #include <asm/kgdb.h>
 #endif
 
-void
-init_waitqueue_entry_current(wait_queue_t *link)
-{
-	init_waitqueue_entry(link, current);
-}
-EXPORT_SYMBOL(init_waitqueue_entry_current);
-
 /**
  * wait_queue_t of Linux (version < 2.6.34) is a FIFO list for exclusively
  * waiting threads, which is not always desirable because all threads will
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index 54290ce..32ed879 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -1076,7 +1076,7 @@ end_loop:
 				break;
 			}
 		}
-		init_waitqueue_entry_current(&__wait);
+		init_waitqueue_entry(&__wait, current);
 		add_wait_queue(&tctl->tctl_waitq, &__wait);
 		set_current_state(TASK_INTERRUPTIBLE);
 		waitq_timedwait(&__wait, TASK_INTERRUPTIBLE,
diff --git a/drivers/staging/lustre/lustre/libcfs/upcall_cache.c b/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
index 245b46f..8a3b62d0 100644
--- a/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
+++ b/drivers/staging/lustre/lustre/libcfs/upcall_cache.c
@@ -218,7 +218,7 @@ find_again:
 			      MAX_SCHEDULE_TIMEOUT;
 		long left;
 
-		init_waitqueue_entry_current(&wait);
+		init_waitqueue_entry(&wait, current);
 		add_wait_queue(&entry->ue_waitq, &wait);
 		set_current_state(TASK_INTERRUPTIBLE);
 		spin_unlock(&cache->uc_lock);
diff --git a/drivers/staging/lustre/lustre/lov/lov_object.c b/drivers/staging/lustre/lustre/lov/lov_object.c
index 7a85caf..8a7a55e 100644
--- a/drivers/staging/lustre/lustre/lov/lov_object.c
+++ b/drivers/staging/lustre/lustre/lov/lov_object.c
@@ -310,7 +310,7 @@ static void lov_subobject_kill(const struct lu_env *env, struct lov_object *lov,
 	 * ->lo_sub[] slot in lovsub_object_fini() */
 	if (r0->lo_sub[idx] == los) {
 		waiter = &lov_env_info(env)->lti_waiter;
-		init_waitqueue_entry_current(waiter);
+		init_waitqueue_entry(waiter, current);
 		add_wait_queue(&bkt->lsb_marche_funebre, waiter);
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		while (1) {
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index 749eb08..c6e1df3 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -932,7 +932,7 @@ int cl_lock_state_wait(const struct lu_env *env, struct cl_lock *lock)
 		 * LU-305 */
 		blocked = cfs_block_sigsinv(LUSTRE_FATAL_SIGS);
 
-		init_waitqueue_entry_current(&waiter);
+		init_waitqueue_entry(&waiter, current);
 		add_wait_queue(&lock->cll_wq, &waiter);
 		set_current_state(TASK_INTERRUPTIBLE);
 		cl_lock_mutex_put(env, lock);
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_object.c b/drivers/staging/lustre/lustre/obdclass/lu_object.c
index 8800384..55bd47f 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_object.c
@@ -571,7 +571,7 @@ static struct lu_object *htable_lookup(struct lu_site *s,
 	 * drained), and moreover, lookup has to wait until object is freed.
 	 */
 
-	init_waitqueue_entry_current(waiter);
+	init_waitqueue_entry(waiter, current);
 	add_wait_queue(&bkt->lsb_marche_funebre, waiter);
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	lprocfs_counter_incr(s->ls_stats, LU_SS_CACHE_DEATH_RACE);
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_svc_upcall.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_svc_upcall.c
index f0aba50..359c48e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_svc_upcall.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_svc_upcall.c
@@ -880,7 +880,7 @@ int gss_svc_upcall_handle_init(struct ptlrpc_request *req,
 
 	cache_get(&rsip->h); /* take an extra ref */
 	init_waitqueue_head(&rsip->waitq);
-	init_waitqueue_entry_current(&wait);
+	init_waitqueue_entry(&wait, current);
 	add_wait_queue(&rsip->waitq, &wait);
 
 cache_check:
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index f65955d..5e747e3 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -545,7 +545,7 @@ again:
 						page_pools.epp_waitqlen;
 
 			set_current_state(TASK_UNINTERRUPTIBLE);
-			init_waitqueue_entry_current(&waitlink);
+			init_waitqueue_entry(&waitlink, current);
 			add_wait_queue(&page_pools.epp_waitq, &waitlink);
 
 			spin_unlock(&page_pools.epp_lock);
-- 
1.7.7.6

