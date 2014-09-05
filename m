Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaIEUJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 16:09:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:23915 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaIEUJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 16:09:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,474,1406617200"; 
   d="scan'208";a="598712535"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>, "John L. Hammond" <john.hammond@intel.com>
Subject: [PATCH 02/12] staging/lustre/osc: remove unused OBD methods
Date: Fri, 5 Sep 2014 15:08:08 -0500
Message-ID: <1409947698-30781-3-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
References: <1409947698-30781-1-git-send-email-john.hammond@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

Remove the unused OBD device methods:
    osc_brw()
    osc_cancel()
    osc_cancel_unused()
    osc_change_cbdata()
    osc_enqueue()
    osc_punch()
    osc_sync()
and their supporting functions.

Signed-off-by: John L. Hammond <john.hammond@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_request.c |  264 -----------------------
 1 file changed, 264 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_request.c b/drivers/staging/lustre/lustre/osc/osc_request.c
index d9f7249..86e9e97 100644
--- a/drivers/staging/lustre/lustre/osc/osc_request.c
+++ b/drivers/staging/lustre/lustre/osc/osc_request.c
@@ -537,17 +537,6 @@ int osc_punch_base(struct obd_export *exp, struct obd_info *oinfo,
 	return 0;
 }
 
-static int osc_punch(const struct lu_env *env, struct obd_export *exp,
-		     struct obd_info *oinfo, struct obd_trans_info *oti,
-		     struct ptlrpc_request_set *rqset)
-{
-	oinfo->oi_oa->o_size   = oinfo->oi_policy.l_extent.start;
-	oinfo->oi_oa->o_blocks = oinfo->oi_policy.l_extent.end;
-	oinfo->oi_oa->o_valid |= OBD_MD_FLSIZE | OBD_MD_FLBLOCKS;
-	return osc_punch_base(exp, oinfo,
-			      oinfo->oi_cb_up, oinfo, rqset);
-}
-
 static int osc_sync_interpret(const struct lu_env *env,
 			      struct ptlrpc_request *req,
 			      void *arg, int rc)
@@ -614,22 +603,6 @@ int osc_sync_base(struct obd_export *exp, struct obd_info *oinfo,
 	return 0;
 }
 
-static int osc_sync(const struct lu_env *env, struct obd_export *exp,
-		    struct obd_info *oinfo, u64 start, u64 end,
-		    struct ptlrpc_request_set *set)
-{
-	if (!oinfo->oi_oa) {
-		CDEBUG(D_INFO, "oa NULL\n");
-		return -EINVAL;
-	}
-
-	oinfo->oi_oa->o_size = start;
-	oinfo->oi_oa->o_blocks = end;
-	oinfo->oi_oa->o_valid |= (OBD_MD_FLSIZE | OBD_MD_FLBLOCKS);
-
-	return osc_sync_base(exp, oinfo, oinfo->oi_cb_up, oinfo, set);
-}
-
 /* Find and cancel locally locks matched by @mode in the resource found by
  * @objid. Found locks are added into @cancel list. Returns the amount of
  * locks added to @cancels list. */
@@ -1618,74 +1591,6 @@ out:
 	return rc;
 }
 
-static int osc_brw_internal(int cmd, struct obd_export *exp, struct obdo *oa,
-			    struct lov_stripe_md *lsm,
-			    u32 page_count, struct brw_page **pga,
-			    struct obd_capa *ocapa)
-{
-	struct ptlrpc_request *req;
-	int		    rc;
-	wait_queue_head_t	    waitq;
-	int		    generation, resends = 0;
-	struct l_wait_info     lwi;
-
-	init_waitqueue_head(&waitq);
-	generation = exp->exp_obd->u.cli.cl_import->imp_generation;
-
-restart_bulk:
-	rc = osc_brw_prep_request(cmd, &exp->exp_obd->u.cli, oa, lsm,
-				  page_count, pga, &req, ocapa, 0, resends);
-	if (rc != 0)
-		return rc;
-
-	if (resends) {
-		req->rq_generation_set = 1;
-		req->rq_import_generation = generation;
-		req->rq_sent = get_seconds() + resends;
-	}
-
-	rc = ptlrpc_queue_wait(req);
-
-	if (rc == -ETIMEDOUT && req->rq_resend) {
-		DEBUG_REQ(D_HA, req,  "BULK TIMEOUT");
-		ptlrpc_req_finished(req);
-		goto restart_bulk;
-	}
-
-	rc = osc_brw_fini_request(req, rc);
-
-	ptlrpc_req_finished(req);
-	/* When server return -EINPROGRESS, client should always retry
-	 * regardless of the number of times the bulk was resent already.*/
-	if (osc_recoverable_error(rc)) {
-		resends++;
-		if (rc != -EINPROGRESS &&
-		    !client_should_resend(resends, &exp->exp_obd->u.cli)) {
-			CERROR("%s: too many resend retries for object: "
-			       ""DOSTID", rc = %d.\n", exp->exp_obd->obd_name,
-			       POSTID(&oa->o_oi), rc);
-			goto out;
-		}
-		if (generation !=
-		    exp->exp_obd->u.cli.cl_import->imp_generation) {
-			CDEBUG(D_HA, "%s: resend cross eviction for object: "
-			       ""DOSTID", rc = %d.\n", exp->exp_obd->obd_name,
-			       POSTID(&oa->o_oi), rc);
-			goto out;
-		}
-
-		lwi = LWI_TIMEOUT_INTR(cfs_time_seconds(resends), NULL, NULL,
-				       NULL);
-		l_wait_event(waitq, 0, &lwi);
-
-		goto restart_bulk;
-	}
-out:
-	if (rc == -EAGAIN || rc == -EINPROGRESS)
-		rc = -EIO;
-	return rc;
-}
-
 static int osc_brw_redo_request(struct ptlrpc_request *request,
 				struct osc_brw_async_args *aa, int rc)
 {
@@ -1789,125 +1694,12 @@ static void sort_brw_pages(struct brw_page **array, int num)
 	} while (stride > 1);
 }
 
-static u32 max_unfragmented_pages(struct brw_page **pg, u32 pages)
-{
-	int count = 1;
-	int offset;
-	int i = 0;
-
-	LASSERT (pages > 0);
-	offset = pg[i]->off & ~CFS_PAGE_MASK;
-
-	for (;;) {
-		pages--;
-		if (pages == 0)	 /* that's all */
-			return count;
-
-		if (offset + pg[i]->count < PAGE_CACHE_SIZE)
-			return count;   /* doesn't end on page boundary */
-
-		i++;
-		offset = pg[i]->off & ~CFS_PAGE_MASK;
-		if (offset != 0)	/* doesn't start on page boundary */
-			return count;
-
-		count++;
-	}
-}
-
-static struct brw_page **osc_build_ppga(struct brw_page *pga, u32 count)
-{
-	struct brw_page **ppga;
-	int i;
-
-	OBD_ALLOC(ppga, sizeof(*ppga) * count);
-	if (ppga == NULL)
-		return NULL;
-
-	for (i = 0; i < count; i++)
-		ppga[i] = pga + i;
-	return ppga;
-}
-
 static void osc_release_ppga(struct brw_page **ppga, u32 count)
 {
 	LASSERT(ppga != NULL);
 	OBD_FREE(ppga, sizeof(*ppga) * count);
 }
 
-static int osc_brw(int cmd, struct obd_export *exp, struct obd_info *oinfo,
-		   u32 page_count, struct brw_page *pga,
-		   struct obd_trans_info *oti)
-{
-	struct obdo *saved_oa = NULL;
-	struct brw_page **ppga, **orig;
-	struct obd_import *imp = class_exp2cliimp(exp);
-	struct client_obd *cli;
-	int rc, page_count_orig;
-
-	LASSERT((imp != NULL) && (imp->imp_obd != NULL));
-	cli = &imp->imp_obd->u.cli;
-
-	if (cmd & OBD_BRW_CHECK) {
-		/* The caller just wants to know if there's a chance that this
-		 * I/O can succeed */
-
-		if (imp->imp_invalid)
-			return -EIO;
-		return 0;
-	}
-
-	/* test_brw with a failed create can trip this, maybe others. */
-	LASSERT(cli->cl_max_pages_per_rpc);
-
-	rc = 0;
-
-	orig = ppga = osc_build_ppga(pga, page_count);
-	if (ppga == NULL)
-		return -ENOMEM;
-	page_count_orig = page_count;
-
-	sort_brw_pages(ppga, page_count);
-	while (page_count) {
-		u32 pages_per_brw;
-
-		if (page_count > cli->cl_max_pages_per_rpc)
-			pages_per_brw = cli->cl_max_pages_per_rpc;
-		else
-			pages_per_brw = page_count;
-
-		pages_per_brw = max_unfragmented_pages(ppga, pages_per_brw);
-
-		if (saved_oa != NULL) {
-			/* restore previously saved oa */
-			*oinfo->oi_oa = *saved_oa;
-		} else if (page_count > pages_per_brw) {
-			/* save a copy of oa (brw will clobber it) */
-			OBDO_ALLOC(saved_oa);
-			if (saved_oa == NULL)
-				GOTO(out, rc = -ENOMEM);
-			*saved_oa = *oinfo->oi_oa;
-		}
-
-		rc = osc_brw_internal(cmd, exp, oinfo->oi_oa, oinfo->oi_md,
-				      pages_per_brw, ppga, oinfo->oi_capa);
-
-		if (rc != 0)
-			break;
-
-		page_count -= pages_per_brw;
-		ppga += pages_per_brw;
-	}
-
-out:
-	osc_release_ppga(orig, page_count_orig);
-
-	if (saved_oa != NULL)
-		OBDO_FREE(saved_oa);
-
-	return rc;
-}
-
 static int brw_interpret(const struct lu_env *env,
 			 struct ptlrpc_request *req, void *data, int rc)
 {
@@ -2267,17 +2059,6 @@ static int osc_set_data_with_check(struct lustre_handle *lockh,
 	return set;
 }
 
-static int osc_change_cbdata(struct obd_export *exp, struct lov_stripe_md *lsm,
-			     ldlm_iterator_t replace, void *data)
-{
-	struct ldlm_res_id res_id;
-	struct obd_device *obd = class_exp2obd(exp);
-
-	ostid_build_res_name(&lsm->lsm_oi, &res_id);
-	ldlm_resource_iterate(obd->obd_namespace, &res_id, replace, data);
-	return 0;
-}
-
 /* find any ldlm lock of the inode in osc
  * return 0    not find
  *	1    find one
@@ -2590,22 +2371,6 @@ int osc_enqueue_base(struct obd_export *exp, struct ldlm_res_id *res_id,
 	return rc;
 }
 
-static int osc_enqueue(struct obd_export *exp, struct obd_info *oinfo,
-		       struct ldlm_enqueue_info *einfo,
-		       struct ptlrpc_request_set *rqset)
-{
-	struct ldlm_res_id res_id;
-	int rc;
-
-	ostid_build_res_name(&oinfo->oi_md->lsm_oi, &res_id);
-	rc = osc_enqueue_base(exp, &res_id, &oinfo->oi_flags, &oinfo->oi_policy,
-			      &oinfo->oi_md->lsm_oinfo[0]->loi_lvb,
-			      oinfo->oi_md->lsm_oinfo[0]->loi_kms_valid,
-			      oinfo->oi_cb_up, oinfo, einfo, oinfo->oi_lockh,
-			      rqset, rqset != NULL, 0);
-	return rc;
-}
-
 int osc_match_base(struct obd_export *exp, struct ldlm_res_id *res_id,
 		   __u32 type, ldlm_policy_data_t *policy, __u32 mode,
 		   __u64 *flags, void *data, struct lustre_handle *lockh,
@@ -2659,28 +2424,6 @@ int osc_cancel_base(struct lustre_handle *lockh, __u32 mode)
 	return 0;
 }
 
-static int osc_cancel(struct obd_export *exp, struct lov_stripe_md *md,
-		      __u32 mode, struct lustre_handle *lockh)
-{
-	return osc_cancel_base(lockh, mode);
-}
-
-static int osc_cancel_unused(struct obd_export *exp,
-			     struct lov_stripe_md *lsm,
-			     ldlm_cancel_flags_t flags,
-			     void *opaque)
-{
-	struct obd_device *obd = class_exp2obd(exp);
-	struct ldlm_res_id res_id, *resp = NULL;
-
-	if (lsm != NULL) {
-		ostid_build_res_name(&lsm->lsm_oi, &res_id);
-		resp = &res_id;
-	}
-
-	return ldlm_cli_cancel_unused(obd->obd_namespace, resp, flags, opaque);
-}
-
 static int osc_statfs_interpret(const struct lu_env *env,
 				struct ptlrpc_request *req,
 				struct osc_async_args *aa, int rc)
@@ -3589,14 +3332,7 @@ struct obd_ops osc_obd_ops = {
 	.o_getattr_async	= osc_getattr_async,
 	.o_setattr	      = osc_setattr,
 	.o_setattr_async	= osc_setattr_async,
-	.o_brw		  = osc_brw,
-	.o_punch		= osc_punch,
-	.o_sync		 = osc_sync,
-	.o_enqueue	      = osc_enqueue,
-	.o_change_cbdata	= osc_change_cbdata,
 	.o_find_cbdata	  = osc_find_cbdata,
-	.o_cancel	       = osc_cancel,
-	.o_cancel_unused	= osc_cancel_unused,
 	.o_iocontrol	    = osc_iocontrol,
 	.o_get_info	     = osc_get_info,
 	.o_set_info_async       = osc_set_info_async,
-- 
1.7.9.5

