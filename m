Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaD0RIs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:48 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48148 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbaD0RIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:44 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Li Xi <lixi@ddn.com>, James Simmons <uja.ornl@gmail.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 42/47] staging/lustre: remove assertion of spin_is_locked()
Date: Sun, 27 Apr 2014 13:07:06 -0400
Message-Id: <1398618431-29757-43-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Xi <lixi@ddn.com>

spin_is_locked() is always false when the platform is
uniprocessor and CONFIG_DEBUG_SPINLOCK is not enabled.
This patch replaces its assertion by assert_spin_locked().

Signed-off-by: Li Xi <lixi@ddn.com>
Signed-off-by: James Simmons <uja.ornl@gmail.com>
Reviewed-on: http://review.whamcloud.com/8144
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4199
Reviewed-by: Alexey Lyashkov <alexey_lyashkov@xyratex.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/include/linux/libcfs/linux/linux-lock.h | 2 +-
 drivers/staging/lustre/lustre/include/lustre_dlm.h             | 2 +-
 drivers/staging/lustre/lustre/include/lustre_net.h             | 2 +-
 drivers/staging/lustre/lustre/lov/lov_merge.c                  | 4 ++--
 drivers/staging/lustre/lustre/obdclass/cl_lock.c               | 2 +-
 drivers/staging/lustre/lustre/obdclass/cl_object.c             | 4 ++--
 drivers/staging/lustre/lustre/obdclass/cl_page.c               | 2 +-
 drivers/staging/lustre/lustre/osc/osc_cache.c                  | 4 ++--
 drivers/staging/lustre/lustre/osc/osc_cl_internal.h            | 9 +++++++++
 drivers/staging/lustre/lustre/ptlrpc/client.c                  | 8 +++-----
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c          | 4 ++--
 drivers/staging/lustre/lustre/ptlrpc/import.c                  | 2 +-
 drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c            | 2 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c                  | 2 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c                | 2 +-
 drivers/staging/lustre/lustre/ptlrpc/service.c                 | 4 ++--
 16 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-lock.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-lock.h
index d6e00f9..b75e401 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-lock.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-lock.h
@@ -66,7 +66,7 @@
  * - spin_unlock(x)
  * - spin_unlock_bh(x)
  * - spin_trylock(x)
- * - spin_is_locked(x)
+ * - assert_spin_locked(x)
  *
  * - spin_lock_irq(x)
  * - spin_lock_irqsave(x, f)
diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index e28e31a..0c6b784 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -1445,7 +1445,7 @@ static inline void unlock_res(struct ldlm_resource *res)
 /** Check if resource is already locked, assert if not. */
 static inline void check_res_locked(struct ldlm_resource *res)
 {
-	LASSERT(spin_is_locked(&res->lr_lock));
+	assert_spin_locked(&res->lr_lock);
 }
 
 struct ldlm_resource * lock_res_and_lock(struct ldlm_lock *lock);
diff --git a/drivers/staging/lustre/lustre/include/lustre_net.h b/drivers/staging/lustre/lustre/include/lustre_net.h
index 7640e17..f6b7d10 100644
--- a/drivers/staging/lustre/lustre/include/lustre_net.h
+++ b/drivers/staging/lustre/lustre/include/lustre_net.h
@@ -719,7 +719,7 @@ struct ptlrpc_nrs_pol_ops {
 	 *			 \a nrq
 	 * \param[in,out] nrq	 The request
 	 *
-	 * \pre spin_is_locked(&svcpt->scp_req_lock)
+	 * \pre assert_spin_locked(&svcpt->scp_req_lock)
 	 *
 	 * \see ptlrpc_nrs_req_stop_nolock()
 	 */
diff --git a/drivers/staging/lustre/lustre/lov/lov_merge.c b/drivers/staging/lustre/lustre/lov/lov_merge.c
index 0a14cee..da959e9 100644
--- a/drivers/staging/lustre/lustre/lov/lov_merge.c
+++ b/drivers/staging/lustre/lustre/lov/lov_merge.c
@@ -58,7 +58,7 @@ int lov_merge_lvb_kms(struct lov_stripe_md *lsm,
 	int i;
 	int rc = 0;
 
-	LASSERT(spin_is_locked(&lsm->lsm_lock));
+	assert_spin_locked(&lsm->lsm_lock);
 	LASSERT(lsm->lsm_lock_owner == current_pid());
 
 	CDEBUG(D_INODE, "MDT ID "DOSTID" initial value: s="LPU64" m="LPU64
@@ -145,7 +145,7 @@ int lov_adjust_kms(struct obd_export *exp, struct lov_stripe_md *lsm,
 	int stripe = 0;
 	__u64 kms;
 
-	LASSERT(spin_is_locked(&lsm->lsm_lock));
+	assert_spin_locked(&lsm->lsm_lock);
 	LASSERT(lsm->lsm_lock_owner == current_pid());
 
 	if (shrink) {
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_lock.c b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
index f8040a8..df77c4f 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_lock.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_lock.c
@@ -478,7 +478,7 @@ static struct cl_lock *cl_lock_lookup(const struct lu_env *env,
 	struct cl_object_header *head;
 
 	head = cl_object_header(obj);
-	LINVRNT(spin_is_locked(&head->coh_lock_guard));
+	assert_spin_locked(&head->coh_lock_guard);
 	CS_LOCK_INC(obj, lookup);
 	list_for_each_entry(lock, &head->coh_locks, cll_linkage) {
 		int matched;
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_object.c b/drivers/staging/lustre/lustre/obdclass/cl_object.c
index 2837cbc..41cbc95 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_object.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_object.c
@@ -220,7 +220,7 @@ int cl_object_attr_get(const struct lu_env *env, struct cl_object *obj,
 	struct lu_object_header *top;
 	int result;
 
-	LASSERT(spin_is_locked(cl_object_attr_guard(obj)));
+	assert_spin_locked(cl_object_attr_guard(obj));
 
 	top = obj->co_lu.lo_header;
 	result = 0;
@@ -251,7 +251,7 @@ int cl_object_attr_set(const struct lu_env *env, struct cl_object *obj,
 	struct lu_object_header *top;
 	int result;
 
-	LASSERT(spin_is_locked(cl_object_attr_guard(obj)));
+	assert_spin_locked(cl_object_attr_guard(obj));
 
 	top = obj->co_lu.lo_header;
 	result = 0;
diff --git a/drivers/staging/lustre/lustre/obdclass/cl_page.c b/drivers/staging/lustre/lustre/obdclass/cl_page.c
index a4b04cb..1b616e4 100644
--- a/drivers/staging/lustre/lustre/obdclass/cl_page.c
+++ b/drivers/staging/lustre/lustre/obdclass/cl_page.c
@@ -130,7 +130,7 @@ struct cl_page *cl_page_lookup(struct cl_object_header *hdr, pgoff_t index)
 {
 	struct cl_page *page;
 
-	LASSERT(spin_is_locked(&hdr->coh_page_guard));
+	assert_spin_locked(&hdr->coh_page_guard);
 
 	page = radix_tree_lookup(&hdr->coh_tree, index);
 	if (page != NULL)
diff --git a/drivers/staging/lustre/lustre/osc/osc_cache.c b/drivers/staging/lustre/lustre/osc/osc_cache.c
index fe9989a..00f38ee 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cache.c
+++ b/drivers/staging/lustre/lustre/osc/osc_cache.c
@@ -1311,7 +1311,7 @@ static int osc_completion(const struct lu_env *env, struct osc_async_page *oap,
 static void osc_consume_write_grant(struct client_obd *cli,
 				    struct brw_page *pga)
 {
-	LASSERT(spin_is_locked(&cli->cl_loi_list_lock.lock));
+	assert_spin_locked(&cli->cl_loi_list_lock.lock);
 	LASSERT(!(pga->flag & OBD_BRW_FROM_GRANT));
 	atomic_inc(&obd_dirty_pages);
 	cli->cl_dirty += PAGE_CACHE_SIZE;
@@ -1326,7 +1326,7 @@ static void osc_consume_write_grant(struct client_obd *cli,
 static void osc_release_write_grant(struct client_obd *cli,
 				    struct brw_page *pga)
 {
-	LASSERT(spin_is_locked(&cli->cl_loi_list_lock.lock));
+	assert_spin_locked(&cli->cl_loi_list_lock.lock);
 	if (!(pga->flag & OBD_BRW_FROM_GRANT)) {
 		return;
 	}
diff --git a/drivers/staging/lustre/lustre/osc/osc_cl_internal.h b/drivers/staging/lustre/lustre/osc/osc_cl_internal.h
index 9e7899f..e74b7bb 100644
--- a/drivers/staging/lustre/lustre/osc/osc_cl_internal.h
+++ b/drivers/staging/lustre/lustre/osc/osc_cl_internal.h
@@ -176,7 +176,16 @@ static inline void osc_object_unlock(struct osc_object *obj)
 
 static inline int osc_object_is_locked(struct osc_object *obj)
 {
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 	return spin_is_locked(&obj->oo_lock);
+#else
+	/*
+	 * It is not perfect to return true all the time.
+	 * But since this function is only used for assertion
+	 * and checking, it seems OK.
+	 */
+	return 1;
+#endif
 }
 
 /*
diff --git a/drivers/staging/lustre/lustre/ptlrpc/client.c b/drivers/staging/lustre/lustre/ptlrpc/client.c
index 2098772..7246e8c 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/client.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/client.c
@@ -2271,7 +2271,7 @@ static int __ptlrpc_req_finished(struct ptlrpc_request *request, int locked);
  */
 void ptlrpc_req_finished_with_imp_lock(struct ptlrpc_request *request)
 {
-	LASSERT(spin_is_locked(&request->rq_import->imp_lock));
+	assert_spin_locked(&request->rq_import->imp_lock);
 	(void)__ptlrpc_req_finished(request, 1);
 }
 EXPORT_SYMBOL(ptlrpc_req_finished_with_imp_lock);
@@ -2452,9 +2452,7 @@ void ptlrpc_free_committed(struct obd_import *imp)
 	bool		       skip_committed_list = true;
 
 	LASSERT(imp != NULL);
-
-	LASSERT(spin_is_locked(&imp->imp_lock));
-
+	assert_spin_locked(&imp->imp_lock);
 
 	if (imp->imp_peer_committed_transno == imp->imp_last_transno_checked &&
 	    imp->imp_generation == imp->imp_last_generation_checked) {
@@ -2585,7 +2583,7 @@ void ptlrpc_retain_replayable_request(struct ptlrpc_request *req,
 {
 	struct list_head *tmp;
 
-	LASSERT(spin_is_locked(&imp->imp_lock));
+	assert_spin_locked(&imp->imp_lock);
 
 	if (req->rq_transno == 0) {
 		DEBUG_REQ(D_EMERG, req, "saving request with zero transno");
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c
index 7a1ff4f..3be5bc1 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_pipefs.c
@@ -137,7 +137,7 @@ void ctx_enhash_pf(struct ptlrpc_cli_ctx *ctx, struct hlist_head *hash)
 static
 void ctx_unhash_pf(struct ptlrpc_cli_ctx *ctx, struct hlist_head *freelist)
 {
-	LASSERT(spin_is_locked(&ctx->cc_sec->ps_lock));
+	assert_spin_locked(&ctx->cc_sec->ps_lock);
 	LASSERT(atomic_read(&ctx->cc_refcount) > 0);
 	LASSERT(test_bit(PTLRPC_CTX_CACHED_BIT, &ctx->cc_flags));
 	LASSERT(!hlist_unhashed(&ctx->cc_cache));
@@ -719,7 +719,7 @@ void gss_unhash_msg_nolock(struct gss_upcall_msg *gmsg)
 	__u32 idx = gmsg->gum_mechidx;
 
 	LASSERT(idx < MECH_MAX);
-	LASSERT(spin_is_locked(&upcall_locks[idx]));
+	assert_spin_locked(&upcall_locks[idx]);
 
 	if (list_empty(&gmsg->gum_list))
 		return;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/import.c b/drivers/staging/lustre/lustre/ptlrpc/import.c
index b231452..1c73194 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/import.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/import.c
@@ -194,7 +194,7 @@ int ptlrpc_set_import_discon(struct obd_import *imp, __u32 conn_cnt)
 /* Must be called with imp_lock held! */
 static void ptlrpc_deactivate_and_unlock_import(struct obd_import *imp)
 {
-	LASSERT(spin_is_locked(&imp->imp_lock));
+	assert_spin_locked(&imp->imp_lock);
 
 	CDEBUG(D_HA, "setting import %s INVALID\n", obd2cli_tgt(imp->imp_obd));
 	imp->imp_invalid = 1;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 7a422ff..6b9c6db 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -449,7 +449,7 @@ void nrs_policy_get_info_locked(struct ptlrpc_nrs_policy *policy,
 {
 	LASSERT(policy != NULL);
 	LASSERT(info != NULL);
-	LASSERT(spin_is_locked(&policy->pol_nrs->nrs_lock));
+	assert_spin_locked(&policy->pol_nrs->nrs_lock);
 
 	memcpy(info->pi_name, policy->pol_desc->pd_name, NRS_POL_NAME_MAX);
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 6dff502..38099d9 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -368,7 +368,7 @@ EXPORT_SYMBOL(ptlrpc_pinger_sending_on_import);
 void ptlrpc_pinger_commit_expected(struct obd_import *imp)
 {
 	ptlrpc_update_next_ping(imp, 1);
-	LASSERT(spin_is_locked(&imp->imp_lock));
+	assert_spin_locked(&imp->imp_lock);
 	/*
 	 * Avoid reading stale imp_connect_data.  When not sure if pings are
 	 * expected or not on next connection, we assume they are not and force
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index 1d46b5e..9d51bad 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -450,7 +450,7 @@ out:
 
 static inline void enc_pools_wakeup(void)
 {
-	LASSERT(spin_is_locked(&page_pools.epp_lock));
+	assert_spin_locked(&page_pools.epp_lock);
 	LASSERT(page_pools.epp_waitqlen >= 0);
 
 	if (unlikely(page_pools.epp_waitqlen)) {
diff --git a/drivers/staging/lustre/lustre/ptlrpc/service.c b/drivers/staging/lustre/lustre/ptlrpc/service.c
index 5d0eb6c..d278f2e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/service.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/service.c
@@ -384,8 +384,8 @@ void ptlrpc_dispatch_difficult_reply(struct ptlrpc_reply_state *rs)
 void
 ptlrpc_schedule_difficult_reply(struct ptlrpc_reply_state *rs)
 {
-	LASSERT(spin_is_locked(&rs->rs_svcpt->scp_rep_lock));
-	LASSERT(spin_is_locked(&rs->rs_lock));
+	assert_spin_locked(&rs->rs_svcpt->scp_rep_lock);
+	assert_spin_locked(&rs->rs_lock);
 	LASSERT(rs->rs_difficult);
 	rs->rs_scheduled_ever = 1;  /* flag any notification attempt */
 
-- 
1.8.5.3

